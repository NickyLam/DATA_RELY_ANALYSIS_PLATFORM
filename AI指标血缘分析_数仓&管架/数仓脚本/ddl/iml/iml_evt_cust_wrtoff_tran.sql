/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_cust_wrtoff_tran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_cust_wrtoff_tran
whenever sqlerror continue none;
drop table ${iml_schema}.evt_cust_wrtoff_tran purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cust_wrtoff_tran(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,wrtoff_seq_num varchar2(60) -- 销账序号
    ,on_acct_seq_num varchar2(60) -- 挂账序号
    ,on_acct_sub_acct_num varchar2(60) -- 挂账子账号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,cust_id varchar2(100) -- 客户编号
    ,curr_cd varchar2(30) -- 币种代码
    ,on_acct_bal number(30,2) -- 挂账余额
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,tran_dt date -- 交易日期
    ,tran_tm date -- 交易时间
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,wrtoff_amt number(30,2) -- 销账金额
    ,cap_src_cd varchar2(30) -- 资金来源代码
    ,cntpty_acct_name varchar2(500) -- 交易对手账户名称
    ,cntpty_acct_id varchar2(100) -- 交易对手账户编号
    ,cntpty_open_acct_org_id varchar2(100) -- 交易对手开户机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_memo_descb varchar2(500) -- 交易摘要描述
    ,auth_teller_id varchar2(100) -- 授权柜员编号
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
grant select on ${iml_schema}.evt_cust_wrtoff_tran to ${icl_schema};
grant select on ${iml_schema}.evt_cust_wrtoff_tran to ${idl_schema};
grant select on ${iml_schema}.evt_cust_wrtoff_tran to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_cust_wrtoff_tran is '客户销账交易事件';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.evt_id is '事件编号';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.lp_id is '法人编号';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.wrtoff_seq_num is '销账序号';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.on_acct_seq_num is '挂账序号';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.on_acct_sub_acct_num is '挂账子账号';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.cust_id is '客户编号';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.on_acct_bal is '挂账余额';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.wrtoff_amt is '销账金额';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.cap_src_cd is '资金来源代码';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.cntpty_acct_name is '交易对手账户名称';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.cntpty_acct_id is '交易对手账户编号';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.cntpty_open_acct_org_id is '交易对手开户机构编号';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.tran_memo_descb is '交易摘要描述';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.start_dt is '开始时间';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.end_dt is '结束时间';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.id_mark is '增删标志';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.job_cd is '任务编码';
comment on column ${iml_schema}.evt_cust_wrtoff_tran.etl_timestamp is 'ETL处理时间戳';
