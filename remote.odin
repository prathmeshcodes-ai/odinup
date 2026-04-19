package odinup

import "core:fmt"
import "core:os"
import "core:encoding/json"
import "core:path/filepath"

Github_Asset :: struct {
    name:                 string,
    browser_download_url: string,
}

Github_Release :: struct {
    tag_name: string,
    assets:[]Github_Asset,
}

fetch_releases :: proc() ->[]Github_Release {
    url := "https://api.github.com/repos/odin-lang/Odin/releases"
    tmp_file, _ := filepath.join([]string{cfg.home_dir, "releases.json"}, context.allocator)
    defer os.remove(tmp_file)

    // Download JSON strictly using curl (standardized across Unix + modern Windows)
    cmd := fmt.tprintf("curl -s -L \"%s\" -o \"%s\"", url, tmp_file)
    if run_command(cmd) != 0 {
        fmt.eprintln("Error: Failed to fetch releases from GitHub using curl.")
        os.exit(1)
    }

    data, read_err := os.read_entire_file_from_path(tmp_file, context.allocator)
    if read_err != nil {
        fmt.eprintln("Error: Failed to read downloaded releases.json")
        os.exit(1)
    }
    defer delete(data)

    releases:[]Github_Release
    err := json.unmarshal(data, &releases)
    if err != nil {
        fmt.eprintln("Error: Failed to parse GitHub API JSON response.")
        os.exit(1)
    }

    return releases
}

list_remote :: proc() {
    fmt.println("Fetching remote versions from GitHub...")
    releases := fetch_releases()
    for rel in releases {
        fmt.printf("  %s\n", rel.tag_name)
    }
}