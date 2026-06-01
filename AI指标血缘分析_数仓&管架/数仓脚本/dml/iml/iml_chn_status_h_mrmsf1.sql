/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_chn_status_h_mrmsf1
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
alter table ${iml_schema}.chn_status_h add partition p_mrmsf1 values ('mrmsf1')(
        subpartition p_mrmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mrmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.chn_status_h_mrmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.chn_status_h partition for ('mrmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.chn_status_h_mrmsf1_tm purge;
drop table ${iml_schema}.chn_status_h_mrmsf1_op purge;
drop table ${iml_schema}.chn_status_h_mrmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.chn_status_h_mrmsf1_tm nologging
compress ${option_switch} for query high
as select
    chn_id -- 渠道商终端设备编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,chn_status_type_cd -- 渠道状态类型代码
    ,chn_status_cd -- 渠道状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.chn_status_h partition for ('mrmsf1')
where 0=1
;

create table ${iml_schema}.chn_status_h_mrmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.chn_status_h partition for ('mrmsf1') where 0=1;

create table ${iml_schema}.chn_status_h_mrmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.chn_status_h partition for ('mrmsf1') where 0=1;

-- 3.1 get new data into table
-- mrms_tbl_term_inf-1
insert into ${iml_schema}.chn_status_h_mrmsf1_tm(
    chn_id -- 渠道商终端设备编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,chn_status_type_cd -- 渠道状态类型代码
    ,chn_status_cd -- 渠道状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '103001'||p1.mcht_cd||p1.term_id -- 渠道商终端设备编号
    ,'9999' -- 法人编号
    ,'MRMS' -- 源系统代码
    ,'CD2008' -- 渠道状态类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.term_sta END -- 渠道状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_term_inf' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_term_inf p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.term_sta = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MRMS'
        AND R1.SRC_TAB_EN_NAME= 'MRMS_TBL_TERM_INF'
        AND R1.SRC_FIELD_EN_NAME= 'term_sta'
        AND R1.TARGET_TAB_EN_NAME= 'CHN_STATUS_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CHN_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- mrms_tbl_term_inf-2
insert into ${iml_schema}.chn_status_h_mrmsf1_tm(
    chn_id -- 渠道商终端设备编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,chn_status_type_cd -- 渠道状态类型代码
    ,chn_status_cd -- 渠道状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '103001'||p1.mcht_cd||p1.term_id -- 渠道商终端设备编号
    ,'9999' -- 法人编号
    ,'MRMS' -- 源系统代码
    ,'CD2165' -- 渠道状态类型代码
    ,nvl(trim(p1.term_sign_sta),'-') -- 渠道状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_term_inf' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_term_inf p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.chn_status_h_mrmsf1_tm 
  	                                group by 
  	                                        chn_id
  	                                        ,lp_id
  	                                        ,sorc_sys_cd
  	                                        ,chn_status_type_cd
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
        into ${iml_schema}.chn_status_h_mrmsf1_cl(
            chn_id -- 渠道商终端设备编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,chn_status_type_cd -- 渠道状态类型代码
    ,chn_status_cd -- 渠道状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.chn_status_h_mrmsf1_op(
            chn_id -- 渠道商终端设备编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,chn_status_type_cd -- 渠道状态类型代码
    ,chn_status_cd -- 渠道状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.chn_id, o.chn_id) as chn_id -- 渠道商终端设备编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.sorc_sys_cd, o.sorc_sys_cd) as sorc_sys_cd -- 源系统代码
    ,nvl(n.chn_status_type_cd, o.chn_status_type_cd) as chn_status_type_cd -- 渠道状态类型代码
    ,nvl(n.chn_status_cd, o.chn_status_cd) as chn_status_cd -- 渠道状态代码
    ,case when
            n.chn_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
            and n.chn_status_type_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.chn_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
            and n.chn_status_type_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.chn_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
            and n.chn_status_type_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.chn_status_h_mrmsf1_tm n
    full join (select * from ${iml_schema}.chn_status_h_mrmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.chn_id = n.chn_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
            and o.chn_status_type_cd = n.chn_status_type_cd
where (
        o.chn_id is null
        and o.lp_id is null
        and o.sorc_sys_cd is null
        and o.chn_status_type_cd is null
    )
    or (
        n.chn_id is null
        and n.lp_id is null
        and n.sorc_sys_cd is null
        and n.chn_status_type_cd is null
    )
    or (
        o.chn_status_cd <> n.chn_status_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.chn_status_h_mrmsf1_cl(
            chn_id -- 渠道商终端设备编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,chn_status_type_cd -- 渠道状态类型代码
    ,chn_status_cd -- 渠道状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.chn_status_h_mrmsf1_op(
            chn_id -- 渠道商终端设备编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,chn_status_type_cd -- 渠道状态类型代码
    ,chn_status_cd -- 渠道状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.chn_id -- 渠道商终端设备编号
    ,o.lp_id -- 法人编号
    ,o.sorc_sys_cd -- 源系统代码
    ,o.chn_status_type_cd -- 渠道状态类型代码
    ,o.chn_status_cd -- 渠道状态代码
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
from ${iml_schema}.chn_status_h_mrmsf1_bk o
    left join ${iml_schema}.chn_status_h_mrmsf1_op n
        on
            o.chn_id = n.chn_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
            and o.chn_status_type_cd = n.chn_status_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.chn_status_h_mrmsf1_cl d
        on
            o.chn_id = d.chn_id
            and o.lp_id = d.lp_id
            and o.sorc_sys_cd = d.sorc_sys_cd
            and o.chn_status_type_cd = d.chn_status_type_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.chn_status_h;
--alter table ${iml_schema}.chn_status_h truncate partition for ('mrmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('chn_status_h') 
               and substr(subpartition_name,1,8)=upper('p_mrmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.chn_status_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.chn_status_h modify partition p_mrmsf1 
add subpartition p_mrmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.chn_status_h exchange subpartition p_mrmsf1_${batch_date} with table ${iml_schema}.chn_status_h_mrmsf1_cl;
alter table ${iml_schema}.chn_status_h exchange subpartition p_mrmsf1_20991231 with table ${iml_schema}.chn_status_h_mrmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.chn_status_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.chn_status_h_mrmsf1_tm purge;
drop table ${iml_schema}.chn_status_h_mrmsf1_op purge;
drop table ${iml_schema}.chn_status_h_mrmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.chn_status_h_mrmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'chn_status_h', partname => 'p_mrmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
