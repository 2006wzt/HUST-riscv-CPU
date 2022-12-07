.text
# 棋盘布局编号
#####################
#  0 #  1 #  2 #  3 #
#####################
#  4 #  5 #  6 #  7 #
#####################
#  8 #  9 # 10 # 11 #
#####################
# 12 # 13 # 14 # 15 #
#####################

# 预处理：生成一个随机数并在棋盘中显示
	addi a7,zero,34
	ecall #生成随机数
	addi a7,zero,44
	ecall #显示棋盘布局
main_loop:
	j main_loop	#循环等待中断响应

#移动注释仅UP段有效，后面的原理完全相同，直接Ctrl+C/V所以没有改注释
#####################################
# UP:用户按下w，响应上移的操作
# 使用寄存器：s0,s1,s2,s3,t0,t1,t2,t3
#####################################
InteruptProgram_UP:
# 依次处理1(0,4,8,12),2(1,5,9,13),3(2,6,10,14),4(3,7,11,15)列
	addi t0,zero,0	# 首地址
	addi t1,zero,16 # 尾地址
	addi t2,zero,0	# 操作标记位，如果存在移位、合并操作，则t2=1
move_up:
# 载入数字
	lw s0,0(t0)	#0,1,2,3
	lw s1,16(t0)#4,5,6,7
	lw s2,32(t0)#8,9,10,11
	lw s3,48(t0)#12,13,14,15
# 处理全0列，加快程序速度
	bne s0,zero,move_up_start
	bne s1,zero,move_up_start
	bne s2,zero,move_up_start
	bne s3,zero,move_up_start
	j move_up_over
move_up_start:
# 最上层格子不动，只需要扫描下面三行
	bne s2,zero,move_up_1	#第2格非空则跳转
	beq s3,zero,move_up_1	#第3格为0不需要移位
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效移位操作
move_up_1:	
	bne s1,zero,move_up_2	#第1格非空则跳转
	beq s2,zero,move_up_2	#第2格为0不需要移位
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效移位操作
move_up_2:
	bne s0,zero,move_up_3	#第0格非空则跳转
	beq s1,zero,move_up_3	#第1格为0不需要移位
	addi s0,s1,0
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效移位操作
# 此时该列所有数都相邻，进入合并阶段
move_up_3:
	bne s0,s1,move_up_4
	add s0,s0,s1
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效合并操作
move_up_4:
	bne s1,s2,move_up_5
	beq s1,zero,move_up_6	#此处s1为0说明已经不再需要考虑后续合并操作
	add s1,s1,s2
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效合并操作
move_up_5:
	bne s2,s3,move_up_6
	beq s2,zero,move_up_6	#此处s2为0说明已经不再需要考虑后续合并操作
	add s2,s2,s3
	addi s3,zero,0
	addi t2,zero,1	#进行了有效合并操作
move_up_6:	#4个数据写回
	sw s0,0(t0)	#0,1,2,3
	sw s1,16(t0)#4,5,6,7
	sw s2,32(t0)#8,9,10,11
	sw s3,48(t0)#12,13,14,15
move_up_over:
	addi t0,t0,4	#准备处理下一列
	bne t0,t1,move_up	#没到尾地址，处理下一列
#处理完4列，进行返回前的操作
	addi t3,zero,1
	bne t2,t3,move_up_finish	#未进行有效操作，不生成随机数
	addi a7,zero,44
	ecall #显示棋盘布局
	addi a7,zero,34
	ecall #生成随机数
	addi a7,zero,44
	ecall #显示棋盘布局
move_up_finish:
	uret	#中断返回

#####################################
# DOWN:用户按下s，响应下移的操作
# 使用寄存器：s0,s1,s2,s3,t0,t1,t2,t3
#####################################
InteruptProgram_DWON:
# 依次处理1(0,4,8,12),2(1,5,9,13),3(2,6,10,14),4(3,7,11,15)列
	addi t0,zero,0	# 首地址
	addi t1,zero,16 # 尾地址
	addi t2,zero,0	# 操作标记位，如果存在移位、合并操作，则t2=1
