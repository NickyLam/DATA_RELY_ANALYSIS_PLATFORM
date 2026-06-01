/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_fin_trade_product
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
create table ${iol_schema}.fams_fin_trade_product_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_fin_trade_product;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_trade_product_op purge;
drop table ${iol_schema}.fams_fin_trade_product_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_trade_product_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_trade_product where 0=1;

create table ${iol_schema}.fams_fin_trade_product_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_trade_product where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_trade_product_cl(
            finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,finprod_type -- 金融产品类型（估值核算），回购、拆借、利率互换等
            ,finprod_type2 -- 金融产品类型（投管分类），回购、拆入、拆出、特拆拆入、利率互换、理财产品子产品等
            ,profit_type -- 收益类型，净值、预期收益、货币、结构
            ,branch_type -- 分支类型
            ,chl_agrt_id -- 通道代码
            ,prin -- 名义本金
            ,ccy -- 本金币种
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,term -- 期限(天)
            ,int_type -- 利率类型
            ,int_rate -- 固定利率
            ,int_rate_id -- 浮动利率基准编号
            ,basis -- 计息基础
            ,m_prin_amt -- 到期本金
            ,m_int_amt -- 到期利息
            ,m_trade_amt -- 到期金额
            ,capi_income_feature -- 本金收益特征，保本、非保本
            ,o_finprod_id -- 原金融产品代码，发生标的转换时用
            ,trade_market -- 交易场所
            ,calendar_id -- 交易日历
            ,term_type -- 期限品种
            ,counter_id -- 交易对手
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,m_unit_cprice -- 
            ,m_unit_int -- 
            ,m_unit_fprice -- 
            ,m_yield -- 
            ,m_delivery_type -- 
            ,vpay_date -- 首期交付日
            ,mpay_date -- 到期交付日
            ,contract_no -- 合同编号
            ,act_cap_days -- 实际占款天数
            ,irs_type -- 互换方式
            ,exc_ps -- 外汇交易方向
            ,cur_pair -- 货币对
            ,exc_fxs_term_type -- 掉期期限类型
            ,usd_amt -- 到期折美元金额
            ,dif_settle_ref_rate -- 差额交割参考汇率
            ,conflict_solve_way -- 争议解决方式
            ,period_id -- 期次代码
            ,is_rush_back -- 截止日是否冲回
            ,contract_name -- 合同名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_trade_product_op(
            finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,finprod_type -- 金融产品类型（估值核算），回购、拆借、利率互换等
            ,finprod_type2 -- 金融产品类型（投管分类），回购、拆入、拆出、特拆拆入、利率互换、理财产品子产品等
            ,profit_type -- 收益类型，净值、预期收益、货币、结构
            ,branch_type -- 分支类型
            ,chl_agrt_id -- 通道代码
            ,prin -- 名义本金
            ,ccy -- 本金币种
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,term -- 期限(天)
            ,int_type -- 利率类型
            ,int_rate -- 固定利率
            ,int_rate_id -- 浮动利率基准编号
            ,basis -- 计息基础
            ,m_prin_amt -- 到期本金
            ,m_int_amt -- 到期利息
            ,m_trade_amt -- 到期金额
            ,capi_income_feature -- 本金收益特征，保本、非保本
            ,o_finprod_id -- 原金融产品代码，发生标的转换时用
            ,trade_market -- 交易场所
            ,calendar_id -- 交易日历
            ,term_type -- 期限品种
            ,counter_id -- 交易对手
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,m_unit_cprice -- 
            ,m_unit_int -- 
            ,m_unit_fprice -- 
            ,m_yield -- 
            ,m_delivery_type -- 
            ,vpay_date -- 首期交付日
            ,mpay_date -- 到期交付日
            ,contract_no -- 合同编号
            ,act_cap_days -- 实际占款天数
            ,irs_type -- 互换方式
            ,exc_ps -- 外汇交易方向
            ,cur_pair -- 货币对
            ,exc_fxs_term_type -- 掉期期限类型
            ,usd_amt -- 到期折美元金额
            ,dif_settle_ref_rate -- 差额交割参考汇率
            ,conflict_solve_way -- 争议解决方式
            ,period_id -- 期次代码
            ,is_rush_back -- 截止日是否冲回
            ,contract_name -- 合同名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.branch, o.branch) as branch -- 分支序号
    ,nvl(n.finprod_type, o.finprod_type) as finprod_type -- 金融产品类型（估值核算），回购、拆借、利率互换等
    ,nvl(n.finprod_type2, o.finprod_type2) as finprod_type2 -- 金融产品类型（投管分类），回购、拆入、拆出、特拆拆入、利率互换、理财产品子产品等
    ,nvl(n.profit_type, o.profit_type) as profit_type -- 收益类型，净值、预期收益、货币、结构
    ,nvl(n.branch_type, o.branch_type) as branch_type -- 分支类型
    ,nvl(n.chl_agrt_id, o.chl_agrt_id) as chl_agrt_id -- 通道代码
    ,nvl(n.prin, o.prin) as prin -- 名义本金
    ,nvl(n.ccy, o.ccy) as ccy -- 本金币种
    ,nvl(n.vdate, o.vdate) as vdate -- 起息日
    ,nvl(n.mdate, o.mdate) as mdate -- 到期日
    ,nvl(n.term, o.term) as term -- 期限(天)
    ,nvl(n.int_type, o.int_type) as int_type -- 利率类型
    ,nvl(n.int_rate, o.int_rate) as int_rate -- 固定利率
    ,nvl(n.int_rate_id, o.int_rate_id) as int_rate_id -- 浮动利率基准编号
    ,nvl(n.basis, o.basis) as basis -- 计息基础
    ,nvl(n.m_prin_amt, o.m_prin_amt) as m_prin_amt -- 到期本金
    ,nvl(n.m_int_amt, o.m_int_amt) as m_int_amt -- 到期利息
    ,nvl(n.m_trade_amt, o.m_trade_amt) as m_trade_amt -- 到期金额
    ,nvl(n.capi_income_feature, o.capi_income_feature) as capi_income_feature -- 本金收益特征，保本、非保本
    ,nvl(n.o_finprod_id, o.o_finprod_id) as o_finprod_id -- 原金融产品代码，发生标的转换时用
    ,nvl(n.trade_market, o.trade_market) as trade_market -- 交易场所
    ,nvl(n.calendar_id, o.calendar_id) as calendar_id -- 交易日历
    ,nvl(n.term_type, o.term_type) as term_type -- 期限品种
    ,nvl(n.counter_id, o.counter_id) as counter_id -- 交易对手
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.m_unit_cprice, o.m_unit_cprice) as m_unit_cprice -- 
    ,nvl(n.m_unit_int, o.m_unit_int) as m_unit_int -- 
    ,nvl(n.m_unit_fprice, o.m_unit_fprice) as m_unit_fprice -- 
    ,nvl(n.m_yield, o.m_yield) as m_yield -- 
    ,nvl(n.m_delivery_type, o.m_delivery_type) as m_delivery_type -- 
    ,nvl(n.vpay_date, o.vpay_date) as vpay_date -- 首期交付日
    ,nvl(n.mpay_date, o.mpay_date) as mpay_date -- 到期交付日
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合同编号
    ,nvl(n.act_cap_days, o.act_cap_days) as act_cap_days -- 实际占款天数
    ,nvl(n.irs_type, o.irs_type) as irs_type -- 互换方式
    ,nvl(n.exc_ps, o.exc_ps) as exc_ps -- 外汇交易方向
    ,nvl(n.cur_pair, o.cur_pair) as cur_pair -- 货币对
    ,nvl(n.exc_fxs_term_type, o.exc_fxs_term_type) as exc_fxs_term_type -- 掉期期限类型
    ,nvl(n.usd_amt, o.usd_amt) as usd_amt -- 到期折美元金额
    ,nvl(n.dif_settle_ref_rate, o.dif_settle_ref_rate) as dif_settle_ref_rate -- 差额交割参考汇率
    ,nvl(n.conflict_solve_way, o.conflict_solve_way) as conflict_solve_way -- 争议解决方式
    ,nvl(n.period_id, o.period_id) as period_id -- 期次代码
    ,nvl(n.is_rush_back, o.is_rush_back) as is_rush_back -- 截止日是否冲回
    ,nvl(n.contract_name, o.contract_name) as contract_name -- 合同名称
    ,case when
            n.finprod_id is null
            and n.branch is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.finprod_id is null
            and n.branch is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.finprod_id is null
            and n.branch is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_fin_trade_product_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_fin_trade_product where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.finprod_id = n.finprod_id
            and o.branch = n.branch
