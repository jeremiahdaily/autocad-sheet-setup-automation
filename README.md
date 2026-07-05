# AutoCAD Sheet Setup Automation

Small AutoLISP utilities for speeding up sheet setup and viewport workflows in AutoCAD.

## Included scripts

- `tbupdate_clean.lsp` - saves a title-block DWG path to the TEMP folder and either repaths an existing XREF or attaches it at 0,0,0.
- `mtexttransfer_clean.lsp` - copies text from one MTEXT object to another and deletes the source MTEXT.
- `resizevp_clean.lsp` - resizes and moves a viewport based on a drawn paper-space rectangle while preserving its view scale and center.
- `markview_clean.lsp` - draws a DEFPOINTS rectangle in model space that matches the extents of a selected paper-space viewport.
- `centervp_clean.lsp` - centers a selected paper-space viewport on a DEFPOINTS rectangle in model space.

## Notes

- `tbupdate_clean.lsp` stores the selected title-block path in the system TEMP folder.
- The scripts are written to avoid embedding personal file paths or user-specific locations.
