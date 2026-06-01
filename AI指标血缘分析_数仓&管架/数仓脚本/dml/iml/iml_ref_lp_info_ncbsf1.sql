/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_lp_info_ncbsf1
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
alter table ${iml_schema}.ref_lp_info add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_lp_info_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_lp_info partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_lp_info_ncbsf1_tm purge;
drop table ${iml_schema}.ref_lp_info_ncbsf1_op purge;
drop table ${iml_schema}.ref_lp_info_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_lp_info_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    corp_id -- 公司编号
    ,lp_id -- 法人编号
    ,corp_name -- 公司名称
    ,hq_org_id -- 总行机构编号
    ,multi_lp_allow_acrs_lp_que_flg -- 多法人允许跨法人查询标志
    ,general_exch_lp_id -- 通兑法人编号
    ,general_storage_lp_id -- 通存法人编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_lp_info partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.ref_lp_info_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_lp_info partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.ref_lp_info_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_lp_info partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_fm_company-1
insert into ${iml_schema}.ref_lp_info_ncbsf1_tm(
    corp_id -- 公司编号
    ,lp_id -- 法人编号
    ,corp_name -- 公司名称
    ,hq_org_id -- 总行机构编号
    ,multi_lp_allow_acrs_lp_que_flg -- 多法人允许跨法人查询标志
    ,general_exch_lp_id -- 通兑法人编号
    ,general_storage_lp_id -- 通存法人编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.COMPANY -- 公司编号
    ,'9999' -- 法人编号
    ,P1.COMPANY_NAME -- 公司名称
    ,P1.HEAD_OFFICE_CODE -- 总行机构编号
    ,DECODE(P1.MULTI_CORP_QUERY_ALLOW,'Y','1','N','0') -- 多法人允许跨法人查询标志
    ,P1.ALL_DRA_COMPANY -- 通兑法人编号
    ,P1.ALL_DEP_COMPANY -- 通存法人编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_fm_company' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_fm_company p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_lp_info_ncbsf1_tm 
  	                                group by 
  	                                        corp_id
  	                                        ,lp_id
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
        into ${iml_schema}.ref_lp_info_ncbsf1_cl(
            corp_id -- 公司编号
    ,lp_id -- 法人编号
    ,corp_name -- 公司名称
    ,hq_org_id -- 总行机构编号
    ,multi_lp_allow_acrs_lp_que_flg -- 多法人允许跨法人查询标志
    ,general_exch_lp_id -- 通兑法人编号
    ,general_storage_lp_id -- 通存法人编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_lp_info_ncbsf1_op(
            corp_id -- 公司编号
    ,lp_id -- 法人编号
    ,corp_name -- 公司名称
    ,hq_org_id -- 总行机构编号
    ,multi_lp_allow_acrs_lp_que_flg -- 多法人允许跨法人查询标志
    ,general_exch_lp_id -- 通兑法人编号
    ,general_storage_lp_id -- 通存法人编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.corp_id, o.corp_id) as corp_id -- 公司编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 公司名称
    ,nvl(n.hq_org_id, o.hq_org_id) as hq_org_id -- 总行机构编号
    ,nvl(n.multi_lp_allow_acrs_lp_que_flg, o.multi_lp_allow_acrs_lp_que_flg) as multi_lp_allow_acrs_lp_que_flg -- 多法人允许跨法人查询标志
    ,nvl(n.general_exch_lp_id, o.general_exch_lp_id) as general_exch_lp_id -- 通兑法人编号
    ,nvl(n.general_storage_lp_id, o.general_storage_lp_id) as general_storage_lp_id -- 通存法人编号
    ,case when
            n.corp_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.corp_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.corp_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_lp_info_ncbsf1_tm n
    full join (select * from ${iml_schema}.ref_lp_info_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.corp_id = n.corp_id
            and o.lp_id = n.lp_id
where (
        o.corp_id is null
        and o.lp_id is null
    )
    or (
        n.corp_id is null
        and n.lp_id is null
    )
    or (
        o.corp_name <> n.corp_name
        or o.hq_org_id <> n.hq_org_id
        or o.multi_lp_allow_acrs_lp_que_flg <> n.multi_lp_allow_acrs_lp_que_flg
        or o.general_exch_lp_id <> n.general_exch_lp_id
        or o.general_storage_lp_id <> n.general_storage_lp_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_lp_info_ncbsf1_cl(
            corp_id -- 公司编号
    ,lp_id -- 法人编号
    ,corp_name -- 公司名称
    ,hq_org_id -- 总行机构编号
    ,multi_lp_allow_acrs_lp_que_flg -- 多法人允许跨法人查询标志
    ,general_exch_lp_id -- 通兑法人编号
    ,general_storage_lp_id -- 通存法人编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_lp_info_ncbsf1_op(
            corp_id -- 公司编号
    ,lp_id -- 法人编号
    ,corp_name -- 公司名称
    ,hq_org_id -- 总行机构编号
    ,multi_lp_allow_acrs_lp_que_flg -- 多法人允许跨法人查询标志
    ,general_exch_lp_id -- 通兑法人编号
    ,general_storage_lp_id -- 通存法人编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.corp_id -- 公司编号
    ,o.lp_id -- 法人编号
    ,o.corp_name -- 公司名称
    ,o.hq_org_id -- 总行机构编号
    ,o.multi_lp_allow_acrs_lp_que_flg -- 多法人允许跨法人查询标志
    ,o.general_exch_lp_id -- 通兑法人编号
    ,o.general_storage_lp_id -- 通存法人编号
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
from ${iml_schema}.ref_lp_info_ncbsf1_bk o
    left join ${iml_schema}.ref_lp_info_ncbsf1_op n
        on
            o.corp_id = n.corp_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_lp_info_ncbsf1_cl d
        on
            o.corp_id = d.corp_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_lp_info;
--alter table ${iml_schema}.ref_lp_info truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ref_lp_info') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ref_lp_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_lp_info modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ref_lp_info exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.ref_lp_info_ncbsf1_cl;
alter table ${iml_schema}.ref_lp_info exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.ref_lp_info_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_lp_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_lp_info_ncbsf1_tm purge;
drop table ${iml_schema}.ref_lp_info_ncbsf1_op purge;
drop table ${iml_schema}.ref_lp_info_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_lp_info_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_lp_info', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
