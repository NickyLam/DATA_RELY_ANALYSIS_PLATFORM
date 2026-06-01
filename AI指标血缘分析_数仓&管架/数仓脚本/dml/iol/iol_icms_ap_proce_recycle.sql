/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_proce_recycle
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
create table ${iol_schema}.icms_ap_proce_recycle_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_proce_recycle
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_proce_recycle_op purge;
drop table ${iol_schema}.icms_ap_proce_recycle_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_proce_recycle_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_proce_recycle where 0=1;

create table ${iol_schema}.icms_ap_proce_recycle_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_proce_recycle where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_proce_recycle_cl(
            recycleno -- 回收编号
            ,saveflag -- 保存状态
            ,isquestion -- 是否有疑议
            ,recyclerate -- 受偿利息
            ,caseno -- 关联案件项目编号
            ,holdname -- 财产持有人
            ,recyclecost -- 受偿费用
            ,remark -- 备注
            ,inform -- 书面通知
            ,updateuserid -- 更新人编号
            ,tmsp -- 时间戳
            ,recycleamt -- 要求回收金额
            ,report -- 分析建议
            ,recycledate -- 实际回收日期
            ,enterprise -- 破产企业
            ,recyclecapital -- 受偿本金
            ,inputuserid -- 登记人编号
            ,caseprogramstage -- 程序阶段信息
            ,inputorgid -- 登记机构编号
            ,updateorgid -- 更新机构编号
            ,holdid -- 财产持有人编号
            ,recyclesum -- 实际受偿金额
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,receiveamt -- 收到金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_proce_recycle_op(
            recycleno -- 回收编号
            ,saveflag -- 保存状态
            ,isquestion -- 是否有疑议
            ,recyclerate -- 受偿利息
            ,caseno -- 关联案件项目编号
            ,holdname -- 财产持有人
            ,recyclecost -- 受偿费用
            ,remark -- 备注
            ,inform -- 书面通知
            ,updateuserid -- 更新人编号
            ,tmsp -- 时间戳
            ,recycleamt -- 要求回收金额
            ,report -- 分析建议
            ,recycledate -- 实际回收日期
            ,enterprise -- 破产企业
            ,recyclecapital -- 受偿本金
            ,inputuserid -- 登记人编号
            ,caseprogramstage -- 程序阶段信息
            ,inputorgid -- 登记机构编号
            ,updateorgid -- 更新机构编号
            ,holdid -- 财产持有人编号
            ,recyclesum -- 实际受偿金额
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,receiveamt -- 收到金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.recycleno, o.recycleno) as recycleno -- 回收编号
    ,nvl(n.saveflag, o.saveflag) as saveflag -- 保存状态
    ,nvl(n.isquestion, o.isquestion) as isquestion -- 是否有疑议
    ,nvl(n.recyclerate, o.recyclerate) as recyclerate -- 受偿利息
    ,nvl(n.caseno, o.caseno) as caseno -- 关联案件项目编号
    ,nvl(n.holdname, o.holdname) as holdname -- 财产持有人
    ,nvl(n.recyclecost, o.recyclecost) as recyclecost -- 受偿费用
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inform, o.inform) as inform -- 书面通知
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.recycleamt, o.recycleamt) as recycleamt -- 要求回收金额
    ,nvl(n.report, o.report) as report -- 分析建议
    ,nvl(n.recycledate, o.recycledate) as recycledate -- 实际回收日期
    ,nvl(n.enterprise, o.enterprise) as enterprise -- 破产企业
    ,nvl(n.recyclecapital, o.recyclecapital) as recyclecapital -- 受偿本金
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人编号
    ,nvl(n.caseprogramstage, o.caseprogramstage) as caseprogramstage -- 程序阶段信息
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构编号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,nvl(n.holdid, o.holdid) as holdid -- 财产持有人编号
    ,nvl(n.recyclesum, o.recyclesum) as recyclesum -- 实际受偿金额
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.receiveamt, o.receiveamt) as receiveamt -- 收到金额
    ,case when
            n.recycleno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.recycleno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.recycleno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_proce_recycle_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_proce_recycle where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.recycleno = n.recycleno
