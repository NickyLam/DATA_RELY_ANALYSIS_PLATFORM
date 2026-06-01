/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_loan_prod_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_loan_prod_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_loan_prod_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_loan_prod_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,prod_id varchar2(100) -- 产品编号
    ,prod_name varchar2(200) -- 产品名称
    ,super_prod_id varchar2(100) -- 上级产品编号
    ,lmt_prod_flg varchar2(10) -- 额度产品标志
    ,prod_status_cd varchar2(30) -- 产品状态代码
    ,in_out_tab_attr_cd varchar2(30) -- 表内外属性代码
    ,prod_effect_dt date -- 产品生效日期
    ,prod_invalid_dt date -- 产品失效日期
    ,prod_edit_id varchar2(100) -- 产品版本编号
    ,cust_type_comb_cd varchar2(3000) -- 客户类型组合代码
    ,dom_overs_comb_cd varchar2(3000) -- 境内境外组合代码
    ,curr_comb_cd varchar2(3000) -- 币种组合代码
    ,repay_way_comb_cd varchar2(3000) -- 还款方式组合代码
    ,guar_way_comb_cd varchar2(3000) -- 担保方式组合代码
    ,acct_type_cd varchar2(100) -- 账户类型代码
    ,discnt_loan_type_cd varchar2(30) -- 贴现贷款类型代码
    ,repay_amt_ctrl_cd varchar2(30) -- 还款金额控制代码
    ,bf_col_int_flg varchar2(10) -- 前收息标志
    ,lont_loan_tenor varchar2(10) -- 最长贷款期限
    ,shortest_loan_tenor varchar2(10) -- 最短贷款期限
    ,subtn_deduct_flg varchar2(10) -- 持续扣款标志
    ,auto_callbk_flg varchar2(10) -- 自动回收标志
    ,circl_flg varchar2(10) -- 循环标志
    ,bar_flg varchar2(10) -- 随借随还标志
    ,int_accr_flg varchar2(10) -- 计息标志
    ,comp_int_flg varchar2(10) -- 复利标志
    ,pnlt_flg varchar2(10) -- 罚息标志
    ,pnlt_comp_int_flg varchar2(10) -- 罚息的复利标志
    ,comp_int_comp_int_flg varchar2(10) -- 复利的复利标志
    ,renew_flg varchar2(10) -- 展期标志
    ,max_renew_cnt varchar2(10) -- 最大展期次数
    ,soterm_flg varchar2(10) -- 缩期标志
    ,max_soterm_cnt varchar2(10) -- 最大缩期次数
    ,grace_period_corp_cd varchar2(30) -- 宽限期单位代码
    ,grace_period varchar2(10) -- 宽限期
    ,crdtc_grace_period varchar2(10) -- 征信宽限期
    ,sig_distr_flg varchar2(10) -- 单笔发放标志
    ,sig_distr_amt_ctrl_flg varchar2(10) -- 单次发放金额控制标志
    ,sig_distr_max_amt varchar2(30) -- 单次最大发放金额
    ,sig_distr_min_amt varchar2(30) -- 单次最小发放金额
    ,sel_sup_loan_flg varchar2(10) -- 自营贷款标志
    ,syn_loan_char_cd varchar2(30) -- 银团贷款性质代码
    ,int_rat_ped_cd varchar2(30) -- 利率周期代码
    ,lowt_exec_int_rat varchar2(30) -- 最低执行利率
    ,higt_exec_int_rat varchar2(30) -- 最高执行利率
    ,ovdue_int_rat_float_way_cd varchar2(30) -- 逾期利率浮动方式代码
    ,ovdue_int_rat_float_ratio varchar2(30) -- 逾期利率浮动比例
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
grant select on ${icl_schema}.cmm_loan_prod_info to ${idl_schema};
grant select on ${icl_schema}.cmm_loan_prod_info to ${iel_schema};
grant select on ${icl_schema}.cmm_loan_prod_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_loan_prod_info is '贷款产品信息';
comment on column ${icl_schema}.cmm_loan_prod_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_loan_prod_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_loan_prod_info.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_loan_prod_info.prod_name is '产品名称';
comment on column ${icl_schema}.cmm_loan_prod_info.super_prod_id is '上级产品编号';
comment on column ${icl_schema}.cmm_loan_prod_info.lmt_prod_flg is '额度产品标志';
comment on column ${icl_schema}.cmm_loan_prod_info.prod_status_cd is '产品状态代码';
comment on column ${icl_schema}.cmm_loan_prod_info.in_out_tab_attr_cd is '表内外属性代码';
comment on column ${icl_schema}.cmm_loan_prod_info.prod_effect_dt is '产品生效日期';
comment on column ${icl_schema}.cmm_loan_prod_info.prod_invalid_dt is '产品失效日期';
comment on column ${icl_schema}.cmm_loan_prod_info.prod_edit_id is '产品版本编号';
comment on column ${icl_schema}.cmm_loan_prod_info.cust_type_comb_cd is '客户类型组合代码';
comment on column ${icl_schema}.cmm_loan_prod_info.dom_overs_comb_cd is '境内境外组合代码';
comment on column ${icl_schema}.cmm_loan_prod_info.curr_comb_cd is '币种组合代码';
comment on column ${icl_schema}.cmm_loan_prod_info.repay_way_comb_cd is '还款方式组合代码';
comment on column ${icl_schema}.cmm_loan_prod_info.guar_way_comb_cd is '担保方式组合代码';
comment on column ${icl_schema}.cmm_loan_prod_info.acct_type_cd is '账户类型代码';
comment on column ${icl_schema}.cmm_loan_prod_info.discnt_loan_type_cd is '贴现贷款类型代码';
comment on column ${icl_schema}.cmm_loan_prod_info.repay_amt_ctrl_cd is '还款金额控制代码';
comment on column ${icl_schema}.cmm_loan_prod_info.bf_col_int_flg is '前收息标志';
comment on column ${icl_schema}.cmm_loan_prod_info.lont_loan_tenor is '最长贷款期限';
comment on column ${icl_schema}.cmm_loan_prod_info.shortest_loan_tenor is '最短贷款期限';
comment on column ${icl_schema}.cmm_loan_prod_info.subtn_deduct_flg is '持续扣款标志';
comment on column ${icl_schema}.cmm_loan_prod_info.auto_callbk_flg is '自动回收标志';
comment on column ${icl_schema}.cmm_loan_prod_info.circl_flg is '循环标志';
comment on column ${icl_schema}.cmm_loan_prod_info.bar_flg is '随借随还标志';
comment on column ${icl_schema}.cmm_loan_prod_info.int_accr_flg is '计息标志';
comment on column ${icl_schema}.cmm_loan_prod_info.comp_int_flg is '复利标志';
comment on column ${icl_schema}.cmm_loan_prod_info.pnlt_flg is '罚息标志';
comment on column ${icl_schema}.cmm_loan_prod_info.pnlt_comp_int_flg is '罚息的复利标志';
comment on column ${icl_schema}.cmm_loan_prod_info.comp_int_comp_int_flg is '复利的复利标志';
comment on column ${icl_schema}.cmm_loan_prod_info.renew_flg is '展期标志';
comment on column ${icl_schema}.cmm_loan_prod_info.max_renew_cnt is '最大展期次数';
comment on column ${icl_schema}.cmm_loan_prod_info.soterm_flg is '缩期标志';
comment on column ${icl_schema}.cmm_loan_prod_info.max_soterm_cnt is '最大缩期次数';
comment on column ${icl_schema}.cmm_loan_prod_info.grace_period_corp_cd is '宽限期单位代码';
comment on column ${icl_schema}.cmm_loan_prod_info.grace_period is '宽限期';
comment on column ${icl_schema}.cmm_loan_prod_info.crdtc_grace_period is '征信宽限期';
comment on column ${icl_schema}.cmm_loan_prod_info.sig_distr_flg is '单笔发放标志';
comment on column ${icl_schema}.cmm_loan_prod_info.sig_distr_amt_ctrl_flg is '单次发放金额控制标志';
comment on column ${icl_schema}.cmm_loan_prod_info.sig_distr_max_amt is '单次最大发放金额';
comment on column ${icl_schema}.cmm_loan_prod_info.sig_distr_min_amt is '单次最小发放金额';
comment on column ${icl_schema}.cmm_loan_prod_info.sel_sup_loan_flg is '自营贷款标志';
comment on column ${icl_schema}.cmm_loan_prod_info.syn_loan_char_cd is '银团贷款性质代码';
comment on column ${icl_schema}.cmm_loan_prod_info.int_rat_ped_cd is '利率周期代码';
comment on column ${icl_schema}.cmm_loan_prod_info.lowt_exec_int_rat is '最低执行利率';
comment on column ${icl_schema}.cmm_loan_prod_info.higt_exec_int_rat is '最高执行利率';
comment on column ${icl_schema}.cmm_loan_prod_info.ovdue_int_rat_float_way_cd is '逾期利率浮动方式代码';
comment on column ${icl_schema}.cmm_loan_prod_info.ovdue_int_rat_float_ratio is '逾期利率浮动比例';
comment on column ${icl_schema}.cmm_loan_prod_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_loan_prod_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_loan_prod_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_loan_prod_info.etl_timestamp is 'ETL处理时间戳';
