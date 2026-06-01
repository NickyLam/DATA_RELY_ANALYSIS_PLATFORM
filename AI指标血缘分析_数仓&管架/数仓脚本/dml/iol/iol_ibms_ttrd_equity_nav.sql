/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_equity_nav
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
create table ${iol_schema}.ibms_ttrd_equity_nav_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_equity_nav;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_equity_nav_op purge;
drop table ${iol_schema}.ibms_ttrd_equity_nav_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_equity_nav_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_equity_nav where 0=1;

create table ${iol_schema}.ibms_ttrd_equity_nav_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_equity_nav where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_equity_nav_cl(
            e_id -- 主键
            ,i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,total_nav -- 总净值
            ,unit_nav -- 单位净值
            ,profit_1w -- 万份收益
            ,yield_7d -- 7日年华收益
            ,pub_date -- 公布日期
            ,beg_date -- 生效日
            ,end_date -- 失效日
            ,imp_date -- 
            ,pipe_id -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_equity_nav_op(
            e_id -- 主键
            ,i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,total_nav -- 总净值
            ,unit_nav -- 单位净值
            ,profit_1w -- 万份收益
            ,yield_7d -- 7日年华收益
            ,pub_date -- 公布日期
            ,beg_date -- 生效日
            ,end_date -- 失效日
            ,imp_date -- 
            ,pipe_id -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.e_id, o.e_id) as e_id -- 主键
    ,nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.total_nav, o.total_nav) as total_nav -- 总净值
    ,nvl(n.unit_nav, o.unit_nav) as unit_nav -- 单位净值
    ,nvl(n.profit_1w, o.profit_1w) as profit_1w -- 万份收益
    ,nvl(n.yield_7d, o.yield_7d) as yield_7d -- 7日年华收益
    ,nvl(n.pub_date, o.pub_date) as pub_date -- 公布日期
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 生效日
    ,nvl(n.end_date, o.end_date) as end_date -- 失效日
    ,nvl(n.imp_date, o.imp_date) as imp_date -- 
    ,nvl(n.pipe_id, o.pipe_id) as pipe_id -- 
    ,case when
            n.e_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.e_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.e_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_equity_nav_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_equity_nav where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.e_id = n.e_id
where (
        o.e_id is null
    )
    or (
        n.e_id is null
    )
    or (
        o.i_code <> n.i_code
        or o.a_type <> n.a_type
        or o.m_type <> n.m_type
        or o.total_nav <> n.total_nav
        or o.unit_nav <> n.unit_nav
        or o.profit_1w <> n.profit_1w
        or o.yield_7d <> n.yield_7d
        or o.pub_date <> n.pub_date
        or o.beg_date <> n.beg_date
        or o.end_date <> n.end_date
        or o.imp_date <> n.imp_date
        or o.pipe_id <> n.pipe_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_equity_nav_cl(
            e_id -- 主键
            ,i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,total_nav -- 总净值
            ,unit_nav -- 单位净值
            ,profit_1w -- 万份收益
            ,yield_7d -- 7日年华收益
            ,pub_date -- 公布日期
            ,beg_date -- 生效日
            ,end_date -- 失效日
            ,imp_date -- 
            ,pipe_id -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_equity_nav_op(
            e_id -- 主键
            ,i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,total_nav -- 总净值
            ,unit_nav -- 单位净值
            ,profit_1w -- 万份收益
            ,yield_7d -- 7日年华收益
            ,pub_date -- 公布日期
            ,beg_date -- 生效日
            ,end_date -- 失效日
            ,imp_date -- 
            ,pipe_id -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.e_id -- 主键
    ,o.i_code -- 金融工具代码
    ,o.a_type -- 资产类型
    ,o.m_type -- 市场类型
    ,o.total_nav -- 总净值
    ,o.unit_nav -- 单位净值
    ,o.profit_1w -- 万份收益
    ,o.yield_7d -- 7日年华收益
    ,o.pub_date -- 公布日期
    ,o.beg_date -- 生效日
    ,o.end_date -- 失效日
    ,o.imp_date -- 
    ,o.pipe_id -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_equity_nav_bk o
    left join ${iol_schema}.ibms_ttrd_equity_nav_op n
        on
            o.e_id = n.e_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_equity_nav_cl d
        on
            o.e_id = d.e_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_equity_nav;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_equity_nav exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_equity_nav_cl;
alter table ${iol_schema}.ibms_ttrd_equity_nav exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_equity_nav_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_equity_nav to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_equity_nav_op purge;
drop table ${iol_schema}.ibms_ttrd_equity_nav_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_equity_nav_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_equity_nav',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
