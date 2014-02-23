(when (require 'auto-complete-config nil t)
  (ac-config-default)
  (setq
   ac-delay 0.1
   ac-auto-show-menu 0.2
   ac-use-menu-map t)
  (add-to-list 'ac-modes 'coffee-mode)
  (add-to-list 'ac-modes 'scss-mode)
  (add-to-list 'ac-modes 'rhtml-mode)
  (add-to-list 'ac-modes 'haml-mode)
  (add-to-list 'ac-modes 'slim-mode)
  (setq-default ac-sources
                '(ac-source-abbrev
                  ac-source-dictionary
                  ac-source-words-in-same-mode-buffers))

  ;; (when (require 'auto-complete-clang-async nil t)
  ;;   (add-hook 'c-mode-common-hook
  ;;             (lambda ()
  ;;               (setq ac-sources
  ;;                     (append '(ac-source-clang-async) ac-sources))
  ;;               (ac-clang-launch-completion-process))))

  ;; (when (require 'auto-complete-clang nil t)
  ;;   (add-hook 'c-mode-common-hook
  ;;             (lambda ()
  ;;               (setq ac-sources
  ;;                     (append '(ac-source-clang ac-source-yasnippet) ac-sources)))))

  (add-hook 'css-mode-hook
            (lambda ()
              (setq ac-sources
                    (append '(ac-source-css-property) ac-sources)))))

(provide 'init-auto-complete)
