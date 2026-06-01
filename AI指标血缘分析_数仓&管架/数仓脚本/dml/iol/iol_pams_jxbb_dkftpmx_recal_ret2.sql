/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_dkftpmx_recal
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;


--create partition 
--whenever sqlerror continue none ;
set serveroutput on
declare
  o_cnt number(22, 0) := 0; -- 原表数据量
  b_cnt number(22, 0) := 0; -- 备份表数据量
  v_flag number(10)   := 0; -- 判断标志
begin
	-- 判断原表中的分区并在重建后的表增加所有的分区
  for tb in (select table_name, partition_name, substr(partition_name, 3) as etl_dt
               from user_tab_partitions
              where table_name = upper('pams_jxbb_dkftpmx_recal_bak_${batch_date}')
                and substr(partition_name, 3) <> '19000101'
                and substr(partition_name, 3) >= '20250722'
				and substr(partition_name, 3) < '20250922'
            ) loop

    -- 判断分区是否存在
	  select count(1)
	    into v_flag
	    from all_tab_partitions
	   where table_name = upper('pams_jxbb_dkftpmx_recal')
	     and table_owner = 'IOL'
	     and partition_name = tb.partition_name;

	  -- 如果分区已经存在，则删除分区
	  if v_flag <> 0 then

	    execute immediate 'alter table iol.pams_jxbb_dkftpmx_recal drop partition ' || tb.partition_name;

    end if;

      execute immediate 'alter table iol.pams_jxbb_dkftpmx_recal add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt ||',''yyyymmdd''))';
	 
  end loop;
  
   dbms_output.put_line('pams_jxbb_dkftpmx_recal');
end;

/

