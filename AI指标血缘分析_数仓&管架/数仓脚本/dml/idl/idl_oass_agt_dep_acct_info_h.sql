/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_dep_acct_info_h
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
alter table ${idl_schema}.oass_agt_dep_acct_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_dep_acct_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_dep_acct_info_h (
etl_dt  --数据日期
,acct_id  --账户编号
,acct_name  --账户名称
,src_agt_id  --源协议编号
,realtm_chase_capt_flg  --实时追缴标志
,bal_type_cd  --钞汇余额代码
,acct_type_cd  --账户等级代码
,int_accr_flg  --计息标志
,open_acct_dt  --开户日期
,clos_acct_dt  --销户日期
,acct_status_cd  --账户状态代码
,curr_cd  --币种代码
,final_tran_dt  --最后交易日期
,open_acct_org_id  --开户机构编号
,open_acct_chn_id  --开户渠道编号
,belong_org_id  --所属机构编号
,vouch_type_cd  --凭证类型代码
,vouch_no  --凭证号码
,vouch_status_cd  --凭证状态代码
,cust_id  --客户编号
,priv_flg  --对私标志
,prod_id  --产品编号
,card_no  --卡号
,cust_acct_num  --客户账号
,sub_acct_num  --子账号
,effect_dt  --生效日期
,fir_tran_dt  --首次交易日期
,last_acct_status_cd  --上一账户状态代码
,status_modif_dt  --状态变更日期
,clos_acct_teller_id  --销户柜员编号
,clos_acct_rs  --销户原因
,core_acct_type_cd  --核心账户类型代码
,dep_term  --存款期限
,tenor_type_cd  --期限类型代码
,exp_dt  --到期日期
,acct_init_exp_dt  --账户原始到期日期
,acct_init_open_acct_dt  --账户原始开户日期
,acct_attr_cd  --存款账户类型代码
,temp_acct_valid_dt  --临时户有效日期
,vtual_acct_flg  --虚户标志
,lmt_flg  --限制标志
,stop_pay_flg  --止付标志
,general_storage_flg  --通存标志
,general_exch_flg  --通兑标志
,reg_acct_type_cd  --定期账户类型代码
,main_acct_flg  --主账户标志
,acct_lics_issue_dt  --账户许可证签发日期
,acct_lics_num  --账户许可证号码
,card_prod_id  --卡产品编号
,main_acct_bal_flg  --主账户带余额标志
,main_acct_int_flg  --主账户带利息标志
,redt_way_type_cd  --自动转存方式代码
,part_pric_redt_flg  --部分本金转存标志
,aldy_pric_redt_cnt  --已本金转存次数
,aldy_pric_int_redt_cnt  --已本息转存次数
,max_pric_redt_cnt  --最大本金转存次数
,max_pric_int_redt_cnt  --最大本息转存次数
,reg_acct_last_status_cd  --定期账户上一状态代码
,allow_add_pric_flg  --允许增加本金标志
,turn_dormt_acct_dt  --转不动户日期
,tran_stl_dt  --交易结算日期
,acct_appl_org_id  --账户申请机构编号
,approval_id  --核准件编号
,acct_aldy_check_flg  --账户已复核标志
,auto_payoff_flg  --自动结清标志
,gl_type_cd  --总账类型代码
,multi_bal_flg  --多余额标志
,l_six_m_no_tran_flg  --最近六个月无交易标志
,off_shore_flg  --离岸标志
,ftz_flg  --自贸区标志
,cust_mgr_id  --客户经理编号
,free_annual_fee_flg  --免年费标志
,exch_way_cd  --汇兑方式代码
,init_prod_id  --原产品编号
,curr_pd  --当前期次
,stl_flg  --结算标志
,stl_teller_id  --结算柜员编号
,src_module_type_cd  --源模块类型代码
,super_acct_id  --上级账户编号
,acct_usage_cd  --账户用途代码
,check_dt  --复核日期
,advise_dep_tenor  --通知存款期限
,check_teller_id  --复核柜员编号
,acct_char_type_cd  --账户性质类型代码
,open_acct_teller_id  --开户柜员编号
,prod_modif_dt  --产品变更日期
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id --账户编号
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name --账户名称
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id --源协议编号
,replace(replace(t1.realtm_chase_capt_flg,chr(13),''),chr(10),'') as realtm_chase_capt_flg --实时追缴标志
,replace(replace(t1.bal_type_cd,chr(13),''),chr(10),'') as bal_type_cd --钞汇余额代码
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd --账户等级代码
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg --计息标志
,t1.open_acct_dt as open_acct_dt --开户日期
,t1.clos_acct_dt as clos_acct_dt --销户日期
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd --账户状态代码
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.final_tran_dt as final_tran_dt --最后交易日期
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id --开户机构编号
,replace(replace(t1.open_acct_chn_id,chr(13),''),chr(10),'') as open_acct_chn_id --开户渠道编号
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id --所属机构编号
,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd --凭证类型代码
,replace(replace(t1.vouch_no,chr(13),''),chr(10),'') as vouch_no --凭证号码
,replace(replace(t1.vouch_status_cd,chr(13),''),chr(10),'') as vouch_status_cd --凭证状态代码
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.priv_flg,chr(13),''),chr(10),'') as priv_flg --对私标志
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no --卡号
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num --客户账号
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num --子账号
,t1.effect_dt as effect_dt --生效日期
,t1.fir_tran_dt as fir_tran_dt --首次交易日期
,replace(replace(t1.last_acct_status_cd,chr(13),''),chr(10),'') as last_acct_status_cd --上一账户状态代码
,t1.status_modif_dt as status_modif_dt --状态变更日期
,replace(replace(t1.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id --销户柜员编号
,replace(replace(t1.clos_acct_rs,chr(13),''),chr(10),'') as clos_acct_rs --销户原因
,replace(replace(t1.core_acct_type_cd,chr(13),''),chr(10),'') as core_acct_type_cd --核心账户类型代码
,t1.dep_term as dep_term --存款期限
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd --期限类型代码
,t1.exp_dt as exp_dt --到期日期
,t1.acct_init_exp_dt as acct_init_exp_dt --账户原始到期日期
,t1.acct_init_open_acct_dt as acct_init_open_acct_dt --账户原始开户日期
,replace(replace(t1.acct_attr_cd,chr(13),''),chr(10),'') as acct_attr_cd --存款账户类型代码
,t1.temp_acct_valid_dt as temp_acct_valid_dt --临时户有效日期
,replace(replace(t1.vtual_acct_flg,chr(13),''),chr(10),'') as vtual_acct_flg --虚户标志
,replace(replace(t1.lmt_flg,chr(13),''),chr(10),'') as lmt_flg --限制标志
,replace(replace(t1.stop_pay_flg,chr(13),''),chr(10),'') as stop_pay_flg --止付标志
,replace(replace(t1.general_storage_flg,chr(13),''),chr(10),'') as general_storage_flg --通存标志
,replace(replace(t1.general_exch_flg,chr(13),''),chr(10),'') as general_exch_flg --通兑标志
,replace(replace(t1.reg_acct_type_cd,chr(13),''),chr(10),'') as reg_acct_type_cd --定期账户类型代码
,replace(replace(t1.main_acct_flg,chr(13),''),chr(10),'') as main_acct_flg --主账户标志
,t1.acct_lics_issue_dt as acct_lics_issue_dt --账户许可证签发日期
,replace(replace(t1.acct_lics_num,chr(13),''),chr(10),'') as acct_lics_num --账户许可证号码
,replace(replace(t1.card_prod_id,chr(13),''),chr(10),'') as card_prod_id --卡产品编号
,replace(replace(t1.main_acct_bal_flg,chr(13),''),chr(10),'') as main_acct_bal_flg --主账户带余额标志
,replace(replace(t1.main_acct_int_flg,chr(13),''),chr(10),'') as main_acct_int_flg --主账户带利息标志
,replace(replace(t1.redt_way_type_cd,chr(13),''),chr(10),'') as redt_way_type_cd --自动转存方式代码
,replace(replace(t1.part_pric_redt_flg,chr(13),''),chr(10),'') as part_pric_redt_flg --部分本金转存标志
,t1.aldy_pric_redt_cnt as aldy_pric_redt_cnt --已本金转存次数
,t1.aldy_pric_int_redt_cnt as aldy_pric_int_redt_cnt --已本息转存次数
,t1.max_pric_redt_cnt as max_pric_redt_cnt --最大本金转存次数
,t1.max_pric_int_redt_cnt as max_pric_int_redt_cnt --最大本息转存次数
,replace(replace(t1.reg_acct_last_status_cd,chr(13),''),chr(10),'') as reg_acct_last_status_cd --定期账户上一状态代码
,replace(replace(t1.allow_add_pric_flg,chr(13),''),chr(10),'') as allow_add_pric_flg --允许增加本金标志
,t1.turn_dormt_acct_dt as turn_dormt_acct_dt --转不动户日期
,t1.tran_stl_dt as tran_stl_dt --交易结算日期
,replace(replace(t1.acct_appl_org_id,chr(13),''),chr(10),'') as acct_appl_org_id --账户申请机构编号
,replace(replace(t1.approval_id,chr(13),''),chr(10),'') as approval_id --核准件编号
,replace(replace(t1.acct_aldy_check_flg,chr(13),''),chr(10),'') as acct_aldy_check_flg --账户已复核标志
,replace(replace(t1.auto_payoff_flg,chr(13),''),chr(10),'') as auto_payoff_flg --自动结清标志
,replace(replace(t1.gl_type_cd,chr(13),''),chr(10),'') as gl_type_cd --总账类型代码
,replace(replace(t1.multi_bal_flg,chr(13),''),chr(10),'') as multi_bal_flg --多余额标志
,replace(replace(t1.l_six_m_no_tran_flg,chr(13),''),chr(10),'') as l_six_m_no_tran_flg --最近六个月无交易标志
,replace(replace(t1.off_shore_flg,chr(13),''),chr(10),'') as off_shore_flg --离岸标志
,replace(replace(t1.ftz_flg,chr(13),''),chr(10),'') as ftz_flg --自贸区标志
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id --客户经理编号
,replace(replace(t1.free_annual_fee_flg,chr(13),''),chr(10),'') as free_annual_fee_flg --免年费标志
,replace(replace(t1.exch_way_cd,chr(13),''),chr(10),'') as exch_way_cd --汇兑方式代码
,replace(replace(t1.init_prod_id,chr(13),''),chr(10),'') as init_prod_id --原产品编号
,t1.curr_pd as curr_pd --当前期次
,replace(replace(t1.stl_flg,chr(13),''),chr(10),'') as stl_flg --结算标志
,replace(replace(t1.stl_teller_id,chr(13),''),chr(10),'') as stl_teller_id --结算柜员编号
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd --源模块类型代码
,replace(replace(t1.super_acct_id,chr(13),''),chr(10),'') as super_acct_id --上级账户编号
,replace(replace(t1.acct_usage_cd,chr(13),''),chr(10),'') as acct_usage_cd --账户用途代码
,t1.check_dt as check_dt --复核日期
,t1.advise_dep_tenor as advise_dep_tenor --通知存款期限
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id --复核柜员编号
,replace(replace(t1.acct_char_type_cd,chr(13),''),chr(10),'') as acct_char_type_cd --账户性质类型代码
,replace(replace(t1.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id --开户柜员编号
,t1.prod_modif_dt as prod_modif_dt --产品变更日期
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_dep_acct_info_h t1    --存款账户信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_dep_acct_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
