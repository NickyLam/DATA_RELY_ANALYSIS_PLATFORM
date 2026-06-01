/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_ic_solvency_indicator
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_ic_solvency_indicator
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_ic_solvency_indicator purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_ic_solvency_indicator(
    seq number(20,0) -- 记录唯一标识
    ,ctime date -- 记录创建时间
    ,mtime date -- 记录修改时间
    ,rtime date -- 记录同步时间
    ,announcement_date date -- 公告日期
    ,org_id varchar2(60) -- 机构ID
    ,ed date -- 截止日期
    ,statement_type_code varchar2(36) -- 报表类型编码
    ,report_type_code varchar2(36) -- 报告类型编码
    ,statement_year number(4,0) -- 报表年度
    ,chg_seq number(3,0) -- 变动序号
    ,is_latest number(1,0) -- 最新标志
    ,core_smpa number(24,4) -- 核心偿付能力溢额
    ,core_smr number(24,4) -- 核心偿付能力充足率
    ,total_smpa number(24,4) -- 综合偿付能力溢额
    ,total_smr number(24,4) -- 综合偿付能力充足率
    ,insurance_business_income number(24,4) -- 保险业务收入
    ,net_profit number(24,4) -- 净利润
    ,net_asset number(24,4) -- 净资产
    ,approved_asset number(24,4) -- 认可资产
    ,approved_debt number(24,4) -- 认可负债
    ,actual_capital number(24,4) -- 实际资本
    ,actual_first_core_capital number(24,4) -- 实际资本:核心一级资本
    ,actual_second_core_capital number(24,4) -- 实际资本:核心二级资本
    ,actual_first_sub_capital number(24,4) -- 实际资本:附属一级资本
    ,actual_sub_core_capital number(24,4) -- 实际资本:附属二级资本
    ,min_capital number(24,4) -- 最低资本
    ,min_quantify_risk_capital number(24,4) -- 最低资本:量化风险最低资本
    ,min_contral_risk_capital number(24,4) -- 最低资本:控制风险最低资本
    ,min_sub_capital number(24,4) -- 最低资本:附加资本
    ,min_lifeinsur_risk_capital number(24,4) -- 寿险业务保险风险最低资本
    ,min_non_lifeinsur_risk_capital number(24,4) -- 非寿险业务保险风险最低资本
    ,min_market_risk_capital number(24,4) -- 市场风险最低资本
    ,min_credit_risk_capital number(24,4) -- 信用风险最低资本
    ,quantify_risk_disperse_effect number(24,4) -- 量化风险分散效应
    ,spe_contract_loss_absorption number(24,4) -- 特定类别保险合同损失吸收效应
    ,latest_risk_rating varchar2(36) -- 最近一次风险综合评级类别
    ,latest_risk_rating_time varchar2(180) -- 最近一次风险综合评级对应时间
    ,net_cash_flow number(24,4) -- 净现金流
    ,net_cash_flow_1y number(24,4) -- 净现金流-报告日后第1年
    ,net_cash_flow_2y number(24,4) -- 净现金流-报告日后第2年
    ,net_cash_flow_3y number(24,4) -- 净现金流-报告日后第3年
    ,total_current_ratio_within_3m number(24,4) -- 综合流动比率-3个月内
    ,total_current_ratio_within_1y number(24,4) -- 综合流动比率-1年内
    ,total_current_ratio_over_1y number(24,4) -- 综合流动比率-1年以上
    ,total_current_ratio_1y_to_3y number(24,4) -- 综合流动比率-1-3年内
    ,total_current_ratio_3y_to_5y number(24,4) -- 综合流动比率-3-5年内
    ,total_current_ratio_over_5y number(24,4) -- 综合流动比率-5年以上
    ,lcr_corp_stress_scenario1 number(24,4) -- 流动性覆盖率-公司整体-压力情景1
    ,lcr_corp_stress_scenario2 number(24,4) -- 流动性覆盖率-公司整体-压力情景2
    ,lcr_account_stress_scenario1 number(24,4) -- 流动性覆盖率-独立账户-压力情景1
    ,lcr_account_stress_scenario2 number(24,4) -- 流动性覆盖率-独立账户-压力情景2
    ,currency_code varchar2(36) -- 币种名称编码
    ,isvalid number(1,0) -- 是否有效
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
grant select on ${iol_schema}.uxds_ic_solvency_indicator to ${iml_schema};
grant select on ${iol_schema}.uxds_ic_solvency_indicator to ${icl_schema};
grant select on ${iol_schema}.uxds_ic_solvency_indicator to ${idl_schema};
grant select on ${iol_schema}.uxds_ic_solvency_indicator to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_ic_solvency_indicator is '';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.ctime is '记录创建时间';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.mtime is '记录修改时间';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.rtime is '记录同步时间';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.announcement_date is '公告日期';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.org_id is '机构ID';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.ed is '截止日期';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.statement_type_code is '报表类型编码';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.report_type_code is '报告类型编码';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.statement_year is '报表年度';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.chg_seq is '变动序号';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.is_latest is '最新标志';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.core_smpa is '核心偿付能力溢额';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.core_smr is '核心偿付能力充足率';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.total_smpa is '综合偿付能力溢额';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.total_smr is '综合偿付能力充足率';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.insurance_business_income is '保险业务收入';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.net_profit is '净利润';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.net_asset is '净资产';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.approved_asset is '认可资产';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.approved_debt is '认可负债';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.actual_capital is '实际资本';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.actual_first_core_capital is '实际资本:核心一级资本';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.actual_second_core_capital is '实际资本:核心二级资本';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.actual_first_sub_capital is '实际资本:附属一级资本';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.actual_sub_core_capital is '实际资本:附属二级资本';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.min_capital is '最低资本';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.min_quantify_risk_capital is '最低资本:量化风险最低资本';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.min_contral_risk_capital is '最低资本:控制风险最低资本';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.min_sub_capital is '最低资本:附加资本';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.min_lifeinsur_risk_capital is '寿险业务保险风险最低资本';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.min_non_lifeinsur_risk_capital is '非寿险业务保险风险最低资本';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.min_market_risk_capital is '市场风险最低资本';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.min_credit_risk_capital is '信用风险最低资本';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.quantify_risk_disperse_effect is '量化风险分散效应';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.spe_contract_loss_absorption is '特定类别保险合同损失吸收效应';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.latest_risk_rating is '最近一次风险综合评级类别';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.latest_risk_rating_time is '最近一次风险综合评级对应时间';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.net_cash_flow is '净现金流';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.net_cash_flow_1y is '净现金流-报告日后第1年';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.net_cash_flow_2y is '净现金流-报告日后第2年';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.net_cash_flow_3y is '净现金流-报告日后第3年';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.total_current_ratio_within_3m is '综合流动比率-3个月内';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.total_current_ratio_within_1y is '综合流动比率-1年内';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.total_current_ratio_over_1y is '综合流动比率-1年以上';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.total_current_ratio_1y_to_3y is '综合流动比率-1-3年内';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.total_current_ratio_3y_to_5y is '综合流动比率-3-5年内';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.total_current_ratio_over_5y is '综合流动比率-5年以上';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.lcr_corp_stress_scenario1 is '流动性覆盖率-公司整体-压力情景1';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.lcr_corp_stress_scenario2 is '流动性覆盖率-公司整体-压力情景2';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.lcr_account_stress_scenario1 is '流动性覆盖率-独立账户-压力情景1';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.lcr_account_stress_scenario2 is '流动性覆盖率-独立账户-压力情景2';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.currency_code is '币种名称编码';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_ic_solvency_indicator.etl_timestamp is 'ETL处理时间戳';
