;;; ~/.config/doom/config.el -*- lexical-binding: t; -*-
(setq! user-full-name "hyluo"
       user-mail-address "hyluo.1999@qq.com")

(setq! doom-font (font-spec :family "Monaco" :size 15 :weight 'normal :width 'normal)
       doom-variable-pitch-font (font-spec :family "Monaco" :size 15 :weight 'normal :width 'normal)
       doom-big-font (font-spec :family "Monaco" :szie 26))
(defun init-cjk-fonts()
  (if (display-graphic-p)
      (dolist (charset '(kana han cjk-misc bopomofo))
        (set-fontset-font (frame-parameter nil 'font)
                          charset (font-spec :family "Hiragino Sans GB" :size 18)))))
(add-hook 'doom-init-ui-hook #'init-cjk-fonts)

(setq! doom-theme 'doom-one)
;; (add-hook! LaTeX-mode (load-theme 'doom-gruvbox-light))
(setq fancy-splash-image (concat doom-private-dir "splash.png"))
;; Hide the menu for as minimalistic a startup screen as possible.
;; (remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)

(map! :leader :desc "Find file split" :n ">" #'find-file-other-window)

(setq! display-line-numbers-type t
       split-height-threshold nil
       split-width-threshold 10
       mac-pass-command-to-system nil)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(autoload 'ffap-file-at-point "ffap")
(defun complete-path-at-point+ ()
  "Return completion data for UNIX path at point."
  (let ((fn (ffap-file-at-point))
        (fap (thing-at-point 'filename)))
    (when (and (or fn (equal "/" fap))
               (save-excursion
                 (search-backward fap (line-beginning-position) t)))
      (list (match-beginning 0)
            (match-end 0)
            #'completion-file-name-table :exclusive 'no))))

(add-hook 'completion-at-point-functions
          #'complete-path-at-point+
          'append)



(setq! org-directory "~/Documents/org"
       org-preview-latex-default-process 'dvisvgm
       ;; org-highlight-latex-and-related '(native)
       org-latex-pdf-process '("latexmk -f -pdf -xelatex -interaction=nonstopmode -output-directory=%o %f")
       org-file-apps '((auto-mode . emacs)
                       (directory . emacs)
                       ("\\.mm\\'" . default)
                       ("\\.x?html?\\'" . default)
                       ("\\.pdf\\'" . emacs))
       org-emphasis-alist '(("*" (bold :foreground "Orange"))
                            ("/" italic)
                            ("_" underline)
                            ("=" org-verbatim verbatim)
                            ("~" org-code verbatim)
                            ("+" (:strike-through t))))

(require 'org-crypt)
(org-crypt-use-before-save-magic)
(setq! org-tags-exclude-from-inheritance (quote("crypt"))
      org-crypt-key nil)

(setq! org-capture-templates '(("t" "Personal todo" entry
                                (file+headline +org-capture-todo-file "Inbox")
                                "* [ ] %?\n%i\n%a" :prepend t)
                               ("n" "Personal notes" entry
                                (file+headline +org-capture-notes-file "Inbox")
                                "* %u %?\n%i\n%a" :prepend t)
                               ("j" "Journal" entry
                                (file+olp+datetree +org-capture-journal-file)
                                "* %U %?\n%i\n%a" :prepend t)
                               ("p" "Templates for projects")
                               ("pt" "Project-local todo" entry
                                (file+headline +org-capture-project-todo-file "Inbox")
                                "* TODO %?\n%i\n%a" :prepend t)
                               ("pn" "Project-local notes" entry
                                (file+headline +org-capture-project-notes-file "Inbox")
                                "* %U %?\n%i\n%a" :prepend t)
                               ("pc" "Project-local changelog" entry
                                (file+headline +org-capture-project-changelog-file "Unreleased")
                                "* %U %?\n%i\n%a" :prepend t)
                               ("o" "Centralized templates for projects")
                               ("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?\n %i\n %a" :heading "Tasks" :prepend nil)
                               ("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?\n %i\n %a" :heading "Notes" :prepend t)
                               ("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?\n %i\n %a" :heading "Changelog" :prepend t)))

(require 'cal-china-x)
(setq! calendar-week-start-day 1
       org-agenda-include-diary t
       diary-file (expand-file-name "hyluo-diary" org-directory)
       mark-holidays-in-calendar t
       cal-china-x-important-holidays cal-china-x-chinese-holidays
       cal-china-x-general-holidays '((holiday-lunar 1 15 "元宵节"))
       calendar-holidays (append cal-china-x-important-holidays cal-china-x-general-holidays))

(setq! citar-bibliography (expand-file-name "bib/references.bib" org-directory)
       bibtex-completion-bibliography citar-bibliography
       citar-notes-paths '("/User/luohongyang/Documents/org/references/")
       citar-open-note-function 'orb-citar-edit-note)

(after! org-roam (setq! org-roam-db-gc-threshold most-positive-fixnum
                        org-roam-directory (expand-file-name "roam" org-directory)
                        org-roam-capture-templates '(("d" "default" plain "%?"
                                                      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+created: %U\n#+last_modified: %U\n\n")
                                                      :unnarrowed t)
                                                     ("r" "bibliography reference" plain "%?"
                                                      :target (file+head "references/${citekey}.org" "#+title: ${title}\n#+created: %U\n#+last_modified: %U\n\n")
                                                      :unnarrowed t))))
(org-roam-db-autosync-mode)
(setq! time-stamp-active t
       time-stamp-start "#\\+last_modified:[ \t]*"
       time-stamp-end "$"
       time-stamp-format "\[%Y-%02m-%02d %3a %02H:%02M\]")
(add-hook 'before-save-hook 'time-stamp nil)
(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (push arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))
(map! :leader
      :desc "later finish node"
      "n r l" #'org-roam-node-insert-immediate)

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
  (setq org-agenda-files (cons org-directory (vulpea-project-files))))

(add-hook 'find-file-hook #'vulpea-project-update-tag)
(add-hook 'before-save-hook #'vulpea-project-update-tag)

(advice-add 'org-agenda :before #'vulpea-agenda-files-update)
(advice-add 'org-todo-list :before #'vulpea-agenda-files-update)

;; functions borrowed from `vulpea' library
;; https://github.com/d12frosted/vulpea/blob/6a735c34f1f64e1f70da77989e9ce8da7864e5ff/vulpea-buffer.el

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

(use-package! websocket
  :after org-roam)
(use-package! org-roam-ui
  :after org-roam
  :config
  (setq! org-roam-ui-sync-theme t
         org-roam-ui-follow t
         org-roam-ui-update-on-save t
         org-roam-ui-open-on-start t))

(use-package! org-roam-bibtex
  :after org-roam
  :config
  (setq! orb-roam-ref-format 'org-cite
         orb-insert-link-description 'citation-org-cite)
  (add-to-list 'orb-note-actions-user (cons "Citar Actions" #'citar-run-default-action)))

(use-package! rime
  ;; :hook
  ;; :init
  :config
  (define-key rime-mode-map (kbd "M-q") 'rime-force-enable)
  (defun rime-predicate-tex-math-or-command-p ()
    "If point is inside a (La)TeX math environment, or a (La)TeX command.

    Return true if the buffer is in `tex-mode' and one of the following three cases occurs:

    1. The point is inside a (La)TeX math environment;
    2. The current character is `$' or `\\', either at the beginning of a line, or after an ascii/space.
    3. The string before the point is of the form a (La)TeX command. If the command have a parameter, it is closed by `}' or `%'. If not, it is closed by a space or `%'.

    Can be used in `rime-disable-predicates' and `rime-inline-predicates'."
    (and (derived-mode-p 'tex-mode 'org-mode)
         (or (and (featurep 'tex-site)
                  (texmathp))
             (and rime--current-input-key
                  (or (= #x24 rime--current-input-key)
                      (= #x5c rime--current-input-key))
                  (or (= (point) (line-beginning-position))
                      (= #x20 (char-before))
                      (rime-predicate-after-ascii-char-p)))
             (and (> (point) (save-excursion (back-to-indentation) (point)))
                  (let ((string (buffer-substring (point) (max (line-beginning-position) (- (point) 80)))))
                    (or (string-match-p "[\x5c][\x21-\x24\x26-\x7e]*$" string)
                        (string-match-p "[\x5c][a-zA-Z\x23\x40]+[\x7b][^\x7d\x25]*$" string)))))))
  (setq! rime-show-candidate 'posframe
         rime-emacs-module-header-root "/opt/homebrew/opt/emacs-mac/include"
         rime-show-preedit 'inline
         default-input-method "rime"
         rime-librime-root (expand-file-name "librime/dist" user-emacs-directory)
         rime-disable-predicates '(rime-predicate-after-alphabet-char-p          ;;在英文字符串之后（必须为以字母开头的英文字符串）
                                   rime-predicate-after-ascii-char-p             ;;任意英文字符后
                                   rime-predicate-prog-in-code-p                 ;;在`prog-mode'和`conf-mode'中除了注释和引号内字符串之外的区域
                                   rime-predicate-in-code-string-p               ;;在代码的字符串中，不含注释的字符串。
                                   rime-predicate-evil-mode-p                    ;;在`evil-mode'的非编辑状态下
                                        ;rime-predicate-ace-window-p                   ;;激活`ace-window-mode'
                                        ;rime-predicate-hydra-p                        ;;如果激活了一个`hydra'keymap
                                        ;rime-predicate-current-input-punctuation-p    ;;当要输入的是符号时
                                   rime-predicate-punctuation-after-space-cc-p   ;;当要在中文字符且有空格之后输入符号时
                                   rime-predicate-punctuation-after-ascii-p      ;;当要在任意英文字符之后输入符号时
                                   rime-predicate-punctuation-line-begin-p       ;;在行首要输入符号时
                                        ;rime-predicate-space-after-ascii-p            ;;在任意英文字符且有空格之后
                                   rime-predicate-space-after-cc-p               ;;在中文字符且有空格之后
                                   rime-predicate-current-uppercase-letter-p     ;;将要输入的为大写字母时
                                        ;rime-predicate-org-in-src-block-p             ;;在`org-src-block'中时
                                   rime-predicate-tex-math-or-command-p)         ;;在 (La)TeX 数学环境中或者输入 (La)TeX 命令时
         rime-posframe-properties (list :font (font-spec :family "Hiragino Sans GB" :size 18)
                                        :internal-border-width 3)))

(setq! mac-command-modifier     'meta
       mac-option-modifier      'super)

(setq-default TeX-engine 'xetex)
(setq! +latex-viewers '(pdf-tools)
       reftex-default-bibliography (expand-file-name "bib/references.bib" org-directory)
       TeX-command-extra-options "-view=none")
(map! :map cdlatex-mode-map
      :i "TAB" #'cdlatex-tab)

(after! company (setq! company-idle-delay 0.2))

(after! which-key (setq! which-key-idle-delay 1.0
                         which-key-max-description-length 80))

(sp-local-pair 'org-mode "$" "$")
