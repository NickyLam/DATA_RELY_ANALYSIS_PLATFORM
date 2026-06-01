/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cif_channel_control
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
create table ${iol_schema}.ncbs_cif_channel_control_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cif_channel_control
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cif_channel_control_op purge;
drop table ${iol_schema}.ncbs_cif_channel_control_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cif_channel_control_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cif_channel_control where 0=1;

create table ${iol_schema}.ncbs_cif_channel_control_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cif_channel_control where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cif_channel_control_cl(
            control_seq_no -- 控制编号
            ,control_type -- 控制类型
            ,auth_user_id -- 授权柜员
            ,last_change_date -- 最后修改日期
            ,last_change_user_id -- 最后修改柜员
            ,client_no -- 客户编号
            ,tran_branch -- 核心交易机构编号
            ,control_status -- 控制状态
            ,limit_level -- 限制级别
            ,document_id -- 证件号码
            ,start_date -- 开始日期
            ,end_date -- 结束日期
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,narrative -- 摘要
            ,sign_user_id -- 签约柜员
            ,sign_channel -- 签约渠道
            ,out_sign_user_id -- 解约柜员
            ,unlost_time -- 解挂时间
            ,start_date_time -- 生效时间
            ,end_date_time -- 失效时间
            ,oper_narrative -- 操作备注
            ,start_timestamp -- 加限的交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cif_channel_control_op(
            control_seq_no -- 控制编号
            ,control_type -- 控制类型
            ,auth_user_id -- 授权柜员
            ,last_change_date -- 最后修改日期
            ,last_change_user_id -- 最后修改柜员
            ,client_no -- 客户编号
            ,tran_branch -- 核心交易机构编号
            ,control_status -- 控制状态
            ,limit_level -- 限制级别
            ,document_id -- 证件号码
            ,start_date -- 开始日期
            ,end_date -- 结束日期
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,narrative -- 摘要
            ,sign_user_id -- 签约柜员
            ,sign_channel -- 签约渠道
            ,out_sign_user_id -- 解约柜员
            ,unlost_time -- 解挂时间
            ,start_date_time -- 生效时间
            ,end_date_time -- 失效时间
            ,oper_narrative -- 操作备注
            ,start_timestamp -- 加限的交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.control_seq_no, o.control_seq_no) as control_seq_no -- 控制编号
    ,nvl(n.control_type, o.control_type) as control_type -- 控制类型
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.control_status, o.control_status) as control_status -- 控制状态
    ,nvl(n.limit_level, o.limit_level) as limit_level -- 限制级别
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.sign_user_id, o.sign_user_id) as sign_user_id -- 签约柜员
    ,nvl(n.sign_channel, o.sign_channel) as sign_channel -- 签约渠道
    ,nvl(n.out_sign_user_id, o.out_sign_user_id) as out_sign_user_id -- 解约柜员
    ,nvl(n.unlost_time, o.unlost_time) as unlost_time -- 解挂时间
    ,nvl(n.start_date_time, o.start_date_time) as start_date_time -- 生效时间
    ,nvl(n.end_date_time, o.end_date_time) as end_date_time -- 失效时间
    ,nvl(n.oper_narrative, o.oper_narrative) as oper_narrative -- 操作备注
    ,nvl(n.start_timestamp, o.start_timestamp) as start_timestamp -- 加限的交易时间戳
    ,case when
            n.control_seq_no is null
            and n.client_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.control_seq_no is null
            and n.client_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.control_seq_no is null
            and n.client_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cif_channel_control_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cif_channel_control where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.control_seq_no = n.control_seq_no
            and o.client_no = n.client_no
