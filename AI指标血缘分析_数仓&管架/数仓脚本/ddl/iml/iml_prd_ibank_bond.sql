/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_ibank_bond
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_ibank_bond
whenever sqlerror continue none;
drop table ${iml_schema}.prd_ibank_bond purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ibank_bond(
    fin_instm_id varchar2(60) -- 金融工具编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,market_type_id varchar2(60) -- 市场类型编号
    ,lp_id varchar2(60) -- 法人编号
    ,shse_cd varchar2(30) -- 上交所代码
    ,szse_cd varchar2(30) -- 深交所代码
    ,bank_amg_cd varchar2(30) -- 银行间代码
    ,curr_cd varchar2(10) -- 币种代码
    ,cty_or_rg_cd varchar2(10) -- 国家或地区代码
    ,quot_way_cd varchar2(10) -- 报价方式代码
    ,issue_org_id varchar2(100) -- 发行机构编号
    ,bond_intnal_id varchar2(60) -- 债券内部编号
    ,cn_abbr varchar2(150) -- 中文简称
    ,bond_name varchar2(375) -- 债券名称
    ,bond_fname varchar2(750) -- 债券全称
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,prod_cls_name varchar2(150) -- 产品分类名称
    ,bond_cls_name varchar2(150) -- 债券分类名称
    ,acctnt_cls_name varchar2(150) -- 会计分类名称
    ,bond_fac_val number(38,8) -- 债券面值
    ,fac_val_int_rat number(18,8) -- 票面利率
    ,issue_price number(18,6) -- 发行价格
    ,issue_dt date -- 债券发行日期
    ,list_dt date -- 上市日期
    ,value_dt date -- 债券起息日期
    ,exp_dt date -- 债券到期日期
    ,bond_actl_exp_dt date -- 债券实际到期日期
    ,tenor_cd varchar2(10) -- 期限代码
    ,base_rat_id varchar2(100) -- 基准利率编号
    ,base_asset_type_id varchar2(60) -- 基准资产类型编号
    ,base_market_type_id varchar2(60) -- 基准市场类型编号
    ,contn_weight_type_cd varchar2(10) -- 含权类型代码
    ,pric_repay_type_cd varchar2(10) -- 本金偿还类型代码
    ,caption_type_cd varchar2(30) -- 资产化类型代码
    ,payoff_level_cd varchar2(10) -- 清偿等级代码
    ,trust_market_id varchar2(60) -- 托管市场编号
    ,rgst_market_id varchar2(60) -- 登记市场编号
    ,issue_way_cd varchar2(10) -- 发行方式代码
    ,actl_issue_size number(38,8) -- 实际发行规模
    ,issuer_id varchar2(60) -- 发行人编号
    ,issuer_name varchar2(375) -- 发行人名称
    ,guartor_id varchar2(60) -- 担保人编号
    ,guartor_name varchar2(750) -- 担保人名称
    ,int_accr_base_cd varchar2(30) -- 计息基准代码
    ,coupon_type_cd varchar2(10) -- 票息类型代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,pay_int_cnt number(18,0) -- 付息次数
    ,fir_pay_int_dt date -- 首次付息日期
    ,fir_int_accr_start_dt date -- 首次计息开始日期
    ,fir_int_accr_exp_dt date -- 首次计息到期日期
    ,pay_int_ped_cd varchar2(10) -- 付息周期代码
    ,pay_int_adj_rule varchar2(90) -- 付息调整规则
    ,int_accr_ped_cd varchar2(10) -- 计息周期代码
    ,int_accr_adj_rule varchar2(90) -- 计息调整规则
    ,int_rat_adj_ped_cd varchar2(10) -- 利率调整周期代码
    ,int_rat_adj_rule varchar2(90) -- 利率调整规则
    ,set_int_day_drift_ped_cd varchar2(10) -- 定息日偏移周期代码
    ,set_int_day_adj_rule varchar2(90) -- 定息日调整规则
    ,init_int_rat number(18,8) -- 初始利率
    ,init_int_rat_mult number(18,8) -- 初始利率倍数
    ,init_uplmi_int_rat number(18,8) -- 初始上限利率
    ,init_lolmi_int_rat number(18,8) -- 初始下限利率
    ,ex_type_cd varchar2(10) -- 行权类型代码
    ,fir_ex_dt date -- 首个行权日期
    ,fir_exec_price number(18,8) -- 首个执行价格
    ,fir_compst_int_rat number(18,8) -- 首个补偿利率
    ,public_issue_flg varchar2(10) -- 公开发行标志
    ,effect_flg varchar2(10) -- 生效标志
    ,updater_name varchar2(150) -- 更新人名称
    ,checker_name varchar2(150) -- 复核人名称
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,mgmt_mode_cd varchar2(30) -- 管理模式代码
    ,src_pay_int_ped_cd varchar2(10) -- 源付息周期代码
    ,abs_flg varchar2(100) -- 再资产证券化标志
    ,in_level_tot_amt number(30,2) -- 该档次总金额
    ,prod_currt_tot_bal_bilon number(38,8) -- 产品当期总余额(亿)
    ,hold_level_currt_bal_bilon number(38,8) -- 持有档次当期余额(亿)
    ,bond_item_rating_dt date -- 债项评级日期
    ,main_rating_dt date -- 主体评级日期
    ,main_rating_cd varchar2(30) -- 主体评级代码
    ,main_rating_org_name varchar2(750) -- 主体评级机构名称
    ,stc_flg varchar2(10) -- STC标志
    ,prior_level_flg varchar2(10) -- 优先档次标志
    ,estate_bond_name varchar2(150) -- 房地产债券类型名称
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_ibank_bond to ${icl_schema};
grant select on ${iml_schema}.prd_ibank_bond to ${idl_schema};
grant select on ${iml_schema}.prd_ibank_bond to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_ibank_bond is '同业债券';
comment on column ${iml_schema}.prd_ibank_bond.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.prd_ibank_bond.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.prd_ibank_bond.market_type_id is '市场类型编号';
comment on column ${iml_schema}.prd_ibank_bond.lp_id is '法人编号';
comment on column ${iml_schema}.prd_ibank_bond.shse_cd is '上交所代码';
comment on column ${iml_schema}.prd_ibank_bond.szse_cd is '深交所代码';
comment on column ${iml_schema}.prd_ibank_bond.bank_amg_cd is '银行间代码';
comment on column ${iml_schema}.prd_ibank_bond.curr_cd is '币种代码';
comment on column ${iml_schema}.prd_ibank_bond.cty_or_rg_cd is '国家或地区代码';
comment on column ${iml_schema}.prd_ibank_bond.quot_way_cd is '报价方式代码';
comment on column ${iml_schema}.prd_ibank_bond.issue_org_id is '发行机构编号';
comment on column ${iml_schema}.prd_ibank_bond.bond_intnal_id is '债券内部编号';
comment on column ${iml_schema}.prd_ibank_bond.cn_abbr is '中文简称';
comment on column ${iml_schema}.prd_ibank_bond.bond_name is '债券名称';
comment on column ${iml_schema}.prd_ibank_bond.bond_fname is '债券全称';
comment on column ${iml_schema}.prd_ibank_bond.prod_type_cd is '产品类型代码';
comment on column ${iml_schema}.prd_ibank_bond.prod_cls_name is '产品分类名称';
comment on column ${iml_schema}.prd_ibank_bond.bond_cls_name is '债券分类名称';
comment on column ${iml_schema}.prd_ibank_bond.acctnt_cls_name is '会计分类名称';
comment on column ${iml_schema}.prd_ibank_bond.bond_fac_val is '债券面值';
comment on column ${iml_schema}.prd_ibank_bond.fac_val_int_rat is '票面利率';
comment on column ${iml_schema}.prd_ibank_bond.issue_price is '发行价格';
comment on column ${iml_schema}.prd_ibank_bond.issue_dt is '债券发行日期';
comment on column ${iml_schema}.prd_ibank_bond.list_dt is '上市日期';
comment on column ${iml_schema}.prd_ibank_bond.value_dt is '债券起息日期';
comment on column ${iml_schema}.prd_ibank_bond.exp_dt is '债券到期日期';
comment on column ${iml_schema}.prd_ibank_bond.bond_actl_exp_dt is '债券实际到期日期';
comment on column ${iml_schema}.prd_ibank_bond.tenor_cd is '期限代码';
comment on column ${iml_schema}.prd_ibank_bond.base_rat_id is '基准利率编号';
comment on column ${iml_schema}.prd_ibank_bond.base_asset_type_id is '基准资产类型编号';
comment on column ${iml_schema}.prd_ibank_bond.base_market_type_id is '基准市场类型编号';
comment on column ${iml_schema}.prd_ibank_bond.contn_weight_type_cd is '含权类型代码';
comment on column ${iml_schema}.prd_ibank_bond.pric_repay_type_cd is '本金偿还类型代码';
comment on column ${iml_schema}.prd_ibank_bond.caption_type_cd is '资产化类型代码';
comment on column ${iml_schema}.prd_ibank_bond.payoff_level_cd is '清偿等级代码';
comment on column ${iml_schema}.prd_ibank_bond.trust_market_id is '托管市场编号';
comment on column ${iml_schema}.prd_ibank_bond.rgst_market_id is '登记市场编号';
comment on column ${iml_schema}.prd_ibank_bond.issue_way_cd is '发行方式代码';
comment on column ${iml_schema}.prd_ibank_bond.actl_issue_size is '实际发行规模';
comment on column ${iml_schema}.prd_ibank_bond.issuer_id is '发行人编号';
comment on column ${iml_schema}.prd_ibank_bond.issuer_name is '发行人名称';
comment on column ${iml_schema}.prd_ibank_bond.guartor_id is '担保人编号';
comment on column ${iml_schema}.prd_ibank_bond.guartor_name is '担保人名称';
comment on column ${iml_schema}.prd_ibank_bond.int_accr_base_cd is '计息基准代码';
comment on column ${iml_schema}.prd_ibank_bond.coupon_type_cd is '票息类型代码';
comment on column ${iml_schema}.prd_ibank_bond.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.prd_ibank_bond.pay_int_cnt is '付息次数';
comment on column ${iml_schema}.prd_ibank_bond.fir_pay_int_dt is '首次付息日期';
comment on column ${iml_schema}.prd_ibank_bond.fir_int_accr_start_dt is '首次计息开始日期';
comment on column ${iml_schema}.prd_ibank_bond.fir_int_accr_exp_dt is '首次计息到期日期';
comment on column ${iml_schema}.prd_ibank_bond.pay_int_ped_cd is '付息周期代码';
comment on column ${iml_schema}.prd_ibank_bond.pay_int_adj_rule is '付息调整规则';
comment on column ${iml_schema}.prd_ibank_bond.int_accr_ped_cd is '计息周期代码';
comment on column ${iml_schema}.prd_ibank_bond.int_accr_adj_rule is '计息调整规则';
comment on column ${iml_schema}.prd_ibank_bond.int_rat_adj_ped_cd is '利率调整周期代码';
comment on column ${iml_schema}.prd_ibank_bond.int_rat_adj_rule is '利率调整规则';
comment on column ${iml_schema}.prd_ibank_bond.set_int_day_drift_ped_cd is '定息日偏移周期代码';
comment on column ${iml_schema}.prd_ibank_bond.set_int_day_adj_rule is '定息日调整规则';
comment on column ${iml_schema}.prd_ibank_bond.init_int_rat is '初始利率';
comment on column ${iml_schema}.prd_ibank_bond.init_int_rat_mult is '初始利率倍数';
comment on column ${iml_schema}.prd_ibank_bond.init_uplmi_int_rat is '初始上限利率';
comment on column ${iml_schema}.prd_ibank_bond.init_lolmi_int_rat is '初始下限利率';
comment on column ${iml_schema}.prd_ibank_bond.ex_type_cd is '行权类型代码';
comment on column ${iml_schema}.prd_ibank_bond.fir_ex_dt is '首个行权日期';
comment on column ${iml_schema}.prd_ibank_bond.fir_exec_price is '首个执行价格';
comment on column ${iml_schema}.prd_ibank_bond.fir_compst_int_rat is '首个补偿利率';
comment on column ${iml_schema}.prd_ibank_bond.public_issue_flg is '公开发行标志';
comment on column ${iml_schema}.prd_ibank_bond.effect_flg is '生效标志';
comment on column ${iml_schema}.prd_ibank_bond.updater_name is '更新人名称';
comment on column ${iml_schema}.prd_ibank_bond.checker_name is '复核人名称';
comment on column ${iml_schema}.prd_ibank_bond.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.prd_ibank_bond.mgmt_mode_cd is '管理模式代码';
comment on column ${iml_schema}.prd_ibank_bond.src_pay_int_ped_cd is '源付息周期代码';
comment on column ${iml_schema}.prd_ibank_bond.abs_flg is '再资产证券化标志';
comment on column ${iml_schema}.prd_ibank_bond.in_level_tot_amt is '该档次总金额';
comment on column ${iml_schema}.prd_ibank_bond.prod_currt_tot_bal_bilon is '产品当期总余额(亿)';
comment on column ${iml_schema}.prd_ibank_bond.hold_level_currt_bal_bilon is '持有档次当期余额(亿)';
comment on column ${iml_schema}.prd_ibank_bond.bond_item_rating_dt is '债项评级日期';
comment on column ${iml_schema}.prd_ibank_bond.main_rating_dt is '主体评级日期';
comment on column ${iml_schema}.prd_ibank_bond.main_rating_cd is '主体评级代码';
comment on column ${iml_schema}.prd_ibank_bond.main_rating_org_name is '主体评级机构名称';
comment on column ${iml_schema}.prd_ibank_bond.stc_flg is 'STC标志';
comment on column ${iml_schema}.prd_ibank_bond.prior_level_flg is '优先档次标志';
comment on column ${iml_schema}.prd_ibank_bond.estate_bond_name is '房地产债券类型名称';
comment on column ${iml_schema}.prd_ibank_bond.create_dt is '创建日期';
comment on column ${iml_schema}.prd_ibank_bond.update_dt is '更新日期';
comment on column ${iml_schema}.prd_ibank_bond.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_ibank_bond.id_mark is '增删标志';
comment on column ${iml_schema}.prd_ibank_bond.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_ibank_bond.job_cd is '任务编码';
comment on column ${iml_schema}.prd_ibank_bond.etl_timestamp is 'ETL处理时间戳';
