/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cd_card_file_job
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
create table ${iol_schema}.ncbs_cd_card_file_job_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cd_card_file_job
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cd_card_file_job_op purge;
drop table ${iol_schema}.ncbs_cd_card_file_job_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cd_card_file_job_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cd_card_file_job where 0=1;

create table ${iol_schema}.ncbs_cd_card_file_job_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cd_card_file_job where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cd_card_file_job_cl(
            file_name -- 文件名称
            ,file_path -- 文件路径
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,user_id -- 交易柜员编号
            ,apply_no -- 申请编号
            ,batch_job_no -- 制卡文件批次号
            ,card_num -- 制卡数量
            ,company -- 法人
            ,file_status -- 文件状态
            ,file_type -- 文件类型
            ,make_card_type -- 制卡类型
            ,same_card_flag -- 是否同号换卡
            ,source_type -- 渠道编号
            ,apply_date -- 申请日期
            ,expire_date -- 失效日期
            ,start_time -- 起始时间
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,card_no_from -- 起始卡号
            ,card_no_thru -- 截止卡号
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cd_card_file_job_op(
            file_name -- 文件名称
            ,file_path -- 文件路径
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,user_id -- 交易柜员编号
            ,apply_no -- 申请编号
            ,batch_job_no -- 制卡文件批次号
            ,card_num -- 制卡数量
            ,company -- 法人
            ,file_status -- 文件状态
            ,file_type -- 文件类型
            ,make_card_type -- 制卡类型
            ,same_card_flag -- 是否同号换卡
            ,source_type -- 渠道编号
            ,apply_date -- 申请日期
            ,expire_date -- 失效日期
            ,start_time -- 起始时间
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,card_no_from -- 起始卡号
            ,card_no_thru -- 截止卡号
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.file_name, o.file_name) as file_name -- 文件名称
    ,nvl(n.file_path, o.file_path) as file_path -- 文件路径
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.apply_no, o.apply_no) as apply_no -- 申请编号
    ,nvl(n.batch_job_no, o.batch_job_no) as batch_job_no -- 制卡文件批次号
    ,nvl(n.card_num, o.card_num) as card_num -- 制卡数量
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.file_status, o.file_status) as file_status -- 文件状态
    ,nvl(n.file_type, o.file_type) as file_type -- 文件类型
    ,nvl(n.make_card_type, o.make_card_type) as make_card_type -- 制卡类型
    ,nvl(n.same_card_flag, o.same_card_flag) as same_card_flag -- 是否同号换卡
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 申请日期
    ,nvl(n.expire_date, o.expire_date) as expire_date -- 失效日期
    ,nvl(n.start_time, o.start_time) as start_time -- 起始时间
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.card_no_from, o.card_no_from) as card_no_from -- 起始卡号
    ,nvl(n.card_no_thru, o.card_no_thru) as card_no_thru -- 截止卡号
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,case when
            n.batch_job_no is null
            and n.file_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.batch_job_no is null
            and n.file_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.batch_job_no is null
            and n.file_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cd_card_file_job_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cd_card_file_job where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.batch_job_no = n.batch_job_no
            and o.file_type = n.file_type
where (
        o.batch_job_no is null
        and o.file_type is null
    )
    or (
        n.batch_job_no is null
        and n.file_type is null
    )
    or (
        o.file_name <> n.file_name
        or o.file_path <> n.file_path
        or o.prod_type <> n.prod_type
        or o.remark <> n.remark
        or o.user_id <> n.user_id
        or o.apply_no <> n.apply_no
        or o.card_num <> n.card_num
        or o.company <> n.company
        or o.file_status <> n.file_status
        or o.make_card_type <> n.make_card_type
        or o.same_card_flag <> n.same_card_flag
        or o.source_type <> n.source_type
        or o.apply_date <> n.apply_date
        or o.expire_date <> n.expire_date
        or o.start_time <> n.start_time
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.card_no_from <> n.card_no_from
        or o.card_no_thru <> n.card_no_thru
        or o.tran_branch <> n.tran_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cd_card_file_job_cl(
            file_name -- 文件名称
            ,file_path -- 文件路径
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,user_id -- 交易柜员编号
            ,apply_no -- 申请编号
            ,batch_job_no -- 制卡文件批次号
            ,card_num -- 制卡数量
            ,company -- 法人
            ,file_status -- 文件状态
            ,file_type -- 文件类型
            ,make_card_type -- 制卡类型
            ,same_card_flag -- 是否同号换卡
            ,source_type -- 渠道编号
            ,apply_date -- 申请日期
            ,expire_date -- 失效日期
            ,start_time -- 起始时间
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,card_no_from -- 起始卡号
            ,card_no_thru -- 截止卡号
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cd_card_file_job_op(
            file_name -- 文件名称
            ,file_path -- 文件路径
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,user_id -- 交易柜员编号
            ,apply_no -- 申请编号
            ,batch_job_no -- 制卡文件批次号
            ,card_num -- 制卡数量
            ,company -- 法人
            ,file_status -- 文件状态
            ,file_type -- 文件类型
            ,make_card_type -- 制卡类型
            ,same_card_flag -- 是否同号换卡
            ,source_type -- 渠道编号
            ,apply_date -- 申请日期
            ,expire_date -- 失效日期
            ,start_time -- 起始时间
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,card_no_from -- 起始卡号
            ,card_no_thru -- 截止卡号
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.file_name -- 文件名称
    ,o.file_path -- 文件路径
    ,o.prod_type -- 产品编号
    ,o.remark -- 备注
    ,o.user_id -- 交易柜员编号
    ,o.apply_no -- 申请编号
    ,o.batch_job_no -- 制卡文件批次号
    ,o.card_num -- 制卡数量
    ,o.company -- 法人
    ,o.file_status -- 文件状态
    ,o.file_type -- 文件类型
    ,o.make_card_type -- 制卡类型
    ,o.same_card_flag -- 是否同号换卡
    ,o.source_type -- 渠道编号
    ,o.apply_date -- 申请日期
    ,o.expire_date -- 失效日期
    ,o.start_time -- 起始时间
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.card_no_from -- 起始卡号
    ,o.card_no_thru -- 截止卡号
    ,o.tran_branch -- 核心交易机构编号
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
from ${iol_schema}.ncbs_cd_card_file_job_bk o
    left join ${iol_schema}.ncbs_cd_card_file_job_op n
        on
            o.batch_job_no = n.batch_job_no
            and o.file_type = n.file_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cd_card_file_job_cl d
        on
            o.batch_job_no = d.batch_job_no
            and o.file_type = d.file_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cd_card_file_job;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cd_card_file_job') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cd_card_file_job drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cd_card_file_job add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cd_card_file_job exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cd_card_file_job_cl;
alter table ${iol_schema}.ncbs_cd_card_file_job exchange partition p_20991231 with table ${iol_schema}.ncbs_cd_card_file_job_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cd_card_file_job to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cd_card_file_job_op purge;
drop table ${iol_schema}.ncbs_cd_card_file_job_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cd_card_file_job_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cd_card_file_job',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
