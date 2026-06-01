/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_tra_bank_account
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
create table ${iol_schema}.amss_tra_bank_account_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_tra_bank_account
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_tra_bank_account_op purge;
drop table ${iol_schema}.amss_tra_bank_account_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_tra_bank_account_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_tra_bank_account where 0=1;

create table ${iol_schema}.amss_tra_bank_account_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_tra_bank_account where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_tra_bank_account_cl(
            account_id -- 账户ID.
            ,org_id -- 机构ID.对应渠道编号或商户编号
            ,account_code -- 银行卡号.
            ,bank_id -- 开户银行.关联银行表( CMS_BANK )
            ,account_name -- 开户人.
            ,account_type -- 帐户类型.1:企业 ;2:个人;5:内部户
            ,contact_line -- 联行号.网点号、联行号
            ,remit_account_code -- 汇出方银行卡号.兴业叫汇出方银行卡号，浦发叫现代支付号
            ,is_inline -- 是否行内账号.true:是，false:不是
            ,bank_name -- 开户支行名称.
            ,province -- 开户支行所在省.
            ,city -- 开户支行所在市.
            ,id_card_type -- 持卡人证件类型.从系统类型表来
            ,id_card -- 持卡人证件号码.
            ,address -- 持卡人地址.
            ,tel -- 手机号码.
            ,examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
            ,examine_time -- 审核时间.
            ,examine_status_remark -- 审核备注.
            ,examine_emp -- 审核人.
            ,enabled -- 是否启用.
            ,data_sign -- 数据签名.
            ,data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移
            ,fld_s1 -- 结算账户的支出户名
            ,fld_s2 -- 字符型保留字段2.
            ,fld_s3 -- 字符型保留字段3.
            ,fld_n1 -- 是否收支分离
            ,fld_n2 -- 结算卡审核状态.0:未提交审核,1:提交未审核,2:提交审核未通过,3:提交审核已通过,4:新增未审核
            ,fld_n3 -- 数值型保留字段3.
            ,fld_d1 -- 日期型保留字段1.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,check_auth -- 是否鉴权
            ,e_account_code -- 电子账户
            ,account_en_name -- 开户人英文名
            ,account_expired_date -- 开户人证件有效期
            ,account_postcode -- 邮编
            ,check_auth3 -- 3要素实名状态
            ,check_auth4 -- 4要素实名状态
            ,e_account_enabled -- 是否开启电子账号
            ,sft_merchant_id -- 盛付通商户号
            ,fee_code -- 费项代码
            ,fee_code2 -- 费项代码2
            ,subject_account -- 科目账号
            ,unit_prop -- 单位性质
            ,new_account_code -- 新账号或主账号
            ,account_properties -- 轧差入账属性字段，按位使用
            ,new_remit_account_code -- 新汇出方卡号
            ,point_payment -- 开通积分支付
            ,points_offer -- 是否积分优惠
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_tra_bank_account_op(
            account_id -- 账户ID.
            ,org_id -- 机构ID.对应渠道编号或商户编号
            ,account_code -- 银行卡号.
            ,bank_id -- 开户银行.关联银行表( CMS_BANK )
            ,account_name -- 开户人.
            ,account_type -- 帐户类型.1:企业 ;2:个人;5:内部户
            ,contact_line -- 联行号.网点号、联行号
            ,remit_account_code -- 汇出方银行卡号.兴业叫汇出方银行卡号，浦发叫现代支付号
            ,is_inline -- 是否行内账号.true:是，false:不是
            ,bank_name -- 开户支行名称.
            ,province -- 开户支行所在省.
            ,city -- 开户支行所在市.
            ,id_card_type -- 持卡人证件类型.从系统类型表来
            ,id_card -- 持卡人证件号码.
            ,address -- 持卡人地址.
            ,tel -- 手机号码.
            ,examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
            ,examine_time -- 审核时间.
            ,examine_status_remark -- 审核备注.
            ,examine_emp -- 审核人.
            ,enabled -- 是否启用.
            ,data_sign -- 数据签名.
            ,data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移
            ,fld_s1 -- 结算账户的支出户名
            ,fld_s2 -- 字符型保留字段2.
            ,fld_s3 -- 字符型保留字段3.
            ,fld_n1 -- 是否收支分离
            ,fld_n2 -- 结算卡审核状态.0:未提交审核,1:提交未审核,2:提交审核未通过,3:提交审核已通过,4:新增未审核
            ,fld_n3 -- 数值型保留字段3.
            ,fld_d1 -- 日期型保留字段1.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,check_auth -- 是否鉴权
            ,e_account_code -- 电子账户
            ,account_en_name -- 开户人英文名
            ,account_expired_date -- 开户人证件有效期
            ,account_postcode -- 邮编
            ,check_auth3 -- 3要素实名状态
            ,check_auth4 -- 4要素实名状态
            ,e_account_enabled -- 是否开启电子账号
            ,sft_merchant_id -- 盛付通商户号
            ,fee_code -- 费项代码
            ,fee_code2 -- 费项代码2
            ,subject_account -- 科目账号
            ,unit_prop -- 单位性质
            ,new_account_code -- 新账号或主账号
            ,account_properties -- 轧差入账属性字段，按位使用
            ,new_remit_account_code -- 新汇出方卡号
            ,point_payment -- 开通积分支付
            ,points_offer -- 是否积分优惠
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.account_id, o.account_id) as account_id -- 账户ID.
    ,nvl(n.org_id, o.org_id) as org_id -- 机构ID.对应渠道编号或商户编号
    ,nvl(n.account_code, o.account_code) as account_code -- 银行卡号.
    ,nvl(n.bank_id, o.bank_id) as bank_id -- 开户银行.关联银行表( CMS_BANK )
    ,nvl(n.account_name, o.account_name) as account_name -- 开户人.
    ,nvl(n.account_type, o.account_type) as account_type -- 帐户类型.1:企业 ;2:个人;5:内部户
    ,nvl(n.contact_line, o.contact_line) as contact_line -- 联行号.网点号、联行号
    ,nvl(n.remit_account_code, o.remit_account_code) as remit_account_code -- 汇出方银行卡号.兴业叫汇出方银行卡号，浦发叫现代支付号
    ,nvl(n.is_inline, o.is_inline) as is_inline -- 是否行内账号.true:是，false:不是
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 开户支行名称.
    ,nvl(n.province, o.province) as province -- 开户支行所在省.
    ,nvl(n.city, o.city) as city -- 开户支行所在市.
    ,nvl(n.id_card_type, o.id_card_type) as id_card_type -- 持卡人证件类型.从系统类型表来
    ,nvl(n.id_card, o.id_card) as id_card -- 持卡人证件号码.
    ,nvl(n.address, o.address) as address -- 持卡人地址.
    ,nvl(n.tel, o.tel) as tel -- 手机号码.
    ,nvl(n.examine_status, o.examine_status) as examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
    ,nvl(n.examine_time, o.examine_time) as examine_time -- 审核时间.
    ,nvl(n.examine_status_remark, o.examine_status_remark) as examine_status_remark -- 审核备注.
    ,nvl(n.examine_emp, o.examine_emp) as examine_emp -- 审核人.
    ,nvl(n.enabled, o.enabled) as enabled -- 是否启用.
    ,nvl(n.data_sign, o.data_sign) as data_sign -- 数据签名.
    ,nvl(n.data_source, o.data_source) as data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移
    ,nvl(n.fld_s1, o.fld_s1) as fld_s1 -- 结算账户的支出户名
    ,nvl(n.fld_s2, o.fld_s2) as fld_s2 -- 字符型保留字段2.
    ,nvl(n.fld_s3, o.fld_s3) as fld_s3 -- 字符型保留字段3.
    ,nvl(n.fld_n1, o.fld_n1) as fld_n1 -- 是否收支分离
    ,nvl(n.fld_n2, o.fld_n2) as fld_n2 -- 结算卡审核状态.0:未提交审核,1:提交未审核,2:提交审核未通过,3:提交审核已通过,4:新增未审核
    ,nvl(n.fld_n3, o.fld_n3) as fld_n3 -- 数值型保留字段3.
    ,nvl(n.fld_d1, o.fld_d1) as fld_d1 -- 日期型保留字段1.
    ,nvl(n.create_user, o.create_user) as create_user -- 创建用户.
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建人.
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间.
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间.
    ,nvl(n.check_auth, o.check_auth) as check_auth -- 是否鉴权
    ,nvl(n.e_account_code, o.e_account_code) as e_account_code -- 电子账户
    ,nvl(n.account_en_name, o.account_en_name) as account_en_name -- 开户人英文名
    ,nvl(n.account_expired_date, o.account_expired_date) as account_expired_date -- 开户人证件有效期
    ,nvl(n.account_postcode, o.account_postcode) as account_postcode -- 邮编
    ,nvl(n.check_auth3, o.check_auth3) as check_auth3 -- 3要素实名状态
    ,nvl(n.check_auth4, o.check_auth4) as check_auth4 -- 4要素实名状态
    ,nvl(n.e_account_enabled, o.e_account_enabled) as e_account_enabled -- 是否开启电子账号
    ,nvl(n.sft_merchant_id, o.sft_merchant_id) as sft_merchant_id -- 盛付通商户号
    ,nvl(n.fee_code, o.fee_code) as fee_code -- 费项代码
    ,nvl(n.fee_code2, o.fee_code2) as fee_code2 -- 费项代码2
    ,nvl(n.subject_account, o.subject_account) as subject_account -- 科目账号
    ,nvl(n.unit_prop, o.unit_prop) as unit_prop -- 单位性质
    ,nvl(n.new_account_code, o.new_account_code) as new_account_code -- 新账号或主账号
    ,nvl(n.account_properties, o.account_properties) as account_properties -- 轧差入账属性字段，按位使用
    ,nvl(n.new_remit_account_code, o.new_remit_account_code) as new_remit_account_code -- 新汇出方卡号
    ,nvl(n.point_payment, o.point_payment) as point_payment -- 开通积分支付
    ,nvl(n.points_offer, o.points_offer) as points_offer -- 是否积分优惠
    ,case when
            n.account_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.account_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.account_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_tra_bank_account_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_tra_bank_account where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.account_id = n.account_id
where (
        o.account_id is null
    )
    or (
        n.account_id is null
    )
    or (
        o.org_id <> n.org_id
        or o.account_code <> n.account_code
        or o.bank_id <> n.bank_id
        or o.account_name <> n.account_name
        or o.account_type <> n.account_type
        or o.contact_line <> n.contact_line
        or o.remit_account_code <> n.remit_account_code
        or o.is_inline <> n.is_inline
        or o.bank_name <> n.bank_name
        or o.province <> n.province
        or o.city <> n.city
        or o.id_card_type <> n.id_card_type
        or o.id_card <> n.id_card
        or o.address <> n.address
        or o.tel <> n.tel
        or o.examine_status <> n.examine_status
        or o.examine_time <> n.examine_time
        or o.examine_status_remark <> n.examine_status_remark
        or o.examine_emp <> n.examine_emp
        or o.enabled <> n.enabled
        or o.data_sign <> n.data_sign
        or o.data_source <> n.data_source
        or o.fld_s1 <> n.fld_s1
        or o.fld_s2 <> n.fld_s2
        or o.fld_s3 <> n.fld_s3
        or o.fld_n1 <> n.fld_n1
        or o.fld_n2 <> n.fld_n2
        or o.fld_n3 <> n.fld_n3
        or o.fld_d1 <> n.fld_d1
        or o.create_user <> n.create_user
        or o.create_emp <> n.create_emp
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.check_auth <> n.check_auth
        or o.e_account_code <> n.e_account_code
        or o.account_en_name <> n.account_en_name
        or o.account_expired_date <> n.account_expired_date
        or o.account_postcode <> n.account_postcode
        or o.check_auth3 <> n.check_auth3
        or o.check_auth4 <> n.check_auth4
        or o.e_account_enabled <> n.e_account_enabled
        or o.sft_merchant_id <> n.sft_merchant_id
        or o.fee_code <> n.fee_code
        or o.fee_code2 <> n.fee_code2
        or o.subject_account <> n.subject_account
        or o.unit_prop <> n.unit_prop
        or o.new_account_code <> n.new_account_code
        or o.account_properties <> n.account_properties
        or o.new_remit_account_code <> n.new_remit_account_code
        or o.point_payment <> n.point_payment
        or o.points_offer <> n.points_offer
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_tra_bank_account_cl(
            account_id -- 账户ID.
            ,org_id -- 机构ID.对应渠道编号或商户编号
            ,account_code -- 银行卡号.
            ,bank_id -- 开户银行.关联银行表( CMS_BANK )
            ,account_name -- 开户人.
            ,account_type -- 帐户类型.1:企业 ;2:个人;5:内部户
            ,contact_line -- 联行号.网点号、联行号
            ,remit_account_code -- 汇出方银行卡号.兴业叫汇出方银行卡号，浦发叫现代支付号
            ,is_inline -- 是否行内账号.true:是，false:不是
            ,bank_name -- 开户支行名称.
            ,province -- 开户支行所在省.
            ,city -- 开户支行所在市.
            ,id_card_type -- 持卡人证件类型.从系统类型表来
            ,id_card -- 持卡人证件号码.
            ,address -- 持卡人地址.
            ,tel -- 手机号码.
            ,examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
            ,examine_time -- 审核时间.
            ,examine_status_remark -- 审核备注.
            ,examine_emp -- 审核人.
            ,enabled -- 是否启用.
            ,data_sign -- 数据签名.
            ,data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移
            ,fld_s1 -- 结算账户的支出户名
            ,fld_s2 -- 字符型保留字段2.
            ,fld_s3 -- 字符型保留字段3.
            ,fld_n1 -- 是否收支分离
            ,fld_n2 -- 结算卡审核状态.0:未提交审核,1:提交未审核,2:提交审核未通过,3:提交审核已通过,4:新增未审核
            ,fld_n3 -- 数值型保留字段3.
            ,fld_d1 -- 日期型保留字段1.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,check_auth -- 是否鉴权
            ,e_account_code -- 电子账户
            ,account_en_name -- 开户人英文名
            ,account_expired_date -- 开户人证件有效期
            ,account_postcode -- 邮编
            ,check_auth3 -- 3要素实名状态
            ,check_auth4 -- 4要素实名状态
            ,e_account_enabled -- 是否开启电子账号
            ,sft_merchant_id -- 盛付通商户号
            ,fee_code -- 费项代码
            ,fee_code2 -- 费项代码2
            ,subject_account -- 科目账号
            ,unit_prop -- 单位性质
            ,new_account_code -- 新账号或主账号
            ,account_properties -- 轧差入账属性字段，按位使用
            ,new_remit_account_code -- 新汇出方卡号
            ,point_payment -- 开通积分支付
            ,points_offer -- 是否积分优惠
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_tra_bank_account_op(
            account_id -- 账户ID.
            ,org_id -- 机构ID.对应渠道编号或商户编号
            ,account_code -- 银行卡号.
            ,bank_id -- 开户银行.关联银行表( CMS_BANK )
            ,account_name -- 开户人.
            ,account_type -- 帐户类型.1:企业 ;2:个人;5:内部户
            ,contact_line -- 联行号.网点号、联行号
            ,remit_account_code -- 汇出方银行卡号.兴业叫汇出方银行卡号，浦发叫现代支付号
            ,is_inline -- 是否行内账号.true:是，false:不是
            ,bank_name -- 开户支行名称.
            ,province -- 开户支行所在省.
            ,city -- 开户支行所在市.
            ,id_card_type -- 持卡人证件类型.从系统类型表来
            ,id_card -- 持卡人证件号码.
            ,address -- 持卡人地址.
            ,tel -- 手机号码.
            ,examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
            ,examine_time -- 审核时间.
            ,examine_status_remark -- 审核备注.
            ,examine_emp -- 审核人.
            ,enabled -- 是否启用.
            ,data_sign -- 数据签名.
            ,data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移
            ,fld_s1 -- 结算账户的支出户名
            ,fld_s2 -- 字符型保留字段2.
            ,fld_s3 -- 字符型保留字段3.
            ,fld_n1 -- 是否收支分离
            ,fld_n2 -- 结算卡审核状态.0:未提交审核,1:提交未审核,2:提交审核未通过,3:提交审核已通过,4:新增未审核
            ,fld_n3 -- 数值型保留字段3.
            ,fld_d1 -- 日期型保留字段1.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,check_auth -- 是否鉴权
            ,e_account_code -- 电子账户
            ,account_en_name -- 开户人英文名
            ,account_expired_date -- 开户人证件有效期
            ,account_postcode -- 邮编
            ,check_auth3 -- 3要素实名状态
            ,check_auth4 -- 4要素实名状态
            ,e_account_enabled -- 是否开启电子账号
            ,sft_merchant_id -- 盛付通商户号
            ,fee_code -- 费项代码
            ,fee_code2 -- 费项代码2
            ,subject_account -- 科目账号
            ,unit_prop -- 单位性质
            ,new_account_code -- 新账号或主账号
            ,account_properties -- 轧差入账属性字段，按位使用
            ,new_remit_account_code -- 新汇出方卡号
            ,point_payment -- 开通积分支付
            ,points_offer -- 是否积分优惠
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.account_id -- 账户ID.
    ,o.org_id -- 机构ID.对应渠道编号或商户编号
    ,o.account_code -- 银行卡号.
    ,o.bank_id -- 开户银行.关联银行表( CMS_BANK )
    ,o.account_name -- 开户人.
    ,o.account_type -- 帐户类型.1:企业 ;2:个人;5:内部户
    ,o.contact_line -- 联行号.网点号、联行号
    ,o.remit_account_code -- 汇出方银行卡号.兴业叫汇出方银行卡号，浦发叫现代支付号
    ,o.is_inline -- 是否行内账号.true:是，false:不是
    ,o.bank_name -- 开户支行名称.
    ,o.province -- 开户支行所在省.
    ,o.city -- 开户支行所在市.
    ,o.id_card_type -- 持卡人证件类型.从系统类型表来
    ,o.id_card -- 持卡人证件号码.
    ,o.address -- 持卡人地址.
    ,o.tel -- 手机号码.
    ,o.examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
    ,o.examine_time -- 审核时间.
    ,o.examine_status_remark -- 审核备注.
    ,o.examine_emp -- 审核人.
    ,o.enabled -- 是否启用.
    ,o.data_sign -- 数据签名.
    ,o.data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移
    ,o.fld_s1 -- 结算账户的支出户名
    ,o.fld_s2 -- 字符型保留字段2.
    ,o.fld_s3 -- 字符型保留字段3.
    ,o.fld_n1 -- 是否收支分离
    ,o.fld_n2 -- 结算卡审核状态.0:未提交审核,1:提交未审核,2:提交审核未通过,3:提交审核已通过,4:新增未审核
    ,o.fld_n3 -- 数值型保留字段3.
    ,o.fld_d1 -- 日期型保留字段1.
    ,o.create_user -- 创建用户.
    ,o.create_emp -- 创建人.
    ,o.create_time -- 创建时间.
    ,o.update_time -- 更新时间.
    ,o.check_auth -- 是否鉴权
    ,o.e_account_code -- 电子账户
    ,o.account_en_name -- 开户人英文名
    ,o.account_expired_date -- 开户人证件有效期
    ,o.account_postcode -- 邮编
    ,o.check_auth3 -- 3要素实名状态
    ,o.check_auth4 -- 4要素实名状态
    ,o.e_account_enabled -- 是否开启电子账号
    ,o.sft_merchant_id -- 盛付通商户号
    ,o.fee_code -- 费项代码
    ,o.fee_code2 -- 费项代码2
    ,o.subject_account -- 科目账号
    ,o.unit_prop -- 单位性质
    ,o.new_account_code -- 新账号或主账号
    ,o.account_properties -- 轧差入账属性字段，按位使用
    ,o.new_remit_account_code -- 新汇出方卡号
    ,o.point_payment -- 开通积分支付
    ,o.points_offer -- 是否积分优惠
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.amss_tra_bank_account_bk o
    left join ${iol_schema}.amss_tra_bank_account_op n
        on
            o.account_id = n.account_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_tra_bank_account_cl d
        on
            o.account_id = d.account_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_tra_bank_account;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_tra_bank_account') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_tra_bank_account drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_tra_bank_account add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_tra_bank_account exchange partition p_${batch_date} with table ${iol_schema}.amss_tra_bank_account_cl;
alter table ${iol_schema}.amss_tra_bank_account exchange partition p_20991231 with table ${iol_schema}.amss_tra_bank_account_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_tra_bank_account to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_tra_bank_account_op purge;
drop table ${iol_schema}.amss_tra_bank_account_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_tra_bank_account_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_tra_bank_account',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
