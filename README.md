# 《量子力学原理》习题解答 LaTeX 项目说明

这个项目把《量子力学原理》习题解答按“章 / 节”拆分成多个 LaTeX 源文件。这样做的目的，是让每一节的习题解答都能独立维护，并且可以按全书、单章或单节快速编译检查。

本仓库是尚卡尔（R. Shankar）《量子力学原理》的习题解答整理项目。仓库中主要保存 LaTeX 源码、章节结构、编译脚本和全书发布版 PDF。

全书发布版 PDF 位于：

```text
pdf/quantum-mechanics-solutions.pdf
```

这个 PDF 会跟随源码一起提交到 GitHub，方便直接下载阅读。`build/` 目录仍然是本地编译临时目录，不需要提交。

## 一、项目总体结构

```text
.
|-- .agents/
|-- .git/
|-- build/                         # 编译后自动生成
|-- chapters/
|   |-- ch01/
|   |-- ch02/
|   |-- ...
|   `-- ch21/
|-- figures/
|   `-- .gitkeep
|-- pdf/
|   |-- .gitkeep
|   `-- quantum-mechanics-solutions.pdf
|-- preamble/
|   |-- packages.tex
|   |-- metadata.tex
|   |-- macros.tex
|   `-- environments.tex
|-- scripts/
|   |-- init-structure.ps1
|   |-- build.ps1
|   `-- watch.ps1
|-- structure/
|   `-- sections.csv
|-- .gitignore
|-- latexmkrc
|-- LICENSE
|-- main.tex
`-- README.md
```

清理说明：

- 根目录中的 `main.aux`、`main.log`、`main.out`、`main.pdf`、`main.synctex.gz`、`main.toc` 是旧的直接编译产物，已经删除。
- 新编译产物统一进入 `build/`。
- 最终发布 PDF 统一放在 `pdf/quantum-mechanics-solutions.pdf`。

## 二、根目录文件作用

| 文件           | 作用                                                                                                                                                         |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `main.tex`   | 全书主入口。它设置文档类`ctexbook`，加载 `preamble/` 下的导言文件，生成标题页和目录，并依次 `\include` 第 1 到第 21 章。正常编译全书时从这个文件开始。 |
| `latexmkrc`  | `latexmk` 的默认配置文件。当前指定 PDF 编译模式、使用 `xelatex`、遇到错误停止、最多重复编译 5 次。                                                       |
| `LICENSE`    | 项目许可证文件，当前使用 MIT License。                                                                                                                       |
| `README.md`  | 项目说明文档，也就是当前文件。用于说明文件结构、每个文件的作用、写题方式和编译步骤。                                                                         |
| `.gitignore` | Git 忽略规则。忽略 `build/` 目录、根目录 `main.pdf` 以及 LaTeX 编译时产生的 `.aux`、`.log`、`.toc`、`.synctex.gz` 等临时文件。                         |

根目录中如果出现 `main.aux`、`main.log`、`main.out`、`main.toc`、`main.synctex.gz`、`main.pdf` 等文件，它们是直接编译 `main.tex` 时生成的编译产物，不是主要源码。推荐使用 `scripts/build.ps1` 编译，这样产物会统一放到 `build/` 目录。

## 三、目录作用

| 目录或文件 | 作用 |
| --- | --- |
| `.agents/` | 本地工具或自动化代理留下的辅助目录，不参与 LaTeX 编译，通常不需要手动修改。 |
| `.git/` | Git 版本库内部数据目录，用于保存提交历史、分支和索引，不要手动编辑或删除。 |
| `build/` | 编译输出目录，由 `scripts/build.ps1` 自动生成。里面包含 PDF、日志、辅助索引、同步定位等临时产物，可以通过 `build.ps1 -Mode clean` 清理后重新生成。 |
| `chapters/` | 全书正文源码目录。每个 `chXX/` 子目录对应一章，里面包含该章入口文件和各小节习题解答文件。 |
| `figures/` | 图片资源目录。正文插图、示意图和外部图片放在这里；`figures/.gitkeep` 用于在目录为空时保留该目录。 |
| `pdf/` | 发布 PDF 目录。`pdf/quantum-mechanics-solutions.pdf` 是全书编译后的发布副本；`pdf/.gitkeep` 用于在目录为空时保留该目录。 |
| `preamble/` | LaTeX 导言区目录，统一管理宏包、元数据、自定义命令和习题环境。 |
| `scripts/` | PowerShell 自动化脚本目录，负责初始化结构、编译和监听。 |
| `structure/` | 章节结构数据目录，当前包含 `sections.csv`。 |

## 四、导言区文件作用

| 文件                          | 作用                                                                                                                                                                                                                                          |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `preamble/packages.tex`     | 管理全书使用的 LaTeX 宏包和版式设置。包括页面尺寸、数学宏包、图片、颜色、表格、列表、页眉页脚、超链接、段落缩进、行距和公式编号方式等。                                                                                                       |
| `preamble/metadata.tex`     | 管理书名、作者、日期等元数据。`main.tex` 中的 `\maketitle` 会使用这里定义的信息。                                                                                                                                                         |
| `preamble/macros.tex`       | 定义常用数学命令。例如虚数单位`\ii`、自然指数 `\ee`、微分 `\dd`、希尔伯特空间 `\h`、算符帽号 `\op{}`、对易子 `\comm{}{}`、Dirac 符号 `\ket{}`、`\bra{}`、`\braket{}{}`、矩阵元 `\mel{}{}{}`、迹 `\Tr`、范数和绝对值等。 |
| `preamble/environments.tex` | 定义习题解答环境。核心是`solution` 环境，以及 `\problem{}`、`\answer`、`\remarkline{}` 等命令。习题编号按小节重置，显示为类似 `7.3.1` 的形式。                                                                                      |

## 五、结构数据文件作用

| 文件                       | 作用                                                                                                                                                                                                                 |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `structure/sections.csv` | 章节结构表。每一行记录一章中的一个小节，字段包括`chapter`、`chapter_title`、`section`、`section_title`。`scripts/init-structure.ps1` 用它生成 `chapters/chXX/chXX.tex` 和 `chapters/chXX/sec-YY.tex`。 |

## 六、脚本文件作用

| 文件                           | 作用                                                                                                                                |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| `scripts/init-structure.ps1` | 根据`structure/sections.csv` 初始化章节目录和小节文件。默认不会覆盖已有文件；加 `-Force` 后会重新生成并覆盖章节入口和小节模板。 |
| `scripts/build.ps1`          | 主要编译脚本。支持全书编译、单章编译、单节编译和清理`build/` 目录。它会调用 `latexmk + xelatex`，并把输出放进 `build/`。      |
| `scripts/watch.ps1`          | 单节监听编译脚本。先编译指定小节，然后用`latexmk -pvc` 持续监听该小节包装文件及相关依赖，文件变化后自动重新编译。                 |

## 七、章节文件作用

`chapters/` 下每个 `chXX/` 目录对应原书的一章。

每章目录里有两类文件：

- `chXX.tex`：该章入口文件，定义 `\chapter{...}`，并按顺序 `\input` 本章所有小节文件。
- `sec-YY.tex`：该章第 `YY` 节的具体习题解答文件。平时主要编辑这些文件。

### 第 1 章：数学导论

| 文件                         | 作用                                                              |
| ---------------------------- | ----------------------------------------------------------------- |
| `chapters/ch01/ch01.tex`   | 第 1 章入口文件，负责生成“数学导论”章标题，并载入本章全部小节。 |
| `chapters/ch01/sec-01.tex` | 第 1.1 节“线性矢量空间：基”的习题解答。                         |
| `chapters/ch01/sec-02.tex` | 第 1.2 节“内积空间”的习题解答。                                 |
| `chapters/ch01/sec-03.tex` | 第 1.3 节“对偶空间和狄拉克符号”的习题解答。                     |
| `chapters/ch01/sec-04.tex` | 第 1.4 节“子空间”的习题解答。                                   |
| `chapters/ch01/sec-05.tex` | 第 1.5 节“线性算符”的习题解答。                                 |
| `chapters/ch01/sec-06.tex` | 第 1.6 节“线性算符的矩阵元”的习题解答。                         |
| `chapters/ch01/sec-07.tex` | 第 1.7 节“主动变换和被动变换”的习题解答。                       |
| `chapters/ch01/sec-08.tex` | 第 1.8 节“本征值问题”的习题解答。                               |
| `chapters/ch01/sec-09.tex` | 第 1.9 节“算符函数及其相关概念”的习题解答。                     |
| `chapters/ch01/sec-10.tex` | 第 1.10 节“推广到无穷维”的习题解答。                            |

### 第 2 章：经典力学述评

| 文件                         | 作用                                                                  |
| ---------------------------- | --------------------------------------------------------------------- |
| `chapters/ch02/ch02.tex`   | 第 2 章入口文件，负责生成“经典力学述评”章标题，并载入本章全部小节。 |
| `chapters/ch02/sec-01.tex` | 第 2.1 节“最小作用原理和拉格朗日力学”的习题解答。                   |
| `chapters/ch02/sec-02.tex` | 第 2.2 节“电磁拉格朗日量”的习题解答。                               |
| `chapters/ch02/sec-03.tex` | 第 2.3 节“两体问题”的习题解答。                                     |
| `chapters/ch02/sec-04.tex` | 第 2.4 节“粒子有多聪明？”的习题解答。                               |
| `chapters/ch02/sec-05.tex` | 第 2.5 节“哈密顿形式”的习题解答。                                   |
| `chapters/ch02/sec-06.tex` | 第 2.6 节“哈密顿量方案中的电磁力”的习题解答。                       |
| `chapters/ch02/sec-07.tex` | 第 2.7 节“循环坐标、泊松括号和正则变换”的习题解答。                 |
| `chapters/ch02/sec-08.tex` | 第 2.8 节“对称性及其推论”的习题解答。                               |

### 第 3 章：经典力学并非一切顺利

| 文件                         | 作用                                                                          |
| ---------------------------- | ----------------------------------------------------------------------------- |
| `chapters/ch03/ch03.tex`   | 第 3 章入口文件，负责生成“经典力学并非一切顺利”章标题，并载入本章全部小节。 |
| `chapters/ch03/sec-01.tex` | 第 3.1 节“经典物理中的粒子和波”的习题解答。                                 |
| `chapters/ch03/sec-02.tex` | 第 3.2 节“（经典）波和粒子的一个实验”的习题解答。                           |
| `chapters/ch03/sec-03.tex` | 第 3.3 节“光的双缝实验”的习题解答。                                         |
| `chapters/ch03/sec-04.tex` | 第 3.4 节“物质波（德布罗意波）”的习题解答。                                 |
| `chapters/ch03/sec-05.tex` | 第 3.5 节“结论”的习题解答。                                                 |

### 第 4 章：公设：一般性讨论

| 文件                         | 作用                                                                      |
| ---------------------------- | ------------------------------------------------------------------------- |
| `chapters/ch04/ch04.tex`   | 第 4 章入口文件，负责生成“公设：一般性讨论”章标题，并载入本章全部小节。 |
| `chapters/ch04/sec-01.tex` | 第 4.1 节“公设”的习题解答。                                             |
| `chapters/ch04/sec-02.tex` | 第 4.2 节“公设 I--III 的讨论”的习题解答。                               |
| `chapters/ch04/sec-03.tex` | 第 4.3 节“薛定谔方程（一丝不苟，注重细节）”的习题解答。                 |

### 第 5 章：一维简单问题

| 文件                         | 作用                                                                  |
| ---------------------------- | --------------------------------------------------------------------- |
| `chapters/ch05/ch05.tex`   | 第 5 章入口文件，负责生成“一维简单问题”章标题，并载入本章全部小节。 |
| `chapters/ch05/sec-01.tex` | 第 5.1 节“自由粒子”的习题解答。                                     |
| `chapters/ch05/sec-02.tex` | 第 5.2 节“箱子中的粒子”的习题解答。                                 |
| `chapters/ch05/sec-03.tex` | 第 5.3 节“概率连续性方程”的习题解答。                               |
| `chapters/ch05/sec-04.tex` | 第 5.4 节“单步阶梯势：一个散射问题”的习题解答。                     |
| `chapters/ch05/sec-05.tex` | 第 5.5 节“双缝实验”的习题解答。                                     |
| `chapters/ch05/sec-06.tex` | 第 5.6 节“一些定理”的习题解答。                                     |

### 第 6 章：经典极限

| 文件                       | 作用                                                                          |
| -------------------------- | ----------------------------------------------------------------------------- |
| `chapters/ch06/ch06.tex` | 第 6 章入口文件，负责生成“经典极限”章标题。目前该章没有拆出单独的小节文件。 |

### 第 7 章：简谐振子

| 文件                         | 作用                                                              |
| ---------------------------- | ----------------------------------------------------------------- |
| `chapters/ch07/ch07.tex`   | 第 7 章入口文件，负责生成“简谐振子”章标题，并载入本章全部小节。 |
| `chapters/ch07/sec-01.tex` | 第 7.1 节“为什么研究简谐振子？”的习题解答。                     |
| `chapters/ch07/sec-02.tex` | 第 7.2 节“经典振子回顾”的习题解答。                             |
| `chapters/ch07/sec-03.tex` | 第 7.3 节“简谐振子的量子化（坐标基）”的习题解答。               |
| `chapters/ch07/sec-04.tex` | 第 7.4 节“能量基下的谐振子”的习题解答。                         |
| `chapters/ch07/sec-05.tex` | 第 7.5 节“从能量基过渡到坐标基”的习题解答。                     |

### 第 8 章：量子理论的路径积分形式

| 文件                         | 作用                                                                            |
| ---------------------------- | ------------------------------------------------------------------------------- |
| `chapters/ch08/ch08.tex`   | 第 8 章入口文件，负责生成“量子理论的路径积分形式”章标题，并载入本章全部小节。 |
| `chapters/ch08/sec-01.tex` | 第 8.1 节“路径积分方案”的习题解答。                                           |
| `chapters/ch08/sec-02.tex` | 第 8.2 节“该方案的分析”的习题解答。                                           |
| `chapters/ch08/sec-03.tex` | 第 8.3 节“自由粒子 U(t) 的一种近似”的习题解答。                               |
| `chapters/ch08/sec-04.tex` | 第 8.4 节“自由粒子传播子的路径积分计算”的习题解答。                           |
| `chapters/ch08/sec-05.tex` | 第 8.5 节“与薛定谔方程的等价性”的习题解答。                                   |
| `chapters/ch08/sec-06.tex` | 第 8.6 节“形式为`V=a+bx+cx^2+d\dot{x}+ex\dot{x}` 的势”的习题解答。          |

### 第 9 章：海森堡不确定度关系

| 文件                         | 作用                                                                        |
| ---------------------------- | --------------------------------------------------------------------------- |
| `chapters/ch09/ch09.tex`   | 第 9 章入口文件，负责生成“海森堡不确定度关系”章标题，并载入本章全部小节。 |
| `chapters/ch09/sec-01.tex` | 第 9.1 节“引言”的习题解答。                                               |
| `chapters/ch09/sec-02.tex` | 第 9.2 节“不确定度关系的推导”的习题解答。                                 |
| `chapters/ch09/sec-03.tex` | 第 9.3 节“最小不确定度波包”的习题解答。                                   |
| `chapters/ch09/sec-04.tex` | 第 9.4 节“不确定性原理的应用”的习题解答。                                 |
| `chapters/ch09/sec-05.tex` | 第 9.5 节“能量-时间不确定度关系”的习题解答。                              |

### 第 10 章：N 个自由度系统

| 文件                         | 作用                                                                     |
| ---------------------------- | ------------------------------------------------------------------------ |
| `chapters/ch10/ch10.tex`   | 第 10 章入口文件，负责生成“N 个自由度系统”章标题，并载入本章全部小节。 |
| `chapters/ch10/sec-01.tex` | 第 10.1 节“一维中的 N 个粒子”的习题解答。                              |
| `chapters/ch10/sec-02.tex` | 第 10.2 节“更高维中的更多粒子”的习题解答。                             |
| `chapters/ch10/sec-03.tex` | 第 10.3 节“全同粒子”的习题解答。                                       |

### 第 11 章：对称性及其推论

| 文件                         | 作用                                                                     |
| ---------------------------- | ------------------------------------------------------------------------ |
| `chapters/ch11/ch11.tex`   | 第 11 章入口文件，负责生成“对称性及其推论”章标题，并载入本章全部小节。 |
| `chapters/ch11/sec-01.tex` | 第 11.1 节“概述”的习题解答。                                           |
| `chapters/ch11/sec-02.tex` | 第 11.2 节“量子理论中的平移不变性”的习题解答。                         |
| `chapters/ch11/sec-03.tex` | 第 11.3 节“时间平移不变性”的习题解答。                                 |
| `chapters/ch11/sec-04.tex` | 第 11.4 节“宇称不变性”的习题解答。                                     |
| `chapters/ch11/sec-05.tex` | 第 11.5 节“时间反演对称性”的习题解答。                                 |

### 第 12 章：转动不变性和角动量

| 文件                         | 作用                                                                         |
| ---------------------------- | ---------------------------------------------------------------------------- |
| `chapters/ch12/ch12.tex`   | 第 12 章入口文件，负责生成“转动不变性和角动量”章标题，并载入本章全部小节。 |
| `chapters/ch12/sec-01.tex` | 第 12.1 节“二维中的平移”的习题解答。                                       |
| `chapters/ch12/sec-02.tex` | 第 12.2 节“二维中的转动”的习题解答。                                       |
| `chapters/ch12/sec-03.tex` | 第 12.3 节“`L_z` 的本征值问题”的习题解答。                               |
| `chapters/ch12/sec-04.tex` | 第 12.4 节“三维中的角动量”的习题解答。                                     |
| `chapters/ch12/sec-05.tex` | 第 12.5 节“`L^2` 和 `L_z` 的本征值问题”的习题解答。                    |
| `chapters/ch12/sec-06.tex` | 第 12.6 节“转动不变问题的解”的习题解答。                                   |

### 第 13 章：氢原子

| 文件                         | 作用                                                             |
| ---------------------------- | ---------------------------------------------------------------- |
| `chapters/ch13/ch13.tex`   | 第 13 章入口文件，负责生成“氢原子”章标题，并载入本章全部小节。 |
| `chapters/ch13/sec-01.tex` | 第 13.1 节“本征值问题”的习题解答。                             |
| `chapters/ch13/sec-02.tex` | 第 13.2 节“氢原子能谱的简并性”的习题解答。                     |
| `chapters/ch13/sec-03.tex` | 第 13.3 节“数值估算和与实验的比较”的习题解答。                 |
| `chapters/ch13/sec-04.tex` | 第 13.4 节“多电子原子和周期表”的习题解答。                     |

### 第 14 章：自旋

| 文件                         | 作用                                                           |
| ---------------------------- | -------------------------------------------------------------- |
| `chapters/ch14/ch14.tex`   | 第 14 章入口文件，负责生成“自旋”章标题，并载入本章全部小节。 |
| `chapters/ch14/sec-01.tex` | 第 14.1 节“引言”的习题解答。                                 |
| `chapters/ch14/sec-02.tex` | 第 14.2 节“自旋的本质是什么？”的习题解答。                   |
| `chapters/ch14/sec-03.tex` | 第 14.3 节“自旋的运动学”的习题解答。                         |
| `chapters/ch14/sec-04.tex` | 第 14.4 节“自旋动力学”的习题解答。                           |
| `chapters/ch14/sec-05.tex` | 第 14.5 节“回到轨道自由度”的习题解答。                       |

### 第 15 章：角动量加法

| 文件                         | 作用                                                                 |
| ---------------------------- | -------------------------------------------------------------------- |
| `chapters/ch15/ch15.tex`   | 第 15 章入口文件，负责生成“角动量加法”章标题，并载入本章全部小节。 |
| `chapters/ch15/sec-01.tex` | 第 15.1 节“一个简单的例子”的习题解答。                             |
| `chapters/ch15/sec-02.tex` | 第 15.2 节“一般问题”的习题解答。                                   |
| `chapters/ch15/sec-03.tex` | 第 15.3 节“不可约张量算符”的习题解答。                             |
| `chapters/ch15/sec-04.tex` | 第 15.4 节“某些“偶然”简并度的解释”的习题解答。                   |

### 第 16 章：变分法和 WKB 法

| 文件                         | 作用                                                                      |
| ---------------------------- | ------------------------------------------------------------------------- |
| `chapters/ch16/ch16.tex`   | 第 16 章入口文件，负责生成“变分法和 WKB 法”章标题，并载入本章全部小节。 |
| `chapters/ch16/sec-01.tex` | 第 16.1 节“变分法”的习题解答。                                          |
| `chapters/ch16/sec-02.tex` | 第 16.2 节“WKB（Wentzel-Kramers-Brillouin）法”的习题解答。              |

### 第 17 章：不含时微扰论

| 文件                         | 作用                                                                   |
| ---------------------------- | ---------------------------------------------------------------------- |
| `chapters/ch17/ch17.tex`   | 第 17 章入口文件，负责生成“不含时微扰论”章标题，并载入本章全部小节。 |
| `chapters/ch17/sec-01.tex` | 第 17.1 节“形式体系”的习题解答。                                     |
| `chapters/ch17/sec-02.tex` | 第 17.2 节“一些例子”的习题解答。                                     |
| `chapters/ch17/sec-03.tex` | 第 17.3 节“简并微扰论”的习题解答。                                   |

### 第 18 章：含时微扰论

| 文件                         | 作用                                                                 |
| ---------------------------- | -------------------------------------------------------------------- |
| `chapters/ch18/ch18.tex`   | 第 18 章入口文件，负责生成“含时微扰论”章标题，并载入本章全部小节。 |
| `chapters/ch18/sec-01.tex` | 第 18.1 节“问题”的习题解答。                                       |
| `chapters/ch18/sec-02.tex` | 第 18.2 节“一阶微扰论”的习题解答。                                 |
| `chapters/ch18/sec-03.tex` | 第 18.3 节“微扰论中的更高阶”的习题解答。                           |
| `chapters/ch18/sec-04.tex` | 第 18.4 节“电磁相互作用的一般讨论”的习题解答。                     |
| `chapters/ch18/sec-05.tex` | 第 18.5 节“原子与电磁辐射的相互作用”的习题解答。                   |

### 第 19 章：散射理论

| 文件                         | 作用                                                               |
| ---------------------------- | ------------------------------------------------------------------ |
| `chapters/ch19/ch19.tex`   | 第 19 章入口文件，负责生成“散射理论”章标题，并载入本章全部小节。 |
| `chapters/ch19/sec-01.tex` | 第 19.1 节“引言”的习题解答。                                     |
| `chapters/ch19/sec-02.tex` | 第 19.2 节“一维散射的再现和概述”的习题解答。                     |
| `chapters/ch19/sec-03.tex` | 第 19.3 节“玻恩近似（含时描述）”的习题解答。                     |
| `chapters/ch19/sec-04.tex` | 第 19.4 节“再论玻恩近似（不含时描述）”的习题解答。               |
| `chapters/ch19/sec-05.tex` | 第 19.5 节“分波展开”的习题解答。                                 |
| `chapters/ch19/sec-06.tex` | 第 19.6 节“两粒子散射”的习题解答。                               |

### 第 20 章：狄拉克方程

| 文件                         | 作用                                                                 |
| ---------------------------- | -------------------------------------------------------------------- |
| `chapters/ch20/ch20.tex`   | 第 20 章入口文件，负责生成“狄拉克方程”章标题，并载入本章全部小节。 |
| `chapters/ch20/sec-01.tex` | 第 20.1 节“自由粒子狄拉克方程”的习题解答。                         |
| `chapters/ch20/sec-02.tex` | 第 20.2 节“狄拉克粒子的电磁相互作用”的习题解答。                   |
| `chapters/ch20/sec-03.tex` | 第 20.3 节“再论相对论量子力学”的习题解答。                         |

### 第 21 章：路径积分：第二部分

| 文件                         | 作用                                                                         |
| ---------------------------- | ---------------------------------------------------------------------------- |
| `chapters/ch21/ch21.tex`   | 第 21 章入口文件，负责生成“路径积分：第二部分”章标题，并载入本章全部小节。 |
| `chapters/ch21/sec-01.tex` | 第 21.1 节“路径积分的导出”的习题解答。                                     |
| `chapters/ch21/sec-02.tex` | 第 21.2 节“虚时形式”的习题解答。                                           |
| `chapters/ch21/sec-03.tex` | 第 21.3 节“自旋和费米子路径积分”的习题解答。                               |
| `chapters/ch21/sec-04.tex` | 第 21.4 节“总结”的习题解答。                                               |

## 八、如何写入习题解答

平时只需要编辑对应的小节文件，例如：

```text
chapters/ch07/sec-03.tex
```

在小节文件中添加习题解答时，使用下面的结构：

```latex
\begin{solution}[题目关键词或原书题号]
\problem{在这里粘贴或概括原题。}
\answer
在这里写解答。
\end{solution}
```

说明：

- `solution` 会自动增加习题编号。
- 编号按小节重置，例如第 7 章第 3 节中的题会显示为 `7.3.1`、`7.3.2`。
- `\problem{}` 用来放题目。
- `\answer` 后面写正式解答。
- 需要补充说明时可以使用 `\remarkline{...}`。

## 九、编译前准备

需要先安装 LaTeX 发行版，并确保命令行里能找到 `latexmk` 和 `xelatex`。

Windows 推荐安装：

- TeX Live，或
- MiKTeX

安装后在 PowerShell 中检查：

```powershell
latexmk -v
xelatex --version
```

如果能输出版本信息，说明编译工具可用。

## 十、编译操作步骤

以下命令都在项目根目录执行：

```powershell
cd "D:\Books\量子力学原理习题解答(尚卡尔)"
```

### 1. 初始化章节文件

如果 `chapters/` 下的章节和小节文件已经存在，通常不需要执行这一步。

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-structure.ps1
```

