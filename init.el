;; -*- lexical-binding: t -*-

;; Startup time
(defun efs/display-startup-time ()
  (message
   "Emacs loaded in %s with %d garbage collections."
   (format
    "%.2f seconds"
    (float-time
     (time-subtract after-init-time before-init-time)))
   gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;; use melpa packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
;; install the setup macro if it isn't installed.
(if
    (package-installed-p 'setup)
    nil
  (if
      (memq 'setup package-archive-contents)
      nil
    (package-refresh-contents))
  (package-install 'setup))
(require 'setup)

;; don't leave backup files
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups")))
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; indent buffer function
(defun my/indent-buffer ()
  "Indent each nonblank line in the buffer."
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

;; resize correctly
(setq frame-resize-pixelwise t)

;; set initial frame(window) size
(set-frame-size (selected-frame) 1040 1000 t)

;; set initial frame(window) position
(set-frame-position (selected-frame) (- (display-pixel-width) (frame-pixel-width)) 0)

;; make lines wrap on words
(global-visual-line-mode 1)

;; replace highlighted text when you type.
(delete-selection-mode 1)

;; remove the tool bar
(tool-bar-mode -1)

;; disable scroll bar
(scroll-bar-mode -1)

;; add right click menu
(context-menu-mode 1)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)
;; revert all buffers
(setq global-auto-revert-non-file-buffers 1)

;; Typed text replaces the selection if the selection is active,
;; pressing delete or backspace deletes the selection.
(delete-selection-mode)

;; enable tab completion
(setq tab-always-indent 'complete)

;; save minibuffer history
(savehist-mode 1)
(cons 'savehist-additional-variables 'command-history)
(cons 'savehist-additional-variables 'file-name-history)

;; recent files mode
(recentf-mode 1)

;; automatic pairs
(electric-pair-mode 1)

;; Do not saves duplicates in kill-ring
(customize-set-variable 'kill-do-not-save-duplicates t)

(eval-after-load "term"
 '(define-key term-raw-map (kbd "C-c C-y") 'term-paste))

;; add line numbers for programming
(add-hook 'prog-mode-hook  #'display-line-numbers-mode)

;; previous and next buffer on f-keys
(define-key global-map [f1] #'previous-buffer)
(define-key global-map [f2] #'next-buffer)

;; set fonts

;; (set-face-attribute 'default nil
;; 		    :font "Iosevka Slab"
;; 		    :height 125
;; 		    :width 'normal)
;; (set-face-attribute 'fixed-pitch nil :font "Iosevka Slab")

(set-face-attribute 'default nil :font "Iosevka" :height 125 :width 'normal)
(set-face-attribute 'fixed-pitch nil :font "Iosevka")
(set-face-attribute 'variable-pitch nil :font "Iosevka Aile")

;; setup themes
(defvar ef-themes-to-toggle)
(setup (:package  ef-themes)
  :option (setq  ef-themes-to-toggle '(ef-day ef-winter))
  (load-theme 'ef-day t)
  (:global "C-c t" ef-themes-toggle))

;; ace-window for managing windows
(setup (:package ace-window)
  :option (:global "C-x o" 'ace-window))

;; gpg pinentry
(setup (:package pinentry)
  :option #'pinentry-start)

;; easily switch to edit files with sudo
(setup (:package sudo-edit)
  :option
  (:global
   "C-c C-r" sudo-edit))

;; which-key shows what the next keys can do after the current sequences
(setup (:package  which-key)
  (:option  which-key-mode 1
            which-key-idle-delay 0.4))

;; auctex
(setup (:package auctex)
  (setq TeX-auto-save t)
  (setq TeX-parse-self t))

;; ui stuff
(setup (:package vertico consult marginalia orderless)
  ;; enable richer annotations using the Marginalia package
  (:option vertico-mode 1
	   vertico-cycle t
	   marginalia-mode 1
	   savehist-mode 1
	   enable-recursive-minibuffers t
	   ;; orderless completion
	   completion-styles '(orderless basic)
	   completion-category-overrides '((file (styles basic partial-completion))))
  ;; consult
  (:global
   "C-x b" consult-buffer
   "C-s" consult-line)
  (:bind-into minibuffer-local-map "C-r" #'consult-history))


;; TODO wip do stuff, fix it so it reuses the same buffer and add something that makes it not split endlessly
;; ;; bufler
;; (setup (:package bufler)
;;   (defun my/bufler-list (&optional)
;;     (interactive)
;;     (split-window-below)
;;     (windmove-down)
;;     (bufler-list)
;;     (previous-window))
;;   (:global "C-x C-b" #'my/bufler-list))

;; (setup-define :lsp-langs
;;   (lambda (mode)
;;     `(add-hook ',(intern  (concat (symbol-name mode) "-hook")) #'lsp))
;;   :documentation
;;   "hook the lsp function to a mode hook"
;;   :repeatable t)
;;(:lsp-langs python-mode java-mode)


;; code completion
;; (setup (:package lsp-mode lsp-ui dap-mode lsp-python-ms)
;;   ;(setq lsp-python-ms-executable (executable-find "python-language-server"))
;;   ;(setq lsp-python-ms-auto-install-server t)
;;   ;(setq lsp-python-ms-extra-paths '(""))
;;   (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
;;   (:option lsp-keymap-prefix "C-l"
;; 	   lsp-ui-mode 1 )
;;   (add-hook 'python-mode-hook #'lsp-deferred)
;;   (add-hook 'nix-mode-hook #'lsp-deferred))

(setup (:package eglot yasnippet)
  (yas-global-mode 1)
  (add-hook 'nix-mode-hook 'eglot-ensure)
  (add-hook 'python-mode-hook 'eglot-ensure))

;; conda
(setup (:package conda)
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell)
  (conda-env-autoactivate-mode t))

;; flycheck
(setup flycheck
  (:option global-flycheck-mode 1))

;; company-mode
;; (setup (:package  company)
;;   (:option global-company-mode 1))

(setup (:package corfu corfu-doc kind-icon)
  (:option corfu-cycle t
	   ;; corfu-auto t
	   ;; corfu-auto-prefix 2
	   ;; corfu-auto-delay 0.0
	   ;; corfu-echo-documentation 0.25
	   global-corfu-mode 1
	   corfu-doc-mode 1
	   kind-icon-default-face 'corfu-default)
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
  (:bind-into corfu-map
    ;; "S-SPC" corfu-insert-separator
    "SPC" corfu-insert-separator
    "<M-up>" #'corfu-doc-scroll-down
    "<M-down>" #'corfu-doc-scroll-up
    "M-d" #'corfu-doc-toggle))

(setup (:package pcmpl-args))
;; (add-hook 'eshell-mode-hook
;;           (lambda ()
;;             (setq-local corfu-auto nil)
;;             (corfu-mode)))

(setup (:package  devdocs-browser))

;; highlight-indent-guides
(setup (:package highlight-indent-guides)
  (:hook-into prog-mode)
  (:option highlight-indent-guides-method 'bitmap))

;; paredit for easier s-expression navigation
(setup (:package paredit)
  (:hook-into emacs-lisp-mode))

;; magit git frontend
(setup (:package magit))

;; nix mode
(setup (:package  nix-mode)
  (:file-match "\\.nix\\'"))

;; slime for common lisp
(setup (:package sly)
  (:option inferior-lisp-program "sbcl"))

;; nov.el for reading
(setup (:package  nov)
  (:file-match "\\.epub\\'"))

;; mixed pitch fonts in org mode
(setup (:package mixed-pitch)
  (:hook-into text-mode))

;; org latex pdf export don't ask for 'yes'
(setq revert-without-query '(".pdf"))

;; setup mysql
(setup (:package emacsql emacsql-mysql))
(setup (:package sqlup-mode)
  (:hook-into sql-mode-hook))

(setup (:package org-roam org-roam-ui)
  (:option
   org-roam-directory "~/Documents/org-roam-notes/")
    (org-roam-db-autosync-mode))

(setq custom-file "~/.config/emacs/custom.el")
(load custom-file)

(provide 'init)
;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
