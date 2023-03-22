;;; init-utils.el --- Interactive completion in buffers -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package benchmark-init
  :init (benchmark-init/activate)
  :hook (after-init . benchmark-init/deactivate))

(defun consult-find-under-here (&optional initial)
  (interactive "P")
  (consult-find default-directory initial))

(defun consult-ripgrep-under-here (&optional initial)
  (interactive "P")
  (consult-ripgrep default-directory initial))

(provide 'init-utils)
;;; init-utils.el ends here
