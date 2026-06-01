/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_lxdftpmx_recal
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_lxdftpmx_recal_ex purge;
alter table ${iol_schema}.pams_jxbb_lxdftpmx_recal add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_jxbb_lxdftpmx_recal truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxbb_lxdftpmx_recal_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_lxdftpmx_recal where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxbb_lxdftpmx_recal_ex(
    tjrq -- 统计日期
    ,jrgjbh -- 金融工具编号
    ,khmc -- 客户名称
    ,khh -- 客户号
    ,jydf -- 交易对手分类描述
    ,jyr -- 交易日期
    ,dqr -- 到期日期
    ,bzdm -- 币种代码
    ,bz -- 币种
    ,tzje -- 交易金额
    ,qmye -- 当期余额
    ,dyrj -- 当月日均
    ,ljrj -- 累计日均
    ,yqsyl -- 票面利率
    ,ftpjg -- FTP价格
    ,jxfs -- 计息方式
    ,tzlx -- 资产类型名称
    ,ssfhhh -- 所属机构编号
    ,ssfh -- 所属分行
    ,dylxsr -- 当月利息收入
    ,dyftpzycb -- 当月FTP转移成本
    ,dyftpjsr -- 当月FTP季收入
    ,ljlxsr -- 累计利息收入
    ,ljftpzycb -- 累计FTP转移成本
    ,ljftpjsr -- 累计FTP季收入
    ,ssjgdh -- 所属机构代号
    ,ssjgmc -- 所属机构名称
    ,khjlxm -- 客户经理名称
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
    ,yqxyss -- 预计信用损失
    ,fxjqzcje -- 风险加权资产金额
    ,xgfxjqzcje -- 新规风险加权资产金额
    ,cpbh -- 产品编号
    ,recal_dt -- 重算日期
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
    ,jydf -- 交易对手分类描述
    ,jyr -- 交易日期
    ,dqr -- 到期日期
    ,bzdm -- 币种代码
    ,bz -- 币种
    ,tzje -- 交易金额
    ,qmye -- 当期余额
    ,dyrj -- 当月日均
    ,ljrj -- 累计日均
    ,yqsyl -- 票面利率
    ,ftpjg -- FTP价格
    ,jxfs -- 计息方式
    ,tzlx -- 资产类型名称
    ,ssfhhh -- 所属机构编号
    ,ssfh -- 所属分行
    ,dylxsr -- 当月利息收入
    ,dyftpzycb -- 当月FTP转移成本
    ,dyftpjsr -- 当月FTP季收入
    ,ljlxsr -- 累计利息收入
    ,ljftpzycb -- 累计FTP转移成本
    ,ljftpjsr -- 累计FTP季收入
    ,ssjgdh -- 所属机构代号
    ,ssjgmc -- 所属机构名称
    ,khjlxm -- 客户经理名称
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
    ,yqxyss -- 预计信用损失
    ,fxjqzcje -- 风险加权资产金额
    ,xgfxjqzcje -- 新规风险加权资产金额
    ,cpbh -- 产品编号
    ,recal_dt -- 重算日期
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
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_lxdftpmx_recal
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxbb_lxdftpmx_recal exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_lxdftpmx_recal_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_lxdftpmx_recal to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxbb_lxdftpmx_recal_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_lxdftpmx_recal',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);