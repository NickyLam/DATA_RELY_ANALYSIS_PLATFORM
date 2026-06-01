/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_vtrd_cashlbcashflow_his
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_vtrd_cashlbcashflow_his
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_vtrd_cashlbcashflow_his purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_cashlbcashflow_his(
    obj_id varchar2(45) -- 债项编号
    ,paymentdate varchar2(30) -- 还款日期
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
grant select on ${iol_schema}.ibms_vtrd_cashlbcashflow_his to ${iml_schema};
grant select on ${iol_schema}.ibms_vtrd_cashlbcashflow_his to ${icl_schema};
grant select on ${iol_schema}.ibms_vtrd_cashlbcashflow_his to ${idl_schema};
grant select on ${iol_schema}.ibms_vtrd_cashlbcashflow_his to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_vtrd_cashlbcashflow_his is '非标历史还款现金流表';
comment on column ${iol_schema}.ibms_vtrd_cashlbcashflow_his.obj_id is '债项编号';
comment on column ${iol_schema}.ibms_vtrd_cashlbcashflow_his.paymentdate is '还款日期';
comment on column ${iol_schema}.ibms_vtrd_cashlbcashflow_his.amount is '还款金额（本金）';
comment on column ${iol_schema}.ibms_vtrd_cashlbcashflow_his.ai is '还款金额（利息）';
comment on column ${iol_schema}.ibms_vtrd_cashlbcashflow_his.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_vtrd_cashlbcashflow_his.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_vtrd_cashlbcashflow_his.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_vtrd_cashlbcashflow_his.etl_timestamp is 'ETL处理时间戳';
