/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wld_tm_schedule
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wld_tm_schedule
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wld_tm_schedule purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wld_tm_schedule(
    scheduleid number(20) -- 分配表id
    ,loanid number(20) -- 贷款计划id
    ,org varchar2(12) -- 机构号
    ,acctno number(20) -- 账户编号
    ,accttype varchar2(1) -- 账户类型
    ,logicalcardno varchar2(19) -- 逻辑卡号
    ,cardno varchar2(19) -- 卡号
    ,loaninitprin number(15,2) -- 贷款总本金
    ,loaninitterm number(38) -- 贷款总期数
    ,currterm number(38) -- 当前期数
    ,loantermprin number(15,2) -- 应还本金
    ,loantermfee1 number(15,2) -- 应还费用
    ,loantermintegererest number(15,2) -- 应还利息
    ,loanpmtduedate date -- 到款到期还款日期
    ,loangracedate date -- 宽限日
    ,lastmodifieddatetime date -- 修改时间
    ,startdate date -- 起息日
    ,scheduleaction varchar2(1) -- 还款计划操作动作
    ,prinpaid number(15,2) -- 已偿还本金
    ,integerpaid number(15,2) -- 已偿还利息
    ,penaltypaid number(15,2) -- 已偿还罚息
    ,compoundpaid number(15,2) -- 已偿还复利
    ,feepaid number(15,2) -- 已偿还费用
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
grant select on ${iol_schema}.icms_wld_tm_schedule to ${iml_schema};
grant select on ${iol_schema}.icms_wld_tm_schedule to ${icl_schema};
grant select on ${iol_schema}.icms_wld_tm_schedule to ${idl_schema};
grant select on ${iol_schema}.icms_wld_tm_schedule to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wld_tm_schedule is '微粒贷贷款分配表';
comment on column ${iol_schema}.icms_wld_tm_schedule.scheduleid is '分配表id';
comment on column ${iol_schema}.icms_wld_tm_schedule.loanid is '贷款计划id';
comment on column ${iol_schema}.icms_wld_tm_schedule.org is '机构号';
comment on column ${iol_schema}.icms_wld_tm_schedule.acctno is '账户编号';
comment on column ${iol_schema}.icms_wld_tm_schedule.accttype is '账户类型';
comment on column ${iol_schema}.icms_wld_tm_schedule.logicalcardno is '逻辑卡号';
comment on column ${iol_schema}.icms_wld_tm_schedule.cardno is '卡号';
comment on column ${iol_schema}.icms_wld_tm_schedule.loaninitprin is '贷款总本金';
comment on column ${iol_schema}.icms_wld_tm_schedule.loaninitterm is '贷款总期数';
comment on column ${iol_schema}.icms_wld_tm_schedule.currterm is '当前期数';
comment on column ${iol_schema}.icms_wld_tm_schedule.loantermprin is '应还本金';
comment on column ${iol_schema}.icms_wld_tm_schedule.loantermfee1 is '应还费用';
comment on column ${iol_schema}.icms_wld_tm_schedule.loantermintegererest is '应还利息';
comment on column ${iol_schema}.icms_wld_tm_schedule.loanpmtduedate is '到款到期还款日期';
comment on column ${iol_schema}.icms_wld_tm_schedule.loangracedate is '宽限日';
comment on column ${iol_schema}.icms_wld_tm_schedule.lastmodifieddatetime is '修改时间';
comment on column ${iol_schema}.icms_wld_tm_schedule.startdate is '起息日';
comment on column ${iol_schema}.icms_wld_tm_schedule.scheduleaction is '还款计划操作动作';
comment on column ${iol_schema}.icms_wld_tm_schedule.prinpaid is '已偿还本金';
comment on column ${iol_schema}.icms_wld_tm_schedule.integerpaid is '已偿还利息';
comment on column ${iol_schema}.icms_wld_tm_schedule.penaltypaid is '已偿还罚息';
comment on column ${iol_schema}.icms_wld_tm_schedule.compoundpaid is '已偿还复利';
comment on column ${iol_schema}.icms_wld_tm_schedule.feepaid is '已偿还费用';
comment on column ${iol_schema}.icms_wld_tm_schedule.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wld_tm_schedule.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wld_tm_schedule.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wld_tm_schedule.etl_timestamp is 'ETL处理时间戳';
