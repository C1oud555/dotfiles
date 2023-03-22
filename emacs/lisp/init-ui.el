;;; init-ui.el --- Interactive completion in buffers -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package rainbow-mode)
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold nil    ; if nil, bold is universally disabled
	doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t))


(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :init (column-number-mode))

(use-package highlight-indent-guides
  :init (setq highlight-indent-guides-method 'character)
  :hook (prog-mode . highlight-indent-guides-mode))

(set-face-attribute 'default nil :font "Monaco-14")

;; set buffer to direction
(add-to-list 'display-buffer-alist
             '((lambda (buffer-or-name _)
                   (let ((buffer (get-buffer buffer-or-name)))
                     (with-current-buffer buffer
                       (or (equal major-mode 'vterm-mode)
			   (equal major-mode 'helpful-mode)
                           (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                (display-buffer-reuse-window display-buffer-at-bottom)
                ;; (display-buffer-reuse-window display-buffer-in-direction)
                ;; (direction . bottom)
                ;; (dedicated . t) 
                (reusable-frames . visible)
                (window-height . 0.3)))

(provide 'init-ui)
;;; init-ui.el ends here
