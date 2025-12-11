(vl-load-com)

(defun c:PDF5143 ( / acad docs doc plot pc3 folder fname fullpath pdfPath lays lay err )

  (setq folder  "C:/draw/")          ; C:\draw\ と同じ意味
  (setq fname   "6R3A5143.dwg")
  (setq fullpath (strcat folder fname))

  (princ (strcat "\n開く図面: " fullpath))

  (setq acad (vlax-get-acad-object))
  (setq docs (vla-get-Documents acad))

  (setq doc (vla-Open docs fullpath))

  ;; 使うPC3（手動プロットで確認できる名前にする）
  (setq pc3 "DWG To PDF.pc3")

  ;; Modelレイアウトの出力デバイスを設定
  (setq lays (vla-get-Layouts doc))
  (setq lay  (vla-Item lays "Model"))
  (vla-put-ConfigName lay pc3)

  ;; ★用紙サイズを固定したいとき（例：A3）
  ;; うまく行かなければ、この2行はコメントアウトして試す
  (vl-catch-all-apply
    '(lambda ()
       (vla-put-CanonicalMediaName lay "ISO_A3_(420.00_x_297.00_MM)")
     )
  )

  ;; 出力先PDF
  (setq pdfPath (strcat folder "6R3A5143.pdf"))

  ;; Plotオブジェクトを取得
  (setq plot (vla-get-Plot doc))

  ;; ★ここでエラーが出ていたので、いったん呼ばない
  ;; (vla-RefreshPlotDeviceInfo plot)

  (princ (strcat "\nPDF出力中: " pdfPath))

  ;; 念のためエラートラップしながらPDF出力
  (setq err
        (vl-catch-all-apply
          'vla-PlotToFile
          (list plot pdfPath pc3)
        )
  )

  (if (vl-catch-all-error-p err)
    (progn
      (princ "\nPDF出力でエラーが発生しました：")
      (princ (vl-catch-all-error-message err))
    )
    (princ (strcat "\nPDF出力完了: " pdfPath))
  )

  ;; 図面を保存せず閉じる
  (vla-Close doc :vlax-false)

  (princ)
)

(princ "\nPDF5143.lsp 読み込み完了。コマンド: PDF5143")
(princ)
