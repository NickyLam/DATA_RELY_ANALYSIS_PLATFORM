/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_order_rec_settle
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_order_rec_settle
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_order_rec_settle purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_order_rec_settle(
    client_no varchar2(16) -- 客户编号
    ,order_no varchar2(50) -- 预约编号
    ,order_seq_no varchar2(50) -- 预约登记号
    ,settle_acct_seq_no varchar2(5) -- 结算账户序号
    ,settle_amt number(17,2) -- 结算金额
    ,settle_base_acct_no varchar2(50) -- 结算账号
    ,settle_ccy varchar2(3) -- 结算币种
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
grant select on ${iol_schema}.ncbs_cl_order_rec_settle to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_order_rec_settle to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_order_rec_settle to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_order_rec_settle to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_order_rec_settle is '贷款预约还款结算信息';
comment on column ${iol_schema}.ncbs_cl_order_rec_settle.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_order_rec_settle.order_no is '预约编号';
comment on column ${iol_schema}.ncbs_cl_order_rec_settle.order_seq_no is '预约登记号';
comment on column ${iol_schema}.ncbs_cl_order_rec_settle.settle_acct_seq_no is '结算账户序号';
comment on column ${iol_schema}.ncbs_cl_order_rec_settle.settle_amt is '结算金额';
comment on column ${iol_schema}.ncbs_cl_order_rec_settle.settle_base_acct_no is '结算账号';
comment on column ${iol_schema}.ncbs_cl_order_rec_settle.settle_ccy is '结算币种';
comment on column ${iol_schema}.ncbs_cl_order_rec_settle.settle_prod_type is '结算账户产品类型';
comment on column ${iol_schema}.ncbs_cl_order_rec_settle.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_order_rec_settle.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_order_rec_settle.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_order_rec_settle.etl_timestamp is 'ETL处理时间戳';
