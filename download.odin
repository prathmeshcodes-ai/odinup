package odinup

import "core:fmt"
import "core:os"
import "core:strings"

download_asset :: proc(version: string, asset_url: string, dest_file: string) {
    fmt.printf("Downloading %s from %s...\n", version, asset_url)
    cmd := fmt.tprintf("curl -L --progress-bar \"%s\" -o \"%s\"", asset_url, dest_file)
    if run_command(cmd) != 0 {
        fmt.eprintln("Error: Failed to download the release asset.")
        os.exit(1)
    }
}

extract_tar :: proc(archive: string, dest: string) {
    cmd := fmt.tprintf("tar -xzf \"%s\" -C \"%s\"", archive, dest)
    if run_command(cmd) != 0 {
        fmt.eprintln("Error: Failed to extract tar archive.")
        os.exit(1)
    }
}

extract_zip :: proc(archive: string, dest: string) {
    cmd := ""
    if ODIN_OS == .Windows {
        // Windows 10+ built-in tar supports unzipping easily
        cmd = fmt.tprintf("tar -xf \"%s\" -C \"%s\"", archive, dest)
    } else {
        cmd = fmt.tprintf("unzip -q \"%s\" -d \"%s\"", archive, dest)
    }
    
    if run_command(cmd) != 0 {
        fmt.eprintln("Error: Failed to extract zip archive.")
        os.exit(1)
    }
}