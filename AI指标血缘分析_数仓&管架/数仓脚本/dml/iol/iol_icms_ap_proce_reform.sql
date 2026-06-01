/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_proce_reform
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
create table ${iol_schema}.icms_ap_proce_reform_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_proce_reform
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_proce_reform_op purge;
drop table ${iol_schema}.icms_ap_proce_reform_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_proce_reform_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_proce_reform where 0=1;

create table ${iol_schema}.icms_ap_proce_reform_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_proce_reform where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_proce_reform_cl(
            reformno -- 重整编号
            ,caseno -- 关联案件项目编号
            ,inputuserid -- 登记人编号
            ,decision -- 裁定书
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构编号
            ,saveflag -- 保存状态
            ,remark -- 备注
            ,updateuserid -- 更新人编号
            ,updatedate -- 更新日期
            ,advice -- 银行审批意见
            ,startdate -- 重整开始日期
            ,isreform -- 是否启动破产重整程序
            ,applydate -- 申请日期
            ,fileno -- 影像平台编号
            ,enddate -- 重整结束日期
            ,ruleid -- 裁定书号
            ,reformresult -- 重整结果
            ,result -- 重整结果
            ,proposername -- 申请人
            ,scheme -- 重整方案
            ,tmsp -- 时间戳
            ,proposerid -- 申请人编号
            ,caseprogramstage -- 程序阶段信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_proce_reform_op(
            reformno -- 重整编号
            ,caseno -- 关联案件项目编号
            ,inputuserid -- 登记人编号
            ,decision -- 裁定书
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构编号
            ,saveflag -- 保存状态
            ,remark -- 备注
            ,updateuserid -- 更新人编号
            ,updatedate -- 更新日期
            ,advice -- 银行审批意见
            ,startdate -- 重整开始日期
            ,isreform -- 是否启动破产重整程序
            ,applydate -- 申请日期
            ,fileno -- 影像平台编号
            ,enddate -- 重整结束日期
            ,ruleid -- 裁定书号
            ,reformresult -- 重整结果
            ,result -- 重整结果
            ,proposername -- 申请人
            ,scheme -- 重整方案
            ,tmsp -- 时间戳
            ,proposerid -- 申请人编号
            ,caseprogramstage -- 程序阶段信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.reformno, o.reformno) as reformno -- 重整编号
    ,nvl(n.caseno, o.caseno) as caseno -- 关联案件项目编号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人编号
    ,nvl(n.decision, o.decision) as decision -- 裁定书
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构编号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,nvl(n.saveflag, o.saveflag) as saveflag -- 保存状态
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.advice, o.advice) as advice -- 银行审批意见
    ,nvl(n.startdate, o.startdate) as startdate -- 重整开始日期
    ,nvl(n.isreform, o.isreform) as isreform -- 是否启动破产重整程序
    ,nvl(n.applydate, o.applydate) as applydate -- 申请日期
    ,nvl(n.fileno, o.fileno) as fileno -- 影像平台编号
    ,nvl(n.enddate, o.enddate) as enddate -- 重整结束日期
    ,nvl(n.ruleid, o.ruleid) as ruleid -- 裁定书号
    ,nvl(n.reformresult, o.reformresult) as reformresult -- 重整结果
    ,nvl(n.result, o.result) as result -- 重整结果
    ,nvl(n.proposername, o.proposername) as proposername -- 申请人
    ,nvl(n.scheme, o.scheme) as scheme -- 重整方案
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.proposerid, o.proposerid) as proposerid -- 申请人编号
    ,nvl(n.caseprogramstage, o.caseprogramstage) as caseprogramstage -- 程序阶段信息
    ,case when
            n.reformno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.reformno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.reformno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_proce_reform_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_proce_reform where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.reformno = n.reformno
