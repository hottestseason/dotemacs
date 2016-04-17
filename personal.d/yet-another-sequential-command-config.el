(require 'sequential-command)

(define-sequential-command seq-home
  beginning-of-line beginning-of-buffer seq-return)
(define-sequential-command seq-end
  end-of-line end-of-buffer seq-return)

(defun seq-upcase-backward-word ()
  (interactive)
  (upcase-word (- (1+ (seq-count*)))))
(defun seq-capitalize-backward-word ()
  (interactive)
  (capitalize-word (- (1+ (seq-count*)))))
(defun seq-downcase-backward-word ()
  (interactive)
  (downcase-word (- (1+ (seq-count*)))))

(eval-after-load 'org
  '(progn
     (define-sequential-command org-seq-home
       org-beginning-of-line beginning-of-buffer seq-return)
     (define-sequential-command org-seq-end
       org-end-of-line end-of-buffer seq-return)
     (define-key org-mode-map "\C-a" 'org-seq-home)
     (define-key org-mode-map "\C-e" 'org-seq-end)))

(provide 'yet-another-sequential-command-config)
