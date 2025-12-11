(vl-load-com)

(defun cPDF5143 (  acad docs doc plot pc3 folder fname fullpath pdfPath lays lay )

  ;; ★1 フォルダとファイル名（ここが条件）
  (setq folder  Cdraw)           ; ← バックスラッシュは2つ
  (setq fname   6R3A5143.dwg)
  (setq fullpath (strcat folder fname)) ; Cdraw6R3A5143.dwg

  ;; ★2 AutoCAD  ドキュメント取得
  (setq acad (vlax-get-acad-object))
  (setq docs (vla-get-Documents acad))

  ;; ★3 図面を開く
  (princ (strcat n開いて出力します  fullpath))
  (setq doc (vla-open docs fullpath))

  ;; ★4 プロッタ(PC3)の指定
  (setq pc3 DWG To PDF.pc3)           ; AutoCAD標準のPDF出力

  ;; モデルレイアウトを取得して、出力先デバイスをPDFにする
  (setq lays (vla-get-Layouts doc))
  (setq lay  (vla-Item lays Model))
  (vla-put-ConfigName lay pc3)

  ;; ★5 出力先PDFファイル名
  (setq pdfPath (strcat folder 6R3A5143.pdf))

  ;; ★6 プロットしてPDF出力
  (setq plot (vla-get-Plot doc))
  (vla-RefreshPlotDeviceInfo plot)
  (princ (strcat nPDF出力中  pdfPath))
  (vla-PlotToFile plot pdfPath pc3)

  ;; ★7 図面を保存せずに閉じる
  (vla-Close doc vlax-false)

  (princ (strcat n完了しました  pdfPath))
  (princ)
)
