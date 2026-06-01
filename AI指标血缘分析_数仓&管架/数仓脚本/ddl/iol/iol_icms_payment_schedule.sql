/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_payment_schedule
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_payment_schedule
whenever sqlerror continue none;
drop table ${iol_schema}.icms_payment_schedule purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_payment_schedule(
    serialno varchar2(40) -- 流水号
    ,accountmanageobjectno varchar2(32) -- 关联提前还款申请流水号
    ,subrepaytype varchar2(9) -- 子还款方式
    ,putoutno varchar2(30) -- 出账号
    ,repaymentdate varchar2(20) -- 还款计划日期
    ,repaycorpus number(24,6) -- 计划还款本金
    ,begindate varchar2(20) -- 业务开始日期
    ,adjusttype varchar2(30) -- 调整类型
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,duebillno varchar2(30) -- 借据号
    ,finishinterest varchar2(10) -- 是否结息
    ,realinterest number(24,6) -- 实际利率
    ,discountcharges number(24,6) -- 贴息
    ,seqid number(22) -- 期次
    ,currency varchar2(30) -- 币种
    ,corpusamount number(24,6) -- 本金余额
    ,repayinterest number(24,6) -- 计划还款利息
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
grant select on ${iol_schema}.icms_payment_schedule to ${iml_schema};
grant select on ${iol_schema}.icms_payment_schedule to ${icl_schema};
grant select on ${iol_schema}.icms_payment_schedule to ${idl_schema};
grant select on ${iol_schema}.icms_payment_schedule to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_payment_schedule is '还款计划';
comment on column ${iol_schema}.icms_payment_schedule.serialno is '流水号';
comment on column ${iol_schema}.icms_payment_schedule.accountmanageobjectno is '关联提前还款申请流水号';
comment on column ${iol_schema}.icms_payment_schedule.subrepaytype is '子还款方式';
comment on column ${iol_schema}.icms_payment_schedule.putoutno is '出账号';
comment on column ${iol_schema}.icms_payment_schedule.repaymentdate is '还款计划日期';
comment on column ${iol_schema}.icms_payment_schedule.repaycorpus is '计划还款本金';
comment on column ${iol_schema}.icms_payment_schedule.begindate is '业务开始日期';
comment on column ${iol_schema}.icms_payment_schedule.adjusttype is '调整类型';
comment on column ${iol_schema}.icms_payment_schedule.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_payment_schedule.duebillno is '借据号';
comment on column ${iol_schema}.icms_payment_schedule.finishinterest is '是否结息';
comment on column ${iol_schema}.icms_payment_schedule.realinterest is '实际利率';
comment on column ${iol_schema}.icms_payment_schedule.discountcharges is '贴息';
comment on column ${iol_schema}.icms_payment_schedule.seqid is '期次';
comment on column ${iol_schema}.icms_payment_schedule.currency is '币种';
comment on column ${iol_schema}.icms_payment_schedule.corpusamount is '本金余额';
comment on column ${iol_schema}.icms_payment_schedule.repayinterest is '计划还款利息';
comment on column ${iol_schema}.icms_payment_schedule.start_dt is '开始时间';
comment on column ${iol_schema}.icms_payment_schedule.end_dt is '结束时间';
comment on column ${iol_schema}.icms_payment_schedule.id_mark is '增删标志';
comment on column ${iol_schema}.icms_payment_schedule.etl_timestamp is 'ETL处理时间戳';
