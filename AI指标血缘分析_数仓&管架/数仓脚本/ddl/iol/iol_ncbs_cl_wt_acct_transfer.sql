/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_wt_acct_transfer
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_wt_acct_transfer
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_wt_acct_transfer purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_wt_acct_transfer(
    branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,dd_no number(5) -- 发放号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,batch_seq_no varchar2(50) -- 批次明细序号
    ,company varchar2(20) -- 法人
    ,status varchar2(1) -- 状态
    ,status_desc varchar2(50) -- 描述信息
    ,last_change_date date -- 最后修改日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,loan_no varchar2(50) -- 贷款号
    ,settle_wtr_acct_ccy varchar2(3) -- 委托存款账户币种
    ,settle_wtr_acct_seq_no varchar2(5) -- 委托存款账户序列号
    ,settle_wtr_base_acct_no varchar2(50) -- 贷款委托账号
    ,settle_wtr_prod_type varchar2(12) -- 贷款委托存款账户类型
    ,settle_wts_acct_ccy varchar2(3) -- 委托结算账户币种
    ,settle_wts_acct_seq_no varchar2(5) -- 委托结算账户序列号
    ,settle_wts_base_acct_no varchar2(50) -- 委托结算账户账号
    ,settle_wts_prod_type varchar2(12) -- 委托结算账户类型
    ,transfer_amount number(17,2) -- 转账金额
    ,remark varchar2(600) -- 备注
    ,res_seq_no varchar2(50) -- 限制编号
    ,wt_tran_deal_flow varchar2(1) -- 委托转账处理方式（1-解限,2-转账）
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
grant select on ${iol_schema}.ncbs_cl_wt_acct_transfer to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_wt_acct_transfer to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_wt_acct_transfer to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_wt_acct_transfer to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_wt_acct_transfer is '贷款委托账户转账中间表';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.branch is '机构编号';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.batch_seq_no is '批次明细序号';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.company is '法人';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.status is '状态';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.status_desc is '描述信息';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.settle_wtr_acct_ccy is '委托存款账户币种';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.settle_wtr_acct_seq_no is '委托存款账户序列号';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.settle_wtr_base_acct_no is '贷款委托账号';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.settle_wtr_prod_type is '贷款委托存款账户类型';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.settle_wts_acct_ccy is '委托结算账户币种';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.settle_wts_acct_seq_no is '委托结算账户序列号';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.settle_wts_base_acct_no is '委托结算账户账号';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.settle_wts_prod_type is '委托结算账户类型';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.transfer_amount is '转账金额';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.remark is '备注';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.wt_tran_deal_flow is '委托转账处理方式（1-解限,2-转账）';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_wt_acct_transfer.etl_timestamp is 'ETL处理时间戳';
