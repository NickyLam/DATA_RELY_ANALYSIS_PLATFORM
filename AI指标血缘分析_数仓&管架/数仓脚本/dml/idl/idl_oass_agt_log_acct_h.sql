/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_log_acct_h
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
alter table ${idl_schema}.oass_agt_log_acct_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_log_acct_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_log_acct_h (
etl_dt  --数据日期
,acct_id  --账户编号
,log_id  --保函编号
,prod_id  --产品编号
,log_cont_id  --保函合同编号
,dubil_id  --借据编号
,open_acct_org_id  --开户机构编号
,tran_org_id  --交易机构编号
,guar_org_id  --担保机构编号
,rev_guar_org_id  --反担机构编号
,appl_cust_id  --申请者客户编号
,benefc_acct_id  --受益人账户编号
,benefc_name  --受益人名称
,cust_mgr_id  --客户经理编号
,curr_cd  --币种代码
,log_amt  --保函金额
,pymc_cust_acct_num  --备款客户账号
,pymc_acct_sub_acct_num  --备款账户子账号
,pymc_acct_curr_cd  --备款账户币种代码
,pymc_acct_prod_id  --备款账户产品编号
,pbc_clear_acct_num  --人行清算账号
,stl_acct_sub_acct_num  --结算账户子账号
,stl_acct_curr_cd  --结算账户币种代码
,stl_acct_prod_id  --结算账户产品编号
,advc_amt  --垫款金额
,advc_loan_acct_num  --垫款贷款账号
,advc_fix_pnlt_int_rat  --垫款固定罚息利率
,begin_dt  --起始日期
,exp_dt  --到期日期
,log_status_cd  --保函状态代码
,remark  --备注
,cont_curr_cd  --合同币种代码
,log_init_froz_amt  --保函原始冻结金额
,benefc_cert_type_cd  --受益人证件类型代码
,benefc_cert_no  --受益人证件号码
,new_log_termnt_dt  --新保函终止日期
,mtg_cont_id  --抵押合同编号
,benefc_resdnt_addr  --受益人居住地址
,col_book_val  --押品账面价值
,surp_compens_amt  --剩余赔付金额
,log_compens_status_cd  --保函赔付状态代码
,loan_sign_cont_amt  --贷款签约合同金额
,cust_id  --客户编号
,auth_teller_id  --授权柜员编号
,check_teller_id  --复核柜员编号
,tran_teller_id  --交易柜员编号
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id --账户编号
,replace(replace(t1.log_id,chr(13),''),chr(10),'') as log_id --保函编号
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.log_cont_id,chr(13),''),chr(10),'') as log_cont_id --保函合同编号
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id --借据编号
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id --开户机构编号
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id --交易机构编号
,replace(replace(t1.guar_org_id,chr(13),''),chr(10),'') as guar_org_id --担保机构编号
,replace(replace(t1.rev_guar_org_id,chr(13),''),chr(10),'') as rev_guar_org_id --反担机构编号
,replace(replace(t1.appl_cust_id,chr(13),''),chr(10),'') as appl_cust_id --申请者客户编号
,replace(replace(t1.benefc_acct_id,chr(13),''),chr(10),'') as benefc_acct_id --受益人账户编号
,replace(replace(t1.benefc_name,chr(13),''),chr(10),'') as benefc_name --受益人名称
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id --客户经理编号
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.log_amt as log_amt --保函金额
,replace(replace(t1.pymc_cust_acct_num,chr(13),''),chr(10),'') as pymc_cust_acct_num --备款客户账号
,replace(replace(t1.pymc_acct_sub_acct_num,chr(13),''),chr(10),'') as pymc_acct_sub_acct_num --备款账户子账号
,replace(replace(t1.pymc_acct_curr_cd,chr(13),''),chr(10),'') as pymc_acct_curr_cd --备款账户币种代码
,replace(replace(t1.pymc_acct_prod_id,chr(13),''),chr(10),'') as pymc_acct_prod_id --备款账户产品编号
,replace(replace(t1.pbc_clear_acct_num,chr(13),''),chr(10),'') as pbc_clear_acct_num --人行清算账号
,replace(replace(t1.stl_acct_sub_acct_num,chr(13),''),chr(10),'') as stl_acct_sub_acct_num --结算账户子账号
,replace(replace(t1.stl_acct_curr_cd,chr(13),''),chr(10),'') as stl_acct_curr_cd --结算账户币种代码
,replace(replace(t1.stl_acct_prod_id,chr(13),''),chr(10),'') as stl_acct_prod_id --结算账户产品编号
,t1.advc_amt as advc_amt --垫款金额
,replace(replace(t1.advc_loan_acct_num,chr(13),''),chr(10),'') as advc_loan_acct_num --垫款贷款账号
,t1.advc_fix_pnlt_int_rat as advc_fix_pnlt_int_rat --垫款固定罚息利率
,t1.begin_dt as begin_dt --起始日期
,t1.exp_dt as exp_dt --到期日期
,replace(replace(t1.log_status_cd,chr(13),''),chr(10),'') as log_status_cd --保函状态代码
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,replace(replace(t1.cont_curr_cd,chr(13),''),chr(10),'') as cont_curr_cd --合同币种代码
,t1.log_init_froz_amt as log_init_froz_amt --保函原始冻结金额
,replace(replace(t1.benefc_cert_type_cd,chr(13),''),chr(10),'') as benefc_cert_type_cd --受益人证件类型代码
,replace(replace(t1.benefc_cert_no,chr(13),''),chr(10),'') as benefc_cert_no --受益人证件号码
,t1.new_log_termnt_dt as new_log_termnt_dt --新保函终止日期
,replace(replace(t1.mtg_cont_id,chr(13),''),chr(10),'') as mtg_cont_id --抵押合同编号
,replace(replace(t1.benefc_resdnt_addr,chr(13),''),chr(10),'') as benefc_resdnt_addr --受益人居住地址
,t1.col_book_val as col_book_val --押品账面价值
,t1.surp_compens_amt as surp_compens_amt --剩余赔付金额
,replace(replace(t1.log_compens_status_cd,chr(13),''),chr(10),'') as log_compens_status_cd --保函赔付状态代码
,t1.loan_sign_cont_amt as loan_sign_cont_amt --贷款签约合同金额
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id --授权柜员编号
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id --复核柜员编号
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id --交易柜员编号
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_log_acct_h t1    --保函账户历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_log_acct_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
