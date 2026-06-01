/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_prd_nodeinfo
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
create table ${iol_schema}.icms_prd_nodeinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_prd_nodeinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_prd_nodeinfo_op purge;
drop table ${iol_schema}.icms_prd_nodeinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_nodeinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_prd_nodeinfo where 0=1;

create table ${iol_schema}.icms_prd_nodeinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_prd_nodeinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_prd_nodeinfo_cl(
            nodeid -- 节点编号
            ,updateorgid -- 更新机构
            ,inputdate -- 登记日期
            ,nodename -- 节点名称
            ,sortno -- 序列号
            ,contracturl -- 合同阶段路径
            ,isinuse -- 是否使用
            ,corporgid -- 法人机构编号
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,itemdescribe -- 节点描述
            ,approveurl -- 批复阶段路径
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_prd_nodeinfo_op(
            nodeid -- 节点编号
            ,updateorgid -- 更新机构
            ,inputdate -- 登记日期
            ,nodename -- 节点名称
            ,sortno -- 序列号
            ,contracturl -- 合同阶段路径
            ,isinuse -- 是否使用
            ,corporgid -- 法人机构编号
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,itemdescribe -- 节点描述
            ,approveurl -- 批复阶段路径
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.nodeid, o.nodeid) as nodeid -- 节点编号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.nodename, o.nodename) as nodename -- 节点名称
    ,nvl(n.sortno, o.sortno) as sortno -- 序列号
    ,nvl(n.contracturl, o.contracturl) as contracturl -- 合同阶段路径
    ,nvl(n.isinuse, o.isinuse) as isinuse -- 是否使用
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.itemdescribe, o.itemdescribe) as itemdescribe -- 节点描述
    ,nvl(n.approveurl, o.approveurl) as approveurl -- 批复阶段路径
    ,case when
            n.nodeid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.nodeid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.nodeid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_prd_nodeinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_prd_nodeinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.nodeid = n.nodeid
where (
        o.nodeid is null
    )
    or (
        n.nodeid is null
    )
    or (
        o.updateorgid <> n.updateorgid
        or o.inputdate <> n.inputdate
        or o.nodename <> n.nodename
        or o.sortno <> n.sortno
        or o.contracturl <> n.contracturl
        or o.isinuse <> n.isinuse
        or o.corporgid <> n.corporgid
        or o.remark <> n.remark
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.updatedate <> n.updatedate
        or o.updateuserid <> n.updateuserid
        or o.itemdescribe <> n.itemdescribe
        or o.approveurl <> n.approveurl
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_prd_nodeinfo_cl(
            nodeid -- 节点编号
            ,updateorgid -- 更新机构
            ,inputdate -- 登记日期
            ,nodename -- 节点名称
            ,sortno -- 序列号
            ,contracturl -- 合同阶段路径
            ,isinuse -- 是否使用
            ,corporgid -- 法人机构编号
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,itemdescribe -- 节点描述
            ,approveurl -- 批复阶段路径
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_prd_nodeinfo_op(
            nodeid -- 节点编号
            ,updateorgid -- 更新机构
            ,inputdate -- 登记日期
            ,nodename -- 节点名称
            ,sortno -- 序列号
            ,contracturl -- 合同阶段路径
            ,isinuse -- 是否使用
            ,corporgid -- 法人机构编号
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,itemdescribe -- 节点描述
            ,approveurl -- 批复阶段路径
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.nodeid -- 节点编号
    ,o.updateorgid -- 更新机构
    ,o.inputdate -- 登记日期
    ,o.nodename -- 节点名称
    ,o.sortno -- 序列号
    ,o.contracturl -- 合同阶段路径
    ,o.isinuse -- 是否使用
    ,o.corporgid -- 法人机构编号
    ,o.remark -- 备注
    ,o.inputorgid -- 登记机构
    ,o.inputuserid -- 登记人
    ,o.updatedate -- 更新日期
    ,o.updateuserid -- 更新人
    ,o.itemdescribe -- 节点描述
    ,o.approveurl -- 批复阶段路径
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
from ${iol_schema}.icms_prd_nodeinfo_bk o
    left join ${iol_schema}.icms_prd_nodeinfo_op n
        on
            o.nodeid = n.nodeid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_prd_nodeinfo_cl d
        on
            o.nodeid = d.nodeid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_prd_nodeinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_prd_nodeinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_prd_nodeinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_prd_nodeinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_prd_nodeinfo exchange partition p_${batch_date} with table ${iol_schema}.icms_prd_nodeinfo_cl;
alter table ${iol_schema}.icms_prd_nodeinfo exchange partition p_20991231 with table ${iol_schema}.icms_prd_nodeinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_prd_nodeinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_prd_nodeinfo_op purge;
drop table ${iol_schema}.icms_prd_nodeinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_prd_nodeinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_prd_nodeinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
