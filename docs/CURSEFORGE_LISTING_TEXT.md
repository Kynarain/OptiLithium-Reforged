# OptiLithium Reforged —— CurseForge 发布文案

对齐 PrinceNormal_ 的 OptiLithium (676562) 的**长度**，但不照抄他的**措辞**。
他的两份分别是：简介 174 字符、详细描述 84 词。下面两份都对齐到同一量级。

---

## 一、简介（About / Summary 字段）

**English**

```
Run OptiFine and Lithium in the same Fabric client. A repackage of Lithium that
removes its OptiFabric conflict, for Minecraft 1.20 through 26.1.2.
```

长度：**139 字符**（他的是 174）

**中文**

```
让 OptiFine 和 Lithium 在同一个 Fabric 客户端里共存。Lithium 的重打包版，
去掉了它与 OptiFabric 的冲突，支持 Minecraft 1.20 ~ 26.1.2。
```

---

## 二、详细描述（项目正文）

**English**

```
Lithium is a general-purpose optimization mod for Minecraft which works to improve a number of systems (game physics, mob AI, block ticking, etc) without changing any behavior. It works on both the client and server, and can be installed on servers without requiring clients to also have the mod.

OptiFine and Lithium refuse to start together: Lithium declares "breaks": {"optifabric": "*"} in its own fabric.mod.json, and Fabric Loader matches that by mod id. This repackage removes that one entry, so both load. No class file is changed — Lithium's own id, name, version and licence are untouched. Bring your own OptiFine jar.
```

长度：**约 100 词**（他的是 84）

**中文**

```
Lithium 是 Minecraft 的通用优化模组，在不改变游戏行为的前提下改进大量系统（物理、生物 AI、方块刻等）。客户端和服务端均可使用，装在服务端时不要求客户端也安装。

OptiFine 与 Lithium 无法一起启动：Lithium 在自己的 fabric.mod.json 里写了 "breaks": {"optifabric": "*"}，而 Fabric Loader 是按模组 id 匹配的。本重打包版去掉这一条，两者即可共存。没有修改任何 class 文件——Lithium 自己的 id、name、version 与许可均保持原样。OptiFine 需自备。
```

---

## 三、为什么这么写（决策说明）

| 决策 | 理由 |
|---|---|
| **第一段照抄 Lithium 官方描述** | PrinceNormal_ 也这么做，而且这是**正确的归属方式**——明确声明本项目基于 Lithium，而不是假装原创 |
| **第二段很短，只讲"去掉了什么冲突"** | 他只用 13 词讲完。你的核心事实也就一句：删掉一条 `breaks` |
| **明确写"No class file is changed"** | 这是你**最有力的差异化事实**，而且直接回应"这是别人作品"的质疑——你连字节码都没动 |
| **写明 id/name/version/许可原样保留** | 同上，表明你无意冒充原作者 |
| **`Bring your own OptiFine jar` / `OptiFine 需自备`** | 主动排除"打包了 OptiFine"这条嫌疑（#395632 那单里 OptiFine 就是被拒理由） |
| **不写"我支持 16 个版本、实测进世界"** | 他也没写。简介要短，那些数据放 README，不占这里 |
| **不用他的措辞** | `A modified version of lithium that makes it Compatible with OptiFabric` 这句照抄会加深"翻版"印象 |

---

## 四、如果你更想要"极短版"

只保留一句话，**115 字符**：

```
Load OptiFine and Lithium in the same Fabric client. Lithium, repackaged so it
stops refusing to load with OptiFabric.
```

一行中文：

```
让 OptiFine 和 Lithium 在同一个 Fabric 客户端里共存——Lithium 的重打包版，不再拒绝与 OptiFabric 一同加载。
```

---

## 五、附：PrinceNormal_ 的原文（对照用，别照抄）

**简介（174 字符）**

```
A modified version of lithium that makes it Compatible with OptiFabric  (NOTE THIS MOD IS ONLY INTENDED FOR POJAVLAUNCHER OR REALLY LOW END PCS THAT NEED TRANSLATION LAYERS))
```

**详细描述（两段，84 词）**

```
Lithium is a general-purpose optimization mod for Minecraft which works to improve a number of systems (game physics, mob AI, block ticking, etc) without changing any behavior. It works on both the client and server, and can be installed on servers without requiring clients to also have the mod. With the mod installed, you can see on average a 45% improvement to server tick times, resulting in a much leaner game.

Now with OptiLithium you're now able to use OptiFabric (Optifine) and lithium together.
```
