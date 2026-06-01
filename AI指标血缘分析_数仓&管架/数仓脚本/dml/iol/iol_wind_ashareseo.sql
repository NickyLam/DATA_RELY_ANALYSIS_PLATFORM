/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_ashareseo
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
create table ${iol_schema}.wind_ashareseo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_ashareseo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_ashareseo_op purge;
drop table ${iol_schema}.wind_ashareseo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareseo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_ashareseo where 0=1;

create table ${iol_schema}.wind_ashareseo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_ashareseo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_ashareseo_cl(
            object_id -- 对象id
            ,s_info_windcode -- wind代码
            ,s_fellow_progress -- 方案进度
            ,s_fellow_issuetype -- 发行方式
            ,crncy_code -- 货币代码
            ,s_fellow_price -- 发行价格(元)
            ,s_fellow_amount -- 发行数量(万股)
            ,s_fellow_collection -- 募集资金(元)
            ,s_fellow_recorddate -- 股权登记日
            ,s_fellow_paystartdate -- 向老股东配售(或优先配售)缴款起始日
            ,s_fellow_payenddate -- 向老股东配售(或优先配售)缴款终止日
            ,s_fellow_subdate -- 网上申购日
            ,s_fellow_otcdate -- 股份登记(定向) 日期
            ,s_fellow_listdate -- 向公众增发股份上市日期
            ,s_fellow_instlistdate -- 向机构增发股份上市日期
            ,s_fellow_changedate -- 定向增发股份变动日期
            ,s_fellow_roadshowdate -- 网上路演日
            ,s_fellow_refunddate -- 网下申购资金(定金)退款日
            ,s_fellow_unfrozedate -- 网上申购资金解冻日
            ,s_fellow_preplandate -- 预案公告日
            ,s_fellow_smtganncedate -- 股东大会公告日
            ,s_fellow_passdate -- 发审委通过公告日
            ,s_fellow_approveddate -- 证监会核准公告日
            ,s_fellow_anncedate -- 上网发行公告日
            ,s_fellow_ratioanncedate -- 网上中签率公告日
            ,s_fellow_offeringdate -- 增发公告日
            ,s_fellow_listanndate -- 上市公告日
            ,s_fellow_offeringobject -- 发行对象
            ,s_fellow_priceuplimit -- 增发预案价上限
            ,s_fellow_pricedownlimit -- 增发预案价下限
            ,s_seo_code -- 增发代码
            ,s_seo_name -- 增发简称
            ,s_seo_pe -- 发行市盈率(摊薄)
            ,s_seo_amtbyplacing -- 上网发行数量(万股)
            ,s_seo_amttojur -- 网下发行数量(万股)
            ,s_seo_holdersubsmode -- 大股东认购方式
            ,s_seo_holdersubsrate -- 大股东认购比例(%)
            ,ann_dt -- 最新公告日期
            ,pricingmode -- 定向增发定价方式代码
            ,s_fellow_orgpricemin -- 原始预案价下限
            ,s_fellow_discntratio -- 折扣率
            ,s_fellow_date -- 定增发行日期
            ,s_fellow_subinvitationdt -- 认购邀请书日
            ,s_fellow_year -- 增发年度
            ,s_fellow_objective_code -- 定向增发目的代码
            ,pricingdate -- 定价基准日
            ,is_no_public -- 是否属于非公开发行
            ,expense -- 发行费用(元)
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_ashareseo_op(
            object_id -- 对象id
            ,s_info_windcode -- wind代码
            ,s_fellow_progress -- 方案进度
            ,s_fellow_issuetype -- 发行方式
            ,crncy_code -- 货币代码
            ,s_fellow_price -- 发行价格(元)
            ,s_fellow_amount -- 发行数量(万股)
            ,s_fellow_collection -- 募集资金(元)
            ,s_fellow_recorddate -- 股权登记日
            ,s_fellow_paystartdate -- 向老股东配售(或优先配售)缴款起始日
            ,s_fellow_payenddate -- 向老股东配售(或优先配售)缴款终止日
            ,s_fellow_subdate -- 网上申购日
            ,s_fellow_otcdate -- 股份登记(定向) 日期
            ,s_fellow_listdate -- 向公众增发股份上市日期
            ,s_fellow_instlistdate -- 向机构增发股份上市日期
            ,s_fellow_changedate -- 定向增发股份变动日期
            ,s_fellow_roadshowdate -- 网上路演日
            ,s_fellow_refunddate -- 网下申购资金(定金)退款日
            ,s_fellow_unfrozedate -- 网上申购资金解冻日
            ,s_fellow_preplandate -- 预案公告日
            ,s_fellow_smtganncedate -- 股东大会公告日
            ,s_fellow_passdate -- 发审委通过公告日
            ,s_fellow_approveddate -- 证监会核准公告日
            ,s_fellow_anncedate -- 上网发行公告日
            ,s_fellow_ratioanncedate -- 网上中签率公告日
            ,s_fellow_offeringdate -- 增发公告日
            ,s_fellow_listanndate -- 上市公告日
            ,s_fellow_offeringobject -- 发行对象
            ,s_fellow_priceuplimit -- 增发预案价上限
            ,s_fellow_pricedownlimit -- 增发预案价下限
            ,s_seo_code -- 增发代码
            ,s_seo_name -- 增发简称
            ,s_seo_pe -- 发行市盈率(摊薄)
            ,s_seo_amtbyplacing -- 上网发行数量(万股)
            ,s_seo_amttojur -- 网下发行数量(万股)
            ,s_seo_holdersubsmode -- 大股东认购方式
            ,s_seo_holdersubsrate -- 大股东认购比例(%)
            ,ann_dt -- 最新公告日期
            ,pricingmode -- 定向增发定价方式代码
            ,s_fellow_orgpricemin -- 原始预案价下限
            ,s_fellow_discntratio -- 折扣率
            ,s_fellow_date -- 定增发行日期
            ,s_fellow_subinvitationdt -- 认购邀请书日
            ,s_fellow_year -- 增发年度
            ,s_fellow_objective_code -- 定向增发目的代码
            ,pricingdate -- 定价基准日
            ,is_no_public -- 是否属于非公开发行
            ,expense -- 发行费用(元)
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.object_id, o.object_id) as object_id -- 对象id
    ,nvl(n.s_info_windcode, o.s_info_windcode) as s_info_windcode -- wind代码
    ,nvl(n.s_fellow_progress, o.s_fellow_progress) as s_fellow_progress -- 方案进度
    ,nvl(n.s_fellow_issuetype, o.s_fellow_issuetype) as s_fellow_issuetype -- 发行方式
    ,nvl(n.crncy_code, o.crncy_code) as crncy_code -- 货币代码
    ,nvl(n.s_fellow_price, o.s_fellow_price) as s_fellow_price -- 发行价格(元)
    ,nvl(n.s_fellow_amount, o.s_fellow_amount) as s_fellow_amount -- 发行数量(万股)
    ,nvl(n.s_fellow_collection, o.s_fellow_collection) as s_fellow_collection -- 募集资金(元)
    ,nvl(n.s_fellow_recorddate, o.s_fellow_recorddate) as s_fellow_recorddate -- 股权登记日
    ,nvl(n.s_fellow_paystartdate, o.s_fellow_paystartdate) as s_fellow_paystartdate -- 向老股东配售(或优先配售)缴款起始日
    ,nvl(n.s_fellow_payenddate, o.s_fellow_payenddate) as s_fellow_payenddate -- 向老股东配售(或优先配售)缴款终止日
    ,nvl(n.s_fellow_subdate, o.s_fellow_subdate) as s_fellow_subdate -- 网上申购日
    ,nvl(n.s_fellow_otcdate, o.s_fellow_otcdate) as s_fellow_otcdate -- 股份登记(定向) 日期
    ,nvl(n.s_fellow_listdate, o.s_fellow_listdate) as s_fellow_listdate -- 向公众增发股份上市日期
    ,nvl(n.s_fellow_instlistdate, o.s_fellow_instlistdate) as s_fellow_instlistdate -- 向机构增发股份上市日期
    ,nvl(n.s_fellow_changedate, o.s_fellow_changedate) as s_fellow_changedate -- 定向增发股份变动日期
    ,nvl(n.s_fellow_roadshowdate, o.s_fellow_roadshowdate) as s_fellow_roadshowdate -- 网上路演日
    ,nvl(n.s_fellow_refunddate, o.s_fellow_refunddate) as s_fellow_refunddate -- 网下申购资金(定金)退款日
    ,nvl(n.s_fellow_unfrozedate, o.s_fellow_unfrozedate) as s_fellow_unfrozedate -- 网上申购资金解冻日
    ,nvl(n.s_fellow_preplandate, o.s_fellow_preplandate) as s_fellow_preplandate -- 预案公告日
    ,nvl(n.s_fellow_smtganncedate, o.s_fellow_smtganncedate) as s_fellow_smtganncedate -- 股东大会公告日
    ,nvl(n.s_fellow_passdate, o.s_fellow_passdate) as s_fellow_passdate -- 发审委通过公告日
    ,nvl(n.s_fellow_approveddate, o.s_fellow_approveddate) as s_fellow_approveddate -- 证监会核准公告日
    ,nvl(n.s_fellow_anncedate, o.s_fellow_anncedate) as s_fellow_anncedate -- 上网发行公告日
    ,nvl(n.s_fellow_ratioanncedate, o.s_fellow_ratioanncedate) as s_fellow_ratioanncedate -- 网上中签率公告日
    ,nvl(n.s_fellow_offeringdate, o.s_fellow_offeringdate) as s_fellow_offeringdate -- 增发公告日
    ,nvl(n.s_fellow_listanndate, o.s_fellow_listanndate) as s_fellow_listanndate -- 上市公告日
    ,nvl(n.s_fellow_offeringobject, o.s_fellow_offeringobject) as s_fellow_offeringobject -- 发行对象
    ,nvl(n.s_fellow_priceuplimit, o.s_fellow_priceuplimit) as s_fellow_priceuplimit -- 增发预案价上限
    ,nvl(n.s_fellow_pricedownlimit, o.s_fellow_pricedownlimit) as s_fellow_pricedownlimit -- 增发预案价下限
    ,nvl(n.s_seo_code, o.s_seo_code) as s_seo_code -- 增发代码
    ,nvl(n.s_seo_name, o.s_seo_name) as s_seo_name -- 增发简称
    ,nvl(n.s_seo_pe, o.s_seo_pe) as s_seo_pe -- 发行市盈率(摊薄)
    ,nvl(n.s_seo_amtbyplacing, o.s_seo_amtbyplacing) as s_seo_amtbyplacing -- 上网发行数量(万股)
    ,nvl(n.s_seo_amttojur, o.s_seo_amttojur) as s_seo_amttojur -- 网下发行数量(万股)
    ,nvl(n.s_seo_holdersubsmode, o.s_seo_holdersubsmode) as s_seo_holdersubsmode -- 大股东认购方式
    ,nvl(n.s_seo_holdersubsrate, o.s_seo_holdersubsrate) as s_seo_holdersubsrate -- 大股东认购比例(%)
    ,nvl(n.ann_dt, o.ann_dt) as ann_dt -- 最新公告日期
    ,nvl(n.pricingmode, o.pricingmode) as pricingmode -- 定向增发定价方式代码
    ,nvl(n.s_fellow_orgpricemin, o.s_fellow_orgpricemin) as s_fellow_orgpricemin -- 原始预案价下限
    ,nvl(n.s_fellow_discntratio, o.s_fellow_discntratio) as s_fellow_discntratio -- 折扣率
    ,nvl(n.s_fellow_date, o.s_fellow_date) as s_fellow_date -- 定增发行日期
    ,nvl(n.s_fellow_subinvitationdt, o.s_fellow_subinvitationdt) as s_fellow_subinvitationdt -- 认购邀请书日
    ,nvl(n.s_fellow_year, o.s_fellow_year) as s_fellow_year -- 增发年度
    ,nvl(n.s_fellow_objective_code, o.s_fellow_objective_code) as s_fellow_objective_code -- 定向增发目的代码
    ,nvl(n.pricingdate, o.pricingdate) as pricingdate -- 定价基准日
    ,nvl(n.is_no_public, o.is_no_public) as is_no_public -- 是否属于非公开发行
    ,nvl(n.expense, o.expense) as expense -- 发行费用(元)
    ,nvl(n.opdate, o.opdate) as opdate -- 
    ,nvl(n.opmode, o.opmode) as opmode -- 
    ,case when
            n.object_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.object_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.object_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_ashareseo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wind_ashareseo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.object_id = n.object_id
where (
        o.object_id is null
    )
    or (
        n.object_id is null
    )
    or (
        o.s_info_windcode <> n.s_info_windcode
        or o.s_fellow_progress <> n.s_fellow_progress
        or o.s_fellow_issuetype <> n.s_fellow_issuetype
        or o.crncy_code <> n.crncy_code
        or o.s_fellow_price <> n.s_fellow_price
        or o.s_fellow_amount <> n.s_fellow_amount
        or o.s_fellow_collection <> n.s_fellow_collection
        or o.s_fellow_recorddate <> n.s_fellow_recorddate
        or o.s_fellow_paystartdate <> n.s_fellow_paystartdate
        or o.s_fellow_payenddate <> n.s_fellow_payenddate
        or o.s_fellow_subdate <> n.s_fellow_subdate
        or o.s_fellow_otcdate <> n.s_fellow_otcdate
        or o.s_fellow_listdate <> n.s_fellow_listdate
        or o.s_fellow_instlistdate <> n.s_fellow_instlistdate
        or o.s_fellow_changedate <> n.s_fellow_changedate
        or o.s_fellow_roadshowdate <> n.s_fellow_roadshowdate
        or o.s_fellow_refunddate <> n.s_fellow_refunddate
        or o.s_fellow_unfrozedate <> n.s_fellow_unfrozedate
        or o.s_fellow_preplandate <> n.s_fellow_preplandate
        or o.s_fellow_smtganncedate <> n.s_fellow_smtganncedate
        or o.s_fellow_passdate <> n.s_fellow_passdate
        or o.s_fellow_approveddate <> n.s_fellow_approveddate
        or o.s_fellow_anncedate <> n.s_fellow_anncedate
        or o.s_fellow_ratioanncedate <> n.s_fellow_ratioanncedate
        or o.s_fellow_offeringdate <> n.s_fellow_offeringdate
        or o.s_fellow_listanndate <> n.s_fellow_listanndate
        or o.s_fellow_offeringobject <> n.s_fellow_offeringobject
        or o.s_fellow_priceuplimit <> n.s_fellow_priceuplimit
        or o.s_fellow_pricedownlimit <> n.s_fellow_pricedownlimit
        or o.s_seo_code <> n.s_seo_code
        or o.s_seo_name <> n.s_seo_name
        or o.s_seo_pe <> n.s_seo_pe
        or o.s_seo_amtbyplacing <> n.s_seo_amtbyplacing
        or o.s_seo_amttojur <> n.s_seo_amttojur
        or o.s_seo_holdersubsmode <> n.s_seo_holdersubsmode
        or o.s_seo_holdersubsrate <> n.s_seo_holdersubsrate
        or o.ann_dt <> n.ann_dt
        or o.pricingmode <> n.pricingmode
        or o.s_fellow_orgpricemin <> n.s_fellow_orgpricemin
        or o.s_fellow_discntratio <> n.s_fellow_discntratio
        or o.s_fellow_date <> n.s_fellow_date
        or o.s_fellow_subinvitationdt <> n.s_fellow_subinvitationdt
        or o.s_fellow_year <> n.s_fellow_year
        or o.s_fellow_objective_code <> n.s_fellow_objective_code
        or o.pricingdate <> n.pricingdate
        or o.is_no_public <> n.is_no_public
        or o.expense <> n.expense
        or o.opdate <> n.opdate
        or o.opmode <> n.opmode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_ashareseo_cl(
            object_id -- 对象id
            ,s_info_windcode -- wind代码
            ,s_fellow_progress -- 方案进度
            ,s_fellow_issuetype -- 发行方式
            ,crncy_code -- 货币代码
            ,s_fellow_price -- 发行价格(元)
            ,s_fellow_amount -- 发行数量(万股)
            ,s_fellow_collection -- 募集资金(元)
            ,s_fellow_recorddate -- 股权登记日
            ,s_fellow_paystartdate -- 向老股东配售(或优先配售)缴款起始日
            ,s_fellow_payenddate -- 向老股东配售(或优先配售)缴款终止日
            ,s_fellow_subdate -- 网上申购日
            ,s_fellow_otcdate -- 股份登记(定向) 日期
            ,s_fellow_listdate -- 向公众增发股份上市日期
            ,s_fellow_instlistdate -- 向机构增发股份上市日期
            ,s_fellow_changedate -- 定向增发股份变动日期
            ,s_fellow_roadshowdate -- 网上路演日
            ,s_fellow_refunddate -- 网下申购资金(定金)退款日
            ,s_fellow_unfrozedate -- 网上申购资金解冻日
            ,s_fellow_preplandate -- 预案公告日
            ,s_fellow_smtganncedate -- 股东大会公告日
            ,s_fellow_passdate -- 发审委通过公告日
            ,s_fellow_approveddate -- 证监会核准公告日
            ,s_fellow_anncedate -- 上网发行公告日
            ,s_fellow_ratioanncedate -- 网上中签率公告日
            ,s_fellow_offeringdate -- 增发公告日
            ,s_fellow_listanndate -- 上市公告日
            ,s_fellow_offeringobject -- 发行对象
            ,s_fellow_priceuplimit -- 增发预案价上限
            ,s_fellow_pricedownlimit -- 增发预案价下限
            ,s_seo_code -- 增发代码
            ,s_seo_name -- 增发简称
            ,s_seo_pe -- 发行市盈率(摊薄)
            ,s_seo_amtbyplacing -- 上网发行数量(万股)
            ,s_seo_amttojur -- 网下发行数量(万股)
            ,s_seo_holdersubsmode -- 大股东认购方式
            ,s_seo_holdersubsrate -- 大股东认购比例(%)
            ,ann_dt -- 最新公告日期
            ,pricingmode -- 定向增发定价方式代码
            ,s_fellow_orgpricemin -- 原始预案价下限
            ,s_fellow_discntratio -- 折扣率
            ,s_fellow_date -- 定增发行日期
            ,s_fellow_subinvitationdt -- 认购邀请书日
            ,s_fellow_year -- 增发年度
            ,s_fellow_objective_code -- 定向增发目的代码
            ,pricingdate -- 定价基准日
            ,is_no_public -- 是否属于非公开发行
            ,expense -- 发行费用(元)
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_ashareseo_op(
            object_id -- 对象id
            ,s_info_windcode -- wind代码
            ,s_fellow_progress -- 方案进度
            ,s_fellow_issuetype -- 发行方式
            ,crncy_code -- 货币代码
            ,s_fellow_price -- 发行价格(元)
            ,s_fellow_amount -- 发行数量(万股)
            ,s_fellow_collection -- 募集资金(元)
            ,s_fellow_recorddate -- 股权登记日
            ,s_fellow_paystartdate -- 向老股东配售(或优先配售)缴款起始日
            ,s_fellow_payenddate -- 向老股东配售(或优先配售)缴款终止日
            ,s_fellow_subdate -- 网上申购日
            ,s_fellow_otcdate -- 股份登记(定向) 日期
            ,s_fellow_listdate -- 向公众增发股份上市日期
            ,s_fellow_instlistdate -- 向机构增发股份上市日期
            ,s_fellow_changedate -- 定向增发股份变动日期
            ,s_fellow_roadshowdate -- 网上路演日
            ,s_fellow_refunddate -- 网下申购资金(定金)退款日
            ,s_fellow_unfrozedate -- 网上申购资金解冻日
            ,s_fellow_preplandate -- 预案公告日
            ,s_fellow_smtganncedate -- 股东大会公告日
            ,s_fellow_passdate -- 发审委通过公告日
            ,s_fellow_approveddate -- 证监会核准公告日
            ,s_fellow_anncedate -- 上网发行公告日
            ,s_fellow_ratioanncedate -- 网上中签率公告日
            ,s_fellow_offeringdate -- 增发公告日
            ,s_fellow_listanndate -- 上市公告日
            ,s_fellow_offeringobject -- 发行对象
            ,s_fellow_priceuplimit -- 增发预案价上限
            ,s_fellow_pricedownlimit -- 增发预案价下限
            ,s_seo_code -- 增发代码
            ,s_seo_name -- 增发简称
            ,s_seo_pe -- 发行市盈率(摊薄)
            ,s_seo_amtbyplacing -- 上网发行数量(万股)
            ,s_seo_amttojur -- 网下发行数量(万股)
            ,s_seo_holdersubsmode -- 大股东认购方式
            ,s_seo_holdersubsrate -- 大股东认购比例(%)
            ,ann_dt -- 最新公告日期
            ,pricingmode -- 定向增发定价方式代码
            ,s_fellow_orgpricemin -- 原始预案价下限
            ,s_fellow_discntratio -- 折扣率
            ,s_fellow_date -- 定增发行日期
            ,s_fellow_subinvitationdt -- 认购邀请书日
            ,s_fellow_year -- 增发年度
            ,s_fellow_objective_code -- 定向增发目的代码
            ,pricingdate -- 定价基准日
            ,is_no_public -- 是否属于非公开发行
            ,expense -- 发行费用(元)
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象id
    ,o.s_info_windcode -- wind代码
    ,o.s_fellow_progress -- 方案进度
    ,o.s_fellow_issuetype -- 发行方式
    ,o.crncy_code -- 货币代码
    ,o.s_fellow_price -- 发行价格(元)
    ,o.s_fellow_amount -- 发行数量(万股)
    ,o.s_fellow_collection -- 募集资金(元)
    ,o.s_fellow_recorddate -- 股权登记日
    ,o.s_fellow_paystartdate -- 向老股东配售(或优先配售)缴款起始日
    ,o.s_fellow_payenddate -- 向老股东配售(或优先配售)缴款终止日
    ,o.s_fellow_subdate -- 网上申购日
    ,o.s_fellow_otcdate -- 股份登记(定向) 日期
    ,o.s_fellow_listdate -- 向公众增发股份上市日期
    ,o.s_fellow_instlistdate -- 向机构增发股份上市日期
    ,o.s_fellow_changedate -- 定向增发股份变动日期
    ,o.s_fellow_roadshowdate -- 网上路演日
    ,o.s_fellow_refunddate -- 网下申购资金(定金)退款日
    ,o.s_fellow_unfrozedate -- 网上申购资金解冻日
    ,o.s_fellow_preplandate -- 预案公告日
    ,o.s_fellow_smtganncedate -- 股东大会公告日
    ,o.s_fellow_passdate -- 发审委通过公告日
    ,o.s_fellow_approveddate -- 证监会核准公告日
    ,o.s_fellow_anncedate -- 上网发行公告日
    ,o.s_fellow_ratioanncedate -- 网上中签率公告日
    ,o.s_fellow_offeringdate -- 增发公告日
    ,o.s_fellow_listanndate -- 上市公告日
    ,o.s_fellow_offeringobject -- 发行对象
    ,o.s_fellow_priceuplimit -- 增发预案价上限
    ,o.s_fellow_pricedownlimit -- 增发预案价下限
    ,o.s_seo_code -- 增发代码
    ,o.s_seo_name -- 增发简称
    ,o.s_seo_pe -- 发行市盈率(摊薄)
    ,o.s_seo_amtbyplacing -- 上网发行数量(万股)
    ,o.s_seo_amttojur -- 网下发行数量(万股)
    ,o.s_seo_holdersubsmode -- 大股东认购方式
    ,o.s_seo_holdersubsrate -- 大股东认购比例(%)
    ,o.ann_dt -- 最新公告日期
    ,o.pricingmode -- 定向增发定价方式代码
    ,o.s_fellow_orgpricemin -- 原始预案价下限
    ,o.s_fellow_discntratio -- 折扣率
    ,o.s_fellow_date -- 定增发行日期
    ,o.s_fellow_subinvitationdt -- 认购邀请书日
    ,o.s_fellow_year -- 增发年度
    ,o.s_fellow_objective_code -- 定向增发目的代码
    ,o.pricingdate -- 定价基准日
    ,o.is_no_public -- 是否属于非公开发行
    ,o.expense -- 发行费用(元)
    ,o.opdate -- 
    ,o.opmode -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_ashareseo_bk o
    left join ${iol_schema}.wind_ashareseo_op n
        on
            o.object_id = n.object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wind_ashareseo_cl d
        on
            o.object_id = d.object_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.wind_ashareseo;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_ashareseo exchange partition p_19000101 with table ${iol_schema}.wind_ashareseo_cl;
alter table ${iol_schema}.wind_ashareseo exchange partition p_20991231 with table ${iol_schema}.wind_ashareseo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_ashareseo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_ashareseo_op purge;
drop table ${iol_schema}.wind_ashareseo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_ashareseo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_ashareseo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
