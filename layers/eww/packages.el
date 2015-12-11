;;; packages.el --- eww Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Andrea Moretti <axyzxp@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.
(setq eww-packages
    '(
      eww
      eww-lnum
      ;; package names go here
      ))

;; List of packages to exclude.
(setq eww-excluded-packages '())

;; For each package, define a function eww/init-<package-name>
;;
;; (defun eww/init-my-package ()
;;   "Initialize my package"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package

(defun eww/init-eww ()
  (use-package eww
    :defer t
    :init
    (evil-leader/set-key "aw" 'eww)
    :config
    (evil-make-overriding-map eww-mode-map 'normal)
    (evil-define-key 'normal eww-mode-map
      "l" 'evil-forward-char
      "i" 'evil-insert
      "H" 'eww-back-url
      "L" 'eww-forward-url
      "f" 'eww-lnum-follow ;;ace-link-eww
      "F" 'eww-lnum-universal
      "o" 'eww
      "Y" 'eww-copy-page-url
      ;; "p" TODO: open url on clipboard
      "r" 'eww-reload
      ;; "b" TODO: helm buffer with bookmarks
      "a" 'eww-add-bookmark)))

(defun eww/init-eww-lnum ()
  (use-package eww-lnum
    :defer t))
