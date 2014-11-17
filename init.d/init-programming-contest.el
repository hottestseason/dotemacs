(defun pc:compile-cpp ()
  (shell-command (message "clang++ -std=c++11 -stdlib=libc++ -o %s %s" (file-name-base) (f-filename (buffer-file-name)))))

(defun pc:compile ()
  (interactive)
  (cond ((equal major-mode 'c++-mode)
         (pc:compile-cpp))
        (t
         0)))

(defun pc:run-command ()
  (cond ((equal major-mode 'ruby-mode)
         (format "ruby %s" (buffer-file-name)))
        ((equal major-mode 'c++-mode)
         (format "./%s" (file-name-base)))
        ((equal major-mode 'd-mode)
         (format "rdmd %s" (buffer-file-name)))))

(defun pc:run ()
  (interactive)
  (when (equal (pc:compile) 0)
    (if (equal (length (f-glob "*\.in")) 0)
        (shell-command (pc:run-command))
      (let ((result (s-join "" (-map (lambda (input)
                                   (s-concat (f-filename input) "\n" (shell-command-to-string (message "cat %s | %s" input (pc:run-command)))))
                                     (f-glob "testcase*\.in"))))
            (result-buffer (get-buffer-create "*programming-contest-result*")))
        (with-current-buffer result-buffer (erase-buffer) (insert result))
        (popwin:popup-buffer result-buffer)))))

(global-set-key (kbd "C-c c") 'pc:compile)
(global-set-key (kbd "s-r") 'pc:run)

(provide 'init-programming-contest)
