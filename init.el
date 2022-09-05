
;;; Code:
;; use melpa packages and use-package
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(require 'setup)

;;remove the tool bar
(tool-bar-mode -1)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)

;; Typed text replaces the selection if the selection is active,
;; pressing delete or backspace deletes the selection.
(delete-selection-mode)

;; enable tab completion
(setq tab-always-indent 'complete)

;;save minibuffer history
(savehist-mode 1)
(cons 'savehist-additional-variables 'command-history)
(cons 'savehist-additional-variables 'file-name-history)

;; recent files mode
(recentf-mode 1)

;; automatic pairs
(electric-pair-mode 1)

;; Do not saves duplicates in kill-ring
(customize-set-variable 'kill-do-not-save-duplicates t)

;;(eval-after-load "term"
;;  '(define-key term-raw-map (kbd "C-c C-y") 'term-paste))

;; add line numbers for programming
(add-hook 'prog-mode-hook  #'display-line-numbers-mode)

;; Set further font and theme customizations
;; (set-face-attribute 'default nil
;;                     :font "Roboto Mono"
;;                     :weight 'normal
;;                     :height 110)

(set-face-attribute 'default nil
		    :font "Hack"
		    :foundry "SRC"
		    :weight 'normal
		    :height 110)

(defvar ef-themes-to-toggle)
(setup (:package  ef-themes)
  :option (setq  ef-themes-to-toggle '(ef-day ef-winter))
  (load-theme 'ef-day :no-confirm))

;; which-key shows what the next keys can do after the current sequences
(setup (:package  which-key)
  (:option  which-key-mode 1
            which-key-idle-delay 0.4))

;; ui stuff
(setup (:package selectrum consult  marginalia  orderless)
  ;; enable richer annotations using the Marginalia package
  (:option selectrum-mode 1
	   marginalia-mode 1
	   ;; orderless completion
	   completion-styles '(orderless basic)
	   completion-category-overrides '((file (styles basic partial-completion))))
  ;; consult
  (:global
   "C-x b" consult-buffer
   "C-s" consult-line))

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
(setup (:package  company)
  (:option global-company-mode 1))

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

;; emms audio play
(setup (:package emms)
  (require 'emms-setup)
  (emms-all)
  (emms-default-players))

;; bongo to play audio
(setup (:package bongo))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("b69d8a1a142cde4bbde2f940ac59d2148e987cd235d13d6c4f412934978da8ab" "793cfa0728664ead4ec7083cbfeac9e77fcc4370c614a27d6120fc7244ecc148" default))
 '(elfeed-feeds
   '("https://www.spreaker.com/show/4253631/episodes/feed" "https://www.spreaker.com/show/4244348/episodes/feed" "https://feeds.redcircle.com/c6d2e869-22ae-4e68-b88e-e1957d070d3a" "https://anchor.fm/s/62d12970/podcast/rss" "https://feeds.buzzsprout.com/1890340.rss"))
 '(package-selected-packages
   '(bongo magit emms elfeed slime setup paredit highlight-indent-guides nov\.el nov ef-themes devdocs-browser emacs-devdocs-browser dirvish q4 eglot lsp-ui dap-mode company-mode company lsp-pyright flycheck lsp-mode selectrum orderless consult marginalia which-key nix-mode use-package doom-themes))
 '(warning-suppress-log-types '((lsp-mode) (lsp-mode) (comp)))
 '(warning-suppress-types '((lsp-mode) (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
