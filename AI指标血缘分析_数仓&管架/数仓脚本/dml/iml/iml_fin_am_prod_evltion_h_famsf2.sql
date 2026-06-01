/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_fin_am_prod_evltion_h_famsf2
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
alter table ${iml_schema}.fin_am_prod_evltion_h add partition p_famsf2 values ('famsf2')(
        subpartition p_famsf2_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_famsf2_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.fin_am_prod_evltion_h_famsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_am_prod_evltion_h partition for ('famsf2')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.fin_am_prod_evltion_h_famsf2_tm purge;
drop table ${iml_schema}.fin_am_prod_evltion_h_famsf2_op purge;
drop table ${iml_schema}.fin_am_prod_evltion_h_famsf2_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_am_prod_evltion_h_famsf2_tm nologging
compress ${option_switch} for query high
as select
    sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,sob_name -- 账套名称
    ,evltion_type_cd -- 估值类型代码
    ,evltion_descb -- 估值描述
    ,evltion -- 估值
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_am_prod_evltion_h partition for ('famsf2')
where 0=1
;

create table ${iml_schema}.fin_am_prod_evltion_h_famsf2_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_am_prod_evltion_h partition for ('famsf2') where 0=1;

create table ${iml_schema}.fin_am_prod_evltion_h_famsf2_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_am_prod_evltion_h partition for ('famsf2') where 0=1;

-- 3.1 get new data into table
-- fams_bok_val_table_data-1
insert into ${iml_schema}.fin_am_prod_evltion_h_famsf2_tm(
    sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,sob_name -- 账套名称
    ,evltion_type_cd -- 估值类型代码
    ,evltion_descb -- 估值描述
    ,evltion -- 估值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.BOOKSET_ID -- 账套编号
    ,'9999' -- 法人编号
    ,P1.BOOKSET_NAME -- 账套名称
    ,P1.DETAIL_DIST -- 估值类型代码
    ,replace(P1.SUBJECT_NO,'：','') -- 估值描述
    ,case when p1.DETAIL_DIST in ('53','56') 
           then TO_NUMBER(nvl(trim(regexp_substr(p1.subject_name, '[0-9.]+')),0))*100
     when p1.DETAIL_DIST in ('09','10','18','27','28','38','39','40','41','42','43','46','47','48','54','55') 
           then TO_NUMBER(nvl(trim(regexp_substr(p1.subject_name, '[0-9.]+')),0))
     when p1.DETAIL_DIST in ('02','05','06','07','08','17') 
           then p1.MARKET_VALUE
END -- 估值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_bok_val_table_data' -- 源表名称
    ,'famsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_bok_val_table_data p1
    inner join  (select a.seq_no,row_number() over(partition by a.bookset_id,a.detail_dist,a.val_date  order by a.seq_no desc) seq 
     from ${iol_schema}.fams_bok_val_table_data a 
     where a.start_dt<=to_date('${batch_date}','yyyymmdd') and  a.end_dt>to_date('${batch_date}','yyyymmdd') 
     and a.val_date = to_date('${batch_date}','yyyymmdd') 
     and a.detail_dist in ('02','05','06','07','08','17','09','10','18','27','28','38','39','40','41','42','43','46','47','48','53','54','55','56')
) p2 on p2.seq_no=p1.seq_no
     and p2.seq=1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
     and P1.VAL_DATE = to_date('${batch_date}','yyyymmdd') 
and P1.DETAIL_DIST in ('02','05','06','07','08','17','09','10','18','27','28','38','39','40','41','42','43','46','47','48','53','54','55','56')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.fin_am_prod_evltion_h_famsf2_cl(
            sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,sob_name -- 账套名称
    ,evltion_type_cd -- 估值类型代码
    ,evltion_descb -- 估值描述
    ,evltion -- 估值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.fin_am_prod_evltion_h_famsf2_op(
            sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,sob_name -- 账套名称
    ,evltion_type_cd -- 估值类型代码
    ,evltion_descb -- 估值描述
    ,evltion -- 估值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sob_id, o.sob_id) as sob_id -- 账套编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.sob_name, o.sob_name) as sob_name -- 账套名称
    ,nvl(n.evltion_type_cd, o.evltion_type_cd) as evltion_type_cd -- 估值类型代码
    ,nvl(n.evltion_descb, o.evltion_descb) as evltion_descb -- 估值描述
    ,nvl(n.evltion, o.evltion) as evltion -- 估值
    ,case when
            n.sob_id is null
            and n.lp_id is null
            and n.evltion_type_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sob_id is null
            and n.lp_id is null
            and n.evltion_type_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sob_id is null
            and n.lp_id is null
            and n.evltion_type_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_am_prod_evltion_h_famsf2_tm n
    full join (select * from ${iml_schema}.fin_am_prod_evltion_h_famsf2_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.sob_id = n.sob_id
            and o.lp_id = n.lp_id
            and o.evltion_type_cd = n.evltion_type_cd
where (
        o.sob_id is null
        and o.lp_id is null
        and o.evltion_type_cd is null
    )
    or (
        n.sob_id is null
        and n.lp_id is null
        and n.evltion_type_cd is null
    )
    or (
        o.sob_name <> n.sob_name
        or o.evltion_descb <> n.evltion_descb
        or o.evltion <> n.evltion
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.fin_am_prod_evltion_h_famsf2_cl(
            sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,sob_name -- 账套名称
    ,evltion_type_cd -- 估值类型代码
    ,evltion_descb -- 估值描述
    ,evltion -- 估值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.fin_am_prod_evltion_h_famsf2_op(
            sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,sob_name -- 账套名称
    ,evltion_type_cd -- 估值类型代码
    ,evltion_descb -- 估值描述
    ,evltion -- 估值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sob_id -- 账套编号
    ,o.lp_id -- 法人编号
    ,o.sob_name -- 账套名称
    ,o.evltion_type_cd -- 估值类型代码
    ,o.evltion_descb -- 估值描述
    ,o.evltion -- 估值
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_am_prod_evltion_h_famsf2_bk o
    left join ${iml_schema}.fin_am_prod_evltion_h_famsf2_op n
        on
            o.sob_id = n.sob_id
            and o.lp_id = n.lp_id
            and o.evltion_type_cd = n.evltion_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.fin_am_prod_evltion_h_famsf2_cl d
        on
            o.sob_id = d.sob_id
            and o.lp_id = d.lp_id
            and o.evltion_type_cd = d.evltion_type_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.fin_am_prod_evltion_h;
alter table ${iml_schema}.fin_am_prod_evltion_h truncate partition for ('famsf2') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.fin_am_prod_evltion_h exchange subpartition p_famsf2_19000101 with table ${iml_schema}.fin_am_prod_evltion_h_famsf2_cl;
alter table ${iml_schema}.fin_am_prod_evltion_h exchange subpartition p_famsf2_20991231 with table ${iml_schema}.fin_am_prod_evltion_h_famsf2_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.fin_am_prod_evltion_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.fin_am_prod_evltion_h_famsf2_tm purge;
drop table ${iml_schema}.fin_am_prod_evltion_h_famsf2_op purge;
drop table ${iml_schema}.fin_am_prod_evltion_h_famsf2_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.fin_am_prod_evltion_h_famsf2_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'fin_am_prod_evltion_h', partname => 'p_famsf2_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
