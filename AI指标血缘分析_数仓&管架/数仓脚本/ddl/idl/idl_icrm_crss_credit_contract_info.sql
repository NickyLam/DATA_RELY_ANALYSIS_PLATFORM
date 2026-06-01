/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_crss_credit_contract_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_crss_credit_contract_info
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_crss_credit_contract_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_crss_credit_contract_info(
    etl_dt date -- 数据日期   
    ,crdt_lmt_agt_id varchar2(60) -- 授信额度协议编号   
    ,cust_id varchar2(60) -- 客户编号   
    ,cust_type_cd varchar2(20) -- 客户类型代码   
    ,manu_cont_id varchar2(200) -- 人工合同编号   
    ,crdt_apv_id varchar2(60) -- 授信审批编号   
    ,crdt_appl_id varchar2(60) -- 授信申请编号   
    ,crdt_kind_cd varchar2(10) -- 授信种类代码   
    ,crdt_bus_kind_cd varchar2(18) -- 授信业务种类代码   
    ,open_dt date -- 开立日期   
    ,apv_dt date -- 审批日期   
    ,crdt_start_dt date -- 授信起始日期   
    ,crdt_exp_dt date -- 授信到期日期   
    ,crdt_termnt_dt date -- 授信终止日期   
    ,crdt_cont_status_cd varchar2(10) -- 授信合同状态代码   
    ,crdt_lmt_wrtoff_effect_dt date -- 授信额度注销生效日期   
    ,crdt_lmt_wrtoff_reason varchar2(10) -- 授信额度注销原因   
    ,crdt_lmt_froz_flg varchar2(1) -- 授信合同冻结标志   
    ,circl_flg varchar2(10) -- 循环标志   
    ,crdt_valid_flg varchar2(3) -- 授信有效标志   
    ,com_group_crdt_lmt_flg varchar2(1) -- 共用集团授信额度标志   
    ,happ_type_cd varchar2(10) -- 发生类型代码   
    ,curr_cd varchar2(10) -- 币种代码   
    ,crdt_lmt number(24,6) -- 授信额度   
    ,used_crdt_lmt number(24,6) -- 已用授信额度   
    ,crdt_bal number(24,6) -- 授信余额   
    ,aval_crdt_lmt number(24,6) -- 可用授信额度   
    ,open_lmt number(24,6) -- 敞口额度   
    ,open_bal number(24,6) -- 敞口余额   
    ,aval_open_lmt number(24,6) -- 敞口可用额度   
    ,onl_lmt number(24,6) -- 线上额度   
    ,onl_bal number(24,6) -- 线上额度余额   
    ,apv_crdt_lmt number(24,6) -- 批复授信额度   
    ,apv_open_lmt number(24,6) -- 批复敞口额度   
    ,group_corp_crdt_lmt number(24,6) -- 集团授信额度公司部分   
    ,group_corp_open_lmt number(24,6) -- 集团授信敞口公司部分   
    ,group_ibank_crdt_lmt number(24,6) -- 集团授信额度同业部分   
    ,group_ibank_open_lmt number(24,6) -- 集团授信敞口同业部分   
    ,guar_val number(24,6) -- 担保价值   
    ,guar_ratio number(24,6) -- 担保比例   
    ,guar_way_cd varchar2(10) -- 担保方式代码   
    ,open_org_id varchar2(60) -- 开立机构编号   
    ,crdt_mgmt_org_id varchar2(60) -- 授信管理机构编号   
    ,crdt_acct_instit_id varchar2(60) -- 授信账务机构编号   
    ,crdt_user_id varchar2(60) -- 授信员工编号   
    ,init_crdt_lmt_agt_id varchar2(60) -- 原授信协议号   
    ,data_src_cd varchar2(10) -- 数据来源代码   
    ,apv_path varchar2(120) -- 批复意见书地址字段   
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
grant select on ${idl_schema}.icrm_crss_credit_contract_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_crss_credit_contract_info is '供对公CRM授信额度信息';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_lmt_agt_id is '授信额度协议编号';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.cust_id is '客户编号';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.cust_type_cd is '客户类型代码';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.manu_cont_id is '人工合同编号';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_apv_id is '授信审批编号';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_appl_id is '授信申请编号';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_kind_cd is '授信种类代码';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_bus_kind_cd is '授信业务种类代码';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.open_dt is '开立日期';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.apv_dt is '审批日期';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_start_dt is '授信起始日期';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_exp_dt is '授信到期日期';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_termnt_dt is '授信终止日期';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_cont_status_cd is '授信合同状态代码';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_lmt_wrtoff_effect_dt is '授信额度注销生效日期';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_lmt_wrtoff_reason is '授信额度注销原因';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_lmt_froz_flg is '授信合同冻结标志';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.circl_flg is '循环标志';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_valid_flg is '授信有效标志';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.com_group_crdt_lmt_flg is '共用集团授信额度标志';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.happ_type_cd is '发生类型代码';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.curr_cd is '币种代码';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_lmt is '授信额度';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.used_crdt_lmt is '已用授信额度';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_bal is '授信余额';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.aval_crdt_lmt is '可用授信额度';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.open_lmt is '敞口额度';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.open_bal is '敞口余额';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.aval_open_lmt is '敞口可用额度';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.onl_lmt is '线上额度';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.onl_bal is '线上额度余额';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.apv_crdt_lmt is '批复授信额度';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.apv_open_lmt is '批复敞口额度';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.group_corp_crdt_lmt is '集团授信额度公司部分';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.group_corp_open_lmt is '集团授信敞口公司部分';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.group_ibank_crdt_lmt is '集团授信额度同业部分';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.group_ibank_open_lmt is '集团授信敞口同业部分';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.guar_val is '担保价值';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.guar_ratio is '担保比例';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.guar_way_cd is '担保方式代码';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.open_org_id is '开立机构编号';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_mgmt_org_id is '授信管理机构编号';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_acct_instit_id is '授信账务机构编号';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.crdt_user_id is '授信员工编号';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.init_crdt_lmt_agt_id is '原授信协议号';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.data_src_cd is '数据来源代码';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.apv_path is '批复意见书地址字段';
comment on column ${idl_schema}.icrm_crss_credit_contract_info.etl_timestamp is '数据处理时间';