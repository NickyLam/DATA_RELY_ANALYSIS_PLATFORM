/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdws_a_cm_cust_nmb_login
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
drop table ${iol_schema}.bdws_a_cm_cust_nmb_login_ex purge;
alter table ${iol_schema}.bdws_a_cm_cust_nmb_login add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.bdws_a_cm_cust_nmb_login truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.bdws_a_cm_cust_nmb_login_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdws_a_cm_cust_nmb_login where 0=1;

insert /*+ append */ into ${iol_schema}.bdws_a_cm_cust_nmb_login_ex(
    cust_id -- 
    ,is_login_last -- 
    ,is_login -- 
    ,sleep_acct_flg -- 
    ,long_hang_acct_flg -- 
    ,is_kjzf_sign -- 
    ,kjzf_hpd_last -- 
    ,kjzf_hpd -- 
    ,load_date -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cust_id -- 
    ,is_login_last -- 
    ,is_login -- 
    ,sleep_acct_flg -- 
    ,long_hang_acct_flg -- 
    ,is_kjzf_sign -- 
    ,kjzf_hpd_last -- 
    ,kjzf_hpd -- 
    ,load_date -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdws_a_cm_cust_nmb_login
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdws_a_cm_cust_nmb_login exchange partition p_${batch_date} with table ${iol_schema}.bdws_a_cm_cust_nmb_login_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdws_a_cm_cust_nmb_login to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdws_a_cm_cust_nmb_login_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdws_a_cm_cust_nmb_login',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);