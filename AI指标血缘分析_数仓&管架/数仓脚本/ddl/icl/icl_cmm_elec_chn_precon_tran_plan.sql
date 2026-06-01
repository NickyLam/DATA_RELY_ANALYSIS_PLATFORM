/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_elec_chn_precon_tran_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_elec_chn_precon_tran_plan
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_elec_chn_precon_tran_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_elec_chn_precon_tran_plan(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,timing_task_id varchar2(60) -- 定时任务编号
    ,timing_task_type_cd varchar2(10) -- 定时任务类型代码
    ,cust_id varchar2(60) -- 客户编号
    ,timing_task_fomult_dt date -- 定时任务制定日期
    ,timing_kind_cd varchar2(10) -- 定时种类代码
    ,timing_freq_kind_cd varchar2(10) -- 定时频率种类代码
    ,timing_rule_descb varchar2(500) -- 定时规则描述
    ,timing_task_status_cd varchar2(10) -- 定时任务状态代码
    ,timing_task_start_dt date -- 定时任务开始日期
    ,timing_task_end_dt date -- 定时任务结束日期
    ,timing_task_cancel_dt date -- 定时任务取消日期
    ,payer_bank_no varchar2(60) -- 付款人行号
    ,payer_acct_id varchar2(60) -- 付款人账户编号
    ,cntpty_acct_id varchar2(60) -- 交易对手账号
    ,cntpty_acct_name varchar2(500) -- 交易对手账户名称
    ,cntpty_acct_open_bank_num varchar2(60) -- 交易对手账户开户行号
    ,cntpty_acct_open_bank_name varchar2(500) -- 交易对手账户开户行名
    ,cntpty_acct_prov_cd varchar2(30) -- 交易对手账户省份代码
    ,cntpty_acct_city_cd varchar2(30) -- 交易对手账户城市代码
    ,cntpty_acct_org_id varchar2(60) -- 交易对手账户机构编号
    ,cntpty_acct_org_name varchar2(500) -- 交易对手账户机构名称
    ,cntpty_acct_clear_bk_num varchar2(60) -- 交易对手账户清算行号
    ,cntpty_mobile_no varchar2(60) -- 交易对手手机号码
    ,plan_exec_cnt number(10) -- 计划执行次数
    ,execed_cnt number(10) -- 已执行次数
    ,sucs_cnt number(10) -- 成功次数
    ,sucs_amt number(30,2) -- 成功金额
    ,fail_cnt number(10) -- 失败次数
    ,fail_amt number(30,2) -- 失败金额
    ,not_exec_cnt number(10) -- 未执行次数
    ,plan_src_cd varchar2(10) -- 计划来源代码
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_elec_chn_precon_tran_plan to ${idl_schema};
grant select on ${icl_schema}.cmm_elec_chn_precon_tran_plan to ${iel_schema};
grant select on ${icl_schema}.cmm_elec_chn_precon_tran_plan to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_elec_chn_precon_tran_plan is '电子渠道预约交易计划';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.timing_task_id is '定时任务编号';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.timing_task_type_cd is '定时任务类型代码';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.timing_task_fomult_dt is '定时任务制定日期';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.timing_kind_cd is '定时种类代码';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.timing_freq_kind_cd is '定时频率种类代码';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.timing_rule_descb is '定时规则描述';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.timing_task_status_cd is '定时任务状态代码';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.timing_task_start_dt is '定时任务开始日期';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.timing_task_end_dt is '定时任务结束日期';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.timing_task_cancel_dt is '定时任务取消日期';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.payer_bank_no is '付款人行号';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.payer_acct_id is '付款人账户编号';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.cntpty_acct_id is '交易对手账号';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.cntpty_acct_name is '交易对手账户名称';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.cntpty_acct_open_bank_num is '交易对手账户开户行号';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.cntpty_acct_open_bank_name is '交易对手账户开户行名';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.cntpty_acct_prov_cd is '交易对手账户省份代码';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.cntpty_acct_city_cd is '交易对手账户城市代码';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.cntpty_acct_org_id is '交易对手账户机构编号';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.cntpty_acct_org_name is '交易对手账户机构名称';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.cntpty_acct_clear_bk_num is '交易对手账户清算行号';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.cntpty_mobile_no is '交易对手手机号码';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.plan_exec_cnt is '计划执行次数';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.execed_cnt is '已执行次数';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.sucs_cnt is '成功次数';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.sucs_amt is '成功金额';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.fail_cnt is '失败次数';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.fail_amt is '失败金额';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.not_exec_cnt is '未执行次数';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.plan_src_cd is '计划来源代码';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_elec_chn_precon_tran_plan.etl_timestamp is 'ETL处理时间戳';
