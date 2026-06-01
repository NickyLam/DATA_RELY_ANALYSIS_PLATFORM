/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_guar_cont_info_h
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
alter table ${idl_schema}.oass_agt_guar_cont_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_guar_cont_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_guar_cont_info_h (
etl_dt  --数据日期
,guar_cont_type_cd  --担保合同类型代码
,guar_way_cd  --担保方式代码
,cont_status_cd  --合同状态代码
,cont_sign_dt  --合同签定日期
,cont_effect_dt  --合同生效日期
,cont_exp_dt  --合同到期日期
,cust_id  --客户编号
,guartor_cate_cd  --担保人类别代码
,guartor_id  --担保人编号
,guartor_name  --担保人名称
,guar_curr_cd  --担保币种代码
,guar_tot_amt  --担保总金额
,other_espec_apot_descb  --其它特别约定描述
,guar_opinion_descb  --担保意见描述
,check_guar_dt  --核保日期
,guartor_cert_type_cd  --担保人证件类型代码
,guartor_cert_no  --担保人证件号码
,guartor_loan_card_no  --担保人贷款卡号
,guar_guar_form_cd  --保证担保形式代码
,rgst_org_id  --登记机构编号
,rgst_teller_id  --登记柜员编号
,rgst_dt  --登记日期
,update_org_id  --更新机构编号
,update_teller_id  --更新柜员编号
,modif_dt  --变更日期
,lp_id  --法人编号
,auth_begin_dt  --授权起始日期
,rev_guar_measure_flg  --反担保措施标志
,nat_std_indus_dir_cd  --国标行业投向代码
,corp_size_cd  --企业规模代码
,natnal_econ_dept_type_cd  --国民经济部门类型代码
,rgst_dist_cd  --注册地行政区划代码
,dir_hxb_guar_flg  --直接向我行担保标志
,obg_name  --权属人名称
,obg_cust_id  --权利人客户编号
,gcust_flg  --代保管标志
,resdnt_flg  --居民标志
,rgst_cty_rg_cd  --注册地国家和地区代码
,guartor_net_asset  --保证人净资产
,matn_flg  --维护标志
,lmt_cont_id  --额度合同编号
,ocup_guar_lmt_flg  --占用担保额度标志
,file_dt  --归档日期
,guar_type_cls_cd  --担保类型分类代码
,guar_exp_dt  --担保到期日期
,guar_begin_dt  --担保起始日期
,guar_range_cd  --担保范围代码
,pri_contr_id  --主合同编号
,brwer_name  --借款人名称
,text_cont_id  --文本合同编号
,ts_flg  --暂存标志
,elec_cont_type  --电子合同类型
,main_guar_way_cd  --主担保方式代码
,margin_ratio  --保证金比例
,credt_org_name  --债权人机构名称
,credt_org_id  --债权人机构编号
,guar_mon_tenor  --担保期限
,aldy_guar_amt  --已担保金额
,aval_bal  --可用余额
,auto_que_crdtc_rept_flg  --自动查询征信报告标志
,crdtc_que_auth_id  --征信查询授权书编号
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,guar_cont_id  --担保合同编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.guar_cont_type_cd,chr(13),''),chr(10),'') as guar_cont_type_cd --担保合同类型代码
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd --担保方式代码
,replace(replace(t1.cont_status_cd,chr(13),''),chr(10),'') as cont_status_cd --合同状态代码
,t1.cont_sign_dt as cont_sign_dt --合同签定日期
,t1.cont_effect_dt as cont_effect_dt --合同生效日期
,t1.cont_exp_dt as cont_exp_dt --合同到期日期
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.guartor_cate_cd,chr(13),''),chr(10),'') as guartor_cate_cd --担保人类别代码
,replace(replace(t1.guartor_id,chr(13),''),chr(10),'') as guartor_id --担保人编号
,replace(replace(t1.guartor_name,chr(13),''),chr(10),'') as guartor_name --担保人名称
,replace(replace(t1.guar_curr_cd,chr(13),''),chr(10),'') as guar_curr_cd --担保币种代码
,t1.guar_tot_amt as guar_tot_amt --担保总金额
,replace(replace(t1.other_espec_apot_descb,chr(13),''),chr(10),'') as other_espec_apot_descb --其它特别约定描述
,replace(replace(t1.guar_opinion_descb,chr(13),''),chr(10),'') as guar_opinion_descb --担保意见描述
,t1.check_guar_dt as check_guar_dt --核保日期
,replace(replace(t1.guartor_cert_type_cd,chr(13),''),chr(10),'') as guartor_cert_type_cd --担保人证件类型代码
,replace(replace(t1.guartor_cert_no,chr(13),''),chr(10),'') as guartor_cert_no --担保人证件号码
,replace(replace(t1.guartor_loan_card_no,chr(13),''),chr(10),'') as guartor_loan_card_no --担保人贷款卡号
,replace(replace(t1.guar_guar_form_cd,chr(13),''),chr(10),'') as guar_guar_form_cd --保证担保形式代码
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id --登记机构编号
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id --登记柜员编号
,t1.rgst_dt as rgst_dt --登记日期
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id --更新机构编号
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id --更新柜员编号
,t1.modif_dt as modif_dt --变更日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,t1.auth_begin_dt as auth_begin_dt --授权起始日期
,replace(replace(t1.rev_guar_measure_flg,chr(13),''),chr(10),'') as rev_guar_measure_flg --反担保措施标志
,replace(replace(t1.nat_std_indus_dir_cd,chr(13),''),chr(10),'') as nat_std_indus_dir_cd --国标行业投向代码
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd --企业规模代码
,replace(replace(t1.natnal_econ_dept_type_cd,chr(13),''),chr(10),'') as natnal_econ_dept_type_cd --国民经济部门类型代码
,replace(replace(t1.rgst_dist_cd,chr(13),''),chr(10),'') as rgst_dist_cd --注册地行政区划代码
,replace(replace(t1.dir_hxb_guar_flg,chr(13),''),chr(10),'') as dir_hxb_guar_flg --直接向我行担保标志
,replace(replace(t1.obg_name,chr(13),''),chr(10),'') as obg_name --权属人名称
,replace(replace(t1.obg_cust_id,chr(13),''),chr(10),'') as obg_cust_id --权利人客户编号
,replace(replace(t1.gcust_flg,chr(13),''),chr(10),'') as gcust_flg --代保管标志
,replace(replace(t1.resdnt_flg,chr(13),''),chr(10),'') as resdnt_flg --居民标志
,replace(replace(t1.rgst_cty_rg_cd,chr(13),''),chr(10),'') as rgst_cty_rg_cd --注册地国家和地区代码
,t1.guartor_net_asset as guartor_net_asset --保证人净资产
,replace(replace(t1.matn_flg,chr(13),''),chr(10),'') as matn_flg --维护标志
,replace(replace(t1.lmt_cont_id,chr(13),''),chr(10),'') as lmt_cont_id --额度合同编号
,replace(replace(t1.ocup_guar_lmt_flg,chr(13),''),chr(10),'') as ocup_guar_lmt_flg --占用担保额度标志
,t1.file_dt as file_dt --归档日期
,replace(replace(t1.guar_type_cls_cd,chr(13),''),chr(10),'') as guar_type_cls_cd --担保类型分类代码
,t1.guar_exp_dt as guar_exp_dt --担保到期日期
,t1.guar_begin_dt as guar_begin_dt --担保起始日期
,replace(replace(t1.guar_range_cd,chr(13),''),chr(10),'') as guar_range_cd --担保范围代码
,replace(replace(t1.pri_contr_id,chr(13),''),chr(10),'') as pri_contr_id --主合同编号
,replace(replace(t1.brwer_name,chr(13),''),chr(10),'') as brwer_name --借款人名称
,replace(replace(t1.text_cont_id,chr(13),''),chr(10),'') as text_cont_id --文本合同编号
,replace(replace(t1.ts_flg,chr(13),''),chr(10),'') as ts_flg --暂存标志
,replace(replace(t1.elec_cont_type,chr(13),''),chr(10),'') as elec_cont_type --电子合同类型
,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd --主担保方式代码
,t1.margin_ratio as margin_ratio --保证金比例
,replace(replace(t1.credt_org_name,chr(13),''),chr(10),'') as credt_org_name --债权人机构名称
,replace(replace(t1.credt_org_id,chr(13),''),chr(10),'') as credt_org_id --债权人机构编号
,t1.guar_mon_tenor as guar_mon_tenor --担保期限
,t1.aldy_guar_amt as aldy_guar_amt --已担保金额
,t1.aval_bal as aval_bal --可用余额
,replace(replace(t1.auto_que_crdtc_rept_flg,chr(13),''),chr(10),'') as auto_que_crdtc_rept_flg --自动查询征信报告标志
,replace(replace(t1.crdtc_que_auth_id,chr(13),''),chr(10),'') as crdtc_que_auth_id --征信查询授权书编号
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id --担保合同编号
from ${iml_schema}.agt_guar_cont_info_h t1    --担保合同信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_guar_cont_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
