/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_security_fix_schd
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
drop table ${iol_schema}.ctms_tbs_v_security_fix_schd_ex purge;
alter table ${iol_schema}.ctms_tbs_v_security_fix_schd add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ctms_tbs_v_security_fix_schd;

-- 2.3 insert data to ex table
create table ${iol_schema}.ctms_tbs_v_security_fix_schd_ex nologging
compress
as
select * from ${iol_schema}.ctms_tbs_v_security_fix_schd where 0=1;

insert /*+ append */ into ${iol_schema}.ctms_tbs_v_security_fix_schd_ex(
    security_code -- 债券代码
    ,seq -- 序号
    ,start_date -- 起始日期
    ,end_date -- 到期日期
    ,fixing_date -- 重定价日期
    ,fixing_rate -- 重定价利率
    ,modify_date -- 修改日期
    ,modify_user -- 修改人ID
    ,spread -- 点差
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    security_code -- 债券代码
    ,seq -- 序号
    ,start_date -- 起始日期
    ,end_date -- 到期日期
    ,fixing_date -- 重定价日期
    ,fixing_rate -- 重定价利率
    ,modify_date -- 修改日期
    ,modify_user -- 修改人ID
    ,spread -- 点差
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ctms_tbs_v_security_fix_schd
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ctms_tbs_v_security_fix_schd exchange partition p_${batch_date} with table ${iol_schema}.ctms_tbs_v_security_fix_schd_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_security_fix_schd to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ctms_tbs_v_security_fix_schd_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_security_fix_schd',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);