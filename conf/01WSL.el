; mozc, mozc-im, mozc-popup is neccesary.
(custom-set-variables
  '(package-selected-packages
   (quote
    (mozc-popup mozc-im mozc))))

;;font
;; デフォルト フォント
(set-face-attribute 'default nil :family "Migu 2M" :height 100)
;; プロポーショナル フォント
(set-face-attribute 'variable-pitch nil :family "Migu 2M" :height 100)
;; 等幅フォント
(set-face-attribute 'fixed-pitch nil :family "Migu 2M" :height 100)
;; ツールチップ表示フォント
(set-face-attribute 'tooltip nil :family "Migu 2M" :height 80)

;; Japanese Input for WSL
(require 'mozc-im)
(require 'mozc-popup)
(require 'mozc-cursor-color)

(setq default-input-method "japanese-mozc-im")

;; popupスタイル を使用する
(setq mozc-candidate-style 'popup)

;; カーソルカラーを設定する
(setq mozc-cursor-color-alist '((direct        . "red")
                                (read-only     . "yellow")
                                (hiragana      . "green")
                                (full-katakana . "goldenrod")
                                (half-ascii    . "dark orchid")
                                (full-ascii    . "orchid")
                                (half-katakana . "dark goldenrod")))

;; カーソルの点滅を OFF にする
(blink-cursor-mode 0)

;; C-o で IME をトグルする
(global-set-key (kbd "C-o") 'toggle-input-method)
(define-key isearch-mode-map (kbd "C-o") 'isearch-toggle-input-method)

;; mozc-cursor-color を利用するための対策
(make-variable-buffer-local 'mozc-im-mode)
(add-hook 'mozc-im-activate-hook (lambda () (setq mozc-im-mode t)))
(add-hook 'mozc-im-deactivate-hook (lambda () (setq mozc-im-mode nil)))

(advice-add 'mozc-cursor-color-update
            :around (lambda (orig-fun &rest args)
                      (let ((mozc-mode mozc-im-mode))
                        (apply orig-fun args))))

;; isearch を利用する前後で IME の状態を維持するための対策
(add-hook 'isearch-mode-hook
          (lambda ()
            (setq im-state mozc-im-mode)))
(add-hook 'isearch-mode-end-hook
          (lambda ()
            (unless (eq im-state mozc-im-mode)
              (if im-state
                  (activate-input-method default-input-method)
                (deactivate-input-method)))))

;; wdired 終了時に IME を OFF にする
(require 'wdired)
(advice-add 'wdired-finish-edit
            :after (lambda (&rest args)
                     (deactivate-input-method)))

;; Windows の mozc では、セッション接続直後 directモード になるので hiraganaモード にする
(advice-add 'mozc-session-execute-command
            :after (lambda (&rest args)
                     (when (eq (nth 0 args) 'CreateSession)
                       ;; (mozc-session-sendkey '(hiragana)))))
                       (mozc-session-sendkey '(Hankaku/Zenkaku)))))
(setq mozc-helper-program-name "mozc_emacs_helper.sh")
