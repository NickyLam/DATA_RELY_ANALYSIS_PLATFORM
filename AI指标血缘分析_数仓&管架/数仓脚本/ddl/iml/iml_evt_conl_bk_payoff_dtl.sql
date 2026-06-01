/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_conl_bk_payoff_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_conl_bk_payoff_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_conl_bk_payoff_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_conl_bk_payoff_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,batch_id varchar2(30) -- 批次编号
    ,batch_dt date -- 批次日期
    ,rec_id varchar2(60) -- 记录编号
    ,chn_dt date -- 渠道日期
    ,chn_seq_num varchar2(10) -- 渠道序号
    ,conl_bk_tran_type_cd varchar2(10) -- 企业网银交易类型代码
    ,dtl_acct_id varchar2(60) -- 明细账户编号
    ,dtl_acct_name varchar2(500) -- 明细账户名称
    ,tran_amt number(30,2) -- 交易金额
    ,tran_sucs_amt number(30,2) -- 交易成功金额
    ,deduct_mode_cd varchar2(30) -- 扣款模式代码
    ,core_memo_cd varchar2(10) -- 核心摘要代码
    ,corp_agent_acct varchar2(90) -- 对公代理账户
    ,core_tran_flow_num varchar2(200) -- 核心交易流水号
    ,core_tran_dt date -- 核心交易日期
    ,resp_code varchar2(45) -- 响应码
    ,resp_code_descb varchar2(1000) -- 响应码描述
    ,cntpty_acct_bank_num varchar2(60) -- 对手账户行号
    ,postsc varchar2(1000) -- 附言
    ,unify_pay_order_no varchar2(200) -- 统一支付订单号
    ,unify_pay_flow_num varchar2(60) -- 统一支付流水号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,ova_flow_num varchar2(100) -- 全局流水号
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
grant select on ${iml_schema}.evt_conl_bk_payoff_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_conl_bk_payoff_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_conl_bk_payoff_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_conl_bk_payoff_dtl is '企业网银代发明细';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.batch_id is '批次编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.batch_dt is '批次日期';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.rec_id is '记录编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.chn_dt is '渠道日期';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.chn_seq_num is '渠道序号';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.conl_bk_tran_type_cd is '企业网银交易类型代码';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.dtl_acct_id is '明细账户编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.dtl_acct_name is '明细账户名称';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.tran_sucs_amt is '交易成功金额';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.deduct_mode_cd is '扣款模式代码';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.core_memo_cd is '核心摘要代码';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.corp_agent_acct is '对公代理账户';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.core_tran_flow_num is '核心交易流水号';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.core_tran_dt is '核心交易日期';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.resp_code is '响应码';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.resp_code_descb is '响应码描述';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.cntpty_acct_bank_num is '对手账户行号';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.postsc is '附言';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.unify_pay_order_no is '统一支付订单号';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.unify_pay_flow_num is '统一支付流水号';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_conl_bk_payoff_dtl.etl_timestamp is 'ETL处理时间戳';
