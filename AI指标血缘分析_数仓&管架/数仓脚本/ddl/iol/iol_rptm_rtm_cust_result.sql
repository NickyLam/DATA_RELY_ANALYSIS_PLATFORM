/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rptm_rtm_cust_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rptm_rtm_cust_result
whenever sqlerror continue none;
drop table ${iol_schema}.rptm_rtm_cust_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_cust_result(
    id varchar2(576) -- 
    ,rp_card_no varchar2(1152) -- 
    ,cust_no varchar2(576) -- 
    ,rp_name varchar2(2295) -- 
    ,is_bank_business varchar2(270) -- 
    ,ybj_rp_card_type varchar2(90) -- 
    ,etl_dt date -- 
    ,update_dt date -- 
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
grant select on ${iol_schema}.rptm_rtm_cust_result to ${iml_schema};
grant select on ${iol_schema}.rptm_rtm_cust_result to ${icl_schema};
grant select on ${iol_schema}.rptm_rtm_cust_result to ${idl_schema};
grant select on ${iol_schema}.rptm_rtm_cust_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.rptm_rtm_cust_result is '关联方客户处理表';
comment on column ${iol_schema}.rptm_rtm_cust_result.id is '';
comment on column ${iol_schema}.rptm_rtm_cust_result.rp_card_no is '';
comment on column ${iol_schema}.rptm_rtm_cust_result.cust_no is '';
comment on column ${iol_schema}.rptm_rtm_cust_result.rp_name is '';
comment on column ${iol_schema}.rptm_rtm_cust_result.is_bank_business is '';
comment on column ${iol_schema}.rptm_rtm_cust_result.ybj_rp_card_type is '';
comment on column ${iol_schema}.rptm_rtm_cust_result.etl_dt is '';
comment on column ${iol_schema}.rptm_rtm_cust_result.update_dt is '';
comment on column ${iol_schema}.rptm_rtm_cust_result.start_dt is '开始时间';
comment on column ${iol_schema}.rptm_rtm_cust_result.end_dt is '结束时间';
comment on column ${iol_schema}.rptm_rtm_cust_result.id_mark is '增删标志';
comment on column ${iol_schema}.rptm_rtm_cust_result.etl_timestamp is 'ETL处理时间戳';
