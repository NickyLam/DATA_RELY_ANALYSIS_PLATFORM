/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_prd_am_cashflow_calc_rule_h
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
alter table ${idl_schema}.oass_prd_am_cashflow_calc_rule_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_prd_am_cashflow_calc_rule_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_prd_am_cashflow_calc_rule_h (
etl_dt  --数据日期
,effect_dt  --生效日期
,accti_type_cd  --核算类型代码
,base_type_cd  --基数类型代码
,base_dt_type_cd  --基数日期类型代码
,int_accr_base_cd  --计息基准代码
,int_rat  --利率
,init_int_rat_flg  --初始利率标志
,prod_id  --产品编号
,src_prod_id  --源产品编号
,brch_seq_num  --分支序号
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,cashflow_id  --现金流编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,t1.effect_dt as effect_dt --生效日期
,replace(replace(t1.accti_type_cd,chr(13),''),chr(10),'') as accti_type_cd --核算类型代码
,replace(replace(t1.base_type_cd,chr(13),''),chr(10),'') as base_type_cd --基数类型代码
,replace(replace(t1.base_dt_type_cd,chr(13),''),chr(10),'') as base_dt_type_cd --基数日期类型代码
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd --计息基准代码
,t1.int_rat as int_rat --利率
,replace(replace(t1.init_int_rat_flg,chr(13),''),chr(10),'') as init_int_rat_flg --初始利率标志
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.src_prod_id,chr(13),''),chr(10),'') as src_prod_id --源产品编号
,t1.brch_seq_num as brch_seq_num --分支序号
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.cashflow_id,chr(13),''),chr(10),'') as cashflow_id --现金流编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.prd_am_cashflow_calc_rule_h t1    --资管现金流计算规则历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_prd_am_cashflow_calc_rule_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
