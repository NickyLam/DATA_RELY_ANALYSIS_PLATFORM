/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tbnd_manual_eval
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tbnd_manual_eval
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tbnd_manual_eval purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tbnd_manual_eval(
    i_code varchar2(45) -- 债券代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,i_name varchar2(150) -- 债券名称
    ,beg_date varchar2(15) -- 估值日期
    ,imp_date varchar2(15) -- 录入日期
    ,price number(10,4) -- 中证估值(净价)
    ,dirty_price number(10,4) -- 中证估值(全价)
    ,mk_mdvbp number(16,6) -- 基点价值
    ,mk_duration number(16,6) -- 修正久期
    ,mk_convexity number(16,6) -- 凸性
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
grant select on ${iol_schema}.ibms_tbnd_manual_eval to ${iml_schema};
grant select on ${iol_schema}.ibms_tbnd_manual_eval to ${icl_schema};
grant select on ${iol_schema}.ibms_tbnd_manual_eval to ${idl_schema};
grant select on ${iol_schema}.ibms_tbnd_manual_eval to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tbnd_manual_eval is '';
comment on column ${iol_schema}.ibms_tbnd_manual_eval.i_code is '债券代码';
comment on column ${iol_schema}.ibms_tbnd_manual_eval.a_type is '资产类型';
comment on column ${iol_schema}.ibms_tbnd_manual_eval.m_type is '市场类型';
comment on column ${iol_schema}.ibms_tbnd_manual_eval.i_name is '债券名称';
comment on column ${iol_schema}.ibms_tbnd_manual_eval.beg_date is '估值日期';
comment on column ${iol_schema}.ibms_tbnd_manual_eval.imp_date is '录入日期';
comment on column ${iol_schema}.ibms_tbnd_manual_eval.price is '中证估值(净价)';
comment on column ${iol_schema}.ibms_tbnd_manual_eval.dirty_price is '中证估值(全价)';
comment on column ${iol_schema}.ibms_tbnd_manual_eval.mk_mdvbp is '基点价值';
comment on column ${iol_schema}.ibms_tbnd_manual_eval.mk_duration is '修正久期';
comment on column ${iol_schema}.ibms_tbnd_manual_eval.mk_convexity is '凸性';
comment on column ${iol_schema}.ibms_tbnd_manual_eval.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_tbnd_manual_eval.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_tbnd_manual_eval.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_tbnd_manual_eval.etl_timestamp is 'ETL处理时间戳';
