package odinup

import "core:fmt"
import "core:os"

main :: proc() {
    cmd, args := parse_args()
    
    // Initialize user path configurations (~/.odinup)
    init_config()
    
    switch cmd {
    case .Help:
        print_usage()
    case .ListRemote:
        list_remote()
    case .List:
        list_local()
    case .Install:
        if len(args) == 0 {
            fmt.eprintln("Error: Please specify a version to install (e.g. dev-2026-04)")
            os.exit(1)
        }
        install_version(args[0])
    case .Use:
        if len(args) == 0 {
            fmt.eprintln("Error: Please specify a version to use (e.g. dev-2026-04)")
            os.exit(1)
        }
        use_version(args[0])
    case .Env:
        print_env()
    }
}