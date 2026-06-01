/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_bill_redcst_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_bill_redcst_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_bill_redcst_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_bill_redcst_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,batch_id varchar2(60) -- 批次编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,bill_id varchar2(60) -- 票据编号
    ,bill_num varchar2(60) -- 票据号码
    ,bill_sub_intrv_id varchar2(60) -- 票据子区间号
    ,subj_id varchar2(60) -- 科目编号
    ,int_adj_subj_id varchar2(60) -- 利息调整科目编号
    ,int_income_subj_id varchar2(60) -- 利息收入科目编号
    ,batch_no_code varchar2(60) -- 批次号码
    ,ctr_nt_id varchar2(60) -- 成交单编号
    ,bill_prod_id varchar2(60) -- 票据产品编号
    ,bill_med_cd varchar2(10) -- 票据介质代码
    ,bill_kind_cd varchar2(10) -- 票据种类代码
    ,draw_dt date -- 出票日期
    ,exp_dt date -- 到期日期
    ,actl_exp_dt date -- 实际到期日期
    ,bus_dt date -- 业务日期
    ,appl_dt date -- 申请日期
    ,stl_dt date -- 结算日期
    ,repo_dt date -- 回购日期
    ,bag_dt date -- 成交日期
    ,bag_tm timestamp(6) -- 成交时间
    ,curr_cd varchar2(10) -- 币种代码
    ,fac_val_amt number(30,2) -- 票面金额
    ,stl_amt number(30,2) -- 结算金额
    ,repo_amt number(30,2) -- 回购金额
    ,int_amt number(30,2) -- 利息金额
    ,discnt_int_rat number(18,8) -- 贴现利率
    ,currt_bal number(30,2) -- 当期余额
    ,int_adj_bal number(30,2) -- 利息调整余额
    ,td_acru_int number(30,2) -- 当日应计利息
    ,currt_acru_int number(30,2) -- 当期应计利息
    ,bus_type_cd varchar2(10) -- 业务类型代码
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(375) -- 交易对手名称
    ,cntpty_bank_no varchar2(60) -- 交易对手行号
    ,cntpty_cate_cd varchar2(10) -- 交易对手类别代码
    ,cntpty_type_cd varchar2(10) -- 交易对手类型代码
    ,hxb_acpt_flg varchar2(10) -- 我行承兑标志
    ,bill_src_cd varchar2(10) -- 票据来源代码
    ,stl_way_cd varchar2(10) -- 结算方式代码
    ,discount_bill_flg varchar2(10) -- 转贴票据标志
    ,remote_bill_flg varchar2(10) -- 异地票据标志
    ,acrd_policy_flg varchar2(10) -- 符合政策标志
    ,refuse_flg varchar2(10) -- 拒绝标志
    ,hold_days number(18,0) -- 持票天数
    ,defer_days number(18,0) -- 顺延天数
    ,valid_flg varchar2(10) -- 有效标志
    ,bus_status_cd varchar2(10) -- 业务状态代码
    ,entry_status_cd varchar2(10) -- 记账状态代码
    ,lmt_status_cd varchar2(10) -- 额度状态代码
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,dept_id varchar2(60) -- 部门编号
    ,bus_org_id varchar2(60) -- 业务机构编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,rgst_teller_id varchar2(60) -- 登记柜员编号
    ,recver_org_id varchar2(60) -- 收款方机构编号
    ,recver_trust_acct_num varchar2(60) -- 收款方托管账户编号
    ,recver_trust_acct_name varchar2(375) -- 收款方托管账户名称
    ,recver_bank_no varchar2(60) -- 收款方资金账号
    ,recver_bank_name varchar2(375) -- 收款方资金账户名称
    ,payer_org_id varchar2(60) -- 付款方机构编号
    ,payer_trust_acct_num varchar2(60) -- 付款方托管账户编号
    ,payer_trust_acct_name varchar2(375) -- 付款方托管账户名称
    ,payer_bank_no varchar2(60) -- 付款方资金账号
    ,payer_bank_name varchar2(375) -- 付款方资金账户名称
    ,stl_status_cd varchar2(10) -- 结算状态代码
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
grant select on ${icl_schema}.cmm_bill_redcst_info to ${idl_schema};
grant select on ${icl_schema}.cmm_bill_redcst_info to ${iel_schema};
grant select on ${icl_schema}.cmm_bill_redcst_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_bill_redcst_info is '票据再贴现信息';
comment on column ${icl_schema}.cmm_bill_redcst_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_bill_redcst_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.batch_id is '批次编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.bill_id is '票据编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.bill_num is '票据号码';
comment on column ${icl_schema}.cmm_bill_redcst_info.bill_sub_intrv_id is '票据子区间号';
comment on column ${icl_schema}.cmm_bill_redcst_info.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.int_adj_subj_id is '利息调整科目编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.int_income_subj_id is '利息收入科目编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.batch_no_code is '批次号码';
comment on column ${icl_schema}.cmm_bill_redcst_info.ctr_nt_id is '成交单编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.bill_prod_id is '票据产品编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.bill_med_cd is '票据介质代码';
comment on column ${icl_schema}.cmm_bill_redcst_info.bill_kind_cd is '票据种类代码';
comment on column ${icl_schema}.cmm_bill_redcst_info.draw_dt is '出票日期';
comment on column ${icl_schema}.cmm_bill_redcst_info.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_bill_redcst_info.actl_exp_dt is '实际到期日期';
comment on column ${icl_schema}.cmm_bill_redcst_info.bus_dt is '业务日期';
comment on column ${icl_schema}.cmm_bill_redcst_info.appl_dt is '申请日期';
comment on column ${icl_schema}.cmm_bill_redcst_info.stl_dt is '结算日期';
comment on column ${icl_schema}.cmm_bill_redcst_info.repo_dt is '回购日期';
comment on column ${icl_schema}.cmm_bill_redcst_info.bag_dt is '成交日期';
comment on column ${icl_schema}.cmm_bill_redcst_info.bag_tm is '成交时间';
comment on column ${icl_schema}.cmm_bill_redcst_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_bill_redcst_info.fac_val_amt is '票面金额';
comment on column ${icl_schema}.cmm_bill_redcst_info.stl_amt is '结算金额';
comment on column ${icl_schema}.cmm_bill_redcst_info.repo_amt is '回购金额';
comment on column ${icl_schema}.cmm_bill_redcst_info.int_amt is '利息金额';
comment on column ${icl_schema}.cmm_bill_redcst_info.discnt_int_rat is '贴现利率';
comment on column ${icl_schema}.cmm_bill_redcst_info.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_bill_redcst_info.int_adj_bal is '利息调整余额';
comment on column ${icl_schema}.cmm_bill_redcst_info.td_acru_int is '当日应计利息';
comment on column ${icl_schema}.cmm_bill_redcst_info.currt_acru_int is '当期应计利息';
comment on column ${icl_schema}.cmm_bill_redcst_info.bus_type_cd is '业务类型代码';
comment on column ${icl_schema}.cmm_bill_redcst_info.cntpty_id is '交易对手编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.cntpty_name is '交易对手名称';
comment on column ${icl_schema}.cmm_bill_redcst_info.cntpty_bank_no is '交易对手行号';
comment on column ${icl_schema}.cmm_bill_redcst_info.cntpty_cate_cd is '交易对手类别代码';
comment on column ${icl_schema}.cmm_bill_redcst_info.cntpty_type_cd is '交易对手类型代码';
comment on column ${icl_schema}.cmm_bill_redcst_info.hxb_acpt_flg is '我行承兑标志';
comment on column ${icl_schema}.cmm_bill_redcst_info.bill_src_cd is '票据来源代码';
comment on column ${icl_schema}.cmm_bill_redcst_info.stl_way_cd is '结算方式代码';
comment on column ${icl_schema}.cmm_bill_redcst_info.discount_bill_flg is '转贴票据标志';
comment on column ${icl_schema}.cmm_bill_redcst_info.remote_bill_flg is '异地票据标志';
comment on column ${icl_schema}.cmm_bill_redcst_info.acrd_policy_flg is '符合政策标志';
comment on column ${icl_schema}.cmm_bill_redcst_info.refuse_flg is '拒绝标志';
comment on column ${icl_schema}.cmm_bill_redcst_info.hold_days is '持票天数';
comment on column ${icl_schema}.cmm_bill_redcst_info.defer_days is '顺延天数';
comment on column ${icl_schema}.cmm_bill_redcst_info.valid_flg is '有效标志';
comment on column ${icl_schema}.cmm_bill_redcst_info.bus_status_cd is '业务状态代码';
comment on column ${icl_schema}.cmm_bill_redcst_info.entry_status_cd is '记账状态代码';
comment on column ${icl_schema}.cmm_bill_redcst_info.lmt_status_cd is '额度状态代码';
comment on column ${icl_schema}.cmm_bill_redcst_info.cust_mgr_id is '客户经理编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.dept_id is '部门编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.bus_org_id is '业务机构编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.rgst_teller_id is '登记柜员编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.recver_org_id is '收款方机构编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.recver_trust_acct_num is '收款方托管账户编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.recver_trust_acct_name is '收款方托管账户名称';
comment on column ${icl_schema}.cmm_bill_redcst_info.recver_bank_no is '收款方资金账号';
comment on column ${icl_schema}.cmm_bill_redcst_info.recver_bank_name is '收款方资金账户名称';
comment on column ${icl_schema}.cmm_bill_redcst_info.payer_org_id is '付款方机构编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.payer_trust_acct_num is '付款方托管账户编号';
comment on column ${icl_schema}.cmm_bill_redcst_info.payer_trust_acct_name is '付款方托管账户名称';
comment on column ${icl_schema}.cmm_bill_redcst_info.payer_bank_no is '付款方资金账号';
comment on column ${icl_schema}.cmm_bill_redcst_info.payer_bank_name is '付款方资金账户名称';
comment on column ${icl_schema}.cmm_bill_redcst_info.stl_status_cd is '结算状态代码';
comment on column ${icl_schema}.cmm_bill_redcst_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_bill_redcst_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_bill_redcst_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_bill_redcst_info.etl_timestamp is 'ETL处理时间戳';
