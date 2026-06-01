/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amis_ac_project_punishment
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
create table ${iol_schema}.amis_ac_project_punishment_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amis_ac_project_punishment
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amis_ac_project_punishment_op purge;
drop table ${iol_schema}.amis_ac_project_punishment_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amis_ac_project_punishment_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amis_ac_project_punishment where 0=1;

create table ${iol_schema}.amis_ac_project_punishment_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amis_ac_project_punishment where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amis_ac_project_punishment_cl(
            ac_project_punishment_uuid -- 处分UUID
            ,nishment_code -- 处分编号
            ,ac_project_uuid -- 问责项目uuid
            ,personduty_name -- 责任人名称
            ,ac_personduty_uuid -- 责任人记录ID
            ,old_orgname -- 原所在机构
            ,old_station -- 原岗位
            ,curr_org_uuid -- 现所在机构UUID
            ,curr_org_name -- 现所在机构名称
            ,curr_station -- 现岗位
            ,ac_project_name -- 问责项目名称
            ,account_number -- 问责文号
            ,dispatch_uuid -- 发文UUID
            ,dispatch_name -- 发文标题
            ,dispatch_org -- 发文单位
            ,dispatch_time -- 发文时间
            ,punishment_type -- 处分类型
            ,disciplinary_punishment -- 纪律处分
            ,economic_punishment -- 经济处罚
            ,organization_punishment -- 组织处理
            ,other_punishment -- 其他处分
            ,exemption_punishment -- 免于处分原因
            ,punishment_reason -- 处分原因
            ,exe_org_uuid -- 执行机构UUID
            ,exe_org_name -- 执行机构名称
            ,create_person_uuid -- 处分录入人UUID
            ,create_person_name -- 处分录入人名称
            ,create_date -- 处分录入时间
            ,exe_date -- 提交执行时间
            ,create_org_uuid -- 处分录入机构UUID
            ,create_org_name -- 处分录入机构
            ,deleted -- 删除标识
            ,punishment_ext1 -- 扩展字段1
            ,punishment_ext2 -- 扩展字段2
            ,punishment_type_code -- 处分类型CODE
            ,punishment_ext3 -- 扩展字段3
            ,punishment_ext4 -- 扩展字段4
            ,punishment_ext5 -- 扩展字段5
            ,status -- 状态
            ,disciplinary_punishment_code -- 纪律处分CODE
            ,organization_punishment_code -- 组织处理CODE
            ,other_punishment_code -- 其他处分CODE
            ,punishment_accordance -- 处分依据
            ,disciplinary_punishment_deadline -- 纪律处分期限
            ,disciplinary_punishment_start_time -- 纪律处分处罚时间
            ,disciplinary_punishment_end_time -- 纪律处分解除时间
            ,organization_punishment_deadline -- 组织处理期限
            ,organization_punishment_start_time -- 组织处理处罚时间
            ,organization_punishment_end_time -- 组织处理解除时间
            ,other_punishment_desc -- 处分具体处分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amis_ac_project_punishment_op(
            ac_project_punishment_uuid -- 处分UUID
            ,nishment_code -- 处分编号
            ,ac_project_uuid -- 问责项目uuid
            ,personduty_name -- 责任人名称
            ,ac_personduty_uuid -- 责任人记录ID
            ,old_orgname -- 原所在机构
            ,old_station -- 原岗位
            ,curr_org_uuid -- 现所在机构UUID
            ,curr_org_name -- 现所在机构名称
            ,curr_station -- 现岗位
            ,ac_project_name -- 问责项目名称
            ,account_number -- 问责文号
            ,dispatch_uuid -- 发文UUID
            ,dispatch_name -- 发文标题
            ,dispatch_org -- 发文单位
            ,dispatch_time -- 发文时间
            ,punishment_type -- 处分类型
            ,disciplinary_punishment -- 纪律处分
            ,economic_punishment -- 经济处罚
            ,organization_punishment -- 组织处理
            ,other_punishment -- 其他处分
            ,exemption_punishment -- 免于处分原因
            ,punishment_reason -- 处分原因
            ,exe_org_uuid -- 执行机构UUID
            ,exe_org_name -- 执行机构名称
            ,create_person_uuid -- 处分录入人UUID
            ,create_person_name -- 处分录入人名称
            ,create_date -- 处分录入时间
            ,exe_date -- 提交执行时间
            ,create_org_uuid -- 处分录入机构UUID
            ,create_org_name -- 处分录入机构
            ,deleted -- 删除标识
            ,punishment_ext1 -- 扩展字段1
            ,punishment_ext2 -- 扩展字段2
            ,punishment_type_code -- 处分类型CODE
            ,punishment_ext3 -- 扩展字段3
            ,punishment_ext4 -- 扩展字段4
            ,punishment_ext5 -- 扩展字段5
            ,status -- 状态
            ,disciplinary_punishment_code -- 纪律处分CODE
            ,organization_punishment_code -- 组织处理CODE
            ,other_punishment_code -- 其他处分CODE
            ,punishment_accordance -- 处分依据
            ,disciplinary_punishment_deadline -- 纪律处分期限
            ,disciplinary_punishment_start_time -- 纪律处分处罚时间
            ,disciplinary_punishment_end_time -- 纪律处分解除时间
            ,organization_punishment_deadline -- 组织处理期限
            ,organization_punishment_start_time -- 组织处理处罚时间
            ,organization_punishment_end_time -- 组织处理解除时间
            ,other_punishment_desc -- 处分具体处分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ac_project_punishment_uuid, o.ac_project_punishment_uuid) as ac_project_punishment_uuid -- 处分UUID
    ,nvl(n.nishment_code, o.nishment_code) as nishment_code -- 处分编号
    ,nvl(n.ac_project_uuid, o.ac_project_uuid) as ac_project_uuid -- 问责项目uuid
    ,nvl(n.personduty_name, o.personduty_name) as personduty_name -- 责任人名称
    ,nvl(n.ac_personduty_uuid, o.ac_personduty_uuid) as ac_personduty_uuid -- 责任人记录ID
    ,nvl(n.old_orgname, o.old_orgname) as old_orgname -- 原所在机构
    ,nvl(n.old_station, o.old_station) as old_station -- 原岗位
    ,nvl(n.curr_org_uuid, o.curr_org_uuid) as curr_org_uuid -- 现所在机构UUID
    ,nvl(n.curr_org_name, o.curr_org_name) as curr_org_name -- 现所在机构名称
    ,nvl(n.curr_station, o.curr_station) as curr_station -- 现岗位
    ,nvl(n.ac_project_name, o.ac_project_name) as ac_project_name -- 问责项目名称
    ,nvl(n.account_number, o.account_number) as account_number -- 问责文号
    ,nvl(n.dispatch_uuid, o.dispatch_uuid) as dispatch_uuid -- 发文UUID
    ,nvl(n.dispatch_name, o.dispatch_name) as dispatch_name -- 发文标题
    ,nvl(n.dispatch_org, o.dispatch_org) as dispatch_org -- 发文单位
    ,nvl(n.dispatch_time, o.dispatch_time) as dispatch_time -- 发文时间
    ,nvl(n.punishment_type, o.punishment_type) as punishment_type -- 处分类型
    ,nvl(n.disciplinary_punishment, o.disciplinary_punishment) as disciplinary_punishment -- 纪律处分
    ,nvl(n.economic_punishment, o.economic_punishment) as economic_punishment -- 经济处罚
    ,nvl(n.organization_punishment, o.organization_punishment) as organization_punishment -- 组织处理
    ,nvl(n.other_punishment, o.other_punishment) as other_punishment -- 其他处分
    ,nvl(n.exemption_punishment, o.exemption_punishment) as exemption_punishment -- 免于处分原因
    ,nvl(n.punishment_reason, o.punishment_reason) as punishment_reason -- 处分原因
    ,nvl(n.exe_org_uuid, o.exe_org_uuid) as exe_org_uuid -- 执行机构UUID
    ,nvl(n.exe_org_name, o.exe_org_name) as exe_org_name -- 执行机构名称
    ,nvl(n.create_person_uuid, o.create_person_uuid) as create_person_uuid -- 处分录入人UUID
    ,nvl(n.create_person_name, o.create_person_name) as create_person_name -- 处分录入人名称
    ,nvl(n.create_date, o.create_date) as create_date -- 处分录入时间
    ,nvl(n.exe_date, o.exe_date) as exe_date -- 提交执行时间
    ,nvl(n.create_org_uuid, o.create_org_uuid) as create_org_uuid -- 处分录入机构UUID
    ,nvl(n.create_org_name, o.create_org_name) as create_org_name -- 处分录入机构
    ,nvl(n.deleted, o.deleted) as deleted -- 删除标识
    ,nvl(n.punishment_ext1, o.punishment_ext1) as punishment_ext1 -- 扩展字段1
    ,nvl(n.punishment_ext2, o.punishment_ext2) as punishment_ext2 -- 扩展字段2
    ,nvl(n.punishment_type_code, o.punishment_type_code) as punishment_type_code -- 处分类型CODE
    ,nvl(n.punishment_ext3, o.punishment_ext3) as punishment_ext3 -- 扩展字段3
    ,nvl(n.punishment_ext4, o.punishment_ext4) as punishment_ext4 -- 扩展字段4
    ,nvl(n.punishment_ext5, o.punishment_ext5) as punishment_ext5 -- 扩展字段5
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.disciplinary_punishment_code, o.disciplinary_punishment_code) as disciplinary_punishment_code -- 纪律处分CODE
    ,nvl(n.organization_punishment_code, o.organization_punishment_code) as organization_punishment_code -- 组织处理CODE
    ,nvl(n.other_punishment_code, o.other_punishment_code) as other_punishment_code -- 其他处分CODE
    ,nvl(n.punishment_accordance, o.punishment_accordance) as punishment_accordance -- 处分依据
    ,nvl(n.disciplinary_punishment_deadline, o.disciplinary_punishment_deadline) as disciplinary_punishment_deadline -- 纪律处分期限
    ,nvl(n.disciplinary_punishment_start_time, o.disciplinary_punishment_start_time) as disciplinary_punishment_start_time -- 纪律处分处罚时间
    ,nvl(n.disciplinary_punishment_end_time, o.disciplinary_punishment_end_time) as disciplinary_punishment_end_time -- 纪律处分解除时间
    ,nvl(n.organization_punishment_deadline, o.organization_punishment_deadline) as organization_punishment_deadline -- 组织处理期限
    ,nvl(n.organization_punishment_start_time, o.organization_punishment_start_time) as organization_punishment_start_time -- 组织处理处罚时间
    ,nvl(n.organization_punishment_end_time, o.organization_punishment_end_time) as organization_punishment_end_time -- 组织处理解除时间
    ,nvl(n.other_punishment_desc, o.other_punishment_desc) as other_punishment_desc -- 处分具体处分
    ,case when
            n.ac_project_punishment_uuid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ac_project_punishment_uuid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ac_project_punishment_uuid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amis_ac_project_punishment_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amis_ac_project_punishment where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ac_project_punishment_uuid = n.ac_project_punishment_uuid
