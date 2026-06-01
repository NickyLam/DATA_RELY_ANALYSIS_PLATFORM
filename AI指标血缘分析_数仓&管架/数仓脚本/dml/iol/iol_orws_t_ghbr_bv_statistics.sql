/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orws_t_ghbr_bv_statistics
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
create table ${iol_schema}.orws_t_ghbr_bv_statistics_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.orws_t_ghbr_bv_statistics
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_t_ghbr_bv_statistics_op purge;
drop table ${iol_schema}.orws_t_ghbr_bv_statistics_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_t_ghbr_bv_statistics_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_t_ghbr_bv_statistics where 0=1;

create table ${iol_schema}.orws_t_ghbr_bv_statistics_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_t_ghbr_bv_statistics where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_t_ghbr_bv_statistics_cl(
            id -- 主键
            ,data_date -- 
            ,data_type -- 
            ,is_shield -- 
            ,hb_num -- 
            ,hb_name -- 
            ,bb_num -- 
            ,bb_name -- 
            ,sb_num -- 
            ,sb_name -- 
            ,organ_num -- 
            ,organ_name -- 
            ,display_num -- 
            ,display_name -- 
            ,total_txnvol -- 
            ,total_weight_txnvol -- 
            ,cbss_txnvol -- 
            ,cbss_weight_txnvol -- 
            ,pwbs_txnvol -- 
            ,pwbs_weight_txnvol -- 
            ,ifms_txnvol -- 
            ,ifms_weight_txnvol -- 
            ,pbss_txnvol -- 
            ,pbss_weight_txnvol -- 
            ,isbs_txnvol -- 
            ,isbs_weight_txnvol -- 
            ,crss_txnvol -- 
            ,crss_weight_txnvol -- 
            ,svss_txnvol -- 
            ,svss_weight_txnvol -- 
            ,amls_txnvol -- 
            ,amls_weight_txnvol -- 
            ,bdms_txnvol -- 
            ,bdms_weight_txnvol -- 
            ,mpcs_txnvol -- 
            ,mpcs_weight_txnvol -- 
            ,ma_txnvol -- 
            ,ma_weight_txnvol -- 
            ,period_type -- 
            ,teller_type -- 
            ,auto_txnvol -- 
            ,auto_weight_txnvol -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_t_ghbr_bv_statistics_op(
            id -- 主键
            ,data_date -- 
            ,data_type -- 
            ,is_shield -- 
            ,hb_num -- 
            ,hb_name -- 
            ,bb_num -- 
            ,bb_name -- 
            ,sb_num -- 
            ,sb_name -- 
            ,organ_num -- 
            ,organ_name -- 
            ,display_num -- 
            ,display_name -- 
            ,total_txnvol -- 
            ,total_weight_txnvol -- 
            ,cbss_txnvol -- 
            ,cbss_weight_txnvol -- 
            ,pwbs_txnvol -- 
            ,pwbs_weight_txnvol -- 
            ,ifms_txnvol -- 
            ,ifms_weight_txnvol -- 
            ,pbss_txnvol -- 
            ,pbss_weight_txnvol -- 
            ,isbs_txnvol -- 
            ,isbs_weight_txnvol -- 
            ,crss_txnvol -- 
            ,crss_weight_txnvol -- 
            ,svss_txnvol -- 
            ,svss_weight_txnvol -- 
            ,amls_txnvol -- 
            ,amls_weight_txnvol -- 
            ,bdms_txnvol -- 
            ,bdms_weight_txnvol -- 
            ,mpcs_txnvol -- 
            ,mpcs_weight_txnvol -- 
            ,ma_txnvol -- 
            ,ma_weight_txnvol -- 
            ,period_type -- 
            ,teller_type -- 
            ,auto_txnvol -- 
            ,auto_weight_txnvol -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.data_date, o.data_date) as data_date -- 
    ,nvl(n.data_type, o.data_type) as data_type -- 
    ,nvl(n.is_shield, o.is_shield) as is_shield -- 
    ,nvl(n.hb_num, o.hb_num) as hb_num -- 
    ,nvl(n.hb_name, o.hb_name) as hb_name -- 
    ,nvl(n.bb_num, o.bb_num) as bb_num -- 
    ,nvl(n.bb_name, o.bb_name) as bb_name -- 
    ,nvl(n.sb_num, o.sb_num) as sb_num -- 
    ,nvl(n.sb_name, o.sb_name) as sb_name -- 
    ,nvl(n.organ_num, o.organ_num) as organ_num -- 
    ,nvl(n.organ_name, o.organ_name) as organ_name -- 
    ,nvl(n.display_num, o.display_num) as display_num -- 
    ,nvl(n.display_name, o.display_name) as display_name -- 
    ,nvl(n.total_txnvol, o.total_txnvol) as total_txnvol -- 
    ,nvl(n.total_weight_txnvol, o.total_weight_txnvol) as total_weight_txnvol -- 
    ,nvl(n.cbss_txnvol, o.cbss_txnvol) as cbss_txnvol -- 
    ,nvl(n.cbss_weight_txnvol, o.cbss_weight_txnvol) as cbss_weight_txnvol -- 
    ,nvl(n.pwbs_txnvol, o.pwbs_txnvol) as pwbs_txnvol -- 
    ,nvl(n.pwbs_weight_txnvol, o.pwbs_weight_txnvol) as pwbs_weight_txnvol -- 
    ,nvl(n.ifms_txnvol, o.ifms_txnvol) as ifms_txnvol -- 
    ,nvl(n.ifms_weight_txnvol, o.ifms_weight_txnvol) as ifms_weight_txnvol -- 
    ,nvl(n.pbss_txnvol, o.pbss_txnvol) as pbss_txnvol -- 
    ,nvl(n.pbss_weight_txnvol, o.pbss_weight_txnvol) as pbss_weight_txnvol -- 
    ,nvl(n.isbs_txnvol, o.isbs_txnvol) as isbs_txnvol -- 
    ,nvl(n.isbs_weight_txnvol, o.isbs_weight_txnvol) as isbs_weight_txnvol -- 
    ,nvl(n.crss_txnvol, o.crss_txnvol) as crss_txnvol -- 
    ,nvl(n.crss_weight_txnvol, o.crss_weight_txnvol) as crss_weight_txnvol -- 
    ,nvl(n.svss_txnvol, o.svss_txnvol) as svss_txnvol -- 
    ,nvl(n.svss_weight_txnvol, o.svss_weight_txnvol) as svss_weight_txnvol -- 
    ,nvl(n.amls_txnvol, o.amls_txnvol) as amls_txnvol -- 
    ,nvl(n.amls_weight_txnvol, o.amls_weight_txnvol) as amls_weight_txnvol -- 
    ,nvl(n.bdms_txnvol, o.bdms_txnvol) as bdms_txnvol -- 
    ,nvl(n.bdms_weight_txnvol, o.bdms_weight_txnvol) as bdms_weight_txnvol -- 
    ,nvl(n.mpcs_txnvol, o.mpcs_txnvol) as mpcs_txnvol -- 
    ,nvl(n.mpcs_weight_txnvol, o.mpcs_weight_txnvol) as mpcs_weight_txnvol -- 
    ,nvl(n.ma_txnvol, o.ma_txnvol) as ma_txnvol -- 
    ,nvl(n.ma_weight_txnvol, o.ma_weight_txnvol) as ma_weight_txnvol -- 
    ,nvl(n.period_type, o.period_type) as period_type -- 
    ,nvl(n.teller_type, o.teller_type) as teller_type -- 
    ,nvl(n.auto_txnvol, o.auto_txnvol) as auto_txnvol -- 
    ,nvl(n.auto_weight_txnvol, o.auto_weight_txnvol) as auto_weight_txnvol -- 
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
from (select * from ${iol_schema}.orws_t_ghbr_bv_statistics_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.orws_t_ghbr_bv_statistics where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.data_date <> n.data_date
        or o.data_type <> n.data_type
        or o.is_shield <> n.is_shield
        or o.hb_num <> n.hb_num
        or o.hb_name <> n.hb_name
        or o.bb_num <> n.bb_num
        or o.bb_name <> n.bb_name
        or o.sb_num <> n.sb_num
        or o.sb_name <> n.sb_name
        or o.organ_num <> n.organ_num
        or o.organ_name <> n.organ_name
        or o.display_num <> n.display_num
        or o.display_name <> n.display_name
        or o.total_txnvol <> n.total_txnvol
        or o.total_weight_txnvol <> n.total_weight_txnvol
        or o.cbss_txnvol <> n.cbss_txnvol
        or o.cbss_weight_txnvol <> n.cbss_weight_txnvol
        or o.pwbs_txnvol <> n.pwbs_txnvol
        or o.pwbs_weight_txnvol <> n.pwbs_weight_txnvol
        or o.ifms_txnvol <> n.ifms_txnvol
        or o.ifms_weight_txnvol <> n.ifms_weight_txnvol
        or o.pbss_txnvol <> n.pbss_txnvol
        or o.pbss_weight_txnvol <> n.pbss_weight_txnvol
        or o.isbs_txnvol <> n.isbs_txnvol
        or o.isbs_weight_txnvol <> n.isbs_weight_txnvol
        or o.crss_txnvol <> n.crss_txnvol
        or o.crss_weight_txnvol <> n.crss_weight_txnvol
        or o.svss_txnvol <> n.svss_txnvol
        or o.svss_weight_txnvol <> n.svss_weight_txnvol
        or o.amls_txnvol <> n.amls_txnvol
        or o.amls_weight_txnvol <> n.amls_weight_txnvol
        or o.bdms_txnvol <> n.bdms_txnvol
        or o.bdms_weight_txnvol <> n.bdms_weight_txnvol
        or o.mpcs_txnvol <> n.mpcs_txnvol
        or o.mpcs_weight_txnvol <> n.mpcs_weight_txnvol
        or o.ma_txnvol <> n.ma_txnvol
        or o.ma_weight_txnvol <> n.ma_weight_txnvol
        or o.period_type <> n.period_type
        or o.teller_type <> n.teller_type
        or o.auto_txnvol <> n.auto_txnvol
        or o.auto_weight_txnvol <> n.auto_weight_txnvol
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_t_ghbr_bv_statistics_cl(
            id -- 主键
            ,data_date -- 
            ,data_type -- 
            ,is_shield -- 
            ,hb_num -- 
            ,hb_name -- 
            ,bb_num -- 
            ,bb_name -- 
            ,sb_num -- 
            ,sb_name -- 
            ,organ_num -- 
            ,organ_name -- 
            ,display_num -- 
            ,display_name -- 
            ,total_txnvol -- 
            ,total_weight_txnvol -- 
            ,cbss_txnvol -- 
            ,cbss_weight_txnvol -- 
            ,pwbs_txnvol -- 
            ,pwbs_weight_txnvol -- 
            ,ifms_txnvol -- 
            ,ifms_weight_txnvol -- 
            ,pbss_txnvol -- 
            ,pbss_weight_txnvol -- 
            ,isbs_txnvol -- 
            ,isbs_weight_txnvol -- 
            ,crss_txnvol -- 
            ,crss_weight_txnvol -- 
            ,svss_txnvol -- 
            ,svss_weight_txnvol -- 
            ,amls_txnvol -- 
            ,amls_weight_txnvol -- 
            ,bdms_txnvol -- 
            ,bdms_weight_txnvol -- 
            ,mpcs_txnvol -- 
            ,mpcs_weight_txnvol -- 
            ,ma_txnvol -- 
            ,ma_weight_txnvol -- 
            ,period_type -- 
            ,teller_type -- 
            ,auto_txnvol -- 
            ,auto_weight_txnvol -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_t_ghbr_bv_statistics_op(
            id -- 主键
            ,data_date -- 
            ,data_type -- 
            ,is_shield -- 
            ,hb_num -- 
            ,hb_name -- 
            ,bb_num -- 
            ,bb_name -- 
            ,sb_num -- 
            ,sb_name -- 
            ,organ_num -- 
            ,organ_name -- 
            ,display_num -- 
            ,display_name -- 
            ,total_txnvol -- 
            ,total_weight_txnvol -- 
            ,cbss_txnvol -- 
            ,cbss_weight_txnvol -- 
            ,pwbs_txnvol -- 
            ,pwbs_weight_txnvol -- 
            ,ifms_txnvol -- 
            ,ifms_weight_txnvol -- 
            ,pbss_txnvol -- 
            ,pbss_weight_txnvol -- 
            ,isbs_txnvol -- 
            ,isbs_weight_txnvol -- 
            ,crss_txnvol -- 
            ,crss_weight_txnvol -- 
            ,svss_txnvol -- 
            ,svss_weight_txnvol -- 
            ,amls_txnvol -- 
            ,amls_weight_txnvol -- 
            ,bdms_txnvol -- 
            ,bdms_weight_txnvol -- 
            ,mpcs_txnvol -- 
            ,mpcs_weight_txnvol -- 
            ,ma_txnvol -- 
            ,ma_weight_txnvol -- 
            ,period_type -- 
            ,teller_type -- 
            ,auto_txnvol -- 
            ,auto_weight_txnvol -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.data_date -- 
    ,o.data_type -- 
    ,o.is_shield -- 
    ,o.hb_num -- 
    ,o.hb_name -- 
    ,o.bb_num -- 
    ,o.bb_name -- 
    ,o.sb_num -- 
    ,o.sb_name -- 
    ,o.organ_num -- 
    ,o.organ_name -- 
    ,o.display_num -- 
    ,o.display_name -- 
    ,o.total_txnvol -- 
    ,o.total_weight_txnvol -- 
    ,o.cbss_txnvol -- 
    ,o.cbss_weight_txnvol -- 
    ,o.pwbs_txnvol -- 
    ,o.pwbs_weight_txnvol -- 
    ,o.ifms_txnvol -- 
    ,o.ifms_weight_txnvol -- 
    ,o.pbss_txnvol -- 
    ,o.pbss_weight_txnvol -- 
    ,o.isbs_txnvol -- 
    ,o.isbs_weight_txnvol -- 
    ,o.crss_txnvol -- 
    ,o.crss_weight_txnvol -- 
    ,o.svss_txnvol -- 
    ,o.svss_weight_txnvol -- 
    ,o.amls_txnvol -- 
    ,o.amls_weight_txnvol -- 
    ,o.bdms_txnvol -- 
    ,o.bdms_weight_txnvol -- 
    ,o.mpcs_txnvol -- 
    ,o.mpcs_weight_txnvol -- 
    ,o.ma_txnvol -- 
    ,o.ma_weight_txnvol -- 
    ,o.period_type -- 
    ,o.teller_type -- 
    ,o.auto_txnvol -- 
    ,o.auto_weight_txnvol -- 
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
from ${iol_schema}.orws_t_ghbr_bv_statistics_bk o
    left join ${iol_schema}.orws_t_ghbr_bv_statistics_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.orws_t_ghbr_bv_statistics_cl d
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
--truncate table ${iol_schema}.orws_t_ghbr_bv_statistics;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('orws_t_ghbr_bv_statistics') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.orws_t_ghbr_bv_statistics drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.orws_t_ghbr_bv_statistics add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.orws_t_ghbr_bv_statistics exchange partition p_${batch_date} with table ${iol_schema}.orws_t_ghbr_bv_statistics_cl;
alter table ${iol_schema}.orws_t_ghbr_bv_statistics exchange partition p_20991231 with table ${iol_schema}.orws_t_ghbr_bv_statistics_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.orws_t_ghbr_bv_statistics to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_t_ghbr_bv_statistics_op purge;
drop table ${iol_schema}.orws_t_ghbr_bv_statistics_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.orws_t_ghbr_bv_statistics_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'orws_t_ghbr_bv_statistics',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
