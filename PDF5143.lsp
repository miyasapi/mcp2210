(vl-load-com)

(defun c:PDF5143 ( / acad docs doc plot pc3 folder fname fullpath pdfPath lays lay)

  ;; 対象DWGの場所と名前
  (setq folder  "C:/draw/")          ; ← C:\draw\ と同じ意味（/の方がLISPでは楽）
  (setq fname   "6R3A5143.dwg")
  (setq fullpath (strcat folder fname))   ; C:/draw/6R3A5143.dwg

  (princ (strcat "\n開く図面: " fullpath))

  ;; AutoCADアプリとドキュメントコレクション
  (setq acad (vlax-get-acad-object))
  (setq docs (vla-get-Documents acad))

  ;; 図面を開く
  (setq doc (vla-Open docs fullpath))

  ;; プロッタ(PC3)の指定
  (setq pc3 "DWG To PDF.pc3")        ; AutoCAD標準のPDF出力

  ;; モデルレイアウトをPDF出力に設定
  (setq lays (vla-get-Layouts doc))
  (setq lay  (vla-Item lays "Model"))
  (vla-put-ConfigName lay pc3)

  ;; 出力先PDFファイル名
  (setq pdfPath (strcat folder "6R3A5143.pdf"))

  ;; Plotオブジェクトを取得してPDF出力
  (setq plot (vla-get-Plot doc))
  (vla-RefreshPlotDeviceInfo plot)

  (princ (strcat "\nPDF出力中: " pdfPath))
  (vla-PlotToFile plot pdfPath pc3)

  ;; 図面を保存せず閉じる
  (vla-Close doc :vlax-false)

  (princ (strcat "\nPDF出力完了: " pdfPath))
  (princ)
)

(princ "\nPDF5143.lsp 読み込み完了。コマンド: PDF5143")
(princ)
