/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dep_acct_assis_info_h_ncbsf1
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
alter table ${iml_schema}.agt_dep_acct_assis_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_assis_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,pcp_de_int_flag -- 产品细类代码
    ,cls_prod_id -- 分类产品编号
    ,inside_acct_char_cd -- 内部账户性质代码
    ,acct_char_cd -- 外汇账户性质代码
    ,acct_vrif_status_cd -- 账户核实状态代码
    ,last_acct_vrif_status_cd -- 上一账户核实状态代码
    ,acct_chn_idf_cd -- 账户渠道标识代码
    ,acct_bal_dir_cd -- 账户余额方向代码
    ,bal_update_type_cd -- 余额更新类型代码
    ,bal_linkg_chg_flg -- 余额联动变动标志
    ,accrd_freq_pay_int_flg -- 按频率付息标志
    ,tax_rat -- 税率
    ,ped -- 周期
    ,ped_corp_cd -- 周期单位代码
    ,sign_prod_cls_cd -- 签约产品分类代码
    ,sign_agt_id -- 签约协议编号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,dep_char_cd -- 存款性质代码
    ,agt_dep_type_cd -- 协议存款类型代码
    ,cap_char -- 资金性质
    ,pd_cd -- 期次编号
    ,verify_type_cd -- 查证类型代码
    ,verify_amt -- 查证金额
    ,disp_way_cd -- 处置方式代码
    ,st_msg_sign_status_cd -- 短信签约状态代码
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_acct_num -- 对手账号
    ,cntpty_acct_num_name -- 对手账号名称
    ,cntpty_acct_open_bank_name -- 对手账户开户行名称
    ,cntpty_acct_open_acct_org_id -- 对手账户开户机构编号
    ,cntpty_acct_open_acct_dt -- 对手账户开户日期
    ,cntpty_bk_open_acct_org_belong_dist_cd -- 对手行开户机构所属行政区域代码
    ,cntpty_bank_belong_cty_rg_cd -- 对手行所属国家和地区代码
    ,non_i_class_acct_check_status_cd -- 非I类户验证状态代码
    ,suspd_wrtoff_flg -- 挂销账标志
    ,on_acct_tenor -- 挂账期限
    ,supv_flg -- 监管标志
    ,supv_type_cd -- 监管类型代码
    ,supv_content_descb -- 监管内容描述
    ,open_acct_way_cd -- 开户方式代码
    ,open_type_cd -- 开立类型代码
    ,remote_open_acct_flg -- 异地开户标志
    ,open_acct_city -- 开户城市
    ,open_acct_prov -- 开户省份
    ,can_od_flg -- 可透支标志
    ,acm_can_wdraw_pric_amt -- 累计可支取本金金额
    ,int_tax_impose_flg -- 利息税征收标志
    ,onl_flg -- 联机标志
    ,final_blklist_dt -- 最后黑名单日期
    ,blklist_status_cd -- 黑名单状态代码
    ,legal_flg -- 涉案标志
    ,legal_dt -- 涉案日期
    ,legal_rs_descb -- 涉案原因描述
    ,apv_odd_no -- 审批单号
    ,general_exch_org_id -- 通兑机构编号
    ,clos_acct_reop_dt -- 销户重开日期
    ,wrtoff_way_cd -- 销账方式代码
    ,check_fail_rs_descb -- 验证失败原因描述
    ,cert_as_flg -- 证件年检标志
    ,aldy_as_flg -- 已年检标志
    ,last_as_closing_dt -- 上一年检截止日期
    ,last_as_reset_dt -- 上一年检重置日期
    ,bank_inter_id -- 银行国际编号
    ,privavy_acct_flg -- 隐私账户标志
    ,earliest_wdraw_dt -- 最早可支取日期
    ,unexp_draw_dt -- 提前支取日期
    ,precon_payoff_day -- 预约结清日
    ,allow_sell_check_flg -- 允许出售支票标志
    ,allow_cnter_cross_bank_depot_permit_flg -- 允许柜面跨行存入许可标志
    ,allow_cnter_cross_bank_wdraw_permit_flg -- 允许柜面跨行支取许可标志
    ,allow_manual_entry_flg -- 允许手工记账标志
    ,allow_acct_turn_long_hang_flg -- 允许账户转久悬标志
    ,acct_redt_tenor -- 账户转存期限
    ,acct_redt_tenor_cd -- 账户转存期限代码
    ,turn_back_dt -- 转回日期
    ,next_renew_dep_day -- 下一续存日
    ,ftz_cd -- 自贸区代码
    ,ftz_acct_flg -- 自贸区账户标志
    ,precon_wdraw_flg -- 预约支取标志
    ,precon_wdraw_dt -- 预约支取日期
    ,print_cert_flg -- 打印证实书标志
    ,auto_renew_dep_flg -- 自动续存标志
    ,one_key_open_acct_flg -- 一键开户标志
    ,prefr_int_tax_rat_exp_dt -- 优惠利息税率到期日期
    ,delay_pay_int_flg -- 延期付息标志
    ,spec_day -- 指定日
    ,bi_lmt_lmt_flg -- 双边限额限制标志
    ,cap_src_acct_id -- 资金来源账户编号
    ,cap_src_acct_sub_acct_num -- 资金来源账户子账号
    ,hold_valid_id_card_flg -- 持有有效身份证件标志
    ,cds_prod_modif_flg -- 大额存单产品变更标志
    ,cash_mgmt_prod_flg -- 现金管理产品标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_assis_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_assis_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_assis_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_acct_attach-1
