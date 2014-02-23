(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.jbuilder$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.cap$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile" . ruby-mode))
(add-hook 'ruby-mode-hook
          (lambda ()
            (setq
             ruby-deep-indent-paren nil
             ruby-deep-arglist nil
             ruby-insert-encoding-magic-comment nil)
            (require 'smartparens-ruby)
;;             (when (require 'ruby-block nil t)
;;               (ruby-block-mode 1)
;;               (setq
;;                ruby-block-highlight-toggle t
;;                ruby-block-delay 0)
;;               (defface original-ruby-block-highlight-face
;; ;;                '((t (:background "#444444")))
;;                 '((t (:background "#666666")))
;;                 "Face used for ruby block highlight")
;;               (setq ruby-block-highlight-face 'original-ruby-block-highlight-face))
;;             (when (require 'ruby-end nil t)
;;               (ruby-end-mode 1)
;;               (setq
;;                ruby-end-insert-newline nil
;;                ruby-end-expand-on-ret nil))
            ))

(provide 'init-ruby)
