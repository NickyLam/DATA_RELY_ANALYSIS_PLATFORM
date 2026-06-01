/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_bill_acpt_batch
CreateDate: 20221108
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_agt_bill_acpt_batch drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_bill_acpt_batch add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_bill_acpt_batch (
etl_dt  --ETL处理日期
,batch_id  --批次编号
,lp_id  --法人编号
,org_id  --机构编号
,acpt_agt_id  --承兑协议编号
,task_type_cd  --任务类型代码
,bill_med_cd  --票据介质代码
,bill_type_cd  --票据类型代码
,drawer_cust_id  --出票人客户编号
,appl_acpt_amt  --申请承兑金额
,appl_draw_dt  --申请出票日期
,exp_dt  --到期日期
,margin_ratio  --保证金比例
,comm_fee_ratio  --手续费比例
,tran_amt  --交易金额
,pay_bank_bank_no  --付款行行号
,cust_mgr_id  --客户经理编号
,dept_id  --部门编号
,operr_id  --操作员编号
,tran_dt  --交易日期
,bus_logic_check_status_cd  --业务逻辑检查状态代码
,apv_status_cd  --审批状态代码
,check_status_cd  --审核状态代码
,crdt_check_status_cd  --授信检查状态代码
,final_modif_tm  --最后修改时间
,drawer_acct_num  --出票人账号
,drawer_bank_name  --出票人行名称
,actl_dir_indus_name  --实际投向行业名称
,enter_acct_org_id  --入账机构编号
,acpt_fee  --承兑费
,mgmt_fee  --管理费
,agt_exp_dt  --协议到期日期
,acct_amt  --账户金额
,apprved_use_crdt_open_amt  --已批准使用授信敞口金额
,distr_post_acm_use_open_amt  --本次放款后累计使用敞口金额
,cert_no  --证件号码
,onl_bank_batch_id  --网银批量批次编号
,fst_repay_acct_id  --第一还款账户编号
,margin_tenor_type_cd  --保证金期限类型代码
,margin_acct_id  --保证金账户编号
,margin_type_cd  --保证金类型代码
,int_rat_type_cd  --利率类型代码
,margin_int_rat_float_type_cd  --保证金利率浮动类型代码
,margin_int_rat_float_way_cd  --保证金利率浮动方式代码
,margin_flo_val  --保证金浮动值
,rela_party_que_rest_cd  --关联方查询结果代码
,tgls_entry_status_cd  --核算中台记账状态代码
,ncbs_entry_status_cd  --核心记账状态代码
,h_data_flg  --历史数据标志
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id --批次编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id --机构编号
,replace(replace(t1.acpt_agt_id,chr(13),''),chr(10),'') as acpt_agt_id --承兑协议编号
,replace(replace(t1.task_type_cd,chr(13),''),chr(10),'') as task_type_cd --任务类型代码
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd --票据介质代码
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd --票据类型代码
,replace(replace(t1.drawer_cust_id,chr(13),''),chr(10),'') as drawer_cust_id --出票人客户编号
,t1.appl_acpt_amt as appl_acpt_amt --申请承兑金额
,t1.appl_draw_dt as appl_draw_dt --申请出票日期
,t1.exp_dt as exp_dt --到期日期
,t1.margin_ratio as margin_ratio --保证金比例
,t1.comm_fee_ratio as comm_fee_ratio --手续费比例
,t1.tran_amt as tran_amt --交易金额
,replace(replace(t1.pay_bank_bank_no,chr(13),''),chr(10),'') as pay_bank_bank_no --付款行行号
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id --客户经理编号
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id --部门编号
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id --操作员编号
,t1.tran_dt as tran_dt --交易日期
,replace(replace(t1.bus_logic_check_status_cd,chr(13),''),chr(10),'') as bus_logic_check_status_cd --业务逻辑检查状态代码
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd --审批状态代码
,replace(replace(t1.check_status_cd,chr(13),''),chr(10),'') as check_status_cd --审核状态代码
,replace(replace(t1.crdt_check_status_cd,chr(13),''),chr(10),'') as crdt_check_status_cd --授信检查状态代码
,t1.final_modif_tm as final_modif_tm --最后修改时间
,replace(replace(t1.drawer_acct_num,chr(13),''),chr(10),'') as drawer_acct_num --出票人账号
,replace(replace(t1.drawer_bank_name,chr(13),''),chr(10),'') as drawer_bank_name --出票人行名称
,replace(replace(t1.actl_dir_indus_name,chr(13),''),chr(10),'') as actl_dir_indus_name --实际投向行业名称
,replace(replace(t1.enter_acct_org_id,chr(13),''),chr(10),'') as enter_acct_org_id --入账机构编号
,t1.acpt_fee as acpt_fee --承兑费
,t1.mgmt_fee as mgmt_fee --管理费
,t1.agt_exp_dt as agt_exp_dt --协议到期日期
,t1.acct_amt as acct_amt --账户金额
,t1.apprved_use_crdt_open_amt as apprved_use_crdt_open_amt --已批准使用授信敞口金额
,t1.distr_post_acm_use_open_amt as distr_post_acm_use_open_amt --本次放款后累计使用敞口金额
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no --证件号码
,replace(replace(t1.onl_bank_batch_id,chr(13),''),chr(10),'') as onl_bank_batch_id --网银批量批次编号
,replace(replace(t1.fst_repay_acct_id,chr(13),''),chr(10),'') as fst_repay_acct_id --第一还款账户编号
,replace(replace(t1.margin_tenor_type_cd,chr(13),''),chr(10),'') as margin_tenor_type_cd --保证金期限类型代码
,replace(replace(t1.margin_acct_id,chr(13),''),chr(10),'') as margin_acct_id --保证金账户编号
,replace(replace(t1.margin_type_cd,chr(13),''),chr(10),'') as margin_type_cd --保证金类型代码
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd --利率类型代码
,replace(replace(t1.margin_int_rat_float_type_cd,chr(13),''),chr(10),'') as margin_int_rat_float_type_cd --保证金利率浮动类型代码
,replace(replace(t1.margin_int_rat_float_way_cd,chr(13),''),chr(10),'') as margin_int_rat_float_way_cd --保证金利率浮动方式代码
,t1.margin_flo_val as margin_flo_val --保证金浮动值
,replace(replace(t1.rela_party_que_rest_cd,chr(13),''),chr(10),'') as rela_party_que_rest_cd --关联方查询结果代码
,replace(replace(t1.tgls_entry_status_cd,chr(13),''),chr(10),'') as tgls_entry_status_cd --核算中台记账状态代码
,replace(replace(t1.ncbs_entry_status_cd,chr(13),''),chr(10),'') as ncbs_entry_status_cd --核心记账状态代码
,replace(replace(t1.h_data_flg,chr(13),''),chr(10),'') as h_data_flg --历史数据标志
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
from ${iml_schema}.agt_bill_acpt_batch t1    --票据承兑批次
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_bill_acpt_batch',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
