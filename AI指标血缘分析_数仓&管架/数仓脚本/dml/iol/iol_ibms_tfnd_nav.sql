/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_tfnd_nav
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
create table ${iol_schema}.ibms_tfnd_nav_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_tfnd_nav;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tfnd_nav_op purge;
drop table ${iol_schema}.ibms_tfnd_nav_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tfnd_nav_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tfnd_nav where 0=1;

create table ${iol_schema}.ibms_tfnd_nav_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tfnd_nav where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tfnd_nav_cl(
            f_id -- 主键
            ,i_code -- 基金代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,f_totalnav -- 总净价
            ,f_yield_7d -- 七天年化收益率
            ,f_pubdate -- 公布日期
            ,beg_date -- 开始日期
            ,end_date -- 结束日期
            ,imp_date -- 导入时间
            ,pipe_id -- 管道ID
            ,f_cumu_nav -- 累积单位净值
            ,f_profit_1w -- 七天万分收益
            ,f_unitnav -- 单位净价
            ,f_scal -- 基金规模（元）
            ,f_count -- 基金总份额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tfnd_nav_op(
            f_id -- 主键
            ,i_code -- 基金代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,f_totalnav -- 总净价
            ,f_yield_7d -- 七天年化收益率
            ,f_pubdate -- 公布日期
            ,beg_date -- 开始日期
            ,end_date -- 结束日期
            ,imp_date -- 导入时间
            ,pipe_id -- 管道ID
            ,f_cumu_nav -- 累积单位净值
            ,f_profit_1w -- 七天万分收益
            ,f_unitnav -- 单位净价
            ,f_scal -- 基金规模（元）
            ,f_count -- 基金总份额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.f_id, o.f_id) as f_id -- 主键
    ,nvl(n.i_code, o.i_code) as i_code -- 基金代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.f_totalnav, o.f_totalnav) as f_totalnav -- 总净价
    ,nvl(n.f_yield_7d, o.f_yield_7d) as f_yield_7d -- 七天年化收益率
    ,nvl(n.f_pubdate, o.f_pubdate) as f_pubdate -- 公布日期
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 开始日期
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.imp_date, o.imp_date) as imp_date -- 导入时间
    ,nvl(n.pipe_id, o.pipe_id) as pipe_id -- 管道ID
    ,nvl(n.f_cumu_nav, o.f_cumu_nav) as f_cumu_nav -- 累积单位净值
    ,nvl(n.f_profit_1w, o.f_profit_1w) as f_profit_1w -- 七天万分收益
    ,nvl(n.f_unitnav, o.f_unitnav) as f_unitnav -- 单位净价
    ,nvl(n.f_scal, o.f_scal) as f_scal -- 基金规模（元）
    ,nvl(n.f_count, o.f_count) as f_count -- 基金总份额
    ,case when
            n.f_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.f_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.f_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_tfnd_nav_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_tfnd_nav where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.f_id = n.f_id
where (
        o.f_id is null
    )
    or (
        n.f_id is null
    )
    or (
        o.i_code <> n.i_code
        or o.a_type <> n.a_type
        or o.m_type <> n.m_type
        or o.f_totalnav <> n.f_totalnav
        or o.f_yield_7d <> n.f_yield_7d
        or o.f_pubdate <> n.f_pubdate
        or o.beg_date <> n.beg_date
        or o.end_date <> n.end_date
        or o.imp_date <> n.imp_date
        or o.pipe_id <> n.pipe_id
        or o.f_cumu_nav <> n.f_cumu_nav
        or o.f_profit_1w <> n.f_profit_1w
        or o.f_unitnav <> n.f_unitnav
        or o.f_scal <> n.f_scal
        or o.f_count <> n.f_count
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tfnd_nav_cl(
            f_id -- 主键
            ,i_code -- 基金代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,f_totalnav -- 总净价
            ,f_yield_7d -- 七天年化收益率
            ,f_pubdate -- 公布日期
            ,beg_date -- 开始日期
            ,end_date -- 结束日期
            ,imp_date -- 导入时间
            ,pipe_id -- 管道ID
            ,f_cumu_nav -- 累积单位净值
            ,f_profit_1w -- 七天万分收益
            ,f_unitnav -- 单位净价
            ,f_scal -- 基金规模（元）
            ,f_count -- 基金总份额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tfnd_nav_op(
            f_id -- 主键
            ,i_code -- 基金代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,f_totalnav -- 总净价
            ,f_yield_7d -- 七天年化收益率
            ,f_pubdate -- 公布日期
            ,beg_date -- 开始日期
            ,end_date -- 结束日期
            ,imp_date -- 导入时间
            ,pipe_id -- 管道ID
            ,f_cumu_nav -- 累积单位净值
            ,f_profit_1w -- 七天万分收益
            ,f_unitnav -- 单位净价
            ,f_scal -- 基金规模（元）
            ,f_count -- 基金总份额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.f_id -- 主键
    ,o.i_code -- 基金代码
    ,o.a_type -- 资产类型
    ,o.m_type -- 市场类型
    ,o.f_totalnav -- 总净价
    ,o.f_yield_7d -- 七天年化收益率
    ,o.f_pubdate -- 公布日期
    ,o.beg_date -- 开始日期
    ,o.end_date -- 结束日期
    ,o.imp_date -- 导入时间
    ,o.pipe_id -- 管道ID
    ,o.f_cumu_nav -- 累积单位净值
    ,o.f_profit_1w -- 七天万分收益
    ,o.f_unitnav -- 单位净价
    ,o.f_scal -- 基金规模（元）
    ,o.f_count -- 基金总份额
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_tfnd_nav_bk o
    left join ${iol_schema}.ibms_tfnd_nav_op n
        on
            o.f_id = n.f_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_tfnd_nav_cl d
        on
            o.f_id = d.f_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_tfnd_nav;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_tfnd_nav exchange partition p_19000101 with table ${iol_schema}.ibms_tfnd_nav_cl;
alter table ${iol_schema}.ibms_tfnd_nav exchange partition p_20991231 with table ${iol_schema}.ibms_tfnd_nav_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_tfnd_nav to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tfnd_nav_op purge;
drop table ${iol_schema}.ibms_tfnd_nav_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_tfnd_nav_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_tfnd_nav',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
