/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_svss_svs_accadm_sealcard
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
create table ${iol_schema}.svss_svs_accadm_sealcard_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.svss_svs_accadm_sealcard
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.svss_svs_accadm_sealcard_op purge;
drop table ${iol_schema}.svss_svs_accadm_sealcard_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.svss_svs_accadm_sealcard_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.svss_svs_accadm_sealcard where 0=1;

create table ${iol_schema}.svss_svs_accadm_sealcard_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.svss_svs_accadm_sealcard where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.svss_svs_accadm_sealcard_cl(
            id -- 序号
            ,acc_id -- 所属账户ID
            ,seal_count -- 印鉴枚数
            ,start_date -- 印鉴卡启用时间
            ,end_date -- 印鉴卡注销日期
            ,memo -- 备注
            ,card_no -- 印鉴卡号
            ,acc_no -- 所属账户的账号
            ,crud_flag -- 印鉴卡的状态
            ,image_ids -- 印鉴卡图像索引组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.svss_svs_accadm_sealcard_op(
            id -- 序号
            ,acc_id -- 所属账户ID
            ,seal_count -- 印鉴枚数
            ,start_date -- 印鉴卡启用时间
            ,end_date -- 印鉴卡注销日期
            ,memo -- 备注
            ,card_no -- 印鉴卡号
            ,acc_no -- 所属账户的账号
            ,crud_flag -- 印鉴卡的状态
            ,image_ids -- 印鉴卡图像索引组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 序号
    ,nvl(n.acc_id, o.acc_id) as acc_id -- 所属账户ID
    ,nvl(n.seal_count, o.seal_count) as seal_count -- 印鉴枚数
    ,nvl(n.start_date, o.start_date) as start_date -- 印鉴卡启用时间
    ,nvl(n.end_date, o.end_date) as end_date -- 印鉴卡注销日期
    ,nvl(n.memo, o.memo) as memo -- 备注
    ,nvl(n.card_no, o.card_no) as card_no -- 印鉴卡号
    ,nvl(n.acc_no, o.acc_no) as acc_no -- 所属账户的账号
    ,nvl(n.crud_flag, o.crud_flag) as crud_flag -- 印鉴卡的状态
    ,nvl(n.image_ids, o.image_ids) as image_ids -- 印鉴卡图像索引组
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.svss_svs_accadm_sealcard_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.svss_svs_accadm_sealcard where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.acc_id <> n.acc_id
        or o.seal_count <> n.seal_count
        or o.start_date <> n.start_date
        or o.end_date <> n.end_date
        or o.memo <> n.memo
        or o.card_no <> n.card_no
        or o.acc_no <> n.acc_no
        or o.crud_flag <> n.crud_flag
        or o.image_ids <> n.image_ids
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.svss_svs_accadm_sealcard_cl(
            id -- 序号
            ,acc_id -- 所属账户ID
            ,seal_count -- 印鉴枚数
            ,start_date -- 印鉴卡启用时间
            ,end_date -- 印鉴卡注销日期
            ,memo -- 备注
            ,card_no -- 印鉴卡号
            ,acc_no -- 所属账户的账号
            ,crud_flag -- 印鉴卡的状态
            ,image_ids -- 印鉴卡图像索引组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.svss_svs_accadm_sealcard_op(
            id -- 序号
            ,acc_id -- 所属账户ID
            ,seal_count -- 印鉴枚数
            ,start_date -- 印鉴卡启用时间
            ,end_date -- 印鉴卡注销日期
            ,memo -- 备注
            ,card_no -- 印鉴卡号
            ,acc_no -- 所属账户的账号
            ,crud_flag -- 印鉴卡的状态
            ,image_ids -- 印鉴卡图像索引组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 序号
    ,o.acc_id -- 所属账户ID
    ,o.seal_count -- 印鉴枚数
    ,o.start_date -- 印鉴卡启用时间
    ,o.end_date -- 印鉴卡注销日期
    ,o.memo -- 备注
    ,o.card_no -- 印鉴卡号
    ,o.acc_no -- 所属账户的账号
    ,o.crud_flag -- 印鉴卡的状态
    ,o.image_ids -- 印鉴卡图像索引组
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
from ${iol_schema}.svss_svs_accadm_sealcard_bk o
    left join ${iol_schema}.svss_svs_accadm_sealcard_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.svss_svs_accadm_sealcard_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.svss_svs_accadm_sealcard;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('svss_svs_accadm_sealcard') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.svss_svs_accadm_sealcard drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.svss_svs_accadm_sealcard add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.svss_svs_accadm_sealcard exchange partition p_${batch_date} with table ${iol_schema}.svss_svs_accadm_sealcard_cl;
alter table ${iol_schema}.svss_svs_accadm_sealcard exchange partition p_20991231 with table ${iol_schema}.svss_svs_accadm_sealcard_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.svss_svs_accadm_sealcard to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.svss_svs_accadm_sealcard_op purge;
drop table ${iol_schema}.svss_svs_accadm_sealcard_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.svss_svs_accadm_sealcard_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'svss_svs_accadm_sealcard',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
