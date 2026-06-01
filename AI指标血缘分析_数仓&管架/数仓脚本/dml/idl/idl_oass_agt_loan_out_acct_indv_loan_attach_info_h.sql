/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_loan_out_acct_indv_loan_attach_info_h
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
alter table ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h (
etl_dt  --数据日期
,lp_id  --法人编号
,appl_distr_amt  --申请放款金额
,risk_mgmt_rest_cd  --风控结果代码
,repay_card_type_cd  --还款卡类型代码
,recver_open_bank_name  --收款人开户行名称
,loan_distr_dt  --贷款发放日期
,loan_perds  --贷款期数
,loan_actl_distr_dt  --贷款实际发放日期
,deflt_repay_day  --默认还款日
,loan_termnt_dt  --贷款终止日期
,input_stamp_tax_flg  --录入印花税标志
,stamp_tax_tax_acct_id  --印花税扣税账户编号
,stamp_tax_acct_name  --印花税扣税账号名称
,stamp_tax_amt  --印花税金额
,open_acct_bind_mobile_no  --开户绑定手机号码
,out_acct_impt_cond_descb  --出账落实条件描述
,entr_pay_cfm_status_cd  --受托支付确认状态代码
,entr_pay_cfm_tm  --受托支付确认时间
,self_pay_amt  --自主支付金额
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,appl_id  --申请编号
,out_acct_flow_num  --出账流水号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,t1.appl_distr_amt as appl_distr_amt --申请放款金额
,replace(replace(t1.risk_mgmt_rest_cd,chr(13),''),chr(10),'') as risk_mgmt_rest_cd --风控结果代码
,replace(replace(t1.repay_card_type_cd,chr(13),''),chr(10),'') as repay_card_type_cd --还款卡类型代码
,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name --收款人开户行名称
,t1.loan_distr_dt as loan_distr_dt --贷款发放日期
,t1.loan_perds as loan_perds --贷款期数
,t1.loan_actl_distr_dt as loan_actl_distr_dt --贷款实际发放日期
,replace(replace(t1.deflt_repay_day,chr(13),''),chr(10),'') as deflt_repay_day --默认还款日
,t1.loan_termnt_dt as loan_termnt_dt --贷款终止日期
,replace(replace(t1.input_stamp_tax_flg,chr(13),''),chr(10),'') as input_stamp_tax_flg --录入印花税标志
,replace(replace(t1.stamp_tax_tax_acct_id,chr(13),''),chr(10),'') as stamp_tax_tax_acct_id --印花税扣税账户编号
,replace(replace(t1.stamp_tax_acct_name,chr(13),''),chr(10),'') as stamp_tax_acct_name --印花税扣税账号名称
,t1.stamp_tax_amt as stamp_tax_amt --印花税金额
,replace(replace(t1.open_acct_bind_mobile_no,chr(13),''),chr(10),'') as open_acct_bind_mobile_no --开户绑定手机号码
,replace(replace(t1.out_acct_impt_cond_descb,chr(13),''),chr(10),'') as out_acct_impt_cond_descb --出账落实条件描述
,replace(replace(t1.entr_pay_cfm_status_cd,chr(13),''),chr(10),'') as entr_pay_cfm_status_cd --受托支付确认状态代码
,t1.entr_pay_cfm_tm as entr_pay_cfm_tm --受托支付确认时间
,t1.self_pay_amt as self_pay_amt --自主支付金额
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id --申请编号
,replace(replace(t1.out_acct_flow_num,chr(13),''),chr(10),'') as out_acct_flow_num --出账流水号
from ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h t1    --贷款出账个人贷款附属信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_loan_out_acct_indv_loan_attach_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
