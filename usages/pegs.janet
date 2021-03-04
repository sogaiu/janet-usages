(import ../janet-usages/pegs :prefix "")

(comment

  (def sample-source
    (string "# \"my test\"\n"
            "(+ 1 1)\n"
            "# => 2\n"))

  (deep=
    #
    (peg/match pegs/top-level sample-source 0)
    #
    @[{:type :comment
       :value "# \"my test\"\n"
       :s-line 1
       :end 12}])
  # => true

  (deep=
    #
    (peg/match pegs/top-level sample-source 12)
    #
    @[{:type :value
       :value "(+ 1 1)\n"
       :s-line 2
       :end 20}])
  # => true

  )
