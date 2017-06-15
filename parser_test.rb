require 'pp'
require './parser'

parse = Parser.new ARGV.shift || <<~EXP
  (+ (1 2.0) (/ 10  8 )
      (*
        {
          use { deep {hashes (with arrays) } }
          (anything can) ("be used" {2 compile})
          ok thanks
        })
   {\"put dashes here\" 'put underscore here'}
 )
EXP

pp parse.parse

sleep 5
