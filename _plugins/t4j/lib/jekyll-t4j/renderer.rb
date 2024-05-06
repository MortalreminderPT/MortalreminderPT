# frozen_string_literal: true

require "strscan"
require "cgi"

module Jekyll::T4J
    HTML_TEXT_MASK = Regexp.union(
        %r{\s*<head[\s\S]*?</head>\s*},
        %r{\s*<script[\s\S]*?</script>\s*},
        %r{\s*<style[\s\S]*?</style>\s*},
        %r{\s*<svg[\s\S]*?</svg>\s*},
        /\s*<!--.*?-->\s*/,
        /\s*<.*?>\s*/
    ).freeze

    TEXT_TEX_MASK = Regexp.union(
        /\\\[[\s\S]*?\\\]/,
        /\$\$[\s\S]*?\$\$/,
        /\\\([\s\S]*?\\\)/,
        /\$[\s\S]*?\$/
    ).freeze

    def self.mask(str, reg)
        s = StringScanner.new str
        parts = []

        while not s.eos? do
            p0 = s.charpos
            m = s.scan_until(reg)

            if m then
                p1 = s.charpos - s.matched.size - 1

                parts << [str[p0..p1], true] unless p1 < p0
                parts << [s.matched, false]
            else
                parts << [str[p0..-1], true]
                break
            end
        end

        parts
    end

    def self.extract(html)
        result = []
        prev = nil

        for p0 in mask(html, HTML_TEXT_MASK)
            if p0[1] then #p0[0] is a text node
                for p1 in mask(p0[0], TEXT_TEX_MASK)
                    if not p1[1] then #p1[0] is a tex snippet
                        prev = nil
                        p1[1] = true
                        result << p1
                    else
                        if prev then
                            prev << p1[0]
                        else
                            prev = p1[0]
                            p1[1] = false
                            result << p1
                        end
                    end
                end
            else
                if prev then
                    prev << p0[0]
                else
                    prev = p0[0]
                    result << p0
                end
            end
        end

        result
    end

    # T4J rendering phase
    Jekyll::Hooks.register :site, :post_render do |site|
        snippets = []
        docs = []

        # collect tex snippets
        site.each_site_file do |f|
            next if f.is_a?(Jekyll::StaticFile)
            next if f.is_a?(Jekyll::Page) and not f.html?

            parts = extract(f.output)
            if parts.size > 1 then #'f' has tex snippet(s)
                parts.each {|part| snippets << Jekyll::T4J::Snippet.new(CGI::unescapeHTML part[0]) if part[1]}
                docs << [f, parts]
            end
        end

        # render 'snippets'
        Jekyll::T4J::Engine.render(snippets, ->(data, extname) {Jekyll::T4J::Merger.ask_for_merge(data, extname)}, site)

        # 'snippets' -> 'docs'
        i = 0
        for doc in docs
            newoutput = String.new

            for part in doc[1]
                if part[1] then
                    part[0] = snippets[i]
                    i += 1
                end

                newoutput << part[0]
            end

            doc[0].output = newoutput.insert(newoutput.index("</head>"), Jekyll::T4J::Engine.header)
        end
    end
end