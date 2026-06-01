/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_temp_fm_repay_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_temp_fm_repay_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_temp_fm_repay_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_temp_fm_repay_detail(
    business_date varchar2(8) -- 业务日期
    ,seq_no varchar2(64) -- 交易流水号
    ,loan_id varchar2(64) -- 借据号
    ,repay_acc_type varchar2(200) -- 还款账户名称
    ,repay_acc_no varchar2(64) -- 还款账号
    ,repay_time varchar2(20) -- 交易时间 YYYYMMDDHHMMSS
    ,settlement_serial_no varchar2(64) -- 清算交易编号
    ,repay_mode varchar2(1) -- 还款类型 1-正常还款 2-逾期还款 4-提前还款
    ,repay_way varchar2(1) -- 还款方式 1-线上还款 2-线下还款 3-系统扣款 9-未知
    ,receipt_type varchar2(1) -- 回收类型 1-正常回收 2-担保代偿
    ,repay_amt varchar2(32) -- 还款总金额
    ,period varchar2(32) -- 还款期次
    ,repay_pri_amt varchar2(32) -- 还款本金
    ,repay_int_amt varchar2(32) -- 还款利息
    ,repay_pin_amt varchar2(32) -- 还款罚息
    ,repay_cin_amt varchar2(32) -- 还款复利
    ,repay_esfee_amt varchar2(32) -- 还款提前结清手续费
    ,finance_type varchar2(1) -- 资产类型 1-联合出资 2-机构全资
    ,in_seq_no varchar2(64) -- 内部交易流水号
    ,asset_identification varchar2(16) -- 资产标识
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
grant select on ${iol_schema}.icms_temp_fm_repay_detail to ${iml_schema};
grant select on ${iol_schema}.icms_temp_fm_repay_detail to ${icl_schema};
grant select on ${iol_schema}.icms_temp_fm_repay_detail to ${idl_schema};
grant select on ${iol_schema}.icms_temp_fm_repay_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_temp_fm_repay_detail is '富民还款明细中间表';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.business_date is '业务日期';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.seq_no is '交易流水号';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.loan_id is '借据号';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.repay_acc_type is '还款账户名称';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.repay_acc_no is '还款账号';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.repay_time is '交易时间 YYYYMMDDHHMMSS';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.settlement_serial_no is '清算交易编号';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.repay_mode is '还款类型 1-正常还款 2-逾期还款 4-提前还款';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.repay_way is '还款方式 1-线上还款 2-线下还款 3-系统扣款 9-未知';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.receipt_type is '回收类型 1-正常回收 2-担保代偿';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.repay_amt is '还款总金额';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.period is '还款期次';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.repay_pri_amt is '还款本金';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.repay_int_amt is '还款利息';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.repay_pin_amt is '还款罚息';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.repay_cin_amt is '还款复利';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.repay_esfee_amt is '还款提前结清手续费';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.finance_type is '资产类型 1-联合出资 2-机构全资';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.in_seq_no is '内部交易流水号';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.asset_identification is '资产标识';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_temp_fm_repay_detail.etl_timestamp is 'ETL处理时间戳';
