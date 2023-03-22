;;; init-chinese.el --- Interactive completion in buffers -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package pinyinlib
  :config
  (defun completion--regex-pinyin (str)
    (orderless-regexp (pinyinlib-build-regexp-string str)))
  (add-to-list 'orderless-matching-styles 'completion--regex-pinyin))

(use-package pangu-spacing
  :config
  (setq pangu-spacing-real-insert-separtor t)
  :init
  (global-pangu-spacing-mode))

(use-package sis
  :config
  (sis-ism-lazyman-config
   "com.apple.keylayout.ABC"
   "com.apple.inputmethod.SCIM.ITABC")
  (sis-global-cursor-color-mode t)
  (sis-global-respect-mode t)
  (sis-global-context-mode t)
  (sis-global-inline-mode t))


(provide 'init-chinese)
;;; init-chinese.el ends here
