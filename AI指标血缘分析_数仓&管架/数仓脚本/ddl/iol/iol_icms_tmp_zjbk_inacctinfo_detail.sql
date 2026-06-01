/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tmp_zjbk_inacctinfo_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail(
    mngmtorgcode varchar2(14) -- 业务管理机构代码
    ,acctcode varchar2(60) -- 账户标识码
    ,rptdate varchar2(32) -- 信息报告日期
    ,rptdatecode varchar2(4) -- 信息报告时点
    ,contractno varchar2(60) -- 借据号
    ,loanamt varchar2(32) -- 借款金额
    ,duedate varchar2(32) -- 到期日期
    ,month varchar2(8) -- 月份
    ,contractstatus varchar2(10) -- 借据状态
    ,acctbal varchar2(32) -- 余额，本金余额
    ,remrepprd varchar2(32) -- 剩余还款期数
    ,fivecate varchar2(2) -- 五级分类
    ,overddays varchar2(32) -- 当前逾期天数
    ,overdprd varchar2(32) -- 当前逾期期数
    ,totoverd varchar2(32) -- 当前逾期总额
    ,overdprinc varchar2(32) -- 当前逾期本金
    ,oved31_60princ varchar2(32) -- 逾期31-60天未归还本金
    ,oved61_90princ varchar2(32) -- 逾期61-90天未归还本金
    ,oved91_180princ varchar2(32) -- 逾期91-180天未归还本金
    ,ovedprinc180 varchar2(32) -- 逾期180天以上未归还本金
    ,ovedrawbaove180 varchar2(32) -- 透支180天以上未还余额
    ,currpyamt varchar2(32) -- 本月应还款金额 ，该借据报送的本期应还金额
    ,actrpyamt varchar2(32) -- 本月实际还款金额，该借据报送的本期实还金额
    ,latrpyamt varchar2(32) -- 该借据的最近一次还款金额
    ,latrpydate varchar2(32) -- 最近一次还款时间
    ,fivecateadjdate varchar2(64) -- 五级分类认定日期
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
grant select on ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail to ${iml_schema};
grant select on ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail to ${icl_schema};
grant select on ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail to ${idl_schema};
grant select on ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail is '人行征信文件中间数据-个人借贷账户信息记录明细数据';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.mngmtorgcode is '业务管理机构代码';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.acctcode is '账户标识码';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.rptdatecode is '信息报告时点';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.contractno is '借据号';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.loanamt is '借款金额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.duedate is '到期日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.month is '月份';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.contractstatus is '借据状态';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.acctbal is '余额，本金余额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.remrepprd is '剩余还款期数';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.fivecate is '五级分类';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.overddays is '当前逾期天数';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.overdprd is '当前逾期期数';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.totoverd is '当前逾期总额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.overdprinc is '当前逾期本金';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.oved31_60princ is '逾期31-60天未归还本金';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.oved61_90princ is '逾期61-90天未归还本金';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.oved91_180princ is '逾期91-180天未归还本金';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.ovedprinc180 is '逾期180天以上未归还本金';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.ovedrawbaove180 is '透支180天以上未还余额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.currpyamt is '本月应还款金额 ，该借据报送的本期应还金额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.actrpyamt is '本月实际还款金额，该借据报送的本期实还金额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.latrpyamt is '该借据的最近一次还款金额';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.latrpydate is '最近一次还款时间';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.fivecateadjdate is '五级分类认定日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail.etl_timestamp is 'ETL处理时间戳';
