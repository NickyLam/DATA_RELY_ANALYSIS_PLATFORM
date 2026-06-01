/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_transfer_amt_detail_register
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_transfer_amt_detail_register
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_transfer_amt_detail_register purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_transfer_amt_detail_register(
    amt_type varchar2(10) -- 金额类型
    ,client_no varchar2(16) -- 客户编号
    ,company varchar2(20) -- 法人
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,pack_tran_amt number(17,2) -- 封包交易日时点金额
    ,pack_amt number(17,2) -- 封包日时点金额
    ,asset_detail_seq_no varchar2(50) -- 资产包合同明细序号
    ,asset_amt_seq_no varchar2(50) -- 资产金额明细序号
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
grant select on ${iol_schema}.ncbs_cl_transfer_amt_detail_register to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_amt_detail_register to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_amt_detail_register to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_amt_detail_register to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_transfer_amt_detail_register is '资产证券化（转让）金额明细登记表';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail_register.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail_register.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail_register.company is '法人';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail_register.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail_register.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail_register.pack_tran_amt is '封包交易日时点金额';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail_register.pack_amt is '封包日时点金额';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail_register.asset_detail_seq_no is '资产包合同明细序号';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail_register.asset_amt_seq_no is '资产金额明细序号';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail_register.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail_register.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail_register.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_transfer_amt_detail_register.etl_timestamp is 'ETL处理时间戳';
