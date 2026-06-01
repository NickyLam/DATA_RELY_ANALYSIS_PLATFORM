/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_temp_wyd_loan_detail_rep_three
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_temp_wyd_loan_detail_rep_three
whenever sqlerror continue none;
drop table ${iol_schema}.icms_temp_wyd_loan_detail_rep_three purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_temp_wyd_loan_detail_rep_three(
    ietmcd varchar2(20) -- 科目号
    ,orgid varchar2(20) -- 机构号
    ,loanno varchar2(64) -- 主借据号
    ,contractno varchar2(64) -- 合同编号
    ,applyno varchar2(64) -- 申请号
    ,ccif varchar2(40) -- 客户号
    ,loanpurpose varchar2(200) -- 投向行业
    ,startdate varchar2(10) -- 发放日期
    ,maturitydate varchar2(10) -- 到期日期
    ,schmaturitydate varchar2(10) -- 约定到期日期
    ,graceperiod varchar2(11) -- 宽限期
    ,rate number(24,6) -- 执行利率
    ,baserate number(12,4) -- 基准利率
    ,currency varchar2(10) -- 币种
    ,amount number(20,4) -- 发放金额
    ,balance number(20,4) -- 贷款余额
    ,paymentfeq varchar2(10) -- 还款频率
    ,payway varchar2(10) -- 支付方式
    ,repricingdate varchar2(10) -- 下一利率重定价日
    ,ratetype varchar2(10) -- 利率类型
    ,overduedays varchar2(11) -- 逾期天数
    ,interest number(20,4) -- 应收利息
    ,prinoddate varchar2(10) -- 本金逾期日期
    ,prinodamt number(24,4) -- 欠本金额
    ,intoddate varchar2(10) -- 利息逾期日期
    ,intodamt number(20,4) -- 欠息金额
    ,poverdueamt number(20,4) -- 逾期总金额
    ,pcanceldate varchar2(10) -- 撤销日期
    ,pinitterm varchar2(11) -- 总期数
    ,activatedate varchar2(10) -- 入账日期
    ,pcurrterm varchar2(11) -- 当前期数
    ,paidoutdate varchar2(10) -- 结清日期
    ,extensionflg varchar2(2) -- 是否展期
    ,extensionamt number(20,4) -- 展期金额
    ,extensionstart varchar2(10) -- 展期起始日期
    ,extensionmaturity varchar2(10) -- 展期到期日期
    ,recomflg varchar2(2) -- 是否重组贷款
    ,recomdate varchar2(10) -- 重组日期
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
grant select on ${iol_schema}.icms_temp_wyd_loan_detail_rep_three to ${iml_schema};
grant select on ${iol_schema}.icms_temp_wyd_loan_detail_rep_three to ${icl_schema};
grant select on ${iol_schema}.icms_temp_wyd_loan_detail_rep_three to ${idl_schema};
grant select on ${iol_schema}.icms_temp_wyd_loan_detail_rep_three to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_temp_wyd_loan_detail_rep_three is '贷款表内明细信息报表中间表03';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.ietmcd is '科目号';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.orgid is '机构号';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.loanno is '主借据号';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.contractno is '合同编号';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.applyno is '申请号';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.ccif is '客户号';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.loanpurpose is '投向行业';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.startdate is '发放日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.maturitydate is '到期日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.schmaturitydate is '约定到期日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.graceperiod is '宽限期';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.rate is '执行利率';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.baserate is '基准利率';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.currency is '币种';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.amount is '发放金额';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.balance is '贷款余额';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.paymentfeq is '还款频率';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.payway is '支付方式';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.repricingdate is '下一利率重定价日';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.ratetype is '利率类型';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.overduedays is '逾期天数';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.interest is '应收利息';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.prinoddate is '本金逾期日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.prinodamt is '欠本金额';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.intoddate is '利息逾期日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.intodamt is '欠息金额';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.poverdueamt is '逾期总金额';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.pcanceldate is '撤销日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.pinitterm is '总期数';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.activatedate is '入账日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.pcurrterm is '当前期数';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.paidoutdate is '结清日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.extensionflg is '是否展期';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.extensionamt is '展期金额';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.extensionstart is '展期起始日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.extensionmaturity is '展期到期日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.recomflg is '是否重组贷款';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.recomdate is '重组日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_detail_rep_three.etl_timestamp is 'ETL处理时间戳';
