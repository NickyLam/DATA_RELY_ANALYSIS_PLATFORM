/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_am_fin_prod_tran_tot_h_famsf2
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
alter table ${iml_schema}.evt_am_fin_prod_tran_tot_h add partition p_famsf2 values ('famsf2')(
        subpartition p_famsf2_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_famsf2_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_am_fin_prod_tran_tot_h partition for ('famsf2')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_tm purge;
drop table ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_op purge;
drop table ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tot_tran_id -- 汇总交易编号
    ,bus_type_cd -- 业务类型代码
    ,fin_prod_id -- 金融产品编号
    ,prod_cate_cd -- 产品类别代码
    ,brch_seq_num -- 分支序号
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,dlvy_dt -- 交割日期
    ,curr_cd -- 币种代码
    ,corp_net_price -- 单位净价
    ,corp_int -- 单位利息
    ,corp_full_price -- 单位全价
    ,corp_fac_val -- 单位面值
    ,net_price_tot -- 净价总额
    ,tran_lot -- 交易份额
    ,tran_pric -- 交易本金
    ,int_tot -- 利息总额
    ,full_price_tot -- 全价总额
    ,tran_amt -- 交易金额
    ,tot_tran_fee -- 总交易费用
    ,tran_type_cd -- 交易类型代码
    ,exp_yld_rat -- 到期收益率
    ,ex_yld_rat -- 行权收益率
    ,invest_aim_cd -- 投资目的代码
    ,tran_status_cd -- 交易状态代码
    ,init_tran_id -- 原交易编号
    ,revo_flg -- 撤销标志
    ,payoff_flg -- 结清标志
    ,cashflow_id -- 现金流编号
    ,secu_mgmt_acct_id -- 证券管理户编号
    ,front_tran_id -- 前置交易编号
    ,pass_id -- 通道编号
    ,cntpty_id -- 交易对手编号
    ,ext_tran_flg -- 外部交易标志
    ,tran_site_cd -- 交易场所代码
    ,tran_plat_cd -- 交易平台代码
    ,market_type_cd -- 市场类型代码
    ,dealer_name -- 交易员名称
    ,cntpty_dealer_name -- 对手方交易员名称
    ,rela_sys_tran_id -- 关联系统交易编号
    ,inv_port_id -- 投资组合编号
    ,finc_prod_id -- 理财产品编号
    ,super_tot_tran_id -- 上级汇总交易编号
    ,remark -- 备注
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,curr_issue_subscr_amt -- 本期认购金额
    ,l_ped_bal -- 上期余额
    ,l_ped_tran_in_bal -- 上期转入余额
    ,avl_cap -- 到账资金
    ,redem_prft -- 赎回收益
    ,redem_cost -- 赎回成本
    ,exp_pric -- 到期本金
    ,pay_dt -- 交付日期
    ,surp_nati_pric -- 剩余名义本金
    ,im_bus_type_cd -- 投管业务类型代码
    ,ovdue_flg -- 逾期标志
    ,fst_stl_way_cd -- 首期结算方式代码
    ,exp_stl_way_cd -- 到期结算方式代码
    ,tenor_days -- 期限天数
    ,clear_ped_cd -- 清算周期代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_am_fin_prod_tran_tot_h partition for ('famsf2')
where 0=1
;

create table ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_am_fin_prod_tran_tot_h partition for ('famsf2') where 0=1;

create table ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_am_fin_prod_tran_tot_h partition for ('famsf2') where 0=1;

-- 3.1 get new data into table
-- fams_trd_fin_product_deal_total-
insert into ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tot_tran_id -- 汇总交易编号
    ,bus_type_cd -- 业务类型代码
    ,fin_prod_id -- 金融产品编号
    ,prod_cate_cd -- 产品类别代码
    ,brch_seq_num -- 分支序号
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,dlvy_dt -- 交割日期
    ,curr_cd -- 币种代码
    ,corp_net_price -- 单位净价
    ,corp_int -- 单位利息
    ,corp_full_price -- 单位全价
    ,corp_fac_val -- 单位面值
    ,net_price_tot -- 净价总额
    ,tran_lot -- 交易份额
    ,tran_pric -- 交易本金
    ,int_tot -- 利息总额
    ,full_price_tot -- 全价总额
    ,tran_amt -- 交易金额
    ,tot_tran_fee -- 总交易费用
    ,tran_type_cd -- 交易类型代码
    ,exp_yld_rat -- 到期收益率
    ,ex_yld_rat -- 行权收益率
    ,invest_aim_cd -- 投资目的代码
    ,tran_status_cd -- 交易状态代码
    ,init_tran_id -- 原交易编号
    ,revo_flg -- 撤销标志
    ,payoff_flg -- 结清标志
    ,cashflow_id -- 现金流编号
    ,secu_mgmt_acct_id -- 证券管理户编号
    ,front_tran_id -- 前置交易编号
    ,pass_id -- 通道编号
    ,cntpty_id -- 交易对手编号
    ,ext_tran_flg -- 外部交易标志
    ,tran_site_cd -- 交易场所代码
    ,tran_plat_cd -- 交易平台代码
    ,market_type_cd -- 市场类型代码
    ,dealer_name -- 交易员名称
    ,cntpty_dealer_name -- 对手方交易员名称
    ,rela_sys_tran_id -- 关联系统交易编号
    ,inv_port_id -- 投资组合编号
    ,finc_prod_id -- 理财产品编号
    ,super_tot_tran_id -- 上级汇总交易编号
    ,remark -- 备注
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,curr_issue_subscr_amt -- 本期认购金额
    ,l_ped_bal -- 上期余额
    ,l_ped_tran_in_bal -- 上期转入余额
    ,avl_cap -- 到账资金
    ,redem_prft -- 赎回收益
    ,redem_cost -- 赎回成本
    ,exp_pric -- 到期本金
    ,pay_dt -- 交付日期
    ,surp_nati_pric -- 剩余名义本金
    ,im_bus_type_cd -- 投管业务类型代码
    ,ovdue_flg -- 逾期标志
    ,fst_stl_way_cd -- 首期结算方式代码
    ,exp_stl_way_cd -- 到期结算方式代码
    ,tenor_days -- 期限天数
    ,clear_ped_cd -- 清算周期代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104036'||P1.TOTLE_TRADE_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TOTLE_TRADE_ID -- 汇总交易编号
    ,NVL(TRIM(P1.BUSI_TYPE),'-') -- 业务类型代码
    ,P1.FINPROD_ID -- 金融产品编号
    ,decode(TRIM(P1.FINPROD_TYPE2),'01','C05','02','C06','03','C03','99','F20',NVL(TRIM(P1.FINPROD_TYPE2),'-')) -- 产品类别代码
    ,to_char(P1.BRANCH) -- 分支序号
    ,P1.TRADE_DATE -- 交易日期
    ,P1.VDATE -- 起息日期
    ,decode(P1.MDATE,to_date('00010101','yyyymmdd'),to_date('29991231','yyyymmdd'),P1.MDATE) -- 到期日期
    ,decode(P1.SETTLE_DATE,to_date('00010101','yyyymmdd'),to_date('29991231','yyyymmdd'),P1.SETTLE_DATE) -- 交割日期
    ,NVL(TRIM(P1.CCY),'-') -- 币种代码
    ,P1.UNIT_CPRICE -- 单位净价
    ,P1.UNIT_INT -- 单位利息
    ,P1.UNIT_FPRICE -- 单位全价
    ,P1.PAR_VALUE -- 单位面值
    ,P1.CPRICE_AMT -- 净价总额
    ,P1.SHARE_AMT -- 交易份额
    ,P1.PRIN_AMT -- 交易本金
    ,P1.INT_AMT -- 利息总额
    ,P1.FPRICE_AMT -- 全价总额
    ,P1.TRADE_AMT -- 交易金额
    ,P1.FEE_AMT -- 总交易费用
    ,NVL(TRIM(P1.PS),'-')  -- 交易类型代码
    ,P1.YIELD -- 到期收益率
    ,P1.EXER_YIELD -- 行权收益率
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.inv_aim END -- 投资目的代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.trade_status END -- 交易状态代码
    ,P1.P_TRADE_ID -- 原交易编号
    ,CASE WHEN P1.IS_CANCEL='Y' THEN '1' WHEN P1.IS_CANCEL='S' THEN '1' WHEN P1.IS_CANCEL='N' THEN '0' ELSE '-' END -- 撤销标志
    ,CASE WHEN P1.IS_CLEAN='Y' THEN '1' WHEN P1.IS_CLEAN='S' THEN '1' WHEN P1.IS_CLEAN='N' THEN '0' ELSE '-' END -- 结清标志
    ,P1.CASH_ID -- 现金流编号
    ,P1.SEC_MANAGE_ACCT_ID -- 证券管理户编号
    ,P1.B_TRADE_ID -- 前置交易编号
    ,P1.CHL_ID -- 通道编号
    ,P1.COUNTER_ID -- 交易对手编号
    ,CASE WHEN P1.IS_OUT_TRADE='Y' THEN '1' WHEN P1.IS_OUT_TRADE='S' THEN '1' WHEN P1.IS_OUT_TRADE='N' THEN '0' ELSE '-' END -- 外部交易标志
    ,NVL(TRIM(P1.TRADE_MARKET),'99') -- 交易场所代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.trade_plat END -- 交易平台代码
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.trade_market_mode END -- 市场类型代码
    ,P1.TRADER -- 交易员名称
    ,P1.COUNTER_TRADER -- 对手方交易员名称
    ,P1.F_TRADE_ID -- 关联系统交易编号
    ,P1.PORTFOLIO_ID -- 投资组合编号
    ,P1.PROD_ID -- 理财产品编号
    ,P1.P_TOTLE_TRADE_ID -- 上级汇总交易编号
    ,P1.REMARK -- 备注
    ,P1.CREATE_TIME -- 创建时间
    ,P1.UPDATE_TIME -- 更新时间
    ,P1.CURRENT_SUB -- 本期认购金额
    ,P1.LAST_AMT -- 上期余额
    ,P1.LAST_AMT_SUB -- 上期转入余额
    ,P1.ACCOUNTING_AMT -- 到账资金
    ,P1.RED_PROFIT -- 赎回收益
    ,P1.RED_COST -- 赎回成本
    ,P1.DQPRIN_AMT -- 到期本金
    ,decode(P1.PAY_DATE,to_date('00010101','yyyymmdd'),to_date('29991231','yyyymmdd'),P1.PAY_DATE) -- 交付日期
    ,P1.REMAIN_PRIN -- 剩余名义本金
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.tg_busi_type END -- 投管业务类型代码
    ,CASE WHEN P1.is_overdue_deal='Y' THEN '1' WHEN P1.is_overdue_deal='S' THEN '1' WHEN P1.is_overdue_deal='N' THEN '0' ELSE '-' END -- 逾期标志
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.delivery_type END -- 首期结算方式代码
    ,P1.m_delivery_type -- 到期结算方式代码
    ,P1.REPO_TERM -- 期限天数
    ,NVL(to_char(P1.SETTLE_SPEED),'9') -- 清算周期代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_trd_fin_product_deal_total' -- 源表名称
    ,'famsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_trd_fin_product_deal_total p1
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.INV_AIM= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FAMS'
        AND R3.SRC_TAB_EN_NAME= 'FAMS_TRD_FIN_PRODUCT_DEAL_TOTAL'
        AND R3.SRC_FIELD_EN_NAME= 'INV_AIM'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_AM_FIN_PROD_TRAN_TOT_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'INVEST_AIM_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.TRADE_STATUS= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'FAMS'
        AND R4.SRC_TAB_EN_NAME= 'FAMS_TRD_FIN_PRODUCT_DEAL_TOTAL'
        AND R4.SRC_FIELD_EN_NAME= 'TRADE_STATUS'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_AM_FIN_PROD_TRAN_TOT_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.TRADE_PLAT= R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'FAMS'
        AND R5.SRC_TAB_EN_NAME= 'FAMS_TRD_FIN_PRODUCT_DEAL_TOTAL'
        AND R5.SRC_FIELD_EN_NAME= 'TRADE_PLAT'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_AM_FIN_PROD_TRAN_TOT_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'TRAN_PLAT_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.TRADE_MARKET_MODE= R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'FAMS'
        AND R6.SRC_TAB_EN_NAME= 'FAMS_TRD_FIN_PRODUCT_DEAL_TOTAL'
        AND R6.SRC_FIELD_EN_NAME= 'TRADE_MARKET_MODE'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_AM_FIN_PROD_TRAN_TOT_H'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'MARKET_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.TG_BUSI_TYPE= R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'FAMS'
        AND R7.SRC_TAB_EN_NAME= 'FAMS_TRD_FIN_PRODUCT_DEAL_TOTAL'
        AND R7.SRC_FIELD_EN_NAME= 'TG_BUSI_TYPE'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_AM_FIN_PROD_TRAN_TOT_H'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'IM_BUS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.DELIVERY_TYPE= R8.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FAMS'
        AND R8.SRC_TAB_EN_NAME= 'FAMS_TRD_FIN_PRODUCT_DEAL_TOTAL'
        AND R8.SRC_FIELD_EN_NAME= 'DELIVERY_TYPE'
        AND R8.TARGET_TAB_EN_NAME= 'EVT_AM_FIN_PROD_TRAN_TOT_H'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'FST_STL_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tot_tran_id -- 汇总交易编号
    ,bus_type_cd -- 业务类型代码
    ,fin_prod_id -- 金融产品编号
    ,prod_cate_cd -- 产品类别代码
    ,brch_seq_num -- 分支序号
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,dlvy_dt -- 交割日期
    ,curr_cd -- 币种代码
    ,corp_net_price -- 单位净价
    ,corp_int -- 单位利息
    ,corp_full_price -- 单位全价
    ,corp_fac_val -- 单位面值
    ,net_price_tot -- 净价总额
    ,tran_lot -- 交易份额
    ,tran_pric -- 交易本金
    ,int_tot -- 利息总额
    ,full_price_tot -- 全价总额
    ,tran_amt -- 交易金额
    ,tot_tran_fee -- 总交易费用
    ,tran_type_cd -- 交易类型代码
    ,exp_yld_rat -- 到期收益率
    ,ex_yld_rat -- 行权收益率
    ,invest_aim_cd -- 投资目的代码
    ,tran_status_cd -- 交易状态代码
    ,init_tran_id -- 原交易编号
    ,revo_flg -- 撤销标志
    ,payoff_flg -- 结清标志
    ,cashflow_id -- 现金流编号
    ,secu_mgmt_acct_id -- 证券管理户编号
    ,front_tran_id -- 前置交易编号
    ,pass_id -- 通道编号
    ,cntpty_id -- 交易对手编号
    ,ext_tran_flg -- 外部交易标志
    ,tran_site_cd -- 交易场所代码
    ,tran_plat_cd -- 交易平台代码
    ,market_type_cd -- 市场类型代码
    ,dealer_name -- 交易员名称
    ,cntpty_dealer_name -- 对手方交易员名称
    ,rela_sys_tran_id -- 关联系统交易编号
    ,inv_port_id -- 投资组合编号
    ,finc_prod_id -- 理财产品编号
    ,super_tot_tran_id -- 上级汇总交易编号
    ,remark -- 备注
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,curr_issue_subscr_amt -- 本期认购金额
    ,l_ped_bal -- 上期余额
    ,l_ped_tran_in_bal -- 上期转入余额
    ,avl_cap -- 到账资金
    ,redem_prft -- 赎回收益
    ,redem_cost -- 赎回成本
    ,exp_pric -- 到期本金
    ,pay_dt -- 交付日期
    ,surp_nati_pric -- 剩余名义本金
    ,im_bus_type_cd -- 投管业务类型代码
    ,ovdue_flg -- 逾期标志
    ,fst_stl_way_cd -- 首期结算方式代码
    ,exp_stl_way_cd -- 到期结算方式代码
    ,tenor_days -- 期限天数
    ,clear_ped_cd -- 清算周期代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tot_tran_id -- 汇总交易编号
    ,bus_type_cd -- 业务类型代码
    ,fin_prod_id -- 金融产品编号
    ,prod_cate_cd -- 产品类别代码
    ,brch_seq_num -- 分支序号
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,dlvy_dt -- 交割日期
    ,curr_cd -- 币种代码
    ,corp_net_price -- 单位净价
    ,corp_int -- 单位利息
    ,corp_full_price -- 单位全价
    ,corp_fac_val -- 单位面值
    ,net_price_tot -- 净价总额
    ,tran_lot -- 交易份额
    ,tran_pric -- 交易本金
    ,int_tot -- 利息总额
    ,full_price_tot -- 全价总额
    ,tran_amt -- 交易金额
    ,tot_tran_fee -- 总交易费用
    ,tran_type_cd -- 交易类型代码
    ,exp_yld_rat -- 到期收益率
    ,ex_yld_rat -- 行权收益率
    ,invest_aim_cd -- 投资目的代码
    ,tran_status_cd -- 交易状态代码
    ,init_tran_id -- 原交易编号
    ,revo_flg -- 撤销标志
    ,payoff_flg -- 结清标志
    ,cashflow_id -- 现金流编号
    ,secu_mgmt_acct_id -- 证券管理户编号
    ,front_tran_id -- 前置交易编号
    ,pass_id -- 通道编号
    ,cntpty_id -- 交易对手编号
    ,ext_tran_flg -- 外部交易标志
    ,tran_site_cd -- 交易场所代码
    ,tran_plat_cd -- 交易平台代码
    ,market_type_cd -- 市场类型代码
    ,dealer_name -- 交易员名称
    ,cntpty_dealer_name -- 对手方交易员名称
    ,rela_sys_tran_id -- 关联系统交易编号
    ,inv_port_id -- 投资组合编号
    ,finc_prod_id -- 理财产品编号
    ,super_tot_tran_id -- 上级汇总交易编号
    ,remark -- 备注
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,curr_issue_subscr_amt -- 本期认购金额
    ,l_ped_bal -- 上期余额
    ,l_ped_tran_in_bal -- 上期转入余额
    ,avl_cap -- 到账资金
    ,redem_prft -- 赎回收益
    ,redem_cost -- 赎回成本
    ,exp_pric -- 到期本金
    ,pay_dt -- 交付日期
    ,surp_nati_pric -- 剩余名义本金
    ,im_bus_type_cd -- 投管业务类型代码
    ,ovdue_flg -- 逾期标志
    ,fst_stl_way_cd -- 首期结算方式代码
    ,exp_stl_way_cd -- 到期结算方式代码
    ,tenor_days -- 期限天数
    ,clear_ped_cd -- 清算周期代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.tot_tran_id, o.tot_tran_id) as tot_tran_id -- 汇总交易编号
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.fin_prod_id, o.fin_prod_id) as fin_prod_id -- 金融产品编号
    ,nvl(n.prod_cate_cd, o.prod_cate_cd) as prod_cate_cd -- 产品类别代码
    ,nvl(n.brch_seq_num, o.brch_seq_num) as brch_seq_num -- 分支序号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.dlvy_dt, o.dlvy_dt) as dlvy_dt -- 交割日期
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.corp_net_price, o.corp_net_price) as corp_net_price -- 单位净价
    ,nvl(n.corp_int, o.corp_int) as corp_int -- 单位利息
    ,nvl(n.corp_full_price, o.corp_full_price) as corp_full_price -- 单位全价
    ,nvl(n.corp_fac_val, o.corp_fac_val) as corp_fac_val -- 单位面值
    ,nvl(n.net_price_tot, o.net_price_tot) as net_price_tot -- 净价总额
    ,nvl(n.tran_lot, o.tran_lot) as tran_lot -- 交易份额
    ,nvl(n.tran_pric, o.tran_pric) as tran_pric -- 交易本金
    ,nvl(n.int_tot, o.int_tot) as int_tot -- 利息总额
    ,nvl(n.full_price_tot, o.full_price_tot) as full_price_tot -- 全价总额
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.tot_tran_fee, o.tot_tran_fee) as tot_tran_fee -- 总交易费用
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 交易类型代码
    ,nvl(n.exp_yld_rat, o.exp_yld_rat) as exp_yld_rat -- 到期收益率
    ,nvl(n.ex_yld_rat, o.ex_yld_rat) as ex_yld_rat -- 行权收益率
    ,nvl(n.invest_aim_cd, o.invest_aim_cd) as invest_aim_cd -- 投资目的代码
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.init_tran_id, o.init_tran_id) as init_tran_id -- 原交易编号
    ,nvl(n.revo_flg, o.revo_flg) as revo_flg -- 撤销标志
    ,nvl(n.payoff_flg, o.payoff_flg) as payoff_flg -- 结清标志
    ,nvl(n.cashflow_id, o.cashflow_id) as cashflow_id -- 现金流编号
    ,nvl(n.secu_mgmt_acct_id, o.secu_mgmt_acct_id) as secu_mgmt_acct_id -- 证券管理户编号
    ,nvl(n.front_tran_id, o.front_tran_id) as front_tran_id -- 前置交易编号
    ,nvl(n.pass_id, o.pass_id) as pass_id -- 通道编号
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.ext_tran_flg, o.ext_tran_flg) as ext_tran_flg -- 外部交易标志
    ,nvl(n.tran_site_cd, o.tran_site_cd) as tran_site_cd -- 交易场所代码
    ,nvl(n.tran_plat_cd, o.tran_plat_cd) as tran_plat_cd -- 交易平台代码
    ,nvl(n.market_type_cd, o.market_type_cd) as market_type_cd -- 市场类型代码
    ,nvl(n.dealer_name, o.dealer_name) as dealer_name -- 交易员名称
    ,nvl(n.cntpty_dealer_name, o.cntpty_dealer_name) as cntpty_dealer_name -- 对手方交易员名称
    ,nvl(n.rela_sys_tran_id, o.rela_sys_tran_id) as rela_sys_tran_id -- 关联系统交易编号
    ,nvl(n.inv_port_id, o.inv_port_id) as inv_port_id -- 投资组合编号
    ,nvl(n.finc_prod_id, o.finc_prod_id) as finc_prod_id -- 理财产品编号
    ,nvl(n.super_tot_tran_id, o.super_tot_tran_id) as super_tot_tran_id -- 上级汇总交易编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.create_tm, o.create_tm) as create_tm -- 创建时间
    ,nvl(n.update_tm, o.update_tm) as update_tm -- 更新时间
    ,nvl(n.curr_issue_subscr_amt, o.curr_issue_subscr_amt) as curr_issue_subscr_amt -- 本期认购金额
    ,nvl(n.l_ped_bal, o.l_ped_bal) as l_ped_bal -- 上期余额
    ,nvl(n.l_ped_tran_in_bal, o.l_ped_tran_in_bal) as l_ped_tran_in_bal -- 上期转入余额
    ,nvl(n.avl_cap, o.avl_cap) as avl_cap -- 到账资金
    ,nvl(n.redem_prft, o.redem_prft) as redem_prft -- 赎回收益
    ,nvl(n.redem_cost, o.redem_cost) as redem_cost -- 赎回成本
    ,nvl(n.exp_pric, o.exp_pric) as exp_pric -- 到期本金
    ,nvl(n.pay_dt, o.pay_dt) as pay_dt -- 交付日期
    ,nvl(n.surp_nati_pric, o.surp_nati_pric) as surp_nati_pric -- 剩余名义本金
    ,nvl(n.im_bus_type_cd, o.im_bus_type_cd) as im_bus_type_cd -- 投管业务类型代码
    ,nvl(n.ovdue_flg, o.ovdue_flg) as ovdue_flg -- 逾期标志
    ,nvl(n.fst_stl_way_cd, o.fst_stl_way_cd) as fst_stl_way_cd -- 首期结算方式代码
    ,nvl(n.exp_stl_way_cd, o.exp_stl_way_cd) as exp_stl_way_cd -- 到期结算方式代码
    ,nvl(n.tenor_days, o.tenor_days) as tenor_days -- 期限天数
    ,nvl(n.clear_ped_cd, o.clear_ped_cd) as clear_ped_cd -- 清算周期代码
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_tm n
    full join (select * from ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.tot_tran_id <> n.tot_tran_id
        or o.bus_type_cd <> n.bus_type_cd
        or o.fin_prod_id <> n.fin_prod_id
        or o.prod_cate_cd <> n.prod_cate_cd
        or o.brch_seq_num <> n.brch_seq_num
        or o.tran_dt <> n.tran_dt
        or o.value_dt <> n.value_dt
        or o.exp_dt <> n.exp_dt
        or o.dlvy_dt <> n.dlvy_dt
        or o.curr_cd <> n.curr_cd
        or o.corp_net_price <> n.corp_net_price
        or o.corp_int <> n.corp_int
        or o.corp_full_price <> n.corp_full_price
        or o.corp_fac_val <> n.corp_fac_val
        or o.net_price_tot <> n.net_price_tot
        or o.tran_lot <> n.tran_lot
        or o.tran_pric <> n.tran_pric
        or o.int_tot <> n.int_tot
        or o.full_price_tot <> n.full_price_tot
        or o.tran_amt <> n.tran_amt
        or o.tot_tran_fee <> n.tot_tran_fee
        or o.tran_type_cd <> n.tran_type_cd
        or o.exp_yld_rat <> n.exp_yld_rat
        or o.ex_yld_rat <> n.ex_yld_rat
        or o.invest_aim_cd <> n.invest_aim_cd
        or o.tran_status_cd <> n.tran_status_cd
        or o.init_tran_id <> n.init_tran_id
        or o.revo_flg <> n.revo_flg
        or o.payoff_flg <> n.payoff_flg
        or o.cashflow_id <> n.cashflow_id
        or o.secu_mgmt_acct_id <> n.secu_mgmt_acct_id
        or o.front_tran_id <> n.front_tran_id
        or o.pass_id <> n.pass_id
        or o.cntpty_id <> n.cntpty_id
        or o.ext_tran_flg <> n.ext_tran_flg
        or o.tran_site_cd <> n.tran_site_cd
        or o.tran_plat_cd <> n.tran_plat_cd
        or o.market_type_cd <> n.market_type_cd
        or o.dealer_name <> n.dealer_name
        or o.cntpty_dealer_name <> n.cntpty_dealer_name
        or o.rela_sys_tran_id <> n.rela_sys_tran_id
        or o.inv_port_id <> n.inv_port_id
        or o.finc_prod_id <> n.finc_prod_id
        or o.super_tot_tran_id <> n.super_tot_tran_id
        or o.remark <> n.remark
        or o.create_tm <> n.create_tm
        or o.update_tm <> n.update_tm
        or o.curr_issue_subscr_amt <> n.curr_issue_subscr_amt
        or o.l_ped_bal <> n.l_ped_bal
        or o.l_ped_tran_in_bal <> n.l_ped_tran_in_bal
        or o.avl_cap <> n.avl_cap
        or o.redem_prft <> n.redem_prft
        or o.redem_cost <> n.redem_cost
        or o.exp_pric <> n.exp_pric
        or o.pay_dt <> n.pay_dt
        or o.surp_nati_pric <> n.surp_nati_pric
        or o.im_bus_type_cd <> n.im_bus_type_cd
        or o.ovdue_flg <> n.ovdue_flg
        or o.fst_stl_way_cd <> n.fst_stl_way_cd
        or o.exp_stl_way_cd <> n.exp_stl_way_cd
        or o.tenor_days <> n.tenor_days
        or o.clear_ped_cd <> n.clear_ped_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tot_tran_id -- 汇总交易编号
    ,bus_type_cd -- 业务类型代码
    ,fin_prod_id -- 金融产品编号
    ,prod_cate_cd -- 产品类别代码
    ,brch_seq_num -- 分支序号
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,dlvy_dt -- 交割日期
    ,curr_cd -- 币种代码
    ,corp_net_price -- 单位净价
    ,corp_int -- 单位利息
    ,corp_full_price -- 单位全价
    ,corp_fac_val -- 单位面值
    ,net_price_tot -- 净价总额
    ,tran_lot -- 交易份额
    ,tran_pric -- 交易本金
    ,int_tot -- 利息总额
    ,full_price_tot -- 全价总额
    ,tran_amt -- 交易金额
    ,tot_tran_fee -- 总交易费用
    ,tran_type_cd -- 交易类型代码
    ,exp_yld_rat -- 到期收益率
    ,ex_yld_rat -- 行权收益率
    ,invest_aim_cd -- 投资目的代码
    ,tran_status_cd -- 交易状态代码
    ,init_tran_id -- 原交易编号
    ,revo_flg -- 撤销标志
    ,payoff_flg -- 结清标志
    ,cashflow_id -- 现金流编号
    ,secu_mgmt_acct_id -- 证券管理户编号
    ,front_tran_id -- 前置交易编号
    ,pass_id -- 通道编号
    ,cntpty_id -- 交易对手编号
    ,ext_tran_flg -- 外部交易标志
    ,tran_site_cd -- 交易场所代码
    ,tran_plat_cd -- 交易平台代码
    ,market_type_cd -- 市场类型代码
    ,dealer_name -- 交易员名称
    ,cntpty_dealer_name -- 对手方交易员名称
    ,rela_sys_tran_id -- 关联系统交易编号
    ,inv_port_id -- 投资组合编号
    ,finc_prod_id -- 理财产品编号
    ,super_tot_tran_id -- 上级汇总交易编号
    ,remark -- 备注
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,curr_issue_subscr_amt -- 本期认购金额
    ,l_ped_bal -- 上期余额
    ,l_ped_tran_in_bal -- 上期转入余额
    ,avl_cap -- 到账资金
    ,redem_prft -- 赎回收益
    ,redem_cost -- 赎回成本
    ,exp_pric -- 到期本金
    ,pay_dt -- 交付日期
    ,surp_nati_pric -- 剩余名义本金
    ,im_bus_type_cd -- 投管业务类型代码
    ,ovdue_flg -- 逾期标志
    ,fst_stl_way_cd -- 首期结算方式代码
    ,exp_stl_way_cd -- 到期结算方式代码
    ,tenor_days -- 期限天数
    ,clear_ped_cd -- 清算周期代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tot_tran_id -- 汇总交易编号
    ,bus_type_cd -- 业务类型代码
    ,fin_prod_id -- 金融产品编号
    ,prod_cate_cd -- 产品类别代码
    ,brch_seq_num -- 分支序号
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,dlvy_dt -- 交割日期
    ,curr_cd -- 币种代码
    ,corp_net_price -- 单位净价
    ,corp_int -- 单位利息
    ,corp_full_price -- 单位全价
    ,corp_fac_val -- 单位面值
    ,net_price_tot -- 净价总额
    ,tran_lot -- 交易份额
    ,tran_pric -- 交易本金
    ,int_tot -- 利息总额
    ,full_price_tot -- 全价总额
    ,tran_amt -- 交易金额
    ,tot_tran_fee -- 总交易费用
    ,tran_type_cd -- 交易类型代码
    ,exp_yld_rat -- 到期收益率
    ,ex_yld_rat -- 行权收益率
    ,invest_aim_cd -- 投资目的代码
    ,tran_status_cd -- 交易状态代码
    ,init_tran_id -- 原交易编号
    ,revo_flg -- 撤销标志
    ,payoff_flg -- 结清标志
    ,cashflow_id -- 现金流编号
    ,secu_mgmt_acct_id -- 证券管理户编号
    ,front_tran_id -- 前置交易编号
    ,pass_id -- 通道编号
    ,cntpty_id -- 交易对手编号
    ,ext_tran_flg -- 外部交易标志
    ,tran_site_cd -- 交易场所代码
    ,tran_plat_cd -- 交易平台代码
    ,market_type_cd -- 市场类型代码
    ,dealer_name -- 交易员名称
    ,cntpty_dealer_name -- 对手方交易员名称
    ,rela_sys_tran_id -- 关联系统交易编号
    ,inv_port_id -- 投资组合编号
    ,finc_prod_id -- 理财产品编号
    ,super_tot_tran_id -- 上级汇总交易编号
    ,remark -- 备注
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,curr_issue_subscr_amt -- 本期认购金额
    ,l_ped_bal -- 上期余额
    ,l_ped_tran_in_bal -- 上期转入余额
    ,avl_cap -- 到账资金
    ,redem_prft -- 赎回收益
    ,redem_cost -- 赎回成本
    ,exp_pric -- 到期本金
    ,pay_dt -- 交付日期
    ,surp_nati_pric -- 剩余名义本金
    ,im_bus_type_cd -- 投管业务类型代码
    ,ovdue_flg -- 逾期标志
    ,fst_stl_way_cd -- 首期结算方式代码
    ,exp_stl_way_cd -- 到期结算方式代码
    ,tenor_days -- 期限天数
    ,clear_ped_cd -- 清算周期代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.tot_tran_id -- 汇总交易编号
    ,o.bus_type_cd -- 业务类型代码
    ,o.fin_prod_id -- 金融产品编号
    ,o.prod_cate_cd -- 产品类别代码
    ,o.brch_seq_num -- 分支序号
    ,o.tran_dt -- 交易日期
    ,o.value_dt -- 起息日期
    ,o.exp_dt -- 到期日期
    ,o.dlvy_dt -- 交割日期
    ,o.curr_cd -- 币种代码
    ,o.corp_net_price -- 单位净价
    ,o.corp_int -- 单位利息
    ,o.corp_full_price -- 单位全价
    ,o.corp_fac_val -- 单位面值
    ,o.net_price_tot -- 净价总额
    ,o.tran_lot -- 交易份额
    ,o.tran_pric -- 交易本金
    ,o.int_tot -- 利息总额
    ,o.full_price_tot -- 全价总额
    ,o.tran_amt -- 交易金额
    ,o.tot_tran_fee -- 总交易费用
    ,o.tran_type_cd -- 交易类型代码
    ,o.exp_yld_rat -- 到期收益率
    ,o.ex_yld_rat -- 行权收益率
    ,o.invest_aim_cd -- 投资目的代码
    ,o.tran_status_cd -- 交易状态代码
    ,o.init_tran_id -- 原交易编号
    ,o.revo_flg -- 撤销标志
    ,o.payoff_flg -- 结清标志
    ,o.cashflow_id -- 现金流编号
    ,o.secu_mgmt_acct_id -- 证券管理户编号
    ,o.front_tran_id -- 前置交易编号
    ,o.pass_id -- 通道编号
    ,o.cntpty_id -- 交易对手编号
    ,o.ext_tran_flg -- 外部交易标志
    ,o.tran_site_cd -- 交易场所代码
    ,o.tran_plat_cd -- 交易平台代码
    ,o.market_type_cd -- 市场类型代码
    ,o.dealer_name -- 交易员名称
    ,o.cntpty_dealer_name -- 对手方交易员名称
    ,o.rela_sys_tran_id -- 关联系统交易编号
    ,o.inv_port_id -- 投资组合编号
    ,o.finc_prod_id -- 理财产品编号
    ,o.super_tot_tran_id -- 上级汇总交易编号
    ,o.remark -- 备注
    ,o.create_tm -- 创建时间
    ,o.update_tm -- 更新时间
    ,o.curr_issue_subscr_amt -- 本期认购金额
    ,o.l_ped_bal -- 上期余额
    ,o.l_ped_tran_in_bal -- 上期转入余额
    ,o.avl_cap -- 到账资金
    ,o.redem_prft -- 赎回收益
    ,o.redem_cost -- 赎回成本
    ,o.exp_pric -- 到期本金
    ,o.pay_dt -- 交付日期
    ,o.surp_nati_pric -- 剩余名义本金
    ,o.im_bus_type_cd -- 投管业务类型代码
    ,o.ovdue_flg -- 逾期标志
    ,o.fst_stl_way_cd -- 首期结算方式代码
    ,o.exp_stl_way_cd -- 到期结算方式代码
    ,o.tenor_days -- 期限天数
    ,o.clear_ped_cd -- 清算周期代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_bk o
    left join ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_am_fin_prod_tran_tot_h;
alter table ${iml_schema}.evt_am_fin_prod_tran_tot_h truncate partition for ('famsf2') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.evt_am_fin_prod_tran_tot_h exchange subpartition p_famsf2_19000101 with table ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_cl;
alter table ${iml_schema}.evt_am_fin_prod_tran_tot_h exchange subpartition p_famsf2_20991231 with table ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_am_fin_prod_tran_tot_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_tm purge;
drop table ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_op purge;
drop table ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_am_fin_prod_tran_tot_h_famsf2_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_am_fin_prod_tran_tot_h', partname => 'p_famsf2_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
