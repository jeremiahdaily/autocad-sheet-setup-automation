;;; titleblock-xref-update.lsp
;;; Title-block path saver and XREF updater.
;;; Author: Jeremiah Daily
;;; Personal portfolio utility.
;;; Generic AutoCAD productivity tool.
;;; No employer files, client data, proprietary standards, confidential drawings,
;;; internal file paths, or company-specific project information included.
;;; Public commands: SET-TBFILE, LOAD-TB
;;; Notes: SET-TBFILE saves the selected title-block DWG path to the TEMP folder.
;;; Notes: LOAD-TB re-paths an existing matching XREF or attaches it at 0,0,0.

(vl-load-com)

(defun get-temp-path (/ path)
  ;; Get the system TEMP folder path.
  (setq path (getenv "TEMP"))
  (if (and path (/= path ""))
    (vl-string-right-trim "\\" path)
    nil
  )
)

(defun get-tbpath-file (/ tempdir)
  (setq tempdir (get-temp-path))
  (if tempdir
    (strcat tempdir "\\tbpath.txt")
    nil
  )
)

(defun write-tbpath (filepath / f tbfile)
  (setq tbfile (get-tbpath-file))
  (if tbfile
    (progn
      (setq f (open tbfile "w"))
      (write-line filepath f)
      (close f)
      T
    )
    nil
  )
)

(defun read-tbpath (/ f line tbfile)
  (setq tbfile (get-tbpath-file))
  (if (and tbfile (findfile tbfile))
    (progn
      (setq f (open tbfile "r"))
      (setq line (read-line f))
      (close f)
      line
    )
    nil
  )
)

(defun c:SET-TBFILE (/ file)
  (vl-load-com)
  (setq file (getfiled "Select the NEW title-block DWG" "" "dwg" 0))
  (cond
    (file
      (if (write-tbpath file)
        (princ (strcat "\nTitleblock path saved: " file))
        (princ "\nTEMP folder is unavailable. Path was not saved.")
      )
    )
    (T
      (princ "\nNothing selected."))
  )
  (princ)
)

(defun c:LOAD-TB (/ file blkname adoc blks xref inspt)
  (vl-load-com)
  (setq file (read-tbpath))
  (if file
    (progn
      (setq blkname (vl-filename-base file))
      (setq adoc (vla-get-ActiveDocument (vlax-get-acad-object)))
      (setq blks (vla-get-Blocks adoc))
      (setq xref (vl-catch-all-apply 'vla-Item (list blks blkname)))

      (cond
        ;; Case 1: XREF already exists.
        ((and (not (vl-catch-all-error-p xref))
              (= (vla-get-IsXref xref) :vlax-true))
          (vla-put-Path xref file)
          (vla-Reload xref)
          (princ (strcat "\nRe-pathed XREF \"" blkname "\" in " (getvar "dwgname")))
        )

        ;; Case 2: Block exists but is not an XREF.
        ((and (not (vl-catch-all-error-p xref))
              (/= (vla-get-IsXref xref) :vlax-true))
          (princ (strcat "\nBlock \"" blkname "\" exists but is NOT an XREF - skipped."))
        )

        ;; Case 3: Block not found, so attach it.
        (T
          (setq inspt (vlax-3d-point '(0 0 0)))
          (vla-AttachExternalReference blks file blkname inspt 1.0 1.0 1.0 0.0 :vlax-true)
          (princ (strcat "\nAttached new XREF \"" blkname "\" to " (getvar "dwgname")))
        )
      )
    )
    (princ "\nNo titleblock path found. Use SET-TBFILE first.")
  )
  (princ)
)

(princ "\ntitleblock-xref-update loaded. Commands: SET-TBFILE, LOAD-TB")
(princ)
