(defmacro after-load (feature &rest body)
  "After FEATURE is loaded, evaluate BODY."
  (declare (indent defun))
  `(eval-after-load ,feature
     '(progn ,@body)))

(defun permute (lat)
  (cond
   ((null lat) '(()))
   (t (mapcan (lambda (atm)
                (mapcar (lambda (lst) (cons atm lst)) (permute (remove* atm lat :count 1))))
              lat))))

(defun build-regexp-from-patterns (patterns &optional default)
  (if (= (length patterns) 0) (or default "")
    (mapconcat (lambda (ordered-patterns)
                 (mapconcat (lambda (pattern)
                              (format "(%s)" pattern)) ordered-patterns ".*"))
               (permute patterns) "|")))

(provide 'personal-utils)
