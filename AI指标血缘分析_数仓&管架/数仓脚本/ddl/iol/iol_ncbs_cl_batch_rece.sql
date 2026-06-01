/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_batch_rece
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_batch_rece
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_batch_rece purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_batch_rece(
    client_no varchar2(16) -- 客户编号
    ,batch_seq_no varchar2(50) -- 批次明细序号
    ,company varchar2(20) -- 法人
    ,res_seq_no varchar2(50) -- 限制编号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,loan_no varchar2(50) -- 贷款号
    ,rec_amt number(17,2) -- 回收金额(指回收的本金)
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
grant select on ${iol_schema}.ncbs_cl_batch_rece to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_batch_rece to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_batch_rece to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_batch_rece to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_batch_rece is '贷款自动回收扣款文件映射表';
comment on column ${iol_schema}.ncbs_cl_batch_rece.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_batch_rece.batch_seq_no is '批次明细序号';
comment on column ${iol_schema}.ncbs_cl_batch_rece.company is '法人';
comment on column ${iol_schema}.ncbs_cl_batch_rece.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_cl_batch_rece.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_batch_rece.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_batch_rece.rec_amt is '回收金额(指回收的本金)';
comment on column ${iol_schema}.ncbs_cl_batch_rece.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_batch_rece.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_batch_rece.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_batch_rece.etl_timestamp is 'ETL处理时间戳';
