/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbshareext
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
create table ${iol_schema}.nfss_tbshareext_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbshareext;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbshareext_op purge;
drop table ${iol_schema}.nfss_tbshareext_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbshareext_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbshareext where 0=1;

create table ${iol_schema}.nfss_tbshareext_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbshareext where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbshareext_cl(
            in_client_no -- 内部客户编号
            ,bank_acc -- 银行帐号
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,ta_code -- TA代码
            ,prd_code -- 产品代码
            ,beg_date -- 期初日期
            ,beg_nav -- 期初净值
            ,end_date -- 期末日期
            ,end_nav -- 期末净值
            ,tot_vol -- 当前总份额
            ,allot_amt -- 认购金额
            ,allot_cfm_amt -- 认购确认金额
            ,sub_amt -- 申购金额
            ,auto_sub_amt -- 定投金额
            ,conv_in_amt -- 转换入金额
            ,trust_in_amt -- 转托管入金额
            ,assign_in_amt -- 非交易过户入金额
            ,force_add_amt -- 份额强增折算金额
            ,red_amt -- 赎回金额
            ,force_red_amt -- 强制赎回金额
            ,conv_out_amt -- 转换出金额
            ,trust_out_amt -- 转托管出金额
            ,assign_out_amt -- 非交易过户出金额
            ,div_vol_amt -- 分红份额折算金额
            ,div_vol -- 分红份额
            ,div_amt -- 分红金额
            ,fund_end_amt -- 基金清盘及终止金额
            ,force_sub_amt -- 份额强减折算金额
            ,income_rate -- 投资收益率
            ,total_cost -- 累积投入资金
            ,total_income -- 累积投资收益(元)
            ,avg_price -- 平均买入价格
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbshareext_op(
            in_client_no -- 内部客户编号
            ,bank_acc -- 银行帐号
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,ta_code -- TA代码
            ,prd_code -- 产品代码
            ,beg_date -- 期初日期
            ,beg_nav -- 期初净值
            ,end_date -- 期末日期
            ,end_nav -- 期末净值
            ,tot_vol -- 当前总份额
            ,allot_amt -- 认购金额
            ,allot_cfm_amt -- 认购确认金额
            ,sub_amt -- 申购金额
            ,auto_sub_amt -- 定投金额
            ,conv_in_amt -- 转换入金额
            ,trust_in_amt -- 转托管入金额
            ,assign_in_amt -- 非交易过户入金额
            ,force_add_amt -- 份额强增折算金额
            ,red_amt -- 赎回金额
            ,force_red_amt -- 强制赎回金额
            ,conv_out_amt -- 转换出金额
            ,trust_out_amt -- 转托管出金额
            ,assign_out_amt -- 非交易过户出金额
            ,div_vol_amt -- 分红份额折算金额
            ,div_vol -- 分红份额
            ,div_amt -- 分红金额
            ,fund_end_amt -- 基金清盘及终止金额
            ,force_sub_amt -- 份额强减折算金额
            ,income_rate -- 投资收益率
            ,total_cost -- 累积投入资金
            ,total_income -- 累积投资收益(元)
            ,avg_price -- 平均买入价格
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.in_client_no, o.in_client_no) as in_client_no -- 内部客户编号
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 银行帐号
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行编号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.ta_code, o.ta_code) as ta_code -- TA代码
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 期初日期
    ,nvl(n.beg_nav, o.beg_nav) as beg_nav -- 期初净值
    ,nvl(n.end_date, o.end_date) as end_date -- 期末日期
    ,nvl(n.end_nav, o.end_nav) as end_nav -- 期末净值
    ,nvl(n.tot_vol, o.tot_vol) as tot_vol -- 当前总份额
    ,nvl(n.allot_amt, o.allot_amt) as allot_amt -- 认购金额
    ,nvl(n.allot_cfm_amt, o.allot_cfm_amt) as allot_cfm_amt -- 认购确认金额
    ,nvl(n.sub_amt, o.sub_amt) as sub_amt -- 申购金额
    ,nvl(n.auto_sub_amt, o.auto_sub_amt) as auto_sub_amt -- 定投金额
    ,nvl(n.conv_in_amt, o.conv_in_amt) as conv_in_amt -- 转换入金额
    ,nvl(n.trust_in_amt, o.trust_in_amt) as trust_in_amt -- 转托管入金额
    ,nvl(n.assign_in_amt, o.assign_in_amt) as assign_in_amt -- 非交易过户入金额
    ,nvl(n.force_add_amt, o.force_add_amt) as force_add_amt -- 份额强增折算金额
    ,nvl(n.red_amt, o.red_amt) as red_amt -- 赎回金额
    ,nvl(n.force_red_amt, o.force_red_amt) as force_red_amt -- 强制赎回金额
    ,nvl(n.conv_out_amt, o.conv_out_amt) as conv_out_amt -- 转换出金额
    ,nvl(n.trust_out_amt, o.trust_out_amt) as trust_out_amt -- 转托管出金额
    ,nvl(n.assign_out_amt, o.assign_out_amt) as assign_out_amt -- 非交易过户出金额
    ,nvl(n.div_vol_amt, o.div_vol_amt) as div_vol_amt -- 分红份额折算金额
    ,nvl(n.div_vol, o.div_vol) as div_vol -- 分红份额
    ,nvl(n.div_amt, o.div_amt) as div_amt -- 分红金额
    ,nvl(n.fund_end_amt, o.fund_end_amt) as fund_end_amt -- 基金清盘及终止金额
    ,nvl(n.force_sub_amt, o.force_sub_amt) as force_sub_amt -- 份额强减折算金额
    ,nvl(n.income_rate, o.income_rate) as income_rate -- 投资收益率
    ,nvl(n.total_cost, o.total_cost) as total_cost -- 累积投入资金
    ,nvl(n.total_income, o.total_income) as total_income -- 累积投资收益(元)
    ,nvl(n.avg_price, o.avg_price) as avg_price -- 平均买入价格
    ,nvl(n.amt1, o.amt1) as amt1 -- 备用金额1
    ,nvl(n.amt2, o.amt2) as amt2 -- 备用金额2
    ,nvl(n.amt3, o.amt3) as amt3 -- 备用金额3
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备注1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备注2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备注3
    ,case when
            n.in_client_no is null
            and n.bank_acc is null
            and n.bank_no is null
            and n.prd_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.in_client_no is null
            and n.bank_acc is null
            and n.bank_no is null
            and n.prd_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.in_client_no is null
            and n.bank_acc is null
            and n.bank_no is null
            and n.prd_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tbshareext_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbshareext where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.in_client_no = n.in_client_no
            and o.bank_acc = n.bank_acc
            and o.bank_no = n.bank_no
            and o.prd_code = n.prd_code
