/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_prd_prod_int_rat_info_h
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
alter table ${idl_schema}.oass_prd_prod_int_rat_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_prd_prod_int_rat_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_prd_prod_int_rat_info_h (
etl_dt  --数据日期
,evt_cate_id  --事件类别编号
,int_cls_cd  --利息分类代码
,int_rat_type_cd  --利率类型代码
,tax_category_cd  --税种代码
,use_sub_acct_int_rat_flg  --使用分户利率标志
,int_accr_way_cd  --计息方式代码
,int_rat_file_way_cd  --利率靠档方式代码
,file_amt_type_cd  --靠档金额类型代码
,amt_file_dir_cd  --金额靠档方向代码
,amt_file_way_cd  --金额靠档方式代码
,days_file_dir_cd  --天数靠档方向代码
,days_file_way_cd  --天数靠档方式代码
,int_calc_amt_type_cd  --利息计算金额类型代码
,value_day_get_val_way_cd  --起息日取值方式代码
,file_days_calc_way_cd  --靠档天数计算方式代码
,int_rat_start_use_way_cd  --利率启用方式代码
,mon_int_accr_base_cd  --月计息基准代码
,grouping_rule_rela_cd  --分组规则关系代码
,int_dtl_effect_way_cd  --利息明细生效方式代码
,int_modif_way_cd  --利息重算方式代码
,min_int_rat  --最小利率
,max_int_rat  --最大利率
,int_rat_modif_day  --利率变更日
,int_rat_modif_ped_cd  --利率变更周期代码
,substr_flg  --截位标志
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,lp_id  --法人编号
,prod_id  --产品编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.evt_cate_id,chr(13),''),chr(10),'') as evt_cate_id --事件类别编号
,replace(replace(t1.int_cls_cd,chr(13),''),chr(10),'') as int_cls_cd --利息分类代码
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd --利率类型代码
,replace(replace(t1.tax_category_cd,chr(13),''),chr(10),'') as tax_category_cd --税种代码
,replace(replace(t1.use_sub_acct_int_rat_flg,chr(13),''),chr(10),'') as use_sub_acct_int_rat_flg --使用分户利率标志
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd --计息方式代码
,replace(replace(t1.int_rat_file_way_cd,chr(13),''),chr(10),'') as int_rat_file_way_cd --利率靠档方式代码
,replace(replace(t1.file_amt_type_cd,chr(13),''),chr(10),'') as file_amt_type_cd --靠档金额类型代码
,replace(replace(t1.amt_file_dir_cd,chr(13),''),chr(10),'') as amt_file_dir_cd --金额靠档方向代码
,replace(replace(t1.amt_file_way_cd,chr(13),''),chr(10),'') as amt_file_way_cd --金额靠档方式代码
,replace(replace(t1.days_file_dir_cd,chr(13),''),chr(10),'') as days_file_dir_cd --天数靠档方向代码
,replace(replace(t1.days_file_way_cd,chr(13),''),chr(10),'') as days_file_way_cd --天数靠档方式代码
,replace(replace(t1.int_calc_amt_type_cd,chr(13),''),chr(10),'') as int_calc_amt_type_cd --利息计算金额类型代码
,replace(replace(t1.value_day_get_val_way_cd,chr(13),''),chr(10),'') as value_day_get_val_way_cd --起息日取值方式代码
,replace(replace(t1.file_days_calc_way_cd,chr(13),''),chr(10),'') as file_days_calc_way_cd --靠档天数计算方式代码
,replace(replace(t1.int_rat_start_use_way_cd,chr(13),''),chr(10),'') as int_rat_start_use_way_cd --利率启用方式代码
,replace(replace(t1.mon_int_accr_base_cd,chr(13),''),chr(10),'') as mon_int_accr_base_cd --月计息基准代码
,replace(replace(t1.grouping_rule_rela_cd,chr(13),''),chr(10),'') as grouping_rule_rela_cd --分组规则关系代码
,replace(replace(t1.int_dtl_effect_way_cd,chr(13),''),chr(10),'') as int_dtl_effect_way_cd --利息明细生效方式代码
,replace(replace(t1.int_modif_way_cd,chr(13),''),chr(10),'') as int_modif_way_cd --利息重算方式代码
,t1.min_int_rat as min_int_rat --最小利率
,t1.max_int_rat as max_int_rat --最大利率
,t1.int_rat_modif_day as int_rat_modif_day --利率变更日
,replace(replace(t1.int_rat_modif_ped_cd,chr(13),''),chr(10),'') as int_rat_modif_ped_cd --利率变更周期代码
,replace(replace(t1.substr_flg,chr(13),''),chr(10),'') as substr_flg --截位标志
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
from ${iml_schema}.prd_prod_int_rat_info_h t1    --产品利率信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_prd_prod_int_rat_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
