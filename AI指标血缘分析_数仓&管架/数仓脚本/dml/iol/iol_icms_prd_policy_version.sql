/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_prd_policy_version
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
create table ${iol_schema}.icms_prd_policy_version_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_prd_policy_version
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_prd_policy_version_op purge;
drop table ${iol_schema}.icms_prd_policy_version_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_policy_version_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_prd_policy_version where 0=1;

create table ${iol_schema}.icms_prd_policy_version_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_prd_policy_version where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_prd_policy_version_cl(
            versionid -- 版本编号
            ,corporgid -- 法人机构编号
            ,inputorgid -- 登记机构
            ,startdate -- 开始执行日期
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,productid -- 产品编号
            ,effectivedate -- 生效日期
            ,expirydate -- 失效日期
            ,remark -- 备注
            ,versionname -- 版本名称
            ,inputdate -- 登记日期
            ,policyid -- 政策编号
            ,updateorgid -- 更新机构
            ,relacomponents -- 引入关联组件
            ,versionstatus -- 版本状态
            ,inputuserid -- 登记人
            ,basecomponents -- 引入基础组件
            ,versiondesc -- 版本说明
            ,title -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_prd_policy_version_op(
            versionid -- 版本编号
            ,corporgid -- 法人机构编号
            ,inputorgid -- 登记机构
            ,startdate -- 开始执行日期
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,productid -- 产品编号
            ,effectivedate -- 生效日期
            ,expirydate -- 失效日期
            ,remark -- 备注
            ,versionname -- 版本名称
            ,inputdate -- 登记日期
            ,policyid -- 政策编号
            ,updateorgid -- 更新机构
            ,relacomponents -- 引入关联组件
            ,versionstatus -- 版本状态
            ,inputuserid -- 登记人
            ,basecomponents -- 引入基础组件
            ,versiondesc -- 版本说明
            ,title -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.versionid, o.versionid) as versionid -- 版本编号
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.startdate, o.startdate) as startdate -- 开始执行日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.effectivedate, o.effectivedate) as effectivedate -- 生效日期
    ,nvl(n.expirydate, o.expirydate) as expirydate -- 失效日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.versionname, o.versionname) as versionname -- 版本名称
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.policyid, o.policyid) as policyid -- 政策编号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.relacomponents, o.relacomponents) as relacomponents -- 引入关联组件
    ,nvl(n.versionstatus, o.versionstatus) as versionstatus -- 版本状态
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.basecomponents, o.basecomponents) as basecomponents -- 引入基础组件
    ,nvl(n.versiondesc, o.versiondesc) as versiondesc -- 版本说明
    ,nvl(n.title, o.title) as title -- 
    ,case when
            n.versionid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.versionid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.versionid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_prd_policy_version_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_prd_policy_version where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.versionid = n.versionid
where (
        o.versionid is null
    )
    or (
        n.versionid is null
    )
    or (
        o.corporgid <> n.corporgid
        or o.inputorgid <> n.inputorgid
        or o.startdate <> n.startdate
        or o.updateuserid <> n.updateuserid
        or o.updatedate <> n.updatedate
        or o.productid <> n.productid
        or o.effectivedate <> n.effectivedate
        or o.expirydate <> n.expirydate
        or o.remark <> n.remark
        or o.versionname <> n.versionname
        or o.inputdate <> n.inputdate
        or o.policyid <> n.policyid
        or o.updateorgid <> n.updateorgid
        or o.relacomponents <> n.relacomponents
        or o.versionstatus <> n.versionstatus
        or o.inputuserid <> n.inputuserid
        or o.basecomponents <> n.basecomponents
        or o.versiondesc <> n.versiondesc
        or o.title <> n.title
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_prd_policy_version_cl(
            versionid -- 版本编号
            ,corporgid -- 法人机构编号
            ,inputorgid -- 登记机构
            ,startdate -- 开始执行日期
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,productid -- 产品编号
            ,effectivedate -- 生效日期
            ,expirydate -- 失效日期
            ,remark -- 备注
            ,versionname -- 版本名称
            ,inputdate -- 登记日期
            ,policyid -- 政策编号
            ,updateorgid -- 更新机构
            ,relacomponents -- 引入关联组件
            ,versionstatus -- 版本状态
            ,inputuserid -- 登记人
            ,basecomponents -- 引入基础组件
            ,versiondesc -- 版本说明
            ,title -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_prd_policy_version_op(
            versionid -- 版本编号
            ,corporgid -- 法人机构编号
            ,inputorgid -- 登记机构
            ,startdate -- 开始执行日期
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,productid -- 产品编号
            ,effectivedate -- 生效日期
            ,expirydate -- 失效日期
            ,remark -- 备注
            ,versionname -- 版本名称
            ,inputdate -- 登记日期
            ,policyid -- 政策编号
            ,updateorgid -- 更新机构
            ,relacomponents -- 引入关联组件
            ,versionstatus -- 版本状态
            ,inputuserid -- 登记人
            ,basecomponents -- 引入基础组件
            ,versiondesc -- 版本说明
            ,title -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.versionid -- 版本编号
    ,o.corporgid -- 法人机构编号
    ,o.inputorgid -- 登记机构
    ,o.startdate -- 开始执行日期
    ,o.updateuserid -- 更新人
    ,o.updatedate -- 更新日期
    ,o.productid -- 产品编号
    ,o.effectivedate -- 生效日期
    ,o.expirydate -- 失效日期
    ,o.remark -- 备注
    ,o.versionname -- 版本名称
    ,o.inputdate -- 登记日期
    ,o.policyid -- 政策编号
    ,o.updateorgid -- 更新机构
    ,o.relacomponents -- 引入关联组件
    ,o.versionstatus -- 版本状态
    ,o.inputuserid -- 登记人
    ,o.basecomponents -- 引入基础组件
    ,o.versiondesc -- 版本说明
    ,o.title -- 
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
from ${iol_schema}.icms_prd_policy_version_bk o
    left join ${iol_schema}.icms_prd_policy_version_op n
        on
            o.versionid = n.versionid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_prd_policy_version_cl d
        on
            o.versionid = d.versionid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_prd_policy_version;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_prd_policy_version') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_prd_policy_version drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_prd_policy_version add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_prd_policy_version exchange partition p_${batch_date} with table ${iol_schema}.icms_prd_policy_version_cl;
alter table ${iol_schema}.icms_prd_policy_version exchange partition p_20991231 with table ${iol_schema}.icms_prd_policy_version_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_prd_policy_version to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_prd_policy_version_op purge;
drop table ${iol_schema}.icms_prd_policy_version_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_prd_policy_version_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_prd_policy_version',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
