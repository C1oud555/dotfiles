;;; init-eglot.el --- LSP support via eglot          -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:


(use-package project)
(use-package eglot
  :hook ((verilog-mode c-mode c++-mode scala-mode python-mode) . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs '(verilog-mode . ("verible-verilog-ls"))))

(with-eval-after-load 'eglot
  (setq completion-category-defaults nil))

;; completion of super-capf is under init-completion

(setq read-process-output-max (* 1024 1024))

(use-package consult-eglot)

(provide 'init-eglot)
;;; init-eglot.el ends here

