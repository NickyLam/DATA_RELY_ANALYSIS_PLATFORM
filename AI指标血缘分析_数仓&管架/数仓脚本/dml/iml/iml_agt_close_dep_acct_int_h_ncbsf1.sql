/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_close_dep_acct_int_h_ncbsf1
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
alter table ${iml_schema}.agt_close_dep_acct_int_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_close_dep_acct_int_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,provi_day -- 计提日
    ,int_provi_ped -- 利息计提周期
    ,next_provi_dt -- 下一计提日期
    ,last_provi_dt -- 上一计提日期
    ,int_set_flg -- 结息标志
    ,int_set_freq_cd -- 结息频率代码
    ,int_set_day -- 结息日
    ,int_set_amt -- 结息金额
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,next_int_set_dt -- 下一结息日期
    ,last_int_set_dt -- 上一结息日期
    ,last_real_int_set_dt -- 上一真实结息日期
    ,day_bf_last_int_set_dt -- 日切前上一结息日期
    ,int_rat_type_cd -- 利率类型代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,acm_provi_int -- 累计计提利息
    ,acm_int_adj_amt -- 累计利息调整
    ,ld_acm_provi_int -- 上日累计计提利息
    ,ld_acm_int_adj_amt -- 上日累计利息调整
    ,ld_acm_adj_dt -- 上日累计调整日期
    ,ld_acm_paid_dt -- 上日累计已付日期
    ,up_ld_acm_int_adj_amt -- 上上日累计利息调整
    ,up_ld_acm_provi_int -- 上上日累计计提利息
    ,up_ld_bf_pay_int -- 上上日前付息
    ,curr_mon_daily_end_day_bal_sum -- 当月累计日终余额
    ,last_mon_daily_end_day_bal_sum -- 上月累计日终余额
    ,cap_flg -- 资本化标志
    ,cust_id -- 客户编号
    ,tran_dt -- 交易日期
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_close_dep_acct_int_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_close_dep_acct_int_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_close_dep_acct_int_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_close_acct_int_detail-1
insert into ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,provi_day -- 计提日
    ,int_provi_ped -- 利息计提周期
    ,next_provi_dt -- 下一计提日期
    ,last_provi_dt -- 上一计提日期
    ,int_set_flg -- 结息标志
    ,int_set_freq_cd -- 结息频率代码
    ,int_set_day -- 结息日
    ,int_set_amt -- 结息金额
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,next_int_set_dt -- 下一结息日期
    ,last_int_set_dt -- 上一结息日期
    ,last_real_int_set_dt -- 上一真实结息日期
    ,day_bf_last_int_set_dt -- 日切前上一结息日期
    ,int_rat_type_cd -- 利率类型代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,acm_provi_int -- 累计计提利息
    ,acm_int_adj_amt -- 累计利息调整
    ,ld_acm_provi_int -- 上日累计计提利息
    ,ld_acm_int_adj_amt -- 上日累计利息调整
    ,ld_acm_adj_dt -- 上日累计调整日期
    ,ld_acm_paid_dt -- 上日累计已付日期
    ,up_ld_acm_int_adj_amt -- 上上日累计利息调整
    ,up_ld_acm_provi_int -- 上上日累计计提利息
    ,up_ld_bf_pay_int -- 上上日前付息
    ,curr_mon_daily_end_day_bal_sum -- 当月累计日终余额
    ,last_mon_daily_end_day_bal_sum -- 上月累计日终余额
    ,cap_flg -- 资本化标志
    ,cust_id -- 客户编号
    ,tran_dt -- 交易日期
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.INT_CLASS -- 利息分类代码
    ,TO_NUMBER(NVL(TRIM(P1.ACCR_INT_DAY),0)) -- 计提日
    ,P1.ACCR_PERIOD_FREQ -- 利息计提周期
    ,P1.NEXT_ACCR_DATE -- 下一计提日期
    ,P1.LAST_ACCRUAL_DATE -- 上一计提日期
    ,decode(trim(p1.CYCLE_FLAG),'','-','Y','1','N','0',p1.CYCLE_FLAG) -- 结息标志
    ,nvl(trim(P1.CYCLE_FREQ),'-') -- 结息频率代码
    ,TO_NUMBER(NVL(TRIM(P1.INT_DAY),0)) -- 结息日
    ,P1.INT_POSTED -- 结息金额
    ,P1.CALC_BEGIN_DATE -- 起息日期
    ,P1.CALC_END_DATE -- 到期日期
    ,P1.NEXT_CYCLE_DATE -- 下一结息日期
    ,P1.LAST_CYCLE_DATE -- 上一结息日期
    ,P1.LAST_TRUE_CYCLE_DATE -- 上一真实结息日期
    ,P1.LAST_CYCLE_DATE_PRE -- 日切前上一结息日期
    ,nvl(trim(P1.INT_TYPE),'-') -- 利率类型代码
    ,nvl(trim(P1.RATE_EFFECT_TYPE),'-') -- 利率生效方式代码
    ,P1.INT_ACCRUED -- 累计计提利息
    ,P1.INT_ADJ -- 累计利息调整
    ,P1.INT_ACCRUED_PREV -- 上日累计计提利息
    ,P1.INT_ADJ_PREV -- 上日累计利息调整
    ,P1.ADJ_UPD_LAST_DATE -- 上日累计调整日期
    ,P1.ADV_UPD_LAST_DATE -- 上日累计已付日期
    ,P1.INT_ADJ_LAST_PREV -- 上上日累计利息调整
    ,P1.INT_ACCRUED_LAST_PREV -- 上上日累计计提利息
    ,P1.DISCNT_INT_LAST_PREV -- 上上日前付息
    ,P1.MONTH_TOTAL_AMOUNT -- 当月累计日终余额
    ,P1.LAST_MONTH_TOTAL_AMOUNT -- 上月累计日终余额
    ,decode(trim(p1.INT_CAP_FLAG),'','-','Y','1','N','0',p1.INT_CAP_FLAG) -- 资本化标志
    ,P1.CLIENT_NO -- 客户编号
    ,${iml_schema}.timeformat_max2(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易日期
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,P1.LAST_CHANGE_USER_ID -- 最后修改柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_close_acct_int_detail' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_close_acct_int_detail p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,acct_id
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
        into ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,provi_day -- 计提日
    ,int_provi_ped -- 利息计提周期
    ,next_provi_dt -- 下一计提日期
    ,last_provi_dt -- 上一计提日期
    ,int_set_flg -- 结息标志
    ,int_set_freq_cd -- 结息频率代码
    ,int_set_day -- 结息日
    ,int_set_amt -- 结息金额
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,next_int_set_dt -- 下一结息日期
    ,last_int_set_dt -- 上一结息日期
    ,last_real_int_set_dt -- 上一真实结息日期
    ,day_bf_last_int_set_dt -- 日切前上一结息日期
    ,int_rat_type_cd -- 利率类型代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,acm_provi_int -- 累计计提利息
    ,acm_int_adj_amt -- 累计利息调整
    ,ld_acm_provi_int -- 上日累计计提利息
    ,ld_acm_int_adj_amt -- 上日累计利息调整
    ,ld_acm_adj_dt -- 上日累计调整日期
    ,ld_acm_paid_dt -- 上日累计已付日期
    ,up_ld_acm_int_adj_amt -- 上上日累计利息调整
    ,up_ld_acm_provi_int -- 上上日累计计提利息
    ,up_ld_bf_pay_int -- 上上日前付息
    ,curr_mon_daily_end_day_bal_sum -- 当月累计日终余额
    ,last_mon_daily_end_day_bal_sum -- 上月累计日终余额
    ,cap_flg -- 资本化标志
    ,cust_id -- 客户编号
    ,tran_dt -- 交易日期
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,provi_day -- 计提日
    ,int_provi_ped -- 利息计提周期
    ,next_provi_dt -- 下一计提日期
    ,last_provi_dt -- 上一计提日期
    ,int_set_flg -- 结息标志
    ,int_set_freq_cd -- 结息频率代码
    ,int_set_day -- 结息日
    ,int_set_amt -- 结息金额
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,next_int_set_dt -- 下一结息日期
    ,last_int_set_dt -- 上一结息日期
    ,last_real_int_set_dt -- 上一真实结息日期
    ,day_bf_last_int_set_dt -- 日切前上一结息日期
    ,int_rat_type_cd -- 利率类型代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,acm_provi_int -- 累计计提利息
    ,acm_int_adj_amt -- 累计利息调整
    ,ld_acm_provi_int -- 上日累计计提利息
    ,ld_acm_int_adj_amt -- 上日累计利息调整
    ,ld_acm_adj_dt -- 上日累计调整日期
    ,ld_acm_paid_dt -- 上日累计已付日期
    ,up_ld_acm_int_adj_amt -- 上上日累计利息调整
    ,up_ld_acm_provi_int -- 上上日累计计提利息
    ,up_ld_bf_pay_int -- 上上日前付息
    ,curr_mon_daily_end_day_bal_sum -- 当月累计日终余额
    ,last_mon_daily_end_day_bal_sum -- 上月累计日终余额
    ,cap_flg -- 资本化标志
    ,cust_id -- 客户编号
    ,tran_dt -- 交易日期
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
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
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.int_cls_cd, o.int_cls_cd) as int_cls_cd -- 利息分类代码
    ,nvl(n.provi_day, o.provi_day) as provi_day -- 计提日
    ,nvl(n.int_provi_ped, o.int_provi_ped) as int_provi_ped -- 利息计提周期
    ,nvl(n.next_provi_dt, o.next_provi_dt) as next_provi_dt -- 下一计提日期
    ,nvl(n.last_provi_dt, o.last_provi_dt) as last_provi_dt -- 上一计提日期
    ,nvl(n.int_set_flg, o.int_set_flg) as int_set_flg -- 结息标志
    ,nvl(n.int_set_freq_cd, o.int_set_freq_cd) as int_set_freq_cd -- 结息频率代码
    ,nvl(n.int_set_day, o.int_set_day) as int_set_day -- 结息日
    ,nvl(n.int_set_amt, o.int_set_amt) as int_set_amt -- 结息金额
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.next_int_set_dt, o.next_int_set_dt) as next_int_set_dt -- 下一结息日期
    ,nvl(n.last_int_set_dt, o.last_int_set_dt) as last_int_set_dt -- 上一结息日期
    ,nvl(n.last_real_int_set_dt, o.last_real_int_set_dt) as last_real_int_set_dt -- 上一真实结息日期
    ,nvl(n.day_bf_last_int_set_dt, o.day_bf_last_int_set_dt) as day_bf_last_int_set_dt -- 日切前上一结息日期
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.int_rat_effect_way_cd, o.int_rat_effect_way_cd) as int_rat_effect_way_cd -- 利率生效方式代码
    ,nvl(n.acm_provi_int, o.acm_provi_int) as acm_provi_int -- 累计计提利息
    ,nvl(n.acm_int_adj_amt, o.acm_int_adj_amt) as acm_int_adj_amt -- 累计利息调整
    ,nvl(n.ld_acm_provi_int, o.ld_acm_provi_int) as ld_acm_provi_int -- 上日累计计提利息
    ,nvl(n.ld_acm_int_adj_amt, o.ld_acm_int_adj_amt) as ld_acm_int_adj_amt -- 上日累计利息调整
    ,nvl(n.ld_acm_adj_dt, o.ld_acm_adj_dt) as ld_acm_adj_dt -- 上日累计调整日期
    ,nvl(n.ld_acm_paid_dt, o.ld_acm_paid_dt) as ld_acm_paid_dt -- 上日累计已付日期
    ,nvl(n.up_ld_acm_int_adj_amt, o.up_ld_acm_int_adj_amt) as up_ld_acm_int_adj_amt -- 上上日累计利息调整
    ,nvl(n.up_ld_acm_provi_int, o.up_ld_acm_provi_int) as up_ld_acm_provi_int -- 上上日累计计提利息
    ,nvl(n.up_ld_bf_pay_int, o.up_ld_bf_pay_int) as up_ld_bf_pay_int -- 上上日前付息
    ,nvl(n.curr_mon_daily_end_day_bal_sum, o.curr_mon_daily_end_day_bal_sum) as curr_mon_daily_end_day_bal_sum -- 当月累计日终余额
    ,nvl(n.last_mon_daily_end_day_bal_sum, o.last_mon_daily_end_day_bal_sum) as last_mon_daily_end_day_bal_sum -- 上月累计日终余额
    ,nvl(n.cap_flg, o.cap_flg) as cap_flg -- 资本化标志
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.final_modif_teller_id, o.final_modif_teller_id) as final_modif_teller_id -- 最后修改柜员编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.int_cls_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.int_cls_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.int_cls_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.int_cls_cd = n.int_cls_cd
where (
        o.agt_id is null
        and o.lp_id is null
        and o.acct_id is null
        and o.int_cls_cd is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.acct_id is null
        and n.int_cls_cd is null
    )
    or (
        o.provi_day <> n.provi_day
        or o.int_provi_ped <> n.int_provi_ped
        or o.next_provi_dt <> n.next_provi_dt
        or o.last_provi_dt <> n.last_provi_dt
        or o.int_set_flg <> n.int_set_flg
        or o.int_set_freq_cd <> n.int_set_freq_cd
        or o.int_set_day <> n.int_set_day
        or o.int_set_amt <> n.int_set_amt
        or o.value_dt <> n.value_dt
        or o.exp_dt <> n.exp_dt
        or o.next_int_set_dt <> n.next_int_set_dt
        or o.last_int_set_dt <> n.last_int_set_dt
        or o.last_real_int_set_dt <> n.last_real_int_set_dt
        or o.day_bf_last_int_set_dt <> n.day_bf_last_int_set_dt
        or o.int_rat_type_cd <> n.int_rat_type_cd
        or o.int_rat_effect_way_cd <> n.int_rat_effect_way_cd
        or o.acm_provi_int <> n.acm_provi_int
        or o.acm_int_adj_amt <> n.acm_int_adj_amt
        or o.ld_acm_provi_int <> n.ld_acm_provi_int
        or o.ld_acm_int_adj_amt <> n.ld_acm_int_adj_amt
        or o.ld_acm_adj_dt <> n.ld_acm_adj_dt
        or o.ld_acm_paid_dt <> n.ld_acm_paid_dt
        or o.up_ld_acm_int_adj_amt <> n.up_ld_acm_int_adj_amt
        or o.up_ld_acm_provi_int <> n.up_ld_acm_provi_int
        or o.up_ld_bf_pay_int <> n.up_ld_bf_pay_int
        or o.curr_mon_daily_end_day_bal_sum <> n.curr_mon_daily_end_day_bal_sum
        or o.last_mon_daily_end_day_bal_sum <> n.last_mon_daily_end_day_bal_sum
        or o.cap_flg <> n.cap_flg
        or o.cust_id <> n.cust_id
        or o.tran_dt <> n.tran_dt
        or o.final_modif_dt <> n.final_modif_dt
        or o.final_modif_teller_id <> n.final_modif_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,provi_day -- 计提日
    ,int_provi_ped -- 利息计提周期
    ,next_provi_dt -- 下一计提日期
    ,last_provi_dt -- 上一计提日期
    ,int_set_flg -- 结息标志
    ,int_set_freq_cd -- 结息频率代码
    ,int_set_day -- 结息日
    ,int_set_amt -- 结息金额
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,next_int_set_dt -- 下一结息日期
    ,last_int_set_dt -- 上一结息日期
    ,last_real_int_set_dt -- 上一真实结息日期
    ,day_bf_last_int_set_dt -- 日切前上一结息日期
    ,int_rat_type_cd -- 利率类型代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,acm_provi_int -- 累计计提利息
    ,acm_int_adj_amt -- 累计利息调整
    ,ld_acm_provi_int -- 上日累计计提利息
    ,ld_acm_int_adj_amt -- 上日累计利息调整
    ,ld_acm_adj_dt -- 上日累计调整日期
    ,ld_acm_paid_dt -- 上日累计已付日期
    ,up_ld_acm_int_adj_amt -- 上上日累计利息调整
    ,up_ld_acm_provi_int -- 上上日累计计提利息
    ,up_ld_bf_pay_int -- 上上日前付息
    ,curr_mon_daily_end_day_bal_sum -- 当月累计日终余额
    ,last_mon_daily_end_day_bal_sum -- 上月累计日终余额
    ,cap_flg -- 资本化标志
    ,cust_id -- 客户编号
    ,tran_dt -- 交易日期
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,provi_day -- 计提日
    ,int_provi_ped -- 利息计提周期
    ,next_provi_dt -- 下一计提日期
    ,last_provi_dt -- 上一计提日期
    ,int_set_flg -- 结息标志
    ,int_set_freq_cd -- 结息频率代码
    ,int_set_day -- 结息日
    ,int_set_amt -- 结息金额
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,next_int_set_dt -- 下一结息日期
    ,last_int_set_dt -- 上一结息日期
    ,last_real_int_set_dt -- 上一真实结息日期
    ,day_bf_last_int_set_dt -- 日切前上一结息日期
    ,int_rat_type_cd -- 利率类型代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,acm_provi_int -- 累计计提利息
    ,acm_int_adj_amt -- 累计利息调整
    ,ld_acm_provi_int -- 上日累计计提利息
    ,ld_acm_int_adj_amt -- 上日累计利息调整
    ,ld_acm_adj_dt -- 上日累计调整日期
    ,ld_acm_paid_dt -- 上日累计已付日期
    ,up_ld_acm_int_adj_amt -- 上上日累计利息调整
    ,up_ld_acm_provi_int -- 上上日累计计提利息
    ,up_ld_bf_pay_int -- 上上日前付息
    ,curr_mon_daily_end_day_bal_sum -- 当月累计日终余额
    ,last_mon_daily_end_day_bal_sum -- 上月累计日终余额
    ,cap_flg -- 资本化标志
    ,cust_id -- 客户编号
    ,tran_dt -- 交易日期
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
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
    ,o.acct_id -- 账户编号
    ,o.int_cls_cd -- 利息分类代码
    ,o.provi_day -- 计提日
    ,o.int_provi_ped -- 利息计提周期
    ,o.next_provi_dt -- 下一计提日期
    ,o.last_provi_dt -- 上一计提日期
    ,o.int_set_flg -- 结息标志
    ,o.int_set_freq_cd -- 结息频率代码
    ,o.int_set_day -- 结息日
    ,o.int_set_amt -- 结息金额
    ,o.value_dt -- 起息日期
    ,o.exp_dt -- 到期日期
    ,o.next_int_set_dt -- 下一结息日期
    ,o.last_int_set_dt -- 上一结息日期
    ,o.last_real_int_set_dt -- 上一真实结息日期
    ,o.day_bf_last_int_set_dt -- 日切前上一结息日期
    ,o.int_rat_type_cd -- 利率类型代码
    ,o.int_rat_effect_way_cd -- 利率生效方式代码
    ,o.acm_provi_int -- 累计计提利息
    ,o.acm_int_adj_amt -- 累计利息调整
    ,o.ld_acm_provi_int -- 上日累计计提利息
    ,o.ld_acm_int_adj_amt -- 上日累计利息调整
    ,o.ld_acm_adj_dt -- 上日累计调整日期
    ,o.ld_acm_paid_dt -- 上日累计已付日期
    ,o.up_ld_acm_int_adj_amt -- 上上日累计利息调整
    ,o.up_ld_acm_provi_int -- 上上日累计计提利息
    ,o.up_ld_bf_pay_int -- 上上日前付息
    ,o.curr_mon_daily_end_day_bal_sum -- 当月累计日终余额
    ,o.last_mon_daily_end_day_bal_sum -- 上月累计日终余额
    ,o.cap_flg -- 资本化标志
    ,o.cust_id -- 客户编号
    ,o.tran_dt -- 交易日期
    ,o.final_modif_dt -- 最后修改日期
    ,o.final_modif_teller_id -- 最后修改柜员编号
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
from ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_bk o
    left join ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.int_cls_cd = n.int_cls_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.acct_id = d.acct_id
            and o.int_cls_cd = d.int_cls_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_close_dep_acct_int_h;
--alter table ${iml_schema}.agt_close_dep_acct_int_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_close_dep_acct_int_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_close_dep_acct_int_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_close_dep_acct_int_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_close_dep_acct_int_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_cl;
alter table ${iml_schema}.agt_close_dep_acct_int_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_close_dep_acct_int_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_close_dep_acct_int_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_close_dep_acct_int_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
