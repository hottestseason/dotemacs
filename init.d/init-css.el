(require 'css-mode)
(add-hook 'css-mode-hook
          (lambda ()
            (setq css-indent-offset 2)
            (setq css-indent-level 2)))
(when (require 'scss-mode nil t)
  (setq scss-sass-command "/Users/summer/.rbenv/shims/sass")
  (setq scss-compile-at-save nil))

(provide 'init-css)
