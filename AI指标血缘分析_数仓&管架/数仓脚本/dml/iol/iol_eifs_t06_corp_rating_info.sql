/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t06_corp_rating_info
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
create table ${iol_schema}.eifs_t06_corp_rating_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t06_corp_rating_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t06_corp_rating_info_op purge;
drop table ${iol_schema}.eifs_t06_corp_rating_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t06_corp_rating_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t06_corp_rating_info where 0=1;

create table ${iol_schema}.eifs_t06_corp_rating_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t06_corp_rating_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t06_corp_rating_info_cl(
            grade_id -- 评级信息id
            ,party_id -- 参与人id
            ,ext_crdt_rating_cd -- 外部信用评级
            ,ext_crdt_rating_dt -- 外部信用评级日期
            ,ext_crdt_effect_dt -- 外部评级生效日期
            ,ext_crdt_invalid_dt -- 外部评级失效日期
            ,rating_org_name -- 外部评级机构名称
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,rating_org_type -- 外部评级机构类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t06_corp_rating_info_op(
            grade_id -- 评级信息id
            ,party_id -- 参与人id
            ,ext_crdt_rating_cd -- 外部信用评级
            ,ext_crdt_rating_dt -- 外部信用评级日期
            ,ext_crdt_effect_dt -- 外部评级生效日期
            ,ext_crdt_invalid_dt -- 外部评级失效日期
            ,rating_org_name -- 外部评级机构名称
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,rating_org_type -- 外部评级机构类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.grade_id, o.grade_id) as grade_id -- 评级信息id
    ,nvl(n.party_id, o.party_id) as party_id -- 参与人id
    ,nvl(n.ext_crdt_rating_cd, o.ext_crdt_rating_cd) as ext_crdt_rating_cd -- 外部信用评级
    ,nvl(n.ext_crdt_rating_dt, o.ext_crdt_rating_dt) as ext_crdt_rating_dt -- 外部信用评级日期
    ,nvl(n.ext_crdt_effect_dt, o.ext_crdt_effect_dt) as ext_crdt_effect_dt -- 外部评级生效日期
    ,nvl(n.ext_crdt_invalid_dt, o.ext_crdt_invalid_dt) as ext_crdt_invalid_dt -- 外部评级失效日期
    ,nvl(n.rating_org_name, o.rating_org_name) as rating_org_name -- 外部评级机构名称
    ,nvl(n.create_te, o.create_te) as create_te -- 创建柜员
    ,nvl(n.create_org, o.create_org) as create_org -- 创建机构号
    ,nvl(n.init_system_id, o.init_system_id) as init_system_id -- 创建渠道
    ,nvl(n.init_created_ts, o.init_created_ts) as init_created_ts -- 源系统创建时间
    ,nvl(n.created_ts, o.created_ts) as created_ts -- 进入ecif的时间
    ,nvl(n.updated_ts, o.updated_ts) as updated_ts -- 在ecif中失效的时间
    ,nvl(n.last_updated_te, o.last_updated_te) as last_updated_te -- 最新更新柜员
    ,nvl(n.last_updated_org, o.last_updated_org) as last_updated_org -- 最新更新机构号
    ,nvl(n.last_system_id, o.last_system_id) as last_system_id -- 最新更新渠道
    ,nvl(n.last_updated_ts, o.last_updated_ts) as last_updated_ts -- 最新更新时间
    ,nvl(n.src_sys_num, o.src_sys_num) as src_sys_num -- 来源系统编号
    ,nvl(n.last_updated_src_sys_num, o.last_updated_src_sys_num) as last_updated_src_sys_num -- 最新更新源系统编号
    ,nvl(n.rating_org_type, o.rating_org_type) as rating_org_type -- 外部评级机构类型
    ,case when
            n.grade_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.grade_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.grade_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t06_corp_rating_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t06_corp_rating_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.grade_id = n.grade_id
where (
        o.grade_id is null
    )
    or (
        n.grade_id is null
    )
    or (
        o.party_id <> n.party_id
        or o.ext_crdt_rating_cd <> n.ext_crdt_rating_cd
        or o.ext_crdt_rating_dt <> n.ext_crdt_rating_dt
        or o.ext_crdt_effect_dt <> n.ext_crdt_effect_dt
        or o.ext_crdt_invalid_dt <> n.ext_crdt_invalid_dt
        or o.rating_org_name <> n.rating_org_name
        or o.create_te <> n.create_te
        or o.create_org <> n.create_org
        or o.init_system_id <> n.init_system_id
        or o.init_created_ts <> n.init_created_ts
        or o.created_ts <> n.created_ts
        or o.updated_ts <> n.updated_ts
        or o.last_updated_te <> n.last_updated_te
        or o.last_updated_org <> n.last_updated_org
        or o.last_system_id <> n.last_system_id
        or o.last_updated_ts <> n.last_updated_ts
        or o.src_sys_num <> n.src_sys_num
        or o.last_updated_src_sys_num <> n.last_updated_src_sys_num
        or o.rating_org_type <> n.rating_org_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t06_corp_rating_info_cl(
            grade_id -- 评级信息id
            ,party_id -- 参与人id
            ,ext_crdt_rating_cd -- 外部信用评级
            ,ext_crdt_rating_dt -- 外部信用评级日期
            ,ext_crdt_effect_dt -- 外部评级生效日期
            ,ext_crdt_invalid_dt -- 外部评级失效日期
            ,rating_org_name -- 外部评级机构名称
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,rating_org_type -- 外部评级机构类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t06_corp_rating_info_op(
            grade_id -- 评级信息id
            ,party_id -- 参与人id
            ,ext_crdt_rating_cd -- 外部信用评级
            ,ext_crdt_rating_dt -- 外部信用评级日期
            ,ext_crdt_effect_dt -- 外部评级生效日期
            ,ext_crdt_invalid_dt -- 外部评级失效日期
            ,rating_org_name -- 外部评级机构名称
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,rating_org_type -- 外部评级机构类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.grade_id -- 评级信息id
    ,o.party_id -- 参与人id
    ,o.ext_crdt_rating_cd -- 外部信用评级
    ,o.ext_crdt_rating_dt -- 外部信用评级日期
    ,o.ext_crdt_effect_dt -- 外部评级生效日期
    ,o.ext_crdt_invalid_dt -- 外部评级失效日期
    ,o.rating_org_name -- 外部评级机构名称
    ,o.create_te -- 创建柜员
    ,o.create_org -- 创建机构号
    ,o.init_system_id -- 创建渠道
    ,o.init_created_ts -- 源系统创建时间
    ,o.created_ts -- 进入ecif的时间
    ,o.updated_ts -- 在ecif中失效的时间
    ,o.last_updated_te -- 最新更新柜员
    ,o.last_updated_org -- 最新更新机构号
    ,o.last_system_id -- 最新更新渠道
    ,o.last_updated_ts -- 最新更新时间
    ,o.src_sys_num -- 来源系统编号
    ,o.last_updated_src_sys_num -- 最新更新源系统编号
    ,o.rating_org_type -- 外部评级机构类型
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.eifs_t06_corp_rating_info_bk o
    left join ${iol_schema}.eifs_t06_corp_rating_info_op n
        on
            o.grade_id = n.grade_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t06_corp_rating_info_cl d
        on
            o.grade_id = d.grade_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t06_corp_rating_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t06_corp_rating_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t06_corp_rating_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t06_corp_rating_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t06_corp_rating_info exchange partition p_${batch_date} with table ${iol_schema}.eifs_t06_corp_rating_info_cl;
alter table ${iol_schema}.eifs_t06_corp_rating_info exchange partition p_20991231 with table ${iol_schema}.eifs_t06_corp_rating_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t06_corp_rating_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t06_corp_rating_info_op purge;
drop table ${iol_schema}.eifs_t06_corp_rating_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t06_corp_rating_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t06_corp_rating_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
