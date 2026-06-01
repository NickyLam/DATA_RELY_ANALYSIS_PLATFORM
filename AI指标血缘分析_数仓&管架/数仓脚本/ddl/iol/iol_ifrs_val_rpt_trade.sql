/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifrs_val_rpt_trade
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifrs_val_rpt_trade
whenever sqlerror continue none;
drop table ${iol_schema}.ifrs_val_rpt_trade purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifrs_val_rpt_trade(
    d_data_dt date -- 数据日期
    ,v_contract_no varchar2(150) -- 资产代码
    ,v_businesstype varchar2(60) -- 业务品种代码
    ,v_businesssubtype varchar2(27) -- 业务子类型
    ,v_currency_code varchar2(5) -- 币种代码
    ,v_org_id varchar2(30) -- 机构号
    ,v_three_class varchar2(150) -- 三分类
    ,n_fv_tier varchar2(15) -- 公允价值层级
    ,v_asset_type varchar2(30) -- 权益/债务
    ,v_value_type varchar2(15) -- 净值类型
    ,v_targetasset_ind varchar2(15) -- 是否可穿透
    ,v_layer varchar2(15) -- 投资层级
    ,n_balance number(24,4) -- 账面金额
    ,n_actual_pay number(24,4) -- 实付金额
    ,n_accrual_interest number(24,4) -- 计提利息
    ,n_pv number(24,4) -- 公允价值
    ,n_pv_variation number(24,4) -- 公允价值变动
    ,n_duration number(24,4) -- 久期
    ,n_time_to_mat number(24,4) -- 剩余期限
    ,n_time_to_repricing number(24,4) -- 重订价期限
    ,v_trade_system varchar2(15) -- 源系统
    ,d_putoutdate date -- 起息日
    ,d_maturity date -- 到期日
    ,n_businessrate number(38,8) -- 预期收益率/贴现率
    ,v_value_model varchar2(60) -- 估值模型代码
    ,v_subjectno varchar2(30) -- 科目号
    ,n_valid number(22,0) -- 有效标志
    ,v_classifyresult varchar2(6) -- 五级分类
    ,v_trade_no varchar2(150) -- 交易编号
    ,n_pv_lastday number(24,4) -- 上一跑批日公允价值
    ,n_pv_acctday number(24,4) -- 上一入账日公允价值
    ,n_pv_move_p_lastday number(24,4) -- 较上一跑批日公允价值波动百分比
    ,n_pv_move_p_acctday number(24,4) -- 较上一入账日公允价值波动百分比
    ,v_operate_orgid varchar2(90) -- 经办机构号
    ,v_bill_no varchar2(60) -- 票据号
    ,n_interest_adjust number(24,4) -- 利息调整
    ,n_zspread number(28,6) -- 点差
    ,v_interest_period varchar2(30) -- 计息周期
    ,v_counterparty_name varchar2(750) -- 交易对手名称
    ,n_pvcny_variation number(24,4) -- 以人民币计价的公允价值变动
    ,v_dept_id varchar2(30) -- 部门
    ,v_subject_name varchar2(75) -- 科目名称
    ,n_position_value number(24,0) -- 持仓面额
    ,n_account_value number(24,4) -- 投资成本/面值
    ,n_net_pv number(24,4) -- 估值净价
    ,n_base_point_value number(24,4) -- 基点价值
    ,n_convexity number(24,4) -- 凸性
    ,n_interest_accrued number(24,4) -- 应计利息(错)
    ,v_serialno varchar2(90) -- 借据号
    ,v_three_stage_cd varchar2(150) -- 三分类标识
    ,v_produck_type_s_cd varchar2(90) -- 标准产品类型
    ,v_cust_code varchar2(90) -- 发行人代码
    ,n_dirtyprice number(24,4) -- 中债估值（全价）
    ,n_cleanprice number(24,4) -- 中债估值（净价）
    ,v_bondduration number(24,4) -- 债券敏感度（修正久期）
    ,v_bonddv01 number(24,4) -- 债券敏感度（基点价值）
    ,v_bondconvexity number(24,4) -- 债券敏感度（凸性）
    ,v_bond_rating varchar2(15) -- 债券评级
    ,v_overdue_flag varchar2(15) -- 违约标识
    ,n_par_rate number(24,4) -- 票面利率
    ,v_gzmeth varchar2(45) -- 估值方法
    ,v_asset_code varchar2(150) -- 资产代码
    ,v_asset_name varchar2(60) -- 资产名称
    ,n_pv_full_price number(24,4) -- 估值全价
    ,n_pv_lastday_dif number(24,4) -- 较上日估值变动
    ,n_pv_lastmon_dif number(24,4) -- 较上月估值变动
    ,n_pv_lastyear_dif number(24,4) -- 较上年估值变动
    ,n_pv_variation_dif number(24,4) -- 较上日公允价值变动（公允价值变动之差）
    ,v_bond_name varchar2(90) -- 债项名称
    ,v_bond_cd varchar2(150) -- 债项编号
    ,n_face_value_bal number(24,3) -- 持仓面值
    ,n_netvalue number(24,4) -- 当日净值
    ,n_holding_share number(24,4) -- 持有份额
    ,v_fund_name varchar2(75) -- 基金名称
    ,v_fund_no varchar2(75) -- 基金代码
    ,n_accrued_interest number(16,2) -- 应收利息
    ,v_trade_name varchar2(150) -- 
    ,n_cleancost number(24,4) -- 净价成本
    ,n_cost number(24,4) -- 本金
    ,v_trade_type varchar2(45) -- 业务分类
    ,n_ovdue_cost number(24,4) -- 逾期本金
    ,n_pvcny number(24,4) -- 以人民币计价的公允价值
    ,n_curr_convt_rate number(18,6) -- 
    ,glob_seq_num varchar2(50) -- 全局流水号
    ,unique_seq_num varchar2(50) -- 业务流水号
    ,ovdue_flg varchar2(15) -- 逾期标识
    ,n_accrued_interest_ext number(24,4) -- 表外应收利息
    ,n_accrual_interest_ext number(24,4) -- 表外应计利息
    ,bill_no varchar2(90) -- 票据编号bill_no
    ,bill_sub_intrv_id varchar2(90) -- 子票据区间编号
    ,recvbl_uncol_acru_int number(30,8) -- 应收未收应计利息
    ,recvbl_uncol_int number(30,8) -- 应收未收利息
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifrs_val_rpt_trade to ${iml_schema};
grant select on ${iol_schema}.ifrs_val_rpt_trade to ${icl_schema};
grant select on ${iol_schema}.ifrs_val_rpt_trade to ${idl_schema};
grant select on ${iol_schema}.ifrs_val_rpt_trade to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifrs_val_rpt_trade is '估值报告表';
comment on column ${iol_schema}.ifrs_val_rpt_trade.d_data_dt is '数据日期';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_contract_no is '资产代码';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_businesstype is '业务品种代码';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_businesssubtype is '业务子类型';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_currency_code is '币种代码';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_org_id is '机构号';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_three_class is '三分类';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_fv_tier is '公允价值层级';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_asset_type is '权益/债务';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_value_type is '净值类型';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_targetasset_ind is '是否可穿透';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_layer is '投资层级';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_balance is '账面金额';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_actual_pay is '实付金额';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_accrual_interest is '计提利息';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_pv is '公允价值';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_pv_variation is '公允价值变动';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_duration is '久期';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_time_to_mat is '剩余期限';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_time_to_repricing is '重订价期限';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_trade_system is '源系统';
comment on column ${iol_schema}.ifrs_val_rpt_trade.d_putoutdate is '起息日';
comment on column ${iol_schema}.ifrs_val_rpt_trade.d_maturity is '到期日';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_businessrate is '预期收益率/贴现率';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_value_model is '估值模型代码';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_subjectno is '科目号';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_valid is '有效标志';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_classifyresult is '五级分类';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_trade_no is '交易编号';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_pv_lastday is '上一跑批日公允价值';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_pv_acctday is '上一入账日公允价值';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_pv_move_p_lastday is '较上一跑批日公允价值波动百分比';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_pv_move_p_acctday is '较上一入账日公允价值波动百分比';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_operate_orgid is '经办机构号';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_bill_no is '票据号';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_interest_adjust is '利息调整';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_zspread is '点差';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_interest_period is '计息周期';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_counterparty_name is '交易对手名称';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_pvcny_variation is '以人民币计价的公允价值变动';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_dept_id is '部门';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_subject_name is '科目名称';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_position_value is '持仓面额';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_account_value is '投资成本/面值';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_net_pv is '估值净价';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_base_point_value is '基点价值';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_convexity is '凸性';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_interest_accrued is '应计利息(错)';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_serialno is '借据号';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_three_stage_cd is '三分类标识';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_produck_type_s_cd is '标准产品类型';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_cust_code is '发行人代码';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_dirtyprice is '中债估值（全价）';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_cleanprice is '中债估值（净价）';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_bondduration is '债券敏感度（修正久期）';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_bonddv01 is '债券敏感度（基点价值）';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_bondconvexity is '债券敏感度（凸性）';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_bond_rating is '债券评级';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_overdue_flag is '违约标识';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_par_rate is '票面利率';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_gzmeth is '估值方法';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_asset_code is '资产代码';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_asset_name is '资产名称';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_pv_full_price is '估值全价';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_pv_lastday_dif is '较上日估值变动';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_pv_lastmon_dif is '较上月估值变动';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_pv_lastyear_dif is '较上年估值变动';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_pv_variation_dif is '较上日公允价值变动（公允价值变动之差）';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_bond_name is '债项名称';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_bond_cd is '债项编号';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_face_value_bal is '持仓面值';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_netvalue is '当日净值';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_holding_share is '持有份额';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_fund_name is '基金名称';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_fund_no is '基金代码';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_accrued_interest is '应收利息';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_trade_name is '';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_cleancost is '净价成本';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_cost is '本金';
comment on column ${iol_schema}.ifrs_val_rpt_trade.v_trade_type is '业务分类';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_ovdue_cost is '逾期本金';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_pvcny is '以人民币计价的公允价值';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_curr_convt_rate is '';
comment on column ${iol_schema}.ifrs_val_rpt_trade.glob_seq_num is '全局流水号';
comment on column ${iol_schema}.ifrs_val_rpt_trade.unique_seq_num is '业务流水号';
comment on column ${iol_schema}.ifrs_val_rpt_trade.ovdue_flg is '逾期标识';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_accrued_interest_ext is '表外应收利息';
comment on column ${iol_schema}.ifrs_val_rpt_trade.n_accrual_interest_ext is '表外应计利息';
comment on column ${iol_schema}.ifrs_val_rpt_trade.bill_no is '票据编号bill_no';
comment on column ${iol_schema}.ifrs_val_rpt_trade.bill_sub_intrv_id is '子票据区间编号';
comment on column ${iol_schema}.ifrs_val_rpt_trade.recvbl_uncol_acru_int is '应收未收应计利息';
comment on column ${iol_schema}.ifrs_val_rpt_trade.recvbl_uncol_int is '应收未收利息';
comment on column ${iol_schema}.ifrs_val_rpt_trade.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifrs_val_rpt_trade.etl_timestamp is 'ETL处理时间戳';
