(defun c:DWG2DXF (/ folder files acad docs doc dxfname)
  (setq folder "C:\\dwg\\")  ; DWGÉtÉHÉãÉ_
  (setq files (vl-directory-files folder "*.dwg" 1))
  (setq acad (vlax-get-acad-object))
  (setq docs (vla-get-documents acad))

  (foreach f files
    (setq doc (vla-open docs (strcat folder f)))
    (setq dxfname (strcat folder (vl-filename-base f) ".dxf"))
    (vla-saveas doc dxfname ac2007_dxf)
    (vla-close doc)
  )
  (princ "\nDWG Å® DXF ïœä∑ äÆóπ")
  (princ)
)