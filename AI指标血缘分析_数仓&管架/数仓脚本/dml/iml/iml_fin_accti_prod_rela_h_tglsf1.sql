/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_fin_accti_prod_rela_h_tglsf1
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
alter table ${iml_schema}.fin_accti_prod_rela_h add partition p_tglsf1 values ('tglsf1')(
        subpartition p_tglsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_tglsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.fin_accti_prod_rela_h_tglsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_accti_prod_rela_h partition for ('tglsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.fin_accti_prod_rela_h_tglsf1_tm purge;
drop table ${iml_schema}.fin_accti_prod_rela_h_tglsf1_op purge;
drop table ${iml_schema}.fin_accti_prod_rela_h_tglsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_accti_prod_rela_h_tglsf1_tm nologging
compress ${option_switch} for query high
as select
    intnal_prod_id -- 内部产品编号
    ,lp_id -- 法人编号
    ,accti_id -- 核算编号
    ,base_prod_id -- 基础产品编号
    ,sob_id -- 账套编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_accti_prod_rela_h partition for ('tglsf1')
where 0=1
;

create table ${iml_schema}.fin_accti_prod_rela_h_tglsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_accti_prod_rela_h partition for ('tglsf1') where 0=1;

create table ${iml_schema}.fin_accti_prod_rela_h_tglsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_accti_prod_rela_h partition for ('tglsf1') where 0=1;

-- 3.1 get new data into table
-- tgls_sys_dtit_map-1
insert into ${iml_schema}.fin_accti_prod_rela_h_tglsf1_tm(
    intnal_prod_id -- 内部产品编号
    ,lp_id -- 法人编号
    ,accti_id -- 核算编号
    ,base_prod_id -- 基础产品编号
    ,sob_id -- 账套编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.PRODCD -- 内部产品编号
    ,'9999' -- 法人编号
    ,P1.DTITCD -- 核算编号
    ,P1.PRODP1 -- 基础产品编号
    ,P1.STACID -- 账套编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_sys_dtit_map' -- 源表名称
    ,'tglsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tgls_sys_dtit_map p1
where  1 = 1 
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.fin_accti_prod_rela_h_tglsf1_tm 
  	                                group by 
  	                                        intnal_prod_id
  	                                        ,lp_id
  	                                        ,accti_id
  	                                        ,base_prod_id
  	                                        ,sob_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.fin_accti_prod_rela_h_tglsf1_cl(
            intnal_prod_id -- 内部产品编号
    ,lp_id -- 法人编号
    ,accti_id -- 核算编号
    ,base_prod_id -- 基础产品编号
    ,sob_id -- 账套编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.fin_accti_prod_rela_h_tglsf1_op(
            intnal_prod_id -- 内部产品编号
    ,lp_id -- 法人编号
    ,accti_id -- 核算编号
    ,base_prod_id -- 基础产品编号
    ,sob_id -- 账套编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.intnal_prod_id, o.intnal_prod_id) as intnal_prod_id -- 内部产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.accti_id, o.accti_id) as accti_id -- 核算编号
    ,nvl(n.base_prod_id, o.base_prod_id) as base_prod_id -- 基础产品编号
    ,nvl(n.sob_id, o.sob_id) as sob_id -- 账套编号
    ,case when
            n.intnal_prod_id is null
            and n.lp_id is null
            and n.accti_id is null
            and n.base_prod_id is null
            and n.sob_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.intnal_prod_id is null
            and n.lp_id is null
            and n.accti_id is null
            and n.base_prod_id is null
            and n.sob_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.intnal_prod_id is null
            and n.lp_id is null
            and n.accti_id is null
            and n.base_prod_id is null
            and n.sob_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_accti_prod_rela_h_tglsf1_tm n
    full join (select * from ${iml_schema}.fin_accti_prod_rela_h_tglsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.intnal_prod_id = n.intnal_prod_id
            and o.lp_id = n.lp_id
            and o.accti_id = n.accti_id
            and o.base_prod_id = n.base_prod_id
            and o.sob_id = n.sob_id
where (
        o.intnal_prod_id is null
        and o.lp_id is null
        and o.accti_id is null
        and o.base_prod_id is null
        and o.sob_id is null
    )
    or (
        n.intnal_prod_id is null
        and n.lp_id is null
        and n.accti_id is null
        and n.base_prod_id is null
        and n.sob_id is null
    )
    or (

    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.fin_accti_prod_rela_h_tglsf1_cl(
            intnal_prod_id -- 内部产品编号
    ,lp_id -- 法人编号
    ,accti_id -- 核算编号
    ,base_prod_id -- 基础产品编号
    ,sob_id -- 账套编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.fin_accti_prod_rela_h_tglsf1_op(
            intnal_prod_id -- 内部产品编号
    ,lp_id -- 法人编号
    ,accti_id -- 核算编号
    ,base_prod_id -- 基础产品编号
    ,sob_id -- 账套编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.intnal_prod_id -- 内部产品编号
    ,o.lp_id -- 法人编号
    ,o.accti_id -- 核算编号
    ,o.base_prod_id -- 基础产品编号
    ,o.sob_id -- 账套编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_accti_prod_rela_h_tglsf1_bk o
    left join ${iml_schema}.fin_accti_prod_rela_h_tglsf1_op n
        on
            o.intnal_prod_id = n.intnal_prod_id
            and o.lp_id = n.lp_id
            and o.accti_id = n.accti_id
            and o.base_prod_id = n.base_prod_id
            and o.sob_id = n.sob_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.fin_accti_prod_rela_h_tglsf1_cl d
        on
            o.intnal_prod_id = d.intnal_prod_id
            and o.lp_id = d.lp_id
            and o.accti_id = d.accti_id
            and o.base_prod_id = d.base_prod_id
            and o.sob_id = d.sob_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.fin_accti_prod_rela_h;
alter table ${iml_schema}.fin_accti_prod_rela_h truncate partition for ('tglsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.fin_accti_prod_rela_h exchange subpartition p_tglsf1_19000101 with table ${iml_schema}.fin_accti_prod_rela_h_tglsf1_cl;
alter table ${iml_schema}.fin_accti_prod_rela_h exchange subpartition p_tglsf1_20991231 with table ${iml_schema}.fin_accti_prod_rela_h_tglsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.fin_accti_prod_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.fin_accti_prod_rela_h_tglsf1_tm purge;
drop table ${iml_schema}.fin_accti_prod_rela_h_tglsf1_op purge;
drop table ${iml_schema}.fin_accti_prod_rela_h_tglsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.fin_accti_prod_rela_h_tglsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'fin_accti_prod_rela_h', partname => 'p_tglsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
