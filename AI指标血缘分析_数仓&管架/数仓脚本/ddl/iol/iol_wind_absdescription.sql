/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_absdescription
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_absdescription
whenever sqlerror continue none;
drop table ${iol_schema}.wind_absdescription purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_absdescription(
    abs_name varchar2(300) -- 项目名称
    ,abs_shortname varchar2(300) -- 项目简称
    ,sponor varchar2(300) -- 发起机构
    ,sponorid varchar2(60) -- 发起机构id
    ,issuer varchar2(300) -- 发行人
    ,issuerid varchar2(60) -- 发行人id
    ,issueamount number(24,8) -- 发行总额(万)
    ,crncy_code varchar2(15) -- 货币代码
    ,pool_name varchar2(300) -- 资产池名称
    ,start_dt_ora varchar2(12) -- 初始起算日
    ,asset_type number(9,0) -- 基础资产类型代码
    ,delivery_dt varchar2(12) -- 交割日
    ,setup_dt varchar2(12) -- 信托成立日
    ,first_pay_dt varchar2(12) -- 首个本息兑付日
    ,maturity_dt varchar2(12) -- 法定到期日
    ,ann_dt varchar2(12) -- 发行公告日
    ,abs_asset varchar2(3000) -- 基础资产
    ,abs_block_code number(9,0) -- 资产支持证券分档代码
    ,is_internal_credit number(1,0) -- 是否有内部信用增级
    ,is_external_credit number(1,0) -- 是否有外部信用增级
    ,assets_is_table number(1,0) -- 资产是否出表
    ,abs_id varchar2(15) -- 项目ID
    ,act_maturity_dt varchar2(12) -- 实际到期日
    ,start_date varchar2(12) -- 清算开始日
    ,end_date varchar2(12) -- 清算结束日
    ,assetout_status number(9,0) -- 资产出表情形
    ,b_info_issuenumber varchar2(150) -- 发行期号
    ,country_code varchar2(15) -- 国家代码
    ,first_payment_period_deadline varchar2(12) -- 首个收款期截止日
    ,end_of_payment_period varchar2(12) -- 最末收款期截止日
    ,pay_frequency varchar2(30) -- 偿付频率
    ,whether_reinvest number(1,0) -- 是否循环购买
    ,start_time varchar2(12) -- 循环期开始时间
    ,end_time_of_cycle varchar2(12) -- 循环期结束时间
    ,the_endtime_of_the_stall varchar2(12) -- 摊还期结束时间
    ,revolving_period_frequency varchar2(30) -- 循环期付息频率
    ,balanced_interest_frequency varchar2(30) -- 摊还期付息频率
    ,basicassets_indirectissuedcode number(9,0) -- 基础资产间接发行通道类型代码
    ,underlying_asset_subdivided varchar2(150) -- 基础资产细分
    ,b_abs_paywaycode number(9,0) -- 支付日推算方法类型代码
    ,b_abs_payway varchar2(1500) -- 支付日推算
    ,abs_payment_inference_day number(9,0) -- 资产支持证券付息推断日
    ,b_abs_interestperioddirection number(9,0) -- 计息区间包闭方式
    ,first_computing_day varchar2(12) -- 首个计算日
    ,calculation_method_type_code number(20,0) -- 计算日计算方法类型代码
    ,calculate_day_shift number(20,0) -- 计算日偏移量
    ,calculatemonthlfrequency_code number(20,0) -- 计算月频率代码
    ,storagerackproject_number number(20,0) -- 储架项目编号
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
grant select on ${iol_schema}.wind_absdescription to ${iml_schema};
grant select on ${iol_schema}.wind_absdescription to ${icl_schema};
grant select on ${iol_schema}.wind_absdescription to ${idl_schema};
grant select on ${iol_schema}.wind_absdescription to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_absdescription is '资产支持证券基本资料';
comment on column ${iol_schema}.wind_absdescription.abs_name is '项目名称';
comment on column ${iol_schema}.wind_absdescription.abs_shortname is '项目简称';
comment on column ${iol_schema}.wind_absdescription.sponor is '发起机构';
comment on column ${iol_schema}.wind_absdescription.sponorid is '发起机构id';
comment on column ${iol_schema}.wind_absdescription.issuer is '发行人';
comment on column ${iol_schema}.wind_absdescription.issuerid is '发行人id';
comment on column ${iol_schema}.wind_absdescription.issueamount is '发行总额(万)';
comment on column ${iol_schema}.wind_absdescription.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_absdescription.pool_name is '资产池名称';
comment on column ${iol_schema}.wind_absdescription.start_dt_ora is '初始起算日';
comment on column ${iol_schema}.wind_absdescription.asset_type is '基础资产类型代码';
comment on column ${iol_schema}.wind_absdescription.delivery_dt is '交割日';
comment on column ${iol_schema}.wind_absdescription.setup_dt is '信托成立日';
comment on column ${iol_schema}.wind_absdescription.first_pay_dt is '首个本息兑付日';
comment on column ${iol_schema}.wind_absdescription.maturity_dt is '法定到期日';
comment on column ${iol_schema}.wind_absdescription.ann_dt is '发行公告日';
comment on column ${iol_schema}.wind_absdescription.abs_asset is '基础资产';
comment on column ${iol_schema}.wind_absdescription.abs_block_code is '资产支持证券分档代码';
comment on column ${iol_schema}.wind_absdescription.is_internal_credit is '是否有内部信用增级';
comment on column ${iol_schema}.wind_absdescription.is_external_credit is '是否有外部信用增级';
comment on column ${iol_schema}.wind_absdescription.assets_is_table is '资产是否出表';
comment on column ${iol_schema}.wind_absdescription.abs_id is '项目ID';
comment on column ${iol_schema}.wind_absdescription.act_maturity_dt is '实际到期日';
comment on column ${iol_schema}.wind_absdescription.start_date is '清算开始日';
comment on column ${iol_schema}.wind_absdescription.end_date is '清算结束日';
comment on column ${iol_schema}.wind_absdescription.assetout_status is '资产出表情形';
comment on column ${iol_schema}.wind_absdescription.b_info_issuenumber is '发行期号';
comment on column ${iol_schema}.wind_absdescription.country_code is '国家代码';
comment on column ${iol_schema}.wind_absdescription.first_payment_period_deadline is '首个收款期截止日';
comment on column ${iol_schema}.wind_absdescription.end_of_payment_period is '最末收款期截止日';
comment on column ${iol_schema}.wind_absdescription.pay_frequency is '偿付频率';
comment on column ${iol_schema}.wind_absdescription.whether_reinvest is '是否循环购买';
comment on column ${iol_schema}.wind_absdescription.start_time is '循环期开始时间';
comment on column ${iol_schema}.wind_absdescription.end_time_of_cycle is '循环期结束时间';
comment on column ${iol_schema}.wind_absdescription.the_endtime_of_the_stall is '摊还期结束时间';
comment on column ${iol_schema}.wind_absdescription.revolving_period_frequency is '循环期付息频率';
comment on column ${iol_schema}.wind_absdescription.balanced_interest_frequency is '摊还期付息频率';
comment on column ${iol_schema}.wind_absdescription.basicassets_indirectissuedcode is '基础资产间接发行通道类型代码';
comment on column ${iol_schema}.wind_absdescription.underlying_asset_subdivided is '基础资产细分';
comment on column ${iol_schema}.wind_absdescription.b_abs_paywaycode is '支付日推算方法类型代码';
comment on column ${iol_schema}.wind_absdescription.b_abs_payway is '支付日推算';
comment on column ${iol_schema}.wind_absdescription.abs_payment_inference_day is '资产支持证券付息推断日';
comment on column ${iol_schema}.wind_absdescription.b_abs_interestperioddirection is '计息区间包闭方式';
comment on column ${iol_schema}.wind_absdescription.first_computing_day is '首个计算日';
comment on column ${iol_schema}.wind_absdescription.calculation_method_type_code is '计算日计算方法类型代码';
comment on column ${iol_schema}.wind_absdescription.calculate_day_shift is '计算日偏移量';
comment on column ${iol_schema}.wind_absdescription.calculatemonthlfrequency_code is '计算月频率代码';
comment on column ${iol_schema}.wind_absdescription.storagerackproject_number is '储架项目编号';
comment on column ${iol_schema}.wind_absdescription.start_dt is '开始时间';
comment on column ${iol_schema}.wind_absdescription.end_dt is '结束时间';
comment on column ${iol_schema}.wind_absdescription.id_mark is '增删标志';
comment on column ${iol_schema}.wind_absdescription.etl_timestamp is 'ETL处理时间戳';
