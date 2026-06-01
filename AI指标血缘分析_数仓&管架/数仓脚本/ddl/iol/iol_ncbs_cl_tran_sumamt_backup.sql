/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_tran_sumamt_backup
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_tran_sumamt_backup
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_tran_sumamt_backup purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_tran_sumamt_backup(
    remark varchar2(600) -- 备注
    ,company varchar2(20) -- 法人
    ,data_origin varchar2(3) -- 日间日终标志
    ,sum_count number(5) -- 累计转账次数
    ,tran_seq_no varchar2(50) -- 交易序号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,total_amt number(17,2) -- 总金额
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
grant select on ${iol_schema}.ncbs_cl_tran_sumamt_backup to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_tran_sumamt_backup to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_tran_sumamt_backup to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_tran_sumamt_backup to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_tran_sumamt_backup is '交易流水金额笔数汇总表';
comment on column ${iol_schema}.ncbs_cl_tran_sumamt_backup.remark is '备注';
comment on column ${iol_schema}.ncbs_cl_tran_sumamt_backup.company is '法人';
comment on column ${iol_schema}.ncbs_cl_tran_sumamt_backup.data_origin is '日间日终标志';
comment on column ${iol_schema}.ncbs_cl_tran_sumamt_backup.sum_count is '累计转账次数';
comment on column ${iol_schema}.ncbs_cl_tran_sumamt_backup.tran_seq_no is '交易序号';
comment on column ${iol_schema}.ncbs_cl_tran_sumamt_backup.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_tran_sumamt_backup.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_tran_sumamt_backup.total_amt is '总金额';
comment on column ${iol_schema}.ncbs_cl_tran_sumamt_backup.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_tran_sumamt_backup.etl_timestamp is 'ETL处理时间戳';
