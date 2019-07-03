# Bazel Rules for Fabric

This repository contains Bazel build rules for working with the Fabric
toolchain on any application. **Using Loom and Gradle will almost always
be more practical when working with Minecraft**.

## Usage

Section TODO: See the `example/` directory for a sample mod.

## Implementation Status

- [x] Minecraft-specific features
  - [x] Fetching official Minecraft jars
- [x] Merging client and server jars
- [x] Remapping jars
  - [x] One step (i.e. official -> intermediary, named -> intermediary)
  - [x] Multiple steps (i.e. official -> intermediary -> named)
- [ ] Mixins
