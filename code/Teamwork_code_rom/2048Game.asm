.text
# ���̲��ֱ��
#####################
#  0 #  1 #  2 #  3 #
#####################
#  4 #  5 #  6 #  7 #
#####################
#  8 #  9 # 10 # 11 #
#####################
# 12 # 13 # 14 # 15 #
#####################

# Ԥ��������һ�������������������ʾ
	addi a7,zero,34
	ecall #���������
	addi a7,zero,44
	ecall #��ʾ���̲���
main_loop:
	j main_loop	#ѭ���ȴ��ж���Ӧ

#�ƶ�ע�ͽ�UP����Ч�������ԭ����ȫ��ͬ��ֱ��Ctrl+C/V����û�и�ע��
#####################################
# UP:�û�����w����Ӧ���ƵĲ���
# ʹ�üĴ�����s0,s1,s2,s3,t0,t1,t2,t3
#####################################
InteruptProgram_UP:
# ���δ���1(0,4,8,12),2(1,5,9,13),3(2,6,10,14),4(3,7,11,15)��
	addi t0,zero,0	# �׵�ַ
	addi t1,zero,16 # β��ַ
	addi t2,zero,0	# �������λ�����������λ���ϲ���������t2=1
move_up:
# ��������
	lw s0,0(t0)	#0,1,2,3
	lw s1,16(t0)#4,5,6,7
	lw s2,32(t0)#8,9,10,11
	lw s3,48(t0)#12,13,14,15
# ����ȫ0�У��ӿ�����ٶ�
	bne s0,zero,move_up_start
	bne s1,zero,move_up_start
	bne s2,zero,move_up_start
	bne s3,zero,move_up_start
	j move_up_over
move_up_start:
# ���ϲ���Ӳ�����ֻ��Ҫɨ����������
	bne s2,zero,move_up_1	#��2��ǿ�����ת
	beq s3,zero,move_up_1	#��3��Ϊ0����Ҫ��λ
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч��λ����
move_up_1:	
	bne s1,zero,move_up_2	#��1��ǿ�����ת
	beq s2,zero,move_up_2	#��2��Ϊ0����Ҫ��λ
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч��λ����
move_up_2:
	bne s0,zero,move_up_3	#��0��ǿ�����ת
	beq s1,zero,move_up_3	#��1��Ϊ0����Ҫ��λ
	addi s0,s1,0
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч��λ����
# ��ʱ���������������ڣ�����ϲ��׶�
move_up_3:
	bne s0,s1,move_up_4
	add s0,s0,s1
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч�ϲ�����
move_up_4:
	bne s1,s2,move_up_5
	beq s1,zero,move_up_6	#�˴�s1Ϊ0˵���Ѿ�������Ҫ���Ǻ����ϲ�����
	add s1,s1,s2
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч�ϲ�����
move_up_5:
	bne s2,s3,move_up_6
	beq s2,zero,move_up_6	#�˴�s2Ϊ0˵���Ѿ�������Ҫ���Ǻ����ϲ�����
	add s2,s2,s3
	addi s3,zero,0
	addi t2,zero,1	#��������Ч�ϲ�����
move_up_6:	#4������д��
	sw s0,0(t0)	#0,1,2,3
	sw s1,16(t0)#4,5,6,7
	sw s2,32(t0)#8,9,10,11
	sw s3,48(t0)#12,13,14,15
move_up_over:
	addi t0,t0,4	#׼��������һ��
	bne t0,t1,move_up	#û��β��ַ��������һ��
#������4�У����з���ǰ�Ĳ���
	addi t3,zero,1
	bne t2,t3,move_up_finish	#δ������Ч�����������������
	addi a7,zero,44
	ecall #��ʾ���̲���
	addi a7,zero,34
	ecall #���������
	addi a7,zero,44
	ecall #��ʾ���̲���
move_up_finish:
	uret	#�жϷ���

#####################################
# DOWN:�û�����s����Ӧ���ƵĲ���
# ʹ�üĴ�����s0,s1,s2,s3,t0,t1,t2,t3
#####################################
InteruptProgram_DWON:
# ���δ���1(0,4,8,12),2(1,5,9,13),3(2,6,10,14),4(3,7,11,15)��
	addi t0,zero,0	# �׵�ַ
	addi t1,zero,16 # β��ַ
	addi t2,zero,0	# �������λ�����������λ���ϲ���������t2=1
