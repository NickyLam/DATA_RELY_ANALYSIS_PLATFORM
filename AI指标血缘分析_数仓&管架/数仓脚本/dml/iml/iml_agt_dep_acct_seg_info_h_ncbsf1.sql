/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dep_acct_seg_info_h_ncbsf1
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
alter table ${iml_schema}.agt_dep_acct_seg_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_seg_info_h partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,fee_rat_id -- 费率编号
    ,acct_id -- 账户编号
    ,ped_seg_id -- 周期分段编号
    ,ped_seg_seq_num -- 周期分段序号
    ,seg_ped -- 分段周期
    ,seg_ped_type_cd -- 分段周期类型代码
    ,int_cls_cd -- 利息分类代码
    ,int_rat_type_cd -- 利率类型代码
    ,float_int_rat -- 浮动利率
    ,bank_int_int_rat -- 行内利率
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,bank_int_exec_int_rat -- 行内执行利率
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_prefr_amt -- 协议优惠金额
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_point -- 协议浮动点数
    ,agt_float_ratio -- 协议浮动比例
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,file_amt -- 靠档金额
    ,provi_days -- 计提天数
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,provi_amt -- 计提金额
    ,cust_id -- 客户编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_seg_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_seg_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_seg_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_acct_int_detail_split-1
