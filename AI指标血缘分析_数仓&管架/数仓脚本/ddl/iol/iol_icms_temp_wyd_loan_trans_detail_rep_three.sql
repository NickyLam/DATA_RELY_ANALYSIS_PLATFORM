/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_temp_wyd_loan_trans_detail_rep_three
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three
whenever sqlerror continue none;
drop table ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three(
    orgid varchar2(20) -- 机构号
    ,serialno varchar2(40) -- 交易流水号
    ,oldtransserialno varchar2(40) -- 原交易流水号
    ,bizseq varchar2(40) -- 业务流水号
    ,txndate varchar2(10) -- 交易日期
    ,loanno varchar2(64) -- 借据号
    ,currency varchar2(10) -- 币种
    ,txncode varchar2(10) -- 交易码
    ,txndesc varchar2(4000) -- 交易描述
    ,postamt number(22,4) -- 交易金额
    ,txntime varchar2(20) -- 交易时间
    ,postdate varchar2(10) -- 入账日期
    ,youracctno varchar2(40) -- 对方账号
    ,youracctname varchar2(100) -- 对方户名
    ,yourbankid varchar2(40) -- 对方行号
    ,transflag varchar2(1) -- 冲补抹标志
    ,payeeacct varchar2(40) -- 收款人账号
    ,payeename varchar2(100) -- 收款人名称
    ,payeebrno varchar2(40) -- 收款人开户行行号
    ,payeebrname varchar2(100) -- 收款人开户行名称
    ,settleid varchar2(100) -- 还款清算交易编号
    ,accttype varchar2(10) -- 账户类型
    ,capitaltransserialno varchar2(40) -- 资金交易关联流水
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
grant select on ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three to ${iml_schema};
grant select on ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three to ${icl_schema};
grant select on ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three to ${idl_schema};
grant select on ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three is '贷款交易流水报表中间表03';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.orgid is '机构号';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.serialno is '交易流水号';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.oldtransserialno is '原交易流水号';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.bizseq is '业务流水号';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.txndate is '交易日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.loanno is '借据号';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.currency is '币种';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.txncode is '交易码';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.txndesc is '交易描述';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.postamt is '交易金额';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.txntime is '交易时间';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.postdate is '入账日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.youracctno is '对方账号';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.youracctname is '对方户名';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.yourbankid is '对方行号';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.transflag is '冲补抹标志';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.payeeacct is '收款人账号';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.payeename is '收款人名称';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.payeebrno is '收款人开户行行号';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.payeebrname is '收款人开户行名称';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.settleid is '还款清算交易编号';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.accttype is '账户类型';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.capitaltransserialno is '资金交易关联流水';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three.etl_timestamp is 'ETL处理时间戳';