where (
        o.reformno is null
    )
    or (
        n.reformno is null
    )
    or (
        o.caseno <> n.caseno
        or o.inputuserid <> n.inputuserid
        or o.decision <> n.decision
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.saveflag <> n.saveflag
        or o.remark <> n.remark
        or o.updateuserid <> n.updateuserid
        or o.updatedate <> n.updatedate
        or o.advice <> n.advice
        or o.startdate <> n.startdate
        or o.isreform <> n.isreform
        or o.applydate <> n.applydate
        or o.fileno <> n.fileno
        or o.enddate <> n.enddate
        or o.ruleid <> n.ruleid
        or o.reformresult <> n.reformresult
        or o.result <> n.result
        or o.proposername <> n.proposername
        or o.scheme <> n.scheme
        or o.tmsp <> n.tmsp
        or o.proposerid <> n.proposerid
        or o.caseprogramstage <> n.caseprogramstage
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_proce_reform_cl(
            reformno -- 重整编号
            ,caseno -- 关联案件项目编号
            ,inputuserid -- 登记人编号
            ,decision -- 裁定书
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构编号
            ,saveflag -- 保存状态
            ,remark -- 备注
            ,updateuserid -- 更新人编号
            ,updatedate -- 更新日期
            ,advice -- 银行审批意见
            ,startdate -- 重整开始日期
            ,isreform -- 是否启动破产重整程序
            ,applydate -- 申请日期
            ,fileno -- 影像平台编号
            ,enddate -- 重整结束日期
            ,ruleid -- 裁定书号
            ,reformresult -- 重整结果
            ,result -- 重整结果
            ,proposername -- 申请人
            ,scheme -- 重整方案
            ,tmsp -- 时间戳
            ,proposerid -- 申请人编号
            ,caseprogramstage -- 程序阶段信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_proce_reform_op(
            reformno -- 重整编号
            ,caseno -- 关联案件项目编号
            ,inputuserid -- 登记人编号
            ,decision -- 裁定书
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构编号
            ,saveflag -- 保存状态
            ,remark -- 备注
            ,updateuserid -- 更新人编号
            ,updatedate -- 更新日期
            ,advice -- 银行审批意见
            ,startdate -- 重整开始日期
            ,isreform -- 是否启动破产重整程序
            ,applydate -- 申请日期
            ,fileno -- 影像平台编号
            ,enddate -- 重整结束日期
            ,ruleid -- 裁定书号
            ,reformresult -- 重整结果
            ,result -- 重整结果
            ,proposername -- 申请人
            ,scheme -- 重整方案
            ,tmsp -- 时间戳
            ,proposerid -- 申请人编号
            ,caseprogramstage -- 程序阶段信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.reformno -- 重整编号
    ,o.caseno -- 关联案件项目编号
    ,o.inputuserid -- 登记人编号
    ,o.decision -- 裁定书
    ,o.inputorgid -- 登记机构编号
    ,o.inputdate -- 登记日期
    ,o.updateorgid -- 更新机构编号
    ,o.saveflag -- 保存状态
    ,o.remark -- 备注
    ,o.updateuserid -- 更新人编号
    ,o.updatedate -- 更新日期
    ,o.advice -- 银行审批意见
    ,o.startdate -- 重整开始日期
    ,o.isreform -- 是否启动破产重整程序
    ,o.applydate -- 申请日期
    ,o.fileno -- 影像平台编号
    ,o.enddate -- 重整结束日期
    ,o.ruleid -- 裁定书号
    ,o.reformresult -- 重整结果
    ,o.result -- 重整结果
    ,o.proposername -- 申请人
    ,o.scheme -- 重整方案
    ,o.tmsp -- 时间戳
    ,o.proposerid -- 申请人编号
    ,o.caseprogramstage -- 程序阶段信息
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
from ${iol_schema}.icms_ap_proce_reform_bk o
    left join ${iol_schema}.icms_ap_proce_reform_op n
        on
            o.reformno = n.reformno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_proce_reform_cl d
        on
            o.reformno = d.reformno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_proce_reform;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_proce_reform') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_proce_reform drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_proce_reform add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_proce_reform exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_proce_reform_cl;
alter table ${iol_schema}.icms_ap_proce_reform exchange partition p_20991231 with table ${iol_schema}.icms_ap_proce_reform_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_proce_reform to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_proce_reform_op purge;
drop table ${iol_schema}.icms_ap_proce_reform_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_proce_reform_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_proce_reform',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
