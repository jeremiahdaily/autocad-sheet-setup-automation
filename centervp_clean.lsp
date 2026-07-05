;;; centervp.lsp
;;; Center a paper-space viewport on a selected Defpoints rectangle in model space.
;;; Author: Jeremiah Daily
;;; Public commands: CENTERVP
;;; Notes: Select a closed rectangular LWPOLYLINE on DEFPOINTS in model space, then select the viewport to center.

(vl-load-com)

(defun butlast (lst)
  (reverse (cdr (reverse lst)))
)

(defun c:CENTERVP (/ doc rectEnt rectData pts minPt maxPt centerPt vpEnt vpObj wasLocked)
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  ;; Step 1: Select rectangle in model space.
  (prompt "\nSelect the rectangle in model space on the DEFPOINTS layer: ")
  (setq rectEnt (car (entsel)))

  (cond
    ((not rectEnt)
      (prompt "\nNo rectangle selected.")
    )

    (T
      (setq rectData (entget rectEnt))

      ;; Validate that it is a closed LWPOLYLINE on the DEFPOINTS layer.
      (if (not (and (= (cdr (assoc 0 rectData)) "LWPOLYLINE")
                    (= (strcase (cdr (assoc 8 rectData))) "DEFPOINTS")
                    (= (logand (cdr (assoc 70 rectData)) 1) 1)))
        (prompt "\nMust be a closed LWPOLYLINE on the DEFPOINTS layer.")
        (progn
          ;; Extract points and calculate center.
          (setq pts (mapcar 'cdr (vl-remove-if-not '(lambda (x) (= (car x) 10)) rectData)))
          (if (equal (car pts) (last pts) 1e-6)
            (setq pts (butlast pts))
          )

          (if (/= (length pts) 4)
            (prompt "\nRectangle must have 4 unique vertices.")
            (progn
              (setq minPt (list (apply 'min (mapcar 'car pts)) (apply 'min (mapcar 'cadr pts))))
              (setq maxPt (list (apply 'max (mapcar 'car pts)) (apply 'max (mapcar 'cadr pts))))
              (setq centerPt (list (/ (+ (car minPt) (car maxPt)) 2.0)
                                   (/ (+ (cadr minPt) (cadr maxPt)) 2.0)))

              ;; Switch to paper space to select the viewport.
              (vla-put-ActiveSpace doc acPaperSpace)
              (prompt "\nSelect the viewport to center: ")
              (setq vpEnt (car (entsel)))

              (if (not vpEnt)
                (prompt "\nNo viewport selected.")
                (progn
                  ;; Temporarily unlock the viewport if needed.
                  (setq vpObj (vlax-ename->vla-object vpEnt))
                  (setq wasLocked (vla-get-DisplayLocked vpObj))
                  (vla-put-DisplayLocked vpObj :vlax-false)

                  ;; Activate the selected viewport and center the view.
                  (command "_.MSPACE")
                  (command "_.ZOOM" "C" centerPt "1X")

                  ;; Restore lock state and return to paper space.
                  (if (= wasLocked :vlax-true)
                    (vla-put-DisplayLocked vpObj :vlax-true)
                  )
                  (command "_.PSPACE")

                  (prompt "\nViewport view centered to the DEFPOINTS rectangle.")
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

(princ "\ncentervp loaded. Commands: CENTERVP")
(princ)
