/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_ded_rate_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_ded_rate_def
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_ded_rate_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_ded_rate_def(
    id number(11,0) -- 序号
    ,name varchar2(150) -- 名称
    ,update_time varchar2(29) -- 更新时间
    ,update_user varchar2(150) -- 更新者
    ,create_time varchar2(29) -- 创建时间
    ,create_user varchar2(30) -- 创建者
    ,type varchar2(30) -- 类型
    ,i_id number(22) -- 金融机构id
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
grant select on ${iol_schema}.ibms_ttrd_ded_rate_def to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_ded_rate_def to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_ded_rate_def to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_ded_rate_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_ded_rate_def is '活期金融工具利率定义表';
comment on column ${iol_schema}.ibms_ttrd_ded_rate_def.id is '序号';
comment on column ${iol_schema}.ibms_ttrd_ded_rate_def.name is '名称';
comment on column ${iol_schema}.ibms_ttrd_ded_rate_def.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_ded_rate_def.update_user is '更新者';
comment on column ${iol_schema}.ibms_ttrd_ded_rate_def.create_time is '创建时间';
comment on column ${iol_schema}.ibms_ttrd_ded_rate_def.create_user is '创建者';
comment on column ${iol_schema}.ibms_ttrd_ded_rate_def.type is '类型';
comment on column ${iol_schema}.ibms_ttrd_ded_rate_def.i_id is '金融机构id';
comment on column ${iol_schema}.ibms_ttrd_ded_rate_def.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_ded_rate_def.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_ded_rate_def.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_ded_rate_def.etl_timestamp is 'ETL处理时间戳';
