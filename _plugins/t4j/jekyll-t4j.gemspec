# frozen_string_literal: true

require_relative "lib/jekyll-t4j/version"

Gem::Specification.new do |s|
    s.name        = "jekyll-t4j"
    s.version     = Jekyll::T4J::VERSION
    s.authors     = "crow02531"
    s.email       = "crow02531@outlook.com"
    s.homepage    = "https://github.com/crow02531/jekyll-t4j"
    s.license     = "MIT"
    s.summary     = "LaTeX support for Jekyll."
    s.description = <<-EOF
        An optimized Jekyll plugin providing (nearly) full support of LaTeX.
    EOF

    s.files = [
        "lib/jekyll-t4j.rb",
        "lib/jekyll-t4j/version.rb",
        "lib/jekyll-t4j/merger.rb",
        "lib/jekyll-t4j/renderer.rb",
        "lib/jekyll-t4j/snippet.rb",
        "lib/jekyll-t4j/engine.rb",
        "lib/jekyll-t4j/engine/dvisvgm.rb",
        "lib/jekyll-t4j/engine/dvisvgm.tex",
        "lib/jekyll-t4j/engine/katex.rb",
        "lib/jekyll-t4j/engine/katex.js",
        "lib/jekyll-t4j/engine/katex.mhchem.js",

        "LICENSE",
        "README.md"
    ]

    s.add_runtime_dependency "jekyll", "~> 4.1"
    s.add_runtime_dependency "duktape", "~> 2.7"
    s.requirements << "A TeX distribution"
end