/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dep_acct_info_h_ncbsf1
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
alter table ${iml_schema}.agt_dep_acct_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dep_acct_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_dep_acct_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,acct_type_cd -- 账户等级代码
    ,acct_char_type_cd -- 账户性质类型代码
    ,priv_flg -- 对私标志
    ,acct_usage_cd -- 账户用途代码
    ,acct_lics_num -- 账户许可证号码
    ,acct_lics_issue_dt -- 账户许可证签发日期
    ,acct_aldy_check_flg -- 账户已复核标志
    ,acct_appl_org_id -- 账户申请机构编号
    ,acct_init_exp_dt -- 账户原始到期日期
    ,acct_init_open_acct_dt -- 账户原始开户日期
    ,acct_attr_cd -- 存款账户类型代码
    ,main_acct_flg -- 主账户标志
    ,main_acct_int_flg -- 主账户带利息标志
    ,main_acct_bal_flg -- 主账户带余额标志
    ,vtual_acct_flg -- 虚户标志
    ,sub_acct_num -- 子账号
    ,curr_cd -- 币种代码
    ,prod_id -- 产品编号
    ,prod_modif_dt -- 产品变更日期
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,cust_type_cd -- 客户类型代码
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cert_cty_cd -- 发证国家代码
    ,multi_bal_flg -- 多余额标志
    ,bal_type_cd -- 钞汇余额代码
    ,dep_term -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,curr_pd -- 当前期次
    ,exp_dt -- 到期日期
    ,reg_acct_type_cd -- 定期账户类型代码
    ,reg_acct_last_status_cd -- 定期账户上一状态代码
    ,fir_tran_dt -- 首次交易日期
    ,stl_flg -- 结算标志
    ,tran_stl_dt -- 交易结算日期
    ,stl_teller_id -- 结算柜员编号
    ,check_teller_id -- 复核柜员编号
    ,check_dt -- 复核日期
    ,belong_kind_cd -- 归属种类代码
    ,gl_type_cd -- 总账类型代码
    ,accti_status_cd -- 核算状态代码
    ,core_acct_type_cd -- 核心账户类型代码
    ,approval_id -- 核准件编号
    ,exch_way_cd -- 汇兑方式代码
    ,int_accr_flg -- 计息标志
    ,tran_teller_id -- 交易柜员编号
    ,card_prod_id -- 卡产品编号
    ,card_no -- 卡号
    ,open_acct_dt -- 开户日期
    ,open_acct_teller_id -- 开户柜员编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_chn_id -- 开户渠道编号
    ,cust_mgr_id -- 客户经理编号
    ,off_shore_flg -- 离岸标志
    ,unite_acct_flg -- 联合账户标志
    ,heat_insu_acct_flg -- 医保账户标志
    ,soci_secu_fin_acct_flg -- 社保卡下金融账户标志
    ,travel_card_flg -- 旅行通账户标志
    ,temp_acct_valid_dt -- 临时户有效日期
    ,travel_card_valid_dt -- 旅行通卡有效日期
    ,free_annual_fee_flg -- 免年费标志
    ,vouch_no -- 凭证号码
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_status_cd -- 凭证状态代码
    ,force_deduct_deflt_flg -- 强制扣划导致违约标志
    ,super_acct_id -- 上级账户编号
    ,last_accti_status_cd -- 上一核算状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,effect_dt -- 生效日期
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,belong_org_id -- 所属机构编号
    ,general_storage_flg -- 通存标志
    ,general_exch_flg -- 通兑标志
    ,advise_dep_tenor -- 通知存款期限
    ,part_pric_redt_flg -- 部分本金转存标志
    ,allow_add_pric_flg -- 允许增加本金标志
    ,aldy_pric_redt_cnt -- 已本金转存次数
    ,aldy_pric_int_redt_cnt -- 已本息转存次数
    ,max_pric_redt_cnt -- 最大本金转存次数
    ,max_pric_int_redt_cnt -- 最大本息转存次数
    ,init_prod_id -- 原产品编号
    ,src_module_type_cd -- 源模块类型代码
    ,src_agt_id -- 源协议编号
    ,lmt_flg -- 限制标志
    ,l_six_m_no_tran_flg -- 最近六个月无交易标志
    ,stop_pay_flg -- 止付标志
    ,turn_dormt_acct_dt -- 转不动户日期
    ,auto_payoff_flg -- 自动结清标志
    ,redt_way_type_cd -- 自动转存方式代码
    ,clos_acct_teller_id -- 销户柜员编号
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,status_modif_dt -- 状态变更日期
    ,aldy_check_blklist_flg -- 已检查黑名单标志
    ,ftz_flg -- 自贸区标志
    ,final_tran_dt -- 最后交易日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_dep_acct_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_dep_acct_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_acct-1
