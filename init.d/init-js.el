(setq js-indent-level 2)
(setq coffee-tab-width 2)

(defun beautify-json ()
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e "python -mjson.tool" (current-buffer) t)))

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(provide 'init-js)
