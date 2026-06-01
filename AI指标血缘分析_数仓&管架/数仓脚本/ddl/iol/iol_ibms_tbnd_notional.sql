/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tbnd_notional
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tbnd_notional
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tbnd_notional purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tbnd_notional(
    d_code varchar2(60) -- 债券内部代码
    ,i_code varchar2(45) -- 交易代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,b_exec_date varchar2(15) -- 生效日
    ,b_notional number(12,6) -- 剩余本金
    ,pipe_id number(22) -- 导入管道
    ,imp_date varchar2(15) -- 导入日期
    ,imp_time varchar2(29) -- 导入时间
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
grant select on ${iol_schema}.ibms_tbnd_notional to ${iml_schema};
grant select on ${iol_schema}.ibms_tbnd_notional to ${icl_schema};
grant select on ${iol_schema}.ibms_tbnd_notional to ${idl_schema};
grant select on ${iol_schema}.ibms_tbnd_notional to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tbnd_notional is '债券本金序列表';
comment on column ${iol_schema}.ibms_tbnd_notional.d_code is '债券内部代码';
comment on column ${iol_schema}.ibms_tbnd_notional.i_code is '交易代码';
comment on column ${iol_schema}.ibms_tbnd_notional.a_type is '资产类型';
comment on column ${iol_schema}.ibms_tbnd_notional.m_type is '市场类型';
comment on column ${iol_schema}.ibms_tbnd_notional.b_exec_date is '生效日';
comment on column ${iol_schema}.ibms_tbnd_notional.b_notional is '剩余本金';
comment on column ${iol_schema}.ibms_tbnd_notional.pipe_id is '导入管道';
comment on column ${iol_schema}.ibms_tbnd_notional.imp_date is '导入日期';
comment on column ${iol_schema}.ibms_tbnd_notional.imp_time is '导入时间';
comment on column ${iol_schema}.ibms_tbnd_notional.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_tbnd_notional.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_tbnd_notional.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_tbnd_notional.etl_timestamp is 'ETL处理时间戳';
