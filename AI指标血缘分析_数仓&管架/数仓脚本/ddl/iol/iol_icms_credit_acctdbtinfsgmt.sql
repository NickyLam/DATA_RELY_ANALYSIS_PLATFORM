/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_acctdbtinfsgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_acctdbtinfsgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_acctdbtinfsgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_acctdbtinfsgmt(
    acctstatus varchar2(2) -- 账户状态
    ,remrepprd varchar2(11) -- 剩余还款期数
    ,create_time varchar2(19) -- 入库时间
    ,fivecate varchar2(1) -- 五级分类
    ,rptdate varchar2(19) -- 信息报告日期
    ,deptcode varchar2(14) -- 征信机构代码
    ,acctcode varchar2(60) -- 账户标识码
    ,rpystatus varchar2(1) -- 当前还款状态
    ,fivecateadjdate varchar2(19) -- 五级分类认定日期
    ,totoverd number(24,6) -- 当前逾期总额
    ,cust_no varchar2(64) -- 客户号码
    ,overdprd varchar2(11) -- 当前逾期期数
    ,latrpydate varchar2(19) -- 最近一次实际还款日期
    ,extra_info varchar2(200) -- 扩展字段
    ,top_deptcode varchar2(14) -- 顶级征信机构代码
    ,latrpyamt number(24,6) -- 最近一次实际还款金额
    ,acctbal number(24,6) -- 余额
    ,closedate varchar2(19) -- 账户关闭日期
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
grant select on ${iol_schema}.icms_credit_acctdbtinfsgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_acctdbtinfsgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_acctdbtinfsgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_acctdbtinfsgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_acctdbtinfsgmt is '个人借贷账户记录-非月度表现信息段';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.acctstatus is '账户状态';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.remrepprd is '剩余还款期数';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.fivecate is '五级分类';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.acctcode is '账户标识码';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.rpystatus is '当前还款状态';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.fivecateadjdate is '五级分类认定日期';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.totoverd is '当前逾期总额';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.cust_no is '客户号码';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.overdprd is '当前逾期期数';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.latrpydate is '最近一次实际还款日期';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.extra_info is '扩展字段';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.top_deptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.latrpyamt is '最近一次实际还款金额';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.acctbal is '余额';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.closedate is '账户关闭日期';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_acctdbtinfsgmt.etl_timestamp is 'ETL处理时间戳';
