# frozen_string_literal: true

require "duktape"

module Jekyll::T4J
    module Engine
        KATEX_VERSION = "0.16.4"

        @@_katex_ctx_ = nil

        def self.setup_katex
            if not @@_katex_ctx_ then
                src = File.read(File.join(__dir__, "katex.js"))
                src << File.read(File.join(__dir__, "katex.mhchem.js")) if Jekyll::T4J.cfg_pkgs.include?("mhchem")

                @@_katex_ctx_ = Duktape::Context.new
                @@_katex_ctx_.exec_string(src)
            end
        end

        def self.katex_raw(snippet)
            begin
                @@_katex_ctx_.call_prop(["katex", "renderToString"], snippet.code_in,
                    {
                        displayMode: snippet.display_mode?,
                        output: "mathml",
                        strict: true
                    }
                )[20..-8]
            rescue
                nil
            end
        end

        def self.katex_raw_bulk(snippets)
            snippets.map do |snippet|
                katex_raw(snippet) # TODO: parallel
            end
        end
    end
end