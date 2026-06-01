/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_proce_allocation
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
create table ${iol_schema}.icms_ap_proce_allocation_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_proce_allocation
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_proce_allocation_op purge;
drop table ${iol_schema}.icms_ap_proce_allocation_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_proce_allocation_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_proce_allocation where 0=1;

create table ${iol_schema}.icms_ap_proce_allocation_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_proce_allocation where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_proce_allocation_cl(
            allocationno -- 分配编号
            ,updatedate -- 更新日期
            ,caseno -- 关联案件项目编号
            ,allocationsum -- 分配比例/分配金额
            ,allocatableinfo -- 破产人剩余可分配信息
            ,ruleid -- 裁定书号
            ,updateuserid -- 更新人编号
            ,updateorgid -- 更新机构编号
            ,decision -- 裁定书
            ,tmsp -- 时间戳
            ,fileno -- 影像平台编号
            ,ruledate -- 裁定日期
            ,saveflag -- 保存状态
            ,decisionid -- 裁定文书号
            ,allocationdate -- 分配日期
            ,inputdate -- 登记日期
            ,remark -- 备注
            ,inputuserid -- 登记人编号
            ,scheme -- 分配方案
            ,right -- 债权人特别权力
            ,inputorgid -- 登记机构编号
            ,caseprogramstage -- 程序阶段信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_proce_allocation_op(
            allocationno -- 分配编号
            ,updatedate -- 更新日期
            ,caseno -- 关联案件项目编号
            ,allocationsum -- 分配比例/分配金额
            ,allocatableinfo -- 破产人剩余可分配信息
            ,ruleid -- 裁定书号
            ,updateuserid -- 更新人编号
            ,updateorgid -- 更新机构编号
            ,decision -- 裁定书
            ,tmsp -- 时间戳
            ,fileno -- 影像平台编号
            ,ruledate -- 裁定日期
            ,saveflag -- 保存状态
            ,decisionid -- 裁定文书号
            ,allocationdate -- 分配日期
            ,inputdate -- 登记日期
            ,remark -- 备注
            ,inputuserid -- 登记人编号
            ,scheme -- 分配方案
            ,right -- 债权人特别权力
            ,inputorgid -- 登记机构编号
            ,caseprogramstage -- 程序阶段信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.allocationno, o.allocationno) as allocationno -- 分配编号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.caseno, o.caseno) as caseno -- 关联案件项目编号
    ,nvl(n.allocationsum, o.allocationsum) as allocationsum -- 分配比例/分配金额
    ,nvl(n.allocatableinfo, o.allocatableinfo) as allocatableinfo -- 破产人剩余可分配信息
    ,nvl(n.ruleid, o.ruleid) as ruleid -- 裁定书号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,nvl(n.decision, o.decision) as decision -- 裁定书
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.fileno, o.fileno) as fileno -- 影像平台编号
    ,nvl(n.ruledate, o.ruledate) as ruledate -- 裁定日期
    ,nvl(n.saveflag, o.saveflag) as saveflag -- 保存状态
    ,nvl(n.decisionid, o.decisionid) as decisionid -- 裁定文书号
    ,nvl(n.allocationdate, o.allocationdate) as allocationdate -- 分配日期
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人编号
    ,nvl(n.scheme, o.scheme) as scheme -- 分配方案
    ,nvl(n.right, o.right) as right -- 债权人特别权力
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构编号
    ,nvl(n.caseprogramstage, o.caseprogramstage) as caseprogramstage -- 程序阶段信息
    ,case when
            n.allocationno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.allocationno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.allocationno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_proce_allocation_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_proce_allocation where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.allocationno = n.allocationno
