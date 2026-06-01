/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ind_imasset
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
create table ${iol_schema}.icms_ind_imasset_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ind_imasset
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_imasset_op purge;
drop table ${iol_schema}.icms_ind_imasset_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_imasset_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_imasset where 0=1;

create table ${iol_schema}.icms_ind_imasset_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_imasset where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_imasset_cl(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,authdate -- 认证时间
            ,assetdescribe -- 资产阐述
            ,authorg -- 认证机构
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,assetname -- 资产名称
            ,updateorgid -- 更新机构
            ,uptodate -- 统计截止日期
            ,updateuserid -- 更新人
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,assettype -- 资产类型资产类型(（代码：1-专利权2-商标权3-著作权4-其他）
            ,evaluatevalue -- 评估价值
            ,corporgid -- 法人机构编号
            ,certid -- 证书编号
            ,inputuserid -- 登记人
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_imasset_op(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,authdate -- 认证时间
            ,assetdescribe -- 资产阐述
            ,authorg -- 认证机构
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,assetname -- 资产名称
            ,updateorgid -- 更新机构
            ,uptodate -- 统计截止日期
            ,updateuserid -- 更新人
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,assettype -- 资产类型资产类型(（代码：1-专利权2-商标权3-著作权4-其他）
            ,evaluatevalue -- 评估价值
            ,corporgid -- 法人机构编号
            ,certid -- 证书编号
            ,inputuserid -- 登记人
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.authdate, o.authdate) as authdate -- 认证时间
    ,nvl(n.assetdescribe, o.assetdescribe) as assetdescribe -- 资产阐述
    ,nvl(n.authorg, o.authorg) as authorg -- 认证机构
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.assetname, o.assetname) as assetname -- 资产名称
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.uptodate, o.uptodate) as uptodate -- 统计截止日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.assettype, o.assettype) as assettype -- 资产类型资产类型(（代码：1-专利权2-商标权3-著作权4-其他）
    ,nvl(n.evaluatevalue, o.evaluatevalue) as evaluatevalue -- 评估价值
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.certid, o.certid) as certid -- 证书编号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ind_imasset_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ind_imasset where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.customerid <> n.customerid
        or o.authdate <> n.authdate
        or o.assetdescribe <> n.assetdescribe
        or o.authorg <> n.authorg
        or o.remark <> n.remark
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.assetname <> n.assetname
        or o.updateorgid <> n.updateorgid
        or o.uptodate <> n.uptodate
        or o.updateuserid <> n.updateuserid
        or o.migtflag <> n.migtflag
        or o.assettype <> n.assettype
        or o.evaluatevalue <> n.evaluatevalue
        or o.corporgid <> n.corporgid
        or o.certid <> n.certid
        or o.inputuserid <> n.inputuserid
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_imasset_cl(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,authdate -- 认证时间
            ,assetdescribe -- 资产阐述
            ,authorg -- 认证机构
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,assetname -- 资产名称
            ,updateorgid -- 更新机构
            ,uptodate -- 统计截止日期
            ,updateuserid -- 更新人
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,assettype -- 资产类型资产类型(（代码：1-专利权2-商标权3-著作权4-其他）
            ,evaluatevalue -- 评估价值
            ,corporgid -- 法人机构编号
            ,certid -- 证书编号
            ,inputuserid -- 登记人
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_imasset_op(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,authdate -- 认证时间
            ,assetdescribe -- 资产阐述
            ,authorg -- 认证机构
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,assetname -- 资产名称
            ,updateorgid -- 更新机构
            ,uptodate -- 统计截止日期
            ,updateuserid -- 更新人
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,assettype -- 资产类型资产类型(（代码：1-专利权2-商标权3-著作权4-其他）
            ,evaluatevalue -- 评估价值
            ,corporgid -- 法人机构编号
            ,certid -- 证书编号
            ,inputuserid -- 登记人
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.customerid -- 客户编号
    ,o.authdate -- 认证时间
    ,o.assetdescribe -- 资产阐述
    ,o.authorg -- 认证机构
    ,o.remark -- 备注
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记时间
    ,o.assetname -- 资产名称
    ,o.updateorgid -- 更新机构
    ,o.uptodate -- 统计截止日期
    ,o.updateuserid -- 更新人
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.assettype -- 资产类型资产类型(（代码：1-专利权2-商标权3-著作权4-其他）
    ,o.evaluatevalue -- 评估价值
    ,o.corporgid -- 法人机构编号
    ,o.certid -- 证书编号
    ,o.inputuserid -- 登记人
    ,o.updatedate -- 更新时间
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
from ${iol_schema}.icms_ind_imasset_bk o
    left join ${iol_schema}.icms_ind_imasset_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ind_imasset_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ind_imasset;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ind_imasset') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ind_imasset drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ind_imasset add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ind_imasset exchange partition p_${batch_date} with table ${iol_schema}.icms_ind_imasset_cl;
alter table ${iol_schema}.icms_ind_imasset exchange partition p_20991231 with table ${iol_schema}.icms_ind_imasset_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ind_imasset to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_imasset_op purge;
drop table ${iol_schema}.icms_ind_imasset_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ind_imasset_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ind_imasset',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
