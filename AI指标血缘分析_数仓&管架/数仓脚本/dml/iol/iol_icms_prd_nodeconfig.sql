/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_prd_nodeconfig
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
create table ${iol_schema}.icms_prd_nodeconfig_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_prd_nodeconfig
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_prd_nodeconfig_op purge;
drop table ${iol_schema}.icms_prd_nodeconfig_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_nodeconfig_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_prd_nodeconfig where 0=1;

create table ${iol_schema}.icms_prd_nodeconfig_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_prd_nodeconfig where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_prd_nodeconfig_cl(
            productid -- 项目编号
            ,nodeid -- 节点编号
            ,inputdate -- 登记日期
            ,sortno -- 排序后
            ,putoutphase -- 放款阶段
            ,inputuserid -- 登记人
            ,fac5 -- FAC5
            ,approvephase -- 批复阶段
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,inputorgid -- 登记机构
            ,nodename -- 节点名称
            ,contractphase -- 合同阶段
            ,corporgid -- 法人机构编号
            ,applyphase -- 申请阶段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_prd_nodeconfig_op(
            productid -- 项目编号
            ,nodeid -- 节点编号
            ,inputdate -- 登记日期
            ,sortno -- 排序后
            ,putoutphase -- 放款阶段
            ,inputuserid -- 登记人
            ,fac5 -- FAC5
            ,approvephase -- 批复阶段
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,inputorgid -- 登记机构
            ,nodename -- 节点名称
            ,contractphase -- 合同阶段
            ,corporgid -- 法人机构编号
            ,applyphase -- 申请阶段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.productid, o.productid) as productid -- 项目编号
    ,nvl(n.nodeid, o.nodeid) as nodeid -- 节点编号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.sortno, o.sortno) as sortno -- 排序后
    ,nvl(n.putoutphase, o.putoutphase) as putoutphase -- 放款阶段
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.fac5, o.fac5) as fac5 -- FAC5
    ,nvl(n.approvephase, o.approvephase) as approvephase -- 批复阶段
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.nodename, o.nodename) as nodename -- 节点名称
    ,nvl(n.contractphase, o.contractphase) as contractphase -- 合同阶段
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.applyphase, o.applyphase) as applyphase -- 申请阶段
    ,case when
            n.productid is null
            and n.nodeid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.productid is null
            and n.nodeid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.productid is null
            and n.nodeid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_prd_nodeconfig_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_prd_nodeconfig where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.productid = n.productid
            and o.nodeid = n.nodeid
where (
        o.productid is null
        and o.nodeid is null
    )
    or (
        n.productid is null
        and n.nodeid is null
    )
    or (
        o.inputdate <> n.inputdate
        or o.sortno <> n.sortno
        or o.putoutphase <> n.putoutphase
        or o.inputuserid <> n.inputuserid
        or o.fac5 <> n.fac5
        or o.approvephase <> n.approvephase
        or o.updateorgid <> n.updateorgid
        or o.updateuserid <> n.updateuserid
        or o.updatedate <> n.updatedate
        or o.inputorgid <> n.inputorgid
        or o.nodename <> n.nodename
        or o.contractphase <> n.contractphase
        or o.corporgid <> n.corporgid
        or o.applyphase <> n.applyphase
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_prd_nodeconfig_cl(
            productid -- 项目编号
            ,nodeid -- 节点编号
            ,inputdate -- 登记日期
            ,sortno -- 排序后
            ,putoutphase -- 放款阶段
            ,inputuserid -- 登记人
            ,fac5 -- FAC5
            ,approvephase -- 批复阶段
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,inputorgid -- 登记机构
            ,nodename -- 节点名称
            ,contractphase -- 合同阶段
            ,corporgid -- 法人机构编号
            ,applyphase -- 申请阶段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_prd_nodeconfig_op(
            productid -- 项目编号
            ,nodeid -- 节点编号
            ,inputdate -- 登记日期
            ,sortno -- 排序后
            ,putoutphase -- 放款阶段
            ,inputuserid -- 登记人
            ,fac5 -- FAC5
            ,approvephase -- 批复阶段
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,inputorgid -- 登记机构
            ,nodename -- 节点名称
            ,contractphase -- 合同阶段
            ,corporgid -- 法人机构编号
            ,applyphase -- 申请阶段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.productid -- 项目编号
    ,o.nodeid -- 节点编号
    ,o.inputdate -- 登记日期
    ,o.sortno -- 排序后
    ,o.putoutphase -- 放款阶段
    ,o.inputuserid -- 登记人
    ,o.fac5 -- FAC5
    ,o.approvephase -- 批复阶段
    ,o.updateorgid -- 更新机构
    ,o.updateuserid -- 更新人
    ,o.updatedate -- 更新日期
    ,o.inputorgid -- 登记机构
    ,o.nodename -- 节点名称
    ,o.contractphase -- 合同阶段
    ,o.corporgid -- 法人机构编号
    ,o.applyphase -- 申请阶段
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
from ${iol_schema}.icms_prd_nodeconfig_bk o
    left join ${iol_schema}.icms_prd_nodeconfig_op n
        on
            o.productid = n.productid
            and o.nodeid = n.nodeid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_prd_nodeconfig_cl d
        on
            o.productid = d.productid
            and o.nodeid = d.nodeid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_prd_nodeconfig;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_prd_nodeconfig') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_prd_nodeconfig drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_prd_nodeconfig add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_prd_nodeconfig exchange partition p_${batch_date} with table ${iol_schema}.icms_prd_nodeconfig_cl;
alter table ${iol_schema}.icms_prd_nodeconfig exchange partition p_20991231 with table ${iol_schema}.icms_prd_nodeconfig_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_prd_nodeconfig to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_prd_nodeconfig_op purge;
drop table ${iol_schema}.icms_prd_nodeconfig_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_prd_nodeconfig_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_prd_nodeconfig',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
