/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_indv_cr_card_ovdue_info
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
create table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_op purge;
drop table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info where 0=1;

create table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_cl(
            key_id -- 主键
            ,grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,indvcr_card_info_seq_num -- 个人贷记卡信息序号
            ,ovdue_rec_start_year_mon -- 逾期记录开始年月
            ,ovdue_amt -- 逾期金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_op(
            key_id -- 主键
            ,grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,indvcr_card_info_seq_num -- 个人贷记卡信息序号
            ,ovdue_rec_start_year_mon -- 逾期记录开始年月
            ,ovdue_amt -- 逾期金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.key_id, o.key_id) as key_id -- 主键
    ,nvl(n.grade_key_id, o.grade_key_id) as grade_key_id -- 申请评分流水号
    ,nvl(n.data_time, o.data_time) as data_time -- 数据记录时间
    ,nvl(n.indvcr_card_info_seq_num, o.indvcr_card_info_seq_num) as indvcr_card_info_seq_num -- 个人贷记卡信息序号
    ,nvl(n.ovdue_rec_start_year_mon, o.ovdue_rec_start_year_mon) as ovdue_rec_start_year_mon -- 逾期记录开始年月
    ,nvl(n.ovdue_amt, o.ovdue_amt) as ovdue_amt -- 逾期金额
    ,case when
            n.key_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.key_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.key_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_ir_indv_cr_card_ovdue_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.key_id = n.key_id
where (
        o.key_id is null
    )
    or (
        n.key_id is null
    )
    or (
        o.grade_key_id <> n.grade_key_id
        or o.data_time <> n.data_time
        or o.indvcr_card_info_seq_num <> n.indvcr_card_info_seq_num
        or o.ovdue_rec_start_year_mon <> n.ovdue_rec_start_year_mon
        or o.ovdue_amt <> n.ovdue_amt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_cl(
            key_id -- 主键
            ,grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,indvcr_card_info_seq_num -- 个人贷记卡信息序号
            ,ovdue_rec_start_year_mon -- 逾期记录开始年月
            ,ovdue_amt -- 逾期金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_op(
            key_id -- 主键
            ,grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,indvcr_card_info_seq_num -- 个人贷记卡信息序号
            ,ovdue_rec_start_year_mon -- 逾期记录开始年月
            ,ovdue_amt -- 逾期金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.key_id -- 主键
    ,o.grade_key_id -- 申请评分流水号
    ,o.data_time -- 数据记录时间
    ,o.indvcr_card_info_seq_num -- 个人贷记卡信息序号
    ,o.ovdue_rec_start_year_mon -- 逾期记录开始年月
    ,o.ovdue_amt -- 逾期金额
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_bk o
    left join ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_op n
        on
            o.key_id = n.key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_cl d
        on
            o.key_id = d.key_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info exchange partition p_19000101 with table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_cl;
alter table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info exchange partition p_20991231 with table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_op purge;
drop table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_ir_indv_cr_card_ovdue_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_indv_cr_card_ovdue_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
