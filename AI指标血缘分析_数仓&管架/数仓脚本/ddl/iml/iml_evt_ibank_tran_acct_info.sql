/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ibank_tran_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ibank_tran_acct_info
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ibank_tran_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ibank_tran_acct_info(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,apv_odd_no varchar2(60) -- 审批单号
    ,cust_acct_id varchar2(60) -- 客户账户编号
    ,cust_acct_sub_acct_id varchar2(60) -- 客户账户子户号
    ,cust_id varchar2(60) -- 交易客户编号
    ,sav_type_cd varchar2(10) -- 储种代码
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_ibank_tran_acct_info to ${icl_schema};
grant select on ${iml_schema}.evt_ibank_tran_acct_info to ${idl_schema};
grant select on ${iml_schema}.evt_ibank_tran_acct_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ibank_tran_acct_info is '同业交易账户信息';
comment on column ${iml_schema}.evt_ibank_tran_acct_info.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ibank_tran_acct_info.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ibank_tran_acct_info.apv_odd_no is '审批单号';
comment on column ${iml_schema}.evt_ibank_tran_acct_info.cust_acct_id is '客户账户编号';
comment on column ${iml_schema}.evt_ibank_tran_acct_info.cust_acct_sub_acct_id is '客户账户子户号';
comment on column ${iml_schema}.evt_ibank_tran_acct_info.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_ibank_tran_acct_info.sav_type_cd is '储种代码';
comment on column ${iml_schema}.evt_ibank_tran_acct_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ibank_tran_acct_info.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ibank_tran_acct_info.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ibank_tran_acct_info.etl_timestamp is 'ETL处理时间戳';
