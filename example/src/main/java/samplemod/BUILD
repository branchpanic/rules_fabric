java_library(
    name = "sample_mod",
    srcs = glob(["*.java"]),
    resources = [
        "//src/main/resources:sample_mod_resources",
    ],
    deps = [
        "//:minecraft_named",
        "@maven//:net_fabricmc_fabric_loader",
    ],
)

load("@rules_fabric//fabric:jar_tools.bzl", "remapped_jar")

remapped_jar(
    name = "sample_mod_dist",
    src = ":sample_mod",
    dst_mapping_name = "intermediary",
    mappings = "@yarn//:mappings",
    src_mapping_name = "named",
)
