# Jekyll::T4J

jekyll-t4j is a Jekyll plugin providing (nearly) full support of LaTeX.

- **Comprehensive**: support almost all packages, including tikz, chemfig, etc.
- **Highly optimized**: employ KaTeX to boost speed. Use cache, precompiled preamble, bulk rendering.
- **Server side rendering**: all stuffs are done in server.

T4J integrates Jekyll with your local TeX distribution, so you need to have either [MikTeX](https://miktex.org/) or [TeX Live](https://tug.org/texlive/) installed.

Feel free to write any LaTeX! &#x1F389;

> **Warning**
> T4J now is in rapid development, it's pretty unstable. So don't forget to check and update frequently.

## Getting Started

Let's start by a simple instance, write a post `2023-02-04-hello-latex.md` and fill it with:

```
---
layout: default
title:  Hello LaTeX
date:   2023-02-04 14:53:32 +0800
---

This is an inline math $r=\sqrt{x^2+y^2}$.

$$\chemfig{*6((--[::-60]HO)-=(-O-[:30])-(-OH)=-=)}$$

And this is vanillyl alcohol.
```

As you can see, its usage is the same as KaTeX or MathJax, but we only allow delimiters `$...$`, `$$...$$`, `\(...\)`, `\[...\]`.

Because we use the chemfig package, so open your `_config.yml` file and write:

```yaml
t4j:
  packages:
    - chemfig
```

Finally, build your site, complete!

You can learn more about T4J [here](https://github.com/crow02531/jekyll-t4j/wiki).

## Installation

First of all, you need to have a TeX distribution. Just download and install [MikTeX](https://miktex.org/) or [TeX Live](https://tug.org/texlive/). Other TeX distirbution is also available.

Then, install jekyll-t4j like other Jekyll plugins. Add this line to your application's Gemfile:

```ruby
gem 'jekyll-t4j'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install jekyll-t4j
```

Lastly, add it to your `_config.yml` file:

```yaml
plugins:
    - jekyll-t4j
```