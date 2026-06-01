/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dep_acct_provi_dtl_h_ncbsf1
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
alter table ${iml_schema}.agt_dep_acct_provi_dtl_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_provi_dtl_h partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,acct_id -- 账户编号
    ,int_provi_dt -- 利息计提日期
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_accr_amt -- 计息金额
    ,file_amt -- 靠档金额
    ,bank_int_base_rat -- 行内基准利率
    ,base_exch_rat -- 基准汇率
    ,float_int_rat -- 浮动利率
    ,final_exec_int_rat -- 最后执行利率
    ,lowt_exec_int_rat -- 最低执行利率
    ,provi_days -- 计提天数
    ,effect_dt_type -- 生效日期类型
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,file_days -- 靠档天数
    ,freq_cd -- 频率代码
    ,int_rat_float_ratio -- 利率浮动比例
    ,year_int_accr_base_cd -- 年计息基准代码
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_provi_dtl_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_provi_dtl_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_provi_dtl_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_int_calc_detail-1
insert into ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,acct_id -- 账户编号
    ,int_provi_dt -- 利息计提日期
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_accr_amt -- 计息金额
    ,file_amt -- 靠档金额
    ,bank_int_base_rat -- 行内基准利率
    ,base_exch_rat -- 基准汇率
    ,float_int_rat -- 浮动利率
    ,final_exec_int_rat -- 最后执行利率
    ,lowt_exec_int_rat -- 最低执行利率
    ,provi_days -- 计提天数
    ,effect_dt_type -- 生效日期类型
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,file_days -- 靠档天数
    ,freq_cd -- 频率代码
    ,int_rat_float_ratio -- 利率浮动比例
    ,year_int_accr_base_cd -- 年计息基准代码
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SEQ_NO -- 流水号
    ,P1.INTERNAL_KEY -- 账户编号
    ,${iml_schema}.dateformat_max2(P1.ACCR_DATE) -- 利息计提日期
    ,P1.INT_CLASS -- 利息分类代码
    ,P1.CLIENT_NO -- 客户编号
    ,P1.CALC_INT_AMT -- 计息金额
    ,P1.NEAR_AMT -- 靠档金额
    ,P1.ACTUAL_RATE -- 行内基准利率
    ,P1.BASIS_RATE -- 基准汇率
    ,P1.FLOAT_RATE -- 浮动利率
    ,P1.LAST_REAL_RATE -- 最后执行利率
    ,P1.MIN_INT_RATE -- 最低执行利率
    ,P1.CALC_DAYS -- 计提天数
    ,P1.EFFECT_DATE_TYPE -- 生效日期类型
    ,P1.INT_APPL_TYPE -- 利率启用方式代码
    ,P1.MONTH_BASIS -- 月计息基准代码
    ,P1.NEAR_DAYS -- 靠档天数
    ,P1.PERIOD_FREQ -- 频率代码
    ,P1.SPREAD_PERCENT -- 利率浮动比例
    ,P1.YEAR_BASIS -- 年计息基准代码
    ,${iml_schema}.dateformat_max2(P1.EFFECT_DATE) -- 起息日期
    ,${iml_schema}.dateformat_max2(P1.END_DATE) -- 结息日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_int_calc_detail' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_int_calc_detail p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,flow_num
  	                                        ,acct_id
  	                                        ,int_provi_dt
  	                                        ,int_cls_cd
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
        into ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,acct_id -- 账户编号
    ,int_provi_dt -- 利息计提日期
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_accr_amt -- 计息金额
    ,file_amt -- 靠档金额
    ,bank_int_base_rat -- 行内基准利率
    ,base_exch_rat -- 基准汇率
    ,float_int_rat -- 浮动利率
    ,final_exec_int_rat -- 最后执行利率
    ,lowt_exec_int_rat -- 最低执行利率
    ,provi_days -- 计提天数
    ,effect_dt_type -- 生效日期类型
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,file_days -- 靠档天数
    ,freq_cd -- 频率代码
    ,int_rat_float_ratio -- 利率浮动比例
    ,year_int_accr_base_cd -- 年计息基准代码
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,acct_id -- 账户编号
    ,int_provi_dt -- 利息计提日期
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_accr_amt -- 计息金额
    ,file_amt -- 靠档金额
    ,bank_int_base_rat -- 行内基准利率
    ,base_exch_rat -- 基准汇率
    ,float_int_rat -- 浮动利率
    ,final_exec_int_rat -- 最后执行利率
    ,lowt_exec_int_rat -- 最低执行利率
    ,provi_days -- 计提天数
    ,effect_dt_type -- 生效日期类型
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,file_days -- 靠档天数
    ,freq_cd -- 频率代码
    ,int_rat_float_ratio -- 利率浮动比例
    ,year_int_accr_base_cd -- 年计息基准代码
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
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
    ,nvl(n.flow_num, o.flow_num) as flow_num -- 流水号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.int_provi_dt, o.int_provi_dt) as int_provi_dt -- 利息计提日期
    ,nvl(n.int_cls_cd, o.int_cls_cd) as int_cls_cd -- 利息分类代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.int_accr_amt, o.int_accr_amt) as int_accr_amt -- 计息金额
    ,nvl(n.file_amt, o.file_amt) as file_amt -- 靠档金额
    ,nvl(n.bank_int_base_rat, o.bank_int_base_rat) as bank_int_base_rat -- 行内基准利率
    ,nvl(n.base_exch_rat, o.base_exch_rat) as base_exch_rat -- 基准汇率
    ,nvl(n.float_int_rat, o.float_int_rat) as float_int_rat -- 浮动利率
    ,nvl(n.final_exec_int_rat, o.final_exec_int_rat) as final_exec_int_rat -- 最后执行利率
    ,nvl(n.lowt_exec_int_rat, o.lowt_exec_int_rat) as lowt_exec_int_rat -- 最低执行利率
    ,nvl(n.provi_days, o.provi_days) as provi_days -- 计提天数
    ,nvl(n.effect_dt_type, o.effect_dt_type) as effect_dt_type -- 生效日期类型
    ,nvl(n.int_rat_start_use_way_cd, o.int_rat_start_use_way_cd) as int_rat_start_use_way_cd -- 利率启用方式代码
    ,nvl(n.mon_int_accr_base_cd, o.mon_int_accr_base_cd) as mon_int_accr_base_cd -- 月计息基准代码
    ,nvl(n.file_days, o.file_days) as file_days -- 靠档天数
    ,nvl(n.freq_cd, o.freq_cd) as freq_cd -- 频率代码
    ,nvl(n.int_rat_float_ratio, o.int_rat_float_ratio) as int_rat_float_ratio -- 利率浮动比例
    ,nvl(n.year_int_accr_base_cd, o.year_int_accr_base_cd) as year_int_accr_base_cd -- 年计息基准代码
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.int_set_dt, o.int_set_dt) as int_set_dt -- 结息日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.flow_num is null
            and n.acct_id is null
            and n.int_provi_dt is null
            and n.int_cls_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.flow_num is null
            and n.acct_id is null
            and n.int_provi_dt is null
            and n.int_cls_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.flow_num is null
            and n.acct_id is null
            and n.int_provi_dt is null
            and n.int_cls_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.flow_num = n.flow_num
            and o.acct_id = n.acct_id
            and o.int_provi_dt = n.int_provi_dt
            and o.int_cls_cd = n.int_cls_cd
