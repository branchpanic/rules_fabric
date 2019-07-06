package me.branchpanic.remix;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import java.io.IOException;

import net.fabricmc.loom.util.MixinRefmapHelper;

class Main {

    public static void main(String[] args) throws IOException {
        if (args.length < 4) {
            System.err.printf("usage: remix.jar <refmap> <version> <input> <output>");
            System.exit(1);
        }

        String refmap = args[0];
        String version = args[1];
        Path input = Paths.get(args[2]);
        Path output = Paths.get(args[3]);

        Files.copy(input, output, StandardCopyOption.REPLACE_EXISTING);

        boolean success = MixinRefmapHelper.addRefmapName(refmap, version, output);

        if (!success) {
            System.out.println("No remapping took place.");
        } else {
            System.out.println("Remapped successfully.");
        }
    }
}
