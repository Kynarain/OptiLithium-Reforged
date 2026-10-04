# SPDX-License-Identifier: LGPL-3.0-only
# One place to say which jars belong to which Minecraft release, so every other script stays version-agnostic.
#
# Dot-source it:  . "$PSScriptRoot\versions.ps1"
#
# WHY A TABLE AND NOT A CONVENTION. Two of the three inputs do not follow the release:
#
#   * OptiFabric's 1.21.x line does not publish every release. 1.21.10 and 1.21.11 have jars; 1.21.1, 1.21.5 and
#     others have none at all, and their jars name the release they were built for in the file name rather than
#     1:1 with the game version (1.21.2 was built against 1.21.3);
#   * OptiFine ships *preview* builds for most releases, and the version string inside the jar is what the
#     loader checks - the file name is not enough.
#
# Guessing any of that from the release number produces a run that tests the wrong jar and looks like a real
# result, so the mapping is written out.

# WHERE THE INPUTS LIVE, resolved rather than spelled out.
#
# These directories are machine-specific, and they MOVE. The OptiFabric fork sat at
# C:\Users\kynar\IdeaProjects\OptiFabric until it was relocated to I:\mods\OptiFabric; because the path was a
# literal in this file, 12 of the 16 releases stopped resolving in one step, and every one of them reported the
# same thing - "OptiFabric jar not found" - which reads like a build that was never made, not like a directory
# that moved. A hard-coded path can only fail that way, so each directory is looked up instead:
#
#   1. the environment variable named below, when it is set   - the override for a one-off run or another machine
#   2. the first candidate that EXISTS                         - the normal case; moving a project adds a line
#                                                               here rather than replacing one
#   3. the first candidate regardless                         - so an error message still names a real path
#
# Resolution only decides WHICH directory to look in. Get-ReleaseJars still fails loudly, per release, when a jar
# is absent from whichever directory won, so a missing build can never pass as a resolved one.
function Resolve-InputDir {
	param(
		# Environment variable that overrides the search, e.g. OPTIFABRIC_DIST.
		[string]$EnvVar,
		# Known locations, most current first.
		[string[]]$Candidates
	)

	if ($EnvVar) {
		$override = [Environment]::GetEnvironmentVariable($EnvVar)
		if ($override) {
			# A set-but-wrong override is a typo, not a fallback: silently searching elsewhere would hide it.
			if (-not (Test-Path $override)) { throw "$EnvVar is set to '$override', which does not exist" }
			return $override
		}
	}

	$found = @($Candidates | Where-Object { Test-Path $_ } | Select-Object -First 1)
	if ($found.Count) { return [string]$found[0] }
	return $Candidates[0]
}

# This project's own version, in semver, and the single place it is written down.
#
# It follows the same shape this workspace's OptiFabric line uses: "<mod version>+mc<Minecraft version>", e.g.
# OptiLithium-Reforged-1.0.0+mc1.21.11.jar. The +mc... part is semver BUILD METADATA, which is exactly what it is - the same
# release built for a different Minecraft - so the release number and the build target each have their own field
# instead of being entangled in one string.
#
# AN OPTILITHIUM VERSION DESCRIBES THE REPACKAGING, NOT THE LITHIUM INSIDE IT. Lithium's version is not this
# project's to bump, and it is already recorded where it belongs: the jar's own fabric.mod.json keeps the upstream
# id, name and version untouched (see README §10.2 for why the id must stay `lithium`), and the OPTILITHIUM-REFORGED.txt
# inside the jar carries both the upstream version and the upstream file's sha256. So a reader comparing two
# OptiLithium builds can tell them apart by this number and find out which Lithium each one wraps from the record.
#
# Bump it when the repackaging changes - a different mixin group switched off per release, a different rule for
# which entries are removed. Do NOT bump it per Minecraft release; that is what the +mc suffix is for.
$script:ModVersion = '1.0.0'