move_down:
# 载入数字
	lw s3,0(t0)	#12,13,14,15
	lw s2,16(t0)#8,9,10,11
	lw s1,32(t0)#4,5,6,7
	lw s0,48(t0)#0,1,2,3
# 处理全0列，加快程序速度
	bne s0,zero,move_down_start
	bne s1,zero,move_down_start
	bne s2,zero,move_down_start
	bne s3,zero,move_down_start
	j move_down_over
move_down_start:
# 最上层格子不动，只需要扫描下面三行
	bne s2,zero,move_down_1	#第2格非空则跳转
	beq s3,zero,move_down_1	#第3格为0不需要移位
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效移位操作
move_down_1:	
	bne s1,zero,move_down_2	#第1格非空则跳转
	beq s2,zero,move_down_2	#第2格为0不需要移位
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效移位操作
move_down_2:
	bne s0,zero,move_down_3	#第0格非空则跳转
	beq s1,zero,move_down_3	#第1格为0不需要移位
	addi s0,s1,0
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效移位操作
# 此时该列所有数都相邻，进入合并阶段
move_down_3:
	bne s0,s1,move_down_4
	add s0,s0,s1
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效合并操作
move_down_4:
	bne s1,s2,move_down_5
	beq s1,zero,move_down_6	#此处s1为0说明已经不再需要考虑后续合并操作
	add s1,s1,s2
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效合并操作
move_down_5:
	bne s2,s3,move_down_6
	beq s2,zero,move_down_6	#此处s2为0说明已经不再需要考虑后续合并操作
	add s2,s2,s3
	addi s3,zero,0
	addi t2,zero,1	#进行了有效合并操作
move_down_6:	#4个数据写回
	sw s3,0(t0)	#12,13,14,15
	sw s2,16(t0)#8,9,10,11
	sw s1,32(t0)#4,5,6,7
	sw s0,48(t0)#0,1,2,3
move_down_over:
	addi t0,t0,4	#准备处理下一列
	bne t0,t1,move_down	#没到尾地址，处理下一列
#处理完4列，进行返回前的操作
	addi t3,zero,1
	bne t2,t3,move_down_finish	#未进行有效操作，不生成随机数
	addi a7,zero,44
	ecall #显示棋盘布局
	addi a7,zero,34
	ecall #生成随机数
	addi a7,zero,44
	ecall #显示棋盘布局
move_down_finish:
	uret	#中断返回

#####################################
# LEFT:用户按下a，响应左移的操作
# 使用寄存器：s0,s1,s2,s3,t0,t1,t2,t3
#####################################
InteruptProgram_LEFT:
# 依次处理1(0,1,2,3),2(4,5,6,7),3(8,9,10,11),4(12,13,14,15)行
	addi t0,zero,0	# 首地址
	addi t1,zero,64 # 尾地址
	addi t2,zero,0	# 操作标记位，如果存在移位、合并操作，则t2=1
move_left:
# 载入数字
	lw s0,0(t0)	#0,4,8,12
	lw s1,4(t0) #1,5,9,13
	lw s2,8(t0)#2,6,10,14
	lw s3,12(t0)#3,7,11,15
# 处理全0行，加快程序速度
	bne s0,zero,move_left_start
	bne s1,zero,move_left_start
	bne s2,zero,move_left_start
	bne s3,zero,move_left_start
	j move_left_over
move_left_start:
# 最上层格子不动，只需要扫描下面三行
	bne s2,zero,move_left_1	#第2格非空则跳转
	beq s3,zero,move_left_1	#第3格为0不需要移位
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效移位操作
move_left_1:	
	bne s1,zero,move_left_2	#第1格非空则跳转
	beq s2,zero,move_left_2	#第2格为0不需要移位
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效移位操作
move_left_2:
	bne s0,zero,move_left_3	#第0格非空则跳转
	beq s1,zero,move_left_3	#第1格为0不需要移位
	addi s0,s1,0
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效移位操作
# 此时该列所有数都相邻，进入合并阶段
move_left_3:
	bne s0,s1,move_left_4
	add s0,s0,s1
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效合并操作
move_left_4:
	bne s1,s2,move_left_5
	beq s1,zero,move_left_6	#此处s1为0说明已经不再需要考虑后续合并操作
	add s1,s1,s2
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效合并操作
move_left_5:
	bne s2,s3,move_left_6
	beq s2,zero,move_left_6	#此处s2为0说明已经不再需要考虑后续合并操作
	add s2,s2,s3
	addi s3,zero,0
	addi t2,zero,1	#进行了有效合并操作
