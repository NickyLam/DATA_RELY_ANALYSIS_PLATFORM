/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_accounting_cash_chg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_accounting_cash_chg
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_accounting_cash_chg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_accounting_cash_chg(
    chg_id varchar2(45) -- 变动id
    ,erase_ref_chg_id varchar2(45) -- 撤销关联变动id
    ,tsk_id varchar2(45) -- 任务id
    ,chg_date varchar2(15) -- 变动日期
    ,chg_type varchar2(30) -- 0：指令生成；1：日生成；2：周期生成。
    ,acctg_obj_id varchar2(45) -- 对象id
    ,inst_id number(16,0) -- 指令id
    ,cash_biz_type varchar2(45) -- 资金指令类型
    ,ext_cash_acct_id varchar2(30) -- 外部资金账户
    ,cash_acct_id varchar2(45) -- 内部资金账户
    ,estd_or_real varchar2(2) -- e：理论核算；r：实际核算。
    ,transf_type varchar2(45) -- 转账方式
    ,currency varchar2(5) -- 币种
    ,real_amount number(31,8) -- 余额
    ,real_margin number(31,8) -- 期货保证金
    ,update_time varchar2(29) -- 更新时间
    ,process varchar2(300) -- 核算过程
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
grant select on ${iol_schema}.ibms_ttrd_accounting_cash_chg to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_cash_chg to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_cash_chg to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_cash_chg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_accounting_cash_chg is '资金核算变动表';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.chg_id is '变动id';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.erase_ref_chg_id is '撤销关联变动id';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.tsk_id is '任务id';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.chg_date is '变动日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.chg_type is '0：指令生成；1：日生成；2：周期生成。';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.acctg_obj_id is '对象id';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.inst_id is '指令id';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.cash_biz_type is '资金指令类型';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.ext_cash_acct_id is '外部资金账户';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.cash_acct_id is '内部资金账户';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.estd_or_real is 'e：理论核算；r：实际核算。';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.transf_type is '转账方式';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.real_amount is '余额';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.real_margin is '期货保证金';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.process is '核算过程';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_accounting_cash_chg.etl_timestamp is 'ETL处理时间戳';
