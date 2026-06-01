/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_fin_deal_pledge
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
create table ${iol_schema}.fams_fin_deal_pledge_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_fin_deal_pledge;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_deal_pledge_op purge;
drop table ${iol_schema}.fams_fin_deal_pledge_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_deal_pledge_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_deal_pledge where 0=1;

create table ${iol_schema}.fams_fin_deal_pledge_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_deal_pledge where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_deal_pledge_cl(
            finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,pledge_finprod_id -- 质押金融产品代码
            ,pledge_face_value -- 质押面值
            ,pledge_number -- 质押数量
            ,pledge_ratio -- 质押率
            ,pledge_amt -- 质押金额
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_deal_pledge_op(
            finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,pledge_finprod_id -- 质押金融产品代码
            ,pledge_face_value -- 质押面值
            ,pledge_number -- 质押数量
            ,pledge_ratio -- 质押率
            ,pledge_amt -- 质押金额
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.branch, o.branch) as branch -- 分支序号
    ,nvl(n.pledge_finprod_id, o.pledge_finprod_id) as pledge_finprod_id -- 质押金融产品代码
    ,nvl(n.pledge_face_value, o.pledge_face_value) as pledge_face_value -- 质押面值
    ,nvl(n.pledge_number, o.pledge_number) as pledge_number -- 质押数量
    ,nvl(n.pledge_ratio, o.pledge_ratio) as pledge_ratio -- 质押率
    ,nvl(n.pledge_amt, o.pledge_amt) as pledge_amt -- 质押金额
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.finprod_id is null
            and n.branch is null
            and n.pledge_finprod_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.finprod_id is null
            and n.branch is null
            and n.pledge_finprod_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.finprod_id is null
            and n.branch is null
            and n.pledge_finprod_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_fin_deal_pledge_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_fin_deal_pledge where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.finprod_id = n.finprod_id
            and o.branch = n.branch
            and o.pledge_finprod_id = n.pledge_finprod_id
where (
        o.finprod_id is null
        and o.branch is null
        and o.pledge_finprod_id is null
    )
    or (
        n.finprod_id is null
        and n.branch is null
        and n.pledge_finprod_id is null
    )
    or (
        o.pledge_face_value <> n.pledge_face_value
        or o.pledge_number <> n.pledge_number
        or o.pledge_ratio <> n.pledge_ratio
        or o.pledge_amt <> n.pledge_amt
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_deal_pledge_cl(
            finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,pledge_finprod_id -- 质押金融产品代码
            ,pledge_face_value -- 质押面值
            ,pledge_number -- 质押数量
            ,pledge_ratio -- 质押率
            ,pledge_amt -- 质押金额
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_deal_pledge_op(
            finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,pledge_finprod_id -- 质押金融产品代码
            ,pledge_face_value -- 质押面值
            ,pledge_number -- 质押数量
            ,pledge_ratio -- 质押率
            ,pledge_amt -- 质押金额
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.finprod_id -- 金融产品代码
    ,o.branch -- 分支序号
    ,o.pledge_finprod_id -- 质押金融产品代码
    ,o.pledge_face_value -- 质押面值
    ,o.pledge_number -- 质押数量
    ,o.pledge_ratio -- 质押率
    ,o.pledge_amt -- 质押金额
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_fin_deal_pledge_bk o
    left join ${iol_schema}.fams_fin_deal_pledge_op n
        on
            o.finprod_id = n.finprod_id
            and o.branch = n.branch
            and o.pledge_finprod_id = n.pledge_finprod_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_fin_deal_pledge_cl d
        on
            o.finprod_id = d.finprod_id
            and o.branch = d.branch
            and o.pledge_finprod_id = d.pledge_finprod_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_fin_deal_pledge;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_fin_deal_pledge exchange partition p_19000101 with table ${iol_schema}.fams_fin_deal_pledge_cl;
alter table ${iol_schema}.fams_fin_deal_pledge exchange partition p_20991231 with table ${iol_schema}.fams_fin_deal_pledge_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_fin_deal_pledge to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_deal_pledge_op purge;
drop table ${iol_schema}.fams_fin_deal_pledge_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_fin_deal_pledge_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_fin_deal_pledge',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
