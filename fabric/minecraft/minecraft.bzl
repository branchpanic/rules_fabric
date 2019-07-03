load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
load("//third_party/bazel_json/lib:json_parser.bzl", "json_parse")

def _minecraft_jars_impl(
        repository_ctx,
        **kwargs):
    repository_ctx.download("https://launchermeta.mojang.com/mc/game/version_manifest.json", output = "version_manifest.json")
    manifest = json_parse(repository_ctx.read("version_manifest.json"))

    version_manifest_url = None
    for remote_version in manifest["versions"]:
        if remote_version["id"] == repository_ctx.attr.version:
            version_manifest_url = remote_version["url"]

    if version_manifest_url == None:
        fail(("No remote Minecraft version %s. " +
              "Consider downloading jars manually with http_file rules.") % repository_ctx.attr.version)

    manifest_filename = "%s_manifest.json" % repository_ctx.attr.version
    repository_ctx.download(version_manifest_url, output = manifest_filename)
    version_manifest = json_parse(repository_ctx.read(manifest_filename))

    downloads = version_manifest["downloads"]

    for dist in ("client", "server"):
        repository_ctx.download(downloads[dist]["url"], output = dist + ".jar")

    repository_ctx.file("BUILD", content = """
filegroup(name = "minecraft_client", srcs = ["client.jar"], visibility = ["//visibility:public"])
filegroup(name = "minecraft_server", srcs = ["server.jar"], visibility = ["//visibility:public"])
    """)

minecraft_jars = repository_rule(
    implementation = _minecraft_jars_impl,
    local = True,
    attrs = {
        "version": attr.string(),
        "launcher_manifest": attr.label(default = Label("@mojang_launcher_meta//files"), allow_files = False),
    },
)
