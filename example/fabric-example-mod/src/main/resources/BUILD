load("@me_branchpanic_rules_fabric//fabric/mixin:refmap.bzl", "mixin_refmap", "remapped_mixins")

filegroup(
    name = "examplemod_resources",
    srcs = glob(["**"]),
    visibility = ["//src/main/java/net/fabricmc/example:__pkg__"],
)

# Something of a hack, but https://github.com/bazelbuild/bazel/issues/97
# still hasn't been addressed. This genrule puts the refmap where the mixin
# JSON will be able to find it (in the root of the jar).

genrule(
    name = "examplemod_refmap",
    srcs = [
        "//src/main/java/net/fabricmc/example:examplemod_refmap_gen",
    ],
    outs = [
        "examplemod_refmap.json",
    ],
    cmd = "cp $(location //src/main/java/net/fabricmc/example:examplemod_refmap_gen) $@",
    visibility = ["//src/main/java/net/fabricmc/example:__pkg__"],
)
