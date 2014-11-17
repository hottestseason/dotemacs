(setq c-default-style "linux")
(add-hook 'c-mode-common-hook
          (lambda ()
            (setq c-basic-offset 2)
            (setq flycheck-clang-standard-library "libc++")
            (setq flycheck-clang-language-standard "c++11")))

;; Qt
(require 'cc-mode)
(font-lock-add-keywords 'c++-mode '(("\\<\\(Q_OBJECT\\|public slots\\|signals\\|public signals\\|private slots\\|private signals\\|protected slots\\|protected signals\\)\\>" . font-lock-constant-face)))

(add-hook 'd-mode-hook
          (lambda ()
             (setup-flycheck-d-unittest)))

(provide 'init-cc)
