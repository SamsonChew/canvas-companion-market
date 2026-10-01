# Canvas Companion 安装指南（ChatGPT 版）

这份指南写给**用 ChatGPT 的同学**。用 Claude 的话，请看[Claude 版安装指南](INSTALL.zh.md)。

Canvas Companion 装好以后，你可以在 **ChatGPT 桌面 App** 里直接问：
「这周要交什么」「帮我预习 W5」「我的进度怎么样」。它还会把课件下载到你的电脑，帮你管理待办清单。

- 它**只读** Canvas：不会替你交作业，不会发帖，不会改 Canvas 上的任何东西。
- 课件、笔记、待办都存在**你自己的 Mac** 上。
- 要用 **ChatGPT 桌面 App**。**网页版 ChatGPT（chatgpt.com）用不了**：网页版读不到你 Mac 上的工具。
- 安装时**下载一个小文件、双击它**，照提示回答几个问题就好，不用自己敲命令。
- **动手大约 10–15 分钟**，只需要做一次。安装结束时浏览器会自动打开授权申请页；
  作者人工审核，**另外要等一等**（通常 1–2 天内，以申请页上写的为准）。

**使用本插件即表示你同意
[使用条款](https://github.com/SamsonChew/canvas-companion-market/blob/main/TERMS.zh.md) 和
[隐私说明](https://github.com/SamsonChew/canvas-companion-market/blob/main/PRIVACY.zh.md)。** 开始前请先读一下。

> ChatGPT 桌面 App 更新很快。如果你看到的按钮或菜单名称和本指南不完全一样，
> 找意思最接近的那个就行；实在找不到，看最后的「常见问题」，或截图发给作者。

---

## 总览

| 步骤 | 做什么 | 大约 |
|---|---|---|
| 0 | 准备：检查 Mac 和套餐，装 ChatGPT 桌面 App，在 Canvas 生成令牌 | 5 分钟 |
| 1 | 下载安装文件，双击运行，回答几个问题 | 5 分钟 |
| 2 | 在自动打开的申请页提交申请（设备编号已填好） | 2 分钟 |
| 3 | 批准后双击同一个文件，填入授权码 | 等批准 + 1 分钟 |
| 4 | 在「课程」文件夹里开对话，开始用 | 2 分钟 |
| 5 | 在手机上用（可选） | — |
| 6 | 更新、卸载、常见问题 | — |

---

## 第 0 步：准备工作

这一步都在 Mac 和浏览器里做，做完就不用再来回切换了。

### 0.1 检查你的 Mac

1. 点屏幕左上角的 **苹果图标** → **关于本机**。
2. 看两行：
   - **芯片**：要写着 **Apple M1、M2、M3、M4**（或更新的 M 系列）。
     如果写的是 **Intel**，**目前还不支持**，请先不要继续。
   - **macOS**：要 **15（Sequoia）或更新**。
     低于 15 的话，先到 **系统设置 → 通用 → 软件更新** 升级。
     （ChatGPT App 本身在旧一点的系统上也能装，但本插件需要 macOS 15。）

### 0.2 检查你的 ChatGPT 套餐

插件是通过 ChatGPT 桌面 App 里的 **Codex** 运行的。按 OpenAI 的说明，
**Free、Go、Plus、Pro、Business、Edu、Enterprise** 套餐都包含 Codex
（见 [OpenAI 的价格说明](https://learn.chatgpt.com/docs/pricing)）。

- **Free 和 Go 的用量比较少**，适合偶尔问几句。预习、同步课件这类任务比较耗用量，
  经常用的话建议 **Plus 或以上**。
- 用量用完时 ChatGPT 会提示你，等额度重置或升级套餐即可。插件本身没有另外的用量限制。

> 套餐和用量规则由 OpenAI 决定，可能会变。以 ChatGPT 里显示的为准。

### 0.3 安装 ChatGPT 桌面 App 并登录

1. 打开 OpenAI 的桌面 App 页面 <https://learn.chatgpt.com/docs/app>，点 **Download for macOS (Apple Silicon)**。
2. 打开下载好的文件，把 App 图标拖进「应用程序」文件夹。
3. 在「应用程序」里打开它，用你的 **ChatGPT 账号**登录。

已经装过 ChatGPT App 的话，请先更新到最新版。旧的 Mac 版 App（现在叫 **ChatGPT Classic**）
**没有**插件需要的功能，请装新的桌面 App。

> **第一次打开可能很慢**，甚至一两分钟没反应：macOS 正在检查这个新下载的 App。
> 等它打开就好，不要反复点。以后就快了。

课程文件夹不用自己建：安装时直接按回车，会在你的个人文件夹里建好 `课程`（`~/课程`）。
已经按 Claude 版指南建过的话，就是同一个。

### 0.4 生成 Canvas 令牌（token）

令牌就像一把只给这个插件用的钥匙，让它能**读**你的 Canvas。安装时要用到，所以先在浏览器里生成好：

1. 用浏览器登录你学校的 Canvas，记下地址栏里的**网址**（只要主机名，例如 `canvas.yourschool.edu`），安装时要填。
2. 点最左边深色竖栏里的 **Account（账户）** → **Settings（设置）**。
3. 往下滚到 **Approved Integrations（已批准的集成）**，点 **+ New Access Token**。
4. **Purpose（用途）** 填：`Canvas Companion`
5. **Expires（过期时间）选允许的最晚一天**：Canvas 规定学生的令牌**最长 120 天**（学校可能设得更短），不能留空。
   **马上在手机日历里设一个提醒**，比到期日早几天；插件也会在到期前 14 天提醒你。
6. 点 **Generate Token**，**复制**那一长串字符。Canvas **只显示这一次**，先别关这个页面，
   等第 1 步安装程序问你要令牌时再粘贴（丢了就重新生成一个）。

> 令牌 = 你的 Canvas 权限。**不要发给任何人（包括作者）**，不要截图发群里。
>
> 找不到 **+ New Access Token** 按钮？说明你的学校关闭了学生自建令牌，这个插件暂时用不了，
> 请联系学校 IT（见[帮助](/help/#no-token-button)）。
>
> 已经给 Claude 版生成过令牌、还没过期的话，也可以用同一个。

---

## 第 1 步：安装插件

<!-- demo-chatgpt:seg-1 -->

### 1.1 下载安装文件

用浏览器点这个链接下载：**[CanvasCompanion-ChatGPT-安装.zip](https://raw.githubusercontent.com/SamsonChew/canvas-companion-market/main/codex/CanvasCompanion-ChatGPT-%E5%AE%89%E8%A3%85.zip)**

- 用 **Safari** 的话，它会自动解压：「下载」文件夹里会出现一个 **CanvasCompanion-ChatGPT** 文件夹。
- 用 Chrome 等其他浏览器的话，到「下载」文件夹里**双击这个 .zip** 解压，得到同样的文件夹。

文件夹里有两个文件：**Canvas Companion 安装与设置.command**（要双击的就是它）和一份 **说明.txt**。
**把这个文件夹留着**：以后换授权码、更新、卸载，都是双击同一个文件。

### 1.2 双击运行（第一次要放行一下）

1. 先**退出 ChatGPT App**（`⌘ + Q`）。
2. 双击 **Canvas Companion 安装与设置.command**。

**第一次双击时 macOS 会拦住它**，弹出「未打开 "Canvas Companion 安装与设置.command"」「Apple 无法验证……」之类的窗口。
这个文件没有 Apple 的开发者签名，**只需要放行一次**：

1. 在弹窗里点 **完成**（**不要**点「移到废纸篓」）。

   ![示意图：macOS 15 的「未打开」弹窗，点「完成」](https://canvas-companion.samsonchew.workers.dev/demo/chatgpt/gatekeeper-1-blocked.png)

2. 苹果图标 → **系统设置** → **隐私与安全性**，往下滚到 **安全性**，
   在「已阻止 "Canvas Companion 安装与设置.command"」旁边点 **仍要打开**。

   ![示意图：系统设置 → 隐私与安全性 → 安全性，点「仍要打开」](https://canvas-companion.samsonchew.workers.dev/demo/chatgpt/gatekeeper-2-open-anyway.png)

3. 输入 Mac 的登录密码，在弹出的窗口里再点一次 **仍要打开**。

> **「仍要打开」只在你双击后大约一小时内出现**
> （见 Apple 的说明[《打开来自未知开发者的 Mac App》](https://support.apple.com/zh-cn/guide/mac-help/mh40616/mac)）。
> 没看到的话，回去**再双击一次**文件，再到系统设置里找。
> 两张图是按 macOS 15 的文字画的**示意图**，不是真实截图。macOS 14 及更早：按住 `Control` 点文件 → **打开** → **打开**。

放行后会弹出一个「终端」窗口，里面是一个菜单：

```
1  安装或更新
2  更换授权码
3  更换 Canvas 令牌
4  更换 Canvas 网址
5  卸载
```

**直接按回车**（就是 1，安装）。

### 1.3 回答几个问题

它会自动下载插件、核对文件，然后依次问你（提示是中英双语的）：

| 它问 | 填什么 |
|---|---|
| **Canvas 的网址**（Canvas address） | 0.4 记下的网址，例如 `canvas.yourschool.edu`（不要 `https://`，结尾不要 `/`），回车 |
| **课程文件放在哪个文件夹**（Folder for your course files） | **直接按回车**，就是 `~/课程`。想用别的文件夹才需要输入路径。 |
| **Canvas 访问令牌**（Canvas token） | 粘贴 0.4 复制的令牌（`⌘ + V`），回车，**再粘贴一次**，回车（两次一样才算数） |
| **授权码**（licence key） | 现在还没有：**直接按两次回车**跳过，第 3 步再填。 |

粘贴令牌和授权码时**屏幕上不会显示任何字符**，这是正常的，粘贴后直接按回车。

然后它会把插件登记到 ChatGPT 桌面 App 里（一个「MCP 服务器」，加上五个「技能」），
显示这台 Mac 的**设备编号**（像 `7K2M-Q9XA-3FDR`），并**自动在浏览器里打开授权申请页**，设备编号已经填好。
看到「✓ 完成 / done」后，回到终端窗口按回车关掉它，接着做第 2 步。

- 令牌和授权码存在 Mac 的「钥匙串」里，不会以明文存在文件里，也不会发给作者。
- 它下载安装程序后会先核对文件（校验码），不一致就不运行，并提示你过几分钟再试。
- 以后再双击安装也没关系：已经填过的网址、令牌和授权码会保留，不会再问。

<details>
<summary><strong>用终端安装（备用：双击的方法不行时再用）</strong></summary>
<p>「终端」是 Mac 自带的 App：按 <code>⌘ + 空格</code>，输入 <code>Terminal</code>，按回车打开。
先退出 ChatGPT App（<code>⌘ + Q</code>），把下面这一行<strong>复制 → 在终端里 <code>⌘ + V</code> 粘贴 → 按回车</strong>：</p>
<pre><code>/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/SamsonChew/canvas-companion-market/main/codex/install.sh)"</code></pre>
<p>它问的几件事和上面的表格一样。第 3 步、更新、卸载也都有对应的终端命令，写在各自的「备用」里。</p>
</details>

### 1.4 确认 ChatGPT 里有这个插件

打开 ChatGPT 桌面 App → **设置（Settings）→ MCP servers**，列表里应该有 **canvas-companion**，并且是打开的。

找不到的话，先 `⌘ + Q` 退出 App 再打开；还不行，退出 App 后再双击一次安装文件，把终端窗口截图发给作者。

> 看不到 **MCP servers** 这一项的话，多半是 App 太旧，或者用的是 ChatGPT Classic，见 0.3。

---

## 第 2 步：申请授权码

<!-- demo-chatgpt:seg-2 old -->

授权码和你的这台 Mac 绑定。安装程序已经算好了这台 Mac 的**设备编号**，并在浏览器里打开了填好编号的申请页。

1. 在申请页上核对设备编号和终端窗口里显示的一样，填一个称呼和联系方式；
   想收到批准通知的话，可以选填一个邮箱。提交。
2. 提交后，页面会给你一条**私人链接**。**马上把它加入书签（`⌘ + D`）。**
   - 这是你以后查看授权码的方式，**只显示这一次**。
   - 不要发给别人：拿到链接的人就能看到你的授权码。
   - 链接丢了，用申请时留的联系方式找作者重新生成。

作者人工审核，**通常 1–2 天内**（申请页提交后会写具体的预计时间）。

**浏览器没有自动打开？** 把终端里「申请授权码 / apply for a licence key」后面那个链接复制到浏览器里打开。
终端已经关掉的话，在 ChatGPT 桌面 App 里**打开「课程」文件夹**开一个新对话，发送：

```
Canvas Companion 授权状态
```

（ChatGPT 问是否允许使用 `license_status` 时点允许。）回复里有设备编号和**申请链接**，点开它，设备编号已经填好。
链接点不开的话，到授权网站 <https://canvas-companion.samsonchew.workers.dev> 点 **申请授权**，把设备编号原样粘贴进去。

> 在拿到授权码之前，插件只会回答授权状态，其他功能都不能用，这是正常的。
>
> **在这台 Mac 上已经用 Claude 版领过授权码？** 设备编号跟着 Mac 走，应该是同一个编号。
> 是的话不用重新申请，直接把那串授权码按第 3 步填进来。

---

## 第 3 步：批准后填入授权码

<!-- demo-chatgpt:seg-3 -->

1. 打开第 2 步收藏的**私人链接**（留了邮箱的话，批准后会收到通知邮件），
   就能看到一串以 `CC1-` 开头的**授权码**。点 **复制**。
2. **退出 ChatGPT App**（`⌘ + Q`），再双击 1.1 那个文件夹里的
   **Canvas Companion 安装与设置.command**，输入 **2**（更换授权码），回车。
3. 提示你输入授权码时，粘贴整串 `CC1-…`（要完整复制），回车，**再粘贴一次**，回车。
   屏幕上不会显示字符，这是正常的。看到「✓ 完成」后按回车关掉窗口。
4. 打开 ChatGPT App，在**课程**文件夹里**新开一个对话**，再问一次：

   ```
   Canvas Companion 授权状态
   ```

   看到「授权有效，有效期至 …」就成功了。

<details>
<summary><strong>备用：用终端填授权码</strong></summary>
<p>退出 ChatGPT App 后，在终端里运行下面这一行，再照上面粘贴两次授权码：</p>
<pre><code>~/.canvas-companion/codex/install.sh --set-license</code></pre>
</details>

---

## 第 4 步：开始用

<!-- demo-chatgpt:seg-4 -->

### 4.1 每次都在「课程」文件夹里用

**每次都在「课程」文件夹里开对话**（开始新对话时选文件夹 / Open folder → **课程**），否则它找不到你的课程。
用过一次之后，这个文件夹一般会出现在最近列表里。

插件的工具只会读 Canvas、读写你课程文件夹里的文件，不会改 Canvas 上的任何东西。
ChatGPT 问你是否允许用某个工具时，点允许即可。

### 4.2 让 ChatGPT 帮你设置课程

第一句话发：

```
帮我设置课程
```

它会列出你这学期 Canvas 上的课，为每门课建一个文件夹。检查一下课程对不对。

### 4.3 试试这些

```
把所有课的资料同步下来
```

```
这周要交什么？
```

```
我的进度怎么样？
```

```
帮我预习 CS2040 第 5 周
```

```
还有什么没做？
```

```
把「交 lab report」加进待办，周五截止
```

第一次同步可能要几分钟，看课件多少。

Canvas 令牌快到期（或已经过期）时，直接说「设置 Canvas」：它会带你生成新令牌，
从剪贴板读取、核对后存好，不用再双击安装文件。

### 4.4 用技能（可选）

插件还带了五个「技能」，适合想要固定格式结果的时候。在输入框里输入 `$`
（有的版本是 `@`），从列表里选，或者直接打出来：

| 技能 | 作用 |
|---|---|
| `$canvas-companion-prep` | 预习某门课某一周，写成笔记 |
| `$canvas-companion-week` | 这周要交什么、有什么新公告 |
| `$canvas-companion-progress` | 整个学期的成绩和进度 |
| `$canvas-companion-todo` | 查看、添加、完成待办 |
| `$canvas-companion-status` | 全部课程的周报 |

例如：

```
$canvas-companion-prep CS2040 W5
```

不用技能、直接用中文问也完全可以。

### 第一次使用时可能弹出的窗口

| 弹窗 | 点什么 |
|---|---|
| ChatGPT 问能不能用某个工具（`canvas-companion` 的工具） | 允许。 |
| 「"ChatGPT"想访问"文稿"（或桌面、下载）文件夹中的文件」 | 点 **允许**。把课程放在「课程」文件夹基本不会出现。 |
| 双击安装文件时：「未打开…」/「Apple 无法验证…」/「无法验证开发者」 | 点 **完成**（不要点「移到废纸篓」），到 **系统设置 → 隐私与安全性** 点 **仍要打开**（双击后约一小时内有效），见 1.2。 |
| 其他时候的「无法验证开发者」/「已阻止使用」 | 点 **完成**（不要点「移到废纸篓」），把整个弹窗截图发给作者。 |

---

## 第 5 步：在手机上用

<!-- demo-chatgpt:seg-5 -->

手机上的 ChatGPT App 可以**远程控制**你的 Mac：在手机上发消息，读文件、跑插件的工具都还在 Mac 上
（见 OpenAI 的[远程连接说明](https://learn.chatgpt.com/docs/remote-connections)）。

1. 手机上装好 **ChatGPT App**（iOS / Android），登录**同一个账号**（和同一个工作区）。
2. 在 Mac 的 ChatGPT 桌面 App 里：**设置（Settings）→ Connections → Control this Mac or PC**，
   点 **Setup**（或 **Add**）。屏幕上会出现一个二维码。
3. 用手机扫这个二维码，按手机上的提示确认账号。
4. 配对好以后，在手机 ChatGPT App 的 **Remote** 里就能看到你的 Mac。在里面打开**课程**文件夹开始对话。

注意：

- **Mac 要开着、联网，不要让它睡着。** 合上盖子或自动睡眠后手机就连不上。
  出门前建议插上电源，并在 **系统设置 → 电池 → 选项** 里打开
  「使用电源适配器且显示器关闭时，防止自动进入睡眠」（不同版本的名称可能略有不同）。
- 手机上也能批准工具的使用请求。
- 直接在手机 ChatGPT App 里**普通聊天**（不经过 Remote）是用不了插件的，和网页版一样。

---

## 第 6 步：更新、卸载和常见问题

### 更新插件

作者发布新版本后，**退出 ChatGPT App**，双击 **Canvas Companion 安装与设置.command**，直接按回车（1 = 安装或更新）。
文件删掉了的话，按 1.1 重新下载一次。

<details>
<summary><strong>备用：用终端更新</strong></summary>
<pre><code>/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/SamsonChew/canvas-companion-market/main/codex/install.sh)"</code></pre>
</details>

然后打开 ChatGPT App。**更新不会动你的东西**：课件、笔记（`notes/`）、待办清单都在「课程」文件夹里；
Canvas 设置、令牌和授权码也会保留，不会再问你。

### 关于授权，你需要知道的

- 授权码只能在**领取时那台 Mac** 上用。换电脑要重新领。
- 授权码有有效期。快到期（7 天内）时插件会提醒你。到授权网站 <https://canvas-companion.samsonchew.workers.dev> 的
  **我的授权** 页面点 **续期**，批准后复制新授权码，按第 3 步换掉旧的即可。
- 插件**每天联网一次**，从授权网站（连不上时从 GitHub，再不行从 jsDelivr）下载一份公开的「停用名单」，
  核对你的授权码是否被停用。这个请求**不会发送**你的授权码、设备编号或任何个人信息。
- **如果你的 Mac 连续 14 天没联网**，插件会暂停工作，直到你联网并重开一次 ChatGPT App。
  联网一次就恢复，不用找作者。
- 请不要把 Mac 的日期往回调，插件会认为时钟异常而暂停。

### 常见问题

| 你看到的情况 | 原因 | 怎么办 |
|---|---|---|
| 在 chatgpt.com 网页上问，它不知道这个插件 | 网页版用不了你 Mac 上的工具 | 用 **ChatGPT 桌面 App**（见 0.3）。 |
| ChatGPT App 第一次打开很慢，或者一两分钟没反应 | macOS 在检查新下载的 App | 等一下，不要反复点。以后就快了。 |
| 设置里找不到 **MCP servers** | App 太旧，或用的是 ChatGPT Classic | 装最新的 ChatGPT 桌面 App（见 0.3）。 |
| **MCP servers** 里没有 canvas-companion | 安装没成功，或 App 没重开 | `⌘ + Q` 退出 App 再打开；还不行就退出 App、再双击一次安装文件（1.2），把终端窗口截图发给作者。 |
| 双击安装文件后说「未打开」「Apple 无法验证」 | 文件没有 Apple 签名，第一次会被拦 | 点 **完成**，到 **系统设置 → 隐私与安全性** 点 **仍要打开**（按钮约一小时后消失，没看到就再双击一次），见 1.2。只需一次。 |
| 双击安装文件，终端里说「校验失败」或「下载失败」 | 网络不稳，或作者刚发布新版本 | 过几分钟再双击一次；还不行就用 1.3 最后的「用终端安装」，并截图发给作者。 |
| 问什么都没反应，ChatGPT 好像不知道这个插件 | 对话没开在「课程」文件夹，或插件被关掉了 | 在「课程」文件夹里新开对话；到 **设置 → MCP servers** 确认 canvas-companion 是打开的。 |
| 提示用量用完了 | 套餐的 Codex 额度用完了 | 等额度重置，或升级套餐（见 0.2）。 |
| 输入 `$` 看不到 canvas-companion 的技能 | 技能没装上，或 App 没重开 | 退出 App 再打开；还不行就再双击一次安装文件、按回车。直接用中文问也能用。 |
| 「还没有填写授权码」 | 还没填授权码 | 正常，点回复里的申请链接，按第 2、3 步做。 |
| 「授权码格式不对」「授权码无效（签名不符）」 | 没复制完整，或多了空格 | 重新复制整串 `CC1-…`，按第 3 步填进去。 |
| 「这个授权码是给另一台设备（…）的」 | 换了电脑，或填了别人的授权码 | 在这台 Mac 上问「Canvas Companion 授权状态」，用新的设备编号到授权网站 <https://canvas-companion.samsonchew.workers.dev> 重新申请。 |
| 「授权码已于 … 过期」/「即将到期」 | 到期了 | 在授权网站 <https://canvas-companion.samsonchew.workers.dev> 的「我的授权」页面续期，拿到新授权码后按第 3 步填入。 |
| 「已经超过 14 天没能联网核对授权状态」 | Mac 太久没联网 | 连上网络，退出并重新打开 ChatGPT App，一次就好。 |
| 「这个授权码需要更新版本的插件」 | 插件太旧 | 按「更新插件」一节更新。 |
| `401 Unauthorized` 或 `Expired access token` | Canvas 令牌过期（最长 120 天）或被删了 | 在「课程」文件夹的对话里说「设置 Canvas」，照提示换一个新令牌（到期日选最晚的）。也可以退出 App，双击安装文件、输入 **3**（更换 Canvas 令牌），粘贴新令牌（两次），再打开 App；终端：`~/.canvas-companion/codex/install.sh --set-token`。 |
| 「连不上 Canvas」或 Canvas 网址填错了 | 安装时网址输错，或学校换了网址 | 双击安装文件、输入 **4**（更换 Canvas 网址），输入正确的网址（例如 `canvas.yourschool.edu`），再退出并重新打开 ChatGPT App。备用：终端运行 `~/.canvas-companion/codex/install.sh --set-domain`。 |
| 手机上看不到 Mac | Mac 睡着了、没联网，或还没配对 | 唤醒 Mac、打开 ChatGPT App，按第 5 步重新配对。 |
| 读 PDF 很慢，或读扫描版效果差 | 没装 PDF 工具 | 能用，只是慢。想更快：先装 [Homebrew](https://brew.sh)，再在终端运行 `brew install poppler`。 |
| 某周的课程页面是空的 | 老师设了解锁时间 | 到时间前 Canvas 本身就是空的，不是插件的问题。 |

更多问题见网站的「常见问题」页。

### Claude 和 ChatGPT 能一起用吗

可以。同一台 Mac 上两边的设备编号一样，用同一串授权码；安装时课程文件夹填同一个「课程」，
课件、笔记、待办两边都能看到。授权码要在两边各填一次（Claude 在插件设置里，ChatGPT 按第 3 步双击填）。

### 不想用了

1. **退出 ChatGPT App**，双击 **Canvas Companion 安装与设置.command**，输入 **5**（卸载），回车，
   再输入 `y` 确认，回车。

   它会把 canvas-companion 从 ChatGPT App 里移除，并删掉钥匙串里的 Canvas 令牌和授权码。
2. 到 Canvas 的 **Account → Settings** 里，把 `canvas-companion` 那个令牌删掉
   （Claude 版还在用同一个令牌的话，先别删）。
3. 「课程」文件夹里的课件和笔记会保留，想删的话自己删掉这个文件夹即可。
   下载的 **CanvasCompanion-ChatGPT** 文件夹也可以删掉了。

<details>
<summary><strong>备用：用终端卸载</strong></summary>
<p>退出 ChatGPT App 后，在终端里运行：</p>
<pre><code>~/.canvas-companion/codex/uninstall.sh</code></pre>
</details>
