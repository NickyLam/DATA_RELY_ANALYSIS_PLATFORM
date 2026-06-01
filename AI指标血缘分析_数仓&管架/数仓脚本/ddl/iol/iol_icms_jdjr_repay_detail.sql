/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_jdjr_repay_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_jdjr_repay_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_jdjr_repay_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_jdjr_repay_detail(
    repayserno varchar2(128) -- 贷款进行交易的流水号(可能存在一天还款多笔)
    ,busmodel varchar2(10) -- 业务模式
    ,prdno varchar2(30) -- 产品编号
    ,currtermpnlt number(26,8) -- 累计应还罚息
    ,migtflag varchar2(80) -- 
    ,termno varchar2(30) -- 分期单号
    ,repaydt varchar2(10) -- 还款日期
    ,repaytype varchar2(2) -- 还款方式
    ,unpayterms number(22) -- 剩余还款期数
    ,realreapyvolfee number(26,8) -- 实还违约金金额
    ,contno varchar2(30) -- 合同号
    ,realrepaypnlt number(26,8) -- 实还罚息金额
    ,limitno varchar2(128) -- 额度编号
    ,realrepayamt number(26,8) -- 实还本金金额
    ,accrepayenchashfee number(26,8) -- 累计应还取现手续费
    ,loanno varchar2(60) -- 贷款编号
    ,currtermamt number(26,8) -- 累计应还本金
    ,realrepayenchashfee number(26,8) -- 实还取现手续费金额
    ,servicefee number(26,8) -- 服务费
    ,mangovdincome number(26,8) -- 资方应收分润逾期收益
    ,prdcode varchar2(20) -- 产品编号（行内）
    ,mangrecfixed number(26,8) -- 资方应收固收
    ,collectfee number(26,8) -- 催收费
    ,ovddays number(22) -- 逾期天数本次还款分期单的逾期天数，无逾期时，值为0
    ,realrepayint number(26,8) -- 实还利息金额
    ,repayterms number(22) -- 还款期数
    ,repaymodel varchar2(10) -- 还款类型
    ,mangnorincome number(26,8) -- 资方应收分润正常收益
    ,bussdate varchar2(10) -- 业务日期
    ,accrepayvolfee number(26,8) -- 累计应还违约金
    ,currtermint number(26,8) -- 累计应还利息
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
grant select on ${iol_schema}.icms_jdjr_repay_detail to ${iml_schema};
grant select on ${iol_schema}.icms_jdjr_repay_detail to ${icl_schema};
grant select on ${iol_schema}.icms_jdjr_repay_detail to ${idl_schema};
grant select on ${iol_schema}.icms_jdjr_repay_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_jdjr_repay_detail is '京东还款明细';
comment on column ${iol_schema}.icms_jdjr_repay_detail.repayserno is '贷款进行交易的流水号(可能存在一天还款多笔)';
comment on column ${iol_schema}.icms_jdjr_repay_detail.busmodel is '业务模式';
comment on column ${iol_schema}.icms_jdjr_repay_detail.prdno is '产品编号';
comment on column ${iol_schema}.icms_jdjr_repay_detail.currtermpnlt is '累计应还罚息';
comment on column ${iol_schema}.icms_jdjr_repay_detail.migtflag is '';
comment on column ${iol_schema}.icms_jdjr_repay_detail.termno is '分期单号';
comment on column ${iol_schema}.icms_jdjr_repay_detail.repaydt is '还款日期';
comment on column ${iol_schema}.icms_jdjr_repay_detail.repaytype is '还款方式';
comment on column ${iol_schema}.icms_jdjr_repay_detail.unpayterms is '剩余还款期数';
comment on column ${iol_schema}.icms_jdjr_repay_detail.realreapyvolfee is '实还违约金金额';
comment on column ${iol_schema}.icms_jdjr_repay_detail.contno is '合同号';
comment on column ${iol_schema}.icms_jdjr_repay_detail.realrepaypnlt is '实还罚息金额';
comment on column ${iol_schema}.icms_jdjr_repay_detail.limitno is '额度编号';
comment on column ${iol_schema}.icms_jdjr_repay_detail.realrepayamt is '实还本金金额';
comment on column ${iol_schema}.icms_jdjr_repay_detail.accrepayenchashfee is '累计应还取现手续费';
comment on column ${iol_schema}.icms_jdjr_repay_detail.loanno is '贷款编号';
comment on column ${iol_schema}.icms_jdjr_repay_detail.currtermamt is '累计应还本金';
comment on column ${iol_schema}.icms_jdjr_repay_detail.realrepayenchashfee is '实还取现手续费金额';
comment on column ${iol_schema}.icms_jdjr_repay_detail.servicefee is '服务费';
comment on column ${iol_schema}.icms_jdjr_repay_detail.mangovdincome is '资方应收分润逾期收益';
comment on column ${iol_schema}.icms_jdjr_repay_detail.prdcode is '产品编号（行内）';
comment on column ${iol_schema}.icms_jdjr_repay_detail.mangrecfixed is '资方应收固收';
comment on column ${iol_schema}.icms_jdjr_repay_detail.collectfee is '催收费';
comment on column ${iol_schema}.icms_jdjr_repay_detail.ovddays is '逾期天数本次还款分期单的逾期天数，无逾期时，值为0';
comment on column ${iol_schema}.icms_jdjr_repay_detail.realrepayint is '实还利息金额';
comment on column ${iol_schema}.icms_jdjr_repay_detail.repayterms is '还款期数';
comment on column ${iol_schema}.icms_jdjr_repay_detail.repaymodel is '还款类型';
comment on column ${iol_schema}.icms_jdjr_repay_detail.mangnorincome is '资方应收分润正常收益';
comment on column ${iol_schema}.icms_jdjr_repay_detail.bussdate is '业务日期';
comment on column ${iol_schema}.icms_jdjr_repay_detail.accrepayvolfee is '累计应还违约金';
comment on column ${iol_schema}.icms_jdjr_repay_detail.currtermint is '累计应还利息';
comment on column ${iol_schema}.icms_jdjr_repay_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_jdjr_repay_detail.etl_timestamp is 'ETL处理时间戳';
