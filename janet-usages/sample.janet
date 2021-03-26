(def sample/content
  ``
  # This comment block has tests
  (comment

    # 1) A comment block test has two pieces:
    #
    # 1) The form
    # 2) The expected value comment
    #
    (+ 1 1)
    # => 2

    # 2) Another example

    # The following form is executed, as it has no expected value, but its
    # effects will remain valid for subsequent portions
    (def my-value 1)

    # Note the use of `my-value` here
    (struct :a my-value :b 2)
    # => {:a 1 :b 2}

    # 3. Below shows one way to express nested content more readably
    (let [i 2]
      (deep=
        #
        (struct :a (/ i i)
                :b [i (+ i 1) (+ i 3) (+ i 5)]
                :c {:x (math/pow 2 3)})
        #
        {:a 1
         :b [2 3 5 7]
         :c {:x 8}}))
    # => true

    # 4. One way to express expected values involving tuples, is to use
    #    square bracket tuples...
    (tuple :a :b)
    # => [:a :b]

    # 5. Alternatively, quote ordinary tuples in the expected value comment
    (tuple :x :y :z)
    # => '(:x :y :z)

    )

  # This comment block does not have tests because there are
  # no expected values expressed as line comments
  (comment

    (print "hi")

    (each x (range 3)
      (print x))

    )

  # In expected value comments, only expressions that yield values that
  # can be used with `marshal` will work.  (The reason for this
  # limitation is because `marshal` / `unmarshal` are used to save and
  # restore test results which are aggregated to produce an overall
  # summary.)
  (comment

    # Thus the following will not work:

    # (comment
    #
    #   printf
    #   # => printf
    #
    #   )

    # as `marshal` cannot handle `printf`:

    # repl:1:> (marshal printf)
    # error: no registry value and cannot marshal <cfunction printf>
    #   in marshal
    #   in _thunk [repl] (tailcall) on line 2, column 1

    # Though not equivalent, one can do this sort of thing instead:

    (describe printf)
    # => "<cfunction printf>"

    # or may be this is sufficient in some cases:

    (type printf)
    # => :cfunction

    )

  ``)
