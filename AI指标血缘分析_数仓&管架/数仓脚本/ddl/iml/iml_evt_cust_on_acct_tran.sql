/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_cust_on_acct_tran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_cust_on_acct_tran
whenever sqlerror continue none;
drop table ${iml_schema}.evt_cust_on_acct_tran purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cust_on_acct_tran(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,on_acct_seq_num varchar2(60) -- 挂账序号
    ,on_acct_sub_acct_num varchar2(60) -- 挂账子账号
    ,curr_cd varchar2(30) -- 币种代码
    ,cust_acct_num varchar2(60) -- 客户账号
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cert_no varchar2(60) -- 证件号码
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,appl_cust_id varchar2(100) -- 申请客户编号
    ,debit_crdt_flg varchar2(10) -- 借贷标志
    ,on_acct_tot number(30,2) -- 挂账总额
    ,on_acct_amt number(30,2) -- 挂账金额
    ,on_acct_bal number(30,2) -- 挂账余额
    ,on_acct_exp_dt date -- 挂账到期日期
    ,cap_src_cd varchar2(30) -- 资金来源代码
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,tran_dt date -- 交易日期
    ,tran_tm date -- 交易时间
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,cntpty_acct_name varchar2(500) -- 交易对手账户名称
    ,cntpty_acct_id varchar2(100) -- 交易对手账户编号
    ,cntpty_open_acct_org_id varchar2(100) -- 交易对手开户机构编号
    ,cntpty_acct_bank_int_flg varchar2(10) -- 交易对手账户行内标志
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_memo_descb varchar2(500) -- 交易摘要描述
    ,stl_acct_name varchar2(500) -- 结算账户名称
    ,stl_acct_id varchar2(100) -- 结算账户编号
    ,gold_bus_id varchar2(100) -- 押金业务编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,last_modif_dt date -- 上次修改日期
    ,final_modif_dt date -- 最后修改日期
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
grant select on ${iml_schema}.evt_cust_on_acct_tran to ${icl_schema};
grant select on ${iml_schema}.evt_cust_on_acct_tran to ${idl_schema};
grant select on ${iml_schema}.evt_cust_on_acct_tran to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_cust_on_acct_tran is '客户挂账交易事件';
comment on column ${iml_schema}.evt_cust_on_acct_tran.evt_id is '事件编号';
comment on column ${iml_schema}.evt_cust_on_acct_tran.lp_id is '法人编号';
comment on column ${iml_schema}.evt_cust_on_acct_tran.on_acct_seq_num is '挂账序号';
comment on column ${iml_schema}.evt_cust_on_acct_tran.on_acct_sub_acct_num is '挂账子账号';
comment on column ${iml_schema}.evt_cust_on_acct_tran.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_cust_on_acct_tran.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_cust_on_acct_tran.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_cust_on_acct_tran.cust_id is '客户编号';
comment on column ${iml_schema}.evt_cust_on_acct_tran.cust_name is '客户名称';
comment on column ${iml_schema}.evt_cust_on_acct_tran.cert_no is '证件号码';
comment on column ${iml_schema}.evt_cust_on_acct_tran.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.evt_cust_on_acct_tran.appl_cust_id is '申请客户编号';
comment on column ${iml_schema}.evt_cust_on_acct_tran.debit_crdt_flg is '借贷标志';
comment on column ${iml_schema}.evt_cust_on_acct_tran.on_acct_tot is '挂账总额';
comment on column ${iml_schema}.evt_cust_on_acct_tran.on_acct_amt is '挂账金额';
comment on column ${iml_schema}.evt_cust_on_acct_tran.on_acct_bal is '挂账余额';
comment on column ${iml_schema}.evt_cust_on_acct_tran.on_acct_exp_dt is '挂账到期日期';
comment on column ${iml_schema}.evt_cust_on_acct_tran.cap_src_cd is '资金来源代码';
comment on column ${iml_schema}.evt_cust_on_acct_tran.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_cust_on_acct_tran.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_cust_on_acct_tran.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_cust_on_acct_tran.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_cust_on_acct_tran.cntpty_acct_name is '交易对手账户名称';
comment on column ${iml_schema}.evt_cust_on_acct_tran.cntpty_acct_id is '交易对手账户编号';
comment on column ${iml_schema}.evt_cust_on_acct_tran.cntpty_open_acct_org_id is '交易对手开户机构编号';
comment on column ${iml_schema}.evt_cust_on_acct_tran.cntpty_acct_bank_int_flg is '交易对手账户行内标志';
comment on column ${iml_schema}.evt_cust_on_acct_tran.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_cust_on_acct_tran.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_cust_on_acct_tran.tran_memo_descb is '交易摘要描述';
comment on column ${iml_schema}.evt_cust_on_acct_tran.stl_acct_name is '结算账户名称';
comment on column ${iml_schema}.evt_cust_on_acct_tran.stl_acct_id is '结算账户编号';
comment on column ${iml_schema}.evt_cust_on_acct_tran.gold_bus_id is '押金业务编号';
comment on column ${iml_schema}.evt_cust_on_acct_tran.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_cust_on_acct_tran.last_modif_dt is '上次修改日期';
comment on column ${iml_schema}.evt_cust_on_acct_tran.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.evt_cust_on_acct_tran.start_dt is '开始时间';
comment on column ${iml_schema}.evt_cust_on_acct_tran.end_dt is '结束时间';
comment on column ${iml_schema}.evt_cust_on_acct_tran.id_mark is '增删标志';
comment on column ${iml_schema}.evt_cust_on_acct_tran.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_cust_on_acct_tran.job_cd is '任务编码';
comment on column ${iml_schema}.evt_cust_on_acct_tran.etl_timestamp is 'ETL处理时间戳';
