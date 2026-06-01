/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbinsurerate
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
create table ${iol_schema}.ifms_tbinsurerate_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbinsurerate;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbinsurerate_op purge;
drop table ${iol_schema}.ifms_tbinsurerate_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinsurerate_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbinsurerate where 0=1;

create table ${iol_schema}.ifms_tbinsurerate_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbinsurerate where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbinsurerate_cl(
            ta_code -- 保险公司代码
            ,prd_code -- 产品代码
            ,trans_type -- 交易类型，查询tbdict表中b_jylx
            ,branch_no -- 所属于机构
            ,pay_year_type -- 缴费年期类型：
            ,pay_year -- 缴费年期
            ,fee_type -- 计算类型，0免收1单笔固定金额2按百分比收3每批固定金额
            ,fee_number -- 计算参数
            ,up_down_flag -- 上下限控制标志
            ,per_max_amt -- 单笔最大金额
            ,per_min_amt -- 单笔最小金额
            ,offer_charge -- 出单费
            ,channel -- 交易渠道
            ,reserve -- 保留字段
            ,insure_year_type -- 保障年期类型
            ,insure_year -- 保障年期
            ,min_insure_fee -- 单笔最低保费
            ,max_insure_fee -- 单笔最高保费
            ,insure_annual -- 保险年度
            ,amt1 -- 保留金额1
            ,amt2 -- 保留金额2
            ,amt3 -- 保留金额3
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbinsurerate_op(
            ta_code -- 保险公司代码
            ,prd_code -- 产品代码
            ,trans_type -- 交易类型，查询tbdict表中b_jylx
            ,branch_no -- 所属于机构
            ,pay_year_type -- 缴费年期类型：
            ,pay_year -- 缴费年期
            ,fee_type -- 计算类型，0免收1单笔固定金额2按百分比收3每批固定金额
            ,fee_number -- 计算参数
            ,up_down_flag -- 上下限控制标志
            ,per_max_amt -- 单笔最大金额
            ,per_min_amt -- 单笔最小金额
            ,offer_charge -- 出单费
            ,channel -- 交易渠道
            ,reserve -- 保留字段
            ,insure_year_type -- 保障年期类型
            ,insure_year -- 保障年期
            ,min_insure_fee -- 单笔最低保费
            ,max_insure_fee -- 单笔最高保费
            ,insure_annual -- 保险年度
            ,amt1 -- 保留金额1
            ,amt2 -- 保留金额2
            ,amt3 -- 保留金额3
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ta_code, o.ta_code) as ta_code -- 保险公司代码
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.trans_type, o.trans_type) as trans_type -- 交易类型，查询tbdict表中b_jylx
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 所属于机构
    ,nvl(n.pay_year_type, o.pay_year_type) as pay_year_type -- 缴费年期类型：
    ,nvl(n.pay_year, o.pay_year) as pay_year -- 缴费年期
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 计算类型，0免收1单笔固定金额2按百分比收3每批固定金额
    ,nvl(n.fee_number, o.fee_number) as fee_number -- 计算参数
    ,nvl(n.up_down_flag, o.up_down_flag) as up_down_flag -- 上下限控制标志
    ,nvl(n.per_max_amt, o.per_max_amt) as per_max_amt -- 单笔最大金额
    ,nvl(n.per_min_amt, o.per_min_amt) as per_min_amt -- 单笔最小金额
    ,nvl(n.offer_charge, o.offer_charge) as offer_charge -- 出单费
    ,nvl(n.channel, o.channel) as channel -- 交易渠道
    ,nvl(n.reserve, o.reserve) as reserve -- 保留字段
    ,nvl(n.insure_year_type, o.insure_year_type) as insure_year_type -- 保障年期类型
    ,nvl(n.insure_year, o.insure_year) as insure_year -- 保障年期
    ,nvl(n.min_insure_fee, o.min_insure_fee) as min_insure_fee -- 单笔最低保费
    ,nvl(n.max_insure_fee, o.max_insure_fee) as max_insure_fee -- 单笔最高保费
    ,nvl(n.insure_annual, o.insure_annual) as insure_annual -- 保险年度
    ,nvl(n.amt1, o.amt1) as amt1 -- 保留金额1
    ,nvl(n.amt2, o.amt2) as amt2 -- 保留金额2
    ,nvl(n.amt3, o.amt3) as amt3 -- 保留金额3
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 保留字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 保留字段2
    ,case when
            n.ta_code is null
            and n.prd_code is null
            and n.trans_type is null
            and n.branch_no is null
            and n.pay_year_type is null
            and n.pay_year is null
            and n.insure_year_type is null
            and n.insure_year is null
            and n.min_insure_fee is null
            and n.insure_annual is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ta_code is null
            and n.prd_code is null
            and n.trans_type is null
            and n.branch_no is null
            and n.pay_year_type is null
            and n.pay_year is null
            and n.insure_year_type is null
            and n.insure_year is null
            and n.min_insure_fee is null
            and n.insure_annual is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ta_code is null
            and n.prd_code is null
            and n.trans_type is null
            and n.branch_no is null
            and n.pay_year_type is null
            and n.pay_year is null
            and n.insure_year_type is null
            and n.insure_year is null
            and n.min_insure_fee is null
            and n.insure_annual is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbinsurerate_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbinsurerate where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ta_code = n.ta_code
            and o.prd_code = n.prd_code
            and o.trans_type = n.trans_type
            and o.branch_no = n.branch_no
            and o.pay_year_type = n.pay_year_type
            and o.pay_year = n.pay_year
            and o.insure_year_type = n.insure_year_type
            and o.insure_year = n.insure_year
            and o.min_insure_fee = n.min_insure_fee
            and o.insure_annual = n.insure_annual
