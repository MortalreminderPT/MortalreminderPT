# frozen_string_literal: true

require "tmpdir"

module Jekyll::T4J
    module Engine
        @@_pwd_fmt_ = nil

        def self.setup_dvisvgm
            if not @@_pwd_fmt_ then
                @@_pwd_fmt_ = Dir.mktmpdir
                at_exit {FileUtils.remove_entry @@_pwd_fmt_}

                # write 'preamble.tex'
                File.write "#{@@_pwd_fmt_}/preamble.tex", <<~HD
                    \\documentclass{article}
                    #{Jekyll::T4J.cfg_pkgs}
                    \\input{#{File.join(__dir__, "dvisvgm.tex")}}
                    \\pagenumbering{gobble}
                    \\dump
                HD

                # call 'latex' to precompile
                shell("latex -ini -halt-on-error -jobname=\"preamble\" \"&latex preamble\"", @@_pwd_fmt_)
            end
        end

        def self.dvisvgm_raw(snippet)
            dvisvgm_raw_bulk([snippet])[0]
        end

        def self.dvisvgm_raw_bulk(snippets)
            # create 'content.tex'
            pwd = Dir.mktmpdir
            File.write "#{pwd}/content.tex", <<~HD
                \\begin{document}
                \\begingroup#{snippets.join("\\endgroup\\newpage\\begingroup")}\\endgroup
                \\end{document}
            HD

            # call 'latex' to compile: tex->dvi
            shell("latex --fmt=\"#{File.join(@@_pwd_fmt_, "preamble.fmt")}\" -halt-on-error content", pwd, 2)
            # call 'dvisvgm' to convert dvi to svg(s)
            shell("dvisvgm -n -e -p 1- -o %1p content", pwd)

            # fetch results
            results = []
            for i in 1..snippets.size
                results << File.read("#{pwd}/#{i.to_s}.svg")
            end

            # return
            results
        ensure
            FileUtils.remove_entry pwd if pwd
        end
    end
end