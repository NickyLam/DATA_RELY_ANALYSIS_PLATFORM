/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_bank_int_ladr_h_ncbsf1
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
alter table ${iml_schema}.ref_bank_int_ladr_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_bank_int_ladr_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_tm purge;
drop table ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_op purge;
drop table ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    ladr_seq_num -- 阶梯序号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,curr_cd -- 币种代码
    ,bank_int_int_rat_type_cd -- 行内利率类型代码
    ,year_base_days -- 年计息基准代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,base_rat_type_id -- 基准利率类型编号
    ,base_exch_rat -- 基础汇率
    ,ped_freq_cd -- 周期频率代码
    ,eh_issue_days -- 每期天数
    ,ladr_amt -- 阶梯金额
    ,bank_int_int_rat -- 行内利率
    ,int_rat_discnt -- 利率折扣
    ,float_ratio -- 浮动比例
    ,float_point -- 浮动点数
    ,max_cu_ratio -- 最大上浮比例
    ,min_cu_ratio -- 浮动比例上限
    ,min_int_rat -- 最小利率
    ,max_int_rat -- 最大利率
    ,max_float_point -- 浮动点差上限
    ,min_float_point -- 浮动点差下限
    ,max_float_ratio -- 最大下浮比例
    ,min_float_ratio -- 最小下浮比例
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_bank_int_ladr_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_bank_int_ladr_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_bank_int_ladr_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_mb_int_matrix-1
insert into ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_tm(
    ladr_seq_num -- 阶梯序号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,curr_cd -- 币种代码
    ,bank_int_int_rat_type_cd -- 行内利率类型代码
    ,year_base_days -- 年计息基准代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,base_rat_type_id -- 基准利率类型编号
    ,base_exch_rat -- 基础汇率
    ,ped_freq_cd -- 周期频率代码
    ,eh_issue_days -- 每期天数
    ,ladr_amt -- 阶梯金额
    ,bank_int_int_rat -- 行内利率
    ,int_rat_discnt -- 利率折扣
    ,float_ratio -- 浮动比例
    ,float_point -- 浮动点数
    ,max_cu_ratio -- 最大上浮比例
    ,min_cu_ratio -- 浮动比例上限
    ,min_int_rat -- 最小利率
    ,max_int_rat -- 最大利率
    ,max_float_point -- 浮动点差上限
    ,min_float_point -- 浮动点差下限
    ,max_float_ratio -- 最大下浮比例
    ,min_float_ratio -- 最小下浮比例
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.MATRIX_NO -- 阶梯序号
    ,'9999' -- 法人编号
    ,P1.BRANCH -- 机构编号
    ,P1.CCY -- 币种代码
    ,P1.INT_TYPE -- 行内利率类型代码
    ,NVL(TRIM(P1.YEAR_BASIS),0) -- 年计息基准代码
    ,P1.EFFECT_DATE -- 生效日期
    ,P1.END_DATE -- 失效日期
    ,P1.INT_BASIS -- 基准利率类型编号
    ,P1.BASE_RATE -- 基础汇率
    ,nvl(trim(P1.PERIOD_FREQ),'-') -- 周期频率代码
    ,P1.DAY_NUM -- 每期天数
    ,P1.MATRIX_AMT -- 阶梯金额
    ,P1.ACTUAL_RATE -- 行内利率
    ,P1.DISC_RATE -- 利率折扣
    ,P1.SPREAD_PERCENT -- 浮动比例
    ,P1.SPREAD_RATE -- 浮动点数
    ,P1.MAX_PERCENT -- 最大上浮比例
    ,P1.MIN_PERCENT -- 浮动比例上限
    ,P1.MIN_RATE -- 最小利率
    ,P1.MAX_RATE -- 最大利率
    ,P1.MAX_SPREAD_RATE -- 浮动点差上限
    ,P1.MIN_SPREAD_RATE -- 浮动点差下限
    ,P1.MAX_SPREAD_PERCENT -- 最大下浮比例
    ,P1.MIN_SPREAD_PERCENT -- 最小下浮比例
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_mb_int_matrix' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_mb_int_matrix p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_tm 
  	                                group by 
  	                                        ladr_seq_num
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
        into ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_cl(
            ladr_seq_num -- 阶梯序号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,curr_cd -- 币种代码
    ,bank_int_int_rat_type_cd -- 行内利率类型代码
    ,year_base_days -- 年计息基准代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,base_rat_type_id -- 基准利率类型编号
    ,base_exch_rat -- 基础汇率
    ,ped_freq_cd -- 周期频率代码
    ,eh_issue_days -- 每期天数
    ,ladr_amt -- 阶梯金额
    ,bank_int_int_rat -- 行内利率
    ,int_rat_discnt -- 利率折扣
    ,float_ratio -- 浮动比例
    ,float_point -- 浮动点数
    ,max_cu_ratio -- 最大上浮比例
    ,min_cu_ratio -- 浮动比例上限
    ,min_int_rat -- 最小利率
    ,max_int_rat -- 最大利率
    ,max_float_point -- 浮动点差上限
    ,min_float_point -- 浮动点差下限
    ,max_float_ratio -- 最大下浮比例
    ,min_float_ratio -- 最小下浮比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_op(
            ladr_seq_num -- 阶梯序号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,curr_cd -- 币种代码
    ,bank_int_int_rat_type_cd -- 行内利率类型代码
    ,year_base_days -- 年计息基准代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,base_rat_type_id -- 基准利率类型编号
    ,base_exch_rat -- 基础汇率
    ,ped_freq_cd -- 周期频率代码
    ,eh_issue_days -- 每期天数
    ,ladr_amt -- 阶梯金额
    ,bank_int_int_rat -- 行内利率
    ,int_rat_discnt -- 利率折扣
    ,float_ratio -- 浮动比例
    ,float_point -- 浮动点数
    ,max_cu_ratio -- 最大上浮比例
    ,min_cu_ratio -- 浮动比例上限
    ,min_int_rat -- 最小利率
    ,max_int_rat -- 最大利率
    ,max_float_point -- 浮动点差上限
    ,min_float_point -- 浮动点差下限
    ,max_float_ratio -- 最大下浮比例
    ,min_float_ratio -- 最小下浮比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ladr_seq_num, o.ladr_seq_num) as ladr_seq_num -- 阶梯序号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.bank_int_int_rat_type_cd, o.bank_int_int_rat_type_cd) as bank_int_int_rat_type_cd -- 行内利率类型代码
    ,nvl(n.year_base_days, o.year_base_days) as year_base_days -- 年计息基准代码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.base_rat_type_id, o.base_rat_type_id) as base_rat_type_id -- 基准利率类型编号
    ,nvl(n.base_exch_rat, o.base_exch_rat) as base_exch_rat -- 基础汇率
    ,nvl(n.ped_freq_cd, o.ped_freq_cd) as ped_freq_cd -- 周期频率代码
    ,nvl(n.eh_issue_days, o.eh_issue_days) as eh_issue_days -- 每期天数
    ,nvl(n.ladr_amt, o.ladr_amt) as ladr_amt -- 阶梯金额
    ,nvl(n.bank_int_int_rat, o.bank_int_int_rat) as bank_int_int_rat -- 行内利率
    ,nvl(n.int_rat_discnt, o.int_rat_discnt) as int_rat_discnt -- 利率折扣
    ,nvl(n.float_ratio, o.float_ratio) as float_ratio -- 浮动比例
    ,nvl(n.float_point, o.float_point) as float_point -- 浮动点数
    ,nvl(n.max_cu_ratio, o.max_cu_ratio) as max_cu_ratio -- 最大上浮比例
    ,nvl(n.min_cu_ratio, o.min_cu_ratio) as min_cu_ratio -- 浮动比例上限
    ,nvl(n.min_int_rat, o.min_int_rat) as min_int_rat -- 最小利率
    ,nvl(n.max_int_rat, o.max_int_rat) as max_int_rat -- 最大利率
    ,nvl(n.max_float_point, o.max_float_point) as max_float_point -- 浮动点差上限
    ,nvl(n.min_float_point, o.min_float_point) as min_float_point -- 浮动点差下限
    ,nvl(n.max_float_ratio, o.max_float_ratio) as max_float_ratio -- 最大下浮比例
    ,nvl(n.min_float_ratio, o.min_float_ratio) as min_float_ratio -- 最小下浮比例
    ,case when
            n.ladr_seq_num is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ladr_seq_num is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ladr_seq_num is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.ladr_seq_num = n.ladr_seq_num
            and o.lp_id = n.lp_id
