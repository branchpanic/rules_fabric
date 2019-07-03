load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

def fabric_repositories():
    http_file(
        name = "stitch",
        sha256 = "7e81d68e8cd305814d82354aff5e9dd2c75c73bb3b1a0f8de5e04343bbe8daed",
        urls = ["https://maven.fabricmc.net/net/fabricmc/stitch/0.2.1.61/stitch-0.2.1.61-all.jar"],
    )

    http_file(
        name = "tinyremapper",
        sha256 = "2be548c7811acf637da8b0c7144b1a337dfa5bf6bfe449d2f513a3dd0bd74568",
        urls = ["https://maven.fabricmc.net/net/fabricmc/tiny-remapper/0.1.0.38/tiny-remapper-0.1.0.38-fat.jar"]
    )
