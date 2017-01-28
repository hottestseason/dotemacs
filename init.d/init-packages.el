(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

(require 'cl)

(defvar installing-package-list
  '(ac-js2
    ack-and-a-half
    ag
    anzu
    auto-complete
    auto-complete-clang
    benchmark-init
    coffee-mode
    d-mode
    dockerfile-mode
    direx
    diminish
    editorconfig
    exec-path-from-shell
    expand-region
    feature-mode
    flycheck
    flycheck-d-unittest
    flycheck-tip
    git-gutter
    git-gutter-fringe
    go-mode
    go-autocomplete
    haml-mode
    haskell-mode
    helm
    helm-ag
    helm-projectile
    hlinum
    jade-mode
    js2-mode
    magit
    markdown-mode
    minor-mode-hack
    move-text
    point-undo
    popwin
    powerline
    projectile
    rainbow-delimiters
    rbenv
    recentf-ext
    region-bindings-mode
    ruby-block
    sass-mode
    scss-mode
    sequential-command
    smartrep
    slim-mode
    smart-compile
    smartparens
    smooth-scroll
    smooth-scrolling
    typescript
    tabbar
    textmate
    undo-tree
    undohist
    volatile-highlights
    yascroll
    yasnippet
    yaml-mode
    zenburn-theme))

(let ((not-installed (loop for x in installing-package-list
			   when (not (package-installed-p x))
			   collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
      (package-install pkg))))

(provide 'init-packages)
