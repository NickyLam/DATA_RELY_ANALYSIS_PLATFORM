/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_abss_code_library
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
create table ${iol_schema}.abss_code_library_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.abss_code_library
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.abss_code_library_op purge;
drop table ${iol_schema}.abss_code_library_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_code_library_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.abss_code_library where 0=1;

create table ${iol_schema}.abss_code_library_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.abss_code_library where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.abss_code_library_cl(
            codeno -- 代码编号
            ,itemno -- 项目编号
            ,itemname -- 项目名
            ,bankno -- 征信代码
            ,sortno -- 排序号
            ,isinuse -- 是否使用
            ,itemdescribe -- 项目描述
            ,itemattribute -- 项目属性
            ,relativecode -- 关联代码
            ,attribute1 -- 属性1
            ,attribute2 -- 属性2
            ,attribute3 -- 属性3
            ,attribute4 -- 属性4
            ,attribute5 -- 属性5
            ,attribute6 -- 属性6
            ,attribute7 -- 属性7
            ,attribute8 -- 属性8
            ,inputuser -- 登记人员
            ,inputorg -- 登记机构
            ,inputtime -- 登记时间
            ,updateuser -- 更新人员
            ,updatetime -- 更新时间
            ,remark -- 备注
            ,helptext -- 帮助文本
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.abss_code_library_op(
            codeno -- 代码编号
            ,itemno -- 项目编号
            ,itemname -- 项目名
            ,bankno -- 征信代码
            ,sortno -- 排序号
            ,isinuse -- 是否使用
            ,itemdescribe -- 项目描述
            ,itemattribute -- 项目属性
            ,relativecode -- 关联代码
            ,attribute1 -- 属性1
            ,attribute2 -- 属性2
            ,attribute3 -- 属性3
            ,attribute4 -- 属性4
            ,attribute5 -- 属性5
            ,attribute6 -- 属性6
            ,attribute7 -- 属性7
            ,attribute8 -- 属性8
            ,inputuser -- 登记人员
            ,inputorg -- 登记机构
            ,inputtime -- 登记时间
            ,updateuser -- 更新人员
            ,updatetime -- 更新时间
            ,remark -- 备注
            ,helptext -- 帮助文本
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.codeno, o.codeno) as codeno -- 代码编号
    ,nvl(n.itemno, o.itemno) as itemno -- 项目编号
    ,nvl(n.itemname, o.itemname) as itemname -- 项目名
    ,nvl(n.bankno, o.bankno) as bankno -- 征信代码
    ,nvl(n.sortno, o.sortno) as sortno -- 排序号
    ,nvl(n.isinuse, o.isinuse) as isinuse -- 是否使用
    ,nvl(n.itemdescribe, o.itemdescribe) as itemdescribe -- 项目描述
    ,nvl(n.itemattribute, o.itemattribute) as itemattribute -- 项目属性
    ,nvl(n.relativecode, o.relativecode) as relativecode -- 关联代码
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 属性1
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 属性2
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 属性3
    ,nvl(n.attribute4, o.attribute4) as attribute4 -- 属性4
    ,nvl(n.attribute5, o.attribute5) as attribute5 -- 属性5
    ,nvl(n.attribute6, o.attribute6) as attribute6 -- 属性6
    ,nvl(n.attribute7, o.attribute7) as attribute7 -- 属性7
    ,nvl(n.attribute8, o.attribute8) as attribute8 -- 属性8
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 登记人员
    ,nvl(n.inputorg, o.inputorg) as inputorg -- 登记机构
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记时间
    ,nvl(n.updateuser, o.updateuser) as updateuser -- 更新人员
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.helptext, o.helptext) as helptext -- 帮助文本
    ,case when
            n.codeno is null
            and n.itemno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.codeno is null
            and n.itemno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.codeno is null
            and n.itemno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.abss_code_library_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.abss_code_library where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.codeno = n.codeno
            and o.itemno = n.itemno
