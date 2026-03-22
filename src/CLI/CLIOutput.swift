// CLIOutput.swift
// Centralized output for help, short usage, errors, and version

import Foundation
import Darwin

enum CLIOutput {

    static func printHelpAndExit(program: String) -> Never {
        let usage = """
        Usage:
          \(program) -m <message> [options]

        Options:
          -h, --help                        Show this help and exit
          -V, --version                     Show version and exit
          -m, --message <text>              Required. Dialog message text.
          -t, --title <text>                Optional. (Default: "Important Information:")
          -w, --width <int>                 Optional. (Default: 400)
          -i, --icon <type>                 Optional. (Default: info)
          -b, --buttons <set>               Optional. (Default: ok)
          -d, --defaultButton <index|label> Optional. Button label (OK, Cancel, Yes, etc.) or index number.
          -v, --vibrancy <bool>             Optional. true|false. (Default: true)
          -T, --titleInBar <bool>           Optional. true|false. (Default: false)

        Button sets:
          ok
          okcancel
          yesno
          yesnocancel
          retrycancel
          abortretryignore

        Icon types:
          info
          warning
          error

        Examples:
          \(program) -m "Hello"
          \(program) -m "Proceed?" -t "Confirm" -b okcancel -d cancel
          \(program) -m "Try again?" -b retrycancel -d 1 -i warning -T true
        
        """
        print(usage)
        fflush(stdout)
        exit(0)
    }

    static func printVersionAndExit(program: String) -> Never {
        let versionLine: String
        if CLIVersion.build.isEmpty {
            versionLine = "\(program) \(CLIVersion.version)"
        } else {
            versionLine = "\(program) \(CLIVersion.version) (\(CLIVersion.build))"
        }
        print(versionLine)
        fflush(stdout)
        exit(0)
    }

    static func printShortUsageAndExit(program: String, reason: String) -> Never {
        let message = """
        Error: \(reason)
        Run \(program) -h or --help for usage.
        
        """
        print(message)
        fflush(stdout)
        exit(64)
    }
}

