/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_loan_int_rat_h
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
alter table ${idl_schema}.oass_agt_loan_int_rat_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_loan_int_rat_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_loan_int_rat_h (
etl_dt  --数据日期
,loan_num  --贷款号
,int_cls_cd  --利息分类代码
,cust_id  --客户编号
,int_set_freq_cd  --结息频率代码
,next_int_set_dt  --下一结息日期
,int_set_day  --结息日
,int_rat_type_cd  --利率类型代码
,bank_int_int_rat  --行内利率
,float_int_rat  --浮动利率
,float_int_rat_point  --浮动利率点数
,float_int_rat_ratio  --浮动利率比例
,sub_acct_fix_int_rat  --分户级固定利率
,sub_acct_int_rat_float_point  --分户级利率浮动点数
,sub_acct_int_rat_float_ratio  --分户级利率浮动比例
,exec_int_rat  --执行利率
,year_int_accr_base_cd  --年计息基准代码
,mon_int_accr_base_cd  --月计息基准代码
,int_accr_base_cd  --计息基准代码
,int_accr_flg  --计息标志
,int_rat_start_use_way_cd  --利率启用方式代码
,int_rat_effect_way_cd  --利率生效方式代码
,next_int_rat_modif_dt  --下一利率变更日期
,int_rat_modif_ped_cd  --利率变更周期代码
,int_rat_modif_day  --利率变更日
,int_accr_begin_dt  --计息起始日期
,int_accr_exp_dt  --计息到期日期
,lowt_exec_int_rat  --最低执行利率
,higt_exec_int_rat  --最高执行利率
,cap_flg  --资本化标志
,pnlt_int_rat_use_way_cd  --罚息利率使用方式代码
,accrd_nomal_int_rat_float_flg  --按正常利率浮动标志
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num --贷款号
,replace(replace(t1.int_cls_cd,chr(13),''),chr(10),'') as int_cls_cd --利息分类代码
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.int_set_freq_cd,chr(13),''),chr(10),'') as int_set_freq_cd --结息频率代码
,t1.next_int_set_dt as next_int_set_dt --下一结息日期
,t1.int_set_day as int_set_day --结息日
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd --利率类型代码
,t1.bank_int_int_rat as bank_int_int_rat --行内利率
,t1.float_int_rat as float_int_rat --浮动利率
,t1.float_int_rat_point as float_int_rat_point --浮动利率点数
,t1.float_int_rat_ratio as float_int_rat_ratio --浮动利率比例
,t1.sub_acct_fix_int_rat as sub_acct_fix_int_rat --分户级固定利率
,t1.sub_acct_int_rat_float_point as sub_acct_int_rat_float_point --分户级利率浮动点数
,t1.sub_acct_int_rat_float_ratio as sub_acct_int_rat_float_ratio --分户级利率浮动比例
,t1.exec_int_rat as exec_int_rat --执行利率
,replace(replace(t1.year_int_accr_base_cd,chr(13),''),chr(10),'') as year_int_accr_base_cd --年计息基准代码
,replace(replace(t1.mon_int_accr_base_cd,chr(13),''),chr(10),'') as mon_int_accr_base_cd --月计息基准代码
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd --计息基准代码
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg --计息标志
,replace(replace(t1.int_rat_start_use_way_cd,chr(13),''),chr(10),'') as int_rat_start_use_way_cd --利率启用方式代码
,replace(replace(t1.int_rat_effect_way_cd,chr(13),''),chr(10),'') as int_rat_effect_way_cd --利率生效方式代码
,t1.next_int_rat_modif_dt as next_int_rat_modif_dt --下一利率变更日期
,replace(replace(t1.int_rat_modif_ped_cd,chr(13),''),chr(10),'') as int_rat_modif_ped_cd --利率变更周期代码
,t1.int_rat_modif_day as int_rat_modif_day --利率变更日
,t1.int_accr_begin_dt as int_accr_begin_dt --计息起始日期
,t1.int_accr_exp_dt as int_accr_exp_dt --计息到期日期
,t1.lowt_exec_int_rat as lowt_exec_int_rat --最低执行利率
,t1.higt_exec_int_rat as higt_exec_int_rat --最高执行利率
,replace(replace(t1.cap_flg,chr(13),''),chr(10),'') as cap_flg --资本化标志
,replace(replace(t1.pnlt_int_rat_use_way_cd,chr(13),''),chr(10),'') as pnlt_int_rat_use_way_cd --罚息利率使用方式代码
,replace(replace(t1.accrd_nomal_int_rat_float_flg,chr(13),''),chr(10),'') as accrd_nomal_int_rat_float_flg --按正常利率浮动标志
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_loan_int_rat_h t1    --贷款利率历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_loan_int_rat_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
