(require 'set-perl5lib)

(add-hook 'perl-mode-hook
          (lambda ()
            (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
              (setq flymake-check-was-interrupted t))
            (ad-activate 'flymake-post-syntax-check)
            (set-perl5lib)))

(provide 'init-perl)
