# Watching and following 🍿
# https://www.destroyallsoftware.com/screencasts/catalog/a-compiler-from-scratch
class Tokenizer

  TYPES = {
    def: /\bdef\b/,
    end: /\bend\b/,
    identifier: /\b[a-z]+\b/,
    oparens: /\(/,
    cparens: /\)/,
    int: /\d+/,
    comma: /,/
  }
  
  def initialize(code)
    @code = code
  end

  def parse
    output = []
    until @code.empty?
      output << parse_next_token
    end
    output
  end

  def parse_next_token
    TYPES.each do |type, regex|
      regex = /\A(#{regex})/
      if @code =~ regex
        value = $1
        @code = @code[value.length..-1].strip
        return [type, value]
      end
    end
    raise "Unexpected code #{@code.inspect}"
  end
end

class Parser
  def initialize(tokens)
    @tokens = tokens
  end

  def parse
    parse_def
  end

  def parse_arguments
    consume(:oparens)
    args = []
    if !peek(:cparens)
      args << consume(:identifier)
      while peek(:comma)
        consume(:comma)
        args << consume(:identifier)
      end
    end
    consume(:cparens)
    args
  end

  def parse_expression_arguments
    consume(:oparens)
    expressions = []
    if !peek(:cparens)
      expressions << parse_expr
      while peek(:comma)
        consume(:comma)
        expressions << parse_expr
      end
    end
    consume(:cparens)
    expressions
  end

  def peek(expected_type, index=0)
    @tokens.fetch(index).first == expected_type
  end

  def parse_expr
    if peek(:int)
      consume_integer
    elsif peek(:identifier) && peek(:oparens, 1)
      parse_call
    elsif peek(:identifier)
      parse_var
    end
  end

  def parse_def
    consume(:def)
    method_name = consume(:identifier)
    args = parse_arguments
    body = []
    body << parse_expr until peek(:end)
    consume(:end)
    DefNode.new(method_name, args, body)
  end

  def parse_call
   method = consume(:identifier)
   CallNode.new(method, parse_expression_arguments)
  end

  def parse_var
    VarNode.new(consume(:identifier))
  end

  def consume_integer
    IntNode.new(consume(:int).to_i)
  end

  def consume expected_type
    type, value = @tokens.shift
    if type != expected_type
      raise "Unexpected token #{type.inspect}. Expecting #{expected_type}.\n #{@tokens.inspect}"
    end
    value
  end
end

IntNode = Struct.new(:value)
VarNode = Struct.new(:identifier)
CallNode = Struct.new(:method_name, :arguments)
DefNode = Struct.new(:method_name, :parameters, :body)

class Generator
  def generate(node)
    case node
    when Array
      node.map(&method(:generate))
    when IntNode
      node.value
    when VarNode
      node.identifier
    when CallNode
      "#{node.method_name}(#{generate(node.arguments).join(',')})"
    when DefNode
      <<~TPL
      function #{node.method_name}(#{node.parameters.join(',')}){
        return #{generate(node.body).join}
      }
      TPL
    else
      raise "wtf #{node}"

    end
  end
end

tokens = Tokenizer.new("def a(x,y,z)\nb(b,2,d(2))\nend").parse

puts "tokens: #{ tokens.inspect }"

tree = Parser.new(tokens).parse

puts  "tree", tree.map(&:to_s).join("\n")
output = Generator.new.generate(tree)
puts output

