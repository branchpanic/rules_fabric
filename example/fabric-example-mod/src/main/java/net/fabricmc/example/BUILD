load("@me_branchpanic_rules_fabric//fabric/mixin:refmap.bzl", "mixin_refmap", "remapped_mixins")

mixin_refmap(
    name = "examplemod_refmap_gen",
    srcs = glob(["**/*.java"]),
    mappings = "@yarn//:mappings",
    visibility = ["//src/main/resources:__pkg__"],
    deps = [
        "//:minecraft_named",
        "@maven//:net_fabricmc_fabric_loader",
        "@me_branchpanic_rules_fabric//fabric/mixin:mixin_annotation_processor",
    ],
)

java_library(
    name = "examplemod",
    srcs = glob(["**/*.java"]),
    resources = [
        "//src/main/resources:examplemod_refmap",
        "//src/main/resources:examplemod_resources",
    ],
    deps = [
        "//:minecraft_named",
        "@maven//:net_fabricmc_fabric_loader",
        "@maven//:net_fabricmc_sponge_mixin",
    ],
)

load("@me_branchpanic_rules_fabric//fabric:jar_tools.bzl", "remapped_jar")

remapped_jar(
    name = "examplemod_remapped",
    src = ":examplemod",
    dst_mapping_name = "intermediary",
    mappings = "@yarn//:mappings",
    src_mapping_name = "named",
)

remapped_mixins(
    name = "examplemod_dist",
    src = ":examplemod_remapped",
    refmap = "//src/main/resources:examplemod_refmap",
)