where (
        o.finprod_id is null
        and o.branch is null
    )
    or (
        n.finprod_id is null
        and n.branch is null
    )
    or (
        o.finprod_type <> n.finprod_type
        or o.finprod_type2 <> n.finprod_type2
        or o.profit_type <> n.profit_type
        or o.branch_type <> n.branch_type
        or o.chl_agrt_id <> n.chl_agrt_id
        or o.prin <> n.prin
        or o.ccy <> n.ccy
        or o.vdate <> n.vdate
        or o.mdate <> n.mdate
        or o.term <> n.term
        or o.int_type <> n.int_type
        or o.int_rate <> n.int_rate
        or o.int_rate_id <> n.int_rate_id
        or o.basis <> n.basis
        or o.m_prin_amt <> n.m_prin_amt
        or o.m_int_amt <> n.m_int_amt
        or o.m_trade_amt <> n.m_trade_amt
        or o.capi_income_feature <> n.capi_income_feature
        or o.o_finprod_id <> n.o_finprod_id
        or o.trade_market <> n.trade_market
        or o.calendar_id <> n.calendar_id
        or o.term_type <> n.term_type
        or o.counter_id <> n.counter_id
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.m_unit_cprice <> n.m_unit_cprice
        or o.m_unit_int <> n.m_unit_int
        or o.m_unit_fprice <> n.m_unit_fprice
        or o.m_yield <> n.m_yield
        or o.m_delivery_type <> n.m_delivery_type
        or o.vpay_date <> n.vpay_date
        or o.mpay_date <> n.mpay_date
        or o.contract_no <> n.contract_no
        or o.act_cap_days <> n.act_cap_days
        or o.irs_type <> n.irs_type
        or o.exc_ps <> n.exc_ps
        or o.cur_pair <> n.cur_pair
        or o.exc_fxs_term_type <> n.exc_fxs_term_type
        or o.usd_amt <> n.usd_amt
        or o.dif_settle_ref_rate <> n.dif_settle_ref_rate
        or o.conflict_solve_way <> n.conflict_solve_way
        or o.period_id <> n.period_id
        or o.is_rush_back <> n.is_rush_back
        or o.contract_name <> n.contract_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_trade_product_cl(
            finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,finprod_type -- 金融产品类型（估值核算），回购、拆借、利率互换等
            ,finprod_type2 -- 金融产品类型（投管分类），回购、拆入、拆出、特拆拆入、利率互换、理财产品子产品等
            ,profit_type -- 收益类型，净值、预期收益、货币、结构
            ,branch_type -- 分支类型
            ,chl_agrt_id -- 通道代码
            ,prin -- 名义本金
            ,ccy -- 本金币种
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,term -- 期限(天)
            ,int_type -- 利率类型
            ,int_rate -- 固定利率
            ,int_rate_id -- 浮动利率基准编号
            ,basis -- 计息基础
            ,m_prin_amt -- 到期本金
            ,m_int_amt -- 到期利息
            ,m_trade_amt -- 到期金额
            ,capi_income_feature -- 本金收益特征，保本、非保本
            ,o_finprod_id -- 原金融产品代码，发生标的转换时用
            ,trade_market -- 交易场所
            ,calendar_id -- 交易日历
            ,term_type -- 期限品种
            ,counter_id -- 交易对手
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,m_unit_cprice -- 
            ,m_unit_int -- 
            ,m_unit_fprice -- 
            ,m_yield -- 
            ,m_delivery_type -- 
            ,vpay_date -- 首期交付日
            ,mpay_date -- 到期交付日
            ,contract_no -- 合同编号
            ,act_cap_days -- 实际占款天数
            ,irs_type -- 互换方式
            ,exc_ps -- 外汇交易方向
            ,cur_pair -- 货币对
            ,exc_fxs_term_type -- 掉期期限类型
            ,usd_amt -- 到期折美元金额
            ,dif_settle_ref_rate -- 差额交割参考汇率
            ,conflict_solve_way -- 争议解决方式
            ,period_id -- 期次代码
            ,is_rush_back -- 截止日是否冲回
            ,contract_name -- 合同名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_trade_product_op(
            finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,finprod_type -- 金融产品类型（估值核算），回购、拆借、利率互换等
            ,finprod_type2 -- 金融产品类型（投管分类），回购、拆入、拆出、特拆拆入、利率互换、理财产品子产品等
            ,profit_type -- 收益类型，净值、预期收益、货币、结构
            ,branch_type -- 分支类型
            ,chl_agrt_id -- 通道代码
            ,prin -- 名义本金
            ,ccy -- 本金币种
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,term -- 期限(天)
            ,int_type -- 利率类型
            ,int_rate -- 固定利率
            ,int_rate_id -- 浮动利率基准编号
            ,basis -- 计息基础
            ,m_prin_amt -- 到期本金
            ,m_int_amt -- 到期利息
            ,m_trade_amt -- 到期金额
            ,capi_income_feature -- 本金收益特征，保本、非保本
            ,o_finprod_id -- 原金融产品代码，发生标的转换时用
            ,trade_market -- 交易场所
            ,calendar_id -- 交易日历
            ,term_type -- 期限品种
            ,counter_id -- 交易对手
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,m_unit_cprice -- 
            ,m_unit_int -- 
            ,m_unit_fprice -- 
            ,m_yield -- 
            ,m_delivery_type -- 
            ,vpay_date -- 首期交付日
            ,mpay_date -- 到期交付日
            ,contract_no -- 合同编号
            ,act_cap_days -- 实际占款天数
            ,irs_type -- 互换方式
            ,exc_ps -- 外汇交易方向
            ,cur_pair -- 货币对
            ,exc_fxs_term_type -- 掉期期限类型
            ,usd_amt -- 到期折美元金额
            ,dif_settle_ref_rate -- 差额交割参考汇率
            ,conflict_solve_way -- 争议解决方式
            ,period_id -- 期次代码
            ,is_rush_back -- 截止日是否冲回
            ,contract_name -- 合同名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.finprod_id -- 金融产品代码
    ,o.branch -- 分支序号
    ,o.finprod_type -- 金融产品类型（估值核算），回购、拆借、利率互换等
    ,o.finprod_type2 -- 金融产品类型（投管分类），回购、拆入、拆出、特拆拆入、利率互换、理财产品子产品等
    ,o.profit_type -- 收益类型，净值、预期收益、货币、结构
    ,o.branch_type -- 分支类型
    ,o.chl_agrt_id -- 通道代码
    ,o.prin -- 名义本金
    ,o.ccy -- 本金币种
    ,o.vdate -- 起息日
    ,o.mdate -- 到期日
    ,o.term -- 期限(天)
    ,o.int_type -- 利率类型
    ,o.int_rate -- 固定利率
    ,o.int_rate_id -- 浮动利率基准编号
    ,o.basis -- 计息基础
    ,o.m_prin_amt -- 到期本金
    ,o.m_int_amt -- 到期利息
    ,o.m_trade_amt -- 到期金额
    ,o.capi_income_feature -- 本金收益特征，保本、非保本
    ,o.o_finprod_id -- 原金融产品代码，发生标的转换时用
    ,o.trade_market -- 交易场所
    ,o.calendar_id -- 交易日历
    ,o.term_type -- 期限品种
    ,o.counter_id -- 交易对手
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.m_unit_cprice -- 
    ,o.m_unit_int -- 
    ,o.m_unit_fprice -- 
    ,o.m_yield -- 
    ,o.m_delivery_type -- 
    ,o.vpay_date -- 首期交付日
    ,o.mpay_date -- 到期交付日
    ,o.contract_no -- 合同编号
    ,o.act_cap_days -- 实际占款天数
    ,o.irs_type -- 互换方式
    ,o.exc_ps -- 外汇交易方向
    ,o.cur_pair -- 货币对
    ,o.exc_fxs_term_type -- 掉期期限类型
    ,o.usd_amt -- 到期折美元金额
    ,o.dif_settle_ref_rate -- 差额交割参考汇率
    ,o.conflict_solve_way -- 争议解决方式
    ,o.period_id -- 期次代码
    ,o.is_rush_back -- 截止日是否冲回
    ,o.contract_name -- 合同名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_fin_trade_product_bk o
    left join ${iol_schema}.fams_fin_trade_product_op n
        on
            o.finprod_id = n.finprod_id
            and o.branch = n.branch
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_fin_trade_product_cl d
        on
            o.finprod_id = d.finprod_id
            and o.branch = d.branch
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_fin_trade_product;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_fin_trade_product exchange partition p_19000101 with table ${iol_schema}.fams_fin_trade_product_cl;
alter table ${iol_schema}.fams_fin_trade_product exchange partition p_20991231 with table ${iol_schema}.fams_fin_trade_product_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_fin_trade_product to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_trade_product_op purge;
drop table ${iol_schema}.fams_fin_trade_product_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_fin_trade_product_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_fin_trade_product',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
