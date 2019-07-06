def _get_transitive_deps(deps):
    """Obtain the source files for a target and its transitive dependencies.

    Args:
      srcs: a list of source files
      deps: a list of targets that are direct dependencies
    Returns:
      a collection of the transitive sources
    """

    flattened_deps = []
    for transitive_deps in [dep[JavaInfo].transitive_deps for dep in deps]:
        flattened_deps.extend(transitive_deps.to_list())
    return flattened_deps

def _mixin_refmap_impl(ctx):
    java_runtime = ctx.attr._java_runtime[java_common.JavaRuntimeInfo]
    transitive_deps = _get_transitive_deps(ctx.attr.deps)

    cmd = "set -e\n"
    cmd += "export JAVA_HOME=%s\n" % java_runtime.java_home
    cmd += "%s/bin/javac -cp %s -proc:only %s -AinMapFileNamedIntermediary=%s -AoutRefMapFile=%s -AdefaultObfuscationEnv=named:intermediary" % (
        java_runtime.java_home,
        ":".join([f.path for f in transitive_deps]),
        " ".join([f.path for f in ctx.files.srcs]),
        ctx.file.mappings.path,
        ctx.outputs.refmap.path,
    )

    ctx.actions.run_shell(
        inputs = ctx.files.srcs + ctx.files.deps + ctx.files.mappings + ctx.files._java_runtime + transitive_deps,
        outputs = [ctx.outputs.refmap],
        command = cmd,
        use_default_shell_env = True,
        mnemonic = "ProcessMixins",
        progress_message = "Generating Mixin refmap",
    )

mixin_refmap = rule(
    implementation = _mixin_refmap_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".java"], mandatory = True),
        "mappings": attr.label(allow_single_file = [".tiny"], mandatory = True),
        "deps": attr.label_list(allow_files = [".jar"], mandatory = True),
        "_java_runtime": attr.label(
            cfg = "host",
            default = Label("@bazel_tools//tools/jdk:current_java_runtime"),
        ),
    },
    outputs = {
        "refmap": "%{name}.json",
    },
)
