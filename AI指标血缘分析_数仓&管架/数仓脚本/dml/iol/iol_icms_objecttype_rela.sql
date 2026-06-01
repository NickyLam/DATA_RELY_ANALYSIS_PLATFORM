/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_objecttype_rela
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
create table ${iol_schema}.icms_objecttype_rela_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_objecttype_rela
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_objecttype_rela_op purge;
drop table ${iol_schema}.icms_objecttype_rela_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_objecttype_rela_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_objecttype_rela where 0=1;

create table ${iol_schema}.icms_objecttype_rela_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_objecttype_rela where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_objecttype_rela_cl(
            objecttype -- 对象类型号
            ,relationship -- 关联关系
            ,displayname -- 显示名称
            ,updateuserid -- 更新人编号
            ,updateuser -- 更新人
            ,isinuse -- 是否可用
            ,attribute2 -- 属性2
            ,updatetime -- 更新时间
            ,relaexpr -- 关系表述
            ,inputuserid -- 登记人编号
            ,updatedate -- 更新日期
            ,viewexpr -- 视图表述
            ,attribute3 -- 属性3
            ,remark -- 备注
            ,inputdate -- 登记日期
            ,inputorg -- 登记机构
            ,sortno -- 排序号
            ,updateorgid -- 更新机构
            ,inputtime -- 登记时间
            ,attribute1 -- 属性1
            ,relaobjecttype -- 关联对象类型
            ,showontabexpr -- 模板表述
            ,inputuser -- 登记人
            ,inputorgid -- 登记机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_objecttype_rela_op(
            objecttype -- 对象类型号
            ,relationship -- 关联关系
            ,displayname -- 显示名称
            ,updateuserid -- 更新人编号
            ,updateuser -- 更新人
            ,isinuse -- 是否可用
            ,attribute2 -- 属性2
            ,updatetime -- 更新时间
            ,relaexpr -- 关系表述
            ,inputuserid -- 登记人编号
            ,updatedate -- 更新日期
            ,viewexpr -- 视图表述
            ,attribute3 -- 属性3
            ,remark -- 备注
            ,inputdate -- 登记日期
            ,inputorg -- 登记机构
            ,sortno -- 排序号
            ,updateorgid -- 更新机构
            ,inputtime -- 登记时间
            ,attribute1 -- 属性1
            ,relaobjecttype -- 关联对象类型
            ,showontabexpr -- 模板表述
            ,inputuser -- 登记人
            ,inputorgid -- 登记机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型号
    ,nvl(n.relationship, o.relationship) as relationship -- 关联关系
    ,nvl(n.displayname, o.displayname) as displayname -- 显示名称
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.updateuser, o.updateuser) as updateuser -- 更新人
    ,nvl(n.isinuse, o.isinuse) as isinuse -- 是否可用
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 属性2
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.relaexpr, o.relaexpr) as relaexpr -- 关系表述
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人编号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.viewexpr, o.viewexpr) as viewexpr -- 视图表述
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 属性3
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.inputorg, o.inputorg) as inputorg -- 登记机构
    ,nvl(n.sortno, o.sortno) as sortno -- 排序号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记时间
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 属性1
    ,nvl(n.relaobjecttype, o.relaobjecttype) as relaobjecttype -- 关联对象类型
    ,nvl(n.showontabexpr, o.showontabexpr) as showontabexpr -- 模板表述
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构编号
    ,case when
            n.objecttype is null
            and n.relationship is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.objecttype is null
            and n.relationship is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.objecttype is null
            and n.relationship is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_objecttype_rela_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_objecttype_rela where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.objecttype = n.objecttype
            and o.relationship = n.relationship
