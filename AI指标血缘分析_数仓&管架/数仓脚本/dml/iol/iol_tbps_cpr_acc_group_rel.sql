/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_acc_group_rel
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
create table ${iol_schema}.tbps_cpr_acc_group_rel_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_acc_group_rel
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_acc_group_rel_op purge;
drop table ${iol_schema}.tbps_cpr_acc_group_rel_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_acc_group_rel_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_acc_group_rel where 0=1;

create table ${iol_schema}.tbps_cpr_acc_group_rel_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_acc_group_rel where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_acc_group_rel_cl(
            agr_accountno -- 账号
            ,agr_ecifno -- 客户号
            ,agr_channel -- 渠道
            ,agr_grpid -- 功能组
            ,agr_authmodel -- 审核流程模板 1：模板一：单一授权（取消该模板）2：模板二：互为授权3：模板三：多重授权（取消该模板）4：模板四：自定义
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_acc_group_rel_op(
            agr_accountno -- 账号
            ,agr_ecifno -- 客户号
            ,agr_channel -- 渠道
            ,agr_grpid -- 功能组
            ,agr_authmodel -- 审核流程模板 1：模板一：单一授权（取消该模板）2：模板二：互为授权3：模板三：多重授权（取消该模板）4：模板四：自定义
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agr_accountno, o.agr_accountno) as agr_accountno -- 账号
    ,nvl(n.agr_ecifno, o.agr_ecifno) as agr_ecifno -- 客户号
    ,nvl(n.agr_channel, o.agr_channel) as agr_channel -- 渠道
    ,nvl(n.agr_grpid, o.agr_grpid) as agr_grpid -- 功能组
    ,nvl(n.agr_authmodel, o.agr_authmodel) as agr_authmodel -- 审核流程模板 1：模板一：单一授权（取消该模板）2：模板二：互为授权3：模板三：多重授权（取消该模板）4：模板四：自定义
    ,case when
            n.agr_accountno is null
            and n.agr_ecifno is null
            and n.agr_grpid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agr_accountno is null
            and n.agr_ecifno is null
            and n.agr_grpid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agr_accountno is null
            and n.agr_ecifno is null
            and n.agr_grpid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_acc_group_rel_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_acc_group_rel where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.agr_accountno = n.agr_accountno
            and o.agr_ecifno = n.agr_ecifno
            and o.agr_grpid = n.agr_grpid
where (
        o.agr_accountno is null
        and o.agr_ecifno is null
        and o.agr_grpid is null
    )
    or (
        n.agr_accountno is null
        and n.agr_ecifno is null
        and n.agr_grpid is null
    )
    or (
        o.agr_channel <> n.agr_channel
        or o.agr_authmodel <> n.agr_authmodel
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_acc_group_rel_cl(
            agr_accountno -- 账号
            ,agr_ecifno -- 客户号
            ,agr_channel -- 渠道
            ,agr_grpid -- 功能组
            ,agr_authmodel -- 审核流程模板 1：模板一：单一授权（取消该模板）2：模板二：互为授权3：模板三：多重授权（取消该模板）4：模板四：自定义
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_acc_group_rel_op(
            agr_accountno -- 账号
            ,agr_ecifno -- 客户号
            ,agr_channel -- 渠道
            ,agr_grpid -- 功能组
            ,agr_authmodel -- 审核流程模板 1：模板一：单一授权（取消该模板）2：模板二：互为授权3：模板三：多重授权（取消该模板）4：模板四：自定义
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agr_accountno -- 账号
    ,o.agr_ecifno -- 客户号
    ,o.agr_channel -- 渠道
    ,o.agr_grpid -- 功能组
    ,o.agr_authmodel -- 审核流程模板 1：模板一：单一授权（取消该模板）2：模板二：互为授权3：模板三：多重授权（取消该模板）4：模板四：自定义
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
from ${iol_schema}.tbps_cpr_acc_group_rel_bk o
    left join ${iol_schema}.tbps_cpr_acc_group_rel_op n
        on
            o.agr_accountno = n.agr_accountno
            and o.agr_ecifno = n.agr_ecifno
            and o.agr_grpid = n.agr_grpid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_acc_group_rel_cl d
        on
            o.agr_accountno = d.agr_accountno
            and o.agr_ecifno = d.agr_ecifno
            and o.agr_grpid = d.agr_grpid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tbps_cpr_acc_group_rel;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tbps_cpr_acc_group_rel') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tbps_cpr_acc_group_rel drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tbps_cpr_acc_group_rel add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tbps_cpr_acc_group_rel exchange partition p_${batch_date} with table ${iol_schema}.tbps_cpr_acc_group_rel_cl;
alter table ${iol_schema}.tbps_cpr_acc_group_rel exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_acc_group_rel_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_acc_group_rel to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_acc_group_rel_op purge;
drop table ${iol_schema}.tbps_cpr_acc_group_rel_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_acc_group_rel_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_acc_group_rel',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
