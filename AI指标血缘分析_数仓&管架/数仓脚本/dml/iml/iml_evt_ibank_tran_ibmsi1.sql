/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ibank_tran_ibmsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_ibank_tran_ibmsi1_tm purge;
alter table ${iml_schema}.evt_ibank_tran add partition p_ibmsi1 values ('ibmsi1')(
        subpartition p_ibmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ibank_tran modify partition p_ibmsi1
    add subpartition p_ibmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ibank_tran_ibmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_num -- 交易号
    ,entr_dt -- 委托日期
    ,entr_tm -- 委托时间
    ,cfm_dt -- 确认日期
    ,cfm_tm -- 确认时间
    ,intnal_tran_num -- 内部交易号
    ,ext_tran_num -- 外部交易号
    ,operr_name -- 操作员名称
    ,tran_type_id -- 交易类型编号
    ,ext_cap_acct_id -- 外部资金账户编号
    ,intnal_cap_acct_id -- 内部资金账户编号
    ,ext_secu_acct_id -- 外部证券账户编号
    ,intnal_secu_acct_id -- 内部证券账户编号
    ,cntpty_id -- 交易对手编号
    ,pric_intnal_cap_acct_id -- 本金内部资金账户编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,tran_market_id -- 交易市场编号
    ,fin_instm_name -- 金融工具名称
    ,tran_qtty -- 交易数量
    ,tran_price -- 交易价格
    ,tran_amt -- 交易金额
    ,tran_fee -- 交易费用
    ,stl_dt -- 结算日期
    ,tran_status_cd -- 交易状态代码
    ,stl_way_cd -- 结算方式代码
    ,net_price_amt -- 净价金额
    ,int_recvbl -- 应收利息
    ,quote_tran_num -- 引用交易号
    ,ignore_flg -- 忽略标志
    ,tran_exec_market_id -- 交易执行市场编号
    ,agent_name -- 经办人名称
    ,cntpty_name -- 交易对手名称
    ,evltion_net_price_brkb -- 估值净价偏移度
    ,tran_src_cd -- 交易来源代码
    ,deal_qtty -- 已成交数量
    ,actl_recv_int -- 实收利息
    ,actl_recv_amt -- 实收金额
    ,dealer_name -- 交易员名称
    ,cntpty_zzd_acct_id -- 交易对手中债登账户编号
    ,cntpty_open_bank_num -- 交易对手开户行号
    ,cntpty_acct_num -- 交易对手账号
    ,cntpty_open_bank_name -- 交易对手开户行名称
    ,cntpty_acct_name -- 交易对手账户名称
    ,cbond_yld_rat -- 中债收益率
    ,exp_yld_rat -- 到期收益率
    ,recvbl_uncol_int -- 应收未收利息
    ,operr_id -- 操作员编号
    ,checker_id -- 复核员编号
    ,recvbl_uncol_pric -- 应收未收本金
    ,actl_int -- 实付利息
    ,actl_pric -- 实付本金
    ,ref_type_cd -- 参考类型代码
    ,recvbl_uncol_int_resv_flg -- 应收未收利息保留标志
    ,recvbl_uncol_pric_resv_flg -- 应收未收本金保留标志
    ,dealer_id -- 交易员编号
    ,tran_mode_cd -- 交易模式代码
    ,clear_mode_cd -- 清算模式代码
    ,apv_odd_no -- 审批单号
    ,stl_status_cd -- 结算状态代码
    ,accti_tran_num -- 核算交易号
    ,ftp_int_rat -- FTP利率
    ,assoced_apv_odd_no -- 关联的审批单号
    ,bi_valid_cont_id -- 双边有效合同编号
    ,data_src_cd -- 数据来源代码
    ,nv_dt -- 净值日期
    ,cntpty_swift_cd -- 交易对手SWIFT代码
    ,splt_type_cd -- 拆分类型代码
    ,parent_tran_num -- 父交易号
    ,main_tran_num -- 主交易号
    ,merge_tran_num -- 合交易号
    ,miro_tran_num -- 镜像交易号
    ,rela_tran_num -- 关联交易号
    ,ex_yld_rat -- 行权收益率
    ,cust_mgr_name -- 客户经理姓名
    ,cust_mgr_id -- 客户经理编号
    ,camp_org_id -- 营销机构编号
    ,redem_cfm_dt -- 赎回确认日期
    ,tran_way_cd -- 转账方式代码
    ,dlvy_dt -- 交割日期
    ,cont_id -- 合同编号
    ,cap_dir_descb -- 资金投向描述
    ,final_dir_type_cd -- 最终投向类型代码
    ,rela_ser_num -- 关联序列号
    ,level5_cls_cd -- 五级分类代码
    ,prod_char_cd -- 产品性质代码
    ,curr_lot -- 当前份额
    ,unpay_turn_lot -- 未结转份额
    ,input_dt -- 录入日期
    ,dlvy_site_id -- 交割场所编号
    ,not_stl_comm_fee -- 不结算手续费
    ,int_accr_base_cd -- 计息基准代码
    ,contn_int_flg -- 含息标志
    ,rela_party_info -- 关联方信息
    ,redem_type_cd -- 赎回类型代码
    ,std_prod_id -- 标准产品编号
    ,ftp_id -- FTP编号
    ,is_term -- 是否约期
    ,term_start_day -- 约期开始日
    ,term_end_day -- 约期结束日
    ,bank_cap_acct_open_bank_num -- 银行资金账户开户行号
    ,bank_cap_acct_id -- 银行资金账户编号
    ,th_ssn_redem_flg -- 当季赎回标志
    ,plan_redem_dt -- 计划赎回日期
    ,acct_b_cate_cd -- 账簿类别代码
    ,underly_fin_instm_id -- 标的金融工具编号
    ,underly_asset_type_id -- 标的资产类型编号
    ,underly_tran_market_id -- 标的交易市场编号
    ,lmt_cont_id -- 额度合同编号
    ,sub_acct_num -- 子账号
    ,p_g_bond_flg -- 条线联动债券标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ibank_tran
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ibms_ttrd_otc_trade-
insert into ${iml_schema}.evt_ibank_tran_ibmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_num -- 交易号
    ,entr_dt -- 委托日期
    ,entr_tm -- 委托时间
    ,cfm_dt -- 确认日期
    ,cfm_tm -- 确认时间
    ,intnal_tran_num -- 内部交易号
    ,ext_tran_num -- 外部交易号
    ,operr_name -- 操作员名称
    ,tran_type_id -- 交易类型编号
    ,ext_cap_acct_id -- 外部资金账户编号
    ,intnal_cap_acct_id -- 内部资金账户编号
    ,ext_secu_acct_id -- 外部证券账户编号
    ,intnal_secu_acct_id -- 内部证券账户编号
    ,cntpty_id -- 交易对手编号
    ,pric_intnal_cap_acct_id -- 本金内部资金账户编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,tran_market_id -- 交易市场编号
    ,fin_instm_name -- 金融工具名称
    ,tran_qtty -- 交易数量
    ,tran_price -- 交易价格
    ,tran_amt -- 交易金额
    ,tran_fee -- 交易费用
    ,stl_dt -- 结算日期
    ,tran_status_cd -- 交易状态代码
    ,stl_way_cd -- 结算方式代码
    ,net_price_amt -- 净价金额
    ,int_recvbl -- 应收利息
    ,quote_tran_num -- 引用交易号
    ,ignore_flg -- 忽略标志
    ,tran_exec_market_id -- 交易执行市场编号
    ,agent_name -- 经办人名称
    ,cntpty_name -- 交易对手名称
    ,evltion_net_price_brkb -- 估值净价偏移度
    ,tran_src_cd -- 交易来源代码
    ,deal_qtty -- 已成交数量
    ,actl_recv_int -- 实收利息
    ,actl_recv_amt -- 实收金额
    ,dealer_name -- 交易员名称
    ,cntpty_zzd_acct_id -- 交易对手中债登账户编号
    ,cntpty_open_bank_num -- 交易对手开户行号
    ,cntpty_acct_num -- 交易对手账号
    ,cntpty_open_bank_name -- 交易对手开户行名称
    ,cntpty_acct_name -- 交易对手账户名称
    ,cbond_yld_rat -- 中债收益率
    ,exp_yld_rat -- 到期收益率
    ,recvbl_uncol_int -- 应收未收利息
    ,operr_id -- 操作员编号
    ,checker_id -- 复核员编号
    ,recvbl_uncol_pric -- 应收未收本金
    ,actl_int -- 实付利息
    ,actl_pric -- 实付本金
    ,ref_type_cd -- 参考类型代码
    ,recvbl_uncol_int_resv_flg -- 应收未收利息保留标志
    ,recvbl_uncol_pric_resv_flg -- 应收未收本金保留标志
    ,dealer_id -- 交易员编号
    ,tran_mode_cd -- 交易模式代码
    ,clear_mode_cd -- 清算模式代码
    ,apv_odd_no -- 审批单号
    ,stl_status_cd -- 结算状态代码
    ,accti_tran_num -- 核算交易号
    ,ftp_int_rat -- FTP利率
    ,assoced_apv_odd_no -- 关联的审批单号
    ,bi_valid_cont_id -- 双边有效合同编号
    ,data_src_cd -- 数据来源代码
    ,nv_dt -- 净值日期
    ,cntpty_swift_cd -- 交易对手SWIFT代码
    ,splt_type_cd -- 拆分类型代码
    ,parent_tran_num -- 父交易号
    ,main_tran_num -- 主交易号
    ,merge_tran_num -- 合交易号
    ,miro_tran_num -- 镜像交易号
    ,rela_tran_num -- 关联交易号
    ,ex_yld_rat -- 行权收益率
    ,cust_mgr_name -- 客户经理姓名
    ,cust_mgr_id -- 客户经理编号
    ,camp_org_id -- 营销机构编号
    ,redem_cfm_dt -- 赎回确认日期
    ,tran_way_cd -- 转账方式代码
    ,dlvy_dt -- 交割日期
    ,cont_id -- 合同编号
    ,cap_dir_descb -- 资金投向描述
    ,final_dir_type_cd -- 最终投向类型代码
    ,rela_ser_num -- 关联序列号
    ,level5_cls_cd -- 五级分类代码
    ,prod_char_cd -- 产品性质代码
    ,curr_lot -- 当前份额
    ,unpay_turn_lot -- 未结转份额
    ,input_dt -- 录入日期
    ,dlvy_site_id -- 交割场所编号
    ,not_stl_comm_fee -- 不结算手续费
    ,int_accr_base_cd -- 计息基准代码
    ,contn_int_flg -- 含息标志
    ,rela_party_info -- 关联方信息
    ,redem_type_cd -- 赎回类型代码
    ,std_prod_id -- 标准产品编号
    ,ftp_id -- FTP编号
    ,is_term -- 是否约期
    ,term_start_day -- 约期开始日
    ,term_end_day -- 约期结束日
    ,bank_cap_acct_open_bank_num -- 银行资金账户开户行号
    ,bank_cap_acct_id -- 银行资金账户编号
    ,th_ssn_redem_flg -- 当季赎回标志
    ,plan_redem_dt -- 计划赎回日期
    ,acct_b_cate_cd -- 账簿类别代码
    ,underly_fin_instm_id -- 标的金融工具编号
    ,underly_asset_type_id -- 标的资产类型编号
    ,underly_tran_market_id -- 标的交易市场编号
    ,lmt_cont_id -- 额度合同编号
    ,sub_acct_num -- 子账号
    ,p_g_bond_flg -- 条线联动债券标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104012'||P1.SYSORDID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SYSORDID -- 交易号
    ,${iml_schema}.DATEFORMAT_MIN(P1.ORDDATE) -- 委托日期
    ,P1.ORDTIME -- 委托时间
    ,${iml_schema}.DATEFORMAT_MAX(P1.CONDATE) -- 确认日期
    ,P1.CONTIME -- 确认时间
    ,P1.INTORDID -- 内部交易号
    ,P1.EXTORDID -- 外部交易号
    ,P1.OPERATOR -- 操作员名称
    ,P1.TRDTYPE -- 交易类型编号
    ,P1.CASH_EXT_ACCID -- 外部资金账户编号
    ,P1.CASH_ACCID -- 内部资金账户编号
    ,P1.SECU_EXT_ACCID -- 外部证券账户编号
    ,P1.SECU_ACCID -- 内部证券账户编号
    ,P1.PARTYID -- 交易对手编号
    ,P1.CP_CASH_ACCID -- 本金内部资金账户编号
    ,P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 交易市场编号
    ,P1.I_NAME -- 金融工具名称
    ,P1.ORDCOUNT -- 交易数量
    ,P1.ORDPRICE -- 交易价格
    ,P1.ORDAMOUNT -- 交易金额
    ,P1.TRDFEE -- 交易费用
    ,${iml_schema}.DATEFORMAT_MAX(P1.SETDATE) -- 结算日期
    ,P1.ORDSTATUS -- 交易状态代码
    ,P1.BND_SETTYPE -- 结算方式代码
    ,P1.BND_NETPRICE -- 净价金额
    ,P1.BND_AIAMOUNT -- 应收利息
    ,P1.REF_SYSORDID -- 引用交易号
    ,P1.IGNORE_FLAG -- 忽略标志
    ,P1.EXE_MARKET -- 交易执行市场编号
    ,P1.TRADER -- 经办人名称
    ,P1.TRADER_CP -- 交易对手名称
    ,P1.EVAL_NETPRICE -- 估值净价偏移度
    ,P1.ORDSOURCE -- 交易来源代码
    ,P1.DEAL_COUNT -- 已成交数量
    ,P1.DEAL_AIAMOUNT -- 实收利息
    ,P1.DEAL_AMOUNT -- 实收金额
    ,P1.EXECUTOR -- 交易员名称
    ,P1.PARTY_ZZDACCCODE -- 交易对手中债登账户编号
    ,P1.PARTY_BANK_CODE -- 交易对手开户行号
    ,P1.PARTY_ACCT_CODE -- 交易对手账号
    ,P1.PARTY_BANK_NAME -- 交易对手开户行名称
    ,P1.PARTY_ACCT_NAME -- 交易对手账户名称
    ,P1.EVAL_YTM -- 中债收益率
    ,P1.BND_YTM -- 到期收益率
    ,P1.DUE_AI -- 应收未收利息
    ,P1.OPERATOR_ID -- 操作员编号
    ,P1.EXECUTOR_ID -- 复核员编号
    ,P1.DUE_CP -- 应收未收本金
    ,P1.REAL_AI -- 实付利息
    ,P1.REAL_CP -- 实付本金
    ,P1.REF_TYPE -- 参考类型代码
    ,SUBSTR(P1.IS_REMAIN，2,1) -- 应收未收利息保留标志
    ,SUBSTR(P1.IS_REMAIN，1,1) -- 应收未收本金保留标志
    ,P1.TRADER_ID -- 交易员编号
    ,P1.TRADEMODEL -- 交易模式代码
    ,P1.SETTLEMODEL -- 清算模式代码
    ,P1.ORD_ID -- 审批单号
    ,P1.INSSTATUS -- 结算状态代码
    ,P1.CLOSE_TRADE_ID -- 核算交易号
    ,P1.FTPRATE -- FTP利率
    ,P1.CONN_ORDID -- 关联的审批单号
    ,P1.TWO_EFFECTIVE_CONTRACT -- 双边有效合同编号
    ,P1.SOURCE_TYPE -- 数据来源代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.NAVDATE) -- 净值日期
    ,P1.PARTY_I_SWIFT_CODE -- 交易对手SWIFT代码
    ,P1.SPLIT_INST_TYPE -- 拆分类型代码
    ,P1.CM_ATTR_PARENT -- 父交易号
    ,P1.CM_ATTR_MASTER -- 主交易号
    ,P1.CM_ATTR_MERGE -- 合交易号
    ,P1.CM_ATTR_MIRROR -- 镜像交易号
    ,P1.CM_ATTR_RELATION -- 关联交易号
    ,P1.STRIKE_YTM -- 行权收益率
    ,P1.USER_NAME -- 客户经理姓名
    ,P1.MARKETING_MANAGER_ID -- 客户经理编号
    ,P1.MARKETING_ORG_ID -- 营销机构编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.COM_DATE) -- 赎回确认日期
    ,P1.TRANSFER_TYPE -- 转账方式代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.SECU_SETDATE) -- 交割日期
    ,P1.CTRCT_ID -- 合同编号
    ,P1.INVEST_DIRECTION -- 资金投向描述
    ,substr(P1.FINAL_INVEST,1,10) -- 最终投向类型代码
    ,P1.ASSOCIATEDNUMBER -- 关联序列号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||TO_CHAR(P1.FIVECLASS) END -- 五级分类代码
    ,P1.PROD_NATURE -- 产品性质代码
    ,P1.CURCOUNT -- 当前份额
    ,P1.CAN_DIV_AMOUNT -- 未结转份额
    ,${iml_schema}.DATEFORMAT_MAX(P1.ENTRY_DATE) -- 录入日期
    ,P1.SETTLEMENT_PLACE -- 交割场所编号
    ,P1.TRDFEE_NOTSET -- 不结算手续费
    ,nvl(trim(P1.DAYCOUNTER),'-') -- 计息基准代码
    ,P1.INCLUDE_INTE -- 含息标志
    ,P1.PARTY_RELEVANCE_INFO -- 关联方信息
    ,P1.FULL_FLAG -- 赎回类型代码
    ,nvl(p2.prod_code,' ') -- 标准产品编号
    ,P1.FTP_CODE -- FTP编号
    ,P1.IS_APPOINT_TIME -- 是否约期
    ,${iml_schema}.DATEFORMAT_MAX(P1.APPOINT_START_DATE) -- 约期开始日
    ,${iml_schema}.DATEFORMAT_MAX(P1.APPOINT_END_DATE) -- 约期结束日
    ,P1.BACK_BANK_CODE -- 银行资金账户开户行号
    ,P1.BACK_ACCT_CODE -- 银行资金账户编号
    ,P1.IS_QUARTER_REDEEM -- 当季赎回标志
    ,${iml_schema}.DATEFORMAT_MAX(P1.REDEEM_DATE) -- 计划赎回日期
    ,P1.credit_secu_type -- 账簿类别代码
    ,nvl(trim(p3.U_I_CODE),' ') -- 标的金融工具编号
    ,nvl(trim(p3.U_A_TYPE),' ') -- 标的资产类型编号
    ,nvl(trim(p3.U_M_TYPE),' ') -- 标的交易市场编号
    ,P1.reply_code -- 额度合同编号
    ,P1.sub_acct -- 子账号
    ,nvl(trim(P4.IS_LINKED_BOND),'-') -- 条线联动债券标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_otc_trade' -- 源表名称
    ,'ibmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_otc_trade p1
    left join ${iol_schema}.ibms_ttrd_instrument p2
    on p1.i_code = p2.i_code
   and p1.a_type = p2.a_type
   and p1.m_type = p2.m_type
   and p2.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and p2.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.ibms_ttrd_otc_trade_extend p3
    on p1.sysordid = p3.trd_id
  and p3.start_dt <= to_date('${batch_date}','yyyymmdd') 
  and p3.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.ibms_ttrd_otc_trade_ext p4
    on p1.sysordid = p4.sysordid
  left join ${iml_schema}.ref_pub_cd_map r1
    on to_char(p1.fiveclass) = r1.src_code_val
   and r1.sorc_sys_cd = 'IBMS'
   and r1.src_tab_en_name = 'IBMS_TTRD_OTC_TRADE'
   and r1.src_field_en_name = 'FIVECLASS'
   and r1.target_tab_en_name = 'EVT_IBANK_TRAN'
   and r1.target_tab_field_en_name = 'LEVEL5_CLS_CD'
  left join ${iml_schema}.ref_pub_cd_map r4
    on p1.daycounter = r4.src_code_val
   and r4.sorc_sys_cd = 'IBMS'
   and r4.src_tab_en_name = 'IBMS_TTRD_OTC_TRADE'
   and r4.src_field_en_name = 'DAYCOUNTER'
   and r4.target_tab_en_name = 'EVT_IBANK_TRAN'
   and r4.target_tab_field_en_name = 'INT_ACCR_BASE_CD'
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_ibank_tran truncate partition p_ibmsi1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ibank_tran exchange subpartition p_ibmsi1_${batch_date} with table ${iml_schema}.evt_ibank_tran_ibmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ibank_tran to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ibank_tran_ibmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ibank_tran', partname => 'p_ibmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);