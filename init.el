(require 'package)
(load "package")

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

;; Installs packages
;; myPackages contains a list of package names

(defvar myPackages
  '(better-defaults                 ;; Set up some better Emacs defaults
    material-theme                  ;; Theme
    magit
    neotree
    rustic
    blacken
    yaml-mode
    highlight-indent-guides
    auctex
    yasnippet
    yasnippet-snippets
    markdown-mode
    use-package
    numpydoc
    py-isort
    consult
    eldoc-box
    orderless
    corfu
    nerd-icons-corfu
    )
  )

;; Scans the list in myPackages
;; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)


(load-theme 'material t)            ;; Load material theme
(global-hl-line-mode t)




(require 'numpydoc)

;; Display line numbers only when in programming modes
(add-hook 'prog-mode-hook 'display-line-numbers-mode)


;highligt indents
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-delay 0)
(setq highlight-indent-guides-method 'character)
(setq highlight-indent-guides-responsive 'top)


;; snipets
(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))



; ----markdown mode
(autoload 'markdown-mode "markdown-mode.el"
   "Major mode for editing Markdown files" t)
(setq auto-mode-alist
   (cons '("\.md" . markdown-mode) auto-mode-alist))

;yaml
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\.yml\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\.yaml\'" . yaml-mode))

(add-hook 'yaml-mode-hook
      '(lambda ()
       (define-key yaml-mode-map "\C-m" 'newline-and-indent)))


;;flyspell
(setq flyspell-default-dictionary "english") 
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(add-hook 'markdown-mode-hook 'flyspell-mode)



;;rust

(use-package rustic)


;;Python


(setq lsp-pyright-use-library-code-for-types t) ;; set this to nil if getting too many false positive type errors
(setq lsp-pyright-stub-path (concat (getenv "HOME") "/divers/python-type-stubs")) ;; example



;LSP performance
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

      
(require 'py-isort)
(add-hook 'before-save-hook 'py-isort-before-save)




;; auctex - configuration
(load "auctex.el" nil t t)
(setq TeX-parse-self t) ; Enable parse on load.
(setq TeX-auto-save t) ; Enable parse on save.
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)




(setq-default font-lock-maximum-decoration t)

(global-font-lock-mode t)
(column-number-mode t)
(line-number-mode t)
(require 'paren)
(show-paren-mode)
(setq show-paren-delay 0)

;pour suprimer selection avec touche
(delete-selection-mode t)




;;##########################################################
;; Langue
(set-terminal-coding-system 'utf-8)
;(set-keyboard-coding-system 'utf-8)
(set-language-environment 'UTF-8)

(tool-bar-mode -1)


(setopt treesit-font-lock-level 13)

(setq display-time-day-and-date t)
(setq display-time-24hr-format t)


;; la langue du dictionnaire
(setq ispell-dictionary "english")


;; la completion respecte la casse
(setq dabbrev-case-replace nil)

;; pour voir les images
(auto-image-file-mode 1)

;; permet d'ouvrir les gz a la volee
(auto-compression-mode 1)

;; Inhiber l'affichage du message d'accueil
(setq inhibit-startup-message t)

;; Remplacer les question "yes or no" par "y or n"
(fset 'yes-or-no-p 'y-or-n-p)

;; style de dates européen
(setq european-calendar-style t)

;; Des espaces pour indenter.
;; (setq indent-tabs-mode nil)

;; colle avec la souris là où se trouve le curseur et non là où on a cliqué
(setq mouse-yank-at-point t)
(setq mouse-yank-at-click nil)


;; de jolis noms pour les buffers sur un meme *nom* de fichier
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)


;; Alias y pour yes et n pour no
(defalias 'yes-or-no-p 'y-or-n-p)

(setq colon-double-space nil)
(setq sentence-end-double-space nil)

(put 'narrow-to-region 'disabled nil)




	; --- CONSULT
(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)

; --- end CONSULT

(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  (read-buffer-completion-ignore-case t)
  (read-file-name-completion-ignore-case t)
  (completion-styles '(basic substring partial-completion flex))
  :init
  (vertico-mode))

;; Improve the accessibility of Emacs documentation by placing
;; descriptions directly in your minibuffer. Give it a try:
;; "M-x find-file".
(use-package marginalia
  :after vertico
  :ensure t
  :init
  (marginalia-mode))



;; Adds intellisense-style code completion at point that works great
;; with LSP via Eglot. You'll likely want to configure this one to
;; match your editing preferences, there's no one-size-fits-all
;; solution.
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  ;; You may want to play with delay/prefix/styles to suit your preferences.
  (corfu-auto-delay 0.0)
  (corfu-auto-prefix 1)
  (completion-styles '(basic)))

(add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)

;; Adds LSP support. Note that you must have the respective LSP
;; server installed on your machine to use it with Eglot. e.g.
;; rust-analyzer to use Eglot with `rust-mode'.
(use-package eglot
  :ensure t
  :bind (("s-<mouse-1>" . eglot-find-implementation)
         ("C-c ." . eglot-code-action-quickfix))
  ;; Add your programming modes here to automatically start Eglot,
  ;; assuming you have the respective LSP server installed.
  :config
  (add-to-list 'eglot-server-programs '(python-mode . ("pyright-langserver" "--stdio")))
  (add-to-list 'eglot-server-programs '(c++-mode . ("clangd")))
  :hook
  (python-mode . eglot-ensure) (c++-mode . eglot-ensure))

;; Add extra context to Emacs documentation to help make it easier to
;; search and understand. This configuration uses the keybindings 
;; recommended by the package author.
(use-package helpful
  :ensure t
  :bind (("C-h f" . #'helpful-callable)
         ("C-h v" . #'helpful-variable)
         ("C-h k" . #'helpful-key)
         ("C-c C-d" . #'helpful-at-point)
         ("C-h F" . #'helpful-function)
         ("C-h C" . #'helpful-command)))


(use-package eldoc-box
  :after eglot
  :hook ((eglot-managed-mode . eldoc-box-hover-at-point-mode)))


(require 'orderless)
(setq completion-styles '(orderless basic)
      completion-category-overrides '((file (styles basic partial-completion))))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "ADBO" :slant normal :weight normal :height 100 :width normal))))
 '(line-number-current-line ((t (:inherit default :foreground "chartreuse")))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(eglot helpful corfu marginalia vertico nerd-icons-corfu orderless eldoc-box consult py-isort numpydoc yasnippet-snippets yasnippet auctex highlight-indent-guides yaml-mode blacken rustic neotree magit material-theme better-defaults)))
