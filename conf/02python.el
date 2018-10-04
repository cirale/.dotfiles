;; company-jedi
(require 'jedi-core)
(setq jedi:complete-on-dot t)
(setq jedi:use-shortcuts t)
(add-hook 'python-mode-hook 'jedi:setup)
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-jedi))
;; pyflakes
(add-hook 'python-mode-hook
          '(lambda()
             (require 'flymake-python-pyflakes)
             (flymake-mode t)
             (flymake-python-pyflakes-load)))