如果修改了 `structure/sections.csv`，并且希望按新的结构重新生成章节文件，可以使用：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-structure.ps1 -Force
```

注意：`-Force` 会覆盖已有章节入口和小节模板，使用前要确认已有内容已经备份或不需要保留。

### 2. 编译全书

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build.ps1
```

等价于：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build.ps1 -Mode full
```

输出文件通常在：

```text
build/shankar-solutions.pdf
```

同时会同步生成发布版本：

```text
pdf/quantum-mechanics-solutions.pdf
```

### 3. 只编译某一章

例如只编译第 7 章：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build.ps1 -Mode chapter -Chapter 7
```

输出文件通常在：

```text
build/shankar-ch07.pdf
```

这个模式适合检查某一章的整体排版和公式编号。

### 4. 只编译某一节

例如只编译第 7 章第 3 节：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build.ps1 -Mode section -Chapter 7 -Section 3
```

输出文件通常在：

```text
build/sec-ch07-03.pdf
```

这个模式最适合日常写题时快速检查当前小节。

### 5. 监听某一节并自动重新编译

例如监听第 7 章第 3 节：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\watch.ps1 -Chapter 7 -Section 3
```

运行后不要关闭这个 PowerShell 窗口。修改并保存相关 `.tex` 文件后，`latexmk` 会自动重新编译。

