/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_am_bond_invest
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_am_bond_invest
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_am_bond_invest purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_am_bond_invest(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,acct_set_id varchar2(60) -- 账套编号
    ,am_prod_id varchar2(60) -- 资管产品编号
    ,am_prod_name varchar2(375) -- 资管产品名称
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,am_prod_prft_type_cd varchar2(60) -- 资管产品收益类型代码
    ,asset_id varchar2(60) -- 资产编号
    ,asset_name varchar2(1000) -- 资产名称
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,bond_id varchar2(60) -- 债券编号
    ,bond_name varchar2(250) -- 债券名称
    ,subj_id varchar2(60) -- 科目编号
    ,asset_type_cd varchar2(60) -- 资产类型代码
    ,tran_market_cd varchar2(10) -- 交易市场代码
    ,bond_type_cd varchar2(10) -- 债券类型代码
    ,brkevn_bond_flg varchar2(10) -- 保本债券标志
    ,convbl_bond_flg varchar2(10) -- 可转债标志
    ,sub_debt_flg varchar2(10) -- 次级债标志
    ,abs_flg varchar2(10) -- ABS标志
    ,issuer_id varchar2(60) -- 发行人编号
    ,issuer_name varchar2(250) -- 发行人名称
    ,issue_dt date -- 发行日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,tenor varchar2(10) -- 期限
    ,base_rat_id varchar2(60) -- 基准利率编号
    ,int_accr_base_cd varchar2(10) -- 计息基准代码
    ,int_accr_way_cd varchar2(60) -- 计息方式代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,int_rat_float_point number(18,8) -- 利率浮动点数
    ,fir_pay_int_dt date -- 首次付息日期
    ,last_pay_int_dt date -- 上次付息日期
    ,next_pay_int_dt date -- 下次付息日期
    ,holiday_rule_cd varchar2(10) -- 节假日规则代码
    ,cty_cd varchar2(10) -- 国家代码
    ,curr_cd varchar2(10) -- 币种代码
    ,fac_val_amt number(30,2) -- 票面金额
    ,fac_val_int_rat number(18,8) -- 票面利率
    ,mk_pri_full_price number(18,8) -- 市价全价
    ,mk_pri_net_price number(18,8) -- 市价净价
    ,pay_int_freq number(18,0) -- 付息频率
    ,pay_int_ped_cd varchar2(10) -- 付息周期代码
    ,int_accr_ped_cd varchar2(10) -- 计息周期代码
    ,reset_ped_cd varchar2(10) -- 重置周期代码
    ,hold_pos number(30,8) -- 持有仓位
    ,hold_fac_val number(30,8) -- 持有面值
    ,pric_bal number(30,8) -- 本金余额
    ,acru_int number(30,8) -- 应计利息
    ,int_recvbl number(30,8) -- 应收利息
    ,int_adj_amt number(30,8) -- 利息调整金额
    ,evha_val_chag number(30,8) -- 公允价值变动
    ,actl_int_rat number(18,8) -- 实际利率
    ,asset_four_cls_cd varchar2(10) -- 资产四分类代码
    ,open_dt date -- 开仓日期
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,crdt_out_acct_flow_num varchar2(60) -- 信贷出账流水号
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
grant select on ${icl_schema}.cmm_am_bond_invest to ${idl_schema};
grant select on ${icl_schema}.cmm_am_bond_invest to ${iel_schema};
grant select on ${icl_schema}.cmm_am_bond_invest to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_am_bond_invest is '资管债券投资';
comment on column ${icl_schema}.cmm_am_bond_invest.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_am_bond_invest.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_am_bond_invest.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_am_bond_invest.acct_set_id is '账套编号';
comment on column ${icl_schema}.cmm_am_bond_invest.am_prod_id is '资管产品编号';
comment on column ${icl_schema}.cmm_am_bond_invest.am_prod_name is '资管产品名称';
comment on column ${icl_schema}.cmm_am_bond_invest.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_am_bond_invest.am_prod_prft_type_cd is '资管产品收益类型代码';
comment on column ${icl_schema}.cmm_am_bond_invest.asset_id is '资产编号';
comment on column ${icl_schema}.cmm_am_bond_invest.asset_name is '资产名称';
comment on column ${icl_schema}.cmm_am_bond_invest.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_am_bond_invest.bond_id is '债券编号';
comment on column ${icl_schema}.cmm_am_bond_invest.bond_name is '债券名称';
comment on column ${icl_schema}.cmm_am_bond_invest.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_am_bond_invest.asset_type_cd is '资产类型代码';
comment on column ${icl_schema}.cmm_am_bond_invest.tran_market_cd is '交易市场代码';
comment on column ${icl_schema}.cmm_am_bond_invest.bond_type_cd is '债券类型代码';
comment on column ${icl_schema}.cmm_am_bond_invest.brkevn_bond_flg is '保本债券标志';
comment on column ${icl_schema}.cmm_am_bond_invest.convbl_bond_flg is '可转债标志';
comment on column ${icl_schema}.cmm_am_bond_invest.sub_debt_flg is '次级债标志';
comment on column ${icl_schema}.cmm_am_bond_invest.abs_flg is 'ABS标志';
comment on column ${icl_schema}.cmm_am_bond_invest.issuer_id is '发行人编号';
comment on column ${icl_schema}.cmm_am_bond_invest.issuer_name is '发行人名称';
comment on column ${icl_schema}.cmm_am_bond_invest.issue_dt is '发行日期';
comment on column ${icl_schema}.cmm_am_bond_invest.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_am_bond_invest.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_am_bond_invest.tenor is '期限';
comment on column ${icl_schema}.cmm_am_bond_invest.base_rat_id is '基准利率编号';
comment on column ${icl_schema}.cmm_am_bond_invest.int_accr_base_cd is '计息基准代码';
comment on column ${icl_schema}.cmm_am_bond_invest.int_accr_way_cd is '计息方式代码';
comment on column ${icl_schema}.cmm_am_bond_invest.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${icl_schema}.cmm_am_bond_invest.int_rat_float_point is '利率浮动点数';
comment on column ${icl_schema}.cmm_am_bond_invest.fir_pay_int_dt is '首次付息日期';
comment on column ${icl_schema}.cmm_am_bond_invest.last_pay_int_dt is '上次付息日期';
comment on column ${icl_schema}.cmm_am_bond_invest.next_pay_int_dt is '下次付息日期';
comment on column ${icl_schema}.cmm_am_bond_invest.holiday_rule_cd is '节假日规则代码';
comment on column ${icl_schema}.cmm_am_bond_invest.cty_cd is '国家代码';
comment on column ${icl_schema}.cmm_am_bond_invest.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_am_bond_invest.fac_val_amt is '票面金额';
comment on column ${icl_schema}.cmm_am_bond_invest.fac_val_int_rat is '票面利率';
comment on column ${icl_schema}.cmm_am_bond_invest.mk_pri_full_price is '市价全价';
comment on column ${icl_schema}.cmm_am_bond_invest.mk_pri_net_price is '市价净价';
comment on column ${icl_schema}.cmm_am_bond_invest.pay_int_freq is '付息频率';
comment on column ${icl_schema}.cmm_am_bond_invest.pay_int_ped_cd is '付息周期代码';
comment on column ${icl_schema}.cmm_am_bond_invest.int_accr_ped_cd is '计息周期代码';
comment on column ${icl_schema}.cmm_am_bond_invest.reset_ped_cd is '重置周期代码';
comment on column ${icl_schema}.cmm_am_bond_invest.hold_pos is '持有仓位';
comment on column ${icl_schema}.cmm_am_bond_invest.hold_fac_val is '持有面值';
comment on column ${icl_schema}.cmm_am_bond_invest.pric_bal is '本金余额';
comment on column ${icl_schema}.cmm_am_bond_invest.acru_int is '应计利息';
comment on column ${icl_schema}.cmm_am_bond_invest.int_recvbl is '应收利息';
comment on column ${icl_schema}.cmm_am_bond_invest.int_adj_amt is '利息调整金额';
comment on column ${icl_schema}.cmm_am_bond_invest.evha_val_chag is '公允价值变动';
comment on column ${icl_schema}.cmm_am_bond_invest.actl_int_rat is '实际利率';
comment on column ${icl_schema}.cmm_am_bond_invest.asset_four_cls_cd is '资产四分类代码';
comment on column ${icl_schema}.cmm_am_bond_invest.open_dt is '开仓日期';
comment on column ${icl_schema}.cmm_am_bond_invest.tran_flow_num is '交易流水号';
comment on column ${icl_schema}.cmm_am_bond_invest.crdt_out_acct_flow_num is '信贷出账流水号';
comment on column ${icl_schema}.cmm_am_bond_invest.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_am_bond_invest.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_am_bond_invest.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_am_bond_invest.etl_timestamp is 'ETL处理时间戳';
