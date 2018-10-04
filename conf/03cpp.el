;; flymake C/C++
(require 'flymake)

(defun flymake-show-help ()
  (when (get-char-property (point) 'flymake-overlay)
    (let ((help (get-char-property (point) 'help-echo)))
      (if help (message "%s" help)))))
(add-hook 'post-command-hook 'flymake-show-help)

(defun flymake-cc-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "g++" (list "-Wall" "-Wextra" "-fsyntax-only" "-std=c++11" local-file))))

(push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)
(push '("\\.cc$"  flymake-cc-init) flymake-allowed-file-name-masks)
(push '("\\.hpp$" flymake-cc-init) flymake-allowed-file-name-masks)

(add-hook 'c++-mode-hook
          '(lambda ()
             (flymake-mode t)
             (flymake-cursor-mode t)
             (local-set-key "\C-c\C-v" 'flymake-start-syntax-check)
             (local-set-key "\C-c\C-p" 'flymake-goto-prev-error)
             (local-set-key "\C-c\C-n" 'flymake-goto-next-error)))

(defun flymake-c-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "gcc" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))

(push '("\\.c$" flymake-c-init) flymake-allowed-file-name-masks)
(push '("\\.h$" flymake-c-init) flymake-allowed-file-name-masks)

(add-hook 'c-mode-hook
          '(lambda ()
             (flymake-mode t)
             (flymake-cursor-mode t)
             (local-set-key "\C-c\C-v" 'flymake-start-syntax-check)
             (local-set-key "\C-c\C-p" 'flymake-goto-prev-error)
             (local-set-key "\C-c\C-n" 'flymake-goto-next-error)))

(require 'irony)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(setq irony-additional-clang-options '("-std=c++11"))
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-irony)) ; backend追加
