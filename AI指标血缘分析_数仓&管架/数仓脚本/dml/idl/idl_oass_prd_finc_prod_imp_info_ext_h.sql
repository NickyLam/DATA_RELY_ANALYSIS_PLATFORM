/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_prd_finc_prod_imp_info_ext_h
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
alter table ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h (
etl_dt  --数据日期
,cfm_dt  --确认日期
,prod_cd  --产品代码
,nv_type_cd  --净值类型代码
,reg_quota_status_cd  --定期定额状态代码
,turn_trust_status_cd  --转托管状态代码
,curr_cd  --币种代码
,affi_flg  --公告标志
,indv_issue_way_cd  --个人发行方式代码
,org_issue_way_cd  --机构发行方式代码
,divd_dt  --分红日期
,eqty_rgst_dt  --权益登记日期
,ex_righ_dt  --除权日期
,subscr_way_cd  --认购方式代码
,charge_way_cd  --收费方式代码
,curr_fund_year_yld_rat  --货币基金年收益率
,allow_deflt_redem_flg  --允许违约赎回标志
,ta_cd  --TA代码
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,quar_aual_yld  --季度年化收益率
,quar_aual_yld_pm_cd  --季度年化收益率正负代码
,ped_yld_rat  --周期收益率
,ped_yld_rat_pm_cd  --周期收益率正负代码
,am_nv_dt  --资管净值日期
,issue_dt  --发布日期
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,t1.cfm_dt as cfm_dt --确认日期
,replace(replace(t1.prod_cd,chr(13),''),chr(10),'') as prod_cd --产品代码
,replace(replace(t1.nv_type_cd,chr(13),''),chr(10),'') as nv_type_cd --净值类型代码
,replace(replace(t1.reg_quota_status_cd,chr(13),''),chr(10),'') as reg_quota_status_cd --定期定额状态代码
,replace(replace(t1.turn_trust_status_cd,chr(13),''),chr(10),'') as turn_trust_status_cd --转托管状态代码
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,replace(replace(t1.affi_flg,chr(13),''),chr(10),'') as affi_flg --公告标志
,replace(replace(t1.indv_issue_way_cd,chr(13),''),chr(10),'') as indv_issue_way_cd --个人发行方式代码
,replace(replace(t1.org_issue_way_cd,chr(13),''),chr(10),'') as org_issue_way_cd --机构发行方式代码
,t1.divd_dt as divd_dt --分红日期
,t1.eqty_rgst_dt as eqty_rgst_dt --权益登记日期
,t1.ex_righ_dt as ex_righ_dt --除权日期
,replace(replace(t1.subscr_way_cd,chr(13),''),chr(10),'') as subscr_way_cd --认购方式代码
,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd --收费方式代码
,t1.curr_fund_year_yld_rat as curr_fund_year_yld_rat --货币基金年收益率
,replace(replace(t1.allow_deflt_redem_flg,chr(13),''),chr(10),'') as allow_deflt_redem_flg --允许违约赎回标志
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd --TA代码
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,t1.quar_aual_yld as quar_aual_yld --季度年化收益率
,replace(replace(t1.quar_aual_yld_pm_cd,chr(13),''),chr(10),'') as quar_aual_yld_pm_cd --季度年化收益率正负代码
,t1.ped_yld_rat as ped_yld_rat --周期收益率
,replace(replace(t1.ped_yld_rat_pm_cd,chr(13),''),chr(10),'') as ped_yld_rat_pm_cd --周期收益率正负代码
,t1.am_nv_dt as am_nv_dt --资管净值日期
,t1.issue_dt as issue_dt --发布日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.prd_finc_prod_imp_info_ext_h t1    --理财产品重要信息扩展历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_prd_finc_prod_imp_info_ext_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
