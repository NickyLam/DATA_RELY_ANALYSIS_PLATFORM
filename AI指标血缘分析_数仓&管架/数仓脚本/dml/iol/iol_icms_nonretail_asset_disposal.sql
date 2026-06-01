/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_nonretail_asset_disposal
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
create table ${iol_schema}.icms_nonretail_asset_disposal_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_nonretail_asset_disposal
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_nonretail_asset_disposal_op purge;
drop table ${iol_schema}.icms_nonretail_asset_disposal_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_nonretail_asset_disposal_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_nonretail_asset_disposal where 0=1;

create table ${iol_schema}.icms_nonretail_asset_disposal_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_nonretail_asset_disposal where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_nonretail_asset_disposal_cl(
            programno -- 方案编号
            ,programname -- 方案名称
            ,summarize -- 方案描述
            ,customername -- 涉及借款人
            ,declarationinstruction -- 申报说明
            ,handletype -- 处置方式
            ,oldhandletype -- 旧处置方式（用于判断是否变更了）
            ,ischangehandletype -- 是否变更处置方式
            ,isrollback -- 是否退回
            ,flowstatus -- 流程状态
            ,taskstatus -- 任务状态
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,reviewno1 -- 审查编号（审查意见-分行）
            ,reviewno2 -- 审查编号（审查意见-总行）
            ,reviewno3 -- 审查编号（回复意见）
            ,updatedate -- 更新日期
            ,inputdate -- 登记日期
            ,reviewcomment -- 审查结论
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_nonretail_asset_disposal_op(
            programno -- 方案编号
            ,programname -- 方案名称
            ,summarize -- 方案描述
            ,customername -- 涉及借款人
            ,declarationinstruction -- 申报说明
            ,handletype -- 处置方式
            ,oldhandletype -- 旧处置方式（用于判断是否变更了）
            ,ischangehandletype -- 是否变更处置方式
            ,isrollback -- 是否退回
            ,flowstatus -- 流程状态
            ,taskstatus -- 任务状态
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,reviewno1 -- 审查编号（审查意见-分行）
            ,reviewno2 -- 审查编号（审查意见-总行）
            ,reviewno3 -- 审查编号（回复意见）
            ,updatedate -- 更新日期
            ,inputdate -- 登记日期
            ,reviewcomment -- 审查结论
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.programno, o.programno) as programno -- 方案编号
    ,nvl(n.programname, o.programname) as programname -- 方案名称
    ,nvl(n.summarize, o.summarize) as summarize -- 方案描述
    ,nvl(n.customername, o.customername) as customername -- 涉及借款人
    ,nvl(n.declarationinstruction, o.declarationinstruction) as declarationinstruction -- 申报说明
    ,nvl(n.handletype, o.handletype) as handletype -- 处置方式
    ,nvl(n.oldhandletype, o.oldhandletype) as oldhandletype -- 旧处置方式（用于判断是否变更了）
    ,nvl(n.ischangehandletype, o.ischangehandletype) as ischangehandletype -- 是否变更处置方式
    ,nvl(n.isrollback, o.isrollback) as isrollback -- 是否退回
    ,nvl(n.flowstatus, o.flowstatus) as flowstatus -- 流程状态
    ,nvl(n.taskstatus, o.taskstatus) as taskstatus -- 任务状态
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.reviewno1, o.reviewno1) as reviewno1 -- 审查编号（审查意见-分行）
    ,nvl(n.reviewno2, o.reviewno2) as reviewno2 -- 审查编号（审查意见-总行）
    ,nvl(n.reviewno3, o.reviewno3) as reviewno3 -- 审查编号（回复意见）
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.reviewcomment, o.reviewcomment) as reviewcomment -- 审查结论
    ,case when
            n.programno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.programno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.programno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_nonretail_asset_disposal_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_nonretail_asset_disposal where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.programno = n.programno
