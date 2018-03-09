class SQLParser
  def initialize(string)
    @tokens = string.scan(/\(|\)|:?\w+|[\+\-\/\*=]+|[<>]=?/)
  end

  def next_token
    @tokens.shift
  end

  def parse
    case token = next_token
    when 'select' then {select: parse_until('from') }.merge!(parse)
    when 'from' then {from: parse_until('where') }.merge!(parse)
    when 'where' then {where: parse }.merge!(parse)
    when /\d+\.\d+/ then {float: token.to_f}
    when /\d+/ then {int: token.to_i}
    when /[<>]=?/ then { token: parse}
    else
      {sym: token.to_sym}
    end
    
  end

  def parse_until(token_close)
    list = []
    list << parse until @tokens.first == token_close
    list
  end
end
parser = SQLParser.new('select id, name from table where age > 30')
require 'pp'
pp parser.parse
