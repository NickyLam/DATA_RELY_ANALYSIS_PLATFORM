/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_crmwdescription
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_crmwdescription
whenever sqlerror continue none;
drop table ${iol_schema}.wind_crmwdescription purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_crmwdescription(
    object_id varchar2(57) -- 对象ID
    ,b_info_windcode varchar2(60) -- Wind代码
    ,b_create_fullname varchar2(150) -- 凭证全称
    ,b_create_name varchar2(120) -- 创设机构名称
    ,b_create_nameid varchar2(15) -- 创设机构ID
    ,filenum varchar2(120) -- 创设批准文件编号
    ,b_create_ann_date varchar2(15) -- 创设公告日
    ,b_create_object number(9,0) -- 发行对象代码
    ,b_create_price number(20,4) -- 凭证创设价格
    ,b_create_amountplan number(20,6) -- 计划创设总额
    ,b_create_amountact number(20,6) -- 实际创设总额
    ,b_create_firstissue varchar2(12) -- 簿记建档日
    ,b_registration_date varchar2(12) -- 凭证登记日
    ,b_create_start_day varchar2(12) -- 凭证起始日
    ,b_create_end_day varchar2(12) -- 凭证到期日
    ,b_create_term_day number(20,4) -- 凭证期限
    ,b_create_payment_code number(9,0) -- 付费方式代码
    ,b_cgross_principal_amount number(20,6) -- 名义本金总额
    ,is_guarantee number(1,0) -- 是否担保
    ,b_cgross_settlement_code number(9,0) -- 结算方式代码
    ,b_voucher_code number(9,0) -- 凭证类别代码
    ,b_security_code number(9,0) -- 履约保障机制代码
    ,b_unit_nominal_capital number(20,4) -- 单位名义本金
    ,b_create_cancellation_day varchar2(12) -- 凭证注销日
    ,b_info_compcode varchar2(15) -- 参考实体公司id
    ,b_create_debt_type varchar2(300) -- 债务种类
    ,b_create_debt_features varchar2(300) -- 债务特征
    ,b_info_code varchar2(150) -- 可交付债务证券id
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
grant select on ${iol_schema}.wind_crmwdescription to ${iml_schema};
grant select on ${iol_schema}.wind_crmwdescription to ${icl_schema};
grant select on ${iol_schema}.wind_crmwdescription to ${idl_schema};
grant select on ${iol_schema}.wind_crmwdescription to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_crmwdescription is '信用风险缓释工具基本情况';
comment on column ${iol_schema}.wind_crmwdescription.object_id is '对象ID';
comment on column ${iol_schema}.wind_crmwdescription.b_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_crmwdescription.b_create_fullname is '凭证全称';
comment on column ${iol_schema}.wind_crmwdescription.b_create_name is '创设机构名称';
comment on column ${iol_schema}.wind_crmwdescription.b_create_nameid is '创设机构ID';
comment on column ${iol_schema}.wind_crmwdescription.filenum is '创设批准文件编号';
comment on column ${iol_schema}.wind_crmwdescription.b_create_ann_date is '创设公告日';
comment on column ${iol_schema}.wind_crmwdescription.b_create_object is '发行对象代码';
comment on column ${iol_schema}.wind_crmwdescription.b_create_price is '凭证创设价格';
comment on column ${iol_schema}.wind_crmwdescription.b_create_amountplan is '计划创设总额';
comment on column ${iol_schema}.wind_crmwdescription.b_create_amountact is '实际创设总额';
comment on column ${iol_schema}.wind_crmwdescription.b_create_firstissue is '簿记建档日';
comment on column ${iol_schema}.wind_crmwdescription.b_registration_date is '凭证登记日';
comment on column ${iol_schema}.wind_crmwdescription.b_create_start_day is '凭证起始日';
comment on column ${iol_schema}.wind_crmwdescription.b_create_end_day is '凭证到期日';
comment on column ${iol_schema}.wind_crmwdescription.b_create_term_day is '凭证期限';
comment on column ${iol_schema}.wind_crmwdescription.b_create_payment_code is '付费方式代码';
comment on column ${iol_schema}.wind_crmwdescription.b_cgross_principal_amount is '名义本金总额';
comment on column ${iol_schema}.wind_crmwdescription.is_guarantee is '是否担保';
comment on column ${iol_schema}.wind_crmwdescription.b_cgross_settlement_code is '结算方式代码';
comment on column ${iol_schema}.wind_crmwdescription.b_voucher_code is '凭证类别代码';
comment on column ${iol_schema}.wind_crmwdescription.b_security_code is '履约保障机制代码';
comment on column ${iol_schema}.wind_crmwdescription.b_unit_nominal_capital is '单位名义本金';
comment on column ${iol_schema}.wind_crmwdescription.b_create_cancellation_day is '凭证注销日';
comment on column ${iol_schema}.wind_crmwdescription.b_info_compcode is '参考实体公司id';
comment on column ${iol_schema}.wind_crmwdescription.b_create_debt_type is '债务种类';
comment on column ${iol_schema}.wind_crmwdescription.b_create_debt_features is '债务特征';
comment on column ${iol_schema}.wind_crmwdescription.b_info_code is '可交付债务证券id';
comment on column ${iol_schema}.wind_crmwdescription.start_dt is '开始时间';
comment on column ${iol_schema}.wind_crmwdescription.end_dt is '结束时间';
comment on column ${iol_schema}.wind_crmwdescription.id_mark is '增删标志';
comment on column ${iol_schema}.wind_crmwdescription.etl_timestamp is 'ETL处理时间戳';
