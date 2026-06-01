/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_direct_term_inf_tmp
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
create table ${iol_schema}.mrms_tbl_direct_term_inf_tmp_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_direct_term_inf_tmp
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_direct_term_inf_tmp_op purge;
drop table ${iol_schema}.mrms_tbl_direct_term_inf_tmp_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_direct_term_inf_tmp_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_direct_term_inf_tmp where 0=1;

create table ${iol_schema}.mrms_tbl_direct_term_inf_tmp_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_direct_term_inf_tmp where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_direct_term_inf_tmp_cl(
            term_cd -- 
            ,term_sn -- 
            ,mcht_no -- 
            ,term_type -- 
            ,use -- 
            ,status -- 
            ,comments -- 
            ,recover -- 
            ,order_dt -- 
            ,install_dt -- 
            ,hsm -- 
            ,dealwith -- 
            ,processing_code -- 
            ,processing_dsp -- 
            ,finish -- 
            ,id -- 
            ,term_area -- 
            ,term_nm -- 
            ,term_tel -- 
            ,oper_id -- 
            ,term_sta -- 
            ,create_date -- 
            ,rec_upd_ts -- 
            ,upd_oper -- 
            ,out_mcht_no -- 
            ,out_term_cd -- 
            ,mchtserial -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_direct_term_inf_tmp_op(
            term_cd -- 
            ,term_sn -- 
            ,mcht_no -- 
            ,term_type -- 
            ,use -- 
            ,status -- 
            ,comments -- 
            ,recover -- 
            ,order_dt -- 
            ,install_dt -- 
            ,hsm -- 
            ,dealwith -- 
            ,processing_code -- 
            ,processing_dsp -- 
            ,finish -- 
            ,id -- 
            ,term_area -- 
            ,term_nm -- 
            ,term_tel -- 
            ,oper_id -- 
            ,term_sta -- 
            ,create_date -- 
            ,rec_upd_ts -- 
            ,upd_oper -- 
            ,out_mcht_no -- 
            ,out_term_cd -- 
            ,mchtserial -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.term_cd, o.term_cd) as term_cd -- 
    ,nvl(n.term_sn, o.term_sn) as term_sn -- 
    ,nvl(n.mcht_no, o.mcht_no) as mcht_no -- 
    ,nvl(n.term_type, o.term_type) as term_type -- 
    ,nvl(n.use, o.use) as use -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.comments, o.comments) as comments -- 
    ,nvl(n.recover, o.recover) as recover -- 
    ,nvl(n.order_dt, o.order_dt) as order_dt -- 
    ,nvl(n.install_dt, o.install_dt) as install_dt -- 
    ,nvl(n.hsm, o.hsm) as hsm -- 
    ,nvl(n.dealwith, o.dealwith) as dealwith -- 
    ,nvl(n.processing_code, o.processing_code) as processing_code -- 
    ,nvl(n.processing_dsp, o.processing_dsp) as processing_dsp -- 
    ,nvl(n.finish, o.finish) as finish -- 
    ,nvl(n.id, o.id) as id -- 
    ,nvl(n.term_area, o.term_area) as term_area -- 
    ,nvl(n.term_nm, o.term_nm) as term_nm -- 
    ,nvl(n.term_tel, o.term_tel) as term_tel -- 
    ,nvl(n.oper_id, o.oper_id) as oper_id -- 
    ,nvl(n.term_sta, o.term_sta) as term_sta -- 
    ,nvl(n.create_date, o.create_date) as create_date -- 
    ,nvl(n.rec_upd_ts, o.rec_upd_ts) as rec_upd_ts -- 
    ,nvl(n.upd_oper, o.upd_oper) as upd_oper -- 
    ,nvl(n.out_mcht_no, o.out_mcht_no) as out_mcht_no -- 
    ,nvl(n.out_term_cd, o.out_term_cd) as out_term_cd -- 
    ,nvl(n.mchtserial, o.mchtserial) as mchtserial -- 
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
from (select * from ${iol_schema}.mrms_tbl_direct_term_inf_tmp_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_tbl_direct_term_inf_tmp where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.term_cd <> n.term_cd
        or o.term_sn <> n.term_sn
        or o.mcht_no <> n.mcht_no
        or o.term_type <> n.term_type
        or o.use <> n.use
        or o.status <> n.status
        or o.comments <> n.comments
        or o.recover <> n.recover
        or o.order_dt <> n.order_dt
        or o.install_dt <> n.install_dt
        or o.hsm <> n.hsm
        or o.dealwith <> n.dealwith
        or o.processing_code <> n.processing_code
        or o.processing_dsp <> n.processing_dsp
        or o.finish <> n.finish
        or o.term_area <> n.term_area
        or o.term_nm <> n.term_nm
        or o.term_tel <> n.term_tel
        or o.oper_id <> n.oper_id
        or o.term_sta <> n.term_sta
        or o.create_date <> n.create_date
        or o.rec_upd_ts <> n.rec_upd_ts
        or o.upd_oper <> n.upd_oper
        or o.out_mcht_no <> n.out_mcht_no
        or o.out_term_cd <> n.out_term_cd
        or o.mchtserial <> n.mchtserial
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_direct_term_inf_tmp_cl(
            term_cd -- 
            ,term_sn -- 
            ,mcht_no -- 
            ,term_type -- 
            ,use -- 
            ,status -- 
            ,comments -- 
            ,recover -- 
            ,order_dt -- 
            ,install_dt -- 
            ,hsm -- 
            ,dealwith -- 
            ,processing_code -- 
            ,processing_dsp -- 
            ,finish -- 
            ,id -- 
            ,term_area -- 
            ,term_nm -- 
            ,term_tel -- 
            ,oper_id -- 
            ,term_sta -- 
            ,create_date -- 
            ,rec_upd_ts -- 
            ,upd_oper -- 
            ,out_mcht_no -- 
            ,out_term_cd -- 
            ,mchtserial -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_direct_term_inf_tmp_op(
            term_cd -- 
            ,term_sn -- 
            ,mcht_no -- 
            ,term_type -- 
            ,use -- 
            ,status -- 
            ,comments -- 
            ,recover -- 
            ,order_dt -- 
            ,install_dt -- 
            ,hsm -- 
            ,dealwith -- 
            ,processing_code -- 
            ,processing_dsp -- 
            ,finish -- 
            ,id -- 
            ,term_area -- 
            ,term_nm -- 
            ,term_tel -- 
            ,oper_id -- 
            ,term_sta -- 
            ,create_date -- 
            ,rec_upd_ts -- 
            ,upd_oper -- 
            ,out_mcht_no -- 
            ,out_term_cd -- 
            ,mchtserial -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.term_cd -- 
    ,o.term_sn -- 
    ,o.mcht_no -- 
    ,o.term_type -- 
    ,o.use -- 
    ,o.status -- 
    ,o.comments -- 
    ,o.recover -- 
    ,o.order_dt -- 
    ,o.install_dt -- 
    ,o.hsm -- 
    ,o.dealwith -- 
    ,o.processing_code -- 
    ,o.processing_dsp -- 
    ,o.finish -- 
    ,o.id -- 
    ,o.term_area -- 
    ,o.term_nm -- 
    ,o.term_tel -- 
    ,o.oper_id -- 
    ,o.term_sta -- 
    ,o.create_date -- 
    ,o.rec_upd_ts -- 
    ,o.upd_oper -- 
    ,o.out_mcht_no -- 
    ,o.out_term_cd -- 
    ,o.mchtserial -- 
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
from ${iol_schema}.mrms_tbl_direct_term_inf_tmp_bk o
    left join ${iol_schema}.mrms_tbl_direct_term_inf_tmp_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_tbl_direct_term_inf_tmp_cl d
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
--truncate table ${iol_schema}.mrms_tbl_direct_term_inf_tmp;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mrms_tbl_direct_term_inf_tmp') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mrms_tbl_direct_term_inf_tmp drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mrms_tbl_direct_term_inf_tmp add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mrms_tbl_direct_term_inf_tmp exchange partition p_${batch_date} with table ${iol_schema}.mrms_tbl_direct_term_inf_tmp_cl;
alter table ${iol_schema}.mrms_tbl_direct_term_inf_tmp exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_direct_term_inf_tmp_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_direct_term_inf_tmp to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_direct_term_inf_tmp_op purge;
drop table ${iol_schema}.mrms_tbl_direct_term_inf_tmp_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_direct_term_inf_tmp_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_direct_term_inf_tmp',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
