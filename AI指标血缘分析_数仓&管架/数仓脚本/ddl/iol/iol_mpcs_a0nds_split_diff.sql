/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0nds_split_diff
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0nds_split_diff
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0nds_split_diff purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0nds_split_diff(
    partition_date varchar2(12) -- 批量日期
    ,error_type varchar2(60) -- 异常类型
    ,bank_group_id varchar2(8) -- 银团编号
    ,bank_no varchar2(15) -- 银行编号
    ,consumer_trans_id varchar2(60) -- 业务流水号
    ,reg_type varchar2(15) -- 交易类型
    ,name varchar2(120) -- 姓名
    ,logical_card_no varchar2(29) -- 逻辑卡号
    ,bf_amt number(15,2) -- 备付金清算金额
    ,account_amt number(15,2) -- cnc记账金额
    ,error_amt number(15,2) -- 应调整差额
    ,batchfilename varchar2(90) -- 批量文件名
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
grant select on ${iol_schema}.mpcs_a0nds_split_diff to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0nds_split_diff to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0nds_split_diff to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0nds_split_diff to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0nds_split_diff is '银团尾差调整表';
comment on column ${iol_schema}.mpcs_a0nds_split_diff.partition_date is '批量日期';
comment on column ${iol_schema}.mpcs_a0nds_split_diff.error_type is '异常类型';
comment on column ${iol_schema}.mpcs_a0nds_split_diff.bank_group_id is '银团编号';
comment on column ${iol_schema}.mpcs_a0nds_split_diff.bank_no is '银行编号';
comment on column ${iol_schema}.mpcs_a0nds_split_diff.consumer_trans_id is '业务流水号';
comment on column ${iol_schema}.mpcs_a0nds_split_diff.reg_type is '交易类型';
comment on column ${iol_schema}.mpcs_a0nds_split_diff.name is '姓名';
comment on column ${iol_schema}.mpcs_a0nds_split_diff.logical_card_no is '逻辑卡号';
comment on column ${iol_schema}.mpcs_a0nds_split_diff.bf_amt is '备付金清算金额';
comment on column ${iol_schema}.mpcs_a0nds_split_diff.account_amt is 'cnc记账金额';
comment on column ${iol_schema}.mpcs_a0nds_split_diff.error_amt is '应调整差额';
comment on column ${iol_schema}.mpcs_a0nds_split_diff.batchfilename is '批量文件名';
comment on column ${iol_schema}.mpcs_a0nds_split_diff.seqno is '序列号';
comment on column ${iol_schema}.mpcs_a0nds_split_diff.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a0nds_split_diff.etl_timestamp is 'ETL处理时间戳';