where (
        o.recycleno is null
    )
    or (
        n.recycleno is null
    )
    or (
        o.saveflag <> n.saveflag
        or o.isquestion <> n.isquestion
        or o.recyclerate <> n.recyclerate
        or o.caseno <> n.caseno
        or o.holdname <> n.holdname
        or o.recyclecost <> n.recyclecost
        or o.remark <> n.remark
        or o.inform <> n.inform
        or o.updateuserid <> n.updateuserid
        or o.tmsp <> n.tmsp
        or o.recycleamt <> n.recycleamt
        or o.report <> n.report
        or o.recycledate <> n.recycledate
        or o.enterprise <> n.enterprise
        or o.recyclecapital <> n.recyclecapital
        or o.inputuserid <> n.inputuserid
        or o.caseprogramstage <> n.caseprogramstage
        or o.inputorgid <> n.inputorgid
        or o.updateorgid <> n.updateorgid
        or o.holdid <> n.holdid
        or o.recyclesum <> n.recyclesum
        or o.inputdate <> n.inputdate
        or o.updatedate <> n.updatedate
        or o.receiveamt <> n.receiveamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_proce_recycle_cl(
            recycleno -- 回收编号
            ,saveflag -- 保存状态
            ,isquestion -- 是否有疑议
            ,recyclerate -- 受偿利息
            ,caseno -- 关联案件项目编号
            ,holdname -- 财产持有人
            ,recyclecost -- 受偿费用
            ,remark -- 备注
            ,inform -- 书面通知
            ,updateuserid -- 更新人编号
            ,tmsp -- 时间戳
            ,recycleamt -- 要求回收金额
            ,report -- 分析建议
            ,recycledate -- 实际回收日期
            ,enterprise -- 破产企业
            ,recyclecapital -- 受偿本金
            ,inputuserid -- 登记人编号
            ,caseprogramstage -- 程序阶段信息
            ,inputorgid -- 登记机构编号
            ,updateorgid -- 更新机构编号
            ,holdid -- 财产持有人编号
            ,recyclesum -- 实际受偿金额
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,receiveamt -- 收到金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_proce_recycle_op(
            recycleno -- 回收编号
            ,saveflag -- 保存状态
            ,isquestion -- 是否有疑议
            ,recyclerate -- 受偿利息
            ,caseno -- 关联案件项目编号
            ,holdname -- 财产持有人
            ,recyclecost -- 受偿费用
            ,remark -- 备注
            ,inform -- 书面通知
            ,updateuserid -- 更新人编号
            ,tmsp -- 时间戳
            ,recycleamt -- 要求回收金额
            ,report -- 分析建议
            ,recycledate -- 实际回收日期
            ,enterprise -- 破产企业
            ,recyclecapital -- 受偿本金
            ,inputuserid -- 登记人编号
            ,caseprogramstage -- 程序阶段信息
            ,inputorgid -- 登记机构编号
            ,updateorgid -- 更新机构编号
            ,holdid -- 财产持有人编号
            ,recyclesum -- 实际受偿金额
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,receiveamt -- 收到金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.recycleno -- 回收编号
    ,o.saveflag -- 保存状态
    ,o.isquestion -- 是否有疑议
    ,o.recyclerate -- 受偿利息
    ,o.caseno -- 关联案件项目编号
    ,o.holdname -- 财产持有人
    ,o.recyclecost -- 受偿费用
    ,o.remark -- 备注
    ,o.inform -- 书面通知
    ,o.updateuserid -- 更新人编号
    ,o.tmsp -- 时间戳
    ,o.recycleamt -- 要求回收金额
    ,o.report -- 分析建议
    ,o.recycledate -- 实际回收日期
    ,o.enterprise -- 破产企业
    ,o.recyclecapital -- 受偿本金
    ,o.inputuserid -- 登记人编号
    ,o.caseprogramstage -- 程序阶段信息
    ,o.inputorgid -- 登记机构编号
    ,o.updateorgid -- 更新机构编号
    ,o.holdid -- 财产持有人编号
    ,o.recyclesum -- 实际受偿金额
    ,o.inputdate -- 登记日期
    ,o.updatedate -- 更新日期
    ,o.receiveamt -- 收到金额
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
from ${iol_schema}.icms_ap_proce_recycle_bk o
    left join ${iol_schema}.icms_ap_proce_recycle_op n
        on
            o.recycleno = n.recycleno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_proce_recycle_cl d
        on
            o.recycleno = d.recycleno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_proce_recycle;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_proce_recycle') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_proce_recycle drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_proce_recycle add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_proce_recycle exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_proce_recycle_cl;
alter table ${iol_schema}.icms_ap_proce_recycle exchange partition p_20991231 with table ${iol_schema}.icms_ap_proce_recycle_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_proce_recycle to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_proce_recycle_op purge;
drop table ${iol_schema}.icms_ap_proce_recycle_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_proce_recycle_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_proce_recycle',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