insert into ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,fee_rat_id -- 费率编号
    ,acct_id -- 账户编号
    ,ped_seg_id -- 周期分段编号
    ,ped_seg_seq_num -- 周期分段序号
    ,seg_ped -- 分段周期
    ,seg_ped_type_cd -- 分段周期类型代码
    ,int_cls_cd -- 利息分类代码
    ,int_rat_type_cd -- 利率类型代码
    ,float_int_rat -- 浮动利率
    ,bank_int_int_rat -- 行内利率
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,bank_int_exec_int_rat -- 行内执行利率
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_prefr_amt -- 协议优惠金额
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_point -- 协议浮动点数
    ,agt_float_ratio -- 协议浮动比例
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,file_amt -- 靠档金额
    ,provi_days -- 计提天数
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,provi_amt -- 计提金额
    ,cust_id -- 客户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.IRL_SEQ_NO -- 费率编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.PERI_SPLIT_ID -- 周期分段编号
    ,P1.PERI_SEQ_NO -- 周期分段序号
    ,NVL(TRIM(P1.NEAR_PERIOD),0) -- 分段周期
    ,P1.NEAR_PERIOD_TYPE -- 分段周期类型代码
    ,P1.INT_CLASS -- 利息分类代码
    ,P1.INT_TYPE -- 利率类型代码
    ,P1.FLOAT_RATE -- 浮动利率
    ,P1.ACTUAL_RATE -- 行内利率
    ,P1.ACCT_FIXED_RATE -- 分户级固定利率
    ,P1.ACCT_PERCENT_RATE -- 分户级利率浮动比例
    ,P1.ACCT_SPREAD_RATE -- 分户级利率浮动点数
    ,P1.REAL_RATE -- 行内执行利率
    ,P1.AGREE_CHANGE_TYPE -- 协议变动方式代码
    ,P1.AGREE_REDUCE_AMT -- 协议优惠金额
    ,P1.AGREE_FIXED_RATE -- 协议固定利率
    ,P1.AGREE_SPREAD_RATE -- 协议浮动点数
    ,P1.AGREE_PERCENT_RATE -- 协议浮动比例
    ,${iml_schema}.dateformat_max2(P1.START_DATE) -- 起息日期
    ,${iml_schema}.dateformat_max2(P1.END_DATE) -- 结息日期
    ,P1.NEAR_AMT -- 靠档金额
    ,P1.ACCR_DAYS -- 计提天数
    ,P1.YEAR_BASIS -- 年计息基准代码
    ,P1.MONTH_BASIS -- 月计息基准代码
    ,P1.ACCR_AMT -- 计提金额
    ,P1.CLIENT_NO -- 客户编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_acct_int_detail_split' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_acct_int_detail_split p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,fee_rat_id
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
        into ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,fee_rat_id -- 费率编号
    ,acct_id -- 账户编号
    ,ped_seg_id -- 周期分段编号
    ,ped_seg_seq_num -- 周期分段序号
    ,seg_ped -- 分段周期
    ,seg_ped_type_cd -- 分段周期类型代码
    ,int_cls_cd -- 利息分类代码
    ,int_rat_type_cd -- 利率类型代码
    ,float_int_rat -- 浮动利率
    ,bank_int_int_rat -- 行内利率
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,bank_int_exec_int_rat -- 行内执行利率
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_prefr_amt -- 协议优惠金额
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_point -- 协议浮动点数
    ,agt_float_ratio -- 协议浮动比例
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,file_amt -- 靠档金额
    ,provi_days -- 计提天数
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,provi_amt -- 计提金额
    ,cust_id -- 客户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,fee_rat_id -- 费率编号
    ,acct_id -- 账户编号
    ,ped_seg_id -- 周期分段编号
    ,ped_seg_seq_num -- 周期分段序号
    ,seg_ped -- 分段周期
    ,seg_ped_type_cd -- 分段周期类型代码
    ,int_cls_cd -- 利息分类代码
    ,int_rat_type_cd -- 利率类型代码
    ,float_int_rat -- 浮动利率
    ,bank_int_int_rat -- 行内利率
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,bank_int_exec_int_rat -- 行内执行利率
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_prefr_amt -- 协议优惠金额
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_point -- 协议浮动点数
    ,agt_float_ratio -- 协议浮动比例
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,file_amt -- 靠档金额
    ,provi_days -- 计提天数
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,provi_amt -- 计提金额
    ,cust_id -- 客户编号
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
    ,nvl(n.fee_rat_id, o.fee_rat_id) as fee_rat_id -- 费率编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.ped_seg_id, o.ped_seg_id) as ped_seg_id -- 周期分段编号
    ,nvl(n.ped_seg_seq_num, o.ped_seg_seq_num) as ped_seg_seq_num -- 周期分段序号
    ,nvl(n.seg_ped, o.seg_ped) as seg_ped -- 分段周期
    ,nvl(n.seg_ped_type_cd, o.seg_ped_type_cd) as seg_ped_type_cd -- 分段周期类型代码
    ,nvl(n.int_cls_cd, o.int_cls_cd) as int_cls_cd -- 利息分类代码
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.float_int_rat, o.float_int_rat) as float_int_rat -- 浮动利率
    ,nvl(n.bank_int_int_rat, o.bank_int_int_rat) as bank_int_int_rat -- 行内利率
    ,nvl(n.sub_acct_fix_int_rat, o.sub_acct_fix_int_rat) as sub_acct_fix_int_rat -- 分户级固定利率
    ,nvl(n.sub_acct_int_rat_float_ratio, o.sub_acct_int_rat_float_ratio) as sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,nvl(n.sub_acct_int_rat_float_point, o.sub_acct_int_rat_float_point) as sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,nvl(n.bank_int_exec_int_rat, o.bank_int_exec_int_rat) as bank_int_exec_int_rat -- 行内执行利率
    ,nvl(n.agt_chg_way_cd, o.agt_chg_way_cd) as agt_chg_way_cd -- 协议变动方式代码
    ,nvl(n.agt_prefr_amt, o.agt_prefr_amt) as agt_prefr_amt -- 协议优惠金额
    ,nvl(n.agt_fix_int_rat, o.agt_fix_int_rat) as agt_fix_int_rat -- 协议固定利率
    ,nvl(n.agt_float_point, o.agt_float_point) as agt_float_point -- 协议浮动点数
    ,nvl(n.agt_float_ratio, o.agt_float_ratio) as agt_float_ratio -- 协议浮动比例
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.int_set_dt, o.int_set_dt) as int_set_dt -- 结息日期
    ,nvl(n.file_amt, o.file_amt) as file_amt -- 靠档金额
    ,nvl(n.provi_days, o.provi_days) as provi_days -- 计提天数
    ,nvl(n.year_int_accr_base_cd, o.year_int_accr_base_cd) as year_int_accr_base_cd -- 年计息基准代码
    ,nvl(n.mon_int_accr_base_cd, o.mon_int_accr_base_cd) as mon_int_accr_base_cd -- 月计息基准代码
    ,nvl(n.provi_amt, o.provi_amt) as provi_amt -- 计提金额
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.fee_rat_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.fee_rat_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.fee_rat_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.fee_rat_id = n.fee_rat_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.fee_rat_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.fee_rat_id is null
    )
    or (
        o.acct_id <> n.acct_id
        or o.ped_seg_id <> n.ped_seg_id
        or o.ped_seg_seq_num <> n.ped_seg_seq_num
        or o.seg_ped <> n.seg_ped
        or o.seg_ped_type_cd <> n.seg_ped_type_cd
        or o.int_cls_cd <> n.int_cls_cd
        or o.int_rat_type_cd <> n.int_rat_type_cd
        or o.float_int_rat <> n.float_int_rat
        or o.bank_int_int_rat <> n.bank_int_int_rat
        or o.sub_acct_fix_int_rat <> n.sub_acct_fix_int_rat
        or o.sub_acct_int_rat_float_ratio <> n.sub_acct_int_rat_float_ratio
        or o.sub_acct_int_rat_float_point <> n.sub_acct_int_rat_float_point
        or o.bank_int_exec_int_rat <> n.bank_int_exec_int_rat
        or o.agt_chg_way_cd <> n.agt_chg_way_cd
        or o.agt_prefr_amt <> n.agt_prefr_amt
        or o.agt_fix_int_rat <> n.agt_fix_int_rat
        or o.agt_float_point <> n.agt_float_point
        or o.agt_float_ratio <> n.agt_float_ratio
        or o.value_dt <> n.value_dt
        or o.int_set_dt <> n.int_set_dt
        or o.file_amt <> n.file_amt
        or o.provi_days <> n.provi_days
        or o.year_int_accr_base_cd <> n.year_int_accr_base_cd
        or o.mon_int_accr_base_cd <> n.mon_int_accr_base_cd
        or o.provi_amt <> n.provi_amt
        or o.cust_id <> n.cust_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,fee_rat_id -- 费率编号
    ,acct_id -- 账户编号
    ,ped_seg_id -- 周期分段编号
    ,ped_seg_seq_num -- 周期分段序号
    ,seg_ped -- 分段周期
    ,seg_ped_type_cd -- 分段周期类型代码
    ,int_cls_cd -- 利息分类代码
    ,int_rat_type_cd -- 利率类型代码
    ,float_int_rat -- 浮动利率
    ,bank_int_int_rat -- 行内利率
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,bank_int_exec_int_rat -- 行内执行利率
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_prefr_amt -- 协议优惠金额
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_point -- 协议浮动点数
    ,agt_float_ratio -- 协议浮动比例
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,file_amt -- 靠档金额
    ,provi_days -- 计提天数
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,provi_amt -- 计提金额
    ,cust_id -- 客户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,fee_rat_id -- 费率编号
    ,acct_id -- 账户编号
    ,ped_seg_id -- 周期分段编号
    ,ped_seg_seq_num -- 周期分段序号
    ,seg_ped -- 分段周期
    ,seg_ped_type_cd -- 分段周期类型代码
    ,int_cls_cd -- 利息分类代码
    ,int_rat_type_cd -- 利率类型代码
    ,float_int_rat -- 浮动利率
    ,bank_int_int_rat -- 行内利率
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,bank_int_exec_int_rat -- 行内执行利率
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_prefr_amt -- 协议优惠金额
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_point -- 协议浮动点数
    ,agt_float_ratio -- 协议浮动比例
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,file_amt -- 靠档金额
    ,provi_days -- 计提天数
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,provi_amt -- 计提金额
    ,cust_id -- 客户编号
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
    ,o.fee_rat_id -- 费率编号
    ,o.acct_id -- 账户编号
    ,o.ped_seg_id -- 周期分段编号
    ,o.ped_seg_seq_num -- 周期分段序号
    ,o.seg_ped -- 分段周期
    ,o.seg_ped_type_cd -- 分段周期类型代码
    ,o.int_cls_cd -- 利息分类代码
    ,o.int_rat_type_cd -- 利率类型代码
    ,o.float_int_rat -- 浮动利率
    ,o.bank_int_int_rat -- 行内利率
    ,o.sub_acct_fix_int_rat -- 分户级固定利率
    ,o.sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,o.sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,o.bank_int_exec_int_rat -- 行内执行利率
    ,o.agt_chg_way_cd -- 协议变动方式代码
    ,o.agt_prefr_amt -- 协议优惠金额
    ,o.agt_fix_int_rat -- 协议固定利率
    ,o.agt_float_point -- 协议浮动点数
    ,o.agt_float_ratio -- 协议浮动比例
    ,o.value_dt -- 起息日期
    ,o.int_set_dt -- 结息日期
    ,o.file_amt -- 靠档金额
    ,o.provi_days -- 计提天数
    ,o.year_int_accr_base_cd -- 年计息基准代码
    ,o.mon_int_accr_base_cd -- 月计息基准代码
    ,o.provi_amt -- 计提金额
    ,o.cust_id -- 客户编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.fee_rat_id = n.fee_rat_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.fee_rat_id = d.fee_rat_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_dep_acct_seg_info_h;
alter table ${iml_schema}.agt_dep_acct_seg_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_dep_acct_seg_info_h exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_dep_acct_seg_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dep_acct_seg_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_dep_acct_seg_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dep_acct_seg_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
