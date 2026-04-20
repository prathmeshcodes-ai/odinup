package odinup

import "core:c/libc"
import "core:os"
import "core:fmt"
import "core:strings"
import "core:path/filepath"

// Executes a shell command synchronously and returns the exit code
run_command :: proc(cmd: string) -> int {
    cstr := strings.clone_to_cstring(cmd)
    defer delete(cstr)
    return int(libc.system(cstr))
}

// Safely checks if a directory exists and creates it if it doesn't
ensure_dir :: proc(path: string) {
    if !os.exists(path) {
        err := os.make_directory(path)
        if err != os.ERROR_NONE {
            fmt.eprintf("Failed to create directory %s: %v\n", path, err)
            os.exit(1)
        }
    }
}

check_clang_availability :: proc() -> bool {
    when ODIN_OS == .Windows {
        ret := run_command("clang --version >nul 2>&1")
    } else {
        ret := run_command("clang --version > /dev/null 2>&1")
    }
    return ret == 0
}

// Creates an executable shim in the bin/ folder pointing to the actual downloaded Odin compiler.
// Using a wrapper script natively fixes relative path standard library ("core") resolution issues
// compared to using symlinks, which differ greatly across OSs.
create_wrapper_script :: proc(target_exe: string, bin_name: string) {
    bat_name := fmt.tprintf("%s.bat", bin_name)
    if ODIN_OS == .Windows {
        bat_path, _ := filepath.join([]string{cfg.bin_dir, bat_name}, context.allocator)
        
        // Pass all arguments natively in Windows Batch using %*
        content := fmt.tprintf("@echo off\n\"%s\" %%*\n", target_exe)
        
        write_err := os.write_entire_file(bat_path, transmute([]u8)content)
        if write_err != nil {
            fmt.eprintln("Error: Failed to write wrapper odin.bat script.")
            os.exit(1)
        }
    } else {
        sh_path, _  := filepath.join([]string{cfg.bin_dir, bin_name}, context.allocator)
        
        // Pass all arguments natively in POSIX Shell using "$@"
        content := fmt.tprintf("#!/bin/sh\nexec \"%s\" \"$@\"\n", target_exe)
        
        write_err := os.write_entire_file(sh_path, transmute([]u8)content)
        if write_err != nil {
            fmt.eprintln("Error: Failed to write wrapper sh script.")
            os.exit(1)
        }
        
        // Make the generated shell script executable on Linux/macOS
        chmod_cmd := fmt.tprintf("chmod +x \"%s\"", sh_path)
        if run_command(chmod_cmd) != 0 {
            fmt.eprintf("Warning: Failed to make '%s' executable. You may need to run 'chmod +x' manually.\n", sh_path)
        }
    }
}

print_version :: proc() {
    filename := fmt.tprintf("%s/.version", cfg.home_dir)

    data, err := os.read_entire_file(filename, context.allocator)
    if err != nil {
        fmt.eprintf("%s%s⚠ Warning: Could not read %s%s\n", B_YELLOW, BOLD, filename, RESET)
        fmt.eprintf("%sPlease reinstall or update to ensure the version file is created correctly.%s\n\n", GRAY, RESET)

        fmt.printf("%s%sodinup%s %sversion unknown%s\n", BOLD, B_CYAN, RESET, B_RED, RESET)
        fmt.printf("%sA native tool to manage Odin and Ols%s\n", GRAY, RESET)
        fmt.printf("%sGitHub: %shttps://github.com/prathmesh-barot/odinup%s\n", GRAY, B_BLUE, RESET)
        return
    }
    defer delete(data, context.allocator)

    version_str := strings.trim_space(string(data))

    if version_str == "" {
        version_str = "unknown"
    }

    fmt.printf("%s%sodinup%s version %s%s%s\n", BOLD, B_CYAN, RESET, B_GREEN, version_str, RESET)
    fmt.printf("%sA native tool to manage Odin and Ols%s\n", GRAY, RESET)
    fmt.printf("%sGitHub: https://github.com/prathmesh-barot/odinup%s\n", B_BLUE, RESET)
}