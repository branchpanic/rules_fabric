java_library(
    name = "mixin_annotation_processor",
    exported_plugins = [
        ":mixin_injection_obf_processor",
        ":mixin_targets_obf_processor",
    ],
    visibility = [
        "//visibility:public",
    ],
    exports = [
        "@maven//:net_fabricmc_fabric_mixin_compile_extensions",
        "@maven//:net_fabricmc_sponge_mixin",
        "@maven//:org_ow2_asm_asm",
        "@maven//:org_ow2_asm_asm_analysis",
        "@maven//:org_ow2_asm_asm_commons",
        "@maven//:org_ow2_asm_asm_tree",
        "@maven//:org_ow2_asm_asm_util",
    ],
)

java_plugin(
    name = "mixin_injection_obf_processor",
    generates_api = 1,
    processor_class = "org.spongepowered.tools.obfuscation.MixinObfuscationProcessorInjection",
    deps = [
        "@maven//:net_fabricmc_fabric_mixin_compile_extensions",
        "@maven//:net_fabricmc_sponge_mixin",
    ],
)

java_plugin(
    name = "mixin_targets_obf_processor",
    generates_api = 1,
    processor_class = "org.spongepowered.tools.obfuscation.MixinObfuscationProcessorTargets",
    deps = [
        "@maven//:net_fabricmc_fabric_mixin_compile_extensions",
        "@maven//:net_fabricmc_sponge_mixin",
    ],
)
