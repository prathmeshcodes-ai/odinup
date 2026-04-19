package odinup

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"

install_version :: proc(version: string, ols: bool) {
    if ols {
        fmt.println("Ols")
        dest_dir, _ := filepath.join([]string{cfg.ols_dir, version}, context.allocator)
        if os.exists(dest_dir) {
            fmt.printf("%s✔ Version %s is already installed.%s\n", GREEN, version, RESET)
            return
        }

        releases := fetch_releases_ols()
        asset_url, asset_name := find_asset_for_platform(releases, version)
        
        if asset_url == "" {
            fmt.eprintf("%s✖ Error: Could not find a compatible binary for this OS/Arch for version %s%s\n", RED, version, RESET)
            os.exit(1)
        }

        tmp_archive, _ := filepath.join([]string{cfg.home_dir, asset_name}, context.allocator)
        defer os.remove(tmp_archive)
        
        download_asset(version, asset_url, tmp_archive)

        fmt.println("Extracting archive...")
        ensure_dir(dest_dir)
        
        if strings.has_suffix(asset_name, ".zip") {
            extract_zip(tmp_archive, dest_dir)
        } else {
            extract_tar(tmp_archive, dest_dir)
        }

        //fmt.printf("Successfully installed Ols %s!\n", version)
        fmt.printf("\n%s%sSuccessfully installed Ols %s!%s\n", GREEN, BOLD, version, RESET)
        fmt.printf("Type %sodinup use %s%s to activate it.\n", CYAN, version, RESET)
    } else {
        dest_dir, _ := filepath.join([]string{cfg.odin_dir, version}, context.allocator)
        if os.exists(dest_dir) {
            fmt.printf("%s✔ Version %s is already installed.%s\n", GREEN, version, RESET)
            return
        }

        releases := fetch_releases()
        asset_url, asset_name := find_asset_for_platform(releases, version)
        
        if asset_url == "" {
            fmt.eprintf("%s✖ Error: Could not find a compatible binary for this OS/Arch for version %s%s\n", RED, version, RESET)
            os.exit(1)
        }

        tmp_archive, _ := filepath.join([]string{cfg.home_dir, asset_name}, context.allocator)
        defer os.remove(tmp_archive)
        
        download_asset(version, asset_url, tmp_archive)

        fmt.println("Extracting archive...")
        ensure_dir(dest_dir)
        
        if strings.has_suffix(asset_name, ".zip") {
            extract_zip(tmp_archive, dest_dir)
        } else {
            extract_tar(tmp_archive, dest_dir)
        }

        //fmt.printf("Successfully installed Odin %s!\n", version)
        fmt.printf("\n%s%sSuccessfully installed Odin %s!%s\n", GREEN, BOLD, version, RESET)
        fmt.printf("Type %sodinup use %s%s to activate it.\n", CYAN, version, RESET)
    }
}

find_asset_for_platform :: proc(releases:[]Github_Release, version: string) -> (url: string, name: string) {
    expected_os, expected_arch := platform_strings()
    
    for rel in releases {
        if rel.tag_name == version {
            for asset in rel.assets {
                lower_name := strings.to_lower(asset.name)
                if strings.contains(lower_name, expected_os) && strings.contains(lower_name, expected_arch) {
                    return asset.browser_download_url, asset.name
                }
            }
        }
    }
    return "", ""
}

platform_strings :: proc() -> (os_str: string, arch_str: string) {
    if ODIN_OS == .Windows do os_str = "windows"
    else if ODIN_OS == .Darwin do os_str = "macos"
    else if ODIN_OS == .Linux do os_str = "linux"

    if ODIN_ARCH == .amd64 do arch_str = "amd64"
    else if ODIN_ARCH == .arm64 do arch_str = "arm64"
    
    return os_str, arch_str
}