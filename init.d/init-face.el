(require 'color)

(custom-set-variables
 '(default-frame-alist (append '((alpha . 90)) default-frame-alist)))

(defun what-face (pos)
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))

(when (package-installed-p 'zenburn-theme)
  (load-theme 'zenburn t)
  (set-face-attribute 'region nil :background (color-darken-name (face-attribute 'region :background) 4)))

(add-hook 'window-setup-hook
          (lambda ()
            (set-face-attribute 'default nil
                                :family "Ricty Discord"
                                :height 140)
            (set-fontset-font (frame-parameter nil 'font)
                              'japanese-jisx0208
                              (cons "Ricty Discord" "iso10646-1"))
            (set-fontset-font (frame-parameter nil 'font)
                              'japanese-jisx0212
                              (cons "Ricty Discord" "iso10646-1"))
            (set-fontset-font (frame-parameter nil 'font)
                              'katakana-jisx0201
                              (cons "Ricty Discord" "iso10646-1"))

            (global-linum-mode)
            (global-hl-line-mode 1)
            (hlinum-activate)

            (global-yascroll-bar-mode 1)
            (custom-set-variables
             '(yascroll:delay-to-hide nil))

            (custom-set-faces
             '(flymake-errline ((t (:underline (:color "red" :style wave)))))
             '(flymake-warnline ((t (:underline (:color "yellow"))))))

            (when (require 'volatile-highlights nil t)
              (volatile-highlights-mode t)
              (custom-set-faces
               '(vhl/default-face ((t (:background "dark slate gray"))))))

            (line-number-mode 1)
            (custom-set-variables
             '(linum-format "%3d "))

            (column-number-mode 1)
            (setq frame-title-format '("%f"))

            (show-paren-mode 1)
            (set-face-attribute 'show-paren-match-face nil :underline "red")
            (custom-set-variables
             '(show-paren-delay 0.1))

            (when (require 'rainbow-delimiters nil t)
              (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

            (require 'init-modeline)))

(eval-after-load 'vc-git
  '(progn
     (when (require 'git-gutter-fringe nil t)
       (global-git-gutter-mode t))))

(provide 'init-face)
