(add-hook 'latex-mode-hook
          (lambda ()
            (flycheck-mode -1)))

(provide 'init-tex)