insert into ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,pcp_de_int_flag -- 产品细类代码
    ,cls_prod_id -- 分类产品编号
    ,inside_acct_char_cd -- 内部账户性质代码
    ,acct_char_cd -- 外汇账户性质代码
    ,acct_vrif_status_cd -- 账户核实状态代码
    ,last_acct_vrif_status_cd -- 上一账户核实状态代码
    ,acct_chn_idf_cd -- 账户渠道标识代码
    ,acct_bal_dir_cd -- 账户余额方向代码
    ,bal_update_type_cd -- 余额更新类型代码
    ,bal_linkg_chg_flg -- 余额联动变动标志
    ,accrd_freq_pay_int_flg -- 按频率付息标志
    ,tax_rat -- 税率
    ,ped -- 周期
    ,ped_corp_cd -- 周期单位代码
    ,sign_prod_cls_cd -- 签约产品分类代码
    ,sign_agt_id -- 签约协议编号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,dep_char_cd -- 存款性质代码
    ,agt_dep_type_cd -- 协议存款类型代码
    ,cap_char -- 资金性质
    ,pd_cd -- 期次编号
    ,verify_type_cd -- 查证类型代码
    ,verify_amt -- 查证金额
    ,disp_way_cd -- 处置方式代码
    ,st_msg_sign_status_cd -- 短信签约状态代码
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_acct_num -- 对手账号
    ,cntpty_acct_num_name -- 对手账号名称
    ,cntpty_acct_open_bank_name -- 对手账户开户行名称
    ,cntpty_acct_open_acct_org_id -- 对手账户开户机构编号
    ,cntpty_acct_open_acct_dt -- 对手账户开户日期
    ,cntpty_bk_open_acct_org_belong_dist_cd -- 对手行开户机构所属行政区域代码
    ,cntpty_bank_belong_cty_rg_cd -- 对手行所属国家和地区代码
    ,non_i_class_acct_check_status_cd -- 非I类户验证状态代码
    ,suspd_wrtoff_flg -- 挂销账标志
    ,on_acct_tenor -- 挂账期限
    ,supv_flg -- 监管标志
    ,supv_type_cd -- 监管类型代码
    ,supv_content_descb -- 监管内容描述
    ,open_acct_way_cd -- 开户方式代码
    ,open_type_cd -- 开立类型代码
    ,remote_open_acct_flg -- 异地开户标志
    ,open_acct_city -- 开户城市
    ,open_acct_prov -- 开户省份
    ,can_od_flg -- 可透支标志
    ,acm_can_wdraw_pric_amt -- 累计可支取本金金额
    ,int_tax_impose_flg -- 利息税征收标志
    ,onl_flg -- 联机标志
    ,final_blklist_dt -- 最后黑名单日期
    ,blklist_status_cd -- 黑名单状态代码
    ,legal_flg -- 涉案标志
    ,legal_dt -- 涉案日期
    ,legal_rs_descb -- 涉案原因描述
    ,apv_odd_no -- 审批单号
    ,general_exch_org_id -- 通兑机构编号
    ,clos_acct_reop_dt -- 销户重开日期
    ,wrtoff_way_cd -- 销账方式代码
    ,check_fail_rs_descb -- 验证失败原因描述
    ,cert_as_flg -- 证件年检标志
    ,aldy_as_flg -- 已年检标志
    ,last_as_closing_dt -- 上一年检截止日期
    ,last_as_reset_dt -- 上一年检重置日期
    ,bank_inter_id -- 银行国际编号
    ,privavy_acct_flg -- 隐私账户标志
    ,earliest_wdraw_dt -- 最早可支取日期
    ,unexp_draw_dt -- 提前支取日期
    ,precon_payoff_day -- 预约结清日
    ,allow_sell_check_flg -- 允许出售支票标志
    ,allow_cnter_cross_bank_depot_permit_flg -- 允许柜面跨行存入许可标志
    ,allow_cnter_cross_bank_wdraw_permit_flg -- 允许柜面跨行支取许可标志
    ,allow_manual_entry_flg -- 允许手工记账标志
    ,allow_acct_turn_long_hang_flg -- 允许账户转久悬标志
    ,acct_redt_tenor -- 账户转存期限
    ,acct_redt_tenor_cd -- 账户转存期限代码
    ,turn_back_dt -- 转回日期
    ,next_renew_dep_day -- 下一续存日
    ,ftz_cd -- 自贸区代码
    ,ftz_acct_flg -- 自贸区账户标志
    ,precon_wdraw_flg -- 预约支取标志
    ,precon_wdraw_dt -- 预约支取日期
    ,print_cert_flg -- 打印证实书标志
    ,auto_renew_dep_flg -- 自动续存标志
    ,one_key_open_acct_flg -- 一键开户标志
    ,prefr_int_tax_rat_exp_dt -- 优惠利息税率到期日期
    ,delay_pay_int_flg -- 延期付息标志
    ,spec_day -- 指定日
    ,bi_lmt_lmt_flg -- 双边限额限制标志
    ,cap_src_acct_id -- 资金来源账户编号
    ,cap_src_acct_sub_acct_num -- 资金来源账户子账号
    ,hold_valid_id_card_flg -- 持有有效身份证件标志
    ,cds_prod_modif_flg -- 大额存单产品变更标志
    ,cash_mgmt_prod_flg -- 现金管理产品标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(P1.PCP_DELAY_INT_FLAG),'-') -- 产品细类代码
    ,P1.PROD_CLASS -- 分类产品编号
    ,nvl(trim(P1.ACCT_PROPERTY2),'-') -- 内部账户性质代码
    ,nvl(trim(P1.ACCT_PROPERTY),'0000') -- 外汇账户性质代码
    ,P1.ACCT_VERIFY_STATUS -- 账户核实状态代码
    ,nvl(trim(P1.ACCT_VERIFY_STATUS_PREV),'-') -- 上一账户核实状态代码
    ,nvl(trim(P1.ACCT_CHANNEL_FLAG),'-') -- 账户渠道标识代码
    ,nvl(trim(P1.BALANCE_WAY),'-') -- 账户余额方向代码
    ,nvl(trim(P1.BAL_UPD_TYPE),'-') -- 余额更新类型代码
    ,decode(trim(p1.BAL_CHG_IND),'','-','Y','1','N','0',p1.BAL_CHG_IND) -- 余额联动变动标志
    ,decode(trim(p1.CYCLE_INT_FLAG),'','-','Y','1','N','0',p1.CYCLE_INT_FLAG) -- 按频率付息标志
    ,nvl(trim(P1.TAX_RATE),0) -- 税率
    ,DECODE(trim(p1.fix_rate_period_freq),'','-',regexp_replace(trim(p1.fix_rate_period_freq),'([a-z]+|[A-Z])+','')) -- 周期
    ,DECODE(trim(p1.fix_rate_period_freq),'','-',regexp_replace(trim(p1.fix_rate_period_freq),'[0-9]+','')) -- 周期单位代码
    ,nvl(trim(P1.SPECIAL_PROD_CLASS),'-') -- 签约产品分类代码
    ,P1.AGREEMENT_ID -- 签约协议编号
    ,nvl(trim(P1.AGREEMENT_STATUS),'-') -- 签约协议状态代码
    ,nvl(trim(P1.DEPOSIT_NATURE),'-') -- 存款性质代码
    ,nvl(trim(P1.AGREEMENT_DEPOSIT_TYPE),'-') -- 协议存款类型代码
    ,P1.AMOUNT_NATURE -- 资金性质
    ,P1.STAGE_CODE -- 期次编号
    ,nvl(trim(P1.CHECK_CERTIFICATE_TYPE),'-') -- 查证类型代码
    ,P1.CHECK_CERTIFICATE_AMT -- 查证金额
    ,nvl(trim(P1.TREATMENT),'-') -- 处置方式代码
    ,nvl(trim(P1.MSG_STATUS),'-') -- 短信签约状态代码
    ,P1.CONTRA_CLIENT_NO -- 对手客户编号
    ,nvl(trim(p8.card_no),p1.CONTRA_BASE_ACCT_NO) -- 对手账号
    ,P1.CONTRA_ACCT_NAME -- 对手账号名称
    ,P1.CONTRA_BRANCH_NAME -- 对手账户开户行名称
    ,P1.CONTRA_BRANCH -- 对手账户开户机构编号
    ,P1.CONTRA_ACCT_OPEN_DATE -- 对手账户开户日期
    ,nvl(trim(P1.CONTRA_AREA_CODE),'XXX') -- 对手行开户机构所属行政区域代码
    ,nvl(trim(P1.CONTRA_COUNTRY),'XXX') -- 对手行所属国家和地区代码
    ,nvl(trim(P1.ACCT_PROOF_STATUS),'-') -- 非I类户验证状态代码
    ,decode(trim(p1.HANG_WRITE_OFF_FLAG),'','-','Y','1','N','0',p1.HANG_WRITE_OFF_FLAG) -- 挂销账标志
    ,NVL(TRIM(P1.HANG_TERM),0) -- 挂账期限
    ,decode(trim(p1.MANAGE_FLAG),'','-','Y','1','N','0',p1.MANAGE_FLAG) -- 监管标志
    ,P1.MANAGE_TYPE -- 监管类型代码
    ,P1.MANAGE_CONTENT -- 监管内容描述
    ,nvl(trim(P1.ACCT_OPEN_TYPE),'-') -- 开户方式代码
    ,nvl(trim(P1.ACCT_OPEN_MODE),'-') -- 开立类型代码
    ,nvl(trim(P1.OFF_SITE_SIGN),'-') -- 异地开户标志
    ,P1.OPEN_ACCT_CITY -- 开户城市
    ,P1.OPEN_ACCT_PROV -- 开户省份
    ,decode(trim(p1.OD_FACILITY),'','-','Y','1','N','0',p1.OD_FACILITY) -- 可透支标志
    ,P1.TOTAL_DRAW_AMT -- 累计可支取本金金额
    ,decode(trim(P1.INT_TAX_LEVY),'Y','1','N','0','-') -- 利息税征收标志
    ,decode(trim(p1.ONLINE_FLAG),'','-','Y','1','N','0',p1.ONLINE_FLAG) -- 联机标志
    ,P1.LAST_BLACKLIST_DATE -- 最后黑名单日期
    ,nvl(trim(P1.BLACKLIST_STATUS),'-') -- 黑名单状态代码
    ,P1.CASE_INVOLVED_FLAG -- 涉案标志
    ,P1.CASE_INVOLVED_DATE -- 涉案日期
    ,P1.CASE_INVOLVED_REASON -- 涉案原因描述
    ,P1.APPROVAL_NO -- 审批单号
    ,P1.ALL_DRA_INT_BRANCH -- 通兑机构编号
    ,P1.RE_OPEN_DATE -- 销户重开日期
    ,nvl(trim(P1.WRITE_OFF_WAY),'-') -- 销账方式代码
    ,P1.ACCT_PROOF_REASON -- 验证失败原因描述
    ,decode(trim(p1.ANNUAL_FLAG),'','-','Y','1','N','0',p1.ANNUAL_FLAG) -- 证件年检标志
    ,DECODE(P1.ANNUAL_STATUS,'Y','1','N','0') -- 已年检标志
    ,P1.LAST_STOP_DATE -- 上一年检截止日期
    ,P1.LAST_RESET_DATE -- 上一年检重置日期
    ,P1.SWIFT_ID -- 银行国际编号
    ,decode(trim(p1.PRIVATE_ACCT_FLAG),'','-','Y','1','N','0',p1.PRIVATE_ACCT_FLAG) -- 隐私账户标志
    ,P1.FIRST_DRAW_DATE -- 最早可支取日期
    ,P1.PRE_DEBT_DATE -- 提前支取日期
    ,p1.BOOK_SETTELE_DATE -- 预约结清日
    ,decode(trim(p1.IS_SELL_CHEQUE),'','-','Y','1','N','0',p1.IS_SELL_CHEQUE) -- 允许出售支票标志
    ,decode(trim(p1.COUNTER_DEP_FLAG),'','-','Y','1','N','0',p1.COUNTER_DEP_FLAG) -- 允许柜面跨行存入许可标志
    ,decode(trim(p1.COUNTER_DEBT_FLAG),'','-','Y','1','N','0',p1.COUNTER_DEBT_FLAG) -- 允许柜面跨行支取许可标志
    ,decode(trim(p1.MANUAL_ACCOUNT_FLAG),'','-','Y','1','N','0',p1.MANUAL_ACCOUNT_FLAG) -- 允许手工记账标志
    ,decode(trim(p1.ALLOW_SUSPEND_FLAG),'','-','Y','1','N','0',p1.ALLOW_SUSPEND_FLAG) -- 允许账户转久悬标志
    ,P1.AUTO_RENEW_TERM -- 账户转存期限
    ,nvl(trim(P1.AUTO_RENEW_TERM_TYPE),'-') -- 账户转存期限代码
    ,P1.BACK_TO_DATE -- 转回日期
    ,P1.NEXT_DEP_DAY -- 下一续存日
    ,P1.FTA_CODE -- 自贸区代码
    ,DECODE(P1.FTA_ACCT_FLAG,'Y','1','N','0') -- 自贸区账户标志
    ,decode(trim(P1.APPLY_DEBT_FLAG),'','-','Y','1','N','0',P1.APPLY_DEBT_FLAG) -- 预约支取标志
    ,P1.APPLY_DEBT_DATE -- 预约支取日期
    ,decode(trim(P1.ALLOW_PRINT_CERTIFICATE_FLAG),'','-','Y','1','N','0',P1.ALLOW_PRINT_CERTIFICATE_FLAG) -- 打印证实书标志
    ,decode(P1.AUTO_DEP,'Y','1','N','0',' ','-',P1.AUTO_DEP) -- 自动续存标志
    ,decode(P1.FAST_OPEN_ACCT_FLAG,'Y','1','N','0',' ','-',P1.FAST_OPEN_ACCT_FLAG) -- 一键开户标志
    ,P1.TAX_DISCOUNT_MATURITY_DATE -- 优惠利息税率到期日期
    ,decode(P1.DELAY_PAY_INT,'Y','1','N','0',' ','-',P1.DELAY_PAY_INT) -- 延期付息标志
    ,regexp_replace(P1.SPEC_DAY, '[^0-9]', '0') -- 指定日
    ,decode(P1.BOTH_LIMIT_FLAG,'Y','1','N','0',' ','-',P1.BOTH_LIMIT_FLAG) -- 双边限额限制标志
    ,P1.FUND_FROM_ACCT_NO -- 资金来源账户编号
    ,P1.FUND_FROM_ACCT_SEQ_NO -- 资金来源账户子账号
    ,decode(P1.IS_EFFECT_DOCUMENT,'Y','1','N','0',' ','-',P1.IS_EFFECT_DOCUMENT) -- 持有有效身份证件标志
    ,decode(P1.DC_PROD_CHANGE_FLAG,'Y','1','N','0',' ','-',P1.DC_PROD_CHANGE_FLAG) -- 大额存单产品变更标志
    ,decode(P1.CASH_MANAGE_PRODUCT,'Y','1','N','0',' ','-',P1.CASH_MANAGE_PRODUCT) -- 现金管理产品标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_acct_attach' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_acct_attach p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.CONTRA_BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_tm 
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
        into ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,pcp_de_int_flag -- 产品细类代码
    ,cls_prod_id -- 分类产品编号
    ,inside_acct_char_cd -- 内部账户性质代码
    ,acct_char_cd -- 外汇账户性质代码
    ,acct_vrif_status_cd -- 账户核实状态代码
    ,last_acct_vrif_status_cd -- 上一账户核实状态代码
    ,acct_chn_idf_cd -- 账户渠道标识代码
    ,acct_bal_dir_cd -- 账户余额方向代码
    ,bal_update_type_cd -- 余额更新类型代码
    ,bal_linkg_chg_flg -- 余额联动变动标志
    ,accrd_freq_pay_int_flg -- 按频率付息标志
    ,tax_rat -- 税率
    ,ped -- 周期
    ,ped_corp_cd -- 周期单位代码
    ,sign_prod_cls_cd -- 签约产品分类代码
    ,sign_agt_id -- 签约协议编号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,dep_char_cd -- 存款性质代码
    ,agt_dep_type_cd -- 协议存款类型代码
    ,cap_char -- 资金性质
    ,pd_cd -- 期次编号
    ,verify_type_cd -- 查证类型代码
    ,verify_amt -- 查证金额
    ,disp_way_cd -- 处置方式代码
    ,st_msg_sign_status_cd -- 短信签约状态代码
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_acct_num -- 对手账号
    ,cntpty_acct_num_name -- 对手账号名称
    ,cntpty_acct_open_bank_name -- 对手账户开户行名称
    ,cntpty_acct_open_acct_org_id -- 对手账户开户机构编号
    ,cntpty_acct_open_acct_dt -- 对手账户开户日期
    ,cntpty_bk_open_acct_org_belong_dist_cd -- 对手行开户机构所属行政区域代码
    ,cntpty_bank_belong_cty_rg_cd -- 对手行所属国家和地区代码
    ,non_i_class_acct_check_status_cd -- 非I类户验证状态代码
    ,suspd_wrtoff_flg -- 挂销账标志
    ,on_acct_tenor -- 挂账期限
    ,supv_flg -- 监管标志
    ,supv_type_cd -- 监管类型代码
    ,supv_content_descb -- 监管内容描述
    ,open_acct_way_cd -- 开户方式代码
    ,open_type_cd -- 开立类型代码
    ,remote_open_acct_flg -- 异地开户标志
    ,open_acct_city -- 开户城市
    ,open_acct_prov -- 开户省份
    ,can_od_flg -- 可透支标志
    ,acm_can_wdraw_pric_amt -- 累计可支取本金金额
    ,int_tax_impose_flg -- 利息税征收标志
    ,onl_flg -- 联机标志
    ,final_blklist_dt -- 最后黑名单日期
    ,blklist_status_cd -- 黑名单状态代码
    ,legal_flg -- 涉案标志
    ,legal_dt -- 涉案日期
    ,legal_rs_descb -- 涉案原因描述
    ,apv_odd_no -- 审批单号
    ,general_exch_org_id -- 通兑机构编号
    ,clos_acct_reop_dt -- 销户重开日期
    ,wrtoff_way_cd -- 销账方式代码
    ,check_fail_rs_descb -- 验证失败原因描述
    ,cert_as_flg -- 证件年检标志
    ,aldy_as_flg -- 已年检标志
    ,last_as_closing_dt -- 上一年检截止日期
    ,last_as_reset_dt -- 上一年检重置日期
    ,bank_inter_id -- 银行国际编号
    ,privavy_acct_flg -- 隐私账户标志
    ,earliest_wdraw_dt -- 最早可支取日期
    ,unexp_draw_dt -- 提前支取日期
    ,precon_payoff_day -- 预约结清日
    ,allow_sell_check_flg -- 允许出售支票标志
    ,allow_cnter_cross_bank_depot_permit_flg -- 允许柜面跨行存入许可标志
    ,allow_cnter_cross_bank_wdraw_permit_flg -- 允许柜面跨行支取许可标志
    ,allow_manual_entry_flg -- 允许手工记账标志
    ,allow_acct_turn_long_hang_flg -- 允许账户转久悬标志
    ,acct_redt_tenor -- 账户转存期限
    ,acct_redt_tenor_cd -- 账户转存期限代码
    ,turn_back_dt -- 转回日期
    ,next_renew_dep_day -- 下一续存日
    ,ftz_cd -- 自贸区代码
    ,ftz_acct_flg -- 自贸区账户标志
    ,precon_wdraw_flg -- 预约支取标志
    ,precon_wdraw_dt -- 预约支取日期
    ,print_cert_flg -- 打印证实书标志
    ,auto_renew_dep_flg -- 自动续存标志
    ,one_key_open_acct_flg -- 一键开户标志
    ,prefr_int_tax_rat_exp_dt -- 优惠利息税率到期日期
    ,delay_pay_int_flg -- 延期付息标志
    ,spec_day -- 指定日
    ,bi_lmt_lmt_flg -- 双边限额限制标志
    ,cap_src_acct_id -- 资金来源账户编号
    ,cap_src_acct_sub_acct_num -- 资金来源账户子账号
    ,hold_valid_id_card_flg -- 持有有效身份证件标志
    ,cds_prod_modif_flg -- 大额存单产品变更标志
    ,cash_mgmt_prod_flg -- 现金管理产品标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,pcp_de_int_flag -- 产品细类代码
    ,cls_prod_id -- 分类产品编号
    ,inside_acct_char_cd -- 内部账户性质代码
    ,acct_char_cd -- 外汇账户性质代码
    ,acct_vrif_status_cd -- 账户核实状态代码
    ,last_acct_vrif_status_cd -- 上一账户核实状态代码
    ,acct_chn_idf_cd -- 账户渠道标识代码
    ,acct_bal_dir_cd -- 账户余额方向代码
    ,bal_update_type_cd -- 余额更新类型代码
    ,bal_linkg_chg_flg -- 余额联动变动标志
    ,accrd_freq_pay_int_flg -- 按频率付息标志
    ,tax_rat -- 税率
    ,ped -- 周期
    ,ped_corp_cd -- 周期单位代码
    ,sign_prod_cls_cd -- 签约产品分类代码
    ,sign_agt_id -- 签约协议编号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,dep_char_cd -- 存款性质代码
    ,agt_dep_type_cd -- 协议存款类型代码
    ,cap_char -- 资金性质
    ,pd_cd -- 期次编号
    ,verify_type_cd -- 查证类型代码
    ,verify_amt -- 查证金额
    ,disp_way_cd -- 处置方式代码
    ,st_msg_sign_status_cd -- 短信签约状态代码
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_acct_num -- 对手账号
    ,cntpty_acct_num_name -- 对手账号名称
    ,cntpty_acct_open_bank_name -- 对手账户开户行名称
    ,cntpty_acct_open_acct_org_id -- 对手账户开户机构编号
    ,cntpty_acct_open_acct_dt -- 对手账户开户日期
    ,cntpty_bk_open_acct_org_belong_dist_cd -- 对手行开户机构所属行政区域代码
    ,cntpty_bank_belong_cty_rg_cd -- 对手行所属国家和地区代码
    ,non_i_class_acct_check_status_cd -- 非I类户验证状态代码
    ,suspd_wrtoff_flg -- 挂销账标志
    ,on_acct_tenor -- 挂账期限
    ,supv_flg -- 监管标志
    ,supv_type_cd -- 监管类型代码
    ,supv_content_descb -- 监管内容描述
    ,open_acct_way_cd -- 开户方式代码
    ,open_type_cd -- 开立类型代码
    ,remote_open_acct_flg -- 异地开户标志
    ,open_acct_city -- 开户城市
    ,open_acct_prov -- 开户省份
    ,can_od_flg -- 可透支标志
    ,acm_can_wdraw_pric_amt -- 累计可支取本金金额
    ,int_tax_impose_flg -- 利息税征收标志
    ,onl_flg -- 联机标志
    ,final_blklist_dt -- 最后黑名单日期
    ,blklist_status_cd -- 黑名单状态代码
    ,legal_flg -- 涉案标志
    ,legal_dt -- 涉案日期
    ,legal_rs_descb -- 涉案原因描述
    ,apv_odd_no -- 审批单号
    ,general_exch_org_id -- 通兑机构编号
    ,clos_acct_reop_dt -- 销户重开日期
    ,wrtoff_way_cd -- 销账方式代码
    ,check_fail_rs_descb -- 验证失败原因描述
    ,cert_as_flg -- 证件年检标志
    ,aldy_as_flg -- 已年检标志
    ,last_as_closing_dt -- 上一年检截止日期
    ,last_as_reset_dt -- 上一年检重置日期
    ,bank_inter_id -- 银行国际编号
    ,privavy_acct_flg -- 隐私账户标志
    ,earliest_wdraw_dt -- 最早可支取日期
    ,unexp_draw_dt -- 提前支取日期
    ,precon_payoff_day -- 预约结清日
    ,allow_sell_check_flg -- 允许出售支票标志
    ,allow_cnter_cross_bank_depot_permit_flg -- 允许柜面跨行存入许可标志
    ,allow_cnter_cross_bank_wdraw_permit_flg -- 允许柜面跨行支取许可标志
    ,allow_manual_entry_flg -- 允许手工记账标志
    ,allow_acct_turn_long_hang_flg -- 允许账户转久悬标志
    ,acct_redt_tenor -- 账户转存期限
    ,acct_redt_tenor_cd -- 账户转存期限代码
    ,turn_back_dt -- 转回日期
    ,next_renew_dep_day -- 下一续存日
    ,ftz_cd -- 自贸区代码
    ,ftz_acct_flg -- 自贸区账户标志
    ,precon_wdraw_flg -- 预约支取标志
    ,precon_wdraw_dt -- 预约支取日期
    ,print_cert_flg -- 打印证实书标志
    ,auto_renew_dep_flg -- 自动续存标志
    ,one_key_open_acct_flg -- 一键开户标志
    ,prefr_int_tax_rat_exp_dt -- 优惠利息税率到期日期
    ,delay_pay_int_flg -- 延期付息标志
    ,spec_day -- 指定日
    ,bi_lmt_lmt_flg -- 双边限额限制标志
    ,cap_src_acct_id -- 资金来源账户编号
    ,cap_src_acct_sub_acct_num -- 资金来源账户子账号
    ,hold_valid_id_card_flg -- 持有有效身份证件标志
    ,cds_prod_modif_flg -- 大额存单产品变更标志
    ,cash_mgmt_prod_flg -- 现金管理产品标志
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
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.pcp_de_int_flag, o.pcp_de_int_flag) as pcp_de_int_flag -- 产品细类代码
    ,nvl(n.cls_prod_id, o.cls_prod_id) as cls_prod_id -- 分类产品编号
    ,nvl(n.inside_acct_char_cd, o.inside_acct_char_cd) as inside_acct_char_cd -- 内部账户性质代码
    ,nvl(n.acct_char_cd, o.acct_char_cd) as acct_char_cd -- 外汇账户性质代码
    ,nvl(n.acct_vrif_status_cd, o.acct_vrif_status_cd) as acct_vrif_status_cd -- 账户核实状态代码
    ,nvl(n.last_acct_vrif_status_cd, o.last_acct_vrif_status_cd) as last_acct_vrif_status_cd -- 上一账户核实状态代码
    ,nvl(n.acct_chn_idf_cd, o.acct_chn_idf_cd) as acct_chn_idf_cd -- 账户渠道标识代码
    ,nvl(n.acct_bal_dir_cd, o.acct_bal_dir_cd) as acct_bal_dir_cd -- 账户余额方向代码
    ,nvl(n.bal_update_type_cd, o.bal_update_type_cd) as bal_update_type_cd -- 余额更新类型代码
    ,nvl(n.bal_linkg_chg_flg, o.bal_linkg_chg_flg) as bal_linkg_chg_flg -- 余额联动变动标志
    ,nvl(n.accrd_freq_pay_int_flg, o.accrd_freq_pay_int_flg) as accrd_freq_pay_int_flg -- 按频率付息标志
    ,nvl(n.tax_rat, o.tax_rat) as tax_rat -- 税率
    ,nvl(n.ped, o.ped) as ped -- 周期
    ,nvl(n.ped_corp_cd, o.ped_corp_cd) as ped_corp_cd -- 周期单位代码
    ,nvl(n.sign_prod_cls_cd, o.sign_prod_cls_cd) as sign_prod_cls_cd -- 签约产品分类代码
    ,nvl(n.sign_agt_id, o.sign_agt_id) as sign_agt_id -- 签约协议编号
    ,nvl(n.sign_agt_status_cd, o.sign_agt_status_cd) as sign_agt_status_cd -- 签约协议状态代码
    ,nvl(n.dep_char_cd, o.dep_char_cd) as dep_char_cd -- 存款性质代码
    ,nvl(n.agt_dep_type_cd, o.agt_dep_type_cd) as agt_dep_type_cd -- 协议存款类型代码
    ,nvl(n.cap_char, o.cap_char) as cap_char -- 资金性质
    ,nvl(n.pd_cd, o.pd_cd) as pd_cd -- 期次编号
    ,nvl(n.verify_type_cd, o.verify_type_cd) as verify_type_cd -- 查证类型代码
    ,nvl(n.verify_amt, o.verify_amt) as verify_amt -- 查证金额
    ,nvl(n.disp_way_cd, o.disp_way_cd) as disp_way_cd -- 处置方式代码
    ,nvl(n.st_msg_sign_status_cd, o.st_msg_sign_status_cd) as st_msg_sign_status_cd -- 短信签约状态代码
    ,nvl(n.cntpty_cust_id, o.cntpty_cust_id) as cntpty_cust_id -- 对手客户编号
    ,nvl(n.cntpty_acct_num, o.cntpty_acct_num) as cntpty_acct_num -- 对手账号
    ,nvl(n.cntpty_acct_num_name, o.cntpty_acct_num_name) as cntpty_acct_num_name -- 对手账号名称
    ,nvl(n.cntpty_acct_open_bank_name, o.cntpty_acct_open_bank_name) as cntpty_acct_open_bank_name -- 对手账户开户行名称
    ,nvl(n.cntpty_acct_open_acct_org_id, o.cntpty_acct_open_acct_org_id) as cntpty_acct_open_acct_org_id -- 对手账户开户机构编号
    ,nvl(n.cntpty_acct_open_acct_dt, o.cntpty_acct_open_acct_dt) as cntpty_acct_open_acct_dt -- 对手账户开户日期
    ,nvl(n.cntpty_bk_open_acct_org_belong_dist_cd, o.cntpty_bk_open_acct_org_belong_dist_cd) as cntpty_bk_open_acct_org_belong_dist_cd -- 对手行开户机构所属行政区域代码
    ,nvl(n.cntpty_bank_belong_cty_rg_cd, o.cntpty_bank_belong_cty_rg_cd) as cntpty_bank_belong_cty_rg_cd -- 对手行所属国家和地区代码
    ,nvl(n.non_i_class_acct_check_status_cd, o.non_i_class_acct_check_status_cd) as non_i_class_acct_check_status_cd -- 非I类户验证状态代码
    ,nvl(n.suspd_wrtoff_flg, o.suspd_wrtoff_flg) as suspd_wrtoff_flg -- 挂销账标志
    ,nvl(n.on_acct_tenor, o.on_acct_tenor) as on_acct_tenor -- 挂账期限
    ,nvl(n.supv_flg, o.supv_flg) as supv_flg -- 监管标志
    ,nvl(n.supv_type_cd, o.supv_type_cd) as supv_type_cd -- 监管类型代码
    ,nvl(n.supv_content_descb, o.supv_content_descb) as supv_content_descb -- 监管内容描述
    ,nvl(n.open_acct_way_cd, o.open_acct_way_cd) as open_acct_way_cd -- 开户方式代码
    ,nvl(n.open_type_cd, o.open_type_cd) as open_type_cd -- 开立类型代码
    ,nvl(n.remote_open_acct_flg, o.remote_open_acct_flg) as remote_open_acct_flg -- 异地开户标志
    ,nvl(n.open_acct_city, o.open_acct_city) as open_acct_city -- 开户城市
    ,nvl(n.open_acct_prov, o.open_acct_prov) as open_acct_prov -- 开户省份
    ,nvl(n.can_od_flg, o.can_od_flg) as can_od_flg -- 可透支标志
    ,nvl(n.acm_can_wdraw_pric_amt, o.acm_can_wdraw_pric_amt) as acm_can_wdraw_pric_amt -- 累计可支取本金金额
    ,nvl(n.int_tax_impose_flg, o.int_tax_impose_flg) as int_tax_impose_flg -- 利息税征收标志
    ,nvl(n.onl_flg, o.onl_flg) as onl_flg -- 联机标志
    ,nvl(n.final_blklist_dt, o.final_blklist_dt) as final_blklist_dt -- 最后黑名单日期
    ,nvl(n.blklist_status_cd, o.blklist_status_cd) as blklist_status_cd -- 黑名单状态代码
    ,nvl(n.legal_flg, o.legal_flg) as legal_flg -- 涉案标志
    ,nvl(n.legal_dt, o.legal_dt) as legal_dt -- 涉案日期
    ,nvl(n.legal_rs_descb, o.legal_rs_descb) as legal_rs_descb -- 涉案原因描述
    ,nvl(n.apv_odd_no, o.apv_odd_no) as apv_odd_no -- 审批单号
    ,nvl(n.general_exch_org_id, o.general_exch_org_id) as general_exch_org_id -- 通兑机构编号
    ,nvl(n.clos_acct_reop_dt, o.clos_acct_reop_dt) as clos_acct_reop_dt -- 销户重开日期
    ,nvl(n.wrtoff_way_cd, o.wrtoff_way_cd) as wrtoff_way_cd -- 销账方式代码
    ,nvl(n.check_fail_rs_descb, o.check_fail_rs_descb) as check_fail_rs_descb -- 验证失败原因描述
    ,nvl(n.cert_as_flg, o.cert_as_flg) as cert_as_flg -- 证件年检标志
    ,nvl(n.aldy_as_flg, o.aldy_as_flg) as aldy_as_flg -- 已年检标志
    ,nvl(n.last_as_closing_dt, o.last_as_closing_dt) as last_as_closing_dt -- 上一年检截止日期
    ,nvl(n.last_as_reset_dt, o.last_as_reset_dt) as last_as_reset_dt -- 上一年检重置日期
    ,nvl(n.bank_inter_id, o.bank_inter_id) as bank_inter_id -- 银行国际编号
    ,nvl(n.privavy_acct_flg, o.privavy_acct_flg) as privavy_acct_flg -- 隐私账户标志
    ,nvl(n.earliest_wdraw_dt, o.earliest_wdraw_dt) as earliest_wdraw_dt -- 最早可支取日期
    ,nvl(n.unexp_draw_dt, o.unexp_draw_dt) as unexp_draw_dt -- 提前支取日期
    ,nvl(n.precon_payoff_day, o.precon_payoff_day) as precon_payoff_day -- 预约结清日
    ,nvl(n.allow_sell_check_flg, o.allow_sell_check_flg) as allow_sell_check_flg -- 允许出售支票标志
    ,nvl(n.allow_cnter_cross_bank_depot_permit_flg, o.allow_cnter_cross_bank_depot_permit_flg) as allow_cnter_cross_bank_depot_permit_flg -- 允许柜面跨行存入许可标志
    ,nvl(n.allow_cnter_cross_bank_wdraw_permit_flg, o.allow_cnter_cross_bank_wdraw_permit_flg) as allow_cnter_cross_bank_wdraw_permit_flg -- 允许柜面跨行支取许可标志
    ,nvl(n.allow_manual_entry_flg, o.allow_manual_entry_flg) as allow_manual_entry_flg -- 允许手工记账标志
    ,nvl(n.allow_acct_turn_long_hang_flg, o.allow_acct_turn_long_hang_flg) as allow_acct_turn_long_hang_flg -- 允许账户转久悬标志
    ,nvl(n.acct_redt_tenor, o.acct_redt_tenor) as acct_redt_tenor -- 账户转存期限
    ,nvl(n.acct_redt_tenor_cd, o.acct_redt_tenor_cd) as acct_redt_tenor_cd -- 账户转存期限代码
    ,nvl(n.turn_back_dt, o.turn_back_dt) as turn_back_dt -- 转回日期
    ,nvl(n.next_renew_dep_day, o.next_renew_dep_day) as next_renew_dep_day -- 下一续存日
    ,nvl(n.ftz_cd, o.ftz_cd) as ftz_cd -- 自贸区代码
    ,nvl(n.ftz_acct_flg, o.ftz_acct_flg) as ftz_acct_flg -- 自贸区账户标志
    ,nvl(n.precon_wdraw_flg, o.precon_wdraw_flg) as precon_wdraw_flg -- 预约支取标志
    ,nvl(n.precon_wdraw_dt, o.precon_wdraw_dt) as precon_wdraw_dt -- 预约支取日期
    ,nvl(n.print_cert_flg, o.print_cert_flg) as print_cert_flg -- 打印证实书标志
    ,nvl(n.auto_renew_dep_flg, o.auto_renew_dep_flg) as auto_renew_dep_flg -- 自动续存标志
    ,nvl(n.one_key_open_acct_flg, o.one_key_open_acct_flg) as one_key_open_acct_flg -- 一键开户标志
    ,nvl(n.prefr_int_tax_rat_exp_dt, o.prefr_int_tax_rat_exp_dt) as prefr_int_tax_rat_exp_dt -- 优惠利息税率到期日期
    ,nvl(n.delay_pay_int_flg, o.delay_pay_int_flg) as delay_pay_int_flg -- 延期付息标志
    ,nvl(n.spec_day, o.spec_day) as spec_day -- 指定日
    ,nvl(n.bi_lmt_lmt_flg, o.bi_lmt_lmt_flg) as bi_lmt_lmt_flg -- 双边限额限制标志
    ,nvl(n.cap_src_acct_id, o.cap_src_acct_id) as cap_src_acct_id -- 资金来源账户编号
    ,nvl(n.cap_src_acct_sub_acct_num, o.cap_src_acct_sub_acct_num) as cap_src_acct_sub_acct_num -- 资金来源账户子账号
    ,nvl(n.hold_valid_id_card_flg, o.hold_valid_id_card_flg) as hold_valid_id_card_flg -- 持有有效身份证件标志
    ,nvl(n.cds_prod_modif_flg, o.cds_prod_modif_flg) as cds_prod_modif_flg -- 大额存单产品变更标志
    ,nvl(n.cash_mgmt_prod_flg, o.cash_mgmt_prod_flg) as cash_mgmt_prod_flg -- 现金管理产品标志
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
from ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.cust_id <> n.cust_id
        or o.pcp_de_int_flag <> n.pcp_de_int_flag
        or o.cls_prod_id <> n.cls_prod_id
        or o.inside_acct_char_cd <> n.inside_acct_char_cd
        or o.acct_char_cd <> n.acct_char_cd
        or o.acct_vrif_status_cd <> n.acct_vrif_status_cd
        or o.last_acct_vrif_status_cd <> n.last_acct_vrif_status_cd
        or o.acct_chn_idf_cd <> n.acct_chn_idf_cd
        or o.acct_bal_dir_cd <> n.acct_bal_dir_cd
        or o.bal_update_type_cd <> n.bal_update_type_cd
        or o.bal_linkg_chg_flg <> n.bal_linkg_chg_flg
        or o.accrd_freq_pay_int_flg <> n.accrd_freq_pay_int_flg
        or o.tax_rat <> n.tax_rat
        or o.ped <> n.ped
        or o.ped_corp_cd <> n.ped_corp_cd
        or o.sign_prod_cls_cd <> n.sign_prod_cls_cd
        or o.sign_agt_id <> n.sign_agt_id
        or o.sign_agt_status_cd <> n.sign_agt_status_cd
        or o.dep_char_cd <> n.dep_char_cd
        or o.agt_dep_type_cd <> n.agt_dep_type_cd
        or o.cap_char <> n.cap_char
        or o.pd_cd <> n.pd_cd
        or o.verify_type_cd <> n.verify_type_cd
        or o.verify_amt <> n.verify_amt
        or o.disp_way_cd <> n.disp_way_cd
        or o.st_msg_sign_status_cd <> n.st_msg_sign_status_cd
        or o.cntpty_cust_id <> n.cntpty_cust_id
        or o.cntpty_acct_num <> n.cntpty_acct_num
        or o.cntpty_acct_num_name <> n.cntpty_acct_num_name
        or o.cntpty_acct_open_bank_name <> n.cntpty_acct_open_bank_name
        or o.cntpty_acct_open_acct_org_id <> n.cntpty_acct_open_acct_org_id
        or o.cntpty_acct_open_acct_dt <> n.cntpty_acct_open_acct_dt
        or o.cntpty_bk_open_acct_org_belong_dist_cd <> n.cntpty_bk_open_acct_org_belong_dist_cd
        or o.cntpty_bank_belong_cty_rg_cd <> n.cntpty_bank_belong_cty_rg_cd
        or o.non_i_class_acct_check_status_cd <> n.non_i_class_acct_check_status_cd
        or o.suspd_wrtoff_flg <> n.suspd_wrtoff_flg
        or o.on_acct_tenor <> n.on_acct_tenor
        or o.supv_flg <> n.supv_flg
        or o.supv_type_cd <> n.supv_type_cd
        or o.supv_content_descb <> n.supv_content_descb
        or o.open_acct_way_cd <> n.open_acct_way_cd
        or o.open_type_cd <> n.open_type_cd
        or o.remote_open_acct_flg <> n.remote_open_acct_flg
        or o.open_acct_city <> n.open_acct_city
        or o.open_acct_prov <> n.open_acct_prov
        or o.can_od_flg <> n.can_od_flg
        or o.acm_can_wdraw_pric_amt <> n.acm_can_wdraw_pric_amt
        or o.int_tax_impose_flg <> n.int_tax_impose_flg
        or o.onl_flg <> n.onl_flg
        or o.final_blklist_dt <> n.final_blklist_dt
        or o.blklist_status_cd <> n.blklist_status_cd
        or o.legal_flg <> n.legal_flg
        or o.legal_dt <> n.legal_dt
        or o.legal_rs_descb <> n.legal_rs_descb
        or o.apv_odd_no <> n.apv_odd_no
        or o.general_exch_org_id <> n.general_exch_org_id
        or o.clos_acct_reop_dt <> n.clos_acct_reop_dt
        or o.wrtoff_way_cd <> n.wrtoff_way_cd
        or o.check_fail_rs_descb <> n.check_fail_rs_descb
        or o.cert_as_flg <> n.cert_as_flg
        or o.aldy_as_flg <> n.aldy_as_flg
        or o.last_as_closing_dt <> n.last_as_closing_dt
        or o.last_as_reset_dt <> n.last_as_reset_dt
        or o.bank_inter_id <> n.bank_inter_id
        or o.privavy_acct_flg <> n.privavy_acct_flg
        or o.earliest_wdraw_dt <> n.earliest_wdraw_dt
        or o.unexp_draw_dt <> n.unexp_draw_dt
        or o.precon_payoff_day <> n.precon_payoff_day
        or o.allow_sell_check_flg <> n.allow_sell_check_flg
        or o.allow_cnter_cross_bank_depot_permit_flg <> n.allow_cnter_cross_bank_depot_permit_flg
        or o.allow_cnter_cross_bank_wdraw_permit_flg <> n.allow_cnter_cross_bank_wdraw_permit_flg
        or o.allow_manual_entry_flg <> n.allow_manual_entry_flg
        or o.allow_acct_turn_long_hang_flg <> n.allow_acct_turn_long_hang_flg
        or o.acct_redt_tenor <> n.acct_redt_tenor
        or o.acct_redt_tenor_cd <> n.acct_redt_tenor_cd
        or o.turn_back_dt <> n.turn_back_dt
        or o.next_renew_dep_day <> n.next_renew_dep_day
        or o.ftz_cd <> n.ftz_cd
        or o.ftz_acct_flg <> n.ftz_acct_flg
        or o.precon_wdraw_flg <> n.precon_wdraw_flg
        or o.precon_wdraw_dt <> n.precon_wdraw_dt
        or o.print_cert_flg <> n.print_cert_flg
        or o.auto_renew_dep_flg <> n.auto_renew_dep_flg
        or o.one_key_open_acct_flg <> n.one_key_open_acct_flg
        or o.prefr_int_tax_rat_exp_dt <> n.prefr_int_tax_rat_exp_dt
        or o.delay_pay_int_flg <> n.delay_pay_int_flg
        or o.spec_day <> n.spec_day
        or o.bi_lmt_lmt_flg <> n.bi_lmt_lmt_flg
        or o.cap_src_acct_id <> n.cap_src_acct_id
        or o.cap_src_acct_sub_acct_num <> n.cap_src_acct_sub_acct_num
        or o.hold_valid_id_card_flg <> n.hold_valid_id_card_flg
        or o.cds_prod_modif_flg <> n.cds_prod_modif_flg
        or o.cash_mgmt_prod_flg <> n.cash_mgmt_prod_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,pcp_de_int_flag -- 产品细类代码
    ,cls_prod_id -- 分类产品编号
    ,inside_acct_char_cd -- 内部账户性质代码
    ,acct_char_cd -- 外汇账户性质代码
    ,acct_vrif_status_cd -- 账户核实状态代码
    ,last_acct_vrif_status_cd -- 上一账户核实状态代码
    ,acct_chn_idf_cd -- 账户渠道标识代码
    ,acct_bal_dir_cd -- 账户余额方向代码
    ,bal_update_type_cd -- 余额更新类型代码
    ,bal_linkg_chg_flg -- 余额联动变动标志
    ,accrd_freq_pay_int_flg -- 按频率付息标志
    ,tax_rat -- 税率
    ,ped -- 周期
    ,ped_corp_cd -- 周期单位代码
    ,sign_prod_cls_cd -- 签约产品分类代码
    ,sign_agt_id -- 签约协议编号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,dep_char_cd -- 存款性质代码
    ,agt_dep_type_cd -- 协议存款类型代码
    ,cap_char -- 资金性质
    ,pd_cd -- 期次编号
    ,verify_type_cd -- 查证类型代码
    ,verify_amt -- 查证金额
    ,disp_way_cd -- 处置方式代码
    ,st_msg_sign_status_cd -- 短信签约状态代码
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_acct_num -- 对手账号
    ,cntpty_acct_num_name -- 对手账号名称
    ,cntpty_acct_open_bank_name -- 对手账户开户行名称
    ,cntpty_acct_open_acct_org_id -- 对手账户开户机构编号
    ,cntpty_acct_open_acct_dt -- 对手账户开户日期
    ,cntpty_bk_open_acct_org_belong_dist_cd -- 对手行开户机构所属行政区域代码
    ,cntpty_bank_belong_cty_rg_cd -- 对手行所属国家和地区代码
    ,non_i_class_acct_check_status_cd -- 非I类户验证状态代码
    ,suspd_wrtoff_flg -- 挂销账标志
    ,on_acct_tenor -- 挂账期限
    ,supv_flg -- 监管标志
    ,supv_type_cd -- 监管类型代码
    ,supv_content_descb -- 监管内容描述
    ,open_acct_way_cd -- 开户方式代码
    ,open_type_cd -- 开立类型代码
    ,remote_open_acct_flg -- 异地开户标志
    ,open_acct_city -- 开户城市
    ,open_acct_prov -- 开户省份
    ,can_od_flg -- 可透支标志
    ,acm_can_wdraw_pric_amt -- 累计可支取本金金额
    ,int_tax_impose_flg -- 利息税征收标志
    ,onl_flg -- 联机标志
    ,final_blklist_dt -- 最后黑名单日期
    ,blklist_status_cd -- 黑名单状态代码
    ,legal_flg -- 涉案标志
    ,legal_dt -- 涉案日期
    ,legal_rs_descb -- 涉案原因描述
    ,apv_odd_no -- 审批单号
    ,general_exch_org_id -- 通兑机构编号
    ,clos_acct_reop_dt -- 销户重开日期
    ,wrtoff_way_cd -- 销账方式代码
    ,check_fail_rs_descb -- 验证失败原因描述
    ,cert_as_flg -- 证件年检标志
    ,aldy_as_flg -- 已年检标志
    ,last_as_closing_dt -- 上一年检截止日期
    ,last_as_reset_dt -- 上一年检重置日期
    ,bank_inter_id -- 银行国际编号
    ,privavy_acct_flg -- 隐私账户标志
    ,earliest_wdraw_dt -- 最早可支取日期
    ,unexp_draw_dt -- 提前支取日期
    ,precon_payoff_day -- 预约结清日
    ,allow_sell_check_flg -- 允许出售支票标志
    ,allow_cnter_cross_bank_depot_permit_flg -- 允许柜面跨行存入许可标志
    ,allow_cnter_cross_bank_wdraw_permit_flg -- 允许柜面跨行支取许可标志
    ,allow_manual_entry_flg -- 允许手工记账标志
    ,allow_acct_turn_long_hang_flg -- 允许账户转久悬标志
    ,acct_redt_tenor -- 账户转存期限
    ,acct_redt_tenor_cd -- 账户转存期限代码
    ,turn_back_dt -- 转回日期
    ,next_renew_dep_day -- 下一续存日
    ,ftz_cd -- 自贸区代码
    ,ftz_acct_flg -- 自贸区账户标志
    ,precon_wdraw_flg -- 预约支取标志
    ,precon_wdraw_dt -- 预约支取日期
    ,print_cert_flg -- 打印证实书标志
    ,auto_renew_dep_flg -- 自动续存标志
    ,one_key_open_acct_flg -- 一键开户标志
    ,prefr_int_tax_rat_exp_dt -- 优惠利息税率到期日期
    ,delay_pay_int_flg -- 延期付息标志
    ,spec_day -- 指定日
    ,bi_lmt_lmt_flg -- 双边限额限制标志
    ,cap_src_acct_id -- 资金来源账户编号
    ,cap_src_acct_sub_acct_num -- 资金来源账户子账号
    ,hold_valid_id_card_flg -- 持有有效身份证件标志
    ,cds_prod_modif_flg -- 大额存单产品变更标志
    ,cash_mgmt_prod_flg -- 现金管理产品标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,pcp_de_int_flag -- 产品细类代码
    ,cls_prod_id -- 分类产品编号
    ,inside_acct_char_cd -- 内部账户性质代码
    ,acct_char_cd -- 外汇账户性质代码
    ,acct_vrif_status_cd -- 账户核实状态代码
    ,last_acct_vrif_status_cd -- 上一账户核实状态代码
    ,acct_chn_idf_cd -- 账户渠道标识代码
    ,acct_bal_dir_cd -- 账户余额方向代码
    ,bal_update_type_cd -- 余额更新类型代码
    ,bal_linkg_chg_flg -- 余额联动变动标志
    ,accrd_freq_pay_int_flg -- 按频率付息标志
    ,tax_rat -- 税率
    ,ped -- 周期
    ,ped_corp_cd -- 周期单位代码
    ,sign_prod_cls_cd -- 签约产品分类代码
    ,sign_agt_id -- 签约协议编号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,dep_char_cd -- 存款性质代码
    ,agt_dep_type_cd -- 协议存款类型代码
    ,cap_char -- 资金性质
    ,pd_cd -- 期次编号
    ,verify_type_cd -- 查证类型代码
    ,verify_amt -- 查证金额
    ,disp_way_cd -- 处置方式代码
    ,st_msg_sign_status_cd -- 短信签约状态代码
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_acct_num -- 对手账号
    ,cntpty_acct_num_name -- 对手账号名称
    ,cntpty_acct_open_bank_name -- 对手账户开户行名称
    ,cntpty_acct_open_acct_org_id -- 对手账户开户机构编号
    ,cntpty_acct_open_acct_dt -- 对手账户开户日期
    ,cntpty_bk_open_acct_org_belong_dist_cd -- 对手行开户机构所属行政区域代码
    ,cntpty_bank_belong_cty_rg_cd -- 对手行所属国家和地区代码
    ,non_i_class_acct_check_status_cd -- 非I类户验证状态代码
    ,suspd_wrtoff_flg -- 挂销账标志
    ,on_acct_tenor -- 挂账期限
    ,supv_flg -- 监管标志
    ,supv_type_cd -- 监管类型代码
    ,supv_content_descb -- 监管内容描述
    ,open_acct_way_cd -- 开户方式代码
    ,open_type_cd -- 开立类型代码
    ,remote_open_acct_flg -- 异地开户标志
    ,open_acct_city -- 开户城市
    ,open_acct_prov -- 开户省份
    ,can_od_flg -- 可透支标志
    ,acm_can_wdraw_pric_amt -- 累计可支取本金金额
    ,int_tax_impose_flg -- 利息税征收标志
    ,onl_flg -- 联机标志
    ,final_blklist_dt -- 最后黑名单日期
    ,blklist_status_cd -- 黑名单状态代码
    ,legal_flg -- 涉案标志
    ,legal_dt -- 涉案日期
    ,legal_rs_descb -- 涉案原因描述
    ,apv_odd_no -- 审批单号
    ,general_exch_org_id -- 通兑机构编号
    ,clos_acct_reop_dt -- 销户重开日期
    ,wrtoff_way_cd -- 销账方式代码
    ,check_fail_rs_descb -- 验证失败原因描述
    ,cert_as_flg -- 证件年检标志
    ,aldy_as_flg -- 已年检标志
    ,last_as_closing_dt -- 上一年检截止日期
    ,last_as_reset_dt -- 上一年检重置日期
    ,bank_inter_id -- 银行国际编号
    ,privavy_acct_flg -- 隐私账户标志
    ,earliest_wdraw_dt -- 最早可支取日期
    ,unexp_draw_dt -- 提前支取日期
    ,precon_payoff_day -- 预约结清日
    ,allow_sell_check_flg -- 允许出售支票标志
    ,allow_cnter_cross_bank_depot_permit_flg -- 允许柜面跨行存入许可标志
    ,allow_cnter_cross_bank_wdraw_permit_flg -- 允许柜面跨行支取许可标志
    ,allow_manual_entry_flg -- 允许手工记账标志
    ,allow_acct_turn_long_hang_flg -- 允许账户转久悬标志
    ,acct_redt_tenor -- 账户转存期限
    ,acct_redt_tenor_cd -- 账户转存期限代码
    ,turn_back_dt -- 转回日期
    ,next_renew_dep_day -- 下一续存日
    ,ftz_cd -- 自贸区代码
    ,ftz_acct_flg -- 自贸区账户标志
    ,precon_wdraw_flg -- 预约支取标志
    ,precon_wdraw_dt -- 预约支取日期
    ,print_cert_flg -- 打印证实书标志
    ,auto_renew_dep_flg -- 自动续存标志
    ,one_key_open_acct_flg -- 一键开户标志
    ,prefr_int_tax_rat_exp_dt -- 优惠利息税率到期日期
    ,delay_pay_int_flg -- 延期付息标志
    ,spec_day -- 指定日
    ,bi_lmt_lmt_flg -- 双边限额限制标志
    ,cap_src_acct_id -- 资金来源账户编号
    ,cap_src_acct_sub_acct_num -- 资金来源账户子账号
    ,hold_valid_id_card_flg -- 持有有效身份证件标志
    ,cds_prod_modif_flg -- 大额存单产品变更标志
    ,cash_mgmt_prod_flg -- 现金管理产品标志
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
    ,o.cust_id -- 客户编号
    ,o.pcp_de_int_flag -- 产品细类代码
    ,o.cls_prod_id -- 分类产品编号
    ,o.inside_acct_char_cd -- 内部账户性质代码
    ,o.acct_char_cd -- 外汇账户性质代码
    ,o.acct_vrif_status_cd -- 账户核实状态代码
    ,o.last_acct_vrif_status_cd -- 上一账户核实状态代码
    ,o.acct_chn_idf_cd -- 账户渠道标识代码
    ,o.acct_bal_dir_cd -- 账户余额方向代码
    ,o.bal_update_type_cd -- 余额更新类型代码
    ,o.bal_linkg_chg_flg -- 余额联动变动标志
    ,o.accrd_freq_pay_int_flg -- 按频率付息标志
    ,o.tax_rat -- 税率
    ,o.ped -- 周期
    ,o.ped_corp_cd -- 周期单位代码
    ,o.sign_prod_cls_cd -- 签约产品分类代码
    ,o.sign_agt_id -- 签约协议编号
    ,o.sign_agt_status_cd -- 签约协议状态代码
    ,o.dep_char_cd -- 存款性质代码
    ,o.agt_dep_type_cd -- 协议存款类型代码
    ,o.cap_char -- 资金性质
    ,o.pd_cd -- 期次编号
    ,o.verify_type_cd -- 查证类型代码
    ,o.verify_amt -- 查证金额
    ,o.disp_way_cd -- 处置方式代码
    ,o.st_msg_sign_status_cd -- 短信签约状态代码
    ,o.cntpty_cust_id -- 对手客户编号
    ,o.cntpty_acct_num -- 对手账号
    ,o.cntpty_acct_num_name -- 对手账号名称
    ,o.cntpty_acct_open_bank_name -- 对手账户开户行名称
    ,o.cntpty_acct_open_acct_org_id -- 对手账户开户机构编号
    ,o.cntpty_acct_open_acct_dt -- 对手账户开户日期
    ,o.cntpty_bk_open_acct_org_belong_dist_cd -- 对手行开户机构所属行政区域代码
    ,o.cntpty_bank_belong_cty_rg_cd -- 对手行所属国家和地区代码
    ,o.non_i_class_acct_check_status_cd -- 非I类户验证状态代码
    ,o.suspd_wrtoff_flg -- 挂销账标志
    ,o.on_acct_tenor -- 挂账期限
    ,o.supv_flg -- 监管标志
    ,o.supv_type_cd -- 监管类型代码
    ,o.supv_content_descb -- 监管内容描述
    ,o.open_acct_way_cd -- 开户方式代码
    ,o.open_type_cd -- 开立类型代码
    ,o.remote_open_acct_flg -- 异地开户标志
    ,o.open_acct_city -- 开户城市
    ,o.open_acct_prov -- 开户省份
    ,o.can_od_flg -- 可透支标志
    ,o.acm_can_wdraw_pric_amt -- 累计可支取本金金额
    ,o.int_tax_impose_flg -- 利息税征收标志
    ,o.onl_flg -- 联机标志
    ,o.final_blklist_dt -- 最后黑名单日期
    ,o.blklist_status_cd -- 黑名单状态代码
    ,o.legal_flg -- 涉案标志
    ,o.legal_dt -- 涉案日期
    ,o.legal_rs_descb -- 涉案原因描述
    ,o.apv_odd_no -- 审批单号
    ,o.general_exch_org_id -- 通兑机构编号
    ,o.clos_acct_reop_dt -- 销户重开日期
    ,o.wrtoff_way_cd -- 销账方式代码
    ,o.check_fail_rs_descb -- 验证失败原因描述
    ,o.cert_as_flg -- 证件年检标志
    ,o.aldy_as_flg -- 已年检标志
    ,o.last_as_closing_dt -- 上一年检截止日期
    ,o.last_as_reset_dt -- 上一年检重置日期
    ,o.bank_inter_id -- 银行国际编号
    ,o.privavy_acct_flg -- 隐私账户标志
    ,o.earliest_wdraw_dt -- 最早可支取日期
    ,o.unexp_draw_dt -- 提前支取日期
    ,o.precon_payoff_day -- 预约结清日
    ,o.allow_sell_check_flg -- 允许出售支票标志
    ,o.allow_cnter_cross_bank_depot_permit_flg -- 允许柜面跨行存入许可标志
    ,o.allow_cnter_cross_bank_wdraw_permit_flg -- 允许柜面跨行支取许可标志
    ,o.allow_manual_entry_flg -- 允许手工记账标志
    ,o.allow_acct_turn_long_hang_flg -- 允许账户转久悬标志
    ,o.acct_redt_tenor -- 账户转存期限
    ,o.acct_redt_tenor_cd -- 账户转存期限代码
    ,o.turn_back_dt -- 转回日期
    ,o.next_renew_dep_day -- 下一续存日
    ,o.ftz_cd -- 自贸区代码
    ,o.ftz_acct_flg -- 自贸区账户标志
    ,o.precon_wdraw_flg -- 预约支取标志
    ,o.precon_wdraw_dt -- 预约支取日期
    ,o.print_cert_flg -- 打印证实书标志
    ,o.auto_renew_dep_flg -- 自动续存标志
    ,o.one_key_open_acct_flg -- 一键开户标志
    ,o.prefr_int_tax_rat_exp_dt -- 优惠利息税率到期日期
    ,o.delay_pay_int_flg -- 延期付息标志
    ,o.spec_day -- 指定日
    ,o.bi_lmt_lmt_flg -- 双边限额限制标志
    ,o.cap_src_acct_id -- 资金来源账户编号
    ,o.cap_src_acct_sub_acct_num -- 资金来源账户子账号
    ,o.hold_valid_id_card_flg -- 持有有效身份证件标志
    ,o.cds_prod_modif_flg -- 大额存单产品变更标志
    ,o.cash_mgmt_prod_flg -- 现金管理产品标志
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
from ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_cl d
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
--truncate table ${iml_schema}.agt_dep_acct_assis_info_h;
--alter table ${iml_schema}.agt_dep_acct_assis_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_dep_acct_assis_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_dep_acct_assis_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_dep_acct_assis_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_dep_acct_assis_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_dep_acct_assis_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dep_acct_assis_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_dep_acct_assis_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dep_acct_assis_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
