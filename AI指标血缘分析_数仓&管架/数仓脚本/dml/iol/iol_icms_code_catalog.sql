/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_code_catalog
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
create table ${iol_schema}.icms_code_catalog_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_code_catalog
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_code_catalog_op purge;
drop table ${iol_schema}.icms_code_catalog_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_code_catalog_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_code_catalog where 0=1;

create table ${iol_schema}.icms_code_catalog_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_code_catalog where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_code_catalog_cl(
            codeno -- 代码编号
            ,codetypetwo -- 代码小类
            ,updateuser -- 更新人
            ,codetypeone -- 代码大类
            ,codeattribute -- 代码属性
            ,updateorg -- 更新机构
            ,inputorg -- 登记机构
            ,sortno -- 排序号
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,codename -- 代码名称
            ,codedescribe -- 代码描述
            ,inputdate -- 登记日期
            ,inputuser -- 登记人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_code_catalog_op(
            codeno -- 代码编号
            ,codetypetwo -- 代码小类
            ,updateuser -- 更新人
            ,codetypeone -- 代码大类
            ,codeattribute -- 代码属性
            ,updateorg -- 更新机构
            ,inputorg -- 登记机构
            ,sortno -- 排序号
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,codename -- 代码名称
            ,codedescribe -- 代码描述
            ,inputdate -- 登记日期
            ,inputuser -- 登记人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.codeno, o.codeno) as codeno -- 代码编号
    ,nvl(n.codetypetwo, o.codetypetwo) as codetypetwo -- 代码小类
    ,nvl(n.updateuser, o.updateuser) as updateuser -- 更新人
    ,nvl(n.codetypeone, o.codetypeone) as codetypeone -- 代码大类
    ,nvl(n.codeattribute, o.codeattribute) as codeattribute -- 代码属性
    ,nvl(n.updateorg, o.updateorg) as updateorg -- 更新机构
    ,nvl(n.inputorg, o.inputorg) as inputorg -- 登记机构
    ,nvl(n.sortno, o.sortno) as sortno -- 排序号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记时间
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.codename, o.codename) as codename -- 代码名称
    ,nvl(n.codedescribe, o.codedescribe) as codedescribe -- 代码描述
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 登记人
    ,case when
            n.codeno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.codeno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.codeno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_code_catalog_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_code_catalog where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.codeno = n.codeno
where (
        o.codeno is null
    )
    or (
        n.codeno is null
    )
    or (
        o.codetypetwo <> n.codetypetwo
        or o.updateuser <> n.updateuser
        or o.codetypeone <> n.codetypeone
        or o.codeattribute <> n.codeattribute
        or o.updateorg <> n.updateorg
        or o.inputorg <> n.inputorg
        or o.sortno <> n.sortno
        or o.remark <> n.remark
        or o.updatedate <> n.updatedate
        or o.inputtime <> n.inputtime
        or o.updatetime <> n.updatetime
        or o.codename <> n.codename
        or o.codedescribe <> n.codedescribe
        or o.inputdate <> n.inputdate
        or o.inputuser <> n.inputuser
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_code_catalog_cl(
            codeno -- 代码编号
            ,codetypetwo -- 代码小类
            ,updateuser -- 更新人
            ,codetypeone -- 代码大类
            ,codeattribute -- 代码属性
            ,updateorg -- 更新机构
            ,inputorg -- 登记机构
            ,sortno -- 排序号
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,codename -- 代码名称
            ,codedescribe -- 代码描述
            ,inputdate -- 登记日期
            ,inputuser -- 登记人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_code_catalog_op(
            codeno -- 代码编号
            ,codetypetwo -- 代码小类
            ,updateuser -- 更新人
            ,codetypeone -- 代码大类
            ,codeattribute -- 代码属性
            ,updateorg -- 更新机构
            ,inputorg -- 登记机构
            ,sortno -- 排序号
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,codename -- 代码名称
            ,codedescribe -- 代码描述
            ,inputdate -- 登记日期
            ,inputuser -- 登记人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.codeno -- 代码编号
    ,o.codetypetwo -- 代码小类
    ,o.updateuser -- 更新人
    ,o.codetypeone -- 代码大类
    ,o.codeattribute -- 代码属性
    ,o.updateorg -- 更新机构
    ,o.inputorg -- 登记机构
    ,o.sortno -- 排序号
    ,o.remark -- 备注
    ,o.updatedate -- 更新日期
    ,o.inputtime -- 登记时间
    ,o.updatetime -- 更新时间
    ,o.codename -- 代码名称
    ,o.codedescribe -- 代码描述
    ,o.inputdate -- 登记日期
    ,o.inputuser -- 登记人
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
from ${iol_schema}.icms_code_catalog_bk o
    left join ${iol_schema}.icms_code_catalog_op n
        on
            o.codeno = n.codeno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_code_catalog_cl d
        on
            o.codeno = d.codeno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_code_catalog;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_code_catalog') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_code_catalog drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_code_catalog add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_code_catalog exchange partition p_${batch_date} with table ${iol_schema}.icms_code_catalog_cl;
alter table ${iol_schema}.icms_code_catalog exchange partition p_20991231 with table ${iol_schema}.icms_code_catalog_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_code_catalog to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_code_catalog_op purge;
drop table ${iol_schema}.icms_code_catalog_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_code_catalog_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_code_catalog',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
