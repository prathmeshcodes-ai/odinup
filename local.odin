package odinup

import "core:fmt"
import "core:os"
import "core:path/filepath"

list_local :: proc() {
    f, err := os.open(cfg.versions_dir)
    if err != os.ERROR_NONE {
        fmt.eprintln("Failed to open versions directory")
        return
    }
    defer os.close(f)

    fi, read_err := os.read_dir(f, -1, context.allocator)
    if read_err != os.ERROR_NONE {
        fmt.eprintln("Failed to read versions directory")
        return
    }

    fmt.println("Installed versions:")
    if len(fi) == 0 {
        fmt.println("  (none)")
        return
    }

    for info in fi {
        if os.is_dir(info.fullpath) {
            fmt.printf("  %s\n", info.name)
        }
    }
}

use_version :: proc(version: string) {
    version_path, _ := filepath.join([]string{cfg.versions_dir, version}, context.allocator)
    if !os.exists(version_path) {
        fmt.eprintf("Error: Version '%s' is not installed.\n", version)
        os.exit(1)
    }

    exe_name := "odin"
    if ODIN_OS == .Windows {
        exe_name = "odin.exe"
    }

    target_exe := find_executable(version_path, exe_name)
    if target_exe == "" {
        fmt.eprintf("Error: Could not find Odin executable inside %s\n", version_path)
        os.exit(1)
    }

    create_wrapper_script(target_exe)
    
    fmt.printf("Successfully set Odin version to: %s\n", version)
}

find_executable :: proc(base_dir: string, exe_name: string) -> string {
    // 1. Direct location check
    direct, _ := filepath.join([]string{base_dir, exe_name}, context.allocator)
    if os.exists(direct) {
        return direct
    }

    // 2. Check within the first nested extraction folder (standard GitHub payload structure)
    f, err := os.open(base_dir)
    if err == os.ERROR_NONE {
        defer os.close(f)
        fis, _ := os.read_dir(f, -1, context.allocator)
        for fi in fis {
            if os.is_dir(fi.fullpath) {
                inner, _ := filepath.join([]string{base_dir, fi.name, exe_name}, context.allocator)
                if os.exists(inner) {
                    return inner
                }
            }
        }
    }
    return ""
}