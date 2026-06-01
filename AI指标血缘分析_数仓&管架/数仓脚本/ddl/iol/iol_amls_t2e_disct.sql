/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t2e_disct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t2e_disct
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t2e_disct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2e_disct(
    dct_id varchar2(96) -- 贴现编号
    ,trans_id varchar2(96) -- 业务标识号
    ,acct_id varchar2(96) -- 贴现账号
    ,dct_dt date -- 贴现日期
    ,contract_id varchar2(90) -- 主合同号
    ,org_id varchar2(90) -- 营业机构
    ,acct_org_id varchar2(30) -- 账务机构号
    ,subject_id varchar2(90) -- 科目编号
    ,dct_day number(22) -- 贴现天数
    ,dct_amt number(30,4) -- 贴现金额
    ,dct_int number(18,8) -- 贴现利息
    ,cust_id varchar2(90) -- 持票（贴现）人客户号
    ,cust_name varchar2(768) -- 持票（贴现）人客户名称
    ,cust_acct_id varchar2(96) -- 持票（贴现）人结算账号
    ,agent_cert_type varchar2(72) -- 贴现委托人证件/证明文件类型
    ,agent_cert_no varchar2(375) -- 贴现委托人证件号码
    ,agent_name varchar2(375) -- 贴现委托人姓名
    ,bill_type varchar2(3) -- 票据种类（参见[字典:aml0094]）
    ,bill_seq varchar2(9) -- 承兑汇票组内序号
    ,bill_no varchar2(90) -- 票据号码
    ,curr_cd varchar2(15) -- 票据币种
    ,bill_amt number(30,4) -- 票面金额
    ,bill_bal number(30,4) -- 票面余额
    ,issue_dt date -- 票据签发日
    ,due_dt date -- 票据到期日
    ,transfer_ind varchar2(2) -- 是否可转让（参见[字典:aml0095]）
    ,issue_cust_id varchar2(48) -- 出票人客户号
    ,issue_cust_name varchar2(500) -- 出票人名称
    ,issue_org_type varchar2(3) -- 出票人行号类型
    ,issue_org_id varchar2(30) -- 出票人开户行行号
    ,issue_org_name varchar2(750) -- 出票人开户行行名
    ,issue_acct_id varchar2(96) -- 出票人开户行账号
    ,rcv_cust_id varchar2(48) -- 收款人客户号
    ,rcv_cust_name varchar2(750) -- 收款人名称
    ,rcv_org_type varchar2(3) -- 收款人行号类型
    ,rcv_org_id varchar2(90) -- 收款人开户行行号
    ,rcv_org_name varchar2(192) -- 收款人开户行行名
    ,rcv_acct_id varchar2(96) -- 收款人开户行账号
    ,acpt_org_type varchar2(3) -- 承兑行类型（参见[字典:aml0096]）
    ,acpt_org_id varchar2(90) -- 承兑行行号
    ,acpt_org_name varchar2(750) -- 承兑行行名
    ,bill_sts varchar2(2) -- 贴现状态（参见[字典:aml0097]）
    ,bill_opr_id varchar2(90) -- 操作柜员
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
grant select on ${iol_schema}.amls_t2e_disct to ${iml_schema};
grant select on ${iol_schema}.amls_t2e_disct to ${icl_schema};
grant select on ${iol_schema}.amls_t2e_disct to ${idl_schema};
grant select on ${iol_schema}.amls_t2e_disct to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t2e_disct is 't2e_贴现登记簿';
comment on column ${iol_schema}.amls_t2e_disct.dct_id is '贴现编号';
comment on column ${iol_schema}.amls_t2e_disct.trans_id is '业务标识号';
comment on column ${iol_schema}.amls_t2e_disct.acct_id is '贴现账号';
comment on column ${iol_schema}.amls_t2e_disct.dct_dt is '贴现日期';
comment on column ${iol_schema}.amls_t2e_disct.contract_id is '主合同号';
comment on column ${iol_schema}.amls_t2e_disct.org_id is '营业机构';
comment on column ${iol_schema}.amls_t2e_disct.acct_org_id is '账务机构号';
comment on column ${iol_schema}.amls_t2e_disct.subject_id is '科目编号';
comment on column ${iol_schema}.amls_t2e_disct.dct_day is '贴现天数';
comment on column ${iol_schema}.amls_t2e_disct.dct_amt is '贴现金额';
comment on column ${iol_schema}.amls_t2e_disct.dct_int is '贴现利息';
comment on column ${iol_schema}.amls_t2e_disct.cust_id is '持票（贴现）人客户号';
comment on column ${iol_schema}.amls_t2e_disct.cust_name is '持票（贴现）人客户名称';
comment on column ${iol_schema}.amls_t2e_disct.cust_acct_id is '持票（贴现）人结算账号';
comment on column ${iol_schema}.amls_t2e_disct.agent_cert_type is '贴现委托人证件/证明文件类型';
comment on column ${iol_schema}.amls_t2e_disct.agent_cert_no is '贴现委托人证件号码';
comment on column ${iol_schema}.amls_t2e_disct.agent_name is '贴现委托人姓名';
comment on column ${iol_schema}.amls_t2e_disct.bill_type is '票据种类（参见[字典:aml0094]）';
comment on column ${iol_schema}.amls_t2e_disct.bill_seq is '承兑汇票组内序号';
comment on column ${iol_schema}.amls_t2e_disct.bill_no is '票据号码';
comment on column ${iol_schema}.amls_t2e_disct.curr_cd is '票据币种';
comment on column ${iol_schema}.amls_t2e_disct.bill_amt is '票面金额';
comment on column ${iol_schema}.amls_t2e_disct.bill_bal is '票面余额';
comment on column ${iol_schema}.amls_t2e_disct.issue_dt is '票据签发日';
comment on column ${iol_schema}.amls_t2e_disct.due_dt is '票据到期日';
comment on column ${iol_schema}.amls_t2e_disct.transfer_ind is '是否可转让（参见[字典:aml0095]）';
comment on column ${iol_schema}.amls_t2e_disct.issue_cust_id is '出票人客户号';
comment on column ${iol_schema}.amls_t2e_disct.issue_cust_name is '出票人名称';
comment on column ${iol_schema}.amls_t2e_disct.issue_org_type is '出票人行号类型';
comment on column ${iol_schema}.amls_t2e_disct.issue_org_id is '出票人开户行行号';
comment on column ${iol_schema}.amls_t2e_disct.issue_org_name is '出票人开户行行名';
comment on column ${iol_schema}.amls_t2e_disct.issue_acct_id is '出票人开户行账号';
comment on column ${iol_schema}.amls_t2e_disct.rcv_cust_id is '收款人客户号';
comment on column ${iol_schema}.amls_t2e_disct.rcv_cust_name is '收款人名称';
comment on column ${iol_schema}.amls_t2e_disct.rcv_org_type is '收款人行号类型';
comment on column ${iol_schema}.amls_t2e_disct.rcv_org_id is '收款人开户行行号';
comment on column ${iol_schema}.amls_t2e_disct.rcv_org_name is '收款人开户行行名';
comment on column ${iol_schema}.amls_t2e_disct.rcv_acct_id is '收款人开户行账号';
comment on column ${iol_schema}.amls_t2e_disct.acpt_org_type is '承兑行类型（参见[字典:aml0096]）';
comment on column ${iol_schema}.amls_t2e_disct.acpt_org_id is '承兑行行号';
comment on column ${iol_schema}.amls_t2e_disct.acpt_org_name is '承兑行行名';
comment on column ${iol_schema}.amls_t2e_disct.bill_sts is '贴现状态（参见[字典:aml0097]）';
comment on column ${iol_schema}.amls_t2e_disct.bill_opr_id is '操作柜员';
comment on column ${iol_schema}.amls_t2e_disct.start_dt is '开始时间';
comment on column ${iol_schema}.amls_t2e_disct.end_dt is '结束时间';
comment on column ${iol_schema}.amls_t2e_disct.id_mark is '增删标志';
comment on column ${iol_schema}.amls_t2e_disct.etl_timestamp is 'ETL处理时间戳';
