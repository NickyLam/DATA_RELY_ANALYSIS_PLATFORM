/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl dpss_agt_dpst_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.dpss_agt_dpst_acct_info
whenever sqlerror continue none;
drop table ${idl_schema}.dpss_agt_dpst_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dpss_agt_dpst_acct_info(
    etl_dt date -- 数据日期
    ,data_src_cd varchar2(4) -- 数据来源代码
    ,del_flg char(1) -- 删除标志
    ,last_update_dt date -- 最后更新日期
    ,etl_task_name varchar2(100) -- 任务名称
    ,dpst_acct_id varchar2(60) -- 存款产品户编号
    ,prd_id varchar2(30) -- 产品编号
    ,dpst_acct_num varchar2(60) -- 存款账户编号
    ,sub_num varchar2(60) -- 子户号
    ,blng_pty_id varchar2(60) -- 所属客户编号
    ,acct_name varchar2(255) -- 账户名称
    ,dacct_typ_cd char(3) -- 存款分户类型代码
    ,open_dt date -- 开户日期
    ,open_tm varchar2(30) -- 开户时间
    ,int_start_dt date -- 起息日期
    ,due_dt date -- 到期日期
    ,prev_acti_acct_dt date -- 上次动户日期
    ,colse_dt date -- 销户日期
    ,acct_stats_cd char(4) -- 账户状态代码
    ,stop_pay_status_cd char(1) -- 止付状态代码
    ,open_org_id varchar2(30) -- 开户机构编号
    ,colse_org_id varchar2(30) -- 销户机构编号
    ,open_teller_id varchar2(30) -- 开户柜员编号
    ,colse_teller_id varchar2(30) -- 销户柜员编号
    ,pty_mgr_id varchar2(30) -- 客户经理编号
    ,cash_remit_ind_cd char(1) -- 钞汇标识代码
    ,dps_type_cd char(3) -- 储种代码
    ,usw_flg char(1) -- 通存通兑标志
    ,sleep_flg char(1) -- 睡眠户标志
    ,ccy_cd char(3) -- 币种代码
    ,acct_bal number(18,2) -- 账户余额
    ,usable_bal number(18,2) -- 可用余额
    ,dacct_acct_frz_amt number(18,2) -- 冻结金额
    ,stop_pay_amt number(18,2) -- 止付金额
    ,rate_base_typ_cd char(3) -- 利率基准类型代码
    ,rate_base_val number(14,10) -- 利率基准值
    ,float_rate_flg char(1) -- 浮动利率标志
    ,rate_float_mode_cd char(1) -- 利率浮动方式代码
    ,rate_float_val number(14,10) -- 利率浮动值
    ,exec_rate number(14,10) -- 执行利率
    ,rcva_int number(18,2) -- 应计利息
    ,day_accr_int number(18,2) -- 日应计利息
    ,dacct_stl_mode_cd char(2) -- 结息方式代码
    ,dacct_intr_mth_cd char(4) -- 计息方式代码
    ,merch_id varchar2(20) -- 商户编号
    ,merch_name varchar2(128) -- 商户名称
    ,merch_up_line_dt date -- 商户上线日期
    ,int_base_cd varchar2(2) -- 计息基准代码
    ,expt_highest_yld number(14,10) -- 预期最高收益率
    ,contr_id varchar2(50) -- 合同编号
    ,contr_due_dt date -- 合同到期日期
    ,co_org_name varchar2(100) -- 合作机构名称
    ,issue_dpst_proof_bk_flg char(1) -- 开立存款证实书标志
    ,cust_acct_id varchar2(60) -- 客户账户编号
    ,cust_sub_acct_num varchar2(100) -- 客户账户子户号
    ,term_code varchar2(5) -- 存期编码
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.dpss_agt_dpst_acct_info to iel;

-- comment
comment on table ${idl_schema}.dpss_agt_dpst_acct_info is '存款分户基本信息';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.etl_dt is '数据日期';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.data_src_cd is '数据来源代码';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.del_flg is '删除标志';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.last_update_dt is '最后更新日期';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.etl_task_name is '任务名称';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.dpst_acct_id is '存款产品户编号';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.prd_id is '产品编号';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.dpst_acct_num is '存款账户编号';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.sub_num is '子户号';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.blng_pty_id is '所属客户编号';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.acct_name is '账户名称';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.dacct_typ_cd is '存款分户类型代码';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.open_dt is '开户日期';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.open_tm is '开户时间';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.int_start_dt is '起息日期';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.due_dt is '到期日期';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.prev_acti_acct_dt is '上次动户日期';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.colse_dt is '销户日期';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.acct_stats_cd is '账户状态代码';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.stop_pay_status_cd is '止付状态代码';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.open_org_id is '开户机构编号';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.colse_org_id is '销户机构编号';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.open_teller_id is '开户柜员编号';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.colse_teller_id is '销户柜员编号';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.pty_mgr_id is '客户经理编号';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.cash_remit_ind_cd is '钞汇标识代码';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.dps_type_cd is '储种代码';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.usw_flg is '通存通兑标志';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.sleep_flg is '睡眠户标志';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.ccy_cd is '币种代码';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.acct_bal is '账户余额';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.usable_bal is '可用余额';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.dacct_acct_frz_amt is '冻结金额';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.stop_pay_amt is '止付金额';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.rate_base_typ_cd is '利率基准类型代码';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.rate_base_val is '利率基准值';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.float_rate_flg is '浮动利率标志';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.rate_float_mode_cd is '利率浮动方式代码';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.rate_float_val is '利率浮动值';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.exec_rate is '执行利率';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.rcva_int is '应计利息';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.day_accr_int is '日应计利息';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.dacct_stl_mode_cd is '结息方式代码';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.dacct_intr_mth_cd is '计息方式代码';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.merch_id is '商户编号';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.merch_name is '商户名称';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.merch_up_line_dt is '商户上线日期';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.int_base_cd is '计息基准代码';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.expt_highest_yld is '预期最高收益率';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.contr_id is '合同编号';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.contr_due_dt is '合同到期日期';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.co_org_name is '合作机构名称';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.issue_dpst_proof_bk_flg is '开立存款证实书标志';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.cust_acct_id is '客户账户编号';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.cust_sub_acct_num is '客户账户子户号';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.term_code is '存期编码';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.job_cd is '任务代码';
comment on column ${idl_schema}.dpss_agt_dpst_acct_info.etl_timestamp is '数据处理时间';
