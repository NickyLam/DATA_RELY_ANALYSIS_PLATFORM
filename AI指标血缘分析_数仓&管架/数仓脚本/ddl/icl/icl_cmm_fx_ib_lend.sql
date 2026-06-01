/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_fx_ib_lend
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_fx_ib_lend
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_fx_ib_lend purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_fx_ib_lend(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,dept_id varchar2(60) -- 部门编号
    ,entry_org_id varchar2(60) -- 记账机构编号
    ,tran_acct_b_id varchar2(60) -- 交易账簿编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,cust_id varchar2(100) -- 客户编号
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(750) -- 交易对手名称
    ,portf_id varchar2(60) -- 投组编号
    ,portf_name varchar2(750) -- 投组名称
    ,portf_class_name varchar2(250) -- 投组类型名称
    ,inv_port_status_cd varchar2(10) -- 投资组合状态代码
    ,subj_id varchar2(60) -- 科目编号
    ,int_recvbl_subj_id varchar2(60) -- 应收利息科目编号
    ,int_income_subj_id varchar2(60) -- 利息收入科目编号
    ,tran_aim_cd varchar2(10) -- 交易目的代码
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,tran_mode_cd varchar2(10) -- 交易模式代码
    ,clear_way_cd varchar2(10) -- 清算方式代码
    ,ib_lend_type_cd varchar2(10) -- 拆借类型代码
    ,clear_org_cd varchar2(10) -- 清算机构代码
    ,input_dt date -- 录入日期
    ,tran_dt date -- 交易日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,tenor number(18,0) -- 期限
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,int_rat_adj_freq_cd varchar2(60) -- 利率调整频率代码
    ,int_accr_base_cd varchar2(10) -- 计息基准代码
    ,int_rat_float_dir_cd varchar2(10) -- 利率浮动方向代码
    ,int_rat_float_point number(18,8) -- 利率浮动点数
    ,int_rat_tenor_cd varchar2(30) -- 利率期限代码
    ,base_rat number(18,8) -- 基准利率
    ,exec_int_rat number(18,8) -- 执行利率
    ,curr_cd varchar2(10) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,exp_amt number(30,2) -- 到期金额
    ,usd_tran_amt number(30,12) -- 折美元交易金额
    ,inpwn_amt varchar2(750) -- 债券质押金额组合
    ,acru_int number(30,2) -- 应计利息
    ,currt_bal number(30,2) -- 当期余额
    ,td_acru_int number(30,2) -- 当日应计利息
    ,currt_acru_int number(30,2) -- 当期应计利息
    ,pay_int_ped_cd varchar2(60) -- 付息周期代码
    ,fir_pay_int_dt date -- 首次付息日期
    ,pay_stub_proc_way_cd varchar2(10) -- 付息残段处理方式代码
    ,bag_status_cd varchar2(10) -- 成交状态代码
    ,tran_src_cd varchar2(10) -- 交易来源代码
    ,tran_site_cd varchar2(10) -- 交易场所代码
    ,bag_id varchar2(60) -- 成交编号
    ,tran_id varchar2(60) -- 交易编号
    ,bond_id varchar2(60) -- 债券编号
    ,bond_fac_val number(30,2) -- 债券面值
    ,bond_curr varchar2(10) -- 债券币种
    ,inpwn_ratio number(18,8) -- 质押比例
    ,inpwn_way_cd varchar2(10) -- 质押方式代码
    ,ghb_clear_acct_id varchar2(500) -- 本方清算账户编号
    ,cntpty_acct_id varchar2(500) -- 交易对手账号
    ,cntpty_bank_no varchar2(500) -- 交易对手行号
    ,cntpty_bank_name varchar2(750) -- 交易对手行名称
    ,dealer_id varchar2(60) -- 交易员编号
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
grant select on ${icl_schema}.cmm_fx_ib_lend to ${idl_schema};
grant select on ${icl_schema}.cmm_fx_ib_lend to ${iel_schema};
grant select on ${icl_schema}.cmm_fx_ib_lend to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_fx_ib_lend is '外汇同业拆借';
comment on column ${icl_schema}.cmm_fx_ib_lend.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_fx_ib_lend.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.dept_id is '部门编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.entry_org_id is '记账机构编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.tran_acct_b_id is '交易账簿编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.cntpty_id is '交易对手编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.cntpty_name is '交易对手名称';
comment on column ${icl_schema}.cmm_fx_ib_lend.portf_id is '投组编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.portf_name is '投组名称';
comment on column ${icl_schema}.cmm_fx_ib_lend.portf_class_name is '投组类型名称';
comment on column ${icl_schema}.cmm_fx_ib_lend.inv_port_status_cd is '投资组合状态代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.int_recvbl_subj_id is '应收利息科目编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.int_income_subj_id is '利息收入科目编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.tran_aim_cd is '交易目的代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.tran_dir_cd is '交易方向代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.tran_mode_cd is '交易模式代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.clear_way_cd is '清算方式代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.ib_lend_type_cd is '拆借类型代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.clear_org_cd is '清算机构代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.input_dt is '录入日期';
comment on column ${icl_schema}.cmm_fx_ib_lend.tran_dt is '交易日期';
comment on column ${icl_schema}.cmm_fx_ib_lend.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_fx_ib_lend.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_fx_ib_lend.tenor is '期限';
comment on column ${icl_schema}.cmm_fx_ib_lend.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.int_rat_adj_freq_cd is '利率调整频率代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.int_accr_base_cd is '计息基准代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.int_rat_float_dir_cd is '利率浮动方向代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.int_rat_float_point is '利率浮动点数';
comment on column ${icl_schema}.cmm_fx_ib_lend.int_rat_tenor_cd is '利率期限代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.base_rat is '基准利率';
comment on column ${icl_schema}.cmm_fx_ib_lend.exec_int_rat is '执行利率';
comment on column ${icl_schema}.cmm_fx_ib_lend.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.tran_amt is '交易金额';
comment on column ${icl_schema}.cmm_fx_ib_lend.exp_amt is '到期金额';
comment on column ${icl_schema}.cmm_fx_ib_lend.usd_tran_amt is '折美元交易金额';
comment on column ${icl_schema}.cmm_fx_ib_lend.inpwn_amt is '债券质押金额组合';
comment on column ${icl_schema}.cmm_fx_ib_lend.acru_int is '应计利息';
comment on column ${icl_schema}.cmm_fx_ib_lend.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_fx_ib_lend.td_acru_int is '当日应计利息';
comment on column ${icl_schema}.cmm_fx_ib_lend.currt_acru_int is '当期应计利息';
comment on column ${icl_schema}.cmm_fx_ib_lend.pay_int_ped_cd is '付息周期代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.fir_pay_int_dt is '首次付息日期';
comment on column ${icl_schema}.cmm_fx_ib_lend.pay_stub_proc_way_cd is '付息残段处理方式代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.bag_status_cd is '成交状态代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.tran_src_cd is '交易来源代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.tran_site_cd is '交易场所代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.bag_id is '成交编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.tran_id is '交易编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.bond_id is '债券编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.bond_fac_val is '债券面值';
comment on column ${icl_schema}.cmm_fx_ib_lend.bond_curr is '债券币种';
comment on column ${icl_schema}.cmm_fx_ib_lend.inpwn_ratio is '质押比例';
comment on column ${icl_schema}.cmm_fx_ib_lend.inpwn_way_cd is '质押方式代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.ghb_clear_acct_id is '本方清算账户编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.cntpty_acct_id is '交易对手账号';
comment on column ${icl_schema}.cmm_fx_ib_lend.cntpty_bank_no is '交易对手行号';
comment on column ${icl_schema}.cmm_fx_ib_lend.cntpty_bank_name is '交易对手行名称';
comment on column ${icl_schema}.cmm_fx_ib_lend.dealer_id is '交易员编号';
comment on column ${icl_schema}.cmm_fx_ib_lend.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_fx_ib_lend.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_fx_ib_lend.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_fx_ib_lend.etl_timestamp is 'ETL处理时间戳';
