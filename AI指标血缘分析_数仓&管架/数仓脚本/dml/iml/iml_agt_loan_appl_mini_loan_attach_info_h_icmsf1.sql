/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_appl_mini_loan_attach_info_h_icmsf1
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
alter table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,adv_repay_applit_name -- 提前还款申请人名称
    ,fst_estate_avg -- 第一房产均价
    ,secd_estate_avg -- 第二房产均价
    ,fst_estate_cert_num -- 第一房产证号
    ,secd_estate_cert_num -- 第二房产证号
    ,fst_estate_cert_addr_dist_cd -- 第一房产证地址区划代码
    ,secd_estate_cert_addr_dist_cd -- 第二房产证地址区划代码
    ,fst_estate_area -- 第一房产面积
    ,secd_estate_area -- 第二房产面积
    ,fst_estate_mtg_flg -- 第一房产抵押标志
    ,secd_estate_mtg_flg -- 第二房产抵押标志
    ,fst_estate_cert_dtl_addr -- 第一房产证详细地址
    ,secd_estate_cert_dtl_addr -- 第二房产证详细地址
    ,fst_estate_house_char_cd -- 第一房产房屋性质代码
    ,secd_estate_house_char_cd -- 第二房产房屋性质代码
    ,fst_estate_own_prop_number -- 第一房产共有产权人数
    ,secd_estate_own_prop_number -- 第二房产共有产权人数
    ,fst_estate_brwer_prop_lot -- 第一房产借款人产权份额
    ,secd_estate_brwer_prop_lot -- 第二房产借款人产权份额
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,promis_fee_rat -- 承诺费率
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,guar_inten_cd -- 担保意向代码
    ,recv_bank_name -- 收款行名称
    ,recv_bank_no -- 收款行行号
    ,secd_repay_acct_name -- 第二还款账户名称
    ,secd_repay_acct_id -- 第二还款账户编号
    ,major_guartor_name -- 主要担保人名称
    ,major_guartor_id -- 主要担保人编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,entr_pay_acct_id -- 受托支付账户编号
    ,init_loan_amt -- 原贷款金额
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,loan_deduct_way_cd -- 贷款扣款方式代码
    ,loan_int_set_way_cd -- 贷款结息方式代码
    ,enter_acct_org_id -- 入账机构编号
    ,first_trial_teller_id -- 初审柜员编号
    ,occu_lmt -- 已占用额度
    ,resv_pric -- 保留本金
    ,occu_margin_amt -- 已占用保证金金额
    ,comm_fee_amt -- 手续费金额
    ,tenor_type_cd -- 期限类型代码
    ,latest_apv_amt -- 最新审批金额
    ,stud_loan_deflt_prod_id -- 助贷默认产品编号
    ,modif_prod_id_flg -- 变更产品编号标志
    ,ky_l_flg -- 快易贷标志
    ,lmt_cont_id -- 额度合同编号
    ,apv_lev_cd -- 审批级别代码
    ,force_manu_apv_flg -- 强制人工审批标志
    ,camp_chn_id -- 营销渠道编号
    ,camp_corp_id -- 营销单位编号
    ,init_withhold_mgmt_fee_sign_flg -- 发起代扣管理费签约标志
    ,guar_corp_id -- 担保公司编号
    ,intror_id -- 介绍人编号
    ,guar_corp_occu_lmt -- 担保公司已占用额度
    ,camp_corp_name -- 营销单位名称
    ,camp_chn_name -- 营销渠道名称
    ,recvbl_open_acct_org_id -- 收款开户机构编号
    ,loan_usage_descb -- 贷款用途描述
    ,loan_prop_id -- 贷款方案编号
    ,sign_org_id -- 签约机构编号
    ,prtcpt_deduct_flg -- 参与批扣标志
    ,repay_comnt -- 还款说明
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_ba_upl_loan-1
insert into ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_tm(
    appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,adv_repay_applit_name -- 提前还款申请人名称
    ,fst_estate_avg -- 第一房产均价
    ,secd_estate_avg -- 第二房产均价
    ,fst_estate_cert_num -- 第一房产证号
    ,secd_estate_cert_num -- 第二房产证号
    ,fst_estate_cert_addr_dist_cd -- 第一房产证地址区划代码
    ,secd_estate_cert_addr_dist_cd -- 第二房产证地址区划代码
    ,fst_estate_area -- 第一房产面积
    ,secd_estate_area -- 第二房产面积
    ,fst_estate_mtg_flg -- 第一房产抵押标志
    ,secd_estate_mtg_flg -- 第二房产抵押标志
    ,fst_estate_cert_dtl_addr -- 第一房产证详细地址
    ,secd_estate_cert_dtl_addr -- 第二房产证详细地址
    ,fst_estate_house_char_cd -- 第一房产房屋性质代码
    ,secd_estate_house_char_cd -- 第二房产房屋性质代码
    ,fst_estate_own_prop_number -- 第一房产共有产权人数
    ,secd_estate_own_prop_number -- 第二房产共有产权人数
    ,fst_estate_brwer_prop_lot -- 第一房产借款人产权份额
    ,secd_estate_brwer_prop_lot -- 第二房产借款人产权份额
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,promis_fee_rat -- 承诺费率
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,guar_inten_cd -- 担保意向代码
    ,recv_bank_name -- 收款行名称
    ,recv_bank_no -- 收款行行号
    ,secd_repay_acct_name -- 第二还款账户名称
    ,secd_repay_acct_id -- 第二还款账户编号
    ,major_guartor_name -- 主要担保人名称
    ,major_guartor_id -- 主要担保人编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,entr_pay_acct_id -- 受托支付账户编号
    ,init_loan_amt -- 原贷款金额
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,loan_deduct_way_cd -- 贷款扣款方式代码
    ,loan_int_set_way_cd -- 贷款结息方式代码
    ,enter_acct_org_id -- 入账机构编号
    ,first_trial_teller_id -- 初审柜员编号
    ,occu_lmt -- 已占用额度
    ,resv_pric -- 保留本金
    ,occu_margin_amt -- 已占用保证金金额
    ,comm_fee_amt -- 手续费金额
    ,tenor_type_cd -- 期限类型代码
    ,latest_apv_amt -- 最新审批金额
    ,stud_loan_deflt_prod_id -- 助贷默认产品编号
    ,modif_prod_id_flg -- 变更产品编号标志
    ,ky_l_flg -- 快易贷标志
    ,lmt_cont_id -- 额度合同编号
    ,apv_lev_cd -- 审批级别代码
    ,force_manu_apv_flg -- 强制人工审批标志
    ,camp_chn_id -- 营销渠道编号
    ,camp_corp_id -- 营销单位编号
    ,init_withhold_mgmt_fee_sign_flg -- 发起代扣管理费签约标志
    ,guar_corp_id -- 担保公司编号
    ,intror_id -- 介绍人编号
    ,guar_corp_occu_lmt -- 担保公司已占用额度
    ,camp_corp_name -- 营销单位名称
    ,camp_chn_name -- 营销渠道名称
    ,recvbl_open_acct_org_id -- 收款开户机构编号
    ,loan_usage_descb -- 贷款用途描述
    ,loan_prop_id -- 贷款方案编号
    ,sign_org_id -- 签约机构编号
    ,prtcpt_deduct_flg -- 参与批扣标志
    ,repay_comnt -- 还款说明
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206004'||P1.SERIALNO -- 申请编号
    ,P1.SERIALNO -- 申请流水号
    ,P1.TRUSTACCNAME -- 提前还款申请人名称
    ,P1.PRICE1 -- 第一房产均价
    ,P1.PRICE2 -- 第二房产均价
    ,P1.HOUSENMBER1 -- 第一房产证号
    ,P1.HOUSENMBER2 -- 第二房产证号
    ,nvl(trim(P1.HOUSEAREACODE1),'000000') -- 第一房产证地址区划代码
    ,nvl(trim(P1.HOUSEAREACODE2),'000000') -- 第二房产证地址区划代码
    ,P1.AMOUNT1 -- 第一房产面积
    ,P1.AMOUNT2 -- 第二房产面积
    ,nvl(trim(P1.ISGUARANTY1),'-') -- 第一房产抵押标志
    ,nvl(trim(P1.ISGUARANTY2),'-') -- 第二房产抵押标志
    ,P1.HOUSEADD1 -- 第一房产证详细地址
    ,P1.HOUSEADD2 -- 第二房产证详细地址
    ,nvl(trim(P1.HOUSETYPE1),'-') -- 第一房产房屋性质代码
    ,nvl(trim(P1.HOUSETYPE2),'-') -- 第二房产房屋性质代码
    ,nvl(trim(p1.PERSONS1),0) -- 第一房产共有产权人数
    ,nvl(trim(p1.PERSONS2),0) -- 第二房产共有产权人数
    ,P1.HAVECOUNT1 -- 第一房产借款人产权份额
    ,P1.HAVECOUNT2 -- 第二房产借款人产权份额
    ,P1.FEERATIO -- 个人贷款手续费率
    ,nvl(trim(P1.FEEPAYMENT),'-') -- 手续费支付方式代码
    ,P1.PROMISESFEERATIO -- 承诺费率
    ,nvl(trim(P1.PAYMENTTYPE),'0') -- 放款支付方式代码
    ,nvl(trim(P1.GUARINTEN),'-') -- 担保意向代码
    ,P1.PAYBANKNAME -- 收款行名称
    ,P1.PAYBANKNO -- 收款行行号
    ,P1.PAYACCOUNTNAME2 -- 第二还款账户名称
    ,P1.PAYACCOUNTNO2 -- 第二还款账户编号
    ,P1.WARRANTOR -- 主要担保人名称
    ,P1.WARRANTORID -- 主要担保人编号
    ,P1.TRUSTPAYACCOUNTNAME -- 受托支付账户名称
    ,P1.TRUSTPAYACCOUNTNO -- 受托支付账户编号
    ,P1.ORGINALBUSINESSUM -- 原贷款金额
    ,P1.LOANTRADESUM -- 贷款用途交易金额
    ,nvl(trim(P1.LOANDEDUCTMETHOD),'-') -- 贷款扣款方式代码
    ,nvl(trim(P1.LOANINTSETTLEMETHOD),'-') -- 贷款结息方式代码
    ,P1.INCOMEORGID -- 入账机构编号
    ,P1.PREAPPROVERID -- 初审柜员编号
    ,P1.USEDSUM -- 已占用额度
    ,P1.HOLDCORPUS -- 保留本金
    ,P1.USEDBAILSUM -- 已占用保证金金额
    ,P1.FEESUM -- 手续费金额
    ,nvl(trim(P1.LOANKIND),'-') -- 期限类型代码
    ,P1.APPROVESUM -- 最新审批金额
    ,P1.SUBBUSINESSTYPE -- 助贷默认产品编号
    ,P1.CHANGETYPEFLAG -- 变更产品编号标志
    ,nvl(trim(P1.ISKYD),'-') -- 快易贷标志
    ,P1.CREDITAGGREEMENT -- 额度合同编号
    ,nvl(trim(P1.APPROVELEVEL),'-') -- 审批级别代码
    ,P1.ISCOMPULSAPPROVAL -- 强制人工审批标志
    ,P1.SALECHANNELID -- 营销渠道编号
    ,P1.SALETEAMID -- 营销单位编号
    ,nvl(trim(P1.IFDKQY),'-') -- 发起代扣管理费签约标志
    ,P1.CORPGUARSERIALNO -- 担保公司编号
    ,P1.INTRODUCERID -- 介绍人编号
    ,P1.GUARUSEDSUM -- 担保公司已占用额度
    ,P1.SALETEAMNAME -- 营销单位名称
    ,P1.SALECHANNELNAME -- 营销渠道名称
    ,P1.PAYBANKADDCODE -- 收款开户机构编号
    ,P1.PURPOSE -- 贷款用途描述
    ,P1.SCHEMENO -- 贷款方案编号
    ,P1.SIGNEDPLACE -- 签约机构编号
    ,nvl(trim(P1.BATCHPAYMENTFLAG),'-') -- 参与批扣标志
    ,P1.PAYSOURCE -- 还款说明
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_ba_upl_loan' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ba_upl_loan p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,appl_flow_num
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
        into ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,adv_repay_applit_name -- 提前还款申请人名称
    ,fst_estate_avg -- 第一房产均价
    ,secd_estate_avg -- 第二房产均价
    ,fst_estate_cert_num -- 第一房产证号
    ,secd_estate_cert_num -- 第二房产证号
    ,fst_estate_cert_addr_dist_cd -- 第一房产证地址区划代码
    ,secd_estate_cert_addr_dist_cd -- 第二房产证地址区划代码
    ,fst_estate_area -- 第一房产面积
    ,secd_estate_area -- 第二房产面积
    ,fst_estate_mtg_flg -- 第一房产抵押标志
    ,secd_estate_mtg_flg -- 第二房产抵押标志
    ,fst_estate_cert_dtl_addr -- 第一房产证详细地址
    ,secd_estate_cert_dtl_addr -- 第二房产证详细地址
    ,fst_estate_house_char_cd -- 第一房产房屋性质代码
    ,secd_estate_house_char_cd -- 第二房产房屋性质代码
    ,fst_estate_own_prop_number -- 第一房产共有产权人数
    ,secd_estate_own_prop_number -- 第二房产共有产权人数
    ,fst_estate_brwer_prop_lot -- 第一房产借款人产权份额
    ,secd_estate_brwer_prop_lot -- 第二房产借款人产权份额
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,promis_fee_rat -- 承诺费率
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,guar_inten_cd -- 担保意向代码
    ,recv_bank_name -- 收款行名称
    ,recv_bank_no -- 收款行行号
    ,secd_repay_acct_name -- 第二还款账户名称
    ,secd_repay_acct_id -- 第二还款账户编号
    ,major_guartor_name -- 主要担保人名称
    ,major_guartor_id -- 主要担保人编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,entr_pay_acct_id -- 受托支付账户编号
    ,init_loan_amt -- 原贷款金额
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,loan_deduct_way_cd -- 贷款扣款方式代码
    ,loan_int_set_way_cd -- 贷款结息方式代码
    ,enter_acct_org_id -- 入账机构编号
    ,first_trial_teller_id -- 初审柜员编号
    ,occu_lmt -- 已占用额度
    ,resv_pric -- 保留本金
    ,occu_margin_amt -- 已占用保证金金额
    ,comm_fee_amt -- 手续费金额
    ,tenor_type_cd -- 期限类型代码
    ,latest_apv_amt -- 最新审批金额
    ,stud_loan_deflt_prod_id -- 助贷默认产品编号
    ,modif_prod_id_flg -- 变更产品编号标志
    ,ky_l_flg -- 快易贷标志
    ,lmt_cont_id -- 额度合同编号
    ,apv_lev_cd -- 审批级别代码
    ,force_manu_apv_flg -- 强制人工审批标志
    ,camp_chn_id -- 营销渠道编号
    ,camp_corp_id -- 营销单位编号
    ,init_withhold_mgmt_fee_sign_flg -- 发起代扣管理费签约标志
    ,guar_corp_id -- 担保公司编号
    ,intror_id -- 介绍人编号
    ,guar_corp_occu_lmt -- 担保公司已占用额度
    ,camp_corp_name -- 营销单位名称
    ,camp_chn_name -- 营销渠道名称
    ,recvbl_open_acct_org_id -- 收款开户机构编号
    ,loan_usage_descb -- 贷款用途描述
    ,loan_prop_id -- 贷款方案编号
    ,sign_org_id -- 签约机构编号
    ,prtcpt_deduct_flg -- 参与批扣标志
    ,repay_comnt -- 还款说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,adv_repay_applit_name -- 提前还款申请人名称
    ,fst_estate_avg -- 第一房产均价
    ,secd_estate_avg -- 第二房产均价
    ,fst_estate_cert_num -- 第一房产证号
    ,secd_estate_cert_num -- 第二房产证号
    ,fst_estate_cert_addr_dist_cd -- 第一房产证地址区划代码
    ,secd_estate_cert_addr_dist_cd -- 第二房产证地址区划代码
    ,fst_estate_area -- 第一房产面积
    ,secd_estate_area -- 第二房产面积
    ,fst_estate_mtg_flg -- 第一房产抵押标志
    ,secd_estate_mtg_flg -- 第二房产抵押标志
    ,fst_estate_cert_dtl_addr -- 第一房产证详细地址
    ,secd_estate_cert_dtl_addr -- 第二房产证详细地址
    ,fst_estate_house_char_cd -- 第一房产房屋性质代码
    ,secd_estate_house_char_cd -- 第二房产房屋性质代码
    ,fst_estate_own_prop_number -- 第一房产共有产权人数
    ,secd_estate_own_prop_number -- 第二房产共有产权人数
    ,fst_estate_brwer_prop_lot -- 第一房产借款人产权份额
    ,secd_estate_brwer_prop_lot -- 第二房产借款人产权份额
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,promis_fee_rat -- 承诺费率
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,guar_inten_cd -- 担保意向代码
    ,recv_bank_name -- 收款行名称
    ,recv_bank_no -- 收款行行号
    ,secd_repay_acct_name -- 第二还款账户名称
    ,secd_repay_acct_id -- 第二还款账户编号
    ,major_guartor_name -- 主要担保人名称
    ,major_guartor_id -- 主要担保人编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,entr_pay_acct_id -- 受托支付账户编号
    ,init_loan_amt -- 原贷款金额
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,loan_deduct_way_cd -- 贷款扣款方式代码
    ,loan_int_set_way_cd -- 贷款结息方式代码
    ,enter_acct_org_id -- 入账机构编号
    ,first_trial_teller_id -- 初审柜员编号
    ,occu_lmt -- 已占用额度
    ,resv_pric -- 保留本金
    ,occu_margin_amt -- 已占用保证金金额
    ,comm_fee_amt -- 手续费金额
    ,tenor_type_cd -- 期限类型代码
    ,latest_apv_amt -- 最新审批金额
    ,stud_loan_deflt_prod_id -- 助贷默认产品编号
    ,modif_prod_id_flg -- 变更产品编号标志
    ,ky_l_flg -- 快易贷标志
    ,lmt_cont_id -- 额度合同编号
    ,apv_lev_cd -- 审批级别代码
    ,force_manu_apv_flg -- 强制人工审批标志
    ,camp_chn_id -- 营销渠道编号
    ,camp_corp_id -- 营销单位编号
    ,init_withhold_mgmt_fee_sign_flg -- 发起代扣管理费签约标志
    ,guar_corp_id -- 担保公司编号
    ,intror_id -- 介绍人编号
    ,guar_corp_occu_lmt -- 担保公司已占用额度
    ,camp_corp_name -- 营销单位名称
    ,camp_chn_name -- 营销渠道名称
    ,recvbl_open_acct_org_id -- 收款开户机构编号
    ,loan_usage_descb -- 贷款用途描述
    ,loan_prop_id -- 贷款方案编号
    ,sign_org_id -- 签约机构编号
    ,prtcpt_deduct_flg -- 参与批扣标志
    ,repay_comnt -- 还款说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.appl_flow_num, o.appl_flow_num) as appl_flow_num -- 申请流水号
    ,nvl(n.adv_repay_applit_name, o.adv_repay_applit_name) as adv_repay_applit_name -- 提前还款申请人名称
    ,nvl(n.fst_estate_avg, o.fst_estate_avg) as fst_estate_avg -- 第一房产均价
    ,nvl(n.secd_estate_avg, o.secd_estate_avg) as secd_estate_avg -- 第二房产均价
    ,nvl(n.fst_estate_cert_num, o.fst_estate_cert_num) as fst_estate_cert_num -- 第一房产证号
    ,nvl(n.secd_estate_cert_num, o.secd_estate_cert_num) as secd_estate_cert_num -- 第二房产证号
    ,nvl(n.fst_estate_cert_addr_dist_cd, o.fst_estate_cert_addr_dist_cd) as fst_estate_cert_addr_dist_cd -- 第一房产证地址区划代码
    ,nvl(n.secd_estate_cert_addr_dist_cd, o.secd_estate_cert_addr_dist_cd) as secd_estate_cert_addr_dist_cd -- 第二房产证地址区划代码
    ,nvl(n.fst_estate_area, o.fst_estate_area) as fst_estate_area -- 第一房产面积
    ,nvl(n.secd_estate_area, o.secd_estate_area) as secd_estate_area -- 第二房产面积
    ,nvl(n.fst_estate_mtg_flg, o.fst_estate_mtg_flg) as fst_estate_mtg_flg -- 第一房产抵押标志
    ,nvl(n.secd_estate_mtg_flg, o.secd_estate_mtg_flg) as secd_estate_mtg_flg -- 第二房产抵押标志
    ,nvl(n.fst_estate_cert_dtl_addr, o.fst_estate_cert_dtl_addr) as fst_estate_cert_dtl_addr -- 第一房产证详细地址
    ,nvl(n.secd_estate_cert_dtl_addr, o.secd_estate_cert_dtl_addr) as secd_estate_cert_dtl_addr -- 第二房产证详细地址
    ,nvl(n.fst_estate_house_char_cd, o.fst_estate_house_char_cd) as fst_estate_house_char_cd -- 第一房产房屋性质代码
    ,nvl(n.secd_estate_house_char_cd, o.secd_estate_house_char_cd) as secd_estate_house_char_cd -- 第二房产房屋性质代码
    ,nvl(n.fst_estate_own_prop_number, o.fst_estate_own_prop_number) as fst_estate_own_prop_number -- 第一房产共有产权人数
    ,nvl(n.secd_estate_own_prop_number, o.secd_estate_own_prop_number) as secd_estate_own_prop_number -- 第二房产共有产权人数
    ,nvl(n.fst_estate_brwer_prop_lot, o.fst_estate_brwer_prop_lot) as fst_estate_brwer_prop_lot -- 第一房产借款人产权份额
    ,nvl(n.secd_estate_brwer_prop_lot, o.secd_estate_brwer_prop_lot) as secd_estate_brwer_prop_lot -- 第二房产借款人产权份额
    ,nvl(n.indv_loan_comm_fee_rat, o.indv_loan_comm_fee_rat) as indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,nvl(n.comm_fee_mode_pay_cd, o.comm_fee_mode_pay_cd) as comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,nvl(n.promis_fee_rat, o.promis_fee_rat) as promis_fee_rat -- 承诺费率
    ,nvl(n.distr_mode_pay_cd, o.distr_mode_pay_cd) as distr_mode_pay_cd -- 放款支付方式代码
    ,nvl(n.guar_inten_cd, o.guar_inten_cd) as guar_inten_cd -- 担保意向代码
    ,nvl(n.recv_bank_name, o.recv_bank_name) as recv_bank_name -- 收款行名称
    ,nvl(n.recv_bank_no, o.recv_bank_no) as recv_bank_no -- 收款行行号
    ,nvl(n.secd_repay_acct_name, o.secd_repay_acct_name) as secd_repay_acct_name -- 第二还款账户名称
    ,nvl(n.secd_repay_acct_id, o.secd_repay_acct_id) as secd_repay_acct_id -- 第二还款账户编号
    ,nvl(n.major_guartor_name, o.major_guartor_name) as major_guartor_name -- 主要担保人名称
    ,nvl(n.major_guartor_id, o.major_guartor_id) as major_guartor_id -- 主要担保人编号
    ,nvl(n.entr_pay_acct_name, o.entr_pay_acct_name) as entr_pay_acct_name -- 受托支付账户名称
    ,nvl(n.entr_pay_acct_id, o.entr_pay_acct_id) as entr_pay_acct_id -- 受托支付账户编号
    ,nvl(n.init_loan_amt, o.init_loan_amt) as init_loan_amt -- 原贷款金额
    ,nvl(n.loan_usage_tran_amt, o.loan_usage_tran_amt) as loan_usage_tran_amt -- 贷款用途交易金额
    ,nvl(n.loan_deduct_way_cd, o.loan_deduct_way_cd) as loan_deduct_way_cd -- 贷款扣款方式代码
    ,nvl(n.loan_int_set_way_cd, o.loan_int_set_way_cd) as loan_int_set_way_cd -- 贷款结息方式代码
    ,nvl(n.enter_acct_org_id, o.enter_acct_org_id) as enter_acct_org_id -- 入账机构编号
    ,nvl(n.first_trial_teller_id, o.first_trial_teller_id) as first_trial_teller_id -- 初审柜员编号
    ,nvl(n.occu_lmt, o.occu_lmt) as occu_lmt -- 已占用额度
    ,nvl(n.resv_pric, o.resv_pric) as resv_pric -- 保留本金
    ,nvl(n.occu_margin_amt, o.occu_margin_amt) as occu_margin_amt -- 已占用保证金金额
    ,nvl(n.comm_fee_amt, o.comm_fee_amt) as comm_fee_amt -- 手续费金额
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.latest_apv_amt, o.latest_apv_amt) as latest_apv_amt -- 最新审批金额
    ,nvl(n.stud_loan_deflt_prod_id, o.stud_loan_deflt_prod_id) as stud_loan_deflt_prod_id -- 助贷默认产品编号
    ,nvl(n.modif_prod_id_flg, o.modif_prod_id_flg) as modif_prod_id_flg -- 变更产品编号标志
    ,nvl(n.ky_l_flg, o.ky_l_flg) as ky_l_flg -- 快易贷标志
    ,nvl(n.lmt_cont_id, o.lmt_cont_id) as lmt_cont_id -- 额度合同编号
    ,nvl(n.apv_lev_cd, o.apv_lev_cd) as apv_lev_cd -- 审批级别代码
    ,nvl(n.force_manu_apv_flg, o.force_manu_apv_flg) as force_manu_apv_flg -- 强制人工审批标志
    ,nvl(n.camp_chn_id, o.camp_chn_id) as camp_chn_id -- 营销渠道编号
    ,nvl(n.camp_corp_id, o.camp_corp_id) as camp_corp_id -- 营销单位编号
    ,nvl(n.init_withhold_mgmt_fee_sign_flg, o.init_withhold_mgmt_fee_sign_flg) as init_withhold_mgmt_fee_sign_flg -- 发起代扣管理费签约标志
    ,nvl(n.guar_corp_id, o.guar_corp_id) as guar_corp_id -- 担保公司编号
    ,nvl(n.intror_id, o.intror_id) as intror_id -- 介绍人编号
    ,nvl(n.guar_corp_occu_lmt, o.guar_corp_occu_lmt) as guar_corp_occu_lmt -- 担保公司已占用额度
    ,nvl(n.camp_corp_name, o.camp_corp_name) as camp_corp_name -- 营销单位名称
    ,nvl(n.camp_chn_name, o.camp_chn_name) as camp_chn_name -- 营销渠道名称
    ,nvl(n.recvbl_open_acct_org_id, o.recvbl_open_acct_org_id) as recvbl_open_acct_org_id -- 收款开户机构编号
    ,nvl(n.loan_usage_descb, o.loan_usage_descb) as loan_usage_descb -- 贷款用途描述
    ,nvl(n.loan_prop_id, o.loan_prop_id) as loan_prop_id -- 贷款方案编号
    ,nvl(n.sign_org_id, o.sign_org_id) as sign_org_id -- 签约机构编号
    ,nvl(n.prtcpt_deduct_flg, o.prtcpt_deduct_flg) as prtcpt_deduct_flg -- 参与批扣标志
    ,nvl(n.repay_comnt, o.repay_comnt) as repay_comnt -- 还款说明
    ,case when
            n.appl_id is null
            and n.appl_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.appl_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.appl_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.appl_flow_num = n.appl_flow_num
