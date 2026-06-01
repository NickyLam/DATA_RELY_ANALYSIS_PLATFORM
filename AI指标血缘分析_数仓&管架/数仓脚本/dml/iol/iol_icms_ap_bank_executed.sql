/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_bank_executed
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
create table ${iol_schema}.icms_ap_bank_executed_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_bank_executed
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_bank_executed_op purge;
drop table ${iol_schema}.icms_ap_bank_executed_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_bank_executed_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_bank_executed where 0=1;

create table ${iol_schema}.icms_ap_bank_executed_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_bank_executed where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_bank_executed_cl(
            executeno -- 我行被执行编号
            ,inputuserid -- 录入人
            ,updatedate -- 更新日期
            ,caseno -- 关联案件编号
            ,updateuserid -- 更新人
            ,executecourt -- 执行法院
            ,inputorgid -- 录入机构
            ,excuteduserid -- 执行对象编号
            ,executeprocess -- 执行过程
            ,inputdate -- 录入日期
            ,updateorgid -- 更新机构
            ,applyexecuterid -- 申请执行人编号
            ,executeflag -- 执行状态
            ,applyexecutername -- 申请执行人名称
            ,directjudgetel -- 承办法官联系方式
            ,directjudgeid -- 承办法官编号
            ,caseprogramstage -- 案件阶段
            ,excutedusername -- 执行对象名称
            ,directjudgename -- 承办法官名称
            ,executecaseno -- 执行案号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_bank_executed_op(
            executeno -- 我行被执行编号
            ,inputuserid -- 录入人
            ,updatedate -- 更新日期
            ,caseno -- 关联案件编号
            ,updateuserid -- 更新人
            ,executecourt -- 执行法院
            ,inputorgid -- 录入机构
            ,excuteduserid -- 执行对象编号
            ,executeprocess -- 执行过程
            ,inputdate -- 录入日期
            ,updateorgid -- 更新机构
            ,applyexecuterid -- 申请执行人编号
            ,executeflag -- 执行状态
            ,applyexecutername -- 申请执行人名称
            ,directjudgetel -- 承办法官联系方式
            ,directjudgeid -- 承办法官编号
            ,caseprogramstage -- 案件阶段
            ,excutedusername -- 执行对象名称
            ,directjudgename -- 承办法官名称
            ,executecaseno -- 执行案号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.executeno, o.executeno) as executeno -- 我行被执行编号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 录入人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.caseno, o.caseno) as caseno -- 关联案件编号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.executecourt, o.executecourt) as executecourt -- 执行法院
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 录入机构
    ,nvl(n.excuteduserid, o.excuteduserid) as excuteduserid -- 执行对象编号
    ,nvl(n.executeprocess, o.executeprocess) as executeprocess -- 执行过程
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 录入日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.applyexecuterid, o.applyexecuterid) as applyexecuterid -- 申请执行人编号
    ,nvl(n.executeflag, o.executeflag) as executeflag -- 执行状态
    ,nvl(n.applyexecutername, o.applyexecutername) as applyexecutername -- 申请执行人名称
    ,nvl(n.directjudgetel, o.directjudgetel) as directjudgetel -- 承办法官联系方式
    ,nvl(n.directjudgeid, o.directjudgeid) as directjudgeid -- 承办法官编号
    ,nvl(n.caseprogramstage, o.caseprogramstage) as caseprogramstage -- 案件阶段
    ,nvl(n.excutedusername, o.excutedusername) as excutedusername -- 执行对象名称
    ,nvl(n.directjudgename, o.directjudgename) as directjudgename -- 承办法官名称
    ,nvl(n.executecaseno, o.executecaseno) as executecaseno -- 执行案号
    ,case when
            n.executeno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.executeno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.executeno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_bank_executed_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_bank_executed where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.executeno = n.executeno
