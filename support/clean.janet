(import ./common)
(import ./jpm :prefix "")

(when (os/stat common/build-dir-name)
  (jpm/rm common/build-dir-name))
