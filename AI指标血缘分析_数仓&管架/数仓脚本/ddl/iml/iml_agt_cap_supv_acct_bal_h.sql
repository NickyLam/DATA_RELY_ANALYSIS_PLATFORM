/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_cap_supv_acct_bal_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_cap_supv_acct_bal_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_cap_supv_acct_bal_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cap_supv_acct_bal_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,vtual_acct_id varchar2(250) -- 虚拟账户编号
    ,actl_bal number(30,2) -- 实际余额
    ,aval_bal number(30,2) -- 可用余额
    ,comm_fee_bal number(30,2) -- 手续费余额
    ,int number(30,2) -- 利息
    ,cust_tot_bal number(30,2) -- 客户总余额
    ,offs_bal number(30,2) -- 轧差余额
    ,mdl_stl_bal number(30,2) -- 中间结算余额
    ,ret_my_bal number(30,2) -- 返现余额
    ,guar_bal number(30,2) -- 担保余额
    ,ld_actl_bal number(30,2) -- 上日实际余额
    ,ld_aval_bal number(30,2) -- 上日可用余额
    ,ld_comm_fee_bal number(30,2) -- 上日手续费余额
    ,ld_int number(30,2) -- 上日利息
    ,ld_cust_tot_bal number(30,2) -- 上日客户总余额
    ,ld_offs_bal number(30,2) -- 上日轧差余额
    ,ld_mdl_stl_bal number(30,2) -- 上日中间结算余额
    ,ld_ret_my_bal number(30,2) -- 上日返现余额
    ,ld_guar_bal number(30,2) -- 上日担保余额
    ,acct_status_cd varchar2(500) -- 账户状态代码
    ,open_tm timestamp -- 开户时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_cap_supv_acct_bal_h to ${icl_schema};
grant select on ${iml_schema}.agt_cap_supv_acct_bal_h to ${idl_schema};
grant select on ${iml_schema}.agt_cap_supv_acct_bal_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_cap_supv_acct_bal_h is '资金监管账户余额历史';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.vtual_acct_id is '虚拟账户编号';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.actl_bal is '实际余额';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.aval_bal is '可用余额';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.comm_fee_bal is '手续费余额';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.int is '利息';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.cust_tot_bal is '客户总余额';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.offs_bal is '轧差余额';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.mdl_stl_bal is '中间结算余额';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.ret_my_bal is '返现余额';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.guar_bal is '担保余额';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.ld_actl_bal is '上日实际余额';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.ld_aval_bal is '上日可用余额';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.ld_comm_fee_bal is '上日手续费余额';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.ld_int is '上日利息';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.ld_cust_tot_bal is '上日客户总余额';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.ld_offs_bal is '上日轧差余额';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.ld_mdl_stl_bal is '上日中间结算余额';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.ld_ret_my_bal is '上日返现余额';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.ld_guar_bal is '上日担保余额';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.open_tm is '开户时间';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_cap_supv_acct_bal_h.etl_timestamp is 'ETL处理时间戳';
