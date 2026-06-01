/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t2f_staff
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
create table ${iol_schema}.amls_t2f_staff_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amls_t2f_staff
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t2f_staff_op purge;
drop table ${iol_schema}.amls_t2f_staff_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2f_staff_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t2f_staff where 0=1;

create table ${iol_schema}.amls_t2f_staff_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t2f_staff where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t2f_staff_cl(
            staf_id -- 员工编号
            ,opr_id -- 柜员编号
            ,staf_name -- 员工姓名
            ,cust_id -- 员工客户编号
            ,org_id -- 机构编号
            ,dept -- 所属部门
            ,staf_lvl -- 员工级别
            ,staf_duty -- 员工职务
            ,staf_tel -- 联系电话
            ,cert_type -- 证件类型
            ,cert_no -- 证件号码
            ,entry_dt -- 入职日期
            ,leave_dt -- 离职日期
            ,sex -- 性别
            ,marriage -- 婚姻
            ,politic -- 政治面貌
            ,post_name -- 岗位
            ,work_dt -- 参加日期
            ,rsrv_01 -- 备用字段1-员工类型
            ,rsrv_02 -- 备用字段2
            ,rsrv_03 -- 备用字段3
            ,rsrv_04 -- 备用字段4
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t2f_staff_op(
            staf_id -- 员工编号
            ,opr_id -- 柜员编号
            ,staf_name -- 员工姓名
            ,cust_id -- 员工客户编号
            ,org_id -- 机构编号
            ,dept -- 所属部门
            ,staf_lvl -- 员工级别
            ,staf_duty -- 员工职务
            ,staf_tel -- 联系电话
            ,cert_type -- 证件类型
            ,cert_no -- 证件号码
            ,entry_dt -- 入职日期
            ,leave_dt -- 离职日期
            ,sex -- 性别
            ,marriage -- 婚姻
            ,politic -- 政治面貌
            ,post_name -- 岗位
            ,work_dt -- 参加日期
            ,rsrv_01 -- 备用字段1-员工类型
            ,rsrv_02 -- 备用字段2
            ,rsrv_03 -- 备用字段3
            ,rsrv_04 -- 备用字段4
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.staf_id, o.staf_id) as staf_id -- 员工编号
    ,nvl(n.opr_id, o.opr_id) as opr_id -- 柜员编号
    ,nvl(n.staf_name, o.staf_name) as staf_name -- 员工姓名
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 员工客户编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.dept, o.dept) as dept -- 所属部门
    ,nvl(n.staf_lvl, o.staf_lvl) as staf_lvl -- 员工级别
    ,nvl(n.staf_duty, o.staf_duty) as staf_duty -- 员工职务
    ,nvl(n.staf_tel, o.staf_tel) as staf_tel -- 联系电话
    ,nvl(n.cert_type, o.cert_type) as cert_type -- 证件类型
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.entry_dt, o.entry_dt) as entry_dt -- 入职日期
    ,nvl(n.leave_dt, o.leave_dt) as leave_dt -- 离职日期
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.marriage, o.marriage) as marriage -- 婚姻
    ,nvl(n.politic, o.politic) as politic -- 政治面貌
    ,nvl(n.post_name, o.post_name) as post_name -- 岗位
    ,nvl(n.work_dt, o.work_dt) as work_dt -- 参加日期
    ,nvl(n.rsrv_01, o.rsrv_01) as rsrv_01 -- 备用字段1-员工类型
    ,nvl(n.rsrv_02, o.rsrv_02) as rsrv_02 -- 备用字段2
    ,nvl(n.rsrv_03, o.rsrv_03) as rsrv_03 -- 备用字段3
    ,nvl(n.rsrv_04, o.rsrv_04) as rsrv_04 -- 备用字段4
    ,case when
            n.staf_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.staf_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.staf_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amls_t2f_staff_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amls_t2f_staff where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.staf_id = n.staf_id
