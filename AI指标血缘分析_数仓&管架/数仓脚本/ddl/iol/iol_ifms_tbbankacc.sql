/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbbankacc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbbankacc
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbbankacc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbbankacc(
    bank_no varchar2(32) -- 
    ,bank_acc varchar2(64) -- 
    ,ta_client varchar2(48) -- 
    ,in_client_no varchar2(30) -- 
    ,client_type varchar2(2) -- 
    ,open_branch varchar2(80) -- 
    ,status varchar2(2) -- 
    ,trans_date number(22) -- 
    ,signoff_date number(22) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbbankacc to ${iml_schema};
grant select on ${iol_schema}.ifms_tbbankacc to ${icl_schema};
grant select on ${iol_schema}.ifms_tbbankacc to ${idl_schema};
grant select on ${iol_schema}.ifms_tbbankacc to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbbankacc is '签约银行账户信息表';
comment on column ${iol_schema}.ifms_tbbankacc.bank_no is '';
comment on column ${iol_schema}.ifms_tbbankacc.bank_acc is '';
comment on column ${iol_schema}.ifms_tbbankacc.ta_client is '';
comment on column ${iol_schema}.ifms_tbbankacc.in_client_no is '';
comment on column ${iol_schema}.ifms_tbbankacc.client_type is '';
comment on column ${iol_schema}.ifms_tbbankacc.open_branch is '';
comment on column ${iol_schema}.ifms_tbbankacc.status is '';
comment on column ${iol_schema}.ifms_tbbankacc.trans_date is '';
comment on column ${iol_schema}.ifms_tbbankacc.signoff_date is '';
comment on column ${iol_schema}.ifms_tbbankacc.reserve1 is '';
comment on column ${iol_schema}.ifms_tbbankacc.reserve2 is '';
comment on column ${iol_schema}.ifms_tbbankacc.reserve3 is '';
comment on column ${iol_schema}.ifms_tbbankacc.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbbankacc.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbbankacc.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbbankacc.etl_timestamp is 'ETL处理时间戳';
