/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_rating_firm
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
create table ${iol_schema}.ctms_tbs_v_rating_firm_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_rating_firm;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_rating_firm_op purge;
drop table ${iol_schema}.ctms_tbs_v_rating_firm_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_rating_firm_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_rating_firm where 0=1;

create table ${iol_schema}.ctms_tbs_v_rating_firm_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_rating_firm where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_rating_firm_cl(
            firm_id -- 评级公司ID
            ,status -- 状态
            ,firm_name_zh -- 评级公司中文名
            ,firm_name_en -- 评级公司英文名
            ,modify_date -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_rating_firm_op(
            firm_id -- 评级公司ID
            ,status -- 状态
            ,firm_name_zh -- 评级公司中文名
            ,firm_name_en -- 评级公司英文名
            ,modify_date -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.firm_id, o.firm_id) as firm_id -- 评级公司ID
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.firm_name_zh, o.firm_name_zh) as firm_name_zh -- 评级公司中文名
    ,nvl(n.firm_name_en, o.firm_name_en) as firm_name_en -- 评级公司英文名
    ,nvl(n.modify_date, o.modify_date) as modify_date -- 修改时间
    ,case when
            n.firm_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.firm_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.firm_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_v_rating_firm_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_rating_firm where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.firm_id = n.firm_id
where (
        o.firm_id is null
    )
    or (
        n.firm_id is null
    )
    or (
        o.status <> n.status
        or o.firm_name_zh <> n.firm_name_zh
        or o.firm_name_en <> n.firm_name_en
        or o.modify_date <> n.modify_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_rating_firm_cl(
            firm_id -- 评级公司ID
            ,status -- 状态
            ,firm_name_zh -- 评级公司中文名
            ,firm_name_en -- 评级公司英文名
            ,modify_date -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_rating_firm_op(
            firm_id -- 评级公司ID
            ,status -- 状态
            ,firm_name_zh -- 评级公司中文名
            ,firm_name_en -- 评级公司英文名
            ,modify_date -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.firm_id -- 评级公司ID
    ,o.status -- 状态
    ,o.firm_name_zh -- 评级公司中文名
    ,o.firm_name_en -- 评级公司英文名
    ,o.modify_date -- 修改时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_v_rating_firm_bk o
    left join ${iol_schema}.ctms_tbs_v_rating_firm_op n
        on
            o.firm_id = n.firm_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_rating_firm_cl d
        on
            o.firm_id = d.firm_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_v_rating_firm;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_v_rating_firm exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_v_rating_firm_cl;
alter table ${iol_schema}.ctms_tbs_v_rating_firm exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_rating_firm_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_rating_firm to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_rating_firm_op purge;
drop table ${iol_schema}.ctms_tbs_v_rating_firm_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_rating_firm_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_rating_firm',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
