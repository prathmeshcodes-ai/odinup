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

// Creates an executable shim in the bin/ folder pointing to the actual downloaded Odin compiler.
// Using a wrapper script natively fixes relative path standard library ("core") resolution issues
// compared to using symlinks, which differ greatly across OSs.
create_wrapper_script :: proc(target_exe: string) {
    if ODIN_OS == .Windows {
        bat_path, _ := filepath.join([]string{cfg.bin_dir, "odin.bat"}, context.allocator)
        
        // Pass all arguments natively in Windows Batch using %*
        content := fmt.tprintf("@echo off\n\"%s\" %%*\n", target_exe)
        
        write_err := os.write_entire_file(bat_path, transmute([]u8)content)
        if write_err != nil {
            fmt.eprintln("Error: Failed to write wrapper odin.bat script.")
            os.exit(1)
        }
    } else {
        sh_path, _ := filepath.join([]string{cfg.bin_dir, "odin"}, context.allocator)
        
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