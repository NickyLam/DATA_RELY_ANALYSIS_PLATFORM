/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_loan_dubil_info_h
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
alter table ${idl_schema}.oass_agt_loan_dubil_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_loan_dubil_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_loan_dubil_info_h (
etl_dt  --数据日期
,rela_out_acct_flow_num  --关联出账流水号
,rela_cont_id  --关联合同编号
,happ_dt  --发生日期
,loan_distr_type_cd  --贷款发放类型代码
,main_guar_way_cd  --主担保方式代码
,cust_id  --客户编号
,cust_name  --客户名称
,prod_id  --产品编号
,curr_cd  --币种代码
,dubil_amt  --借据金额
,mon_tenor  --月期限
,day_tenor  --日期限
,distr_dt  --发放日期
,apot_exp_dt  --约定到期日期
,actl_exp_dt  --实际到期日期
,int_rat_mode_cd  --利率模式代码
,base_rat_type_cd  --基准利率类型代码
,base_rat  --基准利率
,int_rat_float_type_cd  --利率浮动类型代码
,exec_year_int_rat  --执行年利率
,margin_ratio  --保证金比例
,margin_amt  --保证金金额
,margin_acct_id  --保证金账户编号
,distr_mode_pay_cd  --放款支付方式代码
,distr_acct_id  --放款账户编号
,distr_acct_name  --放款账户名称
,repay_way_cd  --还款方式代码
,repay_ped  --还款周期
,repay_ped_cd  --还款周期单位代码
,repay_acct_id  --还款账户编号
,repay_acct_name  --还款账户名称
,repay_num_bal  --还款账户可用余额
,repay_num_aval_bal  --
,curr_bal  --当前余额
,nomal_bal  --正常余额
,ovdue_bal  --逾期本金
,idle_bal  --呆滞余额
,bad_debt_bal  --呆账余额
,renew_cnt  --展期次数
,in_bs_over_int_bal  --表内欠息余额
,off_bs_over_int_bal  --表外欠息余额
,ovdue_pnlt_bal  --逾期罚息余额
,comp_int_bal  --复息余额
,loan_ovdue_days  --贷款逾期天数
,over_int_days  --欠息天数
,loan_grace_period  --贷款宽限期天数
,provi_resv_lmt  --计提准备金额
,pre_loss_amt  --预测损失金额
,termnt_dt  --终止日期
,belong_strip_line_cd  --所属条线代码
,off_bs_flg  --表外标志
,low_risk_flg  --低风险标志
,fir_idtfy_non_dt  --首次认定不良日期
,level5_cls_cd  --五级分类代码
,level5_cls_dt  --五级分类日期
,level11_cls_cd  --十一级分类代码
,level11_cls_dt  --十一级分类日期
,advc_flg  --垫款标志
,dubil_status_cd  --借据状态代码
,init_dubil_id  --原始借据编号
,enter_id  --卡号
,oper_dt  --经办日期
,bus_oper_teller_id  --业务经办人编号
,oper_org_id  --经办机构编号
,rgst_teller_id  --登记柜员编号
,rgst_org_id  --登记机构编号
,rgst_dt  --登记日期
,update_teller_id  --更新柜员编号
,update_org_id  --更新机构编号
,modif_dt  --变更日期
,lp_id  --法人编号
,deflt_repay_day  --默认还款日
,ovdue_dt  --逾期日期
,over_int_dt  --欠息日期
,ovdue_int_rat  --逾期利率
,accti_org_id  --核算机构编号
,asset_thd_cls_cd  --资产三分类代码
,guar_way_cd_two  --担保方式代码二
,guar_way_cd_three  --担保方式代码三
,int_rat_adj_way_cd  --利率调整方式代码
,int_rat_adj_ped_cd  --利率调整周期代码
,int_rat_float_range  --利率浮动幅度
,enter_open_acct_org_id  --入账账户开户机构编号
,bad_debt_wrt_off_status_cd  --呆账核销状态代码
,out_acct_org_id  --出账机构编号
,ovdue_int_rat_float_way_cd  --逾期利率浮动方式代码
,ovdue_int_rat_flo_val  --逾期利率浮动值
,move_remark  --迁移备注
,refac_loan_idf_cd  --支小再贷款标识代码
,old_cust_id  --旧客户编号
,old_prod_id  --旧产品编号
,loan_tot_perds  --贷款总期数
,surp_repay_perds  --剩余还款期数
,level10_cls_manu_med_flg  --十级分类人工干预标志
,last_level10_cls_cd  --上一十级分类代码
,last_level10_cls_dt  --上一十级分类日期
,last_level5_cls_cd  --上一五级分类代码
,last_level5_cls_cmplt_dt  --上一五级分类完成日期
,last_term_level5_cls_modif_dt  --上一期五级分类变更日期
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,dubil_id  --借据编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.rela_out_acct_flow_num,chr(13),''),chr(10),'') as rela_out_acct_flow_num --关联出账流水号
,replace(replace(t1.rela_cont_id,chr(13),''),chr(10),'') as rela_cont_id --关联合同编号
,t1.happ_dt as happ_dt --发生日期
,replace(replace(t1.loan_distr_type_cd,chr(13),''),chr(10),'') as loan_distr_type_cd --贷款发放类型代码
,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd --主担保方式代码
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --客户名称
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.dubil_amt as dubil_amt --借据金额
,t1.mon_tenor as mon_tenor --月期限
,t1.day_tenor as day_tenor --日期限
,t1.distr_dt as distr_dt --发放日期
,t1.apot_exp_dt as apot_exp_dt --约定到期日期
,t1.actl_exp_dt as actl_exp_dt --实际到期日期
,replace(replace(t1.int_rat_mode_cd,chr(13),''),chr(10),'') as int_rat_mode_cd --利率模式代码
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd --基准利率类型代码
,t1.base_rat as base_rat --基准利率
,replace(replace(t1.int_rat_float_type_cd,chr(13),''),chr(10),'') as int_rat_float_type_cd --利率浮动类型代码
,t1.exec_year_int_rat as exec_year_int_rat --执行年利率
,t1.margin_ratio as margin_ratio --保证金比例
,t1.margin_amt as margin_amt --保证金金额
,replace(replace(t1.margin_acct_id,chr(13),''),chr(10),'') as margin_acct_id --保证金账户编号
,replace(replace(t1.distr_mode_pay_cd,chr(13),''),chr(10),'') as distr_mode_pay_cd --放款支付方式代码
,replace(replace(t1.distr_acct_id,chr(13),''),chr(10),'') as distr_acct_id --放款账户编号
,replace(replace(t1.distr_acct_name,chr(13),''),chr(10),'') as distr_acct_name --放款账户名称
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd --还款方式代码
,replace(replace(t1.repay_ped,chr(13),''),chr(10),'') as repay_ped --还款周期
,replace(replace(t1.repay_ped_cd,chr(13),''),chr(10),'') as repay_ped_cd --还款周期单位代码
,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id --还款账户编号
,replace(replace(t1.repay_acct_name,chr(13),''),chr(10),'') as repay_acct_name --还款账户名称
,t1.repay_num_bal as repay_num_bal --还款账户可用余额
,t1.repay_num_aval_bal as repay_num_aval_bal --
,t1.curr_bal as curr_bal --当前余额
,t1.nomal_bal as nomal_bal --正常余额
,t1.ovdue_bal as ovdue_bal --逾期本金
,t1.idle_bal as idle_bal --呆滞余额
,t1.bad_debt_bal as bad_debt_bal --呆账余额
,t1.renew_cnt as renew_cnt --展期次数
,t1.in_bs_over_int_bal as in_bs_over_int_bal --表内欠息余额
,t1.off_bs_over_int_bal as off_bs_over_int_bal --表外欠息余额
,t1.ovdue_pnlt_bal as ovdue_pnlt_bal --逾期罚息余额
,t1.comp_int_bal as comp_int_bal --复息余额
,t1.loan_ovdue_days as loan_ovdue_days --贷款逾期天数
,t1.over_int_days as over_int_days --欠息天数
,t1.loan_grace_period as loan_grace_period --贷款宽限期天数
,t1.provi_resv_lmt as provi_resv_lmt --计提准备金额
,t1.pre_loss_amt as pre_loss_amt --预测损失金额
,t1.termnt_dt as termnt_dt --终止日期
,replace(replace(t1.belong_strip_line_cd,chr(13),''),chr(10),'') as belong_strip_line_cd --所属条线代码
,replace(replace(t1.off_bs_flg,chr(13),''),chr(10),'') as off_bs_flg --表外标志
,replace(replace(t1.low_risk_flg,chr(13),''),chr(10),'') as low_risk_flg --低风险标志
,t1.fir_idtfy_non_dt as fir_idtfy_non_dt --首次认定不良日期
,replace(replace(t1.level5_cls_cd,chr(13),''),chr(10),'') as level5_cls_cd --五级分类代码
,t1.level5_cls_dt as level5_cls_dt --五级分类日期
,replace(replace(t1.level11_cls_cd,chr(13),''),chr(10),'') as level11_cls_cd --十一级分类代码
,t1.level11_cls_dt as level11_cls_dt --十一级分类日期
,replace(replace(t1.advc_flg,chr(13),''),chr(10),'') as advc_flg --垫款标志
,replace(replace(t1.dubil_status_cd,chr(13),''),chr(10),'') as dubil_status_cd --借据状态代码
,replace(replace(t1.init_dubil_id,chr(13),''),chr(10),'') as init_dubil_id --原始借据编号
,replace(replace(t1.enter_id,chr(13),''),chr(10),'') as enter_id --卡号
,t1.oper_dt as oper_dt --经办日期
,replace(replace(t1.bus_oper_teller_id,chr(13),''),chr(10),'') as bus_oper_teller_id --业务经办人编号
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id --经办机构编号
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id --登记柜员编号
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id --登记机构编号
,t1.rgst_dt as rgst_dt --登记日期
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id --更新柜员编号
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id --更新机构编号
,t1.modif_dt as modif_dt --变更日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,t1.deflt_repay_day as deflt_repay_day --默认还款日
,t1.ovdue_dt as ovdue_dt --逾期日期
,t1.over_int_dt as over_int_dt --欠息日期
,t1.ovdue_int_rat as ovdue_int_rat --逾期利率
,replace(replace(t1.accti_org_id,chr(13),''),chr(10),'') as accti_org_id --核算机构编号
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd --资产三分类代码
,replace(replace(t1.guar_way_cd_two,chr(13),''),chr(10),'') as guar_way_cd_two --担保方式代码二
,replace(replace(t1.guar_way_cd_three,chr(13),''),chr(10),'') as guar_way_cd_three --担保方式代码三
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd --利率调整方式代码
,replace(replace(t1.int_rat_adj_ped_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_cd --利率调整周期代码
,t1.int_rat_float_range as int_rat_float_range --利率浮动幅度
,replace(replace(t1.enter_open_acct_org_id,chr(13),''),chr(10),'') as enter_open_acct_org_id --入账账户开户机构编号
,replace(replace(t1.bad_debt_wrt_off_status_cd,chr(13),''),chr(10),'') as bad_debt_wrt_off_status_cd --呆账核销状态代码
,replace(replace(t1.out_acct_org_id,chr(13),''),chr(10),'') as out_acct_org_id --出账机构编号
,replace(replace(t1.ovdue_int_rat_float_way_cd,chr(13),''),chr(10),'') as ovdue_int_rat_float_way_cd --逾期利率浮动方式代码
,t1.ovdue_int_rat_flo_val as ovdue_int_rat_flo_val --逾期利率浮动值
,replace(replace(t1.move_remark,chr(13),''),chr(10),'') as move_remark --迁移备注
,replace(replace(t1.refac_loan_idf_cd,chr(13),''),chr(10),'') as refac_loan_idf_cd --支小再贷款标识代码
,replace(replace(t1.old_cust_id,chr(13),''),chr(10),'') as old_cust_id --旧客户编号
,replace(replace(t1.old_prod_id,chr(13),''),chr(10),'') as old_prod_id --旧产品编号
,t1.loan_tot_perds as loan_tot_perds --贷款总期数
,t1.surp_repay_perds as surp_repay_perds --剩余还款期数
,replace(replace(t1.level10_cls_manu_med_flg,chr(13),''),chr(10),'') as level10_cls_manu_med_flg --十级分类人工干预标志
,replace(replace(t1.last_level10_cls_cd,chr(13),''),chr(10),'') as last_level10_cls_cd --上一十级分类代码
,t1.last_level10_cls_dt as last_level10_cls_dt --上一十级分类日期
,replace(replace(t1.last_level5_cls_cd,chr(13),''),chr(10),'') as last_level5_cls_cd --上一五级分类代码
,t1.last_level5_cls_cmplt_dt as last_level5_cls_cmplt_dt --上一五级分类完成日期
,t1.last_term_level5_cls_modif_dt as last_term_level5_cls_modif_dt --上一期五级分类变更日期
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id --借据编号
from ${iml_schema}.agt_loan_dubil_info_h t1    --贷款借据信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_loan_dubil_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