where (
        o.programno is null
    )
    or (
        n.programno is null
    )
    or (
        o.programname <> n.programname
        or o.summarize <> n.summarize
        or o.customername <> n.customername
        or o.declarationinstruction <> n.declarationinstruction
        or o.handletype <> n.handletype
        or o.oldhandletype <> n.oldhandletype
        or o.ischangehandletype <> n.ischangehandletype
        or o.isrollback <> n.isrollback
        or o.flowstatus <> n.flowstatus
        or o.taskstatus <> n.taskstatus
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.reviewno1 <> n.reviewno1
        or o.reviewno2 <> n.reviewno2
        or o.reviewno3 <> n.reviewno3
        or o.updatedate <> n.updatedate
        or o.inputdate <> n.inputdate
        or o.reviewcomment <> n.reviewcomment
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_nonretail_asset_disposal_cl(
            programno -- 方案编号
            ,programname -- 方案名称
            ,summarize -- 方案描述
            ,customername -- 涉及借款人
            ,declarationinstruction -- 申报说明
            ,handletype -- 处置方式
            ,oldhandletype -- 旧处置方式（用于判断是否变更了）
            ,ischangehandletype -- 是否变更处置方式
            ,isrollback -- 是否退回
            ,flowstatus -- 流程状态
            ,taskstatus -- 任务状态
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,reviewno1 -- 审查编号（审查意见-分行）
            ,reviewno2 -- 审查编号（审查意见-总行）
            ,reviewno3 -- 审查编号（回复意见）
            ,updatedate -- 更新日期
            ,inputdate -- 登记日期
            ,reviewcomment -- 审查结论
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_nonretail_asset_disposal_op(
            programno -- 方案编号
            ,programname -- 方案名称
            ,summarize -- 方案描述
            ,customername -- 涉及借款人
            ,declarationinstruction -- 申报说明
            ,handletype -- 处置方式
            ,oldhandletype -- 旧处置方式（用于判断是否变更了）
            ,ischangehandletype -- 是否变更处置方式
            ,isrollback -- 是否退回
            ,flowstatus -- 流程状态
            ,taskstatus -- 任务状态
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,reviewno1 -- 审查编号（审查意见-分行）
            ,reviewno2 -- 审查编号（审查意见-总行）
            ,reviewno3 -- 审查编号（回复意见）
            ,updatedate -- 更新日期
            ,inputdate -- 登记日期
            ,reviewcomment -- 审查结论
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.programno -- 方案编号
    ,o.programname -- 方案名称
    ,o.summarize -- 方案描述
    ,o.customername -- 涉及借款人
    ,o.declarationinstruction -- 申报说明
    ,o.handletype -- 处置方式
    ,o.oldhandletype -- 旧处置方式（用于判断是否变更了）
    ,o.ischangehandletype -- 是否变更处置方式
    ,o.isrollback -- 是否退回
    ,o.flowstatus -- 流程状态
    ,o.taskstatus -- 任务状态
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.reviewno1 -- 审查编号（审查意见-分行）
    ,o.reviewno2 -- 审查编号（审查意见-总行）
    ,o.reviewno3 -- 审查编号（回复意见）
    ,o.updatedate -- 更新日期
    ,o.inputdate -- 登记日期
    ,o.reviewcomment -- 审查结论
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
from ${iol_schema}.icms_nonretail_asset_disposal_bk o
    left join ${iol_schema}.icms_nonretail_asset_disposal_op n
        on
            o.programno = n.programno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_nonretail_asset_disposal_cl d
        on
            o.programno = d.programno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_nonretail_asset_disposal;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_nonretail_asset_disposal') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_nonretail_asset_disposal drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_nonretail_asset_disposal add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_nonretail_asset_disposal exchange partition p_${batch_date} with table ${iol_schema}.icms_nonretail_asset_disposal_cl;
alter table ${iol_schema}.icms_nonretail_asset_disposal exchange partition p_20991231 with table ${iol_schema}.icms_nonretail_asset_disposal_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_nonretail_asset_disposal to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_nonretail_asset_disposal_op purge;
drop table ${iol_schema}.icms_nonretail_asset_disposal_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_nonretail_asset_disposal_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_nonretail_asset_disposal',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
