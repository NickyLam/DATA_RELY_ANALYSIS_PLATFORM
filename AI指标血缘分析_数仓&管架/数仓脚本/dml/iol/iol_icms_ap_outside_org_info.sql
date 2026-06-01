/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_outside_org_info
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
create table ${iol_schema}.icms_ap_outside_org_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_outside_org_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_outside_org_info_op purge;
drop table ${iol_schema}.icms_ap_outside_org_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_outside_org_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_outside_org_info where 0=1;

create table ${iol_schema}.icms_ap_outside_org_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_outside_org_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_outside_org_info_cl(
            outsideorgno -- 机构编号
            ,certtype -- 证件类型
            ,inputorgid -- 录入机构编号
            ,description -- 机构简介
            ,deleteflag -- 删除标识
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,outsideorgtype -- 机构类型
            ,outsideorgname -- 机构名称
            ,isuse -- 使用状态
            ,orgcorptype -- 组织机构证件类型
            ,inputuserid -- 录入人编号
            ,orgcorpid -- 组织机构代码证号
            ,address -- 地址
            ,inputdate -- 录入日期
            ,updateorgid -- 更新机构
            ,certid -- 证件编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_outside_org_info_op(
            outsideorgno -- 机构编号
            ,certtype -- 证件类型
            ,inputorgid -- 录入机构编号
            ,description -- 机构简介
            ,deleteflag -- 删除标识
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,outsideorgtype -- 机构类型
            ,outsideorgname -- 机构名称
            ,isuse -- 使用状态
            ,orgcorptype -- 组织机构证件类型
            ,inputuserid -- 录入人编号
            ,orgcorpid -- 组织机构代码证号
            ,address -- 地址
            ,inputdate -- 录入日期
            ,updateorgid -- 更新机构
            ,certid -- 证件编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.outsideorgno, o.outsideorgno) as outsideorgno -- 机构编号
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 录入机构编号
    ,nvl(n.description, o.description) as description -- 机构简介
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标识
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.outsideorgtype, o.outsideorgtype) as outsideorgtype -- 机构类型
    ,nvl(n.outsideorgname, o.outsideorgname) as outsideorgname -- 机构名称
    ,nvl(n.isuse, o.isuse) as isuse -- 使用状态
    ,nvl(n.orgcorptype, o.orgcorptype) as orgcorptype -- 组织机构证件类型
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 录入人编号
    ,nvl(n.orgcorpid, o.orgcorpid) as orgcorpid -- 组织机构代码证号
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 录入日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.certid, o.certid) as certid -- 证件编号
    ,case when
            n.outsideorgno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.outsideorgno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.outsideorgno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_outside_org_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_outside_org_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.outsideorgno = n.outsideorgno
where (
        o.outsideorgno is null
    )
    or (
        n.outsideorgno is null
    )
    or (
        o.certtype <> n.certtype
        or o.inputorgid <> n.inputorgid
        or o.description <> n.description
        or o.deleteflag <> n.deleteflag
        or o.updatedate <> n.updatedate
        or o.updateuserid <> n.updateuserid
        or o.outsideorgtype <> n.outsideorgtype
        or o.outsideorgname <> n.outsideorgname
        or o.isuse <> n.isuse
        or o.orgcorptype <> n.orgcorptype
        or o.inputuserid <> n.inputuserid
        or o.orgcorpid <> n.orgcorpid
        or o.address <> n.address
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.certid <> n.certid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_outside_org_info_cl(
            outsideorgno -- 机构编号
            ,certtype -- 证件类型
            ,inputorgid -- 录入机构编号
            ,description -- 机构简介
            ,deleteflag -- 删除标识
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,outsideorgtype -- 机构类型
            ,outsideorgname -- 机构名称
            ,isuse -- 使用状态
            ,orgcorptype -- 组织机构证件类型
            ,inputuserid -- 录入人编号
            ,orgcorpid -- 组织机构代码证号
            ,address -- 地址
            ,inputdate -- 录入日期
            ,updateorgid -- 更新机构
            ,certid -- 证件编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_outside_org_info_op(
            outsideorgno -- 机构编号
            ,certtype -- 证件类型
            ,inputorgid -- 录入机构编号
            ,description -- 机构简介
            ,deleteflag -- 删除标识
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,outsideorgtype -- 机构类型
            ,outsideorgname -- 机构名称
            ,isuse -- 使用状态
            ,orgcorptype -- 组织机构证件类型
            ,inputuserid -- 录入人编号
            ,orgcorpid -- 组织机构代码证号
            ,address -- 地址
            ,inputdate -- 录入日期
            ,updateorgid -- 更新机构
            ,certid -- 证件编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.outsideorgno -- 机构编号
    ,o.certtype -- 证件类型
    ,o.inputorgid -- 录入机构编号
    ,o.description -- 机构简介
    ,o.deleteflag -- 删除标识
    ,o.updatedate -- 更新日期
    ,o.updateuserid -- 更新人
    ,o.outsideorgtype -- 机构类型
    ,o.outsideorgname -- 机构名称
    ,o.isuse -- 使用状态
    ,o.orgcorptype -- 组织机构证件类型
    ,o.inputuserid -- 录入人编号
    ,o.orgcorpid -- 组织机构代码证号
    ,o.address -- 地址
    ,o.inputdate -- 录入日期
    ,o.updateorgid -- 更新机构
    ,o.certid -- 证件编号
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
from ${iol_schema}.icms_ap_outside_org_info_bk o
    left join ${iol_schema}.icms_ap_outside_org_info_op n
        on
            o.outsideorgno = n.outsideorgno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_outside_org_info_cl d
        on
            o.outsideorgno = d.outsideorgno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_outside_org_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_outside_org_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_outside_org_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_outside_org_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_outside_org_info exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_outside_org_info_cl;
alter table ${iol_schema}.icms_ap_outside_org_info exchange partition p_20991231 with table ${iol_schema}.icms_ap_outside_org_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_outside_org_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_outside_org_info_op purge;
drop table ${iol_schema}.icms_ap_outside_org_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_outside_org_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_outside_org_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
