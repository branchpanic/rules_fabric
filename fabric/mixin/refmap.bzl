load("//:defs.bzl", "FABRIC_MIXIN_VERSION")

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

# TODO: Allow mappings other than named->intermediary

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
        "mixin_version": attr.string(default = FABRIC_MIXIN_VERSION),
    },
    outputs = {
        "refmap": "%{name}.json",
    },
)

def _remapped_mixins_impl(ctx):
    java_runtime = ctx.attr._java_runtime[java_common.JavaRuntimeInfo]

    cmd = "set -e\n"
    cmd += "export JAVA_HOME=%s\n" % java_runtime.java_home
    cmd += "%s -jar %s %s %s %s %s" % (
        java_runtime.java_executable_exec_path,
        ctx.file._remix.path,
        ctx.file.refmap.basename,
        ctx.attr.mixin_version,
        ctx.file.src.path,
        ctx.outputs.remapped_jar.path,
    )

    ctx.actions.run_shell(
        tools = [ctx.file._remix],
        inputs = ctx.files.src + ctx.files.refmap + ctx.files._java_runtime,
        outputs = [ctx.outputs.remapped_jar],
        command = cmd,
        use_default_shell_env = True,
    )

remapped_mixins = rule(
    implementation = _remapped_mixins_impl,
    attrs = {
        "src": attr.label(allow_single_file = [".jar"], mandatory = True),
        "refmap": attr.label(allow_single_file = [".json"], mandatory = True),
        "mixin_version": attr.string(default = FABRIC_MIXIN_VERSION),
        "_java_runtime": attr.label(
            cfg = "host",
            default = Label("@bazel_tools//tools/jdk:current_java_runtime"),
        ),
        "_remix": attr.label(
            default = "//remix/src/main/java/me/branchpanic/remix:remix_deploy.jar",
            cfg = "host",
            allow_single_file = True,
        ),
    },
    outputs = {
        "remapped_jar": "%{name}.jar",
    },
)
