/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_pjjzkhmx_recal
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
drop table ${iol_schema}.pams_jxbb_pjjzkhmx_recal_ex purge;
alter table ${iol_schema}.pams_jxbb_pjjzkhmx_recal add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_jxbb_pjjzkhmx_recal truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxbb_pjjzkhmx_recal_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_pjjzkhmx_recal where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxbb_pjjzkhmx_recal_ex(
    tjrq -- 统计日期
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,fhdh -- 所属分行代号
    ,fhmc -- 所属分行名称
    ,jgdh -- 所属机构代号
    ,jgmc -- 所属机构名称
    ,hydh -- 所属行员代号
    ,hymc -- 所属行员名称
    ,cknrj -- 存款年日均
    ,ckljsy -- 存款FTP净收益
    ,sxfljsy -- 承兑手续费收入
    ,dktxljsy -- 直贴FTP净收益
    ,fhfpsy -- 总分联动直贴业务收益
    ,pjjcsy -- 系统内票据转贴现价差损益
    ,nljsy -- 年化收益
    ,sfjzkh -- 是否价值客户:Y-是,N-否
    ,recal_dt -- 重算日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,fhdh -- 所属分行代号
    ,fhmc -- 所属分行名称
    ,jgdh -- 所属机构代号
    ,jgmc -- 所属机构名称
    ,hydh -- 所属行员代号
    ,hymc -- 所属行员名称
    ,cknrj -- 存款年日均
    ,ckljsy -- 存款FTP净收益
    ,sxfljsy -- 承兑手续费收入
    ,dktxljsy -- 直贴FTP净收益
    ,fhfpsy -- 总分联动直贴业务收益
    ,pjjcsy -- 系统内票据转贴现价差损益
    ,nljsy -- 年化收益
    ,sfjzkh -- 是否价值客户:Y-是,N-否
    ,recal_dt -- 重算日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_pjjzkhmx_recal
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxbb_pjjzkhmx_recal exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_pjjzkhmx_recal_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_pjjzkhmx_recal to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxbb_pjjzkhmx_recal_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_pjjzkhmx_recal',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);