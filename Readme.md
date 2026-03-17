# Dialog CLI

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

## Usage

```bash
msgDialogDisplay -m <message> [options]
```

---

## Options

| Flag | Long Form                       | Description                                      |
|------|---------------------------------|--------------------------------------------------|
| `-h` | `--help`                        | Show help and exit                               |
| `-V` | `--version`                     | Show version and exit                            |
| `-m` | `--message <text>`              | Required. Dialog message text                    |
| `-t` | `--title <text>`                | Dialog title (default: "Important Information:") |
| `-w` | `--width <int>`                 | Dialog width (default: 420)                      |
| `-i` | `--icon <type>`                 | Icon type (default: info)                        |
| `-b` | `--buttons <set>`               | Button set (default: ok)                         |
| `-d` | `--defaultButton <index/label>` | Default button                                   |
| `-v` | `--vibrancy <bool>`             | Enable or disable vibrancy (default: true)       |

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
- exclamation → warning
- critical    → error

---

## Default Button

The default button can be specified using either a 1-based index or a label.

Example Index:
```bash
-d 1
```

Example Label:
```bash
-d cancel
```

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

---

## Build

```bash
swift build -c release
```

---
