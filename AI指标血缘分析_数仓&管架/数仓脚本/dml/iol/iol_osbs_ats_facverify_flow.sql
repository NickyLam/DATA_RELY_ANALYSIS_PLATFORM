/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_ats_facverify_flow
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
create table ${iol_schema}.osbs_ats_facverify_flow_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_ats_facverify_flow
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_ats_facverify_flow_op purge;
drop table ${iol_schema}.osbs_ats_facverify_flow_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_ats_facverify_flow_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_ats_facverify_flow where 0=1;

create table ${iol_schema}.osbs_ats_facverify_flow_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_ats_facverify_flow where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_ats_facverify_flow_cl(
            aff_flowno -- 验证流水号：FAC+时间yyyymmddHHmmssSSS+12位序列号ATS_VERIFY_SEQ_NO
            ,aff_ecifno -- 客户号
            ,aff_state -- 流水状态 0：生效 ；1：失效 ; 2:已通过验证
            ,aff_verifycount -- 验证次数
            ,aff_createtime -- 流水创建时间
            ,aff_updatetime -- 上次更新时间
            ,aff_channel -- 验证渠道
            ,aff_trantype -- 交易类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_ats_facverify_flow_op(
            aff_flowno -- 验证流水号：FAC+时间yyyymmddHHmmssSSS+12位序列号ATS_VERIFY_SEQ_NO
            ,aff_ecifno -- 客户号
            ,aff_state -- 流水状态 0：生效 ；1：失效 ; 2:已通过验证
            ,aff_verifycount -- 验证次数
            ,aff_createtime -- 流水创建时间
            ,aff_updatetime -- 上次更新时间
            ,aff_channel -- 验证渠道
            ,aff_trantype -- 交易类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.aff_flowno, o.aff_flowno) as aff_flowno -- 验证流水号：FAC+时间yyyymmddHHmmssSSS+12位序列号ATS_VERIFY_SEQ_NO
    ,nvl(n.aff_ecifno, o.aff_ecifno) as aff_ecifno -- 客户号
    ,nvl(n.aff_state, o.aff_state) as aff_state -- 流水状态 0：生效 ；1：失效 ; 2:已通过验证
    ,nvl(n.aff_verifycount, o.aff_verifycount) as aff_verifycount -- 验证次数
    ,nvl(n.aff_createtime, o.aff_createtime) as aff_createtime -- 流水创建时间
    ,nvl(n.aff_updatetime, o.aff_updatetime) as aff_updatetime -- 上次更新时间
    ,nvl(n.aff_channel, o.aff_channel) as aff_channel -- 验证渠道
    ,nvl(n.aff_trantype, o.aff_trantype) as aff_trantype -- 交易类型
    ,case when
            n.aff_flowno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.aff_flowno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.aff_flowno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_ats_facverify_flow_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_ats_facverify_flow where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.aff_flowno = n.aff_flowno
where (
        o.aff_flowno is null
    )
    or (
        n.aff_flowno is null
    )
    or (
        o.aff_ecifno <> n.aff_ecifno
        or o.aff_state <> n.aff_state
        or o.aff_verifycount <> n.aff_verifycount
        or o.aff_createtime <> n.aff_createtime
        or o.aff_updatetime <> n.aff_updatetime
        or o.aff_channel <> n.aff_channel
        or o.aff_trantype <> n.aff_trantype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_ats_facverify_flow_cl(
            aff_flowno -- 验证流水号：FAC+时间yyyymmddHHmmssSSS+12位序列号ATS_VERIFY_SEQ_NO
            ,aff_ecifno -- 客户号
            ,aff_state -- 流水状态 0：生效 ；1：失效 ; 2:已通过验证
            ,aff_verifycount -- 验证次数
            ,aff_createtime -- 流水创建时间
            ,aff_updatetime -- 上次更新时间
            ,aff_channel -- 验证渠道
            ,aff_trantype -- 交易类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_ats_facverify_flow_op(
            aff_flowno -- 验证流水号：FAC+时间yyyymmddHHmmssSSS+12位序列号ATS_VERIFY_SEQ_NO
            ,aff_ecifno -- 客户号
            ,aff_state -- 流水状态 0：生效 ；1：失效 ; 2:已通过验证
            ,aff_verifycount -- 验证次数
            ,aff_createtime -- 流水创建时间
            ,aff_updatetime -- 上次更新时间
            ,aff_channel -- 验证渠道
            ,aff_trantype -- 交易类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.aff_flowno -- 验证流水号：FAC+时间yyyymmddHHmmssSSS+12位序列号ATS_VERIFY_SEQ_NO
    ,o.aff_ecifno -- 客户号
    ,o.aff_state -- 流水状态 0：生效 ；1：失效 ; 2:已通过验证
    ,o.aff_verifycount -- 验证次数
    ,o.aff_createtime -- 流水创建时间
    ,o.aff_updatetime -- 上次更新时间
    ,o.aff_channel -- 验证渠道
    ,o.aff_trantype -- 交易类型
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
from ${iol_schema}.osbs_ats_facverify_flow_bk o
    left join ${iol_schema}.osbs_ats_facverify_flow_op n
        on
            o.aff_flowno = n.aff_flowno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_ats_facverify_flow_cl d
        on
            o.aff_flowno = d.aff_flowno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.osbs_ats_facverify_flow;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('osbs_ats_facverify_flow') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.osbs_ats_facverify_flow drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.osbs_ats_facverify_flow add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.osbs_ats_facverify_flow exchange partition p_${batch_date} with table ${iol_schema}.osbs_ats_facverify_flow_cl;
alter table ${iol_schema}.osbs_ats_facverify_flow exchange partition p_20991231 with table ${iol_schema}.osbs_ats_facverify_flow_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_ats_facverify_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_ats_facverify_flow_op purge;
drop table ${iol_schema}.osbs_ats_facverify_flow_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_ats_facverify_flow_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_ats_facverify_flow',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
