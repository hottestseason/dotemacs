(defvar-local auto-compile nil)
(add-to-list 'safe-local-variable-values '(auto-compile . t))

(defun kill-long-running-process (process time)
  (run-at-time time nil (lambda (process)
                          (when (process-live-p process)
                            (kill-process process)
                            (message "killed long running process: %s" process))) process))

(add-hook 'latex-mode-hook
          (lambda ()
            (add-hook 'after-save-hook
                      (lambda ()
                        (when (and (eq major-mode 'latex-mode) auto-compile)
                          (kill-long-running-process
                            (start-process-shell-command "auto-compile" "*auto-compile*" compile-command)
                            "10 sec"))))))

;; (defun compile-tex ()
;;   (interactive)
;;   (let ((main-texes (split-string (shell-command-to-string "grep -l 'begin{document}' $(find $(pwd) -name '*.tex')"))))
;;     (mapcar (lambda (tex)
;;               (start-process "platex" "*platex*"
;;                              "latexToPdf.sh" (substring tex 0 -4)))
;;             main-texes)))

(provide 'init-tex)
