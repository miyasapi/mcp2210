(vl-load-com)

(defun c:DWG2PDF_BATCH (/ srcFile srcFolder outDummy outFolder
                          dwgList acadObj docs adoc lay plotObj pdfName
                          old_backplot)

  (princ "\n[DWG → PDF 一括変換]")

  ;; ① 対象フォルダ内の任意の DWG を1つ選んでもらう
  (setq srcFile
        (getfiled
          "変換したい DWG が入っているフォルダ内の DWG を1つ選んでください"
          ""
          "dwg"
          0
        )
  )

  (if (not srcFile)
    (progn
      (princ "\nキャンセルされました。")
      (princ)
    )
    (progn
      (setq srcFolder (vl-filename-directory srcFile))

      ;; ② PDF 出力先フォルダ（任意フォルダ）を指定
      ;;    適当なファイル名で良いので、保存ダイアログでフォルダだけ決める
      (setq outDummy
            (getfiled
              "PDF を保存したいフォルダを指定してください（ファイル名は適当でOK）"
              (strcat srcFolder "\\output.pdf")
              "pdf"
              1
            )
      )

      (if (not outDummy)
        (progn
          (princ "\nキャンセルされました。")
          (princ)
        )
        (progn
          (setq outFolder (vl-filename-directory outDummy))

          ;; 出力フォルダが無ければ作成
          (if (not (vl-file-directory-p outFolder))
            (vl-mkdir outFolder)
          )

          ;; ③ 対象フォルダ内の DWG 一覧を取得
          (setq dwgList (vl-directory-files srcFolder "*.dwg" 1))

          (if (not dwgList)
            (progn
              (princ "\nこのフォルダには DWG がありません。")
            )
            (progn
              (setq acadObj (vlax-get-acad-object))
              (setq docs    (vla-get-Documents acadObj))

              ;; バックグラウンド印刷を OFF（同期的に待つため）
              (setq old_backplot (getvar "BACKGROUNDPLOT"))
              (setvar "BACKGROUNDPLOT" 0)

              (foreach fn dwgList
                (setq full (strcat srcFolder "\\" fn))
                (princ (strcat "\n出力中: " full))

                ;; ④ DWG を開く（ドキュメントとして）
                (setq adoc (vla-open docs full))
                (vla-Activate adoc)

                ;; ⑤ プロット設定（ここは環境に合わせて必要なら修正）
                (setq lay (vla-get-ActiveLayout adoc))

                ;; プロッタ名：日本語版でも通常はこの名前
                (vla-put-ConfigName lay "DWG To PDF.pc3")

                ;; 用紙サイズ：A3 の例（お好みで変えてください）
                ;; 例）A4 にしたい場合は Plot ダイアログで A4 を選び、
                ;;     Canonical size 名を調べて差し替え
                (vla-put-CanonicalMediaName
                  lay
                  "ISO_full_bleed_A3_(420.00_x_297.00_MM)"
                )

                ;; プロットスタイル：モノクロ出力例
                (vla-put-StyleSheet lay "monochrome.ctb")

                ;; 設定を反映
                (vla-RefreshPlotDeviceInfo lay)

                ;; ⑥ PDF ファイル名（DWG と同じ名前で拡張子だけ .pdf）
                (setq pdfName
                      (strcat outFolder "\\" (vl-filename-base fn) ".pdf")
                )

                ;; ⑦ Plot オブジェクトから PDF へ出力（ファイルにプロット）
                (setq plotObj (vla-get-Plot adoc))
                (vla-PlotToFile plotObj pdfName)

                ;; ⑧ 図面を保存せず閉じる
                (vla-Close adoc :vlax-false)
              )

              ;; BACKGROUNDPLOT を元に戻す
              (setvar "BACKGROUNDPLOT" old_backplot)

              (princ
                (strcat
                  "\n*** 変換完了 ***\n出力フォルダ: "
                  outFolder
                )
              )
            )
          )
        )
      )
    )
  )
  (princ)
)
