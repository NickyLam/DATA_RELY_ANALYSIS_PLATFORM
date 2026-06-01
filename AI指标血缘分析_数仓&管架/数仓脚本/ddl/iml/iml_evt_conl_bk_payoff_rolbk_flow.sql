/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_conl_bk_payoff_rolbk_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_conl_bk_payoff_rolbk_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_conl_bk_payoff_rolbk_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_conl_bk_payoff_rolbk_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,tran_amt number(30,2) -- 交易金额
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_tm date -- 交易时间
    ,tran_rest_cd varchar2(30) -- 交易结果代码
    ,midgrod_dt date -- 中台日期
    ,midgrod_flow_num varchar2(100) -- 中台流水号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,tran_inside_acct_acct_num varchar2(60) -- 过渡内部户账号
    ,tran_inside_acct_name varchar2(500) -- 过渡内部户名称
    ,tran_out_acct_id varchar2(100) -- 转出账户编号
    ,tran_out_acct_name varchar2(1000) -- 转出账户名称
    ,tran_in_acct_id varchar2(100) -- 转入账户编号
    ,tran_in_acct_name varchar2(500) -- 转入账户名称
    ,cust_id varchar2(100) -- 客户编号
    ,core_dt date -- 核心日期
    ,core_flow_num varchar2(100) -- 核心流水号
    ,remark varchar2(500) -- 备注
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
grant select on ${iml_schema}.evt_conl_bk_payoff_rolbk_flow to ${icl_schema};
grant select on ${iml_schema}.evt_conl_bk_payoff_rolbk_flow to ${idl_schema};
grant select on ${iml_schema}.evt_conl_bk_payoff_rolbk_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_conl_bk_payoff_rolbk_flow is '企业网银代发回退流水';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.tran_rest_cd is '交易结果代码';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.midgrod_dt is '中台日期';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.midgrod_flow_num is '中台流水号';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.tran_inside_acct_acct_num is '过渡内部户账号';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.tran_inside_acct_name is '过渡内部户名称';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.tran_out_acct_id is '转出账户编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.tran_out_acct_name is '转出账户名称';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.tran_in_acct_id is '转入账户编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.tran_in_acct_name is '转入账户名称';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.core_dt is '核心日期';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.remark is '备注';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_conl_bk_payoff_rolbk_flow.etl_timestamp is 'ETL处理时间戳';
