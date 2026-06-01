/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_ibank_non_std_invest
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_ibank_non_std_invest
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_ibank_non_std_invest purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ibank_non_std_invest(
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
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,asset_type_name varchar2(250) -- 资产类型名称
    ,class_crdt_flg varchar2(10) -- 类信贷标志
    ,abs_flg varchar2(10) -- ABS标志
    ,level5_cls_cd varchar2(10) -- 五级分类代码
    ,acct_name varchar2(500) -- 账户名称
    ,subj_id varchar2(60) -- 科目编号
    ,int_subj_id varchar2(100) -- 利息科目编号
    ,recvbl_uncol_int_subj_id varchar2(100) -- 应收未收利息科目编号
    ,int_adj_subj_id varchar2(100) -- 利息调整科目编号
    ,tran_market_id varchar2(60) -- 交易市场编号
    ,exchg_acct_id varchar2(60) -- 交易所账户编号
    ,cntpty_cust_id varchar2(60) -- 交易对手客户编号
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(375) -- 交易对手名称
    ,cntpty_cls_descb varchar2(1000) -- 交易对手分类描述
    ,bank_flg varchar2(10) -- 银行标志
    ,cty_cd varchar2(10) -- 国家代码
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,tenor_cd varchar2(10) -- 期限代码
    ,int_accr_base_cd varchar2(30) -- 计息基准代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,apv_odd_no varchar2(60) -- 审批单号
    ,crdt_fin_instm_id varchar2(60) -- 授信金融工具编号
    ,asset_uniq_idf_id varchar2(100) -- 资产唯一标识编号
    ,curr_cd varchar2(10) -- 币种代码
    ,fac_val_amt number(38,8) -- 票面金额
    ,fac_val_int_rat number(18,8) -- 票面利率
    ,pay_int_ped_cd varchar2(10) -- 付息周期代码
    ,auto_redt_flg varchar2(10) -- 自动转存标志
    ,actl_qtty number(30,8) -- 实际数量
    ,actl_bal number(30,8) -- 实际余额
    ,pric_bal number(30,8) -- 本金余额
    ,currt_bal number(30,8) -- 当期余额
    ,acru_int number(30,8) -- 应计利息
    ,int_recvbl number(30,8) -- 应收利息
    ,recvbl_uncol_pric number(30,8) -- 应收未收本金
    ,recvbl_uncol_int number(30,8) -- 应收未收利息
    ,int_adj_amt number(30,8) -- 利息调整金额
    ,evha_val_chag number(30,8) -- 公允价值变动
    ,nv_prod_flg varchar2(10) -- 净值产品标志
    ,base_rat number(30,8) -- 基准利率
    ,spd number(30,8) -- 利差
    ,base_rat_mult number(30,8) -- 基准利率倍数
    ,td_nv number(30,8) -- 当日净值
    ,book_bal number(30,8) -- 账面余额
    ,curr_bal number(30,8) -- 当前余额
    ,last_update_dt date -- 上次更新日期
    ,cap_type_cd varchar2(10) -- 资金类型代码
    ,asset_four_cls_cd varchar2(10) -- 资产四分类代码
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,uder_dir_indus_categy_cd varchar2(60) -- 底层资产投向行业门类代码
    ,uder_bond_cd varchar2(60) -- 底层债券代码
    ,uder_bond_name varchar2(500) -- 底层债券名称
    ,uder_bond_flg varchar2(10) -- 底层债券标志
    ,uder_asset_type_id varchar2(10) -- 底层资产类型编号
    ,uder_bond_rating_rest_cd varchar2(10) -- 底层债券评级结果代码
    ,uder_actl_finer_name varchar2(750) -- 底层实际融资人名称
    ,uder_post_denom number(30,8) -- 底层持仓面额
    ,uder_actl_finer_cust_id varchar2(60) -- 底层实际融资人客户编号
    ,uder_actl_finer_group varchar2(450) -- 底层实际融资人所属集团
    ,uder_actl_finer_cust_char varchar2(150) -- 底层实际融资人客户性质
    ,uder_coll_way_cd varchar2(60) -- 底层募集方式代码
    ,uder_cbond_estim_full_price number(30,8) -- 底层中债估价全价
    ,uder_cbond_estim_net_price number(30,8) -- 底层中债估价净价
    ,uder_csecu_full_price_evltion number(30,8) -- 底层中证全价估值
    ,uder_csecu_net_price_evltion number(30,8) -- 底层中证净价估值
    ,uder_csecu_coret_duran number(30,8) -- 底层中证修正久期
    ,uder_csecu_bp_val number(30,8) -- 底层中证基点价值
    ,uder_csecu_estim_cvty number(30,8) -- 底层中证估价凸性
    ,uder_estim_coret_duran number(30,8) -- 底层估价修正久期
    ,uder_bp_val number(30,8) -- 底层基点价值
    ,uder_estim_cvty number(30,8) -- 底层估价凸性
    ,final_dir_type_cd varchar2(10) -- 最终投向类型代码
    ,final_dir_indus_gen varchar2(10) -- 最终投向行业_大类
    ,final_dir_indus_middle_class varchar2(90) -- 最终投向行业_中类
    ,final_dir_indus_subclass varchar2(90) -- 最终投向行业_细类
    ,dir_ind_fund_part number(30,8) -- 投向产业基金的部分
    ,dir_debt_eqty_part number(30,8) -- 投向债转股的部分
    ,dir_pe_part number(30,8) -- 投向私募股权投资基金的部分
    ,dir_pam_prod_part number(30,8) -- 投向私募资产管理产品的部分
    ,tran_amt number(38,8) -- 交易金额
    ,extra_dimen_cd varchar2(10) -- 额外维度代码
    ,stl_dt date -- 结算日期
    ,ovdue_status varchar2(450) -- 逾期状态
    ,in_out_tab_flg_cd varchar2(10) -- 表内外标志代码
    ,ovdue_flg varchar2(10) -- 逾期标志
    ,pric_ovdue_flg varchar2(10) -- 本金逾期标志
    ,pric_ovdue_dt date -- 本金逾期日期
    ,pric_ovdue_days number(10) -- 本金逾期天数
    ,int_ovdue_flg varchar2(10) -- 利息逾期标志
    ,int_ovdue_dt date -- 利息逾期日期
    ,int_ovdue_days number(10) -- 利息逾期天数
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
grant select on ${icl_schema}.cmm_ibank_non_std_invest to ${idl_schema};
grant select on ${icl_schema}.cmm_ibank_non_std_invest to ${iel_schema};
grant select on ${icl_schema}.cmm_ibank_non_std_invest to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_ibank_non_std_invest is '同业非标投资';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.ext_secu_acct_id is '外部证券账户编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.intnal_secu_acct_id is '内部证券账户编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.fin_instm_id is '金融工具编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.asset_type_id is '资产类型编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.market_type_id is '市场类型编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.comb_tran_num is '组合交易号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.obj_id is '对象编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.prod_type_cd is '产品类型代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.asset_type_name is '资产类型名称';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.class_crdt_flg is '类信贷标志';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.abs_flg is 'ABS标志';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.level5_cls_cd is '五级分类代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.acct_name is '账户名称';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.int_subj_id is '利息科目编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.recvbl_uncol_int_subj_id is '应收未收利息科目编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.int_adj_subj_id is '利息调整科目编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.tran_market_id is '交易市场编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.exchg_acct_id is '交易所账户编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.cntpty_cust_id is '交易对手客户编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.cntpty_id is '交易对手编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.cntpty_name is '交易对手名称';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.cntpty_cls_descb is '交易对手分类描述';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.bank_flg is '银行标志';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.cty_cd is '国家代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.tenor_cd is '期限代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.int_accr_base_cd is '计息基准代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.apv_odd_no is '审批单号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.crdt_fin_instm_id is '授信金融工具编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.asset_uniq_idf_id is '资产唯一标识编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.fac_val_amt is '票面金额';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.fac_val_int_rat is '票面利率';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.pay_int_ped_cd is '付息周期代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.auto_redt_flg is '自动转存标志';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.actl_qtty is '实际数量';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.actl_bal is '实际余额';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.pric_bal is '本金余额';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.acru_int is '应计利息';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.int_recvbl is '应收利息';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.recvbl_uncol_pric is '应收未收本金';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.recvbl_uncol_int is '应收未收利息';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.int_adj_amt is '利息调整金额';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.evha_val_chag is '公允价值变动';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.nv_prod_flg is '净值产品标志';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.base_rat is '基准利率';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.spd is '利差';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.base_rat_mult is '基准利率倍数';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.td_nv is '当日净值';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.book_bal is '账面余额';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.curr_bal is '当前余额';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.last_update_dt is '上次更新日期';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.cap_type_cd is '资金类型代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.asset_four_cls_cd is '资产四分类代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.belong_org_id is '所属机构编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_dir_indus_categy_cd is '底层资产投向行业门类代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_bond_cd is '底层债券代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_bond_name is '底层债券名称';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_bond_flg is '底层债券标志';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_asset_type_id is '底层资产类型编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_bond_rating_rest_cd is '底层债券评级结果代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_actl_finer_name is '底层实际融资人名称';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_post_denom is '底层持仓面额';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_actl_finer_cust_id is '底层实际融资人客户编号';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_actl_finer_group is '底层实际融资人所属集团';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_actl_finer_cust_char is '底层实际融资人客户性质';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_coll_way_cd is '底层募集方式代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_cbond_estim_full_price is '底层中债估价全价';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_cbond_estim_net_price is '底层中债估价净价';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_csecu_full_price_evltion is '底层中证全价估值';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_csecu_net_price_evltion is '底层中证净价估值';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_csecu_coret_duran is '底层中证修正久期';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_csecu_bp_val is '底层中证基点价值';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_csecu_estim_cvty is '底层中证估价凸性';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_estim_coret_duran is '底层估价修正久期';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_bp_val is '底层基点价值';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.uder_estim_cvty is '底层估价凸性';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.final_dir_type_cd is '最终投向类型代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.final_dir_indus_gen is '最终投向行业_大类';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.final_dir_indus_middle_class is '最终投向行业_中类';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.final_dir_indus_subclass is '最终投向行业_细类';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.dir_ind_fund_part is '投向产业基金的部分';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.dir_debt_eqty_part is '投向债转股的部分';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.dir_pe_part is '投向私募股权投资基金的部分';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.dir_pam_prod_part is '投向私募资产管理产品的部分';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.tran_amt is '交易金额';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.extra_dimen_cd is '额外维度代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.stl_dt is '结算日期';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.ovdue_status is '逾期状态';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.in_out_tab_flg_cd is '表内外标志代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.ovdue_flg is '逾期标志';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.pric_ovdue_flg is '本金逾期标志';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.pric_ovdue_dt is '本金逾期日期';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.pric_ovdue_days is '本金逾期天数';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.int_ovdue_flg is '利息逾期标志';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.int_ovdue_dt is '利息逾期日期';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.int_ovdue_days is '利息逾期天数';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_ibank_non_std_invest.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_ibank_non_std_invest.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_ibank_non_std_invest.etl_timestamp is 'ETL处理时间戳';
