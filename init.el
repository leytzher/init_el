
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "CaskaydiaCove Nerd Font" :foundry "nil" :slant normal :weight regular :height 160 :width normal)))))

;; transparency
(set-frame-parameter nil 'alpha-background 75) ; For current frame
(add-to-list 'default-frame-alist '(alpha-background . 75)) ; For all new frames henceforth

;; setup relative numbers
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;; display battery for when in full screen mode
(display-battery-mode t)

(global-hl-line-mode 1)

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
	     '("gnu" . "https://elpa.gnu.org/packages/"))
(package-initialize)

;; configure use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-and-compile
  (setq use-package-always-ensure t
	use-package-expand-minimally t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-battery-mode t)
 '(display-line-numbers-type 'relative)
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
   '(marginalia vertico magit diredc org-download evil-org org-superstar org-bullets helm org-roam-ui sly org-roam lsp-mode projectile rainbow-blocks paredit ir-black-theme evil)))


(require 'evil)
(evil-mode 1)

(load-theme 'ir-black t)

(require 'rainbow-blocks)


(setq inferior-lisp-program "sbcl --dynamic-space-size 4096")


(add-hook 'after-init-hook 'global-company-mode)

;; company
(company-mode +1)

;; prjectile)
(projectile-mode +1)

;; paredit
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'lisp-mode-hook #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)

(add-hook 'lisp-mode-hook 'rainbow-blocks-mode)

(global-set-key (kbd "C-M-.") 'sly-edit-definition)
(global-set-key (kbd "C-M-,") 'sly-pop-find-definition-stack)

;; helm
;;; start helm
(helm-mode 1)
;;; bind helm-M-x to M-x
(global-set-key (kbd "M-x") 'helm-M-x)

;; setup org-mode
;;;;;;;
(setq org-startup-folded nil)
(setq org-startup-indented t)
(setq org-startup-with-inline-images t)
;;; setup org-superstar
(use-package org-superstar
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1))))
;;; setup evil org
(use-package evil-org
  :ensure t
  :after (evil org)
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
	    (lambda ()
	      (evil-org-set-key-theme '(navigation insert textobjects additional calendar)))))

;;; setup org-roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "/Users/leytzher/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents/SecondBrain/"))
  (org-roam-dailies-directory  "journals/")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(;; add templates, always keep the default.
     ("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)

     ))
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n g" . org-roam-graph)
	 ("C-c n i" . org-roam-node-insert)
	 ("C-c n I" . org-roam-node-insert-immediate)
	 ("C-c n c" . org-roam-capture)
	 ;; dailies
	 ("C-c n j" . org-roam-dailies-capture-today)
	 :map org-mode-map
	 ("C-M-i" . completion-at-point))
  :config
  (setq org-roam-node-display-template
	(concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  (require 'org-roam-protocol))

(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
	(org-roam-capture-templates (list (append (car org-roam-capture-templates) '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))


(require 'org-download)
(add-hook 'dired-mode-hook 'org-download-enable) 

(use-package org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
	org-roam-ui-follow t
	org-roam-ui-update-on-save t
	org-roam-ui-open-on-start t))

(add-hook 'text-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook 'visual-line-mode)


;; setup babel to code within org-mode
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (emacs-lisp . t)
   (shell . t)
   (gnuplot .t)
   (lisp . t)
   (python . t)
   (sql . t)))

;; setup vertico
(use-package vertico
  :ensure t
  :bind (:map vertico-map
	      ("C-j" . vertico-next)
	      ("C-k" . vertico-previous)
	      ("C-f" . vertico-exit)
	      :map minibuffer-local-map
	      ("M-h" . backward-kill-word))
  :custom
  (vertico--cycle t)
  :init
  (vertico-mode))


(use-package savehist
  :init
  (savehist-mode))

(use-package marginalia
  :after vertico
  :ensure t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil ))
  :init
  (marginalia-mode))

