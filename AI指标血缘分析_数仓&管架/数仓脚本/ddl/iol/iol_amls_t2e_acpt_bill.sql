/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t2e_acpt_bill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t2e_acpt_bill
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t2e_acpt_bill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2e_acpt_bill(
    acpt_id varchar2(96) -- 承兑编号
    ,acct_id varchar2(96) -- 账户编号
    ,contract_no varchar2(96) -- 合同编号
    ,org_id varchar2(30) -- 营业机构
    ,acct_org_id varchar2(30) -- 账务机构
    ,subject_id varchar2(15) -- 科目编号
    ,bill_seq varchar2(9) -- 组内序号
    ,bill_no varchar2(60) -- 票据号码
    ,curr_cd varchar2(5) -- 币种
    ,bill_amt number(30,4) -- 票面金额
    ,issue_dt varchar2(15) -- 出票日期
    ,due_dt varchar2(15) -- 到期日期
    ,cust_id varchar2(48) -- 出票人客户编号
    ,cust_name varchar2(768) -- 出票人客户名称
    ,guar_acct_id varchar2(96) -- 保证金账户编号
    ,guar_ratio number(9,4) -- 保证金比例
    ,guar_amt number(30,4) -- 保证金金额
    ,rcv_org_type varchar2(3) -- 收款人行号类型
    ,rcv_org_id varchar2(30) -- 收款人行号
    ,rcv_org_name varchar2(192) -- 收款人行名
    ,rcv_acct_id varchar2(96) -- 收款人账户编号
    ,pay_dt varchar2(15) -- 付款日期
    ,close_dt varchar2(15) -- 核销日期
    ,is_trans varchar2(2) -- 是否可转让（参见[字典:aml0095]）
    ,bill_sts varchar2(6) -- 票据状态（参见[字典:aml0098]）
    ,bill_opr_id varchar2(48) -- 操作员
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
grant select on ${iol_schema}.amls_t2e_acpt_bill to ${iml_schema};
grant select on ${iol_schema}.amls_t2e_acpt_bill to ${icl_schema};
grant select on ${iol_schema}.amls_t2e_acpt_bill to ${idl_schema};
grant select on ${iol_schema}.amls_t2e_acpt_bill to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t2e_acpt_bill is 't2e_银行承兑汇票表';
comment on column ${iol_schema}.amls_t2e_acpt_bill.acpt_id is '承兑编号';
comment on column ${iol_schema}.amls_t2e_acpt_bill.acct_id is '账户编号';
comment on column ${iol_schema}.amls_t2e_acpt_bill.contract_no is '合同编号';
comment on column ${iol_schema}.amls_t2e_acpt_bill.org_id is '营业机构';
comment on column ${iol_schema}.amls_t2e_acpt_bill.acct_org_id is '账务机构';
comment on column ${iol_schema}.amls_t2e_acpt_bill.subject_id is '科目编号';
comment on column ${iol_schema}.amls_t2e_acpt_bill.bill_seq is '组内序号';
comment on column ${iol_schema}.amls_t2e_acpt_bill.bill_no is '票据号码';
comment on column ${iol_schema}.amls_t2e_acpt_bill.curr_cd is '币种';
comment on column ${iol_schema}.amls_t2e_acpt_bill.bill_amt is '票面金额';
comment on column ${iol_schema}.amls_t2e_acpt_bill.issue_dt is '出票日期';
comment on column ${iol_schema}.amls_t2e_acpt_bill.due_dt is '到期日期';
comment on column ${iol_schema}.amls_t2e_acpt_bill.cust_id is '出票人客户编号';
comment on column ${iol_schema}.amls_t2e_acpt_bill.cust_name is '出票人客户名称';
comment on column ${iol_schema}.amls_t2e_acpt_bill.guar_acct_id is '保证金账户编号';
comment on column ${iol_schema}.amls_t2e_acpt_bill.guar_ratio is '保证金比例';
comment on column ${iol_schema}.amls_t2e_acpt_bill.guar_amt is '保证金金额';
comment on column ${iol_schema}.amls_t2e_acpt_bill.rcv_org_type is '收款人行号类型';
comment on column ${iol_schema}.amls_t2e_acpt_bill.rcv_org_id is '收款人行号';
comment on column ${iol_schema}.amls_t2e_acpt_bill.rcv_org_name is '收款人行名';
comment on column ${iol_schema}.amls_t2e_acpt_bill.rcv_acct_id is '收款人账户编号';
comment on column ${iol_schema}.amls_t2e_acpt_bill.pay_dt is '付款日期';
comment on column ${iol_schema}.amls_t2e_acpt_bill.close_dt is '核销日期';
comment on column ${iol_schema}.amls_t2e_acpt_bill.is_trans is '是否可转让（参见[字典:aml0095]）';
comment on column ${iol_schema}.amls_t2e_acpt_bill.bill_sts is '票据状态（参见[字典:aml0098]）';
comment on column ${iol_schema}.amls_t2e_acpt_bill.bill_opr_id is '操作员';
comment on column ${iol_schema}.amls_t2e_acpt_bill.start_dt is '开始时间';
comment on column ${iol_schema}.amls_t2e_acpt_bill.end_dt is '结束时间';
comment on column ${iol_schema}.amls_t2e_acpt_bill.id_mark is '增删标志';
comment on column ${iol_schema}.amls_t2e_acpt_bill.etl_timestamp is 'ETL处理时间戳';
