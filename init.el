(let ((default-directory "~/.emacs.d/"))
  (normal-top-level-add-subdirs-to-load-path))
(add-to-list 'load-path "~/.emacs.d/init.d/")

(setq gc-cons-threshold 536870912)
(autoload 'esup "esup" "Emacs Start Up Profiler." nil)

(require 'init-global-configs)
(require 'init-packages)
(require 'init-face)
(require 'init-programming-settings)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((encoding . utf-8) (eval when (and (buffer-file-name) (file-regular-p (buffer-file-name)) (string-match-p "^[^.]" (buffer-file-name))) (emacs-lisp-mode) (when (fboundp (quote flycheck-mode)) (flycheck-mode -1)) (unless (featurep (quote package-build)) (let ((load-path (cons ".." load-path))) (require (quote package-build)))) (package-build-minor-mode))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
