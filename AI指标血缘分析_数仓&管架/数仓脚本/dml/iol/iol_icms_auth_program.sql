/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_auth_program
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
create table ${iol_schema}.icms_auth_program_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_auth_program
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_auth_program_op purge;
drop table ${iol_schema}.icms_auth_program_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_auth_program_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_auth_program where 0=1;

create table ${iol_schema}.icms_auth_program_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_auth_program where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_auth_program_cl(
            programid -- 方案编号
            ,corporgid -- 法人机构编号
            ,programstartdate -- 方案起始日
            ,inputorgid -- 登记机构
            ,flows -- 流程
            ,groupid -- 方案组编号
            ,inputuserid -- 登记人
            ,authorizetype -- 授权类型
            ,programenddate -- 方案到期日
            ,programname -- 方案名称
            ,remark -- 备注
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,isinuse -- 有效状态
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,orglevel -- 机构类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_auth_program_op(
            programid -- 方案编号
            ,corporgid -- 法人机构编号
            ,programstartdate -- 方案起始日
            ,inputorgid -- 登记机构
            ,flows -- 流程
            ,groupid -- 方案组编号
            ,inputuserid -- 登记人
            ,authorizetype -- 授权类型
            ,programenddate -- 方案到期日
            ,programname -- 方案名称
            ,remark -- 备注
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,isinuse -- 有效状态
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,orglevel -- 机构类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.programid, o.programid) as programid -- 方案编号
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.programstartdate, o.programstartdate) as programstartdate -- 方案起始日
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.flows, o.flows) as flows -- 流程
    ,nvl(n.groupid, o.groupid) as groupid -- 方案组编号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.authorizetype, o.authorizetype) as authorizetype -- 授权类型
    ,nvl(n.programenddate, o.programenddate) as programenddate -- 方案到期日
    ,nvl(n.programname, o.programname) as programname -- 方案名称
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.isinuse, o.isinuse) as isinuse -- 有效状态
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.orglevel, o.orglevel) as orglevel -- 机构类型
    ,case when
            n.programid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.programid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.programid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_auth_program_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_auth_program where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.programid = n.programid
where (
        o.programid is null
    )
    or (
        n.programid is null
    )
    or (
        o.corporgid <> n.corporgid
        or o.programstartdate <> n.programstartdate
        or o.inputorgid <> n.inputorgid
        or o.flows <> n.flows
        or o.groupid <> n.groupid
        or o.inputuserid <> n.inputuserid
        or o.authorizetype <> n.authorizetype
        or o.programenddate <> n.programenddate
        or o.programname <> n.programname
        or o.remark <> n.remark
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.isinuse <> n.isinuse
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.orglevel <> n.orglevel
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_auth_program_cl(
            programid -- 方案编号
            ,corporgid -- 法人机构编号
            ,programstartdate -- 方案起始日
            ,inputorgid -- 登记机构
            ,flows -- 流程
            ,groupid -- 方案组编号
            ,inputuserid -- 登记人
            ,authorizetype -- 授权类型
            ,programenddate -- 方案到期日
            ,programname -- 方案名称
            ,remark -- 备注
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,isinuse -- 有效状态
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,orglevel -- 机构类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_auth_program_op(
            programid -- 方案编号
            ,corporgid -- 法人机构编号
            ,programstartdate -- 方案起始日
            ,inputorgid -- 登记机构
            ,flows -- 流程
            ,groupid -- 方案组编号
            ,inputuserid -- 登记人
            ,authorizetype -- 授权类型
            ,programenddate -- 方案到期日
            ,programname -- 方案名称
            ,remark -- 备注
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,isinuse -- 有效状态
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,orglevel -- 机构类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.programid -- 方案编号
    ,o.corporgid -- 法人机构编号
    ,o.programstartdate -- 方案起始日
    ,o.inputorgid -- 登记机构
    ,o.flows -- 流程
    ,o.groupid -- 方案组编号
    ,o.inputuserid -- 登记人
    ,o.authorizetype -- 授权类型
    ,o.programenddate -- 方案到期日
    ,o.programname -- 方案名称
    ,o.remark -- 备注
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.isinuse -- 有效状态
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.orglevel -- 机构类型
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
from ${iol_schema}.icms_auth_program_bk o
    left join ${iol_schema}.icms_auth_program_op n
        on
            o.programid = n.programid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_auth_program_cl d
        on
            o.programid = d.programid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_auth_program;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_auth_program') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_auth_program drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_auth_program add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_auth_program exchange partition p_${batch_date} with table ${iol_schema}.icms_auth_program_cl;
alter table ${iol_schema}.icms_auth_program exchange partition p_20991231 with table ${iol_schema}.icms_auth_program_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_auth_program to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_auth_program_op purge;
drop table ${iol_schema}.icms_auth_program_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_auth_program_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_auth_program',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
