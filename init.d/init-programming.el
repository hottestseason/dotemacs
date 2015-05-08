(add-hook 'after-init-hook
          (lambda ()
            (require 'editorconfig)

            ;; (electric-pair-mode 1)
            (require 'smartparens-config)
            (smartparens-global-mode t)
            (show-smartparens-global-mode t)

            (global-subword-mode t)
            (dolist (cmd '(forward-word backward-word mark-word kill-word backward-kill-word transpose-words capitalize-word upcase-word downcase-word left-word right-word))
              (let ((othercmd (let ((name (symbol-name cmd)))
                                (string-match "\\([[:alpha:]-]+\\)-word[s]?" name)
                                (intern (concat "subword-" (match-string 1 name))))))
                (substitute-key-definition cmd othercmd global-map)))

            (add-hook 'write-file-functions 'delete-trailing-whitespace)

            (make-variable-buffer-local 'post-self-insert-hook)
            (add-hook 'after-change-major-mode-hook
                      (lambda ()
                        (cond ((memq major-mode '(coffee-mode
                                                   haml-mode
                                                   haskell-mode
                                                   markdown-mode
                                                   slim-mode
                                                   latex-mode
                                                   python-mode
                                                   yaml-mode))
                               (electric-indent-mode -1)
                               (local-set-key (kbd "RET") 'newline-and-indent))
                              (t
                               (electric-indent-mode 1)))))

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
                (newline-and-indent)))
            (global-set-key (kbd "RET") 'newline-and-insert-newline-and-indent-after-brace)

            (global-set-key (kbd "s-g") 'magit-status)

            (add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)))

(add-hook 'prog-mode-hook
          (lambda ()
            (which-func-mode t)
            (add-to-list 'auto-mode-alist '("\\.t$" . perl-mode))

            ;; (require 'init-tabbar)
            (require 'init-flycheck)
            (require 'init-auto-complete)
            (require 'init-cc)
            (require 'init-ruby)
            (require 'init-js)
            (require 'init-sh)
            (require 'init-tex)
            (require 'init-css)
            (require 'init-haml)
            (require 'init-programming-contest)))

(provide 'init-programming)
