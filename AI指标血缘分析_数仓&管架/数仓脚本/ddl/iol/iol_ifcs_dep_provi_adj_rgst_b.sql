/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_dep_provi_adj_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_dep_provi_adj_rgst_b
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_dep_provi_adj_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_dep_provi_adj_rgst_b(
    tran_dt varchar2(30) -- 登记日期
    ,tran_flow_num varchar2(90) -- 登记流水
    ,dep_prod_sub_acct_id varchar2(15) -- 存款产品分户编号
    ,prod_id varchar2(90) -- 产品编号
    ,provi_amt number(18,2) -- 总计提金额
    ,int_set_amt number(18,2) -- 结息金额
    ,adj_amt number(18,2) -- 调整金额
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,ext_tran_dt varchar2(30) -- 外部交易日期
    ,ext_tran_flow_num varchar2(90) -- 外部交易流水
    ,dep_acct_id varchar2(90) -- 存款账户编号
    ,open_acct_org_id varchar2(90) -- 机构号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifcs_dep_provi_adj_rgst_b to ${iml_schema};
grant select on ${iol_schema}.ifcs_dep_provi_adj_rgst_b to ${icl_schema};
grant select on ${iol_schema}.ifcs_dep_provi_adj_rgst_b to ${idl_schema};
grant select on ${iol_schema}.ifcs_dep_provi_adj_rgst_b to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_dep_provi_adj_rgst_b is '分户计提调整登记簿';
comment on column ${iol_schema}.ifcs_dep_provi_adj_rgst_b.tran_dt is '登记日期';
comment on column ${iol_schema}.ifcs_dep_provi_adj_rgst_b.tran_flow_num is '登记流水';
comment on column ${iol_schema}.ifcs_dep_provi_adj_rgst_b.dep_prod_sub_acct_id is '存款产品分户编号';
comment on column ${iol_schema}.ifcs_dep_provi_adj_rgst_b.prod_id is '产品编号';
comment on column ${iol_schema}.ifcs_dep_provi_adj_rgst_b.provi_amt is '总计提金额';
comment on column ${iol_schema}.ifcs_dep_provi_adj_rgst_b.int_set_amt is '结息金额';
comment on column ${iol_schema}.ifcs_dep_provi_adj_rgst_b.adj_amt is '调整金额';
comment on column ${iol_schema}.ifcs_dep_provi_adj_rgst_b.tran_status_cd is '交易状态代码';
comment on column ${iol_schema}.ifcs_dep_provi_adj_rgst_b.ext_tran_dt is '外部交易日期';
comment on column ${iol_schema}.ifcs_dep_provi_adj_rgst_b.ext_tran_flow_num is '外部交易流水';
comment on column ${iol_schema}.ifcs_dep_provi_adj_rgst_b.dep_acct_id is '存款账户编号';
comment on column ${iol_schema}.ifcs_dep_provi_adj_rgst_b.open_acct_org_id is '机构号';
comment on column ${iol_schema}.ifcs_dep_provi_adj_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifcs_dep_provi_adj_rgst_b.etl_timestamp is 'ETL处理时间戳';