insert /*+ append */ into ${iol_schema}.pams_jxbb_dkftpmx_recal(
    tjrq -- 统计日期
    ,khm -- 客户名
    ,khh -- 客户号
    ,khjgkhdxdh -- 开户机构考核对象代号
    ,khjgh -- 开户机构号
    ,khjgmc -- 开户机构名称
    ,ssjgkhdxdh -- 所属机构考核对象代号
    ,ssjgh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,khjlgh -- 客户经理工号
    ,khjlxm -- 客户经理名称
    ,fpbl -- 分配比例
    ,zhbs -- 账户标识
    ,xwdkbs -- 小微贷款标识
    ,jjh -- 借据号
    ,jjzt -- 借据状态
    ,dqzxll -- 当前执行利率
    ,jzll -- 基准利率
    ,fdbl -- 浮动比率
    ,fdfs -- 浮动方式
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,cpbh -- 产品编号
    ,cpejfl -- 产品二级分类
    ,cpsjfl -- 产品四级分类
    ,cpsijfl -- 产品四级分类
    ,cpzwmc -- 产品中文名称
    ,sfxw -- 是否小微
    ,qx -- 期限
    ,fkr -- 放款日
    ,dqr -- 到期日期
    ,bz -- 币种
    ,ye -- 余额
    ,yrj -- 月日均
    ,nrj -- 年日均
    ,ylx -- 月利息
    ,nlx -- 年利息
    ,ftpjg -- FTP价格
    ,dyftpzycb -- 当月FTP转移成本
    ,ljftpzycb -- 累计FTP转移成本
    ,dyftpjsy -- 当月FTP净收益
    ,ljftpjsy -- 累计FTP净收益
    ,ftplxsr -- FTP利息收入
    ,ftpzycb -- FTP转移成本
    ,ftpsy -- FTP收益
    ,lxkm -- 利息科目
    ,lxkmmc -- 利息科目名称
    ,wjfl -- 五级分类
    ,pjh -- 票据号
    ,yqxyss -- 预计信用损失
    ,fxjqzcje -- 风险加权资产金额
    ,bzdm -- 币种代码
    ,jrj -- 季日均
    ,jlx -- 季利息
    ,djftpzycb -- 当季FTP转移成本
    ,djftpjsy -- 当季FTP净收益
    ,fptx -- 分配条线
    ,txfpbl -- 条线分配比例
    ,bwbs -- 表外标识
    ,gyljrywbz -- 供应链金融业务标志
    ,recal_dt -- 重算日期
    ,ljtzysje -- 累计调整营收金额
    ,tzhljftpjsy -- 调整后累计ftp净收益
    ,ljtzfyje -- 累计调整费用金额
    ,jjljftpjsy -- 计奖累计ftp净收益
    ,dytzysje -- 月累计调整营收金额
    ,tzhdyftpjsy -- 调整后月累计FTP净收益
    ,dytzfyje -- 月累计调整费用金额
    ,jjdyftpjsy -- 计奖月累计FTP净收益
    ,xbcxdbs -- 1+N信保贷标识
    ,zcpbh -- 子产品编号
    ,zcpmc -- 子产品名称
    ,dkje -- 放款金额
    ,bjyqts -- 逾期天数
    ,dkfflb -- 贷款发放类型
    ,nsxl -- 当年收息率
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,khm -- 客户名
    ,khh -- 客户号
    ,khjgkhdxdh -- 开户机构考核对象代号
    ,khjgh -- 开户机构号
    ,khjgmc -- 开户机构名称
    ,ssjgkhdxdh -- 所属机构考核对象代号
    ,ssjgh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,khjlgh -- 客户经理工号
    ,khjlxm -- 客户经理名称
    ,fpbl -- 分配比例
    ,zhbs -- 账户标识
    ,xwdkbs -- 小微贷款标识
    ,jjh -- 借据号
    ,jjzt -- 借据状态
    ,dqzxll -- 当前执行利率
    ,jzll -- 基准利率
    ,fdbl -- 浮动比率
    ,fdfs -- 浮动方式
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,cpbh -- 产品编号
    ,cpejfl -- 产品二级分类
    ,cpsjfl -- 产品四级分类
    ,cpsijfl -- 产品四级分类
    ,cpzwmc -- 产品中文名称
    ,sfxw -- 是否小微
    ,qx -- 期限
    ,fkr -- 放款日
    ,dqr -- 到期日期
    ,bz -- 币种
    ,ye -- 余额
    ,yrj -- 月日均
    ,nrj -- 年日均
    ,ylx -- 月利息
    ,nlx -- 年利息
    ,ftpjg -- FTP价格
    ,dyftpzycb -- 当月FTP转移成本
    ,ljftpzycb -- 累计FTP转移成本
    ,dyftpjsy -- 当月FTP净收益
    ,ljftpjsy -- 累计FTP净收益
    ,ftplxsr -- FTP利息收入
    ,ftpzycb -- FTP转移成本
    ,ftpsy -- FTP收益
    ,lxkm -- 利息科目
    ,lxkmmc -- 利息科目名称
    ,wjfl -- 五级分类
    ,pjh -- 票据号
    ,yqxyss -- 预计信用损失
    ,fxjqzcje -- 风险加权资产金额
    ,bzdm -- 币种代码
    ,jrj -- 季日均
    ,jlx -- 季利息
    ,djftpzycb -- 当季FTP转移成本
    ,djftpjsy -- 当季FTP净收益
    ,fptx -- 分配条线
    ,txfpbl -- 条线分配比例
    ,bwbs -- 表外标识
    ,gyljrywbz -- 供应链金融业务标志
    ,recal_dt -- 重算日期
    ,ljtzysje -- 累计调整营收金额
    ,tzhljftpjsy -- 调整后累计ftp净收益
    ,ljtzfyje -- 累计调整费用金额
    ,jjljftpjsy -- 计奖累计ftp净收益
    ,dytzysje -- 月累计调整营收金额
    ,tzhdyftpjsy -- 调整后月累计FTP净收益
    ,dytzfyje -- 月累计调整费用金额
    ,jjdyftpjsy -- 计奖月累计FTP净收益
    ,xbcxdbs -- 1+N信保贷标识
    ,zcpbh -- 子产品编号
    ,zcpmc -- 子产品名称
	,0 as dkje -- 放款金额
    ,0 as bjyqts -- 逾期天数
    ,' ' as dkfflb -- 贷款发放类型
    ,0 as nsxl -- 当年收息率
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from pams_jxbb_dkftpmx_recal_bak_${batch_date} t1
 where t1.etl_dt >= to_date('20250722', 'yyyymmdd')
and t1.etl_dt < to_date('20250922', 'yyyymmdd');
 commit;
