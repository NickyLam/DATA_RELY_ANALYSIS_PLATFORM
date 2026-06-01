/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_transfer_amt_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_transfer_amt_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_transfer_amt_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_transfer_amt_detail(
    amt_type varchar2(10) -- 金额类型
    ,client_no varchar2(16) -- 客户编号
    ,company varchar2(20) -- 法人
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,cope_amount number(17,2) -- 应付行内金额
    ,cope_redeem_amt number(17,2) -- 赎回应付对手利息
    ,over_amount number(17,2) -- 贷款剩余金额
    ,over_redeem_amt number(17,2) -- 赎回剩余对手利息
    ,asset_detail_seq_no varchar2(50) -- 资产包合同明细序号
    ,asset_amt_seq_no varchar2(50) -- 资产金额明细序号
    ,pack_tran_rec_amt number(17,2) -- 封包转入暂收款账户金额
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
grant select on ${iol_schema}.ncbs_cl_transfer_amt_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_amt_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_amt_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_amt_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_transfer_amt_detail is '资产证券化金额明细登记表';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail.company is '法人';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail.cope_amount is '应付行内金额';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail.cope_redeem_amt is '赎回应付对手利息';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail.over_amount is '贷款剩余金额';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail.over_redeem_amt is '赎回剩余对手利息';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail.asset_detail_seq_no is '资产包合同明细序号';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail.asset_amt_seq_no is '资产金额明细序号';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail.pack_tran_rec_amt is '封包转入暂收款账户金额';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail.etl_timestamp is 'ETL处理时间戳';