where (
        o.in_client_no is null
        and o.bank_acc is null
        and o.bank_no is null
        and o.prd_code is null
    )
    or (
        n.in_client_no is null
        and n.bank_acc is null
        and n.bank_no is null
        and n.prd_code is null
    )
    or (
        o.client_no <> n.client_no
        or o.ta_code <> n.ta_code
        or o.beg_date <> n.beg_date
        or o.beg_nav <> n.beg_nav
        or o.end_date <> n.end_date
        or o.end_nav <> n.end_nav
        or o.tot_vol <> n.tot_vol
        or o.allot_amt <> n.allot_amt
        or o.allot_cfm_amt <> n.allot_cfm_amt
        or o.sub_amt <> n.sub_amt
        or o.auto_sub_amt <> n.auto_sub_amt
        or o.conv_in_amt <> n.conv_in_amt
        or o.trust_in_amt <> n.trust_in_amt
        or o.assign_in_amt <> n.assign_in_amt
        or o.force_add_amt <> n.force_add_amt
        or o.red_amt <> n.red_amt
        or o.force_red_amt <> n.force_red_amt
        or o.conv_out_amt <> n.conv_out_amt
        or o.trust_out_amt <> n.trust_out_amt
        or o.assign_out_amt <> n.assign_out_amt
        or o.div_vol_amt <> n.div_vol_amt
        or o.div_vol <> n.div_vol
        or o.div_amt <> n.div_amt
        or o.fund_end_amt <> n.fund_end_amt
        or o.force_sub_amt <> n.force_sub_amt
        or o.income_rate <> n.income_rate
        or o.total_cost <> n.total_cost
        or o.total_income <> n.total_income
        or o.avg_price <> n.avg_price
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
        or o.amt3 <> n.amt3
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbshareext_cl(
            in_client_no -- 内部客户编号
            ,bank_acc -- 银行帐号
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,ta_code -- TA代码
            ,prd_code -- 产品代码
            ,beg_date -- 期初日期
            ,beg_nav -- 期初净值
            ,end_date -- 期末日期
            ,end_nav -- 期末净值
            ,tot_vol -- 当前总份额
            ,allot_amt -- 认购金额
            ,allot_cfm_amt -- 认购确认金额
            ,sub_amt -- 申购金额
            ,auto_sub_amt -- 定投金额
            ,conv_in_amt -- 转换入金额
            ,trust_in_amt -- 转托管入金额
            ,assign_in_amt -- 非交易过户入金额
            ,force_add_amt -- 份额强增折算金额
            ,red_amt -- 赎回金额
            ,force_red_amt -- 强制赎回金额
            ,conv_out_amt -- 转换出金额
            ,trust_out_amt -- 转托管出金额
            ,assign_out_amt -- 非交易过户出金额
            ,div_vol_amt -- 分红份额折算金额
            ,div_vol -- 分红份额
            ,div_amt -- 分红金额
            ,fund_end_amt -- 基金清盘及终止金额
            ,force_sub_amt -- 份额强减折算金额
            ,income_rate -- 投资收益率
            ,total_cost -- 累积投入资金
            ,total_income -- 累积投资收益(元)
            ,avg_price -- 平均买入价格
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbshareext_op(
            in_client_no -- 内部客户编号
            ,bank_acc -- 银行帐号
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,ta_code -- TA代码
            ,prd_code -- 产品代码
            ,beg_date -- 期初日期
            ,beg_nav -- 期初净值
            ,end_date -- 期末日期
            ,end_nav -- 期末净值
            ,tot_vol -- 当前总份额
            ,allot_amt -- 认购金额
            ,allot_cfm_amt -- 认购确认金额
            ,sub_amt -- 申购金额
            ,auto_sub_amt -- 定投金额
            ,conv_in_amt -- 转换入金额
            ,trust_in_amt -- 转托管入金额
            ,assign_in_amt -- 非交易过户入金额
            ,force_add_amt -- 份额强增折算金额
            ,red_amt -- 赎回金额
            ,force_red_amt -- 强制赎回金额
            ,conv_out_amt -- 转换出金额
            ,trust_out_amt -- 转托管出金额
            ,assign_out_amt -- 非交易过户出金额
            ,div_vol_amt -- 分红份额折算金额
            ,div_vol -- 分红份额
            ,div_amt -- 分红金额
            ,fund_end_amt -- 基金清盘及终止金额
            ,force_sub_amt -- 份额强减折算金额
            ,income_rate -- 投资收益率
            ,total_cost -- 累积投入资金
            ,total_income -- 累积投资收益(元)
            ,avg_price -- 平均买入价格
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.in_client_no -- 内部客户编号
    ,o.bank_acc -- 银行帐号
    ,o.bank_no -- 银行编号
    ,o.client_no -- 客户编号
    ,o.ta_code -- TA代码
    ,o.prd_code -- 产品代码
    ,o.beg_date -- 期初日期
    ,o.beg_nav -- 期初净值
    ,o.end_date -- 期末日期
    ,o.end_nav -- 期末净值
    ,o.tot_vol -- 当前总份额
    ,o.allot_amt -- 认购金额
    ,o.allot_cfm_amt -- 认购确认金额
    ,o.sub_amt -- 申购金额
    ,o.auto_sub_amt -- 定投金额
    ,o.conv_in_amt -- 转换入金额
    ,o.trust_in_amt -- 转托管入金额
    ,o.assign_in_amt -- 非交易过户入金额
    ,o.force_add_amt -- 份额强增折算金额
    ,o.red_amt -- 赎回金额
    ,o.force_red_amt -- 强制赎回金额
    ,o.conv_out_amt -- 转换出金额
    ,o.trust_out_amt -- 转托管出金额
    ,o.assign_out_amt -- 非交易过户出金额
    ,o.div_vol_amt -- 分红份额折算金额
    ,o.div_vol -- 分红份额
    ,o.div_amt -- 分红金额
    ,o.fund_end_amt -- 基金清盘及终止金额
    ,o.force_sub_amt -- 份额强减折算金额
    ,o.income_rate -- 投资收益率
    ,o.total_cost -- 累积投入资金
    ,o.total_income -- 累积投资收益(元)
    ,o.avg_price -- 平均买入价格
    ,o.amt1 -- 备用金额1
    ,o.amt2 -- 备用金额2
    ,o.amt3 -- 备用金额3
    ,o.reserve1 -- 备注1
    ,o.reserve2 -- 备注2
    ,o.reserve3 -- 备注3
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nfss_tbshareext_bk o
    left join ${iol_schema}.nfss_tbshareext_op n
        on
            o.in_client_no = n.in_client_no
            and o.bank_acc = n.bank_acc
            and o.bank_no = n.bank_no
            and o.prd_code = n.prd_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbshareext_cl d
        on
            o.in_client_no = d.in_client_no
            and o.bank_acc = d.bank_acc
            and o.bank_no = d.bank_no
            and o.prd_code = d.prd_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nfss_tbshareext;

-- 4.2 exchange partition
alter table ${iol_schema}.nfss_tbshareext exchange partition p_19000101 with table ${iol_schema}.nfss_tbshareext_cl;
alter table ${iol_schema}.nfss_tbshareext exchange partition p_20991231 with table ${iol_schema}.nfss_tbshareext_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbshareext to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbshareext_op purge;
drop table ${iol_schema}.nfss_tbshareext_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbshareext_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbshareext',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
