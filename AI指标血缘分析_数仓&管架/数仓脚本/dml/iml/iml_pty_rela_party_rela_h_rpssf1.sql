/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_rela_party_rela_h_rpssf1
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
alter table ${iml_schema}.pty_rela_party_rela_h add partition p_rpssf1 values ('rpssf1')(
        subpartition p_rpssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_rpssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_rela_party_rela_h_rpssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_rela_party_rela_h partition for ('rpssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_rela_party_rela_h_rpssf1_tm purge;
drop table ${iml_schema}.pty_rela_party_rela_h_rpssf1_op purge;
drop table ${iml_schema}.pty_rela_party_rela_h_rpssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_rela_party_rela_h_rpssf1_tm nologging
compress ${option_switch} for query high
as select
    rela_party_id -- 关联方编号
    ,lp_id -- 法人编号
    ,rela_party_super_id -- 关联方上级编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,incid_rela_cd -- 关联关系代码
    ,final_update_tm -- 最后更新时间
    ,final_update_affair_tm -- 最后更新事务时间
    ,create_tm -- 创建时间
    ,create_affair_tm -- 创建事务时间
    ,and_up_level_mgers_rela_cd -- 与上层管理方关系代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_rela_party_rela_h partition for ('rpssf1')
where 0=1
;

create table ${iml_schema}.pty_rela_party_rela_h_rpssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_rela_party_rela_h partition for ('rpssf1') where 0=1;

create table ${iml_schema}.pty_rela_party_rela_h_rpssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_rela_party_rela_h partition for ('rpssf1') where 0=1;

-- 3.1 get new data into table
-- rpss_related_relationship-
insert into ${iml_schema}.pty_rela_party_rela_h_rpssf1_tm(
    rela_party_id -- 关联方编号
    ,lp_id -- 法人编号
    ,rela_party_super_id -- 关联方上级编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,incid_rela_cd -- 关联关系代码
    ,final_update_tm -- 最后更新时间
    ,final_update_affair_tm -- 最后更新事务时间
    ,create_tm -- 创建时间
    ,create_affair_tm -- 创建事务时间
    ,and_up_level_mgers_rela_cd -- 与上层管理方关系代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.RELATED_ID_TO -- 关联方编号
    ,'9999' -- 法人编号
    ,P1.RELATED_ID_FROM -- 关联方上级编号
    ,P1.FROM_DATE -- 生效日期
    ,P1.THRU_DATE -- 失效日期
    ,P1.RELATED_RELATIONSHIP_TYPE_ID -- 关联关系代码
    ,P1.LAST_UPDATED_STAMP -- 最后更新时间
    ,P1.LAST_UPDATED_TX_STAMP -- 最后更新事务时间
    ,P1.CREATED_STAMP -- 创建时间
    ,P1.CREATED_TX_STAMP -- 创建事务时间
    ,P1.RELATION_TYPE -- 与上层管理方关系代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rpss_related_relationship' -- 源表名称
    ,'rpssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rpss_related_relationship p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_rela_party_rela_h_rpssf1_tm 
  	                                group by 
  	                                        rela_party_id
  	                                        ,lp_id
  	                                        ,rela_party_super_id
  	                                        ,effect_dt
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
        into ${iml_schema}.pty_rela_party_rela_h_rpssf1_cl(
            rela_party_id -- 关联方编号
    ,lp_id -- 法人编号
    ,rela_party_super_id -- 关联方上级编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,incid_rela_cd -- 关联关系代码
    ,final_update_tm -- 最后更新时间
    ,final_update_affair_tm -- 最后更新事务时间
    ,create_tm -- 创建时间
    ,create_affair_tm -- 创建事务时间
    ,and_up_level_mgers_rela_cd -- 与上层管理方关系代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_rela_party_rela_h_rpssf1_op(
            rela_party_id -- 关联方编号
    ,lp_id -- 法人编号
    ,rela_party_super_id -- 关联方上级编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,incid_rela_cd -- 关联关系代码
    ,final_update_tm -- 最后更新时间
    ,final_update_affair_tm -- 最后更新事务时间
    ,create_tm -- 创建时间
    ,create_affair_tm -- 创建事务时间
    ,and_up_level_mgers_rela_cd -- 与上层管理方关系代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rela_party_id, o.rela_party_id) as rela_party_id -- 关联方编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.rela_party_super_id, o.rela_party_super_id) as rela_party_super_id -- 关联方上级编号
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.incid_rela_cd, o.incid_rela_cd) as incid_rela_cd -- 关联关系代码
    ,nvl(n.final_update_tm, o.final_update_tm) as final_update_tm -- 最后更新时间
    ,nvl(n.final_update_affair_tm, o.final_update_affair_tm) as final_update_affair_tm -- 最后更新事务时间
    ,nvl(n.create_tm, o.create_tm) as create_tm -- 创建时间
    ,nvl(n.create_affair_tm, o.create_affair_tm) as create_affair_tm -- 创建事务时间
    ,nvl(n.and_up_level_mgers_rela_cd, o.and_up_level_mgers_rela_cd) as and_up_level_mgers_rela_cd -- 与上层管理方关系代码
    ,case when
            n.rela_party_id is null
            and n.lp_id is null
            and n.rela_party_super_id is null
            and n.effect_dt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rela_party_id is null
            and n.lp_id is null
            and n.rela_party_super_id is null
            and n.effect_dt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rela_party_id is null
            and n.lp_id is null
            and n.rela_party_super_id is null
            and n.effect_dt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_rela_party_rela_h_rpssf1_tm n
    full join (select * from ${iml_schema}.pty_rela_party_rela_h_rpssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.rela_party_id = n.rela_party_id
            and o.lp_id = n.lp_id
            and o.rela_party_super_id = n.rela_party_super_id
            and o.effect_dt = n.effect_dt
where (
        o.rela_party_id is null
        and o.lp_id is null
        and o.rela_party_super_id is null
        and o.effect_dt is null
    )
    or (
        n.rela_party_id is null
        and n.lp_id is null
        and n.rela_party_super_id is null
        and n.effect_dt is null
    )
    or (
        o.invalid_dt <> n.invalid_dt
        or o.incid_rela_cd <> n.incid_rela_cd
        or o.final_update_tm <> n.final_update_tm
        or o.final_update_affair_tm <> n.final_update_affair_tm
        or o.create_tm <> n.create_tm
        or o.create_affair_tm <> n.create_affair_tm
        or o.and_up_level_mgers_rela_cd <> n.and_up_level_mgers_rela_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_rela_party_rela_h_rpssf1_cl(
            rela_party_id -- 关联方编号
    ,lp_id -- 法人编号
    ,rela_party_super_id -- 关联方上级编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,incid_rela_cd -- 关联关系代码
    ,final_update_tm -- 最后更新时间
    ,final_update_affair_tm -- 最后更新事务时间
    ,create_tm -- 创建时间
    ,create_affair_tm -- 创建事务时间
    ,and_up_level_mgers_rela_cd -- 与上层管理方关系代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_rela_party_rela_h_rpssf1_op(
            rela_party_id -- 关联方编号
    ,lp_id -- 法人编号
    ,rela_party_super_id -- 关联方上级编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,incid_rela_cd -- 关联关系代码
    ,final_update_tm -- 最后更新时间
    ,final_update_affair_tm -- 最后更新事务时间
    ,create_tm -- 创建时间
    ,create_affair_tm -- 创建事务时间
    ,and_up_level_mgers_rela_cd -- 与上层管理方关系代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rela_party_id -- 关联方编号
    ,o.lp_id -- 法人编号
    ,o.rela_party_super_id -- 关联方上级编号
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.incid_rela_cd -- 关联关系代码
    ,o.final_update_tm -- 最后更新时间
    ,o.final_update_affair_tm -- 最后更新事务时间
    ,o.create_tm -- 创建时间
    ,o.create_affair_tm -- 创建事务时间
    ,o.and_up_level_mgers_rela_cd -- 与上层管理方关系代码
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
from ${iml_schema}.pty_rela_party_rela_h_rpssf1_bk o
    left join ${iml_schema}.pty_rela_party_rela_h_rpssf1_op n
        on
            o.rela_party_id = n.rela_party_id
            and o.lp_id = n.lp_id
            and o.rela_party_super_id = n.rela_party_super_id
            and o.effect_dt = n.effect_dt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_rela_party_rela_h_rpssf1_cl d
        on
            o.rela_party_id = d.rela_party_id
            and o.lp_id = d.lp_id
            and o.rela_party_super_id = d.rela_party_super_id
            and o.effect_dt = d.effect_dt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_rela_party_rela_h;
--alter table ${iml_schema}.pty_rela_party_rela_h truncate partition for ('rpssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_rela_party_rela_h') 
               and substr(subpartition_name,1,8)=upper('p_rpssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_rela_party_rela_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_rela_party_rela_h modify partition p_rpssf1 
add subpartition p_rpssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_rela_party_rela_h exchange subpartition p_rpssf1_${batch_date} with table ${iml_schema}.pty_rela_party_rela_h_rpssf1_cl;
alter table ${iml_schema}.pty_rela_party_rela_h exchange subpartition p_rpssf1_20991231 with table ${iml_schema}.pty_rela_party_rela_h_rpssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_rela_party_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_rela_party_rela_h_rpssf1_tm purge;
drop table ${iml_schema}.pty_rela_party_rela_h_rpssf1_op purge;
drop table ${iml_schema}.pty_rela_party_rela_h_rpssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_rela_party_rela_h_rpssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_rela_party_rela_h', partname => 'p_rpssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
