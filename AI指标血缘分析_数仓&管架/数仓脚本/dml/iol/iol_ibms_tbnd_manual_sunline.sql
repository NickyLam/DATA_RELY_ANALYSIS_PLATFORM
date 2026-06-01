/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_tbnd_manual_eval
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
create table ${iol_schema}.ibms_tbnd_manual_eval_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_tbnd_manual_eval;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tbnd_manual_eval_op purge;
drop table ${iol_schema}.ibms_tbnd_manual_eval_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tbnd_manual_eval_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tbnd_manual_eval where 0=1;

create table ${iol_schema}.ibms_tbnd_manual_eval_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tbnd_manual_eval where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tbnd_manual_eval_cl(
            i_code -- 债券代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,i_name -- 债券名称
            ,beg_date -- 估值日期
            ,imp_date -- 录入日期
            ,price -- 中证估值(净价)
            ,dirty_price -- 中证估值(全价)
            ,mk_mdvbp -- 基点价值
            ,mk_duration -- 修正久期
            ,mk_convexity -- 凸性
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tbnd_manual_eval_op(
            i_code -- 债券代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,i_name -- 债券名称
            ,beg_date -- 估值日期
            ,imp_date -- 录入日期
            ,price -- 中证估值(净价)
            ,dirty_price -- 中证估值(全价)
            ,mk_mdvbp -- 基点价值
            ,mk_duration -- 修正久期
            ,mk_convexity -- 凸性
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 债券代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.i_name, o.i_name) as i_name -- 债券名称
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 估值日期
    ,nvl(n.imp_date, o.imp_date) as imp_date -- 录入日期
    ,nvl(n.price, o.price) as price -- 中证估值(净价)
    ,nvl(n.dirty_price, o.dirty_price) as dirty_price -- 中证估值(全价)
    ,nvl(n.mk_mdvbp, o.mk_mdvbp) as mk_mdvbp -- 基点价值
    ,nvl(n.mk_duration, o.mk_duration) as mk_duration -- 修正久期
    ,nvl(n.mk_convexity, o.mk_convexity) as mk_convexity -- 凸性
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.beg_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.beg_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.beg_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_tbnd_manual_eval_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_tbnd_manual_eval where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.beg_date = n.beg_date
where (
        o.i_code is null
        and o.a_type is null
        and o.m_type is null
        and o.beg_date is null
    )
    or (
        n.i_code is null
        and n.a_type is null
        and n.m_type is null
        and n.beg_date is null
    )
    or (
        o.i_name <> n.i_name
        or o.imp_date <> n.imp_date
        or o.price <> n.price
        or o.dirty_price <> n.dirty_price
        or o.mk_mdvbp <> n.mk_mdvbp
        or o.mk_duration <> n.mk_duration
        or o.mk_convexity <> n.mk_convexity
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tbnd_manual_eval_cl(
            i_code -- 债券代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,i_name -- 债券名称
            ,beg_date -- 估值日期
            ,imp_date -- 录入日期
            ,price -- 中证估值(净价)
            ,dirty_price -- 中证估值(全价)
            ,mk_mdvbp -- 基点价值
            ,mk_duration -- 修正久期
            ,mk_convexity -- 凸性
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tbnd_manual_eval_op(
            i_code -- 债券代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,i_name -- 债券名称
            ,beg_date -- 估值日期
            ,imp_date -- 录入日期
            ,price -- 中证估值(净价)
            ,dirty_price -- 中证估值(全价)
            ,mk_mdvbp -- 基点价值
            ,mk_duration -- 修正久期
            ,mk_convexity -- 凸性
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 债券代码
    ,o.a_type -- 资产类型
    ,o.m_type -- 市场类型
    ,o.i_name -- 债券名称
    ,o.beg_date -- 估值日期
    ,o.imp_date -- 录入日期
    ,o.price -- 中证估值(净价)
    ,o.dirty_price -- 中证估值(全价)
    ,o.mk_mdvbp -- 基点价值
    ,o.mk_duration -- 修正久期
    ,o.mk_convexity -- 凸性
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_tbnd_manual_eval_bk o
    left join ${iol_schema}.ibms_tbnd_manual_eval_op n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.beg_date = n.beg_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_tbnd_manual_eval_cl d
        on
            o.i_code = d.i_code
            and o.a_type = d.a_type
            and o.m_type = d.m_type
            and o.beg_date = d.beg_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_tbnd_manual_eval;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_tbnd_manual_eval exchange partition p_19000101 with table ${iol_schema}.ibms_tbnd_manual_eval_cl;
alter table ${iol_schema}.ibms_tbnd_manual_eval exchange partition p_20991231 with table ${iol_schema}.ibms_tbnd_manual_eval_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_tbnd_manual_eval to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tbnd_manual_eval_op purge;
drop table ${iol_schema}.ibms_tbnd_manual_eval_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_tbnd_manual_eval_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_tbnd_manual_eval',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
