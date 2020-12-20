(require 'package)
(load "package")
;(package-initialize)
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
    projectile
    magit
    neotree
    ivy
    counsel
    swiper
    powerline
    rust-mode
    lsp-ui
    flycheck-rust
    elpy
    company-lsp                 
    blacken
    yaml-mode
    highlight-indent-guides
    auctex
    )
  )

;; Scans the list in myPackages
;; If the package listed is not already installed, install it

(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)


(setq inhibit-startup-message t)    ;; Hide the startup message
(load-theme 'material t)            ;; Load material theme

(require 'display-line-numbers)
(defcustom display-line-numbers-exempt-modes '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode)
  "Major modes on which to disable the linum mode, exempts them from global requirement"
  :group 'display-line-numbers
  :type 'list
  :version "green")

(defun display-line-numbers--turn-on ()
  "turn on line numbers but excempting certain majore modes defined in `display-line-numbers-exempt-modes'"
  (if (and
       (not (member major-mode display-line-numbers-exempt-modes))
       (not (minibufferp)))
      (display-line-numbers-mode)))

(global-display-line-numbers-mode)


;(require 'powerline)
;(powerline-default-theme)


;; NEOTREE, open root consistent with projectile
(require 'neotree)
(defun neotree-project-dir ()
  "Open NeoTree using the git root."
  (interactive)
  (let ((project-dir (projectile-project-root))
	(file-name (buffer-file-name)))
    (neotree-toggle)
    (if project-dir
	(if (neo-global--window-exists-p)
	    (progn
	      (neotree-dir project-dir)
	      (neotree-find file-name)))
     (message "Could not find git project root."))))

(global-set-key [f8] 'neotree-project-dir)


;highligt indents
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-delay 0)
(setq highlight-indent-guides-method 'character)
(setq highlight-indent-guides-responsive 'top)

;; autocomplete paired brackets
;;(electric-pair-mode 1)

;; PROJECTILE
(require 'projectile)
;;(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)
(setq projectile-completion-system 'ivy)

;;company
(setq company-idle-delay 0.0)
(setq company-show-numbers t)
(setq company-tooltip-limit 10)
(setq company-minimum-prefix-length 1)
(setq company-tooltip-align-annotations t)
;; invert the navigation direction if the the completion popup-isearch-match
;; is displayed on top (happens near the bottom of windows)
(setq company-tooltip-flip-when-above t)
(setq company-selection-wrap-around t)
;;(global-company-mode 1)


;;IVY
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")


;; enable IDO
;(ido-mode t)
;(setq ido-enable-flex-matching t
;      ido-use-virtual-buffers t)


;; selection and clipoard
(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

;; key binding
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-x g") 'magit-status)

;; centaur tabs
;(require 'centaur-tabs)
;(centaur-tabs-mode t)
;(global-set-key (kbd "C-<prior>")  'centaur-tabs-backward)
;(global-set-key (kbd "C-<next>") 'centaur-tabs-forward)


; ----markdown mode
(autoload 'markdown-mode "markdown-mode.el"
   "Major mode for editing Markdown files" t)
(setq auto-mode-alist
   (cons '("\.md" . markdown-mode) auto-mode-alist))

;yaml
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\.yml\'" . yaml-mode))
(add-hook 'yaml-mode-hook
      '(lambda ()
       (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;flycheck
(require 'flycheck)
(add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++11")))


;; (setq flycheck-highlighting-mode 'lines)
; LSP for rust
(require 'rust-mode)
(require 'lsp-ui)

(require 'company-lsp)
(require 'lsp-mode)
(add-hook 'rust-mode-hook #'lsp)

;; tell company to complete on tabs instead of sitting there like a moron
;;(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)

;; autocompletions for lsp (available with melpa enabled)
;;;(require 'company-lsp)
;;;;(push 'company-lsp company-backends)

;;Python
(require 'elpy)
(elpy-enable)
(when (load "flycheck" t t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
(setq elpy-modules (delq 'elpy-module-highlight-indentation elpy-modules))


(add-to-list 'flycheck-disabled-checkers 'python-pylint)

;(define-key python-mode-map (kbd "TAB") #'company-indent-or-complete-common)
(setq tab-always-indent 'complete)


(setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
             "jupyter")

(advice-add 'elpy-shell--insert-and-font-lock
            :around (lambda (f string face &optional no-font-lock)
                      (if (not (eq face 'comint-highlight-input))
                          (funcall f string face no-font-lock)
                        (funcall f string face t)
                        (python-shell-font-lock-post-command-hook))))

(advice-add 'comint-send-input
            :around (lambda (f &rest args)
                      (if (eq major-mode 'inferior-python-mode)
                          (cl-letf ((g (symbol-function 'add-text-properties))
                                    ((symbol-function 'add-text-properties)
                                     (lambda (start end properties &optional object)
                                       (unless (eq (nth 3 properties) 'comint-highlight-input)
                                         (funcall g start end properties object)))))
                            (apply f args))
                        (apply f args))))



;; auctex - configuration
(load "auctex.el" nil t t)
(setq TeX-parse-self t) ; Enable parse on load.
(setq TeX-auto-save t) ; Enable parse on save.
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)


;; -- general config

(setq-default font-lock-maximum-decoration t)

(global-font-lock-mode t)
(column-number-mode t)
(line-number-mode t)
(require 'paren)
(show-paren-mode)
(setq show-paren-delay 0)

;pour suprimer selection avec touche
(delete-selection-mode t)

;; ============================
;; Set up which modes to use for which file extensions
;; ============================
(setq auto-mode-alist
      (append
       '(
         ("\\.h$"             . c++-mode)
	 ("\\.cu$"            . c++-mode)
         ("\\.dps$"           . pascal-mode)
         ("\\.py$"            . python-mode)
         ("\\.Xdefaults$"     . xrdb-mode)
         ("\\.Xenvironment$"  . xrdb-mode)
         ("\\.Xresources$"    . xrdb-mode)
         ("\\.tei$"           . xml-mode)
         ("\\.php$"           . php-mode)
         ) auto-mode-alist))


;;##########################################################
;; Langue
(set-terminal-coding-system 'utf-8)
;(set-keyboard-coding-system 'utf-8)
(set-language-environment 'UTF-8)

(tool-bar-mode -1)


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

;; Autre type de completion pour le mini-buffer
;; (icomplete-mode 99)

;; Alias y pour yes et n pour no
(defalias 'yes-or-no-p 'y-or-n-p)



(setq colon-double-space nil)
(setq sentence-end-double-space nil)



(put 'narrow-to-region 'disabled nil)

;(require 'ucs-tables)
(unify-8859-on-decoding-mode 1)
(unify-8859-on-encoding-mode 1) 


(setq flyspell-default-dictionary "francais") 

(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "M-y") 'counsel-yank-pop)
;(global-set-key (kbd "<f1> f") 'counsel-describe-function)
;(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
;(global-set-key (kbd "<f1> l") 'counsel-find-library)
;(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
;(global-set-key (kbd "<f2> j") 'counsel-set-variable)
(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "C-c v") 'ivy-push-view)
(global-set-key (kbd "C-c V") 'ivy-pop-view)


(global-set-key "\C-t" 'transpose-sexps)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(auctex centaur-tabs counsel swiper magit rust-mode projectile powerline neotree material-theme lsp-ui ivy imenu-list flycheck-rust elpy company-lsp autopair)))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "ADBO" :slant normal :weight normal :height 91 :width normal))))
 '(line-number-current-line ((t (:inherit default :foreground "chartreuse")))))
