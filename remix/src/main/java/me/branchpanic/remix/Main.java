package me.branchpanic.remix;

import java.nio.file.Path;
import java.nio.file.Paths;

import net.fabricmc.loom.util.MixinRefmapHelper;

class Main {

    public static void main(String[] args) {
        if (args.length < 4) {
            System.err.printf("usage: %s <filename> <refmap> <output>", args[0]);
        }

        String filename = args[1];
        String refmap = args[2];
        Path output = Paths.get(args[3]);

        boolean success = MixinRefmapHelper.addRefmapName(filename, refmap, output);

        if (!success) {
            System.out.println("No remapping took place.");
        } else {
            System.out.println("Remapped successfully.");
        }
    }
}
