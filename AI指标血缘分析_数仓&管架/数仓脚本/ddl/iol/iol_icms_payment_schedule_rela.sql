/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_payment_schedule_rela
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_payment_schedule_rela
whenever sqlerror continue none;
drop table ${iol_schema}.icms_payment_schedule_rela purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_payment_schedule_rela(
    keyid varchar2(32) -- 主键
    ,repaymentdate date -- 还款计划日期
    ,serialno varchar2(64) -- 流水号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,adjusttype varchar2(30) -- 调整类型
    ,seqid number(38,0) -- 期次
    ,repayinterest number(24,6) -- 计划还款利息
    ,discountcharges number(24,6) -- 贴息
    ,relativeserialno varchar2(32) -- 关联变更申请流水号
    ,transt varchar2(1) -- 核心是否已执行0未执行1已执行
    ,putoutno varchar2(30) -- 出账号
    ,repaycorpus number(24,6) -- 计划还款本金
    ,currency varchar2(3) -- 币种
    ,finishinterest varchar2(10) -- 还本日期是否结息(0-不结息1-结息)
    ,corpusamount number(24,6) -- 本金余额
    ,accountmanageobjectno varchar2(32) -- 关联提前还款申请流水号
    ,duebillno varchar2(30) -- 借据号
    ,realinterest number(24,6) -- 实际利率
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
grant select on ${iol_schema}.icms_payment_schedule_rela to ${iml_schema};
grant select on ${iol_schema}.icms_payment_schedule_rela to ${icl_schema};
grant select on ${iol_schema}.icms_payment_schedule_rela to ${idl_schema};
grant select on ${iol_schema}.icms_payment_schedule_rela to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_payment_schedule_rela is '还款计划变更';
comment on column ${iol_schema}.icms_payment_schedule_rela.keyid is '主键';
comment on column ${iol_schema}.icms_payment_schedule_rela.repaymentdate is '还款计划日期';
comment on column ${iol_schema}.icms_payment_schedule_rela.serialno is '流水号';
comment on column ${iol_schema}.icms_payment_schedule_rela.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_payment_schedule_rela.adjusttype is '调整类型';
comment on column ${iol_schema}.icms_payment_schedule_rela.seqid is '期次';
comment on column ${iol_schema}.icms_payment_schedule_rela.repayinterest is '计划还款利息';
comment on column ${iol_schema}.icms_payment_schedule_rela.discountcharges is '贴息';
comment on column ${iol_schema}.icms_payment_schedule_rela.relativeserialno is '关联变更申请流水号';
comment on column ${iol_schema}.icms_payment_schedule_rela.transt is '核心是否已执行0未执行1已执行';
comment on column ${iol_schema}.icms_payment_schedule_rela.putoutno is '出账号';
comment on column ${iol_schema}.icms_payment_schedule_rela.repaycorpus is '计划还款本金';
comment on column ${iol_schema}.icms_payment_schedule_rela.currency is '币种';
comment on column ${iol_schema}.icms_payment_schedule_rela.finishinterest is '还本日期是否结息(0-不结息1-结息)';
comment on column ${iol_schema}.icms_payment_schedule_rela.corpusamount is '本金余额';
comment on column ${iol_schema}.icms_payment_schedule_rela.accountmanageobjectno is '关联提前还款申请流水号';
comment on column ${iol_schema}.icms_payment_schedule_rela.duebillno is '借据号';
comment on column ${iol_schema}.icms_payment_schedule_rela.realinterest is '实际利率';
comment on column ${iol_schema}.icms_payment_schedule_rela.start_dt is '开始时间';
comment on column ${iol_schema}.icms_payment_schedule_rela.end_dt is '结束时间';
comment on column ${iol_schema}.icms_payment_schedule_rela.id_mark is '增删标志';
comment on column ${iol_schema}.icms_payment_schedule_rela.etl_timestamp is 'ETL处理时间戳';