move_left_6:	#4个数据写回
	sw s0,0(t0)	#0,4,8,12
	sw s1,4(t0) #1,5,9,13
	sw s2,8(t0)#2,6,10,14
	sw s3,12(t0)#3,7,11,15
move_left_over:
	addi t0,t0,16	#准备处理下一列
	bne t0,t1,move_left	#没到尾地址，处理下一列
#处理完4列，进行返回前的操作
	addi t3,zero,1
	bne t2,t3,move_left_finish	#未进行有效操作，不生成随机数
	addi a7,zero,44
	ecall #显示棋盘布局
	addi a7,zero,34
	ecall #生成随机数
	addi a7,zero,44
	ecall #显示棋盘布局
move_left_finish:
	uret	#中断返回

#####################################
# RIGHT:用户按下a，响应左移的操作
# 使用寄存器：s0,s1,s2,s3,t0,t1,t2,t3
#####################################
InteruptProgram_RIGHT:
# 依次处理1(0,1,2,3),2(4,5,6,7),3(8,9,10,11),4(12,13,14,15)行
	addi t0,zero,0	# 首地址
	addi t1,zero,64 # 尾地址
	addi t2,zero,0	# 操作标记位，如果存在移位、合并操作，则t2=1
move_right:
# 载入数字
	lw s3,0(t0)	#3,7,11,15
	lw s2,4(t0)	#2,6,10,14
	lw s1,8(t0)#1,5,9,13
	lw s0,12(t0)#0,4,8,12
# 处理全0行，加快程序速度
	bne s0,zero,move_right_start
	bne s1,zero,move_right_start
	bne s2,zero,move_right_start
	bne s3,zero,move_right_start
	j move_right_over
move_right_start:
# 最上层格子不动，只需要扫描下面三行
	bne s2,zero,move_right_1	#第2格非空则跳转
	beq s3,zero,move_right_1	#第3格为0不需要移位
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效移位操作
move_right_1:	
	bne s1,zero,move_right_2	#第1格非空则跳转
	beq s2,zero,move_right_2	#第2格为0不需要移位
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效移位操作
move_right_2:
	bne s0,zero,move_right_3	#第0格非空则跳转
	beq s1,zero,move_right_3	#第1格为0不需要移位
	addi s0,s1,0
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效移位操作
# 此时该列所有数都相邻，进入合并阶段
move_right_3:
	bne s0,s1,move_right_4
	add s0,s0,s1
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效合并操作
move_right_4:
	bne s1,s2,move_right_5
	beq s1,zero,move_right_6	#此处s1为0说明已经不再需要考虑后续合并操作
	add s1,s1,s2
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#进行了有效合并操作
move_right_5:
	bne s2,s3,move_right_6
	beq s2,zero,move_right_6	#此处s2为0说明已经不再需要考虑后续合并操作
	add s2,s2,s3
	addi s3,zero,0
	addi t2,zero,1	#进行了有效合并操作
move_right_6:	#4个数据写回
	sw s3,0(t0)	#3,7,11,15
	sw s2,4(t0)	#2,6,10,14
	sw s1,8(t0)#1,5,9,13
	sw s0,12(t0)#0,4,8,12
move_right_over:
	addi t0,t0,16	#准备处理下一列
	bne t0,t1,move_right	#没到尾地址，处理下一列
#处理完4列，进行返回前的操作
	addi t3,zero,1
	bne t2,t3,move_right_finish	#未进行有效操作，不生成随机数
	addi a7,zero,44
	ecall #显示棋盘布局
	addi a7,zero,34
	ecall #生成随机数
	addi a7,zero,44
	ecall #显示棋盘布局
move_right_finish:
	uret	#中断返回