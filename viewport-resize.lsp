;;; viewport-resize.lsp
;;; Resize and move a viewport without changing its model-space scale or view center.
;;; Author: Jeremiah Daily
;;; Personal portfolio utility.
;;; Generic AutoCAD productivity tool.
;;; No employer files, client data, proprietary standards, confidential drawings,
;;; internal file paths, or company-specific project information included.
;;; Public commands: RESIZEVP
;;; Notes: Select a viewport, then draw a new paper-space rectangle to define the viewport boundary.

(vl-load-com)

(defun c:ResizeVP (/ ent vp pt1 pt2 width height center viewcenter viewscale)
  (princ "\nSelect a viewport to move and resize...")
  (setq ent (car (entsel "\nSelect a viewport: ")))

  (if ent
    (progn
      (setq vp (vlax-ename->vla-object ent))

      (if (= (vla-get-ObjectName vp) "AcDbViewport")
        (progn
          ;; Store current view settings before resizing.
          (setq viewcenter (vla-get-Center vp))
          (setq viewscale  (vla-get-CustomScale vp))

          ;; Get rectangle.
          (princ "\nDraw a rectangle to define the new viewport area.")
          (setq pt1 (getpoint "\nFirst corner: "))
          (setq pt2 (getpoint pt1 "\nOpposite corner: "))

          ;; Calculate new size and center.
          (setq width  (abs (- (car pt2) (car pt1))))
          (setq height (abs (- (cadr pt2) (cadr pt1))))
          (setq center (vlax-3d-point
                         (list
                           (/ (+ (car pt1) (car pt2)) 2.0)
                           (/ (+ (cadr pt1) (cadr pt2)) 2.0)
                           0.0
                         )
                       )
          )

          ;; Apply new size and position.
          (vla-put-Width vp width)
          (vla-put-Height vp height)
          (vla-put-Center vp center)

          ;; Restore view scale and view center.
          (vla-put-CustomScale vp viewscale)
          (vla-put-ViewCenter vp viewcenter)

          (princ "\nViewport moved and resized without changing model scale.")
        )
        (princ "\nSelected object is not a viewport.")
      )
    )
    (princ "\nNo object selected.")
  )
  (princ)
)

(princ "\nviewport-resize loaded. Commands: RESIZEVP")
(princ)
