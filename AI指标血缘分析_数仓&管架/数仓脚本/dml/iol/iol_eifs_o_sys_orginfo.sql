/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_o_sys_orginfo
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
create table ${iol_schema}.eifs_o_sys_orginfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_o_sys_orginfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_o_sys_orginfo_op purge;
drop table ${iol_schema}.eifs_o_sys_orginfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_o_sys_orginfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_o_sys_orginfo where 0=1;

create table ${iol_schema}.eifs_o_sys_orginfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_o_sys_orginfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_o_sys_orginfo_cl(
            org_id -- 机构ID
            ,org_no -- 机构号
            ,org_name -- 机构名称
            ,org_type_cd -- 机构类型代码
            ,up_org_id -- 上级机构ID
            ,b_org_id -- 所属机构
            ,expend_no -- 扩展信息
            ,status_cd -- 状态
            ,created_by -- 创建人
            ,created_ts -- 创建时间
            ,last_upd_by -- 更新人
            ,last_upd_ts -- 更新时间
            ,org_level -- 机构层级
            ,below_line -- 归属线条
            ,remarks -- 备注说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_o_sys_orginfo_op(
            org_id -- 机构ID
            ,org_no -- 机构号
            ,org_name -- 机构名称
            ,org_type_cd -- 机构类型代码
            ,up_org_id -- 上级机构ID
            ,b_org_id -- 所属机构
            ,expend_no -- 扩展信息
            ,status_cd -- 状态
            ,created_by -- 创建人
            ,created_ts -- 创建时间
            ,last_upd_by -- 更新人
            ,last_upd_ts -- 更新时间
            ,org_level -- 机构层级
            ,below_line -- 归属线条
            ,remarks -- 备注说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.org_id, o.org_id) as org_id -- 机构ID
    ,nvl(n.org_no, o.org_no) as org_no -- 机构号
    ,nvl(n.org_name, o.org_name) as org_name -- 机构名称
    ,nvl(n.org_type_cd, o.org_type_cd) as org_type_cd -- 机构类型代码
    ,nvl(n.up_org_id, o.up_org_id) as up_org_id -- 上级机构ID
    ,nvl(n.b_org_id, o.b_org_id) as b_org_id -- 所属机构
    ,nvl(n.expend_no, o.expend_no) as expend_no -- 扩展信息
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.created_ts, o.created_ts) as created_ts -- 创建时间
    ,nvl(n.last_upd_by, o.last_upd_by) as last_upd_by -- 更新人
    ,nvl(n.last_upd_ts, o.last_upd_ts) as last_upd_ts -- 更新时间
    ,nvl(n.org_level, o.org_level) as org_level -- 机构层级
    ,nvl(n.below_line, o.below_line) as below_line -- 归属线条
    ,nvl(n.remarks, o.remarks) as remarks -- 备注说明
    ,case when
            n.org_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.org_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.org_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_o_sys_orginfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_o_sys_orginfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.org_id = n.org_id
where (
        o.org_id is null
    )
    or (
        n.org_id is null
    )
    or (
        o.org_no <> n.org_no
        or o.org_name <> n.org_name
        or o.org_type_cd <> n.org_type_cd
        or o.up_org_id <> n.up_org_id
        or o.b_org_id <> n.b_org_id
        or o.expend_no <> n.expend_no
        or o.status_cd <> n.status_cd
        or o.created_by <> n.created_by
        or o.created_ts <> n.created_ts
        or o.last_upd_by <> n.last_upd_by
        or o.last_upd_ts <> n.last_upd_ts
        or o.org_level <> n.org_level
        or o.below_line <> n.below_line
        or o.remarks <> n.remarks
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_o_sys_orginfo_cl(
            org_id -- 机构ID
            ,org_no -- 机构号
            ,org_name -- 机构名称
            ,org_type_cd -- 机构类型代码
            ,up_org_id -- 上级机构ID
            ,b_org_id -- 所属机构
            ,expend_no -- 扩展信息
            ,status_cd -- 状态
            ,created_by -- 创建人
            ,created_ts -- 创建时间
            ,last_upd_by -- 更新人
            ,last_upd_ts -- 更新时间
            ,org_level -- 机构层级
            ,below_line -- 归属线条
            ,remarks -- 备注说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_o_sys_orginfo_op(
            org_id -- 机构ID
            ,org_no -- 机构号
            ,org_name -- 机构名称
            ,org_type_cd -- 机构类型代码
            ,up_org_id -- 上级机构ID
            ,b_org_id -- 所属机构
            ,expend_no -- 扩展信息
            ,status_cd -- 状态
            ,created_by -- 创建人
            ,created_ts -- 创建时间
            ,last_upd_by -- 更新人
            ,last_upd_ts -- 更新时间
            ,org_level -- 机构层级
            ,below_line -- 归属线条
            ,remarks -- 备注说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.org_id -- 机构ID
    ,o.org_no -- 机构号
    ,o.org_name -- 机构名称
    ,o.org_type_cd -- 机构类型代码
    ,o.up_org_id -- 上级机构ID
    ,o.b_org_id -- 所属机构
    ,o.expend_no -- 扩展信息
    ,o.status_cd -- 状态
    ,o.created_by -- 创建人
    ,o.created_ts -- 创建时间
    ,o.last_upd_by -- 更新人
    ,o.last_upd_ts -- 更新时间
    ,o.org_level -- 机构层级
    ,o.below_line -- 归属线条
    ,o.remarks -- 备注说明
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.eifs_o_sys_orginfo_bk o
    left join ${iol_schema}.eifs_o_sys_orginfo_op n
        on
            o.org_id = n.org_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_o_sys_orginfo_cl d
        on
            o.org_id = d.org_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.eifs_o_sys_orginfo;

-- 4.2 exchange partition
alter table ${iol_schema}.eifs_o_sys_orginfo exchange partition p_19000101 with table ${iol_schema}.eifs_o_sys_orginfo_cl;
alter table ${iol_schema}.eifs_o_sys_orginfo exchange partition p_20991231 with table ${iol_schema}.eifs_o_sys_orginfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_o_sys_orginfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_o_sys_orginfo_op purge;
drop table ${iol_schema}.eifs_o_sys_orginfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_o_sys_orginfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_o_sys_orginfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
