/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_log_acct_h_ncbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_log_acct_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_log_acct_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_log_acct_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_log_acct_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_log_acct_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_log_acct_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_log_acct_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,log_id -- 保函编号
    ,prod_id -- 产品编号
    ,log_cont_id -- 保函合同编号
    ,dubil_id -- 借据编号
    ,open_acct_org_id -- 开户机构编号
    ,tran_org_id -- 交易机构编号
    ,guar_org_id -- 担保机构编号
    ,rev_guar_org_id -- 反担机构编号
    ,appl_cust_id -- 申请者客户编号
    ,benefc_acct_id -- 受益人账户编号
    ,benefc_name -- 受益人名称
    ,cust_mgr_id -- 客户经理编号
    ,curr_cd -- 币种代码
    ,log_amt -- 保函金额
    ,pymc_cust_acct_num -- 备款客户账号
    ,pymc_acct_sub_acct_num -- 备款账户子账号
    ,pymc_acct_curr_cd -- 备款账户币种代码
    ,pymc_acct_prod_id -- 备款账户产品编号
    ,pbc_clear_acct_num -- 人行清算账号
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_prod_id -- 结算账户产品编号
    ,advc_amt -- 垫款金额
    ,advc_loan_acct_num -- 垫款贷款账号
    ,advc_fix_pnlt_int_rat -- 垫款固定罚息利率
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,log_status_cd -- 保函状态代码
    ,remark -- 备注
    ,cont_curr_cd -- 合同币种代码
    ,log_init_froz_amt -- 保函原始冻结金额
    ,benefc_cert_type_cd -- 受益人证件类型代码
    ,benefc_cert_no -- 受益人证件号码
    ,new_log_termnt_dt -- 新保函终止日期
    ,mtg_cont_id -- 抵押合同编号
    ,benefc_resdnt_addr -- 受益人居住地址
    ,col_book_val -- 押品账面价值
    ,surp_compens_amt -- 剩余赔付金额
    ,log_compens_status_cd -- 保函赔付状态代码
    ,loan_sign_cont_amt -- 贷款签约合同金额
    ,cust_id -- 客户编号
    ,auth_teller_id -- 授权柜员编号
    ,check_teller_id -- 复核柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,ghb_benefc_acct_num_flg -- 本行受益人账号标志
    ,final_modif_dt -- 最后修改日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_log_acct_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_log_acct_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_log_acct_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_log_acct_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_log_acct_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cl_lg_register-1