$script:LithiumScratch = Resolve-InputDir -EnvVar 'LITHIUM_SCRATCH' -Candidates @(
	'I:\mods\scratch\lithium'                                                              # since the move
	(Join-Path (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) 'scratch\lithium')   # next to the sibling projects
	'C:\Users\kynar\IdeaProjects\scratch\lithium'                                          # where it was
)
$script:OptiFineScratch = Resolve-InputDir -EnvVar 'OPTIFINE_SCRATCH' -Candidates @(
	'I:\mods\scratch\optifine'                                                             # since the move
	(Join-Path (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) 'scratch\optifine')  # next to the sibling projects
	'C:\Users\kynar\IdeaProjects\scratch\optifine'                                         # where it was
)
$script:OptiFabricDist = Resolve-InputDir -EnvVar 'OPTIFABRIC_DIST' -Candidates @(
	'I:\mods\OptiFabric\dist'                                                              # since the move
	(Join-Path (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) 'OptiFabric\dist')   # sibling project
	'C:\Users\kynar\IdeaProjects\OptiFabric\dist'                                          # where it was
)
# OptiFabric builds that are neither in the fork's dist nor reachable from it: the UPSTREAM 1.20.x line, which
# was only ever published on CurseForge. It is a single jar for every 1.20 release:
#
#   optifabric-1.14.3.jar   CurseForge file 5025647, project 322385, published 2024-01-12
#   sha1 e0818735cc2272ff7704e7a6d28d38d154e65f37 (verified after download)
#   depends: minecraft [1.20, 1.20.1, 1.20.2, 1.20.4]; breaks: no_fog, thallium, xradiation, ... (NOT lithium)
#
# It is the LAST upstream release: 1.20.6 and later have no upstream build, which is why this workspace's own
# OptiFabric fork starts at 1.20.6 (its `main` branch) and continues on 1.21.x / 26.x.
$script:ThirdParty = Join-Path (Split-Path -Parent $PSScriptRoot) 'thirdparty'


# Where each release ends up, and WHICH MIXIN GROUPS IT NEEDS SWITCHED OFF.
#
# The mixin groups are the measured part, not a guess: each entry below is a group whose absence was required for
# the client to reach the world, established by launching the release and reading the failure. The same two groups
# cover every 1.21.x / 26.x release; 1.21 alone also needs block.hopper, because there method_31664 is declared on
# BlockEntity and Mixin does not search supertypes for an @Inject target (measured on 1.21, absent on 1.21.3+).
#
# Releases that are BLOCKED by something this project cannot fix are listed too, with the blocker written out, so
# a reader does not have to re-derive why a version is missing from the working set.
$script:StandardGroups = @(
	'mixin.minimal_nonvanilla=false'
	'mixin.util.inventory_comparator_tracking=false'
)

$script:ExtraGroups = [ordered]@{
	# method_31664 lives on class_2586 here, so block.hopper's @Inject cannot find it on class_2614.
	'1.21' = @('mixin.block.hopper=false')
}

# The status of each release, as MEASURED (see the README for the runs). 'inworld' means the client reached
# "Preparing spawn area" with the shader pack loaded and 0 patched-class failures.
$script:MeasuredStatus = [ordered]@{
	'1.20'    = 'blocked: upstream OptiFabric 1.14.3 stops during OptiFine remapping on Fabric Loader 0.19.5'
	'1.20.1'  = 'blocked: same as 1.20'
	'1.20.2'  = 'blocked: same as 1.20'
	'1.20.4'  = 'blocked: same as 1.20'
	'1.20.6'  = 'blocked: no OptiFabric build for this release'
	'1.21'    = 'blocked: OptiFabric bytecode - Inlined delegating constructor makes class_5944.method_35785 fail the JVM verifier (same crash with NO Lithium installed)'
	'1.21.1'  = 'blocked: no OptiFabric build for this release'
	'1.21.3'  = 'inworld'
	'1.21.4'  = 'inworld'
	'1.21.6'  = 'blocked: OptiFine ShadersTex NPE at class_1043 during init - reproduced WITHOUT Lithium'
	'1.21.7'  = 'blocked: same OptiFine ShadersTex NPE as 1.21.6'
	'1.21.8'  = 'inworld'
	'1.21.9'  = 'inworld'
	'1.21.10' = 'inworld'
	'1.21.11' = 'inworld (shader pack loaded, 54 programs compiled)'
	# Was recorded as blocked for two days, and that was WRONG. The verdict came from a 5-minute window, and the
	# client had stalled for 4 h 19 m with zero log output before finishing the 26.x world-format upgrade in 2 s and
	# opening the world. Re-run on an idle machine - with the 11 clients that the broken cleanup had left running
	# finally gone - the same upgrade finished 18 s after launch and the release reported IN WORLD, 54 programs.
	# So 'NO WORLD' here meant 'not within the window', not 'the game cannot do it'. See README 6.13.
	'26.1.2'  = 'inworld (shader pack loaded, 54 programs compiled)'
}

