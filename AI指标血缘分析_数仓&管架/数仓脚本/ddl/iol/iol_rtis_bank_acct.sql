/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rtis_bank_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rtis_bank_acct
whenever sqlerror continue none;
drop table ${iol_schema}.rtis_bank_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_bank_acct(
    acct_cls_cd varchar2(100) -- 账户分类代码
    ,froz_status_cd varchar2(100) -- 
    ,asset_under_management number(36,0) -- 资产管理规模AUM值
    ,emply_flg varchar2(10) -- 员工标识:1-是,0-否
    ,m_avg_bal number(36,0) -- 账户月日均余额
    ,aum_m_avg_bal number(36,0) -- AUM月均值
    ,acct_belong_org_id varchar2(60) -- 账户所属机构号
    ,control_type varchar2(4000) -- 交易渠道状态代码
    ,restraint_type varchar2(4000) -- 账户限制类型
    ,cust_id varchar2(20) -- 客户号
    ,card_no varchar2(100) -- 账户号（卡号）
    ,open_inst_no varchar2(20) -- 开户机构编号
    ,acct_opene_at timestamp -- 开户时间
    ,acct_type varchar2(20) -- 账户类型
    ,card_type varchar2(20) -- 卡类型
    ,acct_medium varchar2(20) -- 账户介质
    ,daily_balance number(18,2) -- 日终余额
    ,id_card_type varchar2(20) -- 证件类型
    ,id_card_number varchar2(100) -- 证件号码
    ,create_at timestamp -- 入库时间
    ,create_by varchar2(32) -- 入库人
    ,last_update_at timestamp -- 入库后最后变更时间
    ,last_update_by varchar2(32) -- 最后变更人
    ,acct_stat varchar2(8) -- 账户状态
    ,cry_type varchar2(20) -- 币种
    ,acct_kind varchar2(8) -- 公私标识
    ,open_inst_name varchar2(100) -- 开户机构名称
    ,open_agent varchar2(200) -- 开户代办人
    ,open_agent_id_type varchar2(20) -- 开户代办人证件类型
    ,open_agent_id_no varchar2(64) -- 开户代办人证件号码
    ,open_agent_tel varchar2(100) -- 开户代办人电话
    ,company_contact varchar2(200) -- 单位联系人
    ,company_contact_id_type varchar2(20) -- 单位联系人证件类型
    ,company_contact_id_no varchar2(64) -- 单位联系人证件号码
    ,company_contact_tel varchar2(100) -- 单位联系人电话
    ,cust_name varchar2(500) -- 持卡人姓名
    ,card_city varchar2(100) -- 银行卡发卡城市
    ,card_indate timestamp -- 卡有效期
    ,limit_amount number(18,0) -- 信用卡额度,厘
    ,phone_number varchar2(20) -- 预留手机号码
    ,last_update_time timestamp -- 账户最后更新时间
    ,is_dormancy_account varchar2(20) -- 是否为睡眠户
    ,e_acct_type varchar2(20) -- 电子账户类型
    ,cust_type varchar2(20) -- 客户类型
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rtis_bank_acct to ${iml_schema};
grant select on ${iol_schema}.rtis_bank_acct to ${icl_schema};
grant select on ${iol_schema}.rtis_bank_acct to ${idl_schema};
grant select on ${iol_schema}.rtis_bank_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.rtis_bank_acct is '账户信息表';
comment on column ${iol_schema}.rtis_bank_acct.acct_cls_cd is '账户分类代码';
comment on column ${iol_schema}.rtis_bank_acct.froz_status_cd is '';
comment on column ${iol_schema}.rtis_bank_acct.asset_under_management is '资产管理规模AUM值';
comment on column ${iol_schema}.rtis_bank_acct.emply_flg is '员工标识:1-是,0-否';
comment on column ${iol_schema}.rtis_bank_acct.m_avg_bal is '账户月日均余额';
comment on column ${iol_schema}.rtis_bank_acct.aum_m_avg_bal is 'AUM月均值';
comment on column ${iol_schema}.rtis_bank_acct.acct_belong_org_id is '账户所属机构号';
comment on column ${iol_schema}.rtis_bank_acct.control_type is '交易渠道状态代码';
comment on column ${iol_schema}.rtis_bank_acct.restraint_type is '账户限制类型';
comment on column ${iol_schema}.rtis_bank_acct.cust_id is '客户号';
comment on column ${iol_schema}.rtis_bank_acct.card_no is '账户号（卡号）';
comment on column ${iol_schema}.rtis_bank_acct.open_inst_no is '开户机构编号';
comment on column ${iol_schema}.rtis_bank_acct.acct_opene_at is '开户时间';
comment on column ${iol_schema}.rtis_bank_acct.acct_type is '账户类型';
comment on column ${iol_schema}.rtis_bank_acct.card_type is '卡类型';
comment on column ${iol_schema}.rtis_bank_acct.acct_medium is '账户介质';
comment on column ${iol_schema}.rtis_bank_acct.daily_balance is '日终余额';
comment on column ${iol_schema}.rtis_bank_acct.id_card_type is '证件类型';
comment on column ${iol_schema}.rtis_bank_acct.id_card_number is '证件号码';
comment on column ${iol_schema}.rtis_bank_acct.create_at is '入库时间';
comment on column ${iol_schema}.rtis_bank_acct.create_by is '入库人';
comment on column ${iol_schema}.rtis_bank_acct.last_update_at is '入库后最后变更时间';
comment on column ${iol_schema}.rtis_bank_acct.last_update_by is '最后变更人';
comment on column ${iol_schema}.rtis_bank_acct.acct_stat is '账户状态';
comment on column ${iol_schema}.rtis_bank_acct.cry_type is '币种';
comment on column ${iol_schema}.rtis_bank_acct.acct_kind is '公私标识';
comment on column ${iol_schema}.rtis_bank_acct.open_inst_name is '开户机构名称';
comment on column ${iol_schema}.rtis_bank_acct.open_agent is '开户代办人';
comment on column ${iol_schema}.rtis_bank_acct.open_agent_id_type is '开户代办人证件类型';
comment on column ${iol_schema}.rtis_bank_acct.open_agent_id_no is '开户代办人证件号码';
comment on column ${iol_schema}.rtis_bank_acct.open_agent_tel is '开户代办人电话';
comment on column ${iol_schema}.rtis_bank_acct.company_contact is '单位联系人';
comment on column ${iol_schema}.rtis_bank_acct.company_contact_id_type is '单位联系人证件类型';
comment on column ${iol_schema}.rtis_bank_acct.company_contact_id_no is '单位联系人证件号码';
comment on column ${iol_schema}.rtis_bank_acct.company_contact_tel is '单位联系人电话';
comment on column ${iol_schema}.rtis_bank_acct.cust_name is '持卡人姓名';
comment on column ${iol_schema}.rtis_bank_acct.card_city is '银行卡发卡城市';
comment on column ${iol_schema}.rtis_bank_acct.card_indate is '卡有效期';
comment on column ${iol_schema}.rtis_bank_acct.limit_amount is '信用卡额度,厘';
comment on column ${iol_schema}.rtis_bank_acct.phone_number is '预留手机号码';
comment on column ${iol_schema}.rtis_bank_acct.last_update_time is '账户最后更新时间';
comment on column ${iol_schema}.rtis_bank_acct.is_dormancy_account is '是否为睡眠户';
comment on column ${iol_schema}.rtis_bank_acct.e_acct_type is '电子账户类型';
comment on column ${iol_schema}.rtis_bank_acct.cust_type is '客户类型';
comment on column ${iol_schema}.rtis_bank_acct.start_dt is '开始时间';
comment on column ${iol_schema}.rtis_bank_acct.end_dt is '结束时间';
comment on column ${iol_schema}.rtis_bank_acct.id_mark is '增删标志';
comment on column ${iol_schema}.rtis_bank_acct.etl_timestamp is 'ETL处理时间戳';