where (
        o.ta_code is null
        and o.prd_code is null
        and o.trans_type is null
        and o.branch_no is null
        and o.pay_year_type is null
        and o.pay_year is null
        and o.insure_year_type is null
        and o.insure_year is null
        and o.min_insure_fee is null
        and o.insure_annual is null
    )
    or (
        n.ta_code is null
        and n.prd_code is null
        and n.trans_type is null
        and n.branch_no is null
        and n.pay_year_type is null
        and n.pay_year is null
        and n.insure_year_type is null
        and n.insure_year is null
        and n.min_insure_fee is null
        and n.insure_annual is null
    )
    or (
        o.fee_type <> n.fee_type
        or o.fee_number <> n.fee_number
        or o.up_down_flag <> n.up_down_flag
        or o.per_max_amt <> n.per_max_amt
        or o.per_min_amt <> n.per_min_amt
        or o.offer_charge <> n.offer_charge
        or o.channel <> n.channel
        or o.reserve <> n.reserve
        or o.max_insure_fee <> n.max_insure_fee
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
        or o.amt3 <> n.amt3
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbinsurerate_cl(
            ta_code -- 保险公司代码
            ,prd_code -- 产品代码
            ,trans_type -- 交易类型，查询tbdict表中b_jylx
            ,branch_no -- 所属于机构
            ,pay_year_type -- 缴费年期类型：
            ,pay_year -- 缴费年期
            ,fee_type -- 计算类型，0免收1单笔固定金额2按百分比收3每批固定金额
            ,fee_number -- 计算参数
            ,up_down_flag -- 上下限控制标志
            ,per_max_amt -- 单笔最大金额
            ,per_min_amt -- 单笔最小金额
            ,offer_charge -- 出单费
            ,channel -- 交易渠道
            ,reserve -- 保留字段
            ,insure_year_type -- 保障年期类型
            ,insure_year -- 保障年期
            ,min_insure_fee -- 单笔最低保费
            ,max_insure_fee -- 单笔最高保费
            ,insure_annual -- 保险年度
            ,amt1 -- 保留金额1
            ,amt2 -- 保留金额2
            ,amt3 -- 保留金额3
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbinsurerate_op(
            ta_code -- 保险公司代码
            ,prd_code -- 产品代码
            ,trans_type -- 交易类型，查询tbdict表中b_jylx
            ,branch_no -- 所属于机构
            ,pay_year_type -- 缴费年期类型：
            ,pay_year -- 缴费年期
            ,fee_type -- 计算类型，0免收1单笔固定金额2按百分比收3每批固定金额
            ,fee_number -- 计算参数
            ,up_down_flag -- 上下限控制标志
            ,per_max_amt -- 单笔最大金额
            ,per_min_amt -- 单笔最小金额
            ,offer_charge -- 出单费
            ,channel -- 交易渠道
            ,reserve -- 保留字段
            ,insure_year_type -- 保障年期类型
            ,insure_year -- 保障年期
            ,min_insure_fee -- 单笔最低保费
            ,max_insure_fee -- 单笔最高保费
            ,insure_annual -- 保险年度
            ,amt1 -- 保留金额1
            ,amt2 -- 保留金额2
            ,amt3 -- 保留金额3
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ta_code -- 保险公司代码
    ,o.prd_code -- 产品代码
    ,o.trans_type -- 交易类型，查询tbdict表中b_jylx
    ,o.branch_no -- 所属于机构
    ,o.pay_year_type -- 缴费年期类型：
    ,o.pay_year -- 缴费年期
    ,o.fee_type -- 计算类型，0免收1单笔固定金额2按百分比收3每批固定金额
    ,o.fee_number -- 计算参数
    ,o.up_down_flag -- 上下限控制标志
    ,o.per_max_amt -- 单笔最大金额
    ,o.per_min_amt -- 单笔最小金额
    ,o.offer_charge -- 出单费
    ,o.channel -- 交易渠道
    ,o.reserve -- 保留字段
    ,o.insure_year_type -- 保障年期类型
    ,o.insure_year -- 保障年期
    ,o.min_insure_fee -- 单笔最低保费
    ,o.max_insure_fee -- 单笔最高保费
    ,o.insure_annual -- 保险年度
    ,o.amt1 -- 保留金额1
    ,o.amt2 -- 保留金额2
    ,o.amt3 -- 保留金额3
    ,o.reserve1 -- 保留字段1
    ,o.reserve2 -- 保留字段2
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbinsurerate_bk o
    left join ${iol_schema}.ifms_tbinsurerate_op n
        on
            o.ta_code = n.ta_code
            and o.prd_code = n.prd_code
            and o.trans_type = n.trans_type
            and o.branch_no = n.branch_no
            and o.pay_year_type = n.pay_year_type
            and o.pay_year = n.pay_year
            and o.insure_year_type = n.insure_year_type
            and o.insure_year = n.insure_year
            and o.min_insure_fee = n.min_insure_fee
            and o.insure_annual = n.insure_annual
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbinsurerate_cl d
        on
            o.ta_code = d.ta_code
            and o.prd_code = d.prd_code
            and o.trans_type = d.trans_type
            and o.branch_no = d.branch_no
            and o.pay_year_type = d.pay_year_type
            and o.pay_year = d.pay_year
            and o.insure_year_type = d.insure_year_type
            and o.insure_year = d.insure_year
            and o.min_insure_fee = d.min_insure_fee
            and o.insure_annual = d.insure_annual
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbinsurerate;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbinsurerate exchange partition p_19000101 with table ${iol_schema}.ifms_tbinsurerate_cl;
alter table ${iol_schema}.ifms_tbinsurerate exchange partition p_20991231 with table ${iol_schema}.ifms_tbinsurerate_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbinsurerate to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbinsurerate_op purge;
drop table ${iol_schema}.ifms_tbinsurerate_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbinsurerate_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbinsurerate',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
