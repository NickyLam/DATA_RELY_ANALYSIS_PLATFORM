/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_wyd_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_wyd_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_wyd_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wyd_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,we_flow_num varchar2(100) -- 微众流水号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,org_id varchar2(100) -- 机构编号
    ,dubil_id varchar2(100) -- 借据编号
    ,curr_cd varchar2(30) -- 币种代码
    ,cust_id varchar2(100) -- 客户编号
    ,prod_id varchar2(100) -- 产品编号
    ,level5_cls_cd varchar2(30) -- 五级分类代码
    ,tran_code varchar2(30) -- 交易码
    ,tran_descb varchar2(500) -- 交易描述
    ,debit_crdt_flg varchar2(10) -- 借贷标志
    ,acct_id varchar2(100) -- 账户编号
    ,acct_type_cd varchar2(30) -- 账户类型代码
    ,acct_bal number(30,8) -- 账户余额
    ,cash_trans_flg varchar2(10) -- 现转标志
    ,enter_acct_amt number(30,8) -- 入账金额
    ,enter_acct_way_cd varchar2(30) -- 入账方式代码
    ,enter_acct_dt date -- 入账日期
    ,cntpty_acct_id varchar2(100) -- 交易对手账户编号
    ,cntpty_acct_name varchar2(500) -- 交易对手账户名称
    ,cntpty_bank_no varchar2(60) -- 交易对手行号
    ,cntpty_bank_name varchar2(500) -- 交易对手行名称
    ,erase_acct_flg varchar2(10) -- 冲抹标志
    ,repay_clear_tran_id varchar2(100) -- 还款清算交易编号
    ,batch_dt date -- 批量日期
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_belong_org_id varchar2(100) -- 登记所属机构编号
    ,rgst_dt date -- 登记日期
    ,final_update_teller_id varchar2(100) -- 最后更新柜员编号
    ,final_update_org_id varchar2(100) -- 最后更新机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.evt_wyd_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_wyd_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_wyd_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_wyd_tran_flow is '微业贷交易流水';
comment on column ${iml_schema}.evt_wyd_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_wyd_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_wyd_tran_flow.we_flow_num is '微众流水号';
comment on column ${iml_schema}.evt_wyd_tran_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_wyd_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_wyd_tran_flow.org_id is '机构编号';
comment on column ${iml_schema}.evt_wyd_tran_flow.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_wyd_tran_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_wyd_tran_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_wyd_tran_flow.prod_id is '产品编号';
comment on column ${iml_schema}.evt_wyd_tran_flow.level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.evt_wyd_tran_flow.tran_code is '交易码';
comment on column ${iml_schema}.evt_wyd_tran_flow.tran_descb is '交易描述';
comment on column ${iml_schema}.evt_wyd_tran_flow.debit_crdt_flg is '借贷标志';
comment on column ${iml_schema}.evt_wyd_tran_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_wyd_tran_flow.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.evt_wyd_tran_flow.acct_bal is '账户余额';
comment on column ${iml_schema}.evt_wyd_tran_flow.cash_trans_flg is '现转标志';
comment on column ${iml_schema}.evt_wyd_tran_flow.enter_acct_amt is '入账金额';
comment on column ${iml_schema}.evt_wyd_tran_flow.enter_acct_way_cd is '入账方式代码';
comment on column ${iml_schema}.evt_wyd_tran_flow.enter_acct_dt is '入账日期';
comment on column ${iml_schema}.evt_wyd_tran_flow.cntpty_acct_id is '交易对手账户编号';
comment on column ${iml_schema}.evt_wyd_tran_flow.cntpty_acct_name is '交易对手账户名称';
comment on column ${iml_schema}.evt_wyd_tran_flow.cntpty_bank_no is '交易对手行号';
comment on column ${iml_schema}.evt_wyd_tran_flow.cntpty_bank_name is '交易对手行名称';
comment on column ${iml_schema}.evt_wyd_tran_flow.erase_acct_flg is '冲抹标志';
comment on column ${iml_schema}.evt_wyd_tran_flow.repay_clear_tran_id is '还款清算交易编号';
comment on column ${iml_schema}.evt_wyd_tran_flow.batch_dt is '批量日期';
comment on column ${iml_schema}.evt_wyd_tran_flow.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.evt_wyd_tran_flow.rgst_belong_org_id is '登记所属机构编号';
comment on column ${iml_schema}.evt_wyd_tran_flow.rgst_dt is '登记日期';
comment on column ${iml_schema}.evt_wyd_tran_flow.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.evt_wyd_tran_flow.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.evt_wyd_tran_flow.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.evt_wyd_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_wyd_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_wyd_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_wyd_tran_flow.etl_timestamp is 'ETL处理时间戳';
