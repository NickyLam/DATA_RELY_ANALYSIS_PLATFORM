/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_loan_prod_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_loan_prod_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_loan_prod_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_loan_prod_attach_info_h(
    prod_id varchar2(100) -- 产品编号
    ,lp_id varchar2(100) -- 法人编号
    ,prod_name varchar2(500) -- 产品名称
    ,cust_bl_induty_cd varchar2(500) -- 客户所属行业代码
    ,lowt_cust_rating_cd varchar2(60) -- 最低客户评级代码
    ,guar_way_cd varchar2(60) -- 担保方式代码
    ,min_annual_int_rat number(30,8) -- 最小年化利率
    ,max_annual_int_rat number(30,8) -- 最大年化利率
    ,grace_days number(38) -- 宽限天数
    ,auto_out_acct_rgst_flg varchar2(10) -- 自动出账登记标志
    ,max_auto_distr_amt number(30,8) -- 最大自动放款金额
    ,auto_check_distr_flg varchar2(10) -- 自动复核放款标志
    ,auto_entr_pay_flg varchar2(500) -- 自动受托支付标志
    ,entr_pay_acct_id varchar2(100) -- 受托支付账户编号
    ,entr_pay_acct_name varchar2(500) -- 受托支付账户名称
    ,supt_adv_repay_flg varchar2(10) -- 支持提前还款标志
    ,supt_onl_distr_appl_flg varchar2(10) -- 支持线上放款申请标志
    ,lmt_min_tenor number(38) -- 额度最小期限
    ,dom_overs_idf_cd varchar2(60) -- 境内外标识代码
    ,cust_type_cd varchar2(60) -- 客户类型代码
    ,acct_type_cd varchar2(60) -- 账户类型代码
    ,brwer_acct_check_flg varchar2(10) -- 借款人账户检查标志
    ,discnt_loan_type_cd varchar2(60) -- 贴现贷款类型代码
    ,curr_cd varchar2(500) -- 币种代码
    ,sig_distr_amt_ctrl_flg varchar2(10) -- 单次发放金额控制标志
    ,sig_max_distr_amt number(30,8) -- 单次最大发放金额
    ,sig_min_distr_amt number(30,8) -- 单次最小发放金额
    ,loan_tenor_ctrl_flg varchar2(10) -- 贷款期限控制标志
    ,lont_loan_mon_tenor number(38) -- 最长贷款月期限
    ,shortest_loan_mon_tenor number(38) -- 最短贷款月期限
    ,incremt_distr_apv_flg varchar2(10) -- 增量发放审批标志
    ,sig_distr_flg varchar2(10) -- 单笔发放标志
    ,distr_allow_apv_flg varchar2(10) -- 发放允许审批标志
    ,repay_way_cd varchar2(500) -- 还款方式代码
    ,subtn_deduct_flg varchar2(10) -- 持续扣款标志
    ,auto_callbk_flg varchar2(10) -- 自动回收标志
    ,repay_amt_ctrl_flg varchar2(10) -- 还款金额控制标志
    ,adv_col_int_flg varchar2(10) -- 提前收息标志
    ,int_rat_start_use_way_cd varchar2(500) -- 利率启用方式代码
    ,int_rat_adj_ped_cd varchar2(30) -- 利率调整周期代码
    ,int_rat_effect_way_cd varchar2(30) -- 利率生效方式代码
    ,int_accr_flg varchar2(10) -- 计息标志
    ,c_comp_int_flg varchar2(10) -- 收复利标志
    ,c_pnlt_flg varchar2(10) -- 收罚息标志
    ,c_pnlt_comp_int_flg varchar2(10) -- 收罚息的复利标志
    ,c_comp_int_comp_int_flg varchar2(10) -- 收复利的复利标志
    ,allow_renew_flg varchar2(10) -- 允许展期标志
    ,max_renew_cnt number(38) -- 最大展期次数
    ,allow_soterm_flg varchar2(10) -- 允许缩期标志
    ,max_soterm_cnt number(38) -- 最大缩期次数
    ,circl_flg varchar2(10) -- 循环标志
    ,sel_sup_flg varchar2(10) -- 自营标志
    ,asset_tran_flg varchar2(10) -- 资产转让标志
    ,abs_flg varchar2(10) -- 资产证券化标志
    ,log_and_base_cont_rela_type_cd varchar2(30) -- 保函与基础合同关系类型代码
    ,log_attr_cd varchar2(30) -- 保函属性代码
    ,log_advc_prod_id varchar2(500) -- 保函垫款产品编号
    ,rela_margin_flg varchar2(10) -- 关联保证金标志
    ,open_auto_froz_margin_flg varchar2(10) -- 开立时自动冻结保证金标志
    ,retra_auto_unfrz_margin_flg varchar2(10) -- 收回时自动解冻保证金标志
    ,exp_auto_unfrz_margin_flg varchar2(10) -- 到期自动解冻保证金标志
    ,syn_loan_char_cd varchar2(100) -- 银团贷款性质代码
    ,ovdue_soc_days number(38) -- 逾期理赔天数
    ,soc_ratio number(30,8) -- 理赔比例
    ,old_prod_id varchar2(100) -- 旧产品编号
    ,new_prod_id varchar2(100) -- 新产品编号
    ,new_prod_name varchar2(500) -- 新产品名称
    ,prod_effect_dt date -- 产品生效日期
    ,prod_invalid_dt date -- 产品失效日期
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,modif_dt date -- 变更日期
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
grant select on ${iml_schema}.prd_loan_prod_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.prd_loan_prod_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.prd_loan_prod_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_loan_prod_attach_info_h is '贷款产品附属信息历史';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.prod_name is '产品名称';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.cust_bl_induty_cd is '客户所属行业代码';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.lowt_cust_rating_cd is '最低客户评级代码';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.guar_way_cd is '担保方式代码';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.min_annual_int_rat is '最小年化利率';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.max_annual_int_rat is '最大年化利率';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.grace_days is '宽限天数';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.auto_out_acct_rgst_flg is '自动出账登记标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.max_auto_distr_amt is '最大自动放款金额';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.auto_check_distr_flg is '自动复核放款标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.auto_entr_pay_flg is '自动受托支付标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.entr_pay_acct_id is '受托支付账户编号';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.entr_pay_acct_name is '受托支付账户名称';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.supt_adv_repay_flg is '支持提前还款标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.supt_onl_distr_appl_flg is '支持线上放款申请标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.lmt_min_tenor is '额度最小期限';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.dom_overs_idf_cd is '境内外标识代码';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.brwer_acct_check_flg is '借款人账户检查标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.discnt_loan_type_cd is '贴现贷款类型代码';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.sig_distr_amt_ctrl_flg is '单次发放金额控制标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.sig_max_distr_amt is '单次最大发放金额';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.sig_min_distr_amt is '单次最小发放金额';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.loan_tenor_ctrl_flg is '贷款期限控制标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.lont_loan_mon_tenor is '最长贷款月期限';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.shortest_loan_mon_tenor is '最短贷款月期限';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.incremt_distr_apv_flg is '增量发放审批标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.sig_distr_flg is '单笔发放标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.distr_allow_apv_flg is '发放允许审批标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.subtn_deduct_flg is '持续扣款标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.auto_callbk_flg is '自动回收标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.repay_amt_ctrl_flg is '还款金额控制标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.adv_col_int_flg is '提前收息标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.int_rat_start_use_way_cd is '利率启用方式代码';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.int_rat_adj_ped_cd is '利率调整周期代码';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.int_rat_effect_way_cd is '利率生效方式代码';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.int_accr_flg is '计息标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.c_comp_int_flg is '收复利标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.c_pnlt_flg is '收罚息标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.c_pnlt_comp_int_flg is '收罚息的复利标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.c_comp_int_comp_int_flg is '收复利的复利标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.allow_renew_flg is '允许展期标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.max_renew_cnt is '最大展期次数';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.allow_soterm_flg is '允许缩期标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.max_soterm_cnt is '最大缩期次数';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.circl_flg is '循环标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.sel_sup_flg is '自营标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.asset_tran_flg is '资产转让标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.abs_flg is '资产证券化标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.log_and_base_cont_rela_type_cd is '保函与基础合同关系类型代码';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.log_attr_cd is '保函属性代码';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.log_advc_prod_id is '保函垫款产品编号';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.rela_margin_flg is '关联保证金标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.open_auto_froz_margin_flg is '开立时自动冻结保证金标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.retra_auto_unfrz_margin_flg is '收回时自动解冻保证金标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.exp_auto_unfrz_margin_flg is '到期自动解冻保证金标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.syn_loan_char_cd is '银团贷款性质代码';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.ovdue_soc_days is '逾期理赔天数';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.soc_ratio is '理赔比例';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.old_prod_id is '旧产品编号';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.new_prod_id is '新产品编号';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.new_prod_name is '新产品名称';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.prod_effect_dt is '产品生效日期';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.prod_invalid_dt is '产品失效日期';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.modif_dt is '变更日期';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_loan_prod_attach_info_h.etl_timestamp is 'ETL处理时间戳';
