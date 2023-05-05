;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file is a huge long config file of lhy's emacs
;; empower by `use-package' of emacs 29 built-in

;;; Code:

;; Threshold optmize for startup
;; TODO Maybe add `gcmh' later ?
(let ((normal-gc-cons-threshold (* 20 1024 1024))
      (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'emacs-startup-hook
            (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))

;; init `use-packge'
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-enable-at-startup nil)
(package-initialize)
(unless (package-installed-p 'use-package) ; ensure `use-packge' is installed
  (package-refresh-contents)
  (package-install 'use-package))

;; `benchmark' for opt
(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

;; ensure all package listed here get installed.
(eval-and-compile
  (setq use-package-always-ensure t))

;; better defaults
(use-package emacs
  :init
  (setq user-full-name "hyluo"
        user-mail-address "hyluo.1999@qq.com"
        ring-bell-function 'ignore
        inhibit-startup-screen t
        make-backup-files nil
        auto-save-default nil
        frame-resize-pixelwise t
        create-lockfiles nil
        confirm-kill-emacs  'y-or-n-p)
  (setq-default indent-tabs-mode nil)
  (set-charset-priority 'unicode)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  ;; diff sets
  (setq ediff-window-setup-function 'ediff-setup-windows-plain
        ediff-split-window-function 'split-window-horizontally
        ediff-merge-split-window-function 'split-window-horizontally)
  (visual-line-mode)
  (global-hl-line-mode)
  (global-display-line-numbers-mode t)
  ;; (pixel-scroll-precision-mode)
  (setq-default vc-handled-backends '(Git))
  (defalias 'yes-or-no-p 'y-or-n-p)
  (set-face-attribute 'default nil :family "SF Mono" :height 160)
  (if (display-graphic-p)
      (dolist (charset '(kana han symbol cjk-misc bopomofo))
        (set-fontset-font (frame-parameter nil 'font) charset
                          (font-spec :family "Hiragino Sans GB")))))

;; auto save
(use-package saveplace
  :defer t
  :hook (after-init . save-place-mode))

;; fold related
(use-package hideshow
  :defer t
  :diminish hs-minor-mode
  :hook (prog-mode . hs-minor-mode))

;; window redo
(use-package winner
  :defer t
  :ensure nil
  :hook (after-init . winner-mode)
  )

;; sync emacs buffer with outside change
(use-package autorevert
  :defer t
  :ensure nil
  :hook (after-init . global-auto-revert-mode))

;; highlight parens
(use-package paren
  :defer t
  :ensure nil
  :hook (after-init . show-paren-mode)
  :config
  (setq show-paren-when-point-inside-paren t
        show-paren-when-point-in-periphery t))

;; show match paren
(use-package electric
  :defer t
  :ensure nil
  :hook (prog-mode . electric-pair-mode))

;; opt long line
(use-package so-long
  :defer t
  :config (global-so-long-mode 1))

;; clean whitespace
(use-package whitespace
  :defer t
  :ensure nil
  :hook (before-save . whitespace-cleanup))

;; move custom variable to dump file and not load that
(use-package cus-edit
  :defer t
  :ensure nil
  :config
  (setq custom-file (concat user-emacs-directory "to-be-dumped.el")))

;; save history
(use-package savehist
  :defer t
  :init (savehist-mode)
  :config
  (add-hook 'minibuffer-setup-hook #'vertico-repeat-save)
  (add-to-list 'savehist-additional-variables #'vertico-repeat-history))


;; recent file mode
(use-package recentf
  :defer t
  :config
  (setq recentf-auto-cleanup 'never)
  (setq recentf-max-saved-items 1000)
  :init
  (recentf-mode 1))

(use-package general
  :config (general-evil-setup))


;; I can't live without evil
(use-package evil
  :defer 0.3
  :init
  (setq evil-respect-visual-line-mode t)
  (setq evil-want-keybinding nil)
  (setq evil-undo-system 'undo-redo)
  :config
  (evil-mode)
  ;; add shortcuts to windows
  (general-define-key
   :keymaps 'evil-window-map
   "m" 'maximize-window))

;; lots of use set up with evil
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; show match when search
;; but maybe `consult' and `embark-export' will do better
(use-package anzu
  :after evil-anzu
  :config
  (global-anzu-mode +1))
(use-package evil-anzu
  :after evil)

;; gc to commment
(use-package evil-nerd-commenter
  :after evil
  :general
  ( :states '(normal, visual) "gc" #'evilnc-comment-operator))

;; change surrounds
(use-package evil-surround
  :after evil
  :general
  (:states 'visual "s" #'evil-surround-region)
  :config
  (global-evil-surround-mode 1))

;; show changes
(use-package evil-goggles
  :after evil
  :custom
  (evil-goggles-duration 0.100)
  :config
  (evil-goggles-mode)
  (evil-goggles-use-diff-faces))

;; increase number
(use-package evil-numbers
  :after evil
  :general
  ;; maybe sometimes you need `evil-numbers/inc-at-pt'
  (:states '(normal, visual) "g=" #'evil-numbers/inc-at-pt-incremental) )

;; --------------- key binding begin ---------------
(general-create-definer hy-leader-def
  :states '(normal visual)
  :keymaps 'override
  :prefix "SPC")
(general-create-definer hy-local-leader-def
  :states '(normal visual)
  :keymaps 'override
  :prefix "SPC m")

(hy-leader-def
  "SPC" '(project-find-file :which-key "find project file")
  ";" '(pp-eval-expression :which-key "eval")
  ":" '(execute-extended-command :which-key "execute")
  "a" '(embark-act :which-key "action")
  "x" 'org-roam-dailies-capture-today
  "X" 'org-roam-capture
  "u" 'universal-argument
  "w" 'evil-window-map
  "." 'find-file
  "," 'consult-buffer
  "`" 'evil-switch-to-windows-last-buffer
  "'" 'vertico-repeat
  ;; ">" 'find-file-other-window
  "/" 'consult-ripgrep

  "b" '(:ignore t :which-key "buffer")
  "bk" 'kill-current-buffer

  "c" '(:ignore t :which-key "code")
  "ca" 'lsp-execute-code-action
  "cx" 'consult-lsp-diagnostics
  "cf" 'lsp-format-buffer
  "cl" 'lsp-avy-lens
  "cr" 'lsp-rename
  "cs" 'consult-lsp-file-symbols
  "cS" 'consult-lsp-symbols

  "e" '(:ignore t :which-key "eval")
  "eb" 'eval-buffer
  "er" 'eval-region

  "f" '(:ignore t :which-key "file")
  "fs" 'save-buffer
  "fl" 'consult-locate
  "fr" 'consult-recent-file
  "ff" 'find-file
  "fd" 'dired

  "g" '(:ignore t :which-key "git")
  "gg" 'magit-status

  "h" '(:ignore t :which-key "help")
  "hf" 'describe-function
  "hF" 'helpful-function
  "hv" 'describe-variable
  "hc" 'describe-command
  "hm" 'describe-mode
  "hh" 'helpful-at-point
  "hk" 'describe-key

  "i" '(:ignore t :which-key "insert")
  "it" 'tempel-insert
  "iy" 'consult-yank-from-kill-ring

  "o" '(:ignore t :which-key "open")
  "of" 'make-frame
  "oa" 'org-agenda
  "ox" 'lhy/scratch-buf
  "oT" 'vterm-toggle-cd
  "ot" 'vterm-toggle

  "p" '(:ignore t :which-key "project")
  "pc" 'project-compile
  "pd" 'project-dired
  "pb" 'consult-project-buffer
  "pf" 'project-find-file
  "pp" 'project-switch-project

  "q" '(:ignore t :which-key "quit")
  "qf" 'delete-frame
  "qq" 'save-buffers-kill-terminal

  "n" '(:ignore t :which-key "note")
  "nb" 'consult-org-roam-backlinks
  "nd" 'org-roam-dailies-find-date
  "nt" 'org-todo-list
  "ni" 'org-roam-node-insert
  "nl" 'consult-org-roam-forward-links
  "n/" 'consult-org-roam-search
  "nr" 'org-roam-buffer-toggle
  "nf" 'org-roam-node-find

  "s" '(:ignore t :which-key "search")
  "sf" 'consult-find-under-here
  "sF" 'consult-find-other
  "si" 'consult-imenu
  "sd" 'consult-ripgrep-under-here
  "sD" 'consult-ripgrep-other
  "st" 'osx-dictionary-search-word-at-point
  "so" 'consult-outline
  "ss" 'consult-line)

;; some habits binding
(general-nvmap
  :keymaps 'override
  "]F" 'ns-next-frame
  "[F" 'ns-prev-frame
  "[e" 'flymake-goto-prev-error
  "]e" 'flymake-goto-next-error)

;; --------------- key binding end ---------------

;; read pdfs in emacs
(use-package pdf-tools
  :defer t)

;; use `git' in emacs
(use-package magit
  :defer t)

;; default set for `vertico'
(use-package emacs
  :init
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
  (setq enable-recursive-minibuffers t)
  (setq completion-cycle-threshold 4)
  (setq tab-always-indent 'complete))

;; minibuffer enhance
(use-package vertico
  :defer t
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char))
  :hook
  (rfn-eshadow-update-overlay . vertico-directory-tidy)
  :config
  (setq vertico-cycle t)
  :init (vertico-mode))

;; -------- yasnippets -------

;; completion in buffer
;; I prefer tab an go more
(use-package corfu
  :defer t
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-quit-no-match 'separator)
  (corfu-popupinfo-delay '(0.5 . 0.3))
  (corfu-auto-delay 0.1)
  (corfu-preselect 'prompt)
  :bind (:map corfu-map
              ("TAB" . corfu-next)
              ([tab] . corfu-next)
              ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous)
              ("C-SPC" . corfu-insert-separator))
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  (corfu-history-mode))

;; more complete backends
(use-package cape
  :after corfu
  :config
  ;; (add-to-list 'completion-at-point-functions #'cape-tex)
  ;; (add-to-list 'completion-at-point-functions #'cape-sgml)
  ;; (add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;; (add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;; (add-to-list 'completion-at-point-functions #'cape-ispell)
  ;; (add-to-list 'completion-at-point-functions #'cape-line)
  (add-to-list 'completion-at-point-functions #'cape-history)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-symbol)
  (add-to-list 'completion-at-point-functions #'cape-dict)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'tempel-complete))

;; orderless match
(use-package orderless
  :after vertico
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-completion)))))

;; consult everything you want
(use-package consult
  :after vertico
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (setq consult-locate-args "mdfind -name")
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-bookmark consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   :preview-key '(:debounce 0.4 any)
   consult-recent-file consult-ripgrep consult-git-grep
   consult-grep :preview-key "C-SPC")
  (setq consult-narrow-key "<")

  (defun consult-find-under-here (&optional initial)
    ;; find file current directory
    (interactive "P")
    (consult-find default-directory initial))

  (defun consult-ripgrep-under-here (&optional initial)
    ;; grep file current directory
    (interactive "P")
    (consult-ripgrep default-directory initial))

  (defun consult-find-other (&optional initial)
    ;; find file other directory
    (interactive "P")
    (let ((default-directory (read-directory-name "Search find file directory")))
      (consult-find default-directory initial)))

  (defun consult-ripgrep-other (&optional initial)
    ;; grep file other directory
    (interactive "P")
    (let ((default-directory (read-directory-name "Search find file directory")))
      (consult-ripgrep default-directory initial)))
  )

;; find and act
(use-package embark
  :defer t
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (defun embark-which-key-indicator ()
    (lambda (&optional keymap targets prefix)
      (if (null keymap)
          (which-key--hide-popup-ignore-command)
        (which-key--show-keymap
         (if (eq (plist-get (car targets) :type) 'embark-become)
             "Become"
           (format "Act on %s '%s'%s"
                   (plist-get (car targets) :type)
                   (embark--truncate-target (plist-get (car targets) :target))
                   (if (cdr targets) "..." "")))
         (if prefix
             (pcase (lookup-key keymap prefix 'accept-default)
               ((and (pred keymapp) km) km)
               (_ (key-binding prefix 'accept-default)))
           keymap)
         nil nil t (lambda (binding)
                     (not (string-suffix-p "-argument" (cdr binding))))))))
  (setq embark-indicators
        '(embark-which-key-indicator
          embark-highlight-indicator
          embark-isearch-highlight-indicator))
  (defun embark-hide-which-key-indicator (fn &rest args)
    (which-key--hide-popup-ignore-command)
    (let ((embark-indicators
           (remq #'embark-which-key-indicator embark-indicators)))
      (apply fn args)))

  (advice-add #'embark-completing-read-prompter
              :around #'embark-hide-which-key-indicator)
  :bind
  ("C-;" . embark-act)
  ("C-." . embark-dwim))

;; embark and consult !!!
(use-package embark-consult
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; show more information in minibuffer
(use-package marginalia
  :after vertico
  :init (marginalia-mode))

;; snippet engine
(use-package tempel
  :after corfu
  :bind (:map tempel-map
              ("TAB" . tempel-next)
              ([tab] . tempel-next)
              ("S-TAB" . tempel-previous)
              ([backtab] . tempel-previous)))

;; more snippets
(use-package tempel-collection
  :after tempel)

;; help you format keybind
(use-package which-key
  :after evil
  :init (which-key-mode))

;; better describe
(use-package helpful
  :after evil
  :init
  (setq evil-lookup-func #'helpful-at-point)
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))

;; real terminal
(use-package vterm
  :defer t
  :config
  (setq vterm-toggle-fullscreen-p nil)
  (add-hook 'vterm-mode-hook (lambda () (display-line-numbers-mode -1)))
  (setq vterm-tramp-shells
        '(("docker" "/bin/sh")
          ("sshx" "/bin/zsh")
          ("ssh" "/bin/zsh"))))

;; better manage `vterm'
(use-package vterm-toggle
  :custom
  (vterm-toggle-scope 'project)
  :after vterm)

(use-package hide-mode-line
  :hook ((osx-dictionary-mode org-roam-mode helpful-mode vterm-mode) . hide-mode-line-mode)
  :defer t)

;; focus!
(use-package olivetti
  :defer t
  :init
  (setq olivetti-body-width 80)
  (setq olivetti-style 'fancy)
  (setq olivetti-minimum-body-width 50))

;; notice where you are in `python'
(use-package highlight-indent-guides
  :defer t
  :config
  (highlight-indent-guides-auto-set-faces)
  :init
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-responsive 'top)
  :hook (prog-mode . highlight-indent-guides-mode))


;; OKAY highlight thing before
(use-package hl-todo
  :defer t
  :init
  (global-hl-todo-mode))

;; show #ff3256 in color
(use-package rainbow-mode
  :defer t
  :hook (prog-mode . rainbow-mode))

;; show embbeded parens in color
(use-package rainbow-delimiters
  :defer t
  :hook (prog-mode . rainbow-delimiters-mode))

;; leave space between Chinese and English
(use-package pangu-spacing
  :defer t
  :config
  (setq pangu-spacing-real-insert-separtor t)
  :init
  (global-pangu-spacing-mode))

(use-package pyim-basedict
  :after pyim
  :config
  (pyim-basedict-enable))

(use-package pyim
  :after orderless
  :init
  (setq default-input-method "pyim")
  :bind
  ("M-q" . pyim-convert-string-at-point)
  :config
  (advice-add #'orderless-regexp
              :filter-return
              #'pyim-cregexp-build)
  (setq-default pyim-english-input-switch-functions
                '(pyim-probe-dynamic-english
                  pyim-probe-isearch-mode
                  pyim-probe-program-mode
                  pyim-probe-org-structure-template))
  )

;; get shell VARIABLE in emacs
(use-package exec-path-from-shell
  :after evil
  :if (memq window-system '(mac ns))
  :config
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "JAVA_HOME"))

;; manage a real project
(use-package project
  :defer t
  :ensure nil)

;; LSP!!!!
(use-package lsp-mode
  :commands lsp
  :custom
  (lsp-completion-provider :none)
  (read-process-output-max (* 4 1024 1024))
  :init
  (defun  my/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless)))
  :hook
  ((rust-mode verilog-mode c++-mode) . lsp)
  (lsp-completion-mode . my/lsp-mode-setup-completion)
  :config
  (general-nvmap lsp-mode-map
    :keymaps 'override
    "K" 'lsp-describe-thing-at-point
    "gd" 'lsp-find-definition
    "gr" 'lsp-find-references
    "gi" 'lsp-find-implementation)
  (add-to-list 'lsp-language-id-configuration '(verilog-mode . "verilog"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("verible-verilog-ls" "--rules_config_search"))
                    :major-modes '(verilog-mode)
                    :server-id 'verible-ls)))

(use-package consult-lsp
  :defer t)

;; (use-package lsp-ui
;;   :after lsp-mode
;;   :commands lsp-ui-mode)

;; `verilog-mode'
(use-package verilog-mode
  :defer t
  :config
  (hy-local-leader-def
    :keymaps 'verilog-mode-map
    "i" verilog-template-map)
  ;; little hack to let the verilog indent end at the line end
  ;; so `tempel' snippet will hebave more fluent
  (advice-add 'verilog-indent-line-relative :after (lambda (&rest r) (end-of-line)))
  (setq verilog-indent-level 2
        verilog-indent-level-module 2
        verilog-indent-level-declaration 2
        verilog-indent-level-behavioral 2
        verilog-indent-level-directive 2
        verilog-case-indent 2
        verilog-cexp-indent 2
        verilog-indent-lists t
        verilog-auto-newline nil))

;; `rust'
(use-package rust-mode
  :defer t)

;; `scala'
(use-package scala-mode
  :defer t)

;; `python'
(use-package poetry
  :after python
  :init
  (poetry-tracking-mode) ; follow virtual env
  )

;; local leader bind in python
(hy-local-leader-def
  :states '(normal visual)
  :keymaps 'python-base-mode-map
  "r" 'run-python)

;; Best `org' mode
(use-package org
  :defer t
  :ensure nil
  :general
  (general-nvmap org-mode-map
    "zi" 'org-toggle-inline-images)
  :config
  ;; agenda
  (defun vulpea-project-p ()
    "Return non-nil if current buffer has any todo entry.
TODO entries marked as done are ignored, meaning the this
function returns nil if current buffer contains only completed
tasks."
    (seq-find                                 ; (3)
     (lambda (type)
       (eq type 'todo))
     (org-element-map                         ; (2)
      (org-element-parse-buffer 'headline) ; (1)
      'headline
      (lambda (h)
        (org-element-property :todo-type h)))))
  (defun vulpea-project-update-tag ()
    "Update PROJECT tag in the current buffer."
    (when (and (not (active-minibuffer-window))
               (vulpea-buffer-p))
      (save-excursion
        (goto-char (point-min))
        (let* ((tags (vulpea-buffer-tags-get))
               (original-tags tags))
          (if (vulpea-project-p)
              (setq tags (cons "project" tags))
            (setq tags (remove "project" tags)))

          ;; cleanup duplicates
          (setq tags (seq-uniq tags))

          ;; update tags if changed
          (when (or (seq-difference tags original-tags)
                    (seq-difference original-tags tags))
            (apply #'vulpea-buffer-tags-set tags))))))
  (defun vulpea-buffer-p ()
    "Return non-nil if the currently visited buffer is a note."
    (and buffer-file-name
         (string-prefix-p
          (expand-file-name (file-name-as-directory org-roam-directory))
          (file-name-directory buffer-file-name))))

  (defun vulpea-project-files ()
    "Return a list of note files containing 'project' tag." ;
    (seq-uniq
     (seq-map
      #'car
      (org-roam-db-query
       [:select [nodes:file]
                :from tags
                :left-join nodes
                :on (= tags:node-id nodes:id)
                :where (like tag (quote "%\"project\"%"))]))))
  (defun vulpea-agenda-files-update (&rest _)
    "Update the value of `org-agenda-files'."
    (setq org-agenda-files (vulpea-project-files)))

  (add-hook 'find-file-hook #'vulpea-project-update-tag)
  (add-hook 'before-save-hook #'vulpea-project-update-tag)

  (advice-add 'org-agenda :before #'vulpea-agenda-files-update)
  (advice-add 'org-todo-list :before #'vulpea-agenda-files-update)

  (defun vulpea-buffer-tags-get ()
    "Return filetags value in current buffer."
    (vulpea-buffer-prop-get-list "filetags" "[ :]"))

  (defun vulpea-buffer-tags-set (&rest tags)
    "Set TAGS in current buffer.
If filetags value is already set, replace it."
    (if tags
        (vulpea-buffer-prop-set
         "filetags" (concat ":" (string-join tags ":") ":"))
      (vulpea-buffer-prop-remove "filetags")))

  (defun vulpea-buffer-tags-add (tag)
    "Add a TAG to filetags in current buffer."
    (let* ((tags (vulpea-buffer-tags-get))
           (tags (append tags (list tag))))
      (apply #'vulpea-buffer-tags-set tags)))

  (defun vulpea-buffer-tags-remove (tag)
    "Remove a TAG from filetags in current buffer."
    (let* ((tags (vulpea-buffer-tags-get))
           (tags (delete tag tags)))
      (apply #'vulpea-buffer-tags-set tags)))
  (defun vulpea-buffer-prop-set (name value)
    "Set a file property called NAME to VALUE in buffer file.
If the property is already set, replace its value."
    (setq name (downcase name))
    (org-with-point-at 1
                       (let ((case-fold-search t))
                         (if (re-search-forward (concat "^#\\+" name ":\\(.*\\)")
                                                (point-max) t)
                             (replace-match (concat "#+" name ": " value) 'fixedcase)
                           (while (and (not (eobp))
                                       (looking-at "^[#:]"))
                             (if (save-excursion (end-of-line) (eobp))
                                 (progn
                                   (end-of-line)
                                   (insert "\n"))
                               (forward-line)
                               (beginning-of-line)))
                           (insert "#+" name ": " value "\n")))))
  (defun vulpea-buffer-prop-set-list (name values &optional separators)
    "Set a file property called NAME to VALUES in current buffer.
VALUES are quoted and combined into single string using
`combine-and-quote-strings'.
If SEPARATORS is non-nil, it should be a regular expression
matching text that separates, but is not part of, the substrings.
If nil it defaults to `split-string-default-separators', normally
\"[ \f\t\n\r\v]+\", and OMIT-NULLS is forced to t.
If the property is already set, replace its value."
    (vulpea-buffer-prop-set
     name (combine-and-quote-strings values separators)))

  (defun vulpea-buffer-prop-get (name)
    "Get a buffer property called NAME as a string."
    (org-with-point-at 1
                       (when (re-search-forward (concat "^#\\+" name ": \\(.*\\)")
                                                (point-max) t)
                         (buffer-substring-no-properties
                          (match-beginning 1)
                          (match-end 1)))))

  (defun vulpea-buffer-prop-get-list (name &optional separators)
    "Get a buffer property NAME as a list using SEPARATORS.
If SEPARATORS is non-nil, it should be a regular expression
matching text that separates, but is not part of, the substrings.
If nil it defaults to `split-string-default-separators', normally
\"[ \f\t\n\r\v]+\", and OMIT-NULLS is forced to t."
    (let ((value (vulpea-buffer-prop-get name)))
      (when (and value (not (string-empty-p value)))
        (split-string-and-unquote value separators))))

  (defun vulpea-buffer-prop-remove (name)
    "Remove a buffer property called NAME."
    (org-with-point-at 1
                       (when (re-search-forward (concat "\\(^#\\+" name ":.*\n?\\)")
                                                (point-max) t)
                         (replace-match ""))))

  (with-no-warnings
    (custom-declare-face '+org-todo-active  '((t (:inherit (bold font-lock-constant-face org-todo)))) "")
    (custom-declare-face '+org-todo-onhold  '((t (:inherit (bold warning org-todo)))) "")
    (custom-declare-face '+org-todo-cancel  '((t (:inherit (bold error org-todo)))) ""))
  ;; org defaults
  (setq org-directory (file-truename "~/Documents/org")
        org-return-follows-link t
        org-log-done 'time
        org-fontify-done-headline t
        org-startup-with-inline-images t
        org-link-keep-stored-after-insertion t
        org-startup-indented t
        org-cycle-include-plain-lists 'integrate
        org-fontify-quote-and-verse-blocks t
        org-fontify-whole-heading-line t
        org-image-actual-width nil
        org-hide-leading-stars t
        org-eldoc-breadcrumb-separator " → "
        org-indirect-buffer-display 'current-window
        org-todo-keywords
        '((sequence
           "TODO(t)"
           "STAR(s)"
           "HOLD(h)"
           "LOOP(r)"
           "WAIT(w)"
           "IDEA(i)"
           "|"
           "DONE(d)"
           "KILL(k)"))
        org-todo-keyword-faces
        '(("STAR" . font-lock-constant-face)
          ("WAIT" . warning)
          ("HOLD" . warning)
          ("KILL" . error))
        org-priority-faces
        '((?A . error)
          (?B . warning)
          (?C . success)))
  (setq org-agenda-deadline-faces
        '((1.001 . error)
          (1.0 . org-warning)
          (0.5 . org-upcoming-deadline)
          (0.0 . org-upcoming-distant-deadline)))

  (define-key org-src-mode-map (kbd "C-c C-c") #'org-edit-src-exit)

  ;; babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (tcl . t)
     (plantuml . t)))
  (setq org-confirm-babel-evaluate nil
        org-babel-python-command "python3"))

(use-package org-download
  :after org
  :config
  (setq-default org-download-method 'directory
                org-download-image-dir  (concat (file-name-as-directory org-directory) "images")
                org-download-image-org-width 800
                org-download-image-html-width 800
                org-download-image-latex-width 800))

(use-package org-contrib
  :defer t)

;; knowledge network
(use-package org-roam
  :after org
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory org-directory)
  (org-roam-completion-everywhere t)
  :config
  (org-roam-db-autosync-mode))

;; align chinese and english
(use-package valign
  :after org
  :hook (org-mode . valign-mode))

;; `org' and `evil'
(use-package evil-org
  :after org
  :hook (org-mode . evil-org-mode)
  :general
  (general-mmap org-mode-map
    "RET" 'evil-org-return)
  :config
  (evil-org-set-key-theme '(navigation insert textobjects additional calendar))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; consult and roam
(use-package consult-org-roam
  :after org-roam
  :custom
  (consult-org-roam-grep-func #'consult-ripgrep)
  (consult-org-roam-buffer-narrow-key ?r)
  (consult-org-roam-buffer-after-buffers t)
  :config
  ;; org roam buffer
  (consult-org-roam-mode 1)
  (org-roam-db-autosync-mode)
  (consult-customize
   consult-org-roam-forward-links
   :preview-key (kbd "C-SPC")))

;; enable plantuml code and default behavior to a tmp file
;; if a `:file' is given. Then generate the file
;; else will generate a file in tmp dir
(use-package ob-plantuml
  :ensure nil
  :after plantuml-mode
  :init
  (setq org-plantuml-jar-path plantuml-jar-path)

  (defun +plantuml-org-babel-execute:plantuml-a (body params)
    "Execute a block of plantuml code with org-babel.
This function is called by `org-babel-execute-src-block'."
    (require 'plantuml-mode)
    ;; REVIEW Refactor me
    (let* ((body (replace-regexp-in-string
                  "^[[:blank:]\n]*\\(@start\\)"
                  "\\\\\\1"
                  body))
           (fullbody (org-babel-plantuml-make-body body params))
           (out-file (or (cdr (assq :file params))
                         (org-babel-temp-file "plantuml-" ".png")))
           (in-file (org-babel-temp-file "plantuml-")))
      (if (eq plantuml-default-exec-mode 'server)
          (if (bound-and-true-p org-export-current-backend)
              (user-error "Exporting plantuml diagrams in server mode is not supported (see `plantuml-default-exec-mode')")
            (save-current-buffer
              (save-match-data
                (with-current-buffer
                    (url-retrieve-synchronously (plantuml-server-encode-url body)
                                                nil t)
                  (goto-char (point-min))
                  ;; skip the HTTP headers
                  (while (not (looking-at "\n")) (forward-line))
                  (delete-region (point-min) (+ 1 (point)))
                  (write-file out-file)))))
        (let* ((cmd (concat (cond ((eq plantuml-default-exec-mode 'executable)
                                   (unless (executable-find plantuml-executable-path)
                                     (error "Could not find plantuml at %s"
                                            (executable-find plantuml-executable-path)))
                                   (concat (shell-quote-argument (executable-find plantuml-executable-path))
                                           " --headless"))
                                  ((not (file-exists-p plantuml-jar-path))
                                   (error "Could not find plantuml.jar at %s" org-plantuml-jar-path))
                                  ((concat "java " (cdr (assoc :java params)) " -jar "
                                           (shell-quote-argument
                                            (expand-file-name plantuml-jar-path)))))
                            " "
                            (pcase (file-name-extension out-file)
                              ("png" "-tpng")
                              ("svg" "-tsvg")
                              ("eps" "-teps")
                              ("pdf" "-tpdf")
                              ("tex" "-tlatex")
                              ("vdx" "-tvdx")
                              ("xmi" "-txmi")
                              ("scxml" "-tscxml")
                              ("html" "-thtml")
                              ("txt" "-ttxt")
                              ("utxt" "-utxt"))
                            " "
                            " -p " (cdr (assoc :cmdline params)) " < "
                            (org-babel-process-file-name in-file)
                            " > "
                            (org-babel-process-file-name out-file))))
          (with-temp-file in-file (insert fullbody))
          (message "%s" cmd)
          (org-babel-eval cmd "")))
      (unless (cdr (assq :file params))
        out-file)))

  (advice-add #'org-babel-execute:plantuml
              :override #'+plantuml-org-babel-execute:plantuml-a)
  (add-to-list 'org-babel-default-header-args:plantuml
               '(:cmdline . "-charset utf-8")))

(use-package org-superstar
  :after org
  :hook
  (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-loading-bullet ?\s
        ortg-superstar-leading-fallback ?\s))

;; `org-mode' local leader bind
(hy-local-leader-def
  :states '(normal visual)
  :keymaps 'org-mode-map
  ;; "x" 'org-toggle-checkbox ; use C-c C-c instead
  "l" 'org-insert-link
  "p" 'org-set-property
  "s" 'org-store-link
  "h" 'consult-org-heading
  "n" 'org-toggle-narrow-to-subtree
  "t" 'org-todo)

;; --------------- dired begin --------------------
;; `dired' help me manage file
(use-package dired
  :defer t
  :ensure nil
  :init
  (setq-default dired-dwim-target t
                dired-omit-files "^\\.DS_Store"))

;; enhance dired
(use-package diredfl
  :after dired
  :hook (dired-mode . dired-omit-mode)
  :init
  (diredfl-global-mode)
  (require 'dired-x)
  )
;; --------------- dired  end  --------------------

;; OSC specifically
(use-package emacs
  :config
  (setq mac-pass-command-to-system nil
        mac-pass-control-to-system nil
        mac-command-modifier 'meta
        mac-option-modifier 'super))

;; Tramp to my server
(use-package tramp
  :defer t
  :init
  :config
  (setenv "SHELL" "/bin/bash")
  (setq tramp-default-remote-shell "/bin/zsh")
  (customize-set-value 'tramp-encoding-shell "/bin/zsh")
  (add-to-list 'tramp-connection-properties
               (list ".*" "locale" "LC_ALL=C"))
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

(use-package plantuml-mode
  :defer t
  :config
  (setq plantuml-default-exec-mode 'jar
        plantuml-jar-path "~/.config/emacs/.cache/plantuml.jar"))


(use-package persistent-scratch
  :config (persistent-scratch-autosave-mode))

(use-package osx-dictionary
  :defer t
  :if (memq window-system '(mac ns)))

;; ----------------- UI begin --------------------------
(use-package doom-themes
  :after doom-modeline
  :config
  (load-theme 'doom-one t))

;; show things you need
(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :init (column-number-mode))

;; add icon to `corfu'
(use-package kind-icon
  :after (corfu nerd-icons)
  :config
  (setq kind-icon-use-icons nil)
  (setq kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package nerd-icons
  :defer t)

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode)
  :after dired)

(use-package nerd-icons-completion
  :after nerd-icons
  :config (nerd-icons-completion-mode))
;; ----------------- UI begin --------------------------

(use-package browse-at-remote
  :defer t)

;; ----------------- windows management begin ---------------------
(use-package emacs
  :config
  ;; bottom
  (add-to-list 'display-buffer-alist
               '("\*scratch\*" display-buffer-at-bottom
                 (window-height . 0.3)))
  ;; bottom side window
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                   (let ((buffer (get-buffer buffer-or-name)))
                     (with-current-buffer buffer
                       (or (equal major-mode 'helpful-mode)
                           (string-prefix-p "\*vterm\*" (buffer-name buffer))
                           (string-prefix-p "\*lsp-help\*" (buffer-name buffer))
                           (string-prefix-p "\*osx-dictionary\*" (buffer-name buffer))))))
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . bottom)
                 (reusable-frames . visible)
                 (window-height . 0.33)))
  ;; right
  ;; right  side window
  (add-to-list 'display-buffer-alist
               '("\*org-roam\*"
                 (display-buffer-in-side-window)
                 (side . right)
                 (slot . 0)
                 (window-width . 0.33)
                 (window-parameter . ((no-other-window . t)
                                      (no-delete-other-windows . t))))))
;; ----------------- windows management  end  ---------------------

;; --------------- some defined function -------------------
(defun lhy/scratch-buf ()
  (interactive)
  (pop-to-buffer "\*scratch\*"))
;; --------------- some defined function -------------------

(provide 'init)

;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:
;;; init.el ends here
