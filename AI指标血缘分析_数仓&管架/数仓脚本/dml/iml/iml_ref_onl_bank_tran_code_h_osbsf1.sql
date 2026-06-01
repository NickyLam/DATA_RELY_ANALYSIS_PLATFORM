/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_onl_bank_tran_code_h_osbsf1
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
alter table ${iml_schema}.ref_onl_bank_tran_code_h add partition p_osbsf1 values ('osbsf1')(
        subpartition p_osbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_osbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_onl_bank_tran_code_h partition for ('osbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_tm purge;
drop table ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_op purge;
drop table ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_tm nologging
compress ${option_switch} for query high
as select
    serv_type_cd -- 服务类型代码
    ,tran_code -- 交易码
    ,tran_name -- 交易名称
    ,tran_flg_comb -- 交易标志组合
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_onl_bank_tran_code_h partition for ('osbsf1')
where 0=1
;

create table ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_onl_bank_tran_code_h partition for ('osbsf1') where 0=1;

create table ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_onl_bank_tran_code_h partition for ('osbsf1') where 0=1;

-- 3.1 get new data into table
-- osbs_bas_im_service_trans_rel-
insert into ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_tm(
    serv_type_cd -- 服务类型代码
    ,tran_code -- 交易码
    ,tran_name -- 交易名称
    ,tran_flg_comb -- 交易标志组合
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.BST_SERVICEID -- 服务类型代码
    ,P1.BST_TRANSID -- 交易码
    ,P1.BST_TRANSNAME -- 交易名称
    ,P1.BST_TRANSDIAPLSY -- 交易标志组合
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'osbs_bas_im_service_trans_rel' -- 源表名称
    ,'osbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.osbs_bas_im_service_trans_rel p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_cl(
            serv_type_cd -- 服务类型代码
    ,tran_code -- 交易码
    ,tran_name -- 交易名称
    ,tran_flg_comb -- 交易标志组合
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_op(
            serv_type_cd -- 服务类型代码
    ,tran_code -- 交易码
    ,tran_name -- 交易名称
    ,tran_flg_comb -- 交易标志组合
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serv_type_cd, o.serv_type_cd) as serv_type_cd -- 服务类型代码
    ,nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.tran_name, o.tran_name) as tran_name -- 交易名称
    ,nvl(n.tran_flg_comb, o.tran_flg_comb) as tran_flg_comb -- 交易标志组合
    ,case when
            n.serv_type_cd is null
            and n.tran_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serv_type_cd is null
            and n.tran_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serv_type_cd is null
            and n.tran_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_tm n
    full join (select * from ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.serv_type_cd = n.serv_type_cd
            and o.tran_code = n.tran_code
where (
        o.serv_type_cd is null
        and o.tran_code is null
    )
    or (
        n.serv_type_cd is null
        and n.tran_code is null
    )
    or (
        o.tran_name <> n.tran_name
        or o.tran_flg_comb <> n.tran_flg_comb
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_cl(
            serv_type_cd -- 服务类型代码
    ,tran_code -- 交易码
    ,tran_name -- 交易名称
    ,tran_flg_comb -- 交易标志组合
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_op(
            serv_type_cd -- 服务类型代码
    ,tran_code -- 交易码
    ,tran_name -- 交易名称
    ,tran_flg_comb -- 交易标志组合
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serv_type_cd -- 服务类型代码
    ,o.tran_code -- 交易码
    ,o.tran_name -- 交易名称
    ,o.tran_flg_comb -- 交易标志组合
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_bk o
    left join ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_op n
        on
            o.serv_type_cd = n.serv_type_cd
            and o.tran_code = n.tran_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_cl d
        on
            o.serv_type_cd = d.serv_type_cd
            and o.tran_code = d.tran_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_onl_bank_tran_code_h;
alter table ${iml_schema}.ref_onl_bank_tran_code_h truncate partition for ('osbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_onl_bank_tran_code_h exchange subpartition p_osbsf1_19000101 with table ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_cl;
alter table ${iml_schema}.ref_onl_bank_tran_code_h exchange subpartition p_osbsf1_20991231 with table ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_onl_bank_tran_code_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_tm purge;
drop table ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_op purge;
drop table ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_onl_bank_tran_code_h_osbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_onl_bank_tran_code_h', partname => 'p_osbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
