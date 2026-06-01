/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_cny_fori_exch_mdl_p_h_ncbsf1
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
alter table ${iml_schema}.ref_cny_fori_exch_mdl_p_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_cny_fori_exch_mdl_p_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_tm purge;
drop table ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_op purge;
drop table ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    curr_cd -- 币种代码
    ,curr_sym_cd -- 货币符号代码
    ,convt_cny_exch_rat -- 折人民币汇率
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_cny_fori_exch_mdl_p_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_cny_fori_exch_mdl_p_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_cny_fori_exch_mdl_p_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_mb_ccy_rate-1
insert into ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_tm(
    curr_cd -- 币种代码
    ,curr_sym_cd -- 货币符号代码
    ,convt_cny_exch_rat -- 折人民币汇率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CCY -- 币种代码
    ,P1.CCY -- 货币符号代码
    ,P1.MIDDLE_RATE -- 折人民币汇率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_mb_ccy_rate' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from (select t.*,row_number() over(partition by t.CCY order by t.effect_date desc,t.effect_time desc,t.branch) as rn 
						from (select ccy, middle_rate, effect_time, effect_date, branch, rate_type, quote_type   
						      from ${iol_schema}.ncbs_mb_ccy_rate t1
						      where t1.start_dt <= to_date('${batch_date}','yyyymmdd') 
						      and t1.end_dt > to_date('${batch_date}','yyyymmdd')
						      union all 
						      select ccy, middle_rate, effect_time, effect_date, branch, rate_type, quote_type   
						      from ${iol_schema}.ncbs_mb_ccy_rate_hist t2
						      where t2.start_dt <= to_date('${batch_date}','yyyymmdd') 
						      and t2.end_dt > to_date('${batch_date}','yyyymmdd')) t
						where RATE_TYPE='ZBD'  -- 20221122：核心 陈咸宁/邹声昊 反馈汇率中间价取ZBD-准备金汇率
						and quote_type = 'D'
						and EFFECT_DATE<=to_date('${batch_date}','yyyymmdd')) P1
where 1=1
AND P1.RN=1
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_tm 
  	                                group by 
  	                                        curr_cd
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
        into ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_cl(
            curr_cd -- 币种代码
    ,curr_sym_cd -- 货币符号代码
    ,convt_cny_exch_rat -- 折人民币汇率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_op(
            curr_cd -- 币种代码
    ,curr_sym_cd -- 货币符号代码
    ,convt_cny_exch_rat -- 折人民币汇率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.curr_sym_cd, o.curr_sym_cd) as curr_sym_cd -- 货币符号代码
    ,nvl(n.convt_cny_exch_rat, o.convt_cny_exch_rat) as convt_cny_exch_rat -- 折人民币汇率
    ,case when
            n.curr_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.curr_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.curr_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.curr_cd = n.curr_cd
where (
        o.curr_cd is null
    )
    or (
        n.curr_cd is null
    )
    or (
        o.curr_sym_cd <> n.curr_sym_cd
        or o.convt_cny_exch_rat <> n.convt_cny_exch_rat
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_cl(
            curr_cd -- 币种代码
    ,curr_sym_cd -- 货币符号代码
    ,convt_cny_exch_rat -- 折人民币汇率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_op(
            curr_cd -- 币种代码
    ,curr_sym_cd -- 货币符号代码
    ,convt_cny_exch_rat -- 折人民币汇率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.curr_cd -- 币种代码
    ,o.curr_sym_cd -- 货币符号代码
    ,o.convt_cny_exch_rat -- 折人民币汇率
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
from ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_bk o
    left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_op n
        on
            o.curr_cd = n.curr_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_cl d
        on
            o.curr_cd = d.curr_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_cny_fori_exch_mdl_p_h;
--alter table ${iml_schema}.ref_cny_fori_exch_mdl_p_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ref_cny_fori_exch_mdl_p_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ref_cny_fori_exch_mdl_p_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ref_cny_fori_exch_mdl_p_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ref_cny_fori_exch_mdl_p_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_cl;
alter table ${iml_schema}.ref_cny_fori_exch_mdl_p_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_cny_fori_exch_mdl_p_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_tm purge;
drop table ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_op purge;
drop table ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_cny_fori_exch_mdl_p_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_cny_fori_exch_mdl_p_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
