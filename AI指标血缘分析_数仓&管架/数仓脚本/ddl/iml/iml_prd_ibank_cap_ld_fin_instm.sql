/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_ibank_cap_ld_fin_instm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_ibank_cap_ld_fin_instm
whenever sqlerror continue none;
drop table ${iml_schema}.prd_ibank_cap_ld_fin_instm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ibank_cap_ld_fin_instm(
    fin_instm_id varchar2(60) -- 金融工具编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,market_type_id varchar2(60) -- 市场类型编号
    ,lp_id varchar2(60) -- 法人编号
    ,curr_cd varchar2(10) -- 币种代码
    ,cty_cd varchar2(10) -- 国家代码
    ,asset_name varchar2(750) -- 资产名称
    ,asset_type_name varchar2(150) -- 资产类型名称
    ,corp_fac_val number(38,8) -- 单位面值
    ,fac_val_int_rat number(18,8) -- 票面利率
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,src_tenor_cd varchar2(30) -- 源期限代码
    ,tenor number(18,0) -- 期限
    ,tenor_type_cd varchar2(30) -- 期限类型代码
    ,int_accr_base_cd varchar2(20) -- 计息基准代码
    ,base_fin_instm_id varchar2(60) -- 基准金融工具编号
    ,base_asset_type_id varchar2(60) -- 基准资产类型编号
    ,base_market_type_id varchar2(60) -- 基准市场类型编号
    ,issue_mode_cd varchar2(10) -- 发行模式代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,src_pay_int_ped_cd varchar2(10) -- 源付息周期代码
    ,pay_int_ped_freq varchar2(10) -- 付息周期频率
    ,pay_int_ped_corp_cd varchar2(15) -- 期限单位
    ,pay_int_adj_type_cd varchar2(20) -- 付息调整类型代码
    ,src_int_rat_adj_ped_cd varchar2(10) -- 源利率调整周期代码
    ,int_rat_adj_ped_freq varchar2(10) -- 利率调整周期频率
    ,int_rat_adj_ped_corp_cd varchar2(10) -- 利率调整周期单位代码
    ,int_rat_adj_type_cd varchar2(30) -- 利率调整类型代码
    ,issue_org_name varchar2(375) -- 发行公司名称
    ,input_dt date -- 录入日期
    ,cn_abbr varchar2(150) -- 中文简称
    ,del_flg varchar2(10) -- 删除标志
    ,agent_name varchar2(150) -- 经办人名称
    ,checker_name varchar2(150) -- 复核人名称
    ,fir_ped_set_int_dt date -- 首周期定息日期
    ,fir_pay_int_dt date -- 首次付息日期
    ,int_rat_multir number(30) -- 利率乘数
    ,ovdue_int_rat number(18,8) -- 逾期利率
    ,issue_amt number(30,2) -- 发行金额
    ,exp_mode_cd varchar2(10) -- 到期模式代码
    ,edit_num varchar2(60) -- 版本号
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,fst_stl_amt number(38,8) -- 首期结算金额
    ,exp_stl_amt number(38,8) -- 到期结算金额
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,effect_flg varchar2(10) -- 生效标志
    ,acct_id varchar2(60) -- 账户编号
    ,auto_redt_flg varchar2(10) -- 自动转存标志
    ,stup_ped_type_cd varchar2(30) -- 残期类型代码
    ,pay_flg varchar2(10) -- 支付标志
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,cash_dt date -- 兑付日期
    ,pay_int_type_cd varchar2(10) -- 付息类型代码
    ,crdt_cust_id varchar2(60) -- 授信客户编号
    ,guar_way_cd varchar2(10) -- 担保方式代码
    ,guar_name varchar2(750) -- 担保物名称
    ,unexp_draw_int_rat number(18,8) -- 提前支取利率
    ,draw_post_int_rat number(18,8) -- 支取后利率
    ,open_cert_flg varchar2(10) -- 开立证实书标志
    ,auto_calc_int_rat_flg varchar2(10) -- 自动计算利率标志
    ,nmal_int_rat number(18,8) -- 名义利率
    ,vat_rat number(18,8) -- 增值税率
    ,pass_addit_tax_rat number(18,8) -- 通道附加税率
    ,pass_fee_rat number(18,8) -- 通道费率
    ,pass_fee_int_accr_base_cd varchar2(10) -- 通道费计息基准代码
    ,trust_fee_rat number(18,8) -- 托管费率
    ,trust_fee_int_accr_base_cd varchar2(10) -- 托管费计息基准代码
    ,other_fee_rat number(18,8) -- 其他费率
    ,other_fee_int_accr_base_cd varchar2(10) -- 其他费用计息基准代码
    ,nmal_int_rat_int_accr_base_cd varchar2(10) -- 名义利率计息基准代码
    ,int_stl_way_cd varchar2(10) -- 利息结算方式代码
    ,issue_org_id varchar2(60) -- 发行机构编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,cashflow_get_way_cd varchar2(30) -- 现金流获取方式代码
    ,trans_loan_flg varchar2(30) -- 转贷款标志
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
grant select on ${iml_schema}.prd_ibank_cap_ld_fin_instm to ${icl_schema};
grant select on ${iml_schema}.prd_ibank_cap_ld_fin_instm to ${idl_schema};
grant select on ${iml_schema}.prd_ibank_cap_ld_fin_instm to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_ibank_cap_ld_fin_instm is '同业资金借贷金融工具';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.market_type_id is '市场类型编号';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.lp_id is '法人编号';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.curr_cd is '币种代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.cty_cd is '国家代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.asset_name is '资产名称';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.asset_type_name is '资产类型名称';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.corp_fac_val is '单位面值';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.fac_val_int_rat is '票面利率';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.value_dt is '起息日期';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.exp_dt is '到期日期';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.src_tenor_cd is '源期限代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.tenor is '期限';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.int_accr_base_cd is '计息基准代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.base_fin_instm_id is '基准金融工具编号';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.base_asset_type_id is '基准资产类型编号';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.base_market_type_id is '基准市场类型编号';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.issue_mode_cd is '发行模式代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.src_pay_int_ped_cd is '源付息周期代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.pay_int_ped_freq is '付息周期频率';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.pay_int_ped_corp_cd is '期限单位';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.pay_int_adj_type_cd is '付息调整类型代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.src_int_rat_adj_ped_cd is '源利率调整周期代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.int_rat_adj_ped_freq is '利率调整周期频率';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.int_rat_adj_ped_corp_cd is '利率调整周期单位代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.int_rat_adj_type_cd is '利率调整类型代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.issue_org_name is '发行公司名称';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.input_dt is '录入日期';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.cn_abbr is '中文简称';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.del_flg is '删除标志';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.agent_name is '经办人名称';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.checker_name is '复核人名称';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.fir_ped_set_int_dt is '首周期定息日期';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.fir_pay_int_dt is '首次付息日期';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.int_rat_multir is '利率乘数';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.ovdue_int_rat is '逾期利率';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.issue_amt is '发行金额';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.exp_mode_cd is '到期模式代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.edit_num is '版本号';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.effect_dt is '生效日期';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.invalid_dt is '失效日期';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.fst_stl_amt is '首期结算金额';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.exp_stl_amt is '到期结算金额';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.prod_type_cd is '产品类型代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.effect_flg is '生效标志';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.acct_id is '账户编号';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.auto_redt_flg is '自动转存标志';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.stup_ped_type_cd is '残期类型代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.pay_flg is '支付标志';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.cash_dt is '兑付日期';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.pay_int_type_cd is '付息类型代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.crdt_cust_id is '授信客户编号';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.guar_way_cd is '担保方式代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.guar_name is '担保物名称';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.unexp_draw_int_rat is '提前支取利率';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.draw_post_int_rat is '支取后利率';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.open_cert_flg is '开立证实书标志';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.auto_calc_int_rat_flg is '自动计算利率标志';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.nmal_int_rat is '名义利率';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.vat_rat is '增值税率';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.pass_addit_tax_rat is '通道附加税率';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.pass_fee_rat is '通道费率';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.pass_fee_int_accr_base_cd is '通道费计息基准代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.trust_fee_rat is '托管费率';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.trust_fee_int_accr_base_cd is '托管费计息基准代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.other_fee_rat is '其他费率';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.other_fee_int_accr_base_cd is '其他费用计息基准代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.nmal_int_rat_int_accr_base_cd is '名义利率计息基准代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.int_stl_way_cd is '利息结算方式代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.issue_org_id is '发行机构编号';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.cashflow_get_way_cd is '现金流获取方式代码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.trans_loan_flg is '转贷款标志';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.create_dt is '创建日期';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.update_dt is '更新日期';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.id_mark is '增删标志';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.job_cd is '任务编码';
comment on column ${iml_schema}.prd_ibank_cap_ld_fin_instm.etl_timestamp is 'ETL处理时间戳';
