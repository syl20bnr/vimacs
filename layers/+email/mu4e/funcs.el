;;; funcs.el --- mu4e Layer functions File for Spacemacs
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defun mu4e/search-account-by-mail-address (mail-address)
  (car (rassoc-if (lambda (x)
                    (equal (cadr (assoc 'user-mail-address x)) mail-address))
                  mu4e-account-alist)))

(defun mu4e/set-account ()
  "Set the account for composing a message."
  (let* ((account
          (if mu4e-compose-parent-message
              (let* ((mailtos
                      (mu4e-message-field mu4e-compose-parent-message :to))
                     (mailto-account
                      (car (cl-remove-if-not 'identity
                                             (mapcar (lambda (x)
                                                       (mu4e/search-account-by-mail-address (cdr x)))
                                                     mailtos))))
                     (maildir
                      (mu4e-message-field mu4e-compose-parent-message :maildir))
                     (maildir-account
                      (progn
                        (string-match "/\\(.*?\\)/" maildir)
                        (match-string 1 maildir))))
                (or mailto-account maildir-account))
            (helm-comp-read
             "Compose with account:"
             (mapcar (lambda (var) (car var)) mu4e-account-alist))))
         (account-vars (cdr (assoc account mu4e-account-alist))))
    (if account-vars
        (mu4e//map-set account-vars)
      (error "No email account found"))))

(defun mu4e//map-set (vars)
  "Setq an alist VARS of variables and values."
  (mapc (lambda (var) (set (car var) (cadr var)))
        vars))

(defun mu4e/mail-account-reset ()
  "Reset mail account info to first."
  (mu4e//map-set (cdar mu4e-account-alist)))
