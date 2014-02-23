(add-hook 'latex-mode-hook
          (lambda ()
            (add-hook 'after-save-hook
                      (lambda ()
                        (when (eq major-mode 'latex-mode)
                          (let ((main-texes (split-string (shell-command-to-string "grep -l 'begin{document}' $(find $(pwd) -name '*.tex')"))))
                            (mapcar (lambda (tex)
                                      (start-process "platex" "*platex*"
                                                     "latexToPdf.sh" (substring tex 0 -4)))
                                    main-texes)))))))

(provide 'init-tex)
