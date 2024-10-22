# execute this from janet-usages' project directory to build usages.janet

# note: all input files should express import forms in a specific way, e.g.
#
#         (import ./input :prefix "")
#
#       the form must be all on one line and should use `:prefix ""`.
#       definitions in each file should look like:
#
#         (def input/slurp-input
#
#       that is, use names of the form:
#
#         <file-name-no-ext>/<name>
#
#       these limitations exist to make the "compilation" process easier.

(import ./common)
(import ./jpm :prefix "")
(import ./path :prefix "")

# expressed relative to project root
(def src-root
  "janet-usages")

# expressed relative to project root
(def module-roots
  ["judge-gen/judge-gen"])

# order matters because we want overwriting
(def all-modules
  (array/concat (array ;module-roots)
                src-root))

# expressed relatitve to common/build-dir-name
(def start-path
  "./main.janet")

# XXX: a hack -- could reuse parts of a better peg
(def import-grammar
  ~(sequence :s* "("
             :s* "import"
             :s+
             # target item
             (choice (sequence `"`
                               (capture
                                 (some
                                   (if-not (set ` \t\r\n\0\f\v"`) 1)))
                               `"`)
                     (capture (some (if-not (set " \t\r\n\0\f\v)") 1))))
             # the rest
             (choice ")"
                      (sequence :s+
                                (any (if-not ")" 1))
                                ")"))))

(comment

  (peg/match import-grammar "(import ./pegs)")
  # => @["./pegs"]

  (peg/match import-grammar `(import ./pegs :prefix "")`)
  # => @["./pegs"]

  (peg/match import-grammar `(import "./pegs")`)
  # => @["./pegs"]

  )

(defn prepare-build-dir
  [build-dir modules]
  (os/mkdir build-dir)
  (assert (os/stat build-dir)
          (string "build dir is missing: " build-dir))
  (each module modules
    # shhhhh
    (with-dyns [:out @""]
      # each item copied separately for platform consistency
      (each item (os/dir module)
        (def full-path (path/join module item))
        (jpm/copy full-path build-dir)))))

# create a single file of source given a specific starting janet file by:
#
# 1. starting at file-path, read line by line recording the content in
#    out-file unless the line is an import form.
#
# 2. if an import form is encountered, don't record the line in out-file,
#    instead if the file it refers to has not been visited, visit the file
#    and continue recursively.
(defn build
  [start-file-path out-file-path]
  #
  (def cache @{})
  #
  (with [out-file (file/open out-file-path :w)]
    (defn helper
      [a-path]
      (unless (in cache a-path)
        (put cache a-path true)
        (with [in-file (file/open a-path :r)]
          (loop [line :iterate (file/read in-file :line)]
            (if-let [[name-path] (peg/match import-grammar line)]
              (helper (string name-path ".janet"))
              (file/write out-file line))))))
    #
    (helper start-file-path)
    (file/flush out-file)))

(try
  (do
    # prepare build directory and files
    (prin "Copying source files to build dir... ")
    (prepare-build-dir common/build-dir-name all-modules)
    (print "done")
    # build
    (prin "Building... ")
    (os/cd common/build-dir-name)
    # result ends up in test directory
    (def out-path
      (path/join ".."
                 (path/join "test" common/out-name)))
    (build start-path out-path)
    (print "done"))
  ([err]
    (eprint "building failed")
    (error err)))
