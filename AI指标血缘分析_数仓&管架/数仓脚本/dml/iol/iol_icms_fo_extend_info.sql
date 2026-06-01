/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_fo_extend_info
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
create table ${iol_schema}.icms_fo_extend_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_fo_extend_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fo_extend_info_op purge;
drop table ${iol_schema}.icms_fo_extend_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fo_extend_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fo_extend_info where 0=1;

create table ${iol_schema}.icms_fo_extend_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fo_extend_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fo_extend_info_cl(
            serialno -- 流程节点编号
            ,objecttype -- 流程对象任务类型
            ,objectno -- 流程对象编号
            ,customername -- 客户名称
            ,vouchtype -- 授信主担保方式
            ,othervouchtype -- 其他担保方式
            ,credittypeone -- 申请授信种类-一级
            ,ownerline -- 条线
            ,credittypetwo -- 申请授信种类-二级
            ,creditareaflag -- 授信客户区域
            ,iscityinvestcomp -- 是否城投企业
            ,ownershipclassify -- 所有制分类
            ,industry -- 行业
            ,iscreditpolicy -- 是否符合信贷政策导向
            ,iscredit -- 是否新客户授信
            ,inputorg -- 登记机构
            ,inputuser -- 登记人
            ,updateorg -- 更新机构
            ,updateuser -- 更新人
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,isprojectloan -- 是否项目贷款
            ,iscityupdate -- 是否城市更新
            ,completeflag -- 是否保存
            ,score -- 评分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fo_extend_info_op(
            serialno -- 流程节点编号
            ,objecttype -- 流程对象任务类型
            ,objectno -- 流程对象编号
            ,customername -- 客户名称
            ,vouchtype -- 授信主担保方式
            ,othervouchtype -- 其他担保方式
            ,credittypeone -- 申请授信种类-一级
            ,ownerline -- 条线
            ,credittypetwo -- 申请授信种类-二级
            ,creditareaflag -- 授信客户区域
            ,iscityinvestcomp -- 是否城投企业
            ,ownershipclassify -- 所有制分类
            ,industry -- 行业
            ,iscreditpolicy -- 是否符合信贷政策导向
            ,iscredit -- 是否新客户授信
            ,inputorg -- 登记机构
            ,inputuser -- 登记人
            ,updateorg -- 更新机构
            ,updateuser -- 更新人
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,isprojectloan -- 是否项目贷款
            ,iscityupdate -- 是否城市更新
            ,completeflag -- 是否保存
            ,score -- 评分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流程节点编号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 流程对象任务类型
    ,nvl(n.objectno, o.objectno) as objectno -- 流程对象编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 授信主担保方式
    ,nvl(n.othervouchtype, o.othervouchtype) as othervouchtype -- 其他担保方式
    ,nvl(n.credittypeone, o.credittypeone) as credittypeone -- 申请授信种类-一级
    ,nvl(n.ownerline, o.ownerline) as ownerline -- 条线
    ,nvl(n.credittypetwo, o.credittypetwo) as credittypetwo -- 申请授信种类-二级
    ,nvl(n.creditareaflag, o.creditareaflag) as creditareaflag -- 授信客户区域
    ,nvl(n.iscityinvestcomp, o.iscityinvestcomp) as iscityinvestcomp -- 是否城投企业
    ,nvl(n.ownershipclassify, o.ownershipclassify) as ownershipclassify -- 所有制分类
    ,nvl(n.industry, o.industry) as industry -- 行业
    ,nvl(n.iscreditpolicy, o.iscreditpolicy) as iscreditpolicy -- 是否符合信贷政策导向
    ,nvl(n.iscredit, o.iscredit) as iscredit -- 是否新客户授信
    ,nvl(n.inputorg, o.inputorg) as inputorg -- 登记机构
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 登记人
    ,nvl(n.updateorg, o.updateorg) as updateorg -- 更新机构
    ,nvl(n.updateuser, o.updateuser) as updateuser -- 更新人
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记时间
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.isprojectloan, o.isprojectloan) as isprojectloan -- 是否项目贷款
    ,nvl(n.iscityupdate, o.iscityupdate) as iscityupdate -- 是否城市更新
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 是否保存
    ,nvl(n.score, o.score) as score -- 评分
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_fo_extend_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_fo_extend_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.objecttype <> n.objecttype
        or o.objectno <> n.objectno
        or o.customername <> n.customername
        or o.vouchtype <> n.vouchtype
        or o.othervouchtype <> n.othervouchtype
        or o.credittypeone <> n.credittypeone
        or o.ownerline <> n.ownerline
        or o.credittypetwo <> n.credittypetwo
        or o.creditareaflag <> n.creditareaflag
        or o.iscityinvestcomp <> n.iscityinvestcomp
        or o.ownershipclassify <> n.ownershipclassify
        or o.industry <> n.industry
        or o.iscreditpolicy <> n.iscreditpolicy
        or o.iscredit <> n.iscredit
        or o.inputorg <> n.inputorg
        or o.inputuser <> n.inputuser
        or o.updateorg <> n.updateorg
        or o.updateuser <> n.updateuser
        or o.inputtime <> n.inputtime
        or o.updatetime <> n.updatetime
        or o.isprojectloan <> n.isprojectloan
        or o.iscityupdate <> n.iscityupdate
        or o.completeflag <> n.completeflag
        or o.score <> n.score
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fo_extend_info_cl(
            serialno -- 流程节点编号
            ,objecttype -- 流程对象任务类型
            ,objectno -- 流程对象编号
            ,customername -- 客户名称
            ,vouchtype -- 授信主担保方式
            ,othervouchtype -- 其他担保方式
            ,credittypeone -- 申请授信种类-一级
            ,ownerline -- 条线
            ,credittypetwo -- 申请授信种类-二级
            ,creditareaflag -- 授信客户区域
            ,iscityinvestcomp -- 是否城投企业
            ,ownershipclassify -- 所有制分类
            ,industry -- 行业
            ,iscreditpolicy -- 是否符合信贷政策导向
            ,iscredit -- 是否新客户授信
            ,inputorg -- 登记机构
            ,inputuser -- 登记人
            ,updateorg -- 更新机构
            ,updateuser -- 更新人
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,isprojectloan -- 是否项目贷款
            ,iscityupdate -- 是否城市更新
            ,completeflag -- 是否保存
            ,score -- 评分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fo_extend_info_op(
            serialno -- 流程节点编号
            ,objecttype -- 流程对象任务类型
            ,objectno -- 流程对象编号
            ,customername -- 客户名称
            ,vouchtype -- 授信主担保方式
            ,othervouchtype -- 其他担保方式
            ,credittypeone -- 申请授信种类-一级
            ,ownerline -- 条线
            ,credittypetwo -- 申请授信种类-二级
            ,creditareaflag -- 授信客户区域
            ,iscityinvestcomp -- 是否城投企业
            ,ownershipclassify -- 所有制分类
            ,industry -- 行业
            ,iscreditpolicy -- 是否符合信贷政策导向
            ,iscredit -- 是否新客户授信
            ,inputorg -- 登记机构
            ,inputuser -- 登记人
            ,updateorg -- 更新机构
            ,updateuser -- 更新人
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,isprojectloan -- 是否项目贷款
            ,iscityupdate -- 是否城市更新
            ,completeflag -- 是否保存
            ,score -- 评分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流程节点编号
    ,o.objecttype -- 流程对象任务类型
    ,o.objectno -- 流程对象编号
    ,o.customername -- 客户名称
    ,o.vouchtype -- 授信主担保方式
    ,o.othervouchtype -- 其他担保方式
    ,o.credittypeone -- 申请授信种类-一级
    ,o.ownerline -- 条线
    ,o.credittypetwo -- 申请授信种类-二级
    ,o.creditareaflag -- 授信客户区域
    ,o.iscityinvestcomp -- 是否城投企业
    ,o.ownershipclassify -- 所有制分类
    ,o.industry -- 行业
    ,o.iscreditpolicy -- 是否符合信贷政策导向
    ,o.iscredit -- 是否新客户授信
    ,o.inputorg -- 登记机构
    ,o.inputuser -- 登记人
    ,o.updateorg -- 更新机构
    ,o.updateuser -- 更新人
    ,o.inputtime -- 登记时间
    ,o.updatetime -- 更新时间
    ,o.isprojectloan -- 是否项目贷款
    ,o.iscityupdate -- 是否城市更新
    ,o.completeflag -- 是否保存
    ,o.score -- 评分
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
from ${iol_schema}.icms_fo_extend_info_bk o
    left join ${iol_schema}.icms_fo_extend_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_fo_extend_info_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_fo_extend_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_fo_extend_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_fo_extend_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_fo_extend_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_fo_extend_info exchange partition p_${batch_date} with table ${iol_schema}.icms_fo_extend_info_cl;
alter table ${iol_schema}.icms_fo_extend_info exchange partition p_20991231 with table ${iol_schema}.icms_fo_extend_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_fo_extend_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fo_extend_info_op purge;
drop table ${iol_schema}.icms_fo_extend_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_fo_extend_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_fo_extend_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
