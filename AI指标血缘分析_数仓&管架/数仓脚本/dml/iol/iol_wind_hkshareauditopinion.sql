/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_hkshareauditopinion
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.wind_hkshareauditopinion_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_hkshareauditopinion
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_hkshareauditopinion_op purge;
drop table ${iol_schema}.wind_hkshareauditopinion_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hkshareauditopinion_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_hkshareauditopinion where 0=1;

create table ${iol_schema}.wind_hkshareauditopinion_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_hkshareauditopinion where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.wind_hkshareauditopinion_op(
        object_id -- 对象ID
        ,s_info_compcode -- 公司id
        ,ann_dt -- 公告日期
        ,begin_dt -- 起始日期
        ,end_dt_ora -- 截止日期
        ,audit_std -- 会计准则类型代码
        ,s_stmnote_audit_agency -- 审计机构名称
        ,s_stmnote_audit_category -- 审计意见类型
        ,audit_ctnt -- 非标审计意见内容
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.object_id -- 对象ID
    ,n.s_info_compcode -- 公司id
    ,n.ann_dt -- 公告日期
    ,n.begin_dt -- 起始日期
    ,n.end_dt_ora -- 截止日期
    ,n.audit_std -- 会计准则类型代码
    ,n.s_stmnote_audit_agency -- 审计机构名称
    ,n.s_stmnote_audit_category -- 审计意见类型
    ,n.audit_ctnt -- 非标审计意见内容
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_hkshareauditopinion_bk o
    right join (select * from ${itl_schema}.wind_hkshareauditopinion where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.s_info_compcode = n.s_info_compcode
            and o.begin_dt = n.begin_dt
            and o.end_dt_ora = n.end_dt_ora
            and o.audit_std = n.audit_std
where (
        o.s_info_compcode is null
        and o.begin_dt is null
        and o.end_dt_ora is null
        and o.audit_std is null
    )
    or (
        o.object_id <> n.object_id
        or o.ann_dt <> n.ann_dt
        or o.s_stmnote_audit_agency <> n.s_stmnote_audit_agency
        or o.s_stmnote_audit_category <> n.s_stmnote_audit_category
        or o.audit_ctnt <> n.audit_ctnt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_hkshareauditopinion_cl(
            object_id -- 对象ID
        ,s_info_compcode -- 公司id
        ,ann_dt -- 公告日期
        ,begin_dt -- 起始日期
        ,end_dt_ora -- 截止日期
        ,audit_std -- 会计准则类型代码
        ,s_stmnote_audit_agency -- 审计机构名称
        ,s_stmnote_audit_category -- 审计意见类型
        ,audit_ctnt -- 非标审计意见内容
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_hkshareauditopinion_op(
            object_id -- 对象ID
        ,s_info_compcode -- 公司id
        ,ann_dt -- 公告日期
        ,begin_dt -- 起始日期
        ,end_dt_ora -- 截止日期
        ,audit_std -- 会计准则类型代码
        ,s_stmnote_audit_agency -- 审计机构名称
        ,s_stmnote_audit_category -- 审计意见类型
        ,audit_ctnt -- 非标审计意见内容
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象ID
    ,o.s_info_compcode -- 公司id
    ,o.ann_dt -- 公告日期
    ,o.begin_dt -- 起始日期
    ,o.end_dt_ora -- 截止日期
    ,o.audit_std -- 会计准则类型代码
    ,o.s_stmnote_audit_agency -- 审计机构名称
    ,o.s_stmnote_audit_category -- 审计意见类型
    ,o.audit_ctnt -- 非标审计意见内容
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_hkshareauditopinion_bk o
    left join ${iol_schema}.wind_hkshareauditopinion_op n
        on
            o.s_info_compcode = n.s_info_compcode
            and o.begin_dt = n.begin_dt
            and o.end_dt_ora = n.end_dt_ora
            and o.audit_std = n.audit_std
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_hkshareauditopinion;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('wind_hkshareauditopinion') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.wind_hkshareauditopinion drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.wind_hkshareauditopinion add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.wind_hkshareauditopinion exchange partition p_${batch_date} with table ${iol_schema}.wind_hkshareauditopinion_cl;
alter table ${iol_schema}.wind_hkshareauditopinion exchange partition p_20991231 with table ${iol_schema}.wind_hkshareauditopinion_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_hkshareauditopinion to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_hkshareauditopinion_op purge;
drop table ${iol_schema}.wind_hkshareauditopinion_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_hkshareauditopinion_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_hkshareauditopinion',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
