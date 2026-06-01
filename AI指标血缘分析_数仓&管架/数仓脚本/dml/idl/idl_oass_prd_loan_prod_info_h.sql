/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_prd_loan_prod_info_h
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
alter table ${idl_schema}.oass_prd_loan_prod_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_prd_loan_prod_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_prd_loan_prod_info_h (
etl_dt  --数据日期
,prod_name  --产品名称
,bus_breed_cd  --业务品种代码
,super_prod_id  --上级产品编号
,leaf_node_flg  --叶节点标志
,mgmt_dept_id  --管理部门编号
,bus_dept_id  --产品发行机构编号
,exlus_prod_flg  --专属产品标志
,off_bs_flg  --表外标志
,allow_pkg_flg  --允许打包标志
,lmt_prod_flg  --额度产品标志
,loan_mon_tenor  --期限值
,lmt_ocup_way_cd  --额度被占用方式代码
,lmt_rela_agt_flg  --额度关联协议标志
,ocup_lmt_flg  --占用额度标志
,lmt_ocup_comnt  --额度占用说明
,public_lmt_flg  --公开额度标志
,lmt_uniq_flg  --额度唯一标志
,uniq_fit_range_cd  --唯一性适用范围代码
,fit_role_descb  --适用角色描述
,lmt_fit_prod_descb  --额度适用产品描述
,circl_idf_flg  --循环标识标志
,aval_curr_cd  --可用币种代码
,prod_status_cd  --产品状态代码
,prod_descb  --产品描述
,prod_effect_dt  --产品生效日期
,prod_invalid_dt  --产品失效日期
,prod_belong_gen_cd  --产品所属大类代码
,base_claus_model_id  --基础条款模型编号
,rela_claus_model_id  --关联条款模型编号
,noth_risk_bus_flg  --无风险业务标志
,all_open_bus_flg  --全敞口业务标志
,allow_multi_out_acct_flg  --允许多次出账标志
,allow_adv_repay_flg  --允许提前还款标志
,prod_type_cd  --产品类型代码
,allow_multi_distr_flg  --允许多次放款标志
,proc_cap_usage_check_flg  --进行资金用途检查标志
,lmt_ctrl_stage_cd  --额度管控阶段代码
,rgst_teller_id  --登记柜员编号
,rgst_org_id  --登记机构编号
,rgst_dt  --登记日期
,update_teller_id  --更新柜员编号
,update_org_id  --更新机构编号
,modif_dt  --变更日期
,crdt_prod_cate_cd  --信贷产品类别代码
,asset_thd_cls_cd  --资产三分类代码
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,prod_id  --产品编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name --产品名称
,replace(replace(t1.bus_breed_cd,chr(13),''),chr(10),'') as bus_breed_cd --业务品种代码
,replace(replace(t1.super_prod_id,chr(13),''),chr(10),'') as super_prod_id --上级产品编号
,replace(replace(t1.leaf_node_flg,chr(13),''),chr(10),'') as leaf_node_flg --叶节点标志
,replace(replace(t1.mgmt_dept_id,chr(13),''),chr(10),'') as mgmt_dept_id --管理部门编号
,replace(replace(t1.bus_dept_id,chr(13),''),chr(10),'') as bus_dept_id --产品发行机构编号
,replace(replace(t1.exlus_prod_flg,chr(13),''),chr(10),'') as exlus_prod_flg --专属产品标志
,replace(replace(t1.off_bs_flg,chr(13),''),chr(10),'') as off_bs_flg --表外标志
,replace(replace(t1.allow_pkg_flg,chr(13),''),chr(10),'') as allow_pkg_flg --允许打包标志
,replace(replace(t1.lmt_prod_flg,chr(13),''),chr(10),'') as lmt_prod_flg --额度产品标志
,t1.loan_mon_tenor as loan_mon_tenor --期限值
,replace(replace(t1.lmt_ocup_way_cd,chr(13),''),chr(10),'') as lmt_ocup_way_cd --额度被占用方式代码
,replace(replace(t1.lmt_rela_agt_flg,chr(13),''),chr(10),'') as lmt_rela_agt_flg --额度关联协议标志
,replace(replace(t1.ocup_lmt_flg,chr(13),''),chr(10),'') as ocup_lmt_flg --占用额度标志
,replace(replace(t1.lmt_ocup_comnt,chr(13),''),chr(10),'') as lmt_ocup_comnt --额度占用说明
,replace(replace(t1.public_lmt_flg,chr(13),''),chr(10),'') as public_lmt_flg --公开额度标志
,replace(replace(t1.lmt_uniq_flg,chr(13),''),chr(10),'') as lmt_uniq_flg --额度唯一标志
,replace(replace(t1.uniq_fit_range_cd,chr(13),''),chr(10),'') as uniq_fit_range_cd --唯一性适用范围代码
,replace(replace(t1.fit_role_descb,chr(13),''),chr(10),'') as fit_role_descb --适用角色描述
,replace(replace(t1.lmt_fit_prod_descb,chr(13),''),chr(10),'') as lmt_fit_prod_descb --额度适用产品描述
,replace(replace(t1.circl_idf_flg,chr(13),''),chr(10),'') as circl_idf_flg --循环标识标志
,replace(replace(t1.aval_curr_cd,chr(13),''),chr(10),'') as aval_curr_cd --可用币种代码
,replace(replace(t1.prod_status_cd,chr(13),''),chr(10),'') as prod_status_cd --产品状态代码
,replace(replace(t1.prod_descb,chr(13),''),chr(10),'') as prod_descb --产品描述
,t1.prod_effect_dt as prod_effect_dt --产品生效日期
,t1.prod_invalid_dt as prod_invalid_dt --产品失效日期
,replace(replace(t1.prod_belong_gen_cd,chr(13),''),chr(10),'') as prod_belong_gen_cd --产品所属大类代码
,replace(replace(t1.base_claus_model_id,chr(13),''),chr(10),'') as base_claus_model_id --基础条款模型编号
,replace(replace(t1.rela_claus_model_id,chr(13),''),chr(10),'') as rela_claus_model_id --关联条款模型编号
,replace(replace(t1.noth_risk_bus_flg,chr(13),''),chr(10),'') as noth_risk_bus_flg --无风险业务标志
,replace(replace(t1.all_open_bus_flg,chr(13),''),chr(10),'') as all_open_bus_flg --全敞口业务标志
,replace(replace(t1.allow_multi_out_acct_flg,chr(13),''),chr(10),'') as allow_multi_out_acct_flg --允许多次出账标志
,replace(replace(t1.allow_adv_repay_flg,chr(13),''),chr(10),'') as allow_adv_repay_flg --允许提前还款标志
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd --产品类型代码
,replace(replace(t1.allow_multi_distr_flg,chr(13),''),chr(10),'') as allow_multi_distr_flg --允许多次放款标志
,replace(replace(t1.proc_cap_usage_check_flg,chr(13),''),chr(10),'') as proc_cap_usage_check_flg --进行资金用途检查标志
,replace(replace(t1.lmt_ctrl_stage_cd,chr(13),''),chr(10),'') as lmt_ctrl_stage_cd --额度管控阶段代码
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id --登记柜员编号
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id --登记机构编号
,t1.rgst_dt as rgst_dt --登记日期
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id --更新柜员编号
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id --更新机构编号
,t1.modif_dt as modif_dt --变更日期
,replace(replace(t1.crdt_prod_cate_cd,chr(13),''),chr(10),'') as crdt_prod_cate_cd --信贷产品类别代码
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd --资产三分类代码
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.prd_loan_prod_info_h t1    --贷款产品信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_prd_loan_prod_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
