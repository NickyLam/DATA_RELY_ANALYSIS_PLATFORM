/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_tlr_info
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
create table ${iol_schema}.bdms_tlr_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_tlr_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_tlr_info_op purge;
drop table ${iol_schema}.bdms_tlr_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_tlr_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_tlr_info where 0=1;

create table ${iol_schema}.bdms_tlr_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_tlr_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_tlr_info_cl(
            id -- 
            ,tlr_no -- 操作员编号
            ,tlr_name -- 操作员姓名
            ,br_id -- 所属机构id
            ,update_date -- 修改时间
            ,update_userid -- 修改人
            ,br_manager_id -- 总行id
            ,status -- 状态
            ,is_del -- 是否已删除
            ,create_userid -- 创建人
            ,create_date -- 创建时间
            ,mem_user_id -- 
            ,domainid -- 
            ,employeeid -- 员工编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_tlr_info_op(
            id -- 
            ,tlr_no -- 操作员编号
            ,tlr_name -- 操作员姓名
            ,br_id -- 所属机构id
            ,update_date -- 修改时间
            ,update_userid -- 修改人
            ,br_manager_id -- 总行id
            ,status -- 状态
            ,is_del -- 是否已删除
            ,create_userid -- 创建人
            ,create_date -- 创建时间
            ,mem_user_id -- 
            ,domainid -- 
            ,employeeid -- 员工编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.tlr_no, o.tlr_no) as tlr_no -- 操作员编号
    ,nvl(n.tlr_name, o.tlr_name) as tlr_name -- 操作员姓名
    ,nvl(n.br_id, o.br_id) as br_id -- 所属机构id
    ,nvl(n.update_date, o.update_date) as update_date -- 修改时间
    ,nvl(n.update_userid, o.update_userid) as update_userid -- 修改人
    ,nvl(n.br_manager_id, o.br_manager_id) as br_manager_id -- 总行id
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.is_del, o.is_del) as is_del -- 是否已删除
    ,nvl(n.create_userid, o.create_userid) as create_userid -- 创建人
    ,nvl(n.create_date, o.create_date) as create_date -- 创建时间
    ,nvl(n.mem_user_id, o.mem_user_id) as mem_user_id -- 
    ,nvl(n.domainid, o.domainid) as domainid -- 
    ,nvl(n.employeeid, o.employeeid) as employeeid -- 员工编号
    ,case when
            n.id is null
            and n.tlr_no is null
            and n.br_manager_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
            and n.tlr_no is null
            and n.br_manager_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
            and n.tlr_no is null
            and n.br_manager_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_tlr_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_tlr_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
            and o.tlr_no = n.tlr_no
            and o.br_manager_id = n.br_manager_id
where (
        o.id is null
        and o.tlr_no is null
        and o.br_manager_id is null
    )
    or (
        n.id is null
        and n.tlr_no is null
        and n.br_manager_id is null
    )
    or (
        o.tlr_name <> n.tlr_name
        or o.br_id <> n.br_id
        or o.update_date <> n.update_date
        or o.update_userid <> n.update_userid
        or o.status <> n.status
        or o.is_del <> n.is_del
        or o.create_userid <> n.create_userid
        or o.create_date <> n.create_date
        or o.mem_user_id <> n.mem_user_id
        or o.domainid <> n.domainid
        or o.employeeid <> n.employeeid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_tlr_info_cl(
            id -- 
            ,tlr_no -- 操作员编号
            ,tlr_name -- 操作员姓名
            ,br_id -- 所属机构id
            ,update_date -- 修改时间
            ,update_userid -- 修改人
            ,br_manager_id -- 总行id
            ,status -- 状态
            ,is_del -- 是否已删除
            ,create_userid -- 创建人
            ,create_date -- 创建时间
            ,mem_user_id -- 
            ,domainid -- 
            ,employeeid -- 员工编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_tlr_info_op(
            id -- 
            ,tlr_no -- 操作员编号
            ,tlr_name -- 操作员姓名
            ,br_id -- 所属机构id
            ,update_date -- 修改时间
            ,update_userid -- 修改人
            ,br_manager_id -- 总行id
            ,status -- 状态
            ,is_del -- 是否已删除
            ,create_userid -- 创建人
            ,create_date -- 创建时间
            ,mem_user_id -- 
            ,domainid -- 
            ,employeeid -- 员工编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.tlr_no -- 操作员编号
    ,o.tlr_name -- 操作员姓名
    ,o.br_id -- 所属机构id
    ,o.update_date -- 修改时间
    ,o.update_userid -- 修改人
    ,o.br_manager_id -- 总行id
    ,o.status -- 状态
    ,o.is_del -- 是否已删除
    ,o.create_userid -- 创建人
    ,o.create_date -- 创建时间
    ,o.mem_user_id -- 
    ,o.domainid -- 
    ,o.employeeid -- 员工编号
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
from ${iol_schema}.bdms_tlr_info_bk o
    left join ${iol_schema}.bdms_tlr_info_op n
        on
            o.id = n.id
            and o.tlr_no = n.tlr_no
            and o.br_manager_id = n.br_manager_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_tlr_info_cl d
        on
            o.id = d.id
            and o.tlr_no = d.tlr_no
            and o.br_manager_id = d.br_manager_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_tlr_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_tlr_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_tlr_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_tlr_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_tlr_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_tlr_info_cl;
alter table ${iol_schema}.bdms_tlr_info exchange partition p_20991231 with table ${iol_schema}.bdms_tlr_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_tlr_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_tlr_info_op purge;
drop table ${iol_schema}.bdms_tlr_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_tlr_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_tlr_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
