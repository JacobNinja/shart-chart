require 'ruby_parser'
require 'sexp_processor'

module ShartChart

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
      @current_class_hash = {name: class_name.to_s, references: []}
      @poop.push @current_class_hash
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
      @current_class_hash[:references].push(Reference.new(var)) if @current_class_hash
    end

  end

end