(add-to-list 'auto-mode-alist '("\\.zsh$" . shell-script-mode))
(add-hook 'sh-mode-hook (lambda ()
                          (setq sh-indentation 2)
                          (setq sh-basic-offset 2)))

(provide 'init-sh)
