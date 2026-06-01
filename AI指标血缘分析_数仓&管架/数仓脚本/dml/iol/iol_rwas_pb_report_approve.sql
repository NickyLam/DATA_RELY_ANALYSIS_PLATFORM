/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rwas_pb_report_approve
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
create table ${iol_schema}.rwas_pb_report_approve_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rwas_pb_report_approve
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rwas_pb_report_approve_op purge;
drop table ${iol_schema}.rwas_pb_report_approve_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_pb_report_approve_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rwas_pb_report_approve where 0=1;

create table ${iol_schema}.rwas_pb_report_approve_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rwas_pb_report_approve where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rwas_pb_report_approve_cl(
            item_cd -- 报表编码
            ,item_name -- 报表名称
            ,data_date -- 数据日期
            ,solo_no -- 法人编码
            ,org_cd -- 机构编码
            ,ccy_cd -- 币种编码
            ,version -- 版本
            ,version_status -- 版本状态，1-保存，2-审批中，3-归档版本， 4-历史版本
            ,operate_dt -- 操作时间
            ,operate_id -- 操作人ID
            ,operate_name -- 操作人姓名
            ,flow_starter_id -- 流程发起人ID
            ,flow_starter_name -- 流程发起人姓名
            ,approve_remark -- 审批意见
            ,catalog_id -- 附件目录编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rwas_pb_report_approve_op(
            item_cd -- 报表编码
            ,item_name -- 报表名称
            ,data_date -- 数据日期
            ,solo_no -- 法人编码
            ,org_cd -- 机构编码
            ,ccy_cd -- 币种编码
            ,version -- 版本
            ,version_status -- 版本状态，1-保存，2-审批中，3-归档版本， 4-历史版本
            ,operate_dt -- 操作时间
            ,operate_id -- 操作人ID
            ,operate_name -- 操作人姓名
            ,flow_starter_id -- 流程发起人ID
            ,flow_starter_name -- 流程发起人姓名
            ,approve_remark -- 审批意见
            ,catalog_id -- 附件目录编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.item_cd, o.item_cd) as item_cd -- 报表编码
    ,nvl(n.item_name, o.item_name) as item_name -- 报表名称
    ,nvl(n.data_date, o.data_date) as data_date -- 数据日期
    ,nvl(n.solo_no, o.solo_no) as solo_no -- 法人编码
    ,nvl(n.org_cd, o.org_cd) as org_cd -- 机构编码
    ,nvl(n.ccy_cd, o.ccy_cd) as ccy_cd -- 币种编码
    ,nvl(n.version, o.version) as version -- 版本
    ,nvl(n.version_status, o.version_status) as version_status -- 版本状态，1-保存，2-审批中，3-归档版本， 4-历史版本
    ,nvl(n.operate_dt, o.operate_dt) as operate_dt -- 操作时间
    ,nvl(n.operate_id, o.operate_id) as operate_id -- 操作人ID
    ,nvl(n.operate_name, o.operate_name) as operate_name -- 操作人姓名
    ,nvl(n.flow_starter_id, o.flow_starter_id) as flow_starter_id -- 流程发起人ID
    ,nvl(n.flow_starter_name, o.flow_starter_name) as flow_starter_name -- 流程发起人姓名
    ,nvl(n.approve_remark, o.approve_remark) as approve_remark -- 审批意见
    ,nvl(n.catalog_id, o.catalog_id) as catalog_id -- 附件目录编号
    ,case when
            n.item_cd is null
            and n.data_date is null
            and n.org_cd is null
            and n.version is null
            and n.version_status is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.item_cd is null
            and n.data_date is null
            and n.org_cd is null
            and n.version is null
            and n.version_status is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.item_cd is null
            and n.data_date is null
            and n.org_cd is null
            and n.version is null
            and n.version_status is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rwas_pb_report_approve_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rwas_pb_report_approve where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.item_cd = n.item_cd
            and o.data_date = n.data_date
            and o.org_cd = n.org_cd
            and o.version = n.version
            and o.version_status = n.version_status
where (
        o.item_cd is null
        and o.data_date is null
        and o.org_cd is null
        and o.version is null
        and o.version_status is null
    )
    or (
        n.item_cd is null
        and n.data_date is null
        and n.org_cd is null
        and n.version is null
        and n.version_status is null
    )
    or (
        o.item_name <> n.item_name
        or o.solo_no <> n.solo_no
        or o.ccy_cd <> n.ccy_cd
        or o.operate_dt <> n.operate_dt
        or o.operate_id <> n.operate_id
        or o.operate_name <> n.operate_name
        or o.flow_starter_id <> n.flow_starter_id
        or o.flow_starter_name <> n.flow_starter_name
        or o.approve_remark <> n.approve_remark
        or o.catalog_id <> n.catalog_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rwas_pb_report_approve_cl(
            item_cd -- 报表编码
            ,item_name -- 报表名称
            ,data_date -- 数据日期
            ,solo_no -- 法人编码
            ,org_cd -- 机构编码
            ,ccy_cd -- 币种编码
            ,version -- 版本
            ,version_status -- 版本状态，1-保存，2-审批中，3-归档版本， 4-历史版本
            ,operate_dt -- 操作时间
            ,operate_id -- 操作人ID
            ,operate_name -- 操作人姓名
            ,flow_starter_id -- 流程发起人ID
            ,flow_starter_name -- 流程发起人姓名
            ,approve_remark -- 审批意见
            ,catalog_id -- 附件目录编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rwas_pb_report_approve_op(
            item_cd -- 报表编码
            ,item_name -- 报表名称
            ,data_date -- 数据日期
            ,solo_no -- 法人编码
            ,org_cd -- 机构编码
            ,ccy_cd -- 币种编码
            ,version -- 版本
            ,version_status -- 版本状态，1-保存，2-审批中，3-归档版本， 4-历史版本
            ,operate_dt -- 操作时间
            ,operate_id -- 操作人ID
            ,operate_name -- 操作人姓名
            ,flow_starter_id -- 流程发起人ID
            ,flow_starter_name -- 流程发起人姓名
            ,approve_remark -- 审批意见
            ,catalog_id -- 附件目录编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.item_cd -- 报表编码
    ,o.item_name -- 报表名称
    ,o.data_date -- 数据日期
    ,o.solo_no -- 法人编码
    ,o.org_cd -- 机构编码
    ,o.ccy_cd -- 币种编码
    ,o.version -- 版本
    ,o.version_status -- 版本状态，1-保存，2-审批中，3-归档版本， 4-历史版本
    ,o.operate_dt -- 操作时间
    ,o.operate_id -- 操作人ID
    ,o.operate_name -- 操作人姓名
    ,o.flow_starter_id -- 流程发起人ID
    ,o.flow_starter_name -- 流程发起人姓名
    ,o.approve_remark -- 审批意见
    ,o.catalog_id -- 附件目录编号
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
from ${iol_schema}.rwas_pb_report_approve_bk o
    left join ${iol_schema}.rwas_pb_report_approve_op n
        on
            o.item_cd = n.item_cd
            and o.data_date = n.data_date
            and o.org_cd = n.org_cd
            and o.version = n.version
            and o.version_status = n.version_status
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rwas_pb_report_approve_cl d
        on
            o.item_cd = d.item_cd
            and o.data_date = d.data_date
            and o.org_cd = d.org_cd
            and o.version = d.version
            and o.version_status = d.version_status
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rwas_pb_report_approve;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rwas_pb_report_approve') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rwas_pb_report_approve drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rwas_pb_report_approve add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rwas_pb_report_approve exchange partition p_${batch_date} with table ${iol_schema}.rwas_pb_report_approve_cl;
alter table ${iol_schema}.rwas_pb_report_approve exchange partition p_20991231 with table ${iol_schema}.rwas_pb_report_approve_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rwas_pb_report_approve to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rwas_pb_report_approve_op purge;
drop table ${iol_schema}.rwas_pb_report_approve_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rwas_pb_report_approve_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rwas_pb_report_approve',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
