/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ap_register_info_h_icmsf1
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
alter table ${iml_schema}.agt_ap_register_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ap_register_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ap_register_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_ap_register_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_ap_register_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_ap_register_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ap_register_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,prop_id -- 方案编号
    ,prop_name -- 方案名称
    ,cust_name -- 客户名称
    ,disp_type_cd -- 处置类型代码
    ,cont_amt -- 合同金额
    ,cont_bal -- 合同余额
    ,fin_acct_recvbl -- 财务应收款
    ,in_bs_int_bal -- 表内利息余额
    ,off_bs_int_bal -- 表外利息余额
    ,cred_rht_amt -- 债权金额
    ,loan_sucs_tran_idf -- 贷款成功转让标识
    ,tran_amt -- 转让金额
    ,seller_invstg_agent_org_name -- 卖方尽职调查中介机构名称
    ,buyer_name -- 买受人名称
    ,suit_stage_law_fee_amt -- 诉讼阶段法律性费用金额
    ,ckwrf_asset_pric_bal -- 账销案存资产本金余额
    ,ckwrf_asset_inbsoverint_bal -- 账销案存资产表内欠息余额
    ,ckwrf_asset_offbsoverint_bal -- 账销案存资产表外欠息余额
    ,prop_descb -- 方案描述
    ,risk_asset_comb -- 风险资产组合
    ,exec_status_cd -- 执行状态代码
    ,pkg_dt -- 封包日期
    ,tran_type_cd -- 转让类型代码
    ,curr_cd -- 币种代码
    ,modif_post_org_id -- 变更后机构编号
    ,advc_suit_fee -- 代垫诉讼费
    ,pay_way_cd -- 付款方式代码
    ,first_pay_amt -- 首付金额
    ,tran_cont_id -- 转让合同编号
    ,tran_cont_begin_dt -- 转让合同起始日期
    ,tran_cont_exp_dt -- 转让合同到期日期
    ,tran_tran_plat -- 转让交易平台代码
    ,tran_tran_plat_descb -- 转让交易平台描述
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_type_cd -- 交易对手类型代码
    ,cntpty_open_bank_num -- 交易对手开户行号
    ,cntpty_open_bank_name -- 交易对手开户行名称
    ,cntpty_tran_acct_dt -- 交易对手转账日期
    ,input_flg -- 补录标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ap_register_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_ap_register_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ap_register_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_ap_register_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ap_register_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_ap_register_program-1
