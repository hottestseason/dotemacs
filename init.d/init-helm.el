(after-load 'helm
  (require 'helm-config)
  (require 'helm-command)
  (require 'helm-misc)
  (setq
   helm-idle-delay 0
   helm-input-idle-delay 0
   helm-candidate-number-limit 1000
   helm-quick-update t
   helm-m-occur-idle-delay 0
   helm-ff-transformer-show-only-basename nil
   helm-mini-default-sources '(helm-source-buffers-list helm-source-recentf helm-source-find-files helm-c-source-buffer-not-found)
   helm-split-window-preferred-function (lambda (window)
                                          (cond ((require 'popwin nil t)
                                                 (nth 1 (popwin:create-popup-window 25)))
                                                (t
                                                 (split-window-sensibly)))))

  (require 'projectile nil t)
  (after-load 'projectile
    (projectile-global-mode)
    (setq projectile-require-project-root nil)

    (require 'helm-projectile)
    (helm-projectile-on)
    (global-set-key (kbd "M-t") 'helm-projectile)
    (global-set-key (kbd "M-S") 'helm-projectile-ag)))

(global-set-key (kbd "M-s") 'helm-occur)
(global-set-key (kbd "M-S") 'helm-projectile-ack)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "M-z") 'helm-resume)
(global-set-key (kbd "M-o") 'helm-mini)

(require 'helm)

(provide 'init-helm)
