;;; viewport-mark-view.lsp
;;; Draw a DEFPOINTS rectangle in model space showing the current paper-space viewport view extents.
;;; Author: Jeremiah Daily
;;; Personal portfolio utility.
;;; Generic AutoCAD productivity tool.
;;; Public commands: MARKVIEW
;;; Notes: Select a paper-space viewport. The command creates a model-space rectangle matching that viewport view.

(vl-load-com)

(defun c:MarkView (/ ent vp viewctr viewsize width height ll ur doc ms shrink aspect pts safearray poly)
  (setq shrink 1.0) ; Shrink margin in model space units.

  (princ "\nSelect a viewport to mark in model space...")
  (setq ent (car (entsel "\nSelect a viewport: ")))

  (if (and ent (setq vp (vlax-ename->vla-object ent)))
    (if (= (vla-get-ObjectName vp) "AcDbViewport")
      (progn
        ;; Switch to model space so VIEWCTR and VIEWSIZE reflect the selected viewport.
        (command "_.MSPACE")

        ;; Get true model view center and vertical size.
        (setq viewctr (getvar "VIEWCTR"))
        (setq viewsize (getvar "VIEWSIZE"))
        (setq height viewsize)

        ;; Get aspect ratio from viewport paper size.
        (setq aspect (/ (vlax-get vp 'Width) (vlax-get vp 'Height)))
        (setq width (* height aspect))

        ;; Apply shrink.
        (setq width  (- width (* shrink 2)))
        (setq height (- height (* shrink 2)))

        ;; Back to paper space.
        (command "_.PSPACE")

        ;; Calculate rectangle corners in model space.
        (setq ll (list (- (car viewctr) (/ width 2.0))
                       (- (cadr viewctr) (/ height 2.0))))
        (setq ur (list (+ (car viewctr) (/ width 2.0))
                       (+ (cadr viewctr) (/ height 2.0))))

        ;; Flatten points into a safearray.
        (setq pts
          (list
            (car ll) (cadr ll)
            (car ur) (cadr ll)
            (car ur) (cadr ur)
            (car ll) (cadr ur)
            (car ll) (cadr ll)
          )
        )

        (setq safearray (vlax-make-safearray vlax-vbDouble (cons 0 (1- (length pts)))))
        (vlax-safearray-fill safearray pts)

        ;; Draw polyline.
        (setq doc (vla-get-ActiveDocument (vlax-get-Acad-Object)))
        (setq ms (vla-get-ModelSpace doc))
        (setq poly (vla-AddLightWeightPolyline ms safearray))

        (vla-put-Closed poly :vlax-true)
        (vla-put-Layer poly "DEFPOINTS")

        (princ "\nAccurate model-space rectangle added.")
      )
      (princ "\nSelected object is not a viewport.")
    )
    (princ "\nNo viewport selected.")
  )

  (princ)
)

(princ "\nviewport-mark-view loaded. Commands: MARKVIEW")
(princ)
