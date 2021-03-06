(import ../build/grammar :prefix "")

(comment

  (try
    (peg/match grammar/janet "\"\\u001\"")
    ([e] e))
  # => "bad escape"

  (peg/match grammar/janet "\"\\u0001\"")
  # => @[]

  (peg/match grammar/janet "(def a 1)")
  # => @[]

)
