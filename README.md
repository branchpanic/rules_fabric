# Bazel Rules for Fabric

This repository contains Bazel build rules for working with the Fabric
toolchain on any application. **Using Loom and Gradle will almost always
be more practical when working with Minecraft**.

These rules give you **total control** over your Fabric environment. You can
replace any tool or jar along the way with a custom-built one if you so desire,
which may be useful when forking a tool like Stitch.

While Fabric is only useful for applications written in Java, custom toolchains
may use any language (as they are invoked from the command line) for their
components.

## Usage

In this example we'll use the Fabric toolchain to develop against Minecraft.
In addition to being the most common use case, it has two challenges Fabric
is equipped to handle: obfuscated code and separate client/server binaries
built from the same codebase.

### Build Environment

#### WORKSPACE

Our WORKSPACE file fetches the required external dependencies.

First, we'll fetch Yarn mappings as a .jar archive from the Fabric maven. If
you are including your desired .tiny mappings in your source tree (which might
not be a bad idea if this is a "one-off" project), there's no need for this
step.

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "yarn",
    url = "https://maven.fabricmc.net/net/fabricmc/yarn/1.14.3%2Bbuild.9/yarn-1.14.3%2Bbuild.9.jar",
    sha256 = "1efca049d17d555e4d1ebda517cb12db1365c3cc11019c65fcf5c00091e9199a",
    build_file_content =
        """filegroup(
                name = "mappings",
                srcs = glob(["**/*.tiny"]),
                visibility = ["//visibility:public"])
            )
        """
)
```

We're going to build against Minecraft in this example, so we also need to
fetch its binaries. A helper repository rule is provided for fetching
Minecraft jars from Mojang's servers (as Loom would).

In this example we've named the repository "mojang," so the two jars will
have labels `@mojang//:minecraft_client` and `@mojang//:minecraft_server`.

Merging jars is a separate step. All we're doing in our WORKSPACE is
fetching external resources-- not processing them yet.

```python
load("@rules_fabric//:minecraft.bzl", "mojang_minecraft_jars")
mojang_minecraft_jars(
    name = "mojang",
    version = "1.14.3"
)
```

If your game involves only one jar, just download (or instruct your users to
obtain) that. If you need to use Fabric, you probably can't/shouldn't distribute
your target jar file.

#### BUILD

In the BUILD file, we'll process the artifacts we obtained above. Minecraft 
comes as a split jar, so we want a rule to merge it:

```python
merged_jar(
    name = "minecraft_merged",
    srcs = ["@mojang//:minecraft_client", "@mojang//:minecraft_server"]
)
```

This uses the default Fabric toolchain which fetches Stitch from the Fabric
Maven. See the the Custom Fabric Toolchains section for instructions on using
a different merging and remapping tool.

Minecraft's code is obfuscated, meaning that the names in the jar will be
useless for development. We can apply the mappings downloaded before to a rule
that produces a developer-friendly jar.

```python
mapped_jar(
    name = "minecraft_mapped",
    src = ":minecraft_merged",
    mappings = "@yarn//:mappings"
)
```

This jar is now ready to use as a standard Java dependency.

## Creating a Sources Jar

To view sources of our target, we need to properly decompile it. The default
toolchain uses Fernflower, however replacing it with Procyon (or even
ForgeFlower if you dare) would be trivial. See the Custom Fabric Toolchains
section for a guide.

**TODO**

## Custom Fabric Toolchains

**TODO**
