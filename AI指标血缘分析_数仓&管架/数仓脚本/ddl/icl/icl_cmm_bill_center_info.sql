/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_bill_center_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_bill_center_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_bill_center_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_bill_center_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bill_id varchar2(60) -- 票据编号
    ,bill_num varchar2(60) -- 票据号码
    ,bill_sub_intrv_id varchar2(60) -- 票据子区间号
    ,bill_med_cd varchar2(10) -- 票据介质代码
    ,bill_type_cd varchar2(10) -- 票据类型代码
    ,bill_pay_int_way_cd varchar2(30) -- 票据付息方式代码
    ,draw_dt date -- 出票日期
    ,exp_dt date -- 到期日期
    ,distr_dt date -- 放款日期
    ,acpt_dt date -- 承兑日期
    ,cash_dt date -- 兑付日期
    ,curr_cd varchar2(10) -- 币种代码
    ,fac_val_amt number(30,2) -- 票面金额
    ,cust_id varchar2(60) -- 客户编号
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,drawer_cust_id varchar2(60) -- 出票人客户编号
    ,drawer_name varchar2(500) -- 出票人名称
    ,drawer_acct_num varchar2(60) -- 出票人账号
    ,drawer_open_bank_no varchar2(60) -- 出票人开户行行号
    ,drawer_open_bank_name varchar2(750) -- 出票人开户行名称
    ,drawer_operr_id varchar2(60) -- 出票人经办人编号
    ,drawer_type_cd varchar2(30) -- 出票人类型代码
    ,drawer_orgnz_cd varchar2(60) -- 出票人组织机构代码
    ,drawer_soci_crdt_cd varchar2(60) -- 出票人社会信用代码
    ,recver_name varchar2(375) -- 收款人名称
    ,recver_acct_num varchar2(60) -- 收款人账号
    ,recver_open_bank_no varchar2(60) -- 收款人开户行行号
    ,recver_open_bank_name varchar2(750) -- 收款人开户行名称
    ,recver_soci_crdt_cd varchar2(60) -- 收款人社会信用代码
    ,pay_bank_bank_no varchar2(60) -- 付款行行号
    ,pay_bank_name varchar2(750) -- 付款行名称
    ,pay_org_id varchar2(60) -- 付款机构编号
    ,pay_cfm_org_id varchar2(60) -- 付款确认机构编号
    ,accptor_name varchar2(1000) -- 承兑人名称
    ,accptor_acct_num varchar2(60) -- 承兑人账号
    ,accptor_open_bank_no varchar2(60) -- 承兑人开户行行号
    ,accptor_open_bank_name varchar2(750) -- 承兑人开户行名称
    ,accptor_type_cd varchar2(30) -- 承兑人类型代码
    ,acpt_org_id varchar2(60) -- 承兑机构编号
    ,accptor_soci_crdt_cd varchar2(60) -- 承兑人社会信用代码
    ,holder_org_id varchar2(60) -- 持票人机构编号
    ,holder_org_name varchar2(750) -- 持票人机构名称
    ,discnt_bank_org_id varchar2(60) -- 贴现行机构编号
    ,discnt_ibank_no varchar2(60) -- 贴现行联行号
    ,discnt_bank_name varchar2(750) -- 贴现行名称
    ,endors_cnt number(22,0) -- 背书次数
    ,lock_flg varchar2(10) -- 锁定标志
    ,loss_flg varchar2(10) -- 挂失标志
    ,hxb_acpt_flg varchar2(10) -- 我行承兑标志
    ,pay_cfm_flg varchar2(10) -- 付款确认标志
    ,payoff_flg varchar2(10) -- 结清标志
    ,recs_flg varchar2(10) -- 追偿标志
    ,valet_coll_flg varchar2(10) -- 代客托收标志
    ,risk_status_cd varchar2(10) -- 风险状态代码
    ,bill_src_cd varchar2(10) -- 票据来源代码
    ,bill_status_cd varchar2(10) -- 票据状态代码
    ,ccution_status_cd varchar2(30) -- 流转状态代码
    ,invtry_status_cd varchar2(30) -- 库存状态代码
    ,ele_bill_status_cd varchar2(30) -- 电票状态代码
    ,bill_proc_mdl_status_cd varchar2(30) -- 票据处理中状态代码
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,receipt_flg varchar2(10) -- 小票标志
    ,redcst_flg varchar2(10) -- 再贴现标志
    ,data_src_cd varchar2(10) -- 数据来源代码
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
grant select on ${icl_schema}.cmm_bill_center_info to ${idl_schema};
grant select on ${icl_schema}.cmm_bill_center_info to ${iel_schema};
grant select on ${icl_schema}.cmm_bill_center_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_bill_center_info is '票据中心信息';
comment on column ${icl_schema}.cmm_bill_center_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_bill_center_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_bill_center_info.bill_id is '票据编号';
comment on column ${icl_schema}.cmm_bill_center_info.bill_num is '票据号码';
comment on column ${icl_schema}.cmm_bill_center_info.bill_sub_intrv_id is '票据子区间号';
comment on column ${icl_schema}.cmm_bill_center_info.bill_med_cd is '票据介质代码';
comment on column ${icl_schema}.cmm_bill_center_info.bill_type_cd is '票据类型代码';
comment on column ${icl_schema}.cmm_bill_center_info.bill_pay_int_way_cd is '票据付息方式代码';
comment on column ${icl_schema}.cmm_bill_center_info.draw_dt is '出票日期';
comment on column ${icl_schema}.cmm_bill_center_info.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_bill_center_info.distr_dt is '放款日期';
comment on column ${icl_schema}.cmm_bill_center_info.acpt_dt is '承兑日期';
comment on column ${icl_schema}.cmm_bill_center_info.cash_dt is '兑付日期';
comment on column ${icl_schema}.cmm_bill_center_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_bill_center_info.fac_val_amt is '票面金额';
comment on column ${icl_schema}.cmm_bill_center_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_bill_center_info.cust_mgr_id is '客户经理编号';
comment on column ${icl_schema}.cmm_bill_center_info.drawer_cust_id is '出票人客户编号';
comment on column ${icl_schema}.cmm_bill_center_info.drawer_name is '出票人名称';
comment on column ${icl_schema}.cmm_bill_center_info.drawer_acct_num is '出票人账号';
comment on column ${icl_schema}.cmm_bill_center_info.drawer_open_bank_no is '出票人开户行行号';
comment on column ${icl_schema}.cmm_bill_center_info.drawer_open_bank_name is '出票人开户行名称';
comment on column ${icl_schema}.cmm_bill_center_info.drawer_operr_id is '出票人经办人编号';
comment on column ${icl_schema}.cmm_bill_center_info.drawer_type_cd is '出票人类型代码';
comment on column ${icl_schema}.cmm_bill_center_info.drawer_orgnz_cd is '出票人组织机构代码';
comment on column ${icl_schema}.cmm_bill_center_info.drawer_soci_crdt_cd is '出票人社会信用代码';
comment on column ${icl_schema}.cmm_bill_center_info.recver_name is '收款人名称';
comment on column ${icl_schema}.cmm_bill_center_info.recver_acct_num is '收款人账号';
comment on column ${icl_schema}.cmm_bill_center_info.recver_open_bank_no is '收款人开户行行号';
comment on column ${icl_schema}.cmm_bill_center_info.recver_open_bank_name is '收款人开户行名称';
comment on column ${icl_schema}.cmm_bill_center_info.recver_soci_crdt_cd is '收款人社会信用代码';
comment on column ${icl_schema}.cmm_bill_center_info.pay_bank_bank_no is '付款行行号';
comment on column ${icl_schema}.cmm_bill_center_info.pay_bank_name is '付款行名称';
comment on column ${icl_schema}.cmm_bill_center_info.pay_org_id is '付款机构编号';
comment on column ${icl_schema}.cmm_bill_center_info.pay_cfm_org_id is '付款确认机构编号';
comment on column ${icl_schema}.cmm_bill_center_info.accptor_name is '承兑人名称';
comment on column ${icl_schema}.cmm_bill_center_info.accptor_acct_num is '承兑人账号';
comment on column ${icl_schema}.cmm_bill_center_info.accptor_open_bank_no is '承兑人开户行行号';
comment on column ${icl_schema}.cmm_bill_center_info.accptor_open_bank_name is '承兑人开户行名称';
comment on column ${icl_schema}.cmm_bill_center_info.accptor_type_cd is '承兑人类型代码';
comment on column ${icl_schema}.cmm_bill_center_info.acpt_org_id is '承兑机构编号';
comment on column ${icl_schema}.cmm_bill_center_info.accptor_soci_crdt_cd is '承兑人社会信用代码';
comment on column ${icl_schema}.cmm_bill_center_info.holder_org_id is '持票人机构编号';
comment on column ${icl_schema}.cmm_bill_center_info.holder_org_name is '持票人机构名称';
comment on column ${icl_schema}.cmm_bill_center_info.discnt_bank_org_id is '贴现行机构编号';
comment on column ${icl_schema}.cmm_bill_center_info.discnt_ibank_no is '贴现行联行号';
comment on column ${icl_schema}.cmm_bill_center_info.discnt_bank_name is '贴现行名称';
comment on column ${icl_schema}.cmm_bill_center_info.endors_cnt is '背书次数';
comment on column ${icl_schema}.cmm_bill_center_info.lock_flg is '锁定标志';
comment on column ${icl_schema}.cmm_bill_center_info.loss_flg is '挂失标志';
comment on column ${icl_schema}.cmm_bill_center_info.hxb_acpt_flg is '我行承兑标志';
comment on column ${icl_schema}.cmm_bill_center_info.pay_cfm_flg is '付款确认标志';
comment on column ${icl_schema}.cmm_bill_center_info.payoff_flg is '结清标志';
comment on column ${icl_schema}.cmm_bill_center_info.recs_flg is '追偿标志';
comment on column ${icl_schema}.cmm_bill_center_info.valet_coll_flg is '代客托收标志';
comment on column ${icl_schema}.cmm_bill_center_info.risk_status_cd is '风险状态代码';
comment on column ${icl_schema}.cmm_bill_center_info.bill_src_cd is '票据来源代码';
comment on column ${icl_schema}.cmm_bill_center_info.bill_status_cd is '票据状态代码';
comment on column ${icl_schema}.cmm_bill_center_info.ccution_status_cd is '流转状态代码';
comment on column ${icl_schema}.cmm_bill_center_info.invtry_status_cd is '库存状态代码';
comment on column ${icl_schema}.cmm_bill_center_info.ele_bill_status_cd is '电票状态代码';
comment on column ${icl_schema}.cmm_bill_center_info.bill_proc_mdl_status_cd is '票据处理中状态代码';
comment on column ${icl_schema}.cmm_bill_center_info.belong_org_id is '所属机构编号';
comment on column ${icl_schema}.cmm_bill_center_info.receipt_flg is '小票标志';
comment on column ${icl_schema}.cmm_bill_center_info.redcst_flg is '再贴现标志';
comment on column ${icl_schema}.cmm_bill_center_info.data_src_cd is '数据来源代码';
comment on column ${icl_schema}.cmm_bill_center_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_bill_center_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_bill_center_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_bill_center_info.etl_timestamp is 'ETL处理时间戳';
