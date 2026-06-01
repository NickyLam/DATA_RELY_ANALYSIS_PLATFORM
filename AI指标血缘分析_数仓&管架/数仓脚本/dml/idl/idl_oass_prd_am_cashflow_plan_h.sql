/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_prd_am_cashflow_plan_h
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_prd_am_cashflow_plan_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_prd_am_cashflow_plan_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_prd_am_cashflow_plan_h (
etl_dt  --数据日期
,cashflow_seq_num  --现金流序号
,cashflow_cate_cd  --现金流类别代码
,nadj_calc_start_dt  --未调整计算开始日期
,nadj_calc_end_dt  --未调整计算结束日期
,nadj_plan_pay_dt  --未调整计划支付日期
,a_adjust_calc_start_dt  --调整后计算开始日期
,a_adjust_calc_end_dt  --调整后计算结束日期
,a_adjust_plan_pay_dt  --调整后计划支付日期
,calc_ped_days  --计算周期天数
,integy_ped_start_dt  --完整周期开始日期
,integy_ped_end_dt  --完整周期结束日期
,integy_ped_days  --完整周期天数
,plan_pay_pric  --计划支付本金
,int_accr_pric  --计息本金
,plan_pay_int  --计划支付利息
,pay_int_flg  --支付利息标志
,plan_pay_amt  --计划支付金额
,cashflow_base  --现金流基数
,base_corp_type_cd  --基数单位类型代码
,year_pay_int_cnt  --年付息次数
,fin_prod_id  --金融产品编号
,prod_cate_cd  --产品类别代码
,brch_seq_num  --分支序号
,pay_type_cd  --支付类型代码
,intrv_net_yld_rat  --区间净收益率
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,cashflow_id  --现金流编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.cashflow_seq_num,chr(13),''),chr(10),'') as cashflow_seq_num --现金流序号
,replace(replace(t1.cashflow_cate_cd,chr(13),''),chr(10),'') as cashflow_cate_cd --现金流类别代码
,t1.nadj_calc_start_dt as nadj_calc_start_dt --未调整计算开始日期
,t1.nadj_calc_end_dt as nadj_calc_end_dt --未调整计算结束日期
,t1.nadj_plan_pay_dt as nadj_plan_pay_dt --未调整计划支付日期
,t1.a_adjust_calc_start_dt as a_adjust_calc_start_dt --调整后计算开始日期
,t1.a_adjust_calc_end_dt as a_adjust_calc_end_dt --调整后计算结束日期
,t1.a_adjust_plan_pay_dt as a_adjust_plan_pay_dt --调整后计划支付日期
,t1.calc_ped_days as calc_ped_days --计算周期天数
,t1.integy_ped_start_dt as integy_ped_start_dt --完整周期开始日期
,t1.integy_ped_end_dt as integy_ped_end_dt --完整周期结束日期
,t1.integy_ped_days as integy_ped_days --完整周期天数
,t1.plan_pay_pric as plan_pay_pric --计划支付本金
,t1.int_accr_pric as int_accr_pric --计息本金
,t1.plan_pay_int as plan_pay_int --计划支付利息
,replace(replace(t1.pay_int_flg,chr(13),''),chr(10),'') as pay_int_flg --支付利息标志
,t1.plan_pay_amt as plan_pay_amt --计划支付金额
,t1.cashflow_base as cashflow_base --现金流基数
,replace(replace(t1.base_corp_type_cd,chr(13),''),chr(10),'') as base_corp_type_cd --基数单位类型代码
,t1.year_pay_int_cnt as year_pay_int_cnt --年付息次数
,replace(replace(t1.fin_prod_id,chr(13),''),chr(10),'') as fin_prod_id --金融产品编号
,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'') as prod_cate_cd --产品类别代码
,replace(replace(t1.brch_seq_num,chr(13),''),chr(10),'') as brch_seq_num --分支序号
,replace(replace(t1.pay_type_cd,chr(13),''),chr(10),'') as pay_type_cd --支付类型代码
,t1.intrv_net_yld_rat as intrv_net_yld_rat --区间净收益率
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.cashflow_id,chr(13),''),chr(10),'') as cashflow_id --现金流编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.prd_am_cashflow_plan_h t1    --资管现金流计划历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_prd_am_cashflow_plan_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
