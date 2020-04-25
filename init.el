
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(require 'package)
(load "package")
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)


(defvar matt/packages '(projectile
			neotree
			ivy
			powerline
			material-theme
			rust-mode
			lsp-ui
			imenu-list
			flycheck-rust
			elpy
			company-lsp)
  "Default packages")



(load-theme 'material t)

(require 'powerline)
(powerline-default-theme)

(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

(require 'autopair)
(autopair-global-mode)

(require 'projectile)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)

;;company
(setq company-idle-delay 0.0)
(setq company-show-numbers t)
(setq company-tooltip-limit 10)
(setq company-minimum-prefix-length 1)
(setq company-tooltip-align-annotations t)
;; invert the navigation direction if the the completion popup-isearch-match
;; is displayed on top (happens near the bottom of windows)
(setq company-tooltip-flip-when-above t)




(global-company-mode 1)

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

; LSP for rust
(require 'rust-mode)
(require 'lsp-ui)

(require 'company-lsp)
(require 'lsp-mode)
(add-hook 'rust-mode-hook #'lsp)

;; tell company to complete on tabs instead of sitting there like a moron
(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)

;; autocompletions for lsp (available with melpa enabled)
(require 'company-lsp)
(push 'company-lsp company-backends)





;;PYthon
(require 'elpy)
(elpy-enable)
(when (load "flycheck" t t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;auctex
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)



(setq-default font-lock-maximum-decoration t)

(global-font-lock-mode t)
(column-number-mode t)
(line-number-mode t)
(require 'paren)
(show-paren-mode)


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
(setq ispell-dictionary "francais")


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

;; style de dates europ�en
(setq european-calendar-style t)

;; Des espaces pour indenter.
;; (setq indent-tabs-mode nil)

;; colle avec la souris l� o� se trouve le curseur et non l� o� on a cliqu�
(setq mouse-yank-at-point t)
(setq mouse-yank-at-click nil)




;; de jolis noms pour les buffers sur un meme *nom* de fichier
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; Autre type de completion pour le mini-buffer
(icomplete-mode 99)

;; Alias y pour yes et n pour no
(defalias 'yes-or-no-p 'y-or-n-p)



(setq colon-double-space nil)
(setq sentence-end-double-space nil)



(put 'narrow-to-region 'disabled nil)

;(require 'ucs-tables)
(unify-8859-on-decoding-mode 1)
(unify-8859-on-encoding-mode 1) 


(setq flyspell-default-dictionary "francais") 


(global-set-key "\C-t" 'transpose-sexps)




(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (projectile neotree smex helm ivy powerline material-theme rust-mode lsp-ui imenu-list flycheck-rust elpy eglot company-lsp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )