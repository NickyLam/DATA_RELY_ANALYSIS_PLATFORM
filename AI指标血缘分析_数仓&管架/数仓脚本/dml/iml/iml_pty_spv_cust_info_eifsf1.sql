/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_spv_cust_info_eifsf1
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
alter table ${iml_schema}.pty_spv_cust_info add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_eifsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_spv_cust_info_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_spv_cust_info partition for ('eifsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_spv_cust_info_eifsf1_tm purge;
drop table ${iml_schema}.pty_spv_cust_info_eifsf1_op purge;
drop table ${iml_schema}.pty_spv_cust_info_eifsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_spv_cust_info_eifsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,spv_cust_id -- SPV客户编号
    ,spv_id -- SPV编号
    ,spv_name -- SPV名称
    ,spv_type_cd -- SPV类型代码
    ,am_prod_stat_type_id -- 资管产品统计类型编号
    ,cash_mgmt_prod_flg -- 现金管理产品标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_spv_cust_info partition for ('eifsf1')
where 0=1
;

create table ${iml_schema}.pty_spv_cust_info_eifsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_spv_cust_info partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_spv_cust_info_eifsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_spv_cust_info partition for ('eifsf1') where 0=1;

-- 3.1 get new data into table
-- eifs_t99_spv_cust_info-1
insert into ${iml_schema}.pty_spv_cust_info_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,spv_cust_id -- SPV客户编号
    ,spv_id -- SPV编号
    ,spv_name -- SPV名称
    ,spv_type_cd -- SPV类型代码
    ,am_prod_stat_type_id -- 资管产品统计类型编号
    ,cash_mgmt_prod_flg -- 现金管理产品标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ORG_CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.CUST_NUM -- SPV客户编号
    ,P1.SPV_CD -- SPV编号
    ,P1.CUST_NAME -- SPV名称
    ,NVL(TRIM(P1.SPV_YTPE),'-') -- SPV类型代码
    ,P1.PROD_STAT_CD -- 资管产品统计类型编号
    ,decode(trim(P1.IS_CASH_MAGM),'Y','1','N','0','','-',P1.IS_CASH_MAGM) -- 现金管理产品标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t99_spv_cust_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t99_spv_cust_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND P1.UPDATED_TS = to_timestamp('9999-12-31 00:00:00','YYYY-MM-DD HH24:MI:SS')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_spv_cust_info_eifsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                                        ,spv_cust_id
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
        into ${iml_schema}.pty_spv_cust_info_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,spv_cust_id -- SPV客户编号
    ,spv_id -- SPV编号
    ,spv_name -- SPV名称
    ,spv_type_cd -- SPV类型代码
    ,am_prod_stat_type_id -- 资管产品统计类型编号
    ,cash_mgmt_prod_flg -- 现金管理产品标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_spv_cust_info_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,spv_cust_id -- SPV客户编号
    ,spv_id -- SPV编号
    ,spv_name -- SPV名称
    ,spv_type_cd -- SPV类型代码
    ,am_prod_stat_type_id -- 资管产品统计类型编号
    ,cash_mgmt_prod_flg -- 现金管理产品标志
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
    ,nvl(n.spv_cust_id, o.spv_cust_id) as spv_cust_id -- SPV客户编号
    ,nvl(n.spv_id, o.spv_id) as spv_id -- SPV编号
    ,nvl(n.spv_name, o.spv_name) as spv_name -- SPV名称
    ,nvl(n.spv_type_cd, o.spv_type_cd) as spv_type_cd -- SPV类型代码
    ,nvl(n.am_prod_stat_type_id, o.am_prod_stat_type_id) as am_prod_stat_type_id -- 资管产品统计类型编号
    ,nvl(n.cash_mgmt_prod_flg, o.cash_mgmt_prod_flg) as cash_mgmt_prod_flg -- 现金管理产品标志
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.spv_cust_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.spv_cust_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.spv_cust_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_spv_cust_info_eifsf1_tm n
    full join (select * from ${iml_schema}.pty_spv_cust_info_eifsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.spv_cust_id = n.spv_cust_id
where (
        o.party_id is null
        and o.lp_id is null
        and o.spv_cust_id is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
        and n.spv_cust_id is null
    )
    or (
        o.spv_id <> n.spv_id
        or o.spv_name <> n.spv_name
        or o.spv_type_cd <> n.spv_type_cd
        or o.am_prod_stat_type_id <> n.am_prod_stat_type_id
        or o.cash_mgmt_prod_flg <> n.cash_mgmt_prod_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_spv_cust_info_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,spv_cust_id -- SPV客户编号
    ,spv_id -- SPV编号
    ,spv_name -- SPV名称
    ,spv_type_cd -- SPV类型代码
    ,am_prod_stat_type_id -- 资管产品统计类型编号
    ,cash_mgmt_prod_flg -- 现金管理产品标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_spv_cust_info_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,spv_cust_id -- SPV客户编号
    ,spv_id -- SPV编号
    ,spv_name -- SPV名称
    ,spv_type_cd -- SPV类型代码
    ,am_prod_stat_type_id -- 资管产品统计类型编号
    ,cash_mgmt_prod_flg -- 现金管理产品标志
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
    ,o.spv_cust_id -- SPV客户编号
    ,o.spv_id -- SPV编号
    ,o.spv_name -- SPV名称
    ,o.spv_type_cd -- SPV类型代码
    ,o.am_prod_stat_type_id -- 资管产品统计类型编号
    ,o.cash_mgmt_prod_flg -- 现金管理产品标志
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
from ${iml_schema}.pty_spv_cust_info_eifsf1_bk o
    left join ${iml_schema}.pty_spv_cust_info_eifsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.spv_cust_id = n.spv_cust_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_spv_cust_info_eifsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.spv_cust_id = d.spv_cust_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_spv_cust_info;
--alter table ${iml_schema}.pty_spv_cust_info truncate partition for ('eifsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_spv_cust_info') 
               and substr(subpartition_name,1,8)=upper('p_eifsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_spv_cust_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_spv_cust_info modify partition p_eifsf1 
add subpartition p_eifsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_spv_cust_info exchange subpartition p_eifsf1_${batch_date} with table ${iml_schema}.pty_spv_cust_info_eifsf1_cl;
alter table ${iml_schema}.pty_spv_cust_info exchange subpartition p_eifsf1_20991231 with table ${iml_schema}.pty_spv_cust_info_eifsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_spv_cust_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_spv_cust_info_eifsf1_tm purge;
drop table ${iml_schema}.pty_spv_cust_info_eifsf1_op purge;
drop table ${iml_schema}.pty_spv_cust_info_eifsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_spv_cust_info_eifsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_spv_cust_info', partname => 'p_eifsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
