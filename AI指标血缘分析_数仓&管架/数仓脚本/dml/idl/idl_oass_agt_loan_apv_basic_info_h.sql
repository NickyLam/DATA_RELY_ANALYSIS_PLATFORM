/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_loan_apv_basic_info_h
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
alter table ${idl_schema}.oass_agt_loan_apv_basic_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_loan_apv_basic_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_loan_apv_basic_info_h (
etl_dt  --数据日期
,appl_flow_num  --申请流水号
,cust_id  --客户编号
,cust_name  --客户名称
,appl_way_cd  --申请方式代码
,lmt_cont_flg  --额度合同标志
,loan_distr_type_cd  --贷款发放类型代码
,happ_dt  --发生日期
,curr_cd  --币种代码
,apv_amt  --审批金额
,base_prod_id  --基础产品编号
,prod_id  --产品编号
,mon_tenor  --月期限
,day_tenor  --日期限
,begin_dt  --起始日期
,exp_dt  --到期日期
,remote_bus_flg  --异地业务标志
,lmt_circl_flg  --额度循环标志
,risk_type_cd  --风险类型代码
,low_risk_bus_flg  --低风险业务标志
,crdt_dir_cd  --授信投向代码
,nat_std_indus_dir_cd  --国标行业投向代码
,bank_int_indus_dir_cd  --行内行业投向代码
,loan_usage_cd  --贷款用途代码
,usage_descb  --用途描述
,int_rat_mode_cd  --利率模式代码
,fix_int_rat  --固定利率
,base_rat_type_cd  --基准利率类型代码
,base_rat  --基准利率
,int_rat_float_type_cd  --利率浮动类型代码
,int_rat_adj_way_cd  --利率调整方式代码
,int_rat_flo_val  --利率浮动值
,exec_int_rat  --执行利率
,main_guar_way_cd  --主担保方式代码
,guar_way_cd_two  --担保方式代码二
,guar_way_cd_three  --担保方式代码三
,other_guar_way_cd  --其他担保方式代码
,supp_guar_way_flg  --追加担保方式标志
,other_cond_descb  --其他条件描述
,repay_way_cd  --还款方式代码
,repay_ped  --还款周期
,repay_ped_cd  --还款周期单位代码
,deflt_repay_day  --默认还款日
,rsrv_amt  --预留金额
,rela_old_cont_id  --关联旧合同编号
,lmt_id  --额度编号
,create_cont_flg  --生成合同标志
,apv_status_cd  --审批状态代码
,reply_type_cd  --批复类型代码
,final_apv_opinion_descb  --最终审批意见描述
,oper_teller_id  --业务经办人编号
,oper_org_id  --经办机构编号
,oper_dt  --经办日期
,rgst_teller_id  --登记柜员编号
,rgst_org_id  --登记机构编号
,rgst_dt  --登记日期
,update_teller_id  --更新柜员编号
,update_org_id  --更新机构编号
,modif_dt  --变更日期
,belong_strip_line_cd  --所属条线代码
,lp_id  --法人编号
,spec_ped_corp_cd  --指定周期单位代码
,spec_ped_cd  --指定周期代码
,b_renew_exp_dt  --展期前到期日期
,b_renew_amt  --展期前金额
,b_renew_exec_year_int_rat  --展期前执行年利率
,crdt_org_way_cd  --授信组织方式代码
,lmt_open_amt  --额度敞口金额
,file_dt  --归档日期
,level11_cls_cd  --十一级分类代码
,attach_rgst_flg  --补登标志
,effect_flg  --生效标志
,margin_acct_id  --保证金账户编号
,margin_tran_out_acct_id  --保证金转出账户编号
,margin_curr_cd  --保证金币种代码
,margin_ratio  --保证金比例
,margin_amt  --保证金金额
,int_rat_adj_ped_cd  --利率调整周期代码
,ovdue_exec_int_rat  --逾期执行利率
,ovdue_int_rat_float_way_cd  --逾期利率浮动方式代码
,ovdue_int_rat_flo_val  --逾期利率浮动值
,stl_acct_name  --结算账户名称
,enter_id  --入账账户编号
,stl_acct_id  --结算账户编号
,move_remark  --迁移备注
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,apv_flow_num  --审批流水号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num --申请流水号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --客户名称
,replace(replace(t1.appl_way_cd,chr(13),''),chr(10),'') as appl_way_cd --申请方式代码
,replace(replace(t1.lmt_cont_flg,chr(13),''),chr(10),'') as lmt_cont_flg --额度合同标志
,replace(replace(t1.loan_distr_type_cd,chr(13),''),chr(10),'') as loan_distr_type_cd --贷款发放类型代码
,t1.happ_dt as happ_dt --发生日期
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.apv_amt as apv_amt --审批金额
,replace(replace(t1.base_prod_id,chr(13),''),chr(10),'') as base_prod_id --基础产品编号
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,t1.mon_tenor as mon_tenor --月期限
,t1.day_tenor as day_tenor --日期限
,t1.begin_dt as begin_dt --起始日期
,t1.exp_dt as exp_dt --到期日期
,replace(replace(t1.remote_bus_flg,chr(13),''),chr(10),'') as remote_bus_flg --异地业务标志
,replace(replace(t1.lmt_circl_flg,chr(13),''),chr(10),'') as lmt_circl_flg --额度循环标志
,replace(replace(t1.risk_type_cd,chr(13),''),chr(10),'') as risk_type_cd --风险类型代码
,replace(replace(t1.low_risk_bus_flg,chr(13),''),chr(10),'') as low_risk_bus_flg --低风险业务标志
,replace(replace(t1.crdt_dir_cd,chr(13),''),chr(10),'') as crdt_dir_cd --授信投向代码
,replace(replace(t1.nat_std_indus_dir_cd,chr(13),''),chr(10),'') as nat_std_indus_dir_cd --国标行业投向代码
,replace(replace(t1.bank_int_indus_dir_cd,chr(13),''),chr(10),'') as bank_int_indus_dir_cd --行内行业投向代码
,replace(replace(t1.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd --贷款用途代码
,replace(replace(t1.usage_descb,chr(13),''),chr(10),'') as usage_descb --用途描述
,replace(replace(t1.int_rat_mode_cd,chr(13),''),chr(10),'') as int_rat_mode_cd --利率模式代码
,t1.fix_int_rat as fix_int_rat --固定利率
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd --基准利率类型代码
,t1.base_rat as base_rat --基准利率
,replace(replace(t1.int_rat_float_type_cd,chr(13),''),chr(10),'') as int_rat_float_type_cd --利率浮动类型代码
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd --利率调整方式代码
,t1.int_rat_flo_val as int_rat_flo_val --利率浮动值
,t1.exec_int_rat as exec_int_rat --执行利率
,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd --主担保方式代码
,replace(replace(t1.guar_way_cd_two,chr(13),''),chr(10),'') as guar_way_cd_two --担保方式代码二
,replace(replace(t1.guar_way_cd_three,chr(13),''),chr(10),'') as guar_way_cd_three --担保方式代码三
,replace(replace(t1.other_guar_way_cd,chr(13),''),chr(10),'') as other_guar_way_cd --其他担保方式代码
,replace(replace(t1.supp_guar_way_flg,chr(13),''),chr(10),'') as supp_guar_way_flg --追加担保方式标志
,replace(replace(t1.other_cond_descb,chr(13),''),chr(10),'') as other_cond_descb --其他条件描述
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd --还款方式代码
,replace(replace(t1.repay_ped,chr(13),''),chr(10),'') as repay_ped --还款周期
,replace(replace(t1.repay_ped_cd,chr(13),''),chr(10),'') as repay_ped_cd --还款周期单位代码
,replace(replace(t1.deflt_repay_day,chr(13),''),chr(10),'') as deflt_repay_day --默认还款日
,t1.rsrv_amt as rsrv_amt --预留金额
,replace(replace(t1.rela_old_cont_id,chr(13),''),chr(10),'') as rela_old_cont_id --关联旧合同编号
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id --额度编号
,replace(replace(t1.create_cont_flg,chr(13),''),chr(10),'') as create_cont_flg --生成合同标志
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd --审批状态代码
,replace(replace(t1.reply_type_cd,chr(13),''),chr(10),'') as reply_type_cd --批复类型代码
,replace(replace(t1.final_apv_opinion_descb,chr(13),''),chr(10),'') as final_apv_opinion_descb --最终审批意见描述
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id --业务经办人编号
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id --经办机构编号
,t1.oper_dt as oper_dt --经办日期
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id --登记柜员编号
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id --登记机构编号
,t1.rgst_dt as rgst_dt --登记日期
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id --更新柜员编号
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id --更新机构编号
,t1.modif_dt as modif_dt --变更日期
,replace(replace(t1.belong_strip_line_cd,chr(13),''),chr(10),'') as belong_strip_line_cd --所属条线代码
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.spec_ped_corp_cd,chr(13),''),chr(10),'') as spec_ped_corp_cd --指定周期单位代码
,replace(replace(t1.spec_ped_cd,chr(13),''),chr(10),'') as spec_ped_cd --指定周期代码
,t1.b_renew_exp_dt as b_renew_exp_dt --展期前到期日期
,t1.b_renew_amt as b_renew_amt --展期前金额
,t1.b_renew_exec_year_int_rat as b_renew_exec_year_int_rat --展期前执行年利率
,replace(replace(t1.crdt_org_way_cd,chr(13),''),chr(10),'') as crdt_org_way_cd --授信组织方式代码
,t1.lmt_open_amt as lmt_open_amt --额度敞口金额
,t1.file_dt as file_dt --归档日期
,replace(replace(t1.level11_cls_cd,chr(13),''),chr(10),'') as level11_cls_cd --十一级分类代码
,replace(replace(t1.attach_rgst_flg,chr(13),''),chr(10),'') as attach_rgst_flg --补登标志
,replace(replace(t1.effect_flg,chr(13),''),chr(10),'') as effect_flg --生效标志
,replace(replace(t1.margin_acct_id,chr(13),''),chr(10),'') as margin_acct_id --保证金账户编号
,replace(replace(t1.margin_tran_out_acct_id,chr(13),''),chr(10),'') as margin_tran_out_acct_id --保证金转出账户编号
,replace(replace(t1.margin_curr_cd,chr(13),''),chr(10),'') as margin_curr_cd --保证金币种代码
,t1.margin_ratio as margin_ratio --保证金比例
,t1.margin_amt as margin_amt --保证金金额
,replace(replace(t1.int_rat_adj_ped_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_cd --利率调整周期代码
,t1.ovdue_exec_int_rat as ovdue_exec_int_rat --逾期执行利率
,replace(replace(t1.ovdue_int_rat_float_way_cd,chr(13),''),chr(10),'') as ovdue_int_rat_float_way_cd --逾期利率浮动方式代码
,t1.ovdue_int_rat_flo_val as ovdue_int_rat_flo_val --逾期利率浮动值
,replace(replace(t1.stl_acct_name,chr(13),''),chr(10),'') as stl_acct_name --结算账户名称
,replace(replace(t1.enter_id,chr(13),''),chr(10),'') as enter_id --入账账户编号
,replace(replace(t1.stl_acct_id,chr(13),''),chr(10),'') as stl_acct_id --结算账户编号
,replace(replace(t1.move_remark,chr(13),''),chr(10),'') as move_remark --迁移备注
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.apv_flow_num,chr(13),''),chr(10),'') as apv_flow_num --审批流水号
from ${iml_schema}.agt_loan_apv_basic_info_h t1    --贷款审批基本信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_loan_apv_basic_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
