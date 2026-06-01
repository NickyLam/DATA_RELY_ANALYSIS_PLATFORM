/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_cap_bond_invest
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_cap_bond_invest
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_cap_bond_invest purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_cap_bond_invest(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bal_id varchar2(60) -- 余额编号
    ,bond_id varchar2(60) -- 债券编号
    ,custm_bond_id varchar2(60) -- 自定义债券编号
    ,tran_acct_b_id varchar2(60) -- 交易账簿编号
    ,tran_acct_b_name varchar2(375) -- 交易账簿名称
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,dept_id varchar2(60) -- 部门编号
    ,entry_org_id varchar2(60) -- 记账机构编号
    ,acct_attr_cd varchar2(10) -- 账户属性代码
    ,asset_four_cls_cd varchar2(10) -- 资产四分类代码
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,asset_type_name varchar2(150) -- 资产类型名称
    ,bus_cate_name varchar2(150) -- 业务类别名称
    ,subj_id varchar2(60) -- 科目编号
    ,int_recvbl_subj_id varchar2(60) -- 应收利息科目编号
    ,acru_int_subj_id varchar2(60) -- 应计利息科目编号
    ,int_adj_subj_id varchar2(60) -- 利息调整科目编号
    ,evha_val_chag_subj_id varchar2(60) -- 公允价值变动科目编号
    ,stl_dt date -- 结算日期
    ,bond_name varchar2(375) -- 债券名称
    ,issuer_cust_id varchar2(100) -- 发行人客户编号
    ,issuer_name varchar2(250) -- 发行人名称
    ,guartor_name varchar2(375) -- 担保人名称
    ,bond_type_cd varchar2(10) -- 债券类型代码
    ,init_bond_type_cd varchar2(10) -- 原债券类型代码
    ,convbl_bond_id varchar2(60) -- 可转债编号
    ,discnt_debt_flg varchar2(10) -- 贴现债标志
    ,convbl_bond_flg varchar2(10) -- 可转债标志
    ,abs_flg varchar2(10) -- ABS标志
    ,strk_bal_flg varchar2(10) -- 冲账标志
    ,curr_cd varchar2(10) -- 币种代码
    ,hold_pos number(30,2) -- 持有仓位
    ,hold_fac_val number(30,2) -- 持有面值
    ,net_price_cost number(30,2) -- 净价成本
    ,currt_bal number(30,2) -- 当期余额
    ,int_adj_amt number(30,2) -- 利息调整金额
    ,evha_val_chag number(30,2) -- 公允价值变动
    ,int_cost number(30,2) -- 利息成本
    ,full_price_cost number(30,2) -- 全价成本
    ,impam_prep number(30,2) -- 减值准备
    ,spd_prft number(30,2) -- 价差收益
    ,amort_prft number(30,2) -- 摊销收益
    ,int_prft number(30,2) -- 利息收益
    ,evha_val_chag_pl number(30,2) -- 公允价值变动损益
    ,evha_val_chag_pl_carr_bf number(30,2) -- 公允价值变动损益_结转前
    ,impam_loss number(30,2) -- 减值损失
    ,tran_fee number(30,2) -- 交易费用
    ,issue_dt date -- 发行日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,list_tran_dt date -- 上市交易日期
    ,stop_circlt_dt date -- 停止流通日期
    ,tenor number(18,0) -- 期限
    ,tenor_type_cd varchar2(10) -- 期限类型代码
    ,actl_int_rat number(18,8) -- 实际利率
    ,fac_val_int_rat number(30,2) -- 票面利率
    ,base_rat_id varchar2(60) -- 基准利率编号
    ,int_rat_float_dir_cd varchar2(10) -- 利率浮动方向代码
    ,int_rat_float_point number(18,6) -- 利率浮动点数
    ,int_accr_base_cd varchar2(10) -- 计息基准代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,int_rat_reset_ped_cd varchar2(10) -- 利率重置周期代码
    ,fir_int_rat_reset_dt date -- 首次利率重置日期
    ,int_accr_ped_cd varchar2(10) -- 计息周期代码
    ,fir_pay_int_dt date -- 首次付息日期
    ,pay_int_ped_cd varchar2(10) -- 付息周期代码
    ,td_acru_int number(30,2) -- 当日应计利息
    ,open_dt date -- 开仓日期
    ,recnt_tran_dt date -- 最近交易日期
    ,acru_int number(30,2) -- 应计利息
    ,int_recvbl number(30,2) -- 应收利息
    ,cbond_full_price_evltion number(30,8) -- 中债全价估值
    ,cbond_net_price_evltion number(30,8) -- 中债净价估值
    ,estim_coret_duran number(30,8) -- 估价修正久期
    ,bp_val number(30,8) -- 基点价值
    ,estim_cvty number(30,8) -- 估价凸性
    ,estim_yld_rat number(30,8) -- 估价收益率
    ,book_bal number(30,8) -- 账面余额
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
grant select on ${icl_schema}.cmm_cap_bond_invest to ${idl_schema};
grant select on ${icl_schema}.cmm_cap_bond_invest to ${iel_schema};
grant select on ${icl_schema}.cmm_cap_bond_invest to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_cap_bond_invest is '资金债券投资';
comment on column ${icl_schema}.cmm_cap_bond_invest.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_cap_bond_invest.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_cap_bond_invest.bal_id is '余额编号';
comment on column ${icl_schema}.cmm_cap_bond_invest.bond_id is '债券编号';
comment on column ${icl_schema}.cmm_cap_bond_invest.custm_bond_id is '自定义债券编号';
comment on column ${icl_schema}.cmm_cap_bond_invest.tran_acct_b_id is '交易账簿编号';
comment on column ${icl_schema}.cmm_cap_bond_invest.tran_acct_b_name is '交易账簿名称';
comment on column ${icl_schema}.cmm_cap_bond_invest.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_cap_bond_invest.dept_id is '部门编号';
comment on column ${icl_schema}.cmm_cap_bond_invest.entry_org_id is '记账机构编号';
comment on column ${icl_schema}.cmm_cap_bond_invest.acct_attr_cd is '账户属性代码';
comment on column ${icl_schema}.cmm_cap_bond_invest.asset_four_cls_cd is '资产四分类代码';
comment on column ${icl_schema}.cmm_cap_bond_invest.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_cap_bond_invest.asset_type_name is '资产类型名称';
comment on column ${icl_schema}.cmm_cap_bond_invest.bus_cate_name is '业务类别名称';
comment on column ${icl_schema}.cmm_cap_bond_invest.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_cap_bond_invest.int_recvbl_subj_id is '应收利息科目编号';
comment on column ${icl_schema}.cmm_cap_bond_invest.acru_int_subj_id is '应计利息科目编号';
comment on column ${icl_schema}.cmm_cap_bond_invest.int_adj_subj_id is '利息调整科目编号';
comment on column ${icl_schema}.cmm_cap_bond_invest.evha_val_chag_subj_id is '公允价值变动科目编号';
comment on column ${icl_schema}.cmm_cap_bond_invest.stl_dt is '结算日期';
comment on column ${icl_schema}.cmm_cap_bond_invest.bond_name is '债券名称';
comment on column ${icl_schema}.cmm_cap_bond_invest.issuer_cust_id is '发行人客户编号';
comment on column ${icl_schema}.cmm_cap_bond_invest.issuer_name is '发行人名称';
comment on column ${icl_schema}.cmm_cap_bond_invest.guartor_name is '担保人名称';
comment on column ${icl_schema}.cmm_cap_bond_invest.bond_type_cd is '债券类型代码';
comment on column ${icl_schema}.cmm_cap_bond_invest.init_bond_type_cd is '原债券类型代码';
comment on column ${icl_schema}.cmm_cap_bond_invest.convbl_bond_id is '可转债编号';
comment on column ${icl_schema}.cmm_cap_bond_invest.discnt_debt_flg is '贴现债标志';
comment on column ${icl_schema}.cmm_cap_bond_invest.convbl_bond_flg is '可转债标志';
comment on column ${icl_schema}.cmm_cap_bond_invest.abs_flg is 'ABS标志';
comment on column ${icl_schema}.cmm_cap_bond_invest.strk_bal_flg is '冲账标志';
comment on column ${icl_schema}.cmm_cap_bond_invest.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_cap_bond_invest.hold_pos is '持有仓位';
comment on column ${icl_schema}.cmm_cap_bond_invest.hold_fac_val is '持有面值';
comment on column ${icl_schema}.cmm_cap_bond_invest.net_price_cost is '净价成本';
comment on column ${icl_schema}.cmm_cap_bond_invest.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_cap_bond_invest.int_adj_amt is '利息调整金额';
comment on column ${icl_schema}.cmm_cap_bond_invest.evha_val_chag is '公允价值变动';
comment on column ${icl_schema}.cmm_cap_bond_invest.int_cost is '利息成本';
comment on column ${icl_schema}.cmm_cap_bond_invest.full_price_cost is '全价成本';
comment on column ${icl_schema}.cmm_cap_bond_invest.impam_prep is '减值准备';
comment on column ${icl_schema}.cmm_cap_bond_invest.spd_prft is '价差收益';
comment on column ${icl_schema}.cmm_cap_bond_invest.amort_prft is '摊销收益';
comment on column ${icl_schema}.cmm_cap_bond_invest.int_prft is '利息收益';
comment on column ${icl_schema}.cmm_cap_bond_invest.evha_val_chag_pl is '公允价值变动损益';
comment on column ${icl_schema}.cmm_cap_bond_invest.evha_val_chag_pl_carr_bf is '公允价值变动损益_结转前';
comment on column ${icl_schema}.cmm_cap_bond_invest.impam_loss is '减值损失';
comment on column ${icl_schema}.cmm_cap_bond_invest.tran_fee is '交易费用';
comment on column ${icl_schema}.cmm_cap_bond_invest.issue_dt is '发行日期';
comment on column ${icl_schema}.cmm_cap_bond_invest.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_cap_bond_invest.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_cap_bond_invest.list_tran_dt is '上市交易日期';
comment on column ${icl_schema}.cmm_cap_bond_invest.stop_circlt_dt is '停止流通日期';
comment on column ${icl_schema}.cmm_cap_bond_invest.tenor is '期限';
comment on column ${icl_schema}.cmm_cap_bond_invest.tenor_type_cd is '期限类型代码';
comment on column ${icl_schema}.cmm_cap_bond_invest.actl_int_rat is '实际利率';
comment on column ${icl_schema}.cmm_cap_bond_invest.fac_val_int_rat is '票面利率';
comment on column ${icl_schema}.cmm_cap_bond_invest.base_rat_id is '基准利率编号';
comment on column ${icl_schema}.cmm_cap_bond_invest.int_rat_float_dir_cd is '利率浮动方向代码';
comment on column ${icl_schema}.cmm_cap_bond_invest.int_rat_float_point is '利率浮动点数';
comment on column ${icl_schema}.cmm_cap_bond_invest.int_accr_base_cd is '计息基准代码';
comment on column ${icl_schema}.cmm_cap_bond_invest.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${icl_schema}.cmm_cap_bond_invest.int_rat_reset_ped_cd is '利率重置周期代码';
comment on column ${icl_schema}.cmm_cap_bond_invest.fir_int_rat_reset_dt is '首次利率重置日期';
comment on column ${icl_schema}.cmm_cap_bond_invest.int_accr_ped_cd is '计息周期代码';
comment on column ${icl_schema}.cmm_cap_bond_invest.fir_pay_int_dt is '首次付息日期';
comment on column ${icl_schema}.cmm_cap_bond_invest.pay_int_ped_cd is '付息周期代码';
comment on column ${icl_schema}.cmm_cap_bond_invest.td_acru_int is '当日应计利息';
comment on column ${icl_schema}.cmm_cap_bond_invest.open_dt is '开仓日期';
comment on column ${icl_schema}.cmm_cap_bond_invest.recnt_tran_dt is '最近交易日期';
comment on column ${icl_schema}.cmm_cap_bond_invest.acru_int is '应计利息';
comment on column ${icl_schema}.cmm_cap_bond_invest.int_recvbl is '应收利息';
comment on column ${icl_schema}.cmm_cap_bond_invest.cbond_full_price_evltion is '中债全价估值';
comment on column ${icl_schema}.cmm_cap_bond_invest.cbond_net_price_evltion is '中债净价估值';
comment on column ${icl_schema}.cmm_cap_bond_invest.estim_coret_duran is '估价修正久期';
comment on column ${icl_schema}.cmm_cap_bond_invest.bp_val is '基点价值';
comment on column ${icl_schema}.cmm_cap_bond_invest.estim_cvty is '估价凸性';
comment on column ${icl_schema}.cmm_cap_bond_invest.estim_yld_rat is '估价收益率';
comment on column ${icl_schema}.cmm_cap_bond_invest.book_bal is '账面余额';
comment on column ${icl_schema}.cmm_cap_bond_invest.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_cap_bond_invest.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_cap_bond_invest.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_cap_bond_invest.etl_timestamp is 'ETL处理时间戳';
