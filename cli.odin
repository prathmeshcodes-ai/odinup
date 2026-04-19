package odinup

import "core:os"
import "core:fmt"

Command :: enum {
    Help,
    ListRemote,
    List,
    Install,
    Use,
    Env,
}

parse_args :: proc() -> (Command,[]string) {
    if len(os.args) < 2 {
        return .Help, nil
    }

    cmd_str := os.args[1]
    args := os.args[2:]

    switch cmd_str {
    case "list-remote", "lr": 
        return .ListRemote, args
    case "list", "ls":        
        return .List, args
    case "install", "i":      
        return .Install, args
    case "use", "u":          
        return .Use, args
    case "env":               
        return .Env, args
    case "help", "-h", "--help": 
        return .Help, args
    case:
        fmt.eprintf("Unknown command: %s\n\n", cmd_str)
        return .Help, args
    }
}

print_usage :: proc() {
    fmt.println("odinup - The robust Odin version manager")
    fmt.println("\nUsage:")
    fmt.println("  odinup <command> [args]")
    fmt.println("\nCommands:")
    fmt.println("  list-remote, lr         List all available versions from GitHub")
    fmt.println("  list, ls                List locally installed versions")
    fmt.println("  install, i <version>    Download and install a specific version")
    fmt.println("  use, u <version>        Set the given version as the active one")
    fmt.println("  env                     Print the environment variables to configure your shell")
    fmt.println("  help, -h                Show this help message")
}