/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_mst_bond_credit_rating
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
create table ${iol_schema}.fams_mst_bond_credit_rating_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_mst_bond_credit_rating
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_mst_bond_credit_rating_op purge;
drop table ${iol_schema}.fams_mst_bond_credit_rating_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_mst_bond_credit_rating_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_mst_bond_credit_rating where 0=1;

create table ${iol_schema}.fams_mst_bond_credit_rating_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_mst_bond_credit_rating where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_mst_bond_credit_rating_cl(
            sec_id -- 债券代码（市场代码）
            ,grade_org_id -- 评级机构
            ,grade_date -- 评级日期
            ,grade_type -- 评级类型，主体评级、债项评级
            ,short_long_term -- 长短期
            ,grade_result -- 评级结果
            ,sec_issue_id -- 债券发行人
            ,input_type -- 录入方式
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,is_recommand -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_mst_bond_credit_rating_op(
            sec_id -- 债券代码（市场代码）
            ,grade_org_id -- 评级机构
            ,grade_date -- 评级日期
            ,grade_type -- 评级类型，主体评级、债项评级
            ,short_long_term -- 长短期
            ,grade_result -- 评级结果
            ,sec_issue_id -- 债券发行人
            ,input_type -- 录入方式
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,is_recommand -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sec_id, o.sec_id) as sec_id -- 债券代码（市场代码）
    ,nvl(n.grade_org_id, o.grade_org_id) as grade_org_id -- 评级机构
    ,nvl(n.grade_date, o.grade_date) as grade_date -- 评级日期
    ,nvl(n.grade_type, o.grade_type) as grade_type -- 评级类型，主体评级、债项评级
    ,nvl(n.short_long_term, o.short_long_term) as short_long_term -- 长短期
    ,nvl(n.grade_result, o.grade_result) as grade_result -- 评级结果
    ,nvl(n.sec_issue_id, o.sec_issue_id) as sec_issue_id -- 债券发行人
    ,nvl(n.input_type, o.input_type) as input_type -- 录入方式
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.is_recommand, o.is_recommand) as is_recommand -- 
    ,case when
            n.sec_id is null
            and n.grade_org_id is null
            and n.grade_date is null
            and n.grade_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sec_id is null
            and n.grade_org_id is null
            and n.grade_date is null
            and n.grade_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sec_id is null
            and n.grade_org_id is null
            and n.grade_date is null
            and n.grade_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_mst_bond_credit_rating_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_mst_bond_credit_rating where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sec_id = n.sec_id
            and o.grade_org_id = n.grade_org_id
            and o.grade_date = n.grade_date
            and o.grade_type = n.grade_type
where (
        o.sec_id is null
        and o.grade_org_id is null
        and o.grade_date is null
        and o.grade_type is null
    )
    or (
        n.sec_id is null
        and n.grade_org_id is null
        and n.grade_date is null
        and n.grade_type is null
    )
    or (
        o.short_long_term <> n.short_long_term
        or o.grade_result <> n.grade_result
        or o.sec_issue_id <> n.sec_issue_id
        or o.input_type <> n.input_type
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.is_recommand <> n.is_recommand
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_mst_bond_credit_rating_cl(
            sec_id -- 债券代码（市场代码）
            ,grade_org_id -- 评级机构
            ,grade_date -- 评级日期
            ,grade_type -- 评级类型，主体评级、债项评级
            ,short_long_term -- 长短期
            ,grade_result -- 评级结果
            ,sec_issue_id -- 债券发行人
            ,input_type -- 录入方式
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,is_recommand -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_mst_bond_credit_rating_op(
            sec_id -- 债券代码（市场代码）
            ,grade_org_id -- 评级机构
            ,grade_date -- 评级日期
            ,grade_type -- 评级类型，主体评级、债项评级
            ,short_long_term -- 长短期
            ,grade_result -- 评级结果
            ,sec_issue_id -- 债券发行人
            ,input_type -- 录入方式
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,is_recommand -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sec_id -- 债券代码（市场代码）
    ,o.grade_org_id -- 评级机构
    ,o.grade_date -- 评级日期
    ,o.grade_type -- 评级类型，主体评级、债项评级
    ,o.short_long_term -- 长短期
    ,o.grade_result -- 评级结果
    ,o.sec_issue_id -- 债券发行人
    ,o.input_type -- 录入方式
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.is_recommand -- 
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
from ${iol_schema}.fams_mst_bond_credit_rating_bk o
    left join ${iol_schema}.fams_mst_bond_credit_rating_op n
        on
            o.sec_id = n.sec_id
            and o.grade_org_id = n.grade_org_id
            and o.grade_date = n.grade_date
            and o.grade_type = n.grade_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_mst_bond_credit_rating_cl d
        on
            o.sec_id = d.sec_id
            and o.grade_org_id = d.grade_org_id
            and o.grade_date = d.grade_date
            and o.grade_type = d.grade_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_mst_bond_credit_rating;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_mst_bond_credit_rating') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_mst_bond_credit_rating drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_mst_bond_credit_rating add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_mst_bond_credit_rating exchange partition p_${batch_date} with table ${iol_schema}.fams_mst_bond_credit_rating_cl;
alter table ${iol_schema}.fams_mst_bond_credit_rating exchange partition p_20991231 with table ${iol_schema}.fams_mst_bond_credit_rating_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_mst_bond_credit_rating to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_mst_bond_credit_rating_op purge;
drop table ${iol_schema}.fams_mst_bond_credit_rating_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_mst_bond_credit_rating_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_mst_bond_credit_rating',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
