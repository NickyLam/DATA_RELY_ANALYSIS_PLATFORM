/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_cmm_bill_acpt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_cmm_bill_acpt_info
whenever sqlerror continue none;
drop table ${idl_schema}.aml_cmm_bill_acpt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_cmm_bill_acpt_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,batch_id varchar2(60) -- 批次编号
    ,bill_num varchar2(60) -- 票据号码
    ,cust_id varchar2(60) -- 客户编号
    ,bill_med_cd varchar2(10) -- 票据介质代码
    ,bill_kind_cd varchar2(10) -- 票据种类代码
    ,appl_dt date -- 申请日期
    ,recv_dt date -- 签收日期
    ,draw_dt date -- 出票日期
    ,exp_dt date -- 到期日期
    ,dir_indus_name varchar2(100) -- 投向行业名称
    ,main_guar_way_cd varchar2(10) -- 主担保方式代码
    ,drawer_name varchar2(250) -- 出票人名称
    ,drawer_cate_cd varchar2(10) -- 出票人类别代码
    ,drawer_acct_num varchar2(60) -- 出票人账号
    ,drawer_open_bank_no varchar2(60) -- 出票人开户行行号
    ,drawer_open_bank_name varchar2(250) -- 出票人开户行名称
    ,accptor_name varchar2(250) -- 承兑人名称
    ,accptor_acct_num varchar2(60) -- 承兑人账号
    ,accptor_open_bank_no varchar2(60) -- 承兑人开户行行号
    ,accptor_open_bank_name varchar2(250) -- 承兑人开户行名称
    ,recver_cust_id varchar2(60) -- 收款人客户编号
    ,recver_name varchar2(250) -- 收款人名称
    ,recver_acct_num varchar2(60) -- 收款人账号
    ,recver_open_bank_no varchar2(60) -- 收款人开户行行号
    ,recver_open_bank_name varchar2(250) -- 收款人开户行名称
    ,repay_num varchar2(60) -- 还款账号
    ,entry_dt date -- 记账日期
    ,revo_dt date -- 撤销日期
    ,bus_flow_num varchar2(60) -- 业务流水号
    ,margin_ratio number(18,6) -- 保证金比例
    ,comm_fee_ratio number(18,6) -- 手续费比例
    ,entry_status_cd varchar2(10) -- 记账状态代码
    ,draw_status_cd varchar2(10) -- 出票状态代码
    ,tranbl_flg varchar2(10) -- 可转让标志
    ,uncond_pay_flg varchar2(10) -- 无条件支付标志
    ,curr_cd varchar2(10) -- 币种代码
    ,fac_val_amt number(30,2) -- 票面金额
    ,payoff_flg varchar2(10) -- 结清标志
    ,lmt_ocup_amt number(30,2) -- 额度占用金额
    ,lmt_ocup_status_cd varchar2(10) -- 额度占用状态代码
    ,comm_fee number(18,2) -- 手续费
    ,todos number(18,2) -- 工本费
    ,acpt_fee number(30,2) -- 承兑费
    ,mgmt_fee number(30,2) -- 管理费
    ,accptor_crdt_level_cd varchar2(10) -- 承兑人信用等级代码
    ,accptor_rating_exp_dt date -- 承兑人评级到期日期
    ,issue_org_id varchar2(60) -- 签发机构编号
    ,enter_acct_org_id varchar2(60) -- 入账机构编号
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,dept_id varchar2(60) -- 部门编号
    ,operr_id varchar2(60) -- 操作员编号
    ,group_open_flg varchar2(10) -- 集团代开标志
    ,group_name varchar2(250) -- 集团名称
    ,group_id varchar2(60) -- 集团编号
    ,group_open_drawer_name varchar2(250) -- 集团代开出票人名称
    ,group_open_drawer_cust_no varchar2(60) -- 集团代开出票人客户号
    ,job_cd varchar2(10) -- 任务代码
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_cmm_bill_acpt_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_cmm_bill_acpt_info is '票据承兑信息';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.lp_id is '法人编号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.bus_id is '业务编号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.batch_id is '批次编号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.bill_num is '票据号码';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.cust_id is '客户编号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.bill_med_cd is '票据介质代码';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.bill_kind_cd is '票据种类代码';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.appl_dt is '申请日期';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.recv_dt is '签收日期';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.draw_dt is '出票日期';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.exp_dt is '到期日期';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.dir_indus_name is '投向行业名称';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.main_guar_way_cd is '主担保方式代码';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.drawer_name is '出票人名称';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.drawer_cate_cd is '出票人类别代码';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.drawer_acct_num is '出票人账号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.drawer_open_bank_no is '出票人开户行行号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.drawer_open_bank_name is '出票人开户行名称';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.accptor_name is '承兑人名称';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.accptor_acct_num is '承兑人账号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.accptor_open_bank_no is '承兑人开户行行号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.accptor_open_bank_name is '承兑人开户行名称';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.recver_cust_id is '收款人客户编号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.recver_name is '收款人名称';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.recver_acct_num is '收款人账号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.recver_open_bank_no is '收款人开户行行号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.recver_open_bank_name is '收款人开户行名称';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.repay_num is '还款账号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.entry_dt is '记账日期';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.revo_dt is '撤销日期';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.bus_flow_num is '业务流水号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.margin_ratio is '保证金比例';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.comm_fee_ratio is '手续费比例';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.entry_status_cd is '记账状态代码';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.draw_status_cd is '出票状态代码';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.tranbl_flg is '可转让标志';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.uncond_pay_flg is '无条件支付标志';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.curr_cd is '币种代码';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.fac_val_amt is '票面金额';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.payoff_flg is '结清标志';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.lmt_ocup_amt is '额度占用金额';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.lmt_ocup_status_cd is '额度占用状态代码';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.comm_fee is '手续费';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.todos is '工本费';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.acpt_fee is '承兑费';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.mgmt_fee is '管理费';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.accptor_crdt_level_cd is '承兑人信用等级代码';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.accptor_rating_exp_dt is '承兑人评级到期日期';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.issue_org_id is '签发机构编号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.enter_acct_org_id is '入账机构编号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.dept_id is '部门编号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.operr_id is '操作员编号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.group_open_flg is '集团代开标志';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.group_name is '集团名称';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.group_id is '集团编号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.group_open_drawer_name is '集团代开出票人名称';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.group_open_drawer_cust_no is '集团代开出票人客户号';
comment on column ${idl_schema}.aml_cmm_bill_acpt_info.job_cd is '任务代码';