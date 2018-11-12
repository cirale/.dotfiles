(if load-file-name
    (setq user-emacs-directory (file-name-directory load-file-name)))
;; package.el
(require 'package)
(setq package-user-dir "~/.emacs.d/elisp/elpa/")
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)

(defvar my/packages
  '(company-irony
    company-jedi
    company
    dockerfile-mode
    flymake-cursor
    flymake-python-pyflakes
    flymake-easy
    irony
    jedi-core
    epc
    ctable
    concurrent
    monokai-theme
    mozc-im
    mozc-popup
    mozc
    mwim
    popup
    python-environment
    deferred
    rainbow-delimiters
    rust-mode
    s
    tabbar-ruler
    mode-icons
    powerline
    tabbar
    undo-tree
    undohist
    yasnippet-snippets
    yasnippet
    yaml-mode)
  "A list of packages to install from MELPA at launch.")

;; Install Melpa packages
(unless package-archive-contents (package-refresh-contents))
(dolist (package my/packages)
  (unless (package-installed-p package)
    (package-install package)))

(require 'monokai-theme)
(load-theme 'monokai t)

(set-language-environment "Japanese")
(set-default 'buffer-file-coding-system 'utf-8-with-signature)
(set-default-coding-systems 'utf-8-unix)
(setq default-file-name-coding-system 'japanese-cp932-dos)

(setq load-path
    (append (list nil
        (expand-file-name "~/.emacs.d/elisp/lib/")
        (expand-file-name "~/.emacs.d/conf"))
    load-path))
(load "01WSL")
(load "02python")
(load "03cpp")

;;ツールバー、メニューバーを表示しない
(tool-bar-mode -1)
(menu-bar-mode -1)

;;カーソル位置表示
(column-number-mode t)
;;行番号表示
(global-linum-mode t)
;;スタート画面を開かない
(setq inhibit-startup-screen t)
;;対応する括弧をハイライト
(show-paren-mode t)

;; 一時ファイルを~/.emacs.d/tmpに作る
(setq backup-directory-alist '((".*" . "~/.emacs.d/tmp")))
(setq version-control t)
(setq kept-new-versions 3)
(setq delete-old-versions t)
(setq auto-save-file-name-transforms   '((".*" "~/.emacs.d/tmp/" t)))
(setq create-lockfiles nil)

;; 保存時に行末のスペースを削除
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; mwim: コードの先頭・末尾にジャンプ
(global-set-key (kbd "C-a") 'mwim-beginning-of-code-or-line)
(global-set-key (kbd "C-e") 'mwim-end-of-code-or-line)

;; C-hでbackspace
(keyboard-translate ?\C-h ?\C-?)

;; 自動閉じ括弧
(electric-pair-mode 1)

;; サイズ
(setq default-frame-alist
  '((width . 110)
    (height . 50)))

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

;; 自動インデントでスペースを使う
(setq-default indent-tabs-mode nil)

;; タブ幅
(setq default-tab-width 2)

;; タブと全角スペースを可視化
(setq whitespace-style
      '(tabs tab-mark spaces space-mark))
(setq whitespace-space-regexp "\\(\x3000+\\)")
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□])
        (tab-mark   ?\t   [?\xBB ?\t])))
(require 'whitespace)
(global-whitespace-mode 1)
(set-face-foreground 'whitespace-space "LightSlateGray")
(set-face-background 'whitespace-space "DarkSlateGray")
(set-face-foreground 'whitespace-tab "LightSlateGray")
(set-face-background 'whitespace-tab "DarkSlateGray")

;; region がアクティブじゃない時は、C-wで前の一単語を削除
(defun backward-kill-word-or-kill-region ()
  (interactive)
  (if (or (not transient-mark-mode) (region-active-p))
      (kill-region (region-beginning) (region-end))
    (backward-kill-word 1)))
(global-set-key "\C-w" 'backward-kill-word-or-kill-region)

;;undo-tree
(require 'undo-tree)
(global-undo-tree-mode t)
(global-set-key (kbd "M-/") 'undo-tree-redo)

;;tabbar-mode
;; scratch buffer 以外をまとめてタブに表示する
(require 'tabbar)
(tabbar-mode 1)

;; グループ化しない
(setq tabbar-buffer-groups-function nil)

;; 左に表示されるボタンを無効化
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
                 (cons "" nil))))

(global-set-key (kbd "<C-tab>") 'tabbar-forward-tab)
(global-set-key (kbd "<C-iso-lefttab>") 'tabbar-backward-tab)

;; 外観変更
 (set-face-attribute
   'tabbar-default nil
   :background "gray60")
  (set-face-attribute
   'tabbar-unselected nil
   :background "gray85"
   :foreground "gray30"
   :box nil)
  (set-face-attribute
   'tabbar-selected nil
   :background "#f2f2f6"
   :foreground "black"
   :box nil)
  (set-face-attribute
   'tabbar-button nil
   :box '(:line-width 1 :color "gray72" :style released-button))
  (set-face-attribute
   'tabbar-separator nil
   :height 0.7)

(defvar my-tabbar-displayed-buffers
  '("*vc-")
  "*Regexps matches buffer names always included tabs.")

(defun my-tabbar-buffer-list ()
  "Return the list of buffers to show in tabs.
Exclude buffers whose name starts with a space or an asterisk.
The current buffer and buffers matches `my-tabbar-displayed-buffers'
are always included."
  (let* ((hides (list ?\  ?\*))
         (re (regexp-opt my-tabbar-displayed-buffers))
         (cur-buf (current-buffer))
         (tabs (delq nil
                     (mapcar (lambda (buf)
                               (let ((name (buffer-name buf)))
                                 (when (or (string-match re name)
                                           (not (memq (aref name 0) hides)))
                                   buf)))
                             (buffer-list)))))
    ;; Always include the current buffer.
    (if (memq cur-buf tabs)
        tabs
      (cons cur-buf tabs))))
(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)
;; F4 で tabbar-mode
(global-set-key [f4] 'tabbar-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (yaml-mode esup mode-icons mwim mozc-popup mozc-im irony flymake-python-pyflakes company))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
