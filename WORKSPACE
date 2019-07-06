workspace(name = "me_branchpanic_rules_fabric")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

RULES_JVM_EXTERNAL_TAG = "2.2"

RULES_JVM_EXTERNAL_SHA = "f1203ce04e232ab6fdd81897cf0ff76f2c04c0741424d192f28e65ae752ce2d6"

http_archive(
    name = "rules_jvm_external",
    sha256 = RULES_JVM_EXTERNAL_SHA,
    strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
    url = "https://github.com/bazelbuild/rules_jvm_external/archive/%s.zip" % RULES_JVM_EXTERNAL_TAG,
)

load("@rules_jvm_external//:defs.bzl", "maven_install")

maven_install(
    artifacts = [
        "net.fabricmc:fabric-loom:0.2.5-SNAPSHOT",
    ],
    fail_on_missing_checksum = False,  # org.cadixdev.mercury has no MD5
    repositories = [
        "https://jcenter.bintray.com/",
        "https://maven.fabricmc.net/",
    ],
)
