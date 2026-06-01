/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_transfer_canpunk
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_transfer_canpunk
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_transfer_canpunk purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_transfer_canpunk(
    contract_no varchar2(30) -- 合同编号
    ,reference varchar2(50) -- 交易参考号
    ,batch_no varchar2(50) -- 批次号
    ,company varchar2(20) -- 法人
    ,tran_status varchar2(1) -- 冲补抹标志
    ,transfer_seq_no varchar2(50) -- 资产证券化合同明细主键
    ,unpack_error_desc varchar2(50) -- 撤包错误信息描述
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,loan_no varchar2(50) -- 贷款号
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
grant select on ${iol_schema}.ncbs_cl_transfer_canpunk to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_canpunk to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_canpunk to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_canpunk to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_transfer_canpunk is '资产证券化撤包明细';
comment on column ${iol_schema}.ncbs_cl_transfer_canpunk.contract_no is '合同编号';
comment on column ${iol_schema}.ncbs_cl_transfer_canpunk.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_transfer_canpunk.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_cl_transfer_canpunk.company is '法人';
comment on column ${iol_schema}.ncbs_cl_transfer_canpunk.tran_status is '冲补抹标志';
comment on column ${iol_schema}.ncbs_cl_transfer_canpunk.transfer_seq_no is '资产证券化合同明细主键';
comment on column ${iol_schema}.ncbs_cl_transfer_canpunk.unpack_error_desc is '撤包错误信息描述';
comment on column ${iol_schema}.ncbs_cl_transfer_canpunk.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_transfer_canpunk.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_transfer_canpunk.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_transfer_canpunk.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_transfer_canpunk.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_transfer_canpunk.etl_timestamp is 'ETL处理时间戳';