where (
        o.agt_id is null
        and o.lp_id is null
        and o.flow_num is null
        and o.acct_id is null
        and o.int_provi_dt is null
        and o.int_cls_cd is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.flow_num is null
        and n.acct_id is null
        and n.int_provi_dt is null
        and n.int_cls_cd is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.int_accr_amt <> n.int_accr_amt
        or o.file_amt <> n.file_amt
        or o.bank_int_base_rat <> n.bank_int_base_rat
        or o.base_exch_rat <> n.base_exch_rat
        or o.float_int_rat <> n.float_int_rat
        or o.final_exec_int_rat <> n.final_exec_int_rat
        or o.lowt_exec_int_rat <> n.lowt_exec_int_rat
        or o.provi_days <> n.provi_days
        or o.effect_dt_type <> n.effect_dt_type
        or o.int_rat_start_use_way_cd <> n.int_rat_start_use_way_cd
        or o.mon_int_accr_base_cd <> n.mon_int_accr_base_cd
        or o.file_days <> n.file_days
        or o.freq_cd <> n.freq_cd
        or o.int_rat_float_ratio <> n.int_rat_float_ratio
        or o.year_int_accr_base_cd <> n.year_int_accr_base_cd
        or o.value_dt <> n.value_dt
        or o.int_set_dt <> n.int_set_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,acct_id -- 账户编号
    ,int_provi_dt -- 利息计提日期
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_accr_amt -- 计息金额
    ,file_amt -- 靠档金额
    ,bank_int_base_rat -- 行内基准利率
    ,base_exch_rat -- 基准汇率
    ,float_int_rat -- 浮动利率
    ,final_exec_int_rat -- 最后执行利率
    ,lowt_exec_int_rat -- 最低执行利率
    ,provi_days -- 计提天数
    ,effect_dt_type -- 生效日期类型
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,file_days -- 靠档天数
    ,freq_cd -- 频率代码
    ,int_rat_float_ratio -- 利率浮动比例
    ,year_int_accr_base_cd -- 年计息基准代码
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,acct_id -- 账户编号
    ,int_provi_dt -- 利息计提日期
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_accr_amt -- 计息金额
    ,file_amt -- 靠档金额
    ,bank_int_base_rat -- 行内基准利率
    ,base_exch_rat -- 基准汇率
    ,float_int_rat -- 浮动利率
    ,final_exec_int_rat -- 最后执行利率
    ,lowt_exec_int_rat -- 最低执行利率
    ,provi_days -- 计提天数
    ,effect_dt_type -- 生效日期类型
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,file_days -- 靠档天数
    ,freq_cd -- 频率代码
    ,int_rat_float_ratio -- 利率浮动比例
    ,year_int_accr_base_cd -- 年计息基准代码
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
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
    ,o.flow_num -- 流水号
    ,o.acct_id -- 账户编号
    ,o.int_provi_dt -- 利息计提日期
    ,o.int_cls_cd -- 利息分类代码
    ,o.cust_id -- 客户编号
    ,o.int_accr_amt -- 计息金额
    ,o.file_amt -- 靠档金额
    ,o.bank_int_base_rat -- 行内基准利率
    ,o.base_exch_rat -- 基准汇率
    ,o.float_int_rat -- 浮动利率
    ,o.final_exec_int_rat -- 最后执行利率
    ,o.lowt_exec_int_rat -- 最低执行利率
    ,o.provi_days -- 计提天数
    ,o.effect_dt_type -- 生效日期类型
    ,o.int_rat_start_use_way_cd -- 利率启用方式代码
    ,o.mon_int_accr_base_cd -- 月计息基准代码
    ,o.file_days -- 靠档天数
    ,o.freq_cd -- 频率代码
    ,o.int_rat_float_ratio -- 利率浮动比例
    ,o.year_int_accr_base_cd -- 年计息基准代码
    ,o.value_dt -- 起息日期
    ,o.int_set_dt -- 结息日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_bk o
    left join ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.flow_num = n.flow_num
            and o.acct_id = n.acct_id
            and o.int_provi_dt = n.int_provi_dt
            and o.int_cls_cd = n.int_cls_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.flow_num = d.flow_num
            and o.acct_id = d.acct_id
            and o.int_provi_dt = d.int_provi_dt
            and o.int_cls_cd = d.int_cls_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_dep_acct_provi_dtl_h;
alter table ${iml_schema}.agt_dep_acct_provi_dtl_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_dep_acct_provi_dtl_h exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_cl;
alter table ${iml_schema}.agt_dep_acct_provi_dtl_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dep_acct_provi_dtl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_dep_acct_provi_dtl_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dep_acct_provi_dtl_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