where (
        o.executeno is null
    )
    or (
        n.executeno is null
    )
    or (
        o.inputuserid <> n.inputuserid
        or o.updatedate <> n.updatedate
        or o.caseno <> n.caseno
        or o.updateuserid <> n.updateuserid
        or o.executecourt <> n.executecourt
        or o.inputorgid <> n.inputorgid
        or o.excuteduserid <> n.excuteduserid
        or o.executeprocess <> n.executeprocess
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.applyexecuterid <> n.applyexecuterid
        or o.executeflag <> n.executeflag
        or o.applyexecutername <> n.applyexecutername
        or o.directjudgetel <> n.directjudgetel
        or o.directjudgeid <> n.directjudgeid
        or o.caseprogramstage <> n.caseprogramstage
        or o.excutedusername <> n.excutedusername
        or o.directjudgename <> n.directjudgename
        or o.executecaseno <> n.executecaseno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_bank_executed_cl(
            executeno -- 我行被执行编号
            ,inputuserid -- 录入人
            ,updatedate -- 更新日期
            ,caseno -- 关联案件编号
            ,updateuserid -- 更新人
            ,executecourt -- 执行法院
            ,inputorgid -- 录入机构
            ,excuteduserid -- 执行对象编号
            ,executeprocess -- 执行过程
            ,inputdate -- 录入日期
            ,updateorgid -- 更新机构
            ,applyexecuterid -- 申请执行人编号
            ,executeflag -- 执行状态
            ,applyexecutername -- 申请执行人名称
            ,directjudgetel -- 承办法官联系方式
            ,directjudgeid -- 承办法官编号
            ,caseprogramstage -- 案件阶段
            ,excutedusername -- 执行对象名称
            ,directjudgename -- 承办法官名称
            ,executecaseno -- 执行案号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_bank_executed_op(
            executeno -- 我行被执行编号
            ,inputuserid -- 录入人
            ,updatedate -- 更新日期
            ,caseno -- 关联案件编号
            ,updateuserid -- 更新人
            ,executecourt -- 执行法院
            ,inputorgid -- 录入机构
            ,excuteduserid -- 执行对象编号
            ,executeprocess -- 执行过程
            ,inputdate -- 录入日期
            ,updateorgid -- 更新机构
            ,applyexecuterid -- 申请执行人编号
            ,executeflag -- 执行状态
            ,applyexecutername -- 申请执行人名称
            ,directjudgetel -- 承办法官联系方式
            ,directjudgeid -- 承办法官编号
            ,caseprogramstage -- 案件阶段
            ,excutedusername -- 执行对象名称
            ,directjudgename -- 承办法官名称
            ,executecaseno -- 执行案号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.executeno -- 我行被执行编号
    ,o.inputuserid -- 录入人
    ,o.updatedate -- 更新日期
    ,o.caseno -- 关联案件编号
    ,o.updateuserid -- 更新人
    ,o.executecourt -- 执行法院
    ,o.inputorgid -- 录入机构
    ,o.excuteduserid -- 执行对象编号
    ,o.executeprocess -- 执行过程
    ,o.inputdate -- 录入日期
    ,o.updateorgid -- 更新机构
    ,o.applyexecuterid -- 申请执行人编号
    ,o.executeflag -- 执行状态
    ,o.applyexecutername -- 申请执行人名称
    ,o.directjudgetel -- 承办法官联系方式
    ,o.directjudgeid -- 承办法官编号
    ,o.caseprogramstage -- 案件阶段
    ,o.excutedusername -- 执行对象名称
    ,o.directjudgename -- 承办法官名称
    ,o.executecaseno -- 执行案号
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
from ${iol_schema}.icms_ap_bank_executed_bk o
    left join ${iol_schema}.icms_ap_bank_executed_op n
        on
            o.executeno = n.executeno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_bank_executed_cl d
        on
            o.executeno = d.executeno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_bank_executed;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_bank_executed') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_bank_executed drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_bank_executed add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_bank_executed exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_bank_executed_cl;
alter table ${iol_schema}.icms_ap_bank_executed exchange partition p_20991231 with table ${iol_schema}.icms_ap_bank_executed_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_bank_executed to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_bank_executed_op purge;
drop table ${iol_schema}.icms_ap_bank_executed_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_bank_executed_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_bank_executed',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
