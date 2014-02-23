(defun what-face (pos)
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))

(when (package-installed-p 'zenburn-theme)
  (load-theme 'zenburn t)
  (set-face-background 'region "#1B1B1B"))

(setq default-frame-alist
      (append '((alpha . 85)) default-frame-alist))

(custom-set-faces
 '(flymake-errline ((((class color)) (:underline (:color "red" :style wave)))))
 '(flymake-warnline ((((class color)) (:underline (:color "yellow"))))))

(add-hook 'window-setup-hook
          (lambda ()
            (global-linum-mode)
            (global-hl-line-mode 1)
            (hlinum-activate)

            (line-number-mode 1)
            (setq linum-format "%3d ")

            (column-number-mode 1)
            (setq frame-title-format '("%f"))

            (when (require 'git-gutter-fringe nil t)
              (global-git-gutter-mode t))

            (show-paren-mode 1)
            (setq show-paren-delay 0)
            (set-face-underline-p 'show-paren-match-face "orange red")

            (when (require 'rainbow-delimiters nil t)
              (global-rainbow-delimiters-mode))

            (when (require 'powerline nil t)
              (powerline-default-theme))

            (when (require 'diminish nil t)
              (diminish 'git-gutter-mode)
              (diminish 'textmate-mode)
              (diminish 'undo-tree-mode)
              (diminish 'smooth-scroll-mode)
              (diminish 'auto-complete-mode)
              (diminish 'smartparens-mode))))

(provide 'init-face)
