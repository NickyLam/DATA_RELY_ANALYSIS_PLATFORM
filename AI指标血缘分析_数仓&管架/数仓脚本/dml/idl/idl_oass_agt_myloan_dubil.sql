/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_myloan_dubil
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
alter table ${idl_schema}.oass_agt_myloan_dubil drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_myloan_dubil add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_myloan_dubil (
etl_dt  --ETL处理日期
,dubil_id  --借据编号
,ext_prod_id  --外部产品编号
,loan_status_cd  --贷款状态代码
,loan_usage_cd  --贷款用途代码
,loan_cap_use_position_cd  --贷款资金使用位置代码
,distr_dt  --放款日期
,curr_cd  --币种代码
,distr_amt  --放款金额
,loan_value_dt  --贷款起息日期
,loan_exp_dt  --贷款到期日期
,loan_cont_tenor  --贷款合同期限
,repay_way_cd  --还款方式代码
,grace_period_days  --宽限期天数
,src_int_rat_type_cd  --源利率类型代码
,int_rat_adj_way_cd  --利率调整方式代码
,int_rat_adj_ped_corp_cd  --利率调整周期单位代码
,int_rat_adj_ped_freq  --利率调整周期频率
,loan_actl_day_int_rat  --贷款实际日利率
,pric_repay_freq_cd  --本金还款频率代码
,int_repay_freq_cd  --利息还款频率代码
,guar_type_cd  --担保类型代码
,crdt_appl_id  --授信申请编号
,recvbl_num_type_cd  --收款账号类型代码
,recvbl_acct_name  --收款账户名称
,recvbl_acct_id  --收款账户编号
,recvbl_bank_name  --收款银行名称
,repay_num_type_cd  --还款账号类型代码
,repay_acct_name  --还款账户名称
,repay_acct_id  --还款账户编号
,repay_bank_name  --还款银行名称
,prod_type_cd  --产品类型代码
,acctnt_dt  --会计日期
,cont_status_cd  --合约状态代码
,payoff_dt  --结清日期
,loan_level5_cls_cd  --贷款五级分类代码
,acru_non_acru_flg  --应计非应计标志
,next_repay_dt  --下一还款日期
,unpayoff_perds  --未结清期数
,ovdue_pd_cnt  --逾期期次数
,pric_ovdue_days  --本金逾期天数
,int_ovdue_days  --利息逾期天数
,nomal_pric_bal  --正常本金余额
,ovdue_pric_bal  --逾期本金余额
,loan_dir_indus_cd  --贷款投向行业代码
,cust_id  --客户编号
,cust_mgr_id  --客户经理编号
,nomal_int_bal  --正常利息余额
,ovdue_int_bal  --逾期利息余额
,ovdue_pric_pnlt_bal  --逾期本金罚息余额
,ovdue_int_pnlt_bal  --逾期利息罚息余额
,loan_exec_year_int_rat  --贷款执行年利率
,lpr_int_rat  --LPR利率
,int_rat_float_spread_val  --利率浮动点差值
,int_rat_float_dir_cd  --利率浮动方向代码
,base_rat_type_cd  --基准利率类型代码
,tran_type_cd  --转让类型代码
,asset_thd_cls_cd  --资产三分类代码
,prod_id  --产品编号
,contri_type_cd  --出资类型代码
,contri_ratio  --出资比例
,white_list_cust_flg  --白户标志
,cust_char_cd  --客户性质代码
,farm_flg  --农户标志
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id --借据编号
,replace(replace(t1.ext_prod_id,chr(13),''),chr(10),'') as ext_prod_id --外部产品编号
,replace(replace(t1.loan_status_cd,chr(13),''),chr(10),'') as loan_status_cd --贷款状态代码
,replace(replace(t1.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd --贷款用途代码
,replace(replace(t1.loan_cap_use_position_cd,chr(13),''),chr(10),'') as loan_cap_use_position_cd --贷款资金使用位置代码
,t1.distr_dt as distr_dt --放款日期
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.distr_amt as distr_amt --放款金额
,t1.loan_value_dt as loan_value_dt --贷款起息日期
,t1.loan_exp_dt as loan_exp_dt --贷款到期日期
,t1.loan_cont_tenor as loan_cont_tenor --贷款合同期限
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd --还款方式代码
,t1.grace_period_days as grace_period_days --宽限期天数
,replace(replace(t1.src_int_rat_type_cd,chr(13),''),chr(10),'') as src_int_rat_type_cd --源利率类型代码
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd --利率调整方式代码
,replace(replace(t1.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_corp_cd --利率调整周期单位代码
,replace(replace(t1.int_rat_adj_ped_freq,chr(13),''),chr(10),'') as int_rat_adj_ped_freq --利率调整周期频率
,t1.loan_actl_day_int_rat as loan_actl_day_int_rat --贷款实际日利率
,replace(replace(t1.pric_repay_freq_cd,chr(13),''),chr(10),'') as pric_repay_freq_cd --本金还款频率代码
,replace(replace(t1.int_repay_freq_cd,chr(13),''),chr(10),'') as int_repay_freq_cd --利息还款频率代码
,replace(replace(t1.guar_type_cd,chr(13),''),chr(10),'') as guar_type_cd --担保类型代码
,replace(replace(t1.crdt_appl_id,chr(13),''),chr(10),'') as crdt_appl_id --授信申请编号
,replace(replace(t1.recvbl_num_type_cd,chr(13),''),chr(10),'') as recvbl_num_type_cd --收款账号类型代码
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name --收款账户名称
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id --收款账户编号
,replace(replace(t1.recvbl_bank_name,chr(13),''),chr(10),'') as recvbl_bank_name --收款银行名称
,replace(replace(t1.repay_num_type_cd,chr(13),''),chr(10),'') as repay_num_type_cd --还款账号类型代码
,replace(replace(t1.repay_acct_name,chr(13),''),chr(10),'') as repay_acct_name --还款账户名称
,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id --还款账户编号
,replace(replace(t1.repay_bank_name,chr(13),''),chr(10),'') as repay_bank_name --还款银行名称
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd --产品类型代码
,t1.acctnt_dt as acctnt_dt --会计日期
,replace(replace(t1.cont_status_cd,chr(13),''),chr(10),'') as cont_status_cd --合约状态代码
,t1.payoff_dt as payoff_dt --结清日期
,replace(replace(t1.loan_level5_cls_cd,chr(13),''),chr(10),'') as loan_level5_cls_cd --贷款五级分类代码
,replace(replace(t1.acru_non_acru_flg,chr(13),''),chr(10),'') as acru_non_acru_flg --应计非应计标志
,t1.next_repay_dt as next_repay_dt --下一还款日期
,t1.unpayoff_perds as unpayoff_perds --未结清期数
,t1.ovdue_pd_cnt as ovdue_pd_cnt --逾期期次数
,t1.pric_ovdue_days as pric_ovdue_days --本金逾期天数
,t1.int_ovdue_days as int_ovdue_days --利息逾期天数
,t1.nomal_pric_bal as nomal_pric_bal --正常本金余额
,t1.ovdue_pric_bal as ovdue_pric_bal --逾期本金余额
,replace(replace(t1.loan_dir_indus_cd,chr(13),''),chr(10),'') as loan_dir_indus_cd --贷款投向行业代码
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id --客户经理编号
,t1.nomal_int_bal as nomal_int_bal --正常利息余额
,t1.ovdue_int_bal as ovdue_int_bal --逾期利息余额
,t1.ovdue_pric_pnlt_bal as ovdue_pric_pnlt_bal --逾期本金罚息余额
,t1.ovdue_int_pnlt_bal as ovdue_int_pnlt_bal --逾期利息罚息余额
,t1.loan_exec_year_int_rat as loan_exec_year_int_rat --贷款执行年利率
,t1.lpr_int_rat as lpr_int_rat --LPR利率
,t1.int_rat_float_spread_val as int_rat_float_spread_val --利率浮动点差值
,replace(replace(t1.int_rat_float_dir_cd,chr(13),''),chr(10),'') as int_rat_float_dir_cd --利率浮动方向代码
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd --基准利率类型代码
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd --转让类型代码
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd --资产三分类代码
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.contri_type_cd,chr(13),''),chr(10),'') as contri_type_cd --出资类型代码
,t1.contri_ratio as contri_ratio --出资比例
,replace(replace(t1.white_list_cust_flg,chr(13),''),chr(10),'') as white_list_cust_flg --白户标志
,replace(replace(t1.cust_char_cd,chr(13),''),chr(10),'') as cust_char_cd --客户性质代码
,replace(replace(t1.farm_flg,chr(13),''),chr(10),'') as farm_flg --农户标志
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_myloan_dubil t1    --网商贷借据
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_myloan_dubil',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
