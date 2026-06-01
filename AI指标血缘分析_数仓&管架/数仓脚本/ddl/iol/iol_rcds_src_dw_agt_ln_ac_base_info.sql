/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_src_dw_agt_ln_ac_base_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info(
    data_src_cd varchar2(4) -- 数据来源代码
    ,del_flg varchar2(1) -- 删除标志
    ,loan_acct_id varchar2(60) -- 贷款账户编号 Y
    ,etl_dt_ora date -- 数据日期
    ,blng_pty_id varchar2(60) -- 所属客户编号
    ,acct_name varchar2(500) -- 账户名称
    ,prd_id varchar2(60) -- 核算产品编号
    ,open_dt date -- 开户日期
    ,loan_issue_dt date -- 放款日期
    ,int_dt date -- 起息日期
    ,trmi_dt date -- 终止日期
    ,due_dt date -- 到期日期
    ,open_org_id varchar2(30) -- 开户机构编号
    ,mgmt_org_id varchar2(30) -- 管理机构编号
    ,accting_org_id varchar2(30) -- 账务机构编号
    ,pty_mgr_id varchar2(30) -- 客户经理编号
    ,agt_status_cd varchar2(4) -- 贷款账户状态代码
    ,accting_coa_id varchar2(30) -- 会计科目编号
    ,term_corp_cd varchar2(2) -- 期限单位代码
    ,loan_term number(22) -- 贷款期限
    ,ccy_cd varchar2(3) -- 币种代码
    ,issue_amt number(18,2) -- 发放金额
    ,rate_base_typ_cd varchar2(10) -- 利率基准类型代码
    ,rate_base_val number(14,10) -- 利率基准值
    ,exec_rate number(14,10) -- 正常执行利率
    ,ovdue_exec_rate number(14,10) -- 逾期执行利率
    ,float_rate_flg varchar2(1) -- 浮动利率标志
    ,rate_float_mode_cd varchar2(1) -- 利率浮动方式代码
    ,float_freq_cd varchar2(5) -- 浮动频率代码
    ,rate_float_val number(14,10) -- 正常利率浮动值
    ,ovdue_rate_float number(14,10) -- 逾期利率浮动值
    ,curr_rate_eff_day date -- 当前利率生效日
    ,next_rate_adj_day date -- 下一利率调整日
    ,loan_base_mon_day_qty varchar2(10) -- 贷款基准月天数
    ,loan_base_year_day_qty varchar2(10) -- 贷款基准年天数
    ,loan_compd_int_flg varchar2(1) -- 贷款复利标志
    ,loan_stl_mode_cd varchar2(2) -- 贷款结息方式代码
    ,loan_int_mode_cd varchar2(4) -- 贷款计息方式代码
    ,loan_calc_forml varchar2(100) -- 贷款计算公式
    ,dd_acct_id varchar2(60) -- 放款账户编号
    ,repay_mode_cd varchar2(3) -- 还款方式代码
    ,repay_freq_cd varchar2(3) -- 还款频率代码
    ,repay_acct_id varchar2(100) -- 还款账户编号
    ,assoc_loan_contr_id varchar2(60) -- 贷款合同编号
    ,bil_acct_id varchar2(60) -- 记账分户账编号
    ,assoc_bil_id varchar2(60) -- 关联票证编号
    ,loan_assoc_marg_acct varchar2(60) -- 贷款关联保证金账号
    ,margin_ccy_cd varchar2(3) -- 保证金币种代码
    ,margin_amt number(18,2) -- 保证金金额
    ,marg_ratio number(9,2) -- 保证金比例
    ,blng_biz_line_cd varchar2(2) -- 所属业务条线代码
    ,loan_biz_type_cd varchar2(30) -- 贷款业务品种代码
    ,sub_guar_mode_cd varchar2(2) -- 子担保方式代码
    ,loan_cate_cd varchar2(10) -- 贷款类型代码
    ,gov_platf_loan_flg varchar2(1) -- 政府融资平台贷款标志
    ,acct_categ_cd varchar2(4) -- 会计类别代码
    ,loan_flg varchar2(1) -- 贷款标志
    ,acpt_flg varchar2(1) -- 承兑标志
    ,bout_liqdt_flg varchar2(1) -- 买断清收标志
    ,comm_invo_num varchar2(20) -- 商业发票号码
    ,comm_inv_ccy_cd varchar2(3) -- 商业发票币种代码
    ,comm_inv_amt number(18,2) -- 商业发票金额
    ,comm_inv_type_cd varchar2(2) -- 商业发票种类代码
    ,fft_type_cd varchar2(1) -- 福费廷种类代码
    ,int_acct_id varchar2(30) -- 利息科目编号
    ,write_off_flg varchar2(1) -- 核销标志
    ,product_no varchar2(20) -- 标准贷款产品编号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info to ${iml_schema};
grant select on ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info to ${icl_schema};
grant select on ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info to ${idl_schema};
grant select on ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info is '数仓_贷款账户基本信息';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.data_src_cd is '数据来源代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.del_flg is '删除标志';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.loan_acct_id is '贷款账户编号 Y';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.blng_pty_id is '所属客户编号';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.acct_name is '账户名称';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.prd_id is '核算产品编号';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.open_dt is '开户日期';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.loan_issue_dt is '放款日期';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.int_dt is '起息日期';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.trmi_dt is '终止日期';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.due_dt is '到期日期';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.open_org_id is '开户机构编号';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.mgmt_org_id is '管理机构编号';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.accting_org_id is '账务机构编号';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.pty_mgr_id is '客户经理编号';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.agt_status_cd is '贷款账户状态代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.accting_coa_id is '会计科目编号';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.term_corp_cd is '期限单位代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.loan_term is '贷款期限';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.ccy_cd is '币种代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.issue_amt is '发放金额';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.rate_base_typ_cd is '利率基准类型代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.rate_base_val is '利率基准值';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.exec_rate is '正常执行利率';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.ovdue_exec_rate is '逾期执行利率';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.float_rate_flg is '浮动利率标志';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.rate_float_mode_cd is '利率浮动方式代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.float_freq_cd is '浮动频率代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.rate_float_val is '正常利率浮动值';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.ovdue_rate_float is '逾期利率浮动值';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.curr_rate_eff_day is '当前利率生效日';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.next_rate_adj_day is '下一利率调整日';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.loan_base_mon_day_qty is '贷款基准月天数';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.loan_base_year_day_qty is '贷款基准年天数';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.loan_compd_int_flg is '贷款复利标志';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.loan_stl_mode_cd is '贷款结息方式代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.loan_int_mode_cd is '贷款计息方式代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.loan_calc_forml is '贷款计算公式';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.dd_acct_id is '放款账户编号';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.repay_mode_cd is '还款方式代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.repay_freq_cd is '还款频率代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.repay_acct_id is '还款账户编号';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.assoc_loan_contr_id is '贷款合同编号';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.bil_acct_id is '记账分户账编号';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.assoc_bil_id is '关联票证编号';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.loan_assoc_marg_acct is '贷款关联保证金账号';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.margin_ccy_cd is '保证金币种代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.margin_amt is '保证金金额';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.marg_ratio is '保证金比例';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.blng_biz_line_cd is '所属业务条线代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.loan_biz_type_cd is '贷款业务品种代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.sub_guar_mode_cd is '子担保方式代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.loan_cate_cd is '贷款类型代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.gov_platf_loan_flg is '政府融资平台贷款标志';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.acct_categ_cd is '会计类别代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.loan_flg is '贷款标志';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.acpt_flg is '承兑标志';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.bout_liqdt_flg is '买断清收标志';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.comm_invo_num is '商业发票号码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.comm_inv_ccy_cd is '商业发票币种代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.comm_inv_amt is '商业发票金额';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.comm_inv_type_cd is '商业发票种类代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.fft_type_cd is '福费廷种类代码';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.int_acct_id is '利息科目编号';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.write_off_flg is '核销标志';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.product_no is '标准贷款产品编号';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rcds_src_dw_agt_ln_ac_base_info.etl_timestamp is 'ETL处理时间戳';
