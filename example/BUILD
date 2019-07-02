load("@rules_fabric//:mapping.bzl", "remapped_jar", "merged_jar")

merged_jar(
    name = "minecraft_merged",
    srcs = ["@mojang//minecraft_client", "@mojang//minecraft_server"]
)

remapped_jar(
    name = "minecraft_mapped",
    src = ":minecraft_merged",
    mappings = "@yarn//:mappings"
)
