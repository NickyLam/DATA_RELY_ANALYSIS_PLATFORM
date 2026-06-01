/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_loan_prod_attach_info_h_icmsf1
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
alter table ${iml_schema}.prd_loan_prod_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_loan_prod_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_name -- 产品名称
    ,cust_bl_induty_cd -- 客户所属行业代码
    ,lowt_cust_rating_cd -- 最低客户评级代码
    ,guar_way_cd -- 担保方式代码
    ,min_annual_int_rat -- 最小年化利率
    ,max_annual_int_rat -- 最大年化利率
    ,grace_days -- 宽限天数
    ,auto_out_acct_rgst_flg -- 自动出账登记标志
    ,max_auto_distr_amt -- 最大自动放款金额
    ,auto_check_distr_flg -- 自动复核放款标志
    ,auto_entr_pay_flg -- 自动受托支付标志
    ,entr_pay_acct_id -- 受托支付账户编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,supt_adv_repay_flg -- 支持提前还款标志
    ,supt_onl_distr_appl_flg -- 支持线上放款申请标志
    ,lmt_min_tenor -- 额度最小期限
    ,dom_overs_idf_cd -- 境内外标识代码
    ,cust_type_cd -- 客户类型代码
    ,acct_type_cd -- 账户类型代码
    ,brwer_acct_check_flg -- 借款人账户检查标志
    ,discnt_loan_type_cd -- 贴现贷款类型代码
    ,curr_cd -- 币种代码
    ,sig_distr_amt_ctrl_flg -- 单次发放金额控制标志
    ,sig_max_distr_amt -- 单次最大发放金额
    ,sig_min_distr_amt -- 单次最小发放金额
    ,loan_tenor_ctrl_flg -- 贷款期限控制标志
    ,lont_loan_mon_tenor -- 最长贷款月期限
    ,shortest_loan_mon_tenor -- 最短贷款月期限
    ,incremt_distr_apv_flg -- 增量发放审批标志
    ,sig_distr_flg -- 单笔发放标志
    ,distr_allow_apv_flg -- 发放允许审批标志
    ,repay_way_cd -- 还款方式代码
    ,subtn_deduct_flg -- 持续扣款标志
    ,auto_callbk_flg -- 自动回收标志
    ,repay_amt_ctrl_flg -- 还款金额控制标志
    ,adv_col_int_flg -- 提前收息标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,int_accr_flg -- 计息标志
    ,c_comp_int_flg -- 收复利标志
    ,c_pnlt_flg -- 收罚息标志
    ,c_pnlt_comp_int_flg -- 收罚息的复利标志
    ,c_comp_int_comp_int_flg -- 收复利的复利标志
    ,allow_renew_flg -- 允许展期标志
    ,max_renew_cnt -- 最大展期次数
    ,allow_soterm_flg -- 允许缩期标志
    ,max_soterm_cnt -- 最大缩期次数
    ,circl_flg -- 循环标志
    ,sel_sup_flg -- 自营标志
    ,asset_tran_flg -- 资产转让标志
    ,abs_flg -- 资产证券化标志
    ,log_and_base_cont_rela_type_cd -- 保函与基础合同关系类型代码
    ,log_attr_cd -- 保函属性代码
    ,log_advc_prod_id -- 保函垫款产品编号
    ,rela_margin_flg -- 关联保证金标志
    ,open_auto_froz_margin_flg -- 开立时自动冻结保证金标志
    ,retra_auto_unfrz_margin_flg -- 收回时自动解冻保证金标志
    ,exp_auto_unfrz_margin_flg -- 到期自动解冻保证金标志
    ,syn_loan_char_cd -- 银团贷款性质代码
    ,ovdue_soc_days -- 逾期理赔天数
    ,soc_ratio -- 理赔比例
    ,old_prod_id -- 旧产品编号
    ,new_prod_id -- 新产品编号
    ,new_prod_name -- 新产品名称
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_loan_prod_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_loan_prod_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_loan_prod_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_prd_business_define-1
insert into ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_name -- 产品名称
    ,cust_bl_induty_cd -- 客户所属行业代码
    ,lowt_cust_rating_cd -- 最低客户评级代码
    ,guar_way_cd -- 担保方式代码
    ,min_annual_int_rat -- 最小年化利率
    ,max_annual_int_rat -- 最大年化利率
    ,grace_days -- 宽限天数
    ,auto_out_acct_rgst_flg -- 自动出账登记标志
    ,max_auto_distr_amt -- 最大自动放款金额
    ,auto_check_distr_flg -- 自动复核放款标志
    ,auto_entr_pay_flg -- 自动受托支付标志
    ,entr_pay_acct_id -- 受托支付账户编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,supt_adv_repay_flg -- 支持提前还款标志
    ,supt_onl_distr_appl_flg -- 支持线上放款申请标志
    ,lmt_min_tenor -- 额度最小期限
    ,dom_overs_idf_cd -- 境内外标识代码
    ,cust_type_cd -- 客户类型代码
    ,acct_type_cd -- 账户类型代码
    ,brwer_acct_check_flg -- 借款人账户检查标志
    ,discnt_loan_type_cd -- 贴现贷款类型代码
    ,curr_cd -- 币种代码
    ,sig_distr_amt_ctrl_flg -- 单次发放金额控制标志
    ,sig_max_distr_amt -- 单次最大发放金额
    ,sig_min_distr_amt -- 单次最小发放金额
    ,loan_tenor_ctrl_flg -- 贷款期限控制标志
    ,lont_loan_mon_tenor -- 最长贷款月期限
    ,shortest_loan_mon_tenor -- 最短贷款月期限
    ,incremt_distr_apv_flg -- 增量发放审批标志
    ,sig_distr_flg -- 单笔发放标志
    ,distr_allow_apv_flg -- 发放允许审批标志
    ,repay_way_cd -- 还款方式代码
    ,subtn_deduct_flg -- 持续扣款标志
    ,auto_callbk_flg -- 自动回收标志
    ,repay_amt_ctrl_flg -- 还款金额控制标志
    ,adv_col_int_flg -- 提前收息标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,int_accr_flg -- 计息标志
    ,c_comp_int_flg -- 收复利标志
    ,c_pnlt_flg -- 收罚息标志
    ,c_pnlt_comp_int_flg -- 收罚息的复利标志
    ,c_comp_int_comp_int_flg -- 收复利的复利标志
    ,allow_renew_flg -- 允许展期标志
    ,max_renew_cnt -- 最大展期次数
    ,allow_soterm_flg -- 允许缩期标志
    ,max_soterm_cnt -- 最大缩期次数
    ,circl_flg -- 循环标志
    ,sel_sup_flg -- 自营标志
    ,asset_tran_flg -- 资产转让标志
    ,abs_flg -- 资产证券化标志
    ,log_and_base_cont_rela_type_cd -- 保函与基础合同关系类型代码
    ,log_attr_cd -- 保函属性代码
    ,log_advc_prod_id -- 保函垫款产品编号
    ,rela_margin_flg -- 关联保证金标志
    ,open_auto_froz_margin_flg -- 开立时自动冻结保证金标志
    ,retra_auto_unfrz_margin_flg -- 收回时自动解冻保证金标志
    ,exp_auto_unfrz_margin_flg -- 到期自动解冻保证金标志
    ,syn_loan_char_cd -- 银团贷款性质代码
    ,ovdue_soc_days -- 逾期理赔天数
    ,soc_ratio -- 理赔比例
    ,old_prod_id -- 旧产品编号
    ,new_prod_id -- 新产品编号
    ,new_prod_name -- 新产品名称
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.PRODUCTID -- 产品编号
    ,'9999' -- 法人编号
    ,P1.PRODUCTNAME -- 产品名称
    ,nvl(trim(P1.INDUSTRYTYPE),'-') -- 客户所属行业代码
    ,nvl(trim(P1.CUSTOMERLEVEL),'-')-- 最低客户评级代码
    ,nvl(trim(P1.VOUCHTYPE),'-') -- 担保方式代码
    ,P1.MINYEARRATE -- 最小年化利率
    ,P1.MAXYEARRATE -- 最大年化利率
    ,P1.GRACEPERIOD -- 宽限天数
    ,P1.ISAUTOPUTOUTREGISTER -- 自动出账登记标志
    ,P1.MAXBUSINESSSUM -- 最大自动放款金额
    ,P1.ISAUTORECHECKPUTOUT -- 自动复核放款标志
    ,P1.ISAUTOPAYMENT -- 自动受托支付标志
    ,P1.SINOSUREACCOUNT -- 受托支付账户编号
    ,P1.SINOSURENAME -- 受托支付账户名称
    ,P1.ISSUPPREPAYMENT -- 支持提前还款标志
    ,P1.ISSUPONLINEPUTOUT -- 支持线上放款申请标志
    ,P1.MINCREDITTERM -- 额度最小期限
    ,nvl(trim(P1.DOMESTICOROVERSEAS),'-') -- 境内外标识代码
    ,nvl(trim(P1.CUSTOMERTYPE),'-') -- 客户类型代码
    ,nvl(trim(P1.ACCOUNTTYPE),'-') -- 账户类型代码
    ,P1.BORROWACCOUNTCHECK -- 借款人账户检查标志
    ,nvl(trim(P1.DISCOUNTTYPE),'-') -- 贴现贷款类型代码
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.ONCEPAYMENTFLAG -- 单次发放金额控制标志
    ,P1.ONCEMAXPAYMENTFLAG -- 单次最大发放金额
    ,P1.ONCEMINPAYMENTFLAG -- 单次最小发放金额
    ,P1.TERMMONTHFLAG -- 贷款期限控制标志
    ,P1.MAXLOANTERM -- 最长贷款月期限
    ,P1.MINLOANTERM -- 最短贷款月期限
    ,P1.INCREASEGRANTAPPROVE -- 增量发放审批标志
    ,P1.SINGLEGRANT -- 单笔发放标志
    ,P1.ISGRANTAPPROVEFLAG -- 发放允许审批标志
    ,nvl(trim(P1.INSTALLMENTSMENTHOD),'-') -- 还款方式代码
    ,P1.WAIVEDAUTOPAYFLAG -- 持续扣款标志
    ,P1.BACKFLAG -- 自动回收标志
    ,P1.PREPAYAMT -- 还款金额控制标志
    ,P1.ACCEPTINTTYPE -- 提前收息标志
    ,nvl(trim(P1.RATETYPE),'-') -- 利率启用方式代码
    ,nvl(trim(P1.RATECHANGECYCLE),'-')-- 利率调整周期代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.RATEEFFECTTYPE END-- 利率生效方式代码
    ,P1.ICTYPE -- 计息标志
    ,P1.COMPOUNDINTFLAG -- 收复利标志
    ,P1.ISFINTEREST -- 收罚息标志
    ,P1.ISWAIVEDCOMP -- 收罚息的复利标志
    ,P1.COMPOUNTINTEREST -- 收复利的复利标志
    ,P1.ISEXTEND -- 允许展期标志
    ,P1.MAXEXTENDCOUNT -- 最大展期次数
    ,P1.ISISSUE -- 允许缩期标志
    ,P1.MAXISSUECOUNT -- 最大缩期次数
    ,P1.CYCLEFLAG -- 循环标志
    ,P1.PROPIETARYFLAG -- 自营标志
    ,P1.ASSETTRANDFLAG -- 资产转让标志
    ,P1.ISASSETS -- 资产证券化标志
    ,nvl(trim(P1.GUARCONTRACTRELATE),'-') -- 保函与基础合同关系类型代码
    ,nvl(trim(P1.GUARATTRIBUTE),'-') -- 保函属性代码
    ,P1.GUARADVANCEPRODUCT -- 保函垫款产品编号
    ,P1.ISASSOCIATEBAIL -- 关联保证金标志
    ,P1.ISOPENAUTOFREEZEBAIL -- 开立时自动冻结保证金标志
    ,P1.ISTAKEBACKAUTOUNFREEZEBAIL -- 收回时自动解冻保证金标志
    ,P1.ISEXPIREAUTOUNFREEZEBAIL -- 到期自动解冻保证金标志
    ,nvl(trim(P1.HOSTBANKNATURE),'-') -- 银团贷款性质代码
    ,P1.OVERDUECLAIMSDAYS -- 逾期理赔天数
    ,P1.CLAIMSRAIO -- 理赔比例
    ,P1.OLDPRODUCTID -- 旧产品编号
    ,P1.NEWPRODUCTID -- 新产品编号
    ,P1.NEWPRODUCTNAME -- 新产品名称
    ,P1.EFFECTIVEDATE -- 产品生效日期
    ,P1.EXPIRYDATE -- 产品失效日期
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 变更日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_prd_business_define' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_prd_business_define p1
        LEFT JOIN ${iml_schema}.REF_PUB_CD_MAP R1 ON P1.RATEEFFECTTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_PRD_BUSINESS_DEFINE'
        AND R1.SRC_FIELD_EN_NAME= 'RATEEFFECTTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_LOAN_PROD_ATTACH_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_EFFECT_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        prod_id
  	                                        ,lp_id
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
        into ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_name -- 产品名称
    ,cust_bl_induty_cd -- 客户所属行业代码
    ,lowt_cust_rating_cd -- 最低客户评级代码
    ,guar_way_cd -- 担保方式代码
    ,min_annual_int_rat -- 最小年化利率
    ,max_annual_int_rat -- 最大年化利率
    ,grace_days -- 宽限天数
    ,auto_out_acct_rgst_flg -- 自动出账登记标志
    ,max_auto_distr_amt -- 最大自动放款金额
    ,auto_check_distr_flg -- 自动复核放款标志
    ,auto_entr_pay_flg -- 自动受托支付标志
    ,entr_pay_acct_id -- 受托支付账户编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,supt_adv_repay_flg -- 支持提前还款标志
    ,supt_onl_distr_appl_flg -- 支持线上放款申请标志
    ,lmt_min_tenor -- 额度最小期限
    ,dom_overs_idf_cd -- 境内外标识代码
    ,cust_type_cd -- 客户类型代码
    ,acct_type_cd -- 账户类型代码
    ,brwer_acct_check_flg -- 借款人账户检查标志
    ,discnt_loan_type_cd -- 贴现贷款类型代码
    ,curr_cd -- 币种代码
    ,sig_distr_amt_ctrl_flg -- 单次发放金额控制标志
    ,sig_max_distr_amt -- 单次最大发放金额
    ,sig_min_distr_amt -- 单次最小发放金额
    ,loan_tenor_ctrl_flg -- 贷款期限控制标志
    ,lont_loan_mon_tenor -- 最长贷款月期限
    ,shortest_loan_mon_tenor -- 最短贷款月期限
    ,incremt_distr_apv_flg -- 增量发放审批标志
    ,sig_distr_flg -- 单笔发放标志
    ,distr_allow_apv_flg -- 发放允许审批标志
    ,repay_way_cd -- 还款方式代码
    ,subtn_deduct_flg -- 持续扣款标志
    ,auto_callbk_flg -- 自动回收标志
    ,repay_amt_ctrl_flg -- 还款金额控制标志
    ,adv_col_int_flg -- 提前收息标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,int_accr_flg -- 计息标志
    ,c_comp_int_flg -- 收复利标志
    ,c_pnlt_flg -- 收罚息标志
    ,c_pnlt_comp_int_flg -- 收罚息的复利标志
    ,c_comp_int_comp_int_flg -- 收复利的复利标志
    ,allow_renew_flg -- 允许展期标志
    ,max_renew_cnt -- 最大展期次数
    ,allow_soterm_flg -- 允许缩期标志
    ,max_soterm_cnt -- 最大缩期次数
    ,circl_flg -- 循环标志
    ,sel_sup_flg -- 自营标志
    ,asset_tran_flg -- 资产转让标志
    ,abs_flg -- 资产证券化标志
    ,log_and_base_cont_rela_type_cd -- 保函与基础合同关系类型代码
    ,log_attr_cd -- 保函属性代码
    ,log_advc_prod_id -- 保函垫款产品编号
    ,rela_margin_flg -- 关联保证金标志
    ,open_auto_froz_margin_flg -- 开立时自动冻结保证金标志
    ,retra_auto_unfrz_margin_flg -- 收回时自动解冻保证金标志
    ,exp_auto_unfrz_margin_flg -- 到期自动解冻保证金标志
    ,syn_loan_char_cd -- 银团贷款性质代码
    ,ovdue_soc_days -- 逾期理赔天数
    ,soc_ratio -- 理赔比例
    ,old_prod_id -- 旧产品编号
    ,new_prod_id -- 新产品编号
    ,new_prod_name -- 新产品名称
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_name -- 产品名称
    ,cust_bl_induty_cd -- 客户所属行业代码
    ,lowt_cust_rating_cd -- 最低客户评级代码
    ,guar_way_cd -- 担保方式代码
    ,min_annual_int_rat -- 最小年化利率
    ,max_annual_int_rat -- 最大年化利率
    ,grace_days -- 宽限天数
    ,auto_out_acct_rgst_flg -- 自动出账登记标志
    ,max_auto_distr_amt -- 最大自动放款金额
    ,auto_check_distr_flg -- 自动复核放款标志
    ,auto_entr_pay_flg -- 自动受托支付标志
    ,entr_pay_acct_id -- 受托支付账户编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,supt_adv_repay_flg -- 支持提前还款标志
    ,supt_onl_distr_appl_flg -- 支持线上放款申请标志
    ,lmt_min_tenor -- 额度最小期限
    ,dom_overs_idf_cd -- 境内外标识代码
    ,cust_type_cd -- 客户类型代码
    ,acct_type_cd -- 账户类型代码
    ,brwer_acct_check_flg -- 借款人账户检查标志
    ,discnt_loan_type_cd -- 贴现贷款类型代码
    ,curr_cd -- 币种代码
    ,sig_distr_amt_ctrl_flg -- 单次发放金额控制标志
    ,sig_max_distr_amt -- 单次最大发放金额
    ,sig_min_distr_amt -- 单次最小发放金额
    ,loan_tenor_ctrl_flg -- 贷款期限控制标志
    ,lont_loan_mon_tenor -- 最长贷款月期限
    ,shortest_loan_mon_tenor -- 最短贷款月期限
    ,incremt_distr_apv_flg -- 增量发放审批标志
    ,sig_distr_flg -- 单笔发放标志
    ,distr_allow_apv_flg -- 发放允许审批标志
    ,repay_way_cd -- 还款方式代码
    ,subtn_deduct_flg -- 持续扣款标志
    ,auto_callbk_flg -- 自动回收标志
    ,repay_amt_ctrl_flg -- 还款金额控制标志
    ,adv_col_int_flg -- 提前收息标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,int_accr_flg -- 计息标志
    ,c_comp_int_flg -- 收复利标志
    ,c_pnlt_flg -- 收罚息标志
    ,c_pnlt_comp_int_flg -- 收罚息的复利标志
    ,c_comp_int_comp_int_flg -- 收复利的复利标志
    ,allow_renew_flg -- 允许展期标志
    ,max_renew_cnt -- 最大展期次数
    ,allow_soterm_flg -- 允许缩期标志
    ,max_soterm_cnt -- 最大缩期次数
    ,circl_flg -- 循环标志
    ,sel_sup_flg -- 自营标志
    ,asset_tran_flg -- 资产转让标志
    ,abs_flg -- 资产证券化标志
    ,log_and_base_cont_rela_type_cd -- 保函与基础合同关系类型代码
    ,log_attr_cd -- 保函属性代码
    ,log_advc_prod_id -- 保函垫款产品编号
    ,rela_margin_flg -- 关联保证金标志
    ,open_auto_froz_margin_flg -- 开立时自动冻结保证金标志
    ,retra_auto_unfrz_margin_flg -- 收回时自动解冻保证金标志
    ,exp_auto_unfrz_margin_flg -- 到期自动解冻保证金标志
    ,syn_loan_char_cd -- 银团贷款性质代码
    ,ovdue_soc_days -- 逾期理赔天数
    ,soc_ratio -- 理赔比例
    ,old_prod_id -- 旧产品编号
    ,new_prod_id -- 新产品编号
    ,new_prod_name -- 新产品名称
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.cust_bl_induty_cd, o.cust_bl_induty_cd) as cust_bl_induty_cd -- 客户所属行业代码
    ,nvl(n.lowt_cust_rating_cd, o.lowt_cust_rating_cd) as lowt_cust_rating_cd -- 最低客户评级代码
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 担保方式代码
    ,nvl(n.min_annual_int_rat, o.min_annual_int_rat) as min_annual_int_rat -- 最小年化利率
    ,nvl(n.max_annual_int_rat, o.max_annual_int_rat) as max_annual_int_rat -- 最大年化利率
    ,nvl(n.grace_days, o.grace_days) as grace_days -- 宽限天数
    ,nvl(n.auto_out_acct_rgst_flg, o.auto_out_acct_rgst_flg) as auto_out_acct_rgst_flg -- 自动出账登记标志
    ,nvl(n.max_auto_distr_amt, o.max_auto_distr_amt) as max_auto_distr_amt -- 最大自动放款金额
    ,nvl(n.auto_check_distr_flg, o.auto_check_distr_flg) as auto_check_distr_flg -- 自动复核放款标志
    ,nvl(n.auto_entr_pay_flg, o.auto_entr_pay_flg) as auto_entr_pay_flg -- 自动受托支付标志
    ,nvl(n.entr_pay_acct_id, o.entr_pay_acct_id) as entr_pay_acct_id -- 受托支付账户编号
    ,nvl(n.entr_pay_acct_name, o.entr_pay_acct_name) as entr_pay_acct_name -- 受托支付账户名称
    ,nvl(n.supt_adv_repay_flg, o.supt_adv_repay_flg) as supt_adv_repay_flg -- 支持提前还款标志
    ,nvl(n.supt_onl_distr_appl_flg, o.supt_onl_distr_appl_flg) as supt_onl_distr_appl_flg -- 支持线上放款申请标志
    ,nvl(n.lmt_min_tenor, o.lmt_min_tenor) as lmt_min_tenor -- 额度最小期限
    ,nvl(n.dom_overs_idf_cd, o.dom_overs_idf_cd) as dom_overs_idf_cd -- 境内外标识代码
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.brwer_acct_check_flg, o.brwer_acct_check_flg) as brwer_acct_check_flg -- 借款人账户检查标志
    ,nvl(n.discnt_loan_type_cd, o.discnt_loan_type_cd) as discnt_loan_type_cd -- 贴现贷款类型代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.sig_distr_amt_ctrl_flg, o.sig_distr_amt_ctrl_flg) as sig_distr_amt_ctrl_flg -- 单次发放金额控制标志
    ,nvl(n.sig_max_distr_amt, o.sig_max_distr_amt) as sig_max_distr_amt -- 单次最大发放金额
    ,nvl(n.sig_min_distr_amt, o.sig_min_distr_amt) as sig_min_distr_amt -- 单次最小发放金额
    ,nvl(n.loan_tenor_ctrl_flg, o.loan_tenor_ctrl_flg) as loan_tenor_ctrl_flg -- 贷款期限控制标志
    ,nvl(n.lont_loan_mon_tenor, o.lont_loan_mon_tenor) as lont_loan_mon_tenor -- 最长贷款月期限
    ,nvl(n.shortest_loan_mon_tenor, o.shortest_loan_mon_tenor) as shortest_loan_mon_tenor -- 最短贷款月期限
    ,nvl(n.incremt_distr_apv_flg, o.incremt_distr_apv_flg) as incremt_distr_apv_flg -- 增量发放审批标志
    ,nvl(n.sig_distr_flg, o.sig_distr_flg) as sig_distr_flg -- 单笔发放标志
    ,nvl(n.distr_allow_apv_flg, o.distr_allow_apv_flg) as distr_allow_apv_flg -- 发放允许审批标志
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.subtn_deduct_flg, o.subtn_deduct_flg) as subtn_deduct_flg -- 持续扣款标志
    ,nvl(n.auto_callbk_flg, o.auto_callbk_flg) as auto_callbk_flg -- 自动回收标志
    ,nvl(n.repay_amt_ctrl_flg, o.repay_amt_ctrl_flg) as repay_amt_ctrl_flg -- 还款金额控制标志
    ,nvl(n.adv_col_int_flg, o.adv_col_int_flg) as adv_col_int_flg -- 提前收息标志
    ,nvl(n.int_rat_start_use_way_cd, o.int_rat_start_use_way_cd) as int_rat_start_use_way_cd -- 利率启用方式代码
    ,nvl(n.int_rat_adj_ped_cd, o.int_rat_adj_ped_cd) as int_rat_adj_ped_cd -- 利率调整周期代码
    ,nvl(n.int_rat_effect_way_cd, o.int_rat_effect_way_cd) as int_rat_effect_way_cd -- 利率生效方式代码
    ,nvl(n.int_accr_flg, o.int_accr_flg) as int_accr_flg -- 计息标志
    ,nvl(n.c_comp_int_flg, o.c_comp_int_flg) as c_comp_int_flg -- 收复利标志
    ,nvl(n.c_pnlt_flg, o.c_pnlt_flg) as c_pnlt_flg -- 收罚息标志
    ,nvl(n.c_pnlt_comp_int_flg, o.c_pnlt_comp_int_flg) as c_pnlt_comp_int_flg -- 收罚息的复利标志
    ,nvl(n.c_comp_int_comp_int_flg, o.c_comp_int_comp_int_flg) as c_comp_int_comp_int_flg -- 收复利的复利标志
    ,nvl(n.allow_renew_flg, o.allow_renew_flg) as allow_renew_flg -- 允许展期标志
    ,nvl(n.max_renew_cnt, o.max_renew_cnt) as max_renew_cnt -- 最大展期次数
    ,nvl(n.allow_soterm_flg, o.allow_soterm_flg) as allow_soterm_flg -- 允许缩期标志
    ,nvl(n.max_soterm_cnt, o.max_soterm_cnt) as max_soterm_cnt -- 最大缩期次数
    ,nvl(n.circl_flg, o.circl_flg) as circl_flg -- 循环标志
    ,nvl(n.sel_sup_flg, o.sel_sup_flg) as sel_sup_flg -- 自营标志
    ,nvl(n.asset_tran_flg, o.asset_tran_flg) as asset_tran_flg -- 资产转让标志
    ,nvl(n.abs_flg, o.abs_flg) as abs_flg -- 资产证券化标志
    ,nvl(n.log_and_base_cont_rela_type_cd, o.log_and_base_cont_rela_type_cd) as log_and_base_cont_rela_type_cd -- 保函与基础合同关系类型代码
    ,nvl(n.log_attr_cd, o.log_attr_cd) as log_attr_cd -- 保函属性代码
    ,nvl(n.log_advc_prod_id, o.log_advc_prod_id) as log_advc_prod_id -- 保函垫款产品编号
    ,nvl(n.rela_margin_flg, o.rela_margin_flg) as rela_margin_flg -- 关联保证金标志
    ,nvl(n.open_auto_froz_margin_flg, o.open_auto_froz_margin_flg) as open_auto_froz_margin_flg -- 开立时自动冻结保证金标志
    ,nvl(n.retra_auto_unfrz_margin_flg, o.retra_auto_unfrz_margin_flg) as retra_auto_unfrz_margin_flg -- 收回时自动解冻保证金标志
    ,nvl(n.exp_auto_unfrz_margin_flg, o.exp_auto_unfrz_margin_flg) as exp_auto_unfrz_margin_flg -- 到期自动解冻保证金标志
    ,nvl(n.syn_loan_char_cd, o.syn_loan_char_cd) as syn_loan_char_cd -- 银团贷款性质代码
    ,nvl(n.ovdue_soc_days, o.ovdue_soc_days) as ovdue_soc_days -- 逾期理赔天数
    ,nvl(n.soc_ratio, o.soc_ratio) as soc_ratio -- 理赔比例
    ,nvl(n.old_prod_id, o.old_prod_id) as old_prod_id -- 旧产品编号
    ,nvl(n.new_prod_id, o.new_prod_id) as new_prod_id -- 新产品编号
    ,nvl(n.new_prod_name, o.new_prod_name) as new_prod_name -- 新产品名称
    ,nvl(n.prod_effect_dt, o.prod_effect_dt) as prod_effect_dt -- 产品生效日期
    ,nvl(n.prod_invalid_dt, o.prod_invalid_dt) as prod_invalid_dt -- 产品失效日期
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
where (
        o.prod_id is null
        and o.lp_id is null
    )
    or (
        n.prod_id is null
        and n.lp_id is null
    )
    or (
        o.prod_name <> n.prod_name
        or o.cust_bl_induty_cd <> n.cust_bl_induty_cd
        or o.lowt_cust_rating_cd <> n.lowt_cust_rating_cd
        or o.guar_way_cd <> n.guar_way_cd
        or o.min_annual_int_rat <> n.min_annual_int_rat
        or o.max_annual_int_rat <> n.max_annual_int_rat
        or o.grace_days <> n.grace_days
        or o.auto_out_acct_rgst_flg <> n.auto_out_acct_rgst_flg
        or o.max_auto_distr_amt <> n.max_auto_distr_amt
        or o.auto_check_distr_flg <> n.auto_check_distr_flg
        or o.auto_entr_pay_flg <> n.auto_entr_pay_flg
        or o.entr_pay_acct_id <> n.entr_pay_acct_id
        or o.entr_pay_acct_name <> n.entr_pay_acct_name
        or o.supt_adv_repay_flg <> n.supt_adv_repay_flg
        or o.supt_onl_distr_appl_flg <> n.supt_onl_distr_appl_flg
        or o.lmt_min_tenor <> n.lmt_min_tenor
        or o.dom_overs_idf_cd <> n.dom_overs_idf_cd
        or o.cust_type_cd <> n.cust_type_cd
        or o.acct_type_cd <> n.acct_type_cd
        or o.brwer_acct_check_flg <> n.brwer_acct_check_flg
        or o.discnt_loan_type_cd <> n.discnt_loan_type_cd
        or o.curr_cd <> n.curr_cd
        or o.sig_distr_amt_ctrl_flg <> n.sig_distr_amt_ctrl_flg
        or o.sig_max_distr_amt <> n.sig_max_distr_amt
        or o.sig_min_distr_amt <> n.sig_min_distr_amt
        or o.loan_tenor_ctrl_flg <> n.loan_tenor_ctrl_flg
        or o.lont_loan_mon_tenor <> n.lont_loan_mon_tenor
        or o.shortest_loan_mon_tenor <> n.shortest_loan_mon_tenor
        or o.incremt_distr_apv_flg <> n.incremt_distr_apv_flg
        or o.sig_distr_flg <> n.sig_distr_flg
        or o.distr_allow_apv_flg <> n.distr_allow_apv_flg
        or o.repay_way_cd <> n.repay_way_cd
        or o.subtn_deduct_flg <> n.subtn_deduct_flg
        or o.auto_callbk_flg <> n.auto_callbk_flg
        or o.repay_amt_ctrl_flg <> n.repay_amt_ctrl_flg
        or o.adv_col_int_flg <> n.adv_col_int_flg
        or o.int_rat_start_use_way_cd <> n.int_rat_start_use_way_cd
        or o.int_rat_adj_ped_cd <> n.int_rat_adj_ped_cd
        or o.int_rat_effect_way_cd <> n.int_rat_effect_way_cd
        or o.int_accr_flg <> n.int_accr_flg
        or o.c_comp_int_flg <> n.c_comp_int_flg
        or o.c_pnlt_flg <> n.c_pnlt_flg
        or o.c_pnlt_comp_int_flg <> n.c_pnlt_comp_int_flg
        or o.c_comp_int_comp_int_flg <> n.c_comp_int_comp_int_flg
        or o.allow_renew_flg <> n.allow_renew_flg
        or o.max_renew_cnt <> n.max_renew_cnt
        or o.allow_soterm_flg <> n.allow_soterm_flg
        or o.max_soterm_cnt <> n.max_soterm_cnt
        or o.circl_flg <> n.circl_flg
        or o.sel_sup_flg <> n.sel_sup_flg
        or o.asset_tran_flg <> n.asset_tran_flg
        or o.abs_flg <> n.abs_flg
        or o.log_and_base_cont_rela_type_cd <> n.log_and_base_cont_rela_type_cd
        or o.log_attr_cd <> n.log_attr_cd
        or o.log_advc_prod_id <> n.log_advc_prod_id
        or o.rela_margin_flg <> n.rela_margin_flg
        or o.open_auto_froz_margin_flg <> n.open_auto_froz_margin_flg
        or o.retra_auto_unfrz_margin_flg <> n.retra_auto_unfrz_margin_flg
        or o.exp_auto_unfrz_margin_flg <> n.exp_auto_unfrz_margin_flg
        or o.syn_loan_char_cd <> n.syn_loan_char_cd
        or o.ovdue_soc_days <> n.ovdue_soc_days
        or o.soc_ratio <> n.soc_ratio
        or o.old_prod_id <> n.old_prod_id
        or o.new_prod_id <> n.new_prod_id
        or o.new_prod_name <> n.new_prod_name
        or o.prod_effect_dt <> n.prod_effect_dt
        or o.prod_invalid_dt <> n.prod_invalid_dt
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.modif_dt <> n.modif_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_name -- 产品名称
    ,cust_bl_induty_cd -- 客户所属行业代码
    ,lowt_cust_rating_cd -- 最低客户评级代码
    ,guar_way_cd -- 担保方式代码
    ,min_annual_int_rat -- 最小年化利率
    ,max_annual_int_rat -- 最大年化利率
    ,grace_days -- 宽限天数
    ,auto_out_acct_rgst_flg -- 自动出账登记标志
    ,max_auto_distr_amt -- 最大自动放款金额
    ,auto_check_distr_flg -- 自动复核放款标志
    ,auto_entr_pay_flg -- 自动受托支付标志
    ,entr_pay_acct_id -- 受托支付账户编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,supt_adv_repay_flg -- 支持提前还款标志
    ,supt_onl_distr_appl_flg -- 支持线上放款申请标志
    ,lmt_min_tenor -- 额度最小期限
    ,dom_overs_idf_cd -- 境内外标识代码
    ,cust_type_cd -- 客户类型代码
    ,acct_type_cd -- 账户类型代码
    ,brwer_acct_check_flg -- 借款人账户检查标志
    ,discnt_loan_type_cd -- 贴现贷款类型代码
    ,curr_cd -- 币种代码
    ,sig_distr_amt_ctrl_flg -- 单次发放金额控制标志
    ,sig_max_distr_amt -- 单次最大发放金额
    ,sig_min_distr_amt -- 单次最小发放金额
    ,loan_tenor_ctrl_flg -- 贷款期限控制标志
    ,lont_loan_mon_tenor -- 最长贷款月期限
    ,shortest_loan_mon_tenor -- 最短贷款月期限
    ,incremt_distr_apv_flg -- 增量发放审批标志
    ,sig_distr_flg -- 单笔发放标志
    ,distr_allow_apv_flg -- 发放允许审批标志
    ,repay_way_cd -- 还款方式代码
    ,subtn_deduct_flg -- 持续扣款标志
    ,auto_callbk_flg -- 自动回收标志
    ,repay_amt_ctrl_flg -- 还款金额控制标志
    ,adv_col_int_flg -- 提前收息标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,int_accr_flg -- 计息标志
    ,c_comp_int_flg -- 收复利标志
    ,c_pnlt_flg -- 收罚息标志
    ,c_pnlt_comp_int_flg -- 收罚息的复利标志
    ,c_comp_int_comp_int_flg -- 收复利的复利标志
    ,allow_renew_flg -- 允许展期标志
    ,max_renew_cnt -- 最大展期次数
    ,allow_soterm_flg -- 允许缩期标志
    ,max_soterm_cnt -- 最大缩期次数
    ,circl_flg -- 循环标志
    ,sel_sup_flg -- 自营标志
    ,asset_tran_flg -- 资产转让标志
    ,abs_flg -- 资产证券化标志
    ,log_and_base_cont_rela_type_cd -- 保函与基础合同关系类型代码
    ,log_attr_cd -- 保函属性代码
    ,log_advc_prod_id -- 保函垫款产品编号
    ,rela_margin_flg -- 关联保证金标志
    ,open_auto_froz_margin_flg -- 开立时自动冻结保证金标志
    ,retra_auto_unfrz_margin_flg -- 收回时自动解冻保证金标志
    ,exp_auto_unfrz_margin_flg -- 到期自动解冻保证金标志
    ,syn_loan_char_cd -- 银团贷款性质代码
    ,ovdue_soc_days -- 逾期理赔天数
    ,soc_ratio -- 理赔比例
    ,old_prod_id -- 旧产品编号
    ,new_prod_id -- 新产品编号
    ,new_prod_name -- 新产品名称
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_name -- 产品名称
    ,cust_bl_induty_cd -- 客户所属行业代码
    ,lowt_cust_rating_cd -- 最低客户评级代码
    ,guar_way_cd -- 担保方式代码
    ,min_annual_int_rat -- 最小年化利率
    ,max_annual_int_rat -- 最大年化利率
    ,grace_days -- 宽限天数
    ,auto_out_acct_rgst_flg -- 自动出账登记标志
    ,max_auto_distr_amt -- 最大自动放款金额
    ,auto_check_distr_flg -- 自动复核放款标志
    ,auto_entr_pay_flg -- 自动受托支付标志
    ,entr_pay_acct_id -- 受托支付账户编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,supt_adv_repay_flg -- 支持提前还款标志
    ,supt_onl_distr_appl_flg -- 支持线上放款申请标志
    ,lmt_min_tenor -- 额度最小期限
    ,dom_overs_idf_cd -- 境内外标识代码
    ,cust_type_cd -- 客户类型代码
    ,acct_type_cd -- 账户类型代码
    ,brwer_acct_check_flg -- 借款人账户检查标志
    ,discnt_loan_type_cd -- 贴现贷款类型代码
    ,curr_cd -- 币种代码
    ,sig_distr_amt_ctrl_flg -- 单次发放金额控制标志
    ,sig_max_distr_amt -- 单次最大发放金额
    ,sig_min_distr_amt -- 单次最小发放金额
    ,loan_tenor_ctrl_flg -- 贷款期限控制标志
    ,lont_loan_mon_tenor -- 最长贷款月期限
    ,shortest_loan_mon_tenor -- 最短贷款月期限
    ,incremt_distr_apv_flg -- 增量发放审批标志
    ,sig_distr_flg -- 单笔发放标志
    ,distr_allow_apv_flg -- 发放允许审批标志
    ,repay_way_cd -- 还款方式代码
    ,subtn_deduct_flg -- 持续扣款标志
    ,auto_callbk_flg -- 自动回收标志
    ,repay_amt_ctrl_flg -- 还款金额控制标志
    ,adv_col_int_flg -- 提前收息标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,int_accr_flg -- 计息标志
    ,c_comp_int_flg -- 收复利标志
    ,c_pnlt_flg -- 收罚息标志
    ,c_pnlt_comp_int_flg -- 收罚息的复利标志
    ,c_comp_int_comp_int_flg -- 收复利的复利标志
    ,allow_renew_flg -- 允许展期标志
    ,max_renew_cnt -- 最大展期次数
    ,allow_soterm_flg -- 允许缩期标志
    ,max_soterm_cnt -- 最大缩期次数
    ,circl_flg -- 循环标志
    ,sel_sup_flg -- 自营标志
    ,asset_tran_flg -- 资产转让标志
    ,abs_flg -- 资产证券化标志
    ,log_and_base_cont_rela_type_cd -- 保函与基础合同关系类型代码
    ,log_attr_cd -- 保函属性代码
    ,log_advc_prod_id -- 保函垫款产品编号
    ,rela_margin_flg -- 关联保证金标志
    ,open_auto_froz_margin_flg -- 开立时自动冻结保证金标志
    ,retra_auto_unfrz_margin_flg -- 收回时自动解冻保证金标志
    ,exp_auto_unfrz_margin_flg -- 到期自动解冻保证金标志
    ,syn_loan_char_cd -- 银团贷款性质代码
    ,ovdue_soc_days -- 逾期理赔天数
    ,soc_ratio -- 理赔比例
    ,old_prod_id -- 旧产品编号
    ,new_prod_id -- 新产品编号
    ,new_prod_name -- 新产品名称
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_id -- 产品编号
    ,o.lp_id -- 法人编号
    ,o.prod_name -- 产品名称
    ,o.cust_bl_induty_cd -- 客户所属行业代码
    ,o.lowt_cust_rating_cd -- 最低客户评级代码
    ,o.guar_way_cd -- 担保方式代码
    ,o.min_annual_int_rat -- 最小年化利率
    ,o.max_annual_int_rat -- 最大年化利率
    ,o.grace_days -- 宽限天数
    ,o.auto_out_acct_rgst_flg -- 自动出账登记标志
    ,o.max_auto_distr_amt -- 最大自动放款金额
    ,o.auto_check_distr_flg -- 自动复核放款标志
    ,o.auto_entr_pay_flg -- 自动受托支付标志
    ,o.entr_pay_acct_id -- 受托支付账户编号
    ,o.entr_pay_acct_name -- 受托支付账户名称
    ,o.supt_adv_repay_flg -- 支持提前还款标志
    ,o.supt_onl_distr_appl_flg -- 支持线上放款申请标志
    ,o.lmt_min_tenor -- 额度最小期限
    ,o.dom_overs_idf_cd -- 境内外标识代码
    ,o.cust_type_cd -- 客户类型代码
    ,o.acct_type_cd -- 账户类型代码
    ,o.brwer_acct_check_flg -- 借款人账户检查标志
    ,o.discnt_loan_type_cd -- 贴现贷款类型代码
    ,o.curr_cd -- 币种代码
    ,o.sig_distr_amt_ctrl_flg -- 单次发放金额控制标志
    ,o.sig_max_distr_amt -- 单次最大发放金额
    ,o.sig_min_distr_amt -- 单次最小发放金额
    ,o.loan_tenor_ctrl_flg -- 贷款期限控制标志
    ,o.lont_loan_mon_tenor -- 最长贷款月期限
    ,o.shortest_loan_mon_tenor -- 最短贷款月期限
    ,o.incremt_distr_apv_flg -- 增量发放审批标志
    ,o.sig_distr_flg -- 单笔发放标志
    ,o.distr_allow_apv_flg -- 发放允许审批标志
    ,o.repay_way_cd -- 还款方式代码
    ,o.subtn_deduct_flg -- 持续扣款标志
    ,o.auto_callbk_flg -- 自动回收标志
    ,o.repay_amt_ctrl_flg -- 还款金额控制标志
    ,o.adv_col_int_flg -- 提前收息标志
    ,o.int_rat_start_use_way_cd -- 利率启用方式代码
    ,o.int_rat_adj_ped_cd -- 利率调整周期代码
    ,o.int_rat_effect_way_cd -- 利率生效方式代码
    ,o.int_accr_flg -- 计息标志
    ,o.c_comp_int_flg -- 收复利标志
    ,o.c_pnlt_flg -- 收罚息标志
    ,o.c_pnlt_comp_int_flg -- 收罚息的复利标志
    ,o.c_comp_int_comp_int_flg -- 收复利的复利标志
    ,o.allow_renew_flg -- 允许展期标志
    ,o.max_renew_cnt -- 最大展期次数
    ,o.allow_soterm_flg -- 允许缩期标志
    ,o.max_soterm_cnt -- 最大缩期次数
    ,o.circl_flg -- 循环标志
    ,o.sel_sup_flg -- 自营标志
    ,o.asset_tran_flg -- 资产转让标志
    ,o.abs_flg -- 资产证券化标志
    ,o.log_and_base_cont_rela_type_cd -- 保函与基础合同关系类型代码
    ,o.log_attr_cd -- 保函属性代码
    ,o.log_advc_prod_id -- 保函垫款产品编号
    ,o.rela_margin_flg -- 关联保证金标志
    ,o.open_auto_froz_margin_flg -- 开立时自动冻结保证金标志
    ,o.retra_auto_unfrz_margin_flg -- 收回时自动解冻保证金标志
    ,o.exp_auto_unfrz_margin_flg -- 到期自动解冻保证金标志
    ,o.syn_loan_char_cd -- 银团贷款性质代码
    ,o.ovdue_soc_days -- 逾期理赔天数
    ,o.soc_ratio -- 理赔比例
    ,o.old_prod_id -- 旧产品编号
    ,o.new_prod_id -- 新产品编号
    ,o.new_prod_name -- 新产品名称
    ,o.prod_effect_dt -- 产品生效日期
    ,o.prod_invalid_dt -- 产品失效日期
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.modif_dt -- 变更日期
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
from ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_op n
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_cl d
        on
            o.prod_id = d.prod_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_loan_prod_attach_info_h;
--alter table ${iml_schema}.prd_loan_prod_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('prd_loan_prod_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.prd_loan_prod_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.prd_loan_prod_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.prd_loan_prod_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.prd_loan_prod_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_loan_prod_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_loan_prod_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_loan_prod_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
