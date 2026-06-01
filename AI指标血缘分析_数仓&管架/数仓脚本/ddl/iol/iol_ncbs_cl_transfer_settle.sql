/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_transfer_settle
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_transfer_settle
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_transfer_settle purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_transfer_settle(
    amt_type varchar2(10) -- 金额类型
    ,company varchar2(20) -- 法人
    ,settle_acct_class varchar2(3) -- 结算账户分类
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,settle_acct_ccy varchar2(3) -- 结算账户币种
    ,settle_acct_seq_no varchar2(5) -- 结算账户序号
    ,settle_amt number(17,2) -- 结算金额
    ,settle_base_acct_no varchar2(50) -- 结算账号
    ,settle_ccy varchar2(3) -- 结算币种
    ,settle_prod_type varchar2(12) -- 结算账户产品类型
    ,asset_res_seq_no varchar2(50) -- 资产结算账户限制编号
    ,asset_contract_seq_no varchar2(50) -- 资产包合同序号
    ,asset_settle_seq_no varchar2(50) -- 资产包结算明细序号
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
grant select on ${iol_schema}.ncbs_cl_transfer_settle to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_settle to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_settle to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_settle to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_transfer_settle is '资产证券化结算信息表';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.company is '法人';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.settle_acct_class is '结算账户分类';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.settle_acct_ccy is '结算账户币种';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.settle_acct_seq_no is '结算账户序号';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.settle_amt is '结算金额';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.settle_base_acct_no is '结算账号';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.settle_ccy is '结算币种';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.settle_prod_type is '结算账户产品类型';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.asset_res_seq_no is '资产结算账户限制编号';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.asset_contract_seq_no is '资产包合同序号';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.asset_settle_seq_no is '资产包结算明细序号';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_transfer_settle.etl_timestamp is 'ETL处理时间戳';
