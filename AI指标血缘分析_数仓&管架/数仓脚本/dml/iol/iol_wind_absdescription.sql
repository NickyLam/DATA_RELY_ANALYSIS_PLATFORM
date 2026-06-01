/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_absdescription
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
create table ${iol_schema}.wind_absdescription_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_absdescription
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_absdescription_op purge;
drop table ${iol_schema}.wind_absdescription_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_absdescription_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_absdescription where 0=1;

create table ${iol_schema}.wind_absdescription_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_absdescription where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_absdescription_cl(
            abs_name -- 项目名称
            ,abs_shortname -- 项目简称
            ,sponor -- 发起机构
            ,sponorid -- 发起机构id
            ,issuer -- 发行人
            ,issuerid -- 发行人id
            ,issueamount -- 发行总额(万)
            ,crncy_code -- 货币代码
            ,pool_name -- 资产池名称
            ,start_dt_ora -- 初始起算日
            ,asset_type -- 基础资产类型代码
            ,delivery_dt -- 交割日
            ,setup_dt -- 信托成立日
            ,first_pay_dt -- 首个本息兑付日
            ,maturity_dt -- 法定到期日
            ,ann_dt -- 发行公告日
            ,abs_asset -- 基础资产
            ,abs_block_code -- 资产支持证券分档代码
            ,is_internal_credit -- 是否有内部信用增级
            ,is_external_credit -- 是否有外部信用增级
            ,assets_is_table -- 资产是否出表
            ,abs_id -- 项目ID
            ,act_maturity_dt -- 实际到期日
            ,start_date -- 清算开始日
            ,end_date -- 清算结束日
            ,assetout_status -- 资产出表情形
            ,b_info_issuenumber -- 发行期号
            ,country_code -- 国家代码
            ,first_payment_period_deadline -- 首个收款期截止日
            ,end_of_payment_period -- 最末收款期截止日
            ,pay_frequency -- 偿付频率
            ,whether_reinvest -- 是否循环购买
            ,start_time -- 循环期开始时间
            ,end_time_of_cycle -- 循环期结束时间
            ,the_endtime_of_the_stall -- 摊还期结束时间
            ,revolving_period_frequency -- 循环期付息频率
            ,balanced_interest_frequency -- 摊还期付息频率
            ,basicassets_indirectissuedcode -- 基础资产间接发行通道类型代码
            ,underlying_asset_subdivided -- 基础资产细分
            ,b_abs_paywaycode -- 支付日推算方法类型代码
            ,b_abs_payway -- 支付日推算
            ,abs_payment_inference_day -- 资产支持证券付息推断日
            ,b_abs_interestperioddirection -- 计息区间包闭方式
            ,first_computing_day -- 首个计算日
            ,calculation_method_type_code -- 计算日计算方法类型代码
            ,calculate_day_shift -- 计算日偏移量
            ,calculatemonthlfrequency_code -- 计算月频率代码
            ,storagerackproject_number -- 储架项目编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_absdescription_op(
            abs_name -- 项目名称
            ,abs_shortname -- 项目简称
            ,sponor -- 发起机构
            ,sponorid -- 发起机构id
            ,issuer -- 发行人
            ,issuerid -- 发行人id
            ,issueamount -- 发行总额(万)
            ,crncy_code -- 货币代码
            ,pool_name -- 资产池名称
            ,start_dt_ora -- 初始起算日
            ,asset_type -- 基础资产类型代码
            ,delivery_dt -- 交割日
            ,setup_dt -- 信托成立日
            ,first_pay_dt -- 首个本息兑付日
            ,maturity_dt -- 法定到期日
            ,ann_dt -- 发行公告日
            ,abs_asset -- 基础资产
            ,abs_block_code -- 资产支持证券分档代码
            ,is_internal_credit -- 是否有内部信用增级
            ,is_external_credit -- 是否有外部信用增级
            ,assets_is_table -- 资产是否出表
            ,abs_id -- 项目ID
            ,act_maturity_dt -- 实际到期日
            ,start_date -- 清算开始日
            ,end_date -- 清算结束日
            ,assetout_status -- 资产出表情形
            ,b_info_issuenumber -- 发行期号
            ,country_code -- 国家代码
            ,first_payment_period_deadline -- 首个收款期截止日
            ,end_of_payment_period -- 最末收款期截止日
            ,pay_frequency -- 偿付频率
            ,whether_reinvest -- 是否循环购买
            ,start_time -- 循环期开始时间
            ,end_time_of_cycle -- 循环期结束时间
            ,the_endtime_of_the_stall -- 摊还期结束时间
            ,revolving_period_frequency -- 循环期付息频率
            ,balanced_interest_frequency -- 摊还期付息频率
            ,basicassets_indirectissuedcode -- 基础资产间接发行通道类型代码
            ,underlying_asset_subdivided -- 基础资产细分
            ,b_abs_paywaycode -- 支付日推算方法类型代码
            ,b_abs_payway -- 支付日推算
            ,abs_payment_inference_day -- 资产支持证券付息推断日
            ,b_abs_interestperioddirection -- 计息区间包闭方式
            ,first_computing_day -- 首个计算日
            ,calculation_method_type_code -- 计算日计算方法类型代码
            ,calculate_day_shift -- 计算日偏移量
            ,calculatemonthlfrequency_code -- 计算月频率代码
            ,storagerackproject_number -- 储架项目编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.abs_name, o.abs_name) as abs_name -- 项目名称
    ,nvl(n.abs_shortname, o.abs_shortname) as abs_shortname -- 项目简称
    ,nvl(n.sponor, o.sponor) as sponor -- 发起机构
    ,nvl(n.sponorid, o.sponorid) as sponorid -- 发起机构id
    ,nvl(n.issuer, o.issuer) as issuer -- 发行人
    ,nvl(n.issuerid, o.issuerid) as issuerid -- 发行人id
    ,nvl(n.issueamount, o.issueamount) as issueamount -- 发行总额(万)
    ,nvl(n.crncy_code, o.crncy_code) as crncy_code -- 货币代码
    ,nvl(n.pool_name, o.pool_name) as pool_name -- 资产池名称
    ,nvl(n.start_dt_ora, o.start_dt_ora) as start_dt_ora -- 初始起算日
    ,nvl(n.asset_type, o.asset_type) as asset_type -- 基础资产类型代码
    ,nvl(n.delivery_dt, o.delivery_dt) as delivery_dt -- 交割日
    ,nvl(n.setup_dt, o.setup_dt) as setup_dt -- 信托成立日
    ,nvl(n.first_pay_dt, o.first_pay_dt) as first_pay_dt -- 首个本息兑付日
    ,nvl(n.maturity_dt, o.maturity_dt) as maturity_dt -- 法定到期日
    ,nvl(n.ann_dt, o.ann_dt) as ann_dt -- 发行公告日
    ,nvl(n.abs_asset, o.abs_asset) as abs_asset -- 基础资产
    ,nvl(n.abs_block_code, o.abs_block_code) as abs_block_code -- 资产支持证券分档代码
    ,nvl(n.is_internal_credit, o.is_internal_credit) as is_internal_credit -- 是否有内部信用增级
    ,nvl(n.is_external_credit, o.is_external_credit) as is_external_credit -- 是否有外部信用增级
    ,nvl(n.assets_is_table, o.assets_is_table) as assets_is_table -- 资产是否出表
    ,nvl(n.abs_id, o.abs_id) as abs_id -- 项目ID
    ,nvl(n.act_maturity_dt, o.act_maturity_dt) as act_maturity_dt -- 实际到期日
    ,nvl(n.start_date, o.start_date) as start_date -- 清算开始日
    ,nvl(n.end_date, o.end_date) as end_date -- 清算结束日
    ,nvl(n.assetout_status, o.assetout_status) as assetout_status -- 资产出表情形
    ,nvl(n.b_info_issuenumber, o.b_info_issuenumber) as b_info_issuenumber -- 发行期号
    ,nvl(n.country_code, o.country_code) as country_code -- 国家代码
    ,nvl(n.first_payment_period_deadline, o.first_payment_period_deadline) as first_payment_period_deadline -- 首个收款期截止日
    ,nvl(n.end_of_payment_period, o.end_of_payment_period) as end_of_payment_period -- 最末收款期截止日
    ,nvl(n.pay_frequency, o.pay_frequency) as pay_frequency -- 偿付频率
    ,nvl(n.whether_reinvest, o.whether_reinvest) as whether_reinvest -- 是否循环购买
    ,nvl(n.start_time, o.start_time) as start_time -- 循环期开始时间
    ,nvl(n.end_time_of_cycle, o.end_time_of_cycle) as end_time_of_cycle -- 循环期结束时间
    ,nvl(n.the_endtime_of_the_stall, o.the_endtime_of_the_stall) as the_endtime_of_the_stall -- 摊还期结束时间
    ,nvl(n.revolving_period_frequency, o.revolving_period_frequency) as revolving_period_frequency -- 循环期付息频率
    ,nvl(n.balanced_interest_frequency, o.balanced_interest_frequency) as balanced_interest_frequency -- 摊还期付息频率
    ,nvl(n.basicassets_indirectissuedcode, o.basicassets_indirectissuedcode) as basicassets_indirectissuedcode -- 基础资产间接发行通道类型代码
    ,nvl(n.underlying_asset_subdivided, o.underlying_asset_subdivided) as underlying_asset_subdivided -- 基础资产细分
    ,nvl(n.b_abs_paywaycode, o.b_abs_paywaycode) as b_abs_paywaycode -- 支付日推算方法类型代码
    ,nvl(n.b_abs_payway, o.b_abs_payway) as b_abs_payway -- 支付日推算
    ,nvl(n.abs_payment_inference_day, o.abs_payment_inference_day) as abs_payment_inference_day -- 资产支持证券付息推断日
    ,nvl(n.b_abs_interestperioddirection, o.b_abs_interestperioddirection) as b_abs_interestperioddirection -- 计息区间包闭方式
    ,nvl(n.first_computing_day, o.first_computing_day) as first_computing_day -- 首个计算日
    ,nvl(n.calculation_method_type_code, o.calculation_method_type_code) as calculation_method_type_code -- 计算日计算方法类型代码
    ,nvl(n.calculate_day_shift, o.calculate_day_shift) as calculate_day_shift -- 计算日偏移量
    ,nvl(n.calculatemonthlfrequency_code, o.calculatemonthlfrequency_code) as calculatemonthlfrequency_code -- 计算月频率代码
    ,nvl(n.storagerackproject_number, o.storagerackproject_number) as storagerackproject_number -- 储架项目编号
    ,case when
            n.abs_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.abs_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.abs_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_absdescription_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wind_absdescription where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.abs_id = n.abs_id
where (
        o.abs_id is null
    )
    or (
        n.abs_id is null
    )
    or (
        o.abs_name <> n.abs_name
        or o.abs_shortname <> n.abs_shortname
        or o.sponor <> n.sponor
        or o.sponorid <> n.sponorid
        or o.issuer <> n.issuer
        or o.issuerid <> n.issuerid
        or o.issueamount <> n.issueamount
        or o.crncy_code <> n.crncy_code
        or o.pool_name <> n.pool_name
        or o.start_dt_ora <> n.start_dt_ora
        or o.asset_type <> n.asset_type
        or o.delivery_dt <> n.delivery_dt
        or o.setup_dt <> n.setup_dt
        or o.first_pay_dt <> n.first_pay_dt
        or o.maturity_dt <> n.maturity_dt
        or o.ann_dt <> n.ann_dt
        or o.abs_asset <> n.abs_asset
        or o.abs_block_code <> n.abs_block_code
        or o.is_internal_credit <> n.is_internal_credit
        or o.is_external_credit <> n.is_external_credit
        or o.assets_is_table <> n.assets_is_table
        or o.act_maturity_dt <> n.act_maturity_dt
        or o.start_date <> n.start_date
        or o.end_date <> n.end_date
        or o.assetout_status <> n.assetout_status
        or o.b_info_issuenumber <> n.b_info_issuenumber
        or o.country_code <> n.country_code
        or o.first_payment_period_deadline <> n.first_payment_period_deadline
        or o.end_of_payment_period <> n.end_of_payment_period
        or o.pay_frequency <> n.pay_frequency
        or o.whether_reinvest <> n.whether_reinvest
        or o.start_time <> n.start_time
        or o.end_time_of_cycle <> n.end_time_of_cycle
        or o.the_endtime_of_the_stall <> n.the_endtime_of_the_stall
        or o.revolving_period_frequency <> n.revolving_period_frequency
        or o.balanced_interest_frequency <> n.balanced_interest_frequency
        or o.basicassets_indirectissuedcode <> n.basicassets_indirectissuedcode
        or o.underlying_asset_subdivided <> n.underlying_asset_subdivided
        or o.b_abs_paywaycode <> n.b_abs_paywaycode
        or o.b_abs_payway <> n.b_abs_payway
        or o.abs_payment_inference_day <> n.abs_payment_inference_day
        or o.b_abs_interestperioddirection <> n.b_abs_interestperioddirection
        or o.first_computing_day <> n.first_computing_day
        or o.calculation_method_type_code <> n.calculation_method_type_code
        or o.calculate_day_shift <> n.calculate_day_shift
        or o.calculatemonthlfrequency_code <> n.calculatemonthlfrequency_code
        or o.storagerackproject_number <> n.storagerackproject_number
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_absdescription_cl(
            abs_name -- 项目名称
            ,abs_shortname -- 项目简称
            ,sponor -- 发起机构
            ,sponorid -- 发起机构id
            ,issuer -- 发行人
            ,issuerid -- 发行人id
            ,issueamount -- 发行总额(万)
            ,crncy_code -- 货币代码
            ,pool_name -- 资产池名称
            ,start_dt_ora -- 初始起算日
            ,asset_type -- 基础资产类型代码
            ,delivery_dt -- 交割日
            ,setup_dt -- 信托成立日
            ,first_pay_dt -- 首个本息兑付日
            ,maturity_dt -- 法定到期日
            ,ann_dt -- 发行公告日
            ,abs_asset -- 基础资产
            ,abs_block_code -- 资产支持证券分档代码
            ,is_internal_credit -- 是否有内部信用增级
            ,is_external_credit -- 是否有外部信用增级
            ,assets_is_table -- 资产是否出表
            ,abs_id -- 项目ID
            ,act_maturity_dt -- 实际到期日
            ,start_date -- 清算开始日
            ,end_date -- 清算结束日
            ,assetout_status -- 资产出表情形
            ,b_info_issuenumber -- 发行期号
            ,country_code -- 国家代码
            ,first_payment_period_deadline -- 首个收款期截止日
            ,end_of_payment_period -- 最末收款期截止日
            ,pay_frequency -- 偿付频率
            ,whether_reinvest -- 是否循环购买
            ,start_time -- 循环期开始时间
            ,end_time_of_cycle -- 循环期结束时间
            ,the_endtime_of_the_stall -- 摊还期结束时间
            ,revolving_period_frequency -- 循环期付息频率
            ,balanced_interest_frequency -- 摊还期付息频率
            ,basicassets_indirectissuedcode -- 基础资产间接发行通道类型代码
            ,underlying_asset_subdivided -- 基础资产细分
            ,b_abs_paywaycode -- 支付日推算方法类型代码
            ,b_abs_payway -- 支付日推算
            ,abs_payment_inference_day -- 资产支持证券付息推断日
            ,b_abs_interestperioddirection -- 计息区间包闭方式
            ,first_computing_day -- 首个计算日
            ,calculation_method_type_code -- 计算日计算方法类型代码
            ,calculate_day_shift -- 计算日偏移量
            ,calculatemonthlfrequency_code -- 计算月频率代码
            ,storagerackproject_number -- 储架项目编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_absdescription_op(
            abs_name -- 项目名称
            ,abs_shortname -- 项目简称
            ,sponor -- 发起机构
            ,sponorid -- 发起机构id
            ,issuer -- 发行人
            ,issuerid -- 发行人id
            ,issueamount -- 发行总额(万)
            ,crncy_code -- 货币代码
            ,pool_name -- 资产池名称
            ,start_dt_ora -- 初始起算日
            ,asset_type -- 基础资产类型代码
            ,delivery_dt -- 交割日
            ,setup_dt -- 信托成立日
            ,first_pay_dt -- 首个本息兑付日
            ,maturity_dt -- 法定到期日
            ,ann_dt -- 发行公告日
            ,abs_asset -- 基础资产
            ,abs_block_code -- 资产支持证券分档代码
            ,is_internal_credit -- 是否有内部信用增级
            ,is_external_credit -- 是否有外部信用增级
            ,assets_is_table -- 资产是否出表
            ,abs_id -- 项目ID
            ,act_maturity_dt -- 实际到期日
            ,start_date -- 清算开始日
            ,end_date -- 清算结束日
            ,assetout_status -- 资产出表情形
            ,b_info_issuenumber -- 发行期号
            ,country_code -- 国家代码
            ,first_payment_period_deadline -- 首个收款期截止日
            ,end_of_payment_period -- 最末收款期截止日
            ,pay_frequency -- 偿付频率
            ,whether_reinvest -- 是否循环购买
            ,start_time -- 循环期开始时间
            ,end_time_of_cycle -- 循环期结束时间
            ,the_endtime_of_the_stall -- 摊还期结束时间
            ,revolving_period_frequency -- 循环期付息频率
            ,balanced_interest_frequency -- 摊还期付息频率
            ,basicassets_indirectissuedcode -- 基础资产间接发行通道类型代码
            ,underlying_asset_subdivided -- 基础资产细分
            ,b_abs_paywaycode -- 支付日推算方法类型代码
            ,b_abs_payway -- 支付日推算
            ,abs_payment_inference_day -- 资产支持证券付息推断日
            ,b_abs_interestperioddirection -- 计息区间包闭方式
            ,first_computing_day -- 首个计算日
            ,calculation_method_type_code -- 计算日计算方法类型代码
            ,calculate_day_shift -- 计算日偏移量
            ,calculatemonthlfrequency_code -- 计算月频率代码
            ,storagerackproject_number -- 储架项目编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.abs_name -- 项目名称
    ,o.abs_shortname -- 项目简称
    ,o.sponor -- 发起机构
    ,o.sponorid -- 发起机构id
    ,o.issuer -- 发行人
    ,o.issuerid -- 发行人id
    ,o.issueamount -- 发行总额(万)
    ,o.crncy_code -- 货币代码
    ,o.pool_name -- 资产池名称
    ,o.start_dt_ora -- 初始起算日
    ,o.asset_type -- 基础资产类型代码
    ,o.delivery_dt -- 交割日
    ,o.setup_dt -- 信托成立日
    ,o.first_pay_dt -- 首个本息兑付日
    ,o.maturity_dt -- 法定到期日
    ,o.ann_dt -- 发行公告日
    ,o.abs_asset -- 基础资产
    ,o.abs_block_code -- 资产支持证券分档代码
    ,o.is_internal_credit -- 是否有内部信用增级
    ,o.is_external_credit -- 是否有外部信用增级
    ,o.assets_is_table -- 资产是否出表
    ,o.abs_id -- 项目ID
    ,o.act_maturity_dt -- 实际到期日
    ,o.start_date -- 清算开始日
    ,o.end_date -- 清算结束日
    ,o.assetout_status -- 资产出表情形
    ,o.b_info_issuenumber -- 发行期号
    ,o.country_code -- 国家代码
    ,o.first_payment_period_deadline -- 首个收款期截止日
    ,o.end_of_payment_period -- 最末收款期截止日
    ,o.pay_frequency -- 偿付频率
    ,o.whether_reinvest -- 是否循环购买
    ,o.start_time -- 循环期开始时间
    ,o.end_time_of_cycle -- 循环期结束时间
    ,o.the_endtime_of_the_stall -- 摊还期结束时间
    ,o.revolving_period_frequency -- 循环期付息频率
    ,o.balanced_interest_frequency -- 摊还期付息频率
    ,o.basicassets_indirectissuedcode -- 基础资产间接发行通道类型代码
    ,o.underlying_asset_subdivided -- 基础资产细分
    ,o.b_abs_paywaycode -- 支付日推算方法类型代码
    ,o.b_abs_payway -- 支付日推算
    ,o.abs_payment_inference_day -- 资产支持证券付息推断日
    ,o.b_abs_interestperioddirection -- 计息区间包闭方式
    ,o.first_computing_day -- 首个计算日
    ,o.calculation_method_type_code -- 计算日计算方法类型代码
    ,o.calculate_day_shift -- 计算日偏移量
    ,o.calculatemonthlfrequency_code -- 计算月频率代码
    ,o.storagerackproject_number -- 储架项目编号
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
from ${iol_schema}.wind_absdescription_bk o
    left join ${iol_schema}.wind_absdescription_op n
        on
            o.abs_id = n.abs_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wind_absdescription_cl d
        on
            o.abs_id = d.abs_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_absdescription;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('wind_absdescription') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.wind_absdescription drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.wind_absdescription add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.wind_absdescription exchange partition p_${batch_date} with table ${iol_schema}.wind_absdescription_cl;
alter table ${iol_schema}.wind_absdescription exchange partition p_20991231 with table ${iol_schema}.wind_absdescription_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_absdescription to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_absdescription_op purge;
drop table ${iol_schema}.wind_absdescription_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_absdescription_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_absdescription',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
