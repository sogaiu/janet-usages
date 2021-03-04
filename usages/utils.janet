(import ../janet-usages/utils :prefix "")

(comment

  (utils/no-ext "fun.janet")
  # => "fun"

  (utils/no-ext "/etc/man_db.conf")
  # => "/etc/man_db"

  (utils/no-ext "test/usages.janet")
  # => "test/usages"

  )
