/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_temp_fm_open_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_temp_fm_open_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_temp_fm_open_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_temp_fm_open_detail(
    loan_approval_no varchar2(32) -- 借款审批流水号
    ,business_date varchar2(8) -- 业务日期 若8号发生，9号推送，则该业务日期为8号 yyyyMMdd
    ,loan_id varchar2(64) -- 借据号
    ,cust_name varchar2(200) -- 客户姓名
    ,cert_type varchar2(2) -- 证件类型 01--身份证 02--营业执照
    ,cert_no varchar2(60) -- 证件号
    ,borrower_account_number varchar2(64) -- 借款人账户
    ,borrower_account_name varchar2(200) -- 借款人姓名
    ,bank_name varchar2(200) -- 银行卡开户行名称
    ,trans_time varchar2(20) -- 交易时间 yyyyMMddHHmmss
    ,settlement_serial_no varchar2(64) -- 清算交易编号
    ,apply_date varchar2(8) -- 申请日期
    ,start_date varchar2(8) -- 开始日期
    ,end_date varchar2(8) -- 到期日期
    ,loan_amt varchar2(32) -- 放款金额
    ,loan_status varchar2(8) -- 放款状态 00-放款成功
    ,repay_way varchar2(2) -- 还款方式 01--等额本息
    ,grace_day varchar2(32) -- 宽限期
    ,int_rate varchar2(32) -- 利息利率 百分比 1.80000000
    ,pri_rate varchar2(32) -- 罚息利率 百分比 1.80000000
    ,cin_rate varchar2(32) -- 复利利率 百分比 1.80000000
    ,asset_identification varchar2(16) -- 资产标识
    ,finance_type varchar2(1) -- 资产类型  1-联合出资 2-机构全资
    ,fund_loan_rate varchar2(32) -- 出资比例 百分比 0.70000000
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
grant select on ${iol_schema}.icms_temp_fm_open_detail to ${iml_schema};
grant select on ${iol_schema}.icms_temp_fm_open_detail to ${icl_schema};
grant select on ${iol_schema}.icms_temp_fm_open_detail to ${idl_schema};
grant select on ${iol_schema}.icms_temp_fm_open_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_temp_fm_open_detail is '富民放款明细中间表';
comment on column ${iol_schema}.icms_temp_fm_open_detail.loan_approval_no is '借款审批流水号';
comment on column ${iol_schema}.icms_temp_fm_open_detail.business_date is '业务日期 若8号发生，9号推送，则该业务日期为8号 yyyyMMdd';
comment on column ${iol_schema}.icms_temp_fm_open_detail.loan_id is '借据号';
comment on column ${iol_schema}.icms_temp_fm_open_detail.cust_name is '客户姓名';
comment on column ${iol_schema}.icms_temp_fm_open_detail.cert_type is '证件类型 01--身份证 02--营业执照';
comment on column ${iol_schema}.icms_temp_fm_open_detail.cert_no is '证件号';
comment on column ${iol_schema}.icms_temp_fm_open_detail.borrower_account_number is '借款人账户';
comment on column ${iol_schema}.icms_temp_fm_open_detail.borrower_account_name is '借款人姓名';
comment on column ${iol_schema}.icms_temp_fm_open_detail.bank_name is '银行卡开户行名称';
comment on column ${iol_schema}.icms_temp_fm_open_detail.trans_time is '交易时间 yyyyMMddHHmmss';
comment on column ${iol_schema}.icms_temp_fm_open_detail.settlement_serial_no is '清算交易编号';
comment on column ${iol_schema}.icms_temp_fm_open_detail.apply_date is '申请日期';
comment on column ${iol_schema}.icms_temp_fm_open_detail.start_date is '开始日期';
comment on column ${iol_schema}.icms_temp_fm_open_detail.end_date is '到期日期';
comment on column ${iol_schema}.icms_temp_fm_open_detail.loan_amt is '放款金额';
comment on column ${iol_schema}.icms_temp_fm_open_detail.loan_status is '放款状态 00-放款成功';
comment on column ${iol_schema}.icms_temp_fm_open_detail.repay_way is '还款方式 01--等额本息';
comment on column ${iol_schema}.icms_temp_fm_open_detail.grace_day is '宽限期';
comment on column ${iol_schema}.icms_temp_fm_open_detail.int_rate is '利息利率 百分比 1.80000000';
comment on column ${iol_schema}.icms_temp_fm_open_detail.pri_rate is '罚息利率 百分比 1.80000000';
comment on column ${iol_schema}.icms_temp_fm_open_detail.cin_rate is '复利利率 百分比 1.80000000';
comment on column ${iol_schema}.icms_temp_fm_open_detail.asset_identification is '资产标识';
comment on column ${iol_schema}.icms_temp_fm_open_detail.finance_type is '资产类型  1-联合出资 2-机构全资';
comment on column ${iol_schema}.icms_temp_fm_open_detail.fund_loan_rate is '出资比例 百分比 0.70000000';
comment on column ${iol_schema}.icms_temp_fm_open_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_temp_fm_open_detail.etl_timestamp is 'ETL处理时间戳';
