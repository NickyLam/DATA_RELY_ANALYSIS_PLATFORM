/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_catalog
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
create table ${iol_schema}.icms_clr_catalog_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_catalog
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_catalog_op purge;
drop table ${iol_schema}.icms_clr_catalog_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_catalog_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_catalog where 0=1;

create table ${iol_schema}.icms_clr_catalog_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_catalog where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_catalog_cl(
            clrtypeid -- 押品类型编号
            ,clrtypename -- 押品类型名称
            ,parentnodeid -- 父节点编号
            ,isleafnode -- 是否叶节点
            ,clrtablename -- 押品表名
            ,templetno -- 模板编号
            ,corefields -- 核心要素
            ,subfields -- 辅助要素
            ,clronlyscope -- 押品唯一性校验范围
            ,effectivedate -- 生效日期
            ,expirydate -- 失效日期
            ,status -- 状态
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,detailurl -- 详情页面url
            ,editurl -- 编辑页面url
            ,corporgid -- 法人机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_catalog_op(
            clrtypeid -- 押品类型编号
            ,clrtypename -- 押品类型名称
            ,parentnodeid -- 父节点编号
            ,isleafnode -- 是否叶节点
            ,clrtablename -- 押品表名
            ,templetno -- 模板编号
            ,corefields -- 核心要素
            ,subfields -- 辅助要素
            ,clronlyscope -- 押品唯一性校验范围
            ,effectivedate -- 生效日期
            ,expirydate -- 失效日期
            ,status -- 状态
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,detailurl -- 详情页面url
            ,editurl -- 编辑页面url
            ,corporgid -- 法人机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrtypeid, o.clrtypeid) as clrtypeid -- 押品类型编号
    ,nvl(n.clrtypename, o.clrtypename) as clrtypename -- 押品类型名称
    ,nvl(n.parentnodeid, o.parentnodeid) as parentnodeid -- 父节点编号
    ,nvl(n.isleafnode, o.isleafnode) as isleafnode -- 是否叶节点
    ,nvl(n.clrtablename, o.clrtablename) as clrtablename -- 押品表名
    ,nvl(n.templetno, o.templetno) as templetno -- 模板编号
    ,nvl(n.corefields, o.corefields) as corefields -- 核心要素
    ,nvl(n.subfields, o.subfields) as subfields -- 辅助要素
    ,nvl(n.clronlyscope, o.clronlyscope) as clronlyscope -- 押品唯一性校验范围
    ,nvl(n.effectivedate, o.effectivedate) as effectivedate -- 生效日期
    ,nvl(n.expirydate, o.expirydate) as expirydate -- 失效日期
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.detailurl, o.detailurl) as detailurl -- 详情页面url
    ,nvl(n.editurl, o.editurl) as editurl -- 编辑页面url
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,case when
            n.clrtypeid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.clrtypeid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.clrtypeid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_catalog_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_catalog where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrtypeid = n.clrtypeid
where (
        o.clrtypeid is null
    )
    or (
        n.clrtypeid is null
    )
    or (
        o.clrtypename <> n.clrtypename
        or o.parentnodeid <> n.parentnodeid
        or o.isleafnode <> n.isleafnode
        or o.clrtablename <> n.clrtablename
        or o.templetno <> n.templetno
        or o.corefields <> n.corefields
        or o.subfields <> n.subfields
        or o.clronlyscope <> n.clronlyscope
        or o.effectivedate <> n.effectivedate
        or o.expirydate <> n.expirydate
        or o.status <> n.status
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.updateuserid <> n.updateuserid
        or o.updatedate <> n.updatedate
        or o.remark <> n.remark
        or o.detailurl <> n.detailurl
        or o.editurl <> n.editurl
        or o.corporgid <> n.corporgid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_catalog_cl(
            clrtypeid -- 押品类型编号
            ,clrtypename -- 押品类型名称
            ,parentnodeid -- 父节点编号
            ,isleafnode -- 是否叶节点
            ,clrtablename -- 押品表名
            ,templetno -- 模板编号
            ,corefields -- 核心要素
            ,subfields -- 辅助要素
            ,clronlyscope -- 押品唯一性校验范围
            ,effectivedate -- 生效日期
            ,expirydate -- 失效日期
            ,status -- 状态
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,detailurl -- 详情页面url
            ,editurl -- 编辑页面url
            ,corporgid -- 法人机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_catalog_op(
            clrtypeid -- 押品类型编号
            ,clrtypename -- 押品类型名称
            ,parentnodeid -- 父节点编号
            ,isleafnode -- 是否叶节点
            ,clrtablename -- 押品表名
            ,templetno -- 模板编号
            ,corefields -- 核心要素
            ,subfields -- 辅助要素
            ,clronlyscope -- 押品唯一性校验范围
            ,effectivedate -- 生效日期
            ,expirydate -- 失效日期
            ,status -- 状态
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,detailurl -- 详情页面url
            ,editurl -- 编辑页面url
            ,corporgid -- 法人机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrtypeid -- 押品类型编号
    ,o.clrtypename -- 押品类型名称
    ,o.parentnodeid -- 父节点编号
    ,o.isleafnode -- 是否叶节点
    ,o.clrtablename -- 押品表名
    ,o.templetno -- 模板编号
    ,o.corefields -- 核心要素
    ,o.subfields -- 辅助要素
    ,o.clronlyscope -- 押品唯一性校验范围
    ,o.effectivedate -- 生效日期
    ,o.expirydate -- 失效日期
    ,o.status -- 状态
    ,o.inputorgid -- 登记机构
    ,o.inputuserid -- 登记人
    ,o.inputdate -- 登记日期
    ,o.updateorgid -- 更新机构
    ,o.updateuserid -- 更新人
    ,o.updatedate -- 更新日期
    ,o.remark -- 备注
    ,o.detailurl -- 详情页面url
    ,o.editurl -- 编辑页面url
    ,o.corporgid -- 法人机构编号
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
from ${iol_schema}.icms_clr_catalog_bk o
    left join ${iol_schema}.icms_clr_catalog_op n
        on
            o.clrtypeid = n.clrtypeid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_catalog_cl d
        on
            o.clrtypeid = d.clrtypeid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_catalog;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_catalog') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_catalog drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_catalog add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_catalog exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_catalog_cl;
alter table ${iol_schema}.icms_clr_catalog exchange partition p_20991231 with table ${iol_schema}.icms_clr_catalog_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_catalog to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_catalog_op purge;
drop table ${iol_schema}.icms_clr_catalog_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_catalog_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_catalog',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
