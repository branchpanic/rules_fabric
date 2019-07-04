load("@rules_fabric//fabric:jar_tools.bzl", "chain_remapped_jar", "merged_jar")

merged_jar(
    name = "minecraft_merged",
    client_jar = "@mojang//:minecraft_client",
    server_jar = "@mojang//:minecraft_server",
)

chain_remapped_jar(
    src = ":minecraft_merged",
    base_name = "minecraft",
    mappings = "@yarn//:mappings",
    names = [
        "official",
        "intermediary",
        "named",
    ],
    visibility = ["//:__subpackages__"],
)
