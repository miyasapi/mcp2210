(vl-load-com)

(defun c:DWG2PDF_BATCH (/ srcFile srcFolder outDummy outFolder
                          dwgList acadObj docs adoc lay plotObj pdfName
                          old_backplot full res)

  (princ "\n[DWG → PDF 一括変換 開始]")

  ;; ① 対象フォルダ内のDWGを1つ選択
  (setq srcFile
        (getfiled
          "変換したい DWG が入っているフォルダ内の DWG を1つ選んでください"
          ""
          "dwg"
          0
        )
  )

  (if (not srcFile)
    (progn (princ "\nキャンセルされました。") (princ))
    (progn
      (setq srcFolder (vl-filename-directory srcFile))

      ;; ② 出力フォルダ指定（ファイル名はダミーでOK）
      (setq outDummy
            (getfiled
              "PDF を保存したいフォルダを指定してください（ファイル名は適当でOK）"
              (strcat srcFolder "\\output.pdf")
              "pdf"
              1
            )
      )

      (if (not outDummy)
        (progn (princ "\nキャンセルされました。") (princ))
        (progn
          (setq outFolder (vl-filename-directory outDummy))

          ;; 出力フォルダが無ければ作成
          (if (not (vl-file-directory-p outFolder))
            (vl-mkdir outFolder)
          )

          ;; ③ フォルダ内の DWG一覧取得
          (setq dwgList (vl-directory-files srcFolder "*.dwg" 1))

          (if (not dwgList)
            (princ "\nこのフォルダには DWG がありません。")
            (progn
              (setq acadObj (vlax-get-acad-object))
              (setq docs    (vla-get-Documents acadObj))

              ;; バックグラウンド印刷OFF
              (setq old_backplot (getvar "BACKGROUNDPLOT"))
              (setvar "BACKGROUNDPLOT" 0)

              (princ (strcat
                       "\n対象フォルダ: " srcFolder
                       "\n出力フォルダ: " outFolder
                       "\nDWG数: " (itoa (length dwgList))
                     ))

              ;; ④ 1ファイルずつ処理
              (foreach fn dwgList
                (setq full (strcat srcFolder "\\" fn))
                (princ (strcat "\n---\n処理中: " full))

                (setq adoc nil
                      plotObj nil
                      res nil)

                ;; エラーが出ても落ちないように try-catch
                (setq res
                      (vl-catch-all-apply
                        (function
                          (lambda ()
                            ;; DWGを開く
                            (setq adoc (vla-open docs full))
                            (vla-Activate adoc)

                            ;; レイアウト取得（現在のレイアウト）
                            (setq lay (vla-get-ActiveLayout adoc))

                            ;; プロッタ
                            (vla-put-ConfigName lay "DWG To PDF.pc3")

                            ;; 用紙サイズ（A3フルブリードの例）
                            (vla-put-CanonicalMediaName
                              lay
                              "ISO_full_bleed_A3_(420.00_x_297.00_MM)"
                            )

                            ;; プロットスタイル（モノクロ）
                            (vla-put-StyleSheet lay "monochrome.ctb")
                            (vla-RefreshPlotDeviceInfo lay)

                            ;; 出力ファイル名
                            (setq pdfName
                                  (strcat outFolder "\\"
                                          (vl-filename-base fn)
                                          ".pdf"
                                  )
                            )

                            ;; PDF へプロット
                            (setq plotObj (vla-get-Plot adoc))
                            (vla-PlotToFile plotObj pdfName)

                            (princ (strcat "\n  → 出力: " pdfName))
                          )
                        )
                      )
                )

                ;; エラー内容の簡易ログ
                (if (and res (vl-catch-all-error-p res))
                  (princ
                    (strcat
                      "\n  !! エラー発生: "
                      (vl-catch-all-error-message res)
                    )
                  )
                )

                ;; 図面を閉じる（開けた場合のみ）
                (if adoc
                  (progn
                    (vla-Close adoc :vlax-false)
                    (vlax-release-object adoc)
                    (setq adoc nil)
                  )
                )

                ;; Plotオブジェクトも解放
                (if plotObj
                  (progn
                    (vlax-release-object plotObj)
                    (setq plotObj nil)
                  )
                )
              ) ; foreach

              ;; BACKGROUNDPLOT 復元
              (setvar "BACKGROUNDPLOT" old_backplot)

              ;; COMオブジェクト解放
              (if docs    (vlax-release-object docs))
              (if acadObj (vlax-release-object acadObj))

              (princ
                (strcat
                  "\n*** 変換完了 ***"
                  "\n出力フォルダをエクスプローラーで確認してください。"
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
