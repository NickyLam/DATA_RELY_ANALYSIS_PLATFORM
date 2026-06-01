/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl abss_base_asset_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.abss_base_asset_info
whenever sqlerror continue none;
drop table ${idl_schema}.abss_base_asset_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.abss_base_asset_info(
    etl_dt date -- ETL处理日期
    ,asset_src_cd varchar2(60) -- 资产来源代码
    ,asset_id varchar2(60) -- 资产编号
    ,contr_id varchar2(60) -- 合同编号
    ,asst_type_cd varchar2(60) -- 资产类型代码
    ,prod_id varchar2(60) -- 产品编号
    ,prod_name varchar2(750) -- 产品名称
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,loan_tenor_mon number(22) -- 贷款期限（月）
    ,loan_tenor_day number(22) -- 贷款期限（天）
    ,loan_tot_perds number(22) -- 贷款总期数
    ,surp_perds number(22) -- 剩余期数
    ,repay_way_cd varchar2(10) -- 还款方式代码
    ,repay_ped_corp_cd varchar2(10) -- 还款周期单位代码
    ,curr_repaybl_dt date -- 当前应还款日期
    ,curr_cd varchar2(10) -- 币种代码
    ,loan_amt number(30,2) -- 贷款金额
    ,loan_bal number(30,2) -- 贷款余额
    ,ovdue_pric_bal number(30,2) -- 逾期本金余额
    ,fir_ovdue_dt date -- 首次逾期日期
    ,curr_ovdue_days number(22) -- 当前逾期天数
    ,int_ovdue_days number(22) -- 利息逾期天数
    ,curr_unexp_int number(30,2) -- 当前未到期利息（计提利息）
    ,in_bs_over_int_bal number(30,2) -- 表内欠息余额
    ,off_bs_over_int_bal number(30,2) -- 表外欠息余额
    ,pric_pnlt number(30,2) -- 本金罚息
    ,int_pnlt number(30,2) -- 利息罚息
    ,loan_level5_cls_cd varchar2(10) -- 贷款五级分类代码
    ,int_rat_type_cd varchar2(10) -- 利率类型代码
    ,exec_int_rat number(18,8) -- 执行利率
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,base_rat_type_cd varchar2(10) -- 基准利率类型代码
    ,base_rat number(18,8) -- 基准利率
    ,int_rat_float_way_cd varchar2(10) -- 利率浮动方式代码
    ,int_rat_flo_val number(18,8) -- 利率浮动值
    ,ovdue_int_rat_type_cd varchar2(10) -- 逾期利率类型代码
    ,ovdue_int_rat number(18,8) -- 逾期利率
    ,bond_item_rating_cd varchar2(10) -- 债项评级代码
    ,loan_repay_num varchar2(60) -- 贷款还款账号
    ,loan_acct_status_cd varchar2(30) -- 贷款账户状态代码
    ,loan_proc_dt date -- 贷款处理日期
    ,operr_id varchar2(60) -- 经办人编号
    ,oper_org_id varchar2(60) -- 经办机构编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,acct_instit_name varchar2(300) -- 账务机构名称
    ,cust_type_cd varchar2(20) -- 客户类型代码
    ,cust_id varchar2(60) -- 客户编号
    ,cust_name varchar2(375) -- 客户名称
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(500) -- 证件号码
    ,unify_soci_crdt_cd varchar2(30) -- 统一社会信用代码
    ,resdnt_addr varchar2(750) -- 常住地址
    ,brwer_crdt_lmt number(30,2) -- 借款人授信额度
    ,cust_ghb_loan_bal number(30,2) -- 客户在本行贷款余额
    ,ot_bank_loan_ovdue_perds number(22) -- 在其他银行贷款的历史最长逾期期数
    ,crdt_score varchar2(750) -- 信用评分
    ,cust_rating_cd varchar2(100) -- 客户评级代码
    ,gender_cd varchar2(10) -- 性别代码
    ,age number(22) -- 年龄
    ,nationty_cd varchar2(30) -- 民族代码
    ,birth_dt date -- 出生日期
    ,nation_cd varchar2(30) -- 国籍代码
    ,brwer_city_cd varchar2(45) -- 借款人所在城市（地级市）
    ,brwer_prov_cd varchar2(45) -- 借款人所在省份
    ,career_cd varchar2(100) -- 职业代码
    ,degree_cd varchar2(10) -- 学位代码
    ,edu_cd varchar2(10) -- 学历代码
    ,marriage_situ_cd varchar2(30) -- 婚姻状况代码
    ,family_addr varchar2(750) -- 家庭住址
    ,work_unit_name varchar2(750) -- 工作单位名称
    ,corp_bl_induty_type_cd varchar2(30) -- 单位所属行业类型代码
    ,indv_anl_inco number(30,2) -- 个人年收入
    ,ghb_emply_flg varchar2(10) -- 本行员工标志
    ,orgnz_cd varchar2(60) -- 组织机构代码
    ,econ_char_cd varchar2(10) -- 经济性质代码
    ,indus_cls_cd varchar2(10) -- 行业分类代码
    ,corp_size_cd varchar2(10) -- 企业规模代码
    ,list_corp_flg varchar2(10) -- 上市公司标志
    ,cty_rg_cd varchar2(10) -- 国家和地区代码
    ,rgst_addr varchar2(750) -- 注册地址
    ,group_cust_flg varchar2(10) -- 集团客户标志
    ,belong_group_name varchar2(150) -- 所属集团名称
    ,loan_happ_type_cd varchar2(30) -- 贷款发生类型代码
    ,cont_text_id varchar2(500) -- 合同文本编号
    ,cont_begin_dt date -- 合同起始日期
    ,cont_tenor_mon number(20) -- 合同期限（月）
    ,cont_exp_dt date -- 合同到期日期
    ,pm_rat number(18,8) -- 抵质押率
    ,cont_amt number(30,2) -- 合同金额
    ,actl_distrd_amt number(30,2) -- 实际已发放金额
    ,cont_bal number(30,2) -- 合同余额
    ,cont_nomal_bal number(30,2) -- 合同正常余额
    ,cont_ovdue_bal number(30,2) -- 合同逾期余额
    ,indus_dir_cd varchar2(10) -- 贷款投向行业代码
    ,circl_flg varchar2(10) -- 循环标志
    ,brw_new_return_old_cnt number(22) -- 借新还旧次数
    ,main_guar_way_cd varchar2(10) -- 主担保方式代码
    ,higt_lmt_guar_flg varchar2(10) -- 最高额担保标志
    ,loan_usage_type_cd varchar2(2000) -- 贷款用途类型代码
    ,renew_cnt number(22) -- 展期次数
    ,margin_ratio number(18,6) -- 保证金比例
    ,margin_amt number(30,2) -- 保证金金额
    ,dep_rcpt_amt number(30,2) -- 存单金额
    ,tbond_amt number(30,2) -- 国债金额
    ,finc_prod_amt number(38,8) -- 理财产品金额
    ,asset_tran_status_cd varchar2(10) -- 资产转让状态代码
    ,pkg_bf_int_recvbl_bal number(30,2) -- 封包前应收利息余额
    ,pkg_post_int_recvbl_tot number(30,2) -- 封包后应收利息总额
    ,pkg_post_int_recvbl_bal number(30,2) -- 封包后应收利息余额
    ,rtn_pkg_post_int_recvbl number(30,2) -- 已归还封包后应收利息
    ,tran_loan_int_tot number(30,2) -- 转让贷款利息总额
    ,int_recvbl number(30,2) -- 应收利息
    ,unrepay_int_fee_bal number(30,2) -- 未偿息费余额
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.abss_base_asset_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.abss_base_asset_info is '资产基本信息';
comment on column ${idl_schema}.abss_base_asset_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.abss_base_asset_info.asset_src_cd is '资产来源代码';
comment on column ${idl_schema}.abss_base_asset_info.asset_id is '资产编号';
comment on column ${idl_schema}.abss_base_asset_info.contr_id is '合同编号';
comment on column ${idl_schema}.abss_base_asset_info.asst_type_cd is '资产类型代码';
comment on column ${idl_schema}.abss_base_asset_info.prod_id is '产品编号';
comment on column ${idl_schema}.abss_base_asset_info.prod_name is '产品名称';
comment on column ${idl_schema}.abss_base_asset_info.value_dt is '起息日期';
comment on column ${idl_schema}.abss_base_asset_info.exp_dt is '到期日期';
comment on column ${idl_schema}.abss_base_asset_info.loan_tenor_mon is '贷款期限（月）';
comment on column ${idl_schema}.abss_base_asset_info.loan_tenor_day is '贷款期限（天）';
comment on column ${idl_schema}.abss_base_asset_info.loan_tot_perds is '贷款总期数';
comment on column ${idl_schema}.abss_base_asset_info.surp_perds is '剩余期数';
comment on column ${idl_schema}.abss_base_asset_info.repay_way_cd is '还款方式代码';
comment on column ${idl_schema}.abss_base_asset_info.repay_ped_corp_cd is '还款周期单位代码';
comment on column ${idl_schema}.abss_base_asset_info.curr_repaybl_dt is '当前应还款日期';
comment on column ${idl_schema}.abss_base_asset_info.curr_cd is '币种代码';
comment on column ${idl_schema}.abss_base_asset_info.loan_amt is '贷款金额';
comment on column ${idl_schema}.abss_base_asset_info.loan_bal is '贷款余额';
comment on column ${idl_schema}.abss_base_asset_info.ovdue_pric_bal is '逾期本金余额';
comment on column ${idl_schema}.abss_base_asset_info.fir_ovdue_dt is '首次逾期日期';
comment on column ${idl_schema}.abss_base_asset_info.curr_ovdue_days is '当前逾期天数';
comment on column ${idl_schema}.abss_base_asset_info.int_ovdue_days is '利息逾期天数';
comment on column ${idl_schema}.abss_base_asset_info.curr_unexp_int is '当前未到期利息（计提利息）';
comment on column ${idl_schema}.abss_base_asset_info.in_bs_over_int_bal is '表内欠息余额';
comment on column ${idl_schema}.abss_base_asset_info.off_bs_over_int_bal is '表外欠息余额';
comment on column ${idl_schema}.abss_base_asset_info.pric_pnlt is '本金罚息';
comment on column ${idl_schema}.abss_base_asset_info.int_pnlt is '利息罚息';
comment on column ${idl_schema}.abss_base_asset_info.loan_level5_cls_cd is '贷款五级分类代码';
comment on column ${idl_schema}.abss_base_asset_info.int_rat_type_cd is '利率类型代码';
comment on column ${idl_schema}.abss_base_asset_info.exec_int_rat is '执行利率';
comment on column ${idl_schema}.abss_base_asset_info.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${idl_schema}.abss_base_asset_info.base_rat_type_cd is '基准利率类型代码';
comment on column ${idl_schema}.abss_base_asset_info.base_rat is '基准利率';
comment on column ${idl_schema}.abss_base_asset_info.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${idl_schema}.abss_base_asset_info.int_rat_flo_val is '利率浮动值';
comment on column ${idl_schema}.abss_base_asset_info.ovdue_int_rat_type_cd is '逾期利率类型代码';
comment on column ${idl_schema}.abss_base_asset_info.ovdue_int_rat is '逾期利率';
comment on column ${idl_schema}.abss_base_asset_info.bond_item_rating_cd is '债项评级代码';
comment on column ${idl_schema}.abss_base_asset_info.loan_repay_num is '贷款还款账号';
comment on column ${idl_schema}.abss_base_asset_info.loan_acct_status_cd is '贷款账户状态代码';
comment on column ${idl_schema}.abss_base_asset_info.loan_proc_dt is '贷款处理日期';
comment on column ${idl_schema}.abss_base_asset_info.operr_id is '经办人编号';
comment on column ${idl_schema}.abss_base_asset_info.oper_org_id is '经办机构编号';
comment on column ${idl_schema}.abss_base_asset_info.acct_instit_id is '账务机构编号';
comment on column ${idl_schema}.abss_base_asset_info.acct_instit_name is '账务机构名称';
comment on column ${idl_schema}.abss_base_asset_info.cust_type_cd is '客户类型代码';
comment on column ${idl_schema}.abss_base_asset_info.cust_id is '客户编号';
comment on column ${idl_schema}.abss_base_asset_info.cust_name is '客户名称';
comment on column ${idl_schema}.abss_base_asset_info.cert_type_cd is '证件类型代码';
comment on column ${idl_schema}.abss_base_asset_info.cert_no is '证件号码';
comment on column ${idl_schema}.abss_base_asset_info.unify_soci_crdt_cd is '统一社会信用代码';
comment on column ${idl_schema}.abss_base_asset_info.resdnt_addr is '常住地址';
comment on column ${idl_schema}.abss_base_asset_info.brwer_crdt_lmt is '借款人授信额度';
comment on column ${idl_schema}.abss_base_asset_info.cust_ghb_loan_bal is '客户在本行贷款余额';
comment on column ${idl_schema}.abss_base_asset_info.ot_bank_loan_ovdue_perds is '在其他银行贷款的历史最长逾期期数';
comment on column ${idl_schema}.abss_base_asset_info.crdt_score is '信用评分';
comment on column ${idl_schema}.abss_base_asset_info.cust_rating_cd is '客户评级代码';
comment on column ${idl_schema}.abss_base_asset_info.gender_cd is '性别代码';
comment on column ${idl_schema}.abss_base_asset_info.age is '年龄';
comment on column ${idl_schema}.abss_base_asset_info.nationty_cd is '民族代码';
comment on column ${idl_schema}.abss_base_asset_info.birth_dt is '出生日期';
comment on column ${idl_schema}.abss_base_asset_info.nation_cd is '国籍代码';
comment on column ${idl_schema}.abss_base_asset_info.brwer_city_cd is '借款人所在城市（地级市）';
comment on column ${idl_schema}.abss_base_asset_info.brwer_prov_cd is '借款人所在省份';
comment on column ${idl_schema}.abss_base_asset_info.career_cd is '职业代码';
comment on column ${idl_schema}.abss_base_asset_info.degree_cd is '学位代码';
comment on column ${idl_schema}.abss_base_asset_info.edu_cd is '学历代码';
comment on column ${idl_schema}.abss_base_asset_info.marriage_situ_cd is '婚姻状况代码';
comment on column ${idl_schema}.abss_base_asset_info.family_addr is '家庭住址';
comment on column ${idl_schema}.abss_base_asset_info.work_unit_name is '工作单位名称';
comment on column ${idl_schema}.abss_base_asset_info.corp_bl_induty_type_cd is '单位所属行业类型代码';
comment on column ${idl_schema}.abss_base_asset_info.indv_anl_inco is '个人年收入';
comment on column ${idl_schema}.abss_base_asset_info.ghb_emply_flg is '本行员工标志';
comment on column ${idl_schema}.abss_base_asset_info.orgnz_cd is '组织机构代码';
comment on column ${idl_schema}.abss_base_asset_info.econ_char_cd is '经济性质代码';
comment on column ${idl_schema}.abss_base_asset_info.indus_cls_cd is '行业分类代码';
comment on column ${idl_schema}.abss_base_asset_info.corp_size_cd is '企业规模代码';
comment on column ${idl_schema}.abss_base_asset_info.list_corp_flg is '上市公司标志';
comment on column ${idl_schema}.abss_base_asset_info.cty_rg_cd is '国家和地区代码';
comment on column ${idl_schema}.abss_base_asset_info.rgst_addr is '注册地址';
comment on column ${idl_schema}.abss_base_asset_info.group_cust_flg is '集团客户标志';
comment on column ${idl_schema}.abss_base_asset_info.belong_group_name is '所属集团名称';
comment on column ${idl_schema}.abss_base_asset_info.loan_happ_type_cd is '贷款发生类型代码';
comment on column ${idl_schema}.abss_base_asset_info.cont_text_id is '合同文本编号';
comment on column ${idl_schema}.abss_base_asset_info.cont_begin_dt is '合同起始日期';
comment on column ${idl_schema}.abss_base_asset_info.cont_tenor_mon is '合同期限（月）';
comment on column ${idl_schema}.abss_base_asset_info.cont_exp_dt is '合同到期日期';
comment on column ${idl_schema}.abss_base_asset_info.pm_rat is '抵质押率';
comment on column ${idl_schema}.abss_base_asset_info.cont_amt is '合同金额';
comment on column ${idl_schema}.abss_base_asset_info.actl_distrd_amt is '实际已发放金额';
comment on column ${idl_schema}.abss_base_asset_info.cont_bal is '合同余额';
comment on column ${idl_schema}.abss_base_asset_info.cont_nomal_bal is '合同正常余额';
comment on column ${idl_schema}.abss_base_asset_info.cont_ovdue_bal is '合同逾期余额';
comment on column ${idl_schema}.abss_base_asset_info.indus_dir_cd is '贷款投向行业代码';
comment on column ${idl_schema}.abss_base_asset_info.circl_flg is '循环标志';
comment on column ${idl_schema}.abss_base_asset_info.brw_new_return_old_cnt is '借新还旧次数';
comment on column ${idl_schema}.abss_base_asset_info.main_guar_way_cd is '主担保方式代码';
comment on column ${idl_schema}.abss_base_asset_info.higt_lmt_guar_flg is '最高额担保标志';
comment on column ${idl_schema}.abss_base_asset_info.loan_usage_type_cd is '贷款用途类型代码';
comment on column ${idl_schema}.abss_base_asset_info.renew_cnt is '展期次数';
comment on column ${idl_schema}.abss_base_asset_info.margin_ratio is '保证金比例';
comment on column ${idl_schema}.abss_base_asset_info.margin_amt is '保证金金额';
comment on column ${idl_schema}.abss_base_asset_info.dep_rcpt_amt is '存单金额';
comment on column ${idl_schema}.abss_base_asset_info.tbond_amt is '国债金额';
comment on column ${idl_schema}.abss_base_asset_info.finc_prod_amt is '理财产品金额';
comment on column ${idl_schema}.abss_base_asset_info.asset_tran_status_cd is '资产转让状态代码';
comment on column ${idl_schema}.abss_base_asset_info.pkg_bf_int_recvbl_bal is '封包前应收利息余额';
comment on column ${idl_schema}.abss_base_asset_info.pkg_post_int_recvbl_tot is '封包后应收利息总额';
comment on column ${idl_schema}.abss_base_asset_info.pkg_post_int_recvbl_bal is '封包后应收利息余额';
comment on column ${idl_schema}.abss_base_asset_info.rtn_pkg_post_int_recvbl is '已归还封包后应收利息';
comment on column ${idl_schema}.abss_base_asset_info.tran_loan_int_tot is '转让贷款利息总额';
comment on column ${idl_schema}.abss_base_asset_info.int_recvbl is '应收利息';
comment on column ${idl_schema}.abss_base_asset_info.unrepay_int_fee_bal is '未偿息费余额';
comment on column ${idl_schema}.abss_base_asset_info.job_cd is '任务代码';
comment on column ${idl_schema}.abss_base_asset_info.etl_timestamp is 'ETL处理时间戳';