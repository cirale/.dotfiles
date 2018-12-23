(add-hook 'c++-mode-hook 'flycheck-mode)
(add-hook 'c-mode-hook ' flycheck-mode)
(add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++11")))

(require 'irony)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(setq irony-additional-clang-options '("-std=c++11"))
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-irony)) ; backend追加
