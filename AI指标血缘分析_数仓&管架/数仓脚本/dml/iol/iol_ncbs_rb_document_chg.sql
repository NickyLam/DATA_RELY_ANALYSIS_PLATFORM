/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_document_chg
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
drop table ${iol_schema}.ncbs_rb_document_chg_ex purge;
alter table ${iol_schema}.ncbs_rb_document_chg add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_document_chg;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_document_chg_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_document_chg where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_document_chg_ex(
    client_no -- 客户编号
    ,document_type -- 客户证件类型
    ,timestamp -- 时间戳
    ,company -- 法人
    ,seq_no -- 序号
    ,new_document_id -- 变更后证件号码
    ,old_client_name -- 原客户名称
    ,old_document_id -- 变更前证件号码
    ,old_document_type -- 旧证件类型
    ,new_client_name -- 新客户名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    client_no -- 客户编号
    ,document_type -- 客户证件类型
    ,timestamp -- 时间戳
    ,company -- 法人
    ,seq_no -- 序号
    ,new_document_id -- 变更后证件号码
    ,old_client_name -- 原客户名称
    ,old_document_id -- 变更前证件号码
    ,old_document_type -- 旧证件类型
    ,new_client_name -- 新客户名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_document_chg
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_document_chg exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_document_chg_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_document_chg to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_document_chg_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_document_chg',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);