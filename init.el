(require 'package)


;; cider requires:
;;
;; clojure-mode-4.2.0
;; dash-2.11.0
;; pkg-info-0.4
;; emacs-24.3
;; queue-0.1.1
;; spinner-1.4
;; ERROR: CIDER's version (0.10.0-snapshot) does not match cider-nrepl's version (0.9.1). Things will break!
;; installed:
;;
;; dash-2.12.0
;; pkg-info-0.6
;; spinner-1.4
;; queue-0.1.1

(setq package-archives '(

			 ("gnu" . "http://elpa.gnu.org/packages/")

			 ;; cider=0.8.2
			 ("marmalade" . "http://marmalade-repo.org/packages/")

			 ("melpa" . "http://melpa.org/packages/")
			 ("melpa-stable" . "http://stable.melpa.org/packages/")
			 
			 ))

(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; http://stackoverflow.com/questions/9663396/how-do-i-make-emacs-recognize-bash-environment-variables-for-compilation
(let ((path (shell-command-to-string ". ~/.bash_profile; echo -n $PATH")))
  (setenv "PATH" path)
  (setq exec-path 
        (append
         (split-string-and-unquote path ":")
         exec-path)))

;; https://github.com/clojure-emacs/cider#installation
;(unless (package-installed-p 'cider)
;  (package-install 'cider))

;; http://emacswiki.org/emacs/SetFonts#toc14
(when (eq system-type 'darwin)

      ;; default Latin font (e.g. Consolas)
      (set-face-attribute 'default nil :family "Hack")

      ;; default font size (point * 10)
      ;;
      ;; WARNING!  Depending on the default font,
      ;; if the size is not supported very well, the frame will be clipped
      ;; so that the beginning of the buffer may not be visible correctly. 
      (set-face-attribute 'default nil :height 125)

      ;; use specific font for Korean charset.
      ;; if you want to use different font size for specific charset,
      ;; add :size POINT-SIZE in the font-spec.
;     ;; only works on graphical emacs on mac os x: not within terminal
;      (set-fontset-font t 'hangul (font-spec :name "NanumGothicCoding"))

      ;; you may want to add different for other charset in this way.
      )

(load-file "/Users/ekoontz/.emacs.d/sqlindent.el")

;; https://github.com/clojure-emacs/cider#installation
;(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))



(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)
;(ns-set-resource nil "ApplePressAndHoldEnabled" "YES")

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(add-hook
 'tuareg-mode-hook
 (lambda ()
   ;; Add opam emacs directory to the load-path
   (setq opam-share
	 (substring
	  (shell-command-to-string "opam config var share 2> /dev/null")
	  0 -1))
   (add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))
   ;; Load merlin-mode
   (require 'merlin)
   ;; Start merlin on ocaml files
   (add-hook 'tuareg-mode-hook 'merlin-mode t)
   (add-hook 'caml-mode-hook 'merlin-mode t)
   ;; Enable auto-complete
   (setq merlin-use-auto-complete-mode 'easy)
   ;; Use opam switch to lookup ocamlmerlin binary
   (setq merlin-command 'opam)
   (company-mode)
   (require 'ocp-indent)
   (autoload 'utop-minor-mode "utop" "Minor mode for utop" t)
   (autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
   (autoload 'merlin-mode "merlin" "Merlin mode" t)
   (utop-minor-mode)
   (company-quickhelp-mode)
   ;; Important to note that setq-local is a macro and it needs to be
   ;; separate calls, not like setq
   (setq-local merlin-completion-with-doc t)
   (setq-local indent-tabs-mode nil)
   (setq-local show-trailing-whitespace t)
   (setq-local indent-line-function 'ocp-indent-line)
   (setq-local indent-region-function 'ocp-indent-region)
   (if (equal system-type 'darwin)
       (load-file "/Users/ekoontz/.opam/working/share/emacs/site-lisp/ocp-indent.el")
     (load-file "/home/ekoontz/.opam/working/share/emacs/site-lisp/ocp-indent.el"))
   (merlin-mode)))

(add-hook 'utop-mode-hook (lambda ()
			    (set-process-query-on-exit-flag
			     (get-process "utop") nil)))

;; </ocaml-related>

;; <scala-related>
;(use-package ensime
;  :ensure t
;  :pin melpa-stable)

(add-to-list 'exec-path "/usr/local/bin")


;; make the command key a meta key! thanks to http://ergoemacs.org/emacs/emacs_hyper_super_keys.html
(setq mac-command-modifier 'meta)
