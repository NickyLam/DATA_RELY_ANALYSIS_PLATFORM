/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_bond_rpp_int_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_bond_rpp_int_plan
whenever sqlerror continue none;
drop table ${iml_schema}.prd_bond_rpp_int_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_bond_rpp_int_plan(
    bond_id varchar2(60) -- 债券编号
    ,lp_id varchar2(60) -- 法人编号
    ,seq_num number(10) -- 序号
    ,pay_dt date -- 支付日期
    ,issuer_redem_dt date -- 发行人赎回日期
    ,invtor_put_dt date -- 投资人回售日期
    ,int_amt number(30,2) -- 利息金额
    ,pric_amt number(30,2) -- 本金金额
    ,surp_pric_amt number(30,2) -- 剩余本金金额
    ,issuer_redem_price number(30,2) -- 发行人赎回价格
    ,invtor_put_price number(30,2) -- 投资人回售价格
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_bond_rpp_int_plan to ${icl_schema};
grant select on ${iml_schema}.prd_bond_rpp_int_plan to ${idl_schema};
grant select on ${iml_schema}.prd_bond_rpp_int_plan to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_bond_rpp_int_plan is '债券还本付息计划';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.bond_id is '债券编号';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.lp_id is '法人编号';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.seq_num is '序号';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.pay_dt is '支付日期';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.issuer_redem_dt is '发行人赎回日期';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.invtor_put_dt is '投资人回售日期';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.int_amt is '利息金额';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.pric_amt is '本金金额';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.surp_pric_amt is '剩余本金金额';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.issuer_redem_price is '发行人赎回价格';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.invtor_put_price is '投资人回售价格';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.create_dt is '创建日期';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.update_dt is '更新日期';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.id_mark is '增删标志';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.job_cd is '任务编码';
comment on column ${iml_schema}.prd_bond_rpp_int_plan.etl_timestamp is 'ETL处理时间戳';