where (
        o.ladr_seq_num is null
        and o.lp_id is null
    )
    or (
        n.ladr_seq_num is null
        and n.lp_id is null
    )
    or (
        o.org_id <> n.org_id
        or o.curr_cd <> n.curr_cd
        or o.bank_int_int_rat_type_cd <> n.bank_int_int_rat_type_cd
        or o.year_base_days <> n.year_base_days
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.base_rat_type_id <> n.base_rat_type_id
        or o.base_exch_rat <> n.base_exch_rat
        or o.ped_freq_cd <> n.ped_freq_cd
        or o.eh_issue_days <> n.eh_issue_days
        or o.ladr_amt <> n.ladr_amt
        or o.bank_int_int_rat <> n.bank_int_int_rat
        or o.int_rat_discnt <> n.int_rat_discnt
        or o.float_ratio <> n.float_ratio
        or o.float_point <> n.float_point
        or o.max_cu_ratio <> n.max_cu_ratio
        or o.min_cu_ratio <> n.min_cu_ratio
        or o.min_int_rat <> n.min_int_rat
        or o.max_int_rat <> n.max_int_rat
        or o.max_float_point <> n.max_float_point
        or o.min_float_point <> n.min_float_point
        or o.max_float_ratio <> n.max_float_ratio
        or o.min_float_ratio <> n.min_float_ratio
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_cl(
            ladr_seq_num -- 阶梯序号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,curr_cd -- 币种代码
    ,bank_int_int_rat_type_cd -- 行内利率类型代码
    ,year_base_days -- 年计息基准代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,base_rat_type_id -- 基准利率类型编号
    ,base_exch_rat -- 基础汇率
    ,ped_freq_cd -- 周期频率代码
    ,eh_issue_days -- 每期天数
    ,ladr_amt -- 阶梯金额
    ,bank_int_int_rat -- 行内利率
    ,int_rat_discnt -- 利率折扣
    ,float_ratio -- 浮动比例
    ,float_point -- 浮动点数
    ,max_cu_ratio -- 最大上浮比例
    ,min_cu_ratio -- 浮动比例上限
    ,min_int_rat -- 最小利率
    ,max_int_rat -- 最大利率
    ,max_float_point -- 浮动点差上限
    ,min_float_point -- 浮动点差下限
    ,max_float_ratio -- 最大下浮比例
    ,min_float_ratio -- 最小下浮比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_op(
            ladr_seq_num -- 阶梯序号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,curr_cd -- 币种代码
    ,bank_int_int_rat_type_cd -- 行内利率类型代码
    ,year_base_days -- 年计息基准代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,base_rat_type_id -- 基准利率类型编号
    ,base_exch_rat -- 基础汇率
    ,ped_freq_cd -- 周期频率代码
    ,eh_issue_days -- 每期天数
    ,ladr_amt -- 阶梯金额
    ,bank_int_int_rat -- 行内利率
    ,int_rat_discnt -- 利率折扣
    ,float_ratio -- 浮动比例
    ,float_point -- 浮动点数
    ,max_cu_ratio -- 最大上浮比例
    ,min_cu_ratio -- 浮动比例上限
    ,min_int_rat -- 最小利率
    ,max_int_rat -- 最大利率
    ,max_float_point -- 浮动点差上限
    ,min_float_point -- 浮动点差下限
    ,max_float_ratio -- 最大下浮比例
    ,min_float_ratio -- 最小下浮比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ladr_seq_num -- 阶梯序号
    ,o.lp_id -- 法人编号
    ,o.org_id -- 机构编号
    ,o.curr_cd -- 币种代码
    ,o.bank_int_int_rat_type_cd -- 行内利率类型代码
    ,o.year_base_days -- 年计息基准代码
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.base_rat_type_id -- 基准利率类型编号
    ,o.base_exch_rat -- 基础汇率
    ,o.ped_freq_cd -- 周期频率代码
    ,o.eh_issue_days -- 每期天数
    ,o.ladr_amt -- 阶梯金额
    ,o.bank_int_int_rat -- 行内利率
    ,o.int_rat_discnt -- 利率折扣
    ,o.float_ratio -- 浮动比例
    ,o.float_point -- 浮动点数
    ,o.max_cu_ratio -- 最大上浮比例
    ,o.min_cu_ratio -- 浮动比例上限
    ,o.min_int_rat -- 最小利率
    ,o.max_int_rat -- 最大利率
    ,o.max_float_point -- 浮动点差上限
    ,o.min_float_point -- 浮动点差下限
    ,o.max_float_ratio -- 最大下浮比例
    ,o.min_float_ratio -- 最小下浮比例
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
from ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_bk o
    left join ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_op n
        on
            o.ladr_seq_num = n.ladr_seq_num
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_cl d
        on
            o.ladr_seq_num = d.ladr_seq_num
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_bank_int_ladr_h;
--alter table ${iml_schema}.ref_bank_int_ladr_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ref_bank_int_ladr_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ref_bank_int_ladr_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ref_bank_int_ladr_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ref_bank_int_ladr_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_cl;
alter table ${iml_schema}.ref_bank_int_ladr_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_bank_int_ladr_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_tm purge;
drop table ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_op purge;
drop table ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_bank_int_ladr_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_bank_int_ladr_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
