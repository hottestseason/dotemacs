(add-hook 'after-init-hook
          (lambda ()
            ;; (electric-pair-mode 1)
            (require 'smartparens-config)
            (smartparens-global-mode t)

            (add-hook 'write-file-functions 'delete-trailing-whitespace)

            (make-variable-buffer-local 'post-self-insert-hook)
            (setq electric-indent-disable-modes-list
                  '(coffee-mode
                    haml-mode
                    slim-mode
                    latex-mode
                    python-mode
                    yaml-mode))
            (add-hook 'after-change-major-mode-hook
                      (lambda ()
                        (cond ((memq major-mode electric-indent-disable-modes-list)
                               (electric-indent-mode -1)
                               (local-set-key (kbd "RET") 'newline-and-indent))
                              (t
                               (electric-indent-mode 1)))))

            (global-flycheck-mode 1)

            (setq-default indent-tabs-mode nil)
            (add-hook 'makefile-mode-hook
                      (lambda ()
                        (setq indent-tabs-mode t)))
            (setq-default tab-width 2)
            (setq tab-width 2)

            (defun newline-and-insert-newline-and-indent-after-brace ()
              (interactive)
              (if (and (eq (char-before) ?{) (eq (following-char) ?}))
                  (progn
                    (newline-and-indent)
                    (save-excursion
                      (insert "\n")
                      (indent-according-to-mode))
                    (indent-according-to-mode))
                (newline)))

            (global-set-key (kbd "RET") 'newline-and-insert-newline-and-indent-after-brace)

            (global-set-key (kbd "s-g") 'magit-status)

            ;; (require 'init-tabbar)
            (require 'init-auto-complete)
            (require 'init-helm)
            (require 'init-sh)
            (require 'init-js)
            (require 'init-haml)
            (require 'init-cc)
            (require 'init-css)
            (require 'init-ruby)
            (require 'init-tex)
            (require 'init-programming-contest)))

(provide 'init-programming-settings)
