/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_nbzz_xnckmx
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
drop table ${iol_schema}.pams_nbzz_xnckmx_ex purge;
alter table ${iol_schema}.pams_nbzz_xnckmx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_nbzz_xnckmx truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_nbzz_xnckmx_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_nbzz_xnckmx where 0=1;

insert /*+ append */ into ${iol_schema}.pams_nbzz_xnckmx_ex(
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 行员考核对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,kh -- 卡号
    ,kmh -- 科目号
    ,cph -- 产品号
    ,bz -- 币种
    ,fpjs -- 分配角色
    ,zhye -- 账户余额
    ,zlbl -- 增量比例
    ,hyye -- 行员余额
    ,hyylj -- 行员月累计
    ,hyjlj -- 行员季累计
    ,hybnlj -- 行员半年累计
    ,hynlj -- 行员年累计
    ,hyymlj -- 行员月末累计
    ,zlblylj -- 增量比例月累计
    ,zlbljlj -- 增量比例季累计
    ,zlblnlj -- 增量比例年累计
    ,zlblymlj -- 增量比例月末累计
    ,zhnrjye -- 账户年日均余额
    ,zhjrjye -- 账户季日均余额
    ,zhyrjye -- 账户月日均余额
    ,nll -- 年利率
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 行员考核对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,kh -- 卡号
    ,kmh -- 科目号
    ,cph -- 产品号
    ,bz -- 币种
    ,fpjs -- 分配角色
    ,zhye -- 账户余额
    ,zlbl -- 增量比例
    ,hyye -- 行员余额
    ,hyylj -- 行员月累计
    ,hyjlj -- 行员季累计
    ,hybnlj -- 行员半年累计
    ,hynlj -- 行员年累计
    ,hyymlj -- 行员月末累计
    ,zlblylj -- 增量比例月累计
    ,zlbljlj -- 增量比例季累计
    ,zlblnlj -- 增量比例年累计
    ,zlblymlj -- 增量比例月末累计
    ,zhnrjye -- 账户年日均余额
    ,zhjrjye -- 账户季日均余额
    ,zhyrjye -- 账户月日均余额
    ,nll -- 年利率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_nbzz_xnckmx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_nbzz_xnckmx exchange partition p_${batch_date} with table ${iol_schema}.pams_nbzz_xnckmx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_nbzz_xnckmx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_nbzz_xnckmx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_nbzz_xnckmx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);