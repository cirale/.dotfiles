(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-linum-mode t)
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(setq delete-auto-save-files t)
(set-default-coding-systems 'utf-8-unix)
(setq default-file-name-coding-system 'japanese-cp932-dos)
(setq load-path
      (append (list nil
		    (expand-file-name "~/.emacs.d/lib/emacs/"))
	      load-path))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; tabbar-mode: バッファ上部にタブを表示する
;   
; - 参考ページ 
; -- EmacsWiki - Tab Bar Mode:
;      http://www.emacswiki.org/cgi-bin/wiki/TabBarMode
; -- 見た目の変更 - Amit's Thoughts: Emacs: buffer tabs:
;      http://amitp.blogspot.com/2007/04/emacs-buffer-tabs.html
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; scratch buffer 以外をまとめてタブに表示する
(require 'cl) ; for emacs-22.0.50 on Vine Linux 4.2
 (when (require 'tabbar nil t)
    (setq tabbar-buffer-groups-function
	  (lambda (b) (list "All Buffers")))
    (setq tabbar-buffer-list-function
          (lambda ()
            (remove-if
             (lambda(buffer)
               (find (aref (buffer-name buffer) 0) " *"))
             (buffer-list))))
    (tabbar-mode))

;; Ctrl-Tab, Ctrl-Shift-Tab でタブを切り替える
  (dolist (func '(tabbar-mode tabbar-forward-tab tabbar-forward-group tabbar-backward-tab tabbar-backward-group))
    (autoload func "tabbar" "Tabs at the top of buffers and easy control-tab navigation"))
  (defmacro defun-prefix-alt (name on-no-prefix on-prefix &optional do-always)
    `(defun ,name (arg)
       (interactive "P")
       ,do-always
       (if (equal nil arg)
  	 ,on-no-prefix
         ,on-prefix)))
  (defun-prefix-alt shk-tabbar-next (tabbar-forward-tab) (tabbar-forward-group) (tabbar-mode 1))
  (defun-prefix-alt shk-tabbar-prev (tabbar-backward-tab) (tabbar-backward-group) (tabbar-mode 1))
  (global-set-key [(control tab)] 'shk-tabbar-next)
  (global-set-key [(control shift tab)] 'shk-tabbar-prev)

;; 外観変更
 (set-face-attribute
   'tabbar-default-face nil
   :background "gray60")
  (set-face-attribute
   'tabbar-unselected-face nil
   :background "gray85"
   :foreground "gray30"
   :box nil)
  (set-face-attribute
   'tabbar-selected-face nil
   :background "#f2f2f6"
   :foreground "black"
   :box nil)
  (set-face-attribute
   'tabbar-button-face nil
   :box '(:line-width 1 :color "gray72" :style released-button))
  (set-face-attribute
   'tabbar-separator-face nil
   :height 0.7)

;; F4 で tabbar-mode
(global-set-key [f4] 'tabbar-mode)

;; flymake C/C++
(require 'flymake)
(defun flymake-cc-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "g++" (list "-Wall" "-Wextra" "-fsyntax-only" "-std=c++11" local-file))))
 
(push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)
 
(add-hook 'c++-mode-hook
          '(lambda ()
             (flymake-mode t)))
 
(require 'flymake)
(defun flymake-c-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "gcc" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))
 
(push '("\\.c$" flymake-c-init) flymake-allowed-file-name-masks)
 
(add-hook 'c-mode-hook
          '(lambda ()
             (flymake-mode t)))
