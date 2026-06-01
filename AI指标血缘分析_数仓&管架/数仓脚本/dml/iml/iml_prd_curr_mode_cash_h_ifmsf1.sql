/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_curr_mode_cash_h_ifmsf1
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
alter table ${iml_schema}.prd_curr_mode_cash_h add partition p_ifmsf1 values ('ifmsf1')(
        subpartition p_ifmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ifmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_curr_mode_cash_h partition for ('ifmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_tm purge;
drop table ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_op purge;
drop table ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,cash_dt -- 兑付日期
    ,lp_id -- 法人编号
    ,intfc_proc_flg -- 接口处理标志
    ,proc_dt -- 处理日期
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_curr_mode_cash_h partition for ('ifmsf1')
where 0=1
;

create table ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_curr_mode_cash_h partition for ('ifmsf1') where 0=1;

create table ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_curr_mode_cash_h partition for ('ifmsf1') where 0=1;

-- 3.1 get new data into table
-- ifms_tbcashdate-
insert into ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_tm(
    prod_id -- 产品编号
    ,cash_dt -- 兑付日期
    ,lp_id -- 法人编号
    ,intfc_proc_flg -- 接口处理标志
    ,proc_dt -- 处理日期
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.PRD_CODE -- 产品编号
    ,${iml_schema}.DATEFORMAT_max(P1.CASH_DATE) -- 兑付日期
    ,'9999' -- 法人编号
    ,P1.DEAL_STATUS -- 接口处理标志
    ,${iml_schema}.DATEFORMAT_max(P1.DEAL_DATE) -- 处理日期
    ,P1.RESERVE1 -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbcashdate' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbcashdate p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_cl(
            prod_id -- 产品编号
    ,cash_dt -- 兑付日期
    ,lp_id -- 法人编号
    ,intfc_proc_flg -- 接口处理标志
    ,proc_dt -- 处理日期
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_op(
            prod_id -- 产品编号
    ,cash_dt -- 兑付日期
    ,lp_id -- 法人编号
    ,intfc_proc_flg -- 接口处理标志
    ,proc_dt -- 处理日期
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.cash_dt, o.cash_dt) as cash_dt -- 兑付日期
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.intfc_proc_flg, o.intfc_proc_flg) as intfc_proc_flg -- 接口处理标志
    ,nvl(n.proc_dt, o.proc_dt) as proc_dt -- 处理日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.prod_id is null
            and n.cash_dt is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_id is null
            and n.cash_dt is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_id is null
            and n.cash_dt is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_tm n
    full join (select * from ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
            and o.cash_dt = n.cash_dt
            and o.lp_id = n.lp_id
where (
        o.prod_id is null
        and o.cash_dt is null
        and o.lp_id is null
    )
    or (
        n.prod_id is null
        and n.cash_dt is null
        and n.lp_id is null
    )
    or (
        o.intfc_proc_flg <> n.intfc_proc_flg
        or o.proc_dt <> n.proc_dt
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_cl(
            prod_id -- 产品编号
    ,cash_dt -- 兑付日期
    ,lp_id -- 法人编号
    ,intfc_proc_flg -- 接口处理标志
    ,proc_dt -- 处理日期
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_op(
            prod_id -- 产品编号
    ,cash_dt -- 兑付日期
    ,lp_id -- 法人编号
    ,intfc_proc_flg -- 接口处理标志
    ,proc_dt -- 处理日期
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_id -- 产品编号
    ,o.cash_dt -- 兑付日期
    ,o.lp_id -- 法人编号
    ,o.intfc_proc_flg -- 接口处理标志
    ,o.proc_dt -- 处理日期
    ,o.remark -- 备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_bk o
    left join ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_op n
        on
            o.prod_id = n.prod_id
            and o.cash_dt = n.cash_dt
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_cl d
        on
            o.prod_id = d.prod_id
            and o.cash_dt = d.cash_dt
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_curr_mode_cash_h;
alter table ${iml_schema}.prd_curr_mode_cash_h truncate partition for ('ifmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_curr_mode_cash_h exchange subpartition p_ifmsf1_19000101 with table ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_cl;
alter table ${iml_schema}.prd_curr_mode_cash_h exchange subpartition p_ifmsf1_20991231 with table ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_curr_mode_cash_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_tm purge;
drop table ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_op purge;
drop table ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_curr_mode_cash_h_ifmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_curr_mode_cash_h', partname => 'p_ifmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