where (
        o.appl_id is null
        and o.appl_flow_num is null
    )
    or (
        n.appl_id is null
        and n.appl_flow_num is null
    )
    or (
        o.adv_repay_applit_name <> n.adv_repay_applit_name
        or o.fst_estate_avg <> n.fst_estate_avg
        or o.secd_estate_avg <> n.secd_estate_avg
        or o.fst_estate_cert_num <> n.fst_estate_cert_num
        or o.secd_estate_cert_num <> n.secd_estate_cert_num
        or o.fst_estate_cert_addr_dist_cd <> n.fst_estate_cert_addr_dist_cd
        or o.secd_estate_cert_addr_dist_cd <> n.secd_estate_cert_addr_dist_cd
        or o.fst_estate_area <> n.fst_estate_area
        or o.secd_estate_area <> n.secd_estate_area
        or o.fst_estate_mtg_flg <> n.fst_estate_mtg_flg
        or o.secd_estate_mtg_flg <> n.secd_estate_mtg_flg
        or o.fst_estate_cert_dtl_addr <> n.fst_estate_cert_dtl_addr
        or o.secd_estate_cert_dtl_addr <> n.secd_estate_cert_dtl_addr
        or o.fst_estate_house_char_cd <> n.fst_estate_house_char_cd
        or o.secd_estate_house_char_cd <> n.secd_estate_house_char_cd
        or o.fst_estate_own_prop_number <> n.fst_estate_own_prop_number
        or o.secd_estate_own_prop_number <> n.secd_estate_own_prop_number
        or o.fst_estate_brwer_prop_lot <> n.fst_estate_brwer_prop_lot
        or o.secd_estate_brwer_prop_lot <> n.secd_estate_brwer_prop_lot
        or o.indv_loan_comm_fee_rat <> n.indv_loan_comm_fee_rat
        or o.comm_fee_mode_pay_cd <> n.comm_fee_mode_pay_cd
        or o.promis_fee_rat <> n.promis_fee_rat
        or o.distr_mode_pay_cd <> n.distr_mode_pay_cd
        or o.guar_inten_cd <> n.guar_inten_cd
        or o.recv_bank_name <> n.recv_bank_name
        or o.recv_bank_no <> n.recv_bank_no
        or o.secd_repay_acct_name <> n.secd_repay_acct_name
        or o.secd_repay_acct_id <> n.secd_repay_acct_id
        or o.major_guartor_name <> n.major_guartor_name
        or o.major_guartor_id <> n.major_guartor_id
        or o.entr_pay_acct_name <> n.entr_pay_acct_name
        or o.entr_pay_acct_id <> n.entr_pay_acct_id
        or o.init_loan_amt <> n.init_loan_amt
        or o.loan_usage_tran_amt <> n.loan_usage_tran_amt
        or o.loan_deduct_way_cd <> n.loan_deduct_way_cd
        or o.loan_int_set_way_cd <> n.loan_int_set_way_cd
        or o.enter_acct_org_id <> n.enter_acct_org_id
        or o.first_trial_teller_id <> n.first_trial_teller_id
        or o.occu_lmt <> n.occu_lmt
        or o.resv_pric <> n.resv_pric
        or o.occu_margin_amt <> n.occu_margin_amt
        or o.comm_fee_amt <> n.comm_fee_amt
        or o.tenor_type_cd <> n.tenor_type_cd
        or o.latest_apv_amt <> n.latest_apv_amt
        or o.stud_loan_deflt_prod_id <> n.stud_loan_deflt_prod_id
        or o.modif_prod_id_flg <> n.modif_prod_id_flg
        or o.ky_l_flg <> n.ky_l_flg
        or o.lmt_cont_id <> n.lmt_cont_id
        or o.apv_lev_cd <> n.apv_lev_cd
        or o.force_manu_apv_flg <> n.force_manu_apv_flg
        or o.camp_chn_id <> n.camp_chn_id
        or o.camp_corp_id <> n.camp_corp_id
        or o.init_withhold_mgmt_fee_sign_flg <> n.init_withhold_mgmt_fee_sign_flg
        or o.guar_corp_id <> n.guar_corp_id
        or o.intror_id <> n.intror_id
        or o.guar_corp_occu_lmt <> n.guar_corp_occu_lmt
        or o.camp_corp_name <> n.camp_corp_name
        or o.camp_chn_name <> n.camp_chn_name
        or o.recvbl_open_acct_org_id <> n.recvbl_open_acct_org_id
        or o.loan_usage_descb <> n.loan_usage_descb
        or o.loan_prop_id <> n.loan_prop_id
        or o.sign_org_id <> n.sign_org_id
        or o.prtcpt_deduct_flg <> n.prtcpt_deduct_flg
        or o.repay_comnt <> n.repay_comnt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,adv_repay_applit_name -- 提前还款申请人名称
    ,fst_estate_avg -- 第一房产均价
    ,secd_estate_avg -- 第二房产均价
    ,fst_estate_cert_num -- 第一房产证号
    ,secd_estate_cert_num -- 第二房产证号
    ,fst_estate_cert_addr_dist_cd -- 第一房产证地址区划代码
    ,secd_estate_cert_addr_dist_cd -- 第二房产证地址区划代码
    ,fst_estate_area -- 第一房产面积
    ,secd_estate_area -- 第二房产面积
    ,fst_estate_mtg_flg -- 第一房产抵押标志
    ,secd_estate_mtg_flg -- 第二房产抵押标志
    ,fst_estate_cert_dtl_addr -- 第一房产证详细地址
    ,secd_estate_cert_dtl_addr -- 第二房产证详细地址
    ,fst_estate_house_char_cd -- 第一房产房屋性质代码
    ,secd_estate_house_char_cd -- 第二房产房屋性质代码
    ,fst_estate_own_prop_number -- 第一房产共有产权人数
    ,secd_estate_own_prop_number -- 第二房产共有产权人数
    ,fst_estate_brwer_prop_lot -- 第一房产借款人产权份额
    ,secd_estate_brwer_prop_lot -- 第二房产借款人产权份额
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,promis_fee_rat -- 承诺费率
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,guar_inten_cd -- 担保意向代码
    ,recv_bank_name -- 收款行名称
    ,recv_bank_no -- 收款行行号
    ,secd_repay_acct_name -- 第二还款账户名称
    ,secd_repay_acct_id -- 第二还款账户编号
    ,major_guartor_name -- 主要担保人名称
    ,major_guartor_id -- 主要担保人编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,entr_pay_acct_id -- 受托支付账户编号
    ,init_loan_amt -- 原贷款金额
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,loan_deduct_way_cd -- 贷款扣款方式代码
    ,loan_int_set_way_cd -- 贷款结息方式代码
    ,enter_acct_org_id -- 入账机构编号
    ,first_trial_teller_id -- 初审柜员编号
    ,occu_lmt -- 已占用额度
    ,resv_pric -- 保留本金
    ,occu_margin_amt -- 已占用保证金金额
    ,comm_fee_amt -- 手续费金额
    ,tenor_type_cd -- 期限类型代码
    ,latest_apv_amt -- 最新审批金额
    ,stud_loan_deflt_prod_id -- 助贷默认产品编号
    ,modif_prod_id_flg -- 变更产品编号标志
    ,ky_l_flg -- 快易贷标志
    ,lmt_cont_id -- 额度合同编号
    ,apv_lev_cd -- 审批级别代码
    ,force_manu_apv_flg -- 强制人工审批标志
    ,camp_chn_id -- 营销渠道编号
    ,camp_corp_id -- 营销单位编号
    ,init_withhold_mgmt_fee_sign_flg -- 发起代扣管理费签约标志
    ,guar_corp_id -- 担保公司编号
    ,intror_id -- 介绍人编号
    ,guar_corp_occu_lmt -- 担保公司已占用额度
    ,camp_corp_name -- 营销单位名称
    ,camp_chn_name -- 营销渠道名称
    ,recvbl_open_acct_org_id -- 收款开户机构编号
    ,loan_usage_descb -- 贷款用途描述
    ,loan_prop_id -- 贷款方案编号
    ,sign_org_id -- 签约机构编号
    ,prtcpt_deduct_flg -- 参与批扣标志
    ,repay_comnt -- 还款说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,adv_repay_applit_name -- 提前还款申请人名称
    ,fst_estate_avg -- 第一房产均价
    ,secd_estate_avg -- 第二房产均价
    ,fst_estate_cert_num -- 第一房产证号
    ,secd_estate_cert_num -- 第二房产证号
    ,fst_estate_cert_addr_dist_cd -- 第一房产证地址区划代码
    ,secd_estate_cert_addr_dist_cd -- 第二房产证地址区划代码
    ,fst_estate_area -- 第一房产面积
    ,secd_estate_area -- 第二房产面积
    ,fst_estate_mtg_flg -- 第一房产抵押标志
    ,secd_estate_mtg_flg -- 第二房产抵押标志
    ,fst_estate_cert_dtl_addr -- 第一房产证详细地址
    ,secd_estate_cert_dtl_addr -- 第二房产证详细地址
    ,fst_estate_house_char_cd -- 第一房产房屋性质代码
    ,secd_estate_house_char_cd -- 第二房产房屋性质代码
    ,fst_estate_own_prop_number -- 第一房产共有产权人数
    ,secd_estate_own_prop_number -- 第二房产共有产权人数
    ,fst_estate_brwer_prop_lot -- 第一房产借款人产权份额
    ,secd_estate_brwer_prop_lot -- 第二房产借款人产权份额
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,promis_fee_rat -- 承诺费率
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,guar_inten_cd -- 担保意向代码
    ,recv_bank_name -- 收款行名称
    ,recv_bank_no -- 收款行行号
    ,secd_repay_acct_name -- 第二还款账户名称
    ,secd_repay_acct_id -- 第二还款账户编号
    ,major_guartor_name -- 主要担保人名称
    ,major_guartor_id -- 主要担保人编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,entr_pay_acct_id -- 受托支付账户编号
    ,init_loan_amt -- 原贷款金额
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,loan_deduct_way_cd -- 贷款扣款方式代码
    ,loan_int_set_way_cd -- 贷款结息方式代码
    ,enter_acct_org_id -- 入账机构编号
    ,first_trial_teller_id -- 初审柜员编号
    ,occu_lmt -- 已占用额度
    ,resv_pric -- 保留本金
    ,occu_margin_amt -- 已占用保证金金额
    ,comm_fee_amt -- 手续费金额
    ,tenor_type_cd -- 期限类型代码
    ,latest_apv_amt -- 最新审批金额
    ,stud_loan_deflt_prod_id -- 助贷默认产品编号
    ,modif_prod_id_flg -- 变更产品编号标志
    ,ky_l_flg -- 快易贷标志
    ,lmt_cont_id -- 额度合同编号
    ,apv_lev_cd -- 审批级别代码
    ,force_manu_apv_flg -- 强制人工审批标志
    ,camp_chn_id -- 营销渠道编号
    ,camp_corp_id -- 营销单位编号
    ,init_withhold_mgmt_fee_sign_flg -- 发起代扣管理费签约标志
    ,guar_corp_id -- 担保公司编号
    ,intror_id -- 介绍人编号
    ,guar_corp_occu_lmt -- 担保公司已占用额度
    ,camp_corp_name -- 营销单位名称
    ,camp_chn_name -- 营销渠道名称
    ,recvbl_open_acct_org_id -- 收款开户机构编号
    ,loan_usage_descb -- 贷款用途描述
    ,loan_prop_id -- 贷款方案编号
    ,sign_org_id -- 签约机构编号
    ,prtcpt_deduct_flg -- 参与批扣标志
    ,repay_comnt -- 还款说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.appl_flow_num -- 申请流水号
    ,o.adv_repay_applit_name -- 提前还款申请人名称
    ,o.fst_estate_avg -- 第一房产均价
    ,o.secd_estate_avg -- 第二房产均价
    ,o.fst_estate_cert_num -- 第一房产证号
    ,o.secd_estate_cert_num -- 第二房产证号
    ,o.fst_estate_cert_addr_dist_cd -- 第一房产证地址区划代码
    ,o.secd_estate_cert_addr_dist_cd -- 第二房产证地址区划代码
    ,o.fst_estate_area -- 第一房产面积
    ,o.secd_estate_area -- 第二房产面积
    ,o.fst_estate_mtg_flg -- 第一房产抵押标志
    ,o.secd_estate_mtg_flg -- 第二房产抵押标志
    ,o.fst_estate_cert_dtl_addr -- 第一房产证详细地址
    ,o.secd_estate_cert_dtl_addr -- 第二房产证详细地址
    ,o.fst_estate_house_char_cd -- 第一房产房屋性质代码
    ,o.secd_estate_house_char_cd -- 第二房产房屋性质代码
    ,o.fst_estate_own_prop_number -- 第一房产共有产权人数
    ,o.secd_estate_own_prop_number -- 第二房产共有产权人数
    ,o.fst_estate_brwer_prop_lot -- 第一房产借款人产权份额
    ,o.secd_estate_brwer_prop_lot -- 第二房产借款人产权份额
    ,o.indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,o.comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,o.promis_fee_rat -- 承诺费率
    ,o.distr_mode_pay_cd -- 放款支付方式代码
    ,o.guar_inten_cd -- 担保意向代码
    ,o.recv_bank_name -- 收款行名称
    ,o.recv_bank_no -- 收款行行号
    ,o.secd_repay_acct_name -- 第二还款账户名称
    ,o.secd_repay_acct_id -- 第二还款账户编号
    ,o.major_guartor_name -- 主要担保人名称
    ,o.major_guartor_id -- 主要担保人编号
    ,o.entr_pay_acct_name -- 受托支付账户名称
    ,o.entr_pay_acct_id -- 受托支付账户编号
    ,o.init_loan_amt -- 原贷款金额
    ,o.loan_usage_tran_amt -- 贷款用途交易金额
    ,o.loan_deduct_way_cd -- 贷款扣款方式代码
    ,o.loan_int_set_way_cd -- 贷款结息方式代码
    ,o.enter_acct_org_id -- 入账机构编号
    ,o.first_trial_teller_id -- 初审柜员编号
    ,o.occu_lmt -- 已占用额度
    ,o.resv_pric -- 保留本金
    ,o.occu_margin_amt -- 已占用保证金金额
    ,o.comm_fee_amt -- 手续费金额
    ,o.tenor_type_cd -- 期限类型代码
    ,o.latest_apv_amt -- 最新审批金额
    ,o.stud_loan_deflt_prod_id -- 助贷默认产品编号
    ,o.modif_prod_id_flg -- 变更产品编号标志
    ,o.ky_l_flg -- 快易贷标志
    ,o.lmt_cont_id -- 额度合同编号
    ,o.apv_lev_cd -- 审批级别代码
    ,o.force_manu_apv_flg -- 强制人工审批标志
    ,o.camp_chn_id -- 营销渠道编号
    ,o.camp_corp_id -- 营销单位编号
    ,o.init_withhold_mgmt_fee_sign_flg -- 发起代扣管理费签约标志
    ,o.guar_corp_id -- 担保公司编号
    ,o.intror_id -- 介绍人编号
    ,o.guar_corp_occu_lmt -- 担保公司已占用额度
    ,o.camp_corp_name -- 营销单位名称
    ,o.camp_chn_name -- 营销渠道名称
    ,o.recvbl_open_acct_org_id -- 收款开户机构编号
    ,o.loan_usage_descb -- 贷款用途描述
    ,o.loan_prop_id -- 贷款方案编号
    ,o.sign_org_id -- 签约机构编号
    ,o.prtcpt_deduct_flg -- 参与批扣标志
    ,o.repay_comnt -- 还款说明
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
from ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.appl_flow_num = n.appl_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.appl_flow_num = d.appl_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h;
--alter table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_appl_mini_loan_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_appl_mini_loan_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
