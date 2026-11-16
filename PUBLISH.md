# 发布流程（照这个顺序点，不要跳）

镜像发布是**两件事并行**，缺一件都发不出去：

| 放哪儿 | 放什么 | 为什么 |
|---|---|---|
| AutoDL「镜像」 | 镜像本体（系统盘快照，约 25G） | 别人开实例时选它 |
| GitHub | 项目主页（README + 脚本 + 模型清单） | autodl.art 发布表单必填仓库地址 |

---

## 第 1 步：保存镜像（AutoDL 控制台）

1. 我的实例 → **关机**（运行中不能保存）
2. 实例卡片 → **更多** → **保存镜像**
3. 命名：`kijing-h3-v1.1.55-20261116`
4. 左侧「镜像」菜单看进度，占用会显示在这里

> 保存前建议先跑一遍 `/root/prep_image.sh`，确认没有断链、没有在跑的任务。

## 第 2 步：建 GitHub 仓库并推送

本目录已经是初始化好的 git 仓库，只差一个远程地址。

**方式一：网页建空仓库（推荐，无需装工具）**

1. 打开 https://github.com/new
2. Repository name 填 `kijing-h3-image`
3. 选 **Public**（社区镜像要审核，私有仓库审核看不到）
4. **不要**勾选 Add README / .gitignore / license
5. 建完复制仓库地址，然后在本目录执行：

```bash
cd /Users/lr/Downloads/kijing-studio-hk-skill/kijing-h3-image
git remote add origin https://github.com/<你的用户名>/kijing-h3-image.git
git branch -M main
git push -u origin main
```

**方式二：装 gh 一条命令建完**

```bash
brew install gh && gh auth login
cd /Users/lr/Downloads/kijing-studio-hk-skill/kijing-h3-image
gh repo create kijing-h3-image --public --source=. --push
```

## 第 3 步：发布到社区（autodl.art）

1. 打开 **https://www.autodl.art**，用 AutoDL 账号直接登录（两边共用账号）
2. 页头 **`+`** → 发布
3. 按下表填写：

| 字段 | 填什么 |
|---|---|
| 镜像 | 选第 1 步保存的 `kijing-h3-v1.1.55-20261116` |
| 项目名 | 开镜 KaiJing · MiniMax-H3 视频生成环境 |
| GitHub 仓库 | 第 2 步的仓库地址 |
| 简介 | 预装 ComfyUI + MiniMax-H3 视频工作流，含 5 个自定义节点，开箱即用 |
| 启动命令 | `bash /root/autostart_comfyui.sh` |
| 端口 | `6006` |
| 显存要求 | ≥ 24G |
| 说明 | 直接把 README 里「使用步骤 + 常见问题」两节贴过去 |

4. 提交 → 等审核 → 通过后出现在「社区镜像」，任何人创建实例时都能选

## 第 4 步：验一遍（必须做）

用**另一个账号**（或让朋友）走一遍：

- [ ] 创建实例 → 社区镜像里能搜到
- [ ] 勾选公共模型后开机，`bash /root/autostart_comfyui.sh` 起得来
- [ ] 6006 自定义服务能打开 WebUI
- [ ] 跑一条最短工作流能出视频

任何一步失败，都要回到镜像里修，然后**重新保存一版新镜像**（旧镜像不能改，只能删或留着）。

---

## 只在熟人之间发？跳过第 2、3 步

镜像 → 目标镜像 → **操作** → **共享** → 填对方 AutoDL 用户 ID（对方登录后页头用户名下拉里那串）。

不需要 GitHub，也不需要审核。缺点是一次只能加一个人。