where (
        o.allocationno is null
    )
    or (
        n.allocationno is null
    )
    or (
        o.updatedate <> n.updatedate
        or o.caseno <> n.caseno
        or o.allocationsum <> n.allocationsum
        or o.allocatableinfo <> n.allocatableinfo
        or o.ruleid <> n.ruleid
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.decision <> n.decision
        or o.tmsp <> n.tmsp
        or o.fileno <> n.fileno
        or o.ruledate <> n.ruledate
        or o.saveflag <> n.saveflag
        or o.decisionid <> n.decisionid
        or o.allocationdate <> n.allocationdate
        or o.inputdate <> n.inputdate
        or o.remark <> n.remark
        or o.inputuserid <> n.inputuserid
        or o.scheme <> n.scheme
        or o.right <> n.right
        or o.inputorgid <> n.inputorgid
        or o.caseprogramstage <> n.caseprogramstage
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_proce_allocation_cl(
            allocationno -- 分配编号
            ,updatedate -- 更新日期
            ,caseno -- 关联案件项目编号
            ,allocationsum -- 分配比例/分配金额
            ,allocatableinfo -- 破产人剩余可分配信息
            ,ruleid -- 裁定书号
            ,updateuserid -- 更新人编号
            ,updateorgid -- 更新机构编号
            ,decision -- 裁定书
            ,tmsp -- 时间戳
            ,fileno -- 影像平台编号
            ,ruledate -- 裁定日期
            ,saveflag -- 保存状态
            ,decisionid -- 裁定文书号
            ,allocationdate -- 分配日期
            ,inputdate -- 登记日期
            ,remark -- 备注
            ,inputuserid -- 登记人编号
            ,scheme -- 分配方案
            ,right -- 债权人特别权力
            ,inputorgid -- 登记机构编号
            ,caseprogramstage -- 程序阶段信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_proce_allocation_op(
            allocationno -- 分配编号
            ,updatedate -- 更新日期
            ,caseno -- 关联案件项目编号
            ,allocationsum -- 分配比例/分配金额
            ,allocatableinfo -- 破产人剩余可分配信息
            ,ruleid -- 裁定书号
            ,updateuserid -- 更新人编号
            ,updateorgid -- 更新机构编号
            ,decision -- 裁定书
            ,tmsp -- 时间戳
            ,fileno -- 影像平台编号
            ,ruledate -- 裁定日期
            ,saveflag -- 保存状态
            ,decisionid -- 裁定文书号
            ,allocationdate -- 分配日期
            ,inputdate -- 登记日期
            ,remark -- 备注
            ,inputuserid -- 登记人编号
            ,scheme -- 分配方案
            ,right -- 债权人特别权力
            ,inputorgid -- 登记机构编号
            ,caseprogramstage -- 程序阶段信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.allocationno -- 分配编号
    ,o.updatedate -- 更新日期
    ,o.caseno -- 关联案件项目编号
    ,o.allocationsum -- 分配比例/分配金额
    ,o.allocatableinfo -- 破产人剩余可分配信息
    ,o.ruleid -- 裁定书号
    ,o.updateuserid -- 更新人编号
    ,o.updateorgid -- 更新机构编号
    ,o.decision -- 裁定书
    ,o.tmsp -- 时间戳
    ,o.fileno -- 影像平台编号
    ,o.ruledate -- 裁定日期
    ,o.saveflag -- 保存状态
    ,o.decisionid -- 裁定文书号
    ,o.allocationdate -- 分配日期
    ,o.inputdate -- 登记日期
    ,o.remark -- 备注
    ,o.inputuserid -- 登记人编号
    ,o.scheme -- 分配方案
    ,o.right -- 债权人特别权力
    ,o.inputorgid -- 登记机构编号
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
from ${iol_schema}.icms_ap_proce_allocation_bk o
    left join ${iol_schema}.icms_ap_proce_allocation_op n
        on
            o.allocationno = n.allocationno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_proce_allocation_cl d
        on
            o.allocationno = d.allocationno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_proce_allocation;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_proce_allocation') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_proce_allocation drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_proce_allocation add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_proce_allocation exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_proce_allocation_cl;
alter table ${iol_schema}.icms_ap_proce_allocation exchange partition p_20991231 with table ${iol_schema}.icms_ap_proce_allocation_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_proce_allocation to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_proce_allocation_op purge;
drop table ${iol_schema}.icms_ap_proce_allocation_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_proce_allocation_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_proce_allocation',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
