require 'cucumber/formatter/gherkin_formatter_adapter'
require 'cucumber/formatter/io'
require 'gherkin/formatter/argument'
require 'gherkin/formatter/json_formatter'

module Cucumber
  module Formatter
    # The formatter used for <tt>--format online_testing_formatter</tt>
    class OnlineTestingFormatter < GherkinFormatterAdapter
      include Io

      def before_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background, file_colon_line)
        arguments = step_match.step_arguments.map{|a| Gherkin::Formatter::Argument.new(a.offset, a.val)}
        location = step_match.file_colon_line
        match = Gherkin::Formatter::Model::Match.new(arguments, location)
        if @print_emtpy_match
          # Trick the formatter to believe that's what was printed previously so we get arg highlights on #result
          @gf.instance_variable_set('@match', match)
        else
          @gf.match(match)
        end

        error_message = exception ? "#{exception.message}" : nil
        unless @outline
          @gf.result(Gherkin::Formatter::Model::Result.new(status, nil, error_message))
        end
      end

      def initialize(step_mother, io, options)
        @io = ensure_io(io, "my_formatter")
        super(Gherkin::Formatter::JSONFormatter.new(@io), false)
      end
    end
  end
end

