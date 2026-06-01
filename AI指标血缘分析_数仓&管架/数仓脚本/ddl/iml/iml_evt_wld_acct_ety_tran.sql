/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_wld_acct_ety_tran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_wld_acct_ety_tran
whenever sqlerror continue none;
drop table ${iml_schema}.evt_wld_acct_ety_tran purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wld_acct_ety_tran(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,ser_num varchar2(60) -- 序列号
    ,batch_doc_name varchar2(150) -- 批量文件名称
    ,batch_dt date -- 批量日期
    ,grouping_seq_num varchar2(60) -- 分组序号
    ,evt_tran_code varchar2(45) -- 事件交易码
    ,core_tran_flow varchar2(90) -- 核心交易流水
    ,tran_descb varchar2(375) -- 交易描述
    ,perds number(10) -- 期数
    ,card_no varchar2(60) -- 卡号
    ,curr_cd varchar2(10) -- 币种代码
    ,enter_acct_amt number(30,2) -- 入账金额
    ,debit_crdt_flg varchar2(10) -- 借贷标志
    ,enter_acct_way_cd varchar2(10) -- 入账方式代码
    ,subrch_id varchar2(60) -- 支行编号
    ,subj_id varchar2(60) -- 科目编号
    ,loan_prod_id varchar2(60) -- 贷款产品编号
    ,crdt_plan_id varchar2(60) -- 信用计划编号
    ,syn_id varchar2(60) -- 银团编号
    ,bank_id varchar2(60) -- 银行编号
    ,rb_w_flg varchar2(10) -- 红蓝字标志
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,aging_group_cd varchar2(10) -- 账龄组代码
    ,bal_compnt_group_cd varchar2(10) -- 余额成分组代码
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
grant select on ${iml_schema}.evt_wld_acct_ety_tran to ${icl_schema};
grant select on ${iml_schema}.evt_wld_acct_ety_tran to ${idl_schema};
grant select on ${iml_schema}.evt_wld_acct_ety_tran to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_wld_acct_ety_tran is '微粒贷会计分录交易事件';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.evt_id is '事件编号';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.lp_id is '法人编号';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.ser_num is '序列号';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.batch_doc_name is '批量文件名称';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.batch_dt is '批量日期';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.grouping_seq_num is '分组序号';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.evt_tran_code is '事件交易码';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.core_tran_flow is '核心交易流水';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.tran_descb is '交易描述';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.perds is '期数';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.card_no is '卡号';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.enter_acct_amt is '入账金额';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.debit_crdt_flg is '借贷标志';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.enter_acct_way_cd is '入账方式代码';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.subrch_id is '支行编号';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.subj_id is '科目编号';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.loan_prod_id is '贷款产品编号';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.crdt_plan_id is '信用计划编号';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.syn_id is '银团编号';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.bank_id is '银行编号';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.rb_w_flg is '红蓝字标志';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.aging_group_cd is '账龄组代码';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.bal_compnt_group_cd is '余额成分组代码';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.job_cd is '任务编码';
comment on column ${iml_schema}.evt_wld_acct_ety_tran.etl_timestamp is 'ETL处理时间戳';
