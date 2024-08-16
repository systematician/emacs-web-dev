;; Some general tweaks, you can skip these
;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

(load-theme 'tango-dark)
(menu-bar-mode -1)
(setq ring-bell-function 'ignore)
(global-hl-line-mode t)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)

(use-package which-key
  :demand t
  :after evil
  :custom
  (which-key-allow-evil-operators t)
  (which-key-show-remaining-keys t)
  (which-key-sort-order 'which-key-prefix-then-key-order)
  :config
  (which-key-mode 1)
  (which-key-setup-minibuffer)
  (set-face-attribute
   'which-key-local-map-description-face nil :weight 'bold))

(use-package envrc
  :hook (after-init . envrc-global-mode))

(use-package evil
  :demand t
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-Y-yank-to-eol t
        evil-split-window-below t
        evil-vsplit-window-right t
        evil-respect-visual-line-mode t
        evil-undo-system 'undo-tree)
  :config
  (evil-mode 1))

;; Main configuration starts here

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (setq treesit-auto-langs '(javascript typescript tsx css html))
  (treesit-auto-add-to-auto-mode-alist '(javascript typescript tsx css html))
  (global-treesit-auto-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((prog-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :custom
  (read-process-output-max (* 1024 1024))
  :init
  (setq lsp-completion-provider :none)
  (setq lsp-keymap-prefix "C-c")
  (setq lsp-diagnostics-provider :flycheck))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))

(use-package flycheck
  :hook (lsp-mode . flycheck-mode)
  :bind (:map flycheck-mode-map
              ("M-n" . flycheck-previous-error)
              ("M-p" . flycheck-next-error))
  :custom (flycheck-display-errors-delay .3))

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0)
  (corfu-popupinfo-delay '(0.5 . 0.2))
  (corfu-preview-current 'insert)
  (corfu-preselect 'prompt)
  (corfu-on-exact-match nil)
  :bind (:map corfu-map
              ("TAB"        . corfu-next)
              ([tab]        . corfu-next)
              ("S-TAB"      . corfu-previous)
              ([backtab]    . corfu-previous)
              ("S-<return>" . corfu-insert)
              ("RET"        . corfu-insert))
  :init
  (global-corfu-mode)
  (corfu-history-mode))

;; Adds icons to the pop-up window
(use-package nerd-icons-corfu
  :after corfu
  :init (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package apheleia
  :hook (prog-mode . apheleia-mode)
  :config
  (setf (alist-get 'prettier apheleia-formatters)
        '("prettier" "--stdin-filepath" filepath)))
