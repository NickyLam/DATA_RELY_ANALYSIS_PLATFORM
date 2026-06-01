/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_cms_channel
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
create table ${iol_schema}.amss_cms_channel_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_cms_channel
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_channel_op purge;
drop table ${iol_schema}.amss_cms_channel_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_channel_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_channel where 0=1;

create table ${iol_schema}.amss_cms_channel_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_channel where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_channel_cl(
            channel_id -- 渠道ID.即渠道编号
            ,invite_code -- 渠道邀请码.银行受理机构为该银行在我们系统中的银行英文编码;如兴业总行为CIB.兴业深圳支行为CIB_SZ;渠道为我们分配给该渠道的邀请码.生成规则(银行英文编码+I+6位序列)
            ,channel_name -- 渠道名称.
            ,channel_type -- 渠道类型.受理机构-1;渠道-2
            ,parent_channel -- 所属渠道.关联渠道ID，只有受理机构允许为空
            ,pay_accpet_org -- 支付受理机构.关联渠道表 的 渠道ID (CHANNEL_ID)
            ,channel_properties -- 渠道属性.银行机构-1;外部渠道-2
            ,province -- 省份.
            ,city -- 城市.
            ,county -- 区/县.
            ,address -- 地址.
            ,tel -- 电话.
            ,web_site -- 网址.
            ,principal -- 负责人.
            ,id_code -- 负责人身份证.
            ,license_photo -- 营业执照.
            ,indentity_photo -- 身份证照片.
            ,other_doc -- 其他资料.资料包，以zip和rar格式上传和下载
            ,email -- 邮箱.
            ,examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
            ,examine_time -- 审核时间.
            ,examine_status_remark -- 审核备注.
            ,examine_emp -- 审核人.
            ,activate_status -- 激活状态.0:未激活;1:激活成功;2:激活失败;3:需再次激活
            ,activate_time -- 激活时间.
            ,activate_status_remark -- 激活备注.
            ,activate_emp -- 激活人.
            ,sign_key -- 签名key.接口调用时的签名key
            ,extra_propertes -- 附加属性.1:用于标记大商户的渠道属性
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移；12:简易注册
            ,remark -- 备注.
            ,acc_way -- 结算方式.1：标准；2：提现
            ,fld_s1 -- 老平台公有云的渠道ID.老平台公有云的渠道ID
            ,fld_s2 -- 第三方商户ID.SPAY小商户进件
            ,fld_s3 -- 第三方APPID.SPAY小商户进件
            ,fld_n1 -- 具体受理机构类型.1：威富通；2：银行受理机构；3：通道受理机构
            ,fld_n2 -- 是否允许快速进件.1-是  0-否 (SPAY小商户进件)
            ,fld_n3 -- (authTradeType)授权子商户交易的类型
            ,fld_d1 -- 日期型保留字段1.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,thr_channel_id -- 外部渠道号.
            ,advance_side_id -- 垫资方
            ,channel_org_type -- 渠道机构类型.总行-1;分行-2;支行-3
            ,fld_n4 -- (inlineBankId)受理机构的行内银行ID
            ,fld_n5 -- 小商户进件时是否需要审核激活商户,0:需要审核激活(对应商户审核状态：未审核，商户激活状态：未激活),1:不需要审核激活(对应商户审核状态：审核通过，商户激活状态：激活成功)
            ,fld_n6 -- (timeZone)时区
            ,fld_n7 -- (mergeAccount)合并入账
            ,fld_n8 -- (wftOwnCh)是否威富通自有机构.0/null:否,1:是
            ,fld_s4 -- (notifyKey)通知秘钥
            ,fld_s5 -- (notifyUrl)通知地址
            ,fld_s6 -- (agentCode)翼支付机构号
            ,fld_s7 -- (expenseAccountName)成都农商行支出账号户名
            ,fld_s8 -- (expenseAccountCode)成都农商行支出账号卡号
            ,advance_quota -- 垫资额度字段
            ,pid_process_state -- pid改变处理状态 0待处理 1处理完成
            ,logo -- 二受理机构logo图片路径
            ,branch_flag -- 分行标识，0-非分行，1-分行
            ,fld_n9 -- (thiOrgType)数据库机构标识
            ,fld_n10 -- (channelPropertiesExt)渠道扩展属性
            ,fld_n11 -- (channelOwnerShip)渠道归属：1.零售总行,2.企金总行
            ,fld_n12 -- 外包服务机构进件成本费率为0，打上特殊标识1
            ,pay_page_auth_status -- 支付页面授权状态
            ,fld_s9 -- (orgIdPrefix)受理机构分配的机构号id前三位号段
            ,fld_s10 -- 
            ,fld_s11 -- 
            ,fld_s12 -- 
            ,expand_num -- 拓展人工号
            ,inner_org -- 内部机构号
            ,service_provider_id -- 云闪付服务商id
            ,service_public_key -- 云闪付公钥
            ,service_private_key -- 云闪付私钥
            ,passageway_cost_id -- 通道成本渠道id
            ,other_cost_id -- 其他成本渠道id
            ,id_code_begin_time -- 负责人证件有效期开始日
            ,business_license_begin_time -- 营业执照有效期开始日
            ,contacts_idcode -- 负责人证件号码
            ,business_license_expire -- 营业执照过期日
            ,business_license -- 营业执照号
            ,id_code_expire -- 负责人证件过期日
            ,id_code_type -- 负责人证件类型
            ,cle_org_id -- 所属清算机构号
            ,account_code_photo -- 开户许可证
            ,thi_doc_id -- 第三方文档id
            ,limit_credit_pay -- 信用卡限制：0-限制，1-不限制
            ,bank_channel_id -- 银行机构号.
            ,wechat_channel_id -- 微信机构号.
            ,profits_rate -- 分润值.
            ,portal_channel_id -- 门户机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_channel_op(
            channel_id -- 渠道ID.即渠道编号
            ,invite_code -- 渠道邀请码.银行受理机构为该银行在我们系统中的银行英文编码;如兴业总行为CIB.兴业深圳支行为CIB_SZ;渠道为我们分配给该渠道的邀请码.生成规则(银行英文编码+I+6位序列)
            ,channel_name -- 渠道名称.
            ,channel_type -- 渠道类型.受理机构-1;渠道-2
            ,parent_channel -- 所属渠道.关联渠道ID，只有受理机构允许为空
            ,pay_accpet_org -- 支付受理机构.关联渠道表 的 渠道ID (CHANNEL_ID)
            ,channel_properties -- 渠道属性.银行机构-1;外部渠道-2
            ,province -- 省份.
            ,city -- 城市.
            ,county -- 区/县.
            ,address -- 地址.
            ,tel -- 电话.
            ,web_site -- 网址.
            ,principal -- 负责人.
            ,id_code -- 负责人身份证.
            ,license_photo -- 营业执照.
            ,indentity_photo -- 身份证照片.
            ,other_doc -- 其他资料.资料包，以zip和rar格式上传和下载
            ,email -- 邮箱.
            ,examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
            ,examine_time -- 审核时间.
            ,examine_status_remark -- 审核备注.
            ,examine_emp -- 审核人.
            ,activate_status -- 激活状态.0:未激活;1:激活成功;2:激活失败;3:需再次激活
            ,activate_time -- 激活时间.
            ,activate_status_remark -- 激活备注.
            ,activate_emp -- 激活人.
            ,sign_key -- 签名key.接口调用时的签名key
            ,extra_propertes -- 附加属性.1:用于标记大商户的渠道属性
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移；12:简易注册
            ,remark -- 备注.
            ,acc_way -- 结算方式.1：标准；2：提现
            ,fld_s1 -- 老平台公有云的渠道ID.老平台公有云的渠道ID
            ,fld_s2 -- 第三方商户ID.SPAY小商户进件
            ,fld_s3 -- 第三方APPID.SPAY小商户进件
            ,fld_n1 -- 具体受理机构类型.1：威富通；2：银行受理机构；3：通道受理机构
            ,fld_n2 -- 是否允许快速进件.1-是  0-否 (SPAY小商户进件)
            ,fld_n3 -- (authTradeType)授权子商户交易的类型
            ,fld_d1 -- 日期型保留字段1.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,thr_channel_id -- 外部渠道号.
            ,advance_side_id -- 垫资方
            ,channel_org_type -- 渠道机构类型.总行-1;分行-2;支行-3
            ,fld_n4 -- (inlineBankId)受理机构的行内银行ID
            ,fld_n5 -- 小商户进件时是否需要审核激活商户,0:需要审核激活(对应商户审核状态：未审核，商户激活状态：未激活),1:不需要审核激活(对应商户审核状态：审核通过，商户激活状态：激活成功)
            ,fld_n6 -- (timeZone)时区
            ,fld_n7 -- (mergeAccount)合并入账
            ,fld_n8 -- (wftOwnCh)是否威富通自有机构.0/null:否,1:是
            ,fld_s4 -- (notifyKey)通知秘钥
            ,fld_s5 -- (notifyUrl)通知地址
            ,fld_s6 -- (agentCode)翼支付机构号
            ,fld_s7 -- (expenseAccountName)成都农商行支出账号户名
            ,fld_s8 -- (expenseAccountCode)成都农商行支出账号卡号
            ,advance_quota -- 垫资额度字段
            ,pid_process_state -- pid改变处理状态 0待处理 1处理完成
            ,logo -- 二受理机构logo图片路径
            ,branch_flag -- 分行标识，0-非分行，1-分行
            ,fld_n9 -- (thiOrgType)数据库机构标识
            ,fld_n10 -- (channelPropertiesExt)渠道扩展属性
            ,fld_n11 -- (channelOwnerShip)渠道归属：1.零售总行,2.企金总行
            ,fld_n12 -- 外包服务机构进件成本费率为0，打上特殊标识1
            ,pay_page_auth_status -- 支付页面授权状态
            ,fld_s9 -- (orgIdPrefix)受理机构分配的机构号id前三位号段
            ,fld_s10 -- 
            ,fld_s11 -- 
            ,fld_s12 -- 
            ,expand_num -- 拓展人工号
            ,inner_org -- 内部机构号
            ,service_provider_id -- 云闪付服务商id
            ,service_public_key -- 云闪付公钥
            ,service_private_key -- 云闪付私钥
            ,passageway_cost_id -- 通道成本渠道id
            ,other_cost_id -- 其他成本渠道id
            ,id_code_begin_time -- 负责人证件有效期开始日
            ,business_license_begin_time -- 营业执照有效期开始日
            ,contacts_idcode -- 负责人证件号码
            ,business_license_expire -- 营业执照过期日
            ,business_license -- 营业执照号
            ,id_code_expire -- 负责人证件过期日
            ,id_code_type -- 负责人证件类型
            ,cle_org_id -- 所属清算机构号
            ,account_code_photo -- 开户许可证
            ,thi_doc_id -- 第三方文档id
            ,limit_credit_pay -- 信用卡限制：0-限制，1-不限制
            ,bank_channel_id -- 银行机构号.
            ,wechat_channel_id -- 微信机构号.
            ,profits_rate -- 分润值.
            ,portal_channel_id -- 门户机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.channel_id, o.channel_id) as channel_id -- 渠道ID.即渠道编号
    ,nvl(n.invite_code, o.invite_code) as invite_code -- 渠道邀请码.银行受理机构为该银行在我们系统中的银行英文编码;如兴业总行为CIB.兴业深圳支行为CIB_SZ;渠道为我们分配给该渠道的邀请码.生成规则(银行英文编码+I+6位序列)
    ,nvl(n.channel_name, o.channel_name) as channel_name -- 渠道名称.
    ,nvl(n.channel_type, o.channel_type) as channel_type -- 渠道类型.受理机构-1;渠道-2
    ,nvl(n.parent_channel, o.parent_channel) as parent_channel -- 所属渠道.关联渠道ID，只有受理机构允许为空
    ,nvl(n.pay_accpet_org, o.pay_accpet_org) as pay_accpet_org -- 支付受理机构.关联渠道表 的 渠道ID (CHANNEL_ID)
    ,nvl(n.channel_properties, o.channel_properties) as channel_properties -- 渠道属性.银行机构-1;外部渠道-2
    ,nvl(n.province, o.province) as province -- 省份.
    ,nvl(n.city, o.city) as city -- 城市.
    ,nvl(n.county, o.county) as county -- 区/县.
    ,nvl(n.address, o.address) as address -- 地址.
    ,nvl(n.tel, o.tel) as tel -- 电话.
    ,nvl(n.web_site, o.web_site) as web_site -- 网址.
    ,nvl(n.principal, o.principal) as principal -- 负责人.
    ,nvl(n.id_code, o.id_code) as id_code -- 负责人身份证.
    ,nvl(n.license_photo, o.license_photo) as license_photo -- 营业执照.
    ,nvl(n.indentity_photo, o.indentity_photo) as indentity_photo -- 身份证照片.
    ,nvl(n.other_doc, o.other_doc) as other_doc -- 其他资料.资料包，以zip和rar格式上传和下载
    ,nvl(n.email, o.email) as email -- 邮箱.
    ,nvl(n.examine_status, o.examine_status) as examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
    ,nvl(n.examine_time, o.examine_time) as examine_time -- 审核时间.
    ,nvl(n.examine_status_remark, o.examine_status_remark) as examine_status_remark -- 审核备注.
    ,nvl(n.examine_emp, o.examine_emp) as examine_emp -- 审核人.
    ,nvl(n.activate_status, o.activate_status) as activate_status -- 激活状态.0:未激活;1:激活成功;2:激活失败;3:需再次激活
    ,nvl(n.activate_time, o.activate_time) as activate_time -- 激活时间.
    ,nvl(n.activate_status_remark, o.activate_status_remark) as activate_status_remark -- 激活备注.
    ,nvl(n.activate_emp, o.activate_emp) as activate_emp -- 激活人.
    ,nvl(n.sign_key, o.sign_key) as sign_key -- 签名key.接口调用时的签名key
    ,nvl(n.extra_propertes, o.extra_propertes) as extra_propertes -- 附加属性.1:用于标记大商户的渠道属性
    ,nvl(n.physics_flag, o.physics_flag) as physics_flag -- 物理标识.1:正常;2:删除
    ,nvl(n.data_source, o.data_source) as data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移；12:简易注册
    ,nvl(n.remark, o.remark) as remark -- 备注.
    ,nvl(n.acc_way, o.acc_way) as acc_way -- 结算方式.1：标准；2：提现
    ,nvl(n.fld_s1, o.fld_s1) as fld_s1 -- 老平台公有云的渠道ID.老平台公有云的渠道ID
    ,nvl(n.fld_s2, o.fld_s2) as fld_s2 -- 第三方商户ID.SPAY小商户进件
    ,nvl(n.fld_s3, o.fld_s3) as fld_s3 -- 第三方APPID.SPAY小商户进件
    ,nvl(n.fld_n1, o.fld_n1) as fld_n1 -- 具体受理机构类型.1：威富通；2：银行受理机构；3：通道受理机构
    ,nvl(n.fld_n2, o.fld_n2) as fld_n2 -- 是否允许快速进件.1-是  0-否 (SPAY小商户进件)
    ,nvl(n.fld_n3, o.fld_n3) as fld_n3 -- (authTradeType)授权子商户交易的类型
    ,nvl(n.fld_d1, o.fld_d1) as fld_d1 -- 日期型保留字段1.
    ,nvl(n.create_user, o.create_user) as create_user -- 创建用户.
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建人.
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间.
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间.
    ,nvl(n.thr_channel_id, o.thr_channel_id) as thr_channel_id -- 外部渠道号.
    ,nvl(n.advance_side_id, o.advance_side_id) as advance_side_id -- 垫资方
    ,nvl(n.channel_org_type, o.channel_org_type) as channel_org_type -- 渠道机构类型.总行-1;分行-2;支行-3
    ,nvl(n.fld_n4, o.fld_n4) as fld_n4 -- (inlineBankId)受理机构的行内银行ID
    ,nvl(n.fld_n5, o.fld_n5) as fld_n5 -- 小商户进件时是否需要审核激活商户,0:需要审核激活(对应商户审核状态：未审核，商户激活状态：未激活),1:不需要审核激活(对应商户审核状态：审核通过，商户激活状态：激活成功)
    ,nvl(n.fld_n6, o.fld_n6) as fld_n6 -- (timeZone)时区
    ,nvl(n.fld_n7, o.fld_n7) as fld_n7 -- (mergeAccount)合并入账
    ,nvl(n.fld_n8, o.fld_n8) as fld_n8 -- (wftOwnCh)是否威富通自有机构.0/null:否,1:是
    ,nvl(n.fld_s4, o.fld_s4) as fld_s4 -- (notifyKey)通知秘钥
    ,nvl(n.fld_s5, o.fld_s5) as fld_s5 -- (notifyUrl)通知地址
    ,nvl(n.fld_s6, o.fld_s6) as fld_s6 -- (agentCode)翼支付机构号
    ,nvl(n.fld_s7, o.fld_s7) as fld_s7 -- (expenseAccountName)成都农商行支出账号户名
    ,nvl(n.fld_s8, o.fld_s8) as fld_s8 -- (expenseAccountCode)成都农商行支出账号卡号
    ,nvl(n.advance_quota, o.advance_quota) as advance_quota -- 垫资额度字段
    ,nvl(n.pid_process_state, o.pid_process_state) as pid_process_state -- pid改变处理状态 0待处理 1处理完成
    ,nvl(n.logo, o.logo) as logo -- 二受理机构logo图片路径
    ,nvl(n.branch_flag, o.branch_flag) as branch_flag -- 分行标识，0-非分行，1-分行
    ,nvl(n.fld_n9, o.fld_n9) as fld_n9 -- (thiOrgType)数据库机构标识
    ,nvl(n.fld_n10, o.fld_n10) as fld_n10 -- (channelPropertiesExt)渠道扩展属性
    ,nvl(n.fld_n11, o.fld_n11) as fld_n11 -- (channelOwnerShip)渠道归属：1.零售总行,2.企金总行
    ,nvl(n.fld_n12, o.fld_n12) as fld_n12 -- 外包服务机构进件成本费率为0，打上特殊标识1
    ,nvl(n.pay_page_auth_status, o.pay_page_auth_status) as pay_page_auth_status -- 支付页面授权状态
    ,nvl(n.fld_s9, o.fld_s9) as fld_s9 -- (orgIdPrefix)受理机构分配的机构号id前三位号段
    ,nvl(n.fld_s10, o.fld_s10) as fld_s10 -- 
    ,nvl(n.fld_s11, o.fld_s11) as fld_s11 -- 
    ,nvl(n.fld_s12, o.fld_s12) as fld_s12 -- 
    ,nvl(n.expand_num, o.expand_num) as expand_num -- 拓展人工号
    ,nvl(n.inner_org, o.inner_org) as inner_org -- 内部机构号
    ,nvl(n.service_provider_id, o.service_provider_id) as service_provider_id -- 云闪付服务商id
    ,nvl(n.service_public_key, o.service_public_key) as service_public_key -- 云闪付公钥
    ,nvl(n.service_private_key, o.service_private_key) as service_private_key -- 云闪付私钥
    ,nvl(n.passageway_cost_id, o.passageway_cost_id) as passageway_cost_id -- 通道成本渠道id
    ,nvl(n.other_cost_id, o.other_cost_id) as other_cost_id -- 其他成本渠道id
    ,nvl(n.id_code_begin_time, o.id_code_begin_time) as id_code_begin_time -- 负责人证件有效期开始日
    ,nvl(n.business_license_begin_time, o.business_license_begin_time) as business_license_begin_time -- 营业执照有效期开始日
    ,nvl(n.contacts_idcode, o.contacts_idcode) as contacts_idcode -- 负责人证件号码
    ,nvl(n.business_license_expire, o.business_license_expire) as business_license_expire -- 营业执照过期日
    ,nvl(n.business_license, o.business_license) as business_license -- 营业执照号
    ,nvl(n.id_code_expire, o.id_code_expire) as id_code_expire -- 负责人证件过期日
    ,nvl(n.id_code_type, o.id_code_type) as id_code_type -- 负责人证件类型
    ,nvl(n.cle_org_id, o.cle_org_id) as cle_org_id -- 所属清算机构号
    ,nvl(n.account_code_photo, o.account_code_photo) as account_code_photo -- 开户许可证
    ,nvl(n.thi_doc_id, o.thi_doc_id) as thi_doc_id -- 第三方文档id
    ,nvl(n.limit_credit_pay, o.limit_credit_pay) as limit_credit_pay -- 信用卡限制：0-限制，1-不限制
    ,nvl(n.bank_channel_id, o.bank_channel_id) as bank_channel_id -- 银行机构号.
    ,nvl(n.wechat_channel_id, o.wechat_channel_id) as wechat_channel_id -- 微信机构号.
    ,nvl(n.profits_rate, o.profits_rate) as profits_rate -- 分润值.
    ,nvl(n.portal_channel_id, o.portal_channel_id) as portal_channel_id -- 门户机构号
    ,case when
            n.channel_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.channel_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.channel_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_cms_channel_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_cms_channel where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.channel_id = n.channel_id
where (
        o.channel_id is null
    )
    or (
        n.channel_id is null
    )
    or (
        o.invite_code <> n.invite_code
        or o.channel_name <> n.channel_name
        or o.channel_type <> n.channel_type
        or o.parent_channel <> n.parent_channel
        or o.pay_accpet_org <> n.pay_accpet_org
        or o.channel_properties <> n.channel_properties
        or o.province <> n.province
        or o.city <> n.city
        or o.county <> n.county
        or o.address <> n.address
        or o.tel <> n.tel
        or o.web_site <> n.web_site
        or o.principal <> n.principal
        or o.id_code <> n.id_code
        or o.license_photo <> n.license_photo
        or o.indentity_photo <> n.indentity_photo
        or o.other_doc <> n.other_doc
        or o.email <> n.email
        or o.examine_status <> n.examine_status
        or o.examine_time <> n.examine_time
        or o.examine_status_remark <> n.examine_status_remark
        or o.examine_emp <> n.examine_emp
        or o.activate_status <> n.activate_status
        or o.activate_time <> n.activate_time
        or o.activate_status_remark <> n.activate_status_remark
        or o.activate_emp <> n.activate_emp
        or o.sign_key <> n.sign_key
        or o.extra_propertes <> n.extra_propertes
        or o.physics_flag <> n.physics_flag
        or o.data_source <> n.data_source
        or o.remark <> n.remark
        or o.acc_way <> n.acc_way
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
        or o.thr_channel_id <> n.thr_channel_id
        or o.advance_side_id <> n.advance_side_id
        or o.channel_org_type <> n.channel_org_type
        or o.fld_n4 <> n.fld_n4
        or o.fld_n5 <> n.fld_n5
        or o.fld_n6 <> n.fld_n6
        or o.fld_n7 <> n.fld_n7
        or o.fld_n8 <> n.fld_n8
        or o.fld_s4 <> n.fld_s4
        or o.fld_s5 <> n.fld_s5
        or o.fld_s6 <> n.fld_s6
        or o.fld_s7 <> n.fld_s7
        or o.fld_s8 <> n.fld_s8
        or o.advance_quota <> n.advance_quota
        or o.pid_process_state <> n.pid_process_state
        or o.logo <> n.logo
        or o.branch_flag <> n.branch_flag
        or o.fld_n9 <> n.fld_n9
        or o.fld_n10 <> n.fld_n10
        or o.fld_n11 <> n.fld_n11
        or o.fld_n12 <> n.fld_n12
        or o.pay_page_auth_status <> n.pay_page_auth_status
        or o.fld_s9 <> n.fld_s9
        or o.fld_s10 <> n.fld_s10
        or o.fld_s11 <> n.fld_s11
        or o.fld_s12 <> n.fld_s12
        or o.expand_num <> n.expand_num
        or o.inner_org <> n.inner_org
        or o.service_provider_id <> n.service_provider_id
        or o.service_public_key <> n.service_public_key
        or o.service_private_key <> n.service_private_key
        or o.passageway_cost_id <> n.passageway_cost_id
        or o.other_cost_id <> n.other_cost_id
        or o.id_code_begin_time <> n.id_code_begin_time
        or o.business_license_begin_time <> n.business_license_begin_time
        or o.contacts_idcode <> n.contacts_idcode
        or o.business_license_expire <> n.business_license_expire
        or o.business_license <> n.business_license
        or o.id_code_expire <> n.id_code_expire
        or o.id_code_type <> n.id_code_type
        or o.cle_org_id <> n.cle_org_id
        or o.account_code_photo <> n.account_code_photo
        or o.thi_doc_id <> n.thi_doc_id
        or o.limit_credit_pay <> n.limit_credit_pay
        or o.bank_channel_id <> n.bank_channel_id
        or o.wechat_channel_id <> n.wechat_channel_id
        or o.profits_rate <> n.profits_rate
        or o.portal_channel_id <> n.portal_channel_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_channel_cl(
            channel_id -- 渠道ID.即渠道编号
            ,invite_code -- 渠道邀请码.银行受理机构为该银行在我们系统中的银行英文编码;如兴业总行为CIB.兴业深圳支行为CIB_SZ;渠道为我们分配给该渠道的邀请码.生成规则(银行英文编码+I+6位序列)
            ,channel_name -- 渠道名称.
            ,channel_type -- 渠道类型.受理机构-1;渠道-2
            ,parent_channel -- 所属渠道.关联渠道ID，只有受理机构允许为空
            ,pay_accpet_org -- 支付受理机构.关联渠道表 的 渠道ID (CHANNEL_ID)
            ,channel_properties -- 渠道属性.银行机构-1;外部渠道-2
            ,province -- 省份.
            ,city -- 城市.
            ,county -- 区/县.
            ,address -- 地址.
            ,tel -- 电话.
            ,web_site -- 网址.
            ,principal -- 负责人.
            ,id_code -- 负责人身份证.
            ,license_photo -- 营业执照.
            ,indentity_photo -- 身份证照片.
            ,other_doc -- 其他资料.资料包，以zip和rar格式上传和下载
            ,email -- 邮箱.
            ,examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
            ,examine_time -- 审核时间.
            ,examine_status_remark -- 审核备注.
            ,examine_emp -- 审核人.
            ,activate_status -- 激活状态.0:未激活;1:激活成功;2:激活失败;3:需再次激活
            ,activate_time -- 激活时间.
            ,activate_status_remark -- 激活备注.
            ,activate_emp -- 激活人.
            ,sign_key -- 签名key.接口调用时的签名key
            ,extra_propertes -- 附加属性.1:用于标记大商户的渠道属性
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移；12:简易注册
            ,remark -- 备注.
            ,acc_way -- 结算方式.1：标准；2：提现
            ,fld_s1 -- 老平台公有云的渠道ID.老平台公有云的渠道ID
            ,fld_s2 -- 第三方商户ID.SPAY小商户进件
            ,fld_s3 -- 第三方APPID.SPAY小商户进件
            ,fld_n1 -- 具体受理机构类型.1：威富通；2：银行受理机构；3：通道受理机构
            ,fld_n2 -- 是否允许快速进件.1-是  0-否 (SPAY小商户进件)
            ,fld_n3 -- (authTradeType)授权子商户交易的类型
            ,fld_d1 -- 日期型保留字段1.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,thr_channel_id -- 外部渠道号.
            ,advance_side_id -- 垫资方
            ,channel_org_type -- 渠道机构类型.总行-1;分行-2;支行-3
            ,fld_n4 -- (inlineBankId)受理机构的行内银行ID
            ,fld_n5 -- 小商户进件时是否需要审核激活商户,0:需要审核激活(对应商户审核状态：未审核，商户激活状态：未激活),1:不需要审核激活(对应商户审核状态：审核通过，商户激活状态：激活成功)
            ,fld_n6 -- (timeZone)时区
            ,fld_n7 -- (mergeAccount)合并入账
            ,fld_n8 -- (wftOwnCh)是否威富通自有机构.0/null:否,1:是
            ,fld_s4 -- (notifyKey)通知秘钥
            ,fld_s5 -- (notifyUrl)通知地址
            ,fld_s6 -- (agentCode)翼支付机构号
            ,fld_s7 -- (expenseAccountName)成都农商行支出账号户名
            ,fld_s8 -- (expenseAccountCode)成都农商行支出账号卡号
            ,advance_quota -- 垫资额度字段
            ,pid_process_state -- pid改变处理状态 0待处理 1处理完成
            ,logo -- 二受理机构logo图片路径
            ,branch_flag -- 分行标识，0-非分行，1-分行
            ,fld_n9 -- (thiOrgType)数据库机构标识
            ,fld_n10 -- (channelPropertiesExt)渠道扩展属性
            ,fld_n11 -- (channelOwnerShip)渠道归属：1.零售总行,2.企金总行
            ,fld_n12 -- 外包服务机构进件成本费率为0，打上特殊标识1
            ,pay_page_auth_status -- 支付页面授权状态
            ,fld_s9 -- (orgIdPrefix)受理机构分配的机构号id前三位号段
            ,fld_s10 -- 
            ,fld_s11 -- 
            ,fld_s12 -- 
            ,expand_num -- 拓展人工号
            ,inner_org -- 内部机构号
            ,service_provider_id -- 云闪付服务商id
            ,service_public_key -- 云闪付公钥
            ,service_private_key -- 云闪付私钥
            ,passageway_cost_id -- 通道成本渠道id
            ,other_cost_id -- 其他成本渠道id
            ,id_code_begin_time -- 负责人证件有效期开始日
            ,business_license_begin_time -- 营业执照有效期开始日
            ,contacts_idcode -- 负责人证件号码
            ,business_license_expire -- 营业执照过期日
            ,business_license -- 营业执照号
            ,id_code_expire -- 负责人证件过期日
            ,id_code_type -- 负责人证件类型
            ,cle_org_id -- 所属清算机构号
            ,account_code_photo -- 开户许可证
            ,thi_doc_id -- 第三方文档id
            ,limit_credit_pay -- 信用卡限制：0-限制，1-不限制
            ,bank_channel_id -- 银行机构号.
            ,wechat_channel_id -- 微信机构号.
            ,profits_rate -- 分润值.
            ,portal_channel_id -- 门户机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_channel_op(
            channel_id -- 渠道ID.即渠道编号
            ,invite_code -- 渠道邀请码.银行受理机构为该银行在我们系统中的银行英文编码;如兴业总行为CIB.兴业深圳支行为CIB_SZ;渠道为我们分配给该渠道的邀请码.生成规则(银行英文编码+I+6位序列)
            ,channel_name -- 渠道名称.
            ,channel_type -- 渠道类型.受理机构-1;渠道-2
            ,parent_channel -- 所属渠道.关联渠道ID，只有受理机构允许为空
            ,pay_accpet_org -- 支付受理机构.关联渠道表 的 渠道ID (CHANNEL_ID)
            ,channel_properties -- 渠道属性.银行机构-1;外部渠道-2
            ,province -- 省份.
            ,city -- 城市.
            ,county -- 区/县.
            ,address -- 地址.
            ,tel -- 电话.
            ,web_site -- 网址.
            ,principal -- 负责人.
            ,id_code -- 负责人身份证.
            ,license_photo -- 营业执照.
            ,indentity_photo -- 身份证照片.
            ,other_doc -- 其他资料.资料包，以zip和rar格式上传和下载
            ,email -- 邮箱.
            ,examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
            ,examine_time -- 审核时间.
            ,examine_status_remark -- 审核备注.
            ,examine_emp -- 审核人.
            ,activate_status -- 激活状态.0:未激活;1:激活成功;2:激活失败;3:需再次激活
            ,activate_time -- 激活时间.
            ,activate_status_remark -- 激活备注.
            ,activate_emp -- 激活人.
            ,sign_key -- 签名key.接口调用时的签名key
            ,extra_propertes -- 附加属性.1:用于标记大商户的渠道属性
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移；12:简易注册
            ,remark -- 备注.
            ,acc_way -- 结算方式.1：标准；2：提现
            ,fld_s1 -- 老平台公有云的渠道ID.老平台公有云的渠道ID
            ,fld_s2 -- 第三方商户ID.SPAY小商户进件
            ,fld_s3 -- 第三方APPID.SPAY小商户进件
            ,fld_n1 -- 具体受理机构类型.1：威富通；2：银行受理机构；3：通道受理机构
            ,fld_n2 -- 是否允许快速进件.1-是  0-否 (SPAY小商户进件)
            ,fld_n3 -- (authTradeType)授权子商户交易的类型
            ,fld_d1 -- 日期型保留字段1.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,thr_channel_id -- 外部渠道号.
            ,advance_side_id -- 垫资方
            ,channel_org_type -- 渠道机构类型.总行-1;分行-2;支行-3
            ,fld_n4 -- (inlineBankId)受理机构的行内银行ID
            ,fld_n5 -- 小商户进件时是否需要审核激活商户,0:需要审核激活(对应商户审核状态：未审核，商户激活状态：未激活),1:不需要审核激活(对应商户审核状态：审核通过，商户激活状态：激活成功)
            ,fld_n6 -- (timeZone)时区
            ,fld_n7 -- (mergeAccount)合并入账
            ,fld_n8 -- (wftOwnCh)是否威富通自有机构.0/null:否,1:是
            ,fld_s4 -- (notifyKey)通知秘钥
            ,fld_s5 -- (notifyUrl)通知地址
            ,fld_s6 -- (agentCode)翼支付机构号
            ,fld_s7 -- (expenseAccountName)成都农商行支出账号户名
            ,fld_s8 -- (expenseAccountCode)成都农商行支出账号卡号
            ,advance_quota -- 垫资额度字段
            ,pid_process_state -- pid改变处理状态 0待处理 1处理完成
            ,logo -- 二受理机构logo图片路径
            ,branch_flag -- 分行标识，0-非分行，1-分行
            ,fld_n9 -- (thiOrgType)数据库机构标识
            ,fld_n10 -- (channelPropertiesExt)渠道扩展属性
            ,fld_n11 -- (channelOwnerShip)渠道归属：1.零售总行,2.企金总行
            ,fld_n12 -- 外包服务机构进件成本费率为0，打上特殊标识1
            ,pay_page_auth_status -- 支付页面授权状态
            ,fld_s9 -- (orgIdPrefix)受理机构分配的机构号id前三位号段
            ,fld_s10 -- 
            ,fld_s11 -- 
            ,fld_s12 -- 
            ,expand_num -- 拓展人工号
            ,inner_org -- 内部机构号
            ,service_provider_id -- 云闪付服务商id
            ,service_public_key -- 云闪付公钥
            ,service_private_key -- 云闪付私钥
            ,passageway_cost_id -- 通道成本渠道id
            ,other_cost_id -- 其他成本渠道id
            ,id_code_begin_time -- 负责人证件有效期开始日
            ,business_license_begin_time -- 营业执照有效期开始日
            ,contacts_idcode -- 负责人证件号码
            ,business_license_expire -- 营业执照过期日
            ,business_license -- 营业执照号
            ,id_code_expire -- 负责人证件过期日
            ,id_code_type -- 负责人证件类型
            ,cle_org_id -- 所属清算机构号
            ,account_code_photo -- 开户许可证
            ,thi_doc_id -- 第三方文档id
            ,limit_credit_pay -- 信用卡限制：0-限制，1-不限制
            ,bank_channel_id -- 银行机构号.
            ,wechat_channel_id -- 微信机构号.
            ,profits_rate -- 分润值.
            ,portal_channel_id -- 门户机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.channel_id -- 渠道ID.即渠道编号
    ,o.invite_code -- 渠道邀请码.银行受理机构为该银行在我们系统中的银行英文编码;如兴业总行为CIB.兴业深圳支行为CIB_SZ;渠道为我们分配给该渠道的邀请码.生成规则(银行英文编码+I+6位序列)
    ,o.channel_name -- 渠道名称.
    ,o.channel_type -- 渠道类型.受理机构-1;渠道-2
    ,o.parent_channel -- 所属渠道.关联渠道ID，只有受理机构允许为空
    ,o.pay_accpet_org -- 支付受理机构.关联渠道表 的 渠道ID (CHANNEL_ID)
    ,o.channel_properties -- 渠道属性.银行机构-1;外部渠道-2
    ,o.province -- 省份.
    ,o.city -- 城市.
    ,o.county -- 区/县.
    ,o.address -- 地址.
    ,o.tel -- 电话.
    ,o.web_site -- 网址.
    ,o.principal -- 负责人.
    ,o.id_code -- 负责人身份证.
    ,o.license_photo -- 营业执照.
    ,o.indentity_photo -- 身份证照片.
    ,o.other_doc -- 其他资料.资料包，以zip和rar格式上传和下载
    ,o.email -- 邮箱.
    ,o.examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
    ,o.examine_time -- 审核时间.
    ,o.examine_status_remark -- 审核备注.
    ,o.examine_emp -- 审核人.
    ,o.activate_status -- 激活状态.0:未激活;1:激活成功;2:激活失败;3:需再次激活
    ,o.activate_time -- 激活时间.
    ,o.activate_status_remark -- 激活备注.
    ,o.activate_emp -- 激活人.
    ,o.sign_key -- 签名key.接口调用时的签名key
    ,o.extra_propertes -- 附加属性.1:用于标记大商户的渠道属性
    ,o.physics_flag -- 物理标识.1:正常;2:删除
    ,o.data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移；12:简易注册
    ,o.remark -- 备注.
    ,o.acc_way -- 结算方式.1：标准；2：提现
    ,o.fld_s1 -- 老平台公有云的渠道ID.老平台公有云的渠道ID
    ,o.fld_s2 -- 第三方商户ID.SPAY小商户进件
    ,o.fld_s3 -- 第三方APPID.SPAY小商户进件
    ,o.fld_n1 -- 具体受理机构类型.1：威富通；2：银行受理机构；3：通道受理机构
    ,o.fld_n2 -- 是否允许快速进件.1-是  0-否 (SPAY小商户进件)
    ,o.fld_n3 -- (authTradeType)授权子商户交易的类型
    ,o.fld_d1 -- 日期型保留字段1.
    ,o.create_user -- 创建用户.
    ,o.create_emp -- 创建人.
    ,o.create_time -- 创建时间.
    ,o.update_time -- 更新时间.
    ,o.thr_channel_id -- 外部渠道号.
    ,o.advance_side_id -- 垫资方
    ,o.channel_org_type -- 渠道机构类型.总行-1;分行-2;支行-3
    ,o.fld_n4 -- (inlineBankId)受理机构的行内银行ID
    ,o.fld_n5 -- 小商户进件时是否需要审核激活商户,0:需要审核激活(对应商户审核状态：未审核，商户激活状态：未激活),1:不需要审核激活(对应商户审核状态：审核通过，商户激活状态：激活成功)
    ,o.fld_n6 -- (timeZone)时区
    ,o.fld_n7 -- (mergeAccount)合并入账
    ,o.fld_n8 -- (wftOwnCh)是否威富通自有机构.0/null:否,1:是
    ,o.fld_s4 -- (notifyKey)通知秘钥
    ,o.fld_s5 -- (notifyUrl)通知地址
    ,o.fld_s6 -- (agentCode)翼支付机构号
    ,o.fld_s7 -- (expenseAccountName)成都农商行支出账号户名
    ,o.fld_s8 -- (expenseAccountCode)成都农商行支出账号卡号
    ,o.advance_quota -- 垫资额度字段
    ,o.pid_process_state -- pid改变处理状态 0待处理 1处理完成
    ,o.logo -- 二受理机构logo图片路径
    ,o.branch_flag -- 分行标识，0-非分行，1-分行
    ,o.fld_n9 -- (thiOrgType)数据库机构标识
    ,o.fld_n10 -- (channelPropertiesExt)渠道扩展属性
    ,o.fld_n11 -- (channelOwnerShip)渠道归属：1.零售总行,2.企金总行
    ,o.fld_n12 -- 外包服务机构进件成本费率为0，打上特殊标识1
    ,o.pay_page_auth_status -- 支付页面授权状态
    ,o.fld_s9 -- (orgIdPrefix)受理机构分配的机构号id前三位号段
    ,o.fld_s10 -- 
    ,o.fld_s11 -- 
    ,o.fld_s12 -- 
    ,o.expand_num -- 拓展人工号
    ,o.inner_org -- 内部机构号
    ,o.service_provider_id -- 云闪付服务商id
    ,o.service_public_key -- 云闪付公钥
    ,o.service_private_key -- 云闪付私钥
    ,o.passageway_cost_id -- 通道成本渠道id
    ,o.other_cost_id -- 其他成本渠道id
    ,o.id_code_begin_time -- 负责人证件有效期开始日
    ,o.business_license_begin_time -- 营业执照有效期开始日
    ,o.contacts_idcode -- 负责人证件号码
    ,o.business_license_expire -- 营业执照过期日
    ,o.business_license -- 营业执照号
    ,o.id_code_expire -- 负责人证件过期日
    ,o.id_code_type -- 负责人证件类型
    ,o.cle_org_id -- 所属清算机构号
    ,o.account_code_photo -- 开户许可证
    ,o.thi_doc_id -- 第三方文档id
    ,o.limit_credit_pay -- 信用卡限制：0-限制，1-不限制
    ,o.bank_channel_id -- 银行机构号.
    ,o.wechat_channel_id -- 微信机构号.
    ,o.profits_rate -- 分润值.
    ,o.portal_channel_id -- 门户机构号
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
from ${iol_schema}.amss_cms_channel_bk o
    left join ${iol_schema}.amss_cms_channel_op n
        on
            o.channel_id = n.channel_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_cms_channel_cl d
        on
            o.channel_id = d.channel_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_cms_channel;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_cms_channel') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_cms_channel drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_cms_channel add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_cms_channel exchange partition p_${batch_date} with table ${iol_schema}.amss_cms_channel_cl;
alter table ${iol_schema}.amss_cms_channel exchange partition p_20991231 with table ${iol_schema}.amss_cms_channel_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_cms_channel to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_channel_op purge;
drop table ${iol_schema}.amss_cms_channel_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_cms_channel_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_cms_channel',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
