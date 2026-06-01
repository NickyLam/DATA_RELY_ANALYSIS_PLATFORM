/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_branch_amend_amt_transfer
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer(
    amt_type varchar2(10) -- 金额类型
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,invoice_tran_no varchar2(50) -- 通知单号
    ,stage_no number(5) -- 期次
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,old_branch varchar2(12) -- 变更前机构
    ,original_int number(17,2) -- 原计提利息
    ,outstanding number(17,2) -- 单据余额
    ,over_amount number(17,2) -- 贷款剩余金额
    ,rec_outstanding number(17,2) -- 回收剩余单据金额
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
grant select on ${iol_schema}.ncbs_cl_branch_amend_amt_transfer to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_branch_amend_amt_transfer to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_branch_amend_amt_transfer to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_branch_amend_amt_transfer to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer is '机构变更金额转让表';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.company is '法人';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.invoice_tran_no is '通知单号';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.stage_no is '期次';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.old_branch is '变更前机构';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.original_int is '原计提利息';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.outstanding is '单据余额';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.over_amount is '贷款剩余金额';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.rec_outstanding is '回收剩余单据金额';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_branch_amend_amt_transfer.etl_timestamp is 'ETL处理时间戳';