insert into ${iml_schema}.agt_log_acct_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,log_id -- 保函编号
    ,prod_id -- 产品编号
    ,log_cont_id -- 保函合同编号
    ,dubil_id -- 借据编号
    ,open_acct_org_id -- 开户机构编号
    ,tran_org_id -- 交易机构编号
    ,guar_org_id -- 担保机构编号
    ,rev_guar_org_id -- 反担机构编号
    ,appl_cust_id -- 申请者客户编号
    ,benefc_acct_id -- 受益人账户编号
    ,benefc_name -- 受益人名称
    ,cust_mgr_id -- 客户经理编号
    ,curr_cd -- 币种代码
    ,log_amt -- 保函金额
    ,pymc_cust_acct_num -- 备款客户账号
    ,pymc_acct_sub_acct_num -- 备款账户子账号
    ,pymc_acct_curr_cd -- 备款账户币种代码
    ,pymc_acct_prod_id -- 备款账户产品编号
    ,pbc_clear_acct_num -- 人行清算账号
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_prod_id -- 结算账户产品编号
    ,advc_amt -- 垫款金额
    ,advc_loan_acct_num -- 垫款贷款账号
    ,advc_fix_pnlt_int_rat -- 垫款固定罚息利率
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,log_status_cd -- 保函状态代码
    ,remark -- 备注
    ,cont_curr_cd -- 合同币种代码
    ,log_init_froz_amt -- 保函原始冻结金额
    ,benefc_cert_type_cd -- 受益人证件类型代码
    ,benefc_cert_no -- 受益人证件号码
    ,new_log_termnt_dt -- 新保函终止日期
    ,mtg_cont_id -- 抵押合同编号
    ,benefc_resdnt_addr -- 受益人居住地址
    ,col_book_val -- 押品账面价值
    ,surp_compens_amt -- 剩余赔付金额
    ,log_compens_status_cd -- 保函赔付状态代码
    ,loan_sign_cont_amt -- 贷款签约合同金额
    ,cust_id -- 客户编号
    ,auth_teller_id -- 授权柜员编号
    ,check_teller_id -- 复核柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,ghb_benefc_acct_num_flg -- 本行受益人账号标志
    ,final_modif_dt -- 最后修改日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300001'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.LG_NO -- 保函编号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.CONTRACT_NO -- 保函合同编号
    ,P1.CMISLOAN_NO -- 借据编号
    ,P1.OPEN_BRANCH -- 开户机构编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.LG_BRANCH -- 担保机构编号
    ,P1.COUNTERPARTY_BRANCH -- 反担机构编号
    ,P1.APPLY_CLIENT_NO -- 申请者客户编号
    ,P1.BENEFICIARY_ACCT_NO -- 受益人账户编号
    ,P1.BENEFICIARY_NAME -- 受益人名称
    ,P1.ACCT_EXEC -- 客户经理编号
    ,nvl(trim(P1.CCY),'-') -- 币种代码
    ,P1.LG_AMT -- 保函金额
    ,P1.BACK_ACCT_NO -- 备款客户账号
    ,P1.BACK_ACCT_SEQ_NO -- 备款账户子账号
    ,nvl(trim(P1.BACK_ACCT_CCY),'-') -- 备款账户币种代码
    ,P1.BACK_PROD_TYPE -- 备款账户产品编号
    ,P1.SETTLE_ACCT_NO -- 人行清算账号
    ,P1.SETTLE_ACCT_SEQ_NO -- 结算账户子账号
    ,nvl(trim(P1.SETTLE_ACCT_CCY),'-') -- 结算账户币种代码
    ,P1.SETTLE_PROD_TYPE -- 结算账户产品编号
    ,P1.ADVANCED_AMT -- 垫款金额
    ,P1.ADVANCED_ACCT_NO -- 垫款贷款账号
    ,P1.PRI_PLTY_ABS -- 垫款固定罚息利率
    ,P1.LG_START_DATE -- 起始日期
    ,P1.LG_END_DATE -- 到期日期
    ,P1.LG_STATUS -- 保函状态代码
    ,P1.REMARK -- 备注
    ,nvl(trim(P1.CONTRACT_CCY),'-') -- 合同币种代码
    ,P1.ORG_RESTRAINT_AMT -- 保函原始冻结金额
    ,nvl(trim(P1.BENEFICIARY_DOCUMENT_TYPE),'0000') -- 受益人证件类型代码
    ,P1.BENEFICIARY_DOCUMENT_ID -- 受益人证件号码
    ,P1.NEW_LG_END_DATE -- 新保函终止日期
    ,P1.MORTGAGE_CONTRACT_NO -- 抵押合同编号
    ,P1.BENEFICIARY_ADDRESS -- 受益人居住地址
    ,P1.COLLAT_VALUE -- 押品账面价值
    ,P1.LG_COMPENSATE_BALANCE -- 剩余赔付金额
    ,P1.COMPENSATE_STATUS -- 保函赔付状态代码
    ,P1.ORIG_LOAN_AMT -- 贷款签约合同金额
    ,P1.CLIENT_NO -- 客户编号
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,P1.APPR_USER_ID -- 复核柜员编号
    ,P1.USER_ID -- 交易柜员编号
    ,decode(P1.BENEFICIARY_IS_INNER,'Y','1','N','0',' ','-',P1.BENEFICIARY_IS_INNER) -- 本行受益人账号标志
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_lg_register' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_lg_register p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_log_acct_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,acct_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_log_acct_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,log_id -- 保函编号
    ,prod_id -- 产品编号
    ,log_cont_id -- 保函合同编号
    ,dubil_id -- 借据编号
    ,open_acct_org_id -- 开户机构编号
    ,tran_org_id -- 交易机构编号
    ,guar_org_id -- 担保机构编号
    ,rev_guar_org_id -- 反担机构编号
    ,appl_cust_id -- 申请者客户编号
    ,benefc_acct_id -- 受益人账户编号
    ,benefc_name -- 受益人名称
    ,cust_mgr_id -- 客户经理编号
    ,curr_cd -- 币种代码
    ,log_amt -- 保函金额
    ,pymc_cust_acct_num -- 备款客户账号
    ,pymc_acct_sub_acct_num -- 备款账户子账号
    ,pymc_acct_curr_cd -- 备款账户币种代码
    ,pymc_acct_prod_id -- 备款账户产品编号
    ,pbc_clear_acct_num -- 人行清算账号
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_prod_id -- 结算账户产品编号
    ,advc_amt -- 垫款金额
    ,advc_loan_acct_num -- 垫款贷款账号
    ,advc_fix_pnlt_int_rat -- 垫款固定罚息利率
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,log_status_cd -- 保函状态代码
    ,remark -- 备注
    ,cont_curr_cd -- 合同币种代码
    ,log_init_froz_amt -- 保函原始冻结金额
    ,benefc_cert_type_cd -- 受益人证件类型代码
    ,benefc_cert_no -- 受益人证件号码
    ,new_log_termnt_dt -- 新保函终止日期
    ,mtg_cont_id -- 抵押合同编号
    ,benefc_resdnt_addr -- 受益人居住地址
    ,col_book_val -- 押品账面价值
    ,surp_compens_amt -- 剩余赔付金额
    ,log_compens_status_cd -- 保函赔付状态代码
    ,loan_sign_cont_amt -- 贷款签约合同金额
    ,cust_id -- 客户编号
    ,auth_teller_id -- 授权柜员编号
    ,check_teller_id -- 复核柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,ghb_benefc_acct_num_flg -- 本行受益人账号标志
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_log_acct_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,log_id -- 保函编号
    ,prod_id -- 产品编号
    ,log_cont_id -- 保函合同编号
    ,dubil_id -- 借据编号
    ,open_acct_org_id -- 开户机构编号
    ,tran_org_id -- 交易机构编号
    ,guar_org_id -- 担保机构编号
    ,rev_guar_org_id -- 反担机构编号
    ,appl_cust_id -- 申请者客户编号
    ,benefc_acct_id -- 受益人账户编号
    ,benefc_name -- 受益人名称
    ,cust_mgr_id -- 客户经理编号
    ,curr_cd -- 币种代码
    ,log_amt -- 保函金额
    ,pymc_cust_acct_num -- 备款客户账号
    ,pymc_acct_sub_acct_num -- 备款账户子账号
    ,pymc_acct_curr_cd -- 备款账户币种代码
    ,pymc_acct_prod_id -- 备款账户产品编号
    ,pbc_clear_acct_num -- 人行清算账号
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_prod_id -- 结算账户产品编号
    ,advc_amt -- 垫款金额
    ,advc_loan_acct_num -- 垫款贷款账号
    ,advc_fix_pnlt_int_rat -- 垫款固定罚息利率
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,log_status_cd -- 保函状态代码
    ,remark -- 备注
    ,cont_curr_cd -- 合同币种代码
    ,log_init_froz_amt -- 保函原始冻结金额
    ,benefc_cert_type_cd -- 受益人证件类型代码
    ,benefc_cert_no -- 受益人证件号码
    ,new_log_termnt_dt -- 新保函终止日期
    ,mtg_cont_id -- 抵押合同编号
    ,benefc_resdnt_addr -- 受益人居住地址
    ,col_book_val -- 押品账面价值
    ,surp_compens_amt -- 剩余赔付金额
    ,log_compens_status_cd -- 保函赔付状态代码
    ,loan_sign_cont_amt -- 贷款签约合同金额
    ,cust_id -- 客户编号
    ,auth_teller_id -- 授权柜员编号
    ,check_teller_id -- 复核柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,ghb_benefc_acct_num_flg -- 本行受益人账号标志
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.log_id, o.log_id) as log_id -- 保函编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.log_cont_id, o.log_cont_id) as log_cont_id -- 保函合同编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.guar_org_id, o.guar_org_id) as guar_org_id -- 担保机构编号
    ,nvl(n.rev_guar_org_id, o.rev_guar_org_id) as rev_guar_org_id -- 反担机构编号
    ,nvl(n.appl_cust_id, o.appl_cust_id) as appl_cust_id -- 申请者客户编号
    ,nvl(n.benefc_acct_id, o.benefc_acct_id) as benefc_acct_id -- 受益人账户编号
    ,nvl(n.benefc_name, o.benefc_name) as benefc_name -- 受益人名称
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.log_amt, o.log_amt) as log_amt -- 保函金额
    ,nvl(n.pymc_cust_acct_num, o.pymc_cust_acct_num) as pymc_cust_acct_num -- 备款客户账号
    ,nvl(n.pymc_acct_sub_acct_num, o.pymc_acct_sub_acct_num) as pymc_acct_sub_acct_num -- 备款账户子账号
    ,nvl(n.pymc_acct_curr_cd, o.pymc_acct_curr_cd) as pymc_acct_curr_cd -- 备款账户币种代码
    ,nvl(n.pymc_acct_prod_id, o.pymc_acct_prod_id) as pymc_acct_prod_id -- 备款账户产品编号
    ,nvl(n.pbc_clear_acct_num, o.pbc_clear_acct_num) as pbc_clear_acct_num -- 人行清算账号
    ,nvl(n.stl_acct_sub_acct_num, o.stl_acct_sub_acct_num) as stl_acct_sub_acct_num -- 结算账户子账号
    ,nvl(n.stl_acct_curr_cd, o.stl_acct_curr_cd) as stl_acct_curr_cd -- 结算账户币种代码
    ,nvl(n.stl_acct_prod_id, o.stl_acct_prod_id) as stl_acct_prod_id -- 结算账户产品编号
    ,nvl(n.advc_amt, o.advc_amt) as advc_amt -- 垫款金额
    ,nvl(n.advc_loan_acct_num, o.advc_loan_acct_num) as advc_loan_acct_num -- 垫款贷款账号
    ,nvl(n.advc_fix_pnlt_int_rat, o.advc_fix_pnlt_int_rat) as advc_fix_pnlt_int_rat -- 垫款固定罚息利率
    ,nvl(n.begin_dt, o.begin_dt) as begin_dt -- 起始日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.log_status_cd, o.log_status_cd) as log_status_cd -- 保函状态代码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.cont_curr_cd, o.cont_curr_cd) as cont_curr_cd -- 合同币种代码
    ,nvl(n.log_init_froz_amt, o.log_init_froz_amt) as log_init_froz_amt -- 保函原始冻结金额
    ,nvl(n.benefc_cert_type_cd, o.benefc_cert_type_cd) as benefc_cert_type_cd -- 受益人证件类型代码
    ,nvl(n.benefc_cert_no, o.benefc_cert_no) as benefc_cert_no -- 受益人证件号码
    ,nvl(n.new_log_termnt_dt, o.new_log_termnt_dt) as new_log_termnt_dt -- 新保函终止日期
    ,nvl(n.mtg_cont_id, o.mtg_cont_id) as mtg_cont_id -- 抵押合同编号
    ,nvl(n.benefc_resdnt_addr, o.benefc_resdnt_addr) as benefc_resdnt_addr -- 受益人居住地址
    ,nvl(n.col_book_val, o.col_book_val) as col_book_val -- 押品账面价值
    ,nvl(n.surp_compens_amt, o.surp_compens_amt) as surp_compens_amt -- 剩余赔付金额
    ,nvl(n.log_compens_status_cd, o.log_compens_status_cd) as log_compens_status_cd -- 保函赔付状态代码
    ,nvl(n.loan_sign_cont_amt, o.loan_sign_cont_amt) as loan_sign_cont_amt -- 贷款签约合同金额
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,nvl(n.check_teller_id, o.check_teller_id) as check_teller_id -- 复核柜员编号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.ghb_benefc_acct_num_flg, o.ghb_benefc_acct_num_flg) as ghb_benefc_acct_num_flg -- 本行受益人账号标志
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_log_acct_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_log_acct_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.acct_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.acct_id is null
    )
    or (
        o.log_id <> n.log_id
        or o.prod_id <> n.prod_id
        or o.log_cont_id <> n.log_cont_id
        or o.dubil_id <> n.dubil_id
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.tran_org_id <> n.tran_org_id
        or o.guar_org_id <> n.guar_org_id
        or o.rev_guar_org_id <> n.rev_guar_org_id
        or o.appl_cust_id <> n.appl_cust_id
        or o.benefc_acct_id <> n.benefc_acct_id
        or o.benefc_name <> n.benefc_name
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.curr_cd <> n.curr_cd
        or o.log_amt <> n.log_amt
        or o.pymc_cust_acct_num <> n.pymc_cust_acct_num
        or o.pymc_acct_sub_acct_num <> n.pymc_acct_sub_acct_num
        or o.pymc_acct_curr_cd <> n.pymc_acct_curr_cd
        or o.pymc_acct_prod_id <> n.pymc_acct_prod_id
        or o.pbc_clear_acct_num <> n.pbc_clear_acct_num
        or o.stl_acct_sub_acct_num <> n.stl_acct_sub_acct_num
        or o.stl_acct_curr_cd <> n.stl_acct_curr_cd
        or o.stl_acct_prod_id <> n.stl_acct_prod_id
        or o.advc_amt <> n.advc_amt
        or o.advc_loan_acct_num <> n.advc_loan_acct_num
        or o.advc_fix_pnlt_int_rat <> n.advc_fix_pnlt_int_rat
        or o.begin_dt <> n.begin_dt
        or o.exp_dt <> n.exp_dt
        or o.log_status_cd <> n.log_status_cd
        or o.remark <> n.remark
        or o.cont_curr_cd <> n.cont_curr_cd
        or o.log_init_froz_amt <> n.log_init_froz_amt
        or o.benefc_cert_type_cd <> n.benefc_cert_type_cd
        or o.benefc_cert_no <> n.benefc_cert_no
        or o.new_log_termnt_dt <> n.new_log_termnt_dt
        or o.mtg_cont_id <> n.mtg_cont_id
        or o.benefc_resdnt_addr <> n.benefc_resdnt_addr
        or o.col_book_val <> n.col_book_val
        or o.surp_compens_amt <> n.surp_compens_amt
        or o.log_compens_status_cd <> n.log_compens_status_cd
        or o.loan_sign_cont_amt <> n.loan_sign_cont_amt
        or o.cust_id <> n.cust_id
        or o.auth_teller_id <> n.auth_teller_id
        or o.check_teller_id <> n.check_teller_id
        or o.tran_teller_id <> n.tran_teller_id
        or o.ghb_benefc_acct_num_flg <> n.ghb_benefc_acct_num_flg
        or o.final_modif_dt <> n.final_modif_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_log_acct_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,log_id -- 保函编号
    ,prod_id -- 产品编号
    ,log_cont_id -- 保函合同编号
    ,dubil_id -- 借据编号
    ,open_acct_org_id -- 开户机构编号
    ,tran_org_id -- 交易机构编号
    ,guar_org_id -- 担保机构编号
    ,rev_guar_org_id -- 反担机构编号
    ,appl_cust_id -- 申请者客户编号
    ,benefc_acct_id -- 受益人账户编号
    ,benefc_name -- 受益人名称
    ,cust_mgr_id -- 客户经理编号
    ,curr_cd -- 币种代码
    ,log_amt -- 保函金额
    ,pymc_cust_acct_num -- 备款客户账号
    ,pymc_acct_sub_acct_num -- 备款账户子账号
    ,pymc_acct_curr_cd -- 备款账户币种代码
    ,pymc_acct_prod_id -- 备款账户产品编号
    ,pbc_clear_acct_num -- 人行清算账号
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_prod_id -- 结算账户产品编号
    ,advc_amt -- 垫款金额
    ,advc_loan_acct_num -- 垫款贷款账号
    ,advc_fix_pnlt_int_rat -- 垫款固定罚息利率
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,log_status_cd -- 保函状态代码
    ,remark -- 备注
    ,cont_curr_cd -- 合同币种代码
    ,log_init_froz_amt -- 保函原始冻结金额
    ,benefc_cert_type_cd -- 受益人证件类型代码
    ,benefc_cert_no -- 受益人证件号码
    ,new_log_termnt_dt -- 新保函终止日期
    ,mtg_cont_id -- 抵押合同编号
    ,benefc_resdnt_addr -- 受益人居住地址
    ,col_book_val -- 押品账面价值
    ,surp_compens_amt -- 剩余赔付金额
    ,log_compens_status_cd -- 保函赔付状态代码
    ,loan_sign_cont_amt -- 贷款签约合同金额
    ,cust_id -- 客户编号
    ,auth_teller_id -- 授权柜员编号
    ,check_teller_id -- 复核柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,ghb_benefc_acct_num_flg -- 本行受益人账号标志
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_log_acct_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,log_id -- 保函编号
    ,prod_id -- 产品编号
    ,log_cont_id -- 保函合同编号
    ,dubil_id -- 借据编号
    ,open_acct_org_id -- 开户机构编号
    ,tran_org_id -- 交易机构编号
    ,guar_org_id -- 担保机构编号
    ,rev_guar_org_id -- 反担机构编号
    ,appl_cust_id -- 申请者客户编号
    ,benefc_acct_id -- 受益人账户编号
    ,benefc_name -- 受益人名称
    ,cust_mgr_id -- 客户经理编号
    ,curr_cd -- 币种代码
    ,log_amt -- 保函金额
    ,pymc_cust_acct_num -- 备款客户账号
    ,pymc_acct_sub_acct_num -- 备款账户子账号
    ,pymc_acct_curr_cd -- 备款账户币种代码
    ,pymc_acct_prod_id -- 备款账户产品编号
    ,pbc_clear_acct_num -- 人行清算账号
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_prod_id -- 结算账户产品编号
    ,advc_amt -- 垫款金额
    ,advc_loan_acct_num -- 垫款贷款账号
    ,advc_fix_pnlt_int_rat -- 垫款固定罚息利率
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,log_status_cd -- 保函状态代码
    ,remark -- 备注
    ,cont_curr_cd -- 合同币种代码
    ,log_init_froz_amt -- 保函原始冻结金额
    ,benefc_cert_type_cd -- 受益人证件类型代码
    ,benefc_cert_no -- 受益人证件号码
    ,new_log_termnt_dt -- 新保函终止日期
    ,mtg_cont_id -- 抵押合同编号
    ,benefc_resdnt_addr -- 受益人居住地址
    ,col_book_val -- 押品账面价值
    ,surp_compens_amt -- 剩余赔付金额
    ,log_compens_status_cd -- 保函赔付状态代码
    ,loan_sign_cont_amt -- 贷款签约合同金额
    ,cust_id -- 客户编号
    ,auth_teller_id -- 授权柜员编号
    ,check_teller_id -- 复核柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,ghb_benefc_acct_num_flg -- 本行受益人账号标志
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.acct_id -- 账户编号
    ,o.log_id -- 保函编号
    ,o.prod_id -- 产品编号
    ,o.log_cont_id -- 保函合同编号
    ,o.dubil_id -- 借据编号
    ,o.open_acct_org_id -- 开户机构编号
    ,o.tran_org_id -- 交易机构编号
    ,o.guar_org_id -- 担保机构编号
    ,o.rev_guar_org_id -- 反担机构编号
    ,o.appl_cust_id -- 申请者客户编号
    ,o.benefc_acct_id -- 受益人账户编号
    ,o.benefc_name -- 受益人名称
    ,o.cust_mgr_id -- 客户经理编号
    ,o.curr_cd -- 币种代码
    ,o.log_amt -- 保函金额
    ,o.pymc_cust_acct_num -- 备款客户账号
    ,o.pymc_acct_sub_acct_num -- 备款账户子账号
    ,o.pymc_acct_curr_cd -- 备款账户币种代码
    ,o.pymc_acct_prod_id -- 备款账户产品编号
    ,o.pbc_clear_acct_num -- 人行清算账号
    ,o.stl_acct_sub_acct_num -- 结算账户子账号
    ,o.stl_acct_curr_cd -- 结算账户币种代码
    ,o.stl_acct_prod_id -- 结算账户产品编号
    ,o.advc_amt -- 垫款金额
    ,o.advc_loan_acct_num -- 垫款贷款账号
    ,o.advc_fix_pnlt_int_rat -- 垫款固定罚息利率
    ,o.begin_dt -- 起始日期
    ,o.exp_dt -- 到期日期
    ,o.log_status_cd -- 保函状态代码
    ,o.remark -- 备注
    ,o.cont_curr_cd -- 合同币种代码
    ,o.log_init_froz_amt -- 保函原始冻结金额
    ,o.benefc_cert_type_cd -- 受益人证件类型代码
    ,o.benefc_cert_no -- 受益人证件号码
    ,o.new_log_termnt_dt -- 新保函终止日期
    ,o.mtg_cont_id -- 抵押合同编号
    ,o.benefc_resdnt_addr -- 受益人居住地址
    ,o.col_book_val -- 押品账面价值
    ,o.surp_compens_amt -- 剩余赔付金额
    ,o.log_compens_status_cd -- 保函赔付状态代码
    ,o.loan_sign_cont_amt -- 贷款签约合同金额
    ,o.cust_id -- 客户编号
    ,o.auth_teller_id -- 授权柜员编号
    ,o.check_teller_id -- 复核柜员编号
    ,o.tran_teller_id -- 交易柜员编号
    ,o.ghb_benefc_acct_num_flg -- 本行受益人账号标志
    ,o.final_modif_dt -- 最后修改日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_log_acct_h_ncbsf1_bk o
    left join ${iml_schema}.agt_log_acct_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_log_acct_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.acct_id = d.acct_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_log_acct_h;
--alter table ${iml_schema}.agt_log_acct_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_log_acct_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_log_acct_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_log_acct_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_log_acct_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_log_acct_h_ncbsf1_cl;
alter table ${iml_schema}.agt_log_acct_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_log_acct_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_log_acct_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_log_acct_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_log_acct_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_log_acct_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_log_acct_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_log_acct_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
