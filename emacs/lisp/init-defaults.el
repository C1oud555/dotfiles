;;; init-defaults.el --- Interactive completion in buffers -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq gc-cons-threshold (* 64 1024 1024))
(fset 'yes-or-no-p 'y-or-n-p)
(setq confirm-kill-emacs #'y-or-n-p)
(setq inhibit-startup-message t)
(setq make-backup-files nil)

(electric-pair-mode t)
(global-display-line-numbers-mode t)
(pixel-scroll-precision-mode)
(visual-line-mode)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq ring-bell-function 'ignore)


(use-package paren
  :ensure nil
  :hook (after-init . show-paren-mode)
  :config
  (setq show-paren-when-point-inside-paren t
        show-paren-when-point-in-periphery t))

(use-package saveplace
  :hook (after-init . save-place-mode))

(use-package hl-line
  :hook (after-init . global-hl-line-mode))

(use-package hideshow
  :diminish hs-minor-mode
  :hook (prog-mode . hs-minor-mode))

(use-package so-long
  :config (global-so-long-mode 1))

(use-package autorevert
  :ensure nil
  :hook (after-init . global-auto-revert-mode))

(use-package helpful)

(use-package undo-fu)

(use-package tramp
  :commands tramp-mode
  :defer 1)

; tramp
(with-eval-after-load 'tramp
  (setenv "SHELL" "/bin/bash")
  (customize-set-value 'tramp-encoding-shell "/bin/zsh")
  (add-to-list 'tramp-connection-properties
	       (list ".*" "locale" "LC_ALL=C"))
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

(dolist (mode '(org-mode-hook
		term-mode-hook
                vterm-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda() (display-line-numbers-mode 0))))

(use-package diredfl
  :after dired
  :hook (dired-mode . dired-omit-mode)
  :init (diredfl-global-mode))

(require 'dired-x)
(setq dired-omit-files "^\\.DS_Store")

(use-package eldoc-box
  ;; :init (eldoc-box-hover-at-point-mode)
  :after eldoc)
(add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-at-point-mode t)
;; (add-to-list 'eglot-ignored-server-capabilites :hoverProvider)

(provide 'init-defaults)
;;; init-defaults.el ends here
