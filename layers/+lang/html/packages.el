;;; packages.el --- HTML Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq html-packages
  '(
    company
    company-web
    css-mode
    emmet-mode
    evil-matchit
    flycheck
    haml-mode
    helm-css-scss
    jade-mode
    less-css-mode
    sass-mode
    scss-mode
    slim-mode
    smartparens
    tagedit
    web-mode
    yasnippet
    ))

(when (configuration-layer/layer-usedp 'auto-completion)
  ;;TODO: whenever company-web makes a backend for haml-mode it should be added here. -- @robbyoconnor
  (defun html/post-init-company ()
    (spacemacs|add-company-hook css-mode)
    (spacemacs|add-company-hook jade-mode)
    (spacemacs|add-company-hook slim-mode)
    (spacemacs|add-company-hook web-mode))

  (defun html/init-company-web ()
    (use-package company-web)))

(defun html/init-css-mode ()
  (use-package css-mode
    :defer t
    :init
    (progn
      (push 'company-css company-backends-css-mode)

      ;; Mark `css-indent-offset' as safe-local variable
      (put 'css-indent-offset 'safe-local-variable #'integerp)

      ;; Explicitly run prog-mode hooks since css-mode does not derive from
      ;; prog-mode major-mode
      (add-hook 'css-mode-hook 'spacemacs/run-prog-mode-hooks)

      (defun css-expand-statement ()
        "Expand CSS block"
        (interactive)
        (save-excursion
          (end-of-line)
          (search-backward "{")
          (forward-char 1)
          (while (or (eobp) (not (looking-at "}")))
          (let ((beg (point)))
            (newline)
            (search-forward ";")
            (indent-region beg (point))
            ))
          (newline)))

      (defun css-contract-statement ()
        "Contract CSS block"
        (interactive)
        (end-of-line)
        (search-backward "{")
        (while (not (looking-at "}"))
          (join-line -1)))

      (spacemacs/set-leader-keys-for-major-mode 'css-mode
        "zc" 'css-contract-statement
        "zo" 'css-expand-statement))))

(defun html/init-emmet-mode ()
  (use-package emmet-mode
    :defer t
    :init (spacemacs/add-to-hooks 'emmet-mode '(css-mode-hook
                                                html-mode-hook
                                                sass-mode-hook
                                                scss-mode-hook
                                                web-mode-hook))
    :config
    (progn
      (evil-define-key 'insert emmet-mode-keymap (kbd "TAB") 'emmet-expand-yas)
      (evil-define-key 'insert emmet-mode-keymap (kbd "<tab>") 'emmet-expand-yas)
      (evil-define-key 'emacs emmet-mode-keymap (kbd "TAB") 'emmet-expand-yas)
      (evil-define-key 'emacs emmet-mode-keymap (kbd "<tab>") 'emmet-expand-yas)
      (evil-define-key 'hybrid emmet-mode-keymap (kbd "TAB") 'emmet-expand-yas)
      (evil-define-key 'hybrid emmet-mode-keymap (kbd "<tab>") 'emmet-expand-yas)
      (spacemacs|hide-lighter emmet-mode))))

(defun html/post-init-evil-matchit ()
  (add-hook 'web-mode-hook 'turn-on-evil-matchit-mode))

(defun html/post-init-flycheck ()
  (dolist (mode '(haml-mode
                  jade-mode
                  less-mode
                  sass-mode
                  scss-mode
                  slim-mode
                  web-mode))
    (spacemacs/add-flycheck-hook mode)))

(defun html/init-haml-mode ()
  (use-package haml-mode
    :defer t))

(when (configuration-layer/layer-usedp 'spacemacs-helm)
  (defun html/init-helm-css-scss ()
    (use-package helm-css-scss
      :defer t
      :init
      (dolist (mode '(css-mode scss-mode))
        (spacemacs/set-leader-keys-for-major-mode mode "gh" 'helm-css-scss)))))

(defun html/init-jade-mode ()
  (use-package jade-mode
    :defer t
    :mode
    ("\\.pug$" . jade-mode)
    :init
    ;; Explicitly run prog-mode hooks since jade-mode does not derivate from
    ;; prog-mode major-mode
    (add-hook 'jade-mode-hook 'spacemacs/run-prog-mode-hooks)))

(defun html/init-less-css-mode ()
  (use-package less-css-mode
    :defer t
    :mode ("\\.less\\'" . less-css-mode)))

(defun html/init-sass-mode ()
  (use-package sass-mode
    :defer t
    :mode ("\\.sass\\'" . sass-mode)))

(defun html/init-scss-mode ()
  (use-package scss-mode
    :defer t
    :mode ("\\.scss\\'" . scss-mode)))

(defun html/init-slim-mode ()
  (use-package slim-mode
    :defer t))

(defun html/post-init-smartparens ()
  (spacemacs/add-to-hooks
   (if dotspacemacs-smartparens-strict-mode
       'smartparens-strict-mode
     'smartparens-mode)
   '(css-mode-hook scss-mode-hook sass-mode-hook less-css-mode-hook))

  (add-hook 'web-mode-hook 'spacemacs/toggle-smartparens-off))

(defun html/init-tagedit ()
  (use-package tagedit
    :defer t
    :config
    (progn
      (tagedit-add-experimental-features)
      (add-hook 'html-mode-hook (lambda () (tagedit-mode 1)))
      (spacemacs|diminish tagedit-mode " Ⓣ" " T"))))

(defun html/init-web-mode ()
  (use-package web-mode
    :defer t
    :init
    (push '(company-web-html company-css) company-backends-web-mode)
    :config
    (progn
      (spacemacs/set-leader-keys-for-major-mode 'web-mode
        "eh" 'web-mode-dom-errors-show
        "gb" 'web-mode-element-beginning
        "gc" 'web-mode-element-child
        "gp" 'web-mode-element-parent
        "gs" 'web-mode-element-sibling-next
        "hp" 'web-mode-dom-xpath
        "rc" 'web-mode-element-clone
        "rd" 'web-mode-element-vanish
        "rk" 'web-mode-element-kill
        "rr" 'web-mode-element-rename
        "rw" 'web-mode-element-wrap
        "z" 'web-mode-fold-or-unfold
        ;; TODO element close would be nice but broken with evil.
        )

      ;; (defvar spacemacs--web-mode-ms-doc-toggle 0
      ;;   "Display a short doc when nil, full doc otherwise.")

  ;;     (defun spacemacs//web-mode-ms-doc ()
  ;;       (if (equal 0 spacemacs--web-mode-ms-doc-toggle)
  ;;           "[_?_] for help"
  ;;         "
  ;; [_?_] display this help
  ;; [_k_] previous [_j_] next   [_K_] previous sibling [_J_] next sibling
  ;; [_h_] parent   [_l_] child  [_c_] clone [_d_] delete [_D_] kill [_r_] rename
  ;; [_w_] wrap     [_p_] xpath
  ;; [_q_] quit"))

  ;;     (defun spacemacs//web-mode-ms-toggle-doc ()
  ;;       (interactive)
  ;;       (setq spacemacs--web-mode-ms-doc-toggle
  ;;             (logxor spacemacs--web-mode-ms-doc-toggle 1)))

      (spacemacs|define-transient-state web-mode
        :title "Web-mode Transient State"
        :columns 4
        :foreign-keys run
        :bindings
        ("j" web-mode-element-next "next")
        ("J" web-mode-element-sibling-next "next sibling")
        ("gj" web-mode-element-sibling-next)
        ("k" web-mode-element-previous "previous")
        ("K" web-mode-element-sibling-previous "previous sibling")
        ("gk" web-mode-element-sibling-previous)
        ("h" web-mode-element-parent "parent")
        ("l" web-mode-element-child "child")
        ("c" web-mode-element-clone "clone")
        ("d" web-mode-element-vanish "delete")
        ("D" web-mode-element-kill "kill")
        ("r" web-mode-element-rename "rename" :exit t)
        ("w" web-mode-element-wrap "wrap")
        ("p" web-mode-dom-xpath "xpath")
        ("q" nil "quit" :exit t)
        ("<escape>" nil nil :exit t))
      (spacemacs/set-leader-keys-for-major-mode 'web-mode
        "." 'spacemacs/web-mode-transient-state/body))

    :mode
    (("\\.phtml\\'"      . web-mode)
     ("\\.tpl\\.php\\'"  . web-mode)
     ("\\.twig\\'"       . web-mode)
     ("\\.html\\'"       . web-mode)
     ("\\.htm\\'"        . web-mode)
     ("\\.[gj]sp\\'"     . web-mode)
     ("\\.as[cp]x?\\'"   . web-mode)
     ("\\.eex\\'"        . web-mode)
     ("\\.erb\\'"        . web-mode)
     ("\\.mustache\\'"   . web-mode)
     ("\\.handlebars\\'" . web-mode)
     ("\\.hbs\\'"        . web-mode)
     ("\\.eco\\'"        . web-mode)
     ("\\.ejs\\'"        . web-mode)
     ("\\.djhtml\\'"     . web-mode))))

(defun html/post-init-yasnippet ()
  (spacemacs/add-to-hooks 'spacemacs/load-yasnippet '(css-mode-hook
                                                      jade-mode
                                                      slim-mode)))
