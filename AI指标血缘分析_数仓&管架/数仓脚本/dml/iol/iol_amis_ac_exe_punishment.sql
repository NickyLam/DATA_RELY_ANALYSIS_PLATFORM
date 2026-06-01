/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amis_ac_exe_punishment
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
create table ${iol_schema}.amis_ac_exe_punishment_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amis_ac_exe_punishment
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amis_ac_exe_punishment_op purge;
drop table ${iol_schema}.amis_ac_exe_punishment_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amis_ac_exe_punishment_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amis_ac_exe_punishment where 0=1;

create table ${iol_schema}.amis_ac_exe_punishment_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amis_ac_exe_punishment where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amis_ac_exe_punishment_cl(
            ac_exe_punishment_uuid -- 执行处分UUID
            ,ac_punishment_uuid -- 处分录入UUID,关联处分录入UUID
            ,exe_status_code -- 执行标志CODE;1完全执行、0待执行、2部分执行、3无法执行
            ,exe_status_name -- 执行标志
            ,exe_date -- 执行时间
            ,penalty_amount -- 处罚金额;涉及经济处罚的且为已执行（完全执行、部分执行），填列具体金额，金额需大于等于0，默认为空，单位元
            ,create_person_uuid -- 处分录入人UUID
            ,create_person_name -- 处分录入人名称
            ,create_date -- 处分录入时间
            ,create_org_uuid -- 处分录入机构UUID
            ,create_org_name -- 处分录入机构
            ,deleted -- 删除标识;0未删除 1删除
            ,exe_ext1 -- 扩展字段1
            ,exe_ext2 -- 扩展字段2
            ,exe_ext3 -- 扩展字段3
            ,exe_ext4 -- 扩展字段4
            ,exe_ext5 -- 扩展字段5
            ,status -- 状态;1草稿2审核中3审核完成4退回
            ,reason -- 原因描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amis_ac_exe_punishment_op(
            ac_exe_punishment_uuid -- 执行处分UUID
            ,ac_punishment_uuid -- 处分录入UUID,关联处分录入UUID
            ,exe_status_code -- 执行标志CODE;1完全执行、0待执行、2部分执行、3无法执行
            ,exe_status_name -- 执行标志
            ,exe_date -- 执行时间
            ,penalty_amount -- 处罚金额;涉及经济处罚的且为已执行（完全执行、部分执行），填列具体金额，金额需大于等于0，默认为空，单位元
            ,create_person_uuid -- 处分录入人UUID
            ,create_person_name -- 处分录入人名称
            ,create_date -- 处分录入时间
            ,create_org_uuid -- 处分录入机构UUID
            ,create_org_name -- 处分录入机构
            ,deleted -- 删除标识;0未删除 1删除
            ,exe_ext1 -- 扩展字段1
            ,exe_ext2 -- 扩展字段2
            ,exe_ext3 -- 扩展字段3
            ,exe_ext4 -- 扩展字段4
            ,exe_ext5 -- 扩展字段5
            ,status -- 状态;1草稿2审核中3审核完成4退回
            ,reason -- 原因描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ac_exe_punishment_uuid, o.ac_exe_punishment_uuid) as ac_exe_punishment_uuid -- 执行处分UUID
    ,nvl(n.ac_punishment_uuid, o.ac_punishment_uuid) as ac_punishment_uuid -- 处分录入UUID,关联处分录入UUID
    ,nvl(n.exe_status_code, o.exe_status_code) as exe_status_code -- 执行标志CODE;1完全执行、0待执行、2部分执行、3无法执行
    ,nvl(n.exe_status_name, o.exe_status_name) as exe_status_name -- 执行标志
    ,nvl(n.exe_date, o.exe_date) as exe_date -- 执行时间
    ,nvl(n.penalty_amount, o.penalty_amount) as penalty_amount -- 处罚金额;涉及经济处罚的且为已执行（完全执行、部分执行），填列具体金额，金额需大于等于0，默认为空，单位元
    ,nvl(n.create_person_uuid, o.create_person_uuid) as create_person_uuid -- 处分录入人UUID
    ,nvl(n.create_person_name, o.create_person_name) as create_person_name -- 处分录入人名称
    ,nvl(n.create_date, o.create_date) as create_date -- 处分录入时间
    ,nvl(n.create_org_uuid, o.create_org_uuid) as create_org_uuid -- 处分录入机构UUID
    ,nvl(n.create_org_name, o.create_org_name) as create_org_name -- 处分录入机构
    ,nvl(n.deleted, o.deleted) as deleted -- 删除标识;0未删除 1删除
    ,nvl(n.exe_ext1, o.exe_ext1) as exe_ext1 -- 扩展字段1
    ,nvl(n.exe_ext2, o.exe_ext2) as exe_ext2 -- 扩展字段2
    ,nvl(n.exe_ext3, o.exe_ext3) as exe_ext3 -- 扩展字段3
    ,nvl(n.exe_ext4, o.exe_ext4) as exe_ext4 -- 扩展字段4
    ,nvl(n.exe_ext5, o.exe_ext5) as exe_ext5 -- 扩展字段5
    ,nvl(n.status, o.status) as status -- 状态;1草稿2审核中3审核完成4退回
    ,nvl(n.reason, o.reason) as reason -- 原因描述
    ,case when
            n.ac_exe_punishment_uuid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ac_exe_punishment_uuid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ac_exe_punishment_uuid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amis_ac_exe_punishment_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amis_ac_exe_punishment where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ac_exe_punishment_uuid = n.ac_exe_punishment_uuid
where (
        o.ac_exe_punishment_uuid is null
    )
    or (
        n.ac_exe_punishment_uuid is null
    )
    or (
        o.ac_punishment_uuid <> n.ac_punishment_uuid
        or o.exe_status_code <> n.exe_status_code
        or o.exe_status_name <> n.exe_status_name
        or o.exe_date <> n.exe_date
        or o.penalty_amount <> n.penalty_amount
        or o.create_person_uuid <> n.create_person_uuid
        or o.create_person_name <> n.create_person_name
        or o.create_date <> n.create_date
        or o.create_org_uuid <> n.create_org_uuid
        or o.create_org_name <> n.create_org_name
        or o.deleted <> n.deleted
        or o.exe_ext1 <> n.exe_ext1
        or o.exe_ext2 <> n.exe_ext2
        or o.exe_ext3 <> n.exe_ext3
        or o.exe_ext4 <> n.exe_ext4
        or o.exe_ext5 <> n.exe_ext5
        or o.status <> n.status
        or o.reason <> n.reason
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amis_ac_exe_punishment_cl(
            ac_exe_punishment_uuid -- 执行处分UUID
            ,ac_punishment_uuid -- 处分录入UUID,关联处分录入UUID
            ,exe_status_code -- 执行标志CODE;1完全执行、0待执行、2部分执行、3无法执行
            ,exe_status_name -- 执行标志
            ,exe_date -- 执行时间
            ,penalty_amount -- 处罚金额;涉及经济处罚的且为已执行（完全执行、部分执行），填列具体金额，金额需大于等于0，默认为空，单位元
            ,create_person_uuid -- 处分录入人UUID
            ,create_person_name -- 处分录入人名称
            ,create_date -- 处分录入时间
            ,create_org_uuid -- 处分录入机构UUID
            ,create_org_name -- 处分录入机构
            ,deleted -- 删除标识;0未删除 1删除
            ,exe_ext1 -- 扩展字段1
            ,exe_ext2 -- 扩展字段2
            ,exe_ext3 -- 扩展字段3
            ,exe_ext4 -- 扩展字段4
            ,exe_ext5 -- 扩展字段5
            ,status -- 状态;1草稿2审核中3审核完成4退回
            ,reason -- 原因描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amis_ac_exe_punishment_op(
            ac_exe_punishment_uuid -- 执行处分UUID
            ,ac_punishment_uuid -- 处分录入UUID,关联处分录入UUID
            ,exe_status_code -- 执行标志CODE;1完全执行、0待执行、2部分执行、3无法执行
            ,exe_status_name -- 执行标志
            ,exe_date -- 执行时间
            ,penalty_amount -- 处罚金额;涉及经济处罚的且为已执行（完全执行、部分执行），填列具体金额，金额需大于等于0，默认为空，单位元
            ,create_person_uuid -- 处分录入人UUID
            ,create_person_name -- 处分录入人名称
            ,create_date -- 处分录入时间
            ,create_org_uuid -- 处分录入机构UUID
            ,create_org_name -- 处分录入机构
            ,deleted -- 删除标识;0未删除 1删除
            ,exe_ext1 -- 扩展字段1
            ,exe_ext2 -- 扩展字段2
            ,exe_ext3 -- 扩展字段3
            ,exe_ext4 -- 扩展字段4
            ,exe_ext5 -- 扩展字段5
            ,status -- 状态;1草稿2审核中3审核完成4退回
            ,reason -- 原因描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ac_exe_punishment_uuid -- 执行处分UUID
    ,o.ac_punishment_uuid -- 处分录入UUID,关联处分录入UUID
    ,o.exe_status_code -- 执行标志CODE;1完全执行、0待执行、2部分执行、3无法执行
    ,o.exe_status_name -- 执行标志
    ,o.exe_date -- 执行时间
    ,o.penalty_amount -- 处罚金额;涉及经济处罚的且为已执行（完全执行、部分执行），填列具体金额，金额需大于等于0，默认为空，单位元
    ,o.create_person_uuid -- 处分录入人UUID
    ,o.create_person_name -- 处分录入人名称
    ,o.create_date -- 处分录入时间
    ,o.create_org_uuid -- 处分录入机构UUID
    ,o.create_org_name -- 处分录入机构
    ,o.deleted -- 删除标识;0未删除 1删除
    ,o.exe_ext1 -- 扩展字段1
    ,o.exe_ext2 -- 扩展字段2
    ,o.exe_ext3 -- 扩展字段3
    ,o.exe_ext4 -- 扩展字段4
    ,o.exe_ext5 -- 扩展字段5
    ,o.status -- 状态;1草稿2审核中3审核完成4退回
    ,o.reason -- 原因描述
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
from ${iol_schema}.amis_ac_exe_punishment_bk o
    left join ${iol_schema}.amis_ac_exe_punishment_op n
        on
            o.ac_exe_punishment_uuid = n.ac_exe_punishment_uuid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amis_ac_exe_punishment_cl d
        on
            o.ac_exe_punishment_uuid = d.ac_exe_punishment_uuid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amis_ac_exe_punishment;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amis_ac_exe_punishment') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amis_ac_exe_punishment drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amis_ac_exe_punishment add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amis_ac_exe_punishment exchange partition p_${batch_date} with table ${iol_schema}.amis_ac_exe_punishment_cl;
alter table ${iol_schema}.amis_ac_exe_punishment exchange partition p_20991231 with table ${iol_schema}.amis_ac_exe_punishment_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amis_ac_exe_punishment to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amis_ac_exe_punishment_op purge;
drop table ${iol_schema}.amis_ac_exe_punishment_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amis_ac_exe_punishment_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amis_ac_exe_punishment',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
