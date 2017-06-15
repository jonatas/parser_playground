class Parser
  TOKENIZER = /\w+|\(|\)|\{|\}|\d+\.?\d+?|[\+\-\*\/"']/
  def initialize expression
    @tokens = expression.scan(TOKENIZER)
  end
  def next_token
    @tokens.shift
  end
  def parse
    case token = next_token
    when '('
      parse_until ')'
    when '"'
      parse_until('"').join("-")
    when "'"
      parse_until("'").join("_")
    when '{'
      Hash[*parse_until('}')]
    when /\d+\.\d+/
      token.to_f
    when /\d+/
      token.to_i
    else
      token.to_sym
    end
  end
  def parse_until find_token
    list = []
    list << parse until @tokens.first == find_token
    next_token
    list
  end
end
