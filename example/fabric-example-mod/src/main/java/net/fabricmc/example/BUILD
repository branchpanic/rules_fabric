java_library(
    name = "examplemod",
    srcs = glob(["**/*.java"]),
    resources = [
        "//src/main/resources:examplemod_resources",
    ],
    deps = [
        "//:minecraft_named",
        "@maven//:net_fabricmc_fabric_loader",
        "@maven//:org_spongepowered_mixin",
    ],
)

load("@me_branchpanic_rules_fabric//fabric:jar_tools.bzl", "remapped_jar")

remapped_jar(
    name = "examplemod_dist",
    src = ":examplemod",
    dst_mapping_name = "intermediary",
    mappings = "@yarn//:mappings",
    src_mapping_name = "named",
)
