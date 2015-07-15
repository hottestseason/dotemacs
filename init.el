(setq gc-cons-thresholdq 1073741824)

(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'tool-bar-mode) (scroll-bar-mode -1))

(add-to-list 'load-path "~/.emacs.d/init.d")
(add-to-list 'load-path "~/.emacs.d/vendor.d")
(add-to-list 'load-path "~/.emacs.d/personal.d")

(require 'init-packages)
;;(require 'benchmark-init)
(require 'personal-utils)
(require 'init-face)
(require 'init-global-configs)
(require 'init-programming)
