/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_secu_acct_accti_bal_h_ibmsf1
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
alter table ${iml_schema}.agt_secu_acct_accti_bal_h add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ibmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_secu_acct_accti_bal_h partition for ('ibmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_tm purge;
drop table ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_op purge;
drop table ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_id -- 对象编号
    ,task_id -- 任务编号
    ,ext_vch_acct_id -- 外部券账户编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,tran_num -- 交易号
    ,extra_dimen_cd -- 额外维度代码
    ,actl_qtty -- 实际数量
    ,actl_bal -- 实际余额
    ,net_price_cost -- 净价成本
    ,acru_int -- 应计利息
    ,int_cost -- 利息成本
    ,evha_val_chag -- 公允价值变动
    ,recvbl_uncol_bal -- 应收未收余额
    ,recvbl_uncol_net_price_cost -- 应收未收净价成本
    ,recvbl_uncol_acru_int -- 应收未收应计利息
    ,td_amort_bus_cnt -- 当天摊销业务次数
    ,amort_dt -- 摊销日期
    ,int_adj_amt -- 利息调整金额
    ,fair_val_pl -- 公允价值损益
    ,bs_pl -- 买卖损益
    ,int_income -- 利息收入
    ,acru_int_inco -- 应计利息收入
    ,amort_int_income -- 摊销利息收入
    ,curr_post_acru_int_int_income -- 当前持仓应计利息利息收入
    ,curr_post_amort_int_income -- 当前持仓摊销利息收入
    ,reclafy_fair_val_pl -- 重分类公允价值损益
    ,impam_prep -- 减值准备
    ,impam_loss -- 减值损失
    ,futures_margin -- 期货保证金
    ,open_dt -- 开仓日期
    ,last_update_dt -- 上次更新日期
    ,fee -- 费用
    ,paybl_fee -- 应付费用
    ,fee_cost -- 费用成本
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
    ,provi_amort_closing_dt -- 计提摊销截止日期
    ,impam_status_cd -- 减值状态代码
    ,cost_impam_loss -- 成本减值损失
    ,int_impam_loss -- 利息减值损失
    ,cost_impam_prep -- 成本减值准备
    ,wrtn_off_cost -- 已核销成本
    ,wrtn_off_acru_int -- 已核销应计利息
    ,wrtn_off_recvbl_uncol_int -- 已核销应收未收利息
    ,off_bs_acru_int -- 表外应计利息
    ,off_bs_recvbl_uncol_int -- 表外应收未收利息
    ,acru_int_amt -- 应计利息发生额
    ,acru_vat -- 应计增值税
    ,paybl_vat -- 应付增值税
    ,curr_cd -- 币种代码
    ,stl_dt -- 结算日期
    ,rlizd_evha_val_chag_pl -- 已实现公允价值变动损益
    ,curr_post_int_tax -- 当前持仓利息税
    ,open_int_cost -- 开仓利息成本
    ,open_ex_yld_rat -- 开仓行权收益率
    ,pre_recv_int_income -- 预收利息收入
    ,provi_int_income -- 计提利息收入
    ,int_recvbl_inco -- 应收利息收入
    ,actl_recv_int_income -- 实收利息收入
    ,provi_int_income_pre_recv_tax -- 计提利息收入预收税
    ,amort_int_income_paybl_vat -- 摊销利息收入应付增值税
    ,offset_dlvy_dt -- 平仓交割日期
    ,std_prod_id -- 标准产品编号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,at_pre_recv_int_income -- 税后预收利息收入
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_secu_acct_accti_bal_h partition for ('ibmsf1')
where 0=1
;

create table ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_secu_acct_accti_bal_h partition for ('ibmsf1') where 0=1;

create table ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_secu_acct_accti_bal_h partition for ('ibmsf1') where 0=1;

-- 3.1 get new data into table
-- ibms_ttrd_accounting_secu_obj-
insert into ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_id -- 对象编号
    ,task_id -- 任务编号
    ,ext_vch_acct_id -- 外部券账户编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,tran_num -- 交易号
    ,extra_dimen_cd -- 额外维度代码
    ,actl_qtty -- 实际数量
    ,actl_bal -- 实际余额
    ,net_price_cost -- 净价成本
    ,acru_int -- 应计利息
    ,int_cost -- 利息成本
    ,evha_val_chag -- 公允价值变动
    ,recvbl_uncol_bal -- 应收未收余额
    ,recvbl_uncol_net_price_cost -- 应收未收净价成本
    ,recvbl_uncol_acru_int -- 应收未收应计利息
    ,td_amort_bus_cnt -- 当天摊销业务次数
    ,amort_dt -- 摊销日期
    ,int_adj_amt -- 利息调整金额
    ,fair_val_pl -- 公允价值损益
    ,bs_pl -- 买卖损益
    ,int_income -- 利息收入
    ,acru_int_inco -- 应计利息收入
    ,amort_int_income -- 摊销利息收入
    ,curr_post_acru_int_int_income -- 当前持仓应计利息利息收入
    ,curr_post_amort_int_income -- 当前持仓摊销利息收入
    ,reclafy_fair_val_pl -- 重分类公允价值损益
    ,impam_prep -- 减值准备
    ,impam_loss -- 减值损失
    ,futures_margin -- 期货保证金
    ,open_dt -- 开仓日期
    ,last_update_dt -- 上次更新日期
    ,fee -- 费用
    ,paybl_fee -- 应付费用
    ,fee_cost -- 费用成本
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
    ,provi_amort_closing_dt -- 计提摊销截止日期
    ,impam_status_cd -- 减值状态代码
    ,cost_impam_loss -- 成本减值损失
    ,int_impam_loss -- 利息减值损失
    ,cost_impam_prep -- 成本减值准备
    ,wrtn_off_cost -- 已核销成本
    ,wrtn_off_acru_int -- 已核销应计利息
    ,wrtn_off_recvbl_uncol_int -- 已核销应收未收利息
    ,off_bs_acru_int -- 表外应计利息
    ,off_bs_recvbl_uncol_int -- 表外应收未收利息
    ,acru_int_amt -- 应计利息发生额
    ,acru_vat -- 应计增值税
    ,paybl_vat -- 应付增值税
    ,curr_cd -- 币种代码
    ,stl_dt -- 结算日期
    ,rlizd_evha_val_chag_pl -- 已实现公允价值变动损益
    ,curr_post_int_tax -- 当前持仓利息税
    ,open_int_cost -- 开仓利息成本
    ,open_ex_yld_rat -- 开仓行权收益率
    ,pre_recv_int_income -- 预收利息收入
    ,provi_int_income -- 计提利息收入
    ,int_recvbl_inco -- 应收利息收入
    ,actl_recv_int_income -- 实收利息收入
    ,provi_int_income_pre_recv_tax -- 计提利息收入预收税
    ,amort_int_income_paybl_vat -- 摊销利息收入应付增值税
    ,offset_dlvy_dt -- 平仓交割日期
    ,std_prod_id -- 标准产品编号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,at_pre_recv_int_income -- 税后预收利息收入
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '100040'||P1.SECU_ACCT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.OBJ_ID -- 对象编号
    ,P1.TSK_ID -- 任务编号
    ,P1.EXT_SECU_ACCT_ID -- 外部券账户编号
    ,P1.SECU_ACCT_ID -- 内部券账户编号
    ,P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,P1.TRADE_ID -- 交易号
    ,P1.EXTRA_DIM -- 额外维度代码
    ,P1.REAL_VOLUME -- 实际数量
    ,P1.REAL_AMOUNT -- 实际余额
    ,P1.REAL_CP -- 净价成本
    ,P1.AI -- 应计利息
    ,P1.AI_COST -- 利息成本
    ,P1.CHG_FV -- 公允价值变动
    ,P1.DUE_AMOUNT -- 应收未收余额
    ,P1.DUE_CP -- 应收未收净价成本
    ,P1.DUE_AI -- 应收未收应计利息
    ,P1.AMRT_COUNT -- 当天摊销业务次数
    ,${iml_schema}.DATEFORMAT_MIN(P1.AMRT_DATE) -- 摊销日期
    ,P1.AMRT_IR -- 利息调整金额
    ,P1.PRFT_FV -- 公允价值损益
    ,P1.PRFT_TRD -- 买卖损益
    ,P1.PRFT_IR -- 利息收入
    ,P1.PRFT_IR_AI -- 应计利息收入
    ,P1.PRFT_IR_AMRT -- 摊销利息收入
    ,P1.PRFT_IR_AI_HLD -- 当前持仓应计利息利息收入
    ,P1.PRFT_IR_AMRT_HLD -- 当前持仓摊销利息收入
    ,P1.RECLASS_PRFT_FV -- 重分类公允价值损益
    ,P1.IMPAIR -- 减值准备
    ,P1.PRFT_IMPAIR -- 减值损失
    ,P1.REAL_MARGIN -- 期货保证金
    ,${iml_schema}.DATEFORMAT_MIN(P1.OPEN_TIME) -- 开仓日期
    ,${iml_schema}.DATEFORMAT_MIN(SUBSTR(REPLACE(P1.UPDATE_TIME,'-',''),1,8)) -- 上次更新日期
    ,P1.PRFT_FEE -- 费用
    ,P1.DUE_FEE -- 应付费用
    ,P1.FEE -- 费用成本
    ,P1.AMRT_COST_CP -- 摊余净价成本
    ,P1.AMRT_COST_AI -- 摊余利息成本
    ,P1.AMRT_YTM*100 -- 实际利率
    ,P1.INVEST_YTM*100 -- 投资收益率
    ,P1.OPEN_YTM*100 -- 开仓收益率
    ,P1.FUTURE_AI -- 预收息
    ,P1.REAL_CP_NOAMRT -- 不摊销净价成本
    ,P1.CHG_FV_NOAMRT -- 不摊销公允价值变动
    ,P1.PRFT_FV_NOAMRT -- 不摊销公允价值损益
    ,P1.PRFT_TRD_NOAMRT -- 不摊销买卖损益
    ,${iml_schema}.DATEFORMAT_MAX(P1.CALC_DATE) -- 计提摊销截止日期
    ,P1.IPR_STATE -- 减值状态代码
    ,P1.IPR_PRFT_CP -- 成本减值损失
    ,P1.IPR_PRFT_AI -- 利息减值损失
    ,P1.IPR_CP -- 成本减值准备
    ,P1.IPR_HX_CP -- 已核销成本
    ,P1.IPR_HX_AI -- 已核销应计利息
    ,P1.IPR_HX_DUE_AI -- 已核销应收未收利息
    ,P1.IPR_BW_AI -- 表外应计利息
    ,P1.IPR_BW_DUE_AI -- 表外应收未收利息
    ,P1.PRFT_IR_AI_CALC_TAX -- 应计利息发生额
    ,P1.TAX_AI -- 应计增值税
    ,P1.TAX_DUE_AI -- 应付增值税
    ,P1.FV_CURRENCY -- 币种代码
    ,TO_DATE(P1.SET_DATE,'YYYY-MM-DD') -- 结算日期
    ,P1.PRFT_FV_CASH -- 已实现公允价值变动损益
    ,P1.TAX_AI_HLD -- 当前持仓利息税
    ,P1.OPEN_AI -- 开仓利息成本
    ,P1.OPEN_YTM_OPT -- 开仓行权收益率
    ,P1.PRFT_IR_AI_FUT -- 预收利息收入
    ,P1.PRFT_IR_AI_CUR -- 计提利息收入
    ,P1.PRFT_IR_AI_DUE -- 应收利息收入
    ,P1.PRFT_IR_AI_CASH -- 实收利息收入
    ,P1.TAX_FUT_AI -- 计提利息收入预收税
    ,P1.TAX_DUE_AMRT -- 摊销利息收入应付增值税
    ,${iml_schema}.DATEFORMAT_MAX(P1.CLOSE_SET_DATE) -- 平仓交割日期
    ,CASE  WHEN P3.Description in ('协议正回购')    THEN '401030101'
      WHEN P3.Description in ('外币存放同业定期')  THEN '402010202'
      WHEN P3.Description in ('银团同业借款')      THEN '402020201'
      WHEN P3.Description like '%有追索权的保理%' THEN '402020203'
      WHEN P3.Description in ('协议逆回购')        THEN '402030101'
      WHEN P3.Description like '%同兴赢定期%' THEN '401010202'
      WHEN P3.Description = '同业借出' THEN '402020202'
      WHEN P3.Description = '同业存单发行' THEN '401040101'
      WHEN P3.Description like '%同业存放定期%' THEN '401010201'
      WHEN P3.Description like '%存放同业活期%' THEN '402010101'
      WHEN T3.P_TYPE = '0000' AND T3.P_CLASS in ('私募债','其他债券') AND T3.M_TYPE = 'X_CNBD' THEN '301070307'
      WHEN T3.P_TYPE = '0000' AND T3.P_CLASS in ('私募债','其他债券') AND T3.M_TYPE <> 'X_CNBD' THEN '301070204' 
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = '同业理财(保本)'  AND T8.not_undasset_type_two = '5_1' THEN '304010101'
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = '同业理财(非保本)'  AND T8.not_undasset_type_two = '5_1' THEN '304010101'
      WHEN T3.P_TYPE IN ('0700') AND T3.P_CLASS = '理财产品' AND T8.not_undasset_type_two = '5_1' THEN '304010201' 
      WHEN T3.P_TYPE IN ('0706') AND T3.P_CLASS = '理财产品' THEN '304010201' 
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = '单一信托计划/信托收益权(保本)' AND T8.not_undasset_type_two = '5_2' THEN '304020101' 
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = '单一信托计划/信托收益权(非保本)' AND T8.not_undasset_type_two = '5_2' THEN '304020101' 
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = '集合信托计划(保本)' AND T8.not_undasset_type_two = '5_2' THEN '304020101' 
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = '集合信托计划(非保本)' AND T8.not_undasset_type_two = '5_2' THEN '304020101' 
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = 'Pre—ABS项目(ABS前端融资)(保本)' AND T8.not_undasset_type_two = '5_2' THEN '304020102' 
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = 'Pre—ABS项目(ABS前端融资)(非保本)' AND T8.not_undasset_type_two = '5_2' THEN '304020102' 
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = '银登中心信贷资产流转项目-ABS(保本)' AND T8.not_undasset_type_two = '5_2' THEN '304020103'
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = '银登中心信贷资产流转项目-ABS(非保本)' AND T8.not_undasset_type_two = '5_2' THEN '304020103'
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = '银登中心信贷资产流转项目-非标项目(保本)' AND T8.not_undasset_type_two = '5_2' THEN '304020103'
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = '银登中心信贷资产流转项目-非标项目(非保本)'  AND T8.not_undasset_type_two = '5_2' THEN '304020103'
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = '类信贷-信托计划' AND T8.not_undasset_type_two = '5_2' THEN '304020104'
      WHEN T3.P_TYPE IN ('0700') AND T3.P_CLASS = '信托计划' AND T8.not_undasset_type_two = '5_2' THEN '304020201'
      WHEN T3.P_TYPE IN ('0706') AND T3.P_CLASS = '信托计划' THEN '304020201'
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = '交易所资产支持证券(ABS)'  AND T8.not_undasset_type_two = '5_3' THEN '304030101'
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = '券商固定收益定向资管计划'  AND T8.not_undasset_type_two = '5_3' THEN '304030102'
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = '券商固定收益集合资管计划'  AND T8.not_undasset_type_two = '5_3' THEN '304030102'
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = '交易所公司债(含企业债)'  AND T8.not_undasset_type_two = '5_3' THEN '304030104'
      WHEN T3.P_TYPE = '0170' AND T3.P_CLASS = '类信贷-资管计划'  AND T8.not_undasset_type_two = '5_3' THEN '304030105'
      WHEN T3.P_TYPE IN ('0700') AND T3.P_CLASS = '资产管理计划'  AND T8.not_undasset_type_two = '5_3' THEN '304030201'
      WHEN T3.P_TYPE IN ('0706') AND T3.P_CLASS = '资产管理计划'  THEN '304030201'
      WHEN T3.P_TYPE = '0170' AND T8.not_undasset_type_two = '5_4' THEN '304040101'
      WHEN T3.P_TYPE='0170'and T3.P_CLASS like '%票据资管%'  AND T8.not_undasset_type_two = '5_3' THEN '304030202'
      WHEN T8.not_undasset_type_two = '5_5' THEN '304050101'
      WHEN T8.not_undasset_type_two = '4_1' THEN '307010101'
      WHEN T8.not_undasset_type_two = '4_2' THEN '307020101' 
      WHEN T8.not_undasset_type_two = '4_3' THEN '307030101'
      WHEN T8.not_undasset_type_two = '4_4' THEN '307040101' 
      WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL
      WHEN T3.P_TYPE='1100'and T3.P_CLASS = '非金融企业资产支持票据' THEN '301080201' 
      WHEN T3.P_TYPE='0703'and T3.P_CLASS like '%债券基金%' THEN '303010101' 
      WHEN T3.P_TYPE='0706' and T3.P_CLASS = '货币基金' THEN '303020101'
      WHEN T3.P_TYPE='0170'and T3.P_CLASS like '%北金所债权融资计划%' THEN '305010101'
      WHEN (T3.P_TYPE='0170'and T3.P_CLASS like '%类信贷-私募债%')  THEN '305020101'
      WHEN (T3.P_TYPE='0170'and T3.P_CLASS = '私募债')  THEN '305020102'
      WHEN T3.P_CLASS like '%券商固定收益凭证%' THEN '305030101'
      WHEN T3.P_CLASS='同业存放活期' THEN '401010101'
      WHEN T3.P_CLASS='同业存放定期' THEN '401010201'
      ELSE ' '
END -- 标准产品编号
    ,case 
         WHEN R11.TARGET_CD_VAL IS NOT NULL THEN R11.TARGET_CD_VAL   --- 0日调账及以后，三分类从 ibms_ttrd_acctg_account_type 取
         WHEN TO_CHAR(T6.I9_CLASS) is null then 'XXX'
         ELSE '@'||TO_CHAR(T6.I9_CLASS)                        
     end     -- 资产三分类代码
    ,P1.PRFT_IR_FUT_AI -- 税后预收利息收入
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_accounting_secu_obj' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_accounting_secu_obj p1
    left join ${iol_schema}.ibms_ttrd_acc_secu t5 on P1.secu_acct_id = T5.accid
AND T5.START_DT <= to_date('${batch_date}','yyyymmdd') 
AND T5.END_DT > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_acctg_account_type t6 on T5.acting_type = T6.typeid
AND T6.START_DT <= to_date('${batch_date}','yyyymmdd') 
AND T6.END_DT > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_cashlb_manage_ele t8 on P1.i_code = T8.i_code
and P1.a_type = T8.a_type
and P1.m_type = T8.m_type
AND T8.START_DT <= to_date('${batch_date}','yyyymmdd') 
AND T8.END_DT > to_date('${batch_date}','yyyymmdd') 
    left join ${iol_schema}.ibms_ttrd_instrument t3 on P1.i_code = T3.i_code
and P1.a_type = T3.a_type
and P1.m_type = T3.m_type
AND T3.START_DT <= to_date('${batch_date}','yyyymmdd') 
AND T3.END_DT > to_date('${batch_date}','yyyymmdd') 
    left join ${iml_schema}.ref_pub_cd_map r3 on TRIM(T3.P_TYPE)||TRIM(T3.P_CLASS) = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IBMS'
        AND R3.SRC_TAB_EN_NAME= 'IBMS_TTRD_INSTRUMENT'
        AND R3.SRC_FIELD_EN_NAME= 'P_TYPE||P_CLASS'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_FIN_INSTM'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'STD_PROD_ID'
    left join ${iml_schema}.ref_pub_cd_map r11 on to_char(T6.I9_CLASS) = R11.SRC_CODE_VAL
        AND R11.SORC_SYS_CD= 'IBMS'
        AND R11.SRC_TAB_EN_NAME= 'IBMS_TTRD_ACCTG_ACCOUNT_TYPE'
        AND R11.SRC_FIELD_EN_NAME= 'I9_CLASS'
        AND R11.TARGET_TAB_EN_NAME= 'REF_IBANK_ACCTNT_TYPE_CD'
        AND R11.TARGET_TAB_FIELD_EN_NAME= 'ASSET_THD_CLS_CD'
    left join ${iol_schema}.ibms_ttrd_otc_trade p2 on P1.TRADE_ID = P2.INTORDID
    left join ${iol_schema}.ibms_ttrd_trade_type p3 on  P2.TRDTYPE = P3.TRD_TYPE
AND P3.START_DT <= to_date('${batch_date}','yyyymmdd') 
AND P3.END_DT > to_date('${batch_date}','yyyymmdd') 
where  1 = 1 
    AND TO_DATE(P1.BEG_DATE,'YYYY-MM-DD') = TO_DATE('${batch_date}','yyyymmdd') 
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_id -- 对象编号
    ,task_id -- 任务编号
    ,ext_vch_acct_id -- 外部券账户编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,tran_num -- 交易号
    ,extra_dimen_cd -- 额外维度代码
    ,actl_qtty -- 实际数量
    ,actl_bal -- 实际余额
    ,net_price_cost -- 净价成本
    ,acru_int -- 应计利息
    ,int_cost -- 利息成本
    ,evha_val_chag -- 公允价值变动
    ,recvbl_uncol_bal -- 应收未收余额
    ,recvbl_uncol_net_price_cost -- 应收未收净价成本
    ,recvbl_uncol_acru_int -- 应收未收应计利息
    ,td_amort_bus_cnt -- 当天摊销业务次数
    ,amort_dt -- 摊销日期
    ,int_adj_amt -- 利息调整金额
    ,fair_val_pl -- 公允价值损益
    ,bs_pl -- 买卖损益
    ,int_income -- 利息收入
    ,acru_int_inco -- 应计利息收入
    ,amort_int_income -- 摊销利息收入
    ,curr_post_acru_int_int_income -- 当前持仓应计利息利息收入
    ,curr_post_amort_int_income -- 当前持仓摊销利息收入
    ,reclafy_fair_val_pl -- 重分类公允价值损益
    ,impam_prep -- 减值准备
    ,impam_loss -- 减值损失
    ,futures_margin -- 期货保证金
    ,open_dt -- 开仓日期
    ,last_update_dt -- 上次更新日期
    ,fee -- 费用
    ,paybl_fee -- 应付费用
    ,fee_cost -- 费用成本
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
    ,provi_amort_closing_dt -- 计提摊销截止日期
    ,impam_status_cd -- 减值状态代码
    ,cost_impam_loss -- 成本减值损失
    ,int_impam_loss -- 利息减值损失
    ,cost_impam_prep -- 成本减值准备
    ,wrtn_off_cost -- 已核销成本
    ,wrtn_off_acru_int -- 已核销应计利息
    ,wrtn_off_recvbl_uncol_int -- 已核销应收未收利息
    ,off_bs_acru_int -- 表外应计利息
    ,off_bs_recvbl_uncol_int -- 表外应收未收利息
    ,acru_int_amt -- 应计利息发生额
    ,acru_vat -- 应计增值税
    ,paybl_vat -- 应付增值税
    ,curr_cd -- 币种代码
    ,stl_dt -- 结算日期
    ,rlizd_evha_val_chag_pl -- 已实现公允价值变动损益
    ,curr_post_int_tax -- 当前持仓利息税
    ,open_int_cost -- 开仓利息成本
    ,open_ex_yld_rat -- 开仓行权收益率
    ,pre_recv_int_income -- 预收利息收入
    ,provi_int_income -- 计提利息收入
    ,int_recvbl_inco -- 应收利息收入
    ,actl_recv_int_income -- 实收利息收入
    ,provi_int_income_pre_recv_tax -- 计提利息收入预收税
    ,amort_int_income_paybl_vat -- 摊销利息收入应付增值税
    ,offset_dlvy_dt -- 平仓交割日期
    ,std_prod_id -- 标准产品编号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,at_pre_recv_int_income -- 税后预收利息收入
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_id -- 对象编号
    ,task_id -- 任务编号
    ,ext_vch_acct_id -- 外部券账户编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,tran_num -- 交易号
    ,extra_dimen_cd -- 额外维度代码
    ,actl_qtty -- 实际数量
    ,actl_bal -- 实际余额
    ,net_price_cost -- 净价成本
    ,acru_int -- 应计利息
    ,int_cost -- 利息成本
    ,evha_val_chag -- 公允价值变动
    ,recvbl_uncol_bal -- 应收未收余额
    ,recvbl_uncol_net_price_cost -- 应收未收净价成本
    ,recvbl_uncol_acru_int -- 应收未收应计利息
    ,td_amort_bus_cnt -- 当天摊销业务次数
    ,amort_dt -- 摊销日期
    ,int_adj_amt -- 利息调整金额
    ,fair_val_pl -- 公允价值损益
    ,bs_pl -- 买卖损益
    ,int_income -- 利息收入
    ,acru_int_inco -- 应计利息收入
    ,amort_int_income -- 摊销利息收入
    ,curr_post_acru_int_int_income -- 当前持仓应计利息利息收入
    ,curr_post_amort_int_income -- 当前持仓摊销利息收入
    ,reclafy_fair_val_pl -- 重分类公允价值损益
    ,impam_prep -- 减值准备
    ,impam_loss -- 减值损失
    ,futures_margin -- 期货保证金
    ,open_dt -- 开仓日期
    ,last_update_dt -- 上次更新日期
    ,fee -- 费用
    ,paybl_fee -- 应付费用
    ,fee_cost -- 费用成本
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
    ,provi_amort_closing_dt -- 计提摊销截止日期
    ,impam_status_cd -- 减值状态代码
    ,cost_impam_loss -- 成本减值损失
    ,int_impam_loss -- 利息减值损失
    ,cost_impam_prep -- 成本减值准备
    ,wrtn_off_cost -- 已核销成本
    ,wrtn_off_acru_int -- 已核销应计利息
    ,wrtn_off_recvbl_uncol_int -- 已核销应收未收利息
    ,off_bs_acru_int -- 表外应计利息
    ,off_bs_recvbl_uncol_int -- 表外应收未收利息
    ,acru_int_amt -- 应计利息发生额
    ,acru_vat -- 应计增值税
    ,paybl_vat -- 应付增值税
    ,curr_cd -- 币种代码
    ,stl_dt -- 结算日期
    ,rlizd_evha_val_chag_pl -- 已实现公允价值变动损益
    ,curr_post_int_tax -- 当前持仓利息税
    ,open_int_cost -- 开仓利息成本
    ,open_ex_yld_rat -- 开仓行权收益率
    ,pre_recv_int_income -- 预收利息收入
    ,provi_int_income -- 计提利息收入
    ,int_recvbl_inco -- 应收利息收入
    ,actl_recv_int_income -- 实收利息收入
    ,provi_int_income_pre_recv_tax -- 计提利息收入预收税
    ,amort_int_income_paybl_vat -- 摊销利息收入应付增值税
    ,offset_dlvy_dt -- 平仓交割日期
    ,std_prod_id -- 标准产品编号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,at_pre_recv_int_income -- 税后预收利息收入
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
    ,nvl(n.obj_id, o.obj_id) as obj_id -- 对象编号
    ,nvl(n.task_id, o.task_id) as task_id -- 任务编号
    ,nvl(n.ext_vch_acct_id, o.ext_vch_acct_id) as ext_vch_acct_id -- 外部券账户编号
    ,nvl(n.intnal_vch_acct_id, o.intnal_vch_acct_id) as intnal_vch_acct_id -- 内部券账户编号
    ,nvl(n.fin_instm_id, o.fin_instm_id) as fin_instm_id -- 金融工具编号
    ,nvl(n.asset_type_id, o.asset_type_id) as asset_type_id -- 资产类型编号
    ,nvl(n.market_type_id, o.market_type_id) as market_type_id -- 市场类型编号
    ,nvl(n.tran_num, o.tran_num) as tran_num -- 交易号
    ,nvl(n.extra_dimen_cd, o.extra_dimen_cd) as extra_dimen_cd -- 额外维度代码
    ,nvl(n.actl_qtty, o.actl_qtty) as actl_qtty -- 实际数量
    ,nvl(n.actl_bal, o.actl_bal) as actl_bal -- 实际余额
    ,nvl(n.net_price_cost, o.net_price_cost) as net_price_cost -- 净价成本
    ,nvl(n.acru_int, o.acru_int) as acru_int -- 应计利息
    ,nvl(n.int_cost, o.int_cost) as int_cost -- 利息成本
    ,nvl(n.evha_val_chag, o.evha_val_chag) as evha_val_chag -- 公允价值变动
    ,nvl(n.recvbl_uncol_bal, o.recvbl_uncol_bal) as recvbl_uncol_bal -- 应收未收余额
    ,nvl(n.recvbl_uncol_net_price_cost, o.recvbl_uncol_net_price_cost) as recvbl_uncol_net_price_cost -- 应收未收净价成本
    ,nvl(n.recvbl_uncol_acru_int, o.recvbl_uncol_acru_int) as recvbl_uncol_acru_int -- 应收未收应计利息
    ,nvl(n.td_amort_bus_cnt, o.td_amort_bus_cnt) as td_amort_bus_cnt -- 当天摊销业务次数
    ,nvl(n.amort_dt, o.amort_dt) as amort_dt -- 摊销日期
    ,nvl(n.int_adj_amt, o.int_adj_amt) as int_adj_amt -- 利息调整金额
    ,nvl(n.fair_val_pl, o.fair_val_pl) as fair_val_pl -- 公允价值损益
    ,nvl(n.bs_pl, o.bs_pl) as bs_pl -- 买卖损益
    ,nvl(n.int_income, o.int_income) as int_income -- 利息收入
    ,nvl(n.acru_int_inco, o.acru_int_inco) as acru_int_inco -- 应计利息收入
    ,nvl(n.amort_int_income, o.amort_int_income) as amort_int_income -- 摊销利息收入
    ,nvl(n.curr_post_acru_int_int_income, o.curr_post_acru_int_int_income) as curr_post_acru_int_int_income -- 当前持仓应计利息利息收入
    ,nvl(n.curr_post_amort_int_income, o.curr_post_amort_int_income) as curr_post_amort_int_income -- 当前持仓摊销利息收入
    ,nvl(n.reclafy_fair_val_pl, o.reclafy_fair_val_pl) as reclafy_fair_val_pl -- 重分类公允价值损益
    ,nvl(n.impam_prep, o.impam_prep) as impam_prep -- 减值准备
    ,nvl(n.impam_loss, o.impam_loss) as impam_loss -- 减值损失
    ,nvl(n.futures_margin, o.futures_margin) as futures_margin -- 期货保证金
    ,nvl(n.open_dt, o.open_dt) as open_dt -- 开仓日期
    ,nvl(n.last_update_dt, o.last_update_dt) as last_update_dt -- 上次更新日期
    ,nvl(n.fee, o.fee) as fee -- 费用
    ,nvl(n.paybl_fee, o.paybl_fee) as paybl_fee -- 应付费用
    ,nvl(n.fee_cost, o.fee_cost) as fee_cost -- 费用成本
    ,nvl(n.amort_net_price_cost, o.amort_net_price_cost) as amort_net_price_cost -- 摊余净价成本
    ,nvl(n.amort_int_cost, o.amort_int_cost) as amort_int_cost -- 摊余利息成本
    ,nvl(n.actl_int_rat, o.actl_int_rat) as actl_int_rat -- 实际利率
    ,nvl(n.invest_yld_rat, o.invest_yld_rat) as invest_yld_rat -- 投资收益率
    ,nvl(n.open_yld_rat, o.open_yld_rat) as open_yld_rat -- 开仓收益率
    ,nvl(n.pre_recv_int, o.pre_recv_int) as pre_recv_int -- 预收息
    ,nvl(n.non_amort_net_price_cost, o.non_amort_net_price_cost) as non_amort_net_price_cost -- 不摊销净价成本
    ,nvl(n.non_amort_evha_val_chag, o.non_amort_evha_val_chag) as non_amort_evha_val_chag -- 不摊销公允价值变动
    ,nvl(n.non_amort_fair_val_pl, o.non_amort_fair_val_pl) as non_amort_fair_val_pl -- 不摊销公允价值损益
    ,nvl(n.non_amort_bs_pl, o.non_amort_bs_pl) as non_amort_bs_pl -- 不摊销买卖损益
    ,nvl(n.provi_amort_closing_dt, o.provi_amort_closing_dt) as provi_amort_closing_dt -- 计提摊销截止日期
    ,nvl(n.impam_status_cd, o.impam_status_cd) as impam_status_cd -- 减值状态代码
    ,nvl(n.cost_impam_loss, o.cost_impam_loss) as cost_impam_loss -- 成本减值损失
    ,nvl(n.int_impam_loss, o.int_impam_loss) as int_impam_loss -- 利息减值损失
    ,nvl(n.cost_impam_prep, o.cost_impam_prep) as cost_impam_prep -- 成本减值准备
    ,nvl(n.wrtn_off_cost, o.wrtn_off_cost) as wrtn_off_cost -- 已核销成本
    ,nvl(n.wrtn_off_acru_int, o.wrtn_off_acru_int) as wrtn_off_acru_int -- 已核销应计利息
    ,nvl(n.wrtn_off_recvbl_uncol_int, o.wrtn_off_recvbl_uncol_int) as wrtn_off_recvbl_uncol_int -- 已核销应收未收利息
    ,nvl(n.off_bs_acru_int, o.off_bs_acru_int) as off_bs_acru_int -- 表外应计利息
    ,nvl(n.off_bs_recvbl_uncol_int, o.off_bs_recvbl_uncol_int) as off_bs_recvbl_uncol_int -- 表外应收未收利息
    ,nvl(n.acru_int_amt, o.acru_int_amt) as acru_int_amt -- 应计利息发生额
    ,nvl(n.acru_vat, o.acru_vat) as acru_vat -- 应计增值税
    ,nvl(n.paybl_vat, o.paybl_vat) as paybl_vat -- 应付增值税
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.stl_dt, o.stl_dt) as stl_dt -- 结算日期
    ,nvl(n.rlizd_evha_val_chag_pl, o.rlizd_evha_val_chag_pl) as rlizd_evha_val_chag_pl -- 已实现公允价值变动损益
    ,nvl(n.curr_post_int_tax, o.curr_post_int_tax) as curr_post_int_tax -- 当前持仓利息税
    ,nvl(n.open_int_cost, o.open_int_cost) as open_int_cost -- 开仓利息成本
    ,nvl(n.open_ex_yld_rat, o.open_ex_yld_rat) as open_ex_yld_rat -- 开仓行权收益率
    ,nvl(n.pre_recv_int_income, o.pre_recv_int_income) as pre_recv_int_income -- 预收利息收入
    ,nvl(n.provi_int_income, o.provi_int_income) as provi_int_income -- 计提利息收入
    ,nvl(n.int_recvbl_inco, o.int_recvbl_inco) as int_recvbl_inco -- 应收利息收入
    ,nvl(n.actl_recv_int_income, o.actl_recv_int_income) as actl_recv_int_income -- 实收利息收入
    ,nvl(n.provi_int_income_pre_recv_tax, o.provi_int_income_pre_recv_tax) as provi_int_income_pre_recv_tax -- 计提利息收入预收税
    ,nvl(n.amort_int_income_paybl_vat, o.amort_int_income_paybl_vat) as amort_int_income_paybl_vat -- 摊销利息收入应付增值税
    ,nvl(n.offset_dlvy_dt, o.offset_dlvy_dt) as offset_dlvy_dt -- 平仓交割日期
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 资产三分类代码
    ,nvl(n.at_pre_recv_int_income, o.at_pre_recv_int_income) as at_pre_recv_int_income -- 税后预收利息收入
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.obj_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.obj_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.obj_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_tm n
    full join (select * from ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.obj_id = n.obj_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.obj_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.obj_id is null
    )
    or (
        o.task_id <> n.task_id
        or o.ext_vch_acct_id <> n.ext_vch_acct_id
        or o.intnal_vch_acct_id <> n.intnal_vch_acct_id
        or o.fin_instm_id <> n.fin_instm_id
        or o.asset_type_id <> n.asset_type_id
        or o.market_type_id <> n.market_type_id
        or o.tran_num <> n.tran_num
        or o.extra_dimen_cd <> n.extra_dimen_cd
        or o.actl_qtty <> n.actl_qtty
        or o.actl_bal <> n.actl_bal
        or o.net_price_cost <> n.net_price_cost
        or o.acru_int <> n.acru_int
        or o.int_cost <> n.int_cost
        or o.evha_val_chag <> n.evha_val_chag
        or o.recvbl_uncol_bal <> n.recvbl_uncol_bal
        or o.recvbl_uncol_net_price_cost <> n.recvbl_uncol_net_price_cost
        or o.recvbl_uncol_acru_int <> n.recvbl_uncol_acru_int
        or o.td_amort_bus_cnt <> n.td_amort_bus_cnt
        or o.amort_dt <> n.amort_dt
        or o.int_adj_amt <> n.int_adj_amt
        or o.fair_val_pl <> n.fair_val_pl
        or o.bs_pl <> n.bs_pl
        or o.int_income <> n.int_income
        or o.acru_int_inco <> n.acru_int_inco
        or o.amort_int_income <> n.amort_int_income
        or o.curr_post_acru_int_int_income <> n.curr_post_acru_int_int_income
        or o.curr_post_amort_int_income <> n.curr_post_amort_int_income
        or o.reclafy_fair_val_pl <> n.reclafy_fair_val_pl
        or o.impam_prep <> n.impam_prep
        or o.impam_loss <> n.impam_loss
        or o.futures_margin <> n.futures_margin
        or o.open_dt <> n.open_dt
        or o.last_update_dt <> n.last_update_dt
        or o.fee <> n.fee
        or o.paybl_fee <> n.paybl_fee
        or o.fee_cost <> n.fee_cost
        or o.amort_net_price_cost <> n.amort_net_price_cost
        or o.amort_int_cost <> n.amort_int_cost
        or o.actl_int_rat <> n.actl_int_rat
        or o.invest_yld_rat <> n.invest_yld_rat
        or o.open_yld_rat <> n.open_yld_rat
        or o.pre_recv_int <> n.pre_recv_int
        or o.non_amort_net_price_cost <> n.non_amort_net_price_cost
        or o.non_amort_evha_val_chag <> n.non_amort_evha_val_chag
        or o.non_amort_fair_val_pl <> n.non_amort_fair_val_pl
        or o.non_amort_bs_pl <> n.non_amort_bs_pl
        or o.provi_amort_closing_dt <> n.provi_amort_closing_dt
        or o.impam_status_cd <> n.impam_status_cd
        or o.cost_impam_loss <> n.cost_impam_loss
        or o.int_impam_loss <> n.int_impam_loss
        or o.cost_impam_prep <> n.cost_impam_prep
        or o.wrtn_off_cost <> n.wrtn_off_cost
        or o.wrtn_off_acru_int <> n.wrtn_off_acru_int
        or o.wrtn_off_recvbl_uncol_int <> n.wrtn_off_recvbl_uncol_int
        or o.off_bs_acru_int <> n.off_bs_acru_int
        or o.off_bs_recvbl_uncol_int <> n.off_bs_recvbl_uncol_int
        or o.acru_int_amt <> n.acru_int_amt
        or o.acru_vat <> n.acru_vat
        or o.paybl_vat <> n.paybl_vat
        or o.curr_cd <> n.curr_cd
        or o.stl_dt <> n.stl_dt
        or o.rlizd_evha_val_chag_pl <> n.rlizd_evha_val_chag_pl
        or o.curr_post_int_tax <> n.curr_post_int_tax
        or o.open_int_cost <> n.open_int_cost
        or o.open_ex_yld_rat <> n.open_ex_yld_rat
        or o.pre_recv_int_income <> n.pre_recv_int_income
        or o.provi_int_income <> n.provi_int_income
        or o.int_recvbl_inco <> n.int_recvbl_inco
        or o.actl_recv_int_income <> n.actl_recv_int_income
        or o.provi_int_income_pre_recv_tax <> n.provi_int_income_pre_recv_tax
        or o.amort_int_income_paybl_vat <> n.amort_int_income_paybl_vat
        or o.offset_dlvy_dt <> n.offset_dlvy_dt
        or o.std_prod_id <> n.std_prod_id
        or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
        or o.at_pre_recv_int_income <> n.at_pre_recv_int_income
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_id -- 对象编号
    ,task_id -- 任务编号
    ,ext_vch_acct_id -- 外部券账户编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,tran_num -- 交易号
    ,extra_dimen_cd -- 额外维度代码
    ,actl_qtty -- 实际数量
    ,actl_bal -- 实际余额
    ,net_price_cost -- 净价成本
    ,acru_int -- 应计利息
    ,int_cost -- 利息成本
    ,evha_val_chag -- 公允价值变动
    ,recvbl_uncol_bal -- 应收未收余额
    ,recvbl_uncol_net_price_cost -- 应收未收净价成本
    ,recvbl_uncol_acru_int -- 应收未收应计利息
    ,td_amort_bus_cnt -- 当天摊销业务次数
    ,amort_dt -- 摊销日期
    ,int_adj_amt -- 利息调整金额
    ,fair_val_pl -- 公允价值损益
    ,bs_pl -- 买卖损益
    ,int_income -- 利息收入
    ,acru_int_inco -- 应计利息收入
    ,amort_int_income -- 摊销利息收入
    ,curr_post_acru_int_int_income -- 当前持仓应计利息利息收入
    ,curr_post_amort_int_income -- 当前持仓摊销利息收入
    ,reclafy_fair_val_pl -- 重分类公允价值损益
    ,impam_prep -- 减值准备
    ,impam_loss -- 减值损失
    ,futures_margin -- 期货保证金
    ,open_dt -- 开仓日期
    ,last_update_dt -- 上次更新日期
    ,fee -- 费用
    ,paybl_fee -- 应付费用
    ,fee_cost -- 费用成本
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
    ,provi_amort_closing_dt -- 计提摊销截止日期
    ,impam_status_cd -- 减值状态代码
    ,cost_impam_loss -- 成本减值损失
    ,int_impam_loss -- 利息减值损失
    ,cost_impam_prep -- 成本减值准备
    ,wrtn_off_cost -- 已核销成本
    ,wrtn_off_acru_int -- 已核销应计利息
    ,wrtn_off_recvbl_uncol_int -- 已核销应收未收利息
    ,off_bs_acru_int -- 表外应计利息
    ,off_bs_recvbl_uncol_int -- 表外应收未收利息
    ,acru_int_amt -- 应计利息发生额
    ,acru_vat -- 应计增值税
    ,paybl_vat -- 应付增值税
    ,curr_cd -- 币种代码
    ,stl_dt -- 结算日期
    ,rlizd_evha_val_chag_pl -- 已实现公允价值变动损益
    ,curr_post_int_tax -- 当前持仓利息税
    ,open_int_cost -- 开仓利息成本
    ,open_ex_yld_rat -- 开仓行权收益率
    ,pre_recv_int_income -- 预收利息收入
    ,provi_int_income -- 计提利息收入
    ,int_recvbl_inco -- 应收利息收入
    ,actl_recv_int_income -- 实收利息收入
    ,provi_int_income_pre_recv_tax -- 计提利息收入预收税
    ,amort_int_income_paybl_vat -- 摊销利息收入应付增值税
    ,offset_dlvy_dt -- 平仓交割日期
    ,std_prod_id -- 标准产品编号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,at_pre_recv_int_income -- 税后预收利息收入
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_id -- 对象编号
    ,task_id -- 任务编号
    ,ext_vch_acct_id -- 外部券账户编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,tran_num -- 交易号
    ,extra_dimen_cd -- 额外维度代码
    ,actl_qtty -- 实际数量
    ,actl_bal -- 实际余额
    ,net_price_cost -- 净价成本
    ,acru_int -- 应计利息
    ,int_cost -- 利息成本
    ,evha_val_chag -- 公允价值变动
    ,recvbl_uncol_bal -- 应收未收余额
    ,recvbl_uncol_net_price_cost -- 应收未收净价成本
    ,recvbl_uncol_acru_int -- 应收未收应计利息
    ,td_amort_bus_cnt -- 当天摊销业务次数
    ,amort_dt -- 摊销日期
    ,int_adj_amt -- 利息调整金额
    ,fair_val_pl -- 公允价值损益
    ,bs_pl -- 买卖损益
    ,int_income -- 利息收入
    ,acru_int_inco -- 应计利息收入
    ,amort_int_income -- 摊销利息收入
    ,curr_post_acru_int_int_income -- 当前持仓应计利息利息收入
    ,curr_post_amort_int_income -- 当前持仓摊销利息收入
    ,reclafy_fair_val_pl -- 重分类公允价值损益
    ,impam_prep -- 减值准备
    ,impam_loss -- 减值损失
    ,futures_margin -- 期货保证金
    ,open_dt -- 开仓日期
    ,last_update_dt -- 上次更新日期
    ,fee -- 费用
    ,paybl_fee -- 应付费用
    ,fee_cost -- 费用成本
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
    ,provi_amort_closing_dt -- 计提摊销截止日期
    ,impam_status_cd -- 减值状态代码
    ,cost_impam_loss -- 成本减值损失
    ,int_impam_loss -- 利息减值损失
    ,cost_impam_prep -- 成本减值准备
    ,wrtn_off_cost -- 已核销成本
    ,wrtn_off_acru_int -- 已核销应计利息
    ,wrtn_off_recvbl_uncol_int -- 已核销应收未收利息
    ,off_bs_acru_int -- 表外应计利息
    ,off_bs_recvbl_uncol_int -- 表外应收未收利息
    ,acru_int_amt -- 应计利息发生额
    ,acru_vat -- 应计增值税
    ,paybl_vat -- 应付增值税
    ,curr_cd -- 币种代码
    ,stl_dt -- 结算日期
    ,rlizd_evha_val_chag_pl -- 已实现公允价值变动损益
    ,curr_post_int_tax -- 当前持仓利息税
    ,open_int_cost -- 开仓利息成本
    ,open_ex_yld_rat -- 开仓行权收益率
    ,pre_recv_int_income -- 预收利息收入
    ,provi_int_income -- 计提利息收入
    ,int_recvbl_inco -- 应收利息收入
    ,actl_recv_int_income -- 实收利息收入
    ,provi_int_income_pre_recv_tax -- 计提利息收入预收税
    ,amort_int_income_paybl_vat -- 摊销利息收入应付增值税
    ,offset_dlvy_dt -- 平仓交割日期
    ,std_prod_id -- 标准产品编号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,at_pre_recv_int_income -- 税后预收利息收入
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
    ,o.obj_id -- 对象编号
    ,o.task_id -- 任务编号
    ,o.ext_vch_acct_id -- 外部券账户编号
    ,o.intnal_vch_acct_id -- 内部券账户编号
    ,o.fin_instm_id -- 金融工具编号
    ,o.asset_type_id -- 资产类型编号
    ,o.market_type_id -- 市场类型编号
    ,o.tran_num -- 交易号
    ,o.extra_dimen_cd -- 额外维度代码
    ,o.actl_qtty -- 实际数量
    ,o.actl_bal -- 实际余额
    ,o.net_price_cost -- 净价成本
    ,o.acru_int -- 应计利息
    ,o.int_cost -- 利息成本
    ,o.evha_val_chag -- 公允价值变动
    ,o.recvbl_uncol_bal -- 应收未收余额
    ,o.recvbl_uncol_net_price_cost -- 应收未收净价成本
    ,o.recvbl_uncol_acru_int -- 应收未收应计利息
    ,o.td_amort_bus_cnt -- 当天摊销业务次数
    ,o.amort_dt -- 摊销日期
    ,o.int_adj_amt -- 利息调整金额
    ,o.fair_val_pl -- 公允价值损益
    ,o.bs_pl -- 买卖损益
    ,o.int_income -- 利息收入
    ,o.acru_int_inco -- 应计利息收入
    ,o.amort_int_income -- 摊销利息收入
    ,o.curr_post_acru_int_int_income -- 当前持仓应计利息利息收入
    ,o.curr_post_amort_int_income -- 当前持仓摊销利息收入
    ,o.reclafy_fair_val_pl -- 重分类公允价值损益
    ,o.impam_prep -- 减值准备
    ,o.impam_loss -- 减值损失
    ,o.futures_margin -- 期货保证金
    ,o.open_dt -- 开仓日期
    ,o.last_update_dt -- 上次更新日期
    ,o.fee -- 费用
    ,o.paybl_fee -- 应付费用
    ,o.fee_cost -- 费用成本
    ,o.amort_net_price_cost -- 摊余净价成本
    ,o.amort_int_cost -- 摊余利息成本
    ,o.actl_int_rat -- 实际利率
    ,o.invest_yld_rat -- 投资收益率
    ,o.open_yld_rat -- 开仓收益率
    ,o.pre_recv_int -- 预收息
    ,o.non_amort_net_price_cost -- 不摊销净价成本
    ,o.non_amort_evha_val_chag -- 不摊销公允价值变动
    ,o.non_amort_fair_val_pl -- 不摊销公允价值损益
    ,o.non_amort_bs_pl -- 不摊销买卖损益
    ,o.provi_amort_closing_dt -- 计提摊销截止日期
    ,o.impam_status_cd -- 减值状态代码
    ,o.cost_impam_loss -- 成本减值损失
    ,o.int_impam_loss -- 利息减值损失
    ,o.cost_impam_prep -- 成本减值准备
    ,o.wrtn_off_cost -- 已核销成本
    ,o.wrtn_off_acru_int -- 已核销应计利息
    ,o.wrtn_off_recvbl_uncol_int -- 已核销应收未收利息
    ,o.off_bs_acru_int -- 表外应计利息
    ,o.off_bs_recvbl_uncol_int -- 表外应收未收利息
    ,o.acru_int_amt -- 应计利息发生额
    ,o.acru_vat -- 应计增值税
    ,o.paybl_vat -- 应付增值税
    ,o.curr_cd -- 币种代码
    ,o.stl_dt -- 结算日期
    ,o.rlizd_evha_val_chag_pl -- 已实现公允价值变动损益
    ,o.curr_post_int_tax -- 当前持仓利息税
    ,o.open_int_cost -- 开仓利息成本
    ,o.open_ex_yld_rat -- 开仓行权收益率
    ,o.pre_recv_int_income -- 预收利息收入
    ,o.provi_int_income -- 计提利息收入
    ,o.int_recvbl_inco -- 应收利息收入
    ,o.actl_recv_int_income -- 实收利息收入
    ,o.provi_int_income_pre_recv_tax -- 计提利息收入预收税
    ,o.amort_int_income_paybl_vat -- 摊销利息收入应付增值税
    ,o.offset_dlvy_dt -- 平仓交割日期
    ,o.std_prod_id -- 标准产品编号
    ,o.asset_thd_cls_cd -- 资产三分类代码
    ,o.at_pre_recv_int_income -- 税后预收利息收入
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_bk o
    left join ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.obj_id = n.obj_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.obj_id = d.obj_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_secu_acct_accti_bal_h;
alter table ${iml_schema}.agt_secu_acct_accti_bal_h truncate partition for ('ibmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_secu_acct_accti_bal_h exchange subpartition p_ibmsf1_19000101 with table ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_cl;
alter table ${iml_schema}.agt_secu_acct_accti_bal_h exchange subpartition p_ibmsf1_20991231 with table ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_secu_acct_accti_bal_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_tm purge;
drop table ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_op purge;
drop table ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_secu_acct_accti_bal_h_ibmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_secu_acct_accti_bal_h', partname => 'p_ibmsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
