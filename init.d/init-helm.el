(when (require 'helm nil t)
  (require 'helm-config)
  (require 'helm-command)
  (setq
   helm-idle-delay 0
   helm-input-idle-delay 0
   helm-candidate-number-limit 1000
   helm-quick-update t
   helm-m-occur-idle-delay 0
   helm-ff-transformer-show-only-basename nil
   helm-split-window-preferred-function (lambda (window)
                                          (cond ((require 'popwin nil t)
                                                 (nth 1 (popwin:create-popup-window 25)))
                                                (t
                                                 (split-window-sensibly)))))
  (global-set-key (kbd "M-s") 'helm-occur)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  (global-set-key (kbd "M-z") 'helm-resume)
  (global-set-key (kbd "M-o") 'helm-mini)
  (global-set-key (kbd "s-o") 'helm-mini)

  (when (and (require 'projectile nil t) (require 'helm-files nil t))
    (projectile-global-mode)
    (setq projectile-require-project-root nil)
    (global-set-key (kbd "M-t") 'helm-project-files)
    (global-set-key (kbd "s-f") 'helm-ack-project)
    (defun helm-mini ()
      (interactive)
      (let ((file-list '(helm-c-source-buffers-list helm-c-source-recentf helm-c-source-buffer-not-found)))
        (if (and (projectile-project-root) (and
                                            (not (equal (projectile-project-root) "~/"))
                                            (not (equal (projectile-project-root) "/"))))
            (add-to-list 'file-list helm-c-source-ack-project-files))
        (helm-other-buffer file-list "*helm for files*")))

    (defvar helm-c-source-ack-project-files
      '((name . "helm ack project files")
        (init . (lambda ()
                  (helm-candidate-buffer (ack-files-to-buf (project-root-or-current-directory)))))
        (candidates-in-buffer)
        (display-to-real . (lambda (display)
                             (with-current-buffer helm-current-buffer
                               (format "%s%s" (projectile-project-root) (car (split-string display " => "))))))
        (action .  (("Find file" . helm-find-many-files)
                    ("View file" . view-file)
                    ("Insert file" . insert-file)
                    ("Delete file(s)" . helm-delete-marked-files)))))

    (defun ack-files-to-buf (directory)
      (lexical-let* ((ack-files-result-buf (get-buffer-create (format "*ack-files-%s*" directory))))
        (with-current-buffer ack-files-result-buf
          (erase-buffer))
        (set-process-sentinel
         (let ((default-directory directory))
           (start-process (format "ack-files-%s" directory) ack-files-result-buf "ack" "-f"))
         (lambda (proc stat)
           (with-current-buffer ack-files-result-buf
             (while (re-search-forward "Process .* finished" nil t)
               (beginning-of-line)
               (kill-line)))))
        ack-files-result-buf))

    (defun project-root-or-current-directory ()
      (or (projectile-project-root) default-directory))

    (defun permute (lat)
      (cond
       ((null lat) '(()))
       (t (mapcan
           (lambda (atm)
             (mapcar (lambda (lst) (cons atm lst))
                     (permute (remove* atm lat :count 1))))
           lat))))

    (defun build-regexp-from-patterns (patterns)
      (mapconcat (lambda (ordered-patterns)
                   (mapconcat (lambda (pattern)
                                (format "(%s)" pattern)) ordered-patterns ".*"))
                 (permute patterns) "|"))

    (defun build-emacs-regexp-from-patterns (patterns)
      (mapconcat (lambda (ordered-patterns)
                   (mapconcat (lambda (pattern)
                                (format "\\(%s\\)" pattern)) ordered-patterns ".*"))
                 (permute patterns) "|"))

    (if (s-blank? "") "." "fdaij")
    (defun helm-grep-files (root-directory files patterns)
      (let ((default-directory root-directory)
            (content-patterns (-map (lambda (pattern) (substring pattern 1)) (-filter (lambda (pattern) (s-starts-with? "@" pattern)) patterns)))
            (matched-files (-filter (lambda (file) (s-match (build-emacs-regexp-from-patterns (-remove (lambda (pattern) (s-starts-with? "@" pattern)) patterns)) file)) files)))
        ;; (message "content-patterns: %s\nfile-patterns: %s\negrep: %s" content-patterns matched-files (format "egrep -i --color=never -n '%s' %s | head" (build-regexp-from-patterns content-patterns) (mapconcat #'identity matched-files " ")))
        (split-string (shell-command-to-string (format "egrep -i --color=never -n '%s' %s | head" (if (s-blank? (build-regexp-from-patterns content-patterns)) "." (build-regexp-from-patterns content-patterns)) (mapconcat #'identity matched-files " "))) "\n")))
    (defun helm-grep-files-match (candidate)
      t)

    (defvar helm-c-source-ack-project-cache (make-hash-table :test 'equal))
    (defvar helm-c-source-ack-project
      '((name . "helm ack project")
        (requires-pattern)
        (volatile)
        (recenter)
        (delayed)
        (match helm-grep-files-match)
        (init . (lambda ()
                  (setq
                   helm-c-source-ack-project-root (project-root-or-current-directory)
                   helm-c-source-ack-project-files-buf (ack-files-to-buf helm-c-source-ack-project-root))
                  (puthash helm-c-source-ack-project-root (make-hash-table :test 'equal) helm-c-source-ack-project-cache)))
        (candidates . (lambda ()
                        (let ((ack-project-results-cache (gethash helm-c-source-ack-project-root helm-c-source-ack-project-cache))
                              (project-files (replace-regexp-in-string "\n" " " (with-current-buffer helm-c-source-ack-project-files-buf
                                                                                  (buffer-string)))))
                          (unless (gethash helm-pattern ack-project-results-cache)
                            (puthash helm-pattern (helm-grep-files helm-c-source-ack-project-root (split-string project-files) (split-string helm-pattern)) ack-project-results-cache))
                          (gethash helm-pattern ack-project-results-cache))))
        (action .  (("Go to" . (lambda (file-line)
                                 (with-current-buffer helm-current-buffer
                                   (let* ((current-directory (file-name-directory (or (buffer-file-name) dired-directory)))
                                          (file (nth 1 (split-string (nth 2 file-line) current-directory)))
                                          (lineno (nth 0 file-line))
                                          (content (nth 1 file-line)))
                                     ;; (message (format "file-line: %s\ncurrent-directory: %s\nfile: %s\nlineno: %s\ncontent: %s" file-line current-directory file lineno content))
                                     (helm-goto-file-line lineno content (format "%s%s" (project-root-or-current-directory) file))))))))
        (type . file-line)))

    (defun helm-ack-project ()
      (interactive)
      (helm-other-buffer '(helm-c-source-ack-project)
                         (format "*helm project files (%s)*" (project-root-or-current-directory))))

    (defun helm-project-files ()
      (interactive)
      (if (projectile-project-root)
          (helm-other-buffer '(helm-c-source-ack-project-files
                               helm-c-source-buffer-not-found)
                             (format "*helm project files (%s)*" (projectile-project-root)))
        (helm-mini)))

    (defun helm-do-grep-project ()
      (interactive)
      (helm-do-grep-1 (list (project-root-or-current-directory)) t))))

(provide 'init-helm)
