/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_loan_adv_repay_appl_h
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
alter table ${idl_schema}.oass_agt_loan_adv_repay_appl_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_loan_adv_repay_appl_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_loan_adv_repay_appl_h (
etl_dt  --数据日期
,appl_flow_num  --申请流水号
,tran_type_cd  --交易类型代码
,rela_obj_flow_num  --关联对象流水号
,rela_obj_type_name  --关联对象类型名称
,rela_dubil_id  --关联借据编号
,appl_status_cd  --申请状态代码
,cust_id  --客户编号
,cust_name  --客户名称
,prod_id  --产品编号
,curr_cd  --币种代码
,acct_flg  --账户标志
,acct_type_cd  --账户类型代码
,repay_acct_name  --还款账户名称
,repay_acct_id  --还款账户编号
,actl_recv_pric  --实收本金
,actl_recv_int  --实收利息
,actl_recv_pnlt  --实收罚息
,actl_recv_comp_int  --实收复息
,actl_recv_fee  --实收费用
,repay_tot_amt  --还款总金额
,adv_repay_way_cd  --提前还款方式代码
,adv_repay_int_accr_way_cd  --提前还款计息方式代码
,adv_repay_int_accr_base_cd  --提前还款计息基础代码
,adv_repay_amt_type_cd  --提前还款金额类型代码
,adv_repay_amt  --提前还款金额
,adv_rtn_pric  --提前归还本金
,adv_rtn_int  --提前归还利息
,adv_rtn_fee  --提前归还费用
,deduct_seq_cd  --扣款顺序代码
,onl_pay_flg  --在线支付标志
,core_tran_flow_num  --核心交易流水号
,core_tran_status_cd  --核心交易状态代码
,appl_dt  --申请日期
,core_tran_dt  --核心交易日期
,rgst_teller_id  --登记柜员编号
,rgst_org_id  --登记机构编号
,rgst_dt  --登记日期
,update_teller_id  --更新柜员编号
,update_org_id  --更新机构编号
,modif_dt  --变更日期
,belong_strip_line_cd  --所属条线代码
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,appl_id  --申请编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num --申请流水号
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd --交易类型代码
,replace(replace(t1.rela_obj_flow_num,chr(13),''),chr(10),'') as rela_obj_flow_num --关联对象流水号
,replace(replace(t1.rela_obj_type_name,chr(13),''),chr(10),'') as rela_obj_type_name --关联对象类型名称
,replace(replace(t1.rela_dubil_id,chr(13),''),chr(10),'') as rela_dubil_id --关联借据编号
,replace(replace(t1.appl_status_cd,chr(13),''),chr(10),'') as appl_status_cd --申请状态代码
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --客户名称
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,replace(replace(t1.acct_flg,chr(13),''),chr(10),'') as acct_flg --账户标志
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd --账户类型代码
,replace(replace(t1.repay_acct_name,chr(13),''),chr(10),'') as repay_acct_name --还款账户名称
,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id --还款账户编号
,t1.actl_recv_pric as actl_recv_pric --实收本金
,t1.actl_recv_int as actl_recv_int --实收利息
,t1.actl_recv_pnlt as actl_recv_pnlt --实收罚息
,t1.actl_recv_comp_int as actl_recv_comp_int --实收复息
,t1.actl_recv_fee as actl_recv_fee --实收费用
,t1.repay_tot_amt as repay_tot_amt --还款总金额
,replace(replace(t1.adv_repay_way_cd,chr(13),''),chr(10),'') as adv_repay_way_cd --提前还款方式代码
,replace(replace(t1.adv_repay_int_accr_way_cd,chr(13),''),chr(10),'') as adv_repay_int_accr_way_cd --提前还款计息方式代码
,replace(replace(t1.adv_repay_int_accr_base_cd,chr(13),''),chr(10),'') as adv_repay_int_accr_base_cd --提前还款计息基础代码
,replace(replace(t1.adv_repay_amt_type_cd,chr(13),''),chr(10),'') as adv_repay_amt_type_cd --提前还款金额类型代码
,t1.adv_repay_amt as adv_repay_amt --提前还款金额
,t1.adv_rtn_pric as adv_rtn_pric --提前归还本金
,t1.adv_rtn_int as adv_rtn_int --提前归还利息
,replace(replace(t1.adv_rtn_fee,chr(13),''),chr(10),'') as adv_rtn_fee --提前归还费用
,replace(replace(t1.deduct_seq_cd,chr(13),''),chr(10),'') as deduct_seq_cd --扣款顺序代码
,replace(replace(t1.onl_pay_flg,chr(13),''),chr(10),'') as onl_pay_flg --在线支付标志
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num --核心交易流水号
,replace(replace(t1.core_tran_status_cd,chr(13),''),chr(10),'') as core_tran_status_cd --核心交易状态代码
,t1.appl_dt as appl_dt --申请日期
,t1.core_tran_dt as core_tran_dt --核心交易日期
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id --登记柜员编号
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id --登记机构编号
,t1.rgst_dt as rgst_dt --登记日期
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id --更新柜员编号
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id --更新机构编号
,t1.modif_dt as modif_dt --变更日期
,replace(replace(t1.belong_strip_line_cd,chr(13),''),chr(10),'') as belong_strip_line_cd --所属条线代码
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id --申请编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_loan_adv_repay_appl_h t1    --贷款提前还款申请历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_loan_adv_repay_appl_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
