;;; init-snippet.el --- Interactive completion in buffers -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package tempel
  :bind (("M-+" . tempel-complete) ))

(use-package tempel-collection
  :after tempel)

;; (use-package yasnippet
;;   :hook
;;   (prog-mode . yas-minor-mode)
;;   :config
;;   (yas-reload-all)
;;   :bind
;;   (:map yas-minor-mode-map ("S-<tab>" . yas-expand)))

;; (use-package yasnippet-snippets
;;   :after yasnippet)

(provide 'init-snippet)
;;; init-snippet.el ends here