where (
        o.ac_project_punishment_uuid is null
    )
    or (
        n.ac_project_punishment_uuid is null
    )
    or (
        o.nishment_code <> n.nishment_code
        or o.ac_project_uuid <> n.ac_project_uuid
        or o.personduty_name <> n.personduty_name
        or o.ac_personduty_uuid <> n.ac_personduty_uuid
        or o.old_orgname <> n.old_orgname
        or o.old_station <> n.old_station
        or o.curr_org_uuid <> n.curr_org_uuid
        or o.curr_org_name <> n.curr_org_name
        or o.curr_station <> n.curr_station
        or o.ac_project_name <> n.ac_project_name
        or o.account_number <> n.account_number
        or o.dispatch_uuid <> n.dispatch_uuid
        or o.dispatch_name <> n.dispatch_name
        or o.dispatch_org <> n.dispatch_org
        or o.dispatch_time <> n.dispatch_time
        or o.punishment_type <> n.punishment_type
        or o.disciplinary_punishment <> n.disciplinary_punishment
        or o.economic_punishment <> n.economic_punishment
        or o.organization_punishment <> n.organization_punishment
        or o.other_punishment <> n.other_punishment
        or o.exemption_punishment <> n.exemption_punishment
        or o.punishment_reason <> n.punishment_reason
        or o.exe_org_uuid <> n.exe_org_uuid
        or o.exe_org_name <> n.exe_org_name
        or o.create_person_uuid <> n.create_person_uuid
        or o.create_person_name <> n.create_person_name
        or o.create_date <> n.create_date
        or o.exe_date <> n.exe_date
        or o.create_org_uuid <> n.create_org_uuid
        or o.create_org_name <> n.create_org_name
        or o.deleted <> n.deleted
        or o.punishment_ext1 <> n.punishment_ext1
        or o.punishment_ext2 <> n.punishment_ext2
        or o.punishment_type_code <> n.punishment_type_code
        or o.punishment_ext3 <> n.punishment_ext3
        or o.punishment_ext4 <> n.punishment_ext4
        or o.punishment_ext5 <> n.punishment_ext5
        or o.status <> n.status
        or o.disciplinary_punishment_code <> n.disciplinary_punishment_code
        or o.organization_punishment_code <> n.organization_punishment_code
        or o.other_punishment_code <> n.other_punishment_code
        or o.punishment_accordance <> n.punishment_accordance
        or o.disciplinary_punishment_deadline <> n.disciplinary_punishment_deadline
        or o.disciplinary_punishment_start_time <> n.disciplinary_punishment_start_time
        or o.disciplinary_punishment_end_time <> n.disciplinary_punishment_end_time
        or o.organization_punishment_deadline <> n.organization_punishment_deadline
        or o.organization_punishment_start_time <> n.organization_punishment_start_time
        or o.organization_punishment_end_time <> n.organization_punishment_end_time
        or o.other_punishment_desc <> n.other_punishment_desc
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amis_ac_project_punishment_cl(
            ac_project_punishment_uuid -- 处分UUID
            ,nishment_code -- 处分编号
            ,ac_project_uuid -- 问责项目uuid
            ,personduty_name -- 责任人名称
            ,ac_personduty_uuid -- 责任人记录ID
            ,old_orgname -- 原所在机构
            ,old_station -- 原岗位
            ,curr_org_uuid -- 现所在机构UUID
            ,curr_org_name -- 现所在机构名称
            ,curr_station -- 现岗位
            ,ac_project_name -- 问责项目名称
            ,account_number -- 问责文号
            ,dispatch_uuid -- 发文UUID
            ,dispatch_name -- 发文标题
            ,dispatch_org -- 发文单位
            ,dispatch_time -- 发文时间
            ,punishment_type -- 处分类型
            ,disciplinary_punishment -- 纪律处分
            ,economic_punishment -- 经济处罚
            ,organization_punishment -- 组织处理
            ,other_punishment -- 其他处分
            ,exemption_punishment -- 免于处分原因
            ,punishment_reason -- 处分原因
            ,exe_org_uuid -- 执行机构UUID
            ,exe_org_name -- 执行机构名称
            ,create_person_uuid -- 处分录入人UUID
            ,create_person_name -- 处分录入人名称
            ,create_date -- 处分录入时间
            ,exe_date -- 提交执行时间
            ,create_org_uuid -- 处分录入机构UUID
            ,create_org_name -- 处分录入机构
            ,deleted -- 删除标识
            ,punishment_ext1 -- 扩展字段1
            ,punishment_ext2 -- 扩展字段2
            ,punishment_type_code -- 处分类型CODE
            ,punishment_ext3 -- 扩展字段3
            ,punishment_ext4 -- 扩展字段4
            ,punishment_ext5 -- 扩展字段5
            ,status -- 状态
            ,disciplinary_punishment_code -- 纪律处分CODE
            ,organization_punishment_code -- 组织处理CODE
            ,other_punishment_code -- 其他处分CODE
            ,punishment_accordance -- 处分依据
            ,disciplinary_punishment_deadline -- 纪律处分期限
            ,disciplinary_punishment_start_time -- 纪律处分处罚时间
            ,disciplinary_punishment_end_time -- 纪律处分解除时间
            ,organization_punishment_deadline -- 组织处理期限
            ,organization_punishment_start_time -- 组织处理处罚时间
            ,organization_punishment_end_time -- 组织处理解除时间
            ,other_punishment_desc -- 处分具体处分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amis_ac_project_punishment_op(
            ac_project_punishment_uuid -- 处分UUID
            ,nishment_code -- 处分编号
            ,ac_project_uuid -- 问责项目uuid
            ,personduty_name -- 责任人名称
            ,ac_personduty_uuid -- 责任人记录ID
            ,old_orgname -- 原所在机构
            ,old_station -- 原岗位
            ,curr_org_uuid -- 现所在机构UUID
            ,curr_org_name -- 现所在机构名称
            ,curr_station -- 现岗位
            ,ac_project_name -- 问责项目名称
            ,account_number -- 问责文号
            ,dispatch_uuid -- 发文UUID
            ,dispatch_name -- 发文标题
            ,dispatch_org -- 发文单位
            ,dispatch_time -- 发文时间
            ,punishment_type -- 处分类型
            ,disciplinary_punishment -- 纪律处分
            ,economic_punishment -- 经济处罚
            ,organization_punishment -- 组织处理
            ,other_punishment -- 其他处分
            ,exemption_punishment -- 免于处分原因
            ,punishment_reason -- 处分原因
            ,exe_org_uuid -- 执行机构UUID
            ,exe_org_name -- 执行机构名称
            ,create_person_uuid -- 处分录入人UUID
            ,create_person_name -- 处分录入人名称
            ,create_date -- 处分录入时间
            ,exe_date -- 提交执行时间
            ,create_org_uuid -- 处分录入机构UUID
            ,create_org_name -- 处分录入机构
            ,deleted -- 删除标识
            ,punishment_ext1 -- 扩展字段1
            ,punishment_ext2 -- 扩展字段2
            ,punishment_type_code -- 处分类型CODE
            ,punishment_ext3 -- 扩展字段3
            ,punishment_ext4 -- 扩展字段4
            ,punishment_ext5 -- 扩展字段5
            ,status -- 状态
            ,disciplinary_punishment_code -- 纪律处分CODE
            ,organization_punishment_code -- 组织处理CODE
            ,other_punishment_code -- 其他处分CODE
            ,punishment_accordance -- 处分依据
            ,disciplinary_punishment_deadline -- 纪律处分期限
            ,disciplinary_punishment_start_time -- 纪律处分处罚时间
            ,disciplinary_punishment_end_time -- 纪律处分解除时间
            ,organization_punishment_deadline -- 组织处理期限
            ,organization_punishment_start_time -- 组织处理处罚时间
            ,organization_punishment_end_time -- 组织处理解除时间
            ,other_punishment_desc -- 处分具体处分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ac_project_punishment_uuid -- 处分UUID
    ,o.nishment_code -- 处分编号
    ,o.ac_project_uuid -- 问责项目uuid
    ,o.personduty_name -- 责任人名称
    ,o.ac_personduty_uuid -- 责任人记录ID
    ,o.old_orgname -- 原所在机构
    ,o.old_station -- 原岗位
    ,o.curr_org_uuid -- 现所在机构UUID
    ,o.curr_org_name -- 现所在机构名称
    ,o.curr_station -- 现岗位
    ,o.ac_project_name -- 问责项目名称
    ,o.account_number -- 问责文号
    ,o.dispatch_uuid -- 发文UUID
    ,o.dispatch_name -- 发文标题
    ,o.dispatch_org -- 发文单位
    ,o.dispatch_time -- 发文时间
    ,o.punishment_type -- 处分类型
    ,o.disciplinary_punishment -- 纪律处分
    ,o.economic_punishment -- 经济处罚
    ,o.organization_punishment -- 组织处理
    ,o.other_punishment -- 其他处分
    ,o.exemption_punishment -- 免于处分原因
    ,o.punishment_reason -- 处分原因
    ,o.exe_org_uuid -- 执行机构UUID
    ,o.exe_org_name -- 执行机构名称
    ,o.create_person_uuid -- 处分录入人UUID
    ,o.create_person_name -- 处分录入人名称
    ,o.create_date -- 处分录入时间
    ,o.exe_date -- 提交执行时间
    ,o.create_org_uuid -- 处分录入机构UUID
    ,o.create_org_name -- 处分录入机构
    ,o.deleted -- 删除标识
    ,o.punishment_ext1 -- 扩展字段1
    ,o.punishment_ext2 -- 扩展字段2
    ,o.punishment_type_code -- 处分类型CODE
    ,o.punishment_ext3 -- 扩展字段3
    ,o.punishment_ext4 -- 扩展字段4
    ,o.punishment_ext5 -- 扩展字段5
    ,o.status -- 状态
    ,o.disciplinary_punishment_code -- 纪律处分CODE
    ,o.organization_punishment_code -- 组织处理CODE
    ,o.other_punishment_code -- 其他处分CODE
    ,o.punishment_accordance -- 处分依据
    ,o.disciplinary_punishment_deadline -- 纪律处分期限
    ,o.disciplinary_punishment_start_time -- 纪律处分处罚时间
    ,o.disciplinary_punishment_end_time -- 纪律处分解除时间
    ,o.organization_punishment_deadline -- 组织处理期限
    ,o.organization_punishment_start_time -- 组织处理处罚时间
    ,o.organization_punishment_end_time -- 组织处理解除时间
    ,o.other_punishment_desc -- 处分具体处分
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
from ${iol_schema}.amis_ac_project_punishment_bk o
    left join ${iol_schema}.amis_ac_project_punishment_op n
        on
            o.ac_project_punishment_uuid = n.ac_project_punishment_uuid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amis_ac_project_punishment_cl d
        on
            o.ac_project_punishment_uuid = d.ac_project_punishment_uuid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amis_ac_project_punishment;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amis_ac_project_punishment') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amis_ac_project_punishment drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amis_ac_project_punishment add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amis_ac_project_punishment exchange partition p_${batch_date} with table ${iol_schema}.amis_ac_project_punishment_cl;
alter table ${iol_schema}.amis_ac_project_punishment exchange partition p_20991231 with table ${iol_schema}.amis_ac_project_punishment_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amis_ac_project_punishment to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amis_ac_project_punishment_op purge;
drop table ${iol_schema}.amis_ac_project_punishment_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amis_ac_project_punishment_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amis_ac_project_punishment',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
