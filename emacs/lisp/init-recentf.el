;;; init-recentf.el --- Settings for tracking recent files -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(require 'recentf)
(setq recentf-auto-cleanup 'never)
(recentf-mode 1)
(setq-default
 recentf-max-saved-items 1000)

(provide 'init-recentf)
;;; init-recentf.el ends here
