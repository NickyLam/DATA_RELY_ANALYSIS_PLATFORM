/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_conl_bk_payoff_batch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_conl_bk_payoff_batch
whenever sqlerror continue none;
drop table ${iml_schema}.evt_conl_bk_payoff_batch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_conl_bk_payoff_batch(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,chn_id varchar2(10) -- 渠道编号
    ,batch_id varchar2(30) -- 批次编号
    ,batch_dt date -- 批次日期
    ,payoff_kind_cd varchar2(10) -- 代发种类代码
    ,re_payoff_sys_cd varchar2(30) -- 实际代发系统代码
    ,chn_dt date -- 渠道日期
    ,chn_seq_num varchar2(30) -- 渠道序号
    ,batch_doc_id varchar2(60) -- 批量文件编号
    ,cust_id varchar2(30) -- 客户编号
    ,tran_out_acct_id varchar2(60) -- 转出账户编号
    ,tran_out_acct_name varchar2(500) -- 转出账户名称
    ,curr_cd varchar2(10) -- 币种代码
    ,tot_qtty number(10) -- 总数量
    ,sucs_tot_qtty number(10) -- 成功总数量
    ,fail_tot_qtty number(10) -- 失败总数量
    ,tot_amt number(30,2) -- 总金额
    ,sucs_tot_amt number(30,2) -- 成功总金额
    ,fail_tot_amt number(30,2) -- 失败总金额
    ,tran_tm varchar2(30) -- 交易时间
    ,need_acct_tran_flg varchar2(10) -- 需要账户过渡标志
    ,tran_acct_id varchar2(60) -- 过渡账户编号
    ,tran_acct_name varchar2(500) -- 过渡账户名称
    ,postsc varchar2(1000) -- 附言
    ,flow_status_cd varchar2(10) -- 流程状态代码
    ,err_info_desc varchar2(1000) -- 错误信息描述
    ,cntpty_acct_bank_out_flg varchar2(10) -- 对手账户行外标志
    ,corp_acct_bank_out_flg varchar2(10) -- 对公账户行外标志
    ,tran_inside_acct_acct_num varchar2(60) -- 过渡内部户账号
    ,tran_inside_acct_name varchar2(500) -- 过渡内部户名称
    ,core_prpery_flow_num varchar2(200) -- 核心外围流水号
    ,core_flow_num varchar2(200) -- 核心流水号
    ,core_entry_dt date -- 核心记账日期
    ,sign_org_id varchar2(30) -- 签约机构编号
    ,tran_teller_id varchar2(30) -- 交易柜员编号
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
grant select on ${iml_schema}.evt_conl_bk_payoff_batch to ${icl_schema};
grant select on ${iml_schema}.evt_conl_bk_payoff_batch to ${idl_schema};
grant select on ${iml_schema}.evt_conl_bk_payoff_batch to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_conl_bk_payoff_batch is '企业网银代发批次';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.evt_id is '事件编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.lp_id is '法人编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.batch_id is '批次编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.batch_dt is '批次日期';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.payoff_kind_cd is '代发种类代码';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.re_payoff_sys_cd is '实际代发系统代码';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.chn_dt is '渠道日期';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.chn_seq_num is '渠道序号';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.batch_doc_id is '批量文件编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.cust_id is '客户编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.tran_out_acct_id is '转出账户编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.tran_out_acct_name is '转出账户名称';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.tot_qtty is '总数量';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.sucs_tot_qtty is '成功总数量';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.fail_tot_qtty is '失败总数量';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.tot_amt is '总金额';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.sucs_tot_amt is '成功总金额';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.fail_tot_amt is '失败总金额';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.need_acct_tran_flg is '需要账户过渡标志';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.tran_acct_id is '过渡账户编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.tran_acct_name is '过渡账户名称';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.postsc is '附言';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.flow_status_cd is '流程状态代码';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.err_info_desc is '错误信息描述';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.cntpty_acct_bank_out_flg is '对手账户行外标志';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.corp_acct_bank_out_flg is '对公账户行外标志';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.tran_inside_acct_acct_num is '过渡内部户账号';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.tran_inside_acct_name is '过渡内部户名称';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.core_prpery_flow_num is '核心外围流水号';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.core_entry_dt is '核心记账日期';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.sign_org_id is '签约机构编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.job_cd is '任务编码';
comment on column ${iml_schema}.evt_conl_bk_payoff_batch.etl_timestamp is 'ETL处理时间戳';
