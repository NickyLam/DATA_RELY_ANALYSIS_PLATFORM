/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_ashareipo
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
create table ${iol_schema}.wind_ashareipo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_ashareipo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_ashareipo_op purge;
drop table ${iol_schema}.wind_ashareipo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareipo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_ashareipo where 0=1;

create table ${iol_schema}.wind_ashareipo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_ashareipo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_ashareipo_cl(
            object_id -- 对象id
            ,s_info_windcode -- wind代码
            ,crncy_code -- 货币代码
            ,s_ipo_price -- 发行价格(元)
            ,s_ipo_pre_dilutedpe -- 发行市盈率(发行前股本)
            ,s_ipo_dilutedpe -- 发行市盈率(发行后股本)
            ,s_ipo_amount -- 发行数量(万股)
            ,s_ipo_amtbyplacing -- 网上发行数量(万股)
            ,s_ipo_amttojur -- 网下发行数量(万股)
            ,s_ipo_collection -- 募集资金(万元)
            ,s_ipo_cashratio -- 网上发行中签率(%)
            ,s_ipo_purchasecode -- 网上申购代码
            ,s_ipo_subdate -- 申购日
            ,s_ipo_jurisdate -- 向一般法人配售上市日期
            ,s_ipo_instisdate -- 向战略投资者配售部分上市日期
            ,s_ipo_expectlistdate -- 预计上市日期
            ,s_ipo_fundverificationdate -- 申购资金验资日
            ,s_ipo_ratiodate -- 中签率公布日
            ,s_fellow_unfrozedate -- 申购资金解冻日
            ,s_ipo_listdate -- 上市日
            ,s_ipo_puboffrdate -- 招股公告日
            ,s_ipo_anncedate -- 发行公告日
            ,s_ipo_anncelstdate -- 上市公告日
            ,s_ipo_roadshowstartdate -- 初步询价(预路演)起始日期
            ,s_ipo_roadshowenddate -- 初步询价(预路演)终止日期
            ,s_ipo_placingdate -- 网下配售发行公告日
            ,s_ipo_applystartdate -- 网下申购起始日期
            ,s_ipo_applyenddate -- 网下申购截止日期
            ,s_ipo_priceannouncedate -- 网下定价公告日
            ,s_ipo_placingresultdate -- 网下配售结果公告日
            ,s_ipo_fundenddate -- 网下申购资金到帐截止日
            ,s_ipo_capverificationdate -- 网下验资日
            ,s_ipo_refunddate -- 网下多余款项退还日
            ,s_ipo_expectedcollection -- 预计募集资金(万元)
            ,s_ipo_list_fee -- 发行费用(万元)
            ,s_ipo_lpurnameonl -- 
            ,s_ipo_cashamtuplimit -- 申购上限(机构)
            ,s_ipo_cashmoneyuplimit -- 申购金额上限(机构)
            ,s_ipo_namebyplacing -- 上网发行简称
            ,s_ipo_showpricedownlimit -- 投标询价申购价格下限
            ,s_ipo_par -- 面值
            ,s_ipo_purchaseuplimit -- 网上申购上限(个人)
            ,s_ipo_op_uplimit -- 网下申购上限
            ,s_ipo_op_downlimit -- 网下申购下限
            ,s_ipo_purchasemv_dt -- 网上市值申购登记日
            ,s_ipo_pubosdtotisscoll -- 公开及原股东募集资金总额
            ,s_ipo_osdexpoffamount -- 新股发行数量
            ,s_ipo_osdexpoffamountup -- 原股东预计售股数量上限
            ,s_ipo_osdactoffamount -- 原股东实际售股数量
            ,s_ipo_osdactoffprice -- 原股东实际售股金额
            ,s_ipo_osdunderwritingfees -- 原股东应摊承销费用
            ,s_ipo_pureffsubratio -- 网上投资者有效认购倍数
            ,s_ipo_reporate -- 回拨比例
            ,ann_dt -- 最新公告日期
            ,is_failure -- 是否发行失败
            ,s_ipo_otc_cash_pct -- 网下申购配售比例
            ,min_applyunit -- 
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_ashareipo_op(
            object_id -- 对象id
            ,s_info_windcode -- wind代码
            ,crncy_code -- 货币代码
            ,s_ipo_price -- 发行价格(元)
            ,s_ipo_pre_dilutedpe -- 发行市盈率(发行前股本)
            ,s_ipo_dilutedpe -- 发行市盈率(发行后股本)
            ,s_ipo_amount -- 发行数量(万股)
            ,s_ipo_amtbyplacing -- 网上发行数量(万股)
            ,s_ipo_amttojur -- 网下发行数量(万股)
            ,s_ipo_collection -- 募集资金(万元)
            ,s_ipo_cashratio -- 网上发行中签率(%)
            ,s_ipo_purchasecode -- 网上申购代码
            ,s_ipo_subdate -- 申购日
            ,s_ipo_jurisdate -- 向一般法人配售上市日期
            ,s_ipo_instisdate -- 向战略投资者配售部分上市日期
            ,s_ipo_expectlistdate -- 预计上市日期
            ,s_ipo_fundverificationdate -- 申购资金验资日
            ,s_ipo_ratiodate -- 中签率公布日
            ,s_fellow_unfrozedate -- 申购资金解冻日
            ,s_ipo_listdate -- 上市日
            ,s_ipo_puboffrdate -- 招股公告日
            ,s_ipo_anncedate -- 发行公告日
            ,s_ipo_anncelstdate -- 上市公告日
            ,s_ipo_roadshowstartdate -- 初步询价(预路演)起始日期
            ,s_ipo_roadshowenddate -- 初步询价(预路演)终止日期
            ,s_ipo_placingdate -- 网下配售发行公告日
            ,s_ipo_applystartdate -- 网下申购起始日期
            ,s_ipo_applyenddate -- 网下申购截止日期
            ,s_ipo_priceannouncedate -- 网下定价公告日
            ,s_ipo_placingresultdate -- 网下配售结果公告日
            ,s_ipo_fundenddate -- 网下申购资金到帐截止日
            ,s_ipo_capverificationdate -- 网下验资日
            ,s_ipo_refunddate -- 网下多余款项退还日
            ,s_ipo_expectedcollection -- 预计募集资金(万元)
            ,s_ipo_list_fee -- 发行费用(万元)
            ,s_ipo_lpurnameonl -- 
            ,s_ipo_cashamtuplimit -- 申购上限(机构)
            ,s_ipo_cashmoneyuplimit -- 申购金额上限(机构)
            ,s_ipo_namebyplacing -- 上网发行简称
            ,s_ipo_showpricedownlimit -- 投标询价申购价格下限
            ,s_ipo_par -- 面值
            ,s_ipo_purchaseuplimit -- 网上申购上限(个人)
            ,s_ipo_op_uplimit -- 网下申购上限
            ,s_ipo_op_downlimit -- 网下申购下限
            ,s_ipo_purchasemv_dt -- 网上市值申购登记日
            ,s_ipo_pubosdtotisscoll -- 公开及原股东募集资金总额
            ,s_ipo_osdexpoffamount -- 新股发行数量
            ,s_ipo_osdexpoffamountup -- 原股东预计售股数量上限
            ,s_ipo_osdactoffamount -- 原股东实际售股数量
            ,s_ipo_osdactoffprice -- 原股东实际售股金额
            ,s_ipo_osdunderwritingfees -- 原股东应摊承销费用
            ,s_ipo_pureffsubratio -- 网上投资者有效认购倍数
            ,s_ipo_reporate -- 回拨比例
            ,ann_dt -- 最新公告日期
            ,is_failure -- 是否发行失败
            ,s_ipo_otc_cash_pct -- 网下申购配售比例
            ,min_applyunit -- 
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
    ,nvl(n.crncy_code, o.crncy_code) as crncy_code -- 货币代码
    ,nvl(n.s_ipo_price, o.s_ipo_price) as s_ipo_price -- 发行价格(元)
    ,nvl(n.s_ipo_pre_dilutedpe, o.s_ipo_pre_dilutedpe) as s_ipo_pre_dilutedpe -- 发行市盈率(发行前股本)
    ,nvl(n.s_ipo_dilutedpe, o.s_ipo_dilutedpe) as s_ipo_dilutedpe -- 发行市盈率(发行后股本)
    ,nvl(n.s_ipo_amount, o.s_ipo_amount) as s_ipo_amount -- 发行数量(万股)
    ,nvl(n.s_ipo_amtbyplacing, o.s_ipo_amtbyplacing) as s_ipo_amtbyplacing -- 网上发行数量(万股)
    ,nvl(n.s_ipo_amttojur, o.s_ipo_amttojur) as s_ipo_amttojur -- 网下发行数量(万股)
    ,nvl(n.s_ipo_collection, o.s_ipo_collection) as s_ipo_collection -- 募集资金(万元)
    ,nvl(n.s_ipo_cashratio, o.s_ipo_cashratio) as s_ipo_cashratio -- 网上发行中签率(%)
    ,nvl(n.s_ipo_purchasecode, o.s_ipo_purchasecode) as s_ipo_purchasecode -- 网上申购代码
    ,nvl(n.s_ipo_subdate, o.s_ipo_subdate) as s_ipo_subdate -- 申购日
    ,nvl(n.s_ipo_jurisdate, o.s_ipo_jurisdate) as s_ipo_jurisdate -- 向一般法人配售上市日期
    ,nvl(n.s_ipo_instisdate, o.s_ipo_instisdate) as s_ipo_instisdate -- 向战略投资者配售部分上市日期
    ,nvl(n.s_ipo_expectlistdate, o.s_ipo_expectlistdate) as s_ipo_expectlistdate -- 预计上市日期
    ,nvl(n.s_ipo_fundverificationdate, o.s_ipo_fundverificationdate) as s_ipo_fundverificationdate -- 申购资金验资日
    ,nvl(n.s_ipo_ratiodate, o.s_ipo_ratiodate) as s_ipo_ratiodate -- 中签率公布日
    ,nvl(n.s_fellow_unfrozedate, o.s_fellow_unfrozedate) as s_fellow_unfrozedate -- 申购资金解冻日
    ,nvl(n.s_ipo_listdate, o.s_ipo_listdate) as s_ipo_listdate -- 上市日
    ,nvl(n.s_ipo_puboffrdate, o.s_ipo_puboffrdate) as s_ipo_puboffrdate -- 招股公告日
    ,nvl(n.s_ipo_anncedate, o.s_ipo_anncedate) as s_ipo_anncedate -- 发行公告日
    ,nvl(n.s_ipo_anncelstdate, o.s_ipo_anncelstdate) as s_ipo_anncelstdate -- 上市公告日
    ,nvl(n.s_ipo_roadshowstartdate, o.s_ipo_roadshowstartdate) as s_ipo_roadshowstartdate -- 初步询价(预路演)起始日期
    ,nvl(n.s_ipo_roadshowenddate, o.s_ipo_roadshowenddate) as s_ipo_roadshowenddate -- 初步询价(预路演)终止日期
    ,nvl(n.s_ipo_placingdate, o.s_ipo_placingdate) as s_ipo_placingdate -- 网下配售发行公告日
    ,nvl(n.s_ipo_applystartdate, o.s_ipo_applystartdate) as s_ipo_applystartdate -- 网下申购起始日期
    ,nvl(n.s_ipo_applyenddate, o.s_ipo_applyenddate) as s_ipo_applyenddate -- 网下申购截止日期
    ,nvl(n.s_ipo_priceannouncedate, o.s_ipo_priceannouncedate) as s_ipo_priceannouncedate -- 网下定价公告日
    ,nvl(n.s_ipo_placingresultdate, o.s_ipo_placingresultdate) as s_ipo_placingresultdate -- 网下配售结果公告日
    ,nvl(n.s_ipo_fundenddate, o.s_ipo_fundenddate) as s_ipo_fundenddate -- 网下申购资金到帐截止日
    ,nvl(n.s_ipo_capverificationdate, o.s_ipo_capverificationdate) as s_ipo_capverificationdate -- 网下验资日
    ,nvl(n.s_ipo_refunddate, o.s_ipo_refunddate) as s_ipo_refunddate -- 网下多余款项退还日
    ,nvl(n.s_ipo_expectedcollection, o.s_ipo_expectedcollection) as s_ipo_expectedcollection -- 预计募集资金(万元)
    ,nvl(n.s_ipo_list_fee, o.s_ipo_list_fee) as s_ipo_list_fee -- 发行费用(万元)
    ,nvl(n.s_ipo_lpurnameonl, o.s_ipo_lpurnameonl) as s_ipo_lpurnameonl -- 
    ,nvl(n.s_ipo_cashamtuplimit, o.s_ipo_cashamtuplimit) as s_ipo_cashamtuplimit -- 申购上限(机构)
    ,nvl(n.s_ipo_cashmoneyuplimit, o.s_ipo_cashmoneyuplimit) as s_ipo_cashmoneyuplimit -- 申购金额上限(机构)
    ,nvl(n.s_ipo_namebyplacing, o.s_ipo_namebyplacing) as s_ipo_namebyplacing -- 上网发行简称
    ,nvl(n.s_ipo_showpricedownlimit, o.s_ipo_showpricedownlimit) as s_ipo_showpricedownlimit -- 投标询价申购价格下限
    ,nvl(n.s_ipo_par, o.s_ipo_par) as s_ipo_par -- 面值
    ,nvl(n.s_ipo_purchaseuplimit, o.s_ipo_purchaseuplimit) as s_ipo_purchaseuplimit -- 网上申购上限(个人)
    ,nvl(n.s_ipo_op_uplimit, o.s_ipo_op_uplimit) as s_ipo_op_uplimit -- 网下申购上限
    ,nvl(n.s_ipo_op_downlimit, o.s_ipo_op_downlimit) as s_ipo_op_downlimit -- 网下申购下限
    ,nvl(n.s_ipo_purchasemv_dt, o.s_ipo_purchasemv_dt) as s_ipo_purchasemv_dt -- 网上市值申购登记日
    ,nvl(n.s_ipo_pubosdtotisscoll, o.s_ipo_pubosdtotisscoll) as s_ipo_pubosdtotisscoll -- 公开及原股东募集资金总额
    ,nvl(n.s_ipo_osdexpoffamount, o.s_ipo_osdexpoffamount) as s_ipo_osdexpoffamount -- 新股发行数量
    ,nvl(n.s_ipo_osdexpoffamountup, o.s_ipo_osdexpoffamountup) as s_ipo_osdexpoffamountup -- 原股东预计售股数量上限
    ,nvl(n.s_ipo_osdactoffamount, o.s_ipo_osdactoffamount) as s_ipo_osdactoffamount -- 原股东实际售股数量
    ,nvl(n.s_ipo_osdactoffprice, o.s_ipo_osdactoffprice) as s_ipo_osdactoffprice -- 原股东实际售股金额
    ,nvl(n.s_ipo_osdunderwritingfees, o.s_ipo_osdunderwritingfees) as s_ipo_osdunderwritingfees -- 原股东应摊承销费用
    ,nvl(n.s_ipo_pureffsubratio, o.s_ipo_pureffsubratio) as s_ipo_pureffsubratio -- 网上投资者有效认购倍数
    ,nvl(n.s_ipo_reporate, o.s_ipo_reporate) as s_ipo_reporate -- 回拨比例
    ,nvl(n.ann_dt, o.ann_dt) as ann_dt -- 最新公告日期
    ,nvl(n.is_failure, o.is_failure) as is_failure -- 是否发行失败
    ,nvl(n.s_ipo_otc_cash_pct, o.s_ipo_otc_cash_pct) as s_ipo_otc_cash_pct -- 网下申购配售比例
    ,nvl(n.min_applyunit, o.min_applyunit) as min_applyunit -- 
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
from (select * from ${iol_schema}.wind_ashareipo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wind_ashareipo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.crncy_code <> n.crncy_code
        or o.s_ipo_price <> n.s_ipo_price
        or o.s_ipo_pre_dilutedpe <> n.s_ipo_pre_dilutedpe
        or o.s_ipo_dilutedpe <> n.s_ipo_dilutedpe
        or o.s_ipo_amount <> n.s_ipo_amount
        or o.s_ipo_amtbyplacing <> n.s_ipo_amtbyplacing
        or o.s_ipo_amttojur <> n.s_ipo_amttojur
        or o.s_ipo_collection <> n.s_ipo_collection
        or o.s_ipo_cashratio <> n.s_ipo_cashratio
        or o.s_ipo_purchasecode <> n.s_ipo_purchasecode
        or o.s_ipo_subdate <> n.s_ipo_subdate
        or o.s_ipo_jurisdate <> n.s_ipo_jurisdate
        or o.s_ipo_instisdate <> n.s_ipo_instisdate
        or o.s_ipo_expectlistdate <> n.s_ipo_expectlistdate
        or o.s_ipo_fundverificationdate <> n.s_ipo_fundverificationdate
        or o.s_ipo_ratiodate <> n.s_ipo_ratiodate
        or o.s_fellow_unfrozedate <> n.s_fellow_unfrozedate
        or o.s_ipo_listdate <> n.s_ipo_listdate
        or o.s_ipo_puboffrdate <> n.s_ipo_puboffrdate
        or o.s_ipo_anncedate <> n.s_ipo_anncedate
        or o.s_ipo_anncelstdate <> n.s_ipo_anncelstdate
        or o.s_ipo_roadshowstartdate <> n.s_ipo_roadshowstartdate
        or o.s_ipo_roadshowenddate <> n.s_ipo_roadshowenddate
        or o.s_ipo_placingdate <> n.s_ipo_placingdate
        or o.s_ipo_applystartdate <> n.s_ipo_applystartdate
        or o.s_ipo_applyenddate <> n.s_ipo_applyenddate
        or o.s_ipo_priceannouncedate <> n.s_ipo_priceannouncedate
        or o.s_ipo_placingresultdate <> n.s_ipo_placingresultdate
        or o.s_ipo_fundenddate <> n.s_ipo_fundenddate
        or o.s_ipo_capverificationdate <> n.s_ipo_capverificationdate
        or o.s_ipo_refunddate <> n.s_ipo_refunddate
        or o.s_ipo_expectedcollection <> n.s_ipo_expectedcollection
        or o.s_ipo_list_fee <> n.s_ipo_list_fee
        or o.s_ipo_lpurnameonl <> n.s_ipo_lpurnameonl
        or o.s_ipo_cashamtuplimit <> n.s_ipo_cashamtuplimit
        or o.s_ipo_cashmoneyuplimit <> n.s_ipo_cashmoneyuplimit
        or o.s_ipo_namebyplacing <> n.s_ipo_namebyplacing
        or o.s_ipo_showpricedownlimit <> n.s_ipo_showpricedownlimit
        or o.s_ipo_par <> n.s_ipo_par
        or o.s_ipo_purchaseuplimit <> n.s_ipo_purchaseuplimit
        or o.s_ipo_op_uplimit <> n.s_ipo_op_uplimit
        or o.s_ipo_op_downlimit <> n.s_ipo_op_downlimit
        or o.s_ipo_purchasemv_dt <> n.s_ipo_purchasemv_dt
        or o.s_ipo_pubosdtotisscoll <> n.s_ipo_pubosdtotisscoll
        or o.s_ipo_osdexpoffamount <> n.s_ipo_osdexpoffamount
        or o.s_ipo_osdexpoffamountup <> n.s_ipo_osdexpoffamountup
        or o.s_ipo_osdactoffamount <> n.s_ipo_osdactoffamount
        or o.s_ipo_osdactoffprice <> n.s_ipo_osdactoffprice
        or o.s_ipo_osdunderwritingfees <> n.s_ipo_osdunderwritingfees
        or o.s_ipo_pureffsubratio <> n.s_ipo_pureffsubratio
        or o.s_ipo_reporate <> n.s_ipo_reporate
        or o.ann_dt <> n.ann_dt
        or o.is_failure <> n.is_failure
        or o.s_ipo_otc_cash_pct <> n.s_ipo_otc_cash_pct
        or o.min_applyunit <> n.min_applyunit
        or o.opdate <> n.opdate
        or o.opmode <> n.opmode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_ashareipo_cl(
            object_id -- 对象id
            ,s_info_windcode -- wind代码
            ,crncy_code -- 货币代码
            ,s_ipo_price -- 发行价格(元)
            ,s_ipo_pre_dilutedpe -- 发行市盈率(发行前股本)
            ,s_ipo_dilutedpe -- 发行市盈率(发行后股本)
            ,s_ipo_amount -- 发行数量(万股)
            ,s_ipo_amtbyplacing -- 网上发行数量(万股)
            ,s_ipo_amttojur -- 网下发行数量(万股)
            ,s_ipo_collection -- 募集资金(万元)
            ,s_ipo_cashratio -- 网上发行中签率(%)
            ,s_ipo_purchasecode -- 网上申购代码
            ,s_ipo_subdate -- 申购日
            ,s_ipo_jurisdate -- 向一般法人配售上市日期
            ,s_ipo_instisdate -- 向战略投资者配售部分上市日期
            ,s_ipo_expectlistdate -- 预计上市日期
            ,s_ipo_fundverificationdate -- 申购资金验资日
            ,s_ipo_ratiodate -- 中签率公布日
            ,s_fellow_unfrozedate -- 申购资金解冻日
            ,s_ipo_listdate -- 上市日
            ,s_ipo_puboffrdate -- 招股公告日
            ,s_ipo_anncedate -- 发行公告日
            ,s_ipo_anncelstdate -- 上市公告日
            ,s_ipo_roadshowstartdate -- 初步询价(预路演)起始日期
            ,s_ipo_roadshowenddate -- 初步询价(预路演)终止日期
            ,s_ipo_placingdate -- 网下配售发行公告日
            ,s_ipo_applystartdate -- 网下申购起始日期
            ,s_ipo_applyenddate -- 网下申购截止日期
            ,s_ipo_priceannouncedate -- 网下定价公告日
            ,s_ipo_placingresultdate -- 网下配售结果公告日
            ,s_ipo_fundenddate -- 网下申购资金到帐截止日
            ,s_ipo_capverificationdate -- 网下验资日
            ,s_ipo_refunddate -- 网下多余款项退还日
            ,s_ipo_expectedcollection -- 预计募集资金(万元)
            ,s_ipo_list_fee -- 发行费用(万元)
            ,s_ipo_lpurnameonl -- 
            ,s_ipo_cashamtuplimit -- 申购上限(机构)
            ,s_ipo_cashmoneyuplimit -- 申购金额上限(机构)
            ,s_ipo_namebyplacing -- 上网发行简称
            ,s_ipo_showpricedownlimit -- 投标询价申购价格下限
            ,s_ipo_par -- 面值
            ,s_ipo_purchaseuplimit -- 网上申购上限(个人)
            ,s_ipo_op_uplimit -- 网下申购上限
            ,s_ipo_op_downlimit -- 网下申购下限
            ,s_ipo_purchasemv_dt -- 网上市值申购登记日
            ,s_ipo_pubosdtotisscoll -- 公开及原股东募集资金总额
            ,s_ipo_osdexpoffamount -- 新股发行数量
            ,s_ipo_osdexpoffamountup -- 原股东预计售股数量上限
            ,s_ipo_osdactoffamount -- 原股东实际售股数量
            ,s_ipo_osdactoffprice -- 原股东实际售股金额
            ,s_ipo_osdunderwritingfees -- 原股东应摊承销费用
            ,s_ipo_pureffsubratio -- 网上投资者有效认购倍数
            ,s_ipo_reporate -- 回拨比例
            ,ann_dt -- 最新公告日期
            ,is_failure -- 是否发行失败
            ,s_ipo_otc_cash_pct -- 网下申购配售比例
            ,min_applyunit -- 
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_ashareipo_op(
            object_id -- 对象id
            ,s_info_windcode -- wind代码
            ,crncy_code -- 货币代码
            ,s_ipo_price -- 发行价格(元)
            ,s_ipo_pre_dilutedpe -- 发行市盈率(发行前股本)
            ,s_ipo_dilutedpe -- 发行市盈率(发行后股本)
            ,s_ipo_amount -- 发行数量(万股)
            ,s_ipo_amtbyplacing -- 网上发行数量(万股)
            ,s_ipo_amttojur -- 网下发行数量(万股)
            ,s_ipo_collection -- 募集资金(万元)
            ,s_ipo_cashratio -- 网上发行中签率(%)
            ,s_ipo_purchasecode -- 网上申购代码
            ,s_ipo_subdate -- 申购日
            ,s_ipo_jurisdate -- 向一般法人配售上市日期
            ,s_ipo_instisdate -- 向战略投资者配售部分上市日期
            ,s_ipo_expectlistdate -- 预计上市日期
            ,s_ipo_fundverificationdate -- 申购资金验资日
            ,s_ipo_ratiodate -- 中签率公布日
            ,s_fellow_unfrozedate -- 申购资金解冻日
            ,s_ipo_listdate -- 上市日
            ,s_ipo_puboffrdate -- 招股公告日
            ,s_ipo_anncedate -- 发行公告日
            ,s_ipo_anncelstdate -- 上市公告日
            ,s_ipo_roadshowstartdate -- 初步询价(预路演)起始日期
            ,s_ipo_roadshowenddate -- 初步询价(预路演)终止日期
            ,s_ipo_placingdate -- 网下配售发行公告日
            ,s_ipo_applystartdate -- 网下申购起始日期
            ,s_ipo_applyenddate -- 网下申购截止日期
            ,s_ipo_priceannouncedate -- 网下定价公告日
            ,s_ipo_placingresultdate -- 网下配售结果公告日
            ,s_ipo_fundenddate -- 网下申购资金到帐截止日
            ,s_ipo_capverificationdate -- 网下验资日
            ,s_ipo_refunddate -- 网下多余款项退还日
            ,s_ipo_expectedcollection -- 预计募集资金(万元)
            ,s_ipo_list_fee -- 发行费用(万元)
            ,s_ipo_lpurnameonl -- 
            ,s_ipo_cashamtuplimit -- 申购上限(机构)
            ,s_ipo_cashmoneyuplimit -- 申购金额上限(机构)
            ,s_ipo_namebyplacing -- 上网发行简称
            ,s_ipo_showpricedownlimit -- 投标询价申购价格下限
            ,s_ipo_par -- 面值
            ,s_ipo_purchaseuplimit -- 网上申购上限(个人)
            ,s_ipo_op_uplimit -- 网下申购上限
            ,s_ipo_op_downlimit -- 网下申购下限
            ,s_ipo_purchasemv_dt -- 网上市值申购登记日
            ,s_ipo_pubosdtotisscoll -- 公开及原股东募集资金总额
            ,s_ipo_osdexpoffamount -- 新股发行数量
            ,s_ipo_osdexpoffamountup -- 原股东预计售股数量上限
            ,s_ipo_osdactoffamount -- 原股东实际售股数量
            ,s_ipo_osdactoffprice -- 原股东实际售股金额
            ,s_ipo_osdunderwritingfees -- 原股东应摊承销费用
            ,s_ipo_pureffsubratio -- 网上投资者有效认购倍数
            ,s_ipo_reporate -- 回拨比例
            ,ann_dt -- 最新公告日期
            ,is_failure -- 是否发行失败
            ,s_ipo_otc_cash_pct -- 网下申购配售比例
            ,min_applyunit -- 
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
    ,o.crncy_code -- 货币代码
    ,o.s_ipo_price -- 发行价格(元)
    ,o.s_ipo_pre_dilutedpe -- 发行市盈率(发行前股本)
    ,o.s_ipo_dilutedpe -- 发行市盈率(发行后股本)
    ,o.s_ipo_amount -- 发行数量(万股)
    ,o.s_ipo_amtbyplacing -- 网上发行数量(万股)
    ,o.s_ipo_amttojur -- 网下发行数量(万股)
    ,o.s_ipo_collection -- 募集资金(万元)
    ,o.s_ipo_cashratio -- 网上发行中签率(%)
    ,o.s_ipo_purchasecode -- 网上申购代码
    ,o.s_ipo_subdate -- 申购日
    ,o.s_ipo_jurisdate -- 向一般法人配售上市日期
    ,o.s_ipo_instisdate -- 向战略投资者配售部分上市日期
    ,o.s_ipo_expectlistdate -- 预计上市日期
    ,o.s_ipo_fundverificationdate -- 申购资金验资日
    ,o.s_ipo_ratiodate -- 中签率公布日
    ,o.s_fellow_unfrozedate -- 申购资金解冻日
    ,o.s_ipo_listdate -- 上市日
    ,o.s_ipo_puboffrdate -- 招股公告日
    ,o.s_ipo_anncedate -- 发行公告日
    ,o.s_ipo_anncelstdate -- 上市公告日
    ,o.s_ipo_roadshowstartdate -- 初步询价(预路演)起始日期
    ,o.s_ipo_roadshowenddate -- 初步询价(预路演)终止日期
    ,o.s_ipo_placingdate -- 网下配售发行公告日
    ,o.s_ipo_applystartdate -- 网下申购起始日期
    ,o.s_ipo_applyenddate -- 网下申购截止日期
    ,o.s_ipo_priceannouncedate -- 网下定价公告日
    ,o.s_ipo_placingresultdate -- 网下配售结果公告日
    ,o.s_ipo_fundenddate -- 网下申购资金到帐截止日
    ,o.s_ipo_capverificationdate -- 网下验资日
    ,o.s_ipo_refunddate -- 网下多余款项退还日
    ,o.s_ipo_expectedcollection -- 预计募集资金(万元)
    ,o.s_ipo_list_fee -- 发行费用(万元)
    ,o.s_ipo_lpurnameonl -- 
    ,o.s_ipo_cashamtuplimit -- 申购上限(机构)
    ,o.s_ipo_cashmoneyuplimit -- 申购金额上限(机构)
    ,o.s_ipo_namebyplacing -- 上网发行简称
    ,o.s_ipo_showpricedownlimit -- 投标询价申购价格下限
    ,o.s_ipo_par -- 面值
    ,o.s_ipo_purchaseuplimit -- 网上申购上限(个人)
    ,o.s_ipo_op_uplimit -- 网下申购上限
    ,o.s_ipo_op_downlimit -- 网下申购下限
    ,o.s_ipo_purchasemv_dt -- 网上市值申购登记日
    ,o.s_ipo_pubosdtotisscoll -- 公开及原股东募集资金总额
    ,o.s_ipo_osdexpoffamount -- 新股发行数量
    ,o.s_ipo_osdexpoffamountup -- 原股东预计售股数量上限
    ,o.s_ipo_osdactoffamount -- 原股东实际售股数量
    ,o.s_ipo_osdactoffprice -- 原股东实际售股金额
    ,o.s_ipo_osdunderwritingfees -- 原股东应摊承销费用
    ,o.s_ipo_pureffsubratio -- 网上投资者有效认购倍数
    ,o.s_ipo_reporate -- 回拨比例
    ,o.ann_dt -- 最新公告日期
    ,o.is_failure -- 是否发行失败
    ,o.s_ipo_otc_cash_pct -- 网下申购配售比例
    ,o.min_applyunit -- 
    ,o.opdate -- 
    ,o.opmode -- 
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
from ${iol_schema}.wind_ashareipo_bk o
    left join ${iol_schema}.wind_ashareipo_op n
        on
            o.object_id = n.object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wind_ashareipo_cl d
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
--truncate table ${iol_schema}.wind_ashareipo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('wind_ashareipo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.wind_ashareipo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.wind_ashareipo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.wind_ashareipo exchange partition p_${batch_date} with table ${iol_schema}.wind_ashareipo_cl;
alter table ${iol_schema}.wind_ashareipo exchange partition p_20991231 with table ${iol_schema}.wind_ashareipo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_ashareipo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_ashareipo_op purge;
drop table ${iol_schema}.wind_ashareipo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_ashareipo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_ashareipo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
