(import ../janet-usages/segments :prefix "")

(comment

  (def code-buf
    @``
    (def a 1)

    (comment

      (+ a 1)
      # => 2

      (def b 3)

      (- b a)
      # => 2

    )
    ``)

  (deep=
    (segments/parse code-buf)
    #
    @[{:value "    (def a 1)\n\n    "
       :s-line 1
       :type :value
       :end 19}
      {:value (string "(comment\n\n      "
                      "(+ a 1)\n      "
                      "# => 2\n\n      "
                      "(def b 3)\n\n      "
                      "(- b a)\n      "
                      "# => 2\n\n    "
                      ")\n    ")
       :s-line 3
       :type :value
       :end 112}]
    ) # => true

  )
