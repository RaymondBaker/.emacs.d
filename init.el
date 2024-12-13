﻿;;; package --- init-file
;;; Author: Raymond Baker

;;; Commentary:
"Raymond's Init file"

;;; CODE:
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("elpa" . "https://elpa.gnu.org/packages/")))

;; BOOTSTRAP USE-PACKAGE
(package-initialize)
(defvar use-package-always-ensure)
(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

;(use-package gruvbox-theme)
;(load-theme 'gruvbox-dark-medium t)

(use-package ef-themes)
(load-theme 'ef-elea-dark t)



;;; Vim Bindings
(define-prefix-command 'md/leader-map)

(defvar md/org-mode-leader-map (make-sparse-keymap))
(defvar md/leader-map)
(set-keymap-parent md/org-mode-leader-map md/leader-map)

(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit))
  :init
  ;; allows for using cgn
  ;; (setq evil-search-module 'evil-search)
  (setq evil-want-keybinding nil)
  ;; no vim insert bindings
  (setq evil-undo-system 'undo-fu)
  :config
  (progn
  ;; Can't work out how to properly define map bindings using ":bind"
  (bind-key "<SPC>" md/leader-map evil-normal-state-map)
  (bind-key "<SPC>" md/leader-map evil-visual-state-map)
  (evil-mode 1)))

;(use-package evil-cleverparens
;  :ensure t
;  :hook
;  ((lsp-mode-hook) . evil-cleverparens-mode))

(global-set-key (kbd "M-h")  'windmove-left)
(global-set-key (kbd "M-l") 'windmove-right)
(global-set-key (kbd "M-k")    'windmove-up)
(global-set-key (kbd "M-j")  'windmove-down)

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

;;; Vim Bindings Everywhere else
(use-package evil-collection
  :after evil
  :config
  (setq evil-want-integration t)
  (evil-collection-init))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("d609d9aaf89d935677b04d34e4449ba3f8bbfdcaaeeaab3d21ee035f43321ff1" "ae20535e46a88faea5d65775ca5510c7385cbf334dfa7dde93c0cd22ed663ba0" "d6b369a3f09f34cdbaed93eeefcc6a0e05e135d187252e01b0031559b1671e97" "a0e9bc5696ce581f09f7f3e7228b949988d76da5a8376e1f2da39d1d026af386" "296dcaeb2582e7f759e813407ff1facfd979faa071cf27ef54100202c45ae7d4" "2551f2b4bc12993e9b8560144fb072b785d4cddbef2b6ec880c602839227b8c7" "211621592803ada9c81ec8f8ba0659df185f9dc06183fcd0e40fbf646c995f23" "59c36051a521e3ea68dc530ded1c7be169cd19e8873b7994bfc02a216041bf3b" "5a0ddbd75929d24f5ef34944d78789c6c3421aa943c15218bac791c199fc897d" default))
 '(package-selected-packages
   '(vue-mode jinx modus-themes shell-pop shell-pop-el treemacs-icons-dired treemacs-evil treemacs envrc exec-path-from-shell pet treesit-auto flycheck company lsp-pyright pip-requirements pyvenv lsp-ui lsp-mode undo-fu-session evil-collection evil-surround evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; == Undo system ===
(use-package undo-fu)
(use-package undo-fu-session)
(undo-fu-session-global-mode)


;; === SET DISPLAY ===

;; Stop bell sound
;; Get Ride of gui tool bar
(tool-bar-mode -1)
;;(menu-bar-mode -1)
(setq visible-bell t
      ring-bell-function 'ignore
      line-number-mode t
      column-number-mode t)
(scroll-bar-mode -1)
;(customize-set-variable 'scroll-bar-mode nil)
;(customize-set-variable 'horizontal-scroll-bar-mode nil)

(global-display-line-numbers-mode)
  ;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook
                vterm-mode-hook
                compilation-mode        ;; <----
                telega-root-mode-hook
                telega-chat-mode-hook
                erc-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(set-frame-font "IBM Plex Mono-13" nil t)

(setq scroll-step            1
      scroll-conservatively  10000)

;; == Save sessions history ==
(defvar savehist-save-minibuffer-history)
(defvar savehist-file)
(defvar savehist-additional-variables)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring search-ring regexp-search-ring compile-history log-edit-comment-ring)
      savehist-file "~/.emacs.d/savehist")
(savehist-mode t)

;; Org Settings
(defvar org-default-notes-file)
(defvar initial-buffer-choice)
(setq
 org-default-notes-file "~/org/index.org"
 initial-buffer-choice  org-default-notes-file) ; open org index by default

;; use bold instead of showing mark down
(defvar org-hide-emphasis-markers)
(setq org-hide-emphasis-markers t)

(defvar org-capture-templates)
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")))

(use-package company
  :pin melpa
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0) ;; default is 0.2
  (company-dabbrev-downcase nil)
  :config
  (global-company-mode t)
  (add-to-list 'company-transformers #'company-sort-by-occurrence)
  (defun add-pcomplete-to-capf ()
    (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t))
  (add-hook 'org-mode-hook #'add-pcomplete-to-capf)
  )

(use-package treesit-auto
  :functions global-treesit-auto-mode
  :init
  (setq treesit-auto-install 'prompt)
  :config
  (global-treesit-auto-mode)
  )

(use-package lsp-mode
  :defines lsp-modeline-diagnostics-scope
  :hook ((c-mode-common
          c-ts-base-mode
          cmake-ts-mode
          enh-ruby-mode
          go-mode
          go-ts-mode
          groovy-mode
          js-base-mode
	  python-ts-mode
          rust-mode
          rust-ts-mode
          scala-mode
          swift-mode
          typescript-ts-base-mode
          tuareg-mode)
         . lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :commands (lsp lsp-deferred)
  :config
  ;; This variable determines how often lsp-mode will refresh the highlights, lenses, links, etc
  ;; while you type. Slow it down so emacs don't get stuck.
  (setq lsp-idle-delay 0.500)
  ;; (setq lsp-prefer-capf nil) ;; company-capf, use this instead of company lsp, better performance
  (setq lsp-modeline-diagnostics-scope :workspace)
  (setq lsp-modeline-diagnostics-enable nil)
  (setq lsp-headerline-breadcrumb-enable nil)
  )

(use-package lsp-ui
  :after (lsp-mode)
  :commands lsp-ui-mode
  :bind ("M-g f" . lsp-ui-sideline-apply-code-actions)
  :init
  (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  :config
  (setq lsp-ui-doc-position 'top ;; top right
	lsp-signature-auto-activate t
	lsp-ui-sideline-delay 3 ;; 3 seconds
	lsp-signature-doc-lines 1 )
  )

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook (python-ts-mode . (lambda ()
                                   (require 'lsp-pyright)
                                   (lsp-deferred))))  ; or lsp-deferred
(use-package jinx
  :hook ((text-mode
	  org-mode)
	  . jinx-mode)
  :bind (("C-;" . jinx-correct))
  :custom
  (jinx-camel-modes '(prog-mode))
  (jinx-delay 0.1))

(use-package python ;; builtin
  :config
  (evil-define-key 'normal python-mode-map
    "gk" 'python-nav-backward-defun
    "gj" 'python-nav-forward-defun))

(use-package flycheck
  :config
  (global-flycheck-mode t)
  (setq flycheck-python-pycompile-executable "python3")
  )

;; === Java Script ===
(defvar vue-mode-packages)
(setq vue-mode-packages
  '(vue-mode))

(defvar vue-mode-excluded-packages)
(setq vue-mode-excluded-packages '())

(defun vue-mode/init-vue-mode ()
  "Initialize my package."
  (use-package vue-mode))


(use-package shell-pop
  :bind
  (:map global-map
	("C-c t" . shell-pop)))

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(treemacs-start-on-boot)

(use-package envrc)
(envrc-global-mode)

;(provide '.emacs)
;;; .emacs ends here