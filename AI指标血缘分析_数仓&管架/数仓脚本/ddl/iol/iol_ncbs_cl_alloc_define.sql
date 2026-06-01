/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_alloc_define
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_alloc_define
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_alloc_define purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_alloc_define(
    alloc_code varchar2(50) -- 扣款顺序编号
    ,alloc_desc varchar2(50) -- 扣款顺序描述
    ,alloc_seq_fee varchar2(1) -- 贷款费用还款顺序
    ,alloc_seq_int varchar2(1) -- 贷款利息还款顺序
    ,alloc_seq_odi varchar2(1) -- 贷款复利还款顺序
    ,alloc_seq_odp varchar2(1) -- 贷款罚息还款顺序
    ,alloc_seq_pri varchar2(1) -- 贷款本金还款顺序
    ,alloc_seq_type varchar2(1) -- 贷款自动还款类型
    ,company varchar2(20) -- 法人
    ,libra_op_time number(15) -- libra执行次数
    ,accounting_status varchar2(3) -- 核算状态
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_cl_alloc_define to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_alloc_define to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_alloc_define to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_alloc_define to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_alloc_define is '贷款扣款顺序定义表';
comment on column ${iol_schema}.ncbs_cl_alloc_define.alloc_code is '扣款顺序编号';
comment on column ${iol_schema}.ncbs_cl_alloc_define.alloc_desc is '扣款顺序描述';
comment on column ${iol_schema}.ncbs_cl_alloc_define.alloc_seq_fee is '贷款费用还款顺序';
comment on column ${iol_schema}.ncbs_cl_alloc_define.alloc_seq_int is '贷款利息还款顺序';
comment on column ${iol_schema}.ncbs_cl_alloc_define.alloc_seq_odi is '贷款复利还款顺序';
comment on column ${iol_schema}.ncbs_cl_alloc_define.alloc_seq_odp is '贷款罚息还款顺序';
comment on column ${iol_schema}.ncbs_cl_alloc_define.alloc_seq_pri is '贷款本金还款顺序';
comment on column ${iol_schema}.ncbs_cl_alloc_define.alloc_seq_type is '贷款自动还款类型';
comment on column ${iol_schema}.ncbs_cl_alloc_define.company is '法人';
comment on column ${iol_schema}.ncbs_cl_alloc_define.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_cl_alloc_define.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_cl_alloc_define.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_alloc_define.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_alloc_define.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_alloc_define.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_alloc_define.etl_timestamp is 'ETL处理时间戳';
