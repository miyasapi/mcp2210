(defun c:DWG2PDF (/ dwglist dwg pdf full)
  ;; 変換対象DWG一覧取得
  (setq dwglist (vl-directory-files "C:/dwg" "*.dwg" 1))

  ;; 1件ずつ処理
  (foreach dwg dwglist
    (setq full (strcat "C:/dwg/" dwg))
    (command "_.OPEN" full)

    ;; PDF保存名
    (setq pdf (strcat "C:/dwg/" (vl-filename-base dwg) ".pdf"))

    ;; プロット → PDF出力
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

    ;; ---- ★ 安定化のため待機 300ms（0.3秒） ----
    (vl-cmdf "_.DELAY" 300)

    ;; 図面を保存せずに閉じる
    (command "_.CLOSE" "_YES")
  )

  (princ "\n★ PDF出力完了しました！（C:/dwg）")
  (princ)
)
