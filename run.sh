#安装好FPGA板卡后，继续进行如下步骤：
#(0)bwa的index处理
#在命令行中进入Pipeline1/software/bwa-occ64文件夹中，然后执行：
bwa index -a bwtsw ./../library/hg19/genome.fa
bwa index -a bwtsw ./../library/all/ virus_taxid_all.sed.fasta
#这两步耗时较久，建议采用12G以上内存电脑进行处理
#	(1) 加载驱动
#在命令行中执行：
cd  Pipeline1/facedrv
./face-init
./face-reset
#(2)建立服务器
cd  Pipeline1/casmap  
./cm_serve
#注意：这里要保证服务器的开启
#(3)加载xinlinx V7开发板参考序列<ref>
#（打开另一个命令行，然后执行：）
gnome-terminal
cd  Pipeline1/casmap
./cm_load localhost Pipeline1/library/hg19/genome.fa
# (示例位置：Pipeline1/library/hg19/genome.fa)
#(4)进行比对，这里执行：
./cm_aln   localhost   read1.fastq 
#(示例位置： Pipeline1/main/a_fastq_change/V6_1.fastq )
#此步骤生成  read1.fastq.aln 
#(示例位置： Pipeline1/main/a_fastq_change/V6_1.fastq.aln ) 
./cm_aln   localhost   read2.fastq
#(示例位置 Pipeline1/main/a_fastq_change/V6_2.fastq)
#此步骤生成V6_2.fastq.aln
#(示例位置Pipeline1/main/a_fastq_change/V6_2.fastq.aln)
#(5)转换坐标，这里执行：
./cm_aln2pos  Pipeline1/library/hg19/genome.fa  read1.fastq.aln  
#(示例位置1：Pipeline1/library/hg19/genome.fa)
#(示例位置2：Pipeline1/main/a_fastq_change/V6_1.fastq.aln)
#此步骤生成： read1.fastq.aln.pos   
#(示例位置： Pipeline1/main/a_fastq_change/V6_1.fastq.aln.pos ) 
./cm_aln2pos  Pipeline1/library/hg19/genome.fa  read2.fastq.aln
#此步骤生成： read2.fastq.aln.pos   
#(示例位置： Pipeline1/main/a_fastq_change/V6_2.fastq.aln.pos ) 
#注意：内存不够情况需要加内存，若是比对人的数据最低32G内存，推荐48G

#(6)生成sam文件
./cm_pos2sampe -f V6.sam -t 4 Pipeline1/library/hg19/genome.fa  V6_1.fastq.aln.pos V6_2.fastq.aln.pos V6_1.fastq V6_2.fastq
