/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fdps_fdp_cooperator
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fdps_fdp_cooperator
whenever sqlerror continue none;
drop table ${iol_schema}.fdps_fdp_cooperator purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fdps_fdp_cooperator(
    fdp_cooperator_id varchar2(120) -- 字段id
    ,parent_merchant_id varchar2(360) -- 银行合作商编号
    ,parent_merchant_name varchar2(1530) -- 银行合作商名称
    ,customer_type varchar2(1530) -- 客户类型
    ,old_req_seq_no varchar2(360) -- 第三方流水
    ,old_req_account varchar2(360) -- 第三方客户标识
    ,ecif_account_id varchar2(360) -- 客户号
    ,cust_id_type varchar2(360) -- 证件类型
    ,cust_id_no varchar2(360) -- 证件号码
    ,cust_id_due_date varchar2(360) -- 证件到期日
    ,legal_person_name varchar2(360) -- 法定代表人姓名
    ,legal_person_idtype varchar2(360) -- 法定代表人证件类型
    ,legal_person_idno varchar2(360) -- 法定代表人证件号码
    ,lpid_from_date varchar2(360) -- 法人证件开始日期
    ,lpid_to_date varchar2(360) -- 法人证件到期日期
    ,legal_person_telno varchar2(360) -- 法人联系电话
    ,actor_name varchar2(1530) -- 经办人姓名
    ,actor_id_type varchar2(360) -- 经办人证件类型
    ,actor_id_no varchar2(360) -- 经办人证件号码
    ,actorid_from_date varchar2(360) -- 经办人证件开始日期
    ,actorid_to_date varchar2(360) -- 经办人证件到期日期
    ,actor_mobile varchar2(360) -- 经办人手机号
    ,licence_copy_url varchar2(4000) -- 营业执照扫描件url
    ,lp_front_copy_url varchar2(4000) -- 法人身份证正面复印件url
    ,lp_rear_copy_url varchar2(4000) -- 法人身份证反面复印件url
    ,actor_front_copy_url varchar2(4000) -- 经办人身份证正面复印件url
    ,actor_rear_copy_url varchar2(4000) -- 经办人身份证反面复印件url
    ,detail_address varchar2(1530) -- 详细地址
    ,postal_code varchar2(360) -- 邮政编码
    ,contact_tel varchar2(360) -- 联系电话
    ,clear_account varchar2(360) -- 合作商监管账号
    ,clear_account_name varchar2(1530) -- 合作商监管账户名称
    ,clear_org varchar2(360) -- 合作商监管账户机构号
    ,clear_org_name varchar2(1530) -- 合作商监管账户机构名称
    ,mid_clear_account varchar2(1530) -- 中间入账账号
    ,mid_account_name varchar2(1530) -- 中间入账账号名称
    ,mid_clear_org varchar2(1530) -- 中间入账账号机构号
    ,mid_clear_org_name varchar2(1530) -- 中间入账账号机构名称
    ,dep_clear_account varchar2(360) -- 第三方清算入账账号
    ,dep_account_name varchar2(1530) -- 第三方清算入账账号名称
    ,dep_clear_org varchar2(360) -- 第三方清算入账账号机构号
    ,dep_clear_org_name varchar2(1530) -- 第三方清算入账账号机构名称
    ,cust_status varchar2(60) -- 合作商状态
    ,account_no varchar2(120) -- 主账号
    ,ext_name varchar2(1530) -- 扩展变量名
    ,ext_value varchar2(1530) -- 扩展变量值
    ,platform_code varchar2(1530) -- 开通渠道
    ,max_bind_cards number(8) -- 绑定卡数量上限
    ,operator_id varchar2(1530) -- 操作员编号
    ,operator_dept_id varchar2(1530) -- 操作员所属机构
    ,checker_id varchar2(360) -- 复核操作员编号
    ,checker_dept_id varchar2(360) -- 复核操作员所属机构
    ,description varchar2(4000) -- 描述
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事物时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事物时间
    ,parent_merchant_sname varchar2(1530) -- 银行合作商简称
    ,own_org_no varchar2(1530) -- 所属机构号
    ,dep_other_bank_flag varchar2(1530) -- 
    ,settle_model varchar2(60) -- 清算模式
    ,active_msm_model varchar2(60) -- 动账短信模式
    ,ep_clear_ac varchar2(765) -- 企业结算户账号
    ,ep_clear_ac_name varchar2(765) -- 企业结算户名称
    ,ep_clear_org varchar2(765) -- 企业结算户机构号
    ,ep_clear_org_name varchar2(765) -- 企业结算户机构名称
    ,ep_client_no varchar2(765) -- 客户号
    ,merchant_no varchar2(120) -- 商户号
    ,merchant_url varchar2(1530) -- 客户异步通知url
    ,recharge_url varchar2(1530) -- 充值异步通知url
    ,in_account_info varchar2(4000) -- 允许入账信息
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fdps_fdp_cooperator to ${iml_schema};
grant select on ${iol_schema}.fdps_fdp_cooperator to ${icl_schema};
grant select on ${iol_schema}.fdps_fdp_cooperator to ${idl_schema};
grant select on ${iol_schema}.fdps_fdp_cooperator to ${iel_schema};

-- comment
comment on table ${iol_schema}.fdps_fdp_cooperator is '';
comment on column ${iol_schema}.fdps_fdp_cooperator.fdp_cooperator_id is '字段id';
comment on column ${iol_schema}.fdps_fdp_cooperator.parent_merchant_id is '银行合作商编号';
comment on column ${iol_schema}.fdps_fdp_cooperator.parent_merchant_name is '银行合作商名称';
comment on column ${iol_schema}.fdps_fdp_cooperator.customer_type is '客户类型';
comment on column ${iol_schema}.fdps_fdp_cooperator.old_req_seq_no is '第三方流水';
comment on column ${iol_schema}.fdps_fdp_cooperator.old_req_account is '第三方客户标识';
comment on column ${iol_schema}.fdps_fdp_cooperator.ecif_account_id is '客户号';
comment on column ${iol_schema}.fdps_fdp_cooperator.cust_id_type is '证件类型';
comment on column ${iol_schema}.fdps_fdp_cooperator.cust_id_no is '证件号码';
comment on column ${iol_schema}.fdps_fdp_cooperator.cust_id_due_date is '证件到期日';
comment on column ${iol_schema}.fdps_fdp_cooperator.legal_person_name is '法定代表人姓名';
comment on column ${iol_schema}.fdps_fdp_cooperator.legal_person_idtype is '法定代表人证件类型';
comment on column ${iol_schema}.fdps_fdp_cooperator.legal_person_idno is '法定代表人证件号码';
comment on column ${iol_schema}.fdps_fdp_cooperator.lpid_from_date is '法人证件开始日期';
comment on column ${iol_schema}.fdps_fdp_cooperator.lpid_to_date is '法人证件到期日期';
comment on column ${iol_schema}.fdps_fdp_cooperator.legal_person_telno is '法人联系电话';
comment on column ${iol_schema}.fdps_fdp_cooperator.actor_name is '经办人姓名';
comment on column ${iol_schema}.fdps_fdp_cooperator.actor_id_type is '经办人证件类型';
comment on column ${iol_schema}.fdps_fdp_cooperator.actor_id_no is '经办人证件号码';
comment on column ${iol_schema}.fdps_fdp_cooperator.actorid_from_date is '经办人证件开始日期';
comment on column ${iol_schema}.fdps_fdp_cooperator.actorid_to_date is '经办人证件到期日期';
comment on column ${iol_schema}.fdps_fdp_cooperator.actor_mobile is '经办人手机号';
comment on column ${iol_schema}.fdps_fdp_cooperator.licence_copy_url is '营业执照扫描件url';
comment on column ${iol_schema}.fdps_fdp_cooperator.lp_front_copy_url is '法人身份证正面复印件url';
comment on column ${iol_schema}.fdps_fdp_cooperator.lp_rear_copy_url is '法人身份证反面复印件url';
comment on column ${iol_schema}.fdps_fdp_cooperator.actor_front_copy_url is '经办人身份证正面复印件url';
comment on column ${iol_schema}.fdps_fdp_cooperator.actor_rear_copy_url is '经办人身份证反面复印件url';
comment on column ${iol_schema}.fdps_fdp_cooperator.detail_address is '详细地址';
comment on column ${iol_schema}.fdps_fdp_cooperator.postal_code is '邮政编码';
comment on column ${iol_schema}.fdps_fdp_cooperator.contact_tel is '联系电话';
comment on column ${iol_schema}.fdps_fdp_cooperator.clear_account is '合作商监管账号';
comment on column ${iol_schema}.fdps_fdp_cooperator.clear_account_name is '合作商监管账户名称';
comment on column ${iol_schema}.fdps_fdp_cooperator.clear_org is '合作商监管账户机构号';
comment on column ${iol_schema}.fdps_fdp_cooperator.clear_org_name is '合作商监管账户机构名称';
comment on column ${iol_schema}.fdps_fdp_cooperator.mid_clear_account is '中间入账账号';
comment on column ${iol_schema}.fdps_fdp_cooperator.mid_account_name is '中间入账账号名称';
comment on column ${iol_schema}.fdps_fdp_cooperator.mid_clear_org is '中间入账账号机构号';
comment on column ${iol_schema}.fdps_fdp_cooperator.mid_clear_org_name is '中间入账账号机构名称';
comment on column ${iol_schema}.fdps_fdp_cooperator.dep_clear_account is '第三方清算入账账号';
comment on column ${iol_schema}.fdps_fdp_cooperator.dep_account_name is '第三方清算入账账号名称';
comment on column ${iol_schema}.fdps_fdp_cooperator.dep_clear_org is '第三方清算入账账号机构号';
comment on column ${iol_schema}.fdps_fdp_cooperator.dep_clear_org_name is '第三方清算入账账号机构名称';
comment on column ${iol_schema}.fdps_fdp_cooperator.cust_status is '合作商状态';
comment on column ${iol_schema}.fdps_fdp_cooperator.account_no is '主账号';
comment on column ${iol_schema}.fdps_fdp_cooperator.ext_name is '扩展变量名';
comment on column ${iol_schema}.fdps_fdp_cooperator.ext_value is '扩展变量值';
comment on column ${iol_schema}.fdps_fdp_cooperator.platform_code is '开通渠道';
comment on column ${iol_schema}.fdps_fdp_cooperator.max_bind_cards is '绑定卡数量上限';
comment on column ${iol_schema}.fdps_fdp_cooperator.operator_id is '操作员编号';
comment on column ${iol_schema}.fdps_fdp_cooperator.operator_dept_id is '操作员所属机构';
comment on column ${iol_schema}.fdps_fdp_cooperator.checker_id is '复核操作员编号';
comment on column ${iol_schema}.fdps_fdp_cooperator.checker_dept_id is '复核操作员所属机构';
comment on column ${iol_schema}.fdps_fdp_cooperator.description is '描述';
comment on column ${iol_schema}.fdps_fdp_cooperator.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.fdps_fdp_cooperator.last_updated_tx_stamp is '最后更新事物时间';
comment on column ${iol_schema}.fdps_fdp_cooperator.created_stamp is '创建时间';
comment on column ${iol_schema}.fdps_fdp_cooperator.created_tx_stamp is '创建事物时间';
comment on column ${iol_schema}.fdps_fdp_cooperator.parent_merchant_sname is '银行合作商简称';
comment on column ${iol_schema}.fdps_fdp_cooperator.own_org_no is '所属机构号';
comment on column ${iol_schema}.fdps_fdp_cooperator.dep_other_bank_flag is '';
comment on column ${iol_schema}.fdps_fdp_cooperator.settle_model is '清算模式';
comment on column ${iol_schema}.fdps_fdp_cooperator.active_msm_model is '动账短信模式';
comment on column ${iol_schema}.fdps_fdp_cooperator.ep_clear_ac is '企业结算户账号';
comment on column ${iol_schema}.fdps_fdp_cooperator.ep_clear_ac_name is '企业结算户名称';
comment on column ${iol_schema}.fdps_fdp_cooperator.ep_clear_org is '企业结算户机构号';
comment on column ${iol_schema}.fdps_fdp_cooperator.ep_clear_org_name is '企业结算户机构名称';
comment on column ${iol_schema}.fdps_fdp_cooperator.ep_client_no is '客户号';
comment on column ${iol_schema}.fdps_fdp_cooperator.merchant_no is '商户号';
comment on column ${iol_schema}.fdps_fdp_cooperator.merchant_url is '客户异步通知url';
comment on column ${iol_schema}.fdps_fdp_cooperator.recharge_url is '充值异步通知url';
comment on column ${iol_schema}.fdps_fdp_cooperator.in_account_info is '允许入账信息';
comment on column ${iol_schema}.fdps_fdp_cooperator.start_dt is '开始时间';
comment on column ${iol_schema}.fdps_fdp_cooperator.end_dt is '结束时间';
comment on column ${iol_schema}.fdps_fdp_cooperator.id_mark is '增删标志';
comment on column ${iol_schema}.fdps_fdp_cooperator.etl_timestamp is 'ETL处理时间戳';
