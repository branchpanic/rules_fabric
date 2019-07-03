def _remapped_jar_impl(ctx):
    java_runtime = ctx.attr._java_runtime[java_common.JavaRuntimeInfo]

    cmd = "set -e \n"
    cmd += "export JAVA_HOME=%s\n" % java_runtime.java_home
    cmd += "%s -jar %s %s %s %s %s %s %s" % (
        java_runtime.java_executable_exec_path,
        ctx.file._tinyremapper.path,
        ctx.file.src.path,
        ctx.outputs.mapped_jar.path,
        ctx.file.mappings.path,
        ctx.attr.src_mapping_name,
        ctx.attr.dst_mapping_name,
        " ".join(ctx.attr.tinyremapper_opts),
    )

    ctx.actions.run_shell(
        tools = [ctx.file._tinyremapper],
        inputs = [ctx.file.src, ctx.file.mappings] + ctx.files._java_runtime,
        outputs = [ctx.outputs.mapped_jar],
        command = cmd,
        use_default_shell_env = True,
        mnemonic = "TinyRemap",
        progress_message = "Remapping %s from %s to %s with mappings %s to produce %s" % (
            ctx.file.src.basename,
            ctx.attr.src_mapping_name,
            ctx.attr.dst_mapping_name,
            ctx.file.mappings.basename,
            ctx.outputs.mapped_jar.basename,
        ),
    )

    return JavaInfo(
        output_jar = ctx.outputs.mapped_jar,
        compile_jar = ctx.outputs.mapped_jar,
    )

remapped_jar = rule(
    implementation = _remapped_jar_impl,
    attrs = {
        "src": attr.label(mandatory = True, allow_single_file = [".jar"]),
        "mappings": attr.label(mandatory = True, allow_single_file = [".tiny"]),
        "src_mapping_name": attr.string(mandatory = True),
        "dst_mapping_name": attr.string(mandatory = True),
        "tinyremapper_opts": attr.string_list(default = ["--renameinvalidlocals", "--rebuildsourcefilenames"]),
        "_java_runtime": attr.label(
            cfg = "host",
            default = Label("@bazel_tools//tools/jdk:current_java_runtime"),
        ),
        "_tinyremapper": attr.label(
            executable = True,
            cfg = "host",
            default = "@tinyremapper//file",
            allow_single_file = True,
        ),
    },
    outputs = {
        "mapped_jar": "%{name}.jar",
    },
    doc = """
Remaps names in a jar file based on a set of Tiny mappings.
""",
)

def chain_remapped_jar(
        base_name,
        src,
        mappings,
        names,
        **kwargs):
    for i in range(1, len(names)):
        src_mapping_name = names[i - 1]
        dst_mapping_name = names[i]

        remap_src = ":" + base_name + "_" + src_mapping_name
        if i == 1:
            remap_src = src

        remapped_jar(
            name = base_name + "_" + dst_mapping_name,
            src = remap_src,
            mappings = mappings,
            src_mapping_name = src_mapping_name,
            dst_mapping_name = dst_mapping_name,
            **kwargs
        )

def _merged_jar_impl(ctx):
    java_runtime = ctx.attr._java_runtime[java_common.JavaRuntimeInfo]

    cmd = "set -e\n"
    cmd += "export JAVA_HOME=%s\n" % java_runtime.java_home
    cmd += "%s -jar %s mergeJar %s %s %s --syntheticParams" % (
        java_runtime.java_executable_exec_path,
        ctx.file._stitch.path,
        ctx.file.client_jar.path,
        ctx.file.server_jar.path,
        ctx.outputs.merged_jar.path,
    )

    ctx.actions.run_shell(
        tools = [ctx.file._stitch],
        inputs = [ctx.file.client_jar, ctx.file.server_jar] + ctx.files._java_runtime,
        outputs = [ctx.outputs.merged_jar],
        command = cmd,
        use_default_shell_env = True,
        mnemonic = "StitchMerge",
        progress_message = "Merging client: %s and server: %s to produce %s" % (
            ctx.file.client_jar.basename,
            ctx.file.server_jar.basename,
            ctx.outputs.merged_jar.basename,
        ),
    )

merged_jar = rule(
    implementation = _merged_jar_impl,
    attrs = {
        "client_jar": attr.label(mandatory = True, allow_single_file = [".jar"]),
        "server_jar": attr.label(mandatory = True, allow_single_file = [".jar"]),
        "_java_runtime": attr.label(
            cfg = "host",
            default = Label("@bazel_tools//tools/jdk:current_java_runtime"),
        ),
        "_stitch": attr.label(
            executable = True,
            cfg = "host",
            default = "@stitch//file",
            allow_single_file = True,
        ),
    },
    outputs = {
        "merged_jar": "%{name}.jar",
    },
    doc = """
Creates a single "merged" jar from a "client" and "server" jar built from the
same codebase.
""",
)
