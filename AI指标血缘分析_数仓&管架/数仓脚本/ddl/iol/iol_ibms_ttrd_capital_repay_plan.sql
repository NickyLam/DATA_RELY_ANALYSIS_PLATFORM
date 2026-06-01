/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_capital_repay_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_capital_repay_plan
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_capital_repay_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_capital_repay_plan(
    i_code varchar2(48) -- 金融工具代码
    ,a_type varchar2(45) -- 资产类型
    ,m_type varchar2(45) -- 市场类型
    ,amount number(16,2) -- 还本金额
    ,repay_date varchar2(30) -- 还款日期
    ,repay_type varchar2(2) -- 还款类型0：还本1：付息
    ,remark varchar2(383) -- 备注
    ,ai number(16,2) -- 偿还利息(元)
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
grant select on ${iol_schema}.ibms_ttrd_capital_repay_plan to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_capital_repay_plan to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_capital_repay_plan to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_capital_repay_plan to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_capital_repay_plan is '还本计划表';
comment on column ${iol_schema}.ibms_ttrd_capital_repay_plan.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_capital_repay_plan.a_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_capital_repay_plan.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_capital_repay_plan.amount is '还本金额';
comment on column ${iol_schema}.ibms_ttrd_capital_repay_plan.repay_date is '还款日期';
comment on column ${iol_schema}.ibms_ttrd_capital_repay_plan.repay_type is '还款类型0：还本1：付息';
comment on column ${iol_schema}.ibms_ttrd_capital_repay_plan.remark is '备注';
comment on column ${iol_schema}.ibms_ttrd_capital_repay_plan.ai is '偿还利息(元)';
comment on column ${iol_schema}.ibms_ttrd_capital_repay_plan.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_capital_repay_plan.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_capital_repay_plan.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_capital_repay_plan.etl_timestamp is 'ETL处理时间戳';
