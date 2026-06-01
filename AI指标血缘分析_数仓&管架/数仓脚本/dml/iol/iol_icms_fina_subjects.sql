/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_fina_subjects
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
create table ${iol_schema}.icms_fina_subjects_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_fina_subjects
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fina_subjects_op purge;
drop table ${iol_schema}.icms_fina_subjects_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fina_subjects_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fina_subjects where 0=1;

create table ${iol_schema}.icms_fina_subjects_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fina_subjects where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fina_subjects_cl(
            subjectno -- 科目编号
            ,primaryclass -- 一级分类
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,auxiliaryaccounting -- 辅助核算
            ,available -- 可用
            ,remark -- 备注
            ,foreigncurrency -- 外币核算
            ,inputdate -- 登记日期登记日期时间
            ,valuetype -- 值类型
            ,direction -- 方向
            ,secondaryclass -- 二级分类
            ,transferending -- 期末调汇
            ,updateuserid -- 更新人
            ,inputuserid -- 登记人
            ,subjectname -- 科目名称
            ,inputorgid -- 登记机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fina_subjects_op(
            subjectno -- 科目编号
            ,primaryclass -- 一级分类
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,auxiliaryaccounting -- 辅助核算
            ,available -- 可用
            ,remark -- 备注
            ,foreigncurrency -- 外币核算
            ,inputdate -- 登记日期登记日期时间
            ,valuetype -- 值类型
            ,direction -- 方向
            ,secondaryclass -- 二级分类
            ,transferending -- 期末调汇
            ,updateuserid -- 更新人
            ,inputuserid -- 登记人
            ,subjectname -- 科目名称
            ,inputorgid -- 登记机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.subjectno, o.subjectno) as subjectno -- 科目编号
    ,nvl(n.primaryclass, o.primaryclass) as primaryclass -- 一级分类
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.auxiliaryaccounting, o.auxiliaryaccounting) as auxiliaryaccounting -- 辅助核算
    ,nvl(n.available, o.available) as available -- 可用
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.foreigncurrency, o.foreigncurrency) as foreigncurrency -- 外币核算
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期登记日期时间
    ,nvl(n.valuetype, o.valuetype) as valuetype -- 值类型
    ,nvl(n.direction, o.direction) as direction -- 方向
    ,nvl(n.secondaryclass, o.secondaryclass) as secondaryclass -- 二级分类
    ,nvl(n.transferending, o.transferending) as transferending -- 期末调汇
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.subjectname, o.subjectname) as subjectname -- 科目名称
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,case when
            n.subjectno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.subjectno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.subjectno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_fina_subjects_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_fina_subjects where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.subjectno = n.subjectno
where (
        o.subjectno is null
    )
    or (
        n.subjectno is null
    )
    or (
        o.primaryclass <> n.primaryclass
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.auxiliaryaccounting <> n.auxiliaryaccounting
        or o.available <> n.available
        or o.remark <> n.remark
        or o.foreigncurrency <> n.foreigncurrency
        or o.inputdate <> n.inputdate
        or o.valuetype <> n.valuetype
        or o.direction <> n.direction
        or o.secondaryclass <> n.secondaryclass
        or o.transferending <> n.transferending
        or o.updateuserid <> n.updateuserid
        or o.inputuserid <> n.inputuserid
        or o.subjectname <> n.subjectname
        or o.inputorgid <> n.inputorgid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fina_subjects_cl(
            subjectno -- 科目编号
            ,primaryclass -- 一级分类
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,auxiliaryaccounting -- 辅助核算
            ,available -- 可用
            ,remark -- 备注
            ,foreigncurrency -- 外币核算
            ,inputdate -- 登记日期登记日期时间
            ,valuetype -- 值类型
            ,direction -- 方向
            ,secondaryclass -- 二级分类
            ,transferending -- 期末调汇
            ,updateuserid -- 更新人
            ,inputuserid -- 登记人
            ,subjectname -- 科目名称
            ,inputorgid -- 登记机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fina_subjects_op(
            subjectno -- 科目编号
            ,primaryclass -- 一级分类
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,auxiliaryaccounting -- 辅助核算
            ,available -- 可用
            ,remark -- 备注
            ,foreigncurrency -- 外币核算
            ,inputdate -- 登记日期登记日期时间
            ,valuetype -- 值类型
            ,direction -- 方向
            ,secondaryclass -- 二级分类
            ,transferending -- 期末调汇
            ,updateuserid -- 更新人
            ,inputuserid -- 登记人
            ,subjectname -- 科目名称
            ,inputorgid -- 登记机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.subjectno -- 科目编号
    ,o.primaryclass -- 一级分类
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.auxiliaryaccounting -- 辅助核算
    ,o.available -- 可用
    ,o.remark -- 备注
    ,o.foreigncurrency -- 外币核算
    ,o.inputdate -- 登记日期登记日期时间
    ,o.valuetype -- 值类型
    ,o.direction -- 方向
    ,o.secondaryclass -- 二级分类
    ,o.transferending -- 期末调汇
    ,o.updateuserid -- 更新人
    ,o.inputuserid -- 登记人
    ,o.subjectname -- 科目名称
    ,o.inputorgid -- 登记机构
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
from ${iol_schema}.icms_fina_subjects_bk o
    left join ${iol_schema}.icms_fina_subjects_op n
        on
            o.subjectno = n.subjectno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_fina_subjects_cl d
        on
            o.subjectno = d.subjectno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_fina_subjects;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_fina_subjects') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_fina_subjects drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_fina_subjects add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_fina_subjects exchange partition p_${batch_date} with table ${iol_schema}.icms_fina_subjects_cl;
alter table ${iol_schema}.icms_fina_subjects exchange partition p_20991231 with table ${iol_schema}.icms_fina_subjects_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_fina_subjects to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fina_subjects_op purge;
drop table ${iol_schema}.icms_fina_subjects_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_fina_subjects_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_fina_subjects',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
