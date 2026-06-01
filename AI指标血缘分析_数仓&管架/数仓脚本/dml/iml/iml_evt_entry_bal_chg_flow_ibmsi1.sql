/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_entry_bal_chg_flow_ibmsi1
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
drop table ${iml_schema}.evt_entry_bal_chg_flow_ibmsi1_tm purge;
alter table ${iml_schema}.evt_entry_bal_chg_flow add partition p_ibmsi1 values ('ibmsi1')(
        subpartition p_ibmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_entry_bal_chg_flow modify partition p_ibmsi1
    add subpartition p_ibmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_entry_bal_chg_flow_ibmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,chg_id -- 变动编号
    ,task_id -- 任务编号
    ,revo_rela_chg_id -- 撤销关联变动编号
    ,chg_dt -- 变动日期
    ,chg_type_cd -- 变动类型代码
    ,obj_id -- 对象编号
    ,instr_id -- 指令编号
    ,ext_secu_acct_id -- 外部证券账户编号
    ,intnal_secu_acct_id -- 内部证券账户编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,tran_id -- 交易编号
    ,extra_dimen_cd -- 额外维度代码
    ,accti_type_cd -- 核算类型代码
    ,actl_qtty -- 实际数量
    ,actl_bal -- 实际余额
    ,net_price_cost -- 净价成本
    ,acru_int -- 应计利息
    ,int_cost -- 利息成本
    ,acru_turn_recvbl_uncol -- 应计转应收未收
    ,recvbl_uncol_turn_actl_recv -- 应收未收转实收
    ,acru_int_theory_attach_provi -- 应计利息理论补计提
    ,acru_int_actl_attach_provi -- 应计利息实际补计提
    ,evha_val_chag -- 公允价值变动
    ,asset_fair_val_pl -- 资产公允价值损益
    ,liab_fair_val_pl -- 负债公允价值损益
    ,recvbl_uncol_bal -- 应收未收余额
    ,recvbl_uncol_net_price_cost -- 应收未收净价成本
    ,recvbl_uncol_acru_int -- 应收未收应计利息
    ,amort_dt -- 摊销日期
    ,int_adj_amt -- 利息调整金额
    ,fair_val_pl -- 公允价值损益
    ,bs_pl -- 买卖损益
    ,int_income -- 利息收入
    ,acru_int_inco -- 应计利息收入
    ,amort_int_income -- 摊销利息收入
    ,curr_post_acru_int_inco -- 当前持仓应计利息收入
    ,curr_post_amort_int_income -- 当前持仓摊销利息收入
    ,update_tm -- 更新时间
    ,curr_issue_acru_int -- 本期应计利息
    ,curr_issue_int_adj -- 本期利息调整
    ,curr_issue_evha_val_chag -- 本期公允价值变动
    ,curr_issue_asset_evha_val_chag -- 本期资产公允价值变动
    ,curr_issue_liab_evha_val_chag -- 本期负债公允价值变动
    ,fee -- 费用
    ,amort_net_price_cost -- 摊余净价成本
    ,amort_int_cost -- 摊余利息成本
    ,actl_int_rat -- 实际利率
    ,invest_yld_rat -- 投资收益率
    ,open_yld_rat -- 开仓收益率
    ,pre_recv_int -- 预收息
    ,non_amort_net_price_cost -- 不摊销净价成本
    ,non_amort_evha_val_chag -- 不摊销公允价值变动
    ,non_amort_fair_val_pl -- 不摊销公允价值损益
    ,non_amort_bs_pl -- 不摊销买卖损益
    ,reset_bf_amort_dt -- 重置前摊销日期
    ,reset_post_amort_closing_dt -- 重置后计提摊销截止日期
    ,reset_bf_amort_closing_dt -- 重置前计提摊销截止日期
    ,impam_status_cd -- 减值状态代码
    ,cost_impam_loss -- 成本减值损失
    ,int_impam_loss -- 利息减值损失
    ,cost_impam_prep -- 成本减值准备
    ,wrtn_off_cost -- 已核销成本
    ,wrtn_off_acru_int -- 已核销应计利息
    ,wrtn_off_recvbl_uncol_int -- 已核销应收未收利息
    ,off_bs_acru_int -- 表外应计利息
    ,off_bs_recvbl_uncol_int -- 表外应收未收利息
    ,reset_bf_reclafy_amort_start_dt -- 重置前重分类摊销开始日期
    ,reset_post_reclafy_amort_start_dt -- 重置后重分类摊销开始日期
    ,reclafy_amort_start_dt_int_cost -- 重分类摊销开始日期利息成本
    ,acru_int_inco_incremt -- 应计利息收入增量
    ,acru_vat -- 应计增值税
    ,paybl_vat -- 应付增值税
    ,reset_bf_evltion_curr_cd -- 重置前估值币种代码
    ,reset_post_evltion_curr_cd -- 重置后估值币种代码
    ,open_int_cost -- 开仓利息成本
    ,open_ex_yld_rat -- 开仓行权收益率
    ,pre_recv_int_income -- 预收利息收入
    ,provi_int_income -- 计提利息收入
    ,int_recvbl_inco -- 应收利息收入
    ,actl_recv_int_income -- 实收利息收入
    ,at_pre_recv_int_income -- 税后预收利息收入
    ,amort_int_income_paybl_vat -- 摊销利息收入应付增值税
    ,bs_pl_paybl_vat -- 买卖损益应付增值税
    ,fee_pl_paybl_vat -- 费用损益应付增值税
    ,ovdue_flg -- 逾期标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_entry_bal_chg_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ibms_ttrd_bookkeeping_secu_chg_his-1
insert into ${iml_schema}.evt_entry_bal_chg_flow_ibmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,chg_id -- 变动编号
    ,task_id -- 任务编号
    ,revo_rela_chg_id -- 撤销关联变动编号
    ,chg_dt -- 变动日期
    ,chg_type_cd -- 变动类型代码
    ,obj_id -- 对象编号
    ,instr_id -- 指令编号
    ,ext_secu_acct_id -- 外部证券账户编号
    ,intnal_secu_acct_id -- 内部证券账户编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,tran_id -- 交易编号
    ,extra_dimen_cd -- 额外维度代码
    ,accti_type_cd -- 核算类型代码
    ,actl_qtty -- 实际数量
    ,actl_bal -- 实际余额
    ,net_price_cost -- 净价成本
    ,acru_int -- 应计利息
    ,int_cost -- 利息成本
    ,acru_turn_recvbl_uncol -- 应计转应收未收
    ,recvbl_uncol_turn_actl_recv -- 应收未收转实收
    ,acru_int_theory_attach_provi -- 应计利息理论补计提
    ,acru_int_actl_attach_provi -- 应计利息实际补计提
    ,evha_val_chag -- 公允价值变动
    ,asset_fair_val_pl -- 资产公允价值损益
    ,liab_fair_val_pl -- 负债公允价值损益
    ,recvbl_uncol_bal -- 应收未收余额
    ,recvbl_uncol_net_price_cost -- 应收未收净价成本
    ,recvbl_uncol_acru_int -- 应收未收应计利息
    ,amort_dt -- 摊销日期
    ,int_adj_amt -- 利息调整金额
    ,fair_val_pl -- 公允价值损益
    ,bs_pl -- 买卖损益
    ,int_income -- 利息收入
    ,acru_int_inco -- 应计利息收入
    ,amort_int_income -- 摊销利息收入
    ,curr_post_acru_int_inco -- 当前持仓应计利息收入
    ,curr_post_amort_int_income -- 当前持仓摊销利息收入
    ,update_tm -- 更新时间
    ,curr_issue_acru_int -- 本期应计利息
    ,curr_issue_int_adj -- 本期利息调整
    ,curr_issue_evha_val_chag -- 本期公允价值变动
    ,curr_issue_asset_evha_val_chag -- 本期资产公允价值变动
    ,curr_issue_liab_evha_val_chag -- 本期负债公允价值变动
    ,fee -- 费用
    ,amort_net_price_cost -- 摊余净价成本
    ,amort_int_cost -- 摊余利息成本
    ,actl_int_rat -- 实际利率
    ,invest_yld_rat -- 投资收益率
    ,open_yld_rat -- 开仓收益率
    ,pre_recv_int -- 预收息
    ,non_amort_net_price_cost -- 不摊销净价成本
    ,non_amort_evha_val_chag -- 不摊销公允价值变动
    ,non_amort_fair_val_pl -- 不摊销公允价值损益
    ,non_amort_bs_pl -- 不摊销买卖损益
    ,reset_bf_amort_dt -- 重置前摊销日期
    ,reset_post_amort_closing_dt -- 重置后计提摊销截止日期
    ,reset_bf_amort_closing_dt -- 重置前计提摊销截止日期
    ,impam_status_cd -- 减值状态代码
    ,cost_impam_loss -- 成本减值损失
    ,int_impam_loss -- 利息减值损失
    ,cost_impam_prep -- 成本减值准备
    ,wrtn_off_cost -- 已核销成本
    ,wrtn_off_acru_int -- 已核销应计利息
    ,wrtn_off_recvbl_uncol_int -- 已核销应收未收利息
    ,off_bs_acru_int -- 表外应计利息
    ,off_bs_recvbl_uncol_int -- 表外应收未收利息
    ,reset_bf_reclafy_amort_start_dt -- 重置前重分类摊销开始日期
    ,reset_post_reclafy_amort_start_dt -- 重置后重分类摊销开始日期
    ,reclafy_amort_start_dt_int_cost -- 重分类摊销开始日期利息成本
    ,acru_int_inco_incremt -- 应计利息收入增量
    ,acru_vat -- 应计增值税
    ,paybl_vat -- 应付增值税
    ,reset_bf_evltion_curr_cd -- 重置前估值币种代码
    ,reset_post_evltion_curr_cd -- 重置后估值币种代码
    ,open_int_cost -- 开仓利息成本
    ,open_ex_yld_rat -- 开仓行权收益率
    ,pre_recv_int_income -- 预收利息收入
    ,provi_int_income -- 计提利息收入
    ,int_recvbl_inco -- 应收利息收入
    ,actl_recv_int_income -- 实收利息收入
    ,at_pre_recv_int_income -- 税后预收利息收入
    ,amort_int_income_paybl_vat -- 摊销利息收入应付增值税
    ,bs_pl_paybl_vat -- 买卖损益应付增值税
    ,fee_pl_paybl_vat -- 费用损益应付增值税
    ,ovdue_flg -- 逾期标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401016'||P1.CHG_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.CHG_ID -- 变动编号
    ,P1.TSK_ID -- 任务编号
    ,P1.ERASE_REF_CHG_ID -- 撤销关联变动编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.CHG_DATE) -- 变动日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CHG_TYPE END -- 变动类型代码
    ,P1.ACCTG_OBJ_ID -- 对象编号
    ,P1.INST_ID -- 指令编号
    ,P1.EXT_SECU_ACCT_ID -- 外部证券账户编号
    ,P1.SECU_ACCT_ID -- 内部证券账户编号
    ,P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,P1.TRADE_ID -- 交易编号
    ,nvl(trim(P1.EXTRA_DIM),'-') -- 额外维度代码
    ,nvl(trim(P1.ESTD_OR_REAL),'-') -- 核算类型代码
    ,P1.REAL_VOLUME -- 实际数量
    ,P1.REAL_AMOUNT -- 实际余额
    ,P1.REAL_CP -- 净价成本
    ,P1.AI -- 应计利息
    ,P1.AI_COST -- 利息成本
    ,P1.AI2RI -- 应计转应收未收
    ,P1.RI2PI -- 应收未收转实收
    ,P1.AI_FILLUP_ESTD -- 应计利息理论补计提
    ,P1.AI_FILLUP_REAL -- 应计利息实际补计提
    ,P1.CHG_FV -- 公允价值变动
    ,P1.CHG_FV_L -- 资产公允价值损益
    ,P1.CHG_FV_S -- 负债公允价值损益
    ,P1.DUE_AMOUNT -- 应收未收余额
    ,P1.DUE_CP -- 应收未收净价成本
    ,P1.DUE_AI -- 应收未收应计利息
    ,${iml_schema}.DATEFORMAT_MIN(P1.AMRT_DATE) -- 摊销日期
    ,P1.AMRT_IR -- 利息调整金额
    ,P1.PRFT_FV -- 公允价值损益
    ,P1.PRFT_TRD -- 买卖损益
    ,P1.PRFT_IR -- 利息收入
    ,P1.PRFT_IR_AI -- 应计利息收入
    ,P1.PRFT_IR_AMRT -- 摊销利息收入
    ,P1.PRFT_IR_AI_HLD -- 当前持仓应计利息收入
    ,P1.PRFT_IR_AMRT_HLD -- 当前持仓摊销利息收入
    ,${iml_schema}.DATEFORMAT_MIN(P1.UPDATE_TIME) -- 更新时间
    ,P1.PERIODIC_AI -- 本期应计利息
    ,P1.PERIODIC_AMRT_IR -- 本期利息调整
    ,P1.PERIODIC_CHG_FV -- 本期公允价值变动
    ,P1.PERIODIC_CHG_FV_L -- 本期资产公允价值变动
    ,P1.PERIODIC_CHG_FV_S -- 本期负债公允价值变动
    ,P1.PRFT_FEE -- 费用
    ,P1.AMRT_COST_CP -- 摊余净价成本
    ,P1.AMRT_COST_AI -- 摊余利息成本
    ,P1.AMRT_YTM -- 实际利率
    ,P1.INVEST_YTM -- 投资收益率
    ,P1.OPEN_YTM -- 开仓收益率
    ,P1.FUTURE_AI -- 预收息
    ,P1.REAL_CP_NOAMRT -- 不摊销净价成本
    ,P1.CHG_FV_NOAMRT -- 不摊销公允价值变动
    ,P1.PRFT_FV_NOAMRT -- 不摊销公允价值损益
    ,P1.PRFT_TRD_NOAMRT -- 不摊销买卖损益
    ,${iml_schema}.DATEFORMAT_MIN(P1.AMRT_DATE_OLD) -- 重置前摊销日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.CALC_DATE) -- 重置后计提摊销截止日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.CALC_DATE_OLD) -- 重置前计提摊销截止日期
    ,nvl(trim(P1.IPR_STATE),'-') -- 减值状态代码
    ,P1.IPR_PRFT_CP -- 成本减值损失
    ,P1.IPR_PRFT_AI -- 利息减值损失
    ,P1.IPR_CP -- 成本减值准备
    ,P1.IPR_HX_CP -- 已核销成本
    ,P1.IPR_HX_AI -- 已核销应计利息
    ,P1.IPR_HX_DUE_AI -- 已核销应收未收利息
    ,P1.IPR_BW_AI -- 表外应计利息
    ,P1.IPR_BW_DUE_AI -- 表外应收未收利息
    ,${iml_schema}.DATEFORMAT_MIN(P1.AMRT_DATE_RC_OLD) -- 重置前重分类摊销开始日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.AMRT_DATE_RC) -- 重置后重分类摊销开始日期
    ,P1.AMRT_COST_AI_RC -- 重分类摊销开始日期利息成本
    ,P1.PRFT_IR_AI_CALC_TAX -- 应计利息收入增量
    ,P1.TAX_AI -- 应计增值税
    ,P1.TAX_DUE_AI -- 应付增值税
    ,nvl(trim(P1.FV_CURRENCY_OLD),'-') -- 重置前估值币种代码
    ,nvl(trim(P1.FV_CURRENCY),'-') -- 重置后估值币种代码
    ,P1.OPEN_AI -- 开仓利息成本
    ,P1.OPEN_YTM_OPT -- 开仓行权收益率
    ,P1.PRFT_IR_AI_FUT -- 预收利息收入
    ,P1.PRFT_IR_AI_CUR -- 计提利息收入
    ,P1.PRFT_IR_AI_DUE -- 应收利息收入
    ,P1.PRFT_IR_AI_CASH -- 实收利息收入
    ,P1.PRFT_IR_FUT_AI -- 税后预收利息收入
    ,P1.TAX_DUE_AMRT -- 摊销利息收入应付增值税
    ,P1.TAX_DUE_TRD -- 买卖损益应付增值税
    ,P1.TAX_DUE_FEE -- 费用损益应付增值税
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CUSTOM_DIM1 END -- 逾期标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_bookkeeping_secu_chg_his' -- 源表名称
    ,'ibmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_bookkeeping_secu_chg_his p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CHG_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_BOOKKEEPING_SECU_CHG_HIS'
        AND R1.SRC_FIELD_EN_NAME= 'CHG_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_ENTRY_BAL_CHG_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CHG_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CUSTOM_DIM1= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_BOOKKEEPING_SECU_CHG_HIS'
        AND R2.SRC_FIELD_EN_NAME= 'CUSTOM_DIM1'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_ENTRY_BAL_CHG_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'OVDUE_FLG'
where 1=1 
 and to_date(P1.chg_date,'yyyy-mm-dd') = to_date('${batch_date}','yyyy-mm-dd')
 and P1.ETL_DT = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_entry_bal_chg_flow truncate subpartition p_ibmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_entry_bal_chg_flow exchange subpartition p_ibmsi1_${batch_date} with table ${iml_schema}.evt_entry_bal_chg_flow_ibmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_entry_bal_chg_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_entry_bal_chg_flow_ibmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_entry_bal_chg_flow', partname => 'p_ibmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);