where (
        o.codeno is null
        and o.itemno is null
    )
    or (
        n.codeno is null
        and n.itemno is null
    )
    or (
        o.itemname <> n.itemname
        or o.bankno <> n.bankno
        or o.sortno <> n.sortno
        or o.isinuse <> n.isinuse
        or o.itemdescribe <> n.itemdescribe
        or o.itemattribute <> n.itemattribute
        or o.relativecode <> n.relativecode
        or o.attribute1 <> n.attribute1
        or o.attribute2 <> n.attribute2
        or o.attribute3 <> n.attribute3
        or o.attribute4 <> n.attribute4
        or o.attribute5 <> n.attribute5
        or o.attribute6 <> n.attribute6
        or o.attribute7 <> n.attribute7
        or o.attribute8 <> n.attribute8
        or o.inputuser <> n.inputuser
        or o.inputorg <> n.inputorg
        or o.inputtime <> n.inputtime
        or o.updateuser <> n.updateuser
        or o.updatetime <> n.updatetime
        or o.remark <> n.remark
        or o.helptext <> n.helptext
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.abss_code_library_cl(
            codeno -- 代码编号
            ,itemno -- 项目编号
            ,itemname -- 项目名
            ,bankno -- 征信代码
            ,sortno -- 排序号
            ,isinuse -- 是否使用
            ,itemdescribe -- 项目描述
            ,itemattribute -- 项目属性
            ,relativecode -- 关联代码
            ,attribute1 -- 属性1
            ,attribute2 -- 属性2
            ,attribute3 -- 属性3
            ,attribute4 -- 属性4
            ,attribute5 -- 属性5
            ,attribute6 -- 属性6
            ,attribute7 -- 属性7
            ,attribute8 -- 属性8
            ,inputuser -- 登记人员
            ,inputorg -- 登记机构
            ,inputtime -- 登记时间
            ,updateuser -- 更新人员
            ,updatetime -- 更新时间
            ,remark -- 备注
            ,helptext -- 帮助文本
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.abss_code_library_op(
            codeno -- 代码编号
            ,itemno -- 项目编号
            ,itemname -- 项目名
            ,bankno -- 征信代码
            ,sortno -- 排序号
            ,isinuse -- 是否使用
            ,itemdescribe -- 项目描述
            ,itemattribute -- 项目属性
            ,relativecode -- 关联代码
            ,attribute1 -- 属性1
            ,attribute2 -- 属性2
            ,attribute3 -- 属性3
            ,attribute4 -- 属性4
            ,attribute5 -- 属性5
            ,attribute6 -- 属性6
            ,attribute7 -- 属性7
            ,attribute8 -- 属性8
            ,inputuser -- 登记人员
            ,inputorg -- 登记机构
            ,inputtime -- 登记时间
            ,updateuser -- 更新人员
            ,updatetime -- 更新时间
            ,remark -- 备注
            ,helptext -- 帮助文本
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.codeno -- 代码编号
    ,o.itemno -- 项目编号
    ,o.itemname -- 项目名
    ,o.bankno -- 征信代码
    ,o.sortno -- 排序号
    ,o.isinuse -- 是否使用
    ,o.itemdescribe -- 项目描述
    ,o.itemattribute -- 项目属性
    ,o.relativecode -- 关联代码
    ,o.attribute1 -- 属性1
    ,o.attribute2 -- 属性2
    ,o.attribute3 -- 属性3
    ,o.attribute4 -- 属性4
    ,o.attribute5 -- 属性5
    ,o.attribute6 -- 属性6
    ,o.attribute7 -- 属性7
    ,o.attribute8 -- 属性8
    ,o.inputuser -- 登记人员
    ,o.inputorg -- 登记机构
    ,o.inputtime -- 登记时间
    ,o.updateuser -- 更新人员
    ,o.updatetime -- 更新时间
    ,o.remark -- 备注
    ,o.helptext -- 帮助文本
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
from ${iol_schema}.abss_code_library_bk o
    left join ${iol_schema}.abss_code_library_op n
        on
            o.codeno = n.codeno
            and o.itemno = n.itemno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.abss_code_library_cl d
        on
            o.codeno = d.codeno
            and o.itemno = d.itemno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.abss_code_library;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('abss_code_library') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.abss_code_library drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.abss_code_library add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.abss_code_library exchange partition p_${batch_date} with table ${iol_schema}.abss_code_library_cl;
alter table ${iol_schema}.abss_code_library exchange partition p_20991231 with table ${iol_schema}.abss_code_library_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.abss_code_library to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.abss_code_library_op purge;
drop table ${iol_schema}.abss_code_library_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.abss_code_library_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'abss_code_library',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
