/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_acctbsinfsgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_acctbsinfsgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_acctbsinfsgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_acctbsinfsgmt(
    acctcode varchar2(60) -- 账户标识码
    ,loanform varchar2(1) -- 贷款发放形式
    ,busilines varchar2(4) -- 借贷业务大类
    ,loanamt number(24,6) -- 借款金额
    ,guarmode varchar2(1) -- 担保方式
    ,rptdate varchar2(19) -- 信息报告日期
    ,flag varchar2(1) -- 分次放款标志
    ,assettrandflag varchar2(1) -- 资产转让标志
    ,loanconcode varchar2(200) -- 贷款合同编号
    ,duedate varchar2(19) -- 到期日期
    ,firsthouloanflag varchar2(4) -- 是否为首套住房贷款
    ,create_time varchar2(19) -- 入库时间
    ,deptcode varchar2(14) -- 征信机构代码
    ,creditid varchar2(4) -- 卡片标识号
    ,busidtllines varchar2(4) -- 借贷业务种类细分
    ,applybusidist varchar2(6) -- 业务申请地行政区划代码
    ,acctcredline number(24,6) -- 信用额度
    ,ccy varchar2(3) -- 币种
    ,othrepyguarway varchar2(1) -- 其他还款保证方式
    ,repaymode varchar2(2) -- 还款方式
    ,repayfreqcy varchar2(2) -- 还款频率
    ,opendate varchar2(19) -- 开户日期
    ,repayprd varchar2(11) -- 还款期数
    ,fundsou varchar2(2) -- 业务经营类型
    ,top_deptcode varchar2(14) -- 顶级征信机构代码
    ,cust_no varchar2(64) -- 客户号码
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
grant select on ${iol_schema}.icms_credit_acctbsinfsgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_acctbsinfsgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_acctbsinfsgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_acctbsinfsgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_acctbsinfsgmt is '人民银行个人征信元数据';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.acctcode is '账户标识码';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.loanform is '贷款发放形式';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.busilines is '借贷业务大类';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.loanamt is '借款金额';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.guarmode is '担保方式';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.flag is '分次放款标志';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.assettrandflag is '资产转让标志';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.loanconcode is '贷款合同编号';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.duedate is '到期日期';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.firsthouloanflag is '是否为首套住房贷款';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.creditid is '卡片标识号';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.busidtllines is '借贷业务种类细分';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.applybusidist is '业务申请地行政区划代码';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.acctcredline is '信用额度';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.ccy is '币种';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.othrepyguarway is '其他还款保证方式';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.repaymode is '还款方式';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.repayfreqcy is '还款频率';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.opendate is '开户日期';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.repayprd is '还款期数';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.fundsou is '业务经营类型';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.top_deptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.cust_no is '客户号码';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_acctbsinfsgmt.etl_timestamp is 'ETL处理时间戳';
