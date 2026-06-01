/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_batch_settle_result_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_batch_settle_result_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_batch_settle_result_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_batch_settle_result_hist(
    amt_type varchar2(10) -- 金额类型
    ,batch_no varchar2(50) -- 批次号
    ,batch_seq_no varchar2(50) -- 批次明细序号
    ,company varchar2(20) -- 法人
    ,restraint_seq_no varchar2(50) -- 冻结编号
    ,scene_id varchar2(200) -- 场景id
    ,settle_no varchar2(50) -- 结算编号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,settle_acct_ccy varchar2(3) -- 结算账户币种
    ,settle_acct_seq_no varchar2(5) -- 结算账户序号
    ,settle_amt number(17,2) -- 结算金额
    ,settle_base_acct_no varchar2(50) -- 结算账号
    ,settle_prod_type varchar2(12) -- 结算账户产品类型
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
grant select on ${iol_schema}.ncbs_cl_batch_settle_result_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_batch_settle_result_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_batch_settle_result_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_batch_settle_result_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_batch_settle_result_hist is '贷款回收记账结果历史表';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.batch_seq_no is '批次明细序号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.company is '法人';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.restraint_seq_no is '冻结编号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.scene_id is '场景id';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.settle_no is '结算编号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.settle_acct_ccy is '结算账户币种';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.settle_acct_seq_no is '结算账户序号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.settle_amt is '结算金额';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.settle_base_acct_no is '结算账号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.settle_prod_type is '结算账户产品类型';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_batch_settle_result_hist.etl_timestamp is 'ETL处理时间戳';
