/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_mercht_recv_tran_para_h_mrmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_mercht_recv_tran_para_h add partition p_mrmsf1 values ('mrmsf1')(
        subpartition p_mrmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mrmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_mercht_recv_tran_para_h partition for ('mrmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_tm purge;
drop table ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_op purge;
drop table ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_tm nologging
compress ${option_switch} for query high
as select
    tran_code -- 交易码
    ,tran_name -- 交易名称
    ,fin_tran_flg -- 金融交易标志
    ,del_flg -- 删除标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_mercht_recv_tran_para_h partition for ('mrmsf1')
where 0=1
;

create table ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_mercht_recv_tran_para_h partition for ('mrmsf1') where 0=1;

create table ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_mercht_recv_tran_para_h partition for ('mrmsf1') where 0=1;

-- 3.1 get new data into table
-- mrms_txn_num_tab_info-
insert into ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_tm(
    tran_code -- 交易码
    ,tran_name -- 交易名称
    ,fin_tran_flg -- 金融交易标志
    ,del_flg -- 删除标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.TXN_NUM -- 交易码
    ,P1.TXN_NAME -- 交易名称
    ,P1.FIN_TXN_FLG -- 金融交易标志
    ,P1.DEL_FLG -- 删除标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_txn_num_tab' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_txn_num_tab p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_cl(
            tran_code -- 交易码
    ,tran_name -- 交易名称
    ,fin_tran_flg -- 金融交易标志
    ,del_flg -- 删除标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_op(
            tran_code -- 交易码
    ,tran_name -- 交易名称
    ,fin_tran_flg -- 金融交易标志
    ,del_flg -- 删除标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.tran_name, o.tran_name) as tran_name -- 交易名称
    ,nvl(n.fin_tran_flg, o.fin_tran_flg) as fin_tran_flg -- 金融交易标志
    ,nvl(n.del_flg, o.del_flg) as del_flg -- 删除标志
    ,case when
            n.tran_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tran_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tran_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_tm n
    full join (select * from ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.tran_code = n.tran_code
where (
        o.tran_code is null
    )
    or (
        n.tran_code is null
    )
    or (
        o.tran_name <> n.tran_name
        or o.fin_tran_flg <> n.fin_tran_flg
        or o.del_flg <> n.del_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_cl(
            tran_code -- 交易码
    ,tran_name -- 交易名称
    ,fin_tran_flg -- 金融交易标志
    ,del_flg -- 删除标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_op(
            tran_code -- 交易码
    ,tran_name -- 交易名称
    ,fin_tran_flg -- 金融交易标志
    ,del_flg -- 删除标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tran_code -- 交易码
    ,o.tran_name -- 交易名称
    ,o.fin_tran_flg -- 金融交易标志
    ,o.del_flg -- 删除标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_bk o
    left join ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_op n
        on
            o.tran_code = n.tran_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_cl d
        on
            o.tran_code = d.tran_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_mercht_recv_tran_para_h;
alter table ${iml_schema}.ref_mercht_recv_tran_para_h truncate partition for ('mrmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_mercht_recv_tran_para_h exchange subpartition p_mrmsf1_19000101 with table ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_cl;
alter table ${iml_schema}.ref_mercht_recv_tran_para_h exchange subpartition p_mrmsf1_20991231 with table ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_mercht_recv_tran_para_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_tm purge;
drop table ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_op purge;
drop table ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_mercht_recv_tran_para_h_mrmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_mercht_recv_tran_para_h', partname => 'p_mrmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
