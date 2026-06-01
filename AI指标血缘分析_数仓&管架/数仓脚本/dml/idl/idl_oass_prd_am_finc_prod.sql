/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_prd_am_finc_prod
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
alter table ${idl_schema}.oass_prd_am_finc_prod drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_prd_am_finc_prod add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_prd_am_finc_prod (
etl_dt  --ETL处理日期
,std_prod_id  --标准产品编号
,src_prod_id  --源产品编号
,prod_cate_cd  --产品类别代码
,prod_abbr  --产品简称
,prod_fname  --产品全称
,prft_mode_cd  --收益模式代码
,finc_prod_id  --理财产品编号
,issue_curr_cd  --发行币种代码
,tran_caln_cd  --交易日历代码
,coll_way_cd  --募集方式代码
,oper_mode_cd  --运作模式代码
,entr_way_cd  --委托方式代码
,csner_id  --委托人编号
,trustee_id  --托管人编号
,value_dt  --起息日期
,exp_dt  --到期日期
,prod_tenor  --产品期限
,actl_exp_dt  --实际到期日期
,liqd_dt  --清盘日期
,subtn_flg  --永续标志
,subtn_claus  --永续条款
,super_prod_id  --上级产品编号
,sell_dept_id  --销售部门编号
,purch_cfm_tenor  --申购确认期限
,redem_cfm_tenor  --赎回确认期限
,inv_port_id  --投资组合编号
,prod_rgst_code  --产品登记编码
,ped_prod_flg  --周期型产品标志
,layered_flg  --分层标志
,layered_type_cd  --分层类型代码
,invest_char_type_cd  --投资性质类型代码
,prft_type_cd  --收益类型代码
,issue_status_cd  --发行状态代码
,cash_mgmt_flg  --现金管理标志
,risk_level_cd  --风险等级代码
,proc_mode_cd  --处理模式代码
,exlus_prod_flg  --专属产品标志
,ped_days  --周期天数
,prod_mgr_name  --产品经理名称
,init_create_tm  --原创建时间
,init_update_tm  --原更新时间
,tenor_type_cd  --期限类型代码
,prod_seri_cd  --产品系列代码
,prod_cls_cd  --产品分类代码
,exlus_ibank_org_id  --专属同业机构编号
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,prod_id  --产品编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id --标准产品编号
,replace(replace(t1.src_prod_id,chr(13),''),chr(10),'') as src_prod_id --源产品编号
,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'') as prod_cate_cd --产品类别代码
,replace(replace(t1.prod_abbr,chr(13),''),chr(10),'') as prod_abbr --产品简称
,replace(replace(t1.prod_fname,chr(13),''),chr(10),'') as prod_fname --产品全称
,replace(replace(t1.prft_mode_cd,chr(13),''),chr(10),'') as prft_mode_cd --收益模式代码
,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id --理财产品编号
,replace(replace(t1.issue_curr_cd,chr(13),''),chr(10),'') as issue_curr_cd --发行币种代码
,replace(replace(t1.tran_caln_cd,chr(13),''),chr(10),'') as tran_caln_cd --交易日历代码
,replace(replace(t1.coll_way_cd,chr(13),''),chr(10),'') as coll_way_cd --募集方式代码
,replace(replace(t1.oper_mode_cd,chr(13),''),chr(10),'') as oper_mode_cd --运作模式代码
,replace(replace(t1.entr_way_cd,chr(13),''),chr(10),'') as entr_way_cd --委托方式代码
,replace(replace(t1.csner_id,chr(13),''),chr(10),'') as csner_id --委托人编号
,replace(replace(t1.trustee_id,chr(13),''),chr(10),'') as trustee_id --托管人编号
,t1.value_dt as value_dt --起息日期
,t1.exp_dt as exp_dt --到期日期
,t1.prod_tenor as prod_tenor --产品期限
,t1.actl_exp_dt as actl_exp_dt --实际到期日期
,t1.liqd_dt as liqd_dt --清盘日期
,replace(replace(t1.subtn_flg,chr(13),''),chr(10),'') as subtn_flg --永续标志
,replace(replace(t1.subtn_claus,chr(13),''),chr(10),'') as subtn_claus --永续条款
,replace(replace(t1.super_prod_id,chr(13),''),chr(10),'') as super_prod_id --上级产品编号
,replace(replace(t1.sell_dept_id,chr(13),''),chr(10),'') as sell_dept_id --销售部门编号
,t1.purch_cfm_tenor as purch_cfm_tenor --申购确认期限
,t1.redem_cfm_tenor as redem_cfm_tenor --赎回确认期限
,replace(replace(t1.inv_port_id,chr(13),''),chr(10),'') as inv_port_id --投资组合编号
,replace(replace(t1.prod_rgst_code,chr(13),''),chr(10),'') as prod_rgst_code --产品登记编码
,replace(replace(t1.ped_prod_flg,chr(13),''),chr(10),'') as ped_prod_flg --周期型产品标志
,replace(replace(t1.layered_flg,chr(13),''),chr(10),'') as layered_flg --分层标志
,replace(replace(t1.layered_type_cd,chr(13),''),chr(10),'') as layered_type_cd --分层类型代码
,replace(replace(t1.invest_char_type_cd,chr(13),''),chr(10),'') as invest_char_type_cd --投资性质类型代码
,replace(replace(t1.prft_type_cd,chr(13),''),chr(10),'') as prft_type_cd --收益类型代码
,replace(replace(t1.issue_status_cd,chr(13),''),chr(10),'') as issue_status_cd --发行状态代码
,replace(replace(t1.cash_mgmt_flg,chr(13),''),chr(10),'') as cash_mgmt_flg --现金管理标志
,replace(replace(t1.risk_level_cd,chr(13),''),chr(10),'') as risk_level_cd --风险等级代码
,replace(replace(t1.proc_mode_cd,chr(13),''),chr(10),'') as proc_mode_cd --处理模式代码
,replace(replace(t1.exlus_prod_flg,chr(13),''),chr(10),'') as exlus_prod_flg --专属产品标志
,replace(replace(t1.ped_days,chr(13),''),chr(10),'') as ped_days --周期天数
,replace(replace(t1.prod_mgr_name,chr(13),''),chr(10),'') as prod_mgr_name --产品经理名称
,t1.init_create_tm as init_create_tm --原创建时间
,t1.init_update_tm as init_update_tm --原更新时间
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd --期限类型代码
,replace(replace(t1.prod_seri_cd,chr(13),''),chr(10),'') as prod_seri_cd --产品系列代码
,replace(replace(t1.prod_cls_cd,chr(13),''),chr(10),'') as prod_cls_cd --产品分类代码
,replace(replace(t1.exlus_ibank_org_id,chr(13),''),chr(10),'') as exlus_ibank_org_id --专属同业机构编号
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.prd_am_finc_prod t1    --资管理财产品
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_prd_am_finc_prod',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
