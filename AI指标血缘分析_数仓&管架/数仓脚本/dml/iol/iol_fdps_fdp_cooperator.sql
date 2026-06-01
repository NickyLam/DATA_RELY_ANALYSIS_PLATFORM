/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fdps_fdp_cooperator
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.fdps_fdp_cooperator_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fdps_fdp_cooperator;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fdps_fdp_cooperator_op purge;
drop table ${iol_schema}.fdps_fdp_cooperator_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fdps_fdp_cooperator_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fdps_fdp_cooperator where 0=1;

create table ${iol_schema}.fdps_fdp_cooperator_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fdps_fdp_cooperator where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fdps_fdp_cooperator_cl(
            fdp_cooperator_id -- 字段id
            ,parent_merchant_id -- 银行合作商编号
            ,parent_merchant_name -- 银行合作商名称
            ,customer_type -- 客户类型
            ,old_req_seq_no -- 第三方流水
            ,old_req_account -- 第三方客户标识
            ,ecif_account_id -- 客户号
            ,cust_id_type -- 证件类型
            ,cust_id_no -- 证件号码
            ,cust_id_due_date -- 证件到期日
            ,legal_person_name -- 法定代表人姓名
            ,legal_person_idtype -- 法定代表人证件类型
            ,legal_person_idno -- 法定代表人证件号码
            ,lpid_from_date -- 法人证件开始日期
            ,lpid_to_date -- 法人证件到期日期
            ,legal_person_telno -- 法人联系电话
            ,actor_name -- 经办人姓名
            ,actor_id_type -- 经办人证件类型
            ,actor_id_no -- 经办人证件号码
            ,actorid_from_date -- 经办人证件开始日期
            ,actorid_to_date -- 经办人证件到期日期
            ,actor_mobile -- 经办人手机号
            ,licence_copy_url -- 营业执照扫描件url
            ,lp_front_copy_url -- 法人身份证正面复印件url
            ,lp_rear_copy_url -- 法人身份证反面复印件url
            ,actor_front_copy_url -- 经办人身份证正面复印件url
            ,actor_rear_copy_url -- 经办人身份证反面复印件url
            ,detail_address -- 详细地址
            ,postal_code -- 邮政编码
            ,contact_tel -- 联系电话
            ,clear_account -- 合作商监管账号
            ,clear_account_name -- 合作商监管账户名称
            ,clear_org -- 合作商监管账户机构号
            ,clear_org_name -- 合作商监管账户机构名称
            ,mid_clear_account -- 中间入账账号
            ,mid_account_name -- 中间入账账号名称
            ,mid_clear_org -- 中间入账账号机构号
            ,mid_clear_org_name -- 中间入账账号机构名称
            ,dep_clear_account -- 第三方清算入账账号
            ,dep_account_name -- 第三方清算入账账号名称
            ,dep_clear_org -- 第三方清算入账账号机构号
            ,dep_clear_org_name -- 第三方清算入账账号机构名称
            ,cust_status -- 合作商状态
            ,account_no -- 主账号
            ,ext_name -- 扩展变量名
            ,ext_value -- 扩展变量值
            ,platform_code -- 开通渠道
            ,max_bind_cards -- 绑定卡数量上限
            ,operator_id -- 操作员编号
            ,operator_dept_id -- 操作员所属机构
            ,checker_id -- 复核操作员编号
            ,checker_dept_id -- 复核操作员所属机构
            ,description -- 描述
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事物时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事物时间
            ,parent_merchant_sname -- 银行合作商简称
            ,own_org_no -- 所属机构号
            ,dep_other_bank_flag -- 
            ,settle_model -- 清算模式
            ,active_msm_model -- 动账短信模式
            ,ep_clear_ac -- 企业结算户账号
            ,ep_clear_ac_name -- 企业结算户名称
            ,ep_clear_org -- 企业结算户机构号
            ,ep_clear_org_name -- 企业结算户机构名称
            ,ep_client_no -- 客户号
            ,merchant_no -- 商户号
            ,merchant_url -- 客户异步通知url
            ,recharge_url -- 充值异步通知url
            ,in_account_info -- 允许入账信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fdps_fdp_cooperator_op(
            fdp_cooperator_id -- 字段id
            ,parent_merchant_id -- 银行合作商编号
            ,parent_merchant_name -- 银行合作商名称
            ,customer_type -- 客户类型
            ,old_req_seq_no -- 第三方流水
            ,old_req_account -- 第三方客户标识
            ,ecif_account_id -- 客户号
            ,cust_id_type -- 证件类型
            ,cust_id_no -- 证件号码
            ,cust_id_due_date -- 证件到期日
            ,legal_person_name -- 法定代表人姓名
            ,legal_person_idtype -- 法定代表人证件类型
            ,legal_person_idno -- 法定代表人证件号码
            ,lpid_from_date -- 法人证件开始日期
            ,lpid_to_date -- 法人证件到期日期
            ,legal_person_telno -- 法人联系电话
            ,actor_name -- 经办人姓名
            ,actor_id_type -- 经办人证件类型
            ,actor_id_no -- 经办人证件号码
            ,actorid_from_date -- 经办人证件开始日期
            ,actorid_to_date -- 经办人证件到期日期
            ,actor_mobile -- 经办人手机号
            ,licence_copy_url -- 营业执照扫描件url
            ,lp_front_copy_url -- 法人身份证正面复印件url
            ,lp_rear_copy_url -- 法人身份证反面复印件url
            ,actor_front_copy_url -- 经办人身份证正面复印件url
            ,actor_rear_copy_url -- 经办人身份证反面复印件url
            ,detail_address -- 详细地址
            ,postal_code -- 邮政编码
            ,contact_tel -- 联系电话
            ,clear_account -- 合作商监管账号
            ,clear_account_name -- 合作商监管账户名称
            ,clear_org -- 合作商监管账户机构号
            ,clear_org_name -- 合作商监管账户机构名称
            ,mid_clear_account -- 中间入账账号
            ,mid_account_name -- 中间入账账号名称
            ,mid_clear_org -- 中间入账账号机构号
            ,mid_clear_org_name -- 中间入账账号机构名称
            ,dep_clear_account -- 第三方清算入账账号
            ,dep_account_name -- 第三方清算入账账号名称
            ,dep_clear_org -- 第三方清算入账账号机构号
            ,dep_clear_org_name -- 第三方清算入账账号机构名称
            ,cust_status -- 合作商状态
            ,account_no -- 主账号
            ,ext_name -- 扩展变量名
            ,ext_value -- 扩展变量值
            ,platform_code -- 开通渠道
            ,max_bind_cards -- 绑定卡数量上限
            ,operator_id -- 操作员编号
            ,operator_dept_id -- 操作员所属机构
            ,checker_id -- 复核操作员编号
            ,checker_dept_id -- 复核操作员所属机构
            ,description -- 描述
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事物时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事物时间
            ,parent_merchant_sname -- 银行合作商简称
            ,own_org_no -- 所属机构号
            ,dep_other_bank_flag -- 
            ,settle_model -- 清算模式
            ,active_msm_model -- 动账短信模式
            ,ep_clear_ac -- 企业结算户账号
            ,ep_clear_ac_name -- 企业结算户名称
            ,ep_clear_org -- 企业结算户机构号
            ,ep_clear_org_name -- 企业结算户机构名称
            ,ep_client_no -- 客户号
            ,merchant_no -- 商户号
            ,merchant_url -- 客户异步通知url
            ,recharge_url -- 充值异步通知url
            ,in_account_info -- 允许入账信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fdp_cooperator_id, o.fdp_cooperator_id) as fdp_cooperator_id -- 字段id
    ,nvl(n.parent_merchant_id, o.parent_merchant_id) as parent_merchant_id -- 银行合作商编号
    ,nvl(n.parent_merchant_name, o.parent_merchant_name) as parent_merchant_name -- 银行合作商名称
    ,nvl(n.customer_type, o.customer_type) as customer_type -- 客户类型
    ,nvl(n.old_req_seq_no, o.old_req_seq_no) as old_req_seq_no -- 第三方流水
    ,nvl(n.old_req_account, o.old_req_account) as old_req_account -- 第三方客户标识
    ,nvl(n.ecif_account_id, o.ecif_account_id) as ecif_account_id -- 客户号
    ,nvl(n.cust_id_type, o.cust_id_type) as cust_id_type -- 证件类型
    ,nvl(n.cust_id_no, o.cust_id_no) as cust_id_no -- 证件号码
    ,nvl(n.cust_id_due_date, o.cust_id_due_date) as cust_id_due_date -- 证件到期日
    ,nvl(n.legal_person_name, o.legal_person_name) as legal_person_name -- 法定代表人姓名
    ,nvl(n.legal_person_idtype, o.legal_person_idtype) as legal_person_idtype -- 法定代表人证件类型
    ,nvl(n.legal_person_idno, o.legal_person_idno) as legal_person_idno -- 法定代表人证件号码
    ,nvl(n.lpid_from_date, o.lpid_from_date) as lpid_from_date -- 法人证件开始日期
    ,nvl(n.lpid_to_date, o.lpid_to_date) as lpid_to_date -- 法人证件到期日期
    ,nvl(n.legal_person_telno, o.legal_person_telno) as legal_person_telno -- 法人联系电话
    ,nvl(n.actor_name, o.actor_name) as actor_name -- 经办人姓名
    ,nvl(n.actor_id_type, o.actor_id_type) as actor_id_type -- 经办人证件类型
    ,nvl(n.actor_id_no, o.actor_id_no) as actor_id_no -- 经办人证件号码
    ,nvl(n.actorid_from_date, o.actorid_from_date) as actorid_from_date -- 经办人证件开始日期
    ,nvl(n.actorid_to_date, o.actorid_to_date) as actorid_to_date -- 经办人证件到期日期
    ,nvl(n.actor_mobile, o.actor_mobile) as actor_mobile -- 经办人手机号
    ,nvl(n.licence_copy_url, o.licence_copy_url) as licence_copy_url -- 营业执照扫描件url
    ,nvl(n.lp_front_copy_url, o.lp_front_copy_url) as lp_front_copy_url -- 法人身份证正面复印件url
    ,nvl(n.lp_rear_copy_url, o.lp_rear_copy_url) as lp_rear_copy_url -- 法人身份证反面复印件url
    ,nvl(n.actor_front_copy_url, o.actor_front_copy_url) as actor_front_copy_url -- 经办人身份证正面复印件url
    ,nvl(n.actor_rear_copy_url, o.actor_rear_copy_url) as actor_rear_copy_url -- 经办人身份证反面复印件url
    ,nvl(n.detail_address, o.detail_address) as detail_address -- 详细地址
    ,nvl(n.postal_code, o.postal_code) as postal_code -- 邮政编码
    ,nvl(n.contact_tel, o.contact_tel) as contact_tel -- 联系电话
    ,nvl(n.clear_account, o.clear_account) as clear_account -- 合作商监管账号
    ,nvl(n.clear_account_name, o.clear_account_name) as clear_account_name -- 合作商监管账户名称
    ,nvl(n.clear_org, o.clear_org) as clear_org -- 合作商监管账户机构号
    ,nvl(n.clear_org_name, o.clear_org_name) as clear_org_name -- 合作商监管账户机构名称
    ,nvl(n.mid_clear_account, o.mid_clear_account) as mid_clear_account -- 中间入账账号
    ,nvl(n.mid_account_name, o.mid_account_name) as mid_account_name -- 中间入账账号名称
    ,nvl(n.mid_clear_org, o.mid_clear_org) as mid_clear_org -- 中间入账账号机构号
    ,nvl(n.mid_clear_org_name, o.mid_clear_org_name) as mid_clear_org_name -- 中间入账账号机构名称
    ,nvl(n.dep_clear_account, o.dep_clear_account) as dep_clear_account -- 第三方清算入账账号
    ,nvl(n.dep_account_name, o.dep_account_name) as dep_account_name -- 第三方清算入账账号名称
    ,nvl(n.dep_clear_org, o.dep_clear_org) as dep_clear_org -- 第三方清算入账账号机构号
    ,nvl(n.dep_clear_org_name, o.dep_clear_org_name) as dep_clear_org_name -- 第三方清算入账账号机构名称
    ,nvl(n.cust_status, o.cust_status) as cust_status -- 合作商状态
    ,nvl(n.account_no, o.account_no) as account_no -- 主账号
    ,nvl(n.ext_name, o.ext_name) as ext_name -- 扩展变量名
    ,nvl(n.ext_value, o.ext_value) as ext_value -- 扩展变量值
    ,nvl(n.platform_code, o.platform_code) as platform_code -- 开通渠道
    ,nvl(n.max_bind_cards, o.max_bind_cards) as max_bind_cards -- 绑定卡数量上限
    ,nvl(n.operator_id, o.operator_id) as operator_id -- 操作员编号
    ,nvl(n.operator_dept_id, o.operator_dept_id) as operator_dept_id -- 操作员所属机构
    ,nvl(n.checker_id, o.checker_id) as checker_id -- 复核操作员编号
    ,nvl(n.checker_dept_id, o.checker_dept_id) as checker_dept_id -- 复核操作员所属机构
    ,nvl(n.description, o.description) as description -- 描述
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 最后更新时间
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 最后更新事物时间
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 创建时间
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 创建事物时间
    ,nvl(n.parent_merchant_sname, o.parent_merchant_sname) as parent_merchant_sname -- 银行合作商简称
    ,nvl(n.own_org_no, o.own_org_no) as own_org_no -- 所属机构号
    ,nvl(n.dep_other_bank_flag, o.dep_other_bank_flag) as dep_other_bank_flag -- 
    ,nvl(n.settle_model, o.settle_model) as settle_model -- 清算模式
    ,nvl(n.active_msm_model, o.active_msm_model) as active_msm_model -- 动账短信模式
    ,nvl(n.ep_clear_ac, o.ep_clear_ac) as ep_clear_ac -- 企业结算户账号
    ,nvl(n.ep_clear_ac_name, o.ep_clear_ac_name) as ep_clear_ac_name -- 企业结算户名称
    ,nvl(n.ep_clear_org, o.ep_clear_org) as ep_clear_org -- 企业结算户机构号
    ,nvl(n.ep_clear_org_name, o.ep_clear_org_name) as ep_clear_org_name -- 企业结算户机构名称
    ,nvl(n.ep_client_no, o.ep_client_no) as ep_client_no -- 客户号
    ,nvl(n.merchant_no, o.merchant_no) as merchant_no -- 商户号
    ,nvl(n.merchant_url, o.merchant_url) as merchant_url -- 客户异步通知url
    ,nvl(n.recharge_url, o.recharge_url) as recharge_url -- 充值异步通知url
    ,nvl(n.in_account_info, o.in_account_info) as in_account_info -- 允许入账信息
    ,case when
            n.fdp_cooperator_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fdp_cooperator_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fdp_cooperator_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fdps_fdp_cooperator_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fdps_fdp_cooperator where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.fdp_cooperator_id = n.fdp_cooperator_id
where (
        o.fdp_cooperator_id is null
    )
    or (
        n.fdp_cooperator_id is null
    )
    or (
        o.parent_merchant_id <> n.parent_merchant_id
        or o.parent_merchant_name <> n.parent_merchant_name
        or o.customer_type <> n.customer_type
        or o.old_req_seq_no <> n.old_req_seq_no
        or o.old_req_account <> n.old_req_account
        or o.ecif_account_id <> n.ecif_account_id
        or o.cust_id_type <> n.cust_id_type
        or o.cust_id_no <> n.cust_id_no
        or o.cust_id_due_date <> n.cust_id_due_date
        or o.legal_person_name <> n.legal_person_name
        or o.legal_person_idtype <> n.legal_person_idtype
        or o.legal_person_idno <> n.legal_person_idno
        or o.lpid_from_date <> n.lpid_from_date
        or o.lpid_to_date <> n.lpid_to_date
        or o.legal_person_telno <> n.legal_person_telno
        or o.actor_name <> n.actor_name
        or o.actor_id_type <> n.actor_id_type
        or o.actor_id_no <> n.actor_id_no
        or o.actorid_from_date <> n.actorid_from_date
        or o.actorid_to_date <> n.actorid_to_date
        or o.actor_mobile <> n.actor_mobile
        or o.licence_copy_url <> n.licence_copy_url
        or o.lp_front_copy_url <> n.lp_front_copy_url
        or o.lp_rear_copy_url <> n.lp_rear_copy_url
        or o.actor_front_copy_url <> n.actor_front_copy_url
        or o.actor_rear_copy_url <> n.actor_rear_copy_url
        or o.detail_address <> n.detail_address
        or o.postal_code <> n.postal_code
        or o.contact_tel <> n.contact_tel
        or o.clear_account <> n.clear_account
        or o.clear_account_name <> n.clear_account_name
        or o.clear_org <> n.clear_org
        or o.clear_org_name <> n.clear_org_name
        or o.mid_clear_account <> n.mid_clear_account
        or o.mid_account_name <> n.mid_account_name
        or o.mid_clear_org <> n.mid_clear_org
        or o.mid_clear_org_name <> n.mid_clear_org_name
        or o.dep_clear_account <> n.dep_clear_account
        or o.dep_account_name <> n.dep_account_name
        or o.dep_clear_org <> n.dep_clear_org
        or o.dep_clear_org_name <> n.dep_clear_org_name
        or o.cust_status <> n.cust_status
        or o.account_no <> n.account_no
        or o.ext_name <> n.ext_name
        or o.ext_value <> n.ext_value
        or o.platform_code <> n.platform_code
        or o.max_bind_cards <> n.max_bind_cards
        or o.operator_id <> n.operator_id
        or o.operator_dept_id <> n.operator_dept_id
        or o.checker_id <> n.checker_id
        or o.checker_dept_id <> n.checker_dept_id
        or o.description <> n.description
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.parent_merchant_sname <> n.parent_merchant_sname
        or o.own_org_no <> n.own_org_no
        or o.dep_other_bank_flag <> n.dep_other_bank_flag
        or o.settle_model <> n.settle_model
        or o.active_msm_model <> n.active_msm_model
        or o.ep_clear_ac <> n.ep_clear_ac
        or o.ep_clear_ac_name <> n.ep_clear_ac_name
        or o.ep_clear_org <> n.ep_clear_org
        or o.ep_clear_org_name <> n.ep_clear_org_name
        or o.ep_client_no <> n.ep_client_no
        or o.merchant_no <> n.merchant_no
        or o.merchant_url <> n.merchant_url
        or o.recharge_url <> n.recharge_url
        or o.in_account_info <> n.in_account_info
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fdps_fdp_cooperator_cl(
            fdp_cooperator_id -- 字段id
            ,parent_merchant_id -- 银行合作商编号
            ,parent_merchant_name -- 银行合作商名称
            ,customer_type -- 客户类型
            ,old_req_seq_no -- 第三方流水
            ,old_req_account -- 第三方客户标识
            ,ecif_account_id -- 客户号
            ,cust_id_type -- 证件类型
            ,cust_id_no -- 证件号码
            ,cust_id_due_date -- 证件到期日
            ,legal_person_name -- 法定代表人姓名
            ,legal_person_idtype -- 法定代表人证件类型
            ,legal_person_idno -- 法定代表人证件号码
            ,lpid_from_date -- 法人证件开始日期
            ,lpid_to_date -- 法人证件到期日期
            ,legal_person_telno -- 法人联系电话
            ,actor_name -- 经办人姓名
            ,actor_id_type -- 经办人证件类型
            ,actor_id_no -- 经办人证件号码
            ,actorid_from_date -- 经办人证件开始日期
            ,actorid_to_date -- 经办人证件到期日期
            ,actor_mobile -- 经办人手机号
            ,licence_copy_url -- 营业执照扫描件url
            ,lp_front_copy_url -- 法人身份证正面复印件url
            ,lp_rear_copy_url -- 法人身份证反面复印件url
            ,actor_front_copy_url -- 经办人身份证正面复印件url
            ,actor_rear_copy_url -- 经办人身份证反面复印件url
            ,detail_address -- 详细地址
            ,postal_code -- 邮政编码
            ,contact_tel -- 联系电话
            ,clear_account -- 合作商监管账号
            ,clear_account_name -- 合作商监管账户名称
            ,clear_org -- 合作商监管账户机构号
            ,clear_org_name -- 合作商监管账户机构名称
            ,mid_clear_account -- 中间入账账号
            ,mid_account_name -- 中间入账账号名称
            ,mid_clear_org -- 中间入账账号机构号
            ,mid_clear_org_name -- 中间入账账号机构名称
            ,dep_clear_account -- 第三方清算入账账号
            ,dep_account_name -- 第三方清算入账账号名称
            ,dep_clear_org -- 第三方清算入账账号机构号
            ,dep_clear_org_name -- 第三方清算入账账号机构名称
            ,cust_status -- 合作商状态
            ,account_no -- 主账号
            ,ext_name -- 扩展变量名
            ,ext_value -- 扩展变量值
            ,platform_code -- 开通渠道
            ,max_bind_cards -- 绑定卡数量上限
            ,operator_id -- 操作员编号
            ,operator_dept_id -- 操作员所属机构
            ,checker_id -- 复核操作员编号
            ,checker_dept_id -- 复核操作员所属机构
            ,description -- 描述
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事物时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事物时间
            ,parent_merchant_sname -- 银行合作商简称
            ,own_org_no -- 所属机构号
            ,dep_other_bank_flag -- 
            ,settle_model -- 清算模式
            ,active_msm_model -- 动账短信模式
            ,ep_clear_ac -- 企业结算户账号
            ,ep_clear_ac_name -- 企业结算户名称
            ,ep_clear_org -- 企业结算户机构号
            ,ep_clear_org_name -- 企业结算户机构名称
            ,ep_client_no -- 客户号
            ,merchant_no -- 商户号
            ,merchant_url -- 客户异步通知url
            ,recharge_url -- 充值异步通知url
            ,in_account_info -- 允许入账信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fdps_fdp_cooperator_op(
            fdp_cooperator_id -- 字段id
            ,parent_merchant_id -- 银行合作商编号
            ,parent_merchant_name -- 银行合作商名称
            ,customer_type -- 客户类型
            ,old_req_seq_no -- 第三方流水
            ,old_req_account -- 第三方客户标识
            ,ecif_account_id -- 客户号
            ,cust_id_type -- 证件类型
            ,cust_id_no -- 证件号码
            ,cust_id_due_date -- 证件到期日
            ,legal_person_name -- 法定代表人姓名
            ,legal_person_idtype -- 法定代表人证件类型
            ,legal_person_idno -- 法定代表人证件号码
            ,lpid_from_date -- 法人证件开始日期
            ,lpid_to_date -- 法人证件到期日期
            ,legal_person_telno -- 法人联系电话
            ,actor_name -- 经办人姓名
            ,actor_id_type -- 经办人证件类型
            ,actor_id_no -- 经办人证件号码
            ,actorid_from_date -- 经办人证件开始日期
            ,actorid_to_date -- 经办人证件到期日期
            ,actor_mobile -- 经办人手机号
            ,licence_copy_url -- 营业执照扫描件url
            ,lp_front_copy_url -- 法人身份证正面复印件url
            ,lp_rear_copy_url -- 法人身份证反面复印件url
            ,actor_front_copy_url -- 经办人身份证正面复印件url
            ,actor_rear_copy_url -- 经办人身份证反面复印件url
            ,detail_address -- 详细地址
            ,postal_code -- 邮政编码
            ,contact_tel -- 联系电话
            ,clear_account -- 合作商监管账号
            ,clear_account_name -- 合作商监管账户名称
            ,clear_org -- 合作商监管账户机构号
            ,clear_org_name -- 合作商监管账户机构名称
            ,mid_clear_account -- 中间入账账号
            ,mid_account_name -- 中间入账账号名称
            ,mid_clear_org -- 中间入账账号机构号
            ,mid_clear_org_name -- 中间入账账号机构名称
            ,dep_clear_account -- 第三方清算入账账号
            ,dep_account_name -- 第三方清算入账账号名称
            ,dep_clear_org -- 第三方清算入账账号机构号
            ,dep_clear_org_name -- 第三方清算入账账号机构名称
            ,cust_status -- 合作商状态
            ,account_no -- 主账号
            ,ext_name -- 扩展变量名
            ,ext_value -- 扩展变量值
            ,platform_code -- 开通渠道
            ,max_bind_cards -- 绑定卡数量上限
            ,operator_id -- 操作员编号
            ,operator_dept_id -- 操作员所属机构
            ,checker_id -- 复核操作员编号
            ,checker_dept_id -- 复核操作员所属机构
            ,description -- 描述
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事物时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事物时间
            ,parent_merchant_sname -- 银行合作商简称
            ,own_org_no -- 所属机构号
            ,dep_other_bank_flag -- 
            ,settle_model -- 清算模式
            ,active_msm_model -- 动账短信模式
            ,ep_clear_ac -- 企业结算户账号
            ,ep_clear_ac_name -- 企业结算户名称
            ,ep_clear_org -- 企业结算户机构号
            ,ep_clear_org_name -- 企业结算户机构名称
            ,ep_client_no -- 客户号
            ,merchant_no -- 商户号
            ,merchant_url -- 客户异步通知url
            ,recharge_url -- 充值异步通知url
            ,in_account_info -- 允许入账信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fdp_cooperator_id -- 字段id
    ,o.parent_merchant_id -- 银行合作商编号
    ,o.parent_merchant_name -- 银行合作商名称
    ,o.customer_type -- 客户类型
    ,o.old_req_seq_no -- 第三方流水
    ,o.old_req_account -- 第三方客户标识
    ,o.ecif_account_id -- 客户号
    ,o.cust_id_type -- 证件类型
    ,o.cust_id_no -- 证件号码
    ,o.cust_id_due_date -- 证件到期日
    ,o.legal_person_name -- 法定代表人姓名
    ,o.legal_person_idtype -- 法定代表人证件类型
    ,o.legal_person_idno -- 法定代表人证件号码
    ,o.lpid_from_date -- 法人证件开始日期
    ,o.lpid_to_date -- 法人证件到期日期
    ,o.legal_person_telno -- 法人联系电话
    ,o.actor_name -- 经办人姓名
    ,o.actor_id_type -- 经办人证件类型
    ,o.actor_id_no -- 经办人证件号码
    ,o.actorid_from_date -- 经办人证件开始日期
    ,o.actorid_to_date -- 经办人证件到期日期
    ,o.actor_mobile -- 经办人手机号
    ,o.licence_copy_url -- 营业执照扫描件url
    ,o.lp_front_copy_url -- 法人身份证正面复印件url
    ,o.lp_rear_copy_url -- 法人身份证反面复印件url
    ,o.actor_front_copy_url -- 经办人身份证正面复印件url
    ,o.actor_rear_copy_url -- 经办人身份证反面复印件url
    ,o.detail_address -- 详细地址
    ,o.postal_code -- 邮政编码
    ,o.contact_tel -- 联系电话
    ,o.clear_account -- 合作商监管账号
    ,o.clear_account_name -- 合作商监管账户名称
    ,o.clear_org -- 合作商监管账户机构号
    ,o.clear_org_name -- 合作商监管账户机构名称
    ,o.mid_clear_account -- 中间入账账号
    ,o.mid_account_name -- 中间入账账号名称
    ,o.mid_clear_org -- 中间入账账号机构号
    ,o.mid_clear_org_name -- 中间入账账号机构名称
    ,o.dep_clear_account -- 第三方清算入账账号
    ,o.dep_account_name -- 第三方清算入账账号名称
    ,o.dep_clear_org -- 第三方清算入账账号机构号
    ,o.dep_clear_org_name -- 第三方清算入账账号机构名称
    ,o.cust_status -- 合作商状态
    ,o.account_no -- 主账号
    ,o.ext_name -- 扩展变量名
    ,o.ext_value -- 扩展变量值
    ,o.platform_code -- 开通渠道
    ,o.max_bind_cards -- 绑定卡数量上限
    ,o.operator_id -- 操作员编号
    ,o.operator_dept_id -- 操作员所属机构
    ,o.checker_id -- 复核操作员编号
    ,o.checker_dept_id -- 复核操作员所属机构
    ,o.description -- 描述
    ,o.last_updated_stamp -- 最后更新时间
    ,o.last_updated_tx_stamp -- 最后更新事物时间
    ,o.created_stamp -- 创建时间
    ,o.created_tx_stamp -- 创建事物时间
    ,o.parent_merchant_sname -- 银行合作商简称
    ,o.own_org_no -- 所属机构号
    ,o.dep_other_bank_flag -- 
    ,o.settle_model -- 清算模式
    ,o.active_msm_model -- 动账短信模式
    ,o.ep_clear_ac -- 企业结算户账号
    ,o.ep_clear_ac_name -- 企业结算户名称
    ,o.ep_clear_org -- 企业结算户机构号
    ,o.ep_clear_org_name -- 企业结算户机构名称
    ,o.ep_client_no -- 客户号
    ,o.merchant_no -- 商户号
    ,o.merchant_url -- 客户异步通知url
    ,o.recharge_url -- 充值异步通知url
    ,o.in_account_info -- 允许入账信息
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fdps_fdp_cooperator_bk o
    left join ${iol_schema}.fdps_fdp_cooperator_op n
        on
            o.fdp_cooperator_id = n.fdp_cooperator_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fdps_fdp_cooperator_cl d
        on
            o.fdp_cooperator_id = d.fdp_cooperator_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fdps_fdp_cooperator;

-- 4.2 exchange partition
alter table ${iol_schema}.fdps_fdp_cooperator exchange partition p_19000101 with table ${iol_schema}.fdps_fdp_cooperator_cl;
alter table ${iol_schema}.fdps_fdp_cooperator exchange partition p_20991231 with table ${iol_schema}.fdps_fdp_cooperator_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fdps_fdp_cooperator to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fdps_fdp_cooperator_op purge;
drop table ${iol_schema}.fdps_fdp_cooperator_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fdps_fdp_cooperator_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fdps_fdp_cooperator',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
