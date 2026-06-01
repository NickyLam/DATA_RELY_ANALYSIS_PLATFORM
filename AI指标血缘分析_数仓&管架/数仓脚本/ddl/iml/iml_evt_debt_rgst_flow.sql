/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_debt_rgst_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_debt_rgst_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_debt_rgst_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_debt_rgst_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,acct_name varchar2(500) -- 账户名称
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,acct_id varchar2(100) -- 账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,priv_flg varchar2(10) -- 对私标志
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,amt number(30,2) -- 金额
    ,debit_crdt_flg varchar2(10) -- 借贷标志
    ,real_cntpty_cust_acct_num varchar2(60) -- 真实交易对手客户账号
    ,real_cntpty_name varchar2(500) -- 真实交易对手名称
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,tran_revs_flg varchar2(10) -- 交易冲正标志
    ,post_flg varchar2(10) -- 过账标志
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
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
grant select on ${iml_schema}.evt_debt_rgst_flow to ${icl_schema};
grant select on ${iml_schema}.evt_debt_rgst_flow to ${idl_schema};
grant select on ${iml_schema}.evt_debt_rgst_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_debt_rgst_flow is '以资抵债登记流水';
comment on column ${iml_schema}.evt_debt_rgst_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_debt_rgst_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_debt_rgst_flow.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_debt_rgst_flow.acct_name is '账户名称';
comment on column ${iml_schema}.evt_debt_rgst_flow.prod_id is '产品编号';
comment on column ${iml_schema}.evt_debt_rgst_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_debt_rgst_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_debt_rgst_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_debt_rgst_flow.priv_flg is '对私标志';
comment on column ${iml_schema}.evt_debt_rgst_flow.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_debt_rgst_flow.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.evt_debt_rgst_flow.amt is '金额';
comment on column ${iml_schema}.evt_debt_rgst_flow.debit_crdt_flg is '借贷标志';
comment on column ${iml_schema}.evt_debt_rgst_flow.real_cntpty_cust_acct_num is '真实交易对手客户账号';
comment on column ${iml_schema}.evt_debt_rgst_flow.real_cntpty_name is '真实交易对手名称';
comment on column ${iml_schema}.evt_debt_rgst_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_debt_rgst_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_debt_rgst_flow.tran_revs_flg is '交易冲正标志';
comment on column ${iml_schema}.evt_debt_rgst_flow.post_flg is '过账标志';
comment on column ${iml_schema}.evt_debt_rgst_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_debt_rgst_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_debt_rgst_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_debt_rgst_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_debt_rgst_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_debt_rgst_flow.etl_timestamp is 'ETL处理时间戳';
