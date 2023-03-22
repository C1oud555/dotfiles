;;; init-evil.el --- Interactive completion in buffers -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package evil
  :init 
  (setq evil-respect-visual-line-mode t)
  (setq evil-want-keybinding nil)
  :config
  (setq evil-undo-system 'undo-fu)
  (evil-mode))

(use-package evil-anzu
  :after
  (anzu-mode)
  :after evil)

(use-package evil-nerd-commenter
  :after evil)

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-goggles
  :after evil
  :custom
  (evil-goggles-duration 0.100)
  :config
  (evil-goggles-mode)
  (evil-goggles-use-diff-faces))

(provide 'init-evil)
;;; init-evil.el ends here
