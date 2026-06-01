/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_cbonddescription
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
create table ${iol_schema}.wind_cbonddescription_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_cbonddescription;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_cbonddescription_op purge;
drop table ${iol_schema}.wind_cbonddescription_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbonddescription_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_cbonddescription where 0=1;

create table ${iol_schema}.wind_cbonddescription_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_cbonddescription where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_cbonddescription_cl(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,b_info_fullname -- 债券名称
            ,b_info_issuer -- 发行人
            ,b_issue_announcement -- 发行公告日
            ,b_issue_firstissue -- 发行起始日
            ,b_issue_lastissue -- 发行截止日
            ,b_issue_amountplan -- 计划发行总量(亿元)
            ,b_issue_amountact -- 实际发行总量(亿元)
            ,b_info_issueprice -- 发行价格
            ,b_info_par -- 面值
            ,b_info_couponrate -- 发行票面利率(%)
            ,b_info_spread -- 利差(%)
            ,b_info_carrydate -- 计息起始日
            ,b_info_enddate -- 计息截止日
            ,b_info_maturitydate -- 到期日
            ,b_info_term_year_ -- 债券期限(年)
            ,b_info_term_day_ -- 债券期限(天)
            ,b_info_paymentdate -- 兑付日
            ,b_info_paymenttype -- 计息方式
            ,b_info_interestfrequency -- 付息频率
            ,b_info_form -- 债券形式
            ,b_info_coupon -- 息票品种
            ,b_info_interesttype -- 附息利率品种
            ,b_info_act -- 特殊年计息天数
            ,b_issue_fee -- 发行手续费率(%)
            ,b_redemption_feeration -- 兑付手续费率(%)
            ,b_info_taxrate -- 所得税率
            ,crncy_code -- 货币代码
            ,s_info_name -- 债券简称
            ,s_info_exchmarket -- 交易所
            ,b_info_guarantor -- 担保人
            ,b_info_guartype -- 担保方式
            ,b_info_listdate -- 上市日期
            ,b_info_yearsnumber -- 年内序号
            ,s_div_recorddate -- 兑付登记起始日
            ,b_info_codebyplacing -- 上网发行认购代码
            ,b_info_delistdate -- 退市日期
            ,b_info_issuetype -- 发行方式
            ,b_info_guarintroduction -- 担保简介
            ,b_info_bgndbyplacing -- 上网发行起始日期
            ,b_info_enddbyplacing -- 上网发行截止日期
            ,b_info_amountbyplacing -- 上网发行数量(亿元)
            ,b_info_underwritingcode -- 承销方式代码
            ,b_info_issuercode -- 发行人编号
            ,b_info_formercode -- 原债券代码
            ,b_info_coupontxt -- 利率说明
            ,is_failure -- 是否发行失败
            ,is_crossmarket -- 是否跨市场
            ,b_info_coupondatetxt -- 付息日说明
            ,b_info_subordinateornot -- 是否次级债或混合资本债
            ,b_tendrst_referyield -- 参考收益率
            ,b_info_curpar -- 最新面值
            ,s_info_formerwindcode -- 原Wind代码
            ,is_corporate_bond -- 是否公司债
            ,b_info_issuertype -- 发行人类型
            ,b_info_specialbondtype -- 特殊债券类型
            ,is_payadvanced -- 是否可提前兑付
            ,is_callable -- 是否可赎回
            ,is_chooseright -- 是否有选择权
            ,is_netprice -- 是否净价
            ,is_act_days -- 是否按实际天数计息
            ,is_incbonds -- 是否增发债
            ,issue_object -- 发行对象
            ,b_info_actualbenchmark -- 计息基准
            ,register_file_type_code -- 注册文件类型代码
            ,register_file_number -- 注册文件号
            ,list_ann_date -- 上市公告日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_cbonddescription_op(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,b_info_fullname -- 债券名称
            ,b_info_issuer -- 发行人
            ,b_issue_announcement -- 发行公告日
            ,b_issue_firstissue -- 发行起始日
            ,b_issue_lastissue -- 发行截止日
            ,b_issue_amountplan -- 计划发行总量(亿元)
            ,b_issue_amountact -- 实际发行总量(亿元)
            ,b_info_issueprice -- 发行价格
            ,b_info_par -- 面值
            ,b_info_couponrate -- 发行票面利率(%)
            ,b_info_spread -- 利差(%)
            ,b_info_carrydate -- 计息起始日
            ,b_info_enddate -- 计息截止日
            ,b_info_maturitydate -- 到期日
            ,b_info_term_year_ -- 债券期限(年)
            ,b_info_term_day_ -- 债券期限(天)
            ,b_info_paymentdate -- 兑付日
            ,b_info_paymenttype -- 计息方式
            ,b_info_interestfrequency -- 付息频率
            ,b_info_form -- 债券形式
            ,b_info_coupon -- 息票品种
            ,b_info_interesttype -- 附息利率品种
            ,b_info_act -- 特殊年计息天数
            ,b_issue_fee -- 发行手续费率(%)
            ,b_redemption_feeration -- 兑付手续费率(%)
            ,b_info_taxrate -- 所得税率
            ,crncy_code -- 货币代码
            ,s_info_name -- 债券简称
            ,s_info_exchmarket -- 交易所
            ,b_info_guarantor -- 担保人
            ,b_info_guartype -- 担保方式
            ,b_info_listdate -- 上市日期
            ,b_info_yearsnumber -- 年内序号
            ,s_div_recorddate -- 兑付登记起始日
            ,b_info_codebyplacing -- 上网发行认购代码
            ,b_info_delistdate -- 退市日期
            ,b_info_issuetype -- 发行方式
            ,b_info_guarintroduction -- 担保简介
            ,b_info_bgndbyplacing -- 上网发行起始日期
            ,b_info_enddbyplacing -- 上网发行截止日期
            ,b_info_amountbyplacing -- 上网发行数量(亿元)
            ,b_info_underwritingcode -- 承销方式代码
            ,b_info_issuercode -- 发行人编号
            ,b_info_formercode -- 原债券代码
            ,b_info_coupontxt -- 利率说明
            ,is_failure -- 是否发行失败
            ,is_crossmarket -- 是否跨市场
            ,b_info_coupondatetxt -- 付息日说明
            ,b_info_subordinateornot -- 是否次级债或混合资本债
            ,b_tendrst_referyield -- 参考收益率
            ,b_info_curpar -- 最新面值
            ,s_info_formerwindcode -- 原Wind代码
            ,is_corporate_bond -- 是否公司债
            ,b_info_issuertype -- 发行人类型
            ,b_info_specialbondtype -- 特殊债券类型
            ,is_payadvanced -- 是否可提前兑付
            ,is_callable -- 是否可赎回
            ,is_chooseright -- 是否有选择权
            ,is_netprice -- 是否净价
            ,is_act_days -- 是否按实际天数计息
            ,is_incbonds -- 是否增发债
            ,issue_object -- 发行对象
            ,b_info_actualbenchmark -- 计息基准
            ,register_file_type_code -- 注册文件类型代码
            ,register_file_number -- 注册文件号
            ,list_ann_date -- 上市公告日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.object_id, o.object_id) as object_id -- 对象ID
    ,nvl(n.s_info_windcode, o.s_info_windcode) as s_info_windcode -- Wind代码
    ,nvl(n.b_info_fullname, o.b_info_fullname) as b_info_fullname -- 债券名称
    ,nvl(n.b_info_issuer, o.b_info_issuer) as b_info_issuer -- 发行人
    ,nvl(n.b_issue_announcement, o.b_issue_announcement) as b_issue_announcement -- 发行公告日
    ,nvl(n.b_issue_firstissue, o.b_issue_firstissue) as b_issue_firstissue -- 发行起始日
    ,nvl(n.b_issue_lastissue, o.b_issue_lastissue) as b_issue_lastissue -- 发行截止日
    ,nvl(n.b_issue_amountplan, o.b_issue_amountplan) as b_issue_amountplan -- 计划发行总量(亿元)
    ,nvl(n.b_issue_amountact, o.b_issue_amountact) as b_issue_amountact -- 实际发行总量(亿元)
    ,nvl(n.b_info_issueprice, o.b_info_issueprice) as b_info_issueprice -- 发行价格
    ,nvl(n.b_info_par, o.b_info_par) as b_info_par -- 面值
    ,nvl(n.b_info_couponrate, o.b_info_couponrate) as b_info_couponrate -- 发行票面利率(%)
    ,nvl(n.b_info_spread, o.b_info_spread) as b_info_spread -- 利差(%)
    ,nvl(n.b_info_carrydate, o.b_info_carrydate) as b_info_carrydate -- 计息起始日
    ,nvl(n.b_info_enddate, o.b_info_enddate) as b_info_enddate -- 计息截止日
    ,nvl(n.b_info_maturitydate, o.b_info_maturitydate) as b_info_maturitydate -- 到期日
    ,nvl(n.b_info_term_year_, o.b_info_term_year_) as b_info_term_year_ -- 债券期限(年)
    ,nvl(n.b_info_term_day_, o.b_info_term_day_) as b_info_term_day_ -- 债券期限(天)
    ,nvl(n.b_info_paymentdate, o.b_info_paymentdate) as b_info_paymentdate -- 兑付日
    ,nvl(n.b_info_paymenttype, o.b_info_paymenttype) as b_info_paymenttype -- 计息方式
    ,nvl(n.b_info_interestfrequency, o.b_info_interestfrequency) as b_info_interestfrequency -- 付息频率
    ,nvl(n.b_info_form, o.b_info_form) as b_info_form -- 债券形式
    ,nvl(n.b_info_coupon, o.b_info_coupon) as b_info_coupon -- 息票品种
    ,nvl(n.b_info_interesttype, o.b_info_interesttype) as b_info_interesttype -- 附息利率品种
    ,nvl(n.b_info_act, o.b_info_act) as b_info_act -- 特殊年计息天数
    ,nvl(n.b_issue_fee, o.b_issue_fee) as b_issue_fee -- 发行手续费率(%)
    ,nvl(n.b_redemption_feeration, o.b_redemption_feeration) as b_redemption_feeration -- 兑付手续费率(%)
    ,nvl(n.b_info_taxrate, o.b_info_taxrate) as b_info_taxrate -- 所得税率
    ,nvl(n.crncy_code, o.crncy_code) as crncy_code -- 货币代码
    ,nvl(n.s_info_name, o.s_info_name) as s_info_name -- 债券简称
    ,nvl(n.s_info_exchmarket, o.s_info_exchmarket) as s_info_exchmarket -- 交易所
    ,nvl(n.b_info_guarantor, o.b_info_guarantor) as b_info_guarantor -- 担保人
    ,nvl(n.b_info_guartype, o.b_info_guartype) as b_info_guartype -- 担保方式
    ,nvl(n.b_info_listdate, o.b_info_listdate) as b_info_listdate -- 上市日期
    ,nvl(n.b_info_yearsnumber, o.b_info_yearsnumber) as b_info_yearsnumber -- 年内序号
    ,nvl(n.s_div_recorddate, o.s_div_recorddate) as s_div_recorddate -- 兑付登记起始日
    ,nvl(n.b_info_codebyplacing, o.b_info_codebyplacing) as b_info_codebyplacing -- 上网发行认购代码
    ,nvl(n.b_info_delistdate, o.b_info_delistdate) as b_info_delistdate -- 退市日期
    ,nvl(n.b_info_issuetype, o.b_info_issuetype) as b_info_issuetype -- 发行方式
    ,nvl(n.b_info_guarintroduction, o.b_info_guarintroduction) as b_info_guarintroduction -- 担保简介
    ,nvl(n.b_info_bgndbyplacing, o.b_info_bgndbyplacing) as b_info_bgndbyplacing -- 上网发行起始日期
    ,nvl(n.b_info_enddbyplacing, o.b_info_enddbyplacing) as b_info_enddbyplacing -- 上网发行截止日期
    ,nvl(n.b_info_amountbyplacing, o.b_info_amountbyplacing) as b_info_amountbyplacing -- 上网发行数量(亿元)
    ,nvl(n.b_info_underwritingcode, o.b_info_underwritingcode) as b_info_underwritingcode -- 承销方式代码
    ,nvl(n.b_info_issuercode, o.b_info_issuercode) as b_info_issuercode -- 发行人编号
    ,nvl(n.b_info_formercode, o.b_info_formercode) as b_info_formercode -- 原债券代码
    ,nvl(n.b_info_coupontxt, o.b_info_coupontxt) as b_info_coupontxt -- 利率说明
    ,nvl(n.is_failure, o.is_failure) as is_failure -- 是否发行失败
    ,nvl(n.is_crossmarket, o.is_crossmarket) as is_crossmarket -- 是否跨市场
    ,nvl(n.b_info_coupondatetxt, o.b_info_coupondatetxt) as b_info_coupondatetxt -- 付息日说明
    ,nvl(n.b_info_subordinateornot, o.b_info_subordinateornot) as b_info_subordinateornot -- 是否次级债或混合资本债
    ,nvl(n.b_tendrst_referyield, o.b_tendrst_referyield) as b_tendrst_referyield -- 参考收益率
    ,nvl(n.b_info_curpar, o.b_info_curpar) as b_info_curpar -- 最新面值
    ,nvl(n.s_info_formerwindcode, o.s_info_formerwindcode) as s_info_formerwindcode -- 原Wind代码
    ,nvl(n.is_corporate_bond, o.is_corporate_bond) as is_corporate_bond -- 是否公司债
    ,nvl(n.b_info_issuertype, o.b_info_issuertype) as b_info_issuertype -- 发行人类型
    ,nvl(n.b_info_specialbondtype, o.b_info_specialbondtype) as b_info_specialbondtype -- 特殊债券类型
    ,nvl(n.is_payadvanced, o.is_payadvanced) as is_payadvanced -- 是否可提前兑付
    ,nvl(n.is_callable, o.is_callable) as is_callable -- 是否可赎回
    ,nvl(n.is_chooseright, o.is_chooseright) as is_chooseright -- 是否有选择权
    ,nvl(n.is_netprice, o.is_netprice) as is_netprice -- 是否净价
    ,nvl(n.is_act_days, o.is_act_days) as is_act_days -- 是否按实际天数计息
    ,nvl(n.is_incbonds, o.is_incbonds) as is_incbonds -- 是否增发债
    ,nvl(n.issue_object, o.issue_object) as issue_object -- 发行对象
    ,nvl(n.b_info_actualbenchmark, o.b_info_actualbenchmark) as b_info_actualbenchmark -- 计息基准
    ,nvl(n.register_file_type_code, o.register_file_type_code) as register_file_type_code -- 注册文件类型代码
    ,nvl(n.register_file_number, o.register_file_number) as register_file_number -- 注册文件号
    ,nvl(n.list_ann_date, o.list_ann_date) as list_ann_date -- 上市公告日
    ,case when
            n.s_info_windcode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.s_info_windcode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.s_info_windcode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_cbonddescription_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wind_cbonddescription where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.s_info_windcode = n.s_info_windcode
where (
        o.s_info_windcode is null
    )
    or (
        n.s_info_windcode is null
    )
    or (
        o.object_id <> n.object_id
        or o.b_info_fullname <> n.b_info_fullname
        or o.b_info_issuer <> n.b_info_issuer
        or o.b_issue_announcement <> n.b_issue_announcement
        or o.b_issue_firstissue <> n.b_issue_firstissue
        or o.b_issue_lastissue <> n.b_issue_lastissue
        or o.b_issue_amountplan <> n.b_issue_amountplan
        or o.b_issue_amountact <> n.b_issue_amountact
        or o.b_info_issueprice <> n.b_info_issueprice
        or o.b_info_par <> n.b_info_par
        or o.b_info_couponrate <> n.b_info_couponrate
        or o.b_info_spread <> n.b_info_spread
        or o.b_info_carrydate <> n.b_info_carrydate
        or o.b_info_enddate <> n.b_info_enddate
        or o.b_info_maturitydate <> n.b_info_maturitydate
        or o.b_info_term_year_ <> n.b_info_term_year_
        or o.b_info_term_day_ <> n.b_info_term_day_
        or o.b_info_paymentdate <> n.b_info_paymentdate
        or o.b_info_paymenttype <> n.b_info_paymenttype
        or o.b_info_interestfrequency <> n.b_info_interestfrequency
        or o.b_info_form <> n.b_info_form
        or o.b_info_coupon <> n.b_info_coupon
        or o.b_info_interesttype <> n.b_info_interesttype
        or o.b_info_act <> n.b_info_act
        or o.b_issue_fee <> n.b_issue_fee
        or o.b_redemption_feeration <> n.b_redemption_feeration
        or o.b_info_taxrate <> n.b_info_taxrate
        or o.crncy_code <> n.crncy_code
        or o.s_info_name <> n.s_info_name
        or o.s_info_exchmarket <> n.s_info_exchmarket
        or o.b_info_guarantor <> n.b_info_guarantor
        or o.b_info_guartype <> n.b_info_guartype
        or o.b_info_listdate <> n.b_info_listdate
        or o.b_info_yearsnumber <> n.b_info_yearsnumber
        or o.s_div_recorddate <> n.s_div_recorddate
        or o.b_info_codebyplacing <> n.b_info_codebyplacing
        or o.b_info_delistdate <> n.b_info_delistdate
        or o.b_info_issuetype <> n.b_info_issuetype
        or o.b_info_guarintroduction <> n.b_info_guarintroduction
        or o.b_info_bgndbyplacing <> n.b_info_bgndbyplacing
        or o.b_info_enddbyplacing <> n.b_info_enddbyplacing
        or o.b_info_amountbyplacing <> n.b_info_amountbyplacing
        or o.b_info_underwritingcode <> n.b_info_underwritingcode
        or o.b_info_issuercode <> n.b_info_issuercode
        or o.b_info_formercode <> n.b_info_formercode
        or o.b_info_coupontxt <> n.b_info_coupontxt
        or o.is_failure <> n.is_failure
        or o.is_crossmarket <> n.is_crossmarket
        or o.b_info_coupondatetxt <> n.b_info_coupondatetxt
        or o.b_info_subordinateornot <> n.b_info_subordinateornot
        or o.b_tendrst_referyield <> n.b_tendrst_referyield
        or o.b_info_curpar <> n.b_info_curpar
        or o.s_info_formerwindcode <> n.s_info_formerwindcode
        or o.is_corporate_bond <> n.is_corporate_bond
        or o.b_info_issuertype <> n.b_info_issuertype
        or o.b_info_specialbondtype <> n.b_info_specialbondtype
        or o.is_payadvanced <> n.is_payadvanced
        or o.is_callable <> n.is_callable
        or o.is_chooseright <> n.is_chooseright
        or o.is_netprice <> n.is_netprice
        or o.is_act_days <> n.is_act_days
        or o.is_incbonds <> n.is_incbonds
        or o.issue_object <> n.issue_object
        or o.b_info_actualbenchmark <> n.b_info_actualbenchmark
        or o.register_file_type_code <> n.register_file_type_code
        or o.register_file_number <> n.register_file_number
        or o.list_ann_date <> n.list_ann_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_cbonddescription_cl(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,b_info_fullname -- 债券名称
            ,b_info_issuer -- 发行人
            ,b_issue_announcement -- 发行公告日
            ,b_issue_firstissue -- 发行起始日
            ,b_issue_lastissue -- 发行截止日
            ,b_issue_amountplan -- 计划发行总量(亿元)
            ,b_issue_amountact -- 实际发行总量(亿元)
            ,b_info_issueprice -- 发行价格
            ,b_info_par -- 面值
            ,b_info_couponrate -- 发行票面利率(%)
            ,b_info_spread -- 利差(%)
            ,b_info_carrydate -- 计息起始日
            ,b_info_enddate -- 计息截止日
            ,b_info_maturitydate -- 到期日
            ,b_info_term_year_ -- 债券期限(年)
            ,b_info_term_day_ -- 债券期限(天)
            ,b_info_paymentdate -- 兑付日
            ,b_info_paymenttype -- 计息方式
            ,b_info_interestfrequency -- 付息频率
            ,b_info_form -- 债券形式
            ,b_info_coupon -- 息票品种
            ,b_info_interesttype -- 附息利率品种
            ,b_info_act -- 特殊年计息天数
            ,b_issue_fee -- 发行手续费率(%)
            ,b_redemption_feeration -- 兑付手续费率(%)
            ,b_info_taxrate -- 所得税率
            ,crncy_code -- 货币代码
            ,s_info_name -- 债券简称
            ,s_info_exchmarket -- 交易所
            ,b_info_guarantor -- 担保人
            ,b_info_guartype -- 担保方式
            ,b_info_listdate -- 上市日期
            ,b_info_yearsnumber -- 年内序号
            ,s_div_recorddate -- 兑付登记起始日
            ,b_info_codebyplacing -- 上网发行认购代码
            ,b_info_delistdate -- 退市日期
            ,b_info_issuetype -- 发行方式
            ,b_info_guarintroduction -- 担保简介
            ,b_info_bgndbyplacing -- 上网发行起始日期
            ,b_info_enddbyplacing -- 上网发行截止日期
            ,b_info_amountbyplacing -- 上网发行数量(亿元)
            ,b_info_underwritingcode -- 承销方式代码
            ,b_info_issuercode -- 发行人编号
            ,b_info_formercode -- 原债券代码
            ,b_info_coupontxt -- 利率说明
            ,is_failure -- 是否发行失败
            ,is_crossmarket -- 是否跨市场
            ,b_info_coupondatetxt -- 付息日说明
            ,b_info_subordinateornot -- 是否次级债或混合资本债
            ,b_tendrst_referyield -- 参考收益率
            ,b_info_curpar -- 最新面值
            ,s_info_formerwindcode -- 原Wind代码
            ,is_corporate_bond -- 是否公司债
            ,b_info_issuertype -- 发行人类型
            ,b_info_specialbondtype -- 特殊债券类型
            ,is_payadvanced -- 是否可提前兑付
            ,is_callable -- 是否可赎回
            ,is_chooseright -- 是否有选择权
            ,is_netprice -- 是否净价
            ,is_act_days -- 是否按实际天数计息
            ,is_incbonds -- 是否增发债
            ,issue_object -- 发行对象
            ,b_info_actualbenchmark -- 计息基准
            ,register_file_type_code -- 注册文件类型代码
            ,register_file_number -- 注册文件号
            ,list_ann_date -- 上市公告日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_cbonddescription_op(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,b_info_fullname -- 债券名称
            ,b_info_issuer -- 发行人
            ,b_issue_announcement -- 发行公告日
            ,b_issue_firstissue -- 发行起始日
            ,b_issue_lastissue -- 发行截止日
            ,b_issue_amountplan -- 计划发行总量(亿元)
            ,b_issue_amountact -- 实际发行总量(亿元)
            ,b_info_issueprice -- 发行价格
            ,b_info_par -- 面值
            ,b_info_couponrate -- 发行票面利率(%)
            ,b_info_spread -- 利差(%)
            ,b_info_carrydate -- 计息起始日
            ,b_info_enddate -- 计息截止日
            ,b_info_maturitydate -- 到期日
            ,b_info_term_year_ -- 债券期限(年)
            ,b_info_term_day_ -- 债券期限(天)
            ,b_info_paymentdate -- 兑付日
            ,b_info_paymenttype -- 计息方式
            ,b_info_interestfrequency -- 付息频率
            ,b_info_form -- 债券形式
            ,b_info_coupon -- 息票品种
            ,b_info_interesttype -- 附息利率品种
            ,b_info_act -- 特殊年计息天数
            ,b_issue_fee -- 发行手续费率(%)
            ,b_redemption_feeration -- 兑付手续费率(%)
            ,b_info_taxrate -- 所得税率
            ,crncy_code -- 货币代码
            ,s_info_name -- 债券简称
            ,s_info_exchmarket -- 交易所
            ,b_info_guarantor -- 担保人
            ,b_info_guartype -- 担保方式
            ,b_info_listdate -- 上市日期
            ,b_info_yearsnumber -- 年内序号
            ,s_div_recorddate -- 兑付登记起始日
            ,b_info_codebyplacing -- 上网发行认购代码
            ,b_info_delistdate -- 退市日期
            ,b_info_issuetype -- 发行方式
            ,b_info_guarintroduction -- 担保简介
            ,b_info_bgndbyplacing -- 上网发行起始日期
            ,b_info_enddbyplacing -- 上网发行截止日期
            ,b_info_amountbyplacing -- 上网发行数量(亿元)
            ,b_info_underwritingcode -- 承销方式代码
            ,b_info_issuercode -- 发行人编号
            ,b_info_formercode -- 原债券代码
            ,b_info_coupontxt -- 利率说明
            ,is_failure -- 是否发行失败
            ,is_crossmarket -- 是否跨市场
            ,b_info_coupondatetxt -- 付息日说明
            ,b_info_subordinateornot -- 是否次级债或混合资本债
            ,b_tendrst_referyield -- 参考收益率
            ,b_info_curpar -- 最新面值
            ,s_info_formerwindcode -- 原Wind代码
            ,is_corporate_bond -- 是否公司债
            ,b_info_issuertype -- 发行人类型
            ,b_info_specialbondtype -- 特殊债券类型
            ,is_payadvanced -- 是否可提前兑付
            ,is_callable -- 是否可赎回
            ,is_chooseright -- 是否有选择权
            ,is_netprice -- 是否净价
            ,is_act_days -- 是否按实际天数计息
            ,is_incbonds -- 是否增发债
            ,issue_object -- 发行对象
            ,b_info_actualbenchmark -- 计息基准
            ,register_file_type_code -- 注册文件类型代码
            ,register_file_number -- 注册文件号
            ,list_ann_date -- 上市公告日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象ID
    ,o.s_info_windcode -- Wind代码
    ,o.b_info_fullname -- 债券名称
    ,o.b_info_issuer -- 发行人
    ,o.b_issue_announcement -- 发行公告日
    ,o.b_issue_firstissue -- 发行起始日
    ,o.b_issue_lastissue -- 发行截止日
    ,o.b_issue_amountplan -- 计划发行总量(亿元)
    ,o.b_issue_amountact -- 实际发行总量(亿元)
    ,o.b_info_issueprice -- 发行价格
    ,o.b_info_par -- 面值
    ,o.b_info_couponrate -- 发行票面利率(%)
    ,o.b_info_spread -- 利差(%)
    ,o.b_info_carrydate -- 计息起始日
    ,o.b_info_enddate -- 计息截止日
    ,o.b_info_maturitydate -- 到期日
    ,o.b_info_term_year_ -- 债券期限(年)
    ,o.b_info_term_day_ -- 债券期限(天)
    ,o.b_info_paymentdate -- 兑付日
    ,o.b_info_paymenttype -- 计息方式
    ,o.b_info_interestfrequency -- 付息频率
    ,o.b_info_form -- 债券形式
    ,o.b_info_coupon -- 息票品种
    ,o.b_info_interesttype -- 附息利率品种
    ,o.b_info_act -- 特殊年计息天数
    ,o.b_issue_fee -- 发行手续费率(%)
    ,o.b_redemption_feeration -- 兑付手续费率(%)
    ,o.b_info_taxrate -- 所得税率
    ,o.crncy_code -- 货币代码
    ,o.s_info_name -- 债券简称
    ,o.s_info_exchmarket -- 交易所
    ,o.b_info_guarantor -- 担保人
    ,o.b_info_guartype -- 担保方式
    ,o.b_info_listdate -- 上市日期
    ,o.b_info_yearsnumber -- 年内序号
    ,o.s_div_recorddate -- 兑付登记起始日
    ,o.b_info_codebyplacing -- 上网发行认购代码
    ,o.b_info_delistdate -- 退市日期
    ,o.b_info_issuetype -- 发行方式
    ,o.b_info_guarintroduction -- 担保简介
    ,o.b_info_bgndbyplacing -- 上网发行起始日期
    ,o.b_info_enddbyplacing -- 上网发行截止日期
    ,o.b_info_amountbyplacing -- 上网发行数量(亿元)
    ,o.b_info_underwritingcode -- 承销方式代码
    ,o.b_info_issuercode -- 发行人编号
    ,o.b_info_formercode -- 原债券代码
    ,o.b_info_coupontxt -- 利率说明
    ,o.is_failure -- 是否发行失败
    ,o.is_crossmarket -- 是否跨市场
    ,o.b_info_coupondatetxt -- 付息日说明
    ,o.b_info_subordinateornot -- 是否次级债或混合资本债
    ,o.b_tendrst_referyield -- 参考收益率
    ,o.b_info_curpar -- 最新面值
    ,o.s_info_formerwindcode -- 原Wind代码
    ,o.is_corporate_bond -- 是否公司债
    ,o.b_info_issuertype -- 发行人类型
    ,o.b_info_specialbondtype -- 特殊债券类型
    ,o.is_payadvanced -- 是否可提前兑付
    ,o.is_callable -- 是否可赎回
    ,o.is_chooseright -- 是否有选择权
    ,o.is_netprice -- 是否净价
    ,o.is_act_days -- 是否按实际天数计息
    ,o.is_incbonds -- 是否增发债
    ,o.issue_object -- 发行对象
    ,o.b_info_actualbenchmark -- 计息基准
    ,o.register_file_type_code -- 注册文件类型代码
    ,o.register_file_number -- 注册文件号
    ,o.list_ann_date -- 上市公告日
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_cbonddescription_bk o
    left join ${iol_schema}.wind_cbonddescription_op n
        on
            o.s_info_windcode = n.s_info_windcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wind_cbonddescription_cl d
        on
            o.s_info_windcode = d.s_info_windcode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.wind_cbonddescription;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_cbonddescription exchange partition p_19000101 with table ${iol_schema}.wind_cbonddescription_cl;
alter table ${iol_schema}.wind_cbonddescription exchange partition p_20991231 with table ${iol_schema}.wind_cbonddescription_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_cbonddescription to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_cbonddescription_op purge;
drop table ${iol_schema}.wind_cbonddescription_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_cbonddescription_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_cbonddescription',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
