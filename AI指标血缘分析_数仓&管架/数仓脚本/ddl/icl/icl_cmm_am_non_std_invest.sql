/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_am_non_std_invest
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_am_non_std_invest
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_am_non_std_invest purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_am_non_std_invest(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,acct_set_id varchar2(60) -- 账套编号
    ,am_prod_id varchar2(60) -- 资管产品编号
    ,am_plan_id varchar2(60) -- 资管计划编号
    ,am_prod_name varchar2(1000) -- 资管产品名称
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,am_prod_prft_type_cd varchar2(60) -- 资管产品收益类型代码
    ,asset_plan_cd varchar2(60) -- 资产计划代码
    ,asset_plan_name varchar2(750) -- 资产计划名称
    ,asset_plan_kind_cd varchar2(10) -- 资产计划种类代码
    ,asset_prft_type_cd varchar2(60) -- 资产收益类型代码
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,subj_id varchar2(60) -- 科目编号
    ,risk_level_cd varchar2(30) -- 风险等级代码
    ,invest_way_cd varchar2(10) -- 投资方式代码
    ,gover_fin_plat_flg varchar2(10) -- 政府融资平台标志
    ,brkevn_flg varchar2(10) -- 保本标志
    ,sub_debt_flg varchar2(10) -- 次级债标志
    ,abs_flg varchar2(10) -- ABS标志
    ,cont_id varchar2(250) -- 合同编号
    ,fin_corp_id varchar2(250) -- 融资企业编号
    ,fin_corp_name varchar2(500) -- 融资企业名称
    ,indus_type_cd varchar2(10) -- 行业类型代码
    ,co_corp_id varchar2(60) -- 合作公司编号
    ,issue_dt date -- 发行日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,tenor varchar2(10) -- 期限
    ,base_rat_id varchar2(60) -- 基准利率编号
    ,int_accr_base_cd varchar2(10) -- 计息基准代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,int_rat_float_point number(18,8) -- 利率浮动点数
    ,rpp_freq number(18,0) -- 还本频率
    ,pay_int_freq number(18,0) -- 付息频率
    ,pay_int_ped_cd varchar2(10) -- 付息周期代码
    ,fir_pay_int_dt date -- 首次付息日期
    ,last_pay_int_dt date -- 上次付息日期
    ,next_pay_int_dt date -- 下次付息日期
    ,holiday_rule_cd varchar2(10) -- 节假日规则代码
    ,cty_cd varchar2(10) -- 国家代码
    ,curr_cd varchar2(10) -- 币种代码
    ,cont_amt number(30,2) -- 合同金额
    ,base_rat number(18,8) -- 基准利率
    ,exec_int_rat number(18,8) -- 执行利率
    ,hold_pos number(30,8) -- 持有仓位
    ,hold_fac_val number(30,8) -- 持有面值
    ,pric_bal number(30,8) -- 本金余额
    ,td_acru_int number(30,8) -- 当日应计利息
    ,currt_acru_int number(30,8) -- 当期应计利息
    ,acru_int number(30,2) -- 应计利息
    ,actl_int_rat number(18,8) -- 实际利率
    ,exp_yld_rat number(18,8) -- 到期收益率
    ,evha_val_chag number(30,8) -- 公允价值变动
    ,asset_four_cls_cd varchar2(10) -- 资产四分类代码
    ,open_dt date -- 开仓日期
    ,recnt_tran_dt date -- 最近交易日期
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
grant select on ${icl_schema}.cmm_am_non_std_invest to ${idl_schema};
grant select on ${icl_schema}.cmm_am_non_std_invest to ${iel_schema};
grant select on ${icl_schema}.cmm_am_non_std_invest to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_am_non_std_invest is '资管非标投资';
comment on column ${icl_schema}.cmm_am_non_std_invest.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_am_non_std_invest.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_am_non_std_invest.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_am_non_std_invest.acct_set_id is '账套编号';
comment on column ${icl_schema}.cmm_am_non_std_invest.am_prod_id is '资管产品编号';
comment on column ${icl_schema}.cmm_am_non_std_invest.am_plan_id is '资管计划编号';
comment on column ${icl_schema}.cmm_am_non_std_invest.am_prod_name is '资管产品名称';
comment on column ${icl_schema}.cmm_am_non_std_invest.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_am_non_std_invest.am_prod_prft_type_cd is '资管产品收益类型代码';
comment on column ${icl_schema}.cmm_am_non_std_invest.asset_plan_cd is '资产计划代码';
comment on column ${icl_schema}.cmm_am_non_std_invest.asset_plan_name is '资产计划名称';
comment on column ${icl_schema}.cmm_am_non_std_invest.asset_plan_kind_cd is '资产计划种类代码';
comment on column ${icl_schema}.cmm_am_non_std_invest.asset_prft_type_cd is '资产收益类型代码';
comment on column ${icl_schema}.cmm_am_non_std_invest.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_am_non_std_invest.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_am_non_std_invest.risk_level_cd is '风险等级代码';
comment on column ${icl_schema}.cmm_am_non_std_invest.invest_way_cd is '投资方式代码';
comment on column ${icl_schema}.cmm_am_non_std_invest.gover_fin_plat_flg is '政府融资平台标志';
comment on column ${icl_schema}.cmm_am_non_std_invest.brkevn_flg is '保本标志';
comment on column ${icl_schema}.cmm_am_non_std_invest.sub_debt_flg is '次级债标志';
comment on column ${icl_schema}.cmm_am_non_std_invest.abs_flg is 'ABS标志';
comment on column ${icl_schema}.cmm_am_non_std_invest.cont_id is '合同编号';
comment on column ${icl_schema}.cmm_am_non_std_invest.fin_corp_id is '融资企业编号';
comment on column ${icl_schema}.cmm_am_non_std_invest.fin_corp_name is '融资企业名称';
comment on column ${icl_schema}.cmm_am_non_std_invest.indus_type_cd is '行业类型代码';
comment on column ${icl_schema}.cmm_am_non_std_invest.co_corp_id is '合作公司编号';
comment on column ${icl_schema}.cmm_am_non_std_invest.issue_dt is '发行日期';
comment on column ${icl_schema}.cmm_am_non_std_invest.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_am_non_std_invest.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_am_non_std_invest.tenor is '期限';
comment on column ${icl_schema}.cmm_am_non_std_invest.base_rat_id is '基准利率编号';
comment on column ${icl_schema}.cmm_am_non_std_invest.int_accr_base_cd is '计息基准代码';
comment on column ${icl_schema}.cmm_am_non_std_invest.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${icl_schema}.cmm_am_non_std_invest.int_rat_float_point is '利率浮动点数';
comment on column ${icl_schema}.cmm_am_non_std_invest.rpp_freq is '还本频率';
comment on column ${icl_schema}.cmm_am_non_std_invest.pay_int_freq is '付息频率';
comment on column ${icl_schema}.cmm_am_non_std_invest.pay_int_ped_cd is '付息周期代码';
comment on column ${icl_schema}.cmm_am_non_std_invest.fir_pay_int_dt is '首次付息日期';
comment on column ${icl_schema}.cmm_am_non_std_invest.last_pay_int_dt is '上次付息日期';
comment on column ${icl_schema}.cmm_am_non_std_invest.next_pay_int_dt is '下次付息日期';
comment on column ${icl_schema}.cmm_am_non_std_invest.holiday_rule_cd is '节假日规则代码';
comment on column ${icl_schema}.cmm_am_non_std_invest.cty_cd is '国家代码';
comment on column ${icl_schema}.cmm_am_non_std_invest.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_am_non_std_invest.cont_amt is '合同金额';
comment on column ${icl_schema}.cmm_am_non_std_invest.base_rat is '基准利率';
comment on column ${icl_schema}.cmm_am_non_std_invest.exec_int_rat is '执行利率';
comment on column ${icl_schema}.cmm_am_non_std_invest.hold_pos is '持有仓位';
comment on column ${icl_schema}.cmm_am_non_std_invest.hold_fac_val is '持有面值';
comment on column ${icl_schema}.cmm_am_non_std_invest.pric_bal is '本金余额';
comment on column ${icl_schema}.cmm_am_non_std_invest.td_acru_int is '当日应计利息';
comment on column ${icl_schema}.cmm_am_non_std_invest.currt_acru_int is '当期应计利息';
comment on column ${icl_schema}.cmm_am_non_std_invest.acru_int is '应计利息';
comment on column ${icl_schema}.cmm_am_non_std_invest.actl_int_rat is '实际利率';
comment on column ${icl_schema}.cmm_am_non_std_invest.exp_yld_rat is '到期收益率';
comment on column ${icl_schema}.cmm_am_non_std_invest.evha_val_chag is '公允价值变动';
comment on column ${icl_schema}.cmm_am_non_std_invest.asset_four_cls_cd is '资产四分类代码';
comment on column ${icl_schema}.cmm_am_non_std_invest.open_dt is '开仓日期';
comment on column ${icl_schema}.cmm_am_non_std_invest.recnt_tran_dt is '最近交易日期';
comment on column ${icl_schema}.cmm_am_non_std_invest.crdt_out_acct_flow_num is '信贷出账流水号';
comment on column ${icl_schema}.cmm_am_non_std_invest.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_am_non_std_invest.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_am_non_std_invest.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_am_non_std_invest.etl_timestamp is 'ETL处理时间戳';
