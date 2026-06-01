/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_objecttype_catalog
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
create table ${iol_schema}.icms_objecttype_catalog_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_objecttype_catalog
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_objecttype_catalog_op purge;
drop table ${iol_schema}.icms_objecttype_catalog_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_objecttype_catalog_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_objecttype_catalog where 0=1;

create table ${iol_schema}.icms_objecttype_catalog_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_objecttype_catalog where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_objecttype_catalog_cl(
            objecttype -- 对象类型号
            ,objecttable -- 主数据表
            ,inputorg -- 登记机构
            ,sortno -- 排序号
            ,objectattribute -- 属性集
            ,attribute3 -- 属性3
            ,inputdate -- 登记日期
            ,defaultview -- 默认视图
            ,righttype -- 权限方法
            ,treecode -- 对象树图
            ,usagedescribe -- 描述
            ,attribute2 -- 属性2
            ,updatetime -- 更新时间
            ,updatedate -- 更新日期
            ,catalogwhere1 -- where条件1
            ,catalogwhere2 -- where条件2
            ,inputorgid -- 登记机构编号
            ,inputuserid -- 登记人
            ,objectname -- 对象类型名称
            ,pagepath -- Web访问路径
            ,attribute1 -- 属性1
            ,inputtime -- 登记时间
            ,catalogwhere3 -- where条件3
            ,updateorgid -- 更新机构
            ,viewtype -- 视图组
            ,catalogsql -- sql语句
            ,keycolname -- 关键字段名称
            ,relativetable -- 关联数据表
            ,keycol -- 关键字段
            ,inputuser -- 登记人员
            ,remark -- 备注
            ,objectcolattribute -- 对象列属性
            ,updateuserid -- 更新人
            ,updateuser -- 更新人员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_objecttype_catalog_op(
            objecttype -- 对象类型号
            ,objecttable -- 主数据表
            ,inputorg -- 登记机构
            ,sortno -- 排序号
            ,objectattribute -- 属性集
            ,attribute3 -- 属性3
            ,inputdate -- 登记日期
            ,defaultview -- 默认视图
            ,righttype -- 权限方法
            ,treecode -- 对象树图
            ,usagedescribe -- 描述
            ,attribute2 -- 属性2
            ,updatetime -- 更新时间
            ,updatedate -- 更新日期
            ,catalogwhere1 -- where条件1
            ,catalogwhere2 -- where条件2
            ,inputorgid -- 登记机构编号
            ,inputuserid -- 登记人
            ,objectname -- 对象类型名称
            ,pagepath -- Web访问路径
            ,attribute1 -- 属性1
            ,inputtime -- 登记时间
            ,catalogwhere3 -- where条件3
            ,updateorgid -- 更新机构
            ,viewtype -- 视图组
            ,catalogsql -- sql语句
            ,keycolname -- 关键字段名称
            ,relativetable -- 关联数据表
            ,keycol -- 关键字段
            ,inputuser -- 登记人员
            ,remark -- 备注
            ,objectcolattribute -- 对象列属性
            ,updateuserid -- 更新人
            ,updateuser -- 更新人员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型号
    ,nvl(n.objecttable, o.objecttable) as objecttable -- 主数据表
    ,nvl(n.inputorg, o.inputorg) as inputorg -- 登记机构
    ,nvl(n.sortno, o.sortno) as sortno -- 排序号
    ,nvl(n.objectattribute, o.objectattribute) as objectattribute -- 属性集
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 属性3
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.defaultview, o.defaultview) as defaultview -- 默认视图
    ,nvl(n.righttype, o.righttype) as righttype -- 权限方法
    ,nvl(n.treecode, o.treecode) as treecode -- 对象树图
    ,nvl(n.usagedescribe, o.usagedescribe) as usagedescribe -- 描述
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 属性2
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.catalogwhere1, o.catalogwhere1) as catalogwhere1 -- where条件1
    ,nvl(n.catalogwhere2, o.catalogwhere2) as catalogwhere2 -- where条件2
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构编号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.objectname, o.objectname) as objectname -- 对象类型名称
    ,nvl(n.pagepath, o.pagepath) as pagepath -- Web访问路径
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 属性1
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记时间
    ,nvl(n.catalogwhere3, o.catalogwhere3) as catalogwhere3 -- where条件3
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.viewtype, o.viewtype) as viewtype -- 视图组
    ,nvl(n.catalogsql, o.catalogsql) as catalogsql -- sql语句
    ,nvl(n.keycolname, o.keycolname) as keycolname -- 关键字段名称
    ,nvl(n.relativetable, o.relativetable) as relativetable -- 关联数据表
    ,nvl(n.keycol, o.keycol) as keycol -- 关键字段
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 登记人员
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.objectcolattribute, o.objectcolattribute) as objectcolattribute -- 对象列属性
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateuser, o.updateuser) as updateuser -- 更新人员
    ,case when
            n.objecttype is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.objecttype is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.objecttype is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_objecttype_catalog_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_objecttype_catalog where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.objecttype = n.objecttype
