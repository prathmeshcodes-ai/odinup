package odinup

import "core:os"
import "core:fmt"




// ANSI Color Codes for pretty CLI 
RESET  :: "\x1b[0m"
BOLD   :: "\x1b[1m"
RED    :: "\x1b[31m"
GREEN  :: "\x1b[32m"
YELLOW :: "\x1b[33m"
CYAN   :: "\x1b[36m"

Command :: enum {
    Help,
    ListRemote,
    ListRemoteOls,
    List,
    ListOls,
    Install,
    InstallOls,
    Use,
    UseOls,
    Env,
}

parse_args :: proc() -> (Command,[]string) {
    if len(os.args) < 2 {
        return .Help, nil
    }

    cmd_str := os.args[1]
    args := os.args[2:]

    switch cmd_str {
    case "list", "ls":
        if len(os.args) > 2 && os.args[2] == "-ols" {
            return .ListOls, args
        } else if os.args[2][0] == '-' {
            fmt.eprintf("%s✖ Unknown flag: %s. Did you mean -ols?%s\n", RED, os.args[2], RESET)
            os.exit(1)
        }
        return .List, args

    case "list-remote", "lr":
        if len(os.args) > 2 && os.args[2] == "-ols" {
            return .ListRemoteOls, args
        } else if os.args[2][0] == '-' {
            fmt.eprintf("%s✖ Unknown flag: %s. Did you mean -ols?%s\n", RED, os.args[2], RESET)
            os.exit(1)
        }
        return .ListRemote, args

    case "install", "i":
        if len(os.args) > 2 && os.args[2] == "-ols" {
            return .InstallOls, args
        } else if os.args[2][0] == '-' {
            fmt.eprintf("%s✖ Unknown flag: %s. Did you mean -ols?%s\n", RED, os.args[2], RESET)
            os.exit(1)
        }
        return .Install, args

    case "use", "u":
        if len(os.args) > 2 && os.args[2] == "-ols" {
            return .UseOls, args
        } else if os.args[2][0] == '-' {
            fmt.eprintf("%s✖ Unknown flag: %s. Did you mean -ols?%s\n", RED, os.args[2], RESET)
            os.exit(1)
        }
        return .Use, args
    case "env":               
        return .Env, args
    case "help", "-h", "--help": 
        return .Help, args
    case:
        fmt.eprintf("%s%s✖ Unknown command: %s%s\n\n", RED, BOLD, cmd_str, RESET)
        return .Help, args
    }
}

print_usage :: proc() {
    fmt.println("odinup - The robust Odin version manager")
    fmt.printf("%sUsage:%s\n", BOLD, RESET)
    fmt.printf("  odinup <command> [args]\n\n")
    fmt.printf("%sCommands:%s\n", BOLD, RESET)
    fmt.printf("  %s%-23s%s List all available versions of Odin from GitHub\n", GREEN, "list-remote, lr", RESET)
    fmt.printf("  %s%-23s%s List all available versions of Ols from GitHub\n", GREEN, "list-remote -ols, lr -ols", RESET)
    fmt.printf("  %s%-23s%s List locally installed versions of Odin\n", GREEN, "list, ls", RESET)
    fmt.printf("  %s%-23s%s List locally installed versions of Ols\n", GREEN, "list -ols, ls -ols", RESET)
    fmt.printf("  %s%-23s%s Download and install a specific version of Odin\n", GREEN, "install, i <version>", RESET)
    fmt.printf("  %s%-23s%s Download and install a specific version of Ols\n", GREEN, "install -ols, i -ols <version>", RESET)
    fmt.printf("  %s%-23s%s Set the given version as the active one of Odin\n", GREEN, "use, u <version>", RESET)
    fmt.printf("  %s%-23s%s Set the given version as the active one of Ols\n", GREEN, "use -ols, u -ols <version>", RESET)
    fmt.printf("  %s%-23s%s Print the environment variables to configure your shell\n", GREEN, "env", RESET)
    fmt.printf("  %s%-23s%s Show this help message\n", GREEN, "help, -h", RESET)
}