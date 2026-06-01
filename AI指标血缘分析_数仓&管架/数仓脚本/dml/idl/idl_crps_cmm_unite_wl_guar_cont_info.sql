/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_crps_cmm_unite_wl_guar_cont_info
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
alter table ${idl_schema}.crps_cmm_unite_wl_guar_cont_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_cmm_unite_wl_guar_cont_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_cmm_unite_wl_guar_cont_info (
etl_dt  --数据日期
,lp_id  --法人编号
,guar_cont_id  --担保合同编号
,guar_cont_type_cd  --担保合同类型代码
,guar_way_cd  --担保方式代码
,guar_kind_cd  --保证种类代码
,status_cd  --状态代码
,curr_cd  --币种代码
,sign_dt  --签订日期
,effect_dt  --生效日期
,exp_dt  --到期日期
,cust_id  --客户编号
,guartor_cust_id  --担保人客户编号
,guartor_name  --担保人名称
,guartor_cert_type_cd  --担保人证件类型代码
,guartor_cert_no  --担保人证件号码
,guar_amt  --担保金额
,gover_fin_guar_corp_guar_flg  --政府性融资担保公司保证标志
,rev_guar_flg  --反担保标志
,guar_org_name  --担保机构名称
,guar_item_promis_id  --担保事项承诺书编号
,rgst_org_id  --登记机构编号
,rgstrat_id  --登记人编号
,rgst_dt  --登记日期

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id --担保合同编号
,replace(replace(t1.guar_cont_type_cd,chr(13),''),chr(10),'') as guar_cont_type_cd --担保合同类型代码
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd --担保方式代码
,replace(replace(t1.guar_kind_cd,chr(13),''),chr(10),'') as guar_kind_cd --保证种类代码
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd --状态代码
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.sign_dt as sign_dt --签订日期
,t1.effect_dt as effect_dt --生效日期
,t1.exp_dt as exp_dt --到期日期
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.guartor_cust_id,chr(13),''),chr(10),'') as guartor_cust_id --担保人客户编号
,replace(replace(t1.guartor_name,chr(13),''),chr(10),'') as guartor_name --担保人名称
,replace(replace(t1.guartor_cert_type_cd,chr(13),''),chr(10),'') as guartor_cert_type_cd --担保人证件类型代码
,replace(replace(t1.guartor_cert_no,chr(13),''),chr(10),'') as guartor_cert_no --担保人证件号码
,t1.guar_amt as guar_amt --担保金额
,replace(replace(t1.gover_fin_guar_corp_guar_flg,chr(13),''),chr(10),'') as gover_fin_guar_corp_guar_flg --政府性融资担保公司保证标志
,replace(replace(t1.rev_guar_flg,chr(13),''),chr(10),'') as rev_guar_flg --反担保标志
,replace(replace(t1.guar_org_name,chr(13),''),chr(10),'') as guar_org_name --担保机构名称
,replace(replace(t1.guar_item_promis_id,chr(13),''),chr(10),'') as guar_item_promis_id --担保事项承诺书编号
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id --登记机构编号
,replace(replace(t1.rgstrat_id,chr(13),''),chr(10),'') as rgstrat_id --登记人编号
,t1.rgst_dt as rgst_dt --登记日期
from ${icl_schema}.cmm_unite_wl_guar_cont_info t1    --联合网贷担保合同信息
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_cmm_unite_wl_guar_cont_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
