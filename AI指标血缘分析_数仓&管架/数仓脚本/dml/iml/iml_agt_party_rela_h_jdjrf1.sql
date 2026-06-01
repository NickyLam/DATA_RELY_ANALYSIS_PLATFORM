/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_party_rela_h_jdjrf1
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
alter table ${iml_schema}.agt_party_rela_h add partition p_jdjrf1 values ('jdjrf1')(
        subpartition p_jdjrf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_jdjrf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_party_rela_h_jdjrf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_party_rela_h partition for ('jdjrf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_party_rela_h_jdjrf1_tm purge;
drop table ${iml_schema}.agt_party_rela_h_jdjrf1_op purge;
drop table ${iml_schema}.agt_party_rela_h_jdjrf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_party_rela_h_jdjrf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_party_rela_type_cd -- 协议当事人关系类型代码
    ,seq_num -- 序号
    ,party_id -- 当事人编号
    ,ratio -- 比例
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_party_rela_h partition for ('jdjrf1')
where 0=1
;

create table ${iml_schema}.agt_party_rela_h_jdjrf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_party_rela_h partition for ('jdjrf1') where 0=1;

create table ${iml_schema}.agt_party_rela_h_jdjrf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_party_rela_h partition for ('jdjrf1') where 0=1;

-- 3.1 get new data into table
-- icms_jdjr_acc_loan-
insert into ${iml_schema}.agt_party_rela_h_jdjrf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_party_rela_type_cd -- 协议当事人关系类型代码
    ,seq_num -- 序号
    ,party_id -- 当事人编号
    ,ratio -- 比例
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222304'||P1.CONTNO -- 协议编号
    ,'9999' -- 法人编号
    ,'02' -- 协议当事人关系类型代码
    ,'1' -- 序号
    ,P1.INPUTID -- 当事人编号
    ,0.0 -- 比例
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_jdjr_acc_loan' -- 源表名称
    ,'jdjrf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_jdjr_acc_loan p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_party_rela_h_jdjrf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,agt_party_rela_type_cd
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
        into ${iml_schema}.agt_party_rela_h_jdjrf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_party_rela_type_cd -- 协议当事人关系类型代码
    ,seq_num -- 序号
    ,party_id -- 当事人编号
    ,ratio -- 比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_party_rela_h_jdjrf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_party_rela_type_cd -- 协议当事人关系类型代码
    ,seq_num -- 序号
    ,party_id -- 当事人编号
    ,ratio -- 比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.agt_party_rela_type_cd, o.agt_party_rela_type_cd) as agt_party_rela_type_cd -- 协议当事人关系类型代码
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.ratio, o.ratio) as ratio -- 比例
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.agt_party_rela_type_cd is null
            and n.seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.agt_party_rela_type_cd is null
            and n.seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.agt_party_rela_type_cd is null
            and n.seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_party_rela_h_jdjrf1_tm n
    full join (select * from ${iml_schema}.agt_party_rela_h_jdjrf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.agt_party_rela_type_cd = n.agt_party_rela_type_cd
            and o.seq_num = n.seq_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.agt_party_rela_type_cd is null
        and o.seq_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.agt_party_rela_type_cd is null
        and n.seq_num is null
    )
    or (
        o.party_id <> n.party_id
        or o.ratio <> n.ratio
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_party_rela_h_jdjrf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_party_rela_type_cd -- 协议当事人关系类型代码
    ,seq_num -- 序号
    ,party_id -- 当事人编号
    ,ratio -- 比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_party_rela_h_jdjrf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_party_rela_type_cd -- 协议当事人关系类型代码
    ,seq_num -- 序号
    ,party_id -- 当事人编号
    ,ratio -- 比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.agt_party_rela_type_cd -- 协议当事人关系类型代码
    ,o.seq_num -- 序号
    ,o.party_id -- 当事人编号
    ,o.ratio -- 比例
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
from ${iml_schema}.agt_party_rela_h_jdjrf1_bk o
    left join ${iml_schema}.agt_party_rela_h_jdjrf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.agt_party_rela_type_cd = n.agt_party_rela_type_cd
            and o.seq_num = n.seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_party_rela_h_jdjrf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.agt_party_rela_type_cd = d.agt_party_rela_type_cd
            and o.seq_num = d.seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_party_rela_h;
--alter table ${iml_schema}.agt_party_rela_h truncate partition for ('jdjrf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_party_rela_h') 
               and substr(subpartition_name,1,8)=upper('p_jdjrf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_party_rela_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_party_rela_h modify partition p_jdjrf1 
add subpartition p_jdjrf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_party_rela_h exchange subpartition p_jdjrf1_${batch_date} with table ${iml_schema}.agt_party_rela_h_jdjrf1_cl;
alter table ${iml_schema}.agt_party_rela_h exchange subpartition p_jdjrf1_20991231 with table ${iml_schema}.agt_party_rela_h_jdjrf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_party_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_party_rela_h_jdjrf1_tm purge;
drop table ${iml_schema}.agt_party_rela_h_jdjrf1_op purge;
drop table ${iml_schema}.agt_party_rela_h_jdjrf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_party_rela_h_jdjrf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_party_rela_h', partname => 'p_jdjrf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
