/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_repay_way_para_ncbsf1
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
alter table ${iml_schema}.ref_repay_way_para add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_repay_way_para_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_repay_way_para partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_repay_way_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_repay_way_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_repay_way_para_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_repay_way_para_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    repay_way_cd -- 还款方式代码
    ,lp_id -- 法人编号
    ,repay_way_descb -- 还款方式描述
    ,pric_int_proc_way_cd -- 本息处理方式代码
    ,fst_term_flg -- 首期破期标志
    ,pric_repay_type_cd -- 本金还款类型代码
    ,calc_formu -- 计算公式
    ,acpt_pay_idf_cd -- 收付标识代码
    ,term_end_merge_days -- 期末合并天数
    ,term_end_merge_type_cd -- 期末合并类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_repay_way_para partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.ref_repay_way_para_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_repay_way_para partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.ref_repay_way_para_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_repay_way_para partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cl_sched_mode-1
insert into ${iml_schema}.ref_repay_way_para_ncbsf1_tm(
    repay_way_cd -- 还款方式代码
    ,lp_id -- 法人编号
    ,repay_way_descb -- 还款方式描述
    ,pric_int_proc_way_cd -- 本息处理方式代码
    ,fst_term_flg -- 首期破期标志
    ,pric_repay_type_cd -- 本金还款类型代码
    ,calc_formu -- 计算公式
    ,acpt_pay_idf_cd -- 收付标识代码
    ,term_end_merge_days -- 期末合并天数
    ,term_end_merge_type_cd -- 期末合并类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCHED_MODE -- 还款方式代码
    ,'9999' -- 法人编号
    ,P1.SCHED_MODE_DESC -- 还款方式描述
    ,P1.PROCESS_TYPE -- 本息处理方式代码
    ,DECODE(P1.FIRST_BREAK_FLAG,'Y','1','N','0') -- 首期破期标志
    ,P1.PRI_REPAY_TYPE -- 本金还款类型代码
    ,P1.CALC_FORMULA -- 计算公式
    ,P1.PAY_REC -- 收付标识代码
    ,P1.LAST_MERGE_PERIOD -- 期末合并天数
    ,P1.LAST_MERGE_TYPE -- 期末合并类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_sched_mode' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_sched_mode p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_repay_way_para_ncbsf1_tm 
  	                                group by 
  	                                        repay_way_cd
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
        into ${iml_schema}.ref_repay_way_para_ncbsf1_cl(
            repay_way_cd -- 还款方式代码
    ,lp_id -- 法人编号
    ,repay_way_descb -- 还款方式描述
    ,pric_int_proc_way_cd -- 本息处理方式代码
    ,fst_term_flg -- 首期破期标志
    ,pric_repay_type_cd -- 本金还款类型代码
    ,calc_formu -- 计算公式
    ,acpt_pay_idf_cd -- 收付标识代码
    ,term_end_merge_days -- 期末合并天数
    ,term_end_merge_type_cd -- 期末合并类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_repay_way_para_ncbsf1_op(
            repay_way_cd -- 还款方式代码
    ,lp_id -- 法人编号
    ,repay_way_descb -- 还款方式描述
    ,pric_int_proc_way_cd -- 本息处理方式代码
    ,fst_term_flg -- 首期破期标志
    ,pric_repay_type_cd -- 本金还款类型代码
    ,calc_formu -- 计算公式
    ,acpt_pay_idf_cd -- 收付标识代码
    ,term_end_merge_days -- 期末合并天数
    ,term_end_merge_type_cd -- 期末合并类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.repay_way_descb, o.repay_way_descb) as repay_way_descb -- 还款方式描述
    ,nvl(n.pric_int_proc_way_cd, o.pric_int_proc_way_cd) as pric_int_proc_way_cd -- 本息处理方式代码
    ,nvl(n.fst_term_flg, o.fst_term_flg) as fst_term_flg -- 首期破期标志
    ,nvl(n.pric_repay_type_cd, o.pric_repay_type_cd) as pric_repay_type_cd -- 本金还款类型代码
    ,nvl(n.calc_formu, o.calc_formu) as calc_formu -- 计算公式
    ,nvl(n.acpt_pay_idf_cd, o.acpt_pay_idf_cd) as acpt_pay_idf_cd -- 收付标识代码
    ,nvl(n.term_end_merge_days, o.term_end_merge_days) as term_end_merge_days -- 期末合并天数
    ,nvl(n.term_end_merge_type_cd, o.term_end_merge_type_cd) as term_end_merge_type_cd -- 期末合并类型代码
    ,case when
            n.repay_way_cd is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.repay_way_cd is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.repay_way_cd is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_repay_way_para_ncbsf1_tm n
    full join (select * from ${iml_schema}.ref_repay_way_para_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.repay_way_cd = n.repay_way_cd
            and o.lp_id = n.lp_id
where (
        o.repay_way_cd is null
        and o.lp_id is null
    )
    or (
        n.repay_way_cd is null
        and n.lp_id is null
    )
    or (
        o.repay_way_descb <> n.repay_way_descb
        or o.pric_int_proc_way_cd <> n.pric_int_proc_way_cd
        or o.fst_term_flg <> n.fst_term_flg
        or o.pric_repay_type_cd <> n.pric_repay_type_cd
        or o.calc_formu <> n.calc_formu
        or o.acpt_pay_idf_cd <> n.acpt_pay_idf_cd
        or o.term_end_merge_days <> n.term_end_merge_days
        or o.term_end_merge_type_cd <> n.term_end_merge_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_repay_way_para_ncbsf1_cl(
            repay_way_cd -- 还款方式代码
    ,lp_id -- 法人编号
    ,repay_way_descb -- 还款方式描述
    ,pric_int_proc_way_cd -- 本息处理方式代码
    ,fst_term_flg -- 首期破期标志
    ,pric_repay_type_cd -- 本金还款类型代码
    ,calc_formu -- 计算公式
    ,acpt_pay_idf_cd -- 收付标识代码
    ,term_end_merge_days -- 期末合并天数
    ,term_end_merge_type_cd -- 期末合并类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_repay_way_para_ncbsf1_op(
            repay_way_cd -- 还款方式代码
    ,lp_id -- 法人编号
    ,repay_way_descb -- 还款方式描述
    ,pric_int_proc_way_cd -- 本息处理方式代码
    ,fst_term_flg -- 首期破期标志
    ,pric_repay_type_cd -- 本金还款类型代码
    ,calc_formu -- 计算公式
    ,acpt_pay_idf_cd -- 收付标识代码
    ,term_end_merge_days -- 期末合并天数
    ,term_end_merge_type_cd -- 期末合并类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.repay_way_cd -- 还款方式代码
    ,o.lp_id -- 法人编号
    ,o.repay_way_descb -- 还款方式描述
    ,o.pric_int_proc_way_cd -- 本息处理方式代码
    ,o.fst_term_flg -- 首期破期标志
    ,o.pric_repay_type_cd -- 本金还款类型代码
    ,o.calc_formu -- 计算公式
    ,o.acpt_pay_idf_cd -- 收付标识代码
    ,o.term_end_merge_days -- 期末合并天数
    ,o.term_end_merge_type_cd -- 期末合并类型代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_repay_way_para_ncbsf1_bk o
    left join ${iml_schema}.ref_repay_way_para_ncbsf1_op n
        on
            o.repay_way_cd = n.repay_way_cd
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_repay_way_para_ncbsf1_cl d
        on
            o.repay_way_cd = d.repay_way_cd
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_repay_way_para;
alter table ${iml_schema}.ref_repay_way_para truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_repay_way_para exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.ref_repay_way_para_ncbsf1_cl;
alter table ${iml_schema}.ref_repay_way_para exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.ref_repay_way_para_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_repay_way_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_repay_way_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_repay_way_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_repay_way_para_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_repay_way_para_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_repay_way_para', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
