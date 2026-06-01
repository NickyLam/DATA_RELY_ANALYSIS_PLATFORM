/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_transfer_tran_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_transfer_tran_def
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_transfer_tran_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_transfer_tran_def(
    tran_type varchar2(10) -- 交易类型
    ,company varchar2(20) -- 法人
    ,event_type varchar2(20) -- 事件类型
    ,oth_tran_scene varchar2(200) -- 对手交易场景
    ,tran_scene varchar2(50) -- 交易场景
    ,tran_scene_desc varchar2(50) -- 交易场景描述
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_cl_transfer_tran_def to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_tran_def to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_tran_def to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_tran_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_transfer_tran_def is '资产转让交易类型配置表';
comment on column ${iol_schema}.ncbs_cl_transfer_tran_def.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_cl_transfer_tran_def.company is '法人';
comment on column ${iol_schema}.ncbs_cl_transfer_tran_def.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_cl_transfer_tran_def.oth_tran_scene is '对手交易场景';
comment on column ${iol_schema}.ncbs_cl_transfer_tran_def.tran_scene is '交易场景';
comment on column ${iol_schema}.ncbs_cl_transfer_tran_def.tran_scene_desc is '交易场景描述';
comment on column ${iol_schema}.ncbs_cl_transfer_tran_def.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_transfer_tran_def.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_transfer_tran_def.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_transfer_tran_def.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_transfer_tran_def.etl_timestamp is 'ETL处理时间戳';
