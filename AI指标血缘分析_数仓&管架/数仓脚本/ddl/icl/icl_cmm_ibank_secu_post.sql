/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_ibank_secu_post
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_ibank_secu_post
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_ibank_secu_post purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ibank_secu_post(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,ext_secu_acct_id varchar2(60) -- 外部证券账户编号
    ,intnal_secu_acct_id varchar2(60) -- 内部证券账户编号
    ,intnal_secu_acct_status_cd varchar2(10) -- 内部证券账户状态代码
    ,intnal_secu_acct_acctnt_cls_cd varchar2(60) -- 内部证券账户会计分类代码
    ,intnal_secu_acct_acctnt_cls_name varchar2(100) -- 内部证券账户会计分类名称
    ,fin_instm_id varchar2(100) -- 金融工具编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,market_type_id varchar2(60) -- 市场类型编号
    ,bus_id varchar2(60) -- 业务编号
    ,comb_tran_num varchar2(60) -- 组合交易号
    ,cntpty_acct_id varchar2(200) -- 交易对手账号
    ,obj_id varchar2(60) -- 对象编号
    ,apv_form_num varchar2(60) -- 审批单号
    ,crdt_fin_instm_id varchar2(60) -- 授信金融工具编号
    ,asset_uniq_idf_id varchar2(100) -- 资产唯一标识编号
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,asset_type_name varchar2(250) -- 资产类型名称
    ,level5_cls_cd varchar2(10) -- 五级分类代码
    ,subj_id varchar2(60) -- 科目编号
    ,int_subj_id varchar2(100) -- 利息科目编号
    ,recvbl_uncol_int_subj_id varchar2(100) -- 应收未收利息科目编号
    ,int_adj_subj_id varchar2(100) -- 利息调整科目编号
    ,evha_val_chag_subj_id varchar2(100) -- 公允价值变动科目编号
    ,acru_int_inco_subj_id varchar2(100) -- 应计利息收入科目编号
    ,amort_int_income_subj_id varchar2(100) -- 摊销利息收入科目编号
    ,evha_val_chag_pl_subj_id varchar2(100) -- 公允价值变动损益科目编号
    ,spd_pl_subj_id varchar2(100) -- 价差损益科目编号
    ,acru_int_inco_vat_subj_id varchar2(100) -- 应计利息收入增值税科目编号
    ,amort_int_income_vat_subj_id varchar2(100) -- 摊销利息收入增值税科目编号
    ,spd_pl_vat_subj_id varchar2(100) -- 价差损益增值税科目编号
    ,acct_name varchar2(500) -- 账户名称
    ,tran_market_id varchar2(60) -- 交易市场编号
    ,exchg_acct_id varchar2(60) -- 交易所账户编号
    ,issuer_id varchar2(60) -- 发行人编号
    ,issuer_name varchar2(375) -- 发行人名称
    ,stl_site_id varchar2(60) -- 结算场所编号
    ,stl_site_name varchar2(250) -- 结算场所名称
    ,tran_num varchar2(60) -- 交易号
    ,extra_dimen_cd varchar2(10) -- 额外维度代码
    ,curr_cd varchar2(10) -- 币种代码
    ,bal_type_cd varchar2(30) -- 余额类型代码
    ,actl_qtty number(30,8) -- 实际数量
    ,actl_bal number(30,8) -- 实际余额
    ,currt_bal number(30,8) -- 当期余额
    ,net_price_cost number(30,8) -- 净价成本
    ,currt_acru_int number(30,8) -- 当期应计利息
    ,acru_int number(30,8) -- 应计利息
    ,int_recvbl number(30,8) -- 应收利息
    ,int_cost number(30,8) -- 利息成本
    ,evha_val_chag number(30,8) -- 公允价值变动
    ,recvbl_uncol_bal number(30,8) -- 应收未收余额
    ,recvbl_uncol_net_price_cost number(30,8) -- 应收未收净价成本
    ,recvbl_uncol_acru_int number(30,8) -- 应收未收应计利息
    ,int_adj_amt number(30,8) -- 利息调整金额
    ,ref_int_rat number(30,8) -- 参考利率
    ,actl_int_rat number(18,8) -- 实际利率
    ,fac_val_int_rat number(18,8) -- 票面利率
    ,invest_yld_rat number(38,15) -- 投资收益率
    ,open_yld_rat number(18,8) -- 开仓收益率
    ,td_nv number(30,8) -- 当日净值
    ,amort_dt date -- 摊销日期
    ,fir_stl_dt date -- 首次结算日期
    ,tran_dt date -- 交易日期
    ,stl_dt date -- 结算日期
    ,open_dt date -- 开仓日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,last_update_dt date -- 上次更新日期
    ,cap_type_cd varchar2(10) -- 资金类型代码
    ,asset_four_cls_cd varchar2(10) -- 资产四分类代码
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,tran_amt number(38,8) -- 交易金额
    ,evha_val_chag_pl number(30,8) -- 公允价值变动损益
    ,spd_pl number(30,8) -- 价差损益
    ,int_income number(30,8) -- 利息收入
    ,acru_int_inco number(30,8) -- 应计利息收入
    ,amort_int_inco number(30,8) -- 摊销利息收入
    ,acru_int_inco_should_tax_flg number(30,8) -- 应计利息收入应税标志
    ,amort_int_income_should_tax_flg number(30,8) -- 摊销利息收入应税标志
    ,spd_pl_should_tax_flg number(30,8) -- 价差损益应税标志
    ,acru_int_inco_tax_rat number(30,8) -- 应计利息收入税率
    ,amort_int_income_tax_rat number(30,8) -- 摊销利息收入税率
    ,spd_pl_tax_rat number(30,8) -- 价差损益税率
    ,acru_int_inco_tax_lmt number(30,8) -- 应计利息收入税额
    ,amort_int_income_tax_lmt number(30,8) -- 摊销利息收入税额
    ,spd_pl_tax_lmt number(30,8) -- 价差损益税额
    ,ftp_prop_cate varchar2(150) -- FTP方案类别
    ,ftp_spread number(16,2) -- FTP点差
    ,ncds_issue_org_id varchar2(60) -- 同业存单发行机构编号
    ,ncds_issue_org_name varchar2(1000) -- 同业存单发行机构名称
    ,sell_org_name_comb varchar2(4000) -- 销售机构名称组合
    ,sell_org_pct_comnt varchar2(4000) -- 销售机构占比说明
    ,belong_org_name_comb varchar2(4000) -- 归属机构名称组合
    ,belong_org_pct_comnt varchar2(4000) -- 归属机构占比说明
    ,ovdue_status varchar2(450) -- 逾期状态
    ,ovdue_flg varchar2(10) -- 逾期标志
    ,pric_ovdue_dt date -- 本金逾期日期
    ,pric_ovdue_days number(10) -- 本金逾期天数
    ,int_ovdue_dt date -- 利息逾期日期
    ,int_ovdue_days number(10) -- 利息逾期天数
    ,pric_ovdue_amt	number(32,8) -- 本金逾期金额
    ,int_ovdue_amt	number(32,8) -- 利息逾期金额
    ,is_th_ssn_redem varchar2(15) -- 是否当季赎回
    ,curr_issue_build_up_pos_dt date -- 本期建仓日期
    ,expe_redem_dt date -- 预期赎回日期
    ,tran_hold_idf varchar2(15) -- 交易持有标识
    ,apot_tenor_dep_flg varchar2(10) -- 约期存款标志
    ,apot_tenor_start_dt date -- 约期开始日期
    ,apot_tenor_end_dt date -- 约期结束日期
    ,apot_tenor_amt number(30,8) -- 约期金额
    ,tran_cost_accti_method_cd varchar2(30) -- 交易成本核算方法代码
    ,cross_bor_depo_takof_inter_flg varchar2(10) -- 跨境同存标志
    ,cross_bor_depo_takof_inter_sign_value_dt date -- 跨境同存签约起息日期
    ,cross_bor_depo_takof_inter_sign_exp_dt date -- 跨境同存签约到期日期
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
grant select on ${icl_schema}.cmm_ibank_secu_post to ${idl_schema};
grant select on ${icl_schema}.cmm_ibank_secu_post to ${iel_schema};
grant select on ${icl_schema}.cmm_ibank_secu_post to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_ibank_secu_post is '同业证券持仓';
comment on column ${icl_schema}.cmm_ibank_secu_post.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.ext_secu_acct_id is '外部证券账户编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.intnal_secu_acct_id is '内部证券账户编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.intnal_secu_acct_status_cd is '内部证券账户状态代码';
comment on column ${icl_schema}.cmm_ibank_secu_post.intnal_secu_acct_acctnt_cls_cd is '内部证券账户会计分类代码';
comment on column ${icl_schema}.cmm_ibank_secu_post.intnal_secu_acct_acctnt_cls_name is '内部证券账户会计分类名称';
comment on column ${icl_schema}.cmm_ibank_secu_post.fin_instm_id is '金融工具编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.asset_type_id is '资产类型编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.market_type_id is '市场类型编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.comb_tran_num is '组合交易号';
comment on column ${icl_schema}.cmm_ibank_secu_post.cntpty_acct_id is '交易对手账号';
comment on column ${icl_schema}.cmm_ibank_secu_post.obj_id is '对象编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.apv_form_num is '审批单号';
comment on column ${icl_schema}.cmm_ibank_secu_post.crdt_fin_instm_id is '授信金融工具编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.asset_uniq_idf_id is '资产唯一标识编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.prod_type_cd is '产品类型代码';
comment on column ${icl_schema}.cmm_ibank_secu_post.asset_type_name is '资产类型名称';
comment on column ${icl_schema}.cmm_ibank_secu_post.level5_cls_cd is '五级分类代码';
comment on column ${icl_schema}.cmm_ibank_secu_post.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.int_subj_id is '利息科目编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.recvbl_uncol_int_subj_id is '应收未收利息科目编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.int_adj_subj_id is '利息调整科目编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.evha_val_chag_subj_id is '公允价值变动科目编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.acru_int_inco_subj_id is '应计利息收入科目编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.amort_int_income_subj_id is '摊销利息收入科目编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.evha_val_chag_pl_subj_id is '公允价值变动损益科目编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.spd_pl_subj_id is '价差损益科目编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.acru_int_inco_vat_subj_id is '应计利息收入增值税科目编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.amort_int_income_vat_subj_id is '摊销利息收入增值税科目编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.spd_pl_vat_subj_id is '价差损益增值税科目编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.acct_name is '账户名称';
comment on column ${icl_schema}.cmm_ibank_secu_post.tran_market_id is '交易市场编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.exchg_acct_id is '交易所账户编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.issuer_id is '发行人编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.issuer_name is '发行人名称';
comment on column ${icl_schema}.cmm_ibank_secu_post.stl_site_id is '结算场所编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.stl_site_name is '结算场所名称';
comment on column ${icl_schema}.cmm_ibank_secu_post.tran_num is '交易号';
comment on column ${icl_schema}.cmm_ibank_secu_post.extra_dimen_cd is '额外维度代码';
comment on column ${icl_schema}.cmm_ibank_secu_post.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_ibank_secu_post.bal_type_cd is '余额类型代码';
comment on column ${icl_schema}.cmm_ibank_secu_post.actl_qtty is '实际数量';
comment on column ${icl_schema}.cmm_ibank_secu_post.actl_bal is '实际余额';
comment on column ${icl_schema}.cmm_ibank_secu_post.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_ibank_secu_post.net_price_cost is '净价成本';
comment on column ${icl_schema}.cmm_ibank_secu_post.currt_acru_int is '当期应计利息';
comment on column ${icl_schema}.cmm_ibank_secu_post.acru_int is '应计利息';
comment on column ${icl_schema}.cmm_ibank_secu_post.int_recvbl is '应收利息';
comment on column ${icl_schema}.cmm_ibank_secu_post.int_cost is '利息成本';
comment on column ${icl_schema}.cmm_ibank_secu_post.evha_val_chag is '公允价值变动';
comment on column ${icl_schema}.cmm_ibank_secu_post.recvbl_uncol_bal is '应收未收余额';
comment on column ${icl_schema}.cmm_ibank_secu_post.recvbl_uncol_net_price_cost is '应收未收净价成本';
comment on column ${icl_schema}.cmm_ibank_secu_post.recvbl_uncol_acru_int is '应收未收应计利息';
comment on column ${icl_schema}.cmm_ibank_secu_post.int_adj_amt is '利息调整金额';
comment on column ${icl_schema}.cmm_ibank_secu_post.ref_int_rat is '参考利率';
comment on column ${icl_schema}.cmm_ibank_secu_post.actl_int_rat is '实际利率';
comment on column ${icl_schema}.cmm_ibank_secu_post.fac_val_int_rat is '票面利率';
comment on column ${icl_schema}.cmm_ibank_secu_post.invest_yld_rat is '投资收益率';
comment on column ${icl_schema}.cmm_ibank_secu_post.open_yld_rat is '开仓收益率';
comment on column ${icl_schema}.cmm_ibank_secu_post.td_nv is '当日净值';
comment on column ${icl_schema}.cmm_ibank_secu_post.amort_dt is '摊销日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.fir_stl_dt is '首次结算日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.tran_dt is '交易日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.stl_dt is '结算日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.open_dt is '开仓日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.last_update_dt is '上次更新日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.cap_type_cd is '资金类型代码';
comment on column ${icl_schema}.cmm_ibank_secu_post.asset_four_cls_cd is '资产四分类代码';
comment on column ${icl_schema}.cmm_ibank_secu_post.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_ibank_secu_post.belong_org_id is '所属机构编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.tran_amt is '交易金额';
comment on column ${icl_schema}.cmm_ibank_secu_post.evha_val_chag_pl is '公允价值变动损益';
comment on column ${icl_schema}.cmm_ibank_secu_post.spd_pl is '价差损益';
comment on column ${icl_schema}.cmm_ibank_secu_post.int_income is '利息收入';
comment on column ${icl_schema}.cmm_ibank_secu_post.acru_int_inco is '应计利息收入';
comment on column ${icl_schema}.cmm_ibank_secu_post.amort_int_inco is '摊销利息收入';
comment on column ${icl_schema}.cmm_ibank_secu_post.acru_int_inco_should_tax_flg is '应计利息收入应税标志';
comment on column ${icl_schema}.cmm_ibank_secu_post.amort_int_income_should_tax_flg is '摊销利息收入应税标志';
comment on column ${icl_schema}.cmm_ibank_secu_post.spd_pl_should_tax_flg is '价差损益应税标志';
comment on column ${icl_schema}.cmm_ibank_secu_post.acru_int_inco_tax_rat is '应计利息收入税率';
comment on column ${icl_schema}.cmm_ibank_secu_post.amort_int_income_tax_rat is '摊销利息收入税率';
comment on column ${icl_schema}.cmm_ibank_secu_post.spd_pl_tax_rat is '价差损益税率';
comment on column ${icl_schema}.cmm_ibank_secu_post.acru_int_inco_tax_lmt is '应计利息收入税额';
comment on column ${icl_schema}.cmm_ibank_secu_post.amort_int_income_tax_lmt is '摊销利息收入税额';
comment on column ${icl_schema}.cmm_ibank_secu_post.spd_pl_tax_lmt is '价差损益税额';
comment on column ${icl_schema}.cmm_ibank_secu_post.ftp_prop_cate is 'FTP方案类别';
comment on column ${icl_schema}.cmm_ibank_secu_post.ftp_spread is 'FTP点差';
comment on column ${icl_schema}.cmm_ibank_secu_post.ncds_issue_org_id is '同业存单发行机构编号';
comment on column ${icl_schema}.cmm_ibank_secu_post.ncds_issue_org_name is '同业存单发行机构名称';
comment on column ${icl_schema}.cmm_ibank_secu_post.sell_org_name_comb is '销售机构名称组合';
comment on column ${icl_schema}.cmm_ibank_secu_post.sell_org_pct_comnt is '销售机构占比说明';
comment on column ${icl_schema}.cmm_ibank_secu_post.belong_org_name_comb is '归属机构名称组合';
comment on column ${icl_schema}.cmm_ibank_secu_post.belong_org_pct_comnt is '归属机构占比说明';
comment on column ${icl_schema}.cmm_ibank_secu_post.ovdue_status is '逾期状态';
comment on column ${icl_schema}.cmm_ibank_secu_post.ovdue_flg is '逾期标志';
comment on column ${icl_schema}.cmm_ibank_secu_post.pric_ovdue_dt is '本金逾期日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.pric_ovdue_days is '本金逾期天数';
comment on column ${icl_schema}.cmm_ibank_secu_post.int_ovdue_dt is '利息逾期日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.int_ovdue_days is '利息逾期天数';
comment on column ${icl_schema}.cmm_ibank_secu_post.pric_ovdue_amt is '本金逾期金额';
comment on column ${icl_schema}.cmm_ibank_secu_post.int_ovdue_amt	is '利息逾期金额';
comment on column ${icl_schema}.cmm_ibank_secu_post.is_th_ssn_redem is '是否当季赎回';
comment on column ${icl_schema}.cmm_ibank_secu_post.curr_issue_build_up_pos_dt is '本期建仓日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.expe_redem_dt is '预期赎回日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.tran_hold_idf is '交易持有标识';
comment on column ${icl_schema}.cmm_ibank_secu_post.apot_tenor_dep_flg is '约期存款标志';
comment on column ${icl_schema}.cmm_ibank_secu_post.apot_tenor_start_dt is '约期开始日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.apot_tenor_end_dt is '约期结束日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.apot_tenor_amt is '约期金额';
comment on column ${icl_schema}.cmm_ibank_secu_post.tran_cost_accti_method_cd is '交易成本核算方法代码';
comment on column ${icl_schema}.cmm_ibank_secu_post.cross_bor_depo_takof_inter_flg is '跨境同存标志';
comment on column ${icl_schema}.cmm_ibank_secu_post.cross_bor_depo_takof_inter_sign_value_dt is '跨境同存签约起息日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.cross_bor_depo_takof_inter_sign_exp_dt is '跨境同存签约到期日期';
comment on column ${icl_schema}.cmm_ibank_secu_post.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_ibank_secu_post.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_ibank_secu_post.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_ibank_secu_post.etl_timestamp is 'ETL处理时间戳';
