# frozen_string_literal: true

module Jekyll::T4J
    class Snippet
        @is_display_mode
        @source
        @code_in

        attr_reader :source, :code_in

        def initialize(raw)
            @is_display_mode = raw.start_with?("\\[") or raw.start_with?("$$")

            # extract the code inside and minimize it
            @code_in = raw[(display_mode? or raw.start_with?("\\")) ? (2..-3) : (1..-2)]
            @code_in.strip! # TODO: minimize code
            @code_in.freeze

            # create minimized source
            @source = display_mode? ? "\\[#{code_in}\\]" : "\\(#{code_in}\\)"
            @source.freeze

            # we are immutable
            freeze
        end

        def display_mode?
            @is_display_mode
        end

        def hash
            source.hash
        end

        def ==(other)
            self.class === other and source == other.source
        end

        alias to_s source
        alias eql? ==
    end
end