/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_ban_account_detail
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
create table ${iol_schema}.fams_ban_account_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_ban_account_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ban_account_detail_op purge;
drop table ${iol_schema}.fams_ban_account_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ban_account_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ban_account_detail where 0=1;

create table ${iol_schema}.fams_ban_account_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ban_account_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ban_account_detail_cl(
            vouch_subnum -- 凭证子表编号
            ,vouch_num -- 凭证编号
            ,bus_vouchsubnum -- 业务凭证子表编号
            ,happen_date -- 发生日期
            ,table_id -- 场景代码
            ,cd_flag -- 借贷方向
            ,subject_no -- 科目号
            ,happen_amt -- 发生额
            ,happen_number -- 发生数量
            ,busi_id -- 业务明细代码
            ,ccy -- 币种
            ,trade_id -- 交易编号
            ,detail_subject_no -- 四级科目号
            ,book_type -- 凭证类型
            ,b_happen_amt -- 本位币发生额
            ,b_ccy -- 本位币
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ban_account_detail_op(
            vouch_subnum -- 凭证子表编号
            ,vouch_num -- 凭证编号
            ,bus_vouchsubnum -- 业务凭证子表编号
            ,happen_date -- 发生日期
            ,table_id -- 场景代码
            ,cd_flag -- 借贷方向
            ,subject_no -- 科目号
            ,happen_amt -- 发生额
            ,happen_number -- 发生数量
            ,busi_id -- 业务明细代码
            ,ccy -- 币种
            ,trade_id -- 交易编号
            ,detail_subject_no -- 四级科目号
            ,book_type -- 凭证类型
            ,b_happen_amt -- 本位币发生额
            ,b_ccy -- 本位币
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.vouch_subnum, o.vouch_subnum) as vouch_subnum -- 凭证子表编号
    ,nvl(n.vouch_num, o.vouch_num) as vouch_num -- 凭证编号
    ,nvl(n.bus_vouchsubnum, o.bus_vouchsubnum) as bus_vouchsubnum -- 业务凭证子表编号
    ,nvl(n.happen_date, o.happen_date) as happen_date -- 发生日期
    ,nvl(n.table_id, o.table_id) as table_id -- 场景代码
    ,nvl(n.cd_flag, o.cd_flag) as cd_flag -- 借贷方向
    ,nvl(n.subject_no, o.subject_no) as subject_no -- 科目号
    ,nvl(n.happen_amt, o.happen_amt) as happen_amt -- 发生额
    ,nvl(n.happen_number, o.happen_number) as happen_number -- 发生数量
    ,nvl(n.busi_id, o.busi_id) as busi_id -- 业务明细代码
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.trade_id, o.trade_id) as trade_id -- 交易编号
    ,nvl(n.detail_subject_no, o.detail_subject_no) as detail_subject_no -- 四级科目号
    ,nvl(n.book_type, o.book_type) as book_type -- 凭证类型
    ,nvl(n.b_happen_amt, o.b_happen_amt) as b_happen_amt -- 本位币发生额
    ,nvl(n.b_ccy, o.b_ccy) as b_ccy -- 本位币
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.vouch_subnum is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.vouch_subnum is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.vouch_subnum is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_ban_account_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_ban_account_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.vouch_subnum = n.vouch_subnum
where (
        o.vouch_subnum is null
    )
    or (
        n.vouch_subnum is null
    )
    or (
        o.vouch_num <> n.vouch_num
        or o.bus_vouchsubnum <> n.bus_vouchsubnum
        or o.happen_date <> n.happen_date
        or o.table_id <> n.table_id
        or o.cd_flag <> n.cd_flag
        or o.subject_no <> n.subject_no
        or o.happen_amt <> n.happen_amt
        or o.happen_number <> n.happen_number
        or o.busi_id <> n.busi_id
        or o.ccy <> n.ccy
        or o.trade_id <> n.trade_id
        or o.detail_subject_no <> n.detail_subject_no
        or o.book_type <> n.book_type
        or o.b_happen_amt <> n.b_happen_amt
        or o.b_ccy <> n.b_ccy
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ban_account_detail_cl(
            vouch_subnum -- 凭证子表编号
            ,vouch_num -- 凭证编号
            ,bus_vouchsubnum -- 业务凭证子表编号
            ,happen_date -- 发生日期
            ,table_id -- 场景代码
            ,cd_flag -- 借贷方向
            ,subject_no -- 科目号
            ,happen_amt -- 发生额
            ,happen_number -- 发生数量
            ,busi_id -- 业务明细代码
            ,ccy -- 币种
            ,trade_id -- 交易编号
            ,detail_subject_no -- 四级科目号
            ,book_type -- 凭证类型
            ,b_happen_amt -- 本位币发生额
            ,b_ccy -- 本位币
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ban_account_detail_op(
            vouch_subnum -- 凭证子表编号
            ,vouch_num -- 凭证编号
            ,bus_vouchsubnum -- 业务凭证子表编号
            ,happen_date -- 发生日期
            ,table_id -- 场景代码
            ,cd_flag -- 借贷方向
            ,subject_no -- 科目号
            ,happen_amt -- 发生额
            ,happen_number -- 发生数量
            ,busi_id -- 业务明细代码
            ,ccy -- 币种
            ,trade_id -- 交易编号
            ,detail_subject_no -- 四级科目号
            ,book_type -- 凭证类型
            ,b_happen_amt -- 本位币发生额
            ,b_ccy -- 本位币
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.vouch_subnum -- 凭证子表编号
    ,o.vouch_num -- 凭证编号
    ,o.bus_vouchsubnum -- 业务凭证子表编号
    ,o.happen_date -- 发生日期
    ,o.table_id -- 场景代码
    ,o.cd_flag -- 借贷方向
    ,o.subject_no -- 科目号
    ,o.happen_amt -- 发生额
    ,o.happen_number -- 发生数量
    ,o.busi_id -- 业务明细代码
    ,o.ccy -- 币种
    ,o.trade_id -- 交易编号
    ,o.detail_subject_no -- 四级科目号
    ,o.book_type -- 凭证类型
    ,o.b_happen_amt -- 本位币发生额
    ,o.b_ccy -- 本位币
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
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
from ${iol_schema}.fams_ban_account_detail_bk o
    left join ${iol_schema}.fams_ban_account_detail_op n
        on
            o.vouch_subnum = n.vouch_subnum
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_ban_account_detail_cl d
        on
            o.vouch_subnum = d.vouch_subnum
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_ban_account_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_ban_account_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_ban_account_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_ban_account_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_ban_account_detail exchange partition p_${batch_date} with table ${iol_schema}.fams_ban_account_detail_cl;
alter table ${iol_schema}.fams_ban_account_detail exchange partition p_20991231 with table ${iol_schema}.fams_ban_account_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_ban_account_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ban_account_detail_op purge;
drop table ${iol_schema}.fams_ban_account_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_ban_account_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_ban_account_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
