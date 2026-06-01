/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hkgsdbalancesheet
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hkgsdbalancesheet
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hkgsdbalancesheet purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hkgsdbalancesheet(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(15) -- 公司id
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 截至日期
    ,report_type number(9,0) -- 报告类型代码
    ,statement_type number(9,0) -- 报表类型代码
    ,crncy_code varchar2(15) -- 货币代码
    ,tot_cur_assets number(20,4) -- 流动资产合计
    ,cash_cash_equ number(20,4) -- 现金及现金等价物
    ,tradable_fin_assets number(20,4) -- 短期投资(交易性金融资产)
    ,oth_short_inv number(20,4) -- 其他短期投资
    ,ar_total number(20,4) -- 应收款项合计
    ,stm_bs number(20,4) -- 应收账款及票据
    ,oth_rcv number(20,4) -- 其他应收款
    ,inventories number(20,4) -- 存货
    ,oth_cur_assets number(20,4) -- 其他流动资产合计
    ,non_cur_assets number(20,4) -- 非流动资产合计
    ,net_oth_fix_assets number(20,4) -- 固定资产净值
    ,equity_inv number(20,4) -- 权益性投资
    ,held_to_mty_invest number(20,4) -- 持有至到期投资
    ,avail_for_sale_inv number(20,4) -- 可供出售投资
    ,oth_long_inv number(20,4) -- 其他长期投资
    ,goodwill_intang_assets number(20,4) -- 商誉及无形资产
    ,goodwill number(20,4) -- 其中:商誉
    ,right_land_usage number(20,4) -- [内部]租赁土地
    ,oth_noncurrent_assets number(20,4) -- 其他非流动资产合计
    ,tot_assets number(20,4) -- 总资产
    ,cur_liab number(20,4) -- 流动负债合计
    ,ap_note number(20,4) -- 应付账款及票据
    ,taxes_surcharges_payable number(20,4) -- 应交税金
    ,tradable_fin_liab number(20,4) -- 交易性金融负债
    ,stloans_ltloans_curdue number(20,4) -- 短期借贷及长期借贷当期到期部分
    ,oth_cur_liab number(20,4) -- 其他流动负债
    ,non_cur_liab number(20,4) -- 非流动负债合计
    ,lt_borrow number(20,4) -- 长期借贷
    ,oth_non_cur_liab number(20,4) -- 其他非流动负债合计
    ,total_liabilities number(20,4) -- 总负债
    ,prfshare number(20,4) -- 优先股
    ,comshare number(20,4) -- 普通股股本(股本)
    ,reserve number(20,4) -- 储备
    ,premium_stock number(20,4) -- 股本溢价
    ,retained_earn number(20,4) -- 留存收益
    ,oth_reserve number(20,4) -- 其他储备
    ,treasuryshare number(20,4) -- 库存股
    ,oth_com_income number(20,4) -- 其他综合性收益
    ,tot_com_equity number(20,4) -- 普通股权益总额
    ,parsh_int number(20,4) -- 股东权益
    ,minority_int number(20,4) -- 少数股东权益
    ,tot_shrhldr_eqy number(20,4) -- 股东权益合计
    ,tot_liab_eqy number(20,4) -- 总负债及总权益
    ,cash_inter_bal number(20,4) -- 现金及同业结存
    ,due_bank number(20,4) -- 存放同业
    ,net_loans number(20,4) -- 客户贷款及垫款净额
    ,deposit_bank number(20,4) -- 银行同业存款
    ,funds_lent number(20,4) -- 拆出资金
    ,mort_sec number(20,4) -- 抵押担保证券
    ,sale_loan number(20,4) -- 可供出售贷款
    ,tot_deposits number(20,4) -- 总存款
    ,loans_oth_banks number(20,4) -- 拆入资金
    ,secured_fin number(20,4) -- 抵押担保融资
    ,reinsur_pay number(20,4) -- 应付再保
    ,reinsur_rece number(20,4) -- 应收再保
    ,insur_pre_rec number(20,4) -- 应收保费
    ,defer_cost number(20,4) -- 递延保单获得成本
    ,insur_liab number(20,4) -- 保险合同负债
    ,invest_liab number(20,4) -- 投资合同负债
    ,oth_inv number(20,4) -- 其他投资
    ,oth_assets number(20,4) -- 其他资产
    ,oth_liab number(20,4) -- 其他负债
    ,s_info_comptype varchar2(2) -- 报告期公司类型代码
    ,s_memo varchar2(3000) -- 备注
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
grant select on ${iol_schema}.wind_hkgsdbalancesheet to ${iml_schema};
grant select on ${iol_schema}.wind_hkgsdbalancesheet to ${icl_schema};
grant select on ${iol_schema}.wind_hkgsdbalancesheet to ${idl_schema};
grant select on ${iol_schema}.wind_hkgsdbalancesheet to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hkgsdbalancesheet is '香港股票资产负债表(GSD)';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.object_id is '对象ID';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.report_period is '截至日期';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.report_type is '报告类型代码';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.tot_cur_assets is '流动资产合计';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.cash_cash_equ is '现金及现金等价物';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.tradable_fin_assets is '短期投资(交易性金融资产)';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.oth_short_inv is '其他短期投资';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.ar_total is '应收款项合计';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.stm_bs is '应收账款及票据';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.oth_rcv is '其他应收款';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.inventories is '存货';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.oth_cur_assets is '其他流动资产合计';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.non_cur_assets is '非流动资产合计';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.net_oth_fix_assets is '固定资产净值';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.equity_inv is '权益性投资';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.held_to_mty_invest is '持有至到期投资';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.avail_for_sale_inv is '可供出售投资';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.oth_long_inv is '其他长期投资';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.goodwill_intang_assets is '商誉及无形资产';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.goodwill is '其中:商誉';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.right_land_usage is '[内部]租赁土地';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.oth_noncurrent_assets is '其他非流动资产合计';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.tot_assets is '总资产';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.cur_liab is '流动负债合计';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.ap_note is '应付账款及票据';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.taxes_surcharges_payable is '应交税金';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.tradable_fin_liab is '交易性金融负债';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.stloans_ltloans_curdue is '短期借贷及长期借贷当期到期部分';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.oth_cur_liab is '其他流动负债';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.non_cur_liab is '非流动负债合计';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.lt_borrow is '长期借贷';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.oth_non_cur_liab is '其他非流动负债合计';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.total_liabilities is '总负债';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.prfshare is '优先股';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.comshare is '普通股股本(股本)';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.reserve is '储备';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.premium_stock is '股本溢价';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.retained_earn is '留存收益';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.oth_reserve is '其他储备';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.treasuryshare is '库存股';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.oth_com_income is '其他综合性收益';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.tot_com_equity is '普通股权益总额';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.parsh_int is '股东权益';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.minority_int is '少数股东权益';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.tot_shrhldr_eqy is '股东权益合计';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.tot_liab_eqy is '总负债及总权益';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.cash_inter_bal is '现金及同业结存';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.due_bank is '存放同业';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.net_loans is '客户贷款及垫款净额';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.deposit_bank is '银行同业存款';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.funds_lent is '拆出资金';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.mort_sec is '抵押担保证券';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.sale_loan is '可供出售贷款';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.tot_deposits is '总存款';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.loans_oth_banks is '拆入资金';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.secured_fin is '抵押担保融资';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.reinsur_pay is '应付再保';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.reinsur_rece is '应收再保';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.insur_pre_rec is '应收保费';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.defer_cost is '递延保单获得成本';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.insur_liab is '保险合同负债';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.invest_liab is '投资合同负债';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.oth_inv is '其他投资';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.oth_assets is '其他资产';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.oth_liab is '其他负债';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.s_info_comptype is '报告期公司类型代码';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.s_memo is '备注';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_hkgsdbalancesheet.etl_timestamp is 'ETL处理时间戳';
