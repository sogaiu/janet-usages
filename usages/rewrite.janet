(import ../build/rewrite :prefix "")

(comment

  (rewrite/has-tests? @["(+ 1 1)\n  " [:returns "2" 1]])
  # => true

  (rewrite/has-tests? @["(comment \"2\")\n  "])
  # => nil

  )