# The lines to bake into a release's jar: the standard two, plus whatever that release additionally needs.
function Get-LithiumOptions {
	param([string]$Release)

	$opts = @($script:StandardGroups)
	if ($script:ExtraGroups.Contains($Release)) { $opts += $script:ExtraGroups[$Release] }
	return $opts
}

# release -> @{ lithium; optifine; optifabric; java; profile; note }
$script:Releases = [ordered]@{
	'1.20' = @{
		lithium = '1.20__lithium-fabric-mc1.20-0.11.2.jar'
		optifine = 'preview_OptiFine_1.20_HD_U_I5_pre5.jar'
		# The upstream 1.20.x line, published only on CurseForge: one jar covers 1.20 through 1.20.4.
		optifabric = 'optifabric-1.14.3.jar'
		java = 'C:\Program Files\Java\jdk-17'; profile = '1.20-Fabric-0.19.5'
	}
	'1.20.1' = @{
		lithium = '1.20.1__lithium-fabric-mc1.20.1-0.11.4.jar'
		optifine = 'OptiFine_1.20.1_HD_U_I6.jar'
		optifabric = 'optifabric-1.14.3.jar'
		java = 'C:\Program Files\Java\jdk-17'; profile = '1.20.1-Fabric-0.19.5'
	}
	'1.20.2' = @{
		lithium = '1.20.2__lithium-fabric-mc1.20.2-0.12.0.jar'
		optifine = 'preview_OptiFine_1.20.2_HD_U_I7_pre1.jar'
		optifabric = 'optifabric-1.14.3.jar'
		java = 'C:\Program Files\Java\jdk-17'; profile = '1.20.2-Fabric-0.19.5'
	}
	'1.20.4' = @{
		lithium = '1.20.4__lithium-fabric-mc1.20.4-0.12.1.jar'
		optifine = 'OptiFine_1.20.4_HD_U_I7.jar'
		optifabric = 'optifabric-1.14.3.jar'
		java = 'C:\Program Files\Java\jdk-17'; profile = '1.20.4-Fabric-0.19.5'
	}
	'1.20.6' = @{
		lithium = '1.20.6__lithium-fabric-mc1.20.6-0.12.5.jar'
		optifine = 'preview_OptiFine_1.20.6_HD_U_J1_pre18.jar'
		# No upstream OptiFabric for 1.20.6 (1.14.3 stops at the 1.20.4 protocol); this workspace's own fork
		# continues the line from here. Its `main` branch is exactly the 1.20.6 project.
		optifabric = 'OptiFabric-1.1.0+mc1.21.jar'
		java = 'C:\Program Files\Java\jdk-21'; profile = '1.20.6-Fabric-0.19.5'
	}
	'1.21' = @{
		lithium = '1.21__lithium-fabric-mc1.21-0.13.1.jar'
		optifine = 'preview_OptiFine_1.21_HD_U_J1_pre9.jar'
		optifabric = 'OptiFabric-1.1.0+mc1.21.jar'
		java = 'C:\Program Files\Java\jdk-21'; profile = '1.21-Fabric-0.19.5'
	}
	'1.21.1' = @{
		lithium = '1.21.1__lithium-fabric-0.15.4+mc1.21.1.jar'
		optifine = 'OptiFine_1.21.1_HD_U_J1.jar'
		# No 1.21.1 build of OptiFabric; the 1.21 jar is the nearest.
		optifabric = 'OptiFabric-1.1.0+mc1.21.jar'; optifabricIsForeign = $true
		java = 'C:\Program Files\Java\jdk-21'; profile = '1.21.1-Fabric-0.19.5'
	}
	'1.21.3' = @{
		lithium = '1.21.3__lithium-fabric-0.14.6+mc1.21.3.jar'
		optifine = 'OptiFine_1.21.3_HD_U_J2.jar'
		optifabric = 'OptiFabric-1.1.2+mc1.21.3.jar'
		java = 'C:\Program Files\Java\jdk-21'; profile = '1.21.3-Fabric-0.19.5'
	}
	'1.21.4' = @{
		lithium = '1.21.4__lithium-fabric-0.15.3+mc1.21.4.jar'
		optifine = 'OptiFine_1.21.4_HD_U_J3.jar'
		optifabric = 'OptiFabric-1.1.2+mc1.21.4.jar'
		java = 'C:\Program Files\Java\jdk-21'; profile = '1.21.4-Fabric-0.19.5'
	}
	'1.21.6' = @{
		lithium = '1.21.6__lithium-fabric-0.17.0+mc1.21.6.jar'
		optifine = 'preview_OptiFine_1.21.6_HD_U_J6_pre3.jar'
		optifabric = 'OptiFabric-1.1.2+mc1.21.6.jar'
		java = 'C:\Program Files\Java\jdk-21'; profile = '1.21.6-Fabric-0.19.5'
	}
	'1.21.7' = @{
		lithium = '1.21.7__lithium-fabric-0.18.0+mc1.21.7.jar'
		optifine = 'preview_OptiFine_1.21.7_HD_U_J6_pre7.jar'
		optifabric = 'OptiFabric-1.1.2+mc1.21.7.jar'
		java = 'C:\Program Files\Java\jdk-21'; profile = '1.21.7-Fabric-0.19.5'
	}
	'1.21.8' = @{
		lithium = '1.21.8__lithium-fabric-0.18.1+mc1.21.8.jar'
		optifine = 'preview_OptiFine_1.21.8_HD_U_J6_pre16.jar'
		optifabric = 'OptiFabric-1.1.2+mc1.21.8.jar'
		java = 'C:\Program Files\Java\jdk-21'; profile = '1.21.8-Fabric-0.19.5'
	}
	'1.21.9' = @{
		lithium = '1.21.9__lithium-fabric-0.19.2+mc1.21.9.jar'
		optifine = 'preview_OptiFine_1.21.9_HD_U_J7_pre2.jar'
		optifabric = 'OptiFabric-1.1.2+mc1.21.9.jar'
		java = 'C:\Program Files\Java\jdk-21'; profile = '1.21.9-Fabric-0.19.5'
	}
	'1.21.10' = @{
		lithium = '1.21.10__lithium-fabric-0.20.1+mc1.21.10.jar'
		optifine = 'preview_OptiFine_1.21.10_HD_U_J7_pre11.jar'
		optifabric = 'OptiFabric-1.1.2+mc1.21.10.jar'
		java = 'C:\Program Files\Java\jdk-21'; profile = '1.21.10-Fabric-0.19.5'
	}
	'1.21.11' = @{
		lithium = '1.21.11__lithium-fabric-0.21.4+mc1.21.11.jar'
		optifine = 'OptiFine_1.21.11_HD_U_J9.jar'
		optifabric = 'OptiFabric-1.1.2+mc1.21.11.jar'
		java = 'C:\Program Files\Java\jdk-21'; profile = '1.21.11-Fabric-0.19.5'
	}
	'26.1.2' = @{
		lithium = '26.1.2__lithium-fabric-0.24.7+mc26.1.2.jar'
		optifine = 'preview_OptiFine_26.1.2_HD_U_K1_pre2.jar'
		optifabric = 'OptiFabric-Reforged-2.0.0+mc26.1.2.jar'
		# 26.1.2 is the case that shows why this must be read and not inferred: the 26.x OptiFabric renamed
		# itself to optifabric_reforged, but Lithium still names the OLD id in its breaks, so the entry that has
		# to go is 'optifabric'. Removing optifabric_reforged leaves the loader conflict in place - measured, and
		# it is exactly the mistake this table entry now prevents.
		java = Join-Path $env:USERPROFILE '.gradle\jdks\eclipse_adoptium-25-amd64-windows.2'
		profile = '26.1.2-Fabric-0.19.5'
	}
}

