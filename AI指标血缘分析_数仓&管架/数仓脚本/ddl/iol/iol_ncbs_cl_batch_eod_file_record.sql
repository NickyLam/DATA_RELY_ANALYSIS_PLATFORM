/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_batch_eod_file_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_batch_eod_file_record
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_batch_eod_file_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_batch_eod_file_record(
    batch_no varchar2(50) -- 批次号
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,run_date date -- 运行日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_cl_batch_eod_file_record to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_batch_eod_file_record to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_batch_eod_file_record to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_batch_eod_file_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_batch_eod_file_record is '贷款日终二次供数文件批次信息表';
comment on column ${iol_schema}.ncbs_cl_batch_eod_file_record.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_cl_batch_eod_file_record.company is '法人';
comment on column ${iol_schema}.ncbs_cl_batch_eod_file_record.seq_no is '序号';
comment on column ${iol_schema}.ncbs_cl_batch_eod_file_record.run_date is '运行日期';
comment on column ${iol_schema}.ncbs_cl_batch_eod_file_record.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_batch_eod_file_record.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_batch_eod_file_record.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_batch_eod_file_record.etl_timestamp is 'ETL处理时间戳';
