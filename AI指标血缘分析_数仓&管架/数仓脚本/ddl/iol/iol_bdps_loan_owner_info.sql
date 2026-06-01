/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_loan_owner_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_loan_owner_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_loan_owner_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_loan_owner_info(
    id number(22) -- 
    ,lntype varchar2(2) -- 
    ,appno varchar2(48) -- 
    ,loanno varchar2(60) -- 
    ,guarno varchar2(60) -- 
    ,orcustno varchar2(24) -- 
    ,guarrate number(10,6) -- 
    ,last_upd_oper_id number(22) -- 
    ,last_upd_time varchar2(21) -- 
    ,totalamt number(18,2) -- 
    ,collztn_status varchar2(2) -- 
    ,custno varchar2(24) -- 
    ,pool_type varchar2(2) -- 1-  票据池 2-  资产池
    ,paragraph_amt number(18,2) -- 业务合同下已备款金额
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdps_loan_owner_info to ${iml_schema};
grant select on ${iol_schema}.bdps_loan_owner_info to ${icl_schema};
grant select on ${iol_schema}.bdps_loan_owner_info to ${idl_schema};
grant select on ${iol_schema}.bdps_loan_owner_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_loan_owner_info is '票据池权属人信息业务表';
comment on column ${iol_schema}.bdps_loan_owner_info.id is '';
comment on column ${iol_schema}.bdps_loan_owner_info.lntype is '';
comment on column ${iol_schema}.bdps_loan_owner_info.appno is '';
comment on column ${iol_schema}.bdps_loan_owner_info.loanno is '';
comment on column ${iol_schema}.bdps_loan_owner_info.guarno is '';
comment on column ${iol_schema}.bdps_loan_owner_info.orcustno is '';
comment on column ${iol_schema}.bdps_loan_owner_info.guarrate is '';
comment on column ${iol_schema}.bdps_loan_owner_info.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_loan_owner_info.last_upd_time is '';
comment on column ${iol_schema}.bdps_loan_owner_info.totalamt is '';
comment on column ${iol_schema}.bdps_loan_owner_info.collztn_status is '';
comment on column ${iol_schema}.bdps_loan_owner_info.custno is '';
comment on column ${iol_schema}.bdps_loan_owner_info.pool_type is '1-  票据池 2-  资产池';
comment on column ${iol_schema}.bdps_loan_owner_info.paragraph_amt is '业务合同下已备款金额';
comment on column ${iol_schema}.bdps_loan_owner_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_loan_owner_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_loan_owner_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_loan_owner_info.etl_timestamp is 'ETL处理时间戳';