where (
        o.objecttype is null
        and o.relationship is null
    )
    or (
        n.objecttype is null
        and n.relationship is null
    )
    or (
        o.displayname <> n.displayname
        or o.updateuserid <> n.updateuserid
        or o.updateuser <> n.updateuser
        or o.isinuse <> n.isinuse
        or o.attribute2 <> n.attribute2
        or o.updatetime <> n.updatetime
        or o.relaexpr <> n.relaexpr
        or o.inputuserid <> n.inputuserid
        or o.updatedate <> n.updatedate
        or o.viewexpr <> n.viewexpr
        or o.attribute3 <> n.attribute3
        or o.remark <> n.remark
        or o.inputdate <> n.inputdate
        or o.inputorg <> n.inputorg
        or o.sortno <> n.sortno
        or o.updateorgid <> n.updateorgid
        or o.inputtime <> n.inputtime
        or o.attribute1 <> n.attribute1
        or o.relaobjecttype <> n.relaobjecttype
        or o.showontabexpr <> n.showontabexpr
        or o.inputuser <> n.inputuser
        or o.inputorgid <> n.inputorgid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_objecttype_rela_cl(
            objecttype -- 对象类型号
            ,relationship -- 关联关系
            ,displayname -- 显示名称
            ,updateuserid -- 更新人编号
            ,updateuser -- 更新人
            ,isinuse -- 是否可用
            ,attribute2 -- 属性2
            ,updatetime -- 更新时间
            ,relaexpr -- 关系表述
            ,inputuserid -- 登记人编号
            ,updatedate -- 更新日期
            ,viewexpr -- 视图表述
            ,attribute3 -- 属性3
            ,remark -- 备注
            ,inputdate -- 登记日期
            ,inputorg -- 登记机构
            ,sortno -- 排序号
            ,updateorgid -- 更新机构
            ,inputtime -- 登记时间
            ,attribute1 -- 属性1
            ,relaobjecttype -- 关联对象类型
            ,showontabexpr -- 模板表述
            ,inputuser -- 登记人
            ,inputorgid -- 登记机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_objecttype_rela_op(
            objecttype -- 对象类型号
            ,relationship -- 关联关系
            ,displayname -- 显示名称
            ,updateuserid -- 更新人编号
            ,updateuser -- 更新人
            ,isinuse -- 是否可用
            ,attribute2 -- 属性2
            ,updatetime -- 更新时间
            ,relaexpr -- 关系表述
            ,inputuserid -- 登记人编号
            ,updatedate -- 更新日期
            ,viewexpr -- 视图表述
            ,attribute3 -- 属性3
            ,remark -- 备注
            ,inputdate -- 登记日期
            ,inputorg -- 登记机构
            ,sortno -- 排序号
            ,updateorgid -- 更新机构
            ,inputtime -- 登记时间
            ,attribute1 -- 属性1
            ,relaobjecttype -- 关联对象类型
            ,showontabexpr -- 模板表述
            ,inputuser -- 登记人
            ,inputorgid -- 登记机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.objecttype -- 对象类型号
    ,o.relationship -- 关联关系
    ,o.displayname -- 显示名称
    ,o.updateuserid -- 更新人编号
    ,o.updateuser -- 更新人
    ,o.isinuse -- 是否可用
    ,o.attribute2 -- 属性2
    ,o.updatetime -- 更新时间
    ,o.relaexpr -- 关系表述
    ,o.inputuserid -- 登记人编号
    ,o.updatedate -- 更新日期
    ,o.viewexpr -- 视图表述
    ,o.attribute3 -- 属性3
    ,o.remark -- 备注
    ,o.inputdate -- 登记日期
    ,o.inputorg -- 登记机构
    ,o.sortno -- 排序号
    ,o.updateorgid -- 更新机构
    ,o.inputtime -- 登记时间
    ,o.attribute1 -- 属性1
    ,o.relaobjecttype -- 关联对象类型
    ,o.showontabexpr -- 模板表述
    ,o.inputuser -- 登记人
    ,o.inputorgid -- 登记机构编号
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
from ${iol_schema}.icms_objecttype_rela_bk o
    left join ${iol_schema}.icms_objecttype_rela_op n
        on
            o.objecttype = n.objecttype
            and o.relationship = n.relationship
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_objecttype_rela_cl d
        on
            o.objecttype = d.objecttype
            and o.relationship = d.relationship
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_objecttype_rela;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_objecttype_rela') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_objecttype_rela drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_objecttype_rela add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_objecttype_rela exchange partition p_${batch_date} with table ${iol_schema}.icms_objecttype_rela_cl;
alter table ${iol_schema}.icms_objecttype_rela exchange partition p_20991231 with table ${iol_schema}.icms_objecttype_rela_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_objecttype_rela to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_objecttype_rela_op purge;
drop table ${iol_schema}.icms_objecttype_rela_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_objecttype_rela_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_objecttype_rela',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
