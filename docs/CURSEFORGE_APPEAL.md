# OptiLithium Reforged —— CurseForge 申诉

## 拒绝原文

> Your project, OptiLithium Reforged (https://legacy.curseforge.com/minecraft/mc-mods/optilithium-reforged), has been rejected:
>
> **This appears to be another author's work. The original author should upload it on his or her own.**
>
> You can create a new project following our Moderation Guidelines. If you think the rejection is false, you can contact our Support team.

## 上传物的真实构成（申诉必须基于这个来写）

```
OptiLithium-Reforged-1.0.0+mc1.21.11.jar   839,247 字节   703 个条目
  ├── net/caffeinemc/**            687 个   ← Lithium 自己的代码（CaffeineMC）
  ├── assets/                       3 个
  ├── META-INF/                     6 个
  └── (根)                          7 个
       ├── fabric.mod.json              id=lithium  name=Lithium
       │                                version=0.21.4+mc1.21.11
       │                                license=LGPL-3.0-only
       │                                authors=JellySquid, 2No2Name
       ├── LICENSE.md                   Lithium 原许可，未改
       └── OPTILITHIUM-REFORGED.txt     我加的修改说明
```

**我加的只有 3 个文件**：`LICENSE.md`（原样）、`OPTILITHIUM-REFORGED.txt`（修改说明）、以及被改过一条的 `fabric.mod.json`。

**所以 CurseForge 说"这是另一位作者的作品"，从内容看是准确的。申诉不能否认这一点，只能说明"这是许可允许的、且我做对了义务"。**

---

## 提交入口

```
https://support.curseforge.com/support/tickets/new
```

分类选 **Authors support** 或 **Moderation**。

---

## 工单正文（英文，整段复制）

**Subject:** Appeal — "OptiLithium Reforged" rejection; this is an LGPL-3.0 redistribution of Lithium, and I'd like to know if that's allowed here

Hi,

My project OptiLithium Reforged was rejected as another author's work. I want to be straight with you about what I uploaded, because I don't think arguing around it would help either of us.

**The file is a modified build of Lithium.** Not a mod of mine that uses Lithium. It's Lithium itself — 687 of its 703 entries are CaffeineMC's own `net/caffeinemc` classes — with one line removed from its `fabric.mod.json`, plus a text file explaining the change and Lithium's own licence kept in place. The metadata inside still says `id: lithium`, `name: Lithium`, `authors: JellySquid, 2No2Name`, `license: LGPL-3.0-only`, exactly as upstream ships it. I never claimed to have written it.

**What I'm relying on is its licence.** Lithium is LGPL-3.0, which permits distributing modified versions. What it requires is that I keep the licence and copyright notices, state that I changed it, and make the corresponding source available. I do all three:

- `LICENSE.md` is shipped unchanged
- `OPTILITHIUM-REFORGED.txt` states exactly what I changed — one entry removed from `breaks`, two mixin groups set to `false` in Lithium's default config
- it also records which upstream file this was built from and that file's SHA-256, so anyone can get the source and reproduce it

I'd also point out that **no class file is modified at all**. Every mixin is byte-identical to upstream. The change is configuration only.

**Here is my actual question.** There's a project on your platform doing the same thing: **OptiLithium (676562) by PrinceNormal_**, live since September 2022, about 14,000 downloads, status approved. Its files are named `OptiLithium-fabric-mc1.19.4-0.11.1.jar` — `fabric-mc<version>-<lithium version>` is Lithium's own artifact naming, and `0.11.1` is a Lithium version, so those are repackaged Lithium builds too. I'm not asking you to take his down. I'm asking whether the same thing is acceptable now, and if it wasn't acceptable then either, then his listing answers my question and I'll stop.

So: **is an LGPL-3.0 redistribution of a modified mod something you accept on CurseForge?** If yes, I'd like this looked at again. If no, that's a clear answer and I'll distribute it through my GitHub releases instead — I just don't want to keep guessing at a rule I can't find.

For reference:

- My profile: https://www.curseforge.com/members/kynarain
- My own mod, which is unrelated to this file and which I do hold the copyright to: https://www.curseforge.com/minecraft/mc-mods/optifabric-reforged
- Source repository: https://github.com/Kynarain/OptiFabric-Reforged

Thanks for your time.

---

## 提交时要附的材料

1. **拒绝通知截图**（含原文）
2. **PrinceNormal_ 的项目页截图** —— 显示状态正常、下载量、以及文件列表里的 `OptiLithium-fabric-mc1.19.4-0.11.1.jar` 这个命名
3. （可选）**你自己 jar 内 `OPTILITHIUM-REFORGED.txt` 的截图** —— 一眼看到三项义务都写了

---

## 这份申诉的取舍（重要，你要清楚）

| 做法 | 效果 |
|---|---|
| ✅ **承认文件是 Lithium 的修改版** | 唯一站得住的定位。对方一解压就知道，硬说原创会立刻失分 |
| ✅ **把依据放在 LGPL-3.0 上** | LGPL 确实允许。你不是在求法外开恩，是在陈述许可权利 |
| ✅ **用 PrinceNormal_ 要"一致性裁定"** | 措辞是"同一个标准"，不是"你们为什么放过他"——后者像举报，会招反感 |
| ✅ **明确写出"如果不允许，我就换 GitHub"** | 给台阶。对方可能正需要一句"你换个地方发"来结案 |
| ✅ **区分两个项目** | 明确说 `optifabric-reforged` 是你持有版权的，与这个文件无关，避免连坐 |
| ❌ **不提 OptiFabric Reforged 的批准来类推** | 那是你自己的原创项目，与"重新打包 Lithium"性质不同，**类推会被驳** |
| ❌ **不主张自写代码比例** | 上一版申诉的错误就是拿模组代码去答一个关于 Lithium jar 的质疑 |

---

## 说实话的胜算判断

**不高。** 理由：

- CurseForge 的 Moderation Guidelines 有"mods 应为原创作品"的倾向，**审核实务通常严于许可法本身**
- 对方第一次的原话是"**The original author should upload it on his or her own**"，语气是明确的政策立场，不是误判
- 你请求的是"让我分发别人模组的修改版"——即使许可允许，平台也有权不收

**但值得发一次**，因为：成本低、能拿到明确答复、而且那条 PrinceNormal_ 的先例是对方无法回避的事实。无论结果如何，你都能知道该不该继续在 CurseForge 上做这件事。

---

## 如果被拒（大概率），换这条路

**CurseForge 放你的模组，Lithium 修改版走 GitHub Release。**

| 平台 | 放什么 | 为什么 |
|---|---|---|
| **GitHub Release** | 16 个 `OptiLithium-Reforged-1.0.0+mc*.jar` + 构建脚本 | 这个圈子分发 Lithium 修改版的标准做法；LGPL 的"对应源码"义务在这里最扎实（脚本 + 上游 jar = 同一个产物） |
| **CurseForge** | 只放 `OptiLithium Reforged` **模组本身**（你的 MPL-2.0 代码） | 那是你的原创作品，不会有"他人作品"问题 |
| **Modrinth** | 两边都可试 | 无"必须原作者上传"这类判定，态度以许可为准 |

**注意**：如果走这条路，CurseForge 上的项目名和内容要**名实相符**。现在叫 `OptiLithium Reforged` 但传的是 Lithium 构建，本身就是"名字像模组、内容是别人的 mod"——这也是审核容易起疑的地方。
