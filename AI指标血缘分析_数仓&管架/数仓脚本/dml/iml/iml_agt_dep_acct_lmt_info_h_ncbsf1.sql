/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dep_acct_lmt_info_h_ncbsf1
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
alter table ${iml_schema}.agt_dep_acct_lmt_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_lmt_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,tran_lmt_type_cd -- 交易限制类型代码
    ,lmt_id -- 限制编号
    ,acct_lmt_status_cd -- 账户限制状态代码
    ,lmt_acct_range_cd -- 限制账户范围代码
    ,acct_lmt_amt -- 账户限制金额
    ,sub_lmt_cate_cd -- 子限制类别代码
    ,actl_ctrl_amt -- 实际控制金额
    ,actl_effect_dt -- 实际生效日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,ova_flow_num -- 全局流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,acct_aldy_check_flg -- 账户已复核标志
    ,acct_check_dt -- 账户复核日期
    ,tran_ref_no -- 交易参考号
    ,tran_cd -- 交易码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_memo_descb -- 交易摘要描述
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_amt -- 交易金额
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,cntpty_acct_prod_id -- 交易对手账户产品编号
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_cust_acct_num -- 交易对手客户账号
    ,cntpty_curr_cd -- 交易对手币种代码
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,vouch_type_cd -- 凭证类型代码
    ,begin_check_id -- 起始支票编号
    ,begin_amt -- 起始金额
    ,termnt_check_id -- 终止支票编号
    ,stop_amt -- 截止金额
    ,aldy_paid_amt -- 已还金额
    ,pay_amt -- 支付金额
    ,tot_pay_cnt -- 总支付笔数
    ,aldy_pay_cnt -- 已支付笔数
    ,interp_flg -- 中断标志
    ,pm_flg -- 抵质押标志
    ,mtg_acct_id -- 抵押账户编号
    ,mtg_cust_acct_num -- 抵押客户账号
    ,mtg_acct_curr_cd -- 抵押账户币种代码
    ,mtg_acct_type_cd -- 抵押账户类型代码
    ,matn_way_cd -- 维护方式代码
    ,stl_flow_id -- 结算流水编号
    ,check_entry_code -- 对账编码
    ,revs_flg -- 冲正标志
    ,wait_to_froz_seq_num -- 轮候冻结序号
    ,full_amt_froz_flg -- 全额冻结标志
    ,ct_froz_flg -- 续冻标志
    ,froz_org_name -- 冻结机关名称
    ,froz_org_law_doc_num -- 冻结机关法律文书号码
    ,froz_lev -- 冻结级别
    ,unfrz_org_name -- 解冻机关名称
    ,unfrz_org_law_doc_num -- 解冻机关法律文书号码
    ,unloss_tm -- 解挂时间
    ,unloss_teller_id -- 解挂柜员编号
    ,can_deduct_amt -- 可扣划金额
    ,deduct_law_doc_num -- 扣划法律文书号码
    ,auth_org_name -- 有权机关名称
    ,exec_org_cd -- 执行机关代码
    ,asit_exec_item -- 协助执行事项
    ,enforc_ps_1_name -- 执法人1名称
    ,enforc_ps_1_cert_a_type_cd -- 执法人1证件A类型代码
    ,enforc_ps_1_cert_a_no -- 执法人1证件A号码
    ,enforc_ps_1_cert_b_type_cd -- 执法人1证件B类型代码
    ,enforc_ps_1_cert_b_no -- 执法人1证件B号码
    ,enforc_ps_2_name -- 执法人2名称
    ,enforc_ps_2_cert_a_type_cd -- 执法人2证件A类型代码
    ,enforc_ps_2_cert_a_no -- 执法人2证件A号码
    ,enforc_ps_2_cert_b_type_cd -- 执法人2证件B类型代码
    ,enforc_ps_2_cert_b_no -- 执法人2证件B号码
    ,operr_1_name -- 经办人1名称
    ,operr_1_cert_a_type_cd -- 经办人1证件A类型代码
    ,operr_1_cert_a_no -- 经办人1证件A号码
    ,operr_1_cert_b_type_cd -- 经办人1证件B类型代码
    ,operr_1_cert_b_no -- 经办人1证件B号码
    ,operr_2_name -- 经办人2名称
    ,operr_2_cert_a_type_cd -- 经办人2证件A类型代码
    ,operr_2_cert_a_no -- 经办人2证件A号码
    ,operr_2_cert_b_type_cd -- 经办人2证件B类型代码
    ,operr_2_cert_b_no -- 经办人2证件B号码
    ,proof_cate_cd -- 证明人证件类型代码
    ,src_module_type_cd -- 源模块类型代码
    ,sign_chn_id -- 签约渠道编号
    ,sign_teller_id -- 签约柜员编号
    ,check_teller_id -- 复核柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_lmt_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_lmt_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_lmt_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_restraints-1
