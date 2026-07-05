# AutoCAD Sheet Setup Automation

Small AutoLISP utilities for speeding up sheet setup, viewport alignment, title-block handling, and repetitive drafting workflows in AutoCAD.

## Purpose

The goal of this repository is to document practical CAD automation tools built around common production drafting tasks.

These scripts are intentionally simple, focused, and workflow-driven. Each utility is designed to reduce repetitive manual steps, improve consistency, and demonstrate how AutoLISP can be used to automate real drafting problems.

## Included Scripts

| File | Command | Description |
|---|---|---|
| `titleblock-xref-update.lsp` | `SET-TBFILE`, `LOAD-TB` | Saves a selected title-block DWG path and either repaths an existing XREF or attaches it at `0,0,0`. |
| `mtext-transfer.lsp` | `MTX` | Copies text from one MTEXT object to another and deletes the source MTEXT. |
| `viewport-resize.lsp` | `RESIZEVP` | Resizes and moves a viewport based on a drawn paper-space rectangle while preserving its view scale and center. |
| `viewport-mark-view.lsp` | `MARKVIEW` | Draws a DEFPOINTS rectangle in model space that matches the extents of a selected paper-space viewport. |
| `viewport-center.lsp` | `CENTERVP` | Centers a selected paper-space viewport on a DEFPOINTS rectangle in model space. |

## Skills Demonstrated

- AutoLISP scripting
- AutoCAD viewport automation
- XREF workflow support
- MTEXT object manipulation
- CAD productivity tooling
- Command-line user interaction
- Drafting workflow improvement
- Technical documentation

## Usage

1. Download or clone this repository.
2. Open AutoCAD.
3. Use `APPLOAD` to load the desired `.lsp` file.
4. Run the command listed in the table above.

Example:

```text
APPLOAD
```

Load:

```text
mtext-transfer.lsp
```

Run:

```text
MTX
```

## Notes

- `titleblock-xref-update.lsp` stores the selected title-block path in the system TEMP folder.
- The tools are designed as general productivity utilities and may need adjustment for different CAD standards or office workflows.
- The files use intentional public-facing names instead of temporary cleanup names.

## Disclaimer

This repository contains generic AutoCAD productivity utilities created and maintained as a personal portfolio project.

These tools do not include employer files, client data, proprietary standards, confidential drawings, internal file paths, or company-specific project information.

The scripts are intended to demonstrate general CAD automation concepts for common drafting and sheet setup workflows.
