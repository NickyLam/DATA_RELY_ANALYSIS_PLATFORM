/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_yblxdftpmx
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

declare
     v_flag   number(10) :=0;
          
begin
	for tb in (select partition_name,table_name,substr(partition_name,3) as etl_dt 
	             from user_tab_partitions 
	            where table_name = upper('pams_jxbb_yblxdftpmx_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('pams_jxbb_yblxdftpmx')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table pams_jxbb_yblxdftpmx drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table pams_jxbb_yblxdftpmx add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';
end loop;
end;
/
insert /*+ append */ into ${iol_schema}.pams_jxbb_yblxdftpmx(
    tjrq -- 统计日期
    ,jrgjbh -- 金融工具编号
    ,khmc -- 客户名称
    ,khh -- 客户号
    ,jydf -- 交易对方
    ,jyr -- 交易日
    ,dqr -- 到期日
    ,bzdm -- 币种代码
    ,bz -- 币种
    ,tzje -- 投资金额
    ,qmye -- 期末余额
    ,dyrj -- 当月日均
    ,ljrj -- 累计日均
    ,yqsyl -- 预期收益率
    ,ftpjg -- FTP价格
    ,jxfs -- 付息频率
    ,tzlx -- 投资类型
    ,ssfhhh -- 财务机构
    ,ssfh -- 财务机构名称
    ,dylxsr -- 当月利息收入
    ,dyftpzycb -- 当月FTP转移成本
    ,dyftpjsr -- 当月FTP净收入
    ,ljlxsr -- 累计利息收入
    ,ljftpzycb -- 累计FTP转移成本
    ,ljftpjsr -- 累计FTP净收入
    ,ssjgdh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,khjlxm -- 客户经理姓名
    ,khjlgh -- 客户经理工号
    ,fpbl -- 分配比例
    ,fphtzje -- 分配后投资金额
    ,fphqmye -- 分配后期末余额
    ,fphdyrj -- 分配后当月日均
    ,fphljrj -- 分配后累计日均
    ,fphdylxsr -- 分配后当月利息收入
    ,fphdyftpzycb -- 分配后当月FTP转移成本
    ,fphdyftpjsr -- 分配后当月FTP净收入
    ,fphljlxsr -- 分配后累计利息收入
    ,fphljftpzycb -- 分配后累计FTP转移成本
    ,fphljftpjsr -- 分配后累计FTP净收入
    ,wjfl -- 五级分类
    ,yqxyss -- 逾期信用损失
    ,fxjqzcje -- 风险加权资产金额
    ,ljtzysje -- 累计调整营收金额
    ,tzhljftpjsy -- 调整后累计ftp净收益
    ,ljtzfyje -- 累计调整费用金额
    ,jjljftpjsy -- 计奖累计ftp净收益
    ,fphljtzysje -- 分配后累计调整营收金额
    ,fphtzhljftpjsy -- 分配后调整后累计ftp净收益
    ,fphljtzfyje -- 分配后累计调整费用金额
    ,fphjjljftpjsy -- 分配后计奖累计ftp净收益
    ,dytzysje -- 月累计调整营收金额
    ,tzhdyftpjsy -- 调整后月累计FTP净收益
    ,dytzfyje -- 月累计调整费用金额
    ,jjdyftpjsy -- 计奖月累计FTP净收益
    ,fphdytzysje -- 分配后月累计调整营收金额
    ,fphtzhdyftpjsy -- 分配后调整后月累计FTP净收益
    ,fphdytzfyje -- 分配后月累计调整费用金额
    ,fphjjdyftpjsy -- 分配后计奖月累计FTP净收益
    ,fphdnmmsy -- 分配后当年买卖损益
    ,fphdngyjzbd -- 分配后当年公允价值变动
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jrgjbh -- 金融工具编号
    ,khmc -- 客户名称
    ,khh -- 客户号
    ,jydf -- 交易对方
    ,jyr -- 交易日
    ,dqr -- 到期日
    ,bzdm -- 币种代码
    ,bz -- 币种
    ,tzje -- 投资金额
    ,qmye -- 期末余额
    ,dyrj -- 当月日均
    ,ljrj -- 累计日均
    ,yqsyl -- 预期收益率
    ,ftpjg -- FTP价格
    ,jxfs -- 付息频率
    ,tzlx -- 投资类型
    ,ssfhhh -- 财务机构
    ,ssfh -- 财务机构名称
    ,dylxsr -- 当月利息收入
    ,dyftpzycb -- 当月FTP转移成本
    ,dyftpjsr -- 当月FTP净收入
    ,ljlxsr -- 累计利息收入
    ,ljftpzycb -- 累计FTP转移成本
    ,ljftpjsr -- 累计FTP净收入
    ,ssjgdh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,khjlxm -- 客户经理姓名
    ,khjlgh -- 客户经理工号
    ,fpbl -- 分配比例
    ,fphtzje -- 分配后投资金额
    ,fphqmye -- 分配后期末余额
    ,fphdyrj -- 分配后当月日均
    ,fphljrj -- 分配后累计日均
    ,fphdylxsr -- 分配后当月利息收入
    ,fphdyftpzycb -- 分配后当月FTP转移成本
    ,fphdyftpjsr -- 分配后当月FTP净收入
    ,fphljlxsr -- 分配后累计利息收入
    ,fphljftpzycb -- 分配后累计FTP转移成本
    ,fphljftpjsr -- 分配后累计FTP净收入
    ,wjfl -- 五级分类
    ,yqxyss -- 逾期信用损失
    ,fxjqzcje -- 风险加权资产金额
    ,ljtzysje -- 累计调整营收金额
    ,tzhljftpjsy -- 调整后累计ftp净收益
    ,ljtzfyje -- 累计调整费用金额
    ,jjljftpjsy -- 计奖累计ftp净收益
    ,fphljtzysje -- 分配后累计调整营收金额
    ,fphtzhljftpjsy -- 分配后调整后累计ftp净收益
    ,fphljtzfyje -- 分配后累计调整费用金额
    ,fphjjljftpjsy -- 分配后计奖累计ftp净收益
    ,dytzysje -- 月累计调整营收金额
    ,tzhdyftpjsy -- 调整后月累计FTP净收益
    ,dytzfyje -- 月累计调整费用金额
    ,jjdyftpjsy -- 计奖月累计FTP净收益
    ,fphdytzysje -- 分配后月累计调整营收金额
    ,fphtzhdyftpjsy -- 分配后调整后月累计FTP净收益
    ,fphdytzfyje -- 分配后月累计调整费用金额
    ,fphjjdyftpjsy -- 分配后计奖月累计FTP净收益
    ,0 as fphdnmmsy -- 分配后当年买卖损益
    ,0 as fphdngyjzbd -- 分配后当年公允价值变动
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
from pams_jxbb_yblxdftpmx_bak${batch_date};

commit;