实时查看结果的推荐工作模式：

1. 在 VS Code 里打开要编辑的小节，例如 `chapters/ch07/sec-03.tex`。
2. 打开一个 PowerShell 终端，运行上面的监听命令。
3. 第一次编译完成后，打开生成的 PDF：

```text
build/sec-ch07-03.pdf
```

4. 之后保持 PDF 预览窗口打开，继续修改并保存 `sec-03.tex`。监听脚本会自动重新编译，PDF 预览会随文件更新而刷新。

对应关系是：

```text
chapters/chXX/sec-YY.tex  ->  build/sec-chXX-YY.pdf
```

例如：

```text
chapters/ch01/sec-02.tex  ->  build/sec-ch01-02.pdf
chapters/ch07/sec-03.tex  ->  build/sec-ch07-03.pdf
chapters/ch12/sec-05.tex  ->  build/sec-ch12-05.pdf
```

日常只需要打开 `build/` 中对应小节的 PDF，不需要打开根目录的 `main.pdf`。如果根目录出现 `main.aux`、`main.log`、`main.pdf`、`main.synctex.gz`、`main.toc`，说明你曾经直接编译过 `main.tex`，这些都是可删除的编译产物。

如果 VS Code 的 PDF 预览没有自动刷新，可以关闭 PDF 预览页再重新打开，或者使用 SumatraPDF 这类支持自动刷新的 PDF 阅读器。

