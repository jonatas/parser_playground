# Parser Playground

I like to play with parsers then I decide to keep my small examples and
prototypes in a single repo instead of using gists.

## [parser.rb](parser.rb)

It accepts deep arrays with `()` or transfom arguments into a hash with `{}`.

$ ruby parser.rb '(+ 2 3 6 (- 2 1) (/ 2 3))'

```ruby
[:+, 2, 3, 6, [:-, 2, 1], [:/, 2, 3]]
```
$ ruby parser.rb '(an (deep (array {with hash})))'

```ruby
[:an, [:deep, [:array, {:with=>:hash}]]]
```

$ ruby parser.rb '(an (deep (array {with hash} 2 (+ 3 (/ 5 4)))))'

```ruby
[:an, [:deep, [:array, {:with=>:hash}, 2, [:+, 3, [:/, 5, 4]]]]]
```

## [expression.rb](expression.rb)

$ ruby expression.rb '{any of this guys}

Outputs:

```ruby
{:any=>
  [{:token=>"any"@1},
   {:token=>"of"@5},
   {:token=>"this"@8},
   {:token=>"guys"@13}]}
```

$ ruby expression.rb '(sequence of this guys)'

```ruby
{:find=>
  [{:token=>"sequence"@1},
   {:token=>"of"@10},
   {:token=>"this"@13},
   {:token=>"guys"@18}]}
```

$ ruby expression.rb '(deep $(capture (sequence of {this guys})))'

```ruby
{:find=>
  [{:token=>"deep"@1},
   {:capture=>"$"@6,
    :find=>
     [{:token=>"capture"@8},
      {:find=>
        [{:token=>"sequence"@17},
         {:token=>"of"@26},
         {:any=>[{:token=>"this"@30}, {:token=>"guys"@35}]}]}]}]}<Paste>
```

## [sql_parser.rb](sql_parser.rb)

$ ruby sql_parser.rb

```ruby
{:select=>[{:sym=>:id}, {:sym=>:name}],
 :from=>[{:sym=>:table}],
 :where=>{:sym=>:age},
 :token=>{:int=>30}}
```
