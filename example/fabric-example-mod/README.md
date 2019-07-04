# Example: Fabric Example Mod

Now with 100% less Gradle and 100% more complexity.

To build a loadable mod jar, run:

```sh
bazel build //src/main/java/net/fabricmc/example:examplemod_dist
```

This generates both `libexamplemod.jar` (NOT remapped and thus will crash on
production Fabric) and `examplemod_dist.jar` (remapped to Intermediary,
suitable for distribution), among other files.

## Points of Interest

### /WORKSPACE

Dependencies are retrieved in the workspace: Minecraft jars, Yarn mappings, and
Maven dependencies (Fabric and Mixin in this case).

Note the call to `fabric_repositories`. This downloads Stitch and TinyRemapper
under labels `@stitch//files` and `@tinyremapper//files`.

### /BUILD

The topmost BUILD file contains rules for merging and remapping Minecraft jars.

### /src/main/java/net/fabricmc/example/BUILD

This BUILD file builds the actual mod as a Java library
(`//src/.../example:examplemod`). Additionally, a remapped jar
(`//src/.../example:examplemod_dist`) is created. This jar is suitable for
distribution (CurseForge, etc.).

### /src/main/resources/BUILD

This BUILD file contains a filegroup of the mod's resources (mixin listing,
Fabric mod definition, textures).
