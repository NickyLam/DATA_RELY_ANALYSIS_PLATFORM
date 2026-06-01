/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_party_rating_h_isbsf1
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
alter table ${iml_schema}.pty_party_rating_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_party_rating_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_rating_h partition for ('isbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_party_rating_h_isbsf1_tm purge;
drop table ${iml_schema}.pty_party_rating_h_isbsf1_op purge;
drop table ${iml_schema}.pty_party_rating_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_rating_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,party_rating_type_cd -- 当事人评级类型代码
    ,seq_num -- 序号
    ,rating_org_id -- 评级机构编号
    ,rating_org_name -- 评级机构名称
    ,rating_dt -- 评级日期
    ,rating_score_val -- 评级分值
    ,rating_effect_dt -- 评级生效日期
    ,rating_invalid_dt -- 评级失效日期
    ,rating_result_cd -- 评级结果代码
    ,irs_task_flow_num -- 内评系统任务流水号
    ,rating_level_cd -- 评级等级代码
    ,lmt -- 限额
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_rating_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.pty_party_rating_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_rating_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.pty_party_rating_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_rating_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_pty-1
insert into ${iml_schema}.pty_party_rating_h_isbsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,party_rating_type_cd -- 当事人评级类型代码
    ,seq_num -- 序号
    ,rating_org_id -- 评级机构编号
    ,rating_org_name -- 评级机构名称
    ,rating_dt -- 评级日期
    ,rating_score_val -- 评级分值
    ,rating_effect_dt -- 评级生效日期
    ,rating_invalid_dt -- 评级失效日期
    ,rating_result_cd -- 评级结果代码
    ,irs_task_flow_num -- 内评系统任务流水号
    ,rating_level_cd -- 评级等级代码
    ,lmt -- 限额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    'ISBS01'|| P1.INR -- 当事人编号
    ,'9999' -- 法人编号
    ,'ISBS' -- 源系统代码
    ,'06' -- 当事人评级类型代码
    ,'1' -- 序号
    ,' ' -- 评级机构编号
    ,' ' -- 评级机构名称
    ,to_date('00010101','yyyymmdd') -- 评级日期
    ,0.0 -- 评级分值
    ,to_date('00010101','yyyymmdd') -- 评级生效日期
    ,to_date('20991231','yyyymmdd') -- 评级失效日期
    ,' ' -- 评级结果代码
    ,' ' -- 内评系统任务流水号
    ,case when R1.TARGET_CD_VAL is not null then R1.TARGET_CD_VAL else '@'|| P1.RSKCLS end  -- 评级等级代码
    ,0.0 -- 限额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_pty' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_pty p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.RSKCLS=R1.SRC_CODE_VAL
AND R1.SORC_SYS_CD='ISBS'
AND R1.SRC_TAB_EN_NAME='ISBS_PTY'
AND R1.SRC_FIELD_EN_NAME='RSKCLS'
AND R1.TARGET_TAB_EN_NAME='PTY_PARTY_RATING_H'
AND R1.TARGET_TAB_FIELD_EN_NAME='RATING_LEVEL_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_party_rating_h_isbsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                                        ,sorc_sys_cd
  	                                        ,party_rating_type_cd
  	                                        ,seq_num
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
        into ${iml_schema}.pty_party_rating_h_isbsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,party_rating_type_cd -- 当事人评级类型代码
    ,seq_num -- 序号
    ,rating_org_id -- 评级机构编号
    ,rating_org_name -- 评级机构名称
    ,rating_dt -- 评级日期
    ,rating_score_val -- 评级分值
    ,rating_effect_dt -- 评级生效日期
    ,rating_invalid_dt -- 评级失效日期
    ,rating_result_cd -- 评级结果代码
    ,irs_task_flow_num -- 内评系统任务流水号
    ,rating_level_cd -- 评级等级代码
    ,lmt -- 限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_rating_h_isbsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,party_rating_type_cd -- 当事人评级类型代码
    ,seq_num -- 序号
    ,rating_org_id -- 评级机构编号
    ,rating_org_name -- 评级机构名称
    ,rating_dt -- 评级日期
    ,rating_score_val -- 评级分值
    ,rating_effect_dt -- 评级生效日期
    ,rating_invalid_dt -- 评级失效日期
    ,rating_result_cd -- 评级结果代码
    ,irs_task_flow_num -- 内评系统任务流水号
    ,rating_level_cd -- 评级等级代码
    ,lmt -- 限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.sorc_sys_cd, o.sorc_sys_cd) as sorc_sys_cd -- 源系统代码
    ,nvl(n.party_rating_type_cd, o.party_rating_type_cd) as party_rating_type_cd -- 当事人评级类型代码
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.rating_org_id, o.rating_org_id) as rating_org_id -- 评级机构编号
    ,nvl(n.rating_org_name, o.rating_org_name) as rating_org_name -- 评级机构名称
    ,nvl(n.rating_dt, o.rating_dt) as rating_dt -- 评级日期
    ,nvl(n.rating_score_val, o.rating_score_val) as rating_score_val -- 评级分值
    ,nvl(n.rating_effect_dt, o.rating_effect_dt) as rating_effect_dt -- 评级生效日期
    ,nvl(n.rating_invalid_dt, o.rating_invalid_dt) as rating_invalid_dt -- 评级失效日期
    ,nvl(n.rating_result_cd, o.rating_result_cd) as rating_result_cd -- 评级结果代码
    ,nvl(n.irs_task_flow_num, o.irs_task_flow_num) as irs_task_flow_num -- 内评系统任务流水号
    ,nvl(n.rating_level_cd, o.rating_level_cd) as rating_level_cd -- 评级等级代码
    ,nvl(n.lmt, o.lmt) as lmt -- 限额
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
            and n.party_rating_type_cd is null
            and n.seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
            and n.party_rating_type_cd is null
            and n.seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
            and n.party_rating_type_cd is null
            and n.seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_rating_h_isbsf1_tm n
    full join (select * from ${iml_schema}.pty_party_rating_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
            and o.party_rating_type_cd = n.party_rating_type_cd
            and o.seq_num = n.seq_num
where (
        o.party_id is null
        and o.lp_id is null
        and o.sorc_sys_cd is null
        and o.party_rating_type_cd is null
        and o.seq_num is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
        and n.sorc_sys_cd is null
        and n.party_rating_type_cd is null
        and n.seq_num is null
    )
    or (
        o.rating_org_id <> n.rating_org_id
        or o.rating_org_name <> n.rating_org_name
        or o.rating_dt <> n.rating_dt
        or o.rating_score_val <> n.rating_score_val
        or o.rating_effect_dt <> n.rating_effect_dt
        or o.rating_invalid_dt <> n.rating_invalid_dt
        or o.rating_result_cd <> n.rating_result_cd
        or o.irs_task_flow_num <> n.irs_task_flow_num
        or o.rating_level_cd <> n.rating_level_cd
        or o.lmt <> n.lmt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_party_rating_h_isbsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,party_rating_type_cd -- 当事人评级类型代码
    ,seq_num -- 序号
    ,rating_org_id -- 评级机构编号
    ,rating_org_name -- 评级机构名称
    ,rating_dt -- 评级日期
    ,rating_score_val -- 评级分值
    ,rating_effect_dt -- 评级生效日期
    ,rating_invalid_dt -- 评级失效日期
    ,rating_result_cd -- 评级结果代码
    ,irs_task_flow_num -- 内评系统任务流水号
    ,rating_level_cd -- 评级等级代码
    ,lmt -- 限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_rating_h_isbsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,party_rating_type_cd -- 当事人评级类型代码
    ,seq_num -- 序号
    ,rating_org_id -- 评级机构编号
    ,rating_org_name -- 评级机构名称
    ,rating_dt -- 评级日期
    ,rating_score_val -- 评级分值
    ,rating_effect_dt -- 评级生效日期
    ,rating_invalid_dt -- 评级失效日期
    ,rating_result_cd -- 评级结果代码
    ,irs_task_flow_num -- 内评系统任务流水号
    ,rating_level_cd -- 评级等级代码
    ,lmt -- 限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.sorc_sys_cd -- 源系统代码
    ,o.party_rating_type_cd -- 当事人评级类型代码
    ,o.seq_num -- 序号
    ,o.rating_org_id -- 评级机构编号
    ,o.rating_org_name -- 评级机构名称
    ,o.rating_dt -- 评级日期
    ,o.rating_score_val -- 评级分值
    ,o.rating_effect_dt -- 评级生效日期
    ,o.rating_invalid_dt -- 评级失效日期
    ,o.rating_result_cd -- 评级结果代码
    ,o.irs_task_flow_num -- 内评系统任务流水号
    ,o.rating_level_cd -- 评级等级代码
    ,o.lmt -- 限额
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
from ${iml_schema}.pty_party_rating_h_isbsf1_bk o
    left join ${iml_schema}.pty_party_rating_h_isbsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
            and o.party_rating_type_cd = n.party_rating_type_cd
            and o.seq_num = n.seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_party_rating_h_isbsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.sorc_sys_cd = d.sorc_sys_cd
            and o.party_rating_type_cd = d.party_rating_type_cd
            and o.seq_num = d.seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_party_rating_h;
--alter table ${iml_schema}.pty_party_rating_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_party_rating_h') 
               and substr(subpartition_name,1,8)=upper('p_isbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_party_rating_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_party_rating_h modify partition p_isbsf1 
add subpartition p_isbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_party_rating_h exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.pty_party_rating_h_isbsf1_cl;
alter table ${iml_schema}.pty_party_rating_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.pty_party_rating_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_party_rating_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_party_rating_h_isbsf1_tm purge;
drop table ${iml_schema}.pty_party_rating_h_isbsf1_op purge;
drop table ${iml_schema}.pty_party_rating_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_party_rating_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_party_rating_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
