/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbprdfeature_hxyh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbprdfeature_hxyh
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbprdfeature_hxyh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbprdfeature_hxyh(
    prd_code varchar2(32) -- 
    ,trade_rule varchar2(2000) -- 
    ,prd_feature varchar2(2000) -- 
    ,reserve1 varchar2(2000) -- 
    ,reserve2 varchar2(2000) -- 
    ,reserve3 varchar2(2000) -- 
    ,reserve4 varchar2(375) -- 
    ,reserve5 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbprdfeature_hxyh to ${iml_schema};
grant select on ${iol_schema}.ifms_tbprdfeature_hxyh to ${icl_schema};
grant select on ${iol_schema}.ifms_tbprdfeature_hxyh to ${idl_schema};
grant select on ${iol_schema}.ifms_tbprdfeature_hxyh to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbprdfeature_hxyh is '';
comment on column ${iol_schema}.ifms_tbprdfeature_hxyh.prd_code is '';
comment on column ${iol_schema}.ifms_tbprdfeature_hxyh.trade_rule is '';
comment on column ${iol_schema}.ifms_tbprdfeature_hxyh.prd_feature is '';
comment on column ${iol_schema}.ifms_tbprdfeature_hxyh.reserve1 is '';
comment on column ${iol_schema}.ifms_tbprdfeature_hxyh.reserve2 is '';
comment on column ${iol_schema}.ifms_tbprdfeature_hxyh.reserve3 is '';
comment on column ${iol_schema}.ifms_tbprdfeature_hxyh.reserve4 is '';
comment on column ${iol_schema}.ifms_tbprdfeature_hxyh.reserve5 is '';
comment on column ${iol_schema}.ifms_tbprdfeature_hxyh.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbprdfeature_hxyh.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbprdfeature_hxyh.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbprdfeature_hxyh.etl_timestamp is 'ETL处理时间戳';