move_down:
# ��������
	lw s3,0(t0)	#12,13,14,15
	lw s2,16(t0)#8,9,10,11
	lw s1,32(t0)#4,5,6,7
	lw s0,48(t0)#0,1,2,3
# ����ȫ0�У��ӿ�����ٶ�
	bne s0,zero,move_down_start
	bne s1,zero,move_down_start
	bne s2,zero,move_down_start
	bne s3,zero,move_down_start
	j move_down_over
move_down_start:
# ���ϲ���Ӳ�����ֻ��Ҫɨ����������
	bne s2,zero,move_down_1	#��2��ǿ�����ת
	beq s3,zero,move_down_1	#��3��Ϊ0����Ҫ��λ
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч��λ����
move_down_1:	
	bne s1,zero,move_down_2	#��1��ǿ�����ת
	beq s2,zero,move_down_2	#��2��Ϊ0����Ҫ��λ
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч��λ����
move_down_2:
	bne s0,zero,move_down_3	#��0��ǿ�����ת
	beq s1,zero,move_down_3	#��1��Ϊ0����Ҫ��λ
	addi s0,s1,0
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч��λ����
# ��ʱ���������������ڣ�����ϲ��׶�
move_down_3:
	bne s0,s1,move_down_4
	add s0,s0,s1
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч�ϲ�����
move_down_4:
	bne s1,s2,move_down_5
	beq s1,zero,move_down_6	#�˴�s1Ϊ0˵���Ѿ�������Ҫ���Ǻ����ϲ�����
	add s1,s1,s2
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч�ϲ�����
move_down_5:
	bne s2,s3,move_down_6
	beq s2,zero,move_down_6	#�˴�s2Ϊ0˵���Ѿ�������Ҫ���Ǻ����ϲ�����
	add s2,s2,s3
	addi s3,zero,0
	addi t2,zero,1	#��������Ч�ϲ�����
move_down_6:	#4������д��
	sw s3,0(t0)	#12,13,14,15
	sw s2,16(t0)#8,9,10,11
	sw s1,32(t0)#4,5,6,7
	sw s0,48(t0)#0,1,2,3
move_down_over:
	addi t0,t0,4	#׼��������һ��
	bne t0,t1,move_down	#û��β��ַ��������һ��
#������4�У����з���ǰ�Ĳ���
	addi t3,zero,1
	bne t2,t3,move_down_finish	#δ������Ч�����������������
	addi a7,zero,44
	ecall #��ʾ���̲���
	addi a7,zero,34
	ecall #���������
	addi a7,zero,44
	ecall #��ʾ���̲���
move_down_finish:
	uret	#�жϷ���

#####################################
# LEFT:�û�����a����Ӧ���ƵĲ���
# ʹ�üĴ�����s0,s1,s2,s3,t0,t1,t2,t3
#####################################
InteruptProgram_LEFT:
# ���δ���1(0,1,2,3),2(4,5,6,7),3(8,9,10,11),4(12,13,14,15)��
	addi t0,zero,0	# �׵�ַ
	addi t1,zero,64 # β��ַ
	addi t2,zero,0	# �������λ�����������λ���ϲ���������t2=1
move_left:
# ��������
	lw s0,0(t0)	#0,4,8,12
	lw s1,4(t0) #1,5,9,13
	lw s2,8(t0)#2,6,10,14
	lw s3,12(t0)#3,7,11,15
# ����ȫ0�У��ӿ�����ٶ�
	bne s0,zero,move_left_start
	bne s1,zero,move_left_start
	bne s2,zero,move_left_start
	bne s3,zero,move_left_start
	j move_left_over
move_left_start:
# ���ϲ���Ӳ�����ֻ��Ҫɨ����������
	bne s2,zero,move_left_1	#��2��ǿ�����ת
	beq s3,zero,move_left_1	#��3��Ϊ0����Ҫ��λ
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч��λ����
move_left_1:	
	bne s1,zero,move_left_2	#��1��ǿ�����ת
	beq s2,zero,move_left_2	#��2��Ϊ0����Ҫ��λ
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч��λ����
move_left_2:
	bne s0,zero,move_left_3	#��0��ǿ�����ת
	beq s1,zero,move_left_3	#��1��Ϊ0����Ҫ��λ
	addi s0,s1,0
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч��λ����
# ��ʱ���������������ڣ�����ϲ��׶�
move_left_3:
	bne s0,s1,move_left_4
	add s0,s0,s1
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч�ϲ�����
move_left_4:
	bne s1,s2,move_left_5
	beq s1,zero,move_left_6	#�˴�s1Ϊ0˵���Ѿ�������Ҫ���Ǻ����ϲ�����
	add s1,s1,s2
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч�ϲ�����
move_left_5:
	bne s2,s3,move_left_6
	beq s2,zero,move_left_6	#�˴�s2Ϊ0˵���Ѿ�������Ҫ���Ǻ����ϲ�����
	add s2,s2,s3
	addi s3,zero,0
	addi t2,zero,1	#��������Ч�ϲ�����
