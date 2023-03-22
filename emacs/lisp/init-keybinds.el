;;; init-keybinds.el --- Interactive completion in buffers -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package general
  :init (general-evil-setup))

(general-create-definer komo-leader-def
  :prefix "SPC")
(general-create-definer komo-lleader-def
  :prefix "SPC m")

(general-create-definer komo-buffers
  :prefix "SPC b")
(general-create-definer komo-code
  :prefix "SPC c")
(general-create-definer komo-eval
  :prefix "SPC e")
(general-create-definer komo-files
  :prefix "SPC f")
(general-create-definer komo-git
  :prefix "SPC g")
(general-create-definer komo-help
  :prefix "SPC h")
(general-create-definer komo-insert
  :prefix "SPC i")
(general-create-definer komo-note
  :prefix "SPC n")
(general-create-definer komo-open
  :prefix "SPC o")
(general-create-definer komo-project
  :prefix "SPC p")
(general-create-definer komo-quit
  :prefix "SPC q")
(general-create-definer komo-search
  :prefix "SPC s")

(komo-leader-def
  :states '(normal visual)
  :keymaps 'override
  "SPC" 'projectile-find-file
  ";" 'pp-eval-expression
  ":" 'execute-extended-command
  "a" 'embark-act
  "x" 'org-roam-dailies-capture-today
  "X" 'org-roam-capture
  "u" 'universal-argument
  "w" 'evil-window-map
  "." 'find-file
  "," 'consult-buffer
  "`" 'evil-switch-to-windows-last-buffer
  "'" 'vertico-repeat
  ">" 'find-file-other-window
  "/" 'consult-ripgrep)

(komo-buffers
  :states '(normal visual)
  :keymaps 'override
  "k" 'kill-current-buffer)

(komo-code
  :states '(normal visual)
  :keymaps 'override
  "a" 'eglot-code-actions
  "x" 'consult-flymake
  "f" 'eglot-format
  "r" 'eglot-rename
  "j" 'consult-eglot-symbols)

(komo-eval
  :states '(normal visual)
  :keymaps 'override
  "b" 'eval-buffer
  "r" 'eval-region)

(komo-files
  :states '(normal visual)
  :keymaps 'override
  "s" 'save-buffer
  "l" 'consult-locate
  "r" 'consult-recent-file
  "f" 'find-file)

(komo-git
  :states '(normal visual)
  :keymaps 'override
  "g" 'magit-status)

(komo-help
  :states '(normal visual)
  :keymaps 'override
  "f" 'helpful-function
  "v" 'helpful-variable
  "c" 'helpful-callable
  "m" 'describe-mode
  "p" 'helpful-at-point
  "k" 'helpful-key)

(komo-insert
  :states '(normal visual)
  :keymaps 'override
  "t" 'tempel-insert
  "y" 'consult-yank-from-kill-ring)

(komo-open
  :states '(normal visual)
  :keymaps 'override
  "f" 'make-frame
  "a" 'org-agenda
  "x" 'scratch-buffer
  "T" 'vterm-toggle-cd
  "t" 'vterm-toggle)

(komo-project
  :states '(normal visual)
  :keymaps 'override
  "a" 'projectile-add-known-project
  "d" 'projectile-remove-known-project
  "f" 'projectile-find-file
  "p" 'projectile-switch-project)

(komo-quit
  :states '(normal visual)
  :keymaps 'override
  "f" 'delete-frame
  "q" 'save-buffers-kill-terminal)

(komo-note
  :states '(normal visual)
  :keymaps 'override
  "b" 'consult-org-roam-backlinks
  "d" 'org-roam-dailies-find-date
  "t" 'org-todo-list
  "l" 'consult-org-roam-forward-links
  "s" 'consult-org-roam-search
  "f" 'org-roam-node-find)

(komo-search
  :states '(normal visual)
  :keymaps 'override
  "f" 'consult-find-under-here
  "d" 'consult-ripgrep-under-here
  "s" 'consult-line)

(general-nvmap
  :keymaps 'override
  "gc" 'evilnc-comment-operator
  "]F" 'ns-next-frame
  "[F" 'ns-prev-frame
  "[e" 'flymake-goto-prev-error
  "]e" 'flymake-goto-next-error)

(general-nvmap
 :keymaps 'org-mode-map
 "RET" 'org-return)

;; add shortcuts to windows
(general-define-key
 :keymaps 'evil-window-map
 "m" 'maximize-window)


(provide 'init-keybinds)
;;; init-keybinds.el ends here
