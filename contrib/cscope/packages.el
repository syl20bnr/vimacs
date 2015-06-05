;;; packages.el --- cscope Layer packages File for Spacemacs
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

(setq cscope-packages '(evil-jumper
                        helm-cscope
                        xcscope))

(setq cscope-excluded-packages '())

(defun cscope/post-init-evil-jump ()
  (defadvice helm-cscope-find-this-symbol (before cscope/goto activate)
    (evil-jumper--push)))

(defun cscope/init-helm-cscope ()
  (use-package helm-cscope
    :config
    (use-package xcscope
      :config
      ;; for python projects, we don't want xcscope to rebuild the databse,
      ;; because it uses cscope instead of pycscope
      (setq-default cscope-option-do-not-update-database t)
      (setq-default cscope-display-cscope-buffer nil)

      (defun cscope//safe-project-root ()
        "Return project's root, or nil if not in a project."
        (and (fboundp 'projectile-project-root)
             (projectile-project-p)
             (projectile-project-root)))

      (defun cscope/run-pycscope (directory)
        (interactive (list (file-name-as-directory
                            (read-directory-name "Run pycscope in directory: "
                                                 (cscope//safe-project-root)))))
        (let ((default-directory directory))
          (shell-command (format "pycscope -R -f '%s'"
                                 (expand-file-name "cscope.out" directory)))))

      (dolist (mode '(python-mode c-mode c++-mode))
        (evil-leader/set-key-for-mode mode
          "mgc" 'helm-cscope-find-called-function
          "mgC" 'helm-cscope-find-calling-this-funtcion
          "mgd" 'helm-cscope-find-global-definition
          "mge" 'helm-cscope-find-egrep-pattern
          "mgf" 'helm-cscope-find-this-file
          "mgF" 'helm-cscope-find-files-including-file
          "mgr" 'helm-cscope-find-this-symbol
          "mgx" 'helm-cscope-find-this-text-string))
      (evil-leader/set-key-for-mode 'python-mode "mgi" 'cscope/run-pycscope)
      (evil-leader/set-key-for-mode 'c-mode "mgi" 'cscope-index-files)
      (evil-leader/set-key-for-mode 'c++-mode "mgi" 'cscope-index-files))))

