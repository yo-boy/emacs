;;; package --- Summary
;; -*- lexical-binding: t -*-

;;; Commentary:
					;This file provides my cutom Emacs configuration.

;;; Code:
;; Startup time
(defun my/display-startup-time ()
  "This function will return the startup time."
  (message
   "Emacs loaded in %s with %d garbage collections."
   (format
    "%.2f seconds"
    (float-time
     (time-subtract after-init-time before-init-time)))
   gcs-done))

(add-hook 'emacs-startup-hook #'my/display-startup-time)

(setq warning-minimum-level :error)

;; use melpa packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
;; install the setup macro if it isn't installed.
(unless (package-installed-p 'setup)
  (package-install 'setup))

(require 'setup)

;; don't leave backup files
(setq
 backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
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

;; disable splash screen
(setq inhibit-startup-message t)
(setq initial-scratch-message ";; This buffer is for text that is not saved, and for Lisp evaluation.\n\n")

;; resize correctly
(setq frame-resize-pixelwise t)

;; make lines wrap on words
(global-visual-line-mode 1)

;; remove the tool bar
(tool-bar-mode -1)

;; disable scroll bar
(scroll-bar-mode -1)

;; save place mode
(save-place-mode 1)

;; add right click menu
(context-menu-mode 1)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)
;; revert all buffers
(setq global-auto-revert-non-file-buffers 1)

;; Save bookmarks as soon as they are changed
(setq bookmark-save-flag 1)

;; Typed text replaces the selection if the selection is active,
;; pressing delete or backspace deletes the selection.
(delete-selection-mode 1)

;; enable tab completion
(setq tab-always-indent 'complete)

;; save minibuffer history
(savehist-mode 1)
(cons 'savehist-additional-variables 'command-history)
(cons 'savehist-additional-variables 'file-name-history)

;; recent files mode
(recentf-mode 1)
(run-at-time nil (* 5 60) 'recentf-save-list)

;; automatic pairs
(electric-pair-mode 1)

;; enable tab-bar-mode
(setq tab-bar-show 1)
(tab-bar-mode 1)

;; tab-line-mode
(global-tab-line-mode 1)

;; refresh (revert) files in buffers
(global-auto-revert-mode 1)

;; Do not saves duplicates in kill-ring
(customize-set-variable 'kill-do-not-save-duplicates t)

(eval-after-load "term"
  '(define-key term-raw-map (kbd "C-c C-y") 'term-paste))

;; add line numbers for programming
(add-hook 'prog-mode-hook  #'display-line-numbers-mode)

;; previous and next buffer on f-keys
(define-key global-map [f1] #'tab-line-switch-to-prev-tab)
(define-key global-map [f2] #'tab-line-switch-to-next-tab)

;; buttons to start and end of buffer
(define-key global-map (kbd "C-<next>") 'end-of-buffer)
(define-key global-map (kbd "C-<prior>") 'beginning-of-buffer)

;; set fonts
(set-face-attribute 'default nil :font "Iosevka" :height 125)
(set-face-attribute 'fixed-pitch nil :font "Iosevka")
;(set-face-attribute 'variable-pitch nil :font "Iosevka Aile")

;; all the icons
(setup (:package all-the-icons all-the-icons-dired all-the-icons-completion)
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
  (all-the-icons-completion-mode))

;; page break lines
(setup (:package page-break-lines)
  (global-page-break-lines-mode))

;; dashboard
(setup (:package dashboard)
  (dashboard-setup-startup-hook)
  (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
  ;;(setq dashboard-startup-banner 2)
  (setq dashboard-startup-banner "~/.config/emacs/rin-rustbook.png")
  (setq dashboard-center-content t)
  (setq dashboard-items '((recents  . 7)
                          (projects . 5)
                          (agenda . 8)
			  (bookmarks . 5)))
  (setq dashboard-set-init-info t)
  (setq dashboard-projects-backend 'project-el)
  (setq dashboard-icon-type 'all-the-icons)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-set-navigator t)
  (setq dashboard-heading-icons '((recents   . "history")
                                  (bookmarks . "bookmark")
                                  (agenda    . "calendar")
                                  (projects  . "rocket")
                                  (registers . "database"))))


;; setup themes
;; (setup (:package color-theme-sanityinc-tomorrow)
;; ; (load-theme 'sanityinc-tomorrow-night t)
;;   (load-theme 'sanityinc-tomorrow-eighties t))
(defvar ef-themes-to-toggle)
(setup (:package  ef-themes)
  :option (setq  ef-themes-to-toggle '(ef-arbutus ef-melissa-dark))
  (load-theme 'ef-melissa-dark t)
  (:global "C-c t" ef-themes-toggle))

;; ace-window for managing windows
(setup (:package ace-window)
  :option (:global "C-x o" 'ace-window))

;; expand region
(setup (:package expand-region)
  (:global "C-;" #'er/expand-region))

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

;;; ui stuff
;; vertico
(setup (:package vertico marginalia orderless)
  ;; enable richer annotations using the Marginalia package
  (:option vertico-mode 1
	   vertico-cycle t
	   marginalia-mode 1
	   savehist-mode 1
	   enable-recursive-minibuffers t
	   ;; orderless completion
	   completion-styles '(orderless basic)
	   completion-category-overrides '((file (styles basic partial-completion)))))

;; consult
(setup (:package consult consult-yasnippet)
  (:option  xref-show-xrefs-function #'consult-xref
            xref-show-definitions-function #'consult-xref)
  (:global
   "C-x b" consult-buffer
   "C-s" consult-line
   "C-c f" consult-flymake
					;"C-c TAB" consult-yasnippet
   )
  (:bind-into minibuffer-local-map "C-r" #'consult-history))

;; code folding
;; (setup (:package origami)
;;   (global-origami-mode 1)
;;   (add-to-list  'origami-parser-alist '(rustic-mode . origami-c-style-parser))
;;   ;(define-key origami-mode-map (kbd "C-<tab>") #'origami-toggle-node)
;;   (define-key origami-mode-map (kbd "C-r") #'origami-forward-toggle-node))

(setq help-window-select t)
(setq eldoc-echo-area-prefer-doc-buffer 'maybe)
(setq eldoc-echo-area-use-multiline-p 'truncate-sym-name-if-fit)
(setq eldoc-echo-area-display-truncation-message t)

(setup (:package eglot yasnippet yasnippet-snippets)
  (yas-global-mode 1)
  (setq eglot-events-buffer-size 0)
  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  (define-key yas-minor-mode-map (kbd "TAB") nil)
  (add-hook 'nix-mode-hook 'eglot-ensure)
  (add-hook 'python-mode-hook 'eglot-ensure)
  (add-hook 'c-mode 'eglot-ensure)
  (add-hook 'rustic-mode 'eglot-ensure)
  (add-hook 'eglot-managed-mode-hook #'eglot-inlay-hints-mode)
  (:bind-into eglot-mode-map "C-c g" #'eglot-code-actions))

;; (setup (:package tree-sitter-langs)
;;   (global-tree-sitter-mode 1)
;;   (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

;; Enabled inline static analysis
(add-hook 'prog-mode-hook #'flymake-mode)
(setq help-at-pt-display-when-idle t)

(setup (:package corfu kind-icon)
  (:option corfu-cycle t
	   ;;corfu-auto t
	   corfu-auto-prefix 2
	   ;;corfu-auto-delay 0.0
	   corfu-echo-documentation 0.25
	   ;;corfu-quit-no-match t
	   corfu-preselect 'valid
	   global-corfu-mode 1
	   corfu-popupinfo-mode 1
	   corfu-popupinfo-delay '(0.25 . 0.1)
	   kind-icon-default-face 'corfu-default)
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
  (:bind-into corfu-map
    "S-SPC" corfu-insert-separator
    "<M-up>" #'corfu-doc-scroll-down
    "<M-down>" #'corfu-doc-scroll-up
    "M-d" #'corfu-doc-toggle))

;; (setup (:package corfu-candidate-overlay)
;;   (:option corfu-candidate-overlay-mode +1))

(setup (:package cape yasnippet-capf)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
					;(add-to-list 'completion-at-point-functions #'cape-file)
					;(add-to-list 'completion-at-point-functions #'cape-history)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  ;;(add-to-list 'completion-at-point-functions #'cape-tex)
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;;  (add-to-list 'completion-at-point-functions #'cape-ispell)
  ;;(add-to-list 'completion-at-point-functions #'cape-dict)
  ;;  (add-to-list 'completion-at-point-functions #'cape-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)
  (add-to-list 'completion-at-point-functions #'yasnippet-capf))

(defun my/eglot-cap-config ()
  "This function will replace the eglot cap function with one that integrates 'yasnippet-capf'."
  (setq-local completion-at-point-functions
              (list
                #'eglot-completion-at-point
                #'yasnippet-capf
		)))
(add-hook 'eglot-managed-mode-hook #'my/eglot-cap-config)

(defun my/elisp-cap-config ()
  "This function will replace the elisp-capf with one that integrates 'yasnippet-capf'."
  (setq-local completion-at-point-functions
	      (list (cape-capf-super
		     #'elisp-completion-at-point
		     #'yasnippet-capf))))
(add-hook 'emacs-lisp-mode-hook #'my/elisp-cap-config)

;; autocompletion for shell commands
(setup (:package pcmpl-args))

(setup (:package  devdocs-browser))

;; show vc changes in file
(setup (:package diff-hl)
  (:hook-into prog-mode)
  (:option diff-hl-flydiff-mode t)
  global-diff-hl-show-hunk-mouse-mode
  (:global "C-c h" diff-hl-show-hunk))

;; highlight-indent-guides
(setup (:package highlight-indent-guides)
  (:hook-into prog-mode)
  (:option highlight-indent-guides-method 'character))

;; paredit for easier s-expression navigation
(setup (:package paredit)
  (:hook-into emacs-lisp-mode))

;; magit git frontend
(setup (:package magit))

;; rustic mode for rust
(setup (:package rustic)
  (:option rustic-lsp-client 'eglot
	   rustic-format-trigger 'on-save
	   rustic-cargo-clippy-trigger-fix 'on-compile
	   rustic-ansi-faces ["black" "red3" "green3" "yellow3" "purple2" "magenta3" "cyan3" "white"])
  (:bind-into rustic-mode-map "C-c C-c u" #'rustic-cargo-update))

;; markdown mode config
(add-to-list 'auto-mode-alist '("\\.mdx\\'" . markdown-mode))

;; web mode
(setup (:package web-mode)
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
					; (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (:option
   web-mode-enable-auto-expanding t
   web-mode-enable-current-element-highlight t
   web-mode-enable-auto-closing t
   web-mode-enable-auto-pairing t))

(setup (:package php-mode))

;; Add lsp or lsp-deferred function call to functions for your php-mode customization
(defun init-php-mode ()
  (eglot-ensure))

(with-eval-after-load 'php-mode
  ;; If phpactor command is not installed as global, remove next ;; and write the full path
  ;; (custom-set-variables '(lsp-phpactor-path "/path/to/phpactor"))
  (add-hook 'php-mode-hook #'init-php-mode))

;; nix mode
(setup (:package  nix-mode nix-ts-mode)
  (:file-match "\\.nix\\'"))

;; support for some programming languages
(setup (:package json-mode go-mode kotlin-mode))

;; slime for common lisp
(setup (:package sly)
  (:option inferior-lisp-program "sbcl"))

;; nov.el for reading
(setup (:package  nov)
  (:file-match "\\.epub\\'"))

;; pdf-tools and save place
(setup (:package pdf-tools saveplace-pdf-view bookmark)
  (:file-match ".pdf")
  (pdf-tools-install)
  (add-hook 'pdf-view-mode-hook #'pdf-view-midnight-minor-mode))

;; In-Emacs Terminal Emulation
(setup (:package eat)
  (:option eat-kill-buffer-on-exit t
	   eat-enable-mouse t))

;;; org mode config
(setq org-hide-emphasis-markers nil)
(setq org-startup-indented t)
(setq org-hide-leading-stars t)
(setq org-html-checkbox-type 'html)
(require 'org)
(custom-set-faces
 '(org-level-1 ((t (:inherit outline-1 :height 1.6))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.4))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
 '(org-level-4 ((t (:inherit outline-4 :height 1.1))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.0))))
 (set-face-attribute 'org-document-title nil :height 1.8 :underline nil))
(setq org-timestamp-custom-formats '("%d/%m/%y %a" . "%d/%m/%y %a %H:%M"))

(with-eval-after-load 'ol
  (org-link-set-parameters
   "img"
   :follow (lambda (path arg) (org-link-open-as-file path arg))
   :export (lambda (path desc backend cchannel)
             (cond ((eq backend 'html)
                    (format "<img style=\"max-width:80%%;margin:2em\" src=\"data:%s;base64,%s\">"
                            (mailcap-file-name-to-mime-type path)
                            (base64-encode-string
                             (with-temp-buffer
                               (insert-file-contents path)
                               (buffer-string)))))))))

;; org-babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (C . t)))

;; org sort keybind
(define-key org-mode-map (kbd "C-c c") #'org-sort-entries)

;; mixed pitch fonts in org mode
(setup (:package mixed-pitch)
  (:hook-into text-mode))

;; setup writing environment

(setup (:package wc-mode)
  (setq wc-modeline-format "[%W%w/%tw]"))

(setup (:package olivetti)
  (setq olivetti-body-width 90))

(add-hook 'text-mode-hook 'olivetti-mode)
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'text-mode-hook 'wc-mode)
;;(add-hook 'text-mode-hook 'display-line-numbers-mode)

;; org latex pdf export don't ask for 'yes'
(setq revert-without-query '(".pdf"))

;; setup mysql
;;(setup (:package emacsql emacsql-mysql))
;; (setup (:package sqlup-mode)
;;   (:hook-into sql-mode-hook))

(setup (:package org-roam org-roam-ui)
  (:option
   org-roam-directory "~/Documents/org-roam-notes/")
  (org-roam-db-autosync-mode))

(setq custom-file "~/.config/emacs/custom.el")
(load custom-file)

(setup (:package ox-epub))
;; colors in orgmode code export
(require 'ox-epub)
(require 'ox-latex)
(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-latex-listings 'minted)

(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)

;; code folding
(add-hook 'prog-mode-hook #'hs-minor-mode)
(require 'hideshow)
(define-key hs-minor-mode-map (kbd "C-r") #'hs-toggle-hiding)


;; set initial frame(window) size
(set-frame-size (selected-frame) 1040 980 t)

;; set initial frame(window) position
;(set-frame-position (selected-frame) (- (display-pixel-width) (frame-pixel-width)) 0) ;; doesn't work on wayland

(provide 'init)