move_left_6:	#4������д��
	sw s0,0(t0)	#0,4,8,12
	sw s1,4(t0) #1,5,9,13
	sw s2,8(t0)#2,6,10,14
	sw s3,12(t0)#3,7,11,15
move_left_over:
	addi t0,t0,16	#׼��������һ��
	bne t0,t1,move_left	#û��β��ַ��������һ��
#������4�У����з���ǰ�Ĳ���
	addi t3,zero,1
	bne t2,t3,move_left_finish	#δ������Ч�����������������
	addi a7,zero,44
	ecall #��ʾ���̲���
	addi a7,zero,34
	ecall #���������
	addi a7,zero,44
	ecall #��ʾ���̲���
move_left_finish:
	uret	#�жϷ���

#####################################
# RIGHT:�û�����a����Ӧ���ƵĲ���
# ʹ�üĴ�����s0,s1,s2,s3,t0,t1,t2,t3
#####################################
InteruptProgram_RIGHT:
# ���δ���1(0,1,2,3),2(4,5,6,7),3(8,9,10,11),4(12,13,14,15)��
	addi t0,zero,0	# �׵�ַ
	addi t1,zero,64 # β��ַ
	addi t2,zero,0	# �������λ�����������λ���ϲ���������t2=1
move_right:
# ��������
	lw s3,0(t0)	#3,7,11,15
	lw s2,4(t0)	#2,6,10,14
	lw s1,8(t0)#1,5,9,13
	lw s0,12(t0)#0,4,8,12
# ����ȫ0�У��ӿ�����ٶ�
	bne s0,zero,move_right_start
	bne s1,zero,move_right_start
	bne s2,zero,move_right_start
	bne s3,zero,move_right_start
	j move_right_over
move_right_start:
# ���ϲ���Ӳ�����ֻ��Ҫɨ����������
	bne s2,zero,move_right_1	#��2��ǿ�����ת
	beq s3,zero,move_right_1	#��3��Ϊ0����Ҫ��λ
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч��λ����
move_right_1:	
	bne s1,zero,move_right_2	#��1��ǿ�����ת
	beq s2,zero,move_right_2	#��2��Ϊ0����Ҫ��λ
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч��λ����
move_right_2:
	bne s0,zero,move_right_3	#��0��ǿ�����ת
	beq s1,zero,move_right_3	#��1��Ϊ0����Ҫ��λ
	addi s0,s1,0
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч��λ����
# ��ʱ���������������ڣ�����ϲ��׶�
move_right_3:
	bne s0,s1,move_right_4
	add s0,s0,s1
	addi s1,s2,0
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч�ϲ�����
move_right_4:
	bne s1,s2,move_right_5
	beq s1,zero,move_right_6	#�˴�s1Ϊ0˵���Ѿ�������Ҫ���Ǻ����ϲ�����
	add s1,s1,s2
	addi s2,s3,0
	addi s3,zero,0
	addi t2,zero,1	#��������Ч�ϲ�����
move_right_5:
	bne s2,s3,move_right_6
	beq s2,zero,move_right_6	#�˴�s2Ϊ0˵���Ѿ�������Ҫ���Ǻ����ϲ�����
	add s2,s2,s3
	addi s3,zero,0
	addi t2,zero,1	#��������Ч�ϲ�����
move_right_6:	#4������д��
	sw s3,0(t0)	#3,7,11,15
	sw s2,4(t0)	#2,6,10,14
	sw s1,8(t0)#1,5,9,13
	sw s0,12(t0)#0,4,8,12
move_right_over:
	addi t0,t0,16	#׼��������һ��
	bne t0,t1,move_right	#û��β��ַ��������һ��
#������4�У����з���ǰ�Ĳ���
	addi t3,zero,1
	bne t2,t3,move_right_finish	#δ������Ч�����������������
	addi a7,zero,44
	ecall #��ʾ���̲���
	addi a7,zero,34
	ecall #���������
	addi a7,zero,44
	ecall #��ʾ���̲���
move_right_finish:
	uret	#�жϷ���