where (
        o.objecttype is null
    )
    or (
        n.objecttype is null
    )
    or (
        o.objecttable <> n.objecttable
        or o.inputorg <> n.inputorg
        or o.sortno <> n.sortno
        or o.objectattribute <> n.objectattribute
        or o.attribute3 <> n.attribute3
        or o.inputdate <> n.inputdate
        or o.defaultview <> n.defaultview
        or o.righttype <> n.righttype
        or o.treecode <> n.treecode
        or o.usagedescribe <> n.usagedescribe
        or o.attribute2 <> n.attribute2
        or o.updatetime <> n.updatetime
        or o.updatedate <> n.updatedate
        or o.catalogwhere1 <> n.catalogwhere1
        or o.catalogwhere2 <> n.catalogwhere2
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.objectname <> n.objectname
        or o.pagepath <> n.pagepath
        or o.attribute1 <> n.attribute1
        or o.inputtime <> n.inputtime
        or o.catalogwhere3 <> n.catalogwhere3
        or o.updateorgid <> n.updateorgid
        or o.viewtype <> n.viewtype
        or o.catalogsql <> n.catalogsql
        or o.keycolname <> n.keycolname
        or o.relativetable <> n.relativetable
        or o.keycol <> n.keycol
        or o.inputuser <> n.inputuser
        or o.remark <> n.remark
        or o.objectcolattribute <> n.objectcolattribute
        or o.updateuserid <> n.updateuserid
        or o.updateuser <> n.updateuser
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_objecttype_catalog_cl(
            objecttype -- 对象类型号
            ,objecttable -- 主数据表
            ,inputorg -- 登记机构
            ,sortno -- 排序号
            ,objectattribute -- 属性集
            ,attribute3 -- 属性3
            ,inputdate -- 登记日期
            ,defaultview -- 默认视图
            ,righttype -- 权限方法
            ,treecode -- 对象树图
            ,usagedescribe -- 描述
            ,attribute2 -- 属性2
            ,updatetime -- 更新时间
            ,updatedate -- 更新日期
            ,catalogwhere1 -- where条件1
            ,catalogwhere2 -- where条件2
            ,inputorgid -- 登记机构编号
            ,inputuserid -- 登记人
            ,objectname -- 对象类型名称
            ,pagepath -- Web访问路径
            ,attribute1 -- 属性1
            ,inputtime -- 登记时间
            ,catalogwhere3 -- where条件3
            ,updateorgid -- 更新机构
            ,viewtype -- 视图组
            ,catalogsql -- sql语句
            ,keycolname -- 关键字段名称
            ,relativetable -- 关联数据表
            ,keycol -- 关键字段
            ,inputuser -- 登记人员
            ,remark -- 备注
            ,objectcolattribute -- 对象列属性
            ,updateuserid -- 更新人
            ,updateuser -- 更新人员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_objecttype_catalog_op(
            objecttype -- 对象类型号
            ,objecttable -- 主数据表
            ,inputorg -- 登记机构
            ,sortno -- 排序号
            ,objectattribute -- 属性集
            ,attribute3 -- 属性3
            ,inputdate -- 登记日期
            ,defaultview -- 默认视图
            ,righttype -- 权限方法
            ,treecode -- 对象树图
            ,usagedescribe -- 描述
            ,attribute2 -- 属性2
            ,updatetime -- 更新时间
            ,updatedate -- 更新日期
            ,catalogwhere1 -- where条件1
            ,catalogwhere2 -- where条件2
            ,inputorgid -- 登记机构编号
            ,inputuserid -- 登记人
            ,objectname -- 对象类型名称
            ,pagepath -- Web访问路径
            ,attribute1 -- 属性1
            ,inputtime -- 登记时间
            ,catalogwhere3 -- where条件3
            ,updateorgid -- 更新机构
            ,viewtype -- 视图组
            ,catalogsql -- sql语句
            ,keycolname -- 关键字段名称
            ,relativetable -- 关联数据表
            ,keycol -- 关键字段
            ,inputuser -- 登记人员
            ,remark -- 备注
            ,objectcolattribute -- 对象列属性
            ,updateuserid -- 更新人
            ,updateuser -- 更新人员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.objecttype -- 对象类型号
    ,o.objecttable -- 主数据表
    ,o.inputorg -- 登记机构
    ,o.sortno -- 排序号
    ,o.objectattribute -- 属性集
    ,o.attribute3 -- 属性3
    ,o.inputdate -- 登记日期
    ,o.defaultview -- 默认视图
    ,o.righttype -- 权限方法
    ,o.treecode -- 对象树图
    ,o.usagedescribe -- 描述
    ,o.attribute2 -- 属性2
    ,o.updatetime -- 更新时间
    ,o.updatedate -- 更新日期
    ,o.catalogwhere1 -- where条件1
    ,o.catalogwhere2 -- where条件2
    ,o.inputorgid -- 登记机构编号
    ,o.inputuserid -- 登记人
    ,o.objectname -- 对象类型名称
    ,o.pagepath -- Web访问路径
    ,o.attribute1 -- 属性1
    ,o.inputtime -- 登记时间
    ,o.catalogwhere3 -- where条件3
    ,o.updateorgid -- 更新机构
    ,o.viewtype -- 视图组
    ,o.catalogsql -- sql语句
    ,o.keycolname -- 关键字段名称
    ,o.relativetable -- 关联数据表
    ,o.keycol -- 关键字段
    ,o.inputuser -- 登记人员
    ,o.remark -- 备注
    ,o.objectcolattribute -- 对象列属性
    ,o.updateuserid -- 更新人
    ,o.updateuser -- 更新人员
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
from ${iol_schema}.icms_objecttype_catalog_bk o
    left join ${iol_schema}.icms_objecttype_catalog_op n
        on
            o.objecttype = n.objecttype
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_objecttype_catalog_cl d
        on
            o.objecttype = d.objecttype
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_objecttype_catalog;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_objecttype_catalog') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_objecttype_catalog drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_objecttype_catalog add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_objecttype_catalog exchange partition p_${batch_date} with table ${iol_schema}.icms_objecttype_catalog_cl;
alter table ${iol_schema}.icms_objecttype_catalog exchange partition p_20991231 with table ${iol_schema}.icms_objecttype_catalog_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_objecttype_catalog to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_objecttype_catalog_op purge;
drop table ${iol_schema}.icms_objecttype_catalog_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_objecttype_catalog_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_objecttype_catalog',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
