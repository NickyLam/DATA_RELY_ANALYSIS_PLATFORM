/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_finc_open_ped_set_info_h_ifmsf1
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
alter table ${iml_schema}.ref_finc_open_ped_set_info_h add partition p_ifmsf1 values ('ifmsf1')(
        subpartition p_ifmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ifmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_finc_open_ped_set_info_h partition for ('ifmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_tm purge;
drop table ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_op purge;
drop table ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_tm nologging
compress ${option_switch} for query high
as select
    ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,open_day_type_cd -- 开放日类型代码
    ,open_start_dt -- 开放开始日期
    ,open_end_dt -- 开放结束日期
    ,open_cfm_dt -- 开放确认日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_finc_open_ped_set_info_h partition for ('ifmsf1')
where 0=1
;

create table ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_finc_open_ped_set_info_h partition for ('ifmsf1') where 0=1;

create table ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_finc_open_ped_set_info_h partition for ('ifmsf1') where 0=1;

-- 3.1 get new data into table
-- ifms_tbcycleset_hxyh-
insert into ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_tm(
    ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,open_day_type_cd -- 开放日类型代码
    ,open_start_dt -- 开放开始日期
    ,open_end_dt -- 开放结束日期
    ,open_cfm_dt -- 开放确认日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.TA_CODE -- TA代码
    ,P1.PRD_CODE -- 产品编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DATE_TYPE END -- 开放日类型代码
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.CYCLE_START_DATE)) -- 开放开始日期
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.CYCLE_END_DATE)) -- 开放结束日期
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.CYCLE_CFM_DATE)) -- 开放确认日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbcycleset_hxyh' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbcycleset_hxyh p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DATE_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBCYCLESET_HXYH'
        AND R1.SRC_FIELD_EN_NAME= 'DATE_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'REF_FINC_OPEN_PED_SET_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'OPEN_DAY_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_tm 
  	                                group by 
  	                                        ta_cd
  	                                        ,prod_id
  	                                        ,open_day_type_cd
  	                                        ,open_cfm_dt
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
        into ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_cl(
            ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,open_day_type_cd -- 开放日类型代码
    ,open_start_dt -- 开放开始日期
    ,open_end_dt -- 开放结束日期
    ,open_cfm_dt -- 开放确认日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_op(
            ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,open_day_type_cd -- 开放日类型代码
    ,open_start_dt -- 开放开始日期
    ,open_end_dt -- 开放结束日期
    ,open_cfm_dt -- 开放确认日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.open_day_type_cd, o.open_day_type_cd) as open_day_type_cd -- 开放日类型代码
    ,nvl(n.open_start_dt, o.open_start_dt) as open_start_dt -- 开放开始日期
    ,nvl(n.open_end_dt, o.open_end_dt) as open_end_dt -- 开放结束日期
    ,nvl(n.open_cfm_dt, o.open_cfm_dt) as open_cfm_dt -- 开放确认日期
    ,case when
            n.ta_cd is null
            and n.prod_id is null
            and n.open_day_type_cd is null
            and n.open_cfm_dt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ta_cd is null
            and n.prod_id is null
            and n.open_day_type_cd is null
            and n.open_cfm_dt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ta_cd is null
            and n.prod_id is null
            and n.open_day_type_cd is null
            and n.open_cfm_dt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_tm n
    full join (select * from ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.ta_cd = n.ta_cd
            and o.prod_id = n.prod_id
            and o.open_day_type_cd = n.open_day_type_cd
            and o.open_cfm_dt = n.open_cfm_dt
where (
        o.ta_cd is null
        and o.prod_id is null
        and o.open_day_type_cd is null
        and o.open_cfm_dt is null
    )
    or (
        n.ta_cd is null
        and n.prod_id is null
        and n.open_day_type_cd is null
        and n.open_cfm_dt is null
    )
    or (
        o.open_start_dt <> n.open_start_dt
        or o.open_end_dt <> n.open_end_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_cl(
            ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,open_day_type_cd -- 开放日类型代码
    ,open_start_dt -- 开放开始日期
    ,open_end_dt -- 开放结束日期
    ,open_cfm_dt -- 开放确认日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_op(
            ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,open_day_type_cd -- 开放日类型代码
    ,open_start_dt -- 开放开始日期
    ,open_end_dt -- 开放结束日期
    ,open_cfm_dt -- 开放确认日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ta_cd -- TA代码
    ,o.prod_id -- 产品编号
    ,o.open_day_type_cd -- 开放日类型代码
    ,o.open_start_dt -- 开放开始日期
    ,o.open_end_dt -- 开放结束日期
    ,o.open_cfm_dt -- 开放确认日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_bk o
    left join ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_op n
        on
            o.ta_cd = n.ta_cd
            and o.prod_id = n.prod_id
            and o.open_day_type_cd = n.open_day_type_cd
            and o.open_cfm_dt = n.open_cfm_dt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_cl d
        on
            o.ta_cd = d.ta_cd
            and o.prod_id = d.prod_id
            and o.open_day_type_cd = d.open_day_type_cd
            and o.open_cfm_dt = d.open_cfm_dt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_finc_open_ped_set_info_h;
--alter table ${iml_schema}.ref_finc_open_ped_set_info_h truncate partition for ('ifmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ref_finc_open_ped_set_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ifmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ref_finc_open_ped_set_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ref_finc_open_ped_set_info_h modify partition p_ifmsf1 
add subpartition p_ifmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ref_finc_open_ped_set_info_h exchange subpartition p_ifmsf1_${batch_date} with table ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_cl;
alter table ${iml_schema}.ref_finc_open_ped_set_info_h exchange subpartition p_ifmsf1_20991231 with table ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_finc_open_ped_set_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_tm purge;
drop table ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_op purge;
drop table ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_finc_open_ped_set_info_h_ifmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_finc_open_ped_set_info_h', partname => 'p_ifmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
