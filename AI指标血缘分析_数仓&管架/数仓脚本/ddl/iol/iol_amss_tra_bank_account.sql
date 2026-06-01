/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_tra_bank_account
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_tra_bank_account
whenever sqlerror continue none;
drop table ${iol_schema}.amss_tra_bank_account purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_tra_bank_account(
    account_id varchar2(16) -- 账户ID.
    ,org_id varchar2(32) -- 机构ID.对应渠道编号或商户编号
    ,account_code varchar2(128) -- 银行卡号.
    ,bank_id number(10,0) -- 开户银行.关联银行表( CMS_BANK )
    ,account_name varchar2(128) -- 开户人.
    ,account_type number(4,0) -- 帐户类型.1:企业 ;2:个人;5:内部户
    ,contact_line varchar2(64) -- 联行号.网点号、联行号
    ,remit_account_code varchar2(128) -- 汇出方银行卡号.兴业叫汇出方银行卡号，浦发叫现代支付号
    ,is_inline number(1,0) -- 是否行内账号.true:是，false:不是
    ,bank_name varchar2(128) -- 开户支行名称.
    ,province varchar2(16) -- 开户支行所在省.
    ,city varchar2(16) -- 开户支行所在市.
    ,id_card_type number(4,0) -- 持卡人证件类型.从系统类型表来
    ,id_card varchar2(128) -- 持卡人证件号码.
    ,address varchar2(512) -- 持卡人地址.
    ,tel varchar2(64) -- 手机号码.
    ,examine_status number(4,0) -- 审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核
    ,examine_time timestamp -- 审核时间.
    ,examine_status_remark varchar2(256) -- 审核备注.
    ,examine_emp varchar2(32) -- 审核人.
    ,enabled number(1,0) -- 是否启用.
    ,data_sign varchar2(128) -- 数据签名.
    ,data_source number(4,0) -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移
    ,fld_s1 varchar2(256) -- 结算账户的支出户名
    ,fld_s2 varchar2(256) -- 字符型保留字段2.
    ,fld_s3 varchar2(256) -- 字符型保留字段3.
    ,fld_n1 number(10,0) -- 是否收支分离
    ,fld_n2 number(10,0) -- 结算卡审核状态.0:未提交审核,1:提交未审核,2:提交审核未通过,3:提交审核已通过,4:新增未审核
    ,fld_n3 number(10,0) -- 数值型保留字段3.
    ,fld_d1 timestamp -- 日期型保留字段1.
    ,create_user number(10,0) -- 创建用户.
    ,create_emp varchar2(32) -- 创建人.
    ,create_time timestamp -- 创建时间.
    ,update_time timestamp -- 更新时间.
    ,check_auth number(4,0) -- 是否鉴权
    ,e_account_code varchar2(64) -- 电子账户
    ,account_en_name varchar2(64) -- 开户人英文名
    ,account_expired_date date -- 开户人证件有效期
    ,account_postcode varchar2(16) -- 邮编
    ,check_auth3 varchar2(1) -- 3要素实名状态
    ,check_auth4 varchar2(1) -- 4要素实名状态
    ,e_account_enabled number(1,0) -- 是否开启电子账号
    ,sft_merchant_id varchar2(32) -- 盛付通商户号
    ,fee_code varchar2(32) -- 费项代码
    ,fee_code2 varchar2(32) -- 费项代码2
    ,subject_account varchar2(32) -- 科目账号
    ,unit_prop varchar2(4) -- 单位性质
    ,new_account_code varchar2(64) -- 新账号或主账号
    ,account_properties number(10,0) -- 轧差入账属性字段，按位使用
    ,new_remit_account_code varchar2(64) -- 新汇出方卡号
    ,point_payment number(1,0) -- 开通积分支付
    ,points_offer number(5,0) -- 是否积分优惠
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
grant select on ${iol_schema}.amss_tra_bank_account to ${iml_schema};
grant select on ${iol_schema}.amss_tra_bank_account to ${icl_schema};
grant select on ${iol_schema}.amss_tra_bank_account to ${idl_schema};
grant select on ${iol_schema}.amss_tra_bank_account to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_tra_bank_account is '银行结算账户表';
comment on column ${iol_schema}.amss_tra_bank_account.account_id is '账户ID.';
comment on column ${iol_schema}.amss_tra_bank_account.org_id is '机构ID.对应渠道编号或商户编号';
comment on column ${iol_schema}.amss_tra_bank_account.account_code is '银行卡号.';
comment on column ${iol_schema}.amss_tra_bank_account.bank_id is '开户银行.关联银行表( CMS_BANK )';
comment on column ${iol_schema}.amss_tra_bank_account.account_name is '开户人.';
comment on column ${iol_schema}.amss_tra_bank_account.account_type is '帐户类型.1:企业 ;2:个人;5:内部户';
comment on column ${iol_schema}.amss_tra_bank_account.contact_line is '联行号.网点号、联行号';
comment on column ${iol_schema}.amss_tra_bank_account.remit_account_code is '汇出方银行卡号.兴业叫汇出方银行卡号，浦发叫现代支付号';
comment on column ${iol_schema}.amss_tra_bank_account.is_inline is '是否行内账号.true:是，false:不是';
comment on column ${iol_schema}.amss_tra_bank_account.bank_name is '开户支行名称.';
comment on column ${iol_schema}.amss_tra_bank_account.province is '开户支行所在省.';
comment on column ${iol_schema}.amss_tra_bank_account.city is '开户支行所在市.';
comment on column ${iol_schema}.amss_tra_bank_account.id_card_type is '持卡人证件类型.从系统类型表来';
comment on column ${iol_schema}.amss_tra_bank_account.id_card is '持卡人证件号码.';
comment on column ${iol_schema}.amss_tra_bank_account.address is '持卡人地址.';
comment on column ${iol_schema}.amss_tra_bank_account.tel is '手机号码.';
comment on column ${iol_schema}.amss_tra_bank_account.examine_status is '审核状态.0:未审核;1:审核通过;2:审核不通过;3:需再次审核';
comment on column ${iol_schema}.amss_tra_bank_account.examine_time is '审核时间.';
comment on column ${iol_schema}.amss_tra_bank_account.examine_status_remark is '审核备注.';
comment on column ${iol_schema}.amss_tra_bank_account.examine_emp is '审核人.';
comment on column ${iol_schema}.amss_tra_bank_account.enabled is '是否启用.';
comment on column ${iol_schema}.amss_tra_bank_account.data_sign is '数据签名.';
comment on column ${iol_schema}.amss_tra_bank_account.data_source is '数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移';
comment on column ${iol_schema}.amss_tra_bank_account.fld_s1 is '结算账户的支出户名';
comment on column ${iol_schema}.amss_tra_bank_account.fld_s2 is '字符型保留字段2.';
comment on column ${iol_schema}.amss_tra_bank_account.fld_s3 is '字符型保留字段3.';
comment on column ${iol_schema}.amss_tra_bank_account.fld_n1 is '是否收支分离';
comment on column ${iol_schema}.amss_tra_bank_account.fld_n2 is '结算卡审核状态.0:未提交审核,1:提交未审核,2:提交审核未通过,3:提交审核已通过,4:新增未审核';
comment on column ${iol_schema}.amss_tra_bank_account.fld_n3 is '数值型保留字段3.';
comment on column ${iol_schema}.amss_tra_bank_account.fld_d1 is '日期型保留字段1.';
comment on column ${iol_schema}.amss_tra_bank_account.create_user is '创建用户.';
comment on column ${iol_schema}.amss_tra_bank_account.create_emp is '创建人.';
comment on column ${iol_schema}.amss_tra_bank_account.create_time is '创建时间.';
comment on column ${iol_schema}.amss_tra_bank_account.update_time is '更新时间.';
comment on column ${iol_schema}.amss_tra_bank_account.check_auth is '是否鉴权';
comment on column ${iol_schema}.amss_tra_bank_account.e_account_code is '电子账户';
comment on column ${iol_schema}.amss_tra_bank_account.account_en_name is '开户人英文名';
comment on column ${iol_schema}.amss_tra_bank_account.account_expired_date is '开户人证件有效期';
comment on column ${iol_schema}.amss_tra_bank_account.account_postcode is '邮编';
comment on column ${iol_schema}.amss_tra_bank_account.check_auth3 is '3要素实名状态';
comment on column ${iol_schema}.amss_tra_bank_account.check_auth4 is '4要素实名状态';
comment on column ${iol_schema}.amss_tra_bank_account.e_account_enabled is '是否开启电子账号';
comment on column ${iol_schema}.amss_tra_bank_account.sft_merchant_id is '盛付通商户号';
comment on column ${iol_schema}.amss_tra_bank_account.fee_code is '费项代码';
comment on column ${iol_schema}.amss_tra_bank_account.fee_code2 is '费项代码2';
comment on column ${iol_schema}.amss_tra_bank_account.subject_account is '科目账号';
comment on column ${iol_schema}.amss_tra_bank_account.unit_prop is '单位性质';
comment on column ${iol_schema}.amss_tra_bank_account.new_account_code is '新账号或主账号';
comment on column ${iol_schema}.amss_tra_bank_account.account_properties is '轧差入账属性字段，按位使用';
comment on column ${iol_schema}.amss_tra_bank_account.new_remit_account_code is '新汇出方卡号';
comment on column ${iol_schema}.amss_tra_bank_account.point_payment is '开通积分支付';
comment on column ${iol_schema}.amss_tra_bank_account.points_offer is '是否积分优惠';
comment on column ${iol_schema}.amss_tra_bank_account.start_dt is '开始时间';
comment on column ${iol_schema}.amss_tra_bank_account.end_dt is '结束时间';
comment on column ${iol_schema}.amss_tra_bank_account.id_mark is '增删标志';
comment on column ${iol_schema}.amss_tra_bank_account.etl_timestamp is 'ETL处理时间戳';
