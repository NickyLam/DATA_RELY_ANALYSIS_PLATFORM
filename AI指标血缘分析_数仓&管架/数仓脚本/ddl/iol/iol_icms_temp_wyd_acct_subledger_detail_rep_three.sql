/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_temp_wyd_acct_subledger_detail_rep_three
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three
whenever sqlerror continue none;
drop table ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three(
    serialno varchar2(32) -- 流水号
    ,transserialno varchar2(32) -- 交易流水号
    ,transcode varchar2(10) -- 交易码
    ,subledgerserialno varchar2(32) -- 分账流水号
    ,relativeobjectno varchar2(32) -- 借据编号
    ,accountingorgid varchar2(40) -- 记账机构
    ,currency varchar2(10) -- 币种
    ,bookdate varchar2(10) -- 发生日期
    ,accountcodeno varchar2(20) -- 系统科目号
    ,exaccountcodeno varchar2(20) -- 银行科目号
    ,amount number(20,2) -- 发生额
    ,direction varchar2(5) -- 余额方向
    ,remark varchar2(4000) -- 描述
    ,debitbalance number(20,2) -- 变化后借方余额
    ,creditbalance number(20,2) -- 变化后贷方余额
    ,odebitbalance number(20,2) -- 变化前借方余额
    ,ocreditbalance number(20,2) -- 变化前贷方余额
    ,subtranscode varchar2(100) -- 交易明细码
    ,remarkcode varchar2(100) -- 描述代码
    ,productid varchar2(20) -- 产品ID
    ,subdetailtype varchar2(30) -- 分录类型
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
grant select on ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three to ${iml_schema};
grant select on ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three to ${icl_schema};
grant select on ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three to ${idl_schema};
grant select on ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three is '分录明细报表中间表03';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.serialno is '流水号';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.transserialno is '交易流水号';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.transcode is '交易码';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.subledgerserialno is '分账流水号';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.relativeobjectno is '借据编号';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.accountingorgid is '记账机构';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.currency is '币种';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.bookdate is '发生日期';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.accountcodeno is '系统科目号';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.exaccountcodeno is '银行科目号';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.amount is '发生额';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.direction is '余额方向';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.remark is '描述';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.debitbalance is '变化后借方余额';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.creditbalance is '变化后贷方余额';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.odebitbalance is '变化前借方余额';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.ocreditbalance is '变化前贷方余额';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.subtranscode is '交易明细码';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.remarkcode is '描述代码';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.productid is '产品ID';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.subdetailtype is '分录类型';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.capitaltransserialno is '资金交易关联流水';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three.etl_timestamp is 'ETL处理时间戳';
