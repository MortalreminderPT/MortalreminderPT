# frozen_string_literal: true

unless system("latex -version", [:out, :err] => File::NULL)
    STDERR.puts "You are missing a TeX distribution. Please install:"
    STDERR.puts "  MiKTeX or TeX Live or..."
    raise "Missing TeX distribution"
end

require "open3"

require "jekyll-t4j/engine/katex"
require "jekyll-t4j/engine/dvisvgm"

module Jekyll::T4J
    module Engine
        @@cache_katex = Jekyll::Cache.new "Jekyll-T4J::Katex"
        @@cache_dvisvgm = Jekyll::Cache.new "Jekyll-T4J::Dvisvgm"

        def self.header
            <<~HD
                <script>
                    document.addEventListener("DOMContentLoaded", () => {
                        let z = document.body.getElementsByTagName("include")
                        for (let i = 0; i < z.length; ++i) {
                            let elmnt = z[i]
                            let xhttp = new XMLHttpRequest()
                            xhttp.onreadystatechange = function() { elmnt.innerHTML = this.responseText }
                            xhttp.open("GET", elmnt.getAttribute("src"), true)
                            xhttp.send()
                        }
                    })
                </script>
            HD
        end

        def self.setup
            setup_katex
            setup_dvisvgm
        end

        def self.render(snippets, merger, site)
            gen_svg = ->(svg, displayMode) {
                "<embed src=\"#{merger.(svg, ".svg")}\" style=\"height:#{
                    (svg[/height='(\S+?)pt'/, 1].to_f * 0.1).round(4)
                }em;#{
                    displayMode ? "display:block;margin:auto" : "display:inline;vertical-align:middle"
                }\">"
            }
            gen_mathml = ->(mathml) {
                "<include src=\"#{site.config["baseurl"] + merger.(mathml, ".xml")}\"></include>"
            }

            # 'snippets' << caches
            uncached = {} #act as hash set
            snippets.each_with_index do |s, i|
                r = nil
                begin
                    r = gen_mathml.(@@cache_katex[s.source])
                rescue
                    begin
                        r = gen_svg.(@@cache_dvisvgm[Jekyll::T4J.cfg_pkgs + s.source], s.display_mode?)
                    rescue
                        uncached[s] = nil
                    end
                end

                snippets[i] = r if r
            end

            # finish if no 'uncached' found
            return if uncached.empty?
            uncached = uncached.keys

            # otherwise render 'uncached' with katex and cache them
            katex_raw_bulk(uncached).each_with_index do |result, i|
                @@cache_katex[uncached[i].source] = result if result
            end

            # 'snippets' << rendering results
            uncached = {} #act as hash set again
                snippets.each_with_index do |s, i|
                    next if !s.is_a?(Snippet)
                        begin
                            snippets[i] = gen_mathml.(@@cache_katex[s.source])
                        rescue
                            uncached[s] = nil
                end
            end

            # finish if no 'uncached' found
            return if uncached.empty?
            uncached = uncached.keys

            # otherwise render 'uncached' with dvisvgm and cache them
            dvisvgm_raw_bulk(uncached).each_with_index do |result, i|
                @@cache_dvisvgm[Jekyll::T4J.cfg_pkgs + uncached[i].source] = result
            end

            # 'snippets' << rendering results
            snippets.each_with_index do |s, i|
                next if !s.is_a?(Snippet)

                begin
                    snippets[i] = gen_svg.(@@cache_dvisvgm[Jekyll::T4J.cfg_pkgs + s.source], s.display_mode?)
                rescue
                    # impossible!
                end
            end
        end

        def self.shell(cmd, pwd, n = 1)
            n.times do
                log, s = Open3.capture2e(cmd, :chdir => pwd) # TODO: even the quickest 'dvisvgm' cost at least 0.3s in my laptop
                raise log if not s.success?
            end
        end
    end
end