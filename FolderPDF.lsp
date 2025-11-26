;;; ------------------------------------------------------------
;;; フォルダ内のDWGを自動走査して、
;;; 図面ごとに別PDFを出力するLISP
;;; コマンド名：FOLDERPDF
;;; ------------------------------------------------------------

(vl-load-com)

(defun c:FOLDERPDF (/ *error* oldcmdecho acad docs anydwg folder files fn full
                      doc layouts layName layout plot pdfPath)

  ;; エラー処理
  (defun *error* (msg)
    (if (and msg
             (not (wcmatch (strcase msg) "*CANCEL*,*QUIT*"))
        )
      (princ (strcat "\nエラー: " msg))
    )
    (if oldcmdecho (setvar 'CMDECHO oldcmdecho))
    (princ)
  )

  (setq oldcmdecho (getvar 'CMDECHO))
  (setvar 'CMDECHO 0)

  ;; 任意のDWGを1つ選んでもらい、そのファイルのフォルダを使用
  (setq anydwg
        (getfiled
          "PDF化したいDWGが入っているフォルダ内のDWGを1つ選んでください"
          ""
          "dwg"
          0
        )
  )

  (if (not anydwg)
    (progn
      (princ "\nキャンセルされました。")
      (setvar 'CMDECHO oldcmdecho)
      (princ)
      (exit)
    )
  )

  ;; 選択したDWGファイルのフォルダを取得
  (setq folder (vl-filename-directory anydwg))

  ;; フォルダ内の *.dwg を取得
  (setq files (vl-directory-files folder "*.dwg" 1))

  (if (not files)
    (progn
      (princ "\nこのフォルダにはDWGファイルが見つかりませんでした。")
      (setvar 'CMDECHO oldcmdecho)
      (princ)
      (exit)
    )
  )

  (setq acad (vlax-get-acad-object))
  (setq docs (vla-get-Documents acad))

  (princ (strcat "\nフォルダ： " folder))
  (princ (strcat "\nDWGファイル数： " (itoa (length files))))

  (foreach fn files
    (setq full (strcat folder "\\" fn))
    (princ (strcat "\n処理中： " full))

    ;; 図面を開く
    (setq doc (vla-open docs full))
    (vla-Activate doc)

    ;; 現在のレイアウト名（CTAB）を取得
    ;; （通常は印刷したいレイアウトをアクティブにして保存してある前提）
    (setq layName (getvar "CTAB"))

    ;; レイアウトオブジェクト取得
    (setq layouts (vla-get-Layouts doc))
    (setq layout  (vla-Item layouts layName))

    ;; 出力デバイスに「DWG To PDF.pc3」をセット
    (vla-put-ConfigName layout "DWG To PDF.pc3")

    ;; 必要に応じて用紙サイズを固定する場合（例：A3）
    ;; (vla-put-CanonicalMediaName layout "ISO_A3_(297.00_x_420.00_MM)")

    ;; PDFの保存先パス（DWG名と同じ名前）
    (setq pdfPath (strcat folder "\\" (vl-filename-base fn) ".pdf"))

    ;; Plotオブジェクトを取得してファイル出力
    (setq plot (vla-get-Plot doc))
    (vla-PlotToFile plot pdfPath layName)

    ;; 図面を保存せずに閉じる
    (vla-Close doc :vlax-false)
  )

  (setvar 'CMDECHO oldcmdecho)
  (princ "\n--- すべてのDWGのPDF化が完了しました ---")
  (princ)
)
