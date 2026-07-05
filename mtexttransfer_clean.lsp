;;; mtexttransfer.lsp
;;; Transfer text from one MTEXT object into another MTEXT object and delete the source.
;;; Author: Jeremiah Daily
;;; Public commands: MTX
;;; Notes: Select the source MTEXT first, then select the destination MTEXT to overwrite.

(vl-load-com)

(defun c:MTX (/ source dest plainText sourceObj destObj)
  ;; Prompt for source MTEXT.
  (setq source (car (entsel "\nSelect MTEXT to copy from. Source will be deleted: ")))
  (if (and source (= (cdr (assoc 0 (entget source))) "MTEXT"))
    (progn
      (setq sourceObj (vlax-ename->vla-object source))
      (setq plainText (vlax-get sourceObj 'TextString))

      ;; Prompt for destination MTEXT.
      (setq dest (car (entsel "\nSelect MTEXT to paste into: ")))
      (if (and dest (= (cdr (assoc 0 (entget dest))) "MTEXT"))
        (progn
          (setq destObj (vlax-ename->vla-object dest))
          (vlax-put destObj 'TextString plainText)
          (vla-delete sourceObj)
          (princ "\nText transferred and source MTEXT deleted.")
        )
        (princ "\nInvalid destination MTEXT.")
      )
    )
    (princ "\nInvalid source MTEXT.")
  )

  (princ)
)

(princ "\nmtexttransfer loaded. Commands: MTX")
(princ)
