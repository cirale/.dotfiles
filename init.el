;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(global-linum-mode t)
 '(inhibit-startup-screen t)
 '(irony-additional-clang-options (quote ("-std=c++11")))
 '(package-selected-packages (quote (rainbow-delimiters mozc-popup mozc-im mozc)))
 '(show-paren-mode t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(set-language-environment "Japanese")
(set-default 'buffer-file-coding-system 'utf-8-with-signature)
(tool-bar-mode -1)
(set-default-coding-systems 'utf-8-unix)
(setq default-file-name-coding-system 'japanese-cp932-dos)
(setq load-path
      (append (list nil
		    (expand-file-name "~/.emacs.d/lib/")
		     (expand-file-name "~/.emacs.d/conf"))
	      load-path))

(load "01WSL")
(load "02python")
(load "03cpp")

; 一時ファイルを~/.emacs.d/tmpに作る
(setq backup-directory-alist '((".*" . "~/.emacs.d/tmp")))
(setq version-control t)
(setq kept-new-versions 3)
(setq delete-old-versions t)
(setq auto-save-file-name-transforms   '((".*" "~/.emacs.d/tmp/" t)))
(setq create-lockfiles nil)

; 保存時に行末のスペースを削除
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;mwim: コードの先頭・末尾にジャンプ
(global-set-key (kbd "C-a") 'mwim-beginning-of-code-or-line)
(global-set-key (kbd "C-e") 'mwim-end-of-code-or-line)

;C-hでbackspace
(keyboard-translate ?\C-h ?\C-?)

;自動閉じ括弧
(electric-pair-mode 1)

;サイズ
(setq default-frame-alist
  '(
    (width . 110)
    (height . 50)
   ))

;; 警告音もフラッシュも全て無効
(setq ring-bell-function 'ignore)

;; mini-bufferで大文字小文字を区別しない
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)


;; company-mode
(require 'company)
(global-company-mode 1)
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)
(setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
(global-set-key (kbd "C-M-i") 'company-complete)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-search-map (kbd "C-n") 'company-select-next)
(define-key company-search-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "<tab>") 'company-complete-selection)

(require 'yasnippet)
;; 既存スニペットを挿入する
(define-key yas-minor-mode-map (kbd "C-x i i") 'yas-insert-snippet)
;; 新規スニペットを作成するバッファを用意する
(define-key yas-minor-mode-map (kbd "C-x i n") 'yas-new-snippet)
;; 既存スニペットを閲覧・編集する
(define-key yas-minor-mode-map (kbd "C-x i v") 'yas-visit-snippet-file)

(yas-global-mode 1)

;; rainbow-delimiters:括弧ごとに色分け
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
;; 色変更
(require 'cl-lib)
(require 'color)
(cl-loop
 for index from 1 to rainbow-delimiters-max-face-count
 do
 (let ((face (intern (format "rainbow-delimiters-depth-%d-face" index))))
   (cl-callf color-saturate-name (face-foreground face) 30)))

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
