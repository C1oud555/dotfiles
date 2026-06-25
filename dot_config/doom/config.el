;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Maple Mono NF CN" :size 15 :weight 'semi-light))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! corfu-auto
  (setq corfu-auto-delay 0.05))

(after! org
  (setq
   org-capture-templates
   '(("t" "Personal todo" entry (file +org-capture-todo-file)
      "* TODO %?\n%i\n%a" :prepend t)
     ("n" "Personal notes" entry
      (file +org-capture-notes-file)
      "* %u %?\n%i\n%a" :prepend t)
     ("w" "Work todo" entry (file "work.org")
      "* TODO %?\n%i\n%a" :prepend t))
   org-todo-keywords
   '((sequence "TODO(t)" "PROJ(p)" "LOOP(r)" "STRT(s)" "WAIT(w)" "HOLD(h)" "IDEA(i)"
      "|" "DONE(d)" "KILL(k)"))
   org-agenda-files '("todo.org")
   org-log-done 'time
   org-agenda-start-with-log-mode '(closed clock)
   org-tags-exclude-from-inheritance '("crypt"))

  (defun my/org-agenda-personal-todos ()
    "Show TODOs from todo.org only."
    (interactive)
    (let ((org-agenda-files
           (list (expand-file-name "todo.org" org-directory))))
      (org-todo-list)))

  (defun my/org-agenda-work-todos ()
    "Show TODOs from work.org only."
    (interactive)
    (let ((org-agenda-files
           (list (expand-file-name "work.org" org-directory))))
      (org-todo-list)))

  (org-crypt-use-before-save-magic))

(map! :leader
      (:prefix ("n" . "notes")
       :desc "Personal TODOs" "t" #'my/org-agenda-personal-todos
       :desc "Work TODOs"     "w" #'my/org-agenda-work-todos))

(setq-hook! 'python-ts-mode-hook +format-with 'ruff)

;; hack for rime crash
(defun rime-lib-finalize() nil)
(add-hook 'kill-emacs-hook #'rime-lib-finalize)

(after! evil-snipe
  (setq
   evil-snipe-scope 'whole-visible
   evil-snipe-repeat-scope 'whole-visible
   evil-snipe-smart-case t))


(use-package! breadcrumb
  :hook (eglot-managed-mode . breadcrumb-local-mode))

(use-package! rime
  :custom
  (mode-line-mule-info '((:eval (rime-lighter))))
  (rime-disable-predicates
   '(rime-predicate-evil-mode-p
     rime-predicate-current-uppercase-letter-p
     rime-predicate-space-after-cc-p
     rime-predicate-after-alphabet-char-p
     rime-predicate-prog-in-code-p))
  (default-input-method "rime")
  (rime-show-candidate 'posframe))

(after! orderless
  (use-package! pinyinlib)

  (defun +my-orderless-pinyin-dispatcher (pattern _index _total)
    (when (let ((case-fold-search nil))
            (string-match-p "\\`[A-Z]\\{2,\\}\\'" pattern))
      `(orderless-regexp
        . ,(pinyinlib-build-regexp-string
            (downcase pattern)
            t))))

  (add-to-list 'orderless-style-dispatchers
               #'+my-orderless-pinyin-dispatcher))
