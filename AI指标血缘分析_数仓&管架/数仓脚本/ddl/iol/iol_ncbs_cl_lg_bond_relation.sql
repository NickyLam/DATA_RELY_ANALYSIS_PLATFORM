/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_lg_bond_relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_lg_bond_relation
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_lg_bond_relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_lg_bond_relation(
    client_no varchar2(16) -- 客户编号
    ,company varchar2(20) -- 法人
    ,lg_no varchar2(50) -- 保函编号
    ,restraint_seq_no varchar2(50) -- 冻结编号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,bond_acct_ccy varchar2(3) -- 保证金账户币种
    ,bond_acct_no varchar2(50) -- 保证金账号
    ,bond_acct_seq_no varchar2(5) -- 保证金账户序号
    ,bond_prod_type varchar2(12) -- 保证金账户产品类型
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
grant select on ${iol_schema}.ncbs_cl_lg_bond_relation to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_lg_bond_relation to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_lg_bond_relation to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_lg_bond_relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_lg_bond_relation is '保函保证金账户关联表';
comment on column ${iol_schema}.ncbs_cl_lg_bond_relation.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_lg_bond_relation.company is '法人';
comment on column ${iol_schema}.ncbs_cl_lg_bond_relation.lg_no is '保函编号';
comment on column ${iol_schema}.ncbs_cl_lg_bond_relation.restraint_seq_no is '冻结编号';
comment on column ${iol_schema}.ncbs_cl_lg_bond_relation.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_lg_bond_relation.bond_acct_ccy is '保证金账户币种';
comment on column ${iol_schema}.ncbs_cl_lg_bond_relation.bond_acct_no is '保证金账号';
comment on column ${iol_schema}.ncbs_cl_lg_bond_relation.bond_acct_seq_no is '保证金账户序号';
comment on column ${iol_schema}.ncbs_cl_lg_bond_relation.bond_prod_type is '保证金账户产品类型';
comment on column ${iol_schema}.ncbs_cl_lg_bond_relation.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_lg_bond_relation.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_lg_bond_relation.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_lg_bond_relation.etl_timestamp is 'ETL处理时间戳';
