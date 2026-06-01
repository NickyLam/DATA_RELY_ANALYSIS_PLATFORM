/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_fin_subj_info_h
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
alter table ${idl_schema}.oass_fin_subj_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_fin_subj_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_fin_subj_info_h (
etl_dt  --数据日期
,subj_id  --科目编号
,super_subj_id  --上级科目编号
,subj_name  --科目名称
,subj_level_cd  --科目级别代码
,subj_type_cd  --科目类型代码
,subj_attr_cd  --科目属性代码
,end_level_subj_flg  --末级科目标志
,subj_bal_dir_cd  --科目余额方向代码
,subj_status_cd  --科目状态代码
,lmt_subj_flg  --受限科目标志
,allow_od_flg  --透支标志
,curr_char_proj_cd  --货币性项目代码
,setup_acct_type_cd  --建账类型代码
,subj_belong_cd  --科目归属代码
,in_bs_flg  --表内标志
,manual_open_acct_proc_mode_cd  --手工开户受理模式代码
,start_use_dt  --启用日期
,stop_use_dt  --停用日期
,subj_use_sys_cd  --科目使用系统代码
,subj_amt_dir_cd  --科目发生额方向代码
,price_tax_sept_cd  --价税分离代码
,subj_bal_float_warn_flg  --科目余额浮动预警标志
,cnter_manual_entry_start_dt  --柜面手工记账开始日期
,cnter_manual_entry_end_dt  --柜面手工记账结束日期
,accti_midgrod_manual_entry_start_dt  --核算中台手工记账开始日期
,accti_midgrod_manual_entry_end_dt  --核算中台手工记账结束日期
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,sob_id  --账套编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id --科目编号
,replace(replace(t1.super_subj_id,chr(13),''),chr(10),'') as super_subj_id --上级科目编号
,replace(replace(t1.subj_name,chr(13),''),chr(10),'') as subj_name --科目名称
,t1.subj_level_cd as subj_level_cd --科目级别代码
,replace(replace(t1.subj_type_cd,chr(13),''),chr(10),'') as subj_type_cd --科目类型代码
,replace(replace(t1.subj_attr_cd,chr(13),''),chr(10),'') as subj_attr_cd --科目属性代码
,replace(replace(t1.end_level_subj_flg,chr(13),''),chr(10),'') as end_level_subj_flg --末级科目标志
,replace(replace(t1.subj_bal_dir_cd,chr(13),''),chr(10),'') as subj_bal_dir_cd --科目余额方向代码
,replace(replace(t1.subj_status_cd,chr(13),''),chr(10),'') as subj_status_cd --科目状态代码
,replace(replace(t1.lmt_subj_flg,chr(13),''),chr(10),'') as lmt_subj_flg --受限科目标志
,replace(replace(t1.allow_od_flg,chr(13),''),chr(10),'') as allow_od_flg --透支标志
,replace(replace(t1.curr_char_proj_cd,chr(13),''),chr(10),'') as curr_char_proj_cd --货币性项目代码
,replace(replace(t1.setup_acct_type_cd,chr(13),''),chr(10),'') as setup_acct_type_cd --建账类型代码
,replace(replace(t1.subj_belong_cd,chr(13),''),chr(10),'') as subj_belong_cd --科目归属代码
,replace(replace(t1.in_bs_flg,chr(13),''),chr(10),'') as in_bs_flg --表内标志
,replace(replace(t1.manual_open_acct_proc_mode_cd,chr(13),''),chr(10),'') as manual_open_acct_proc_mode_cd --手工开户受理模式代码
,t1.start_use_dt as start_use_dt --启用日期
,t1.stop_use_dt as stop_use_dt --停用日期
,replace(replace(t1.subj_use_sys_cd,chr(13),''),chr(10),'') as subj_use_sys_cd --科目使用系统代码
,replace(replace(t1.subj_amt_dir_cd,chr(13),''),chr(10),'') as subj_amt_dir_cd --科目发生额方向代码
,replace(replace(t1.price_tax_sept_cd,chr(13),''),chr(10),'') as price_tax_sept_cd --价税分离代码
,replace(replace(t1.subj_bal_float_warn_flg,chr(13),''),chr(10),'') as subj_bal_float_warn_flg --科目余额浮动预警标志
,t1.cnter_manual_entry_start_dt as cnter_manual_entry_start_dt --柜面手工记账开始日期
,t1.cnter_manual_entry_end_dt as cnter_manual_entry_end_dt --柜面手工记账结束日期
,t1.accti_midgrod_manual_entry_start_dt as accti_midgrod_manual_entry_start_dt --核算中台手工记账开始日期
,t1.accti_midgrod_manual_entry_end_dt as accti_midgrod_manual_entry_end_dt --核算中台手工记账结束日期
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.sob_id,chr(13),''),chr(10),'') as sob_id --账套编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.fin_subj_info_h t1    --科目信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_fin_subj_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
