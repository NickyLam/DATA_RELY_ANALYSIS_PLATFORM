/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_prd_term_data
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
create table ${iol_schema}.icms_prd_term_data_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_prd_term_data
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_prd_term_data_op purge;
drop table ${iol_schema}.icms_prd_term_data_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_term_data_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_prd_term_data where 0=1;

create table ${iol_schema}.icms_prd_term_data_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_prd_term_data where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_prd_term_data_cl(
            versionid -- 版本编号
            ,componentid -- 组件编号
            ,termid -- 条款编号
            ,inputdate -- 登记日期
            ,termvaluename -- 条款值名称
            ,updateuserid -- 更新人
            ,inputorgid -- 登记机构
            ,updateorgid -- 更新机构
            ,controltype -- 控制类型
            ,updatedate -- 更新日期
            ,inputuserid -- 登记人
            ,termvaluetwo -- 条款右值
            ,controlscene -- 控制场景
            ,termvalue -- 条款值
            ,corporgid -- 法人机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_prd_term_data_op(
            versionid -- 版本编号
            ,componentid -- 组件编号
            ,termid -- 条款编号
            ,inputdate -- 登记日期
            ,termvaluename -- 条款值名称
            ,updateuserid -- 更新人
            ,inputorgid -- 登记机构
            ,updateorgid -- 更新机构
            ,controltype -- 控制类型
            ,updatedate -- 更新日期
            ,inputuserid -- 登记人
            ,termvaluetwo -- 条款右值
            ,controlscene -- 控制场景
            ,termvalue -- 条款值
            ,corporgid -- 法人机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.versionid, o.versionid) as versionid -- 版本编号
    ,nvl(n.componentid, o.componentid) as componentid -- 组件编号
    ,nvl(n.termid, o.termid) as termid -- 条款编号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.termvaluename, o.termvaluename) as termvaluename -- 条款值名称
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.controltype, o.controltype) as controltype -- 控制类型
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.termvaluetwo, o.termvaluetwo) as termvaluetwo -- 条款右值
    ,nvl(n.controlscene, o.controlscene) as controlscene -- 控制场景
    ,nvl(n.termvalue, o.termvalue) as termvalue -- 条款值
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,case when
            n.versionid is null
            and n.componentid is null
            and n.termid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.versionid is null
            and n.componentid is null
            and n.termid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.versionid is null
            and n.componentid is null
            and n.termid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_prd_term_data_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_prd_term_data where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.versionid = n.versionid
            and o.componentid = n.componentid
            and o.termid = n.termid
where (
        o.versionid is null
        and o.componentid is null
        and o.termid is null
    )
    or (
        n.versionid is null
        and n.componentid is null
        and n.termid is null
    )
    or (
        o.inputdate <> n.inputdate
        or o.termvaluename <> n.termvaluename
        or o.updateuserid <> n.updateuserid
        or o.inputorgid <> n.inputorgid
        or o.updateorgid <> n.updateorgid
        or o.controltype <> n.controltype
        or o.updatedate <> n.updatedate
        or o.inputuserid <> n.inputuserid
        or o.termvaluetwo <> n.termvaluetwo
        or o.controlscene <> n.controlscene
        or o.termvalue <> n.termvalue
        or o.corporgid <> n.corporgid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_prd_term_data_cl(
            versionid -- 版本编号
            ,componentid -- 组件编号
            ,termid -- 条款编号
            ,inputdate -- 登记日期
            ,termvaluename -- 条款值名称
            ,updateuserid -- 更新人
            ,inputorgid -- 登记机构
            ,updateorgid -- 更新机构
            ,controltype -- 控制类型
            ,updatedate -- 更新日期
            ,inputuserid -- 登记人
            ,termvaluetwo -- 条款右值
            ,controlscene -- 控制场景
            ,termvalue -- 条款值
            ,corporgid -- 法人机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_prd_term_data_op(
            versionid -- 版本编号
            ,componentid -- 组件编号
            ,termid -- 条款编号
            ,inputdate -- 登记日期
            ,termvaluename -- 条款值名称
            ,updateuserid -- 更新人
            ,inputorgid -- 登记机构
            ,updateorgid -- 更新机构
            ,controltype -- 控制类型
            ,updatedate -- 更新日期
            ,inputuserid -- 登记人
            ,termvaluetwo -- 条款右值
            ,controlscene -- 控制场景
            ,termvalue -- 条款值
            ,corporgid -- 法人机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.versionid -- 版本编号
    ,o.componentid -- 组件编号
    ,o.termid -- 条款编号
    ,o.inputdate -- 登记日期
    ,o.termvaluename -- 条款值名称
    ,o.updateuserid -- 更新人
    ,o.inputorgid -- 登记机构
    ,o.updateorgid -- 更新机构
    ,o.controltype -- 控制类型
    ,o.updatedate -- 更新日期
    ,o.inputuserid -- 登记人
    ,o.termvaluetwo -- 条款右值
    ,o.controlscene -- 控制场景
    ,o.termvalue -- 条款值
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
from ${iol_schema}.icms_prd_term_data_bk o
    left join ${iol_schema}.icms_prd_term_data_op n
        on
            o.versionid = n.versionid
            and o.componentid = n.componentid
            and o.termid = n.termid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_prd_term_data_cl d
        on
            o.versionid = d.versionid
            and o.componentid = d.componentid
            and o.termid = d.termid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_prd_term_data;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_prd_term_data') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_prd_term_data drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_prd_term_data add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_prd_term_data exchange partition p_${batch_date} with table ${iol_schema}.icms_prd_term_data_cl;
alter table ${iol_schema}.icms_prd_term_data exchange partition p_20991231 with table ${iol_schema}.icms_prd_term_data_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_prd_term_data to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_prd_term_data_op purge;
drop table ${iol_schema}.icms_prd_term_data_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_prd_term_data_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_prd_term_data',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
