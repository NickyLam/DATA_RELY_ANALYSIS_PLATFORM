/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_ibank_cash_debit_crdt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_ibank_cash_debit_crdt
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_ibank_cash_debit_crdt purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ibank_cash_debit_crdt(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,ext_secu_acct_id varchar2(60) -- 外部证券账户编号
    ,intnal_secu_acct_id varchar2(60) -- 内部证券账户编号
    ,acct_id varchar2(60) -- 账户编号
    ,fin_instm_id varchar2(100) -- 金融工具编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,market_type_id varchar2(60) -- 市场类型编号
    ,bus_id varchar2(60) -- 业务编号
    ,comb_tran_num varchar2(60) -- 组合交易号
    ,tran_seq_num varchar2(60) -- 交易序号
    ,obj_id varchar2(60) -- 对象编号
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,asset_type_name varchar2(250) -- 资产类型名称
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
    ,cntpty_acct_num varchar2(200) -- 交易对手账号
    ,cntpty_acct_name varchar2(750) -- 交易对手账户名称
    ,cntpty_open_bank_num varchar2(60) -- 交易对手开户行号
    ,cntpty_open_bank_name varchar2(750) -- 交易对手开户行名称
    ,cntpty_cls_descb varchar2(1000) -- 交易对手分类描述
    ,cntpty_idf_code varchar2(150) -- 交易对手标识编码
    ,cntpty_idf_code_type_cd varchar2(100) -- 交易对手标识编码类型代码
    ,tran_type_cd varchar2(10) -- 交易类型代码
    ,bank_flg varchar2(10) -- 银行标志
    ,cty_cd varchar2(10) -- 国家代码
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,cash_dt date -- 兑付日期
    ,tenor_cd varchar2(10) -- 期限代码
    ,int_accr_base_cd varchar2(10) -- 计息基准代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,base_rat_type_cd varchar2(10) -- 基准利率类型代码
    ,int_rat_adj_freq_cd varchar2(10) -- 利率调整频率代码
    ,apv_odd_no varchar2(60) -- 审批单号
    ,crdt_fin_instm_id varchar2(60) -- 授信金融工具编号
    ,asset_uniq_idf_id varchar2(100) -- 资产唯一标识编号
    ,curr_cd varchar2(10) -- 币种代码
    ,fac_val_amt number(38,8) -- 票面金额
    ,fac_val_int_rat number(18,8) -- 票面利率
    ,base_rat number(18,8) -- 基准利率
    ,exec_int_rat number(18,8) -- 执行利率
    ,pay_int_ped_cd varchar2(10) -- 付息周期代码
    ,auto_redt_flg varchar2(10) -- 自动转存标志
    ,trans_loan_flag varchar2(10) -- 转贷款标志
    ,actl_bal number(30,8) -- 实际余额
    ,pric_bal number(30,8) -- 本金余额
    ,currt_bal number(30,8) -- 当期余额
    ,acru_int number(30,8) -- 应计利息
    ,int_recvbl number(30,8) -- 应收利息
    ,recvbl_uncol_pric number(30,8) -- 应收未收本金
    ,recvbl_uncol_int number(30,8) -- 应收未收利息
    ,last_update_dt date -- 上次更新日期
    ,cap_type_cd varchar2(10) -- 资金类型代码
    ,asset_four_cls_cd varchar2(10) -- 资产四分类代码
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,tran_amt number(38,8) -- 交易金额
    ,extra_dimen_cd varchar2(10) -- 额外维度代码
    ,stl_dt date -- 结算日期
    ,ovdue_status varchar2(450) -- 逾期状态
    ,ovdue_flg varchar2(10) -- 逾期标志
    ,pric_ovdue_dt date -- 本金逾期日期
    ,pric_ovdue_days number(10) -- 贷款本金逾期天数
    ,int_ovdue_dt date -- 利息逾期日期
    ,int_ovdue_days number(10) -- 利息逾期天数
    ,acct_char_descb varchar2(150) -- 账户性质描述
    ,acct_attr_descb varchar2(150) -- 账户属性描述
    ,actl_finer_cust_id varchar2(60) -- 实际融资人客户编号
    ,actl_finer_name varchar2(750) -- 实际融资人名称
    ,actl_finer_group_name varchar2(500) -- 实际融资人集团名称
    ,inpwn_vch_id varchar2(60) -- 质押券编号
    ,inpwn_vch_asset_type_id varchar2(60) -- 质押券资产类型编号
    ,inpwn_vch_market_type_id varchar2(60) -- 质押券市场类型编号
    ,inpwn_cert_face_lmt number(30,8) -- 质押券面额
    ,inpwn_vch_discnt_rat number(30,8) -- 质押券折价率
    ,inpwn_vch_pct number(30,8) -- 质押券占比
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
grant select on ${icl_schema}.cmm_ibank_cash_debit_crdt to ${idl_schema};
grant select on ${icl_schema}.cmm_ibank_cash_debit_crdt to ${iel_schema};
grant select on ${icl_schema}.cmm_ibank_cash_debit_crdt to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_ibank_cash_debit_crdt is '同业现金借贷';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.ext_secu_acct_id is '外部证券账户编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.intnal_secu_acct_id is '内部证券账户编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.acct_id is '账户编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.fin_instm_id is '金融工具编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.asset_type_id is '资产类型编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.market_type_id is '市场类型编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.comb_tran_num is '组合交易号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.tran_seq_num is '交易序号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.obj_id is '对象编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.prod_type_cd is '产品类型代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.asset_type_name is '资产类型名称';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.level5_cls_cd is '五级分类代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.acct_name is '账户名称';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.int_subj_id is '利息科目编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.recvbl_uncol_int_subj_id is '应收未收利息科目编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.int_adj_subj_id is '利息调整科目编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.tran_market_id is '交易市场编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.exchg_acct_id is '交易所账户编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.cntpty_cust_id is '交易对手客户编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.cntpty_id is '交易对手编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.cntpty_name is '交易对手名称';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.cntpty_acct_num is '交易对手账号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.cntpty_acct_name is '交易对手账户名称';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.cntpty_open_bank_num is '交易对手开户行号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.cntpty_open_bank_name is '交易对手开户行名称';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.cntpty_cls_descb is '交易对手分类描述';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.cntpty_idf_code is '交易对手标识编码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.cntpty_idf_code_type_cd is '交易对手标识编码类型代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.tran_type_cd is '交易类型代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.bank_flg is '银行标志';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.cty_cd is '国家代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.cash_dt is '兑付日期';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.tenor_cd is '期限代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.int_accr_base_cd is '计息基准代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.base_rat_type_cd is '基准利率类型代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.int_rat_adj_freq_cd is '利率调整频率代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.apv_odd_no is '审批单号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.crdt_fin_instm_id is '授信金融工具编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.asset_uniq_idf_id is '资产唯一标识编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.fac_val_amt is '票面金额';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.fac_val_int_rat is '票面利率';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.base_rat is '基准利率';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.exec_int_rat is '执行利率';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.pay_int_ped_cd is '付息周期代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.auto_redt_flg is '自动转存标志';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.trans_loan_flag is '转贷款标志';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.actl_bal is '实际余额';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.pric_bal is '本金余额';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.acru_int is '应计利息';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.int_recvbl is '应收利息';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.recvbl_uncol_pric is '应收未收本金';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.recvbl_uncol_int is '应收未收利息';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.last_update_dt is '上次更新日期';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.cap_type_cd is '资金类型代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.asset_four_cls_cd is '资产四分类代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.belong_org_id is '所属机构编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.tran_amt is '交易金额';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.extra_dimen_cd is '额外维度代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.stl_dt is '结算日期';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.ovdue_status is '逾期状态';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.ovdue_flg is '逾期标志';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.pric_ovdue_dt is '本金逾期日期';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.pric_ovdue_days is '贷款本金逾期天数';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.int_ovdue_dt is '利息逾期日期';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.int_ovdue_days is '利息逾期天数';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.acct_char_descb is '账户性质描述';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.acct_attr_descb is '账户属性描述';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.actl_finer_cust_id is '实际融资人客户编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.actl_finer_name is '实际融资人名称';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.actl_finer_group_name is '实际融资人集团名称';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.inpwn_vch_id is '质押券编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.inpwn_vch_asset_type_id is '质押券资产类型编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.inpwn_vch_market_type_id is '质押券市场类型编号';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.inpwn_cert_face_lmt is '质押券面额';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.inpwn_vch_discnt_rat is '质押券折价率';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.inpwn_vch_pct is '质押券占比';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_ibank_cash_debit_crdt.etl_timestamp is 'ETL处理时间戳';
