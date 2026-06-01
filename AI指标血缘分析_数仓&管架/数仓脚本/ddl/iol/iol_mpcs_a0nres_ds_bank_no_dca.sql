/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0nres_ds_bank_no_dca
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0nres_ds_bank_no_dca
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0nres_ds_bank_no_dca purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0nres_ds_bank_no_dca(
    partition_date varchar2(15) -- 分区日期
    ,repay_date date -- 还款日期
    ,card_no varchar2(36) -- 逻辑卡号
    ,ref_nbr varchar2(90) -- 借据号
    ,due_days number(22,0) -- 逾期天数
    ,bank_group_id varchar2(36) -- 参贷方案编号
    ,bank_no varchar2(36) -- 银行编号
    ,bank_proportion number(15,6) -- 参贷方案比例
    ,repay_amt number(15,2) -- 还款金额
    ,commission_ratio number(15,6) -- 委外费率
    ,out_expense number(15,2) -- 委外费用
    ,batchfilename varchar2(192) -- 批量文件名
    ,seqno varchar2(30) -- 序列号
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
grant select on ${iol_schema}.mpcs_a0nres_ds_bank_no_dca to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0nres_ds_bank_no_dca to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0nres_ds_bank_no_dca to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0nres_ds_bank_no_dca to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0nres_ds_bank_no_dca is '微粒贷银行催收佣金日报表';
comment on column ${iol_schema}.mpcs_a0nres_ds_bank_no_dca.partition_date is '分区日期';
comment on column ${iol_schema}.mpcs_a0nres_ds_bank_no_dca.repay_date is '还款日期';
comment on column ${iol_schema}.mpcs_a0nres_ds_bank_no_dca.card_no is '逻辑卡号';
comment on column ${iol_schema}.mpcs_a0nres_ds_bank_no_dca.ref_nbr is '借据号';
comment on column ${iol_schema}.mpcs_a0nres_ds_bank_no_dca.due_days is '逾期天数';
comment on column ${iol_schema}.mpcs_a0nres_ds_bank_no_dca.bank_group_id is '参贷方案编号';
comment on column ${iol_schema}.mpcs_a0nres_ds_bank_no_dca.bank_no is '银行编号';
comment on column ${iol_schema}.mpcs_a0nres_ds_bank_no_dca.bank_proportion is '参贷方案比例';
comment on column ${iol_schema}.mpcs_a0nres_ds_bank_no_dca.repay_amt is '还款金额';
comment on column ${iol_schema}.mpcs_a0nres_ds_bank_no_dca.commission_ratio is '委外费率';
comment on column ${iol_schema}.mpcs_a0nres_ds_bank_no_dca.out_expense is '委外费用';
comment on column ${iol_schema}.mpcs_a0nres_ds_bank_no_dca.batchfilename is '批量文件名';
comment on column ${iol_schema}.mpcs_a0nres_ds_bank_no_dca.seqno is '序列号';
comment on column ${iol_schema}.mpcs_a0nres_ds_bank_no_dca.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a0nres_ds_bank_no_dca.etl_timestamp is 'ETL处理时间戳';
