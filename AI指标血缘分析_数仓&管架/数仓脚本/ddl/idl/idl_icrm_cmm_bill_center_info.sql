/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_cmm_bill_center_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_cmm_bill_center_info
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_cmm_bill_center_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_cmm_bill_center_info(
    etl_dt date -- 数据日期   
    ,lp_id varchar2(60) -- 法人编号   
    ,bill_id varchar2(60) -- 票据编号   
    ,bill_num varchar2(60) -- 票据号码   
    ,bill_med_cd varchar2(10) -- 票据介质代码   
    ,bill_type_cd varchar2(10) -- 票据类型代码   
    ,draw_dt date -- 出票日期   
    ,exp_dt date -- 到期日期   
    ,curr_cd varchar2(10) -- 币种代码   
    ,fac_val_amt number(30,2) -- 票面金额   
    ,drawer_name varchar2(250) -- 出票人名称   
    ,drawer_acct_num varchar2(60) -- 出票人账号   
    ,drawer_open_bank_no varchar2(60) -- 出票人开户行行号   
    ,drawer_open_bank_name varchar2(250) -- 出票人开户行名称   
    ,recver_name varchar2(250) -- 收款人名称   
    ,recver_acct_num varchar2(60) -- 收款人账号   
    ,recver_open_bank_no varchar2(60) -- 收款人开户行行号   
    ,recver_open_bank_name varchar2(250) -- 收款人开户行名称   
    ,pay_bank_bank_no varchar2(60) -- 付款行行号   
    ,pay_bank_name varchar2(250) -- 付款行名称   
    ,pay_org_id varchar2(60) -- 付款机构编号   
    ,pay_cfm_org_id varchar2(60) -- 付款确认机构编号   
    ,accptor_name varchar2(250) -- 承兑人名称   
    ,accptor_acct_num varchar2(60) -- 承兑人账号   
    ,accptor_open_bank_no varchar2(60) -- 承兑人开户行行号   
    ,accptor_open_bank_name varchar2(250) -- 承兑人开户行名称   
    ,holder_org_id varchar2(60) -- 持票人机构编号   
    ,holder_org_name varchar2(250) -- 持票人机构名称   
    ,endors_cnt integer -- 背书次数   
    ,lock_flg varchar2(10) -- 锁定标志   
    ,loss_flg varchar2(10) -- 挂失标志   
    ,hxb_acpt_flg varchar2(10) -- 我行承兑标志   
    ,pay_cfm_flg varchar2(10) -- 付款确认标志   
    ,payoff_flg varchar2(10) -- 结清标志   
    ,recs_flg varchar2(10) -- 追偿标志   
    ,risk_status_cd varchar2(10) -- 风险状态代码   
    ,bill_src_cd varchar2(10) -- 票据来源代码   
    ,bill_status_cd varchar2(10) -- 票据状态代码   
    ,belong_org_id varchar2(60) -- 所属机构编号   
    ,job_cd varchar2(10) -- 任务代码   
    ,etl_timestamp timestamp -- 数据处理时间   
    ,data_src_cd varchar2(10) -- 数据来源代码   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_cmm_bill_center_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_cmm_bill_center_info is '票据中心信息';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.bill_id is '票据编号';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.bill_num is '票据号码';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.bill_med_cd is '票据介质代码';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.bill_type_cd is '票据类型代码';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.draw_dt is '出票日期';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.exp_dt is '到期日期';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.curr_cd is '币种代码';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.fac_val_amt is '票面金额';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.drawer_name is '出票人名称';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.drawer_acct_num is '出票人账号';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.drawer_open_bank_no is '出票人开户行行号';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.drawer_open_bank_name is '出票人开户行名称';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.recver_name is '收款人名称';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.recver_acct_num is '收款人账号';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.recver_open_bank_no is '收款人开户行行号';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.recver_open_bank_name is '收款人开户行名称';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.pay_bank_bank_no is '付款行行号';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.pay_bank_name is '付款行名称';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.pay_org_id is '付款机构编号';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.pay_cfm_org_id is '付款确认机构编号';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.accptor_name is '承兑人名称';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.accptor_acct_num is '承兑人账号';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.accptor_open_bank_no is '承兑人开户行行号';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.accptor_open_bank_name is '承兑人开户行名称';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.holder_org_id is '持票人机构编号';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.holder_org_name is '持票人机构名称';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.endors_cnt is '背书次数';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.lock_flg is '锁定标志';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.loss_flg is '挂失标志';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.hxb_acpt_flg is '我行承兑标志';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.pay_cfm_flg is '付款确认标志';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.payoff_flg is '结清标志';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.recs_flg is '追偿标志';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.risk_status_cd is '风险状态代码';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.bill_src_cd is '票据来源代码';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.bill_status_cd is '票据状态代码';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.belong_org_id is '所属机构编号';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.etl_timestamp is '数据处理时间';
comment on column ${idl_schema}.icrm_cmm_bill_center_info.data_src_cd is '数据来源代码';