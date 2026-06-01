/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_loan_out_acct_appl_h
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
alter table ${idl_schema}.oass_agt_loan_out_acct_appl_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_loan_out_acct_appl_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_loan_out_acct_appl_h (
etl_dt  --数据日期
,cont_id  --合同编号
,cust_id  --客户编号
,cust_name  --客户名称
,prod_id  --产品编号
,curr_cd  --币种代码
,cont_amt  --合同金额
,ths_tm_distr_amt  --本次放款金额
,loan_distr_type_cd  --贷款发放类型代码
,happ_dt  --发生日期
,distr_dt  --发放日期
,exp_dt  --到期日期
,int_rat_mode_cd  --利率模式代码
,fix_int_rat  --固定利率
,base_rat_type_cd  --基准利率类型代码
,base_rat  --基准利率
,int_rat_float_type_cd  --利率浮动类型代码
,int_rat_adj_way_cd  --利率调整方式代码
,int_rat_flo_val  --利率浮动值
,exec_int_rat  --执行利率
,stl_acct_id  --结算账户编号
,enter_id  --入账账户编号
,secd_repay_acct_id  --第二还款账户编号
,distr_mode_pay_cd  --放款支付方式代码
,appl_way_cd  --申请方式代码
,apv_status_cd  --审批状态代码
,belong_strip_line_cd  --所属条线代码
,off_bs_flg  --表外标志
,low_risk_flg  --低风险标志
,lmt_id  --额度编号
,spec_ped_corp_cd  --指定周期单位代码
,spec_ped_cd  --指定周期代码
,repay_way_cd  --还款方式代码
,repay_ped  --还款周期
,repay_ped_cd  --还款周期单位代码
,deflt_repay_day  --默认还款日
,ovdue_exec_int_rat  --逾期执行利率
,ovdue_int_rat_float_way_cd  --逾期利率浮动方式代码
,ovdue_int_rat_flo_val  --逾期利率浮动值
,oper_org_id  --经办机构编号
,bus_oper_teller_id  --业务经办人编号
,oper_dt  --经办日期
,rgst_teller_id  --登记柜员编号
,rgst_org_id  --登记机构编号
,rgst_dt  --登记日期
,update_teller_id  --更新柜员编号
,update_org_id  --更新机构编号
,modif_dt  --变更日期
,lp_id  --法人编号
,text_cont_id  --文本合同编号
,margin_acct_id  --保证金账户编号
,margin_tran_out_acct_id  --保证金转出账户编号
,margin_curr_cd  --保证金币种代码
,margin_ratio  --保证金比例
,margin_sub_acct_num  --保证金子账号
,margin_amt  --保证金金额
,dubil_id  --借据编号
,subj_id  --科目编号
,out_acct_org_id  --出账机构编号
,loan_org_id  --贷款机构编号
,int_accr_way_cd  --计息方式代码
,enter_open_acct_org_id  --入账账户开户机构编号
,enter_name  --入账账户名称
,enter_sub_acct_num  --入账账户子账号
,comm_fee_collect_way_cd  --手续费计收方式代码
,comm_fee_deduct_acct_id  --手续费扣费账户编号
,comm_fee_amort_flg  --手续费摊销标志
,comm_fee_rat  --手续费率
,comm_fee_amt  --手续费金额
,loan_usage_cd  --贷款用途代码
,entr_pay_amt  --受托支付金额
,entr_pay_stop_pay_flow_num  --受托支付止付流水号
,file_dt  --归档日期
,major_guar_way_cd  --主要担保方式代码
,mon_tenor  --月期限
,day_tenor  --日期限
,tran_status_cd  --交易状态代码
,tran_tm  --交易时间
,core_tran_dt  --核心交易日期
,core_tran_flow_num  --核心交易流水号
,stl_acct_name  --结算账户名称
,int_rat_adj_ped_cd  --利率调整周期代码
,move_remark  --迁移备注
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --申请编号
,out_acct_flow_num  --出账流水号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id --合同编号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --客户名称
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.cont_amt as cont_amt --合同金额
,t1.ths_tm_distr_amt as ths_tm_distr_amt --本次放款金额
,replace(replace(t1.loan_distr_type_cd,chr(13),''),chr(10),'') as loan_distr_type_cd --贷款发放类型代码
,t1.happ_dt as happ_dt --发生日期
,t1.distr_dt as distr_dt --发放日期
,t1.exp_dt as exp_dt --到期日期
,replace(replace(t1.int_rat_mode_cd,chr(13),''),chr(10),'') as int_rat_mode_cd --利率模式代码
,t1.fix_int_rat as fix_int_rat --固定利率
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd --基准利率类型代码
,t1.base_rat as base_rat --基准利率
,replace(replace(t1.int_rat_float_type_cd,chr(13),''),chr(10),'') as int_rat_float_type_cd --利率浮动类型代码
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd --利率调整方式代码
,t1.int_rat_flo_val as int_rat_flo_val --利率浮动值
,t1.exec_int_rat as exec_int_rat --执行利率
,replace(replace(t1.stl_acct_id,chr(13),''),chr(10),'') as stl_acct_id --结算账户编号
,replace(replace(t1.enter_id,chr(13),''),chr(10),'') as enter_id --入账账户编号
,replace(replace(t1.secd_repay_acct_id,chr(13),''),chr(10),'') as secd_repay_acct_id --第二还款账户编号
,replace(replace(t1.distr_mode_pay_cd,chr(13),''),chr(10),'') as distr_mode_pay_cd --放款支付方式代码
,replace(replace(t1.appl_way_cd,chr(13),''),chr(10),'') as appl_way_cd --申请方式代码
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd --审批状态代码
,replace(replace(t1.belong_strip_line_cd,chr(13),''),chr(10),'') as belong_strip_line_cd --所属条线代码
,replace(replace(t1.off_bs_flg,chr(13),''),chr(10),'') as off_bs_flg --表外标志
,replace(replace(t1.low_risk_flg,chr(13),''),chr(10),'') as low_risk_flg --低风险标志
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id --额度编号
,replace(replace(t1.spec_ped_corp_cd,chr(13),''),chr(10),'') as spec_ped_corp_cd --指定周期单位代码
,replace(replace(t1.spec_ped_cd,chr(13),''),chr(10),'') as spec_ped_cd --指定周期代码
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd --还款方式代码
,replace(replace(t1.repay_ped,chr(13),''),chr(10),'') as repay_ped --还款周期
,replace(replace(t1.repay_ped_cd,chr(13),''),chr(10),'') as repay_ped_cd --还款周期单位代码
,t1.deflt_repay_day as deflt_repay_day --默认还款日
,t1.ovdue_exec_int_rat as ovdue_exec_int_rat --逾期执行利率
,replace(replace(t1.ovdue_int_rat_float_way_cd,chr(13),''),chr(10),'') as ovdue_int_rat_float_way_cd --逾期利率浮动方式代码
,t1.ovdue_int_rat_flo_val as ovdue_int_rat_flo_val --逾期利率浮动值
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id --经办机构编号
,replace(replace(t1.bus_oper_teller_id,chr(13),''),chr(10),'') as bus_oper_teller_id --业务经办人编号
,t1.oper_dt as oper_dt --经办日期
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id --登记柜员编号
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id --登记机构编号
,t1.rgst_dt as rgst_dt --登记日期
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id --更新柜员编号
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id --更新机构编号
,t1.modif_dt as modif_dt --变更日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.text_cont_id,chr(13),''),chr(10),'') as text_cont_id --文本合同编号
,replace(replace(t1.margin_acct_id,chr(13),''),chr(10),'') as margin_acct_id --保证金账户编号
,replace(replace(t1.margin_tran_out_acct_id,chr(13),''),chr(10),'') as margin_tran_out_acct_id --保证金转出账户编号
,replace(replace(t1.margin_curr_cd,chr(13),''),chr(10),'') as margin_curr_cd --保证金币种代码
,t1.margin_ratio as margin_ratio --保证金比例
,replace(replace(t1.margin_sub_acct_num,chr(13),''),chr(10),'') as margin_sub_acct_num --保证金子账号
,t1.margin_amt as margin_amt --保证金金额
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id --借据编号
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id --科目编号
,replace(replace(t1.out_acct_org_id,chr(13),''),chr(10),'') as out_acct_org_id --出账机构编号
,replace(replace(t1.loan_org_id,chr(13),''),chr(10),'') as loan_org_id --贷款机构编号
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd --计息方式代码
,replace(replace(t1.enter_open_acct_org_id,chr(13),''),chr(10),'') as enter_open_acct_org_id --入账账户开户机构编号
,replace(replace(t1.enter_name,chr(13),''),chr(10),'') as enter_name --入账账户名称
,replace(replace(t1.enter_sub_acct_num,chr(13),''),chr(10),'') as enter_sub_acct_num --入账账户子账号
,replace(replace(t1.comm_fee_collect_way_cd,chr(13),''),chr(10),'') as comm_fee_collect_way_cd --手续费计收方式代码
,replace(replace(t1.comm_fee_deduct_acct_id,chr(13),''),chr(10),'') as comm_fee_deduct_acct_id --手续费扣费账户编号
,replace(replace(t1.comm_fee_amort_flg,chr(13),''),chr(10),'') as comm_fee_amort_flg --手续费摊销标志
,t1.comm_fee_rat as comm_fee_rat --手续费率
,t1.comm_fee_amt as comm_fee_amt --手续费金额
,replace(replace(t1.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd --贷款用途代码
,t1.entr_pay_amt as entr_pay_amt --受托支付金额
,replace(replace(t1.entr_pay_stop_pay_flow_num,chr(13),''),chr(10),'') as entr_pay_stop_pay_flow_num --受托支付止付流水号
,t1.file_dt as file_dt --归档日期
,replace(replace(t1.major_guar_way_cd,chr(13),''),chr(10),'') as major_guar_way_cd --主要担保方式代码
,t1.mon_tenor as mon_tenor --月期限
,t1.day_tenor as day_tenor --日期限
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd --交易状态代码
,t1.tran_tm as tran_tm --交易时间
,t1.core_tran_dt as core_tran_dt --核心交易日期
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num --核心交易流水号
,replace(replace(t1.stl_acct_name,chr(13),''),chr(10),'') as stl_acct_name --结算账户名称
,replace(replace(t1.int_rat_adj_ped_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_cd --利率调整周期代码
,replace(replace(t1.move_remark,chr(13),''),chr(10),'') as move_remark --迁移备注
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --申请编号
,replace(replace(t1.out_acct_flow_num,chr(13),''),chr(10),'') as out_acct_flow_num --出账流水号
from ${iml_schema}.agt_loan_out_acct_appl_h t1    --贷款出账申请历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_loan_out_acct_appl_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
