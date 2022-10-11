;; -*- lexical-binding: t -*-
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

;; make lines wrap on words
(global-visual-line-mode 1)

;; replace highlighted text when you type.
(delete-selection-mode 1)

;; remove the tool bar
(tool-bar-mode -1)

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

;; set fonts

;; (set-face-attribute 'default nil
;; 		    :font "Iosevka Slab"
;; 		    :height 125
;; 		    :width 'normal)
;; (set-face-attribute 'fixed-pitch nil :font "Iosevka Slab")

(set-face-attribute 'default nil :font "Iosevka-12.5" :width 'normal)
(set-face-attribute 'fixed-pitch nil :font "Iosevka")
(set-face-attribute 'variable-pitch nil :font "Iosevka Etoile")

;; remove scrollbar from minibuffer.
(set-window-scroll-bars (minibuffer-window) nil nil)

;; setup themes
(defvar ef-themes-to-toggle)
(setup (:package  ef-themes)
  :option (setq  ef-themes-to-toggle '(ef-day ef-winter))
  (load-theme 'ef-day t)
  (:global "C-c t" ef-themes-toggle))

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
(setup (:package auctex))

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

(setup-define :lsp-langs
  (lambda (mode)
    `(add-hook ',(intern  (concat (symbol-name mode) "-hook")) #'lsp))
  :documentation
  "hook the lsp function to a mode hook"
  :repeatable t)

;; lsp-mode
(setup (:package lsp-mode lsp-ui dap-mode)
  (:lsp-langs python-mode java-mode)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (:option lsp-keymap-prefix "C-l"
	   lsp-ui-mode 1 ))

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
(setup (:package slime)
  (:option inferior-lisp-program "ccl"))

;; nov.el for reading
(setup (:package  nov)
  (:file-match "\\.epub\\'"))

;; elfeed rss tracker
(setup (:package elfeed))

;; bongo to play audio
(setup (:package bongo))

(setq custom-file "~/.config/emacs/custom.el")
(load custom-file)

(provide 'init)
;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
