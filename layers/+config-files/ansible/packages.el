;;; packages.el --- Ansible Layer extensions File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2015 Brian Hicks & Contributors
;;
;; Author: Brian Hicks <brian@brianthicks.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3
(setq ansible-packages
      '(ansible
        ansible-doc
        company
        yaml-mode))

(defun ansible/init-ansible ()
  (use-package ansible :defer t))

(defun ansible/init-ansible-doc ()
  (use-package ansible-doc :defer t))

(defun ansible/post-init-company ()
  ;; ansible-mode requires ac-user-dictionary-files. If the
  ;; config is using company-mode this variable will not be
  ;; set, so we set it to a dummy value.
  ;;
  ;; Tracking here:
  ;; https://github.com/k1LoW/emacs-ansible/issues/2
  (defvar ac-user-dictionary-files nil))

(defun ansible/post-init-yaml-mode ()
  (spacemacs/set-leader-keys-for-major-mode 'yaml-mode "ha" 'ansible-doc)
  (spacemacs/add-to-hook 'yaml-mode-hook '(ansible/ansible-maybe-enable
                                           ansible/ansible-doc-maybe-enable)))
