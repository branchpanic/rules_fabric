# Bazel Rules for Fabric

This repository contains Bazel build rules for working with the Fabric
modding toolchain. When working with Minecraft, using
[Loom](https://github.com/FabricMC/fabric-loom) with Gradle may be a more
practical option.

## Usage

Section TODO: See the `example/` directory.

## Implementation Status

- [x] Minecraft-specific features
  - [x] Fetching official Minecraft jars
- [x] Merging client and server jars
- [x] Remapping jars
  - [x] One step (i.e. official -> intermediary, named -> intermediary)
  - [x] Multiple steps (i.e. official -> intermediary -> named)
- [x] Mixins
