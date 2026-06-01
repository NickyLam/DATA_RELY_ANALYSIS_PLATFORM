/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rtis_bank_cust_corp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rtis_bank_cust_corp
whenever sqlerror continue none;
drop table ${iol_schema}.rtis_bank_cust_corp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_bank_cust_corp(
    biz_lic_exp_date timestamp -- 营业执照到期日期
    ,open_at timestamp -- 开户时间
    ,create_at timestamp -- 入库时间
    ,create_by varchar2(60) -- 入库人
    ,last_update_at timestamp -- 入库后最后变更时间
    ,last_update_by varchar2(60) -- 最后变更人
    ,cust_surname varchar2(100) -- 客户姓氏
    ,cust_middle_name varchar2(100) -- 客户中间名
    ,cust_first_name varchar2(100) -- 客户名字
    ,id_card_type varchar2(20) -- 证件类型
    ,id_card_number varchar2(100) -- 证件号码
    ,mobile_number varchar2(100) -- 预留手机号
    ,age number(3,0) -- 年龄(法人年龄)
    ,cust_open_inst_prov varchar2(50) -- 开户机构所在省
    ,cust_open_inst_city varchar2(50) -- 开户机构所在市
    ,id_card_prov varchar2(50) -- 身份证归属省
    ,id_card_city varchar2(50) -- 身份证归属市
    ,mobile_prov varchar2(50) -- 预留手机号归属省
    ,mobile_city varchar2(50) -- 预留手机号归属市
    ,gender varchar2(10) -- 性别
    ,risk_level varchar2(100) -- 风险等级
    ,cust_build_channel varchar2(50) -- 客户信息建立渠道
    ,occupation varchar2(30) -- 职业
    ,register_address varchar2(1000) -- 注册地址
    ,business_address varchar2(1000) -- 办公地址
    ,operation_no varchar2(60) -- 运营机构编号
    ,corporate_card_indate varchar2(100) -- 法定代表人证件有效期
    ,cust_principal_name varchar2(500) -- 客户负责人姓名
    ,cust_principal_card_type varchar2(10) -- 客户负责人证件类型
    ,cust_principal_card_indate timestamp -- 单位负责人证件有效期
    ,cust_receiptor_name varchar2(500) -- 客户受益人姓名
    ,cust_receiptor_card_type varchar2(10) -- 客户受益人证件类型
    ,cust_receiptor_card_no varchar2(60) -- 客户受益人证件号
    ,cust_linkman_name varchar2(500) -- 客户业务联系人姓名
    ,cust_linkman_card_type varchar2(10) -- 客户业务联系人证件类型
    ,cust_linkman_card_no varchar2(60) -- 客户业务联系人证件号
    ,cust_agent_name varchar2(500) -- 客户授权代表人姓名
    ,cust_agent_card_type varchar2(10) -- 客户授权代表人证件类型
    ,cust_agent_card_no varchar2(60) -- 客户授权代表人证件号
    ,cust_charater varchar2(20) -- 客户性质
    ,cust_type varchar2(60) -- 客户类型
    ,corporate_phone_no varchar2(50) -- 法人联系电话
    ,finance_mgr_phone_no varchar2(50) -- 财务负责人联系电话
    ,posta_addr varchar2(4000) -- 通讯地址
    ,iden_addr varchar2(4000) -- 户口所在地
    ,work_unit_addr varchar2(4000) -- 单位地址
    ,if_acct_black varchar2(4000) -- 是否为黑名单
    ,cust_id varchar2(60) -- 客户号
    ,cust_name varchar2(200) -- 客户名称
    ,cust_stat varchar2(10) -- 客户状态
    ,cust_open_inst_no varchar2(60) -- 开户机构编号
    ,cust_open_inst_name varchar2(200) -- 开户机构名称
    ,corp_cert_type varchar2(20) -- 企业证件类型
    ,corp_cert_no varchar2(64) -- 企业证件号码
    ,cust_kind varchar2(20) -- 企业种类
    ,country varchar2(10) -- 国别代码
    ,ind_type varchar2(20) -- 行业分类代码
    ,corp_scale varchar2(20) -- 企业规模
    ,corp_scope varchar2(1000) -- 经营范围
    ,address varchar2(1000) -- 客户地址
    ,tel varchar2(100) -- 联系电话
    ,fex varchar2(16) -- 传真号码
    ,email varchar2(50) -- 电子邮箱
    ,reg_capital varchar2(500) -- 注册资本
    ,contrib_capital varchar2(20) -- 实缴资本
    ,reg_date timestamp -- 注册时间
    ,legal_name varchar2(500) -- 法人姓名
    ,legal_cert_type varchar2(10) -- 法人证件类型
    ,legal_cert_no varchar2(64) -- 法人证件号码
    ,financial_name varchar2(500) -- 财务姓名
    ,financial_cert_type varchar2(10) -- 财务证件类型
    ,financial_cert_no varchar2(64) -- 财务证件号码
    ,manager_no varchar2(32) -- 客户经理编号
    ,manager_name varchar2(100) -- 客户经理姓名
    ,manager_mobile varchar2(60) -- 客户经理手机号
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
grant select on ${iol_schema}.rtis_bank_cust_corp to ${iml_schema};
grant select on ${iol_schema}.rtis_bank_cust_corp to ${icl_schema};
grant select on ${iol_schema}.rtis_bank_cust_corp to ${idl_schema};
grant select on ${iol_schema}.rtis_bank_cust_corp to ${iel_schema};

-- comment
comment on table ${iol_schema}.rtis_bank_cust_corp is '客户信息表';
comment on column ${iol_schema}.rtis_bank_cust_corp.biz_lic_exp_date is '营业执照到期日期';
comment on column ${iol_schema}.rtis_bank_cust_corp.open_at is '开户时间';
comment on column ${iol_schema}.rtis_bank_cust_corp.create_at is '入库时间';
comment on column ${iol_schema}.rtis_bank_cust_corp.create_by is '入库人';
comment on column ${iol_schema}.rtis_bank_cust_corp.last_update_at is '入库后最后变更时间';
comment on column ${iol_schema}.rtis_bank_cust_corp.last_update_by is '最后变更人';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_surname is '客户姓氏';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_middle_name is '客户中间名';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_first_name is '客户名字';
comment on column ${iol_schema}.rtis_bank_cust_corp.id_card_type is '证件类型';
comment on column ${iol_schema}.rtis_bank_cust_corp.id_card_number is '证件号码';
comment on column ${iol_schema}.rtis_bank_cust_corp.mobile_number is '预留手机号';
comment on column ${iol_schema}.rtis_bank_cust_corp.age is '年龄(法人年龄)';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_open_inst_prov is '开户机构所在省';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_open_inst_city is '开户机构所在市';
comment on column ${iol_schema}.rtis_bank_cust_corp.id_card_prov is '身份证归属省';
comment on column ${iol_schema}.rtis_bank_cust_corp.id_card_city is '身份证归属市';
comment on column ${iol_schema}.rtis_bank_cust_corp.mobile_prov is '预留手机号归属省';
comment on column ${iol_schema}.rtis_bank_cust_corp.mobile_city is '预留手机号归属市';
comment on column ${iol_schema}.rtis_bank_cust_corp.gender is '性别';
comment on column ${iol_schema}.rtis_bank_cust_corp.risk_level is '风险等级';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_build_channel is '客户信息建立渠道';
comment on column ${iol_schema}.rtis_bank_cust_corp.occupation is '职业';
comment on column ${iol_schema}.rtis_bank_cust_corp.register_address is '注册地址';
comment on column ${iol_schema}.rtis_bank_cust_corp.business_address is '办公地址';
comment on column ${iol_schema}.rtis_bank_cust_corp.operation_no is '运营机构编号';
comment on column ${iol_schema}.rtis_bank_cust_corp.corporate_card_indate is '法定代表人证件有效期';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_principal_name is '客户负责人姓名';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_principal_card_type is '客户负责人证件类型';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_principal_card_indate is '单位负责人证件有效期';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_receiptor_name is '客户受益人姓名';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_receiptor_card_type is '客户受益人证件类型';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_receiptor_card_no is '客户受益人证件号';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_linkman_name is '客户业务联系人姓名';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_linkman_card_type is '客户业务联系人证件类型';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_linkman_card_no is '客户业务联系人证件号';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_agent_name is '客户授权代表人姓名';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_agent_card_type is '客户授权代表人证件类型';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_agent_card_no is '客户授权代表人证件号';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_charater is '客户性质';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_type is '客户类型';
comment on column ${iol_schema}.rtis_bank_cust_corp.corporate_phone_no is '法人联系电话';
comment on column ${iol_schema}.rtis_bank_cust_corp.finance_mgr_phone_no is '财务负责人联系电话';
comment on column ${iol_schema}.rtis_bank_cust_corp.posta_addr is '通讯地址';
comment on column ${iol_schema}.rtis_bank_cust_corp.iden_addr is '户口所在地';
comment on column ${iol_schema}.rtis_bank_cust_corp.work_unit_addr is '单位地址';
comment on column ${iol_schema}.rtis_bank_cust_corp.if_acct_black is '是否为黑名单';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_id is '客户号';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_name is '客户名称';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_stat is '客户状态';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_open_inst_no is '开户机构编号';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_open_inst_name is '开户机构名称';
comment on column ${iol_schema}.rtis_bank_cust_corp.corp_cert_type is '企业证件类型';
comment on column ${iol_schema}.rtis_bank_cust_corp.corp_cert_no is '企业证件号码';
comment on column ${iol_schema}.rtis_bank_cust_corp.cust_kind is '企业种类';
comment on column ${iol_schema}.rtis_bank_cust_corp.country is '国别代码';
comment on column ${iol_schema}.rtis_bank_cust_corp.ind_type is '行业分类代码';
comment on column ${iol_schema}.rtis_bank_cust_corp.corp_scale is '企业规模';
comment on column ${iol_schema}.rtis_bank_cust_corp.corp_scope is '经营范围';
comment on column ${iol_schema}.rtis_bank_cust_corp.address is '客户地址';
comment on column ${iol_schema}.rtis_bank_cust_corp.tel is '联系电话';
comment on column ${iol_schema}.rtis_bank_cust_corp.fex is '传真号码';
comment on column ${iol_schema}.rtis_bank_cust_corp.email is '电子邮箱';
comment on column ${iol_schema}.rtis_bank_cust_corp.reg_capital is '注册资本';
comment on column ${iol_schema}.rtis_bank_cust_corp.contrib_capital is '实缴资本';
comment on column ${iol_schema}.rtis_bank_cust_corp.reg_date is '注册时间';
comment on column ${iol_schema}.rtis_bank_cust_corp.legal_name is '法人姓名';
comment on column ${iol_schema}.rtis_bank_cust_corp.legal_cert_type is '法人证件类型';
comment on column ${iol_schema}.rtis_bank_cust_corp.legal_cert_no is '法人证件号码';
comment on column ${iol_schema}.rtis_bank_cust_corp.financial_name is '财务姓名';
comment on column ${iol_schema}.rtis_bank_cust_corp.financial_cert_type is '财务证件类型';
comment on column ${iol_schema}.rtis_bank_cust_corp.financial_cert_no is '财务证件号码';
comment on column ${iol_schema}.rtis_bank_cust_corp.manager_no is '客户经理编号';
comment on column ${iol_schema}.rtis_bank_cust_corp.manager_name is '客户经理姓名';
comment on column ${iol_schema}.rtis_bank_cust_corp.manager_mobile is '客户经理手机号';
comment on column ${iol_schema}.rtis_bank_cust_corp.start_dt is '开始时间';
comment on column ${iol_schema}.rtis_bank_cust_corp.end_dt is '结束时间';
comment on column ${iol_schema}.rtis_bank_cust_corp.id_mark is '增删标志';
comment on column ${iol_schema}.rtis_bank_cust_corp.etl_timestamp is 'ETL处理时间戳';
