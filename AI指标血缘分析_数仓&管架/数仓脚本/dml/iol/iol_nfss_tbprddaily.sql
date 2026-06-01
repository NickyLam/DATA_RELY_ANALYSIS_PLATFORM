/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbprddaily
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
create table ${iol_schema}.nfss_tbprddaily_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbprddaily;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbprddaily_op purge;
drop table ${iol_schema}.nfss_tbprddaily_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbprddaily_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbprddaily where 0=1;

create table ${iol_schema}.nfss_tbprddaily_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbprddaily where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbprddaily_cl(
            iss_date -- 发布日期
            ,cfm_date -- 确认日期(当天日期)
            ,prd_code -- 产品代码
            ,ta_code -- TA代码
            ,prd_scale -- 产品总规模
            ,tot_vol -- 产品总份数
            ,increase_vol -- 当日增加份数
            ,reduce_vol -- 当日减少份数
            ,nav -- 单位净值
            ,face_value -- 产品面值
            ,larg_red_flag -- 巨额赎回标志
            ,larg_red_cfm_rate -- 巨额赎回确认比例
            ,chgout_cfm_rate -- 巨额赎回转出确认比例
            ,excess_flag -- 超额申购标志
            ,excess_cfm_rate -- 超额申购确认比例
            ,income_rate -- 年化收益率
            ,income -- 产品收益
            ,income_unit -- 万份单位收益
            ,unassign_income -- 未分配收益
            ,assign_income -- 当天分配收益
            ,assign_flag -- 收益分配标志
            ,conv_flag -- 转换标志
            ,status -- 产品状态
            ,last_status -- 上日产品状态
            ,tot_nav -- 产品累计净值
            ,amt1 -- 备用金额1
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbprddaily_op(
            iss_date -- 发布日期
            ,cfm_date -- 确认日期(当天日期)
            ,prd_code -- 产品代码
            ,ta_code -- TA代码
            ,prd_scale -- 产品总规模
            ,tot_vol -- 产品总份数
            ,increase_vol -- 当日增加份数
            ,reduce_vol -- 当日减少份数
            ,nav -- 单位净值
            ,face_value -- 产品面值
            ,larg_red_flag -- 巨额赎回标志
            ,larg_red_cfm_rate -- 巨额赎回确认比例
            ,chgout_cfm_rate -- 巨额赎回转出确认比例
            ,excess_flag -- 超额申购标志
            ,excess_cfm_rate -- 超额申购确认比例
            ,income_rate -- 年化收益率
            ,income -- 产品收益
            ,income_unit -- 万份单位收益
            ,unassign_income -- 未分配收益
            ,assign_income -- 当天分配收益
            ,assign_flag -- 收益分配标志
            ,conv_flag -- 转换标志
            ,status -- 产品状态
            ,last_status -- 上日产品状态
            ,tot_nav -- 产品累计净值
            ,amt1 -- 备用金额1
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.iss_date, o.iss_date) as iss_date -- 发布日期
    ,nvl(n.cfm_date, o.cfm_date) as cfm_date -- 确认日期(当天日期)
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.ta_code, o.ta_code) as ta_code -- TA代码
    ,nvl(n.prd_scale, o.prd_scale) as prd_scale -- 产品总规模
    ,nvl(n.tot_vol, o.tot_vol) as tot_vol -- 产品总份数
    ,nvl(n.increase_vol, o.increase_vol) as increase_vol -- 当日增加份数
    ,nvl(n.reduce_vol, o.reduce_vol) as reduce_vol -- 当日减少份数
    ,nvl(n.nav, o.nav) as nav -- 单位净值
    ,nvl(n.face_value, o.face_value) as face_value -- 产品面值
    ,nvl(n.larg_red_flag, o.larg_red_flag) as larg_red_flag -- 巨额赎回标志
    ,nvl(n.larg_red_cfm_rate, o.larg_red_cfm_rate) as larg_red_cfm_rate -- 巨额赎回确认比例
    ,nvl(n.chgout_cfm_rate, o.chgout_cfm_rate) as chgout_cfm_rate -- 巨额赎回转出确认比例
    ,nvl(n.excess_flag, o.excess_flag) as excess_flag -- 超额申购标志
    ,nvl(n.excess_cfm_rate, o.excess_cfm_rate) as excess_cfm_rate -- 超额申购确认比例
    ,nvl(n.income_rate, o.income_rate) as income_rate -- 年化收益率
    ,nvl(n.income, o.income) as income -- 产品收益
    ,nvl(n.income_unit, o.income_unit) as income_unit -- 万份单位收益
    ,nvl(n.unassign_income, o.unassign_income) as unassign_income -- 未分配收益
    ,nvl(n.assign_income, o.assign_income) as assign_income -- 当天分配收益
    ,nvl(n.assign_flag, o.assign_flag) as assign_flag -- 收益分配标志
    ,nvl(n.conv_flag, o.conv_flag) as conv_flag -- 转换标志
    ,nvl(n.status, o.status) as status -- 产品状态
    ,nvl(n.last_status, o.last_status) as last_status -- 上日产品状态
    ,nvl(n.tot_nav, o.tot_nav) as tot_nav -- 产品累计净值
    ,nvl(n.amt1, o.amt1) as amt1 -- 备用金额1
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用2
    ,case when
            n.iss_date is null
            and n.cfm_date is null
            and n.prd_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.iss_date is null
            and n.cfm_date is null
            and n.prd_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.iss_date is null
            and n.cfm_date is null
            and n.prd_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tbprddaily_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbprddaily where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.iss_date = n.iss_date
            and o.cfm_date = n.cfm_date
            and o.prd_code = n.prd_code
