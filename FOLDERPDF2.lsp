(vl-load-com)

(defun c:FOLDERPDF (/ anydwg folder files fn full pdfPath)

  ;; DWGファイルを1つ選んでもらい、そのフォルダを使う
  (setq anydwg (getfiled "PDF化したいDWGが入っているフォルダ内のDWGを1つ選択" "" "dwg" 0))

  (if (not anydwg)
    (progn (princ "\nキャンセルされました。") (princ) (exit))
  )

  (setq folder (vl-filename-directory anydwg))
  (setq files (vl-directory-files folder "*.dwg" 1))

  (if (not files)
    (progn (princ "\nこのフォルダにDWGはありません。") (princ) (exit))
  )

  (princ (strcat "\nフォルダ：" folder))
  (princ (strcat "\nDWG数：" (itoa (length files))))

  (foreach fn files

    (setq full (strcat folder "\\" fn))
    (setq pdfPath (strcat folder "\\" (vl-filename-base fn) ".pdf"))

    (princ (strcat "\nPDF出力中：" full))

    ;; 図面を開く
    (command "_.OPEN" full)

    ;; 現在のレイアウトを取得
    (setq lay (getvar "CTAB"))

    ;; -PLOT コマンドで PDF 出力を強制
    (command
      "._-PLOT"
      "Y"               ; 詳細プロット設定？ → YES
      lay               ; レイアウト名
      "DWG To PDF.pc3"  ; プロッタ
      ""                ; 用紙サイズはレイアウト設定を使う
      ""                ; 印刷領域はレイアウト設定を使用
      "1:1"             ; スケール
      "Y"               ; 方向はレイアウト設定を使用
      "N"               ; オフセット自動調整しない
      "Y"               ; プロットスタイル適用
      "N"               ; 白黒強制なし
      "N"               ; シェーディングオプションなし
      "N"               ; ビューポートオプションなし
      pdfPath           ; PDF保存先
      "Y"               ; 上書き可
      "Y"               ; 印刷実行
    )

    (command "_.CLOSE" "N") ; 保存せず閉じる
  )

  (princ "\n--- すべてPDFへ変換完了 ---")
  (princ)
)
