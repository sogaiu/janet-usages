# janet-usages

# includes various portions of (or inspiration from) bakpakin's:
#
# * helper.janet
# * jpm
# * path.janet
# * peg for janet

(import ./path :prefix "")
(import ./runner :prefix "")
(import ./sample :prefix "")
(import ./utils :prefix "")

# from the perspective of `jpm test`
(def proj-root
  (path/abspath "."))

# XXX: hack to prevent from running when testing
(when (nil? (dyn :judge-gen/test-out))
  (let [src-root "usages"
        judge-dir-name ".janet-usages"]
    # ensure src-root exists
    (var was-no-src-root false)
    (unless (os/stat src-root)
      (set was-no-src-root true)
      (eprintf "creating %s directory..." src-root)
      (os/mkdir src-root))
    (def stat (os/stat src-root))
    (unless (and stat
                 (= :directory (stat :mode)))
      (eprint "src-root must be a directory: " src-root)
      (os/exit 1))
    # create sample file if there was no src-root
    (when was-no-src-root
      (def sample-file-path
        (path/join src-root "sample.janet"))
      (unless (os/stat sample-file-path)
        (eprintf "creating sample file: %s" sample-file-path)
        (spit sample-file-path sample/content)))
    # generate and run tests
    (let [all-passed (runner/handle-one
                       {:judge-dir-name judge-dir-name
                        :proj-root proj-root
                        :src-root src-root})]
      (when (not all-passed)
        (os/exit 1)))))
