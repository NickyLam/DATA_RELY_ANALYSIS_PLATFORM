/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_loan_acct_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.loan_acct_info drop partition p_${last_date};
alter table ${idl_schema}.loan_acct_info drop partition p_${batch_date};

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${idl_schema}.loan_acct_info_tmp purge;
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.loan_acct_info_tmp 
nologging
compress ${option_switch} for query high
as select acct_id from ${idl_schema}.loan_acct_info where 0=1;

-- 1.3 插入贷款还款号至新建临时表
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.loan_acct_info_tmp(
select max(repay_num) acct_id from icl.cmm_unite_wl_dubil_info where etl_dt = to_date('${batch_date}','yyyymmdd') and pric_bal > 0 group by repay_num);
commit;
insert /*+ append */ into ${idl_schema}.loan_acct_info_tmp(
select max(loan_repay_num) acct_id from icl.cmm_corp_loan_acct_info where etl_dt = to_date('${batch_date}','yyyymmdd') and pric_bal > 0 group by loan_repay_num);
commit;
insert /*+ append */ into ${idl_schema}.loan_acct_info_tmp(
select max(loan_repay_num) acct_id from icl.cmm_retl_loan_acct_info where etl_dt = to_date('${batch_date}','yyyymmdd') and pric_bal > 0 group by loan_repay_num);
commit;

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.loan_acct_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.loan_acct_info (
    etl_dt  -- 数据日期
    ,acct_id  -- 账户编号
    ,acct_name  -- 账户名称
    ,cust_id  -- 客户编号
    ,cert_type_cd  -- 证件类型代码
    ,cert_no  -- 证件号码
    ,open_brac_id  -- 开户网点编号
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(p2.cust_acct_id,chr(13),''),chr(10),'')  -- 贷款还款账号
    ,replace(replace(p2.cust_acct_name,chr(13),''),chr(10),'')  -- 客户账户名称
    ,replace(replace(p2.cust_id,chr(13),''),chr(10),'')  -- 客户号 
    ,replace(replace(p3.cert_type_cd,chr(13),''),chr(10),'')  -- 证件类型代码
    ,replace(replace(p3.cert_num,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(p2.open_acct_org_id,chr(13),''),chr(10),'')  -- 开户机构编号
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${icl_schema}.cmm_dep_cust_acct_info  p2   --存款主账户信息
inner join ${idl_schema}.loan_acct_info_tmp p1
    on p1.acct_id = p2.cust_acct_id 
left join ${iml_schema}.pty_party_cert_info_h p3   --当事人证件信息历史
    on p2.cust_id = p3.party_id
  and p3.start_dt <= to_date('${batch_date}','yyyymmdd')
  and p3.end_dt > to_date('${batch_date}','yyyymmdd')
  and p3.id_mark <> 'D'
where p2.etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;

-- 3.1 drop tmp table
whenever sqlerror continue none ;
drop table ${idl_schema}.loan_acct_info_tmp purge;

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'loan_acct_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);