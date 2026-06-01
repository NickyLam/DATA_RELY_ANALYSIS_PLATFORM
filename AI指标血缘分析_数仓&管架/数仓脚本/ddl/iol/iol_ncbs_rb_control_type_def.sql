/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_control_type_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_control_type_def
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_control_type_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_control_type_def(
    manual_un_ctrl_flag varchar2(1) -- 允许手工解控标志
    ,manual_ctrl_flag varchar2(1) -- 允许手工控制标志
    ,company varchar2(20) -- 法人
    ,control_type varchar2(3) -- 控制类型
    ,forbid_channels varchar2(200) -- 禁止渠道集合
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,control_class varchar2(5) -- 控制科目
    ,control_type_desc varchar2(200) -- 控制类型描述
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
grant select on ${iol_schema}.ncbs_rb_control_type_def to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_control_type_def to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_control_type_def to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_control_type_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_control_type_def is '控制类型参数表';
comment on column ${iol_schema}.ncbs_rb_control_type_def.manual_un_ctrl_flag is '允许手工解控标志';
comment on column ${iol_schema}.ncbs_rb_control_type_def.manual_ctrl_flag is '允许手工控制标志';
comment on column ${iol_schema}.ncbs_rb_control_type_def.company is '法人';
comment on column ${iol_schema}.ncbs_rb_control_type_def.control_type is '控制类型';
comment on column ${iol_schema}.ncbs_rb_control_type_def.forbid_channels is '禁止渠道集合';
comment on column ${iol_schema}.ncbs_rb_control_type_def.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_control_type_def.control_class is '控制科目';
comment on column ${iol_schema}.ncbs_rb_control_type_def.control_type_desc is '控制类型描述';
comment on column ${iol_schema}.ncbs_rb_control_type_def.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_control_type_def.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_control_type_def.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_control_type_def.etl_timestamp is 'ETL处理时间戳';
