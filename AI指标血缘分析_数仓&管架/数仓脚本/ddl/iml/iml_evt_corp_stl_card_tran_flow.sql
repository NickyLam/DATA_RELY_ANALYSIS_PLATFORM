/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_corp_stl_card_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_corp_stl_card_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_corp_stl_card_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_corp_stl_card_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,lp_id varchar2(100) -- 法人编号
    ,glob_tran_flow_num varchar2(100) -- 全局交易流水号
    ,card_no varchar2(60) -- 卡号
    ,card_prod_id varchar2(100) -- 卡产品编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,acct_sub_acct_num varchar2(60) -- 账户子账号
    ,acct_curr_cd varchar2(30) -- 账户币种代码
    ,acct_prod_id varchar2(100) -- 账户产品编号
    ,cust_id varchar2(100) -- 客户编号
    ,tran_dt date -- 交易日期
    ,tran_cd varchar2(30) -- 交易码
    ,evt_cate_id varchar2(100) -- 事件类别编号
    ,tran_amt number(30,2) -- 交易金额
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,cntpty_card_no varchar2(60) -- 交易对手卡号
    ,cntpty_card_prod_id varchar2(100) -- 交易对手卡产品编号
    ,cntpty_cust_acct_num varchar2(60) -- 交易对手客户账号
    ,sign_cntpty_curr_cd varchar2(30) -- 签约对手币种代码
    ,cntpty_acct_sub_acct_num varchar2(60) -- 交易对手账户子账号
    ,cntpty_acct_prod_id varchar2(100) -- 交易对手账户产品编号
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
grant select on ${iml_schema}.evt_corp_stl_card_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_corp_stl_card_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_corp_stl_card_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_corp_stl_card_tran_flow is '单位结算卡交易流水';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.glob_tran_flow_num is '全局交易流水号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.card_no is '卡号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.card_prod_id is '卡产品编号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.acct_sub_acct_num is '账户子账号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.acct_curr_cd is '账户币种代码';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.acct_prod_id is '账户产品编号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.tran_cd is '交易码';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.evt_cate_id is '事件类别编号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.cntpty_card_no is '交易对手卡号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.cntpty_card_prod_id is '交易对手卡产品编号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.cntpty_cust_acct_num is '交易对手客户账号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.sign_cntpty_curr_cd is '签约对手币种代码';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.cntpty_acct_sub_acct_num is '交易对手账户子账号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.cntpty_acct_prod_id is '交易对手账户产品编号';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_corp_stl_card_tran_flow.etl_timestamp is 'ETL处理时间戳';
