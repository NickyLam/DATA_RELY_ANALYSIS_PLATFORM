/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_acctmthlyblginfsgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_acctmthlyblginfsgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_acctmthlyblginfsgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_acctmthlyblginfsgmt(
    pridacctbal number(24,6) -- 本期账单余额
    ,usedamt number(24,6) -- 已使用额度
    ,overdprd varchar2(11) -- 当前逾期期数
    ,notisubal number(24,6) -- 未出单的大额专项分期余额
    ,fivecateadjdate varchar2(19) -- 五级分类认定日期
    ,ovedrawbaove180 number(24,6) -- 透支180天以上未还余额
    ,create_time varchar2(19) -- 入库时间
    ,cust_no varchar2(64) -- 客户号码
    ,acctbal number(24,6) -- 余额
    ,oved91_180princ number(24,6) -- 逾期91-180天未归还本金
    ,latrpyamt number(24,6) -- 最近一次实际还款金额
    ,deptcode varchar2(14) -- 征信机构代码
    ,currpyamt number(24,6) -- 本月应还款金额
    ,totoverd number(24,6) -- 当前逾期总额
    ,oved61_90princ number(24,6) -- 逾期61-90天未归还本金
    ,settdate varchar2(19) -- 结算/应还款日
    ,acctcode varchar2(60) -- 账户标识码
    ,oved31_60princ number(24,6) -- 逾期31-60天未归还本金
    ,latrpydate varchar2(19) -- 最近一次实际还款日期
    ,top_deptcode varchar2(14) -- 顶级征信机构代码
    ,rptdate varchar2(19) -- 信息报告日期
    ,month varchar2(8) -- 月份
    ,acctstatus varchar2(2) -- 账户状态
    ,actrpyamt number(24,6) -- 本月实际还款金额
    ,rpyprct varchar2(11) -- 实际还款百分比
    ,closedate varchar2(19) -- 账户关闭日期
    ,extra_info varchar2(200) -- 扩展字段
    ,ovedprinc180 number(24,6) -- 逾期180天以上未归还本金
    ,fivecate varchar2(1) -- 五级分类
    ,remrepprd varchar2(11) -- 剩余还款期数
    ,rpystatus varchar2(1) -- 当前还款状态
    ,overdprinc number(24,6) -- 当前逾期本金
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_credit_acctmthlyblginfsgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_acctmthlyblginfsgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_acctmthlyblginfsgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_acctmthlyblginfsgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_acctmthlyblginfsgmt is '个人借贷账户记录-月度表现信息段';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.pridacctbal is '本期账单余额';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.usedamt is '已使用额度';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.overdprd is '当前逾期期数';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.notisubal is '未出单的大额专项分期余额';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.fivecateadjdate is '五级分类认定日期';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.ovedrawbaove180 is '透支180天以上未还余额';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.cust_no is '客户号码';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.acctbal is '余额';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.oved91_180princ is '逾期91-180天未归还本金';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.latrpyamt is '最近一次实际还款金额';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.currpyamt is '本月应还款金额';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.totoverd is '当前逾期总额';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.oved61_90princ is '逾期61-90天未归还本金';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.settdate is '结算/应还款日';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.acctcode is '账户标识码';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.oved31_60princ is '逾期31-60天未归还本金';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.latrpydate is '最近一次实际还款日期';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.top_deptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.month is '月份';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.acctstatus is '账户状态';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.actrpyamt is '本月实际还款金额';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.rpyprct is '实际还款百分比';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.closedate is '账户关闭日期';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.extra_info is '扩展字段';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.ovedprinc180 is '逾期180天以上未归还本金';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.fivecate is '五级分类';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.remrepprd is '剩余还款期数';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.rpystatus is '当前还款状态';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.overdprinc is '当前逾期本金';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_acctmthlyblginfsgmt.etl_timestamp is 'ETL处理时间戳';
