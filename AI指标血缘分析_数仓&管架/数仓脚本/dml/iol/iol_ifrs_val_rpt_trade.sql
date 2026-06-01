/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifrs_val_rpt_trade
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifrs_val_rpt_trade_ex purge;
alter table ${iol_schema}.ifrs_val_rpt_trade add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ifrs_val_rpt_trade truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ifrs_val_rpt_trade_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifrs_val_rpt_trade where 0=1;

insert /*+ append */ into ${iol_schema}.ifrs_val_rpt_trade_ex(
    d_data_dt -- 数据日期
    ,v_contract_no -- 资产代码
    ,v_businesstype -- 业务品种代码
    ,v_businesssubtype -- 业务子类型
    ,v_currency_code -- 币种代码
    ,v_org_id -- 机构号
    ,v_three_class -- 三分类
    ,n_fv_tier -- 公允价值层级
    ,v_asset_type -- 权益/债务
    ,v_value_type -- 净值类型
    ,v_targetasset_ind -- 是否可穿透
    ,v_layer -- 投资层级
    ,n_balance -- 账面金额
    ,n_actual_pay -- 实付金额
    ,n_accrual_interest -- 计提利息
    ,n_pv -- 公允价值
    ,n_pv_variation -- 公允价值变动
    ,n_duration -- 久期
    ,n_time_to_mat -- 剩余期限
    ,n_time_to_repricing -- 重订价期限
    ,v_trade_system -- 源系统
    ,d_putoutdate -- 起息日
    ,d_maturity -- 到期日
    ,n_businessrate -- 预期收益率/贴现率
    ,v_value_model -- 估值模型代码
    ,v_subjectno -- 科目号
    ,n_valid -- 有效标志
    ,v_classifyresult -- 五级分类
    ,v_trade_no -- 交易编号
    ,n_pv_lastday -- 上一跑批日公允价值
    ,n_pv_acctday -- 上一入账日公允价值
    ,n_pv_move_p_lastday -- 较上一跑批日公允价值波动百分比
    ,n_pv_move_p_acctday -- 较上一入账日公允价值波动百分比
    ,v_operate_orgid -- 经办机构号
    ,v_bill_no -- 票据号
    ,n_interest_adjust -- 利息调整
    ,n_zspread -- 点差
    ,v_interest_period -- 计息周期
    ,v_counterparty_name -- 交易对手名称
    ,n_pvcny_variation -- 以人民币计价的公允价值变动
    ,v_dept_id -- 部门
    ,v_subject_name -- 科目名称
    ,n_position_value -- 持仓面额
    ,n_account_value -- 投资成本/面值
    ,n_net_pv -- 估值净价
    ,n_base_point_value -- 基点价值
    ,n_convexity -- 凸性
    ,n_interest_accrued -- 应计利息(错)
    ,v_serialno -- 借据号
    ,v_three_stage_cd -- 三分类标识
    ,v_produck_type_s_cd -- 标准产品类型
    ,v_cust_code -- 发行人代码
    ,n_dirtyprice -- 中债估值（全价）
    ,n_cleanprice -- 中债估值（净价）
    ,v_bondduration -- 债券敏感度（修正久期）
    ,v_bonddv01 -- 债券敏感度（基点价值）
    ,v_bondconvexity -- 债券敏感度（凸性）
    ,v_bond_rating -- 债券评级
    ,v_overdue_flag -- 违约标识
    ,n_par_rate -- 票面利率
    ,v_gzmeth -- 估值方法
    ,v_asset_code -- 资产代码
    ,v_asset_name -- 资产名称
    ,n_pv_full_price -- 估值全价
    ,n_pv_lastday_dif -- 较上日估值变动
    ,n_pv_lastmon_dif -- 较上月估值变动
    ,n_pv_lastyear_dif -- 较上年估值变动
    ,n_pv_variation_dif -- 较上日公允价值变动（公允价值变动之差）
    ,v_bond_name -- 债项名称
    ,v_bond_cd -- 债项编号
    ,n_face_value_bal -- 持仓面值
    ,n_netvalue -- 当日净值
    ,n_holding_share -- 持有份额
    ,v_fund_name -- 基金名称
    ,v_fund_no -- 基金代码
    ,n_accrued_interest -- 应收利息
    ,v_trade_name -- 
    ,n_cleancost -- 净价成本
    ,n_cost -- 本金
    ,v_trade_type -- 业务分类
    ,n_ovdue_cost -- 逾期本金
    ,n_pvcny -- 以人民币计价的公允价值
    ,n_curr_convt_rate -- 
    ,glob_seq_num -- 全局流水号
    ,unique_seq_num -- 业务流水号
    ,ovdue_flg -- 逾期标识
    ,n_accrued_interest_ext -- 表外应收利息
    ,n_accrual_interest_ext -- 表外应计利息
    ,bill_no -- 票据编号bill_no
    ,bill_sub_intrv_id -- 子票据区间编号
    ,recvbl_uncol_acru_int -- 应收未收应计利息
    ,recvbl_uncol_int -- 应收未收利息
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    d_data_dt -- 数据日期
    ,v_contract_no -- 资产代码
    ,v_businesstype -- 业务品种代码
    ,v_businesssubtype -- 业务子类型
    ,v_currency_code -- 币种代码
    ,v_org_id -- 机构号
    ,v_three_class -- 三分类
    ,n_fv_tier -- 公允价值层级
    ,v_asset_type -- 权益/债务
    ,v_value_type -- 净值类型
    ,v_targetasset_ind -- 是否可穿透
    ,v_layer -- 投资层级
    ,n_balance -- 账面金额
    ,n_actual_pay -- 实付金额
    ,n_accrual_interest -- 计提利息
    ,n_pv -- 公允价值
    ,n_pv_variation -- 公允价值变动
    ,n_duration -- 久期
    ,n_time_to_mat -- 剩余期限
    ,n_time_to_repricing -- 重订价期限
    ,v_trade_system -- 源系统
    ,d_putoutdate -- 起息日
    ,d_maturity -- 到期日
    ,n_businessrate -- 预期收益率/贴现率
    ,v_value_model -- 估值模型代码
    ,v_subjectno -- 科目号
    ,n_valid -- 有效标志
    ,v_classifyresult -- 五级分类
    ,v_trade_no -- 交易编号
    ,n_pv_lastday -- 上一跑批日公允价值
    ,n_pv_acctday -- 上一入账日公允价值
    ,n_pv_move_p_lastday -- 较上一跑批日公允价值波动百分比
    ,n_pv_move_p_acctday -- 较上一入账日公允价值波动百分比
    ,v_operate_orgid -- 经办机构号
    ,v_bill_no -- 票据号
    ,n_interest_adjust -- 利息调整
    ,n_zspread -- 点差
    ,v_interest_period -- 计息周期
    ,v_counterparty_name -- 交易对手名称
    ,n_pvcny_variation -- 以人民币计价的公允价值变动
    ,v_dept_id -- 部门
    ,v_subject_name -- 科目名称
    ,n_position_value -- 持仓面额
    ,n_account_value -- 投资成本/面值
    ,n_net_pv -- 估值净价
    ,n_base_point_value -- 基点价值
    ,n_convexity -- 凸性
    ,n_interest_accrued -- 应计利息(错)
    ,v_serialno -- 借据号
    ,v_three_stage_cd -- 三分类标识
    ,v_produck_type_s_cd -- 标准产品类型
    ,v_cust_code -- 发行人代码
    ,n_dirtyprice -- 中债估值（全价）
    ,n_cleanprice -- 中债估值（净价）
    ,v_bondduration -- 债券敏感度（修正久期）
    ,v_bonddv01 -- 债券敏感度（基点价值）
    ,v_bondconvexity -- 债券敏感度（凸性）
    ,v_bond_rating -- 债券评级
    ,v_overdue_flag -- 违约标识
    ,n_par_rate -- 票面利率
    ,v_gzmeth -- 估值方法
    ,v_asset_code -- 资产代码
    ,v_asset_name -- 资产名称
    ,n_pv_full_price -- 估值全价
    ,n_pv_lastday_dif -- 较上日估值变动
    ,n_pv_lastmon_dif -- 较上月估值变动
    ,n_pv_lastyear_dif -- 较上年估值变动
    ,n_pv_variation_dif -- 较上日公允价值变动（公允价值变动之差）
    ,v_bond_name -- 债项名称
    ,v_bond_cd -- 债项编号
    ,n_face_value_bal -- 持仓面值
    ,n_netvalue -- 当日净值
    ,n_holding_share -- 持有份额
    ,v_fund_name -- 基金名称
    ,v_fund_no -- 基金代码
    ,n_accrued_interest -- 应收利息
    ,v_trade_name -- 
    ,n_cleancost -- 净价成本
    ,n_cost -- 本金
    ,v_trade_type -- 业务分类
    ,n_ovdue_cost -- 逾期本金
    ,n_pvcny -- 以人民币计价的公允价值
    ,n_curr_convt_rate -- 
    ,glob_seq_num -- 全局流水号
    ,unique_seq_num -- 业务流水号
    ,ovdue_flg -- 逾期标识
    ,n_accrued_interest_ext -- 表外应收利息
    ,n_accrual_interest_ext -- 表外应计利息
    ,bill_no -- 票据编号bill_no
    ,bill_sub_intrv_id -- 子票据区间编号
    ,recvbl_uncol_acru_int -- 应收未收应计利息
    ,recvbl_uncol_int -- 应收未收利息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifrs_val_rpt_trade
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifrs_val_rpt_trade exchange partition p_${batch_date} with table ${iol_schema}.ifrs_val_rpt_trade_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifrs_val_rpt_trade to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifrs_val_rpt_trade_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifrs_val_rpt_trade',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);