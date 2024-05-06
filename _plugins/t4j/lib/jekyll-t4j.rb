# frozen_string_literal: true

require "jekyll"

require "jekyll-t4j/version"

module Jekyll::T4J
    @@cfg_pkgs

    def self.cfg_pkgs
        @@cfg_pkgs
    end

    # initialize plugin
    Jekyll::Hooks.register :site, :after_init do |site|
        Jekyll.logger.info "Initializing T4J..."
        t0 = Time.now

        cfg = site.config["t4j"]
        if cfg and (cfg = cfg["packages"]) then
            pkgs = String.new

            for p in cfg
                raise "Illegal config: #{p}" unless p.match(/\s*([\w-]+)(\[[^\[\]]*\])?\s*/)
                pkgs << "\\usepackage#{$2}{#{$1}}"
            end

            @@cfg_pkgs = pkgs
        else
            @@cfg_pkgs = ""
        end

        Jekyll::T4J::Engine.setup
        Jekyll.logger.info "", "done in #{(Time.now - t0).round(3)} seconds."
    end
end

require "jekyll-t4j/snippet"
require "jekyll-t4j/merger"
require "jekyll-t4j/engine"
require "jekyll-t4j/renderer"