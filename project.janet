(declare-project
  :name "janet-usages"
  :url "https://gitlab.com/sogaiu/janet-usages"
  :repo "git+https://gitlab.com/sogaiu/janet-usages")

# XXX: not sure if doing this is a good idea...

(put (dyn :rules) "build" nil)
(phony "build" []
       (os/execute ["janet"
                    "support/build.janet"] :p))

(put (dyn :rules) "clean" nil)
(phony "clean" []
       (os/execute ["janet"
                    "support/clean.janet"] :p))

