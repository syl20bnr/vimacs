;;; funcs.el --- HTML Layer functions File for Spacemacs
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defun spacemacs/emmet-expand ()
  (interactive)
  (unless (if (bound-and-true-p yas-minor-mode)
              (call-interactively 'emmet-expand-yas)
            (call-interactively 'emmet-expand-line))
    (indent-for-tab-command)))

(defun spacemacs/impatient-mode ()
  (interactive)
  (if (bound-and-true-p impatient-mode)
      (impatient-mode -1)
    (unless (process-status "httpd")
        (httpd-start))
    (impatient-mode)
    (when (string-match-p "\\.html\\'" (buffer-name))
      (imp-visit-buffer))))
