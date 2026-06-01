/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_temp_wyd_loan_rep_three
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_temp_wyd_loan_rep_three
whenever sqlerror continue none;
drop table ${iol_schema}.icms_temp_wyd_loan_rep_three purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_temp_wyd_loan_rep_three(
    orgid varchar2(10) -- 合作机构号
    ,busisno varchar2(32) -- 提款准入流水
    ,ccif varchar2(64) -- 客户号
    ,custtype varchar2(10) -- 客户类型
    ,loanno varchar2(64) -- 主借据号
    ,customername varchar2(400) -- 客户姓名
    ,termdate varchar2(4) -- 贷款期限
    ,putoutdate varchar2(8) -- 起始日期
    ,maturity varchar2(8) -- 到期日期
    ,tremmonth varchar2(4) -- 期限月
    ,currency varchar2(3) -- 币种
    ,businesssum number(16,2) -- 贷款金额
    ,balance number(16,2) -- 贷款余额
    ,businessrate number(24,6) -- 贷款利率
    ,overduefine number(24,6) -- 逾期利率
    ,startinterestdate varchar2(8) -- 起息日
    ,payday varchar2(2) -- 还款日
    ,loanstatus varchar2(10) -- 贷款状态
    ,productid varchar2(20) -- 核算产品号
    ,composedproductid varchar2(20) -- 组合产品号
    ,projectid varchar2(20) -- 项目编号
    ,writeoffdate varchar2(10) -- 核销日期
    ,finishdate varchar2(10) -- 结清日期
    ,corpuspaymethod varchar2(20) -- 还款方式
    ,payacctno varchar2(40) -- 贷款还款账号
    ,payacctnoname varchar2(200) -- 贷款还款账号名称
    ,payacctbankno varchar2(40) -- 贷款还款行号
    ,payacctbank varchar2(200) -- 贷款还款行名
    ,inacctno varchar2(40) -- 贷款入账账号
    ,inacctnoname varchar2(200) -- 贷款入账账号名称
    ,inacctbankno varchar2(40) -- 贷款入账行号
    ,inacctbank varchar2(200) -- 贷款入账行名
    ,lprbaserate number(16,6) -- lpr基准利率
    ,participantratio number(24,6) -- 合作方出资比例
    ,loanusage varchar2(4) -- 贷款用途
    ,recommender varchar2(50) -- 推荐人
    ,guaranteeflag varchar2(4) -- 中小担标志
    ,loanchangefrequency varchar2(3) -- 延期还款次数
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
grant select on ${iol_schema}.icms_temp_wyd_loan_rep_three to ${iml_schema};
grant select on ${iol_schema}.icms_temp_wyd_loan_rep_three to ${icl_schema};
grant select on ${iol_schema}.icms_temp_wyd_loan_rep_three to ${idl_schema};
grant select on ${iol_schema}.icms_temp_wyd_loan_rep_three to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_temp_wyd_loan_rep_three is '贷款主文件报表中间表03';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.orgid is '合作机构号';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.busisno is '提款准入流水';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.ccif is '客户号';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.custtype is '客户类型';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.loanno is '主借据号';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.customername is '客户姓名';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.termdate is '贷款期限';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.putoutdate is '起始日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.maturity is '到期日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.tremmonth is '期限月';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.currency is '币种';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.businesssum is '贷款金额';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.balance is '贷款余额';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.businessrate is '贷款利率';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.overduefine is '逾期利率';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.startinterestdate is '起息日';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.payday is '还款日';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.loanstatus is '贷款状态';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.productid is '核算产品号';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.composedproductid is '组合产品号';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.projectid is '项目编号';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.writeoffdate is '核销日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.finishdate is '结清日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.corpuspaymethod is '还款方式';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.payacctno is '贷款还款账号';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.payacctnoname is '贷款还款账号名称';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.payacctbankno is '贷款还款行号';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.payacctbank is '贷款还款行名';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.inacctno is '贷款入账账号';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.inacctnoname is '贷款入账账号名称';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.inacctbankno is '贷款入账行号';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.inacctbank is '贷款入账行名';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.lprbaserate is 'lpr基准利率';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.participantratio is '合作方出资比例';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.loanusage is '贷款用途';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.recommender is '推荐人';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.guaranteeflag is '中小担标志';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.loanchangefrequency is '延期还款次数';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_rep_three.etl_timestamp is 'ETL处理时间戳';
