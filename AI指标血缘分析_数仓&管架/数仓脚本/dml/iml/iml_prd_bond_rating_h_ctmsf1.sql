/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_bond_rating_h_ctmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_bond_rating_h add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ctmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_bond_rating_h_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_rating_h partition for ('ctmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_bond_rating_h_ctmsf1_tm purge;
drop table ${iml_schema}.prd_bond_rating_h_ctmsf1_op purge;
drop table ${iml_schema}.prd_bond_rating_h_ctmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_bond_rating_h_ctmsf1_tm nologging
compress ${option_switch} for query high
as select
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,rating_org_id -- 评级机构编号
    ,rating_cate_cd -- 评级类别代码
    ,rating_dt -- 评级日期
    ,rating_level -- 评级等级
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_rating_h partition for ('ctmsf1')
where 0=1
;

create table ${iml_schema}.prd_bond_rating_h_ctmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_rating_h partition for ('ctmsf1') where 0=1;

create table ${iml_schema}.prd_bond_rating_h_ctmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_rating_h partition for ('ctmsf1') where 0=1;

-- 3.1 get new data into table
-- ctms_tbs_v_security_rating-
insert into ${iml_schema}.prd_bond_rating_h_ctmsf1_tm(
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,rating_org_id -- 评级机构编号
    ,rating_cate_cd -- 评级类别代码
    ,rating_dt -- 评级日期
    ,rating_level -- 评级等级
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SECURITY_CODE -- 债券编号
    ,'9999' -- 法人编号
    ,P1.FIRM_ID -- 评级机构编号
    ,P1.RATING_CATEGORY -- 评级类别代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.RATING_DATE) -- 评级日期
    ,P1.RATING -- 评级等级
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_v_security_rating' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_v_security_rating p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_bond_rating_h_ctmsf1_cl(
            bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,rating_org_id -- 评级机构编号
    ,rating_cate_cd -- 评级类别代码
    ,rating_dt -- 评级日期
    ,rating_level -- 评级等级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_bond_rating_h_ctmsf1_op(
            bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,rating_org_id -- 评级机构编号
    ,rating_cate_cd -- 评级类别代码
    ,rating_dt -- 评级日期
    ,rating_level -- 评级等级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bond_id, o.bond_id) as bond_id -- 债券编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.rating_org_id, o.rating_org_id) as rating_org_id -- 评级机构编号
    ,nvl(n.rating_cate_cd, o.rating_cate_cd) as rating_cate_cd -- 评级类别代码
    ,nvl(n.rating_dt, o.rating_dt) as rating_dt -- 评级日期
    ,nvl(n.rating_level, o.rating_level) as rating_level -- 评级等级
    ,case when
            n.bond_id is null
            and n.lp_id is null
            and n.rating_org_id is null
            and n.rating_cate_cd is null
            and n.rating_dt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bond_id is null
            and n.lp_id is null
            and n.rating_org_id is null
            and n.rating_cate_cd is null
            and n.rating_dt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bond_id is null
            and n.lp_id is null
            and n.rating_org_id is null
            and n.rating_cate_cd is null
            and n.rating_dt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_rating_h_ctmsf1_tm n
    full join (select * from ${iml_schema}.prd_bond_rating_h_ctmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.bond_id = n.bond_id
            and o.lp_id = n.lp_id
            and o.rating_org_id = n.rating_org_id
            and o.rating_cate_cd = n.rating_cate_cd
            and o.rating_dt = n.rating_dt
where (
        o.bond_id is null
        and o.lp_id is null
        and o.rating_org_id is null
        and o.rating_cate_cd is null
        and o.rating_dt is null
    )
    or (
        n.bond_id is null
        and n.lp_id is null
        and n.rating_org_id is null
        and n.rating_cate_cd is null
        and n.rating_dt is null
    )
    or (
        o.rating_level <> n.rating_level
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_bond_rating_h_ctmsf1_cl(
            bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,rating_org_id -- 评级机构编号
    ,rating_cate_cd -- 评级类别代码
    ,rating_dt -- 评级日期
    ,rating_level -- 评级等级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_bond_rating_h_ctmsf1_op(
            bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,rating_org_id -- 评级机构编号
    ,rating_cate_cd -- 评级类别代码
    ,rating_dt -- 评级日期
    ,rating_level -- 评级等级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bond_id -- 债券编号
    ,o.lp_id -- 法人编号
    ,o.rating_org_id -- 评级机构编号
    ,o.rating_cate_cd -- 评级类别代码
    ,o.rating_dt -- 评级日期
    ,o.rating_level -- 评级等级
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_rating_h_ctmsf1_bk o
    left join ${iml_schema}.prd_bond_rating_h_ctmsf1_op n
        on
            o.bond_id = n.bond_id
            and o.lp_id = n.lp_id
            and o.rating_org_id = n.rating_org_id
            and o.rating_cate_cd = n.rating_cate_cd
            and o.rating_dt = n.rating_dt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_bond_rating_h_ctmsf1_cl d
        on
            o.bond_id = d.bond_id
            and o.lp_id = d.lp_id
            and o.rating_org_id = d.rating_org_id
            and o.rating_cate_cd = d.rating_cate_cd
            and o.rating_dt = d.rating_dt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_bond_rating_h;
alter table ${iml_schema}.prd_bond_rating_h truncate partition for ('ctmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_bond_rating_h exchange subpartition p_ctmsf1_19000101 with table ${iml_schema}.prd_bond_rating_h_ctmsf1_cl;
alter table ${iml_schema}.prd_bond_rating_h exchange subpartition p_ctmsf1_20991231 with table ${iml_schema}.prd_bond_rating_h_ctmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_bond_rating_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_bond_rating_h_ctmsf1_tm purge;
drop table ${iml_schema}.prd_bond_rating_h_ctmsf1_op purge;
drop table ${iml_schema}.prd_bond_rating_h_ctmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_bond_rating_h_ctmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_bond_rating_h', partname => 'p_ctmsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
