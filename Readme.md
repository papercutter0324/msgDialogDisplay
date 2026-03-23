# msgDialogDisplay

A lightweight command-line utility for displaying configurable dialog windows.  
Supports customizable messages, titles, button sets, icons, and behavior through a simple flag-based interface.

---

## Features

- Configurable message and title
- Multiple icon types (information, warning, error)
- Predefined button sets (OK, Yes/No, Retry, etc.)
- Default button selection by index or label
- Adjustable dialog width
- Optional vibrancy effect
- Strict argument validation with clear error messages

---

## Requirements

- macOS (AppKit/PDFKit)
- Xcode (to build)
- Swift ArgumentParser (SPM dependency included by the Xcode project)

---

## Installation

- Open the project in Xcode and build the “msgDialogDisplay” scheme in Release.
- The resulting binary will be in your build products (DerivedData). Copy it to a location on your `$PATH` if desired.

---

## Usage

Run the tool from Terminal or a shell command, such as by an AppleScript, and provide message and any desired optional valus.

### Basic Syntax

```bash
msgDialogDisplay -m <message> [options]
```

---

## Options

| Flag | Long Form                       | Description                                   | Optional | Default                  |
|------|---------------------------------|----------------------------------------------------------|--------------------------|
| `-m` | `--message <text>`              | Message to display. (Required)                |     X    |                          |
| `-t` | `--title <text>`                | Message Title       (Optional)                |     √    | "Important Information:" |
| `-w` | `--width <int>`                 | Custom dialog width (Optional)                |     √    | 400                      |
| `-i` | `--icon <type>`                 | Message icon:       (Optional)                |     √    | "info"                   |
| `-b` | `--buttons <set>`               | Button combination  (Optional)                |     √    | "ok"                     |
| `-d` | `--defaultButton <index/label>` | Default button      (Optional)                |     √    | 1                        |
| `-v` | `--vibrant <bool>`              | Use new vibrancy-style dialogs  (Optional)    |     √    | false                    |
| `-T` | `--inTitleBar <bool>`           | Title in title bar instead of content window. |     √    | false                    |
|      | `--version`                     | Show version and exit                         |     √    |                          |
| `-h` | `--help`                        | Show help and exit                            |     √    |                          |

---

## Button Sets

| Name               | Buttons              |
|--------------------|----------------------|
| `ok`               | OK                   |
| `okcancel`         | OK, Cancel           |
| `yesno`            | Yes, No              |
| `yesnocancel`      | Yes, No, Cancel      |
| `retrycancel`      | Retry, Cancel        |
| `abortretryignore` | Abort, Retry, Ignore |

---

## Icon Types

- info
- warning
- error

Aliases:
- information → info
- question    → info
- exclamation → warning
- critical    → error

---

## Examples

Basic dialog:
```bash
msgDialogDisplay -m "Hello world"
```

Confirmation dialog:
```bash
msgDialogDisplay -m "Proceed?" -t "Confirm" -b okcancel -d cancel
```

Custom width and disabled vibrancy:
```bash
msgDialogDisplay -m "Wide dialog" -w 600 -v false
```
