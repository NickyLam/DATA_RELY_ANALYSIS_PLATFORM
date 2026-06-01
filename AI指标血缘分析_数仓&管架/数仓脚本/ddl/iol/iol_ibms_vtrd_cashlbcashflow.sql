/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_vtrd_cashlbcashflow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_vtrd_cashlbcashflow
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_vtrd_cashlbcashflow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_cashlbcashflow(
    obj_id varchar2(45) -- 债项编号
    ,paymentdate varchar2(15) -- 还款日期
    ,amount number(31,4) -- 还款金额（本金）
    ,ai number(31,4) -- 还款金额（利息）
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
grant select on ${iol_schema}.ibms_vtrd_cashlbcashflow to ${iml_schema};
grant select on ${iol_schema}.ibms_vtrd_cashlbcashflow to ${icl_schema};
grant select on ${iol_schema}.ibms_vtrd_cashlbcashflow to ${idl_schema};
grant select on ${iol_schema}.ibms_vtrd_cashlbcashflow to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_vtrd_cashlbcashflow is '非标还款现金流计划表';
comment on column ${iol_schema}.ibms_vtrd_cashlbcashflow.obj_id is '债项编号';
comment on column ${iol_schema}.ibms_vtrd_cashlbcashflow.paymentdate is '还款日期';
comment on column ${iol_schema}.ibms_vtrd_cashlbcashflow.amount is '还款金额（本金）';
comment on column ${iol_schema}.ibms_vtrd_cashlbcashflow.ai is '还款金额（利息）';
comment on column ${iol_schema}.ibms_vtrd_cashlbcashflow.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_vtrd_cashlbcashflow.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_vtrd_cashlbcashflow.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_vtrd_cashlbcashflow.etl_timestamp is 'ETL处理时间戳';
