require 'ruby_parser'
require 'sexp_processor'

module ShartChart

  Result = Struct.new(:klass, :references)
  Reference = Struct.new(:klass)

  class PoopParser < SexpProcessor

    def parse(rb)
      self.auto_shift_type = true
      @poop = []
      parser = RubyParser.new
      ast = parser.parse(rb)
      p ast
      process(ast)
      @poop
    end

    def process_class(exp)
      class_name = exp.shift
      @current_class_result = Result.new(class_name.to_s, [])
      @poop.push @current_class_result
      process(exp.shift) until exp.empty?
      s()
    end

    alias process_module process_class

    def process_const(exp)
      const = exp.shift
      push_reference(const.to_s)
      s()
    end

    private

    def push_reference(var)
      @current_class_result.references.push(Reference.new(var)) if @current_class_result
    end

  end

end