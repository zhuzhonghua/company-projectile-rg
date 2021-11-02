
(defun company-pr-match-string (arg line)
	"match request parameter"
	;;(message "cr-match-string %s %s" arg line)
	(if (string-match (format "\\([a-zA-Z_\\-]*%s[a-zA-Z_\\-]*\\)" arg) line)
			(match-string 0 line)
		""))

(defun company-pr-split-candidates (arg lines)
	"split the result by line end"
	(mapcar '(lambda (line) (company-pr-match-string arg line))
					(split-string lines "[\r\n]")))

(defun company-pr-get-candidates (arg)
	(if (projectile-project-root)
			(delete-dups
			 (company-pr-split-candidates arg
														(shell-command-to-string (format "rg %s %s"
																														 arg
																														 (projectile-project-root)))))))
		;;(progn
		;;	(message "not in a projectile project or just close company-rg-projectile")
		;;	nil)))

(defun company-projectile-rg (command &optional arg &rest ignored)
	"company-projectile-rg backend for rg"
	(interactive (list 'interactive))
	(cl-case command
    (interactive (company-begin-backend 'company-projectile-rg))
		(prefix (and (not (company-in-string-or-comment))
								 (company-grab-symbol)))
		(candidates (company-pr-get-candidates arg))
		(meta (format "This value is named %s" arg))
		(no-cache t)
		(sorted t)))

(provide 'company-projectile-rg)
