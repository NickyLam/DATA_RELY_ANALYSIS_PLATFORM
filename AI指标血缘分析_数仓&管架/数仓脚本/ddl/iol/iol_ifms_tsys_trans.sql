/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tsys_trans
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tsys_trans
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tsys_trans purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tsys_trans(
    trans_code varchar2(48) -- 
    ,trans_name varchar2(250) -- 
    ,kind_code varchar2(128) -- 
    ,model_code varchar2(48) -- 
    ,remark varchar2(1000) -- 
    ,ext_field_1 varchar2(384) -- 
    ,ext_field_2 varchar2(384) -- 
    ,ext_field_3 varchar2(384) -- 
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
grant select on ${iol_schema}.ifms_tsys_trans to ${iml_schema};
grant select on ${iol_schema}.ifms_tsys_trans to ${icl_schema};
grant select on ${iol_schema}.ifms_tsys_trans to ${idl_schema};
grant select on ${iol_schema}.ifms_tsys_trans to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tsys_trans is '系统交易表';
comment on column ${iol_schema}.ifms_tsys_trans.trans_code is '';
comment on column ${iol_schema}.ifms_tsys_trans.trans_name is '';
comment on column ${iol_schema}.ifms_tsys_trans.kind_code is '';
comment on column ${iol_schema}.ifms_tsys_trans.model_code is '';
comment on column ${iol_schema}.ifms_tsys_trans.remark is '';
comment on column ${iol_schema}.ifms_tsys_trans.ext_field_1 is '';
comment on column ${iol_schema}.ifms_tsys_trans.ext_field_2 is '';
comment on column ${iol_schema}.ifms_tsys_trans.ext_field_3 is '';
comment on column ${iol_schema}.ifms_tsys_trans.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tsys_trans.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tsys_trans.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tsys_trans.etl_timestamp is 'ETL处理时间戳';
