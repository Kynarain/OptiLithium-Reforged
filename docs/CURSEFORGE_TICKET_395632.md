# CurseForge 工单材料（按项目分开）

> **本文件曾用错项目，已更正。**
>
> 上一版把工单 **#395632** 的内容写在了 OptiLithium 的文件里。实际上 **#395632 是关于
> `OptifiNeoforge` 的工单**，与 OptiLithium / OptiLithium-Reforged **无关**。
>
> 那个工单里"被判另一位作者的作品指的是 **OptiFine**、项目可接受但由于已被删除需要先改名字和 slug 才能恢复"
> 这一整套结论，**只适用于 OptifiNeoforge**。**不要**把它们套到 OptiLithium-Reforged 上。

---

## 一、OptiLithium / OptiLithium-Reforged

**状态：待确认拒绝理由。**

目前已知的只有用户最早转述的一句话："项目被拒绝，说是**另一位作者的作品**"，并给出了
`https://legacy.curseforge.com/minecraft/mc-mods/optilithium-reforged`。

**这不足以开申诉**，因为：

- "另一位作者的作品"未指明对象。在 #395632 那单里，这句话最终指的是 **OptiFine**，而不是预想的那个同名项目——
  说明这句话的指向**必须向客服问清**，不能自行推断。
- 该 URL 从本机无法验证（Cloudflare 对 `legacy.curseforge.com` 全域返回 403，连"一定存在"和"一定不存在"
  的对照 URL 都是 403），所以本机**无法**判定它是 404 还是被墙。

**开申诉前必须先拿到：**

1. 拒绝通知的**原文**（作者后台状态页 / 邮件 / 提交后弹窗，截图或文字均可）
2. 确认是"**改名后重新提交又被拒**"，还是"**改名后尚未重新提交**"

**已知可用的正面事实（无论理由是哪一种都用得上）：**

| 事实 | 证据 |
|---|---|
| 不动任何代码 | 每个 class 文件与上游 Lithium 发布版逐字节相同；只改两处配置 |
| 不含 OptiFine | 16 个 jar 实测：OptiFine 路径 **0** 个、外来 class **0** 个 |
| 不含 Lithium | 无 `lithium.mixins.json`、无 `net/caffeinemc/**` |
| 保留上游身份 | jar 内 `id=lithium`、`name=Lithium`、`version` 为上游版本，原样保留 |
| 许可已履行 | LGPL-3.0：原样携带 `LICENSE`，内含 provenance（上游文件名 + SHA-256） |
| 已改名 | 项目名 `OptiLithium Reforged`；jar 文件名 `OptiLithium-Reforged-1.0.0+mc<版本>.jar` |

**已备好的 16 个产物**：

- `C:\Users\kynar\IdeaProjects\optilithium\build\libs\`（15 个，1.20 ~ 1.21.11）
- `C:\Users\kynar\IdeaProjects\optilithium\v26\build\libs\`（1 个，26.1.2）

---

## 二、OptifiNeoforge（工单 #395632）

**这单的结论与下一步只适用于 OptifiNeoforge。**

| 轮次 | 对方说什么 | 动作 |
|---|---|---|
| 1 | 自动回复：要求补**个人资料链接 + 授权链接/权限 + 截图** | 提供 `https://www.curseforge.com/members/kynarain`、已发布项目、GitHub 仓库、截图 |
| 2 | 真人（Noam V）：**判"另一位作者的作品"指的是 OptiFine**；**可以接受该项目**；但发现项目已被删除，问是否**恢复** | 回复"要恢复" + 用事实说明不打包 OptiFine |
| 3 | Noam V：**恢复前请先改项目名和 slug**（删除后它们被替换成了通用占位名） | 在后台改名为 `OptiLithium Reforged` / slug `optilithium-reforged`，或请客服代改 |

> ⚠️ 第 3 步里的名字与 slug 是**按 OptiLithium 的命名给的**。如果这一步实际是要给 `OptifiNeoforge` 用，
> 名字应改成 OptifiNeoforge 自己的名字，不要照搬。

**关于 OptiFine 的结论（这一条是通用的，对任何"需要用户自备 OptiFine"的项目都成立）：**

CurseForge 的立场是——**要求用户自备 OptiFine 是可以接受的，但不得打包 OptiFine 的资产**。
OptiFabric 就是按这个模式在 CurseForge 上发布的。所以：

- ✅ 允许：启动时读取用户放进 `mods/` 的 OptiFine jar、在运行时处理它
- ❌ 不允许：把 OptiFine 的 class 或资源打包进自己的 jar

---

## 三、通用申诉流程（官方文档依据）

来源：[Project Statuses 101](https://support.curseforge.com/support/solutions/articles/9000197905-thumbs_down)

**项目状态与文件状态是两套，含义不同：**

| 层级 | 状态 | 含义 |
|---|---|---|
| 项目 | New | 刚建，未被审核看过（**至少一个文件**才进入审核） |
| 项目 | **Changes Required** | **"快过了"**：只要求改几处，会给具体说明。改完重提交 → Changes Made。**不要申诉这个** |
| 项目 | Approved | 项目页通过，等文件也通过才公开 |
| 项目 | **Rejected** | 未通过，会给理由，官方称**不能重新评估** → 只能提工单 |
| 文件 | **Rejected** | 官方原文：*"if you feel this was done by mistake, please open a support ticket"* ← **申诉的正式依据** |
| 文件 | Under manual review | 人工审核中，**不要重复提交** |

**入口与时限：**

- `https://support.curseforge.com/support/tickets/new`（官方文档指定的申诉入口）
- `https://support.overwolf.com/helpdesk/tickets/<编号>`（#395632 所在系统；两个系统都真实存在）
- 回复时限 48–72 小时，周末更慢

**工单必须包含：** 个人资料链接、一个已发布项目 + 其源码仓库（证明账号归属）、截图、以及**明确的诉求**
（恢复 / 重审 / 澄清记录）。

**不要重复提交项目**，等工单结论。重复提交会被视为骚扰，且可能撞上同一条判定。

---

## 四、从 #395632 得来的经验（通用，可复用）

| 做法 | 为什么有效 |
|---|---|
| **先问"你们指的是哪一个"** | 我们一开始认定被拒是"名字撞了同名项目"，一路按重名准备；结果对方指的是 **OptiFine**。不先问清对象，材料全是白准备 |
| **用可核验的事实，不用形容词** | 不说"我没打包 OptiFine"，而是把 jar 全查一遍给出数字：OptiFine 路径 0 个、外来 class 0 个 |
| **主动交代可能被误判的点** | 主动说明自己类名里有 11 处 "Optifine" 字样，免得对方搜到字符串反过来质疑 |
| **放弃争不赢的部分** | "名字我不争了，已经改了"——把力气集中到真正的诉求上 |
| **结尾问一个具体问题** | 问"会不会被记成重新上传他人作品"，比"希望你们重新考虑"更能得到明确答复 |
| **一条铁律** | 拒绝理由里的那个"另一个项目名"，**指向的对象可能和你想的完全不同**，必须向客服确认 |
