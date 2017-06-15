require 'pp'
require 'parslet'

class FastExpression < Parslet::Parser
  # Single character rules
  rule(:lparen)     { str('(') >> space? }
  rule(:rparen)     { str(')') >> space? }
  rule(:capture_it) { str('$') >> space? }
  rule(:lbracket)   { str('{') >> space? }
  rule(:rbracket)   { str('}') >> space? }

  rule(:space)      { match('\s').repeat(1) }
  rule(:enter)      { match(?\n).repeat(1) }
  rule(:space?)     { space.maybe | enter.maybe }

  # Things
  rule(:integer)    { match('[0-9]').repeat(1).as(:int) >> space? }
  rule(:identifier) { match['a-z'].repeat(1).as(:token)  }
  rule(:one_thing)  { (str('_') >> space?).as(:thing) }
  rule(:one_node)   { (str('...') >> space?).as(:node) }
  rule(:nil_node)   { (str('nil') >> space?).as('nil') }

  # Grammar parts
  rule(:arglist)    { expression >> (space? >> expression).repeat }
  rule(:find)       { lparen >> arglist.as(:find) >> rparen }
  rule(:any)        { lbracket >> arglist.as(:any) >> rbracket }
  rule(:capture)    { capture_it.as(:capture) >> expression}

  rule(:expression) { find | any | capture | identifier | integer | one_thing | one_node | nil_node  }
  root :expression
end

expression = <<~EXP
  (send
    (send
      (send nil object)
      method)
    call 
    ( ( {int float} _) ))
EXP

pp FastExpression.new.parse(ARGV.shift || expression)

