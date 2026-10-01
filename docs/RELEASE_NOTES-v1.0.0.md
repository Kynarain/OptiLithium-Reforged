# OptiLithium-Reforged 1.0.0

**16 个 jar，覆盖 Minecraft 1.20 ~ 1.21.11 与 26.1.2** / 每个 jar 对应一个版本，不可跨版本使用

状态：**加载器冲突已在 16/16 个版本上消除；其中 6 个已实测进入世界并编译光影**

## 这个版本是什么

Lithium 在自己的 `fabric.mod.json` 里写了 `"breaks": {"optifabric": "*"}`，而 Fabric Loader **按模组 id 匹配**这一条，所以装了 OptiFabric 时 Lithium 会让整个启动在加载任何类之前终止：

```
[main/INFO]: Immediate reason: [NEG_HARD_DEP lithium ... {breaks optifabric @ [*]}, ...]
[main/ERROR]: Incompatible mods found!
```

本项目把这一条去掉，并把因 OptiFine 改写而无法注入的 mixin 组写进 **Lithium 自己的默认配置**（`assets/lithium/lithium-mixin-config-default.properties`）。

**没有修改任何 class 文件**——输出 jar 里每个 class 都与上游逐字节相同。改动只有两处，都是配置：

1. `fabric.mod.json` 里删掉一条 `breaks`；
2. 默认配置里把需要的 mixin 组设为 `false`。

jar 内保留了 Lithium 自己的 `id` / `name` / `version` 与许可文件，并附带 `OPTILITHIUM-REFORGED.txt`，记录上游文件名、上游版本、改了哪几行、以及上游文件的 SHA-256。

## 用哪个文件

| Minecraft | 文件 | 需要 OptiFabric | 状态 |
|---|---|---|---|
| 1.20 | `OptiLithium-Reforged-1.0.0+mc1.20.jar` | `optifabric-1.14.3` | 加载器冲突已除；未进世界 |
| 1.20.1 | `…+mc1.20.1.jar` | `optifabric-1.14.3` | 同上 |
| 1.20.2 | `…+mc1.20.2.jar` | `optifabric-1.14.3` | 同上 |
| 1.20.4 | `…+mc1.20.4.jar` | `optifabric-1.14.3` | 同上 |
| 1.20.6 | `…+mc1.20.6.jar` | **无可用构建** | 加载器仍拒绝（OptiFabric 缺 1.20.6 构建） |
| 1.21 | `…+mc1.21.jar` | `OptiFabric-1.1.0+mc1.21` | 加载器冲突已除；未进世界 |
| 1.21.1 | `…+mc1.21.1.jar` | **无可用构建** | 加载器仍拒绝 |
| 1.21.3 | `…+mc1.21.3.jar` | `OptiFabric-1.1.2+mc1.21.3` | **进世界，光影可用** |
| 1.21.4 | `…+mc1.21.4.jar` | `OptiFabric-1.1.2+mc1.21.4` | **进世界，光影可用** |
| 1.21.6 | `…+mc1.21.6.jar` | `OptiFabric-1.1.2+mc1.21.6` | 加载器冲突已除；未进世界 |
| 1.21.7 | `…+mc1.21.7.jar` | `OptiFabric-1.1.2+mc1.21.7` | 加载器冲突已除；未进世界 |
| 1.21.8 | `…+mc1.21.8.jar` | `OptiFabric-1.1.2+mc1.21.8` | **进世界，光影可用** |
| 1.21.9 | `…+mc1.21.9.jar` | `OptiFabric-1.1.2+mc1.21.9` | **进世界，光影可用** |
| 1.21.10 | `…+mc1.21.10.jar` | `OptiFabric-1.1.2+mc1.21.10` | **进世界，光影可用** |
| 1.21.11 | `…+mc1.21.11.jar` | `OptiFabric-1.1.2+mc1.21.11` | **进世界，光影可用** |
| 26.1.2 | `…+mc26.1.2.jar` | `OptiFabric-Reforged-2.0.0+mc26.1.2` | 加载器冲突已除；未进世界 |

## 安装

1. 装 Fabric Loader（1.20 ~ 1.20.4 用 Java 17；1.20.5 ~ 1.21.11 用 Java 21；26.x 用 Java 25）；
2. **用本 jar 替换掉 `mods\` 里原来的官方 Lithium**——不要两个同时放，两者 mod id 相同，加载器会报重复模组；
3. 再放入对应版本的 **OptiFabric** 与 OptiFine（OptiFine 需自备，本项目不打包、不再分发）；
4. 用 Fabric 档案启动。

## 已知限制

- **1.20.6 与 1.21.1 无法使用**：这两个版本没有任何 OptiFabric 构建，用邻近版本的 jar 会被它自己的 `depends minecraft` 挡下。这与 Lithium 无关。
- **1.20 ~ 1.20.4 能过加载器，但进不了世界**：官方 `optifabric-1.14.3`（2024-01 发布，当时 Loader 是 0.15.x）在 Loader 0.19.5 上会卡在 OptiFine 重映射阶段——日志 10 分钟无新增，JVM 仍在运行。这是 OptiFabric 与 Loader 的兼容问题。若想在这些版本上跑通，请改用 **OptiLithium 模组**（独立 mod id，不依赖 OptiFabric）。
- **1.21 能过加载器，但进不了世界**：随后崩在 OptiFabric 自己的 `Inlined delegating constructor` 字节码上（`VerifyError: Bad return type` @ `class_5944.method_35785`）。**去掉 Lithium 后同样崩**，与本项目无关。
- **1.21.6 / 1.21.7 进不了世界**：崩在 OptiFine 自己的 `ShadersTex`（`multiTex` 为 null）。**去掉 Lithium 后同样崩**。
- **26.1.2 不进世界，而不带本模组的游戏也一样**：纯 Fabric 26.1.2 不带任何模组时会忽略 quick play 参数、停在标题界面。

以上每一条都做过"**去掉 Lithium**"的对照实验，确认阻塞点不在 Lithium。完整证据见仓库 README 第三、四节。

## 许可

**LGPL-3.0-only。** 这些 jar 是 **CaffeineMC 的 Lithium 的修改版**，以同一许可分发：保留 Lithium 的许可文件、注明修改内容、并记录上游文件与 SHA-256。

**OptiFine 不包含、不再分发**（sp614x 的作品）；**Lithium 的上游源码**在 https://github.com/CaffeineMC/lithium-fabric。

构建脚本在仓库的 `tools\` 下，任何人可用上游 jar 复现出完全相同的文件。
