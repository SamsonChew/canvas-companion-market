# Canvas Companion 隐私说明

> 本文件适用于当前的 Beta（免费）阶段；开始收费前会更新，并提前通知。

更新日期：2026-10-01　·　提供者：Samson Chew（下称「作者」）

一句话：**你的 Canvas 令牌和课程资料只在你自己的 Mac 上；作者看不到。**

## 1. 留在你 Mac 上的东西

| 内容 | 存在哪里 |
|---|---|
| Canvas 访问令牌、授权码 | macOS 钥匙串（由 Claude Code 的插件设置保存） |
| Canvas 网址 | Claude Code 的插件设置 |
| 下载的课件、你的笔记、待办清单、课表 | 你的课程文件夹（其中 `.companion/` 放设置和待办） |
| 授权检查的缓存（吊销列表、上次联网核对的时间） | `~/Library/Application Support/canvas-companion/license-state.json` |

这些都**不会**发给作者。插件没有使用统计、没有崩溃上报、没有广告。

## 2. 插件会连到哪里

1. **你的大学的 Canvas**：用你的令牌读取课程、作业、文件、公告。只读，不写。
2. **吊销列表**：每天最多一次，对授权网站（https://canvas-companion.samsonchew.workers.dev，托管在 Cloudflare）发一个普通 GET 请求；
   失败时依次再试 GitHub（`raw.githubusercontent.com`）和 jsDelivr（`cdn.jsdelivr.net`）。
   请求里**不带**你的授权码、设备编号、名字或任何其他数据，
   但和任何网络请求一样，Cloudflare / GitHub / jsDelivr 会看到你的 **IP 地址**和请求时间。
   它们如何处理这些数据，见各自的隐私政策。
3. **Anthropic**：你和 Claude 的对话（包括插件读给 Claude 的课件内容）按你自己的 Claude 账户，
   由 Claude Code 发给 Anthropic，受你和 Anthropic 之间的条款约束。插件不会另外把数据发给 Anthropic。

## 3. 作者持有的信息

作者只保存签发授权码需要的东西，存在授权网站的数据库（Cloudflare）里，作者自己的 Mac 上有离线备份：

- 你在授权网站申请时留下的**联系方式**（例如 Telegram 用户名或手机号）；
- 你的名字或你给的称呼；
- 选填邮箱，仅用于批准通知（申请时不填就没有；批准后发一封通知邮件，不含授权码）；
- 你的**设备编号**（例如 `7K2M-Q9XA-3FDR`，是 Mac 硬件编号加盐后的哈希，不能反推出硬件编号或任何个人信息）；
- 授权码、签发和到期日期；
- 付款记录（日期、金额、方式）和备注。

作者**没有**你的 Canvas 令牌、成绩、课件、笔记或对话内容。

保存多久：授权结束后 1 年；你可以随时要求删除，付款记录按法律要求保留的除外。
要查看或删除你的信息：通过学生站「帮助」页（https://canvas-companion.samsonchew.workers.dev/help/）或 Telegram联系作者。

## 4. 卸载

卸载插件（`claude plugin uninstall …`）后，插件不再联网。你的课程文件夹不会被删除；
钥匙串里的令牌可以在 Canvas 里作废，缓存文件可以手动删除上面第 1 节的那个路径。
