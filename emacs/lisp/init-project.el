;;; init-project.el --- Interactive completion in buffers -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package projectile
  :config
  (setq projectile-mode-line "Projectile")
  (setq projectile-track-known-projects-automatically nil)
  :init
  (projectile-mode))

(provide 'init-project)
;;; init-project.el ends here

