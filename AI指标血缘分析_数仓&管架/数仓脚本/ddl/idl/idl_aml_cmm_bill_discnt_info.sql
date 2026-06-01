/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_cmm_bill_discnt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_cmm_bill_discnt_info
whenever sqlerror continue none;
drop table ${idl_schema}.aml_cmm_bill_discnt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_cmm_bill_discnt_info(
    etl_dt date           -- 数据日期
    ,lp_id varchar2(60)   -- 法人编号
    ,bus_id varchar2(60)   -- 业务编号
    ,batch_id varchar2(60)   -- 批次编号
    ,bill_num varchar2(60)   -- 票据号码
    ,cust_id varchar2(60)   -- 客户编号
    ,cust_name varchar2(250)  -- 客户名称
    ,bill_med_cd varchar2(10)   -- 票据介质代码
    ,bill_kind_cd varchar2(10)   -- 票据种类代码
    ,discnt_bus_type_cd varchar2(10)   -- 贴现业务类型代码
    ,sys_in_flg varchar2(10)   -- 系统内标志
    ,city_wide_flg varchar2(10)   -- 同城标志
    ,int_accr_flg varchar2(10)   -- 计息标志
    ,appl_dt date           -- 申请日期
    ,recv_dt date           -- 签收日期
    ,value_dt date           -- 起息日期
    ,revo_dt date           -- 撤销日期
    ,draw_dt date           -- 出票日期
    ,exp_dt date           -- 到期日期
    ,dir_rher_name varchar2(250)  -- 直接前手名称
    ,discnt_applit_acct_num varchar2(60)   -- 贴现申请人账号
    ,discnt_applit_bank_no varchar2(60)   -- 贴现申请人行号
    ,dscnt_props_cate_cd varchar2(10)   -- 贴出人类别代码
    ,dscnt_props_name varchar2(250)  -- 贴出人名称
    ,dscnt_props_orgnz_cd varchar2(10)   -- 贴出人组织机构代码
    ,dscnt_props_acct_num varchar2(60)   -- 贴出人账号
    ,dscnt_props_open_bank_no varchar2(60)   -- 贴出人开户行行号
    ,dscnt_name varchar2(250)  -- 贴入人名称
    ,dscnt_bank_no varchar2(60)   -- 贴入人行号
    ,drawer_name varchar2(250)  -- 出票人名称
    ,drawer_cate_cd varchar2(10)   -- 出票人类别代码
    ,drawer_acct_num varchar2(60)   -- 出票人账号
    ,drawer_open_bank_no varchar2(60)   -- 出票人开户行行号
    ,drawer_open_bank_name varchar2(250)  -- 出票人开户行名称
    ,accptor_name varchar2(250)  -- 承兑人名称
    ,accptor_acct_num varchar2(60)   -- 承兑人账号
    ,accptor_open_bank_no varchar2(60)   -- 承兑人开户行行号
    ,accptor_open_bank_name varchar2(250)  -- 承兑人开户行名称
    ,main_guar_way_cd varchar2(10)   -- 主担保方式代码
    ,agent_discnt_flg varchar2(10)   -- 代理贴现标志
    ,onl_discnt_flg varchar2(10)   -- 在线贴现标志
    ,entry_status_cd varchar2(10)   -- 记账状态代码
    ,entry_dt date           -- 记账日期
    ,int_accr_exp_dt date           -- 计息到期日期
    ,discnt_int_rat number(18,6)   -- 贴现利率
    ,defer_days varchar2(10)   -- 顺延天数
    ,int_accr_days number(10)     -- 计息天数
    ,not_ngbl_flg varchar2(10)   -- 不得转让标志
    ,hxb_acpt_flg varchar2(10)   -- 我行承兑标志
    ,curr_cd varchar2(10)   -- 币种代码
    ,fac_val_amt number(30,2)   -- 票面金额
    ,payoff_flg varchar2(10)   -- 结清标志
    ,discnt_status_cd varchar2(10)   -- 贴现状态代码
    ,int_amt number(18,2)   -- 利息金额
    ,buyer_pay_int_amt number(18,2)   -- 买方付息金额
    ,actl_amt number(30,2)   -- 实付金额
    ,risk_bear_fee number(30,2)   -- 风险承担费
    ,issue_org_id varchar2(60)   -- 签发机构编号
    ,enter_acct_org_id varchar2(60)   -- 入账机构编号
    ,cust_mgr_id varchar2(60)   -- 客户经理编号
    ,dept_id varchar2(60)   -- 部门编号
    ,operr_id varchar2(60)   -- 操作员编号
    ,agent_name varchar2(60)   -- 代理人名称
    ,drawer_crdt_level_cd varchar2(10)   -- 出票人信用等级代码
    ,drawer_rating_org_name varchar2(250)  -- 出票人评级机构名称
    ,drawer_rating_exp_dt date           -- 出票人评级到期日期
    ,job_cd varchar2(10)   -- 任务代码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_cmm_bill_discnt_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_cmm_bill_discnt_info is '票据贴现信息';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.lp_id is '法人编号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.bus_id is '业务编号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.batch_id is '批次编号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.bill_num is '票据号码';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.cust_id is '客户编号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.cust_name is '客户名称';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.bill_med_cd is '票据介质代码';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.bill_kind_cd is '票据种类代码';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.discnt_bus_type_cd is '贴现业务类型代码';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.sys_in_flg is '系统内标志';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.city_wide_flg is '同城标志';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.int_accr_flg is '计息标志';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.appl_dt is '申请日期';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.recv_dt is '签收日期';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.value_dt is '起息日期';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.revo_dt is '撤销日期';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.draw_dt is '出票日期';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.exp_dt is '到期日期';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.dir_rher_name is '直接前手名称';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.discnt_applit_acct_num is '贴现申请人账号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.discnt_applit_bank_no is '贴现申请人行号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.dscnt_props_cate_cd is '贴出人类别代码';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.dscnt_props_name is '贴出人名称';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.dscnt_props_orgnz_cd is '贴出人组织机构代码';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.dscnt_props_acct_num is '贴出人账号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.dscnt_props_open_bank_no is '贴出人开户行行号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.dscnt_name is '贴入人名称';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.dscnt_bank_no is '贴入人行号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.drawer_name is '出票人名称';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.drawer_cate_cd is '出票人类别代码';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.drawer_acct_num is '出票人账号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.drawer_open_bank_no is '出票人开户行行号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.drawer_open_bank_name is '出票人开户行名称';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.accptor_name is '承兑人名称';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.accptor_acct_num is '承兑人账号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.accptor_open_bank_no is '承兑人开户行行号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.accptor_open_bank_name is '承兑人开户行名称';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.main_guar_way_cd is '主担保方式代码';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.agent_discnt_flg is '代理贴现标志';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.onl_discnt_flg is '在线贴现标志';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.entry_status_cd is '记账状态代码';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.entry_dt is '记账日期';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.int_accr_exp_dt is '计息到期日期';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.discnt_int_rat is '贴现利率';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.defer_days is '顺延天数';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.int_accr_days is '计息天数';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.not_ngbl_flg is '不得转让标志';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.hxb_acpt_flg is '我行承兑标志';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.curr_cd is '币种代码';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.fac_val_amt is '票面金额';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.payoff_flg is '结清标志';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.discnt_status_cd is '贴现状态代码';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.int_amt is '利息金额';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.buyer_pay_int_amt is '买方付息金额';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.actl_amt is '实付金额';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.risk_bear_fee is '风险承担费';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.issue_org_id is '签发机构编号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.enter_acct_org_id is '入账机构编号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.dept_id is '部门编号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.operr_id is '操作员编号';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.agent_name is '代理人名称';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.drawer_crdt_level_cd is '出票人信用等级代码';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.drawer_rating_org_name is '出票人评级机构名称';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.drawer_rating_exp_dt is '出票人评级到期日期';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.job_cd is '任务代码';
comment on column ${idl_schema}.aml_cmm_bill_discnt_info.etl_timestamp is 'ETL处理时间戳';