### 6. 清理编译产物

清理 `build/` 目录：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build.ps1 -Mode clean
```

如果根目录中有直接编译产生的 `main.aux`、`main.log`、`main.out`、`main.toc`、`main.synctex.gz` 等文件，可以手动删除；它们不会影响源码。

## 十一、每次修改后的 Git 提交步骤

以下命令都在项目根目录执行：

```powershell
cd "D:\Books\quantum-mechanics-solutions"
```

### 1. 查看当前修改

```powershell
git status
```

重点检查：

- `chapters/`、`preamble/`、`main.tex`、`README.md` 等源码或文档修改是否符合预期。
- `pdf/quantum-mechanics-solutions.pdf` 是否在重新编译后发生变化。
- `build/`、`.agents/`、`.codex/`、临时 `.aux`、`.log`、`.toc` 文件不应该出现在待提交列表里。

### 2. 修改习题或项目文件

平时主要编辑对应章节的小节文件，例如：

```text
chapters/ch07/sec-03.tex
```

如果修改了导言区、宏命令、章节结构或说明文档，也可以同时提交对应文件。

### 3. 重新编译全书 PDF

提交前建议至少编译一次全书：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build.ps1
```

成功后会生成：

```text
build/shankar-solutions.pdf
pdf/quantum-mechanics-solutions.pdf
```

