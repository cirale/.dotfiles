;Jedi, flymake-python-pyflakes is necessary.
; "pip install pyflakes" is necessary.
(add-hook 'python-mode-hook
          '(lambda ()
	     (jedi:setup)
	     (define-key jedi-mode-map (kbd "<C-tab>") nil) 
	     (setq jedi:complete-on-dot t)
	     (setq ac-sources
		   (delete 'ac-source-words-in-same-mode-buffers ac-sources))
	     (add-to-list 'ac-sources 'ac-source-filename)
	     (add-to-list 'ac-sources 'ac-source-jedi-direct)
	     (define-key python-mode-map "\C-ct" 'jedi:goto-definition)
	     (define-key python-mode-map "\C-cb" 'jedi:goto-definition-pop-marker)
	     (define-key python-mode-map "\C-cr" 'helm-jedi-related-names)
	     
	     (flymake-mode t)
	     (require 'flymake-python-pyflakes)
	     (flymake-python-pyflakes-load)
	   )
	  
)
