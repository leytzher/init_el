(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "CaskaydiaCove Nerd Font Propo" :foundry "nil" :slant normal :weight regular :height 160 :width normal)))))

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

;; Ivy, Counsel, and Swiper configuration
(use-package ivy
  :ensure t
  :diminish
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t))

(use-package counsel
  :ensure t
  :after ivy
  :config (counsel-mode 1))

(use-package swiper
  :ensure t
  :after ivy
  :bind (("C-s" . swiper)))



;; Evil mode configuration
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; NeoTree configuration
(use-package neotree
  :ensure t
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (setq neo-smart-open t)
  (setq neo-window-width 40)
  (setq neo-window-fixed-size nil)
  (setq neo-show-hidden-files t)
  
  ;; NeoTree Evil state
  (evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-quick-look)
  (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
  (evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "g") 'neotree-refresh)
  (evil-define-key 'normal neotree-mode-map (kbd "n") 'neotree-next-line)
  (evil-define-key 'normal neotree-mode-map (kbd "p") 'neotree-previous-line)
  (evil-define-key 'normal neotree-mode-map (kbd "A") 'neotree-stretch-toggle)
  (evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle))


;; Which-key for displaying available key bindings
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; General for better key binding management
(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")
    "tn" '(neotree-toggle :which-key "toggle neotree")
    "f"  '(:ignore f :which-key "files")
    "ff" '(counsel-find-file :which-key "find file")
    "fr" '(counsel-recentf :which-key "recent files")
    "p"  '(:ignore p :which-key "project")
    "pf" '(counsel-projectile-find-file :which-key "find file in project")
    "ps" '(counsel-projectile-switch-project :which-key "switch project")
    "b"  '(:ignore b :which-key "buffers")
    "bb" '(counsel-switch-buffer :which-key "switch buffer")
    "h"  '(:ignore h :which-key "help")
    "hk" '(which-key-show-top-level :which-key "show key tree")))

;; Clojure and ClojureScript support
(use-package clojure-mode
  :ensure t
  :mode (("\\.clj\\'" . clojure-mode)
         ("\\.cljs\\'" . clojurescript-mode)
         ("\\.cljc\\'" . clojurec-mode)))

(use-package cider
  :ensure t
  :after clojure-mode
  :config
  (setq cider-repl-display-help-banner nil))

;; remove any SLIME-related configurations if present
(setq lisp-mode-hook (remove 'slime-lisp-mode-hook lisp-mode-hook))

;; Common Lisp support
(use-package sly
  :ensure t
  :init
  (setq inferior-lisp-program "sbcl")
  :config
  (sly-setup)
  :hook (lisp-mode . sly-editing-mode)
  :bind (:map lisp-mode-map 
              ("C-c C-s" . sly)))

;; ParEdit for structural editing of Lisp code
(use-package paredit
  :ensure t
  :hook ((emacs-lisp-mode lisp-mode clojure-mode sly-mrepl-mode) . paredit-mode))

;; Rainbow delimiters for better visualization of nested parentheses
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(paredit-everywhere all-the-icons rainbow-delimiters which-key vertico sly slime rainbow-blocks projectile paredit org-superstar marginalia ir-black-theme helm general evil-org evil-collection company cider)))
