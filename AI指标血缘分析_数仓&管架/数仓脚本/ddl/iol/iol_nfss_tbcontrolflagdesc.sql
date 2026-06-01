/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbcontrolflagdesc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbcontrolflagdesc
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbcontrolflagdesc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbcontrolflagdesc(
    table_name varchar2(48) -- 表名称
    ,field_name varchar2(48) -- 字段名称
    ,position number(22,0) -- 位置（第几位）
    ,table_label varchar2(90) -- 显示名称
    ,default_value varchar2(2) -- 默认值
    ,option_visible varchar2(2) -- 是否显示
    ,input_type varchar2(2) -- 控件类型
    ,table_index number(22,0) -- 顺序号
    ,table_value varchar2(2) -- 值
    ,prompt varchar2(375) -- 提示信息
    ,remark1 varchar2(375) -- 备用1
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
grant select on ${iol_schema}.nfss_tbcontrolflagdesc to ${iml_schema};
grant select on ${iol_schema}.nfss_tbcontrolflagdesc to ${icl_schema};
grant select on ${iol_schema}.nfss_tbcontrolflagdesc to ${idl_schema};
grant select on ${iol_schema}.nfss_tbcontrolflagdesc to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbcontrolflagdesc is '控制字段描述表';
comment on column ${iol_schema}.nfss_tbcontrolflagdesc.table_name is '表名称';
comment on column ${iol_schema}.nfss_tbcontrolflagdesc.field_name is '字段名称';
comment on column ${iol_schema}.nfss_tbcontrolflagdesc.position is '位置（第几位）';
comment on column ${iol_schema}.nfss_tbcontrolflagdesc.table_label is '显示名称';
comment on column ${iol_schema}.nfss_tbcontrolflagdesc.default_value is '默认值';
comment on column ${iol_schema}.nfss_tbcontrolflagdesc.option_visible is '是否显示';
comment on column ${iol_schema}.nfss_tbcontrolflagdesc.input_type is '控件类型';
comment on column ${iol_schema}.nfss_tbcontrolflagdesc.table_index is '顺序号';
comment on column ${iol_schema}.nfss_tbcontrolflagdesc.table_value is '值';
comment on column ${iol_schema}.nfss_tbcontrolflagdesc.prompt is '提示信息';
comment on column ${iol_schema}.nfss_tbcontrolflagdesc.remark1 is '备用1';
comment on column ${iol_schema}.nfss_tbcontrolflagdesc.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbcontrolflagdesc.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbcontrolflagdesc.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbcontrolflagdesc.etl_timestamp is 'ETL处理时间戳';
