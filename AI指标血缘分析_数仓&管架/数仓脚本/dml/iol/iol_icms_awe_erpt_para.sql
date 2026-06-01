/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_awe_erpt_para
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
create table ${iol_schema}.icms_awe_erpt_para_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_awe_erpt_para
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_awe_erpt_para_op purge;
drop table ${iol_schema}.icms_awe_erpt_para_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_awe_erpt_para_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_awe_erpt_para where 0=1;

create table ${iol_schema}.icms_awe_erpt_para_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_awe_erpt_para where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_awe_erpt_para_cl(
            orgid -- 组织机构号
            ,docid -- 调查报告模板编号
            ,docname -- 模板名称
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,defaultvalue -- 默认打印节点
            ,attribute1 -- 属性1
            ,attribute2 -- 属性2
            ,updateuser -- 更新人
            ,inputtime -- 登记日期
            ,inputuser -- 登记人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_awe_erpt_para_op(
            orgid -- 组织机构号
            ,docid -- 调查报告模板编号
            ,docname -- 模板名称
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,defaultvalue -- 默认打印节点
            ,attribute1 -- 属性1
            ,attribute2 -- 属性2
            ,updateuser -- 更新人
            ,inputtime -- 登记日期
            ,inputuser -- 登记人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.orgid, o.orgid) as orgid -- 组织机构号
    ,nvl(n.docid, o.docid) as docid -- 调查报告模板编号
    ,nvl(n.docname, o.docname) as docname -- 模板名称
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.defaultvalue, o.defaultvalue) as defaultvalue -- 默认打印节点
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 属性1
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 属性2
    ,nvl(n.updateuser, o.updateuser) as updateuser -- 更新人
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记日期
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 登记人
    ,case when
            n.orgid is null
            and n.docid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.orgid is null
            and n.docid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.orgid is null
            and n.docid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_awe_erpt_para_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_awe_erpt_para where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.orgid = n.orgid
            and o.docid = n.docid
where (
        o.orgid is null
        and o.docid is null
    )
    or (
        n.orgid is null
        and n.docid is null
    )
    or (
        o.docname <> n.docname
        or o.remark <> n.remark
        or o.updatedate <> n.updatedate
        or o.defaultvalue <> n.defaultvalue
        or o.attribute1 <> n.attribute1
        or o.attribute2 <> n.attribute2
        or o.updateuser <> n.updateuser
        or o.inputtime <> n.inputtime
        or o.inputuser <> n.inputuser
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_awe_erpt_para_cl(
            orgid -- 组织机构号
            ,docid -- 调查报告模板编号
            ,docname -- 模板名称
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,defaultvalue -- 默认打印节点
            ,attribute1 -- 属性1
            ,attribute2 -- 属性2
            ,updateuser -- 更新人
            ,inputtime -- 登记日期
            ,inputuser -- 登记人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_awe_erpt_para_op(
            orgid -- 组织机构号
            ,docid -- 调查报告模板编号
            ,docname -- 模板名称
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,defaultvalue -- 默认打印节点
            ,attribute1 -- 属性1
            ,attribute2 -- 属性2
            ,updateuser -- 更新人
            ,inputtime -- 登记日期
            ,inputuser -- 登记人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.orgid -- 组织机构号
    ,o.docid -- 调查报告模板编号
    ,o.docname -- 模板名称
    ,o.remark -- 备注
    ,o.updatedate -- 更新日期
    ,o.defaultvalue -- 默认打印节点
    ,o.attribute1 -- 属性1
    ,o.attribute2 -- 属性2
    ,o.updateuser -- 更新人
    ,o.inputtime -- 登记日期
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
from ${iol_schema}.icms_awe_erpt_para_bk o
    left join ${iol_schema}.icms_awe_erpt_para_op n
        on
            o.orgid = n.orgid
            and o.docid = n.docid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_awe_erpt_para_cl d
        on
            o.orgid = d.orgid
            and o.docid = d.docid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_awe_erpt_para;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_awe_erpt_para') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_awe_erpt_para drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_awe_erpt_para add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_awe_erpt_para exchange partition p_${batch_date} with table ${iol_schema}.icms_awe_erpt_para_cl;
alter table ${iol_schema}.icms_awe_erpt_para exchange partition p_20991231 with table ${iol_schema}.icms_awe_erpt_para_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_awe_erpt_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_awe_erpt_para_op purge;
drop table ${iol_schema}.icms_awe_erpt_para_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_awe_erpt_para_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_awe_erpt_para',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
