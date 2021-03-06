(import ../build/validate :prefix "")

(comment

  (validate/valid-code? "true")
  # => true

  (validate/valid-code? "(")
  # => false

  (validate/valid-code? "()")
  # => true

  (validate/valid-code? "(]")
  # => false

  )
