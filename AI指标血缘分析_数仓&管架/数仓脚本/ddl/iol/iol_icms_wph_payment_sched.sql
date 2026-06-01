/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wph_payment_sched
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wph_payment_sched
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wph_payment_sched purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_payment_sched(
    trandate varchar2(10) -- 交易日期
    ,internalkey varchar2(50) -- 借据号
    ,prodtype varchar2(50) -- 产品类型
    ,stageno number(5,0) -- 期次
    ,ccy varchar2(3) -- 币种
    ,schedamt number(17,2) -- 应还总金额
    ,priamt number(17,2) -- 应还本金金额
    ,intamt number(17,2) -- 应还利息金额
    ,odpamt number(17,2) -- 应还罚息金额
    ,odiamt number(17,2) -- 应还复利金额
    ,startdate varchar2(10) -- 起始日期
    ,enddate varchar2(10) -- 终止日期
    ,graceperioddate varchar2(10) -- 宽限日期
    ,schedpaid number(17,2) -- 实还总金额
    ,pripaid number(17,2) -- 实还本金金额
    ,intpaid number(17,2) -- 实还利息金额
    ,odppaid number(17,2) -- 实还罚息金额
    ,odipaid number(17,2) -- 实还复利金额
    ,periodstatus varchar2(3) -- 期次状态
    ,perdueday number(5,0) -- 逾期天数
    ,settledate varchar2(10) -- 结清日期
    ,schedbal number(17,2) -- 当期总余额
    ,pribal number(17,2) -- 当期本金余额
    ,intbal number(17,2) -- 当期利息余额
    ,odpbal number(17,2) -- 当期罚息余额
    ,odibal number(17,2) -- 当期复利余额
    ,inputdate date -- 登记日期
    ,bizdate varchar2(10) -- 流程日期
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
grant select on ${iol_schema}.icms_wph_payment_sched to ${iml_schema};
grant select on ${iol_schema}.icms_wph_payment_sched to ${icl_schema};
grant select on ${iol_schema}.icms_wph_payment_sched to ${idl_schema};
grant select on ${iol_schema}.icms_wph_payment_sched to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wph_payment_sched is '唯品消金还款计划表';
comment on column ${iol_schema}.icms_wph_payment_sched.trandate is '交易日期';
comment on column ${iol_schema}.icms_wph_payment_sched.internalkey is '借据号';
comment on column ${iol_schema}.icms_wph_payment_sched.prodtype is '产品类型';
comment on column ${iol_schema}.icms_wph_payment_sched.stageno is '期次';
comment on column ${iol_schema}.icms_wph_payment_sched.ccy is '币种';
comment on column ${iol_schema}.icms_wph_payment_sched.schedamt is '应还总金额';
comment on column ${iol_schema}.icms_wph_payment_sched.priamt is '应还本金金额';
comment on column ${iol_schema}.icms_wph_payment_sched.intamt is '应还利息金额';
comment on column ${iol_schema}.icms_wph_payment_sched.odpamt is '应还罚息金额';
comment on column ${iol_schema}.icms_wph_payment_sched.odiamt is '应还复利金额';
comment on column ${iol_schema}.icms_wph_payment_sched.startdate is '起始日期';
comment on column ${iol_schema}.icms_wph_payment_sched.enddate is '终止日期';
comment on column ${iol_schema}.icms_wph_payment_sched.graceperioddate is '宽限日期';
comment on column ${iol_schema}.icms_wph_payment_sched.schedpaid is '实还总金额';
comment on column ${iol_schema}.icms_wph_payment_sched.pripaid is '实还本金金额';
comment on column ${iol_schema}.icms_wph_payment_sched.intpaid is '实还利息金额';
comment on column ${iol_schema}.icms_wph_payment_sched.odppaid is '实还罚息金额';
comment on column ${iol_schema}.icms_wph_payment_sched.odipaid is '实还复利金额';
comment on column ${iol_schema}.icms_wph_payment_sched.periodstatus is '期次状态';
comment on column ${iol_schema}.icms_wph_payment_sched.perdueday is '逾期天数';
comment on column ${iol_schema}.icms_wph_payment_sched.settledate is '结清日期';
comment on column ${iol_schema}.icms_wph_payment_sched.schedbal is '当期总余额';
comment on column ${iol_schema}.icms_wph_payment_sched.pribal is '当期本金余额';
comment on column ${iol_schema}.icms_wph_payment_sched.intbal is '当期利息余额';
comment on column ${iol_schema}.icms_wph_payment_sched.odpbal is '当期罚息余额';
comment on column ${iol_schema}.icms_wph_payment_sched.odibal is '当期复利余额';
comment on column ${iol_schema}.icms_wph_payment_sched.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wph_payment_sched.bizdate is '流程日期';
comment on column ${iol_schema}.icms_wph_payment_sched.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wph_payment_sched.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wph_payment_sched.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wph_payment_sched.etl_timestamp is 'ETL处理时间戳';
