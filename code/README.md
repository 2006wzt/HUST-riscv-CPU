# 项目源码

- cpu-riscv：cpu21-riscv.circ、cs3410.jar、riscv-probe.jar、硬布线控制器表达式自动生成、Teamwork_code_rom

其中 `cpu21-riscv.circ` 包含的内容如下：

> ① RISC-V单周期CPU：支持24条基本指令，ccab（SRL，SLTIU，SB，BLT）
>
> ② 理想流水线
>
> ③ 气泡流水线
>
> ④ 重定向流水线
>
> ⑤ 单机中断
>
> ⑥ 多级中断
>
> ⑦ 流水终端
>
> ⑧ 动态分支预测
>
> ⑨ 团队任务：基于单级中断的2048游戏

- `Teamwork_code_rom` 包含的内容如下：

> ① 2048游戏riscv源码
>
> ② LED译码器ROM存储内容

- Verilog_FPGA：verilog、constraint_file

其中 `verilog` 包含的内容如下：

> ① CPU：单周期CPU顶层模块
>
> ② Memory：相关存储器，MEM、RegFile、register、ROM
>
> ③ Mux：多路选择器和译码器，mux2、mux4、mux32、decoder2_4
>
> ④ Control：控制器，arithmetic_controller、control_signal_controller、hard_wire_controller
>
> ⑤ Display：数码管显示和计数器，BinToBCD、counter、counter_32、decoder3_8、display_sel、divider、FPGADigit、pattern
>
> ⑥ Extend：位扩展器，extend_0，extend_sign
>
> ⑦ Shift：移位器，ari_shifter_right、log_shifter_left、log_shifter_right
>
> ⑧ ALU：运算器

`constraint_file.xdc` 为Vivado中用到的约束文件
