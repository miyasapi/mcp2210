(defun c:EXPORTCSV ( / ss lst rowlist sorted rows cols fp)
  (setq ss (ssget '((0 . "TEXT,MTEXT")))) ;文字だけ選択
  (if (not ss)
    (alert "文字が選択されていません。")
  )

  ;; 文字データ取得
  (setq lst '())
  (repeat (setq i (sslength ss))
    (setq ent (ssname ss (setq i (1- i))))
    (setq ed (entget ent))
    (setq pt (cdr (assoc 10 ed)))       ;挿入点
    (setq txt (cdr (assoc 1 ed)))       ;文字列
    (setq lst (cons (list txt (car pt) (cadr pt)) lst))
  )

  ;; Y座標で並べ替え（上→下）
  (setq sorted (vl-sort lst (function (lambda(a b)(> (caddr a)(caddr b))))))

  ;; 行ごとにグループ化（Yの近い値をまとめる）
  (setq rowlist '())
  (foreach item sorted
    (setq added nil)
    (foreach r rowlist
      (if (< (abs (- (caddr (car r)) (caddr item))) 1.0) ;許容誤差 1mm
        (progn
          (setq r (append r (list item)))
          (setq added T)
        )
      )
    )
    (if (not added)
      (setq rowlist (append rowlist (list (list item))))
    )
  )

  ;; 各行内をX座標で並べ替え
  (setq rows '())
  (foreach r rowlist
    (setq cols (vl-sort r (function (lambda(a b)(< (cadr a)(cadr b))))))
    (setq rows (append rows (list cols)))
  )

  ;; CSVファイルへ書き込み
  (setq fp (open "table_export.csv" "w"))
  (foreach r rows
    (write-line
      (apply 'strcat
             (mapcar '(lambda(x)(strcat (car x) ",")) r)
      )
      fp
    )
  )
  (close fp)

  (princ "\nCSVを書き出しました → table_export.csv")
  (princ)
)