其中 `pdf/quantum-mechanics-solutions.pdf` 是要提交到 GitHub 的发布版 PDF。

### 4. 再次检查修改

```powershell
git status
```

如果只改了某些文件，也可以查看具体差异：

```powershell
git diff
```

如果发布版 PDF 更新了，`git diff` 不会显示 PDF 内容，这是正常的；只要 `git status` 中出现 `pdf/quantum-mechanics-solutions.pdf`，说明 Git 已经检测到 PDF 变化。

### 5. 加入暂存区

如果确认本次所有修改都要提交，可以执行：

```powershell
git add .
```

如果只想提交部分文件，使用明确路径更稳妥，例如：

```powershell
git add chapters/ch07/sec-03.tex pdf/quantum-mechanics-solutions.pdf README.md
```

### 6. 确认暂存区内容

```powershell
git status
```

此时要确认 `Changes to be committed` 下面列出的文件就是本次准备提交的内容。

也可以查看暂存区中的文本差异：

```powershell
git diff --cached
```

### 7. 创建提交

提交信息要简短说明本次修改内容，例如：

```powershell
git commit -m "Add chapter 7 oscillator solutions"
```

如果只是更新全书 PDF，可以写：

```powershell
git commit -m "Update compiled solution PDF"
```

如果同时修改源码和 PDF，可以写：

