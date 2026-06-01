/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_fin_am_prod_subj_bal_h_famsf2
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
alter table ${iml_schema}.fin_am_prod_subj_bal_h add partition p_famsf2 values ('famsf2')(
        subpartition p_famsf2_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_famsf2_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_am_prod_subj_bal_h partition for ('famsf2')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_tm purge;
drop table ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_op purge;
drop table ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_tm nologging
compress ${option_switch} for query high
as select
    sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,subj_id -- 科目编号
    ,prod_id -- 产品编号
    ,src_prod_id -- 源产品编号
    ,super_subj_id -- 上级科目编号
    ,subj_level_cd -- 科目等级代码
    ,bal_dir_cd -- 科目余额方向
    ,oc_curr_cd -- 原币币种代码
    ,oc_bal -- 原币余额
    ,dc_curr_cd -- 本币币种代码
    ,dc_bal -- 本币余额
    ,noth_subor_subj_flg -- 无下级科目标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_am_prod_subj_bal_h partition for ('famsf2')
where 0=1
;

create table ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_am_prod_subj_bal_h partition for ('famsf2') where 0=1;

create table ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_am_prod_subj_bal_h partition for ('famsf2') where 0=1;

-- 3.1 get new data into table
-- fams_ban_bank_bok_balance-1
insert into ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_tm(
    sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,subj_id -- 科目编号
    ,prod_id -- 产品编号
    ,src_prod_id -- 源产品编号
    ,super_subj_id -- 上级科目编号
    ,subj_level_cd -- 科目等级代码
    ,bal_dir_cd -- 科目余额方向
    ,oc_curr_cd -- 原币币种代码
    ,oc_bal -- 原币余额
    ,dc_curr_cd -- 本币币种代码
    ,dc_bal -- 本币余额
    ,noth_subor_subj_flg -- 无下级科目标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.BOOKSET_ID -- 账套编号
    ,'9999' -- 法人编号
    ,P1.SUBJECT_NO -- 科目编号
    ,case when P2.FINPROD_TYPE2 in ('F16','F24','F26') then '223002'||P2.FINPROD_ID
     else '223003'||P2.FINPROD_ID end -- 产品编号
    ,P1.FINPROD_ID -- 源产品编号
    ,P1.FSUBJECT_NO -- 上级科目编号
    ,P1.SUBJECT_LEVEL -- 科目等级代码
    ,P1.BAL_FLAG -- 科目余额方向
    ,NVL(TRIM(P1.O_CCY),'-') -- 原币币种代码
    ,P1.O_AMT -- 原币余额
    ,NVL(TRIM(P1.B_CCY),'-') -- 本币币种代码
    ,P1.B_AMT -- 本币余额
    ,CASE WHEN P1.IS_LEAF ='N' THEN '0' WHEN P1.IS_LEAF ='Y' THEN '1' ELSE '-' END -- 无下级科目标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_ban_bank_bok_balance' -- 源表名称
    ,'famsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_ban_bank_bok_balance p1
    left join ${iol_schema}.fams_fin_product p2 on p1.finprod_id=p2.finprod_id
 and P2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND  P2.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and P1.BALANCE_DATE = to_date('${batch_date}','yyyymmdd')
and p2.finprod_id is not null
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_tm 
  	                                group by 
  	                                        sob_id
  	                                        ,lp_id
  	                                        ,subj_id
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
        into ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_cl(
            sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,subj_id -- 科目编号
    ,prod_id -- 产品编号
    ,src_prod_id -- 源产品编号
    ,super_subj_id -- 上级科目编号
    ,subj_level_cd -- 科目等级代码
    ,bal_dir_cd -- 科目余额方向
    ,oc_curr_cd -- 原币币种代码
    ,oc_bal -- 原币余额
    ,dc_curr_cd -- 本币币种代码
    ,dc_bal -- 本币余额
    ,noth_subor_subj_flg -- 无下级科目标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_op(
            sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,subj_id -- 科目编号
    ,prod_id -- 产品编号
    ,src_prod_id -- 源产品编号
    ,super_subj_id -- 上级科目编号
    ,subj_level_cd -- 科目等级代码
    ,bal_dir_cd -- 科目余额方向
    ,oc_curr_cd -- 原币币种代码
    ,oc_bal -- 原币余额
    ,dc_curr_cd -- 本币币种代码
    ,dc_bal -- 本币余额
    ,noth_subor_subj_flg -- 无下级科目标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sob_id, o.sob_id) as sob_id -- 账套编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.subj_id, o.subj_id) as subj_id -- 科目编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.src_prod_id, o.src_prod_id) as src_prod_id -- 源产品编号
    ,nvl(n.super_subj_id, o.super_subj_id) as super_subj_id -- 上级科目编号
    ,nvl(n.subj_level_cd, o.subj_level_cd) as subj_level_cd -- 科目等级代码
    ,nvl(n.bal_dir_cd, o.bal_dir_cd) as bal_dir_cd -- 科目余额方向
    ,nvl(n.oc_curr_cd, o.oc_curr_cd) as oc_curr_cd -- 原币币种代码
    ,nvl(n.oc_bal, o.oc_bal) as oc_bal -- 原币余额
    ,nvl(n.dc_curr_cd, o.dc_curr_cd) as dc_curr_cd -- 本币币种代码
    ,nvl(n.dc_bal, o.dc_bal) as dc_bal -- 本币余额
    ,nvl(n.noth_subor_subj_flg, o.noth_subor_subj_flg) as noth_subor_subj_flg -- 无下级科目标志
    ,case when
            n.sob_id is null
            and n.lp_id is null
            and n.subj_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sob_id is null
            and n.lp_id is null
            and n.subj_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sob_id is null
            and n.lp_id is null
            and n.subj_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_tm n
    full join (select * from ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.sob_id = n.sob_id
            and o.lp_id = n.lp_id
            and o.subj_id = n.subj_id
where (
        o.sob_id is null
        and o.lp_id is null
        and o.subj_id is null
    )
    or (
        n.sob_id is null
        and n.lp_id is null
        and n.subj_id is null
    )
    or (
        o.prod_id <> n.prod_id
        or o.src_prod_id <> n.src_prod_id
        or o.super_subj_id <> n.super_subj_id
        or o.subj_level_cd <> n.subj_level_cd
        or o.bal_dir_cd <> n.bal_dir_cd
        or o.oc_curr_cd <> n.oc_curr_cd
        or o.oc_bal <> n.oc_bal
        or o.dc_curr_cd <> n.dc_curr_cd
        or o.dc_bal <> n.dc_bal
        or o.noth_subor_subj_flg <> n.noth_subor_subj_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_cl(
            sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,subj_id -- 科目编号
    ,prod_id -- 产品编号
    ,src_prod_id -- 源产品编号
    ,super_subj_id -- 上级科目编号
    ,subj_level_cd -- 科目等级代码
    ,bal_dir_cd -- 科目余额方向
    ,oc_curr_cd -- 原币币种代码
    ,oc_bal -- 原币余额
    ,dc_curr_cd -- 本币币种代码
    ,dc_bal -- 本币余额
    ,noth_subor_subj_flg -- 无下级科目标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_op(
            sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,subj_id -- 科目编号
    ,prod_id -- 产品编号
    ,src_prod_id -- 源产品编号
    ,super_subj_id -- 上级科目编号
    ,subj_level_cd -- 科目等级代码
    ,bal_dir_cd -- 科目余额方向
    ,oc_curr_cd -- 原币币种代码
    ,oc_bal -- 原币余额
    ,dc_curr_cd -- 本币币种代码
    ,dc_bal -- 本币余额
    ,noth_subor_subj_flg -- 无下级科目标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sob_id -- 账套编号
    ,o.lp_id -- 法人编号
    ,o.subj_id -- 科目编号
    ,o.prod_id -- 产品编号
    ,o.src_prod_id -- 源产品编号
    ,o.super_subj_id -- 上级科目编号
    ,o.subj_level_cd -- 科目等级代码
    ,o.bal_dir_cd -- 科目余额方向
    ,o.oc_curr_cd -- 原币币种代码
    ,o.oc_bal -- 原币余额
    ,o.dc_curr_cd -- 本币币种代码
    ,o.dc_bal -- 本币余额
    ,o.noth_subor_subj_flg -- 无下级科目标志
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
from ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_bk o
    left join ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_op n
        on
            o.sob_id = n.sob_id
            and o.lp_id = n.lp_id
            and o.subj_id = n.subj_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_cl d
        on
            o.sob_id = d.sob_id
            and o.lp_id = d.lp_id
            and o.subj_id = d.subj_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.fin_am_prod_subj_bal_h;
--alter table ${iml_schema}.fin_am_prod_subj_bal_h truncate partition for ('famsf2') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('fin_am_prod_subj_bal_h') 
               and substr(subpartition_name,1,8)=upper('p_famsf2')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.fin_am_prod_subj_bal_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.fin_am_prod_subj_bal_h modify partition p_famsf2 
add subpartition p_famsf2_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.fin_am_prod_subj_bal_h exchange subpartition p_famsf2_${batch_date} with table ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_cl;
alter table ${iml_schema}.fin_am_prod_subj_bal_h exchange subpartition p_famsf2_20991231 with table ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.fin_am_prod_subj_bal_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_tm purge;
drop table ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_op purge;
drop table ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.fin_am_prod_subj_bal_h_famsf2_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'fin_am_prod_subj_bal_h', partname => 'p_famsf2_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