insert into ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,tran_lmt_type_cd -- 交易限制类型代码
    ,lmt_id -- 限制编号
    ,acct_lmt_status_cd -- 账户限制状态代码
    ,lmt_acct_range_cd -- 限制账户范围代码
    ,acct_lmt_amt -- 账户限制金额
    ,sub_lmt_cate_cd -- 子限制类别代码
    ,actl_ctrl_amt -- 实际控制金额
    ,actl_effect_dt -- 实际生效日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,ova_flow_num -- 全局流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,acct_aldy_check_flg -- 账户已复核标志
    ,acct_check_dt -- 账户复核日期
    ,tran_ref_no -- 交易参考号
    ,tran_cd -- 交易码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_memo_descb -- 交易摘要描述
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_amt -- 交易金额
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,cntpty_acct_prod_id -- 交易对手账户产品编号
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_cust_acct_num -- 交易对手客户账号
    ,cntpty_curr_cd -- 交易对手币种代码
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,vouch_type_cd -- 凭证类型代码
    ,begin_check_id -- 起始支票编号
    ,begin_amt -- 起始金额
    ,termnt_check_id -- 终止支票编号
    ,stop_amt -- 截止金额
    ,aldy_paid_amt -- 已还金额
    ,pay_amt -- 支付金额
    ,tot_pay_cnt -- 总支付笔数
    ,aldy_pay_cnt -- 已支付笔数
    ,interp_flg -- 中断标志
    ,pm_flg -- 抵质押标志
    ,mtg_acct_id -- 抵押账户编号
    ,mtg_cust_acct_num -- 抵押客户账号
    ,mtg_acct_curr_cd -- 抵押账户币种代码
    ,mtg_acct_type_cd -- 抵押账户类型代码
    ,matn_way_cd -- 维护方式代码
    ,stl_flow_id -- 结算流水编号
    ,check_entry_code -- 对账编码
    ,revs_flg -- 冲正标志
    ,wait_to_froz_seq_num -- 轮候冻结序号
    ,full_amt_froz_flg -- 全额冻结标志
    ,ct_froz_flg -- 续冻标志
    ,froz_org_name -- 冻结机关名称
    ,froz_org_law_doc_num -- 冻结机关法律文书号码
    ,froz_lev -- 冻结级别
    ,unfrz_org_name -- 解冻机关名称
    ,unfrz_org_law_doc_num -- 解冻机关法律文书号码
    ,unloss_tm -- 解挂时间
    ,unloss_teller_id -- 解挂柜员编号
    ,can_deduct_amt -- 可扣划金额
    ,deduct_law_doc_num -- 扣划法律文书号码
    ,auth_org_name -- 有权机关名称
    ,exec_org_cd -- 执行机关代码
    ,asit_exec_item -- 协助执行事项
    ,enforc_ps_1_name -- 执法人1名称
    ,enforc_ps_1_cert_a_type_cd -- 执法人1证件A类型代码
    ,enforc_ps_1_cert_a_no -- 执法人1证件A号码
    ,enforc_ps_1_cert_b_type_cd -- 执法人1证件B类型代码
    ,enforc_ps_1_cert_b_no -- 执法人1证件B号码
    ,enforc_ps_2_name -- 执法人2名称
    ,enforc_ps_2_cert_a_type_cd -- 执法人2证件A类型代码
    ,enforc_ps_2_cert_a_no -- 执法人2证件A号码
    ,enforc_ps_2_cert_b_type_cd -- 执法人2证件B类型代码
    ,enforc_ps_2_cert_b_no -- 执法人2证件B号码
    ,operr_1_name -- 经办人1名称
    ,operr_1_cert_a_type_cd -- 经办人1证件A类型代码
    ,operr_1_cert_a_no -- 经办人1证件A号码
    ,operr_1_cert_b_type_cd -- 经办人1证件B类型代码
    ,operr_1_cert_b_no -- 经办人1证件B号码
    ,operr_2_name -- 经办人2名称
    ,operr_2_cert_a_type_cd -- 经办人2证件A类型代码
    ,operr_2_cert_a_no -- 经办人2证件A号码
    ,operr_2_cert_b_type_cd -- 经办人2证件B类型代码
    ,operr_2_cert_b_no -- 经办人2证件B号码
    ,proof_cate_cd -- 证明人证件类型代码
    ,src_module_type_cd -- 源模块类型代码
    ,sign_chn_id -- 签约渠道编号
    ,sign_teller_id -- 签约柜员编号
    ,check_teller_id -- 复核柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,nvl(trim(P1.RESTRAINT_TYPE),'-') -- 交易限制类型代码
    ,P1.RES_SEQ_NO -- 限制编号
    ,P1.RESTRAINTS_STATUS -- 账户限制状态代码
    ,nvl(trim(P1.RES_ACCT_RANGE),'-') -- 限制账户范围代码
    ,P1.PLEDGED_AMT -- 账户限制金额
    ,nvl(trim(P1.SUB_RESTRAINT_CLASS),'-') -- 子限制类别代码
    ,P1.ACTUAL_PLD_AMOUNT -- 实际控制金额
    ,${iml_schema}.timeformat_min(P1.ACTUAL_EFFECT_TIME) -- 实际生效日期
    ,P1.START_DATE -- 生效日期
    ,P1.END_DATE -- 失效日期
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.MSG_CLIENT -- 客户名称
    ,NVL(TRIM(P1.TERM),0) -- 存款期限
    ,nvl(trim(P1.TERM_TYPE),'-') -- 期限类型代码
    ,decode(trim(p1.APPR_FLAG),'','-','Y','1','N','0',p1.APPR_FLAG) -- 账户已复核标志
    ,P1.APPROVAL_DATE -- 账户复核日期
    ,P1.REFERENCE -- 交易参考号
    ,P1.TRAN_TYPE -- 交易码
    ,nvl(trim(P1.PROGRAM_ID),'0000') -- 交易渠道代码
    ,P1.NARRATIVE -- 交易摘要描述
    ,P1.CHANNEL_DATE -- 交易日期
    ,${iml_schema}.timeformat_max2(P1.TRAN_TIMESTAMP) -- 交易时间
    ,P1.TRAN_AMT -- 交易金额
    ,P1.USER_ID -- 交易柜员编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.OTH_PROD_TYPE -- 交易对手账户产品编号
    ,P1.OTH_ACCT_NO -- 交易对手账户编号
    ,P1.OTH_ACCT_DESC -- 交易对手账户名称
    ,nvl(trim(p8.card_no),p1.OTH_BASE_ACCT_NO) -- 交易对手客户账号
    ,nvl(trim(P1.OTH_ACCT_CCY),'-') -- 交易对手币种代码
    ,P1.OTH_BANK_CODE -- 交易对手开户机构编号
    ,nvl(trim(P1.DOC_TYPE),'-') -- 凭证类型代码
    ,P1.START_CHEQUE_NO -- 起始支票编号
    ,P1.START_AMT -- 起始金额
    ,P1.END_CHEQUE_NO -- 终止支票编号
    ,P1.END_AMT -- 截止金额
    ,P1.PAID_AMT -- 已还金额
    ,P1.TO_PAY_AMT -- 支付金额
    ,P1.NO_OF_PAYMENT -- 总支付笔数
    ,P1.PAYMENT_MADE -- 已支付笔数
    ,decode(trim(p1.INTERRUPT_FLAG),'','-','Y','1','N','0',p1.INTERRUPT_FLAG) -- 中断标志
    ,decode(trim(p1.UNDER_LIEN),'','-','Y','1','N','0',p1.UNDER_LIEN) -- 抵质押标志
    ,P1.PLEDGED_ACCT_NO -- 抵押账户编号
    ,nvl(trim(p9.card_no),p1.PLEDGED_BASE_ACCT_NO) -- 抵押客户账号
    ,nvl(trim(P1.PLEDGED_ACCT_CCY),'-') -- 抵押账户币种代码
    ,nvl(trim(P1.PLEDGED_ACCT_TYPE),'-') -- 抵押账户类型代码
    ,nvl(trim(P1.MAINTAIN_TYPE),'-') -- 维护方式代码
    ,P1.STL_SEQ_NO -- 结算流水编号
    ,P1.REACCOUNT_CD -- 对账编码
    ,decode(P1.RESERVE,'Y','1','N','0',' ','-',P1.RESERVE) -- 冲正标志
    ,P1.WAIT_SEQ -- 轮候冻结序号
    ,decode(trim(p1.FULL_FREEZE_IND),'','-','Y','1','N','0',p1.FULL_FREEZE_IND) -- 全额冻结标志
    ,decode(trim(p1.IS_FROZEN),'','-','Y','1','N','0',p1.IS_FROZEN) -- 续冻标志
    ,P1.RESTRAINT_JUDICIARY_NAME -- 冻结机关名称
    ,P1.RES_LAW_NO -- 冻结机关法律文书号码
    ,P1.RES_PRIORITY -- 冻结级别
    ,P1.RELEASE_JUDICIARY_NAME -- 解冻机关名称
    ,P1.RELEASE_LAW_NO -- 解冻机关法律文书号码
    ,${iml_schema}.timeformat_max2(P1.UNLOST_TIME) -- 解挂时间
    ,P1.OUT_SIGN_USER_ID -- 解挂柜员编号
    ,P1.REAL_RESTRAINT_AMT -- 可扣划金额
    ,P1.DEDUCTION_LAW_NO -- 扣划法律文书号码
    ,P1.DEDUCTION_JUDICIARY_NAME -- 有权机关名称
    ,P1.COURT_CODE -- 执行机关代码
    ,P1.HELP_OPTION -- 协助执行事项
    ,P1.JUDICIARY_OFFICER_NAME -- 执法人1名称
    ,nvl(trim(P1.JUDICIARY_DOCUMENT_TYPE),'0000') -- 执法人1证件A类型代码
    ,P1.JUDICIARY_DOCUMENT_ID -- 执法人1证件A号码
    ,nvl(trim(P1.JUDICIARY_DOCUMENT_TYPE2),'0000') -- 执法人1证件B类型代码
    ,P1.JUDICIARY_DOCUMENT_ID2 -- 执法人1证件B号码
    ,P1.JUDICIARY_OTH_OFFICER_NAME -- 执法人2名称
    ,nvl(trim(P1.JUDICIARY_OTH_DOCUMENT_TYPE),'0000') -- 执法人2证件A类型代码
    ,P1.JUDICIARY_OTH_DOCUMENT_ID -- 执法人2证件A号码
    ,nvl(trim(P1.JUDICIARY_OTH_DOCUMENT_TYPE2),'0000') -- 执法人2证件B类型代码
    ,P1.JUDICIARY_OTH_DOCUMENT_ID2 -- 执法人2证件B号码
    ,P1.THAW_OFFICER_NAME -- 经办人1名称
    ,nvl(trim(P1.THAW_DOCUMENT_TYPE),'0000') -- 经办人1证件A类型代码
    ,P1.THAW_DOCUMENT_ID -- 经办人1证件A号码
    ,nvl(trim(P1.THAW_DOCUMENT_TYPE2),'0000') -- 经办人1证件B类型代码
    ,P1.THAW_DOCUMENT_ID2 -- 经办人1证件B号码
    ,P1.THAW_OTH_OFFICER_NAME -- 经办人2名称
    ,nvl(trim(P1.THAW_OTH_DOCUMENT_TYPE),'0000') -- 经办人2证件A类型代码
    ,P1.THAW_OTH_DOCUMENT_ID -- 经办人2证件A号码
    ,nvl(trim(P1.THAW_OTH_DOCUMENT_TYPE2),'0000') -- 经办人2证件B类型代码
    ,P1.THAW_OTH_DOCUMENT_ID2 -- 经办人2证件B号码
    ,nvl(trim(P1.DEDUCTION_LAW_TYPE),'0000') -- 证明人证件类型代码
    ,nvl(trim(P1.SOURCE_MODULE),'-') -- 源模块类型代码
    ,P1.SIGN_CHANNEL -- 签约渠道编号
    ,P1.SIGN_USER_ID -- 签约柜员编号
    ,P1.APPR_USER_ID -- 复核柜员编号
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,P1.LAST_CHANGE_USER_ID -- 最后修改柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_restraints' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_restraints p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.oth_base_acct_no = p8.base_acct_no
   and p8.base_acct_no like '0%'
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p9 on p1.PLEDGED_BASE_ACCT_NO = p9.BASE_ACCT_NO and p9.BASE_ACCT_NO LIKE '0%'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,acct_id
  	                                        ,tran_lmt_type_cd
  	                                        ,lmt_id
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
        into ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,tran_lmt_type_cd -- 交易限制类型代码
    ,lmt_id -- 限制编号
    ,acct_lmt_status_cd -- 账户限制状态代码
    ,lmt_acct_range_cd -- 限制账户范围代码
    ,acct_lmt_amt -- 账户限制金额
    ,sub_lmt_cate_cd -- 子限制类别代码
    ,actl_ctrl_amt -- 实际控制金额
    ,actl_effect_dt -- 实际生效日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,ova_flow_num -- 全局流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,acct_aldy_check_flg -- 账户已复核标志
    ,acct_check_dt -- 账户复核日期
    ,tran_ref_no -- 交易参考号
    ,tran_cd -- 交易码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_memo_descb -- 交易摘要描述
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_amt -- 交易金额
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,cntpty_acct_prod_id -- 交易对手账户产品编号
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_cust_acct_num -- 交易对手客户账号
    ,cntpty_curr_cd -- 交易对手币种代码
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,vouch_type_cd -- 凭证类型代码
    ,begin_check_id -- 起始支票编号
    ,begin_amt -- 起始金额
    ,termnt_check_id -- 终止支票编号
    ,stop_amt -- 截止金额
    ,aldy_paid_amt -- 已还金额
    ,pay_amt -- 支付金额
    ,tot_pay_cnt -- 总支付笔数
    ,aldy_pay_cnt -- 已支付笔数
    ,interp_flg -- 中断标志
    ,pm_flg -- 抵质押标志
    ,mtg_acct_id -- 抵押账户编号
    ,mtg_cust_acct_num -- 抵押客户账号
    ,mtg_acct_curr_cd -- 抵押账户币种代码
    ,mtg_acct_type_cd -- 抵押账户类型代码
    ,matn_way_cd -- 维护方式代码
    ,stl_flow_id -- 结算流水编号
    ,check_entry_code -- 对账编码
    ,revs_flg -- 冲正标志
    ,wait_to_froz_seq_num -- 轮候冻结序号
    ,full_amt_froz_flg -- 全额冻结标志
    ,ct_froz_flg -- 续冻标志
    ,froz_org_name -- 冻结机关名称
    ,froz_org_law_doc_num -- 冻结机关法律文书号码
    ,froz_lev -- 冻结级别
    ,unfrz_org_name -- 解冻机关名称
    ,unfrz_org_law_doc_num -- 解冻机关法律文书号码
    ,unloss_tm -- 解挂时间
    ,unloss_teller_id -- 解挂柜员编号
    ,can_deduct_amt -- 可扣划金额
    ,deduct_law_doc_num -- 扣划法律文书号码
    ,auth_org_name -- 有权机关名称
    ,exec_org_cd -- 执行机关代码
    ,asit_exec_item -- 协助执行事项
    ,enforc_ps_1_name -- 执法人1名称
    ,enforc_ps_1_cert_a_type_cd -- 执法人1证件A类型代码
    ,enforc_ps_1_cert_a_no -- 执法人1证件A号码
    ,enforc_ps_1_cert_b_type_cd -- 执法人1证件B类型代码
    ,enforc_ps_1_cert_b_no -- 执法人1证件B号码
    ,enforc_ps_2_name -- 执法人2名称
    ,enforc_ps_2_cert_a_type_cd -- 执法人2证件A类型代码
    ,enforc_ps_2_cert_a_no -- 执法人2证件A号码
    ,enforc_ps_2_cert_b_type_cd -- 执法人2证件B类型代码
    ,enforc_ps_2_cert_b_no -- 执法人2证件B号码
    ,operr_1_name -- 经办人1名称
    ,operr_1_cert_a_type_cd -- 经办人1证件A类型代码
    ,operr_1_cert_a_no -- 经办人1证件A号码
    ,operr_1_cert_b_type_cd -- 经办人1证件B类型代码
    ,operr_1_cert_b_no -- 经办人1证件B号码
    ,operr_2_name -- 经办人2名称
    ,operr_2_cert_a_type_cd -- 经办人2证件A类型代码
    ,operr_2_cert_a_no -- 经办人2证件A号码
    ,operr_2_cert_b_type_cd -- 经办人2证件B类型代码
    ,operr_2_cert_b_no -- 经办人2证件B号码
    ,proof_cate_cd -- 证明人证件类型代码
    ,src_module_type_cd -- 源模块类型代码
    ,sign_chn_id -- 签约渠道编号
    ,sign_teller_id -- 签约柜员编号
    ,check_teller_id -- 复核柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,tran_lmt_type_cd -- 交易限制类型代码
    ,lmt_id -- 限制编号
    ,acct_lmt_status_cd -- 账户限制状态代码
    ,lmt_acct_range_cd -- 限制账户范围代码
    ,acct_lmt_amt -- 账户限制金额
    ,sub_lmt_cate_cd -- 子限制类别代码
    ,actl_ctrl_amt -- 实际控制金额
    ,actl_effect_dt -- 实际生效日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,ova_flow_num -- 全局流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,acct_aldy_check_flg -- 账户已复核标志
    ,acct_check_dt -- 账户复核日期
    ,tran_ref_no -- 交易参考号
    ,tran_cd -- 交易码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_memo_descb -- 交易摘要描述
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_amt -- 交易金额
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,cntpty_acct_prod_id -- 交易对手账户产品编号
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_cust_acct_num -- 交易对手客户账号
    ,cntpty_curr_cd -- 交易对手币种代码
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,vouch_type_cd -- 凭证类型代码
    ,begin_check_id -- 起始支票编号
    ,begin_amt -- 起始金额
    ,termnt_check_id -- 终止支票编号
    ,stop_amt -- 截止金额
    ,aldy_paid_amt -- 已还金额
    ,pay_amt -- 支付金额
    ,tot_pay_cnt -- 总支付笔数
    ,aldy_pay_cnt -- 已支付笔数
    ,interp_flg -- 中断标志
    ,pm_flg -- 抵质押标志
    ,mtg_acct_id -- 抵押账户编号
    ,mtg_cust_acct_num -- 抵押客户账号
    ,mtg_acct_curr_cd -- 抵押账户币种代码
    ,mtg_acct_type_cd -- 抵押账户类型代码
    ,matn_way_cd -- 维护方式代码
    ,stl_flow_id -- 结算流水编号
    ,check_entry_code -- 对账编码
    ,revs_flg -- 冲正标志
    ,wait_to_froz_seq_num -- 轮候冻结序号
    ,full_amt_froz_flg -- 全额冻结标志
    ,ct_froz_flg -- 续冻标志
    ,froz_org_name -- 冻结机关名称
    ,froz_org_law_doc_num -- 冻结机关法律文书号码
    ,froz_lev -- 冻结级别
    ,unfrz_org_name -- 解冻机关名称
    ,unfrz_org_law_doc_num -- 解冻机关法律文书号码
    ,unloss_tm -- 解挂时间
    ,unloss_teller_id -- 解挂柜员编号
    ,can_deduct_amt -- 可扣划金额
    ,deduct_law_doc_num -- 扣划法律文书号码
    ,auth_org_name -- 有权机关名称
    ,exec_org_cd -- 执行机关代码
    ,asit_exec_item -- 协助执行事项
    ,enforc_ps_1_name -- 执法人1名称
    ,enforc_ps_1_cert_a_type_cd -- 执法人1证件A类型代码
    ,enforc_ps_1_cert_a_no -- 执法人1证件A号码
    ,enforc_ps_1_cert_b_type_cd -- 执法人1证件B类型代码
    ,enforc_ps_1_cert_b_no -- 执法人1证件B号码
    ,enforc_ps_2_name -- 执法人2名称
    ,enforc_ps_2_cert_a_type_cd -- 执法人2证件A类型代码
    ,enforc_ps_2_cert_a_no -- 执法人2证件A号码
    ,enforc_ps_2_cert_b_type_cd -- 执法人2证件B类型代码
    ,enforc_ps_2_cert_b_no -- 执法人2证件B号码
    ,operr_1_name -- 经办人1名称
    ,operr_1_cert_a_type_cd -- 经办人1证件A类型代码
    ,operr_1_cert_a_no -- 经办人1证件A号码
    ,operr_1_cert_b_type_cd -- 经办人1证件B类型代码
    ,operr_1_cert_b_no -- 经办人1证件B号码
    ,operr_2_name -- 经办人2名称
    ,operr_2_cert_a_type_cd -- 经办人2证件A类型代码
    ,operr_2_cert_a_no -- 经办人2证件A号码
    ,operr_2_cert_b_type_cd -- 经办人2证件B类型代码
    ,operr_2_cert_b_no -- 经办人2证件B号码
    ,proof_cate_cd -- 证明人证件类型代码
    ,src_module_type_cd -- 源模块类型代码
    ,sign_chn_id -- 签约渠道编号
    ,sign_teller_id -- 签约柜员编号
    ,check_teller_id -- 复核柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
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
    ,nvl(n.tran_lmt_type_cd, o.tran_lmt_type_cd) as tran_lmt_type_cd -- 交易限制类型代码
    ,nvl(n.lmt_id, o.lmt_id) as lmt_id -- 限制编号
    ,nvl(n.acct_lmt_status_cd, o.acct_lmt_status_cd) as acct_lmt_status_cd -- 账户限制状态代码
    ,nvl(n.lmt_acct_range_cd, o.lmt_acct_range_cd) as lmt_acct_range_cd -- 限制账户范围代码
    ,nvl(n.acct_lmt_amt, o.acct_lmt_amt) as acct_lmt_amt -- 账户限制金额
    ,nvl(n.sub_lmt_cate_cd, o.sub_lmt_cate_cd) as sub_lmt_cate_cd -- 子限制类别代码
    ,nvl(n.actl_ctrl_amt, o.actl_ctrl_amt) as actl_ctrl_amt -- 实际控制金额
    ,nvl(n.actl_effect_dt, o.actl_effect_dt) as actl_effect_dt -- 实际生效日期
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.ova_flow_num, o.ova_flow_num) as ova_flow_num -- 全局流水号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.dep_tenor, o.dep_tenor) as dep_tenor -- 存款期限
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.acct_aldy_check_flg, o.acct_aldy_check_flg) as acct_aldy_check_flg -- 账户已复核标志
    ,nvl(n.acct_check_dt, o.acct_check_dt) as acct_check_dt -- 账户复核日期
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.tran_cd, o.tran_cd) as tran_cd -- 交易码
    ,nvl(n.tran_chn_cd, o.tran_chn_cd) as tran_chn_cd -- 交易渠道代码
    ,nvl(n.tran_memo_descb, o.tran_memo_descb) as tran_memo_descb -- 交易摘要描述
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.cntpty_acct_prod_id, o.cntpty_acct_prod_id) as cntpty_acct_prod_id -- 交易对手账户产品编号
    ,nvl(n.cntpty_acct_id, o.cntpty_acct_id) as cntpty_acct_id -- 交易对手账户编号
    ,nvl(n.cntpty_acct_name, o.cntpty_acct_name) as cntpty_acct_name -- 交易对手账户名称
    ,nvl(n.cntpty_cust_acct_num, o.cntpty_cust_acct_num) as cntpty_cust_acct_num -- 交易对手客户账号
    ,nvl(n.cntpty_curr_cd, o.cntpty_curr_cd) as cntpty_curr_cd -- 交易对手币种代码
    ,nvl(n.cntpty_open_acct_org_id, o.cntpty_open_acct_org_id) as cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,nvl(n.vouch_type_cd, o.vouch_type_cd) as vouch_type_cd -- 凭证类型代码
    ,nvl(n.begin_check_id, o.begin_check_id) as begin_check_id -- 起始支票编号
    ,nvl(n.begin_amt, o.begin_amt) as begin_amt -- 起始金额
    ,nvl(n.termnt_check_id, o.termnt_check_id) as termnt_check_id -- 终止支票编号
    ,nvl(n.stop_amt, o.stop_amt) as stop_amt -- 截止金额
    ,nvl(n.aldy_paid_amt, o.aldy_paid_amt) as aldy_paid_amt -- 已还金额
    ,nvl(n.pay_amt, o.pay_amt) as pay_amt -- 支付金额
    ,nvl(n.tot_pay_cnt, o.tot_pay_cnt) as tot_pay_cnt -- 总支付笔数
    ,nvl(n.aldy_pay_cnt, o.aldy_pay_cnt) as aldy_pay_cnt -- 已支付笔数
    ,nvl(n.interp_flg, o.interp_flg) as interp_flg -- 中断标志
    ,nvl(n.pm_flg, o.pm_flg) as pm_flg -- 抵质押标志
    ,nvl(n.mtg_acct_id, o.mtg_acct_id) as mtg_acct_id -- 抵押账户编号
    ,nvl(n.mtg_cust_acct_num, o.mtg_cust_acct_num) as mtg_cust_acct_num -- 抵押客户账号
    ,nvl(n.mtg_acct_curr_cd, o.mtg_acct_curr_cd) as mtg_acct_curr_cd -- 抵押账户币种代码
    ,nvl(n.mtg_acct_type_cd, o.mtg_acct_type_cd) as mtg_acct_type_cd -- 抵押账户类型代码
    ,nvl(n.matn_way_cd, o.matn_way_cd) as matn_way_cd -- 维护方式代码
    ,nvl(n.stl_flow_id, o.stl_flow_id) as stl_flow_id -- 结算流水编号
    ,nvl(n.check_entry_code, o.check_entry_code) as check_entry_code -- 对账编码
    ,nvl(n.revs_flg, o.revs_flg) as revs_flg -- 冲正标志
    ,nvl(n.wait_to_froz_seq_num, o.wait_to_froz_seq_num) as wait_to_froz_seq_num -- 轮候冻结序号
    ,nvl(n.full_amt_froz_flg, o.full_amt_froz_flg) as full_amt_froz_flg -- 全额冻结标志
    ,nvl(n.ct_froz_flg, o.ct_froz_flg) as ct_froz_flg -- 续冻标志
    ,nvl(n.froz_org_name, o.froz_org_name) as froz_org_name -- 冻结机关名称
    ,nvl(n.froz_org_law_doc_num, o.froz_org_law_doc_num) as froz_org_law_doc_num -- 冻结机关法律文书号码
    ,nvl(n.froz_lev, o.froz_lev) as froz_lev -- 冻结级别
    ,nvl(n.unfrz_org_name, o.unfrz_org_name) as unfrz_org_name -- 解冻机关名称
    ,nvl(n.unfrz_org_law_doc_num, o.unfrz_org_law_doc_num) as unfrz_org_law_doc_num -- 解冻机关法律文书号码
    ,nvl(n.unloss_tm, o.unloss_tm) as unloss_tm -- 解挂时间
    ,nvl(n.unloss_teller_id, o.unloss_teller_id) as unloss_teller_id -- 解挂柜员编号
    ,nvl(n.can_deduct_amt, o.can_deduct_amt) as can_deduct_amt -- 可扣划金额
    ,nvl(n.deduct_law_doc_num, o.deduct_law_doc_num) as deduct_law_doc_num -- 扣划法律文书号码
    ,nvl(n.auth_org_name, o.auth_org_name) as auth_org_name -- 有权机关名称
    ,nvl(n.exec_org_cd, o.exec_org_cd) as exec_org_cd -- 执行机关代码
    ,nvl(n.asit_exec_item, o.asit_exec_item) as asit_exec_item -- 协助执行事项
    ,nvl(n.enforc_ps_1_name, o.enforc_ps_1_name) as enforc_ps_1_name -- 执法人1名称
    ,nvl(n.enforc_ps_1_cert_a_type_cd, o.enforc_ps_1_cert_a_type_cd) as enforc_ps_1_cert_a_type_cd -- 执法人1证件A类型代码
    ,nvl(n.enforc_ps_1_cert_a_no, o.enforc_ps_1_cert_a_no) as enforc_ps_1_cert_a_no -- 执法人1证件A号码
    ,nvl(n.enforc_ps_1_cert_b_type_cd, o.enforc_ps_1_cert_b_type_cd) as enforc_ps_1_cert_b_type_cd -- 执法人1证件B类型代码
    ,nvl(n.enforc_ps_1_cert_b_no, o.enforc_ps_1_cert_b_no) as enforc_ps_1_cert_b_no -- 执法人1证件B号码
    ,nvl(n.enforc_ps_2_name, o.enforc_ps_2_name) as enforc_ps_2_name -- 执法人2名称
    ,nvl(n.enforc_ps_2_cert_a_type_cd, o.enforc_ps_2_cert_a_type_cd) as enforc_ps_2_cert_a_type_cd -- 执法人2证件A类型代码
    ,nvl(n.enforc_ps_2_cert_a_no, o.enforc_ps_2_cert_a_no) as enforc_ps_2_cert_a_no -- 执法人2证件A号码
    ,nvl(n.enforc_ps_2_cert_b_type_cd, o.enforc_ps_2_cert_b_type_cd) as enforc_ps_2_cert_b_type_cd -- 执法人2证件B类型代码
    ,nvl(n.enforc_ps_2_cert_b_no, o.enforc_ps_2_cert_b_no) as enforc_ps_2_cert_b_no -- 执法人2证件B号码
    ,nvl(n.operr_1_name, o.operr_1_name) as operr_1_name -- 经办人1名称
    ,nvl(n.operr_1_cert_a_type_cd, o.operr_1_cert_a_type_cd) as operr_1_cert_a_type_cd -- 经办人1证件A类型代码
    ,nvl(n.operr_1_cert_a_no, o.operr_1_cert_a_no) as operr_1_cert_a_no -- 经办人1证件A号码
    ,nvl(n.operr_1_cert_b_type_cd, o.operr_1_cert_b_type_cd) as operr_1_cert_b_type_cd -- 经办人1证件B类型代码
    ,nvl(n.operr_1_cert_b_no, o.operr_1_cert_b_no) as operr_1_cert_b_no -- 经办人1证件B号码
    ,nvl(n.operr_2_name, o.operr_2_name) as operr_2_name -- 经办人2名称
    ,nvl(n.operr_2_cert_a_type_cd, o.operr_2_cert_a_type_cd) as operr_2_cert_a_type_cd -- 经办人2证件A类型代码
    ,nvl(n.operr_2_cert_a_no, o.operr_2_cert_a_no) as operr_2_cert_a_no -- 经办人2证件A号码
    ,nvl(n.operr_2_cert_b_type_cd, o.operr_2_cert_b_type_cd) as operr_2_cert_b_type_cd -- 经办人2证件B类型代码
    ,nvl(n.operr_2_cert_b_no, o.operr_2_cert_b_no) as operr_2_cert_b_no -- 经办人2证件B号码
    ,nvl(n.proof_cate_cd, o.proof_cate_cd) as proof_cate_cd -- 证明人证件类型代码
    ,nvl(n.src_module_type_cd, o.src_module_type_cd) as src_module_type_cd -- 源模块类型代码
    ,nvl(n.sign_chn_id, o.sign_chn_id) as sign_chn_id -- 签约渠道编号
    ,nvl(n.sign_teller_id, o.sign_teller_id) as sign_teller_id -- 签约柜员编号
    ,nvl(n.check_teller_id, o.check_teller_id) as check_teller_id -- 复核柜员编号
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.final_modif_teller_id, o.final_modif_teller_id) as final_modif_teller_id -- 最后修改柜员编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.tran_lmt_type_cd is null
            and n.lmt_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.tran_lmt_type_cd is null
            and n.lmt_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.tran_lmt_type_cd is null
            and n.lmt_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.tran_lmt_type_cd = n.tran_lmt_type_cd
            and o.lmt_id = n.lmt_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.acct_id is null
        and o.tran_lmt_type_cd is null
        and o.lmt_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.acct_id is null
        and n.tran_lmt_type_cd is null
        and n.lmt_id is null
    )
    or (
        o.acct_lmt_status_cd <> n.acct_lmt_status_cd
        or o.lmt_acct_range_cd <> n.lmt_acct_range_cd
        or o.acct_lmt_amt <> n.acct_lmt_amt
        or o.sub_lmt_cate_cd <> n.sub_lmt_cate_cd
        or o.actl_ctrl_amt <> n.actl_ctrl_amt
        or o.actl_effect_dt <> n.actl_effect_dt
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.ova_flow_num <> n.ova_flow_num
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.dep_tenor <> n.dep_tenor
        or o.tenor_type_cd <> n.tenor_type_cd
        or o.acct_aldy_check_flg <> n.acct_aldy_check_flg
        or o.acct_check_dt <> n.acct_check_dt
        or o.tran_ref_no <> n.tran_ref_no
        or o.tran_cd <> n.tran_cd
        or o.tran_chn_cd <> n.tran_chn_cd
        or o.tran_memo_descb <> n.tran_memo_descb
        or o.tran_dt <> n.tran_dt
        or o.tran_tm <> n.tran_tm
        or o.tran_amt <> n.tran_amt
        or o.tran_teller_id <> n.tran_teller_id
        or o.tran_org_id <> n.tran_org_id
        or o.cntpty_acct_prod_id <> n.cntpty_acct_prod_id
        or o.cntpty_acct_id <> n.cntpty_acct_id
        or o.cntpty_acct_name <> n.cntpty_acct_name
        or o.cntpty_cust_acct_num <> n.cntpty_cust_acct_num
        or o.cntpty_curr_cd <> n.cntpty_curr_cd
        or o.cntpty_open_acct_org_id <> n.cntpty_open_acct_org_id
        or o.vouch_type_cd <> n.vouch_type_cd
        or o.begin_check_id <> n.begin_check_id
        or o.begin_amt <> n.begin_amt
        or o.termnt_check_id <> n.termnt_check_id
        or o.stop_amt <> n.stop_amt
        or o.aldy_paid_amt <> n.aldy_paid_amt
        or o.pay_amt <> n.pay_amt
        or o.tot_pay_cnt <> n.tot_pay_cnt
        or o.aldy_pay_cnt <> n.aldy_pay_cnt
        or o.interp_flg <> n.interp_flg
        or o.pm_flg <> n.pm_flg
        or o.mtg_acct_id <> n.mtg_acct_id
        or o.mtg_cust_acct_num <> n.mtg_cust_acct_num
        or o.mtg_acct_curr_cd <> n.mtg_acct_curr_cd
        or o.mtg_acct_type_cd <> n.mtg_acct_type_cd
        or o.matn_way_cd <> n.matn_way_cd
        or o.stl_flow_id <> n.stl_flow_id
        or o.check_entry_code <> n.check_entry_code
        or o.revs_flg <> n.revs_flg
        or o.wait_to_froz_seq_num <> n.wait_to_froz_seq_num
        or o.full_amt_froz_flg <> n.full_amt_froz_flg
        or o.ct_froz_flg <> n.ct_froz_flg
        or o.froz_org_name <> n.froz_org_name
        or o.froz_org_law_doc_num <> n.froz_org_law_doc_num
        or o.froz_lev <> n.froz_lev
        or o.unfrz_org_name <> n.unfrz_org_name
        or o.unfrz_org_law_doc_num <> n.unfrz_org_law_doc_num
        or o.unloss_tm <> n.unloss_tm
        or o.unloss_teller_id <> n.unloss_teller_id
        or o.can_deduct_amt <> n.can_deduct_amt
        or o.deduct_law_doc_num <> n.deduct_law_doc_num
        or o.auth_org_name <> n.auth_org_name
        or o.exec_org_cd <> n.exec_org_cd
        or o.asit_exec_item <> n.asit_exec_item
        or o.enforc_ps_1_name <> n.enforc_ps_1_name
        or o.enforc_ps_1_cert_a_type_cd <> n.enforc_ps_1_cert_a_type_cd
        or o.enforc_ps_1_cert_a_no <> n.enforc_ps_1_cert_a_no
        or o.enforc_ps_1_cert_b_type_cd <> n.enforc_ps_1_cert_b_type_cd
        or o.enforc_ps_1_cert_b_no <> n.enforc_ps_1_cert_b_no
        or o.enforc_ps_2_name <> n.enforc_ps_2_name
        or o.enforc_ps_2_cert_a_type_cd <> n.enforc_ps_2_cert_a_type_cd
        or o.enforc_ps_2_cert_a_no <> n.enforc_ps_2_cert_a_no
        or o.enforc_ps_2_cert_b_type_cd <> n.enforc_ps_2_cert_b_type_cd
        or o.enforc_ps_2_cert_b_no <> n.enforc_ps_2_cert_b_no
        or o.operr_1_name <> n.operr_1_name
        or o.operr_1_cert_a_type_cd <> n.operr_1_cert_a_type_cd
        or o.operr_1_cert_a_no <> n.operr_1_cert_a_no
        or o.operr_1_cert_b_type_cd <> n.operr_1_cert_b_type_cd
        or o.operr_1_cert_b_no <> n.operr_1_cert_b_no
        or o.operr_2_name <> n.operr_2_name
        or o.operr_2_cert_a_type_cd <> n.operr_2_cert_a_type_cd
        or o.operr_2_cert_a_no <> n.operr_2_cert_a_no
        or o.operr_2_cert_b_type_cd <> n.operr_2_cert_b_type_cd
        or o.operr_2_cert_b_no <> n.operr_2_cert_b_no
        or o.proof_cate_cd <> n.proof_cate_cd
        or o.src_module_type_cd <> n.src_module_type_cd
        or o.sign_chn_id <> n.sign_chn_id
        or o.sign_teller_id <> n.sign_teller_id
        or o.check_teller_id <> n.check_teller_id
        or o.auth_teller_id <> n.auth_teller_id
        or o.final_modif_dt <> n.final_modif_dt
        or o.final_modif_teller_id <> n.final_modif_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,tran_lmt_type_cd -- 交易限制类型代码
    ,lmt_id -- 限制编号
    ,acct_lmt_status_cd -- 账户限制状态代码
    ,lmt_acct_range_cd -- 限制账户范围代码
    ,acct_lmt_amt -- 账户限制金额
    ,sub_lmt_cate_cd -- 子限制类别代码
    ,actl_ctrl_amt -- 实际控制金额
    ,actl_effect_dt -- 实际生效日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,ova_flow_num -- 全局流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,acct_aldy_check_flg -- 账户已复核标志
    ,acct_check_dt -- 账户复核日期
    ,tran_ref_no -- 交易参考号
    ,tran_cd -- 交易码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_memo_descb -- 交易摘要描述
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_amt -- 交易金额
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,cntpty_acct_prod_id -- 交易对手账户产品编号
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_cust_acct_num -- 交易对手客户账号
    ,cntpty_curr_cd -- 交易对手币种代码
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,vouch_type_cd -- 凭证类型代码
    ,begin_check_id -- 起始支票编号
    ,begin_amt -- 起始金额
    ,termnt_check_id -- 终止支票编号
    ,stop_amt -- 截止金额
    ,aldy_paid_amt -- 已还金额
    ,pay_amt -- 支付金额
    ,tot_pay_cnt -- 总支付笔数
    ,aldy_pay_cnt -- 已支付笔数
    ,interp_flg -- 中断标志
    ,pm_flg -- 抵质押标志
    ,mtg_acct_id -- 抵押账户编号
    ,mtg_cust_acct_num -- 抵押客户账号
    ,mtg_acct_curr_cd -- 抵押账户币种代码
    ,mtg_acct_type_cd -- 抵押账户类型代码
    ,matn_way_cd -- 维护方式代码
    ,stl_flow_id -- 结算流水编号
    ,check_entry_code -- 对账编码
    ,revs_flg -- 冲正标志
    ,wait_to_froz_seq_num -- 轮候冻结序号
    ,full_amt_froz_flg -- 全额冻结标志
    ,ct_froz_flg -- 续冻标志
    ,froz_org_name -- 冻结机关名称
    ,froz_org_law_doc_num -- 冻结机关法律文书号码
    ,froz_lev -- 冻结级别
    ,unfrz_org_name -- 解冻机关名称
    ,unfrz_org_law_doc_num -- 解冻机关法律文书号码
    ,unloss_tm -- 解挂时间
    ,unloss_teller_id -- 解挂柜员编号
    ,can_deduct_amt -- 可扣划金额
    ,deduct_law_doc_num -- 扣划法律文书号码
    ,auth_org_name -- 有权机关名称
    ,exec_org_cd -- 执行机关代码
    ,asit_exec_item -- 协助执行事项
    ,enforc_ps_1_name -- 执法人1名称
    ,enforc_ps_1_cert_a_type_cd -- 执法人1证件A类型代码
    ,enforc_ps_1_cert_a_no -- 执法人1证件A号码
    ,enforc_ps_1_cert_b_type_cd -- 执法人1证件B类型代码
    ,enforc_ps_1_cert_b_no -- 执法人1证件B号码
    ,enforc_ps_2_name -- 执法人2名称
    ,enforc_ps_2_cert_a_type_cd -- 执法人2证件A类型代码
    ,enforc_ps_2_cert_a_no -- 执法人2证件A号码
    ,enforc_ps_2_cert_b_type_cd -- 执法人2证件B类型代码
    ,enforc_ps_2_cert_b_no -- 执法人2证件B号码
    ,operr_1_name -- 经办人1名称
    ,operr_1_cert_a_type_cd -- 经办人1证件A类型代码
    ,operr_1_cert_a_no -- 经办人1证件A号码
    ,operr_1_cert_b_type_cd -- 经办人1证件B类型代码
    ,operr_1_cert_b_no -- 经办人1证件B号码
    ,operr_2_name -- 经办人2名称
    ,operr_2_cert_a_type_cd -- 经办人2证件A类型代码
    ,operr_2_cert_a_no -- 经办人2证件A号码
    ,operr_2_cert_b_type_cd -- 经办人2证件B类型代码
    ,operr_2_cert_b_no -- 经办人2证件B号码
    ,proof_cate_cd -- 证明人证件类型代码
    ,src_module_type_cd -- 源模块类型代码
    ,sign_chn_id -- 签约渠道编号
    ,sign_teller_id -- 签约柜员编号
    ,check_teller_id -- 复核柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,tran_lmt_type_cd -- 交易限制类型代码
    ,lmt_id -- 限制编号
    ,acct_lmt_status_cd -- 账户限制状态代码
    ,lmt_acct_range_cd -- 限制账户范围代码
    ,acct_lmt_amt -- 账户限制金额
    ,sub_lmt_cate_cd -- 子限制类别代码
    ,actl_ctrl_amt -- 实际控制金额
    ,actl_effect_dt -- 实际生效日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,ova_flow_num -- 全局流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,acct_aldy_check_flg -- 账户已复核标志
    ,acct_check_dt -- 账户复核日期
    ,tran_ref_no -- 交易参考号
    ,tran_cd -- 交易码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_memo_descb -- 交易摘要描述
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_amt -- 交易金额
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,cntpty_acct_prod_id -- 交易对手账户产品编号
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_cust_acct_num -- 交易对手客户账号
    ,cntpty_curr_cd -- 交易对手币种代码
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,vouch_type_cd -- 凭证类型代码
    ,begin_check_id -- 起始支票编号
    ,begin_amt -- 起始金额
    ,termnt_check_id -- 终止支票编号
    ,stop_amt -- 截止金额
    ,aldy_paid_amt -- 已还金额
    ,pay_amt -- 支付金额
    ,tot_pay_cnt -- 总支付笔数
    ,aldy_pay_cnt -- 已支付笔数
    ,interp_flg -- 中断标志
    ,pm_flg -- 抵质押标志
    ,mtg_acct_id -- 抵押账户编号
    ,mtg_cust_acct_num -- 抵押客户账号
    ,mtg_acct_curr_cd -- 抵押账户币种代码
    ,mtg_acct_type_cd -- 抵押账户类型代码
    ,matn_way_cd -- 维护方式代码
    ,stl_flow_id -- 结算流水编号
    ,check_entry_code -- 对账编码
    ,revs_flg -- 冲正标志
    ,wait_to_froz_seq_num -- 轮候冻结序号
    ,full_amt_froz_flg -- 全额冻结标志
    ,ct_froz_flg -- 续冻标志
    ,froz_org_name -- 冻结机关名称
    ,froz_org_law_doc_num -- 冻结机关法律文书号码
    ,froz_lev -- 冻结级别
    ,unfrz_org_name -- 解冻机关名称
    ,unfrz_org_law_doc_num -- 解冻机关法律文书号码
    ,unloss_tm -- 解挂时间
    ,unloss_teller_id -- 解挂柜员编号
    ,can_deduct_amt -- 可扣划金额
    ,deduct_law_doc_num -- 扣划法律文书号码
    ,auth_org_name -- 有权机关名称
    ,exec_org_cd -- 执行机关代码
    ,asit_exec_item -- 协助执行事项
    ,enforc_ps_1_name -- 执法人1名称
    ,enforc_ps_1_cert_a_type_cd -- 执法人1证件A类型代码
    ,enforc_ps_1_cert_a_no -- 执法人1证件A号码
    ,enforc_ps_1_cert_b_type_cd -- 执法人1证件B类型代码
    ,enforc_ps_1_cert_b_no -- 执法人1证件B号码
    ,enforc_ps_2_name -- 执法人2名称
    ,enforc_ps_2_cert_a_type_cd -- 执法人2证件A类型代码
    ,enforc_ps_2_cert_a_no -- 执法人2证件A号码
    ,enforc_ps_2_cert_b_type_cd -- 执法人2证件B类型代码
    ,enforc_ps_2_cert_b_no -- 执法人2证件B号码
    ,operr_1_name -- 经办人1名称
    ,operr_1_cert_a_type_cd -- 经办人1证件A类型代码
    ,operr_1_cert_a_no -- 经办人1证件A号码
    ,operr_1_cert_b_type_cd -- 经办人1证件B类型代码
    ,operr_1_cert_b_no -- 经办人1证件B号码
    ,operr_2_name -- 经办人2名称
    ,operr_2_cert_a_type_cd -- 经办人2证件A类型代码
    ,operr_2_cert_a_no -- 经办人2证件A号码
    ,operr_2_cert_b_type_cd -- 经办人2证件B类型代码
    ,operr_2_cert_b_no -- 经办人2证件B号码
    ,proof_cate_cd -- 证明人证件类型代码
    ,src_module_type_cd -- 源模块类型代码
    ,sign_chn_id -- 签约渠道编号
    ,sign_teller_id -- 签约柜员编号
    ,check_teller_id -- 复核柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
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
    ,o.tran_lmt_type_cd -- 交易限制类型代码
    ,o.lmt_id -- 限制编号
    ,o.acct_lmt_status_cd -- 账户限制状态代码
    ,o.lmt_acct_range_cd -- 限制账户范围代码
    ,o.acct_lmt_amt -- 账户限制金额
    ,o.sub_lmt_cate_cd -- 子限制类别代码
    ,o.actl_ctrl_amt -- 实际控制金额
    ,o.actl_effect_dt -- 实际生效日期
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.ova_flow_num -- 全局流水号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.dep_tenor -- 存款期限
    ,o.tenor_type_cd -- 期限类型代码
    ,o.acct_aldy_check_flg -- 账户已复核标志
    ,o.acct_check_dt -- 账户复核日期
    ,o.tran_ref_no -- 交易参考号
    ,o.tran_cd -- 交易码
    ,o.tran_chn_cd -- 交易渠道代码
    ,o.tran_memo_descb -- 交易摘要描述
    ,o.tran_dt -- 交易日期
    ,o.tran_tm -- 交易时间
    ,o.tran_amt -- 交易金额
    ,o.tran_teller_id -- 交易柜员编号
    ,o.tran_org_id -- 交易机构编号
    ,o.cntpty_acct_prod_id -- 交易对手账户产品编号
    ,o.cntpty_acct_id -- 交易对手账户编号
    ,o.cntpty_acct_name -- 交易对手账户名称
    ,o.cntpty_cust_acct_num -- 交易对手客户账号
    ,o.cntpty_curr_cd -- 交易对手币种代码
    ,o.cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,o.vouch_type_cd -- 凭证类型代码
    ,o.begin_check_id -- 起始支票编号
    ,o.begin_amt -- 起始金额
    ,o.termnt_check_id -- 终止支票编号
    ,o.stop_amt -- 截止金额
    ,o.aldy_paid_amt -- 已还金额
    ,o.pay_amt -- 支付金额
    ,o.tot_pay_cnt -- 总支付笔数
    ,o.aldy_pay_cnt -- 已支付笔数
    ,o.interp_flg -- 中断标志
    ,o.pm_flg -- 抵质押标志
    ,o.mtg_acct_id -- 抵押账户编号
    ,o.mtg_cust_acct_num -- 抵押客户账号
    ,o.mtg_acct_curr_cd -- 抵押账户币种代码
    ,o.mtg_acct_type_cd -- 抵押账户类型代码
    ,o.matn_way_cd -- 维护方式代码
    ,o.stl_flow_id -- 结算流水编号
    ,o.check_entry_code -- 对账编码
    ,o.revs_flg -- 冲正标志
    ,o.wait_to_froz_seq_num -- 轮候冻结序号
    ,o.full_amt_froz_flg -- 全额冻结标志
    ,o.ct_froz_flg -- 续冻标志
    ,o.froz_org_name -- 冻结机关名称
    ,o.froz_org_law_doc_num -- 冻结机关法律文书号码
    ,o.froz_lev -- 冻结级别
    ,o.unfrz_org_name -- 解冻机关名称
    ,o.unfrz_org_law_doc_num -- 解冻机关法律文书号码
    ,o.unloss_tm -- 解挂时间
    ,o.unloss_teller_id -- 解挂柜员编号
    ,o.can_deduct_amt -- 可扣划金额
    ,o.deduct_law_doc_num -- 扣划法律文书号码
    ,o.auth_org_name -- 有权机关名称
    ,o.exec_org_cd -- 执行机关代码
    ,o.asit_exec_item -- 协助执行事项
    ,o.enforc_ps_1_name -- 执法人1名称
    ,o.enforc_ps_1_cert_a_type_cd -- 执法人1证件A类型代码
    ,o.enforc_ps_1_cert_a_no -- 执法人1证件A号码
    ,o.enforc_ps_1_cert_b_type_cd -- 执法人1证件B类型代码
    ,o.enforc_ps_1_cert_b_no -- 执法人1证件B号码
    ,o.enforc_ps_2_name -- 执法人2名称
    ,o.enforc_ps_2_cert_a_type_cd -- 执法人2证件A类型代码
    ,o.enforc_ps_2_cert_a_no -- 执法人2证件A号码
    ,o.enforc_ps_2_cert_b_type_cd -- 执法人2证件B类型代码
    ,o.enforc_ps_2_cert_b_no -- 执法人2证件B号码
    ,o.operr_1_name -- 经办人1名称
    ,o.operr_1_cert_a_type_cd -- 经办人1证件A类型代码
    ,o.operr_1_cert_a_no -- 经办人1证件A号码
    ,o.operr_1_cert_b_type_cd -- 经办人1证件B类型代码
    ,o.operr_1_cert_b_no -- 经办人1证件B号码
    ,o.operr_2_name -- 经办人2名称
    ,o.operr_2_cert_a_type_cd -- 经办人2证件A类型代码
    ,o.operr_2_cert_a_no -- 经办人2证件A号码
    ,o.operr_2_cert_b_type_cd -- 经办人2证件B类型代码
    ,o.operr_2_cert_b_no -- 经办人2证件B号码
    ,o.proof_cate_cd -- 证明人证件类型代码
    ,o.src_module_type_cd -- 源模块类型代码
    ,o.sign_chn_id -- 签约渠道编号
    ,o.sign_teller_id -- 签约柜员编号
    ,o.check_teller_id -- 复核柜员编号
    ,o.auth_teller_id -- 授权柜员编号
    ,o.final_modif_dt -- 最后修改日期
    ,o.final_modif_teller_id -- 最后修改柜员编号
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
from ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.tran_lmt_type_cd = n.tran_lmt_type_cd
            and o.lmt_id = n.lmt_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.acct_id = d.acct_id
            and o.tran_lmt_type_cd = d.tran_lmt_type_cd
            and o.lmt_id = d.lmt_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_dep_acct_lmt_info_h;
--alter table ${iml_schema}.agt_dep_acct_lmt_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_dep_acct_lmt_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_dep_acct_lmt_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_dep_acct_lmt_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_dep_acct_lmt_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_dep_acct_lmt_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dep_acct_lmt_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_dep_acct_lmt_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dep_acct_lmt_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
