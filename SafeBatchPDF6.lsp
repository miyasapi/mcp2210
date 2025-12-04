(defun c:SafeBatchPDF6 (/ folder filelist acadObj doc plot pdfname fullpath oldbgp layout)
  (vl-load-com)

  (setq folder "C:\\draw\\") ;; 図面 & PDF 出力フォルダ
  (setq filelist (vl-directory-files folder "*.dwg" 1))
  (setq acadObj (vlax-get-Acad-Object))

  ;; バックグラウンドプロットを一時的にOFF
  (setq oldbgp (getvar "BACKGROUNDPLOT"))
  (setvar "BACKGROUNDPLOT" 0)

  (foreach f filelist
    (setq fullpath (strcat folder f))
    (vl-catch-all-apply
      '(lambda ()
         ;; ★ 図面を開いて、その戻り値を doc に入れる
         (setq doc (vla-Open (vla-get-Documents acadObj) fullpath))
         (vla-Activate doc)

         ;; Model レイアウトをアクティブに
         (setq layout (vla-Item (vla-get-Layouts doc) "Model"))
         (vla-put-ActiveLayout doc layout)

         ;; Plot オブジェクト取得
         (setq plot (vla-get-Plot doc))

         ;; PDFファイル名
         (setq pdfname (strcat folder (vl-filename-base f) ".pdf"))

         ;; PDF出力
         (vla-PlotToFile plot pdfname "DWG To PDF.pc3")
         (princ "\nfile name: ")
         (princ pdfname)

         ;; 保存せずクローズ
         (vla-Close doc :vlax-false)
       )
    )
  )

  ;; BACKGROUNDPLOT を元に戻す
  (setvar "BACKGROUNDPLOT" oldbgp)

  (princ "\nPDF出力完了！")
  (princ)
)
