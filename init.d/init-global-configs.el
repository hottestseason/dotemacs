(tool-bar-mode -1)
(scroll-bar-mode -1)

(add-hook 'after-init-hook
          (lambda ()
            (require 'server)
            (unless (server-running-p) (server-start))

            (setq inhibit-startup-message t)

            (savehist-mode t)

            (setq-default save-place t)
            (require 'saveplace)

            (add-to-list 'backup-directory-alist (cons "." "~/.emacs.d/backups"))

            (setq auto-save-file-name-transforms `((".*", (expand-file-name "~/.emacs.d/backups/") t)))

            (setq create-lockfiles nil)

            (global-auto-revert-mode t)

            (setq undo-limit 1000000)
            (setq undo-strong-limit 1000000)

            (setq-default abbrev-mode nil)

            (setq echo-keystrokes 0.1)

            (defalias 'yes-or-no-p 'y-or-n-p)

            (setq truncate-lines t)
            (setq truncate-partial-width-windows t)
            (global-set-key (kbd "C-c l") 'toggle-truncate-lines)

            (setq vc-follow-symlinks t)

            (require 'ido)
            (ido-mode t)
            (ido-everywhere t)

            (require 'uniquify)
            (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
            (setq uniquify-ignore-buffer-re "*[^*]+*")

            ;; change window
            (defun other-window-or-split ()
              (interactive)
              (when (one-window-p)
                (split-window-horizontally))
              (other-window 1))
            (global-set-key (kbd "<C-tab>") 'other-window-or-split)
            (global-set-key (kbd "C-x o") 'other-window-or-split)

            (setq hippie-expand-try-functions-list
                  '(try-expand-dabbrev
                    try-expand-dabbrev-all-buffers
                    try-expand-dabbrev-from-kill
                    try-complete-file-name-partially
                    try-complete-file-name
                    try-expand-all-abbrevs
                    try-expand-list try-expand-line
                    try-complete-lisp-symbol-partially
                    try-complete-lisp-symbol))
            (global-set-key (kbd "C-.") 'hippie-expand)

            (require 'smooth-scrolling)

            (when (require 'smooth-scroll nil t)
              (smooth-scroll-mode t)
              (setq smooth-scroll/vscroll-step-size 4))

            (when (package-installed-p 'exec-path-from-shell)
              (when (memq window-system '(mac ns))
                (exec-path-from-shell-initialize)))

            (when (require 'sequential-command-config nil t)
              (global-set-key (kbd "C-a") 'seq-home)
              (global-set-key (kbd "C-e") 'seq-end)
              (global-set-key (kbd "M-u") 'seq-upcase-backward-word)
              (global-set-key (kbd "M-c") 'seq-capitalize-backward-word)
              (global-set-key (kbd "M-l") 'seq-downcase-backward-word))

            (when (require 'expand-region nil t)
              (global-set-key (kbd "S-SPC") 'er/expand-region))

            (add-hook 'dired-mode-hook
                      (lambda ()
                        (when (require 'dired-x nil t)
                          (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode))))

            (setq recentf-max-saved-items 1000000)
            (setq recentf-max-menu-items 500)
            (setq recentf-exclude '("\.ido\.hist" "\.ido\.last" "xhtml-loader\.rnc" "elpa\/"))

            (when (require 'undo-tree nil t)
              (global-undo-tree-mode t)
              (define-key undo-tree-map (kbd "s-Z") 'undo-tree-redo))

            (when (require 'undohist nil t)
              (undohist-initialize))

            (when (require 'point-undo nil t)
              (global-set-key (kbd "M-/") 'point-undo)
              (global-set-key (kbd "M-?") 'point-redo))

            (when (require 'textmate nil t)
              (textmate-mode 1)
              (define-key *textmate-mode-map* (kbd "M-<up>") nil)
              (define-key *textmate-mode-map* (kbd "M-<down>") nil))

            (when (require 'move-text nil t)
               (move-text-default-bindings))

            (cua-mode 1)
            (setq cua-enable-cua-keys nil)

            (add-hook 'before-save-hook
                      (lambda ()
                        (when buffer-file-name
                          (let ((dir (file-name-directory buffer-file-name)))
                            (when (and (not (file-exists-p dir))
                                       (y-or-n-p (format "Directory %s does not exist. Create it?" dir)))
                              (make-directory dir t))))))

            (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

            (global-set-key (kbd "C->") 'mc/mark-next-like-this)
            (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
            (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)))


(provide 'init-global-configs)
