/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_cms_merchant
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_cms_merchant
whenever sqlerror continue none;
drop table ${iol_schema}.amss_cms_merchant purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_merchant(
    merchant_id varchar2(32) -- 商户ID.即商户编号
    ,auto_id number(10,0) -- 自增ID.自增ID,V3.5的值来自SEQ_CMS_MERCHANT序列（需要注意初始序列值大小）.数据迁移时对应V3的PAY_MCH的ID字段
    ,merchant_name varchar2(128) -- 商户名称.
    ,merchant_type number(4,0) -- 商户类型.大商户-11,普通商户-12,直营商户-13,加盟商户-14
    ,mch_deal_type number(4,0) -- 商户经营类型.0:全部;1:实体;2:虚拟
    ,fee_type varchar2(64) -- 币种.多个币种使用英文逗号分隔
    ,channel_id varchar2(32) -- 所属渠道.关联渠道表 的 渠道ID (CHANNEL_ID)
    ,auth_trade_channel_id varchar2(32) -- 授权交易渠道.关联渠道表 的 渠道ID (CHANNEL_ID),对应V3的sign_agent_no字段
    ,accept_org_id varchar2(32) -- 所属受理机构.关联渠道表 的 渠道ID (CHANNEL_ID)
    ,pay_accpet_org varchar2(32) -- 支付受理机构.关联渠道表 的 渠道ID (CHANNEL_ID),一般情况下,支付受理机构的值为所属渠道的受理机构;当威富通的某个渠道下的某个商户挂到兴业的某个渠道做支付时,所属渠道为威富通下的渠道,支付受理机构为兴业
    ,parent_merchant varchar2(32) -- 父商户.大商户、普通商户无父商户.直营商户、加盟商户的父商户为大商户
    ,pay_parent_merchant varchar2(32) -- 支付父商户.一般情况下,支付父商户和父商户的值相同;当跨父商户的情况下,值为实际支付时指定的父商户值.暂不启用
    ,dept_id varchar2(32) -- 部门.关联部门表的 DEPT_ID
    ,salesman_id number(10,0) -- 业务员ID.关联员工表 的 EMP_ID 字段
    ,merchant_detail_id varchar2(32) -- 商户详细信息.关联商户详细信息表的 MERCHANT_DETAIL_ID
    ,examine_status number(4,0) -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
    ,examine_time timestamp -- 审核时间.
    ,examine_status_remark varchar2(256) -- 审核备注.
    ,examine_emp varchar2(32) -- 审核人.
    ,activate_status number(4,0) -- 激活状态.0:未激活;1:激活成功;2:激活失败;3:需再次激活;4:冻结;5:注销;6:解冻
    ,activate_time timestamp -- 激活时间.
    ,activate_status_remark varchar2(256) -- 激活备注.
    ,activate_emp varchar2(32) -- 激活人.
    ,sign_key varchar2(128) -- 签名key.接口调用时的签名key
    ,cover_flag number(4,0) -- 覆盖标识.导入导出时用到该字段;1:可覆盖;2:不可覆盖;3:可覆盖，但不可覆盖所属渠道字段
    ,physics_flag number(4,0) -- 物理标识.1:正常;2:删除
    ,data_source number(4,0) -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移；12:简易注册
    ,remark varchar2(256) -- 备注.
    ,acc_way number(4,0) -- 结算方式.1：标准；2：提现
    ,fld_s1 varchar2(256) -- 商户类型中文名
    ,fld_s2 varchar2(256) -- 商户经营类型中文名
    ,fld_s3 varchar2(256) -- (storeRemark)门店备注
    ,fld_n1 number(10,0) -- (mchPreExamineRank)商户初审等级
    ,fld_n2 number(10,0) -- 数值型保留字段2.
    ,fld_n3 number(10,0) -- (authTradeChannelSource)授权交易机构的数据来源
    ,fld_d1 timestamp -- (accWayEffectiveTime)结算方式的生效时间
    ,create_user number(10,0) -- 创建用户.
    ,create_emp varchar2(32) -- 创建人.
    ,create_time timestamp -- 创建时间.
    ,update_time timestamp -- 更新时间.
    ,out_merchant_id varchar2(64) -- 外商户号.
    ,pay_channel_id varchar2(32) -- 支付渠道ID.
    ,merchant_properties number(10,0) -- 商户属性字段，按位使用
    ,fld_n4 number(10,0) -- (prepayCenterId)预付卡通道ID
    ,fld_n5 number(20,0) -- (mchDailyLimit)商户日限额,以分为单位
    ,fld_n6 number(10,0) -- (customAuthTradeSourceType)商户自主授权的来源类型 1-商户平台自主授权 2-后台编辑商户授权
    ,fld_n7 number(10,0) -- (merchantBusinessType)商户性质.1-公司商户,2-个体商户
    ,fld_n8 number(10,0) -- (merchantBusinessProperty)商户属性.1-网络特约商户,2-实体特约商户,3-实体兼网络特约商户
    ,fld_s4 varchar2(256) -- (alipayOauthPid)支付宝授权账号
    ,fld_s5 varchar2(256) -- (unionIndirectPayCenter)银联间联通道列表
    ,fld_s6 varchar2(256) -- (scenceInfo)用于配置商户的场景信息
    ,fld_s7 varchar2(256) -- 
    ,fld_s8 varchar2(256) -- 
    ,notify_key varchar2(128) -- 商户外部平台notifyKey
    ,notify_url varchar2(4000) -- 商户外部平台notifyUrl
    ,salesman_serial varchar2(32) -- 业务员序列
    ,pre_examine_status number(4,0) -- 初审状态
    ,pre_examine_time timestamp -- 初审时间
    ,pre_examine_status_remark varchar2(256) -- 初审备注
    ,pre_examine_emp varchar2(32) -- 初审人
    ,auth_trade_time timestamp -- 授权交易时间
    ,fld_n9 number(20,0) -- 商户月限额
    ,fld_n10 number(10,0) -- 
    ,fld_n11 number(10,0) -- 
    ,fld_n12 number(10,0) -- 
    ,fld_n13 number(10,0) -- 
    ,fld_s9 varchar2(512) -- (unionadminMchNo)保存银总商户号
    ,fld_s10 varchar2(512) -- 
    ,fld_s11 varchar2(512) -- 
    ,fld_s12 varchar2(512) -- 
    ,fld_s13 varchar2(512) -- 
    ,limit_credit_pay number(4,0) -- 是否允许使用信用卡
    ,credit_pay_pre_limit number(20,0) -- 信用卡单笔限额
    ,credit_pay_day_limit number(20,0) -- 信用卡单日限额
    ,days_kingdee_id varchar2(32) -- 得仕商户的金蝶商户号99.开头
    ,days_mrch_no varchar2(32) -- 得仕商户的得仕商户号940开头
    ,pcac_status number(4,0) -- 清算协会侧状态
    ,credit_pay_month_limit number(20,0) -- 信用卡单月限额
    ,expand_num varchar2(32) -- 拓展人工号
    ,inner_org varchar2(32) -- 拓展机构号
    ,jl_mch_no varchar2(32) -- 收单机构商户号
    ,jl_protocol_id varchar2(64) -- 收单机构协议号
    ,mch_property_extension varchar2(512) -- 商户属性扩展
    ,passageway_cost_id varchar2(32) -- 通道成本渠道id
    ,other_cost_id varchar2(32) -- 其他成本渠道id
    ,register_mch_name varchar2(64) -- 商户报备名称
    ,is_signatured varchar2(1024) -- 是否签约，0：未签约 1：已签约
    ,inviter number(10,0) -- 邀请人
    ,trade_able_hours_begin varchar2(100) -- 可交易开始时间
    ,trade_able_hours_end varchar2(100) -- 可交易结束时间
    ,reservation_id varchar2(32) -- 预约id，长江商业银行需要
    ,first_active date -- 首次激活时间
    ,is_open_d0 varchar2(2) -- 是否开通小额D0
    ,first_activate_time timestamp -- 首次激活时间
    ,union_mch_direct_flag number(1,0) -- 直连pos商户标识 0否 1是 默认为0
    ,is_open_smart_business number(1,0) -- 是否开通智慧经营标识 1-是；2-否
    ,outer_channel_id varchar2(32) -- 
    ,xft_flag number(1,0) -- 是否兴付通商户（0-否，1-是）
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
grant select on ${iol_schema}.amss_cms_merchant to ${iml_schema};
grant select on ${iol_schema}.amss_cms_merchant to ${icl_schema};
grant select on ${iol_schema}.amss_cms_merchant to ${idl_schema};
grant select on ${iol_schema}.amss_cms_merchant to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_cms_merchant is '商户表';
comment on column ${iol_schema}.amss_cms_merchant.merchant_id is '商户ID.即商户编号';
comment on column ${iol_schema}.amss_cms_merchant.auto_id is '自增ID.自增ID,V3.5的值来自SEQ_CMS_MERCHANT序列（需要注意初始序列值大小）.数据迁移时对应V3的PAY_MCH的ID字段';
comment on column ${iol_schema}.amss_cms_merchant.merchant_name is '商户名称.';
comment on column ${iol_schema}.amss_cms_merchant.merchant_type is '商户类型.大商户-11,普通商户-12,直营商户-13,加盟商户-14';
comment on column ${iol_schema}.amss_cms_merchant.mch_deal_type is '商户经营类型.0:全部;1:实体;2:虚拟';
comment on column ${iol_schema}.amss_cms_merchant.fee_type is '币种.多个币种使用英文逗号分隔';
comment on column ${iol_schema}.amss_cms_merchant.channel_id is '所属渠道.关联渠道表 的 渠道ID (CHANNEL_ID)';
comment on column ${iol_schema}.amss_cms_merchant.auth_trade_channel_id is '授权交易渠道.关联渠道表 的 渠道ID (CHANNEL_ID),对应V3的sign_agent_no字段';
comment on column ${iol_schema}.amss_cms_merchant.accept_org_id is '所属受理机构.关联渠道表 的 渠道ID (CHANNEL_ID)';
comment on column ${iol_schema}.amss_cms_merchant.pay_accpet_org is '支付受理机构.关联渠道表 的 渠道ID (CHANNEL_ID),一般情况下,支付受理机构的值为所属渠道的受理机构;当威富通的某个渠道下的某个商户挂到兴业的某个渠道做支付时,所属渠道为威富通下的渠道,支付受理机构为兴业';
comment on column ${iol_schema}.amss_cms_merchant.parent_merchant is '父商户.大商户、普通商户无父商户.直营商户、加盟商户的父商户为大商户';
comment on column ${iol_schema}.amss_cms_merchant.pay_parent_merchant is '支付父商户.一般情况下,支付父商户和父商户的值相同;当跨父商户的情况下,值为实际支付时指定的父商户值.暂不启用';
comment on column ${iol_schema}.amss_cms_merchant.dept_id is '部门.关联部门表的 DEPT_ID';
comment on column ${iol_schema}.amss_cms_merchant.salesman_id is '业务员ID.关联员工表 的 EMP_ID 字段';
comment on column ${iol_schema}.amss_cms_merchant.merchant_detail_id is '商户详细信息.关联商户详细信息表的 MERCHANT_DETAIL_ID';
comment on column ${iol_schema}.amss_cms_merchant.examine_status is '审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核';
comment on column ${iol_schema}.amss_cms_merchant.examine_time is '审核时间.';
comment on column ${iol_schema}.amss_cms_merchant.examine_status_remark is '审核备注.';
comment on column ${iol_schema}.amss_cms_merchant.examine_emp is '审核人.';
comment on column ${iol_schema}.amss_cms_merchant.activate_status is '激活状态.0:未激活;1:激活成功;2:激活失败;3:需再次激活;4:冻结;5:注销;6:解冻';
comment on column ${iol_schema}.amss_cms_merchant.activate_time is '激活时间.';
comment on column ${iol_schema}.amss_cms_merchant.activate_status_remark is '激活备注.';
comment on column ${iol_schema}.amss_cms_merchant.activate_emp is '激活人.';
comment on column ${iol_schema}.amss_cms_merchant.sign_key is '签名key.接口调用时的签名key';
comment on column ${iol_schema}.amss_cms_merchant.cover_flag is '覆盖标识.导入导出时用到该字段;1:可覆盖;2:不可覆盖;3:可覆盖，但不可覆盖所属渠道字段';
comment on column ${iol_schema}.amss_cms_merchant.physics_flag is '物理标识.1:正常;2:删除';
comment on column ${iol_schema}.amss_cms_merchant.data_source is '数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移；12:简易注册';
comment on column ${iol_schema}.amss_cms_merchant.remark is '备注.';
comment on column ${iol_schema}.amss_cms_merchant.acc_way is '结算方式.1：标准；2：提现';
comment on column ${iol_schema}.amss_cms_merchant.fld_s1 is '商户类型中文名';
comment on column ${iol_schema}.amss_cms_merchant.fld_s2 is '商户经营类型中文名';
comment on column ${iol_schema}.amss_cms_merchant.fld_s3 is '(storeRemark)门店备注';
comment on column ${iol_schema}.amss_cms_merchant.fld_n1 is '(mchPreExamineRank)商户初审等级';
comment on column ${iol_schema}.amss_cms_merchant.fld_n2 is '数值型保留字段2.';
comment on column ${iol_schema}.amss_cms_merchant.fld_n3 is '(authTradeChannelSource)授权交易机构的数据来源';
comment on column ${iol_schema}.amss_cms_merchant.fld_d1 is '(accWayEffectiveTime)结算方式的生效时间';
comment on column ${iol_schema}.amss_cms_merchant.create_user is '创建用户.';
comment on column ${iol_schema}.amss_cms_merchant.create_emp is '创建人.';
comment on column ${iol_schema}.amss_cms_merchant.create_time is '创建时间.';
comment on column ${iol_schema}.amss_cms_merchant.update_time is '更新时间.';
comment on column ${iol_schema}.amss_cms_merchant.out_merchant_id is '外商户号.';
comment on column ${iol_schema}.amss_cms_merchant.pay_channel_id is '支付渠道ID.';
comment on column ${iol_schema}.amss_cms_merchant.merchant_properties is '商户属性字段，按位使用';
comment on column ${iol_schema}.amss_cms_merchant.fld_n4 is '(prepayCenterId)预付卡通道ID';
comment on column ${iol_schema}.amss_cms_merchant.fld_n5 is '(mchDailyLimit)商户日限额,以分为单位';
comment on column ${iol_schema}.amss_cms_merchant.fld_n6 is '(customAuthTradeSourceType)商户自主授权的来源类型 1-商户平台自主授权 2-后台编辑商户授权';
comment on column ${iol_schema}.amss_cms_merchant.fld_n7 is '(merchantBusinessType)商户性质.1-公司商户,2-个体商户';
comment on column ${iol_schema}.amss_cms_merchant.fld_n8 is '(merchantBusinessProperty)商户属性.1-网络特约商户,2-实体特约商户,3-实体兼网络特约商户';
comment on column ${iol_schema}.amss_cms_merchant.fld_s4 is '(alipayOauthPid)支付宝授权账号';
comment on column ${iol_schema}.amss_cms_merchant.fld_s5 is '(unionIndirectPayCenter)银联间联通道列表';
comment on column ${iol_schema}.amss_cms_merchant.fld_s6 is '(scenceInfo)用于配置商户的场景信息';
comment on column ${iol_schema}.amss_cms_merchant.fld_s7 is '';
comment on column ${iol_schema}.amss_cms_merchant.fld_s8 is '';
comment on column ${iol_schema}.amss_cms_merchant.notify_key is '商户外部平台notifyKey';
comment on column ${iol_schema}.amss_cms_merchant.notify_url is '商户外部平台notifyUrl';
comment on column ${iol_schema}.amss_cms_merchant.salesman_serial is '业务员序列';
comment on column ${iol_schema}.amss_cms_merchant.pre_examine_status is '初审状态';
comment on column ${iol_schema}.amss_cms_merchant.pre_examine_time is '初审时间';
comment on column ${iol_schema}.amss_cms_merchant.pre_examine_status_remark is '初审备注';
comment on column ${iol_schema}.amss_cms_merchant.pre_examine_emp is '初审人';
comment on column ${iol_schema}.amss_cms_merchant.auth_trade_time is '授权交易时间';
comment on column ${iol_schema}.amss_cms_merchant.fld_n9 is '商户月限额';
comment on column ${iol_schema}.amss_cms_merchant.fld_n10 is '';
comment on column ${iol_schema}.amss_cms_merchant.fld_n11 is '';
comment on column ${iol_schema}.amss_cms_merchant.fld_n12 is '';
comment on column ${iol_schema}.amss_cms_merchant.fld_n13 is '';
comment on column ${iol_schema}.amss_cms_merchant.fld_s9 is '(unionadminMchNo)保存银总商户号';
comment on column ${iol_schema}.amss_cms_merchant.fld_s10 is '';
comment on column ${iol_schema}.amss_cms_merchant.fld_s11 is '';
comment on column ${iol_schema}.amss_cms_merchant.fld_s12 is '';
comment on column ${iol_schema}.amss_cms_merchant.fld_s13 is '';
comment on column ${iol_schema}.amss_cms_merchant.limit_credit_pay is '是否允许使用信用卡';
comment on column ${iol_schema}.amss_cms_merchant.credit_pay_pre_limit is '信用卡单笔限额';
comment on column ${iol_schema}.amss_cms_merchant.credit_pay_day_limit is '信用卡单日限额';
comment on column ${iol_schema}.amss_cms_merchant.days_kingdee_id is '得仕商户的金蝶商户号99.开头';
comment on column ${iol_schema}.amss_cms_merchant.days_mrch_no is '得仕商户的得仕商户号940开头';
comment on column ${iol_schema}.amss_cms_merchant.pcac_status is '清算协会侧状态';
comment on column ${iol_schema}.amss_cms_merchant.credit_pay_month_limit is '信用卡单月限额';
comment on column ${iol_schema}.amss_cms_merchant.expand_num is '拓展人工号';
comment on column ${iol_schema}.amss_cms_merchant.inner_org is '拓展机构号';
comment on column ${iol_schema}.amss_cms_merchant.jl_mch_no is '收单机构商户号';
comment on column ${iol_schema}.amss_cms_merchant.jl_protocol_id is '收单机构协议号';
comment on column ${iol_schema}.amss_cms_merchant.mch_property_extension is '商户属性扩展';
comment on column ${iol_schema}.amss_cms_merchant.passageway_cost_id is '通道成本渠道id';
comment on column ${iol_schema}.amss_cms_merchant.other_cost_id is '其他成本渠道id';
comment on column ${iol_schema}.amss_cms_merchant.register_mch_name is '商户报备名称';
comment on column ${iol_schema}.amss_cms_merchant.is_signatured is '是否签约，0：未签约 1：已签约';
comment on column ${iol_schema}.amss_cms_merchant.inviter is '邀请人';
comment on column ${iol_schema}.amss_cms_merchant.trade_able_hours_begin is '可交易开始时间';
comment on column ${iol_schema}.amss_cms_merchant.trade_able_hours_end is '可交易结束时间';
comment on column ${iol_schema}.amss_cms_merchant.reservation_id is '预约id，长江商业银行需要';
comment on column ${iol_schema}.amss_cms_merchant.first_active is '首次激活时间';
comment on column ${iol_schema}.amss_cms_merchant.is_open_d0 is '是否开通小额D0';
comment on column ${iol_schema}.amss_cms_merchant.first_activate_time is '首次激活时间';
comment on column ${iol_schema}.amss_cms_merchant.union_mch_direct_flag is '直连pos商户标识 0否 1是 默认为0';
comment on column ${iol_schema}.amss_cms_merchant.is_open_smart_business is '是否开通智慧经营标识 1-是；2-否';
comment on column ${iol_schema}.amss_cms_merchant.outer_channel_id is '';
comment on column ${iol_schema}.amss_cms_merchant.xft_flag is '是否兴付通商户（0-否，1-是）';
comment on column ${iol_schema}.amss_cms_merchant.start_dt is '开始时间';
comment on column ${iol_schema}.amss_cms_merchant.end_dt is '结束时间';
comment on column ${iol_schema}.amss_cms_merchant.id_mark is '增删标志';
comment on column ${iol_schema}.amss_cms_merchant.etl_timestamp is 'ETL处理时间戳';
