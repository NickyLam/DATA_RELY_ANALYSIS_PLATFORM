/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_crps_cmm_unite_wl_loan_guar_cont_rela
CreateDate: 20231111
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela (
etl_dt  --数据日期
,lp_id	--法人编号
,loan_cont_id	--贷款合同编号
,guar_cont_id	--担保合同编号
,col_id	--押品编号
,guar_way_cd	--担保方式代码
,guar_curr_cd	--担保币种代码
,guar_cont_status_cd	--担保合同状态代码
,guartor_cust_id	--担保人客户号
,guartor_name --担保人名称
,guar_effect_dt --担保生效日期
,guar_exp_dt --担保到期日期

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.loan_cont_id,chr(13),''),chr(10),'') as loan_cont_id
,replace(replace(t1.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.guar_curr_cd,chr(13),''),chr(10),'') as guar_curr_cd
,replace(replace(t1.guar_cont_status_cd,chr(13),''),chr(10),'') as guar_cont_status_cd
,replace(replace(t1.guartor_cust_id,chr(13),''),chr(10),'') as guartor_cust_id
,replace(replace(t1.guartor_name,chr(13),''),chr(10),'') as guartor_name
,guar_effect_dt
,guar_exp_dt

from ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela t1    --联合网贷贷款合同信息
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_cmm_unite_wl_loan_guar_cont_rela',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
