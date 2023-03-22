;;; init-term.el --- Interactive completion in buffers -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package vterm
  :defer 1
  :config
  (setq vterm-tramp-shells
	'(("docker" "/bin/sh")
	  ("sshx" "/bin/zsh")
	  ("ssh" "/bin/zsh"))))
(use-package vterm-toggle
  :after vterm)

(setq tramp-default-remote-shell "/bin/zsh")
(setq vterm-toggle-fullscreen-p nil)

(provide 'init-term)
;;; init-term.el ends here
