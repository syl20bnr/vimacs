;;; packages.el --- Java configuration File for Spacemacs
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Lukasz Klich <klich.lukasz@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; variables

(spacemacs|define-jump-handlers java-mode)

(defvar java-backend 'meghanada
  "The backend to use for IDE features. Possible values are `eclim', `ensime'
and `meghanada'.")

(defvar java--ensime-modes '(java-mode)
  "Modes using ensime. Mainly used to define ENSIME key bindings.")

(defvar java-enable-backend-company t
  "If non-nil enable company backends for the given java layer backend.
   Default: t.")

(defvar java-autoenable-backend nil
  "If non nil the chosen backend mode will be automatically activated when entering
   java mode.
   Default: nil.")
