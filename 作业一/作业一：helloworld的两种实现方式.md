# 第一次作业：Hello World

**学号**：2252042

**姓名**：周政宇

**课程**： 汇编语言

**日期**： 2024/9/22

---

## 0. 作业要求

本次作业主要实现一个简单的`Hello World`程序。任务一是通过传统的源代码编写、汇编、链接，并通过 `debug` 工具反汇编来查看机器码与源代码的关系。任务二是另类方式，直接通过 `debug` 工具向内存中写入代码和数据，然后执行程序输出`Hello world`。

------

## 1. 环境配置

### 安装插件

- **MASM/TASM 插件**：用于支持 MASM 汇编代码的编写、语法高亮、自动补全等功能。
- **vscode-dosbox 插件**：集成了 DOSBox 模拟器，可以在 VSCode 中直接运行 DOS 程序。

### 设置插件

- 进入 **MASM/TASM** 插件的**扩展设置**。
- 选择 **MASM** 作为汇编器。
- 将 DOSBox 配置为 `dosbox-x`。

### 验证配置

打开`.asm`文件，工作台空白处右键，选择`运行当前程序(汇编+链接+运行)`，即可自动运行。

## 2. 方法一：传统方式

### 源代码

```assembly
STKSEG SEGMENT STACK
    DW 32 DUP(0)
STKSEG ENDS

DATASEG SEGMENT
    MSG DB "Hello World$"
DATASEG ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG, DS:DATASEG
MAIN PROC FAR
    MOV AX,DATASEG   ; 加载数据段的地址到AX寄存器
    MOV DS,AX        ; 将AX的值赋给DS寄存器
    MOV AH,9         ; 调用DOS中断功能9，显示字符串
    MOV DX,OFFSET MSG; 加载字符串的偏移地址到DX寄存器
    INT 21H          ; 中断21H，显示字符串
    MOV AX,4C00H     ; 退出程序
    INT 21H
MAIN ENDP
CODESEG ENDS
    END MAIN
```

该汇编代码设置了一个包含消息 "Hello World$" 的数据段，并使用 DOS 中断功能21H显示该消息，最后通过 4C00H 退出程序。

### 汇编代码

命令：

```bash
masm D:\TEST.ASM; >>C:\32837.LOG
```

此命令将源代码汇编为目标文件。使用 `masm` 工具读取 `TEST.ASM` 文件并生成机器码。

### 链接代码

命令：

```bash
link D:\TEST; >>C:\32837.LOG
```

此步骤将目标文件链接为可执行文件，能够在DOS下直接运行。

### 运行程序

运行程序后，输出字符串“Hello World”。

![hello](..\assets\hello.png)

### 使用 Debug 工具反汇编

使用 `debug` 工具反汇编可执行文件，命令如下：

```bash
debug test.exe
-u
```

反汇编后的指令如下：

![debug-u](..\assets\debug-u.png)

此反汇编代码展示了机器码与源代码的对应关系，每条指令的机器码与汇编指令一一对应。

---

## 3. 方法二：直接写入内存

在该方法中，我们使用 `debug` 工具直接将字符串数据和机器码写入内存，然后通过修改寄存器来执行程序。

### A）写入数据到内存

字符串 "Hello World$" 的 ASCII 码为：

```
48 65 6C 6C 6F 20 57 6F 72 6C 64 24
```

使用以下命令，将该字符串写入内存地址 `076A:0000`：

```bash
-e 076A:0000 00 48 00 65 00 6C 00 6C 00 6F 00 24
```

### B）写入代码到内存

以下是“Hello World”程序的机器码：

```
B8 6B 07 BE D8 00 B4 09 CD 21 B8 00 4C CD 21
```

使用以下命令，将代码写入内存地址 `076B:0000`：

```bash
-e 076B:0000 B8 6B 07 BE D8 00 B4 09 CD 21 B8 00 4C CD 21
```

### C）修改寄存器并执行

```bash
-g
```

执行该命令后，程序输出“Hello World”。

![直接修改内存](..\assets\直接修改内存.png)

---

## 4. 结论

两种方法均成功输出“Hello World”字符串。第一种传统方式通过编写源代码、汇编、链接，体现了标准的程序开发流程。第二种方法则通过直接操作内存和寄存器，展示了更底层的程序执行方式。两种方式各有优势，第一种方法结构清晰，适合软件开发；第二种方法展示了汇编语言与内存和CPU直接交互的细节。通过这次作业，我加深了对低级编程和系统架构的理解。
