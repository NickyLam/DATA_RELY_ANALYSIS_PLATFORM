/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_ibank_bond_invest
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_ibank_bond_invest
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_ibank_bond_invest purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ibank_bond_invest(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,ext_secu_acct_id varchar2(60) -- 外部证券账户编号
    ,intnal_secu_acct_id varchar2(60) -- 内部证券账户编号
    ,fin_instm_id varchar2(100) -- 金融工具编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,market_type_id varchar2(60) -- 市场类型编号
    ,bus_id varchar2(60) -- 业务编号
    ,comb_tran_num varchar2(60) -- 组合交易号
    ,obj_id varchar2(60) -- 对象编号
    ,crdt_fin_instm_id varchar2(60) -- 授信金融工具编号
    ,asset_uniq_idf_id varchar2(100) -- 资产唯一标识编号
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,asset_type_name varchar2(250) -- 资产类型名称
    ,acct_name varchar2(500) -- 账户名称
    ,bond_name varchar2(90) -- 债券名称
    ,convbl_bond_flg varchar2(10) -- 可转债标志
    ,sub_debt_flg varchar2(10) -- 次级债标志
    ,abs_flg varchar2(10) -- ABS标志
    ,subj_id varchar2(60) -- 科目编号
    ,int_subj_id varchar2(100) -- 利息科目编号
    ,recvbl_uncol_int_subj_id varchar2(100) -- 应收未收利息科目编号
    ,int_adj_subj_id varchar2(100) -- 利息调整科目编号
    ,tran_market_id varchar2(60) -- 交易市场编号
    ,exchg_acct_id varchar2(60) -- 交易所账户编号
    ,issuer_cust_id varchar2(60) -- 发行人客户编号
    ,issuer_id varchar2(60) -- 发行人编号
    ,issuer_name varchar2(375) -- 发行人名称
    ,guartor_name varchar2(750) -- 担保人名称
    ,payoff_level_cd varchar2(10) -- 清偿等级代码
    ,issue_dt date -- 发行日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,tenor_cd varchar2(10) -- 期限代码
    ,base_rat_id varchar2(100) -- 基准利率编号
    ,base_rat_asset_type_id varchar2(60) -- 基准利率资产类型编号
    ,base_rat_market_type_id varchar2(60) -- 基准利率市场类型编号
    ,base_rat number(30,8) -- 基准利率
    ,int_accr_base_cd varchar2(30) -- 计息基准代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,issue_way_cd varchar2(10) -- 发行方式代码
    ,ex_type_cd varchar2(10) -- 行权类型代码
    ,fir_ex_dt date -- 首个行权日期
    ,fir_ex_price number(30,2) -- 首个行权价格
    ,fir_compst_int_rat number(18,8) -- 首个补偿利率
    ,cty_cd varchar2(10) -- 国家代码
    ,curr_cd varchar2(10) -- 币种代码
    ,fac_val_amt number(38,8) -- 票面金额
    ,fac_val_int_rat number(18,8) -- 票面利率
    ,pay_int_ped_cd varchar2(10) -- 付息周期代码
    ,src_pay_int_ped_cd varchar2(10) -- 源付息周期代码
    ,int_accr_ped_cd varchar2(10) -- 计息周期代码
    ,reset_ped_cd varchar2(10) -- 重置周期代码
    ,hold_pos number(30,8) -- 持有仓位
    ,hold_fac_val number(30,8) -- 持有面值
    ,pric_bal number(30,8) -- 本金余额
    ,currt_bal number(30,8) -- 当期余额
    ,acru_int number(30,8) -- 应计利息
    ,int_recvbl number(30,8) -- 应收利息
    ,recvbl_uncol_pric number(30,8) -- 应收未收本金
    ,recvbl_uncol_int number(30,8) -- 应收未收利息
    ,int_adj_amt number(30,8) -- 利息调整金额
    ,evha_val_chag number(30,8) -- 公允价值变动
    ,fair_val_pl number(30,8) -- 公允价值损益
    ,actl_int_rat number(18,8) -- 实际利率
    ,last_update_dt date -- 上次更新日期
    ,cap_type_cd varchar2(10) -- 资金类型代码
    ,asset_four_cls_cd varchar2(10) -- 资产四分类代码
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,cbond_full_price_evltion number(30,8) -- 中债全价估值
    ,cbond_net_price_evltion number(30,8) -- 中债净价估值
    ,estim_coret_duran number(30,8) -- 估价修正久期
    ,bp_val number(30,8) -- 基点价值
    ,estim_cvty number(30,8) -- 估价凸性
    ,estim_yld_rat number(30,8) -- 估价收益率
    ,csecu_full_price_evltion number(30,8) -- 中证全价估值
    ,csecu_net_price_evltion number(30,8) -- 中证净价估值
    ,csecu_coret_duran number(30,8) -- 中证修正久期
    ,csecu_bp_val number(30,8) -- 中证基点价值
    ,csecu_estim_cvty number(30,8) -- 中证估价凸性
    ,book_bal number(30,8) -- 账面余额
    ,extra_dimen_cd varchar2(10) -- 额外维度代码
    ,stl_dt date -- 结算日期
    ,ovdue_status varchar2(450) -- 逾期状态
    ,ovdue_flg varchar2(10) -- 逾期标志
    ,pric_ovdue_dt date -- 本金逾期日期
    ,pric_ovdue_days number(10) -- 本金逾期天数
    ,int_ovdue_dt date -- 利息逾期日期
    ,int_ovdue_days number(10) -- 利息逾期天数
    ,uder_asset_type_id varchar2(250) -- 底层资产类型编号
    ,final_dir_type_descb varchar2(450) -- 最终投向类型描述
    ,final_dir_indus_gen varchar2(450) -- 最终投向行业大类
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_ibank_bond_invest to ${idl_schema};
grant select on ${icl_schema}.cmm_ibank_bond_invest to ${iel_schema};
grant select on ${icl_schema}.cmm_ibank_bond_invest to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_ibank_bond_invest is '同业债券投资';
comment on column ${icl_schema}.cmm_ibank_bond_invest.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_ibank_bond_invest.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.ext_secu_acct_id is '外部证券账户编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.intnal_secu_acct_id is '内部证券账户编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.fin_instm_id is '金融工具编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.asset_type_id is '资产类型编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.market_type_id is '市场类型编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.comb_tran_num is '组合交易号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.obj_id is '对象编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.crdt_fin_instm_id is '授信金融工具编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.asset_uniq_idf_id is '资产唯一标识编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.prod_type_cd is '产品类型代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.asset_type_name is '资产类型名称';
comment on column ${icl_schema}.cmm_ibank_bond_invest.acct_name is '账户名称';
comment on column ${icl_schema}.cmm_ibank_bond_invest.bond_name is '债券名称';
comment on column ${icl_schema}.cmm_ibank_bond_invest.convbl_bond_flg is '可转债标志';
comment on column ${icl_schema}.cmm_ibank_bond_invest.sub_debt_flg is '次级债标志';
comment on column ${icl_schema}.cmm_ibank_bond_invest.abs_flg is 'ABS标志';
comment on column ${icl_schema}.cmm_ibank_bond_invest.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.int_subj_id is '利息科目编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.recvbl_uncol_int_subj_id is '应收未收利息科目编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.int_adj_subj_id is '利息调整科目编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.tran_market_id is '交易市场编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.exchg_acct_id is '交易所账户编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.issuer_cust_id is '发行人客户编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.issuer_id is '发行人编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.issuer_name is '发行人名称';
comment on column ${icl_schema}.cmm_ibank_bond_invest.guartor_name is '担保人名称';
comment on column ${icl_schema}.cmm_ibank_bond_invest.payoff_level_cd is '清偿等级代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.issue_dt is '发行日期';
comment on column ${icl_schema}.cmm_ibank_bond_invest.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_ibank_bond_invest.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_ibank_bond_invest.tenor_cd is '期限代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.base_rat_id is '基准利率编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.base_rat_asset_type_id is '基准利率资产类型编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.base_rat_market_type_id is '基准利率市场类型编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.base_rat is '基准利率';
comment on column ${icl_schema}.cmm_ibank_bond_invest.int_accr_base_cd is '计息基准代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.issue_way_cd is '发行方式代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.ex_type_cd is '行权类型代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.fir_ex_dt is '首个行权日期';
comment on column ${icl_schema}.cmm_ibank_bond_invest.fir_ex_price is '首个行权价格';
comment on column ${icl_schema}.cmm_ibank_bond_invest.fir_compst_int_rat is '首个补偿利率';
comment on column ${icl_schema}.cmm_ibank_bond_invest.cty_cd is '国家代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.fac_val_amt is '票面金额';
comment on column ${icl_schema}.cmm_ibank_bond_invest.fac_val_int_rat is '票面利率';
comment on column ${icl_schema}.cmm_ibank_bond_invest.pay_int_ped_cd is '付息周期代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.src_pay_int_ped_cd is '源付息周期代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.int_accr_ped_cd is '计息周期代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.reset_ped_cd is '重置周期代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.hold_pos is '持有仓位';
comment on column ${icl_schema}.cmm_ibank_bond_invest.hold_fac_val is '持有面值';
comment on column ${icl_schema}.cmm_ibank_bond_invest.pric_bal is '本金余额';
comment on column ${icl_schema}.cmm_ibank_bond_invest.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_ibank_bond_invest.acru_int is '应计利息';
comment on column ${icl_schema}.cmm_ibank_bond_invest.int_recvbl is '应收利息';
comment on column ${icl_schema}.cmm_ibank_bond_invest.recvbl_uncol_pric is '应收未收本金';
comment on column ${icl_schema}.cmm_ibank_bond_invest.recvbl_uncol_int is '应收未收利息';
comment on column ${icl_schema}.cmm_ibank_bond_invest.int_adj_amt is '利息调整金额';
comment on column ${icl_schema}.cmm_ibank_bond_invest.evha_val_chag is '公允价值变动';
comment on column ${icl_schema}.cmm_ibank_bond_invest.fair_val_pl is '公允价值损益';
comment on column ${icl_schema}.cmm_ibank_bond_invest.actl_int_rat is '实际利率';
comment on column ${icl_schema}.cmm_ibank_bond_invest.last_update_dt is '上次更新日期';
comment on column ${icl_schema}.cmm_ibank_bond_invest.cap_type_cd is '资金类型代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.asset_four_cls_cd is '资产四分类代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.belong_org_id is '所属机构编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.cbond_full_price_evltion is '中债全价估值';
comment on column ${icl_schema}.cmm_ibank_bond_invest.cbond_net_price_evltion is '中债净价估值';
comment on column ${icl_schema}.cmm_ibank_bond_invest.estim_coret_duran is '估价修正久期';
comment on column ${icl_schema}.cmm_ibank_bond_invest.bp_val is '基点价值';
comment on column ${icl_schema}.cmm_ibank_bond_invest.estim_cvty is '估价凸性';
comment on column ${icl_schema}.cmm_ibank_bond_invest.estim_yld_rat is '估价收益率';
comment on column ${icl_schema}.cmm_ibank_bond_invest.csecu_full_price_evltion is '中证全价估值';
comment on column ${icl_schema}.cmm_ibank_bond_invest.csecu_net_price_evltion is '中证净价估值';
comment on column ${icl_schema}.cmm_ibank_bond_invest.csecu_coret_duran is '中证修正久期';
comment on column ${icl_schema}.cmm_ibank_bond_invest.csecu_bp_val is '中证基点价值';
comment on column ${icl_schema}.cmm_ibank_bond_invest.csecu_estim_cvty is '中证估价凸性';
comment on column ${icl_schema}.cmm_ibank_bond_invest.book_bal is '账面余额';
comment on column ${icl_schema}.cmm_ibank_bond_invest.extra_dimen_cd is '额外维度代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.stl_dt is '结算日期';
comment on column ${icl_schema}.cmm_ibank_bond_invest.ovdue_status is '逾期状态';
comment on column ${icl_schema}.cmm_ibank_bond_invest.ovdue_flg is '逾期标志';
comment on column ${icl_schema}.cmm_ibank_bond_invest.pric_ovdue_dt is '本金逾期日期';
comment on column ${icl_schema}.cmm_ibank_bond_invest.pric_ovdue_days is '本金逾期天数';
comment on column ${icl_schema}.cmm_ibank_bond_invest.int_ovdue_dt is '利息逾期日期';
comment on column ${icl_schema}.cmm_ibank_bond_invest.int_ovdue_days is '利息逾期天数';
comment on column ${icl_schema}.cmm_ibank_bond_invest.uder_asset_type_id is '底层资产类型编号';
comment on column ${icl_schema}.cmm_ibank_bond_invest.final_dir_type_descb is '最终投向类型描述';
comment on column ${icl_schema}.cmm_ibank_bond_invest.final_dir_indus_gen is '最终投向行业大类';
comment on column ${icl_schema}.cmm_ibank_bond_invest.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_ibank_bond_invest.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_ibank_bond_invest.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_ibank_bond_invest.etl_timestamp is 'ETL处理时间戳';