insert into ${iml_schema}.agt_dep_acct_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,acct_type_cd -- 账户等级代码
    ,acct_char_type_cd -- 账户性质类型代码
    ,priv_flg -- 对私标志
    ,acct_usage_cd -- 账户用途代码
    ,acct_lics_num -- 账户许可证号码
    ,acct_lics_issue_dt -- 账户许可证签发日期
    ,acct_aldy_check_flg -- 账户已复核标志
    ,acct_appl_org_id -- 账户申请机构编号
    ,acct_init_exp_dt -- 账户原始到期日期
    ,acct_init_open_acct_dt -- 账户原始开户日期
    ,acct_attr_cd -- 存款账户类型代码
    ,main_acct_flg -- 主账户标志
    ,main_acct_int_flg -- 主账户带利息标志
    ,main_acct_bal_flg -- 主账户带余额标志
    ,vtual_acct_flg -- 虚户标志
    ,sub_acct_num -- 子账号
    ,curr_cd -- 币种代码
    ,prod_id -- 产品编号
    ,prod_modif_dt -- 产品变更日期
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,cust_type_cd -- 客户类型代码
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cert_cty_cd -- 发证国家代码
    ,multi_bal_flg -- 多余额标志
    ,bal_type_cd -- 钞汇余额代码
    ,dep_term -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,curr_pd -- 当前期次
    ,exp_dt -- 到期日期
    ,reg_acct_type_cd -- 定期账户类型代码
    ,reg_acct_last_status_cd -- 定期账户上一状态代码
    ,fir_tran_dt -- 首次交易日期
    ,stl_flg -- 结算标志
    ,tran_stl_dt -- 交易结算日期
    ,stl_teller_id -- 结算柜员编号
    ,check_teller_id -- 复核柜员编号
    ,check_dt -- 复核日期
    ,belong_kind_cd -- 归属种类代码
    ,gl_type_cd -- 总账类型代码
    ,accti_status_cd -- 核算状态代码
    ,core_acct_type_cd -- 核心账户类型代码
    ,approval_id -- 核准件编号
    ,exch_way_cd -- 汇兑方式代码
    ,int_accr_flg -- 计息标志
    ,tran_teller_id -- 交易柜员编号
    ,card_prod_id -- 卡产品编号
    ,card_no -- 卡号
    ,open_acct_dt -- 开户日期
    ,open_acct_teller_id -- 开户柜员编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_chn_id -- 开户渠道编号
    ,cust_mgr_id -- 客户经理编号
    ,off_shore_flg -- 离岸标志
    ,unite_acct_flg -- 联合账户标志
    ,heat_insu_acct_flg -- 医保账户标志
    ,soci_secu_fin_acct_flg -- 社保卡下金融账户标志
    ,travel_card_flg -- 旅行通账户标志
    ,temp_acct_valid_dt -- 临时户有效日期
    ,travel_card_valid_dt -- 旅行通卡有效日期
    ,free_annual_fee_flg -- 免年费标志
    ,vouch_no -- 凭证号码
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_status_cd -- 凭证状态代码
    ,force_deduct_deflt_flg -- 强制扣划导致违约标志
    ,super_acct_id -- 上级账户编号
    ,last_accti_status_cd -- 上一核算状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,effect_dt -- 生效日期
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,belong_org_id -- 所属机构编号
    ,general_storage_flg -- 通存标志
    ,general_exch_flg -- 通兑标志
    ,advise_dep_tenor -- 通知存款期限
    ,part_pric_redt_flg -- 部分本金转存标志
    ,allow_add_pric_flg -- 允许增加本金标志
    ,aldy_pric_redt_cnt -- 已本金转存次数
    ,aldy_pric_int_redt_cnt -- 已本息转存次数
    ,max_pric_redt_cnt -- 最大本金转存次数
    ,max_pric_int_redt_cnt -- 最大本息转存次数
    ,init_prod_id -- 原产品编号
    ,src_module_type_cd -- 源模块类型代码
    ,src_agt_id -- 源协议编号
    ,lmt_flg -- 限制标志
    ,l_six_m_no_tran_flg -- 最近六个月无交易标志
    ,stop_pay_flg -- 止付标志
    ,turn_dormt_acct_dt -- 转不动户日期
    ,auto_payoff_flg -- 自动结清标志
    ,redt_way_type_cd -- 自动转存方式代码
    ,clos_acct_teller_id -- 销户柜员编号
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,status_modif_dt -- 状态变更日期
    ,aldy_check_blklist_flg -- 已检查黑名单标志
    ,ftz_flg -- 自贸区标志
    ,final_tran_dt -- 最后交易日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||P1.INTERNAL_KEY  -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.ACCT_STATUS -- 账户状态代码
    ,nvl(trim(P1.ACCT_CLASS),'-') -- 账户等级代码
    ,nvl(trim(P1.ACCT_PROPERTY2),'-') -- 账户性质类型代码
    ,DECODE(P1.INDIVIDUAL_FLAG,'Y','1','N','0') -- 对私标志
    ,nvl(trim(P1.REASON_CODE),'-') -- 账户用途代码
    ,P1.ACCT_LICENSE_NO -- 账户许可证号码
    ,P1.ACCT_LICENSE_DATE -- 账户许可证签发日期
    ,decode(trim(p1.APPR_FLAG),'','-','Y','1','N','0',p1.APPR_FLAG) -- 账户已复核标志
    ,P1.APPLY_BRANCH -- 账户申请机构编号
    ,decode(P1.ORI_MATURITY_DATE, to_date('0001/01/01','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),P1.ORI_MATURITY_DATE) -- 账户原始到期日期
    ,P1.ORIG_ACCT_OPEN_DATE -- 账户原始开户日期
    ,nvl(triM(P1.ACCT_NATURE),'-') -- 存款账户类型代码
    ,DECODE(P1.LEAD_ACCT_FLAG,'Y','1','N','0') -- 主账户标志
    ,decode(trim(p1.MAIN_INT_FLAG),'','-','Y','1','N','0',p1.MAIN_INT_FLAG) -- 主账户带利息标志
    ,decode(trim(p1.MAIN_BAL_FLAG),'','-','Y','1','N','0',p1.MAIN_BAL_FLAG) -- 主账户带余额标志
    ,DECODE(P1.ACCT_REAL_FLAG,'Y','0','N','1') -- 虚户标志
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.ACCT_CCY -- 币种代码
    ,P1.PROD_TYPE -- 产品编号
    ,P1.AMEND_DATE -- 产品变更日期
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.DOCUMENT_ID -- 证件号码
    ,nvl(trim(P1.DOCUMENT_TYPE),'0000') -- 证件类型代码
    ,nvl(trim(P1.ISS_COUNTRY),'XXX') -- 发证国家代码
    ,decode(trim(p1.MULTI_BAL_TYPE_FLAG),'','-','Y','1','N','0',p1.MULTI_BAL_TYPE_FLAG) -- 多余额标志
    ,nvl(trim(P1.BAL_TYPE),'-') -- 钞汇余额代码
    ,NVL(TRIM(P1.TERM),'0') -- 存款期限
    ,nvl(trim(P1.TERM_TYPE),'-') -- 期限类型代码
    ,NVL(TRIM(P1.CUR_STAGE_NO),0) -- 当前期次
    ,decode(P1.MATURITY_DATE, to_date('0001/01/01','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),P1.MATURITY_DATE) -- 到期日期
    ,nvl(trim(P1.FIXED_CALL),'-') -- 定期账户类型代码
    ,nvl(trim(P1.LAST_MVMT_STATUS),'-') -- 定期账户上一状态代码
    ,P1.OPEN_TRAN_DATE -- 首次交易日期
    ,decode(trim(p1.SETTLE),'','-','Y','1','N','0',p1.SETTLE) -- 结算标志
    ,P1.SETTLE_DATE -- 交易结算日期
    ,P1.SETTLE_USER_ID -- 结算柜员编号
    ,P1.APPR_USER_ID -- 复核柜员编号
    ,P1.APPROVAL_DATE -- 复核日期
    ,nvl(trim(P1.OWNERSHIP_TYPE),'-') -- 归属种类代码
    ,P1.GL_TYPE -- 总账类型代码
    ,nvl(trim(P1.ACCOUNTING_STATUS),'-') -- 核算状态代码
    ,nvl(trim(P1.ACCT_TYPE),'-') -- 核心账户类型代码
    ,P1.APPR_LETTER_NO -- 核准件编号
    ,nvl(trim(P1.XRATE_ID),'-') -- 汇兑方式代码
    ,DECODE(P1.INT_IND_FLAG,'Y','1','N','0') -- 计息标志
    ,P1.USER_ID -- 交易柜员编号
    ,P1.MAIN_PROD_TYPE -- 卡产品编号
    ,P1.CARD_NO -- 卡号
    ,P1.ACCT_OPEN_DATE -- 开户日期
    ,P1.OPEN_USER_ID -- 开户柜员编号
    ,P1.ACCT_BRANCH -- 开户机构编号
    ,P1.SOURCE_TYPE -- 开户渠道编号
    ,P1.ACCT_EXEC -- 客户经理编号
    ,DECODE(P1.OSA_FLAG,'I','1','O','0') -- 离岸标志
    ,decode(P1.JOINT_ACCT_FLAG,'Y','1','N','0',' ','-',P1.JOINT_ACCT_FLAG) -- 联合账户标志
    ,decode(P1.IS_MED_INS_FLAG,'Y','1','N','0',' ','-',P1.IS_MED_INS_FLAG) -- 医保账户标志
    ,decode(P1.IS_SOC_FIN_FLAG,'Y','1','N','0',' ','-',P1.IS_SOC_FIN_FLAG) -- 社保卡下金融账户标志
    ,decode(P1.IS_TRAVEL_CARD_FLAG,'Y','1','N','0',' ','-',P1.IS_TRAVEL_CARD_FLAG) -- 旅行通账户标志
    ,P1.ACCT_DUE_DATE -- 临时户有效日期
    ,P1.TRAVEL_DUE_DATE -- 旅行通卡有效日期
    ,decode(trim(p1.MANAGEMENT_FREE_FLAG),'','-','Y','1','N','0',p1.MANAGEMENT_FREE_FLAG) -- 免年费标志
    ,P1.VOUCHER_START_NO -- 凭证号码
    ,nvl(trim(P1.DOC_TYPE),'-') -- 凭证类型代码
    ,nvl(trim(P1.VOUCHER_STATUS),'-') -- 凭证状态代码
    ,decode(P1.IMPOUND_FAD,'Y','1','N','0',' ','-',P1.IMPOUND_FAD) -- 强制扣划导致违约标志
    ,P1.PARENT_INTERNAL_KEY -- 上级账户编号
    ,nvl(trim(P1.ACCOUNTING_STATUS_PREV),'-') -- 上一核算状态代码
    ,NVL(TRIM(P1.ACCT_STATUS_PREV),'-') -- 上一账户状态代码
    ,P1.EFFECT_DATE -- 生效日期
    ,decode(trim(P1.RECOVER_FLAG),'Y','1','N','0','-') -- 实时追缴标志
    ,P1.HOME_BRANCH -- 所属机构编号
    ,nvl(trim(P1.ALL_DEP_IND),'-') -- 通存标志
    ,nvl(trim(P1.ALL_DRA_IND),'-') -- 通兑标志
    ,NVL(TRIM(P1.NOTICE_PERIOD),0) -- 通知存款期限
    ,decode(trim(p1.PARTIAL_RENEW_ROLL),'','-','Y','1','N','0',p1.PARTIAL_RENEW_ROLL) -- 部分本金转存标志
    ,decode(trim(p1.ADDTL_PRINCIPAL),'','-','Y','1','N','0',p1.ADDTL_PRINCIPAL) -- 允许增加本金标志
    ,P1.TIMES_RENEWED -- 已本金转存次数
    ,P1.TIMES_ROLLEDOVER -- 已本息转存次数
    ,P1.RENEW_NO -- 最大本金转存次数
    ,P1.ROLLOVER_NO -- 最大本息转存次数
    ,P1.OLD_PROD_TYPE -- 原产品编号
    ,P1.SOURCE_MODULE -- 源模块类型代码
    ,P1.AGREEMENT_ID -- 源协议编号
    ,decode(trim(p1.ACCT_RES_STATUS),'','-','Y','1','N','0',p1.ACCT_RES_STATUS) -- 限制标志
    ,decode(trim(p1.NO_TRAN_FLAG),'','-','Y','1','N','0',p1.NO_TRAN_FLAG) -- 最近六个月无交易标志
    ,decode(trim(p1.ACCT_STOP_PAY),'','-','Y','1','N','0',p1.ACCT_STOP_PAY) -- 止付标志
    ,P1.DORMANT_DATE -- 转不动户日期
    ,decode(trim(p1.AUTO_SETTLE_FLAG),'','-','Y','1','N','0',p1.AUTO_SETTLE_FLAG) -- 自动结清标志
    ,nvl(trim(P1.AUTO_RENEW_ROLLOVER),'-') -- 自动转存方式代码
    ,P1.ACCT_CLOSE_USER_ID -- 销户柜员编号
    ,decode(P1.ACCT_CLOSE_DATE,to_date('00010101','yyyymmdd'),to_date('29991231','yyyymmdd'),P1.ACCT_CLOSE_DATE) -- 销户日期
    ,P1.ACCT_CLOSE_REASON -- 销户原因
    ,P1.ACCT_STATUS_UPD_DATE -- 状态变更日期
    ,decode(P1.CHECKED_FLAG,'Y','1','N','0',' ','-',P1.CHECKED_FLAG) -- 已检查黑名单标志
    ,decode(trim(p1.REGION_FLAG),'','-','I','1','O','0',p1.REGION_FLAG) -- 自贸区标志
    ,P1.LAST_TRAN_DATE -- 最后交易日期
    ,P1.LAST_CHANGE_USER_ID -- 最后修改柜员编号
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_acct' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_acct p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.base_acct_no = p8.base_acct_no
   and p8.base_acct_no like '0%'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_RB_ACCT'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_DEP_ACCT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dep_acct_info_h_ncbsf1_tm 
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
        into ${iml_schema}.agt_dep_acct_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,acct_type_cd -- 账户等级代码
    ,acct_char_type_cd -- 账户性质类型代码
    ,priv_flg -- 对私标志
    ,acct_usage_cd -- 账户用途代码
    ,acct_lics_num -- 账户许可证号码
    ,acct_lics_issue_dt -- 账户许可证签发日期
    ,acct_aldy_check_flg -- 账户已复核标志
    ,acct_appl_org_id -- 账户申请机构编号
    ,acct_init_exp_dt -- 账户原始到期日期
    ,acct_init_open_acct_dt -- 账户原始开户日期
    ,acct_attr_cd -- 存款账户类型代码
    ,main_acct_flg -- 主账户标志
    ,main_acct_int_flg -- 主账户带利息标志
    ,main_acct_bal_flg -- 主账户带余额标志
    ,vtual_acct_flg -- 虚户标志
    ,sub_acct_num -- 子账号
    ,curr_cd -- 币种代码
    ,prod_id -- 产品编号
    ,prod_modif_dt -- 产品变更日期
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,cust_type_cd -- 客户类型代码
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cert_cty_cd -- 发证国家代码
    ,multi_bal_flg -- 多余额标志
    ,bal_type_cd -- 钞汇余额代码
    ,dep_term -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,curr_pd -- 当前期次
    ,exp_dt -- 到期日期
    ,reg_acct_type_cd -- 定期账户类型代码
    ,reg_acct_last_status_cd -- 定期账户上一状态代码
    ,fir_tran_dt -- 首次交易日期
    ,stl_flg -- 结算标志
    ,tran_stl_dt -- 交易结算日期
    ,stl_teller_id -- 结算柜员编号
    ,check_teller_id -- 复核柜员编号
    ,check_dt -- 复核日期
    ,belong_kind_cd -- 归属种类代码
    ,gl_type_cd -- 总账类型代码
    ,accti_status_cd -- 核算状态代码
    ,core_acct_type_cd -- 核心账户类型代码
    ,approval_id -- 核准件编号
    ,exch_way_cd -- 汇兑方式代码
    ,int_accr_flg -- 计息标志
    ,tran_teller_id -- 交易柜员编号
    ,card_prod_id -- 卡产品编号
    ,card_no -- 卡号
    ,open_acct_dt -- 开户日期
    ,open_acct_teller_id -- 开户柜员编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_chn_id -- 开户渠道编号
    ,cust_mgr_id -- 客户经理编号
    ,off_shore_flg -- 离岸标志
    ,unite_acct_flg -- 联合账户标志
    ,heat_insu_acct_flg -- 医保账户标志
    ,soci_secu_fin_acct_flg -- 社保卡下金融账户标志
    ,travel_card_flg -- 旅行通账户标志
    ,temp_acct_valid_dt -- 临时户有效日期
    ,travel_card_valid_dt -- 旅行通卡有效日期
    ,free_annual_fee_flg -- 免年费标志
    ,vouch_no -- 凭证号码
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_status_cd -- 凭证状态代码
    ,force_deduct_deflt_flg -- 强制扣划导致违约标志
    ,super_acct_id -- 上级账户编号
    ,last_accti_status_cd -- 上一核算状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,effect_dt -- 生效日期
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,belong_org_id -- 所属机构编号
    ,general_storage_flg -- 通存标志
    ,general_exch_flg -- 通兑标志
    ,advise_dep_tenor -- 通知存款期限
    ,part_pric_redt_flg -- 部分本金转存标志
    ,allow_add_pric_flg -- 允许增加本金标志
    ,aldy_pric_redt_cnt -- 已本金转存次数
    ,aldy_pric_int_redt_cnt -- 已本息转存次数
    ,max_pric_redt_cnt -- 最大本金转存次数
    ,max_pric_int_redt_cnt -- 最大本息转存次数
    ,init_prod_id -- 原产品编号
    ,src_module_type_cd -- 源模块类型代码
    ,src_agt_id -- 源协议编号
    ,lmt_flg -- 限制标志
    ,l_six_m_no_tran_flg -- 最近六个月无交易标志
    ,stop_pay_flg -- 止付标志
    ,turn_dormt_acct_dt -- 转不动户日期
    ,auto_payoff_flg -- 自动结清标志
    ,redt_way_type_cd -- 自动转存方式代码
    ,clos_acct_teller_id -- 销户柜员编号
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,status_modif_dt -- 状态变更日期
    ,aldy_check_blklist_flg -- 已检查黑名单标志
    ,ftz_flg -- 自贸区标志
    ,final_tran_dt -- 最后交易日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,acct_type_cd -- 账户等级代码
    ,acct_char_type_cd -- 账户性质类型代码
    ,priv_flg -- 对私标志
    ,acct_usage_cd -- 账户用途代码
    ,acct_lics_num -- 账户许可证号码
    ,acct_lics_issue_dt -- 账户许可证签发日期
    ,acct_aldy_check_flg -- 账户已复核标志
    ,acct_appl_org_id -- 账户申请机构编号
    ,acct_init_exp_dt -- 账户原始到期日期
    ,acct_init_open_acct_dt -- 账户原始开户日期
    ,acct_attr_cd -- 存款账户类型代码
    ,main_acct_flg -- 主账户标志
    ,main_acct_int_flg -- 主账户带利息标志
    ,main_acct_bal_flg -- 主账户带余额标志
    ,vtual_acct_flg -- 虚户标志
    ,sub_acct_num -- 子账号
    ,curr_cd -- 币种代码
    ,prod_id -- 产品编号
    ,prod_modif_dt -- 产品变更日期
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,cust_type_cd -- 客户类型代码
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cert_cty_cd -- 发证国家代码
    ,multi_bal_flg -- 多余额标志
    ,bal_type_cd -- 钞汇余额代码
    ,dep_term -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,curr_pd -- 当前期次
    ,exp_dt -- 到期日期
    ,reg_acct_type_cd -- 定期账户类型代码
    ,reg_acct_last_status_cd -- 定期账户上一状态代码
    ,fir_tran_dt -- 首次交易日期
    ,stl_flg -- 结算标志
    ,tran_stl_dt -- 交易结算日期
    ,stl_teller_id -- 结算柜员编号
    ,check_teller_id -- 复核柜员编号
    ,check_dt -- 复核日期
    ,belong_kind_cd -- 归属种类代码
    ,gl_type_cd -- 总账类型代码
    ,accti_status_cd -- 核算状态代码
    ,core_acct_type_cd -- 核心账户类型代码
    ,approval_id -- 核准件编号
    ,exch_way_cd -- 汇兑方式代码
    ,int_accr_flg -- 计息标志
    ,tran_teller_id -- 交易柜员编号
    ,card_prod_id -- 卡产品编号
    ,card_no -- 卡号
    ,open_acct_dt -- 开户日期
    ,open_acct_teller_id -- 开户柜员编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_chn_id -- 开户渠道编号
    ,cust_mgr_id -- 客户经理编号
    ,off_shore_flg -- 离岸标志
    ,unite_acct_flg -- 联合账户标志
    ,heat_insu_acct_flg -- 医保账户标志
    ,soci_secu_fin_acct_flg -- 社保卡下金融账户标志
    ,travel_card_flg -- 旅行通账户标志
    ,temp_acct_valid_dt -- 临时户有效日期
    ,travel_card_valid_dt -- 旅行通卡有效日期
    ,free_annual_fee_flg -- 免年费标志
    ,vouch_no -- 凭证号码
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_status_cd -- 凭证状态代码
    ,force_deduct_deflt_flg -- 强制扣划导致违约标志
    ,super_acct_id -- 上级账户编号
    ,last_accti_status_cd -- 上一核算状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,effect_dt -- 生效日期
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,belong_org_id -- 所属机构编号
    ,general_storage_flg -- 通存标志
    ,general_exch_flg -- 通兑标志
    ,advise_dep_tenor -- 通知存款期限
    ,part_pric_redt_flg -- 部分本金转存标志
    ,allow_add_pric_flg -- 允许增加本金标志
    ,aldy_pric_redt_cnt -- 已本金转存次数
    ,aldy_pric_int_redt_cnt -- 已本息转存次数
    ,max_pric_redt_cnt -- 最大本金转存次数
    ,max_pric_int_redt_cnt -- 最大本息转存次数
    ,init_prod_id -- 原产品编号
    ,src_module_type_cd -- 源模块类型代码
    ,src_agt_id -- 源协议编号
    ,lmt_flg -- 限制标志
    ,l_six_m_no_tran_flg -- 最近六个月无交易标志
    ,stop_pay_flg -- 止付标志
    ,turn_dormt_acct_dt -- 转不动户日期
    ,auto_payoff_flg -- 自动结清标志
    ,redt_way_type_cd -- 自动转存方式代码
    ,clos_acct_teller_id -- 销户柜员编号
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,status_modif_dt -- 状态变更日期
    ,aldy_check_blklist_flg -- 已检查黑名单标志
    ,ftz_flg -- 自贸区标志
    ,final_tran_dt -- 最后交易日期
    ,final_modif_teller_id -- 最后修改柜员编号
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
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户等级代码
    ,nvl(n.acct_char_type_cd, o.acct_char_type_cd) as acct_char_type_cd -- 账户性质类型代码
    ,nvl(n.priv_flg, o.priv_flg) as priv_flg -- 对私标志
    ,nvl(n.acct_usage_cd, o.acct_usage_cd) as acct_usage_cd -- 账户用途代码
    ,nvl(n.acct_lics_num, o.acct_lics_num) as acct_lics_num -- 账户许可证号码
    ,nvl(n.acct_lics_issue_dt, o.acct_lics_issue_dt) as acct_lics_issue_dt -- 账户许可证签发日期
    ,nvl(n.acct_aldy_check_flg, o.acct_aldy_check_flg) as acct_aldy_check_flg -- 账户已复核标志
    ,nvl(n.acct_appl_org_id, o.acct_appl_org_id) as acct_appl_org_id -- 账户申请机构编号
    ,nvl(n.acct_init_exp_dt, o.acct_init_exp_dt) as acct_init_exp_dt -- 账户原始到期日期
    ,nvl(n.acct_init_open_acct_dt, o.acct_init_open_acct_dt) as acct_init_open_acct_dt -- 账户原始开户日期
    ,nvl(n.acct_attr_cd, o.acct_attr_cd) as acct_attr_cd -- 存款账户类型代码
    ,nvl(n.main_acct_flg, o.main_acct_flg) as main_acct_flg -- 主账户标志
    ,nvl(n.main_acct_int_flg, o.main_acct_int_flg) as main_acct_int_flg -- 主账户带利息标志
    ,nvl(n.main_acct_bal_flg, o.main_acct_bal_flg) as main_acct_bal_flg -- 主账户带余额标志
    ,nvl(n.vtual_acct_flg, o.vtual_acct_flg) as vtual_acct_flg -- 虚户标志
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.prod_modif_dt, o.prod_modif_dt) as prod_modif_dt -- 产品变更日期
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_cty_cd, o.cert_cty_cd) as cert_cty_cd -- 发证国家代码
    ,nvl(n.multi_bal_flg, o.multi_bal_flg) as multi_bal_flg -- 多余额标志
    ,nvl(n.bal_type_cd, o.bal_type_cd) as bal_type_cd -- 钞汇余额代码
    ,nvl(n.dep_term, o.dep_term) as dep_term -- 存款期限
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.curr_pd, o.curr_pd) as curr_pd -- 当前期次
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.reg_acct_type_cd, o.reg_acct_type_cd) as reg_acct_type_cd -- 定期账户类型代码
    ,nvl(n.reg_acct_last_status_cd, o.reg_acct_last_status_cd) as reg_acct_last_status_cd -- 定期账户上一状态代码
    ,nvl(n.fir_tran_dt, o.fir_tran_dt) as fir_tran_dt -- 首次交易日期
    ,nvl(n.stl_flg, o.stl_flg) as stl_flg -- 结算标志
    ,nvl(n.tran_stl_dt, o.tran_stl_dt) as tran_stl_dt -- 交易结算日期
    ,nvl(n.stl_teller_id, o.stl_teller_id) as stl_teller_id -- 结算柜员编号
    ,nvl(n.check_teller_id, o.check_teller_id) as check_teller_id -- 复核柜员编号
    ,nvl(n.check_dt, o.check_dt) as check_dt -- 复核日期
    ,nvl(n.belong_kind_cd, o.belong_kind_cd) as belong_kind_cd -- 归属种类代码
    ,nvl(n.gl_type_cd, o.gl_type_cd) as gl_type_cd -- 总账类型代码
    ,nvl(n.accti_status_cd, o.accti_status_cd) as accti_status_cd -- 核算状态代码
    ,nvl(n.core_acct_type_cd, o.core_acct_type_cd) as core_acct_type_cd -- 核心账户类型代码
    ,nvl(n.approval_id, o.approval_id) as approval_id -- 核准件编号
    ,nvl(n.exch_way_cd, o.exch_way_cd) as exch_way_cd -- 汇兑方式代码
    ,nvl(n.int_accr_flg, o.int_accr_flg) as int_accr_flg -- 计息标志
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.card_prod_id, o.card_prod_id) as card_prod_id -- 卡产品编号
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.open_acct_dt, o.open_acct_dt) as open_acct_dt -- 开户日期
    ,nvl(n.open_acct_teller_id, o.open_acct_teller_id) as open_acct_teller_id -- 开户柜员编号
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.open_acct_chn_id, o.open_acct_chn_id) as open_acct_chn_id -- 开户渠道编号
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.off_shore_flg, o.off_shore_flg) as off_shore_flg -- 离岸标志
    ,nvl(n.unite_acct_flg, o.unite_acct_flg) as unite_acct_flg -- 联合账户标志
    ,nvl(n.heat_insu_acct_flg, o.heat_insu_acct_flg) as heat_insu_acct_flg -- 医保账户标志
    ,nvl(n.soci_secu_fin_acct_flg, o.soci_secu_fin_acct_flg) as soci_secu_fin_acct_flg -- 社保卡下金融账户标志
    ,nvl(n.travel_card_flg, o.travel_card_flg) as travel_card_flg -- 旅行通账户标志
    ,nvl(n.temp_acct_valid_dt, o.temp_acct_valid_dt) as temp_acct_valid_dt -- 临时户有效日期
    ,nvl(n.travel_card_valid_dt, o.travel_card_valid_dt) as travel_card_valid_dt -- 旅行通卡有效日期
    ,nvl(n.free_annual_fee_flg, o.free_annual_fee_flg) as free_annual_fee_flg -- 免年费标志
    ,nvl(n.vouch_no, o.vouch_no) as vouch_no -- 凭证号码
    ,nvl(n.vouch_type_cd, o.vouch_type_cd) as vouch_type_cd -- 凭证类型代码
    ,nvl(n.vouch_status_cd, o.vouch_status_cd) as vouch_status_cd -- 凭证状态代码
    ,nvl(n.force_deduct_deflt_flg, o.force_deduct_deflt_flg) as force_deduct_deflt_flg -- 强制扣划导致违约标志
    ,nvl(n.super_acct_id, o.super_acct_id) as super_acct_id -- 上级账户编号
    ,nvl(n.last_accti_status_cd, o.last_accti_status_cd) as last_accti_status_cd -- 上一核算状态代码
    ,nvl(n.last_acct_status_cd, o.last_acct_status_cd) as last_acct_status_cd -- 上一账户状态代码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.realtm_chase_capt_flg, o.realtm_chase_capt_flg) as realtm_chase_capt_flg -- 实时追缴标志
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.general_storage_flg, o.general_storage_flg) as general_storage_flg -- 通存标志
    ,nvl(n.general_exch_flg, o.general_exch_flg) as general_exch_flg -- 通兑标志
    ,nvl(n.advise_dep_tenor, o.advise_dep_tenor) as advise_dep_tenor -- 通知存款期限
    ,nvl(n.part_pric_redt_flg, o.part_pric_redt_flg) as part_pric_redt_flg -- 部分本金转存标志
    ,nvl(n.allow_add_pric_flg, o.allow_add_pric_flg) as allow_add_pric_flg -- 允许增加本金标志
    ,nvl(n.aldy_pric_redt_cnt, o.aldy_pric_redt_cnt) as aldy_pric_redt_cnt -- 已本金转存次数
    ,nvl(n.aldy_pric_int_redt_cnt, o.aldy_pric_int_redt_cnt) as aldy_pric_int_redt_cnt -- 已本息转存次数
    ,nvl(n.max_pric_redt_cnt, o.max_pric_redt_cnt) as max_pric_redt_cnt -- 最大本金转存次数
    ,nvl(n.max_pric_int_redt_cnt, o.max_pric_int_redt_cnt) as max_pric_int_redt_cnt -- 最大本息转存次数
    ,nvl(n.init_prod_id, o.init_prod_id) as init_prod_id -- 原产品编号
    ,nvl(n.src_module_type_cd, o.src_module_type_cd) as src_module_type_cd -- 源模块类型代码
    ,nvl(n.src_agt_id, o.src_agt_id) as src_agt_id -- 源协议编号
    ,nvl(n.lmt_flg, o.lmt_flg) as lmt_flg -- 限制标志
    ,nvl(n.l_six_m_no_tran_flg, o.l_six_m_no_tran_flg) as l_six_m_no_tran_flg -- 最近六个月无交易标志
    ,nvl(n.stop_pay_flg, o.stop_pay_flg) as stop_pay_flg -- 止付标志
    ,nvl(n.turn_dormt_acct_dt, o.turn_dormt_acct_dt) as turn_dormt_acct_dt -- 转不动户日期
    ,nvl(n.auto_payoff_flg, o.auto_payoff_flg) as auto_payoff_flg -- 自动结清标志
    ,nvl(n.redt_way_type_cd, o.redt_way_type_cd) as redt_way_type_cd -- 自动转存方式代码
    ,nvl(n.clos_acct_teller_id, o.clos_acct_teller_id) as clos_acct_teller_id -- 销户柜员编号
    ,nvl(n.clos_acct_dt, o.clos_acct_dt) as clos_acct_dt -- 销户日期
    ,nvl(n.clos_acct_rs, o.clos_acct_rs) as clos_acct_rs -- 销户原因
    ,nvl(n.status_modif_dt, o.status_modif_dt) as status_modif_dt -- 状态变更日期
    ,nvl(n.aldy_check_blklist_flg, o.aldy_check_blklist_flg) as aldy_check_blklist_flg -- 已检查黑名单标志
    ,nvl(n.ftz_flg, o.ftz_flg) as ftz_flg -- 自贸区标志
    ,nvl(n.final_tran_dt, o.final_tran_dt) as final_tran_dt -- 最后交易日期
    ,nvl(n.final_modif_teller_id, o.final_modif_teller_id) as final_modif_teller_id -- 最后修改柜员编号
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
from ${iml_schema}.agt_dep_acct_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_dep_acct_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.acct_name <> n.acct_name
        or o.acct_status_cd <> n.acct_status_cd
        or o.acct_type_cd <> n.acct_type_cd
        or o.acct_char_type_cd <> n.acct_char_type_cd
        or o.priv_flg <> n.priv_flg
        or o.acct_usage_cd <> n.acct_usage_cd
        or o.acct_lics_num <> n.acct_lics_num
        or o.acct_lics_issue_dt <> n.acct_lics_issue_dt
        or o.acct_aldy_check_flg <> n.acct_aldy_check_flg
        or o.acct_appl_org_id <> n.acct_appl_org_id
        or o.acct_init_exp_dt <> n.acct_init_exp_dt
        or o.acct_init_open_acct_dt <> n.acct_init_open_acct_dt
        or o.acct_attr_cd <> n.acct_attr_cd
        or o.main_acct_flg <> n.main_acct_flg
        or o.main_acct_int_flg <> n.main_acct_int_flg
        or o.main_acct_bal_flg <> n.main_acct_bal_flg
        or o.vtual_acct_flg <> n.vtual_acct_flg
        or o.sub_acct_num <> n.sub_acct_num
        or o.curr_cd <> n.curr_cd
        or o.prod_id <> n.prod_id
        or o.prod_modif_dt <> n.prod_modif_dt
        or o.cust_id <> n.cust_id
        or o.cust_acct_num <> n.cust_acct_num
        or o.cust_type_cd <> n.cust_type_cd
        or o.cert_no <> n.cert_no
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_cty_cd <> n.cert_cty_cd
        or o.multi_bal_flg <> n.multi_bal_flg
        or o.bal_type_cd <> n.bal_type_cd
        or o.dep_term <> n.dep_term
        or o.tenor_type_cd <> n.tenor_type_cd
        or o.curr_pd <> n.curr_pd
        or o.exp_dt <> n.exp_dt
        or o.reg_acct_type_cd <> n.reg_acct_type_cd
        or o.reg_acct_last_status_cd <> n.reg_acct_last_status_cd
        or o.fir_tran_dt <> n.fir_tran_dt
        or o.stl_flg <> n.stl_flg
        or o.tran_stl_dt <> n.tran_stl_dt
        or o.stl_teller_id <> n.stl_teller_id
        or o.check_teller_id <> n.check_teller_id
        or o.check_dt <> n.check_dt
        or o.belong_kind_cd <> n.belong_kind_cd
        or o.gl_type_cd <> n.gl_type_cd
        or o.accti_status_cd <> n.accti_status_cd
        or o.core_acct_type_cd <> n.core_acct_type_cd
        or o.approval_id <> n.approval_id
        or o.exch_way_cd <> n.exch_way_cd
        or o.int_accr_flg <> n.int_accr_flg
        or o.tran_teller_id <> n.tran_teller_id
        or o.card_prod_id <> n.card_prod_id
        or o.card_no <> n.card_no
        or o.open_acct_dt <> n.open_acct_dt
        or o.open_acct_teller_id <> n.open_acct_teller_id
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.open_acct_chn_id <> n.open_acct_chn_id
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.off_shore_flg <> n.off_shore_flg
        or o.unite_acct_flg <> n.unite_acct_flg
        or o.heat_insu_acct_flg <> n.heat_insu_acct_flg
        or o.soci_secu_fin_acct_flg <> n.soci_secu_fin_acct_flg
        or o.travel_card_flg <> n.travel_card_flg
        or o.temp_acct_valid_dt <> n.temp_acct_valid_dt
        or o.travel_card_valid_dt <> n.travel_card_valid_dt
        or o.free_annual_fee_flg <> n.free_annual_fee_flg
        or o.vouch_no <> n.vouch_no
        or o.vouch_type_cd <> n.vouch_type_cd
        or o.vouch_status_cd <> n.vouch_status_cd
        or o.force_deduct_deflt_flg <> n.force_deduct_deflt_flg
        or o.super_acct_id <> n.super_acct_id
        or o.last_accti_status_cd <> n.last_accti_status_cd
        or o.last_acct_status_cd <> n.last_acct_status_cd
        or o.effect_dt <> n.effect_dt
        or o.realtm_chase_capt_flg <> n.realtm_chase_capt_flg
        or o.belong_org_id <> n.belong_org_id
        or o.general_storage_flg <> n.general_storage_flg
        or o.general_exch_flg <> n.general_exch_flg
        or o.advise_dep_tenor <> n.advise_dep_tenor
        or o.part_pric_redt_flg <> n.part_pric_redt_flg
        or o.allow_add_pric_flg <> n.allow_add_pric_flg
        or o.aldy_pric_redt_cnt <> n.aldy_pric_redt_cnt
        or o.aldy_pric_int_redt_cnt <> n.aldy_pric_int_redt_cnt
        or o.max_pric_redt_cnt <> n.max_pric_redt_cnt
        or o.max_pric_int_redt_cnt <> n.max_pric_int_redt_cnt
        or o.init_prod_id <> n.init_prod_id
        or o.src_module_type_cd <> n.src_module_type_cd
        or o.src_agt_id <> n.src_agt_id
        or o.lmt_flg <> n.lmt_flg
        or o.l_six_m_no_tran_flg <> n.l_six_m_no_tran_flg
        or o.stop_pay_flg <> n.stop_pay_flg
        or o.turn_dormt_acct_dt <> n.turn_dormt_acct_dt
        or o.auto_payoff_flg <> n.auto_payoff_flg
        or o.redt_way_type_cd <> n.redt_way_type_cd
        or o.clos_acct_teller_id <> n.clos_acct_teller_id
        or o.clos_acct_dt <> n.clos_acct_dt
        or o.clos_acct_rs <> n.clos_acct_rs
        or o.status_modif_dt <> n.status_modif_dt
        or o.aldy_check_blklist_flg <> n.aldy_check_blklist_flg
        or o.ftz_flg <> n.ftz_flg
        or o.final_tran_dt <> n.final_tran_dt
        or o.final_modif_teller_id <> n.final_modif_teller_id
        or o.final_modif_dt <> n.final_modif_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dep_acct_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,acct_type_cd -- 账户等级代码
    ,acct_char_type_cd -- 账户性质类型代码
    ,priv_flg -- 对私标志
    ,acct_usage_cd -- 账户用途代码
    ,acct_lics_num -- 账户许可证号码
    ,acct_lics_issue_dt -- 账户许可证签发日期
    ,acct_aldy_check_flg -- 账户已复核标志
    ,acct_appl_org_id -- 账户申请机构编号
    ,acct_init_exp_dt -- 账户原始到期日期
    ,acct_init_open_acct_dt -- 账户原始开户日期
    ,acct_attr_cd -- 存款账户类型代码
    ,main_acct_flg -- 主账户标志
    ,main_acct_int_flg -- 主账户带利息标志
    ,main_acct_bal_flg -- 主账户带余额标志
    ,vtual_acct_flg -- 虚户标志
    ,sub_acct_num -- 子账号
    ,curr_cd -- 币种代码
    ,prod_id -- 产品编号
    ,prod_modif_dt -- 产品变更日期
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,cust_type_cd -- 客户类型代码
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cert_cty_cd -- 发证国家代码
    ,multi_bal_flg -- 多余额标志
    ,bal_type_cd -- 钞汇余额代码
    ,dep_term -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,curr_pd -- 当前期次
    ,exp_dt -- 到期日期
    ,reg_acct_type_cd -- 定期账户类型代码
    ,reg_acct_last_status_cd -- 定期账户上一状态代码
    ,fir_tran_dt -- 首次交易日期
    ,stl_flg -- 结算标志
    ,tran_stl_dt -- 交易结算日期
    ,stl_teller_id -- 结算柜员编号
    ,check_teller_id -- 复核柜员编号
    ,check_dt -- 复核日期
    ,belong_kind_cd -- 归属种类代码
    ,gl_type_cd -- 总账类型代码
    ,accti_status_cd -- 核算状态代码
    ,core_acct_type_cd -- 核心账户类型代码
    ,approval_id -- 核准件编号
    ,exch_way_cd -- 汇兑方式代码
    ,int_accr_flg -- 计息标志
    ,tran_teller_id -- 交易柜员编号
    ,card_prod_id -- 卡产品编号
    ,card_no -- 卡号
    ,open_acct_dt -- 开户日期
    ,open_acct_teller_id -- 开户柜员编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_chn_id -- 开户渠道编号
    ,cust_mgr_id -- 客户经理编号
    ,off_shore_flg -- 离岸标志
    ,unite_acct_flg -- 联合账户标志
    ,heat_insu_acct_flg -- 医保账户标志
    ,soci_secu_fin_acct_flg -- 社保卡下金融账户标志
    ,travel_card_flg -- 旅行通账户标志
    ,temp_acct_valid_dt -- 临时户有效日期
    ,travel_card_valid_dt -- 旅行通卡有效日期
    ,free_annual_fee_flg -- 免年费标志
    ,vouch_no -- 凭证号码
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_status_cd -- 凭证状态代码
    ,force_deduct_deflt_flg -- 强制扣划导致违约标志
    ,super_acct_id -- 上级账户编号
    ,last_accti_status_cd -- 上一核算状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,effect_dt -- 生效日期
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,belong_org_id -- 所属机构编号
    ,general_storage_flg -- 通存标志
    ,general_exch_flg -- 通兑标志
    ,advise_dep_tenor -- 通知存款期限
    ,part_pric_redt_flg -- 部分本金转存标志
    ,allow_add_pric_flg -- 允许增加本金标志
    ,aldy_pric_redt_cnt -- 已本金转存次数
    ,aldy_pric_int_redt_cnt -- 已本息转存次数
    ,max_pric_redt_cnt -- 最大本金转存次数
    ,max_pric_int_redt_cnt -- 最大本息转存次数
    ,init_prod_id -- 原产品编号
    ,src_module_type_cd -- 源模块类型代码
    ,src_agt_id -- 源协议编号
    ,lmt_flg -- 限制标志
    ,l_six_m_no_tran_flg -- 最近六个月无交易标志
    ,stop_pay_flg -- 止付标志
    ,turn_dormt_acct_dt -- 转不动户日期
    ,auto_payoff_flg -- 自动结清标志
    ,redt_way_type_cd -- 自动转存方式代码
    ,clos_acct_teller_id -- 销户柜员编号
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,status_modif_dt -- 状态变更日期
    ,aldy_check_blklist_flg -- 已检查黑名单标志
    ,ftz_flg -- 自贸区标志
    ,final_tran_dt -- 最后交易日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,acct_type_cd -- 账户等级代码
    ,acct_char_type_cd -- 账户性质类型代码
    ,priv_flg -- 对私标志
    ,acct_usage_cd -- 账户用途代码
    ,acct_lics_num -- 账户许可证号码
    ,acct_lics_issue_dt -- 账户许可证签发日期
    ,acct_aldy_check_flg -- 账户已复核标志
    ,acct_appl_org_id -- 账户申请机构编号
    ,acct_init_exp_dt -- 账户原始到期日期
    ,acct_init_open_acct_dt -- 账户原始开户日期
    ,acct_attr_cd -- 存款账户类型代码
    ,main_acct_flg -- 主账户标志
    ,main_acct_int_flg -- 主账户带利息标志
    ,main_acct_bal_flg -- 主账户带余额标志
    ,vtual_acct_flg -- 虚户标志
    ,sub_acct_num -- 子账号
    ,curr_cd -- 币种代码
    ,prod_id -- 产品编号
    ,prod_modif_dt -- 产品变更日期
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,cust_type_cd -- 客户类型代码
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cert_cty_cd -- 发证国家代码
    ,multi_bal_flg -- 多余额标志
    ,bal_type_cd -- 钞汇余额代码
    ,dep_term -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,curr_pd -- 当前期次
    ,exp_dt -- 到期日期
    ,reg_acct_type_cd -- 定期账户类型代码
    ,reg_acct_last_status_cd -- 定期账户上一状态代码
    ,fir_tran_dt -- 首次交易日期
    ,stl_flg -- 结算标志
    ,tran_stl_dt -- 交易结算日期
    ,stl_teller_id -- 结算柜员编号
    ,check_teller_id -- 复核柜员编号
    ,check_dt -- 复核日期
    ,belong_kind_cd -- 归属种类代码
    ,gl_type_cd -- 总账类型代码
    ,accti_status_cd -- 核算状态代码
    ,core_acct_type_cd -- 核心账户类型代码
    ,approval_id -- 核准件编号
    ,exch_way_cd -- 汇兑方式代码
    ,int_accr_flg -- 计息标志
    ,tran_teller_id -- 交易柜员编号
    ,card_prod_id -- 卡产品编号
    ,card_no -- 卡号
    ,open_acct_dt -- 开户日期
    ,open_acct_teller_id -- 开户柜员编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_chn_id -- 开户渠道编号
    ,cust_mgr_id -- 客户经理编号
    ,off_shore_flg -- 离岸标志
    ,unite_acct_flg -- 联合账户标志
    ,heat_insu_acct_flg -- 医保账户标志
    ,soci_secu_fin_acct_flg -- 社保卡下金融账户标志
    ,travel_card_flg -- 旅行通账户标志
    ,temp_acct_valid_dt -- 临时户有效日期
    ,travel_card_valid_dt -- 旅行通卡有效日期
    ,free_annual_fee_flg -- 免年费标志
    ,vouch_no -- 凭证号码
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_status_cd -- 凭证状态代码
    ,force_deduct_deflt_flg -- 强制扣划导致违约标志
    ,super_acct_id -- 上级账户编号
    ,last_accti_status_cd -- 上一核算状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,effect_dt -- 生效日期
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,belong_org_id -- 所属机构编号
    ,general_storage_flg -- 通存标志
    ,general_exch_flg -- 通兑标志
    ,advise_dep_tenor -- 通知存款期限
    ,part_pric_redt_flg -- 部分本金转存标志
    ,allow_add_pric_flg -- 允许增加本金标志
    ,aldy_pric_redt_cnt -- 已本金转存次数
    ,aldy_pric_int_redt_cnt -- 已本息转存次数
    ,max_pric_redt_cnt -- 最大本金转存次数
    ,max_pric_int_redt_cnt -- 最大本息转存次数
    ,init_prod_id -- 原产品编号
    ,src_module_type_cd -- 源模块类型代码
    ,src_agt_id -- 源协议编号
    ,lmt_flg -- 限制标志
    ,l_six_m_no_tran_flg -- 最近六个月无交易标志
    ,stop_pay_flg -- 止付标志
    ,turn_dormt_acct_dt -- 转不动户日期
    ,auto_payoff_flg -- 自动结清标志
    ,redt_way_type_cd -- 自动转存方式代码
    ,clos_acct_teller_id -- 销户柜员编号
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,status_modif_dt -- 状态变更日期
    ,aldy_check_blklist_flg -- 已检查黑名单标志
    ,ftz_flg -- 自贸区标志
    ,final_tran_dt -- 最后交易日期
    ,final_modif_teller_id -- 最后修改柜员编号
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
    ,o.acct_name -- 账户名称
    ,o.acct_status_cd -- 账户状态代码
    ,o.acct_type_cd -- 账户等级代码
    ,o.acct_char_type_cd -- 账户性质类型代码
    ,o.priv_flg -- 对私标志
    ,o.acct_usage_cd -- 账户用途代码
    ,o.acct_lics_num -- 账户许可证号码
    ,o.acct_lics_issue_dt -- 账户许可证签发日期
    ,o.acct_aldy_check_flg -- 账户已复核标志
    ,o.acct_appl_org_id -- 账户申请机构编号
    ,o.acct_init_exp_dt -- 账户原始到期日期
    ,o.acct_init_open_acct_dt -- 账户原始开户日期
    ,o.acct_attr_cd -- 存款账户类型代码
    ,o.main_acct_flg -- 主账户标志
    ,o.main_acct_int_flg -- 主账户带利息标志
    ,o.main_acct_bal_flg -- 主账户带余额标志
    ,o.vtual_acct_flg -- 虚户标志
    ,o.sub_acct_num -- 子账号
    ,o.curr_cd -- 币种代码
    ,o.prod_id -- 产品编号
    ,o.prod_modif_dt -- 产品变更日期
    ,o.cust_id -- 客户编号
    ,o.cust_acct_num -- 客户账号
    ,o.cust_type_cd -- 客户类型代码
    ,o.cert_no -- 证件号码
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_cty_cd -- 发证国家代码
    ,o.multi_bal_flg -- 多余额标志
    ,o.bal_type_cd -- 钞汇余额代码
    ,o.dep_term -- 存款期限
    ,o.tenor_type_cd -- 期限类型代码
    ,o.curr_pd -- 当前期次
    ,o.exp_dt -- 到期日期
    ,o.reg_acct_type_cd -- 定期账户类型代码
    ,o.reg_acct_last_status_cd -- 定期账户上一状态代码
    ,o.fir_tran_dt -- 首次交易日期
    ,o.stl_flg -- 结算标志
    ,o.tran_stl_dt -- 交易结算日期
    ,o.stl_teller_id -- 结算柜员编号
    ,o.check_teller_id -- 复核柜员编号
    ,o.check_dt -- 复核日期
    ,o.belong_kind_cd -- 归属种类代码
    ,o.gl_type_cd -- 总账类型代码
    ,o.accti_status_cd -- 核算状态代码
    ,o.core_acct_type_cd -- 核心账户类型代码
    ,o.approval_id -- 核准件编号
    ,o.exch_way_cd -- 汇兑方式代码
    ,o.int_accr_flg -- 计息标志
    ,o.tran_teller_id -- 交易柜员编号
    ,o.card_prod_id -- 卡产品编号
    ,o.card_no -- 卡号
    ,o.open_acct_dt -- 开户日期
    ,o.open_acct_teller_id -- 开户柜员编号
    ,o.open_acct_org_id -- 开户机构编号
    ,o.open_acct_chn_id -- 开户渠道编号
    ,o.cust_mgr_id -- 客户经理编号
    ,o.off_shore_flg -- 离岸标志
    ,o.unite_acct_flg -- 联合账户标志
    ,o.heat_insu_acct_flg -- 医保账户标志
    ,o.soci_secu_fin_acct_flg -- 社保卡下金融账户标志
    ,o.travel_card_flg -- 旅行通账户标志
    ,o.temp_acct_valid_dt -- 临时户有效日期
    ,o.travel_card_valid_dt -- 旅行通卡有效日期
    ,o.free_annual_fee_flg -- 免年费标志
    ,o.vouch_no -- 凭证号码
    ,o.vouch_type_cd -- 凭证类型代码
    ,o.vouch_status_cd -- 凭证状态代码
    ,o.force_deduct_deflt_flg -- 强制扣划导致违约标志
    ,o.super_acct_id -- 上级账户编号
    ,o.last_accti_status_cd -- 上一核算状态代码
    ,o.last_acct_status_cd -- 上一账户状态代码
    ,o.effect_dt -- 生效日期
    ,o.realtm_chase_capt_flg -- 实时追缴标志
    ,o.belong_org_id -- 所属机构编号
    ,o.general_storage_flg -- 通存标志
    ,o.general_exch_flg -- 通兑标志
    ,o.advise_dep_tenor -- 通知存款期限
    ,o.part_pric_redt_flg -- 部分本金转存标志
    ,o.allow_add_pric_flg -- 允许增加本金标志
    ,o.aldy_pric_redt_cnt -- 已本金转存次数
    ,o.aldy_pric_int_redt_cnt -- 已本息转存次数
    ,o.max_pric_redt_cnt -- 最大本金转存次数
    ,o.max_pric_int_redt_cnt -- 最大本息转存次数
    ,o.init_prod_id -- 原产品编号
    ,o.src_module_type_cd -- 源模块类型代码
    ,o.src_agt_id -- 源协议编号
    ,o.lmt_flg -- 限制标志
    ,o.l_six_m_no_tran_flg -- 最近六个月无交易标志
    ,o.stop_pay_flg -- 止付标志
    ,o.turn_dormt_acct_dt -- 转不动户日期
    ,o.auto_payoff_flg -- 自动结清标志
    ,o.redt_way_type_cd -- 自动转存方式代码
    ,o.clos_acct_teller_id -- 销户柜员编号
    ,o.clos_acct_dt -- 销户日期
    ,o.clos_acct_rs -- 销户原因
    ,o.status_modif_dt -- 状态变更日期
    ,o.aldy_check_blklist_flg -- 已检查黑名单标志
    ,o.ftz_flg -- 自贸区标志
    ,o.final_tran_dt -- 最后交易日期
    ,o.final_modif_teller_id -- 最后修改柜员编号
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
from ${iml_schema}.agt_dep_acct_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_dep_acct_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_dep_acct_info_h_ncbsf1_cl d
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
--truncate table ${iml_schema}.agt_dep_acct_info_h;
--alter table ${iml_schema}.agt_dep_acct_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_dep_acct_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_dep_acct_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_dep_acct_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_dep_acct_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_dep_acct_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_dep_acct_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_dep_acct_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dep_acct_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dep_acct_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_dep_acct_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dep_acct_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
