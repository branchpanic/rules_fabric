def _remapped_jar_impl(ctx):
    ctx.actions.run_shell(
        command = "touch %s" % ctx.outputs.txt.path,
        outputs = [ctx.outputs.txt],
    )

remapped_jar = rule(
    implementation = _remapped_jar_impl,
    attrs = {
        "mappings": attr.label(mandatory = True, allow_single_file = [".tiny"]),
        "src": attr.label(mandatory = True, allow_single_file = [".jar"]),
    },
    outputs = {
        "jar": "%{name}_mapped.jar",
    },
)

def _merged_jar_impl(ctx):
    pass

merged_jar = rule(
    implementation = _merged_jar_impl,
    attrs = {
        "srcs": attr.label_list(mandatory = True, allow_files = [".jar"])
    }
)
