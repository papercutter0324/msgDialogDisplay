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
dialog-cli -m <message> [options]
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
| `-d` | `--defaultButton <index|label>` | Default button                                   |
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
- critical → error

---

## Default Button

The default button can be specified using either a 1-based index or a label.

Index:
```bash
-d 1
```

Label:
```bash
-d cancel
-d yes
-d retry
```

Supported labels:
- ok, cancel
- yes, no
- retry, ignore, abort

Aliases:
- okay → ok
- esc, escape → cancel

---

## Examples

Basic dialog:
```bash
dialog-cli -m "Hello world"
```

Confirmation dialog:
```bash
dialog-cli -m "Proceed?" -t "Confirm" -b okcancel -d cancel
```

Retry dialog with warning icon:
```bash
dialog-cli -m "Try again?" -b retrycancel -d 1 -i warning
```

Custom width and disabled vibrancy:
```bash
dialog-cli -m "Wide dialog" -w 600 -v false
```

---

## Argument Rules

- Both short (-m) and long (--message) flags are supported
- Values can be passed as separate arguments or using =
- Boolean values accept: true, false, yes, no, 1, 0, on, off
- Unknown flags and invalid values result in an error

---

## Error Handling

Invalid input is rejected with a clear message and a non-zero exit code.

Example:
```bash
Error: Invalid value for --width: abc
Run dialog-cli -h or --help for usage.
```

---

## Build

```bash
swift build -c release
```

---

## License

Specify your license here.

---

## Notes

- This tool does not support positional arguments
- All inputs must be provided using flags
- Default values are applied when optional flags are omitted