where (
        o.iss_date is null
        and o.cfm_date is null
        and o.prd_code is null
    )
    or (
        n.iss_date is null
        and n.cfm_date is null
        and n.prd_code is null
    )
    or (
        o.ta_code <> n.ta_code
        or o.prd_scale <> n.prd_scale
        or o.tot_vol <> n.tot_vol
        or o.increase_vol <> n.increase_vol
        or o.reduce_vol <> n.reduce_vol
        or o.nav <> n.nav
        or o.face_value <> n.face_value
        or o.larg_red_flag <> n.larg_red_flag
        or o.larg_red_cfm_rate <> n.larg_red_cfm_rate
        or o.chgout_cfm_rate <> n.chgout_cfm_rate
        or o.excess_flag <> n.excess_flag
        or o.excess_cfm_rate <> n.excess_cfm_rate
        or o.income_rate <> n.income_rate
        or o.income <> n.income
        or o.income_unit <> n.income_unit
        or o.unassign_income <> n.unassign_income
        or o.assign_income <> n.assign_income
        or o.assign_flag <> n.assign_flag
        or o.conv_flag <> n.conv_flag
        or o.status <> n.status
        or o.last_status <> n.last_status
        or o.tot_nav <> n.tot_nav
        or o.amt1 <> n.amt1
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbprddaily_cl(
            iss_date -- 发布日期
            ,cfm_date -- 确认日期(当天日期)
            ,prd_code -- 产品代码
            ,ta_code -- TA代码
            ,prd_scale -- 产品总规模
            ,tot_vol -- 产品总份数
            ,increase_vol -- 当日增加份数
            ,reduce_vol -- 当日减少份数
            ,nav -- 单位净值
            ,face_value -- 产品面值
            ,larg_red_flag -- 巨额赎回标志
            ,larg_red_cfm_rate -- 巨额赎回确认比例
            ,chgout_cfm_rate -- 巨额赎回转出确认比例
            ,excess_flag -- 超额申购标志
            ,excess_cfm_rate -- 超额申购确认比例
            ,income_rate -- 年化收益率
            ,income -- 产品收益
            ,income_unit -- 万份单位收益
            ,unassign_income -- 未分配收益
            ,assign_income -- 当天分配收益
            ,assign_flag -- 收益分配标志
            ,conv_flag -- 转换标志
            ,status -- 产品状态
            ,last_status -- 上日产品状态
            ,tot_nav -- 产品累计净值
            ,amt1 -- 备用金额1
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbprddaily_op(
            iss_date -- 发布日期
            ,cfm_date -- 确认日期(当天日期)
            ,prd_code -- 产品代码
            ,ta_code -- TA代码
            ,prd_scale -- 产品总规模
            ,tot_vol -- 产品总份数
            ,increase_vol -- 当日增加份数
            ,reduce_vol -- 当日减少份数
            ,nav -- 单位净值
            ,face_value -- 产品面值
            ,larg_red_flag -- 巨额赎回标志
            ,larg_red_cfm_rate -- 巨额赎回确认比例
            ,chgout_cfm_rate -- 巨额赎回转出确认比例
            ,excess_flag -- 超额申购标志
            ,excess_cfm_rate -- 超额申购确认比例
            ,income_rate -- 年化收益率
            ,income -- 产品收益
            ,income_unit -- 万份单位收益
            ,unassign_income -- 未分配收益
            ,assign_income -- 当天分配收益
            ,assign_flag -- 收益分配标志
            ,conv_flag -- 转换标志
            ,status -- 产品状态
            ,last_status -- 上日产品状态
            ,tot_nav -- 产品累计净值
            ,amt1 -- 备用金额1
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.iss_date -- 发布日期
    ,o.cfm_date -- 确认日期(当天日期)
    ,o.prd_code -- 产品代码
    ,o.ta_code -- TA代码
    ,o.prd_scale -- 产品总规模
    ,o.tot_vol -- 产品总份数
    ,o.increase_vol -- 当日增加份数
    ,o.reduce_vol -- 当日减少份数
    ,o.nav -- 单位净值
    ,o.face_value -- 产品面值
    ,o.larg_red_flag -- 巨额赎回标志
    ,o.larg_red_cfm_rate -- 巨额赎回确认比例
    ,o.chgout_cfm_rate -- 巨额赎回转出确认比例
    ,o.excess_flag -- 超额申购标志
    ,o.excess_cfm_rate -- 超额申购确认比例
    ,o.income_rate -- 年化收益率
    ,o.income -- 产品收益
    ,o.income_unit -- 万份单位收益
    ,o.unassign_income -- 未分配收益
    ,o.assign_income -- 当天分配收益
    ,o.assign_flag -- 收益分配标志
    ,o.conv_flag -- 转换标志
    ,o.status -- 产品状态
    ,o.last_status -- 上日产品状态
    ,o.tot_nav -- 产品累计净值
    ,o.amt1 -- 备用金额1
    ,o.reserve1 -- 备用1
    ,o.reserve2 -- 备用2
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nfss_tbprddaily_bk o
    left join ${iol_schema}.nfss_tbprddaily_op n
        on
            o.iss_date = n.iss_date
            and o.cfm_date = n.cfm_date
            and o.prd_code = n.prd_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbprddaily_cl d
        on
            o.iss_date = d.iss_date
            and o.cfm_date = d.cfm_date
            and o.prd_code = d.prd_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nfss_tbprddaily;

-- 4.2 exchange partition
alter table ${iol_schema}.nfss_tbprddaily exchange partition p_19000101 with table ${iol_schema}.nfss_tbprddaily_cl;
alter table ${iol_schema}.nfss_tbprddaily exchange partition p_20991231 with table ${iol_schema}.nfss_tbprddaily_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbprddaily to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbprddaily_op purge;
drop table ${iol_schema}.nfss_tbprddaily_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbprddaily_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbprddaily',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
