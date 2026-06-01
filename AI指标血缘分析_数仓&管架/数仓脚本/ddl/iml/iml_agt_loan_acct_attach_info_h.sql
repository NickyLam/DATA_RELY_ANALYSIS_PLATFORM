/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_acct_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_acct_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_acct_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_acct_attach_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,loan_num varchar2(60) -- 贷款号
    ,rela_loan_num varchar2(60) -- 关联贷款号
    ,tran_sign_dt date -- 交易签约日期
    ,bar_flg varchar2(10) -- 随借随还标志
    ,repay_flg varchar2(10) -- 随还标志
    ,entr_loan_stl_idf_cd varchar2(30) -- 委托贷款结算标识代码
    ,loan_sign_cont_amt number(30,2) -- 贷款签约合同金额
    ,grace_period number(10) -- 宽限期
    ,grace_period_corp_cd varchar2(30) -- 宽限期单位代码
    ,coll_pnlt_flg varchar2(10) -- 收取罚息标志
    ,coll_comp_int_flg varchar2(10) -- 收取复利标志
    ,coll_pnlt_comp_int_flg varchar2(10) -- 收取罚息的复利标志
    ,coll_comp_int_comp_flg varchar2(10) -- 收取复利的复利标志
    ,mpr_flg varchar2(10) -- 利随本清标志
    ,adv_rpp_compst_amt number(20,8) -- 提前还本补偿金额
    ,distr_closing_dt date -- 发放截止日期
    ,loan_stop_accr_int_flg varchar2(10) -- 贷款停息标志
    ,dis_loan_adv_repay_low_fine number(30,2) -- 折扣贷款提前还款最低罚金
    ,adv_repay_low_compst_gold number(30,2) -- 提前还款最低补偿金
    ,max_renew_cnt number(10) -- 最大展期次数
    ,cont_id varchar2(100) -- 合同编号
    ,subtn_deduct_idf_cd varchar2(30) -- 持续扣款标识代码
    ,incremt_distr_flg varchar2(10) -- 增量发放标志
    ,loan_cate_cd varchar2(30) -- 贷款类别代码
    ,force_grace_flag varchar2(10) -- 宽限期遇节假日顺延标志
    ,grace_charge_int_flag varchar2(10) -- 到期本金在宽限期收息标志
    ,grace_pric_flg varchar2(10) -- 宽限本金标志
    ,grace_int_flg varchar2(10) -- 宽限利息标志
    ,coll_loan_stamp_tax_flg varchar2(10) -- 收取贷款印花税标志
    ,prtcpt_bk_contri_amt number(30,2) -- 参与行出资金额
    ,tax_idf_cd varchar2(30) -- 收税标识代码
    ,syn_loan_distr_cnt number(10) -- 银团贷款发放次数
    ,grace_period_minor_type_cd varchar2(30) -- 宽限期次类型代码
    ,grace_charge_odi_flag varchar2(10) -- 宽限期内收复利标志
    ,acrs_mon_idf_cd varchar2(30) -- 跨月标识代码
    ,free_int_term_days number(10) -- 免息期天数
    ,adv_col_int_flg varchar2(10) -- 提前收息标志
    ,cap_char_cd varchar2(30) -- 资金性质代码
    ,auto_payoff_flg varchar2(10) -- 自动结清标志
    ,cust_abbr varchar2(375) -- 客户简称
    ,loan_usage_cd varchar2(10) -- 贷款用途代码
    ,promis_lmt number(30,2) -- 承诺额
    ,tran_teller_id varchar2(60) -- 交易柜员编号
    ,final_modif_teller_id varchar2(100) -- 最后修改柜员编号
    ,final_modif_dt date -- 最后修改日期
    ,soc_ratio number(30,8) -- 理赔比例
    ,ovdue_soc_days number(38) -- 逾期理赔天数
    ,corp_size_cd varchar2(10) -- 企业规模代码
    ,natnal_econ_dept_type_cd varchar2(250) -- 国民经济部门类型代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_loan_acct_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_acct_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_acct_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_acct_attach_info_h is '贷款账户补充信息历史';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.loan_num is '贷款号';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.rela_loan_num is '关联贷款号';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.tran_sign_dt is '交易签约日期';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.bar_flg is '随借随还标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.repay_flg is '随还标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.entr_loan_stl_idf_cd is '委托贷款结算标识代码';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.loan_sign_cont_amt is '贷款签约合同金额';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.grace_period is '宽限期';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.grace_period_corp_cd is '宽限期单位代码';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.coll_pnlt_flg is '收取罚息标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.coll_comp_int_flg is '收取复利标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.coll_pnlt_comp_int_flg is '收取罚息的复利标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.coll_comp_int_comp_flg is '收取复利的复利标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.mpr_flg is '利随本清标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.adv_rpp_compst_amt is '提前还本补偿金额';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.distr_closing_dt is '发放截止日期';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.loan_stop_accr_int_flg is '贷款停息标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.dis_loan_adv_repay_low_fine is '折扣贷款提前还款最低罚金';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.adv_repay_low_compst_gold is '提前还款最低补偿金';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.max_renew_cnt is '最大展期次数';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.subtn_deduct_idf_cd is '持续扣款标识代码';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.incremt_distr_flg is '增量发放标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.loan_cate_cd is '贷款类别代码';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.force_grace_flag is '宽限期遇节假日顺延标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.grace_charge_int_flag is '到期本金在宽限期收息标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.grace_pric_flg is '宽限本金标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.grace_int_flg is '宽限利息标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.coll_loan_stamp_tax_flg is '收取贷款印花税标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.prtcpt_bk_contri_amt is '参与行出资金额';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.tax_idf_cd is '收税标识代码';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.syn_loan_distr_cnt is '银团贷款发放次数';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.grace_period_minor_type_cd is '宽限期次类型代码';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.grace_charge_odi_flag is '宽限期内收复利标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.acrs_mon_idf_cd is '跨月标识代码';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.free_int_term_days is '免息期天数';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.adv_col_int_flg is '提前收息标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.cap_char_cd is '资金性质代码';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.auto_payoff_flg is '自动结清标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.cust_abbr is '客户简称';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.promis_lmt is '承诺额';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.final_modif_teller_id is '最后修改柜员编号';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.soc_ratio is '理赔比例';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.ovdue_soc_days is '逾期理赔天数';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.corp_size_cd is '企业规模代码';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.natnal_econ_dept_type_cd is '国民经济部门类型代码';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_acct_attach_info_h.etl_timestamp is 'ETL处理时间戳';
