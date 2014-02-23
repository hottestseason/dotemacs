(defun pc-compile ()
  (interactive)
  (shell-command (message "clang++ -std=c++11 -stdlib=libc++ -o %s %s" (file-name-base) (f-filename (buffer-file-name)))))

(defun pc-run ()
  (interactive)
  (when (equal (pc-compile) 0)
    (cond ((equal (length (f-glob "input*")) 0)
           (shell-command (message "./%s" (file-name-base))))
          (t
           (-map (lambda (input) (shell-command (message "cat %s | ./%s" input (file-name-base)))) (f-glob "input*"))))))

(global-set-key (kbd "C-c c") 'pc-compile)
(global-set-key (kbd "s-r") 'pc-run)

(provide 'init-programming-contest)
