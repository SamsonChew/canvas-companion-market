# Canvas Companion 安装指南

Canvas Companion 是 Claude Code 的一个插件。装好以后，你可以直接问 Claude：
「这周要交什么」「帮我预习 W5」「我的进度怎么样」。它还会把课件下载到你的电脑，帮你管理待办清单。

这份指南写给**用 Claude 的同学**。用 ChatGPT 的话，请看[ChatGPT 版安装指南](INSTALL-chatgpt.zh.md)。

- 它**只读** Canvas：不会替你交作业，不会发帖，不会改 Canvas 上的任何东西。
- 课件、笔记、待办都存在**你自己的 Mac** 上。
- 全程在 **Claude 桌面 App** 和浏览器里点鼠标完成，**不需要用终端**。
- **动手大约 10–15 分钟**，只需要做一次。中间要在授权网站 <https://canvas-companion.samsonchew.workers.dev> 申请授权码，
  由作者人工审核，**另外要等一等**（通常 1–2 天内，以申请页上写的为准）。

**使用本插件即表示你同意
[使用条款](https://github.com/SamsonChew/canvas-companion-market/blob/main/TERMS.zh.md) 和
[隐私说明](https://github.com/SamsonChew/canvas-companion-market/blob/main/PRIVACY.zh.md)。** 开始前请先读一下。

> Claude 桌面 App 更新很快。如果你看到的按钮或菜单名称和本指南不完全一样，
> 找意思最接近的那个就行；实在找不到，每一步后面都有「备用办法」。

---

## 总览

| 步骤 | 做什么 | 大约 |
|---|---|---|
| 0 | 准备：检查 Mac 和套餐，装 Claude 桌面 App，建「课程」文件夹，确认学校的 Canvas | 5 分钟 |
| 1 | 在桌面 App 里添加插件市场、安装插件（设置全部先留空） | 3 分钟 |
| 2 | 问「Canvas Companion 授权状态」，点回复里的链接申请授权码 | 2 分钟 |
| 3 | 批准后填入授权码 | 等批准 + 1 分钟 |
| 4 | 在对话里连上 Canvas，设置课程，开始用 | 3 分钟 |
| 5 | 在手机上用（可选） | — |
| 6 | 更新、常见问题 | — |

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

### 0.2 检查你的 Claude 套餐

你需要 **Claude Pro、Max、Team 或 Enterprise** 付费套餐。**免费版不能用 Claude Code。**
在 [claude.ai](https://claude.ai) 左下角点你的名字 → **设置**，可以看到自己的套餐。

### 0.3 安装 Claude 桌面 App 并登录

1. 打开 <https://claude.com/download>，下载 **macOS** 版。
2. 打开下载好的文件，把 **Claude** 图标拖进「应用程序」文件夹。
3. 在「应用程序」里打开 **Claude**，用你的 Claude 账号登录。
4. 点窗口顶部中间的 **Code** 标签。
   - 如果提示你升级套餐，说明账号还不是付费版（见 0.2）。
   - 如果提示你在网页上登录，照做，然后退出 App（`⌘ + Q`）再打开。

已经装过 Claude App 的话，请先更新到最新版（旧版可能没有添加插件市场的按钮）。

### 0.4 建一个课程文件夹

推荐放在你的**个人文件夹**里，叫 `课程`，而**不是**「文稿」或「桌面」：
很多 Mac 开着 iCloud 同步「桌面与文稿」，课件多了会被「移到云端」只留图标，插件就读不到了；
而且这几个文件夹受系统保护，会不时弹窗问能不能访问。

1. 打开 **Finder（访达）**，按 `⌘ + Shift + H`，进入个人文件夹（有个小房子图标）。
2. 在空白处右键 → **新建文件夹**，命名为 `课程`。

### 0.5 确认你学校的 Canvas

1. 用浏览器登录你学校的 Canvas，记下地址栏里的**网址**（只要主机名，例如 `canvas.yourschool.edu`）。
2. 点最左边深色竖栏里的 **Account（账户）** → **Settings（设置）**，往下滚到 **Approved Integrations**，
   确认能看到 **+ New Access Token** 按钮。**先不用点它**：第 4 步 Claude 会在对话里带你生成令牌。

> 找不到 **+ New Access Token** 按钮？说明你的学校关闭了学生自建令牌，这个插件暂时用不了，
> 请联系学校 IT（见[帮助](/help/#no-token-button)）。先确认这一点，免得白申请授权码。

---

## 第 1 步：在 Claude 桌面 App 里安装插件

<!-- demo:seg-1 old -->

### 1.1 打开一个本地会话

1. 在 Claude App 里点 **Code** 标签。
2. 在输入框附近，把运行环境选成 **Local**（在你自己的电脑上运行）。
3. 点 **Select folder**（选择文件夹），选刚才建的 **课程** 文件夹。
4. 如果问你**是否信任这个文件夹**，选信任（Trust / Yes）。

### 1.2 添加插件市场

1. 点左侧边栏的 **Customize（自定义）** → **Plugins**。
2. 点 **Add marketplace（添加市场）**，粘贴下面这一串，确认：

   ```
   SamsonChew/canvas-companion-market
   ```

这样添加的插件跟着你的 Claude 账号同步，作者发布新版本后会**自动更新**，不需要终端，也不需要另装开发者工具。

> **备用办法**：找不到 **Customize** 或里面没有 **Add marketplace** 的话，点输入框旁边的 **+** →
> **Plugins** → **Add plugin**，在插件浏览器里找 **Add marketplace**，粘贴同一串。
> 这条路第一次可能弹出「需要安装命令行开发者工具」：点 **安装**，等几分钟装完再做一次。
> 还不行，就用本步最后的「用终端安装」。

### 1.3 安装 canvas-companion（设置先全部留空）

1. 在 **Customize** → **Plugins** 的列表里找到 **canvas-companion**，打开它（Enable / Install）。
   走 **+** 那条备用路的话，安装范围选**你的用户账号**（user / Install for you）。
2. 可能会弹出一个设置窗口，有 **Canvas domain**、**Canvas access token**、**License key** 三项。
   **三项都可以留空**，直接保存或关掉：授权码第 3 步再填，Canvas 第 4 步在对话里连。

> 已经有 Canvas 令牌、想现在就填也可以：**Canvas domain** 填 0.5 记下的网址（不要 `https://`，结尾不要 `/`），
> **Canvas access token** 粘贴令牌。这样第 4 步的 4.2 就可以跳过。
>
> 令牌和授权码会存进 Mac 的「钥匙串」，不会以明文存在文件里。

<details>
<summary><strong>用终端安装（备用：桌面 App 里的按钮找不到时再用）</strong></summary>
<p>「终端」是 Mac 自带的 App：按 <code>⌘ + 空格</code>，输入 <code>Terminal</code>，按回车打开。
下面每个灰色框：<strong>复制 → 在终端里 <code>⌘ + V</code> 粘贴 → 按回车</strong>。</p>
<p><strong>A. 装命令行版 Claude Code</strong>（桌面 App 不会自动装它）：</p>
<pre><code>curl -fsSL https://claude.ai/install.sh | bash</code></pre>
<p>看到 <code>Claude Code successfully installed!</code> 后，<code>⌘ + Q</code> 退出终端再打开，运行
<code>claude --version</code>，能看到版本号就成功了。第一次运行 <code>claude</code> 时，照浏览器提示登录同一个 Claude 账号。</p>
<p><strong>B. 添加市场、安装插件</strong>，依次运行：</p>
<pre><code>claude plugin marketplace add SamsonChew/canvas-companion-market</code></pre>
<pre><code>claude plugin install canvas-companion@canvas-companion-market</code></pre>
<p>看到 <code>Successfully installed plugin</code> 就装好了。以后要在终端里填设置：<code>cd ~/课程 &amp;&amp; claude</code>，
输入 <code>/plugin</code> → 按 <strong>Tab</strong> 切到 <strong>Installed</strong> → 选 <strong>canvas-companion</strong> →
<strong>Configure options</strong>。之后回到桌面 App 用即可：两边读的是同一份设置。</p>
</details>

---

## 第 2 步：申请授权码

<!-- demo:seg-2 old -->

授权码和你的这台 Mac 绑定。插件会算出这台 Mac 的**设备编号**，并直接给你一个填好编号的申请链接。

1. 在 Claude App 的 **Code** 标签里，打开 **课程** 文件夹的会话，发送：

   ```
   Canvas Companion 授权状态
   ```

2. Claude 第一次用插件的工具时，会问你**是否允许**使用 `license_status`。点允许。
3. 它会回复「还没有填写授权码」，里面有你的**设备编号**（像 `7K2M-Q9XA-3FDR`）和一个**申请链接**。
   这是正常的：拿到授权码之前，插件只会回答授权状态。
4. 点开申请链接，设备编号已经**自动填好**。
   填一个称呼和联系方式；想收到批准通知的话，可以选填一个邮箱。提交。
   - 链接点不开：用浏览器打开授权网站 <https://canvas-companion.samsonchew.workers.dev>，点 **申请授权**，把设备编号**原样**粘贴进去。
5. 提交后，页面会给你一条**私人链接**。**马上把它加入书签（`⌘ + D`）。**
   - 这是你以后查看授权码的方式，**只显示这一次**。
   - 不要发给别人：拿到链接的人就能看到你的授权码。
   - 链接丢了，用申请时留的联系方式找作者重新生成。

作者人工审核，**通常 1–2 天内**（申请页提交后会写具体的预计时间）。等的时候可以先关掉 App。

---

## 第 3 步：批准后填入授权码

<!-- demo:seg-3 old -->

1. 打开第 2 步收藏的**私人链接**（留了邮箱的话，批准后会收到通知邮件），
   就能看到一串以 `CC1-` 开头的**授权码**。点 **复制**。
2. 回到 Claude App：**Customize** → **Plugins** → **canvas-companion** → 设置（Configure）。
   （备用：**+** → **Plugins** → **Manage plugins** → **canvas-companion**。）
3. 在 **License key** 一栏粘贴整串 `CC1-…` 授权码（要完整复制；之前填过 `x` 的话换掉它）。其他两项不用动。
4. **退出 Claude App（`⌘ + Q`）再打开**，设置才会生效。
5. 在 **课程** 文件夹的会话里再问一次：

   ```
   Canvas Companion 授权状态
   ```

   看到「授权有效，有效期至 …」就成功了。

---

## 第 4 步：连上 Canvas，开始用

<!-- demo:seg-4 -->

### 4.1 一次性允许插件的工具

不做这一步也能用，只是 Claude 每次用插件的工具都会问「是否允许」。想一次性全部允许，在会话里发送：

```
请在 ~/.claude/settings.json 的 permissions.allow 里加上 mcp__plugin_canvas-companion_companion__*（保留原有内容）
```

Claude 会请你批准修改这个文件，点允许；之后新开的会话就不会再问了。
插件没法自己预先获得这个许可，所以要你亲自点一次。这些工具只读 Canvas、读写你课程文件夹里的文件。

### 4.2 连上 Canvas（生成令牌）

令牌（token）就像一把只给这个插件用的钥匙，让它能**读**你的 Canvas。在会话里发送：

```
设置 Canvas
```

Claude 会问你学校的名字，找到你学校的 Canvas，给你一个直达令牌页面的链接，并一步步告诉你怎么做：

1. 在令牌页面点 **+ New Access Token**，**Purpose** 填 `Canvas Companion`。
2. **Expires 选允许的最晚一天**：Canvas 规定学生的令牌**最长 120 天**（学校可能设得更短）。
3. 点 **Generate Token**，**复制**那一长串字符（只显示这一次）。**不要把它粘贴到对话里。**
4. 回到对话说「复制好了」。插件会自己从剪贴板读取、到 Canvas 核对，存进钥匙串，并告诉你它哪天到期。

马上生效，不用重开 App。**在手机日历里设一个提醒**，比到期日早几天；
插件也会在到期前 14 天提醒你。到期后再说一次「设置 Canvas」换个新的就行（见[帮助](/help/#canvas-401)）。

> 令牌 = 你的 Canvas 权限。**不要发给任何人（包括作者）**，不要截图发群里。
>
> 不想在对话里做：自己在 Canvas 的 **Account → Settings** 生成令牌，填进插件设置
> （**Customize** → **Plugins** → **canvas-companion**）的 **Canvas domain** 和 **Canvas access token** 两栏，
> 然后退出 Claude App 再打开。

### 4.3 让 Claude 帮你设置课程

```
帮我设置课程
```

Claude 会列出你这学期 Canvas 上的课，为每门课建一个文件夹。检查一下课程对不对。

### 4.4 试试这些

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

也可以直接用插件自带的命令（在输入框里输入 `/`，或点 **+** → **Slash commands**）：

| 命令 | 作用 |
|---|---|
| `/canvas-companion:prep` | 预习某门课某一周，写成笔记 |
| `/canvas-companion:week` | 这周要交什么、有什么新公告 |
| `/canvas-companion:progress` | 整个学期的成绩和进度 |
| `/canvas-companion:todo` | 查看、添加、完成待办 |
| `/canvas-companion:status` | 全部课程的周报 |
| `/canvas-companion:setup` | 连上 Canvas，或更换到期的令牌 |

例如：

```
/canvas-companion:prep CS2040 W5
```

### 4.5 以后每次怎么打开

**每次都在「课程」文件夹里开会话**，否则它找不到你的课程：
Claude App → **Code** → 新会话 → **Local** → 文件夹选 **课程**。
用过一次之后，这个文件夹一般会出现在最近列表里。

### 第一次使用时可能弹出的窗口

| 弹窗 | 点什么 |
|---|---|
| 问你是否信任这个文件夹 | 在你自己的「课程」文件夹里选信任。 |
| Claude 问能不能用某个工具（`mcp__plugin_canvas-companion…`） | 允许。做完 4.1 就不会再问插件的工具了。 |
| 「"git" 命令需要使用命令行开发者工具」/ 安装开发者工具 | 只在走 **+** 备用路时出现：点 **安装**，装完再重做刚才那一步。 |
| 「"Claude"想访问"文稿"（或桌面、下载）文件夹中的文件」 | 点 **允许**。把课程放在「课程」文件夹基本不会出现。 |
| 「无法验证开发者」/「已阻止使用」 | 点 **完成**（不要点「移到废纸篓」），把整个弹窗截图发给作者。 |

---

## 第 5 步：在手机上用

<!-- demo:seg-5 -->

### 5.1 推荐：Remote Control（手机当遥控器）

Remote Control 是 Claude 官方的功能：你的 Mac 上开着会话，手机上的 Claude App 当它的「遥控器」。
读文件、跑工具都还在你的 Mac 上。Pro、Max、Team、Enterprise 都可以用
（Team / Enterprise 需要管理员先在后台打开 Remote Control）。

1. 手机上装好 **Claude App**（iOS / Android），登录**同一个账号**。
2. 在 Mac 的 Claude App 里，打开 **课程** 文件夹的会话，在输入框发送：

   ```
   /remote-control
   ```

   第一次可能会请你确认启用，选同意。
3. 在手机的 Claude App 里点 **Code**，在会话列表里找到这个会话
   （在线的会话有电脑图标和绿点），点进去。之后在手机上直接问就行。
4. 想断开时，在 Mac 上再发一次 `/remote-control`。

想让每个会话都自动连上：Mac 的 Claude App → **设置（Settings）→ Claude Code** →
打开 **Enable remote control by default**。

注意：

- **Mac 要开着，Claude App 不能退出。** 退出 App 或关机，手机上的会话就离线了。
- **不要让 Mac 睡着。** 合上盖子或自动睡眠后会断开，醒来后会自动重连。
  出门前建议插上电源，并在 **系统设置 → 电池 → 选项** 里打开
  「使用电源适配器且显示器关闭时，防止自动进入睡眠」（不同版本的名称可能略有不同）。
- 手机上的会话不能选 Auto 模式，工具权限会弹到手机上让你点。做了 4.1 会少很多。
- 连着 Remote Control 时，对话记录会经过 Anthropic 的服务器同步到手机。

### 5.2 可选：用 Telegram 聊天（官方 Channels 插件）

如果你更习惯在 Telegram 里发消息，可以用 Anthropic 官方的 **Telegram 插件**。先说清楚：

- 它是 Claude 的 **研究预览（research preview）** 功能，用法以后可能会变。
- 只能在**终端**里的 Claude Code 用，需要先装好命令行版（见第 1 步「用终端安装」A 部分），
  还要装 [Bun](https://bun.sh)。
- 你要自己在 Telegram 里建一个**机器人**，终端窗口要一直开着，Mac 不能睡。
- Pro、Max 个人账号可以直接用；Team / Enterprise 需要管理员先打开 Channels。

步骤（大致）：

1. 在 Telegram 里打开 **@BotFather**，发送 `/newbot`，起个名字和以 `bot` 结尾的用户名，
   复制它给你的 **token**（这是机器人的钥匙，不要发给别人）。
2. 在终端安装 Bun：

   ```bash
   curl -fsSL https://bun.sh/install | bash
   ```

3. 在课程文件夹打开 Claude Code：

   ```bash
   cd ~/课程 && claude
   ```

4. 在 Claude Code 里依次输入（安装时选 user 范围；`<token>` 换成第 1 步的 token）：

   ```
   /plugin install telegram@claude-plugins-official
   ```

   ```
   /telegram:configure <token>
   ```

5. 输入 `/exit` 退出，再用这一行重新打开：

   ```bash
   cd ~/课程 && claude --channels plugin:telegram@claude-plugins-official
   ```

6. 在 Telegram 里给你的机器人发任意一句话，它会回一个**配对码**。回到终端输入
   （`<code>` 换成配对码）：

   ```
   /telegram:access pair <code>
   ```

   ```
   /telegram:access policy allowlist
   ```

   第二行的作用是：只有你自己能给这个机器人发指令。

之后在 Telegram 里给机器人发消息，就会在你的 Mac 上执行。
详细说明见官方文档 <https://code.claude.com/docs/en/channels>。

---

## 第 6 步：更新和常见问题

### 更新插件

按 1.2 从 **Customize** → **Plugins** 添加的，会**自动更新**，不用做任何事；更新后退出 Claude App 再打开即可。

用 **+** 或终端装的，作者发布新版本后，最稳的办法是在终端运行（需要命令行版，见第 1 步「用终端安装」A 部分）：

```bash
claude plugin marketplace update canvas-companion-market
```

```bash
claude plugin update canvas-companion@canvas-companion-market
```

然后退出 Claude App 再打开。如果桌面 App 的 **+** → **Plugins** → **Manage plugins** 里有更新按钮，也可以直接点。

想让它自动更新：在终端的 `claude` 里输入 `/plugin` → **Tab** 到 **Marketplaces** →
选 `canvas-companion-market` → **Enable auto-update**。

**更新不会动你的东西**：课件、笔记（`notes/`）、待办清单都在「课程」文件夹里；
Canvas 令牌、授权码和其他设置存在 Claude 的设置和钥匙串里。这些更新后都还在。

### 关于授权，你需要知道的

- 授权码只能在**领取时那台 Mac** 上用。换电脑要重新领。
- 授权码有有效期。快到期（7 天内）时插件会提醒你。到授权网站 <https://canvas-companion.samsonchew.workers.dev> 的
  **我的授权** 页面点 **续期**，批准后复制新授权码，按第 3 步换掉旧的即可。
- 插件**每天联网一次**，从授权网站（连不上时从 GitHub，再不行从 jsDelivr）下载一份公开的「停用名单」，
  核对你的授权码是否被停用。这个请求**不会发送**你的授权码、设备编号或任何个人信息。
- **如果你的 Mac 连续 14 天没联网**（比如出国旅行、长时间不开机），插件会暂停工作，
  直到你联网并重开一次 Claude App。联网一次就恢复，不用找作者。
- 请不要把 Mac 的日期往回调，插件会认为时钟异常而暂停。

### 常见问题

| 你看到的情况 | 原因 | 怎么办 |
|---|---|---|
| 点 **Code** 标签提示升级 | 账号是免费版 | 需要 Pro、Max、Team 或 Enterprise（见 0.2）。 |
| **Customize → Plugins** 里找不到 canvas-companion | 市场还没加上 | 先把 Claude App 更新到最新版，重做 1.2；还不行就用「用终端安装」。 |
| 走 **+** 备用路添加市场时报错，或弹出安装开发者工具 | 缺少 `git` | 在弹窗里点 **安装**，装完后重做 1.2。 |
| 问什么都没反应，Claude 好像不知道这个插件 | 插件没启用，或设置改了没重开 | `⌘ + Q` 退出 Claude App 再打开。到 **Customize** → **Plugins** 确认 canvas-companion 已启用。还不行就截图发给作者。 |
| 输入 `/permissions` 或 `/plugin` 提示 `isn't available in this environment` | 桌面 App 不支持这类命令 | 正常。按 4.1 的办法，或在终端里的 `claude` 用。 |
| 「还没有填写授权码」 | 还没填授权码（或填的是 `x`） | 正常，点回复里的申请链接，按第 2、3 步做。 |
| 「授权码格式不对」「授权码无效（签名不符）」 | 没复制完整，或多了空格 | 重新复制整串 `CC1-…`，按第 3 步填进去，重开。 |
| 「这个授权码是给另一台设备（…）的」 | 换了电脑，或填了别人的授权码 | 在这台 Mac 上问「Canvas Companion 授权状态」，用新的设备编号到授权网站 <https://canvas-companion.samsonchew.workers.dev> 重新申请。 |
| 「授权码已于 … 过期」/「即将到期」 | 到期了 | 在授权网站 <https://canvas-companion.samsonchew.workers.dev> 的「我的授权」页面续期，拿到新授权码后按第 3 步填入。 |
| 「这个授权码已被作者停用」 | 作者停用了这个授权码 | 联系作者。 |
| 「已经超过 14 天没能联网核对授权状态」 | Mac 太久没联网 | 连上网络，退出并重新打开 Claude App，一次就好。 |
| 「这台 Mac 的系统时间比之前见过的时间…早了一天以上」 | 日期被调回过去了 | **系统设置 → 通用 → 日期与时间**，打开自动设置时间，然后重开 Claude App。 |
| 「这个授权码需要更新版本的插件」 | 插件太旧 | 按「更新插件」一节更新。 |
| `401 Unauthorized` 或 `Expired access token` | Canvas 令牌过期（最长 120 天）或被删了 | 在会话里说「设置 Canvas」，按 4.2 换一个新令牌（到期日选最晚的）。 |
| 找不到课程 / 文件同步到了奇怪的地方 | 会话没开在「课程」文件夹 | 新开一个会话，文件夹选 **课程**（见 4.5）。 |
| 手机上看不到会话 | Mac 睡着了、App 退出了，或没开 Remote Control | 唤醒 Mac，打开 Claude App，在会话里再发一次 `/remote-control`。 |
| 读 PDF 很慢，或读扫描版效果差 | 没装 PDF 工具，Claude 在用内置方式逐页看图 | 能用，只是慢。想更快：先装 [Homebrew](https://brew.sh)，再在终端运行下面的命令。 |
| 某周的课程页面是空的 | 老师设了解锁时间 | 到时间前 Canvas 本身就是空的，不是插件的问题。 |

可选的 PDF 加速工具（需要先装好 Homebrew）：

```bash
brew install poppler
```

### 和作者自己的版本有什么不同

作者自己用的是一套自建的版本，和你装的插件有几处不同：

- **手机**：作者用自建的 Telegram 机器人；插件用户用官方的 **Remote Control**（或可选的官方 Telegram 插件）。
- **提醒事项 / 日历**：作者的版本能写入 Mac 的「提醒事项」、读日历；插件没有这些，待办都在插件自己的清单里。
- **安装方式**：作者从源码运行；你装的是作者打包好的插件，需要授权码。
- 核心功能一样：读 Canvas、同步课件、预习、待办、进度、周报，都**只读** Canvas。

### 不想用了

1. Claude App → **Customize** → **Plugins** → **canvas-companion** → 卸载（Uninstall）。
   （用终端的话：`claude plugin uninstall canvas-companion@canvas-companion-market`）
2. 到 Canvas 的 **Account → Settings** 里，把 `Canvas Companion`（以前装的可能叫 `claude-code`）那个令牌删掉。
3. 「课程」文件夹里的课件和笔记会保留，想删的话自己删掉这个文件夹即可。