insert into ${iml_schema}.agt_ap_register_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,prop_id -- 方案编号
    ,prop_name -- 方案名称
    ,cust_name -- 客户名称
    ,disp_type_cd -- 处置类型代码
    ,cont_amt -- 合同金额
    ,cont_bal -- 合同余额
    ,fin_acct_recvbl -- 财务应收款
    ,in_bs_int_bal -- 表内利息余额
    ,off_bs_int_bal -- 表外利息余额
    ,cred_rht_amt -- 债权金额
    ,loan_sucs_tran_idf -- 贷款成功转让标识
    ,tran_amt -- 转让金额
    ,seller_invstg_agent_org_name -- 卖方尽职调查中介机构名称
    ,buyer_name -- 买受人名称
    ,suit_stage_law_fee_amt -- 诉讼阶段法律性费用金额
    ,ckwrf_asset_pric_bal -- 账销案存资产本金余额
    ,ckwrf_asset_inbsoverint_bal -- 账销案存资产表内欠息余额
    ,ckwrf_asset_offbsoverint_bal -- 账销案存资产表外欠息余额
    ,prop_descb -- 方案描述
    ,risk_asset_comb -- 风险资产组合
    ,exec_status_cd -- 执行状态代码
    ,pkg_dt -- 封包日期
    ,tran_type_cd -- 转让类型代码
    ,curr_cd -- 币种代码
    ,modif_post_org_id -- 变更后机构编号
    ,advc_suit_fee -- 代垫诉讼费
    ,pay_way_cd -- 付款方式代码
    ,first_pay_amt -- 首付金额
    ,tran_cont_id -- 转让合同编号
    ,tran_cont_begin_dt -- 转让合同起始日期
    ,tran_cont_exp_dt -- 转让合同到期日期
    ,tran_tran_plat -- 转让交易平台代码
    ,tran_tran_plat_descb -- 转让交易平台描述
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_type_cd -- 交易对手类型代码
    ,cntpty_open_bank_num -- 交易对手开户行号
    ,cntpty_open_bank_name -- 交易对手开户行名称
    ,cntpty_tran_acct_dt -- 交易对手转账日期
    ,input_flg -- 补录标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300038'||P1.SERIALNO||p1.programno -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 流水号
    ,P1.PROGRAMNO -- 方案编号
    ,P1.PROGRAMNAME -- 方案名称
    ,P1.CUSTOMERNAME -- 客户名称
    ,nvl(trim(P1.HANDLETYPE),'-') -- 处置类型代码
    ,P1.BUSINESSSUM -- 合同金额
    ,P1.BALANCESUM -- 合同余额
    ,P1.RECEIVEAMONUT -- 财务应收款
    ,P1.ONINTERESTSUM -- 表内利息余额
    ,P1.OUTINTERESTSUM -- 表外利息余额
    ,P1.PECUNIACREDITASUM -- 债权金额
    ,P1.ONACCOUNTNO -- 贷款成功转让标识
    ,P1.TRANSFERPRICE -- 转让金额
    ,P1.RESPINVESTIGATIONORG -- 卖方尽职调查中介机构名称
    ,P1.VENDEENAME -- 买受人名称
    ,P1.LITIGATIONPHASECOST -- 诉讼阶段法律性费用金额
    ,P1.CANCELACCOUNTCAPBALDEPOS -- 账销案存资产本金余额
    ,P1.CANCELACCOUNTCAPINOWEBALANCE -- 账销案存资产表内欠息余额
    ,P1.CANCELACCOUNTCAPOUTOWEBALANCE -- 账销案存资产表外欠息余额
    ,P1.SUMMARIZE -- 方案描述
    ,P1.RISKASSETLIST -- 风险资产组合
    ,nvl(trim(P1.EXECUTESTATUS),'-') -- 执行状态代码
    ,P1.PACKAGEDATE -- 封包日期
    ,nvl(trim(P1.TRANSFERFLAG),'-') -- 转让类型代码
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.TRANSFERORG -- 变更后机构编号
    ,P1.AGENTLEGALFEE -- 代垫诉讼费
    ,P1.REPAYMODE -- 付款方式代码
    ,P1.DOWNPAYMENT -- 首付金额
    ,P1.TRANSCONTRACTNO -- 转让合同编号
    ,P1.TRANSCONTRACTSTARTDATE -- 转让合同起始日期
    ,P1.TRANSCONTRACTENDDATE -- 转让合同到期日期
    ,nvl(trim(P1.TRANSTRADPLATFORM),'QT') -- 转让交易平台代码
    ,P1.TRANSTRADPLATFORMCUS -- 转让交易平台描述
    ,P1.COUNTERPARTYACCT -- 交易对手账户编号
    ,P1.COUNTERPARTYACCTNAME -- 交易对手账户名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.COUNTERPARTYACCTTYPE END -- 交易对手类型代码
    ,P1.OPENBANKNO -- 交易对手开户行号
    ,P1.OPENBANKNAME -- 交易对手开户行名称
    ,P1.COUNTERPARTYPAYDATE -- 交易对手转账日期
    ,nvl(trim(P1.ISADDREC),'-') -- 补录标志
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_ap_register_program' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ap_register_program p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.COUNTERPARTYACCTTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_AP_REGISTER_PROGRAM'
        AND R1.SRC_FIELD_EN_NAME= 'COUNTERPARTYACCTTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_AP_REGISTER_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CNTPTY_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ap_register_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
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
        into ${iml_schema}.agt_ap_register_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,prop_id -- 方案编号
    ,prop_name -- 方案名称
    ,cust_name -- 客户名称
    ,disp_type_cd -- 处置类型代码
    ,cont_amt -- 合同金额
    ,cont_bal -- 合同余额
    ,fin_acct_recvbl -- 财务应收款
    ,in_bs_int_bal -- 表内利息余额
    ,off_bs_int_bal -- 表外利息余额
    ,cred_rht_amt -- 债权金额
    ,loan_sucs_tran_idf -- 贷款成功转让标识
    ,tran_amt -- 转让金额
    ,seller_invstg_agent_org_name -- 卖方尽职调查中介机构名称
    ,buyer_name -- 买受人名称
    ,suit_stage_law_fee_amt -- 诉讼阶段法律性费用金额
    ,ckwrf_asset_pric_bal -- 账销案存资产本金余额
    ,ckwrf_asset_inbsoverint_bal -- 账销案存资产表内欠息余额
    ,ckwrf_asset_offbsoverint_bal -- 账销案存资产表外欠息余额
    ,prop_descb -- 方案描述
    ,risk_asset_comb -- 风险资产组合
    ,exec_status_cd -- 执行状态代码
    ,pkg_dt -- 封包日期
    ,tran_type_cd -- 转让类型代码
    ,curr_cd -- 币种代码
    ,modif_post_org_id -- 变更后机构编号
    ,advc_suit_fee -- 代垫诉讼费
    ,pay_way_cd -- 付款方式代码
    ,first_pay_amt -- 首付金额
    ,tran_cont_id -- 转让合同编号
    ,tran_cont_begin_dt -- 转让合同起始日期
    ,tran_cont_exp_dt -- 转让合同到期日期
    ,tran_tran_plat -- 转让交易平台代码
    ,tran_tran_plat_descb -- 转让交易平台描述
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_type_cd -- 交易对手类型代码
    ,cntpty_open_bank_num -- 交易对手开户行号
    ,cntpty_open_bank_name -- 交易对手开户行名称
    ,cntpty_tran_acct_dt -- 交易对手转账日期
    ,input_flg -- 补录标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ap_register_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,prop_id -- 方案编号
    ,prop_name -- 方案名称
    ,cust_name -- 客户名称
    ,disp_type_cd -- 处置类型代码
    ,cont_amt -- 合同金额
    ,cont_bal -- 合同余额
    ,fin_acct_recvbl -- 财务应收款
    ,in_bs_int_bal -- 表内利息余额
    ,off_bs_int_bal -- 表外利息余额
    ,cred_rht_amt -- 债权金额
    ,loan_sucs_tran_idf -- 贷款成功转让标识
    ,tran_amt -- 转让金额
    ,seller_invstg_agent_org_name -- 卖方尽职调查中介机构名称
    ,buyer_name -- 买受人名称
    ,suit_stage_law_fee_amt -- 诉讼阶段法律性费用金额
    ,ckwrf_asset_pric_bal -- 账销案存资产本金余额
    ,ckwrf_asset_inbsoverint_bal -- 账销案存资产表内欠息余额
    ,ckwrf_asset_offbsoverint_bal -- 账销案存资产表外欠息余额
    ,prop_descb -- 方案描述
    ,risk_asset_comb -- 风险资产组合
    ,exec_status_cd -- 执行状态代码
    ,pkg_dt -- 封包日期
    ,tran_type_cd -- 转让类型代码
    ,curr_cd -- 币种代码
    ,modif_post_org_id -- 变更后机构编号
    ,advc_suit_fee -- 代垫诉讼费
    ,pay_way_cd -- 付款方式代码
    ,first_pay_amt -- 首付金额
    ,tran_cont_id -- 转让合同编号
    ,tran_cont_begin_dt -- 转让合同起始日期
    ,tran_cont_exp_dt -- 转让合同到期日期
    ,tran_tran_plat -- 转让交易平台代码
    ,tran_tran_plat_descb -- 转让交易平台描述
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_type_cd -- 交易对手类型代码
    ,cntpty_open_bank_num -- 交易对手开户行号
    ,cntpty_open_bank_name -- 交易对手开户行名称
    ,cntpty_tran_acct_dt -- 交易对手转账日期
    ,input_flg -- 补录标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
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
    ,nvl(n.flow_num, o.flow_num) as flow_num -- 流水号
    ,nvl(n.prop_id, o.prop_id) as prop_id -- 方案编号
    ,nvl(n.prop_name, o.prop_name) as prop_name -- 方案名称
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.disp_type_cd, o.disp_type_cd) as disp_type_cd -- 处置类型代码
    ,nvl(n.cont_amt, o.cont_amt) as cont_amt -- 合同金额
    ,nvl(n.cont_bal, o.cont_bal) as cont_bal -- 合同余额
    ,nvl(n.fin_acct_recvbl, o.fin_acct_recvbl) as fin_acct_recvbl -- 财务应收款
    ,nvl(n.in_bs_int_bal, o.in_bs_int_bal) as in_bs_int_bal -- 表内利息余额
    ,nvl(n.off_bs_int_bal, o.off_bs_int_bal) as off_bs_int_bal -- 表外利息余额
    ,nvl(n.cred_rht_amt, o.cred_rht_amt) as cred_rht_amt -- 债权金额
    ,nvl(n.loan_sucs_tran_idf, o.loan_sucs_tran_idf) as loan_sucs_tran_idf -- 贷款成功转让标识
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 转让金额
    ,nvl(n.seller_invstg_agent_org_name, o.seller_invstg_agent_org_name) as seller_invstg_agent_org_name -- 卖方尽职调查中介机构名称
    ,nvl(n.buyer_name, o.buyer_name) as buyer_name -- 买受人名称
    ,nvl(n.suit_stage_law_fee_amt, o.suit_stage_law_fee_amt) as suit_stage_law_fee_amt -- 诉讼阶段法律性费用金额
    ,nvl(n.ckwrf_asset_pric_bal, o.ckwrf_asset_pric_bal) as ckwrf_asset_pric_bal -- 账销案存资产本金余额
    ,nvl(n.ckwrf_asset_inbsoverint_bal, o.ckwrf_asset_inbsoverint_bal) as ckwrf_asset_inbsoverint_bal -- 账销案存资产表内欠息余额
    ,nvl(n.ckwrf_asset_offbsoverint_bal, o.ckwrf_asset_offbsoverint_bal) as ckwrf_asset_offbsoverint_bal -- 账销案存资产表外欠息余额
    ,nvl(n.prop_descb, o.prop_descb) as prop_descb -- 方案描述
    ,nvl(n.risk_asset_comb, o.risk_asset_comb) as risk_asset_comb -- 风险资产组合
    ,nvl(n.exec_status_cd, o.exec_status_cd) as exec_status_cd -- 执行状态代码
    ,nvl(n.pkg_dt, o.pkg_dt) as pkg_dt -- 封包日期
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 转让类型代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.modif_post_org_id, o.modif_post_org_id) as modif_post_org_id -- 变更后机构编号
    ,nvl(n.advc_suit_fee, o.advc_suit_fee) as advc_suit_fee -- 代垫诉讼费
    ,nvl(n.pay_way_cd, o.pay_way_cd) as pay_way_cd -- 付款方式代码
    ,nvl(n.first_pay_amt, o.first_pay_amt) as first_pay_amt -- 首付金额
    ,nvl(n.tran_cont_id, o.tran_cont_id) as tran_cont_id -- 转让合同编号
    ,nvl(n.tran_cont_begin_dt, o.tran_cont_begin_dt) as tran_cont_begin_dt -- 转让合同起始日期
    ,nvl(n.tran_cont_exp_dt, o.tran_cont_exp_dt) as tran_cont_exp_dt -- 转让合同到期日期
    ,nvl(n.tran_tran_plat, o.tran_tran_plat) as tran_tran_plat -- 转让交易平台代码
    ,nvl(n.tran_tran_plat_descb, o.tran_tran_plat_descb) as tran_tran_plat_descb -- 转让交易平台描述
    ,nvl(n.cntpty_acct_id, o.cntpty_acct_id) as cntpty_acct_id -- 交易对手账户编号
    ,nvl(n.cntpty_acct_name, o.cntpty_acct_name) as cntpty_acct_name -- 交易对手账户名称
    ,nvl(n.cntpty_type_cd, o.cntpty_type_cd) as cntpty_type_cd -- 交易对手类型代码
    ,nvl(n.cntpty_open_bank_num, o.cntpty_open_bank_num) as cntpty_open_bank_num -- 交易对手开户行号
    ,nvl(n.cntpty_open_bank_name, o.cntpty_open_bank_name) as cntpty_open_bank_name -- 交易对手开户行名称
    ,nvl(n.cntpty_tran_acct_dt, o.cntpty_tran_acct_dt) as cntpty_tran_acct_dt -- 交易对手转账日期
    ,nvl(n.input_flg, o.input_flg) as input_flg -- 补录标志
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.up_date, o.up_date) as up_date -- 更新日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ap_register_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_ap_register_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.flow_num <> n.flow_num
        or o.prop_id <> n.prop_id
        or o.prop_name <> n.prop_name
        or o.cust_name <> n.cust_name
        or o.disp_type_cd <> n.disp_type_cd
        or o.cont_amt <> n.cont_amt
        or o.cont_bal <> n.cont_bal
        or o.fin_acct_recvbl <> n.fin_acct_recvbl
        or o.in_bs_int_bal <> n.in_bs_int_bal
        or o.off_bs_int_bal <> n.off_bs_int_bal
        or o.cred_rht_amt <> n.cred_rht_amt
        or o.loan_sucs_tran_idf <> n.loan_sucs_tran_idf
        or o.tran_amt <> n.tran_amt
        or o.seller_invstg_agent_org_name <> n.seller_invstg_agent_org_name
        or o.buyer_name <> n.buyer_name
        or o.suit_stage_law_fee_amt <> n.suit_stage_law_fee_amt
        or o.ckwrf_asset_pric_bal <> n.ckwrf_asset_pric_bal
        or o.ckwrf_asset_inbsoverint_bal <> n.ckwrf_asset_inbsoverint_bal
        or o.ckwrf_asset_offbsoverint_bal <> n.ckwrf_asset_offbsoverint_bal
        or o.prop_descb <> n.prop_descb
        or o.risk_asset_comb <> n.risk_asset_comb
        or o.exec_status_cd <> n.exec_status_cd
        or o.pkg_dt <> n.pkg_dt
        or o.tran_type_cd <> n.tran_type_cd
        or o.curr_cd <> n.curr_cd
        or o.modif_post_org_id <> n.modif_post_org_id
        or o.advc_suit_fee <> n.advc_suit_fee
        or o.pay_way_cd <> n.pay_way_cd
        or o.first_pay_amt <> n.first_pay_amt
        or o.tran_cont_id <> n.tran_cont_id
        or o.tran_cont_begin_dt <> n.tran_cont_begin_dt
        or o.tran_cont_exp_dt <> n.tran_cont_exp_dt
        or o.tran_tran_plat <> n.tran_tran_plat
        or o.tran_tran_plat_descb <> n.tran_tran_plat_descb
        or o.cntpty_acct_id <> n.cntpty_acct_id
        or o.cntpty_acct_name <> n.cntpty_acct_name
        or o.cntpty_type_cd <> n.cntpty_type_cd
        or o.cntpty_open_bank_num <> n.cntpty_open_bank_num
        or o.cntpty_open_bank_name <> n.cntpty_open_bank_name
        or o.cntpty_tran_acct_dt <> n.cntpty_tran_acct_dt
        or o.input_flg <> n.input_flg
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.up_date <> n.up_date
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ap_register_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,prop_id -- 方案编号
    ,prop_name -- 方案名称
    ,cust_name -- 客户名称
    ,disp_type_cd -- 处置类型代码
    ,cont_amt -- 合同金额
    ,cont_bal -- 合同余额
    ,fin_acct_recvbl -- 财务应收款
    ,in_bs_int_bal -- 表内利息余额
    ,off_bs_int_bal -- 表外利息余额
    ,cred_rht_amt -- 债权金额
    ,loan_sucs_tran_idf -- 贷款成功转让标识
    ,tran_amt -- 转让金额
    ,seller_invstg_agent_org_name -- 卖方尽职调查中介机构名称
    ,buyer_name -- 买受人名称
    ,suit_stage_law_fee_amt -- 诉讼阶段法律性费用金额
    ,ckwrf_asset_pric_bal -- 账销案存资产本金余额
    ,ckwrf_asset_inbsoverint_bal -- 账销案存资产表内欠息余额
    ,ckwrf_asset_offbsoverint_bal -- 账销案存资产表外欠息余额
    ,prop_descb -- 方案描述
    ,risk_asset_comb -- 风险资产组合
    ,exec_status_cd -- 执行状态代码
    ,pkg_dt -- 封包日期
    ,tran_type_cd -- 转让类型代码
    ,curr_cd -- 币种代码
    ,modif_post_org_id -- 变更后机构编号
    ,advc_suit_fee -- 代垫诉讼费
    ,pay_way_cd -- 付款方式代码
    ,first_pay_amt -- 首付金额
    ,tran_cont_id -- 转让合同编号
    ,tran_cont_begin_dt -- 转让合同起始日期
    ,tran_cont_exp_dt -- 转让合同到期日期
    ,tran_tran_plat -- 转让交易平台代码
    ,tran_tran_plat_descb -- 转让交易平台描述
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_type_cd -- 交易对手类型代码
    ,cntpty_open_bank_num -- 交易对手开户行号
    ,cntpty_open_bank_name -- 交易对手开户行名称
    ,cntpty_tran_acct_dt -- 交易对手转账日期
    ,input_flg -- 补录标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ap_register_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,prop_id -- 方案编号
    ,prop_name -- 方案名称
    ,cust_name -- 客户名称
    ,disp_type_cd -- 处置类型代码
    ,cont_amt -- 合同金额
    ,cont_bal -- 合同余额
    ,fin_acct_recvbl -- 财务应收款
    ,in_bs_int_bal -- 表内利息余额
    ,off_bs_int_bal -- 表外利息余额
    ,cred_rht_amt -- 债权金额
    ,loan_sucs_tran_idf -- 贷款成功转让标识
    ,tran_amt -- 转让金额
    ,seller_invstg_agent_org_name -- 卖方尽职调查中介机构名称
    ,buyer_name -- 买受人名称
    ,suit_stage_law_fee_amt -- 诉讼阶段法律性费用金额
    ,ckwrf_asset_pric_bal -- 账销案存资产本金余额
    ,ckwrf_asset_inbsoverint_bal -- 账销案存资产表内欠息余额
    ,ckwrf_asset_offbsoverint_bal -- 账销案存资产表外欠息余额
    ,prop_descb -- 方案描述
    ,risk_asset_comb -- 风险资产组合
    ,exec_status_cd -- 执行状态代码
    ,pkg_dt -- 封包日期
    ,tran_type_cd -- 转让类型代码
    ,curr_cd -- 币种代码
    ,modif_post_org_id -- 变更后机构编号
    ,advc_suit_fee -- 代垫诉讼费
    ,pay_way_cd -- 付款方式代码
    ,first_pay_amt -- 首付金额
    ,tran_cont_id -- 转让合同编号
    ,tran_cont_begin_dt -- 转让合同起始日期
    ,tran_cont_exp_dt -- 转让合同到期日期
    ,tran_tran_plat -- 转让交易平台代码
    ,tran_tran_plat_descb -- 转让交易平台描述
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_type_cd -- 交易对手类型代码
    ,cntpty_open_bank_num -- 交易对手开户行号
    ,cntpty_open_bank_name -- 交易对手开户行名称
    ,cntpty_tran_acct_dt -- 交易对手转账日期
    ,input_flg -- 补录标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
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
    ,o.flow_num -- 流水号
    ,o.prop_id -- 方案编号
    ,o.prop_name -- 方案名称
    ,o.cust_name -- 客户名称
    ,o.disp_type_cd -- 处置类型代码
    ,o.cont_amt -- 合同金额
    ,o.cont_bal -- 合同余额
    ,o.fin_acct_recvbl -- 财务应收款
    ,o.in_bs_int_bal -- 表内利息余额
    ,o.off_bs_int_bal -- 表外利息余额
    ,o.cred_rht_amt -- 债权金额
    ,o.loan_sucs_tran_idf -- 贷款成功转让标识
    ,o.tran_amt -- 转让金额
    ,o.seller_invstg_agent_org_name -- 卖方尽职调查中介机构名称
    ,o.buyer_name -- 买受人名称
    ,o.suit_stage_law_fee_amt -- 诉讼阶段法律性费用金额
    ,o.ckwrf_asset_pric_bal -- 账销案存资产本金余额
    ,o.ckwrf_asset_inbsoverint_bal -- 账销案存资产表内欠息余额
    ,o.ckwrf_asset_offbsoverint_bal -- 账销案存资产表外欠息余额
    ,o.prop_descb -- 方案描述
    ,o.risk_asset_comb -- 风险资产组合
    ,o.exec_status_cd -- 执行状态代码
    ,o.pkg_dt -- 封包日期
    ,o.tran_type_cd -- 转让类型代码
    ,o.curr_cd -- 币种代码
    ,o.modif_post_org_id -- 变更后机构编号
    ,o.advc_suit_fee -- 代垫诉讼费
    ,o.pay_way_cd -- 付款方式代码
    ,o.first_pay_amt -- 首付金额
    ,o.tran_cont_id -- 转让合同编号
    ,o.tran_cont_begin_dt -- 转让合同起始日期
    ,o.tran_cont_exp_dt -- 转让合同到期日期
    ,o.tran_tran_plat -- 转让交易平台代码
    ,o.tran_tran_plat_descb -- 转让交易平台描述
    ,o.cntpty_acct_id -- 交易对手账户编号
    ,o.cntpty_acct_name -- 交易对手账户名称
    ,o.cntpty_type_cd -- 交易对手类型代码
    ,o.cntpty_open_bank_num -- 交易对手开户行号
    ,o.cntpty_open_bank_name -- 交易对手开户行名称
    ,o.cntpty_tran_acct_dt -- 交易对手转账日期
    ,o.input_flg -- 补录标志
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.up_date -- 更新日期
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
from ${iml_schema}.agt_ap_register_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_ap_register_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_ap_register_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_ap_register_info_h;
--alter table ${iml_schema}.agt_ap_register_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_ap_register_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_ap_register_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_ap_register_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_ap_register_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_ap_register_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_ap_register_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_ap_register_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ap_register_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ap_register_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_ap_register_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_ap_register_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_ap_register_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ap_register_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
