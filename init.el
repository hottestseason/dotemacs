
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

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
