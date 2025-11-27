(defun c:DWG2PDF (/ dwglist dwg pdf full)
  ;; C:\draw のDWG一覧取得
  (setq dwglist (vl-directory-files "C:/draw" "*.dwg" 1))

  ;; ダイアログ無効（完全自動処理のため）
  (setvar "FILEDIA" 0)

  ;; 1つずつ処理
  (foreach dwg dwglist
    ;; DWGのフルパス
    (setq full (strcat "C:/draw/" dwg))

    ;; 図面を開く（_.OPENは2023でも安定）
    (command "_.OPEN" full)

    ;; PDFファイル名（DWGと同じ名前）
    (setq pdf (strcat "C:/draw/" (vl-filename-base dwg) ".pdf"))

    ;; プロット→PDF出力
    (command "-PLOT"
             "Y"
             ""
             "DWG To PDF.pc3"
             ""
             ""
             "M"
             "L"
             "Y"
             "N"
             "N"
             pdf
             "Y")

    ;; ---- ★ 安定化のための待機（0.3秒） ----
    (vl-cmdf "_.DELAY" 300)

    ;; 図面を保存せず閉じる
    (command "_.CLOSE" "_YES")
  )

  ;; ダイアログを元に戻す
  (setvar "FILEDIA" 1)

  (princ "\n★ PDF出力完了しました！（C:/draw）")
  (princ)
)
