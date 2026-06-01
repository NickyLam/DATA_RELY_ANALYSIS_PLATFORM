/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ifs_sub_acct_provi_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,provi_dt date -- 计提日期
    ,dep_acct_id varchar2(60) -- 存款账户编号
    ,dep_prod_sub_acct_id varchar2(60) -- 存款产品分户编号
    ,org_id varchar2(60) -- 机构编号
    ,prod_id varchar2(60) -- 产品编号
    ,dep_bal number(30,2) -- 存款余额
    ,td_int_paybl number(30,2) -- 当日应付利息
    ,exec_int_rat number(18,8) -- 执行利率
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,etl_dt date -- ETL处理日期
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
grant select on ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b to ${icl_schema};
grant select on ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b to ${idl_schema};
grant select on ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b is '联合存款分户计提登记簿';
comment on column ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b.provi_dt is '计提日期';
comment on column ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b.dep_acct_id is '存款账户编号';
comment on column ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b.dep_prod_sub_acct_id is '存款产品分户编号';
comment on column ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b.org_id is '机构编号';
comment on column ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b.prod_id is '产品编号';
comment on column ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b.dep_bal is '存款余额';
comment on column ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b.td_int_paybl is '当日应付利息';
comment on column ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b.exec_int_rat is '执行利率';
comment on column ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b.etl_timestamp is 'ETL处理时间戳';