# Resolve a release's three jars to full paths and fail loudly when one is absent, so a missing input can never
# present itself as "the patch did not work".
function Get-ReleaseJars {
	param([string]$Release)

	if (-not $script:Releases.Contains($Release)) { throw "unknown release '$Release'" }

	$r = $script:Releases[$Release]

	# OptiFabric comes from the fork's dist\ when the fork built it, and from thirdparty\ when it did not - the
	# upstream 1.20.x line only ever existed on CurseForge, so nothing in this workspace can produce it. Looking in
	# dist first and thirdparty second keeps ONE field in the table above and no path spelled out per release.
	$optifabric = Join-Path $script:OptiFabricDist $r.optifabric
	if (-not (Test-Path $optifabric)) {
		$fromThirdParty = Join-Path $script:ThirdParty $r.optifabric
		if (Test-Path $fromThirdParty) { $optifabric = $fromThirdParty }
	}

	$paths = [ordered]@{
		Lithium   = Join-Path $script:LithiumScratch $r.lithium
		OptiFine  = Join-Path $script:OptiFineScratch $r.optifine
		OptiFabric = $optifabric
		Java      = $r.java
		Profile   = $r.profile
		BreaksId  = if ($r.breaksId) { $r.breaksId } else { 'optifabric' }
		Foreign   = [bool]$r.optifabricIsForeign
	}

	foreach ($k in @('Lithium','OptiFine','OptiFabric')) {
		if (-not (Test-Path $paths[$k])) {
			# The message names the directory that was searched AND how to point somewhere else. When an input
			# project is moved, the directory is the only thing that changed - a bare "not found" sends the reader
			# looking for a build that was never made. (Measured: relocating the OptiFabric fork produced this
			# error for 12 releases at once.)
			$hint = switch ($k) {
				'Lithium'   { "override the directory with `$env:LITHIUM_SCRATCH (searched: $script:LithiumScratch)" }
				'OptiFine'  { "override the directory with `$env:OPTIFINE_SCRATCH (searched: $script:OptiFineScratch)" }
				'OptiFabric' { "override the directory with `$env:OPTIFABRIC_DIST (searched: $script:OptiFabricDist and $script:ThirdParty)" }
			}
			throw "$Release`: $k jar not found at $($paths[$k]) - $hint"
		}
	}

	return $paths
}

# The name of the patched jar this project produces for a release, e.g. "OptiLithium-Reforged-1.0.0+mc1.21.11.jar".
#
# The version field is this project's own semver ($script:ModVersion) and the +mc... tail is semver build metadata
# naming the Minecraft release, matching the OptiFabric convention used elsewhere in this workspace. It is NOT the
# Lithium version: that belongs to upstream and is recorded in the jar's own manifest and in OPTILITHIUM-REFORGED.txt.
#
# It lives here, as one function, so a caller cannot assemble the name slightly differently from the builder and
# then fail to find its own output - which is the failure mode that makes a rename look like a broken build.
function Get-PatchedJarName {
	param([string]$Release)

	return "OptiLithium-Reforged-$($script:ModVersion)+mc$Release.jar"
}
