/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_prd_finc_prod_imp_info_h
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
alter table ${idl_schema}.oass_prd_finc_prod_imp_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_prd_finc_prod_imp_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_prd_finc_prod_imp_info_h (
etl_dt  --数据日期
,cfm_dt  --确认日期
,prod_id  --产品编号
,ta_cd  --TA代码
,prod_tot_size  --产品总规模
,lot_tot  --份额总数
,td_add_shares  --当日增加份数
,td_decrs_shares  --当日减少份数
,prod_nv  --产品净值
,prod_fac_val  --产品面值
,prft_cust_ratio  --收益客户比例
,prft_assign_flg  --收益分配标志
,tran_flg  --转换标志
,status_cd  --状态代码
,ld_status_cd  --上日状态代码
,prod_acm_nv  --产品累计净值
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,issue_dt  --发布日期
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,t1.cfm_dt as cfm_dt --确认日期
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd --TA代码
,t1.prod_tot_size as prod_tot_size --产品总规模
,t1.lot_tot as lot_tot --份额总数
,t1.td_add_shares as td_add_shares --当日增加份数
,t1.td_decrs_shares as td_decrs_shares --当日减少份数
,t1.prod_nv as prod_nv --产品净值
,t1.prod_fac_val as prod_fac_val --产品面值
,t1.prft_cust_ratio as prft_cust_ratio --收益客户比例
,replace(replace(t1.prft_assign_flg,chr(13),''),chr(10),'') as prft_assign_flg --收益分配标志
,replace(replace(t1.tran_flg,chr(13),''),chr(10),'') as tran_flg --转换标志
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd --状态代码
,replace(replace(t1.ld_status_cd,chr(13),''),chr(10),'') as ld_status_cd --上日状态代码
,t1.prod_acm_nv as prod_acm_nv --产品累计净值
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,t1.issue_dt as issue_dt --发布日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.prd_finc_prod_imp_info_h t1    --理财产品重要信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_prd_finc_prod_imp_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
