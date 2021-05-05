(require 'package)

(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("org"   . "https://orgmode.org/elpa/")))

  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)
    :config
    (leaf-keywords-init)))

(leaf cus-edit
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

(leaf cus-start
  :preface
  (defun what-face (pos)
    (interactive "d")
    (let ((face (or (get-char-property (point) 'read-face-name)
                    (get-char-property (point) 'face))))
      (if face (message "Face: %s" face) (message "No face at %d" pos))))
  (defun other-window-or-split ()
    (interactive)
    (when (one-window-p)
      (split-window-horizontally))
    (other-window 1))
  (defun text-scale-reset ()
    (interactive)
    (text-scale-set 0))
  (defun newline-and-insert-newline-and-indent-after-brace ()
    (interactive)
    (if (and (eq (char-before) ?{) (eq (following-char) ?}))
        (progn
          (newline-and-indent)
          (save-excursion
            (insert "\n")
            (indent-according-to-mode))
          (indent-according-to-mode))
      (newline-and-indent)))
  :bind (("C-c l" . toggle-truncate-lines)
         ("<C-tab>" . other-window-or-split)
         ("C-x o" . other-window-or-split)
         ("C-." . hippie-expand)
         ("M-SPC" . cycle-spacing)
         ("M-g" . goto-line)
         ("RET" . newline-and-insert-newline-and-indent-after-brace)
         ("s-a" . mark-whole-buffer)
         ("s-c" . kill-ring-save)
         ("s-l" . goto-line)
         ("s-s" . save-buffer)
         ("s-v" . yank)
         ("s-w" . delete-frame)
         ("s-z" . undo)
         ("s-Z" . redo)
         ("s-x" . kill-region)
         ("s-=" . text-scale-increase)
         ("s--" . text-scale-decrease)
         ("s-0" . text-scale-reset))
  :custom ((auto-save-timeout . 15)
           (auto-save-interval . 60)
           (auto-save-file-name-transforms . `((".*", (expand-file-name "~/.emacs.d/backups/") t)))
           (backup-directory-alist . `(("." . "~/.emacs.d/backups")))
           (create-lockfiles . nil)
           (cua-enable-cua-keys . nil)
           (debug-on-error . t)
           (delete-old-versions . t)
           (echo-keystrokes . 0.1)
           (fill-column . 100)
           (frame-title-format . '("%f"))
           (garbage-collection-messages . t)
           (gc-cons-threshold . 1073741824)
           (hippie-expand-try-functions-list . '(try-expand-dabbrev
                                                 try-expand-dabbrev-all-buffers
                                                 try-expand-dabbrev-from-kill
                                                 try-complete-file-name-partially
                                                 try-complete-file-name
                                                 try-expand-all-abbrevs
                                                 try-expand-list try-expand-line
                                                 try-complete-lisp-symbol-partially
                                                 try-complete-lisp-symbol))
           (inhibit-startup-message . t)
           (indent-tabs-mode . nil)
           (kill-read-only-ok . t)
           (ring-bell-function . 'ignore)
           (recentf-max-saved-items . 10000000)
           (recentf-max-menu-items . 10000)
           (recentf-exclude . '("\.ido\.hist" "\.ido\.last" "xhtml-loader\.rnc" "elpa\/"))
           (recentf-auto-cleanup . 'never)
           (scroll-bar-mode . nil)
           (scroll-preserve-screen-position . t)
           (tab-width . 2)
           (tool-bar-mode . nil)
           (truncate-lines . t)
           (truncate-partial-width-windows . t)
           (undo-limit . 1000000)
           (undo-strong-limit . 1000000)
           (vc-follow-symlinks . t)
           (version-control . t))
  :config
  (custom-set-variables
   '(default-frame-alist (append '((alpha . 90)) default-frame-alist)))
  (column-number-mode t)
  (cua-mode t)
  (defalias 'yes-or-no-p 'y-or-n-p)
  (electric-pair-mode t)
  (global-display-line-numbers-mode t)
  (global-hl-line-mode t)
  (global-subword-mode t)
  (dolist (cmd '(forward-word backward-word mark-word kill-word backward-kill-word transpose-words capitalize-word upcase-word downcase-word left-word right-word))
    (let ((othercmd (let ((name (symbol-name cmd)))
                      (string-match "\\([[:alpha:]-]+\\)-word[s]?" name)
                      (intern (concat "subword-" (match-string 1 name))))))
      (substitute-key-definition cmd othercmd global-map)))
  (prefer-coding-system 'utf-8)
  (which-function-mode t)
  (run-with-idle-timer 60.0 t #'garbage-collect)
  (set-face-attribute 'default nil
                      :family "Ricty Diminished"
                      :height 140)
  (set-fontset-font (frame-parameter nil 'font)
                    'japanese-jisx0208
                    (cons "Ricty Diminished" "iso10646-1"))
  (set-fontset-font (frame-parameter nil 'font)
                    'japanese-jisx0212
                    (cons "Ricty Diminished" "iso10646-1"))
  (set-fontset-font (frame-parameter nil 'font)
                    'katakana-jisx0201
                    (cons "Ricty Diminished" "iso10646-1"))
  (add-hook 'write-file-functions 'delete-trailing-whitespace)
  (make-variable-buffer-local 'post-self-insert-hook)
  (add-hook 'after-change-major-mode-hook
            (lambda ()
              (cond ((memq major-mode '(haskell-mode
                                        markdown-mode
                                        latex-mode
                                        python-mode
                                        yaml-mode))
                     (electric-indent-mode -1)
                     (local-set-key (kbd "RET") 'newline-and-indent))
                    (t
                     (electric-indent-mode 1)))))
  (add-hook 'makefile-mode-hook
            (lambda ()
              (setq indent-tabs-mode t)))
  (cond ((featurep 'gtk)
         (setq x-alt-keysym 'meta)
         (setq x-meta-keysym 'super))))

(leaf all-the-icons
  :ensure t)

(leaf anzu
  :ensure t
  :global-minor-mode global-anzu-mode
  :config
  (custom-set-variables
   '(anzu-mode-lighter nil)
   '(anzu-search-threshold 1000)))

(leaf auto-revert
  :custom ((auto-revert-interval . 1))
  :global-minor-mode global-auto-revert-mode)

(leaf company
  :ensure t
  :blackout t
  :leaf-defer nil
  :bind ((company-active-map
          ("M-n" . nil)
          ("M-p" . nil)
          ("C-s" . company-filter-candidates)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("<tab>" . company-complete-selection))
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)))
  :custom ((company-idle-delay . 0)
           (company-minimum-prefix-length . 2)
           (completion-ignore-case . t)
           (company-dabbrev-downcase . nil))
  :hook
  (prog-mode-hook . company-mode)
  :config
  (leaf company-anyware
    :el-get zk-phi/company-anywhere
    :config
    (require 'company-anywhere))
  (leaf company-box
    :ensure t
    :after all-the-icons
    :custom
    (company-box-icons-alist 'company-box-icons-all-the-icons)
    :hook
    ((company-mode-hook . company-box-mode)))
  (leaf company-posframe
    :ensure t
    :global-minor-mode t)
  (leaf company-statistics
    :ensure t
    :global-minor-mode t))

(leaf delete-selection
  :global-minor-mode delete-selection-mode)

(leaf diminish
  :ensure t)

(leaf dired-x
  :require t
  :bind ((dired-mode-map
          ("r" . wdired-change-to-wdired-mode))))

(leaf dockerfile-mode
  :ensure t)

(leaf doom-themes
  :ensure t
  :custom
  (doom-themes-enable-italic . t)
  (doom-themes-enable-bold . t)
  :config
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  (doom-themes-org-config))

(leaf doom-modeline
  :ensure t
  :require t
  :hook (after-init-hook . doom-modeline-mode)
  :custom
  (doom-modeline-buffer-file-name-style . 'truncate-with-project)
  (doom-modeline-icon . t)
  (doom-modeline-major-mode-icon . nil)
  (doom-modeline-minor-modes . nil))

(leaf editorconfig
  :ensure t)

(leaf exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH"))

(leaf expand-region
  :ensure t
  :bind (("S-SPC" . er/expand-region)))

(leaf go-mode
  :ensure t
  :custom
  (gofmt-command . "goimports")
  :hook
  (before-save-hook . gofmt-before-save))

(leaf flycheck
  :ensure t
  :custom ((flycheck-idle-change-delay . 0.5)
           (flycheck-disabled-checkers . '(emacs-lisp-checkdoc html-tidy)))
  :global-minor-mode global-flycheck-mode
  :config
  (leaf flycheck-posframe
    :ensure t
    :hook
    (flycheck-mode-hook . flycheck-posframe-mode)))

(leaf highlight-indent-guides
  :ensure t
  :custom
  (highlight-indent-guides-responsive top)
  (highlight-indent-guides-method . 'column)
  :hook
  ((prog-mode-hook yaml-mode-hook) . highlight-indent-guides-mode))

(leaf imenu-list
  :ensure t
  :bind (("s-i" . imenu-list-smart-toggle))
  :custom
  (imenu-list-focus-after-activation . t)
  :config
  (leaf leaf-tree
    :ensure t))

(leaf ivy
  :ensure t
  :blackout t
  :bind (("C-x b" . ivy-switch-buffer)
         ("C-x C-f" . counsel-find-file)
         ("M-x" . counsel-M-x)
         ("M-y" . counsel-yank-pop)
         ("M-z" . ivy-resume))
  :custom ((ivy-virtual-abbreviate . 'abbreviate)
           (ivy-count-format . "(%d/%d) ")
           (ivy-height . 20)
           (ivy-initial-inputs-alist . nil)
           (ivy-truncate-lines . nil)
           (ivy-use-selectable-prompt . t)
           (ivy-use-virtual-buffers . t)
           (ivy-wrap . t))
  :global-minor-mode t
  :config
  (leaf ivy-rich
    :ensure t
    :global-minor-mode t
    :config
    (leaf all-the-icons-ivy-rich
      :ensure t
      :global-minor-mode t))
  (leaf counsel
    :ensure t
    :blackout t
    :bind ((counsel-find-file-map
            ("<left>" . counsel-up-directory)
            ("<right>" . counsel-down-directory)))
    :custom `((counsel-yank-pop-separator . "\n----------\n")
              (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
    :global-minor-mode t
    :config
    (leaf counsel-projectile
      :ensure t
      :after projectile
      :bind (("M-p" . counsel-projectile-switch-project)
             ("M-t" . counsel-projectile-find-file)
             ("M-s" . counsel-projectile-rg))
      :custom ((counsel-projectile-sort-projects . t)
               (counsel-projectile-sort-files . t)
               (counsel-projectile-sort-directories . t)
               (counsel-projectile-sort-buffers . t))
      :global-minor-mode t)))

(leaf ivy-prescient
  :ensure t
  :after prescient ivy
  :custom ((ivy-prescient-retain-classic-highlighting . t))
  :global-minor-mode t)

(leaf magit
  :ensure t
  :preface
  (defun magit-stash-show-after (&rest args)
    (delete-other-windows))
  :custom ((magit-display-buffer-function . #'magit-display-buffer-fullframe-status-v1)
           (magit-diff-refine-hunk . t)
           (magit-no-confirm . t)
           (magit-delta-delta-args  . '("--features" "magit-delta")))
  :advice (:after magit-stash-show magit-stash-show-after)
  :config
  (remove-hook 'magit-refs-sections-hook 'magit-insert-tags)
  (remove-hook 'magit-refs-sections-hook 'magit-insert-remote-branches))

(leaf markdown-mode
  :ensure t)

(leaf move-text
  :ensure t
  :config
  (move-text-default-bindings))

(leaf neotree
  :ensure t
  :preface
  (defun neotree-projectile-toggle ()
      (interactive)
      (let ((neo-smart-open t))
        (neotree-toggle)))
  :bind (("C-t" . neotree-projectile-toggle)))

(leaf org
  :bind ((:org-mode-map
          ("<S-down>" . nil)))
  :config
  (leaf org-superstar
    :ensure t
    :hook
    (org-mode-hook (lambda () (org-superstar-mode 1)))))

(leaf point-undo
  :el-get emacsmirror/point-undo
  :require t
  :bind (("M-/" . point-undo)
         ("M-?" . point-redo)))

(leaf perl-mode
  :mode (("\\.t$" . perl-mode))
  :config
  ;; void-function remove-if
  ;; (leaf set-perl5lib
  ;;   :el-get gist:1333926:git
  ;;   :hook
  ;;   (perl-mode-hook . set-perl5lib))
  )

(leaf prescient
  :ensure t
  :custom ((prescient-aggressive-file-save . t))
  :global-minor-mode prescient-persist-mode)

(leaf projectile
  :ensure t
  :custom ((projectile-enable-caching . t)
           (projectile-require-project-root . nil))
  :global-minor-mode t)

(leaf rainbow-delimiters
  :ensure t
  :hook
  (prog-mode-hook . rainbow-delimiters-mode))

(leaf rainbow-mode
  :ensure t
  :hook
  (web-mode-hook . rainbow-mode))

(leaf rbenv
  :ensure t
  :global-minor-mode global-rbenv-mode)

(leaf recentf-ext
  :ensure t)

(leaf ruby-mode
  :mode (("\\.rb$" . ruby-mode)
         ("Gemfile" . ruby-mode)
         ("Capfile" . ruby-mode)
         ("\\.jbuilder$" . ruby-mode)
         ("\\.rake$" . ruby-mode)
         ("Rakefile" . ruby-mode)
         ("\\.cap$" . ruby-mode)
         ("Guardfile" . ruby-mode)
         ("\\.schema$" . ruby-mode))
  :custom ((ruby-deep-indent-paren . nil)
           (ruby-deep-arglist . nil)
           (ruby-insert-encoding-magic-comment . nil))
  :config
  (add-to-list 'auto-mode-alist '("\\.t$" . perl-mode)))

(leaf save-place
  :global-minor-mode save-place-mode)

(leaf savehist
  :global-minor-mode savehist-mode)

(leaf sequential-command
  :ensure t
  :preface
  (defun seq-upcase-backward-word ()
    (interactive)
    (upcase-word (- (1+ (seq-count*)))))
  (defun seq-capitalize-backward-word ()
    (interactive)
    (capitalize-word (- (1+ (seq-count*)))))
  (defun seq-downcase-backward-word ()
    (interactive)
    (downcase-word (- (1+ (seq-count*)))))
  :bind
  (("C-a" . seq-home)
   ("C-e" . seq-end)
   ("M-u" . seq-upcase-backward-word)
   ("M-c" . seq-capitalize-backward-word)
   ("M-l" . seq-downcase-backward-word))
  :config
  (define-sequential-command seq-home
    beginning-of-line beginning-of-buffer seq-return)
  (define-sequential-command seq-end
    end-of-line end-of-buffer seq-return))

(leaf server
  :require t
  :config
  (unless (server-running-p) (server-start)))

(leaf show-paren
  :custom ((show-paren-delay . 0.1))
  :global-minor-mode show-paren-mode)

(leaf smartparens
  :ensure t
  :require smartparens-config
  :config
  (smartparens-global-mode t)
  (show-smartparens-global-mode t))

(leaf smooth-scroll
  :ensure t
  :require t
  :custom (smooth-scroll/vscroll-step-size . 4)
  :global-minor-mode smooth-scroll-mode)

(leaf textmate
  :ensure t
  :preface
  (defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))
  :bind ((*textmate-mode-map*
          ("<C-tab>" . nil)
          ("C-c C-t" . nil)
          ("M-<up>" . nil)
          ("M-<down>" . nil)
          ("M-t" . nil)
          ("s-[" . textmate-shift-left)
          ("s-]" . textmate-shift-right))
         ("s-/" . comment-or-uncomment-region-or-line))
  :global-minor-mode t)

(leaf undo-tree
  :ensure t
  :bind (("s-Z" . undo-tree-redo))
  :global-minor-mode global-undo-tree-mode)

(leaf undohist
  :ensure t
  :require t
  :config
  (undohist-initialize))

(leaf volatile-highlights
  :ensure t
  :global-minor-mode volatile-highlights-mode)

(leaf web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.tt\\'" . web-mode)
         ("\\.scss\\'" . web-mode)
         ("\\.css\\'" . web-mode)
         ("\\.js\\'" . web-mode))
  :custom
  (web-mode-markup-indent-offset . 2)
   (web-mode-css-indent-offset . 2)
   (web-mode-code-indent-offset . 2)
   (web-mode-comment-style . 2)
   (web-mode-style-padding . 1)
   (web-mode-script-padding . 1))

(leaf yaml-mode
  :ensure t)

(leaf yascroll
  :ensure t
  :custom
  (yascroll:delay-to-hide . nil)
  :global-minor-mode global-yascroll-bar-mode)
