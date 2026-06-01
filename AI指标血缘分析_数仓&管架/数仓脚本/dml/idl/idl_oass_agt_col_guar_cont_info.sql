/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_col_guar_cont_info
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
alter table ${idl_schema}.oass_agt_col_guar_cont_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_col_guar_cont_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_col_guar_cont_info (
etl_dt  --数据日期
,guar_amt  --担保金额
,guar_amt_convt_cny  --担保金额_折人民币
,guar_cont_id  --担保合同编号
,guar_cont_type_cd  --担保合同类型代码
,guartor_id  --担保人编号
,guartor_type_cd  --担保人类型代码
,guartor_rg_num  --担保人地区号
,strip_line_cd  --条线代码
,cont_type_cd  --合同类型代码
,setup_dt  --建立日期
,setup_ps_id  --建立人编号
,guar_curr_cd  --担保币种代码
,guartor_rating  --担保人评级
,data_src_cd  --数据来源代码
,effect_flg  --生效标志
,exp_day  --到期日
,exp_status_cd  --到期状态代码
,higt_pm_cont_flg  --最高抵质押合同标志
,mender_id  --修改人编号
,modif_dt  --修改日期
,begin_day  --起始日
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,t1.guar_amt as guar_amt --担保金额
,t1.guar_amt_convt_cny as guar_amt_convt_cny --担保金额_折人民币
,replace(replace(t1.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id --担保合同编号
,replace(replace(t1.guar_cont_type_cd,chr(13),''),chr(10),'') as guar_cont_type_cd --担保合同类型代码
,replace(replace(t1.guartor_id,chr(13),''),chr(10),'') as guartor_id --担保人编号
,replace(replace(t1.guartor_type_cd,chr(13),''),chr(10),'') as guartor_type_cd --担保人类型代码
,replace(replace(t1.guartor_rg_num,chr(13),''),chr(10),'') as guartor_rg_num --担保人地区号
,replace(replace(t1.strip_line_cd,chr(13),''),chr(10),'') as strip_line_cd --条线代码
,replace(replace(t1.cont_type_cd,chr(13),''),chr(10),'') as cont_type_cd --合同类型代码
,t1.setup_dt as setup_dt --建立日期
,replace(replace(t1.setup_ps_id,chr(13),''),chr(10),'') as setup_ps_id --建立人编号
,replace(replace(t1.guar_curr_cd,chr(13),''),chr(10),'') as guar_curr_cd --担保币种代码
,replace(replace(t1.guartor_rating,chr(13),''),chr(10),'') as guartor_rating --担保人评级
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd --数据来源代码
,replace(replace(t1.effect_flg,chr(13),''),chr(10),'') as effect_flg --生效标志
,t1.exp_day as exp_day --到期日
,replace(replace(t1.exp_status_cd,chr(13),''),chr(10),'') as exp_status_cd --到期状态代码
,replace(replace(t1.higt_pm_cont_flg,chr(13),''),chr(10),'') as higt_pm_cont_flg --最高抵质押合同标志
,replace(replace(t1.mender_id,chr(13),''),chr(10),'') as mender_id --修改人编号
,t1.modif_dt as modif_dt --修改日期
,t1.begin_day as begin_day --起始日
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_col_guar_cont_info t1    --押品担保合同信息表
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_col_guar_cont_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
