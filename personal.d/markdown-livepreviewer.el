;;; -*- coding: utf-8; lexical-binding: t -*-

(defun livepreview-markdown ()
  (interactive)
  (let ((markdown-file (buffer-file-name))
        (html-file (markdown-export)))
    (start-process "hello" "world" "browser-sync" "start" "--server" "--files" html-file "--index" (file-name-nondirectory html-file))
    (add-hook 'after-save-hook (lambda ()
                                 (if (eq markdown-file (buffer-file-name))
                                     (markdown-export))))))

(provide 'markdown-livepreviewer)
