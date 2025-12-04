
(defun c:SafeBatchPDF (/ folder filelist acadObj doc plot pdfname)
  (setq folder "C:\\draw\\") ;; 出力フォルダ
  (setq filelist (vl-directory-files folder "*.dwg" 1))
  (setq acadObj (vlax-get-Acad-Object))

  (foreach f filelist
    (setq fullpath (strcat folder f))
    (vl-catch-all-apply
      '(lambda ()
         ;; 図面を開く
         (vla-Open (vla-get-Documents acadObj) fullpath)
         (setq doc (vla-get-ActiveDocument acadObj))
         
         ;; レイアウトをModelに設定
         (vla-put-ActiveSpace doc acModelSpace)

         ;; Plotオブジェクト取得
         (setq plot (vla-get-Plot doc))

         ;; PDFファイル名
         (setq pdfname (strcat folder (vl-filename-base f) ".pdf"))

         ;; 出力実行
         (vla-PlotToFile plot pdfname "DWG To PDF.pc3")
         (princ "file name")
         (princ pdfname)

         ;; 図面を閉じる（保存しない）
         (vla-Close doc :vlax-false)
      )
    )
  )
  (princ "\nPDF出力完了！")
)
