/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t1a_workday
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t1a_workday
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t1a_workday purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t1a_workday(
    day_dt date -- 日期
    ,is_holiday varchar2(2) -- 是否节假日（参见[字典:t00002]）
    ,is_week_first varchar2(2) -- 是否每周第一天（参见[字典:t00002]）
    ,day_desc varchar2(300) -- 描述
    ,create_tm varchar2(29) -- 创建时间
    ,creator varchar2(48) -- 创建人
    ,modify_tm varchar2(29) -- 修改时间
    ,modifier varchar2(48) -- 修改人
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.amls_t1a_workday to ${iml_schema};
grant select on ${iol_schema}.amls_t1a_workday to ${icl_schema};
grant select on ${iol_schema}.amls_t1a_workday to ${idl_schema};
grant select on ${iol_schema}.amls_t1a_workday to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t1a_workday is 'T1A_工作日配置表';
comment on column ${iol_schema}.amls_t1a_workday.day_dt is '日期';
comment on column ${iol_schema}.amls_t1a_workday.is_holiday is '是否节假日（参见[字典:t00002]）';
comment on column ${iol_schema}.amls_t1a_workday.is_week_first is '是否每周第一天（参见[字典:t00002]）';
comment on column ${iol_schema}.amls_t1a_workday.day_desc is '描述';
comment on column ${iol_schema}.amls_t1a_workday.create_tm is '创建时间';
comment on column ${iol_schema}.amls_t1a_workday.creator is '创建人';
comment on column ${iol_schema}.amls_t1a_workday.modify_tm is '修改时间';
comment on column ${iol_schema}.amls_t1a_workday.modifier is '修改人';
comment on column ${iol_schema}.amls_t1a_workday.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t1a_workday.etl_timestamp is 'ETL处理时间戳';
