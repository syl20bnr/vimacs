;;; packages.el --- cedet Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defvar cedet-packages
  '(
    ;; package cedets go here
    stickyfunc-enhance
    )
  "List of all packages to install and/or initialize. Built-in packages
which require an initialization must be listed explicitly in the list.")

(unless (version< emacs-version "24.4")
  (add-to-list 'cedet-packages 'srefactor))

(defvar cedet-excluded-packages '()
  "List of packages to exclude.")

;; For each package, define a function cedet/init-<package-cedet>
;;
;; (defun cedet/init-my-package ()
;;   "Initialize my package"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
(defun cedet/enable-semantic-mode (mode)
  (let ((hook (intern (concat (symbol-name mode) "-hook"))))
    (add-hook hook (lambda ()
                     (require 'semantic)
                     (add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
                     (add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
                     ;; enable specific major mode setup before it can be used
                     ;; properly. For now, only Emacs Lisp.
                     (when (eq major-mode 'emacs-lisp-mode)
                       (semantic-default-elisp-setup)
                       (evil-leader/set-key-for-mode 'emacs-lisp-mode "mfb" 'srefactor-lisp-format-buffer)
                       (evil-leader/set-key-for-mode 'emacs-lisp-mode "mfd" 'srefactor-lisp-format-defun)
                       (evil-leader/set-key-for-mode 'emacs-lisp-mode "mfr" 'srefactor-lisp-format-sexp)
                       (evil-leader/set-key-for-mode 'emacs-lisp-mode "mfo" 'srefactor-lisp-one-line))
                     (semantic-mode 1)))))

(defun cedet/init-srefactor ()
  (use-package srefactor
    :defer t
    :init
    (progn
      (setq srecode-map-save-file (concat spacemacs-cache-directory "srecode-map.el"))
      (setq semanticdb-default-save-directory (concat spacemacs-cache-directory "semanticdb/"))
      (cedet/enable-semantic-mode 'emacs-lisp-mode))))

(defun cedet/init-stickyfunc-enhance ()
  (use-package stickyfunc-enhance
    :defer t
    :init
    (defun spacemacs/lazy-load-stickyfunc-enhance ()
      "Lazy load the package."
      (require 'stickyfunc-enhance))))
