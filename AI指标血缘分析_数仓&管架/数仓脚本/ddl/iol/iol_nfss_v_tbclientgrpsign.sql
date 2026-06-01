/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_v_tbclientgrpsign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_v_tbclientgrpsign
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_v_tbclientgrpsign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_v_tbclientgrpsign(
    in_client_no varchar2(30) -- 
    ,bank_acc varchar2(96) -- 
    ,group_code varchar2(48) -- 
    ,virtual_bank_acc varchar2(48) -- 
    ,status varchar2(2) -- 
    ,create_date number(38) -- 
    ,signoff_date number(38) -- 
    ,auto_redeem_flag varchar2(2) -- 
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
grant select on ${iol_schema}.nfss_v_tbclientgrpsign to ${iml_schema};
grant select on ${iol_schema}.nfss_v_tbclientgrpsign to ${icl_schema};
grant select on ${iol_schema}.nfss_v_tbclientgrpsign to ${idl_schema};
grant select on ${iol_schema}.nfss_v_tbclientgrpsign to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_v_tbclientgrpsign is '客户签约组合表';
comment on column ${iol_schema}.nfss_v_tbclientgrpsign.in_client_no is '';
comment on column ${iol_schema}.nfss_v_tbclientgrpsign.bank_acc is '';
comment on column ${iol_schema}.nfss_v_tbclientgrpsign.group_code is '';
comment on column ${iol_schema}.nfss_v_tbclientgrpsign.virtual_bank_acc is '';
comment on column ${iol_schema}.nfss_v_tbclientgrpsign.status is '';
comment on column ${iol_schema}.nfss_v_tbclientgrpsign.create_date is '';
comment on column ${iol_schema}.nfss_v_tbclientgrpsign.signoff_date is '';
comment on column ${iol_schema}.nfss_v_tbclientgrpsign.auto_redeem_flag is '';
comment on column ${iol_schema}.nfss_v_tbclientgrpsign.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_v_tbclientgrpsign.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_v_tbclientgrpsign.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_v_tbclientgrpsign.etl_timestamp is 'ETL处理时间戳';
