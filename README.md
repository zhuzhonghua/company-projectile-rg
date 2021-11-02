# 基于projectile和rg写的company-backend

按照company-backend的格式定义company-projectile-rg

```
(defun company-projectile-rg (command &optional arg &rest ignored)
	"company-projectile-rg backend for rg"
	(interactive (list 'interactive))
	(cl-case command
    	(interactive (company-begin-backend 'company-projectile-rg))
```

基于模板，能复制的就复制，能修改的就修改

定义prefix，必须在非注释行下才有作用

```
(prefix (and (not (company-in-string-or-comment))
			(company-grab-symbol)))
(candidates (company-pr-get-candidates arg))
```

candidates 获取候选项列表

不在projectile功能内时，什么也不做

```
(defun company-pr-get-candidates (arg)
	(if (projectile-project-root)
		(delete-dups
			(company-pr-split-candidates 
				arg
				(shell-command-to-string (format "rg %s %s" 
												arg 
												(projectile-project-root)))))))
```

使用 "rg 候选词 搜索目录" 获取搜索结果，在使用 shell-command-to-string 转换为字符串，以供拆分候选项

```
(defun company-pr-split-candidates (arg lines)
	"split the result by line end"
	(mapcar '(lambda (line) (company-pr-match-string arg line))
			(split-string lines "[\r\n]")))
```

先根据行来分割

```
(defun company-pr-match-string (arg line)
	"match request parameter"
	;;(message "cr-match-string %s %s" arg line)
	(if (string-match (format "\\([a-zA-Z_\\-]*%s[a-zA-Z_\\-]*\\)" arg) line)
			(match-string 0 line)
		""))
```

针对每一行，根据正则表达式在候选词前后搜索整个单词作为候选项
