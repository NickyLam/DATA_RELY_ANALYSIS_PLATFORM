/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdws_a_cust_acct_status_flg
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
drop table ${iol_schema}.bdws_a_cust_acct_status_flg_ex purge;
alter table ${iol_schema}.bdws_a_cust_acct_status_flg add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.bdws_a_cust_acct_status_flg;

-- 2.3 insert data to ex table
create table ${iol_schema}.bdws_a_cust_acct_status_flg_ex nologging
compress
as
select * from ${iol_schema}.bdws_a_cust_acct_status_flg where 0=1;

insert /*+ append */ into ${iol_schema}.bdws_a_cust_acct_status_flg_ex(
    cust_id -- 客户号
    ,acct_type -- 账户类型（取最高等级的账户，按I>II>III>定期>临时>虚拟>其它>未知）
    ,if_allacct_close -- 是否所有账户已销户
    ,acct_type_i -- 是否持有I类户
    ,acct_type_ii -- 是否持有II类户
    ,acct_type_iii -- 是否持有III类户
    ,acct_type_dept -- 是否持有定期户
    ,acct_type_tmp -- 是否持有临时户
    ,acct_type_virt -- 是否持有虚拟户
    ,acct_type_oth -- 是否持有其它账户
    ,acct_type_und -- 是否持有未知账户
    ,last_clos_dt -- 最后一个销户日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cust_id -- 客户号
    ,acct_type -- 账户类型（取最高等级的账户，按I>II>III>定期>临时>虚拟>其它>未知）
    ,if_allacct_close -- 是否所有账户已销户
    ,acct_type_i -- 是否持有I类户
    ,acct_type_ii -- 是否持有II类户
    ,acct_type_iii -- 是否持有III类户
    ,acct_type_dept -- 是否持有定期户
    ,acct_type_tmp -- 是否持有临时户
    ,acct_type_virt -- 是否持有虚拟户
    ,acct_type_oth -- 是否持有其它账户
    ,acct_type_und -- 是否持有未知账户
    ,last_clos_dt -- 最后一个销户日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdws_a_cust_acct_status_flg
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdws_a_cust_acct_status_flg exchange partition p_${batch_date} with table ${iol_schema}.bdws_a_cust_acct_status_flg_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdws_a_cust_acct_status_flg to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdws_a_cust_acct_status_flg_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdws_a_cust_acct_status_flg',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);