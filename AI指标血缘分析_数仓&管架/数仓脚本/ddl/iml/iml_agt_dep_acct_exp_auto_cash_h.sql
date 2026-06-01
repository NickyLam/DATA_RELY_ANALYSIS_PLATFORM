/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_dep_acct_exp_auto_cash_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_dep_acct_exp_auto_cash_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_dep_acct_exp_auto_cash_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_exp_auto_cash_h(
    agt_id varchar2(250) -- 协议编号
    ,acct_id varchar2(100) -- 账户编号
    ,lp_id varchar2(100) -- 法人编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,sub_acct_num varchar2(60) -- 子账号
    ,seq_num varchar2(60) -- 序号
    ,curr_cd varchar2(30) -- 币种代码
    ,prod_id varchar2(100) -- 产品编号
    ,acct_name varchar2(500) -- 账户名称
    ,open_acct_dt date -- 开户日期
    ,exp_dt date -- 到期日期
    ,tran_dt date -- 交易日期
    ,core_tran_org_id varchar2(100) -- 核心交易机构编号
    ,int_amt number(30,2) -- 利息金额
    ,pric_amt number(30,2) -- 本金金额
    ,cash_redem_amt number(30,2) -- 兑付赎回金额
    ,exec_year_int_rat number(18,8) -- 执行年利率
    ,proc_cate_cd varchar2(30) -- 处理类别代码
    ,pric_int_enter_acct_cust_id varchar2(100) -- 本息入账客户编号
    ,pric_int_enter_acct_cust_acct_num varchar2(60) -- 本息入账客户账号
    ,pric_int_enter_acct_sub_acct_num varchar2(60) -- 本息入账子账号
    ,pric_int_enter_curr_cd varchar2(30) -- 本息入账账户币种代码
    ,pric_int_enter_prod_id varchar2(100) -- 本息入账账户产品编号
    ,int_enter_name varchar2(500) -- 利息入账账户名称
    ,pd_cd varchar2(30) -- 期次编号
    ,pd_prod_cate_cd varchar2(30) -- 期次产品类别代码
    ,rest_cd varchar2(30) -- 处理结果代码
    ,fail_rs_descb varchar2(2000) -- 失败原因描述
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_dep_acct_exp_auto_cash_h to ${icl_schema};
grant select on ${iml_schema}.agt_dep_acct_exp_auto_cash_h to ${idl_schema};
grant select on ${iml_schema}.agt_dep_acct_exp_auto_cash_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_dep_acct_exp_auto_cash_h is '存款账户到期自动兑付历史';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.seq_num is '序号';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.acct_name is '账户名称';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.open_acct_dt is '开户日期';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.core_tran_org_id is '核心交易机构编号';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.int_amt is '利息金额';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.pric_amt is '本金金额';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.cash_redem_amt is '兑付赎回金额';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.exec_year_int_rat is '执行年利率';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.proc_cate_cd is '处理类别代码';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.pric_int_enter_acct_cust_id is '本息入账客户编号';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.pric_int_enter_acct_cust_acct_num is '本息入账客户账号';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.pric_int_enter_acct_sub_acct_num is '本息入账子账号';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.pric_int_enter_curr_cd is '本息入账账户币种代码';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.pric_int_enter_prod_id is '本息入账账户产品编号';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.int_enter_name is '利息入账账户名称';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.pd_cd is '期次编号';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.pd_prod_cate_cd is '期次产品类别代码';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.rest_cd is '处理结果代码';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.fail_rs_descb is '失败原因描述';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_dep_acct_exp_auto_cash_h.etl_timestamp is 'ETL处理时间戳';
