/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amis_ac_account_project
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
create table ${iol_schema}.amis_ac_account_project_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amis_ac_account_project
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amis_ac_account_project_op purge;
drop table ${iol_schema}.amis_ac_account_project_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amis_ac_account_project_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amis_ac_account_project where 0=1;

create table ${iol_schema}.amis_ac_account_project_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amis_ac_account_project where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amis_ac_account_project_cl(
            ac_account_project_uuid -- 主键
            ,account_type_code -- 问责类型code
            ,account_type_desc -- 问责类型描述
            ,project_name -- 关联项目
            ,acc_project_code -- 问责项目编号
            ,account_item -- 问责事项
            ,description -- 基本情况
            ,loss_amount -- 损失金额
            ,remarks -- 备注
            ,account_imp_dept -- 问责实施部门
            ,create_person_uuid -- 创建人UUID
            ,create_person_name　 -- 创建人姓名
            ,create_org_name　 -- 创建人机构
            ,create_time　 -- 创建时间
            ,create_org_uuid -- 创建人机构uuid
            ,create_dept -- 创建人部门
            ,create_dept_uuid -- 创建人部门uuid
            ,state -- 审批状态
            ,current_node -- 当前阶段
            ,deleted -- 删除标志位
            ,ext1 -- 扩展字段
            ,ext2 -- 扩展字段
            ,ext3 -- 扩展字段
            ,client_code -- 委托单位CODE
            ,client_desc -- 委托单位
            ,client_date -- 委托日期
            ,project_state -- 项目状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amis_ac_account_project_op(
            ac_account_project_uuid -- 主键
            ,account_type_code -- 问责类型code
            ,account_type_desc -- 问责类型描述
            ,project_name -- 关联项目
            ,acc_project_code -- 问责项目编号
            ,account_item -- 问责事项
            ,description -- 基本情况
            ,loss_amount -- 损失金额
            ,remarks -- 备注
            ,account_imp_dept -- 问责实施部门
            ,create_person_uuid -- 创建人UUID
            ,create_person_name　 -- 创建人姓名
            ,create_org_name　 -- 创建人机构
            ,create_time　 -- 创建时间
            ,create_org_uuid -- 创建人机构uuid
            ,create_dept -- 创建人部门
            ,create_dept_uuid -- 创建人部门uuid
            ,state -- 审批状态
            ,current_node -- 当前阶段
            ,deleted -- 删除标志位
            ,ext1 -- 扩展字段
            ,ext2 -- 扩展字段
            ,ext3 -- 扩展字段
            ,client_code -- 委托单位CODE
            ,client_desc -- 委托单位
            ,client_date -- 委托日期
            ,project_state -- 项目状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ac_account_project_uuid, o.ac_account_project_uuid) as ac_account_project_uuid -- 主键
    ,nvl(n.account_type_code, o.account_type_code) as account_type_code -- 问责类型code
    ,nvl(n.account_type_desc, o.account_type_desc) as account_type_desc -- 问责类型描述
    ,nvl(n.project_name, o.project_name) as project_name -- 关联项目
    ,nvl(n.acc_project_code, o.acc_project_code) as acc_project_code -- 问责项目编号
    ,nvl(n.account_item, o.account_item) as account_item -- 问责事项
    ,nvl(n.description, o.description) as description -- 基本情况
    ,nvl(n.loss_amount, o.loss_amount) as loss_amount -- 损失金额
    ,nvl(n.remarks, o.remarks) as remarks -- 备注
    ,nvl(n.account_imp_dept, o.account_imp_dept) as account_imp_dept -- 问责实施部门
    ,nvl(n.create_person_uuid, o.create_person_uuid) as create_person_uuid -- 创建人UUID
    ,nvl(n.create_person_name　, o.create_person_name　) as create_person_name　 -- 创建人姓名
    ,nvl(n.create_org_name　, o.create_org_name　) as create_org_name　 -- 创建人机构
    ,nvl(n.create_time　, o.create_time　) as create_time　 -- 创建时间
    ,nvl(n.create_org_uuid, o.create_org_uuid) as create_org_uuid -- 创建人机构uuid
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建人部门
    ,nvl(n.create_dept_uuid, o.create_dept_uuid) as create_dept_uuid -- 创建人部门uuid
    ,nvl(n.state, o.state) as state -- 审批状态
    ,nvl(n.current_node, o.current_node) as current_node -- 当前阶段
    ,nvl(n.deleted, o.deleted) as deleted -- 删除标志位
    ,nvl(n.ext1, o.ext1) as ext1 -- 扩展字段
    ,nvl(n.ext2, o.ext2) as ext2 -- 扩展字段
    ,nvl(n.ext3, o.ext3) as ext3 -- 扩展字段
    ,nvl(n.client_code, o.client_code) as client_code -- 委托单位CODE
    ,nvl(n.client_desc, o.client_desc) as client_desc -- 委托单位
    ,nvl(n.client_date, o.client_date) as client_date -- 委托日期
    ,nvl(n.project_state, o.project_state) as project_state -- 项目状态
    ,case when
            n.ac_account_project_uuid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ac_account_project_uuid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ac_account_project_uuid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amis_ac_account_project_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amis_ac_account_project where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ac_account_project_uuid = n.ac_account_project_uuid
where (
        o.ac_account_project_uuid is null
    )
    or (
        n.ac_account_project_uuid is null
    )
    or (
        o.account_type_code <> n.account_type_code
        or o.account_type_desc <> n.account_type_desc
        or o.project_name <> n.project_name
        or o.acc_project_code <> n.acc_project_code
        or o.account_item <> n.account_item
        or o.description <> n.description
        or o.loss_amount <> n.loss_amount
        or o.remarks <> n.remarks
        or o.account_imp_dept <> n.account_imp_dept
        or o.create_person_uuid <> n.create_person_uuid
        or o.create_person_name　 <> n.create_person_name　
        or o.create_org_name　 <> n.create_org_name　
        or o.create_time　 <> n.create_time　
        or o.create_org_uuid <> n.create_org_uuid
        or o.create_dept <> n.create_dept
        or o.create_dept_uuid <> n.create_dept_uuid
        or o.state <> n.state
        or o.current_node <> n.current_node
        or o.deleted <> n.deleted
        or o.ext1 <> n.ext1
        or o.ext2 <> n.ext2
        or o.ext3 <> n.ext3
        or o.client_code <> n.client_code
        or o.client_desc <> n.client_desc
        or o.client_date <> n.client_date
        or o.project_state <> n.project_state
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amis_ac_account_project_cl(
            ac_account_project_uuid -- 主键
            ,account_type_code -- 问责类型code
            ,account_type_desc -- 问责类型描述
            ,project_name -- 关联项目
            ,acc_project_code -- 问责项目编号
            ,account_item -- 问责事项
            ,description -- 基本情况
            ,loss_amount -- 损失金额
            ,remarks -- 备注
            ,account_imp_dept -- 问责实施部门
            ,create_person_uuid -- 创建人UUID
            ,create_person_name　 -- 创建人姓名
            ,create_org_name　 -- 创建人机构
            ,create_time　 -- 创建时间
            ,create_org_uuid -- 创建人机构uuid
            ,create_dept -- 创建人部门
            ,create_dept_uuid -- 创建人部门uuid
            ,state -- 审批状态
            ,current_node -- 当前阶段
            ,deleted -- 删除标志位
            ,ext1 -- 扩展字段
            ,ext2 -- 扩展字段
            ,ext3 -- 扩展字段
            ,client_code -- 委托单位CODE
            ,client_desc -- 委托单位
            ,client_date -- 委托日期
            ,project_state -- 项目状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amis_ac_account_project_op(
            ac_account_project_uuid -- 主键
            ,account_type_code -- 问责类型code
            ,account_type_desc -- 问责类型描述
            ,project_name -- 关联项目
            ,acc_project_code -- 问责项目编号
            ,account_item -- 问责事项
            ,description -- 基本情况
            ,loss_amount -- 损失金额
            ,remarks -- 备注
            ,account_imp_dept -- 问责实施部门
            ,create_person_uuid -- 创建人UUID
            ,create_person_name　 -- 创建人姓名
            ,create_org_name　 -- 创建人机构
            ,create_time　 -- 创建时间
            ,create_org_uuid -- 创建人机构uuid
            ,create_dept -- 创建人部门
            ,create_dept_uuid -- 创建人部门uuid
            ,state -- 审批状态
            ,current_node -- 当前阶段
            ,deleted -- 删除标志位
            ,ext1 -- 扩展字段
            ,ext2 -- 扩展字段
            ,ext3 -- 扩展字段
            ,client_code -- 委托单位CODE
            ,client_desc -- 委托单位
            ,client_date -- 委托日期
            ,project_state -- 项目状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ac_account_project_uuid -- 主键
    ,o.account_type_code -- 问责类型code
    ,o.account_type_desc -- 问责类型描述
    ,o.project_name -- 关联项目
    ,o.acc_project_code -- 问责项目编号
    ,o.account_item -- 问责事项
    ,o.description -- 基本情况
    ,o.loss_amount -- 损失金额
    ,o.remarks -- 备注
    ,o.account_imp_dept -- 问责实施部门
    ,o.create_person_uuid -- 创建人UUID
    ,o.create_person_name　 -- 创建人姓名
    ,o.create_org_name　 -- 创建人机构
    ,o.create_time　 -- 创建时间
    ,o.create_org_uuid -- 创建人机构uuid
    ,o.create_dept -- 创建人部门
    ,o.create_dept_uuid -- 创建人部门uuid
    ,o.state -- 审批状态
    ,o.current_node -- 当前阶段
    ,o.deleted -- 删除标志位
    ,o.ext1 -- 扩展字段
    ,o.ext2 -- 扩展字段
    ,o.ext3 -- 扩展字段
    ,o.client_code -- 委托单位CODE
    ,o.client_desc -- 委托单位
    ,o.client_date -- 委托日期
    ,o.project_state -- 项目状态
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
from ${iol_schema}.amis_ac_account_project_bk o
    left join ${iol_schema}.amis_ac_account_project_op n
        on
            o.ac_account_project_uuid = n.ac_account_project_uuid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amis_ac_account_project_cl d
        on
            o.ac_account_project_uuid = d.ac_account_project_uuid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amis_ac_account_project;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amis_ac_account_project') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amis_ac_account_project drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amis_ac_account_project add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amis_ac_account_project exchange partition p_${batch_date} with table ${iol_schema}.amis_ac_account_project_cl;
alter table ${iol_schema}.amis_ac_account_project exchange partition p_20991231 with table ${iol_schema}.amis_ac_account_project_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amis_ac_account_project to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amis_ac_account_project_op purge;
drop table ${iol_schema}.amis_ac_account_project_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amis_ac_account_project_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amis_ac_account_project',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
