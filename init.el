;; package --- init-file
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
    ;; For all modes
    (evil-mode 1)))


;; w or e, etc will go over _ + -
(add-hook 'prog-mode-hook
          (lambda ()
	    (modify-syntax-entry ?_ "w")
	    (modify-syntax-entry ?- "w")))

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

(defvar custom-file)
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

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
(setq-default show-trailing-whitespace t)
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
		w3m-mode-hook
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
;(defvar org-default-notes-file)
;(defvar initial-buffer-choice)
;(setq
; org-default-notes-file "~/org/index.org"
; initial-buffer-choice  org-default-notes-file) ; open org index by default

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
  (company-dabbrev-code-ignore-case t)
  (company-dabbrev-ignore-case t)
  (company-dabbrev-downcase nil)
  (company-dabbrev-minimum-length 1)
  ; Remove dups
  ; https://company-mode.github.io/manual/Backends.html#Candidates-Post_002dProcessing
  ;(company-transformers '(delete-dups))
  :config
  (global-company-mode t)
  ;(add-to-list 'company-transformers #'company-sort-by-occurrence)
  ;(add-to-list 'company-transformers #'delete-consecutive-dups)
  (defun add-pcomplete-to-capf ()
    (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t))
  ;(add-hook 'org-mode-hook #'add-pcomplete-to-capf)
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

;; === Spell Check ===
(use-package jinx
  :hook ((org-mode)
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
  :config
  ;; Dont allow prompt to be deleted
  (defvar comint-prompt-read-only)
  (setq comint-prompt-read-only t)
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
(treemacs-start-on-boot)

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package csound-mode
  :ensure t
  :custom
  (csound-skeleton-default-options "-d -oadc -W -3 -+rtmidi=alsa -Ma -+rtaudio=alsa --limiter=0.95")
  ; One way to simulate csound-mode as prog-mode (it has issues though
  ;:hook
  ;(csound-mode . prog-mode)
  :config
  ; Boot up csound repl with midi capabilities
  ; Got this from https://github.com/hlolli/csound-mode/blob/main/csound-repl.el#L515
  (defun csound-repl--start-server (port console-port sr ksmps nchnls zero-db-fs)
    "Function to start csound repl."
    (start-process "Csound Server" csound-repl-buffer-name
                   "csound" "-odac"
		           "-+rtmidi=alsa""-Ma"
		           "-+rtaudio=alsa" "--limiter=0.95"
                   (format "--port=%s" port)
                   (format "--udp-console=127.0.0.1:%s" console-port)
                   (format "--sample-rate=%s" sr)
                   (format "--ksmps=%s" ksmps)
                   (format "--nchnls=%s" nchnls)
                   (format "--0dbfs=%s" zero-db-fs)))
;  (advice-add 'csound-repl--start-server :override #'csound-repl--start-server)
  )
;:config

; To fix csound output
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)
(defvar compilation-scroll-output)
(setq compilation-scroll-output t)

;;; SuperCollider prereq
;(use-package sclang
;  :ensure nil
;  :load-path "~/.local/share/SuperCollider/downloaded-quarks/scel/el")
;
;(use-package w3m
;  :ensure t)

(use-package envrc)
(envrc-global-mode)

(provide 'init)
;;; init.el ends here
