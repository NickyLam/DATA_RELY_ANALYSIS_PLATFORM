/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_cms_channel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_cms_channel
whenever sqlerror continue none;
drop table ${iol_schema}.amss_cms_channel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_channel(
    channel_id varchar2(32) -- 渠道ID.即渠道编号
    ,invite_code varchar2(32) -- 渠道邀请码.银行受理机构为该银行在我们系统中的银行英文编码;如兴业总行为CIB.兴业深圳支行为CIB_SZ;渠道为我们分配给该渠道的邀请码.生成规则(银行英文编码+I+6位序列)
    ,channel_name varchar2(255) -- 渠道名称.
    ,channel_type number(4,0) -- 渠道类型.受理机构-1;渠道-2
    ,parent_channel varchar2(32) -- 所属渠道.关联渠道ID，只有受理机构允许为空
    ,pay_accpet_org varchar2(32) -- 支付受理机构.关联渠道表 的 渠道ID (CHANNEL_ID)
    ,channel_properties number(4,0) -- 渠道属性.银行机构-1;外部渠道-2
    ,province varchar2(16) -- 省份.
    ,city varchar2(16) -- 城市.
    ,county varchar2(16) -- 区/县.
    ,address varchar2(256) -- 地址.
    ,tel varchar2(128) -- 电话.
    ,web_site varchar2(128) -- 网址.
    ,principal varchar2(32) -- 负责人.
    ,id_code varchar2(128) -- 负责人身份证.
    ,license_photo varchar2(256) -- 营业执照.
    ,indentity_photo varchar2(256) -- 身份证照片.
    ,other_doc varchar2(2000) -- 其他资料.资料包，以zip和rar格式上传和下载
    ,email varchar2(64) -- 邮箱.
    ,examine_status number(4,0) -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
    ,examine_time timestamp -- 审核时间.
    ,examine_status_remark varchar2(256) -- 审核备注.
    ,examine_emp varchar2(32) -- 审核人.
    ,activate_status number(4,0) -- 激活状态.0:未激活;1:激活成功;2:激活失败;3:需再次激活
    ,activate_time timestamp -- 激活时间.
    ,activate_status_remark varchar2(256) -- 激活备注.
    ,activate_emp varchar2(32) -- 激活人.
    ,sign_key varchar2(128) -- 签名key.接口调用时的签名key
    ,extra_propertes number(4,0) -- 附加属性.1:用于标记大商户的渠道属性
    ,physics_flag number(4,0) -- 物理标识.1:正常;2:删除
    ,data_source number(4,0) -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移；12:简易注册
    ,remark varchar2(256) -- 备注.
    ,acc_way number(4,0) -- 结算方式.1：标准；2：提现
    ,fld_s1 varchar2(256) -- 老平台公有云的渠道ID.老平台公有云的渠道ID
    ,fld_s2 varchar2(256) -- 第三方商户ID.SPAY小商户进件
    ,fld_s3 varchar2(256) -- 第三方APPID.SPAY小商户进件
    ,fld_n1 number(10,0) -- 具体受理机构类型.1：威富通；2：银行受理机构；3：通道受理机构
    ,fld_n2 number(10,0) -- 是否允许快速进件.1-是  0-否 (SPAY小商户进件)
    ,fld_n3 number(10,0) -- (authTradeType)授权子商户交易的类型
    ,fld_d1 timestamp -- 日期型保留字段1.
    ,create_user number(10,0) -- 创建用户.
    ,create_emp varchar2(32) -- 创建人.
    ,create_time timestamp -- 创建时间.
    ,update_time timestamp -- 更新时间.
    ,thr_channel_id varchar2(64) -- 外部渠道号.
    ,advance_side_id number(10,0) -- 垫资方
    ,channel_org_type number(4,0) -- 渠道机构类型.总行-1;分行-2;支行-3
    ,fld_n4 number(10,0) -- (inlineBankId)受理机构的行内银行ID
    ,fld_n5 number(10,0) -- 小商户进件时是否需要审核激活商户,0:需要审核激活(对应商户审核状态：未审核，商户激活状态：未激活),1:不需要审核激活(对应商户审核状态：审核通过，商户激活状态：激活成功)
    ,fld_n6 number(10,0) -- (timeZone)时区
    ,fld_n7 number(10,0) -- (mergeAccount)合并入账
    ,fld_n8 number(10,0) -- (wftOwnCh)是否威富通自有机构.0/null:否,1:是
    ,fld_s4 varchar2(256) -- (notifyKey)通知秘钥
    ,fld_s5 varchar2(256) -- (notifyUrl)通知地址
    ,fld_s6 varchar2(256) -- (agentCode)翼支付机构号
    ,fld_s7 varchar2(256) -- (expenseAccountName)成都农商行支出账号户名
    ,fld_s8 varchar2(256) -- (expenseAccountCode)成都农商行支出账号卡号
    ,advance_quota number(19,0) -- 垫资额度字段
    ,pid_process_state number(4,0) -- pid改变处理状态 0待处理 1处理完成
    ,logo varchar2(512) -- 二受理机构logo图片路径
    ,branch_flag number(4,0) -- 分行标识，0-非分行，1-分行
    ,fld_n9 number(10,0) -- (thiOrgType)数据库机构标识
    ,fld_n10 number(10,0) -- (channelPropertiesExt)渠道扩展属性
    ,fld_n11 number(10,0) -- (channelOwnerShip)渠道归属：1.零售总行,2.企金总行
    ,fld_n12 number(10,0) -- 外包服务机构进件成本费率为0，打上特殊标识1
    ,pay_page_auth_status number(10,0) -- 支付页面授权状态
    ,fld_s9 varchar2(512) -- (orgIdPrefix)受理机构分配的机构号id前三位号段
    ,fld_s10 varchar2(512) -- 
    ,fld_s11 varchar2(512) -- 
    ,fld_s12 varchar2(512) -- 
    ,expand_num varchar2(32) -- 拓展人工号
    ,inner_org varchar2(32) -- 内部机构号
    ,service_provider_id varchar2(128) -- 云闪付服务商id
    ,service_public_key varchar2(1024) -- 云闪付公钥
    ,service_private_key varchar2(2048) -- 云闪付私钥
    ,passageway_cost_id varchar2(32) -- 通道成本渠道id
    ,other_cost_id varchar2(32) -- 其他成本渠道id
    ,id_code_begin_time timestamp -- 负责人证件有效期开始日
    ,business_license_begin_time timestamp -- 营业执照有效期开始日
    ,contacts_idcode varchar2(64) -- 负责人证件号码
    ,business_license_expire timestamp -- 营业执照过期日
    ,business_license varchar2(64) -- 营业执照号
    ,id_code_expire timestamp -- 负责人证件过期日
    ,id_code_type number(10,0) -- 负责人证件类型
    ,cle_org_id varchar2(32) -- 所属清算机构号
    ,account_code_photo varchar2(256) -- 开户许可证
    ,thi_doc_id varchar2(256) -- 第三方文档id
    ,limit_credit_pay number(2,0) -- 信用卡限制：0-限制，1-不限制
    ,bank_channel_id varchar2(32) -- 银行机构号.
    ,wechat_channel_id varchar2(32) -- 微信机构号.
    ,profits_rate number(10,0) -- 分润值.
    ,portal_channel_id varchar2(32) -- 门户机构号
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
grant select on ${iol_schema}.amss_cms_channel to ${iml_schema};
grant select on ${iol_schema}.amss_cms_channel to ${icl_schema};
grant select on ${iol_schema}.amss_cms_channel to ${idl_schema};
grant select on ${iol_schema}.amss_cms_channel to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_cms_channel is '渠道表';
comment on column ${iol_schema}.amss_cms_channel.channel_id is '渠道ID.即渠道编号';
comment on column ${iol_schema}.amss_cms_channel.invite_code is '渠道邀请码.银行受理机构为该银行在我们系统中的银行英文编码;如兴业总行为CIB.兴业深圳支行为CIB_SZ;渠道为我们分配给该渠道的邀请码.生成规则(银行英文编码+I+6位序列)';
comment on column ${iol_schema}.amss_cms_channel.channel_name is '渠道名称.';
comment on column ${iol_schema}.amss_cms_channel.channel_type is '渠道类型.受理机构-1;渠道-2';
comment on column ${iol_schema}.amss_cms_channel.parent_channel is '所属渠道.关联渠道ID，只有受理机构允许为空';
comment on column ${iol_schema}.amss_cms_channel.pay_accpet_org is '支付受理机构.关联渠道表 的 渠道ID (CHANNEL_ID)';
comment on column ${iol_schema}.amss_cms_channel.channel_properties is '渠道属性.银行机构-1;外部渠道-2';
comment on column ${iol_schema}.amss_cms_channel.province is '省份.';
comment on column ${iol_schema}.amss_cms_channel.city is '城市.';
comment on column ${iol_schema}.amss_cms_channel.county is '区/县.';
comment on column ${iol_schema}.amss_cms_channel.address is '地址.';
comment on column ${iol_schema}.amss_cms_channel.tel is '电话.';
comment on column ${iol_schema}.amss_cms_channel.web_site is '网址.';
comment on column ${iol_schema}.amss_cms_channel.principal is '负责人.';
comment on column ${iol_schema}.amss_cms_channel.id_code is '负责人身份证.';
comment on column ${iol_schema}.amss_cms_channel.license_photo is '营业执照.';
comment on column ${iol_schema}.amss_cms_channel.indentity_photo is '身份证照片.';
comment on column ${iol_schema}.amss_cms_channel.other_doc is '其他资料.资料包，以zip和rar格式上传和下载';
comment on column ${iol_schema}.amss_cms_channel.email is '邮箱.';
comment on column ${iol_schema}.amss_cms_channel.examine_status is '审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核';
comment on column ${iol_schema}.amss_cms_channel.examine_time is '审核时间.';
comment on column ${iol_schema}.amss_cms_channel.examine_status_remark is '审核备注.';
comment on column ${iol_schema}.amss_cms_channel.examine_emp is '审核人.';
comment on column ${iol_schema}.amss_cms_channel.activate_status is '激活状态.0:未激活;1:激活成功;2:激活失败;3:需再次激活';
comment on column ${iol_schema}.amss_cms_channel.activate_time is '激活时间.';
comment on column ${iol_schema}.amss_cms_channel.activate_status_remark is '激活备注.';
comment on column ${iol_schema}.amss_cms_channel.activate_emp is '激活人.';
comment on column ${iol_schema}.amss_cms_channel.sign_key is '签名key.接口调用时的签名key';
comment on column ${iol_schema}.amss_cms_channel.extra_propertes is '附加属性.1:用于标记大商户的渠道属性';
comment on column ${iol_schema}.amss_cms_channel.physics_flag is '物理标识.1:正常;2:删除';
comment on column ${iol_schema}.amss_cms_channel.data_source is '数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移；12:简易注册';
comment on column ${iol_schema}.amss_cms_channel.remark is '备注.';
comment on column ${iol_schema}.amss_cms_channel.acc_way is '结算方式.1：标准；2：提现';
comment on column ${iol_schema}.amss_cms_channel.fld_s1 is '老平台公有云的渠道ID.老平台公有云的渠道ID';
comment on column ${iol_schema}.amss_cms_channel.fld_s2 is '第三方商户ID.SPAY小商户进件';
comment on column ${iol_schema}.amss_cms_channel.fld_s3 is '第三方APPID.SPAY小商户进件';
comment on column ${iol_schema}.amss_cms_channel.fld_n1 is '具体受理机构类型.1：威富通；2：银行受理机构；3：通道受理机构';
comment on column ${iol_schema}.amss_cms_channel.fld_n2 is '是否允许快速进件.1-是  0-否 (SPAY小商户进件)';
comment on column ${iol_schema}.amss_cms_channel.fld_n3 is '(authTradeType)授权子商户交易的类型';
comment on column ${iol_schema}.amss_cms_channel.fld_d1 is '日期型保留字段1.';
comment on column ${iol_schema}.amss_cms_channel.create_user is '创建用户.';
comment on column ${iol_schema}.amss_cms_channel.create_emp is '创建人.';
comment on column ${iol_schema}.amss_cms_channel.create_time is '创建时间.';
comment on column ${iol_schema}.amss_cms_channel.update_time is '更新时间.';
comment on column ${iol_schema}.amss_cms_channel.thr_channel_id is '外部渠道号.';
comment on column ${iol_schema}.amss_cms_channel.advance_side_id is '垫资方';
comment on column ${iol_schema}.amss_cms_channel.channel_org_type is '渠道机构类型.总行-1;分行-2;支行-3';
comment on column ${iol_schema}.amss_cms_channel.fld_n4 is '(inlineBankId)受理机构的行内银行ID';
comment on column ${iol_schema}.amss_cms_channel.fld_n5 is '小商户进件时是否需要审核激活商户,0:需要审核激活(对应商户审核状态：未审核，商户激活状态：未激活),1:不需要审核激活(对应商户审核状态：审核通过，商户激活状态：激活成功)';
comment on column ${iol_schema}.amss_cms_channel.fld_n6 is '(timeZone)时区';
comment on column ${iol_schema}.amss_cms_channel.fld_n7 is '(mergeAccount)合并入账';
comment on column ${iol_schema}.amss_cms_channel.fld_n8 is '(wftOwnCh)是否威富通自有机构.0/null:否,1:是';
comment on column ${iol_schema}.amss_cms_channel.fld_s4 is '(notifyKey)通知秘钥';
comment on column ${iol_schema}.amss_cms_channel.fld_s5 is '(notifyUrl)通知地址';
comment on column ${iol_schema}.amss_cms_channel.fld_s6 is '(agentCode)翼支付机构号';
comment on column ${iol_schema}.amss_cms_channel.fld_s7 is '(expenseAccountName)成都农商行支出账号户名';
comment on column ${iol_schema}.amss_cms_channel.fld_s8 is '(expenseAccountCode)成都农商行支出账号卡号';
comment on column ${iol_schema}.amss_cms_channel.advance_quota is '垫资额度字段';
comment on column ${iol_schema}.amss_cms_channel.pid_process_state is 'pid改变处理状态 0待处理 1处理完成';
comment on column ${iol_schema}.amss_cms_channel.logo is '二受理机构logo图片路径';
comment on column ${iol_schema}.amss_cms_channel.branch_flag is '分行标识，0-非分行，1-分行';
comment on column ${iol_schema}.amss_cms_channel.fld_n9 is '(thiOrgType)数据库机构标识';
comment on column ${iol_schema}.amss_cms_channel.fld_n10 is '(channelPropertiesExt)渠道扩展属性';
comment on column ${iol_schema}.amss_cms_channel.fld_n11 is '(channelOwnerShip)渠道归属：1.零售总行,2.企金总行';
comment on column ${iol_schema}.amss_cms_channel.fld_n12 is '外包服务机构进件成本费率为0，打上特殊标识1';
comment on column ${iol_schema}.amss_cms_channel.pay_page_auth_status is '支付页面授权状态';
comment on column ${iol_schema}.amss_cms_channel.fld_s9 is '(orgIdPrefix)受理机构分配的机构号id前三位号段';
comment on column ${iol_schema}.amss_cms_channel.fld_s10 is '';
comment on column ${iol_schema}.amss_cms_channel.fld_s11 is '';
comment on column ${iol_schema}.amss_cms_channel.fld_s12 is '';
comment on column ${iol_schema}.amss_cms_channel.expand_num is '拓展人工号';
comment on column ${iol_schema}.amss_cms_channel.inner_org is '内部机构号';
comment on column ${iol_schema}.amss_cms_channel.service_provider_id is '云闪付服务商id';
comment on column ${iol_schema}.amss_cms_channel.service_public_key is '云闪付公钥';
comment on column ${iol_schema}.amss_cms_channel.service_private_key is '云闪付私钥';
comment on column ${iol_schema}.amss_cms_channel.passageway_cost_id is '通道成本渠道id';
comment on column ${iol_schema}.amss_cms_channel.other_cost_id is '其他成本渠道id';
comment on column ${iol_schema}.amss_cms_channel.id_code_begin_time is '负责人证件有效期开始日';
comment on column ${iol_schema}.amss_cms_channel.business_license_begin_time is '营业执照有效期开始日';
comment on column ${iol_schema}.amss_cms_channel.contacts_idcode is '负责人证件号码';
comment on column ${iol_schema}.amss_cms_channel.business_license_expire is '营业执照过期日';
comment on column ${iol_schema}.amss_cms_channel.business_license is '营业执照号';
comment on column ${iol_schema}.amss_cms_channel.id_code_expire is '负责人证件过期日';
comment on column ${iol_schema}.amss_cms_channel.id_code_type is '负责人证件类型';
comment on column ${iol_schema}.amss_cms_channel.cle_org_id is '所属清算机构号';
comment on column ${iol_schema}.amss_cms_channel.account_code_photo is '开户许可证';
comment on column ${iol_schema}.amss_cms_channel.thi_doc_id is '第三方文档id';
comment on column ${iol_schema}.amss_cms_channel.limit_credit_pay is '信用卡限制：0-限制，1-不限制';
comment on column ${iol_schema}.amss_cms_channel.bank_channel_id is '银行机构号.';
comment on column ${iol_schema}.amss_cms_channel.wechat_channel_id is '微信机构号.';
comment on column ${iol_schema}.amss_cms_channel.profits_rate is '分润值.';
comment on column ${iol_schema}.amss_cms_channel.portal_channel_id is '门户机构号';
comment on column ${iol_schema}.amss_cms_channel.start_dt is '开始时间';
comment on column ${iol_schema}.amss_cms_channel.end_dt is '结束时间';
comment on column ${iol_schema}.amss_cms_channel.id_mark is '增删标志';
comment on column ${iol_schema}.amss_cms_channel.etl_timestamp is 'ETL处理时间戳';
