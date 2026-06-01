/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_pjcbsyfxmx_recal
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
drop table ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal_ex purge;
alter table ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal_ex(
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,fpjs -- 分配角色
    ,zlbl -- 认领比例
    ,bz -- 币种
    ,hydh -- 行员代号
    ,hymc -- 行员名称
    ,gsjgdh -- 归属机构代号
    ,gsjgmc -- 归属机构名称
    ,zqdm -- 债券代码
    ,zqmc -- 债券名称
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,hyme -- 行员面额
    ,hymeylj -- 行员面额月累计
    ,hymenlj -- 行员面额年累计
    ,hysybj -- 行员剩余本金
    ,hysybjylj -- 行员剩余本金月累计
    ,hysybjnlj -- 行员剩余本金年累计
    ,hypjcb -- 行员平均成本
    ,hypjcbylj -- 行员平均成本月累计
    ,hypjcbnlj -- 行员平均成本年累计
    ,hyzytjj -- 行员折溢摊净价
    ,hyzytjjylj -- 行员折溢摊净价月累计
    ,hyzytjjnlj -- 行员折溢摊净价年累计
    ,hyyjlx -- 行员应计利息
    ,hyyjlxylj -- 行员应计利息月累计
    ,hyyjlxnlj -- 行员应计利息年累计
    ,zcfzfl -- 资产负债分类
    ,zqdmmc -- 债券代码名称
    ,xzrq -- 修正久期
    ,dv01 -- DV01
    ,tzid -- 投组id
    ,jytzmc -- 交易投组名称
    ,tzsfl -- 投组三分类
    ,zhid -- 账户ID
    ,zhdm -- 账户代码
    ,zhmc -- 账户名称
    ,khjg -- 部门机构
    ,bzcp -- 标准产品
    ,dqsyl -- 到期收益率
    ,dcq -- 待偿期
    ,zqlx -- 债券类型
    ,hylxsr -- 行员利息收入
    ,hylxsrylj -- 行员利息收入月累计
    ,hylxsrnlj -- 行员利息收入年累计
    ,hyzyt -- 行员折溢摊
    ,hyzytylj -- 行员折溢摊月累计
    ,hyzytnlj -- 行员折溢摊年累计
    ,hymmjc -- 行员买卖价差
    ,hymmjcylj -- 行员买卖价差月累计
    ,hymmjcnlj -- 行员买卖价差年累计
    ,hyfdyk -- 行员浮动盈亏
    ,hyfdykylj -- 行员浮动盈亏月累计
    ,hyfdyknlj -- 行员浮动盈亏年累计
    ,recal_dt -- 重算日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,fpjs -- 分配角色
    ,zlbl -- 认领比例
    ,bz -- 币种
    ,hydh -- 行员代号
    ,hymc -- 行员名称
    ,gsjgdh -- 归属机构代号
    ,gsjgmc -- 归属机构名称
    ,zqdm -- 债券代码
    ,zqmc -- 债券名称
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,hyme -- 行员面额
    ,hymeylj -- 行员面额月累计
    ,hymenlj -- 行员面额年累计
    ,hysybj -- 行员剩余本金
    ,hysybjylj -- 行员剩余本金月累计
    ,hysybjnlj -- 行员剩余本金年累计
    ,hypjcb -- 行员平均成本
    ,hypjcbylj -- 行员平均成本月累计
    ,hypjcbnlj -- 行员平均成本年累计
    ,hyzytjj -- 行员折溢摊净价
    ,hyzytjjylj -- 行员折溢摊净价月累计
    ,hyzytjjnlj -- 行员折溢摊净价年累计
    ,hyyjlx -- 行员应计利息
    ,hyyjlxylj -- 行员应计利息月累计
    ,hyyjlxnlj -- 行员应计利息年累计
    ,zcfzfl -- 资产负债分类
    ,zqdmmc -- 债券代码名称
    ,xzrq -- 修正久期
    ,dv01 -- DV01
    ,tzid -- 投组id
    ,jytzmc -- 交易投组名称
    ,tzsfl -- 投组三分类
    ,zhid -- 账户ID
    ,zhdm -- 账户代码
    ,zhmc -- 账户名称
    ,khjg -- 部门机构
    ,bzcp -- 标准产品
    ,dqsyl -- 到期收益率
    ,dcq -- 待偿期
    ,zqlx -- 债券类型
    ,hylxsr -- 行员利息收入
    ,hylxsrylj -- 行员利息收入月累计
    ,hylxsrnlj -- 行员利息收入年累计
    ,hyzyt -- 行员折溢摊
    ,hyzytylj -- 行员折溢摊月累计
    ,hyzytnlj -- 行员折溢摊年累计
    ,hymmjc -- 行员买卖价差
    ,hymmjcylj -- 行员买卖价差月累计
    ,hymmjcnlj -- 行员买卖价差年累计
    ,hyfdyk -- 行员浮动盈亏
    ,hyfdykylj -- 行员浮动盈亏月累计
    ,hyfdyknlj -- 行员浮动盈亏年累计
    ,recal_dt -- 重算日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_pjcbsyfxmx_recal
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxbb_pjcbsyfxmx_recal_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_pjcbsyfxmx_recal',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);