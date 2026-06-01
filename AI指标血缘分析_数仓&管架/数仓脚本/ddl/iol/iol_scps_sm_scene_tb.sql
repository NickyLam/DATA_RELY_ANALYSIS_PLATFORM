/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_sm_scene_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_sm_scene_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_sm_scene_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_sm_scene_tb(
    scene_code varchar2(32) -- 业务场景id
    ,scene_name varchar2(100) -- 业务场景中文名
    ,scene_desc varchar2(500) -- 业务场景描述
    ,is_open varchar2(1) -- 是否启用
    ,last_modi_date varchar2(14) -- 最后修改时间
    ,bank_no varchar2(10) -- 银行号
    ,system_no varchar2(10) -- 系统号
    ,istolocal varchar2(10) -- 转本地标识
    ,element_no varchar2(100) -- 节点名
    ,field_range varchar2(1000) -- 
    ,value_type varchar2(100) -- 
    ,default_value varchar2(100) -- 
    ,field_type varchar2(100) -- 
    ,regex_msg varchar2(500) -- 
    ,regx varchar2(100) -- 
    ,field_pange varchar2(100) -- 
    ,tradecode varchar2(18) -- 交易码
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
grant select on ${iol_schema}.scps_sm_scene_tb to ${iml_schema};
grant select on ${iol_schema}.scps_sm_scene_tb to ${icl_schema};
grant select on ${iol_schema}.scps_sm_scene_tb to ${idl_schema};
grant select on ${iol_schema}.scps_sm_scene_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_sm_scene_tb is '业务场景表';
comment on column ${iol_schema}.scps_sm_scene_tb.scene_code is '业务场景id';
comment on column ${iol_schema}.scps_sm_scene_tb.scene_name is '业务场景中文名';
comment on column ${iol_schema}.scps_sm_scene_tb.scene_desc is '业务场景描述';
comment on column ${iol_schema}.scps_sm_scene_tb.is_open is '是否启用';
comment on column ${iol_schema}.scps_sm_scene_tb.last_modi_date is '最后修改时间';
comment on column ${iol_schema}.scps_sm_scene_tb.bank_no is '银行号';
comment on column ${iol_schema}.scps_sm_scene_tb.system_no is '系统号';
comment on column ${iol_schema}.scps_sm_scene_tb.istolocal is '转本地标识';
comment on column ${iol_schema}.scps_sm_scene_tb.element_no is '节点名';
comment on column ${iol_schema}.scps_sm_scene_tb.field_range is '';
comment on column ${iol_schema}.scps_sm_scene_tb.value_type is '';
comment on column ${iol_schema}.scps_sm_scene_tb.default_value is '';
comment on column ${iol_schema}.scps_sm_scene_tb.field_type is '';
comment on column ${iol_schema}.scps_sm_scene_tb.regex_msg is '';
comment on column ${iol_schema}.scps_sm_scene_tb.regx is '';
comment on column ${iol_schema}.scps_sm_scene_tb.field_pange is '';
comment on column ${iol_schema}.scps_sm_scene_tb.tradecode is '交易码';
comment on column ${iol_schema}.scps_sm_scene_tb.start_dt is '开始时间';
comment on column ${iol_schema}.scps_sm_scene_tb.end_dt is '结束时间';
comment on column ${iol_schema}.scps_sm_scene_tb.id_mark is '增删标志';
comment on column ${iol_schema}.scps_sm_scene_tb.etl_timestamp is 'ETL处理时间戳';
