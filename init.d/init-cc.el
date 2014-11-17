(add-hook 'c-mode-common-hook
          (lambda ()
            (setq
             c-default-style "linux"
             c-basic-offset 2
             flycheck-clang-standard-library "libc++"
             flycheck-clang-language-standard "c++11")

            ;; Qt
            (font-lock-add-keywords 'c++-mode '(("\\<\\(Q_OBJECT\\|public slots\\|signals\\|public signals\\|private slots\\|private signals\\|protected slots\\|protected signals\\)\\>" . font-lock-constant-face)))))

(add-hook 'd-mode-hook
          (lambda ()
             (setup-flycheck-d-unittest)))

(provide 'init-cc)
