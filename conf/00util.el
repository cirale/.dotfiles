;; インストール済みパッケージのインポート/エクスポート
(defun save-installed-packages ()
  "Creates a file named ~/.emacs.d/emacs-packages containing all activated emacs packages."
  (interactive)
  (setq export-filename "~/.emacs.d/emacs-packages")
  (if (file-exists-p export-filename) (delete-file export-filename))
  (dolist (x package-activated-list)
    (append-to-file
     (format "%s\r\n" (symbol-name x))
     nil export-filename))
  (message "Done writing export file."))

(defun restore-packages ()
  "Installs packages listed in ~/.emacs.d/emacs-packages."
  (interactive)
  (setq export-filename "~/.emacs.d/emacs-packages")
  (if (file-exists-p export-filename)
      (mapcar
       (lambda (package)
         (package-install 'package))
       (with-temp-buffer
         (insert-file-contents export-filename)
         (split-string (buffer-string) "\n" t))
       )
    (message (format "Could not find %s. Cancelling package import." export-filename)))
  )