where (
        o.control_seq_no is null
        and o.client_no is null
    )
    or (
        n.control_seq_no is null
        and n.client_no is null
    )
    or (
        o.control_type <> n.control_type
        or o.auth_user_id <> n.auth_user_id
        or o.last_change_date <> n.last_change_date
        or o.last_change_user_id <> n.last_change_user_id
        or o.tran_branch <> n.tran_branch
        or o.control_status <> n.control_status
        or o.limit_level <> n.limit_level
        or o.document_id <> n.document_id
        or o.start_date <> n.start_date
        or o.end_date <> n.end_date
        or o.company <> n.company
        or o.tran_timestamp <> n.tran_timestamp
        or o.narrative <> n.narrative
        or o.sign_user_id <> n.sign_user_id
        or o.sign_channel <> n.sign_channel
        or o.out_sign_user_id <> n.out_sign_user_id
        or o.unlost_time <> n.unlost_time
        or o.start_date_time <> n.start_date_time
        or o.end_date_time <> n.end_date_time
        or o.oper_narrative <> n.oper_narrative
        or o.start_timestamp <> n.start_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cif_channel_control_cl(
            control_seq_no -- 控制编号
            ,control_type -- 控制类型
            ,auth_user_id -- 授权柜员
            ,last_change_date -- 最后修改日期
            ,last_change_user_id -- 最后修改柜员
            ,client_no -- 客户编号
            ,tran_branch -- 核心交易机构编号
            ,control_status -- 控制状态
            ,limit_level -- 限制级别
            ,document_id -- 证件号码
            ,start_date -- 开始日期
            ,end_date -- 结束日期
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,narrative -- 摘要
            ,sign_user_id -- 签约柜员
            ,sign_channel -- 签约渠道
            ,out_sign_user_id -- 解约柜员
            ,unlost_time -- 解挂时间
            ,start_date_time -- 生效时间
            ,end_date_time -- 失效时间
            ,oper_narrative -- 操作备注
            ,start_timestamp -- 加限的交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cif_channel_control_op(
            control_seq_no -- 控制编号
            ,control_type -- 控制类型
            ,auth_user_id -- 授权柜员
            ,last_change_date -- 最后修改日期
            ,last_change_user_id -- 最后修改柜员
            ,client_no -- 客户编号
            ,tran_branch -- 核心交易机构编号
            ,control_status -- 控制状态
            ,limit_level -- 限制级别
            ,document_id -- 证件号码
            ,start_date -- 开始日期
            ,end_date -- 结束日期
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,narrative -- 摘要
            ,sign_user_id -- 签约柜员
            ,sign_channel -- 签约渠道
            ,out_sign_user_id -- 解约柜员
            ,unlost_time -- 解挂时间
            ,start_date_time -- 生效时间
            ,end_date_time -- 失效时间
            ,oper_narrative -- 操作备注
            ,start_timestamp -- 加限的交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.control_seq_no -- 控制编号
    ,o.control_type -- 控制类型
    ,o.auth_user_id -- 授权柜员
    ,o.last_change_date -- 最后修改日期
    ,o.last_change_user_id -- 最后修改柜员
    ,o.client_no -- 客户编号
    ,o.tran_branch -- 核心交易机构编号
    ,o.control_status -- 控制状态
    ,o.limit_level -- 限制级别
    ,o.document_id -- 证件号码
    ,o.start_date -- 开始日期
    ,o.end_date -- 结束日期
    ,o.company -- 法人
    ,o.tran_timestamp -- 交易时间戳
    ,o.narrative -- 摘要
    ,o.sign_user_id -- 签约柜员
    ,o.sign_channel -- 签约渠道
    ,o.out_sign_user_id -- 解约柜员
    ,o.unlost_time -- 解挂时间
    ,o.start_date_time -- 生效时间
    ,o.end_date_time -- 失效时间
    ,o.oper_narrative -- 操作备注
    ,o.start_timestamp -- 加限的交易时间戳
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
from ${iol_schema}.ncbs_cif_channel_control_bk o
    left join ${iol_schema}.ncbs_cif_channel_control_op n
        on
            o.control_seq_no = n.control_seq_no
            and o.client_no = n.client_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cif_channel_control_cl d
        on
            o.control_seq_no = d.control_seq_no
            and o.client_no = d.client_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cif_channel_control;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cif_channel_control') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cif_channel_control drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cif_channel_control add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cif_channel_control exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cif_channel_control_cl;
alter table ${iol_schema}.ncbs_cif_channel_control exchange partition p_20991231 with table ${iol_schema}.ncbs_cif_channel_control_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cif_channel_control to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cif_channel_control_op purge;
drop table ${iol_schema}.ncbs_cif_channel_control_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cif_channel_control_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cif_channel_control',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
