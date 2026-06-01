/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_security_rating
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
create table ${iol_schema}.ctms_tbs_v_security_rating_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_security_rating;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_security_rating_op purge;
drop table ${iol_schema}.ctms_tbs_v_security_rating_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_security_rating_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_security_rating where 0=1;

create table ${iol_schema}.ctms_tbs_v_security_rating_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_security_rating where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_security_rating_cl(
            security_code -- 债券代码
            ,firm_id -- 评级公司id
            ,rating -- 评级
            ,modify_time -- 修改时间
            ,rating_date -- 评级日期
            ,rating_category -- 评级类别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_security_rating_op(
            security_code -- 债券代码
            ,firm_id -- 评级公司id
            ,rating -- 评级
            ,modify_time -- 修改时间
            ,rating_date -- 评级日期
            ,rating_category -- 评级类别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.security_code, o.security_code) as security_code -- 债券代码
    ,nvl(n.firm_id, o.firm_id) as firm_id -- 评级公司id
    ,nvl(n.rating, o.rating) as rating -- 评级
    ,nvl(n.modify_time, o.modify_time) as modify_time -- 修改时间
    ,nvl(n.rating_date, o.rating_date) as rating_date -- 评级日期
    ,nvl(n.rating_category, o.rating_category) as rating_category -- 评级类别
    ,case when
            n.security_code is null
            and n.firm_id is null
            and n.rating is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.security_code is null
            and n.firm_id is null
            and n.rating is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.security_code is null
            and n.firm_id is null
            and n.rating is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_v_security_rating_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_security_rating where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.security_code = n.security_code
            and o.firm_id = n.firm_id
            and o.rating = n.rating
where (
        o.security_code is null
        and o.firm_id is null
        and o.rating is null
    )
    or (
        n.security_code is null
        and n.firm_id is null
        and n.rating is null
    )
    or (
        o.modify_time <> n.modify_time
        or o.rating_date <> n.rating_date
        or o.rating_category <> n.rating_category
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_security_rating_cl(
            security_code -- 债券代码
            ,firm_id -- 评级公司id
            ,rating -- 评级
            ,modify_time -- 修改时间
            ,rating_date -- 评级日期
            ,rating_category -- 评级类别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_security_rating_op(
            security_code -- 债券代码
            ,firm_id -- 评级公司id
            ,rating -- 评级
            ,modify_time -- 修改时间
            ,rating_date -- 评级日期
            ,rating_category -- 评级类别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.security_code -- 债券代码
    ,o.firm_id -- 评级公司id
    ,o.rating -- 评级
    ,o.modify_time -- 修改时间
    ,o.rating_date -- 评级日期
    ,o.rating_category -- 评级类别
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_v_security_rating_bk o
    left join ${iol_schema}.ctms_tbs_v_security_rating_op n
        on
            o.security_code = n.security_code
            and o.firm_id = n.firm_id
            and o.rating = n.rating
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_security_rating_cl d
        on
            o.security_code = d.security_code
            and o.firm_id = d.firm_id
            and o.rating = d.rating
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_v_security_rating;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_v_security_rating exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_v_security_rating_cl;
alter table ${iol_schema}.ctms_tbs_v_security_rating exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_security_rating_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_security_rating to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_security_rating_op purge;
drop table ${iol_schema}.ctms_tbs_v_security_rating_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_security_rating_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_security_rating',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
