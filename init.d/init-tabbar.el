(when (require 'tabbar nil t)
  (tabbar-mode 1)

  (tabbar-mwheel-mode -1)

  (dolist (btn '(tabbar-buffer-home-button
                 tabbar-scroll-left-button
                 tabbar-scroll-right-button))
    (set btn (cons (cons "" nil)
                   (cons "" nil))))

  (global-set-key (kbd "<C-tab>") 'tabbar-forward-tab)
  (global-set-key (kbd "<C-S-tab>") 'tabbar-backward-tab)
  (global-set-key (kbd "<C-M-tab>") 'tabbar-forward-group)
  (global-set-key (kbd "<C-M-S-tab>") 'tabbar-backward-group)

  (set-face-attribute
   'tabbar-default nil
   :family (face-attribute 'default :family)
   :background (face-attribute 'mode-line-inactive :background)
   :height 1.0)
  (set-face-attribute
   'tabbar-unselected nil
   :background (face-attribute 'mode-line-inactive :background)
   :foreground (face-attribute 'mode-line-inactive :foreground)
   :box nil)
  (set-face-attribute
   'tabbar-selected nil
   :background (face-attribute 'mode-line :background)
   :foreground (face-attribute 'mode-line :foreground)
   :box nil)
  (set-face-attribute
   'tabbar-separator nil
   :height 1.4)

  (setq tabbar-buffer-groups-function
        (lambda ()
          (list (cond ((string-equal "*" (substring (buffer-name) 0 1)) "emacs")
                      (t (project-root-or-current-directory))))))

  ; Add a buffer modification state indicator in the label (http://www.emacswiki.org/emacs/TabBarMode#toc13)
  ;; Add a buffer modification state indicator in the tab label, and place a
  ;; space around the label to make it looks less crowd.
  (defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
    (setq ad-return-value
          (if (and (buffer-modified-p (tabbar-tab-value tab))
                   (buffer-file-name (tabbar-tab-value tab)))
              (concat "+" (concat ad-return-value " "))
            (concat " " (concat ad-return-value " ")))))
  ;; Called each time the modification state of the buffer changed.
  (defun ztl-modification-state-change ()
    (tabbar-set-template tabbar-current-tabset nil)
    (tabbar-display-update))
  ;; First-change-hook is called BEFORE the change is made.
  (defun ztl-on-buffer-modification ()
    (set-buffer-modified-p t)
    (ztl-modification-state-change))
  (add-hook 'after-save-hook 'ztl-modification-state-change)
  ;; This doesn't work for revert, I don't know.
  ;;(add-hook 'after-revert-hook 'ztl-modification-state-change)
  (add-hook 'first-change-hook 'ztl-on-buffer-modification))

(provide 'init-tabbar)
