/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_cms_merchant
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
create table ${iol_schema}.amss_cms_merchant_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_cms_merchant
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_merchant_op purge;
drop table ${iol_schema}.amss_cms_merchant_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_merchant_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_merchant where 0=1;

create table ${iol_schema}.amss_cms_merchant_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_merchant where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_merchant_cl(
            merchant_id -- 商户ID.即商户编号
            ,auto_id -- 自增ID.自增ID,V3.5的值来自SEQ_CMS_MERCHANT序列（需要注意初始序列值大小）.数据迁移时对应V3的PAY_MCH的ID字段
            ,merchant_name -- 商户名称.
            ,merchant_type -- 商户类型.大商户-11,普通商户-12,直营商户-13,加盟商户-14
            ,mch_deal_type -- 商户经营类型.0:全部;1:实体;2:虚拟
            ,fee_type -- 币种.多个币种使用英文逗号分隔
            ,channel_id -- 所属渠道.关联渠道表 的 渠道ID (CHANNEL_ID)
            ,auth_trade_channel_id -- 授权交易渠道.关联渠道表 的 渠道ID (CHANNEL_ID),对应V3的sign_agent_no字段
            ,accept_org_id -- 所属受理机构.关联渠道表 的 渠道ID (CHANNEL_ID)
            ,pay_accpet_org -- 支付受理机构.关联渠道表 的 渠道ID (CHANNEL_ID),一般情况下,支付受理机构的值为所属渠道的受理机构;当威富通的某个渠道下的某个商户挂到兴业的某个渠道做支付时,所属渠道为威富通下的渠道,支付受理机构为兴业
            ,parent_merchant -- 父商户.大商户、普通商户无父商户.直营商户、加盟商户的父商户为大商户
            ,pay_parent_merchant -- 支付父商户.一般情况下,支付父商户和父商户的值相同;当跨父商户的情况下,值为实际支付时指定的父商户值.暂不启用
            ,dept_id -- 部门.关联部门表的 DEPT_ID
            ,salesman_id -- 业务员ID.关联员工表 的 EMP_ID 字段
            ,merchant_detail_id -- 商户详细信息.关联商户详细信息表的 MERCHANT_DETAIL_ID
            ,examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
            ,examine_time -- 审核时间.
            ,examine_status_remark -- 审核备注.
            ,examine_emp -- 审核人.
            ,activate_status -- 激活状态.0:未激活;1:激活成功;2:激活失败;3:需再次激活;4:冻结;5:注销;6:解冻
            ,activate_time -- 激活时间.
            ,activate_status_remark -- 激活备注.
            ,activate_emp -- 激活人.
            ,sign_key -- 签名key.接口调用时的签名key
            ,cover_flag -- 覆盖标识.导入导出时用到该字段;1:可覆盖;2:不可覆盖;3:可覆盖，但不可覆盖所属渠道字段
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移；12:简易注册
            ,remark -- 备注.
            ,acc_way -- 结算方式.1：标准；2：提现
            ,fld_s1 -- 商户类型中文名
            ,fld_s2 -- 商户经营类型中文名
            ,fld_s3 -- (storeRemark)门店备注
            ,fld_n1 -- (mchPreExamineRank)商户初审等级
            ,fld_n2 -- 数值型保留字段2.
            ,fld_n3 -- (authTradeChannelSource)授权交易机构的数据来源
            ,fld_d1 -- (accWayEffectiveTime)结算方式的生效时间
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,out_merchant_id -- 外商户号.
            ,pay_channel_id -- 支付渠道ID.
            ,merchant_properties -- 商户属性字段，按位使用
            ,fld_n4 -- (prepayCenterId)预付卡通道ID
            ,fld_n5 -- (mchDailyLimit)商户日限额,以分为单位
            ,fld_n6 -- (customAuthTradeSourceType)商户自主授权的来源类型 1-商户平台自主授权 2-后台编辑商户授权
            ,fld_n7 -- (merchantBusinessType)商户性质.1-公司商户,2-个体商户
            ,fld_n8 -- (merchantBusinessProperty)商户属性.1-网络特约商户,2-实体特约商户,3-实体兼网络特约商户
            ,fld_s4 -- (alipayOauthPid)支付宝授权账号
            ,fld_s5 -- (unionIndirectPayCenter)银联间联通道列表
            ,fld_s6 -- (scenceInfo)用于配置商户的场景信息
            ,fld_s7 -- 
            ,fld_s8 -- 
            ,notify_key -- 商户外部平台notifyKey
            ,notify_url -- 商户外部平台notifyUrl
            ,salesman_serial -- 业务员序列
            ,pre_examine_status -- 初审状态
            ,pre_examine_time -- 初审时间
            ,pre_examine_status_remark -- 初审备注
            ,pre_examine_emp -- 初审人
            ,auth_trade_time -- 授权交易时间
            ,fld_n9 -- 商户月限额
            ,fld_n10 -- 
            ,fld_n11 -- 
            ,fld_n12 -- 
            ,fld_n13 -- 
            ,fld_s9 -- (unionadminMchNo)保存银总商户号
            ,fld_s10 -- 
            ,fld_s11 -- 
            ,fld_s12 -- 
            ,fld_s13 -- 
            ,limit_credit_pay -- 是否允许使用信用卡
            ,credit_pay_pre_limit -- 信用卡单笔限额
            ,credit_pay_day_limit -- 信用卡单日限额
            ,days_kingdee_id -- 得仕商户的金蝶商户号99.开头
            ,days_mrch_no -- 得仕商户的得仕商户号940开头
            ,pcac_status -- 清算协会侧状态
            ,credit_pay_month_limit -- 信用卡单月限额
            ,expand_num -- 拓展人工号
            ,inner_org -- 拓展机构号
            ,jl_mch_no -- 收单机构商户号
            ,jl_protocol_id -- 收单机构协议号
            ,mch_property_extension -- 商户属性扩展
            ,passageway_cost_id -- 通道成本渠道id
            ,other_cost_id -- 其他成本渠道id
            ,register_mch_name -- 商户报备名称
            ,is_signatured -- 是否签约，0：未签约 1：已签约
            ,inviter -- 邀请人
            ,trade_able_hours_begin -- 可交易开始时间
            ,trade_able_hours_end -- 可交易结束时间
            ,reservation_id -- 预约id，长江商业银行需要
            ,first_active -- 首次激活时间
            ,is_open_d0 -- 是否开通小额D0
            ,first_activate_time -- 首次激活时间
            ,union_mch_direct_flag -- 直连pos商户标识 0否 1是 默认为0
            ,is_open_smart_business -- 是否开通智慧经营标识 1-是；2-否
            ,outer_channel_id -- 
            ,xft_flag -- 是否兴付通商户（0-否，1-是）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_merchant_op(
            merchant_id -- 商户ID.即商户编号
            ,auto_id -- 自增ID.自增ID,V3.5的值来自SEQ_CMS_MERCHANT序列（需要注意初始序列值大小）.数据迁移时对应V3的PAY_MCH的ID字段
            ,merchant_name -- 商户名称.
            ,merchant_type -- 商户类型.大商户-11,普通商户-12,直营商户-13,加盟商户-14
            ,mch_deal_type -- 商户经营类型.0:全部;1:实体;2:虚拟
            ,fee_type -- 币种.多个币种使用英文逗号分隔
            ,channel_id -- 所属渠道.关联渠道表 的 渠道ID (CHANNEL_ID)
            ,auth_trade_channel_id -- 授权交易渠道.关联渠道表 的 渠道ID (CHANNEL_ID),对应V3的sign_agent_no字段
            ,accept_org_id -- 所属受理机构.关联渠道表 的 渠道ID (CHANNEL_ID)
            ,pay_accpet_org -- 支付受理机构.关联渠道表 的 渠道ID (CHANNEL_ID),一般情况下,支付受理机构的值为所属渠道的受理机构;当威富通的某个渠道下的某个商户挂到兴业的某个渠道做支付时,所属渠道为威富通下的渠道,支付受理机构为兴业
            ,parent_merchant -- 父商户.大商户、普通商户无父商户.直营商户、加盟商户的父商户为大商户
            ,pay_parent_merchant -- 支付父商户.一般情况下,支付父商户和父商户的值相同;当跨父商户的情况下,值为实际支付时指定的父商户值.暂不启用
            ,dept_id -- 部门.关联部门表的 DEPT_ID
            ,salesman_id -- 业务员ID.关联员工表 的 EMP_ID 字段
            ,merchant_detail_id -- 商户详细信息.关联商户详细信息表的 MERCHANT_DETAIL_ID
            ,examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
            ,examine_time -- 审核时间.
            ,examine_status_remark -- 审核备注.
            ,examine_emp -- 审核人.
            ,activate_status -- 激活状态.0:未激活;1:激活成功;2:激活失败;3:需再次激活;4:冻结;5:注销;6:解冻
            ,activate_time -- 激活时间.
            ,activate_status_remark -- 激活备注.
            ,activate_emp -- 激活人.
            ,sign_key -- 签名key.接口调用时的签名key
            ,cover_flag -- 覆盖标识.导入导出时用到该字段;1:可覆盖;2:不可覆盖;3:可覆盖，但不可覆盖所属渠道字段
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移；12:简易注册
            ,remark -- 备注.
            ,acc_way -- 结算方式.1：标准；2：提现
            ,fld_s1 -- 商户类型中文名
            ,fld_s2 -- 商户经营类型中文名
            ,fld_s3 -- (storeRemark)门店备注
            ,fld_n1 -- (mchPreExamineRank)商户初审等级
            ,fld_n2 -- 数值型保留字段2.
            ,fld_n3 -- (authTradeChannelSource)授权交易机构的数据来源
            ,fld_d1 -- (accWayEffectiveTime)结算方式的生效时间
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,out_merchant_id -- 外商户号.
            ,pay_channel_id -- 支付渠道ID.
            ,merchant_properties -- 商户属性字段，按位使用
            ,fld_n4 -- (prepayCenterId)预付卡通道ID
            ,fld_n5 -- (mchDailyLimit)商户日限额,以分为单位
            ,fld_n6 -- (customAuthTradeSourceType)商户自主授权的来源类型 1-商户平台自主授权 2-后台编辑商户授权
            ,fld_n7 -- (merchantBusinessType)商户性质.1-公司商户,2-个体商户
            ,fld_n8 -- (merchantBusinessProperty)商户属性.1-网络特约商户,2-实体特约商户,3-实体兼网络特约商户
            ,fld_s4 -- (alipayOauthPid)支付宝授权账号
            ,fld_s5 -- (unionIndirectPayCenter)银联间联通道列表
            ,fld_s6 -- (scenceInfo)用于配置商户的场景信息
            ,fld_s7 -- 
            ,fld_s8 -- 
            ,notify_key -- 商户外部平台notifyKey
            ,notify_url -- 商户外部平台notifyUrl
            ,salesman_serial -- 业务员序列
            ,pre_examine_status -- 初审状态
            ,pre_examine_time -- 初审时间
            ,pre_examine_status_remark -- 初审备注
            ,pre_examine_emp -- 初审人
            ,auth_trade_time -- 授权交易时间
            ,fld_n9 -- 商户月限额
            ,fld_n10 -- 
            ,fld_n11 -- 
            ,fld_n12 -- 
            ,fld_n13 -- 
            ,fld_s9 -- (unionadminMchNo)保存银总商户号
            ,fld_s10 -- 
            ,fld_s11 -- 
            ,fld_s12 -- 
            ,fld_s13 -- 
            ,limit_credit_pay -- 是否允许使用信用卡
            ,credit_pay_pre_limit -- 信用卡单笔限额
            ,credit_pay_day_limit -- 信用卡单日限额
            ,days_kingdee_id -- 得仕商户的金蝶商户号99.开头
            ,days_mrch_no -- 得仕商户的得仕商户号940开头
            ,pcac_status -- 清算协会侧状态
            ,credit_pay_month_limit -- 信用卡单月限额
            ,expand_num -- 拓展人工号
            ,inner_org -- 拓展机构号
            ,jl_mch_no -- 收单机构商户号
            ,jl_protocol_id -- 收单机构协议号
            ,mch_property_extension -- 商户属性扩展
            ,passageway_cost_id -- 通道成本渠道id
            ,other_cost_id -- 其他成本渠道id
            ,register_mch_name -- 商户报备名称
            ,is_signatured -- 是否签约，0：未签约 1：已签约
            ,inviter -- 邀请人
            ,trade_able_hours_begin -- 可交易开始时间
            ,trade_able_hours_end -- 可交易结束时间
            ,reservation_id -- 预约id，长江商业银行需要
            ,first_active -- 首次激活时间
            ,is_open_d0 -- 是否开通小额D0
            ,first_activate_time -- 首次激活时间
            ,union_mch_direct_flag -- 直连pos商户标识 0否 1是 默认为0
            ,is_open_smart_business -- 是否开通智慧经营标识 1-是；2-否
            ,outer_channel_id -- 
            ,xft_flag -- 是否兴付通商户（0-否，1-是）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.merchant_id, o.merchant_id) as merchant_id -- 商户ID.即商户编号
    ,nvl(n.auto_id, o.auto_id) as auto_id -- 自增ID.自增ID,V3.5的值来自SEQ_CMS_MERCHANT序列（需要注意初始序列值大小）.数据迁移时对应V3的PAY_MCH的ID字段
    ,nvl(n.merchant_name, o.merchant_name) as merchant_name -- 商户名称.
    ,nvl(n.merchant_type, o.merchant_type) as merchant_type -- 商户类型.大商户-11,普通商户-12,直营商户-13,加盟商户-14
    ,nvl(n.mch_deal_type, o.mch_deal_type) as mch_deal_type -- 商户经营类型.0:全部;1:实体;2:虚拟
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 币种.多个币种使用英文逗号分隔
    ,nvl(n.channel_id, o.channel_id) as channel_id -- 所属渠道.关联渠道表 的 渠道ID (CHANNEL_ID)
    ,nvl(n.auth_trade_channel_id, o.auth_trade_channel_id) as auth_trade_channel_id -- 授权交易渠道.关联渠道表 的 渠道ID (CHANNEL_ID),对应V3的sign_agent_no字段
    ,nvl(n.accept_org_id, o.accept_org_id) as accept_org_id -- 所属受理机构.关联渠道表 的 渠道ID (CHANNEL_ID)
    ,nvl(n.pay_accpet_org, o.pay_accpet_org) as pay_accpet_org -- 支付受理机构.关联渠道表 的 渠道ID (CHANNEL_ID),一般情况下,支付受理机构的值为所属渠道的受理机构;当威富通的某个渠道下的某个商户挂到兴业的某个渠道做支付时,所属渠道为威富通下的渠道,支付受理机构为兴业
    ,nvl(n.parent_merchant, o.parent_merchant) as parent_merchant -- 父商户.大商户、普通商户无父商户.直营商户、加盟商户的父商户为大商户
    ,nvl(n.pay_parent_merchant, o.pay_parent_merchant) as pay_parent_merchant -- 支付父商户.一般情况下,支付父商户和父商户的值相同;当跨父商户的情况下,值为实际支付时指定的父商户值.暂不启用
    ,nvl(n.dept_id, o.dept_id) as dept_id -- 部门.关联部门表的 DEPT_ID
    ,nvl(n.salesman_id, o.salesman_id) as salesman_id -- 业务员ID.关联员工表 的 EMP_ID 字段
    ,nvl(n.merchant_detail_id, o.merchant_detail_id) as merchant_detail_id -- 商户详细信息.关联商户详细信息表的 MERCHANT_DETAIL_ID
    ,nvl(n.examine_status, o.examine_status) as examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
    ,nvl(n.examine_time, o.examine_time) as examine_time -- 审核时间.
    ,nvl(n.examine_status_remark, o.examine_status_remark) as examine_status_remark -- 审核备注.
    ,nvl(n.examine_emp, o.examine_emp) as examine_emp -- 审核人.
    ,nvl(n.activate_status, o.activate_status) as activate_status -- 激活状态.0:未激活;1:激活成功;2:激活失败;3:需再次激活;4:冻结;5:注销;6:解冻
    ,nvl(n.activate_time, o.activate_time) as activate_time -- 激活时间.
    ,nvl(n.activate_status_remark, o.activate_status_remark) as activate_status_remark -- 激活备注.
    ,nvl(n.activate_emp, o.activate_emp) as activate_emp -- 激活人.
    ,nvl(n.sign_key, o.sign_key) as sign_key -- 签名key.接口调用时的签名key
    ,nvl(n.cover_flag, o.cover_flag) as cover_flag -- 覆盖标识.导入导出时用到该字段;1:可覆盖;2:不可覆盖;3:可覆盖，但不可覆盖所属渠道字段
    ,nvl(n.physics_flag, o.physics_flag) as physics_flag -- 物理标识.1:正常;2:删除
    ,nvl(n.data_source, o.data_source) as data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移；12:简易注册
    ,nvl(n.remark, o.remark) as remark -- 备注.
    ,nvl(n.acc_way, o.acc_way) as acc_way -- 结算方式.1：标准；2：提现
    ,nvl(n.fld_s1, o.fld_s1) as fld_s1 -- 商户类型中文名
    ,nvl(n.fld_s2, o.fld_s2) as fld_s2 -- 商户经营类型中文名
    ,nvl(n.fld_s3, o.fld_s3) as fld_s3 -- (storeRemark)门店备注
    ,nvl(n.fld_n1, o.fld_n1) as fld_n1 -- (mchPreExamineRank)商户初审等级
    ,nvl(n.fld_n2, o.fld_n2) as fld_n2 -- 数值型保留字段2.
    ,nvl(n.fld_n3, o.fld_n3) as fld_n3 -- (authTradeChannelSource)授权交易机构的数据来源
    ,nvl(n.fld_d1, o.fld_d1) as fld_d1 -- (accWayEffectiveTime)结算方式的生效时间
    ,nvl(n.create_user, o.create_user) as create_user -- 创建用户.
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建人.
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间.
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间.
    ,nvl(n.out_merchant_id, o.out_merchant_id) as out_merchant_id -- 外商户号.
    ,nvl(n.pay_channel_id, o.pay_channel_id) as pay_channel_id -- 支付渠道ID.
    ,nvl(n.merchant_properties, o.merchant_properties) as merchant_properties -- 商户属性字段，按位使用
    ,nvl(n.fld_n4, o.fld_n4) as fld_n4 -- (prepayCenterId)预付卡通道ID
    ,nvl(n.fld_n5, o.fld_n5) as fld_n5 -- (mchDailyLimit)商户日限额,以分为单位
    ,nvl(n.fld_n6, o.fld_n6) as fld_n6 -- (customAuthTradeSourceType)商户自主授权的来源类型 1-商户平台自主授权 2-后台编辑商户授权
    ,nvl(n.fld_n7, o.fld_n7) as fld_n7 -- (merchantBusinessType)商户性质.1-公司商户,2-个体商户
    ,nvl(n.fld_n8, o.fld_n8) as fld_n8 -- (merchantBusinessProperty)商户属性.1-网络特约商户,2-实体特约商户,3-实体兼网络特约商户
    ,nvl(n.fld_s4, o.fld_s4) as fld_s4 -- (alipayOauthPid)支付宝授权账号
    ,nvl(n.fld_s5, o.fld_s5) as fld_s5 -- (unionIndirectPayCenter)银联间联通道列表
    ,nvl(n.fld_s6, o.fld_s6) as fld_s6 -- (scenceInfo)用于配置商户的场景信息
    ,nvl(n.fld_s7, o.fld_s7) as fld_s7 -- 
    ,nvl(n.fld_s8, o.fld_s8) as fld_s8 -- 
    ,nvl(n.notify_key, o.notify_key) as notify_key -- 商户外部平台notifyKey
    ,nvl(n.notify_url, o.notify_url) as notify_url -- 商户外部平台notifyUrl
    ,nvl(n.salesman_serial, o.salesman_serial) as salesman_serial -- 业务员序列
    ,nvl(n.pre_examine_status, o.pre_examine_status) as pre_examine_status -- 初审状态
    ,nvl(n.pre_examine_time, o.pre_examine_time) as pre_examine_time -- 初审时间
    ,nvl(n.pre_examine_status_remark, o.pre_examine_status_remark) as pre_examine_status_remark -- 初审备注
    ,nvl(n.pre_examine_emp, o.pre_examine_emp) as pre_examine_emp -- 初审人
    ,nvl(n.auth_trade_time, o.auth_trade_time) as auth_trade_time -- 授权交易时间
    ,nvl(n.fld_n9, o.fld_n9) as fld_n9 -- 商户月限额
    ,nvl(n.fld_n10, o.fld_n10) as fld_n10 -- 
    ,nvl(n.fld_n11, o.fld_n11) as fld_n11 -- 
    ,nvl(n.fld_n12, o.fld_n12) as fld_n12 -- 
    ,nvl(n.fld_n13, o.fld_n13) as fld_n13 -- 
    ,nvl(n.fld_s9, o.fld_s9) as fld_s9 -- (unionadminMchNo)保存银总商户号
    ,nvl(n.fld_s10, o.fld_s10) as fld_s10 -- 
    ,nvl(n.fld_s11, o.fld_s11) as fld_s11 -- 
    ,nvl(n.fld_s12, o.fld_s12) as fld_s12 -- 
    ,nvl(n.fld_s13, o.fld_s13) as fld_s13 -- 
    ,nvl(n.limit_credit_pay, o.limit_credit_pay) as limit_credit_pay -- 是否允许使用信用卡
    ,nvl(n.credit_pay_pre_limit, o.credit_pay_pre_limit) as credit_pay_pre_limit -- 信用卡单笔限额
    ,nvl(n.credit_pay_day_limit, o.credit_pay_day_limit) as credit_pay_day_limit -- 信用卡单日限额
    ,nvl(n.days_kingdee_id, o.days_kingdee_id) as days_kingdee_id -- 得仕商户的金蝶商户号99.开头
    ,nvl(n.days_mrch_no, o.days_mrch_no) as days_mrch_no -- 得仕商户的得仕商户号940开头
    ,nvl(n.pcac_status, o.pcac_status) as pcac_status -- 清算协会侧状态
    ,nvl(n.credit_pay_month_limit, o.credit_pay_month_limit) as credit_pay_month_limit -- 信用卡单月限额
    ,nvl(n.expand_num, o.expand_num) as expand_num -- 拓展人工号
    ,nvl(n.inner_org, o.inner_org) as inner_org -- 拓展机构号
    ,nvl(n.jl_mch_no, o.jl_mch_no) as jl_mch_no -- 收单机构商户号
    ,nvl(n.jl_protocol_id, o.jl_protocol_id) as jl_protocol_id -- 收单机构协议号
    ,nvl(n.mch_property_extension, o.mch_property_extension) as mch_property_extension -- 商户属性扩展
    ,nvl(n.passageway_cost_id, o.passageway_cost_id) as passageway_cost_id -- 通道成本渠道id
    ,nvl(n.other_cost_id, o.other_cost_id) as other_cost_id -- 其他成本渠道id
    ,nvl(n.register_mch_name, o.register_mch_name) as register_mch_name -- 商户报备名称
    ,nvl(n.is_signatured, o.is_signatured) as is_signatured -- 是否签约，0：未签约 1：已签约
    ,nvl(n.inviter, o.inviter) as inviter -- 邀请人
    ,nvl(n.trade_able_hours_begin, o.trade_able_hours_begin) as trade_able_hours_begin -- 可交易开始时间
    ,nvl(n.trade_able_hours_end, o.trade_able_hours_end) as trade_able_hours_end -- 可交易结束时间
    ,nvl(n.reservation_id, o.reservation_id) as reservation_id -- 预约id，长江商业银行需要
    ,nvl(n.first_active, o.first_active) as first_active -- 首次激活时间
    ,nvl(n.is_open_d0, o.is_open_d0) as is_open_d0 -- 是否开通小额D0
    ,nvl(n.first_activate_time, o.first_activate_time) as first_activate_time -- 首次激活时间
    ,nvl(n.union_mch_direct_flag, o.union_mch_direct_flag) as union_mch_direct_flag -- 直连pos商户标识 0否 1是 默认为0
    ,nvl(n.is_open_smart_business, o.is_open_smart_business) as is_open_smart_business -- 是否开通智慧经营标识 1-是；2-否
    ,nvl(n.outer_channel_id, o.outer_channel_id) as outer_channel_id -- 
    ,nvl(n.xft_flag, o.xft_flag) as xft_flag -- 是否兴付通商户（0-否，1-是）
    ,case when
            n.merchant_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.merchant_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.merchant_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_cms_merchant_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_cms_merchant where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.merchant_id = n.merchant_id
where (
        o.merchant_id is null
    )
    or (
        n.merchant_id is null
    )
    or (
        o.auto_id <> n.auto_id
        or o.merchant_name <> n.merchant_name
        or o.merchant_type <> n.merchant_type
        or o.mch_deal_type <> n.mch_deal_type
        or o.fee_type <> n.fee_type
        or o.channel_id <> n.channel_id
        or o.auth_trade_channel_id <> n.auth_trade_channel_id
        or o.accept_org_id <> n.accept_org_id
        or o.pay_accpet_org <> n.pay_accpet_org
        or o.parent_merchant <> n.parent_merchant
        or o.pay_parent_merchant <> n.pay_parent_merchant
        or o.dept_id <> n.dept_id
        or o.salesman_id <> n.salesman_id
        or o.merchant_detail_id <> n.merchant_detail_id
        or o.examine_status <> n.examine_status
        or o.examine_time <> n.examine_time
        or o.examine_status_remark <> n.examine_status_remark
        or o.examine_emp <> n.examine_emp
        or o.activate_status <> n.activate_status
        or o.activate_time <> n.activate_time
        or o.activate_status_remark <> n.activate_status_remark
        or o.activate_emp <> n.activate_emp
        or o.sign_key <> n.sign_key
        or o.cover_flag <> n.cover_flag
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
        or o.out_merchant_id <> n.out_merchant_id
        or o.pay_channel_id <> n.pay_channel_id
        or o.merchant_properties <> n.merchant_properties
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
        or o.notify_key <> n.notify_key
        or o.notify_url <> n.notify_url
        or o.salesman_serial <> n.salesman_serial
        or o.pre_examine_status <> n.pre_examine_status
        or o.pre_examine_time <> n.pre_examine_time
        or o.pre_examine_status_remark <> n.pre_examine_status_remark
        or o.pre_examine_emp <> n.pre_examine_emp
        or o.auth_trade_time <> n.auth_trade_time
        or o.fld_n9 <> n.fld_n9
        or o.fld_n10 <> n.fld_n10
        or o.fld_n11 <> n.fld_n11
        or o.fld_n12 <> n.fld_n12
        or o.fld_n13 <> n.fld_n13
        or o.fld_s9 <> n.fld_s9
        or o.fld_s10 <> n.fld_s10
        or o.fld_s11 <> n.fld_s11
        or o.fld_s12 <> n.fld_s12
        or o.fld_s13 <> n.fld_s13
        or o.limit_credit_pay <> n.limit_credit_pay
        or o.credit_pay_pre_limit <> n.credit_pay_pre_limit
        or o.credit_pay_day_limit <> n.credit_pay_day_limit
        or o.days_kingdee_id <> n.days_kingdee_id
        or o.days_mrch_no <> n.days_mrch_no
        or o.pcac_status <> n.pcac_status
        or o.credit_pay_month_limit <> n.credit_pay_month_limit
        or o.expand_num <> n.expand_num
        or o.inner_org <> n.inner_org
        or o.jl_mch_no <> n.jl_mch_no
        or o.jl_protocol_id <> n.jl_protocol_id
        or o.mch_property_extension <> n.mch_property_extension
        or o.passageway_cost_id <> n.passageway_cost_id
        or o.other_cost_id <> n.other_cost_id
        or o.register_mch_name <> n.register_mch_name
        or o.is_signatured <> n.is_signatured
        or o.inviter <> n.inviter
        or o.trade_able_hours_begin <> n.trade_able_hours_begin
        or o.trade_able_hours_end <> n.trade_able_hours_end
        or o.reservation_id <> n.reservation_id
        or o.first_active <> n.first_active
        or o.is_open_d0 <> n.is_open_d0
        or o.first_activate_time <> n.first_activate_time
        or o.union_mch_direct_flag <> n.union_mch_direct_flag
        or o.is_open_smart_business <> n.is_open_smart_business
        or o.outer_channel_id <> n.outer_channel_id
        or o.xft_flag <> n.xft_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_merchant_cl(
            merchant_id -- 商户ID.即商户编号
            ,auto_id -- 自增ID.自增ID,V3.5的值来自SEQ_CMS_MERCHANT序列（需要注意初始序列值大小）.数据迁移时对应V3的PAY_MCH的ID字段
            ,merchant_name -- 商户名称.
            ,merchant_type -- 商户类型.大商户-11,普通商户-12,直营商户-13,加盟商户-14
            ,mch_deal_type -- 商户经营类型.0:全部;1:实体;2:虚拟
            ,fee_type -- 币种.多个币种使用英文逗号分隔
            ,channel_id -- 所属渠道.关联渠道表 的 渠道ID (CHANNEL_ID)
            ,auth_trade_channel_id -- 授权交易渠道.关联渠道表 的 渠道ID (CHANNEL_ID),对应V3的sign_agent_no字段
            ,accept_org_id -- 所属受理机构.关联渠道表 的 渠道ID (CHANNEL_ID)
            ,pay_accpet_org -- 支付受理机构.关联渠道表 的 渠道ID (CHANNEL_ID),一般情况下,支付受理机构的值为所属渠道的受理机构;当威富通的某个渠道下的某个商户挂到兴业的某个渠道做支付时,所属渠道为威富通下的渠道,支付受理机构为兴业
            ,parent_merchant -- 父商户.大商户、普通商户无父商户.直营商户、加盟商户的父商户为大商户
            ,pay_parent_merchant -- 支付父商户.一般情况下,支付父商户和父商户的值相同;当跨父商户的情况下,值为实际支付时指定的父商户值.暂不启用
            ,dept_id -- 部门.关联部门表的 DEPT_ID
            ,salesman_id -- 业务员ID.关联员工表 的 EMP_ID 字段
            ,merchant_detail_id -- 商户详细信息.关联商户详细信息表的 MERCHANT_DETAIL_ID
            ,examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
            ,examine_time -- 审核时间.
            ,examine_status_remark -- 审核备注.
            ,examine_emp -- 审核人.
            ,activate_status -- 激活状态.0:未激活;1:激活成功;2:激活失败;3:需再次激活;4:冻结;5:注销;6:解冻
            ,activate_time -- 激活时间.
            ,activate_status_remark -- 激活备注.
            ,activate_emp -- 激活人.
            ,sign_key -- 签名key.接口调用时的签名key
            ,cover_flag -- 覆盖标识.导入导出时用到该字段;1:可覆盖;2:不可覆盖;3:可覆盖，但不可覆盖所属渠道字段
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移；12:简易注册
            ,remark -- 备注.
            ,acc_way -- 结算方式.1：标准；2：提现
            ,fld_s1 -- 商户类型中文名
            ,fld_s2 -- 商户经营类型中文名
            ,fld_s3 -- (storeRemark)门店备注
            ,fld_n1 -- (mchPreExamineRank)商户初审等级
            ,fld_n2 -- 数值型保留字段2.
            ,fld_n3 -- (authTradeChannelSource)授权交易机构的数据来源
            ,fld_d1 -- (accWayEffectiveTime)结算方式的生效时间
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,out_merchant_id -- 外商户号.
            ,pay_channel_id -- 支付渠道ID.
            ,merchant_properties -- 商户属性字段，按位使用
            ,fld_n4 -- (prepayCenterId)预付卡通道ID
            ,fld_n5 -- (mchDailyLimit)商户日限额,以分为单位
            ,fld_n6 -- (customAuthTradeSourceType)商户自主授权的来源类型 1-商户平台自主授权 2-后台编辑商户授权
            ,fld_n7 -- (merchantBusinessType)商户性质.1-公司商户,2-个体商户
            ,fld_n8 -- (merchantBusinessProperty)商户属性.1-网络特约商户,2-实体特约商户,3-实体兼网络特约商户
            ,fld_s4 -- (alipayOauthPid)支付宝授权账号
            ,fld_s5 -- (unionIndirectPayCenter)银联间联通道列表
            ,fld_s6 -- (scenceInfo)用于配置商户的场景信息
            ,fld_s7 -- 
            ,fld_s8 -- 
            ,notify_key -- 商户外部平台notifyKey
            ,notify_url -- 商户外部平台notifyUrl
            ,salesman_serial -- 业务员序列
            ,pre_examine_status -- 初审状态
            ,pre_examine_time -- 初审时间
            ,pre_examine_status_remark -- 初审备注
            ,pre_examine_emp -- 初审人
            ,auth_trade_time -- 授权交易时间
            ,fld_n9 -- 商户月限额
            ,fld_n10 -- 
            ,fld_n11 -- 
            ,fld_n12 -- 
            ,fld_n13 -- 
            ,fld_s9 -- (unionadminMchNo)保存银总商户号
            ,fld_s10 -- 
            ,fld_s11 -- 
            ,fld_s12 -- 
            ,fld_s13 -- 
            ,limit_credit_pay -- 是否允许使用信用卡
            ,credit_pay_pre_limit -- 信用卡单笔限额
            ,credit_pay_day_limit -- 信用卡单日限额
            ,days_kingdee_id -- 得仕商户的金蝶商户号99.开头
            ,days_mrch_no -- 得仕商户的得仕商户号940开头
            ,pcac_status -- 清算协会侧状态
            ,credit_pay_month_limit -- 信用卡单月限额
            ,expand_num -- 拓展人工号
            ,inner_org -- 拓展机构号
            ,jl_mch_no -- 收单机构商户号
            ,jl_protocol_id -- 收单机构协议号
            ,mch_property_extension -- 商户属性扩展
            ,passageway_cost_id -- 通道成本渠道id
            ,other_cost_id -- 其他成本渠道id
            ,register_mch_name -- 商户报备名称
            ,is_signatured -- 是否签约，0：未签约 1：已签约
            ,inviter -- 邀请人
            ,trade_able_hours_begin -- 可交易开始时间
            ,trade_able_hours_end -- 可交易结束时间
            ,reservation_id -- 预约id，长江商业银行需要
            ,first_active -- 首次激活时间
            ,is_open_d0 -- 是否开通小额D0
            ,first_activate_time -- 首次激活时间
            ,union_mch_direct_flag -- 直连pos商户标识 0否 1是 默认为0
            ,is_open_smart_business -- 是否开通智慧经营标识 1-是；2-否
            ,outer_channel_id -- 
            ,xft_flag -- 是否兴付通商户（0-否，1-是）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_merchant_op(
            merchant_id -- 商户ID.即商户编号
            ,auto_id -- 自增ID.自增ID,V3.5的值来自SEQ_CMS_MERCHANT序列（需要注意初始序列值大小）.数据迁移时对应V3的PAY_MCH的ID字段
            ,merchant_name -- 商户名称.
            ,merchant_type -- 商户类型.大商户-11,普通商户-12,直营商户-13,加盟商户-14
            ,mch_deal_type -- 商户经营类型.0:全部;1:实体;2:虚拟
            ,fee_type -- 币种.多个币种使用英文逗号分隔
            ,channel_id -- 所属渠道.关联渠道表 的 渠道ID (CHANNEL_ID)
            ,auth_trade_channel_id -- 授权交易渠道.关联渠道表 的 渠道ID (CHANNEL_ID),对应V3的sign_agent_no字段
            ,accept_org_id -- 所属受理机构.关联渠道表 的 渠道ID (CHANNEL_ID)
            ,pay_accpet_org -- 支付受理机构.关联渠道表 的 渠道ID (CHANNEL_ID),一般情况下,支付受理机构的值为所属渠道的受理机构;当威富通的某个渠道下的某个商户挂到兴业的某个渠道做支付时,所属渠道为威富通下的渠道,支付受理机构为兴业
            ,parent_merchant -- 父商户.大商户、普通商户无父商户.直营商户、加盟商户的父商户为大商户
            ,pay_parent_merchant -- 支付父商户.一般情况下,支付父商户和父商户的值相同;当跨父商户的情况下,值为实际支付时指定的父商户值.暂不启用
            ,dept_id -- 部门.关联部门表的 DEPT_ID
            ,salesman_id -- 业务员ID.关联员工表 的 EMP_ID 字段
            ,merchant_detail_id -- 商户详细信息.关联商户详细信息表的 MERCHANT_DETAIL_ID
            ,examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
            ,examine_time -- 审核时间.
            ,examine_status_remark -- 审核备注.
            ,examine_emp -- 审核人.
            ,activate_status -- 激活状态.0:未激活;1:激活成功;2:激活失败;3:需再次激活;4:冻结;5:注销;6:解冻
            ,activate_time -- 激活时间.
            ,activate_status_remark -- 激活备注.
            ,activate_emp -- 激活人.
            ,sign_key -- 签名key.接口调用时的签名key
            ,cover_flag -- 覆盖标识.导入导出时用到该字段;1:可覆盖;2:不可覆盖;3:可覆盖，但不可覆盖所属渠道字段
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移；12:简易注册
            ,remark -- 备注.
            ,acc_way -- 结算方式.1：标准；2：提现
            ,fld_s1 -- 商户类型中文名
            ,fld_s2 -- 商户经营类型中文名
            ,fld_s3 -- (storeRemark)门店备注
            ,fld_n1 -- (mchPreExamineRank)商户初审等级
            ,fld_n2 -- 数值型保留字段2.
            ,fld_n3 -- (authTradeChannelSource)授权交易机构的数据来源
            ,fld_d1 -- (accWayEffectiveTime)结算方式的生效时间
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,out_merchant_id -- 外商户号.
            ,pay_channel_id -- 支付渠道ID.
            ,merchant_properties -- 商户属性字段，按位使用
            ,fld_n4 -- (prepayCenterId)预付卡通道ID
            ,fld_n5 -- (mchDailyLimit)商户日限额,以分为单位
            ,fld_n6 -- (customAuthTradeSourceType)商户自主授权的来源类型 1-商户平台自主授权 2-后台编辑商户授权
            ,fld_n7 -- (merchantBusinessType)商户性质.1-公司商户,2-个体商户
            ,fld_n8 -- (merchantBusinessProperty)商户属性.1-网络特约商户,2-实体特约商户,3-实体兼网络特约商户
            ,fld_s4 -- (alipayOauthPid)支付宝授权账号
            ,fld_s5 -- (unionIndirectPayCenter)银联间联通道列表
            ,fld_s6 -- (scenceInfo)用于配置商户的场景信息
            ,fld_s7 -- 
            ,fld_s8 -- 
            ,notify_key -- 商户外部平台notifyKey
            ,notify_url -- 商户外部平台notifyUrl
            ,salesman_serial -- 业务员序列
            ,pre_examine_status -- 初审状态
            ,pre_examine_time -- 初审时间
            ,pre_examine_status_remark -- 初审备注
            ,pre_examine_emp -- 初审人
            ,auth_trade_time -- 授权交易时间
            ,fld_n9 -- 商户月限额
            ,fld_n10 -- 
            ,fld_n11 -- 
            ,fld_n12 -- 
            ,fld_n13 -- 
            ,fld_s9 -- (unionadminMchNo)保存银总商户号
            ,fld_s10 -- 
            ,fld_s11 -- 
            ,fld_s12 -- 
            ,fld_s13 -- 
            ,limit_credit_pay -- 是否允许使用信用卡
            ,credit_pay_pre_limit -- 信用卡单笔限额
            ,credit_pay_day_limit -- 信用卡单日限额
            ,days_kingdee_id -- 得仕商户的金蝶商户号99.开头
            ,days_mrch_no -- 得仕商户的得仕商户号940开头
            ,pcac_status -- 清算协会侧状态
            ,credit_pay_month_limit -- 信用卡单月限额
            ,expand_num -- 拓展人工号
            ,inner_org -- 拓展机构号
            ,jl_mch_no -- 收单机构商户号
            ,jl_protocol_id -- 收单机构协议号
            ,mch_property_extension -- 商户属性扩展
            ,passageway_cost_id -- 通道成本渠道id
            ,other_cost_id -- 其他成本渠道id
            ,register_mch_name -- 商户报备名称
            ,is_signatured -- 是否签约，0：未签约 1：已签约
            ,inviter -- 邀请人
            ,trade_able_hours_begin -- 可交易开始时间
            ,trade_able_hours_end -- 可交易结束时间
            ,reservation_id -- 预约id，长江商业银行需要
            ,first_active -- 首次激活时间
            ,is_open_d0 -- 是否开通小额D0
            ,first_activate_time -- 首次激活时间
            ,union_mch_direct_flag -- 直连pos商户标识 0否 1是 默认为0
            ,is_open_smart_business -- 是否开通智慧经营标识 1-是；2-否
            ,outer_channel_id -- 
            ,xft_flag -- 是否兴付通商户（0-否，1-是）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.merchant_id -- 商户ID.即商户编号
    ,o.auto_id -- 自增ID.自增ID,V3.5的值来自SEQ_CMS_MERCHANT序列（需要注意初始序列值大小）.数据迁移时对应V3的PAY_MCH的ID字段
    ,o.merchant_name -- 商户名称.
    ,o.merchant_type -- 商户类型.大商户-11,普通商户-12,直营商户-13,加盟商户-14
    ,o.mch_deal_type -- 商户经营类型.0:全部;1:实体;2:虚拟
    ,o.fee_type -- 币种.多个币种使用英文逗号分隔
    ,o.channel_id -- 所属渠道.关联渠道表 的 渠道ID (CHANNEL_ID)
    ,o.auth_trade_channel_id -- 授权交易渠道.关联渠道表 的 渠道ID (CHANNEL_ID),对应V3的sign_agent_no字段
    ,o.accept_org_id -- 所属受理机构.关联渠道表 的 渠道ID (CHANNEL_ID)
    ,o.pay_accpet_org -- 支付受理机构.关联渠道表 的 渠道ID (CHANNEL_ID),一般情况下,支付受理机构的值为所属渠道的受理机构;当威富通的某个渠道下的某个商户挂到兴业的某个渠道做支付时,所属渠道为威富通下的渠道,支付受理机构为兴业
    ,o.parent_merchant -- 父商户.大商户、普通商户无父商户.直营商户、加盟商户的父商户为大商户
    ,o.pay_parent_merchant -- 支付父商户.一般情况下,支付父商户和父商户的值相同;当跨父商户的情况下,值为实际支付时指定的父商户值.暂不启用
    ,o.dept_id -- 部门.关联部门表的 DEPT_ID
    ,o.salesman_id -- 业务员ID.关联员工表 的 EMP_ID 字段
    ,o.merchant_detail_id -- 商户详细信息.关联商户详细信息表的 MERCHANT_DETAIL_ID
    ,o.examine_status -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
    ,o.examine_time -- 审核时间.
    ,o.examine_status_remark -- 审核备注.
    ,o.examine_emp -- 审核人.
    ,o.activate_status -- 激活状态.0:未激活;1:激活成功;2:激活失败;3:需再次激活;4:冻结;5:注销;6:解冻
    ,o.activate_time -- 激活时间.
    ,o.activate_status_remark -- 激活备注.
    ,o.activate_emp -- 激活人.
    ,o.sign_key -- 签名key.接口调用时的签名key
    ,o.cover_flag -- 覆盖标识.导入导出时用到该字段;1:可覆盖;2:不可覆盖;3:可覆盖，但不可覆盖所属渠道字段
    ,o.physics_flag -- 物理标识.1:正常;2:删除
    ,o.data_source -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移；12:简易注册
    ,o.remark -- 备注.
    ,o.acc_way -- 结算方式.1：标准；2：提现
    ,o.fld_s1 -- 商户类型中文名
    ,o.fld_s2 -- 商户经营类型中文名
    ,o.fld_s3 -- (storeRemark)门店备注
    ,o.fld_n1 -- (mchPreExamineRank)商户初审等级
    ,o.fld_n2 -- 数值型保留字段2.
    ,o.fld_n3 -- (authTradeChannelSource)授权交易机构的数据来源
    ,o.fld_d1 -- (accWayEffectiveTime)结算方式的生效时间
    ,o.create_user -- 创建用户.
    ,o.create_emp -- 创建人.
    ,o.create_time -- 创建时间.
    ,o.update_time -- 更新时间.
    ,o.out_merchant_id -- 外商户号.
    ,o.pay_channel_id -- 支付渠道ID.
    ,o.merchant_properties -- 商户属性字段，按位使用
    ,o.fld_n4 -- (prepayCenterId)预付卡通道ID
    ,o.fld_n5 -- (mchDailyLimit)商户日限额,以分为单位
    ,o.fld_n6 -- (customAuthTradeSourceType)商户自主授权的来源类型 1-商户平台自主授权 2-后台编辑商户授权
    ,o.fld_n7 -- (merchantBusinessType)商户性质.1-公司商户,2-个体商户
    ,o.fld_n8 -- (merchantBusinessProperty)商户属性.1-网络特约商户,2-实体特约商户,3-实体兼网络特约商户
    ,o.fld_s4 -- (alipayOauthPid)支付宝授权账号
    ,o.fld_s5 -- (unionIndirectPayCenter)银联间联通道列表
    ,o.fld_s6 -- (scenceInfo)用于配置商户的场景信息
    ,o.fld_s7 -- 
    ,o.fld_s8 -- 
    ,o.notify_key -- 商户外部平台notifyKey
    ,o.notify_url -- 商户外部平台notifyUrl
    ,o.salesman_serial -- 业务员序列
    ,o.pre_examine_status -- 初审状态
    ,o.pre_examine_time -- 初审时间
    ,o.pre_examine_status_remark -- 初审备注
    ,o.pre_examine_emp -- 初审人
    ,o.auth_trade_time -- 授权交易时间
    ,o.fld_n9 -- 商户月限额
    ,o.fld_n10 -- 
    ,o.fld_n11 -- 
    ,o.fld_n12 -- 
    ,o.fld_n13 -- 
    ,o.fld_s9 -- (unionadminMchNo)保存银总商户号
    ,o.fld_s10 -- 
    ,o.fld_s11 -- 
    ,o.fld_s12 -- 
    ,o.fld_s13 -- 
    ,o.limit_credit_pay -- 是否允许使用信用卡
    ,o.credit_pay_pre_limit -- 信用卡单笔限额
    ,o.credit_pay_day_limit -- 信用卡单日限额
    ,o.days_kingdee_id -- 得仕商户的金蝶商户号99.开头
    ,o.days_mrch_no -- 得仕商户的得仕商户号940开头
    ,o.pcac_status -- 清算协会侧状态
    ,o.credit_pay_month_limit -- 信用卡单月限额
    ,o.expand_num -- 拓展人工号
    ,o.inner_org -- 拓展机构号
    ,o.jl_mch_no -- 收单机构商户号
    ,o.jl_protocol_id -- 收单机构协议号
    ,o.mch_property_extension -- 商户属性扩展
    ,o.passageway_cost_id -- 通道成本渠道id
    ,o.other_cost_id -- 其他成本渠道id
    ,o.register_mch_name -- 商户报备名称
    ,o.is_signatured -- 是否签约，0：未签约 1：已签约
    ,o.inviter -- 邀请人
    ,o.trade_able_hours_begin -- 可交易开始时间
    ,o.trade_able_hours_end -- 可交易结束时间
    ,o.reservation_id -- 预约id，长江商业银行需要
    ,o.first_active -- 首次激活时间
    ,o.is_open_d0 -- 是否开通小额D0
    ,o.first_activate_time -- 首次激活时间
    ,o.union_mch_direct_flag -- 直连pos商户标识 0否 1是 默认为0
    ,o.is_open_smart_business -- 是否开通智慧经营标识 1-是；2-否
    ,o.outer_channel_id -- 
    ,o.xft_flag -- 是否兴付通商户（0-否，1-是）
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
from ${iol_schema}.amss_cms_merchant_bk o
    left join ${iol_schema}.amss_cms_merchant_op n
        on
            o.merchant_id = n.merchant_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_cms_merchant_cl d
        on
            o.merchant_id = d.merchant_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_cms_merchant;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_cms_merchant') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_cms_merchant drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_cms_merchant add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_cms_merchant exchange partition p_${batch_date} with table ${iol_schema}.amss_cms_merchant_cl;
alter table ${iol_schema}.amss_cms_merchant exchange partition p_20991231 with table ${iol_schema}.amss_cms_merchant_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_cms_merchant to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_merchant_op purge;
drop table ${iol_schema}.amss_cms_merchant_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_cms_merchant_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_cms_merchant',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