where (
        o.staf_id is null
    )
    or (
        n.staf_id is null
    )
    or (
        o.opr_id <> n.opr_id
        or o.staf_name <> n.staf_name
        or o.cust_id <> n.cust_id
        or o.org_id <> n.org_id
        or o.dept <> n.dept
        or o.staf_lvl <> n.staf_lvl
        or o.staf_duty <> n.staf_duty
        or o.staf_tel <> n.staf_tel
        or o.cert_type <> n.cert_type
        or o.cert_no <> n.cert_no
        or o.entry_dt <> n.entry_dt
        or o.leave_dt <> n.leave_dt
        or o.sex <> n.sex
        or o.marriage <> n.marriage
        or o.politic <> n.politic
        or o.post_name <> n.post_name
        or o.work_dt <> n.work_dt
        or o.rsrv_01 <> n.rsrv_01
        or o.rsrv_02 <> n.rsrv_02
        or o.rsrv_03 <> n.rsrv_03
        or o.rsrv_04 <> n.rsrv_04
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t2f_staff_cl(
            staf_id -- 员工编号
            ,opr_id -- 柜员编号
            ,staf_name -- 员工姓名
            ,cust_id -- 员工客户编号
            ,org_id -- 机构编号
            ,dept -- 所属部门
            ,staf_lvl -- 员工级别
            ,staf_duty -- 员工职务
            ,staf_tel -- 联系电话
            ,cert_type -- 证件类型
            ,cert_no -- 证件号码
            ,entry_dt -- 入职日期
            ,leave_dt -- 离职日期
            ,sex -- 性别
            ,marriage -- 婚姻
            ,politic -- 政治面貌
            ,post_name -- 岗位
            ,work_dt -- 参加日期
            ,rsrv_01 -- 备用字段1-员工类型
            ,rsrv_02 -- 备用字段2
            ,rsrv_03 -- 备用字段3
            ,rsrv_04 -- 备用字段4
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t2f_staff_op(
            staf_id -- 员工编号
            ,opr_id -- 柜员编号
            ,staf_name -- 员工姓名
            ,cust_id -- 员工客户编号
            ,org_id -- 机构编号
            ,dept -- 所属部门
            ,staf_lvl -- 员工级别
            ,staf_duty -- 员工职务
            ,staf_tel -- 联系电话
            ,cert_type -- 证件类型
            ,cert_no -- 证件号码
            ,entry_dt -- 入职日期
            ,leave_dt -- 离职日期
            ,sex -- 性别
            ,marriage -- 婚姻
            ,politic -- 政治面貌
            ,post_name -- 岗位
            ,work_dt -- 参加日期
            ,rsrv_01 -- 备用字段1-员工类型
            ,rsrv_02 -- 备用字段2
            ,rsrv_03 -- 备用字段3
            ,rsrv_04 -- 备用字段4
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.staf_id -- 员工编号
    ,o.opr_id -- 柜员编号
    ,o.staf_name -- 员工姓名
    ,o.cust_id -- 员工客户编号
    ,o.org_id -- 机构编号
    ,o.dept -- 所属部门
    ,o.staf_lvl -- 员工级别
    ,o.staf_duty -- 员工职务
    ,o.staf_tel -- 联系电话
    ,o.cert_type -- 证件类型
    ,o.cert_no -- 证件号码
    ,o.entry_dt -- 入职日期
    ,o.leave_dt -- 离职日期
    ,o.sex -- 性别
    ,o.marriage -- 婚姻
    ,o.politic -- 政治面貌
    ,o.post_name -- 岗位
    ,o.work_dt -- 参加日期
    ,o.rsrv_01 -- 备用字段1-员工类型
    ,o.rsrv_02 -- 备用字段2
    ,o.rsrv_03 -- 备用字段3
    ,o.rsrv_04 -- 备用字段4
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
from ${iol_schema}.amls_t2f_staff_bk o
    left join ${iol_schema}.amls_t2f_staff_op n
        on
            o.staf_id = n.staf_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amls_t2f_staff_cl d
        on
            o.staf_id = d.staf_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amls_t2f_staff;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amls_t2f_staff') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amls_t2f_staff drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amls_t2f_staff add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amls_t2f_staff exchange partition p_${batch_date} with table ${iol_schema}.amls_t2f_staff_cl;
alter table ${iol_schema}.amls_t2f_staff exchange partition p_20991231 with table ${iol_schema}.amls_t2f_staff_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t2f_staff to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t2f_staff_op purge;
drop table ${iol_schema}.amls_t2f_staff_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amls_t2f_staff_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t2f_staff',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