```powershell
git commit -m "Update solutions and compiled PDF"
```

### 8. 推送到 GitHub

```powershell
git push
```

如果是第一次推送当前分支，使用：

```powershell
git push -u origin main
```

本仓库已经配置了远程仓库 `origin`，正常情况下后续只需要执行 `git push`。

### 9. 完整示例

一次常见的完整流程如下：

```powershell
git status
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build.ps1
git status
git add .
git status
git commit -m "Update solutions and compiled PDF"
git push
```

如果 `git status` 中出现不想提交的文件，不要继续 `git add .`，先确认 `.gitignore` 是否需要调整，或者改用 `git add 文件路径` 只提交本次需要的文件。

## 十二、常见问题

### 找不到 `latexmk`

说明 LaTeX 发行版没有安装，或者安装目录没有加入 `PATH`。先安装 TeX Live 或 MiKTeX，然后重新打开 PowerShell 再试。

### 中文无法显示或编译失败

本项目使用 `ctexbook` 和 `xelatex`，不要改用 `pdflatex`。请确认使用的是：

```powershell
xelatex --version
```

### 单节编译提示找不到章节或小节

单节编译会读取 `structure/sections.csv`。如果命令是：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build.ps1 -Mode section -Chapter 7 -Section 3
```

就必须在 `structure/sections.csv` 中存在 `chapter=7`、`section=3` 的记录。

### 修改了章节结构后没有生效

修改 `structure/sections.csv` 后，需要重新运行初始化脚本：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-structure.ps1 -Force
```

然后再重新编译。

