(import ./common)
(import ./jpm :prefix "")

(when (os/stat common/out-name)
  (os/rm common/out-name))

(when (os/stat common/build-dir-name)
  (jpm/rm common/build-dir-name))
