/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_dubil_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_dubil_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_dubil_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_dubil_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,rela_out_acct_flow_num varchar2(100) -- 关联出账流水号
    ,rela_cont_id varchar2(100) -- 关联合同编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,prod_id varchar2(100) -- 产品编号
    ,sub_prod_id varchar2(100) -- 子产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,loan_status_cd varchar2(60) -- 贷款状态代码
    ,loan_distr_type_cd varchar2(30) -- 贷款发放类型代码
    ,distr_dt date -- 发放日期
    ,enter_id varchar2(100) -- 卡号
    ,actl_amt number(30,8) -- 实付金额
    ,dubil_status_cd varchar2(30) -- 借据状态代码
    ,dubil_amt number(30,6) -- 借据金额
    ,loan_tot_perds number(10) -- 贷款总期数
    ,surp_repay_perds number(10) -- 剩余还款期数
    ,mon_tenor number(22) -- 月期限
    ,day_tenor number(22) -- 日期限
    ,apot_exp_dt date -- 约定到期日期
    ,actl_exp_dt date -- 实际到期日期
    ,int_rat_mode_cd varchar2(30) -- 利率模式代码
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,base_rat number(18,8) -- 基准利率
    ,ncb_base_rat_type_cd varchar2(30) -- 核心基准利率类型代码
    ,int_rat_float_type_cd varchar2(30) -- 利率浮动类型代码
    ,exec_year_int_rat number(18,8) -- 执行年利率
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,int_rat_adj_ped_cd varchar2(30) -- 利率调整周期代码
    ,int_rat_float_range number(30,8) -- 利率浮动幅度
    ,int_rat_float_way_cd varchar2(30) -- 利率浮动方式代码
    ,int_rat_start_use_way_cd varchar2(30) -- 利率启用方式代码
    ,int_rat_modif_ped_cd varchar2(30) -- 利率变更周期代码
    ,float_point number(18,8) -- 浮动百分点
    ,main_guar_way_cd varchar2(30) -- 主担保方式代码
    ,guar_way_cd_two varchar2(30) -- 担保方式代码二
    ,guar_way_cd_three varchar2(30) -- 担保方式代码三
    ,margin_ratio number(18,6) -- 保证金比例
    ,margin_amt number(30,2) -- 保证金金额
    ,margin_acct_id varchar2(100) -- 保证金账户编号
    ,distr_mode_pay_cd varchar2(30) -- 放款支付方式代码
    ,distr_acct_id varchar2(100) -- 放款账户编号
    ,distr_acct_name varchar2(500) -- 放款账户名称
    ,enter_open_acct_org_id varchar2(100) -- 入账账户开户机构编号
    ,out_acct_org_id varchar2(100) -- 出账机构编号
    ,rela_pay_appl_form_id varchar2(100) -- 关联付款申请书编号
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,deflt_repay_day number(22) -- 默认还款日
    ,repay_ped varchar2(10) -- 还款周期
    ,repay_ped_cd varchar2(30) -- 还款周期单位代码
    ,dep_lon_int_set_day date -- 存贷结息日
    ,renew_cnt number(22) -- 展期次数
    ,repay_acct_id varchar2(250) -- 还款账户编号
    ,repay_acct_name varchar2(500) -- 还款账户名称
    ,repay_num_bal number(30,6) -- 还款账号余额
    ,repay_num_aval_bal number(30,6) -- 还款账户可用余额
    ,nomal_bal number(30,2) -- 正常余额
    ,pric_bal number(30,8) -- 本金余额
    ,int_bal number(30,8) -- 利息余额
    ,ibank_sys_pric_bal number(30,8) -- 同业系统本金余额
    ,comp_int_bal number(30,2) -- 复息余额
    ,file_int_accr_flg varchar2(10) -- 靠档计息标志
    ,int_accr_flg varchar2(10) -- 计息标志
    ,acru_int number(30,8) -- 应计利息
    ,acru_pnlt number(30,8) -- 应计罚息
    ,acru_comp_int number(30,8) -- 应计复息
    ,recvbl_uncol_comp_int number(30,8) -- 应收未收复息
    ,non_acru_bal number(30,8) -- 非应计余额
    ,advc_flg varchar2(10) -- 垫款标志
    ,happ_dt date -- 垫款日期
    ,curr_bal number(30,2) -- 垫款余额
    ,comp_amt number(30,8) -- 代偿金额
    ,loan_grace_period number(22) -- 贷款宽限期天数
    ,grace_period_type_cd varchar2(30) -- 宽限期类型代码
    ,grace_exp_dt date -- 宽限到期日期
    ,grace_begin_dt date -- 宽限起始日期
    ,ovdue_cnt number(22) -- 逾期次数
    ,fir_ovdue_dt date -- 首次逾期日期
    ,conti_ovdue_dt date -- 连续逾期日期
    ,ovdue_dt date -- 逾期日期
    ,loan_ovdue_days number(22) -- 贷款逾期天数
    ,ovdue_bal number(30,2) -- 逾期本金
    ,pric_ovdue_days number(22) -- 本金逾期天数
    ,pric_ovdue_amt number(30,8) -- 本金逾期金额
    ,pric_ovdue_fst_dt date -- 本金最早逾期日期
    ,int_ovdue_days number(22) -- 利息逾期天数
    ,int_ovdue_amt number(30,8) -- 利息逾期金额
    ,int_ovdue_fst_dt date -- 利息最早逾期日期
    ,pnlt_flg varchar2(10) -- 罚息标志
    ,ovdue_pnlt_bal number(30,2) -- 逾期罚息余额
    ,ovdue_int_rat number(18,8) -- 逾期利率
    ,ovdue_int_rat_float_way_cd varchar2(30) -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val number(18,6) -- 逾期利率浮动值
    ,over_int_dt date -- 欠息日期
    ,over_int_days number(22) -- 欠息天数
    ,recvbl_over_int number(30,8) -- 应收欠息
    ,recvbl_pnlt number(30,8) -- 应收罚息
    ,recvbl_uncol_pnlt number(30,8) -- 应收未收罚息
    ,comp_int_flg varchar2(10) -- 复利标志
    ,coll_over_int number(30,8) -- 催收欠息
    ,coll_pnlt number(30,8) -- 催收罚息
    ,coll_acru_int number(30,8) -- 催收应计利息
    ,coll_acru_pnlt number(30,8) -- 催收应计罚息
    ,acm_rtn_pric number(30,8) -- 累计归还本金
    ,acm_rtn_int number(30,8) -- 累计归还利息
    ,in_bs_over_int_bal number(30,2) -- 表内欠息余额
    ,off_bs_flg varchar2(10) -- 表外标志
    ,off_bs_over_int_bal number(30,2) -- 表外欠息余额
    ,idle_bal number(30,2) -- 呆滞余额
    ,bad_debt_bal number(30,2) -- 呆账余额
    ,accti_org_id varchar2(100) -- 核算机构编号
    ,provi_resv_lmt number(30,2) -- 计提准备金额
    ,pre_loss_amt number(30,2) -- 预测损失金额
    ,move_remark varchar2(500) -- 迁移备注
    ,refac_loan_idf_cd varchar2(10) -- 支小再贷款标识代码
    ,spcl_refac_idf_cd varchar2(30) -- 专项再贷款标识代码
    ,init_bus_id varchar2(100) -- 原业务编号
    ,init_dubil_id varchar2(100) -- 原始借据编号
    ,init_loan_exp_dt date -- 原贷款到期日期
    ,old_cust_id varchar2(100) -- 旧客户编号
    ,old_prod_id varchar2(100) -- 旧产品编号
    ,next_int_set_dt date -- 下一结息日期
    ,prob_asset_flg varchar2(10) -- 问题资产标志
    ,fir_idtfy_non_dt date -- 首次认定不良日期
    ,regroup_loan_flg varchar2(10) -- 重组贷款标志
    ,regroup_dt date -- 重组日期
    ,regroup_loan_type_cd varchar2(30) -- 重组贷款类型代码
    ,stl_acct_open_bank_num varchar2(60) -- 结算账户开户行号
    ,stl_acct_seq_num varchar2(60) -- 结算账户序号
    ,bad_debt_wrt_off_status_cd varchar2(30) -- 呆账核销状态代码
    ,wrt_off_dt date -- 核销日期
    ,wrt_off_pric number(30,8) -- 核销本金
    ,wrt_off_int number(30,8) -- 核销利息
    ,wrt_off_callbk_amt number(30,8) -- 核销回收金额
    ,revs_flg varchar2(10) -- 冲正标志
    ,termnt_dt date -- 终止日期
    ,belong_strip_line_cd varchar2(30) -- 所属条线代码
    ,risk_monit_rela_flow_num varchar2(100) -- 风险监测关联流水号
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,level5_cls_cd varchar2(30) -- 五级分类代码
    ,level5_cls_dt date -- 五级分类日期
    ,level11_cls_cd varchar2(30) -- 十一级分类代码
    ,level11_cls_dt date -- 十一级分类日期
    ,low_risk_flg varchar2(10) -- 低风险标志
    ,level10_cls_manu_med_flg varchar2(10) -- 十级分类人工干预标志
    ,last_level10_cls_cd varchar2(30) -- 上一十级分类代码
    ,last_level10_cls_dt date -- 上一十级分类日期
    ,last_level5_cls_cd varchar2(30) -- 上一五级分类代码
    ,last_level5_cls_cmplt_dt date -- 上一五级分类完成日期
    ,last_term_level5_cls_modif_dt date -- 上一期五级分类变更日期
    ,abs_flg varchar2(10) -- 资产证券化标志
    ,cred_rht_advise_cfmed_flg varchar2(10) -- 债权通知书已确认标志
    ,provi_for_aged_property_flg varchar2(10) -- 养老产业标志
    ,prft_cut_amt number(30,8) -- 分润金额
    ,oper_dt date -- 经办日期
    ,bus_oper_teller_id varchar2(100) -- 业务经办人编号
    ,oper_org_id varchar2(100) -- 经办机构编号
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
grant select on ${iml_schema}.agt_loan_dubil_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_dubil_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_dubil_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_dubil_info_h is '贷款借据信息历史';
comment on column ${iml_schema}.agt_loan_dubil_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.rela_out_acct_flow_num is '关联出账流水号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.rela_cont_id is '关联合同编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_loan_dubil_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.sub_prod_id is '子产品编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.loan_status_cd is '贷款状态代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.loan_distr_type_cd is '贷款发放类型代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.distr_dt is '发放日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.enter_id is '卡号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.actl_amt is '实付金额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.dubil_status_cd is '借据状态代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.dubil_amt is '借据金额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.loan_tot_perds is '贷款总期数';
comment on column ${iml_schema}.agt_loan_dubil_info_h.surp_repay_perds is '剩余还款期数';
comment on column ${iml_schema}.agt_loan_dubil_info_h.mon_tenor is '月期限';
comment on column ${iml_schema}.agt_loan_dubil_info_h.day_tenor is '日期限';
comment on column ${iml_schema}.agt_loan_dubil_info_h.apot_exp_dt is '约定到期日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.actl_exp_dt is '实际到期日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.int_rat_mode_cd is '利率模式代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.base_rat is '基准利率';
comment on column ${iml_schema}.agt_loan_dubil_info_h.ncb_base_rat_type_cd is '核心基准利率类型代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.int_rat_float_type_cd is '利率浮动类型代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.exec_year_int_rat is '执行年利率';
comment on column ${iml_schema}.agt_loan_dubil_info_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.int_rat_adj_ped_cd is '利率调整周期代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.int_rat_float_range is '利率浮动幅度';
comment on column ${iml_schema}.agt_loan_dubil_info_h.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.int_rat_start_use_way_cd is '利率启用方式代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.int_rat_modif_ped_cd is '利率变更周期代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.float_point is '浮动百分点';
comment on column ${iml_schema}.agt_loan_dubil_info_h.main_guar_way_cd is '主担保方式代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.guar_way_cd_two is '担保方式代码二';
comment on column ${iml_schema}.agt_loan_dubil_info_h.guar_way_cd_three is '担保方式代码三';
comment on column ${iml_schema}.agt_loan_dubil_info_h.margin_ratio is '保证金比例';
comment on column ${iml_schema}.agt_loan_dubil_info_h.margin_amt is '保证金金额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.margin_acct_id is '保证金账户编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.distr_mode_pay_cd is '放款支付方式代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.distr_acct_id is '放款账户编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.distr_acct_name is '放款账户名称';
comment on column ${iml_schema}.agt_loan_dubil_info_h.enter_open_acct_org_id is '入账账户开户机构编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.out_acct_org_id is '出账机构编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.rela_pay_appl_form_id is '关联付款申请书编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.deflt_repay_day is '默认还款日';
comment on column ${iml_schema}.agt_loan_dubil_info_h.repay_ped is '还款周期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.repay_ped_cd is '还款周期单位代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.dep_lon_int_set_day is '存贷结息日';
comment on column ${iml_schema}.agt_loan_dubil_info_h.renew_cnt is '展期次数';
comment on column ${iml_schema}.agt_loan_dubil_info_h.repay_acct_id is '还款账户编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.repay_acct_name is '还款账户名称';
comment on column ${iml_schema}.agt_loan_dubil_info_h.repay_num_bal is '还款账号余额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.repay_num_aval_bal is '还款账户可用余额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.nomal_bal is '正常余额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.pric_bal is '本金余额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.int_bal is '利息余额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.ibank_sys_pric_bal is '同业系统本金余额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.comp_int_bal is '复息余额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.file_int_accr_flg is '靠档计息标志';
comment on column ${iml_schema}.agt_loan_dubil_info_h.int_accr_flg is '计息标志';
comment on column ${iml_schema}.agt_loan_dubil_info_h.acru_int is '应计利息';
comment on column ${iml_schema}.agt_loan_dubil_info_h.acru_pnlt is '应计罚息';
comment on column ${iml_schema}.agt_loan_dubil_info_h.acru_comp_int is '应计复息';
comment on column ${iml_schema}.agt_loan_dubil_info_h.recvbl_uncol_comp_int is '应收未收复息';
comment on column ${iml_schema}.agt_loan_dubil_info_h.non_acru_bal is '非应计余额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.advc_flg is '垫款标志';
comment on column ${iml_schema}.agt_loan_dubil_info_h.happ_dt is '垫款日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.curr_bal is '垫款余额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.comp_amt is '代偿金额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.loan_grace_period is '贷款宽限期天数';
comment on column ${iml_schema}.agt_loan_dubil_info_h.grace_period_type_cd is '宽限期类型代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.grace_exp_dt is '宽限到期日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.grace_begin_dt is '宽限起始日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.ovdue_cnt is '逾期次数';
comment on column ${iml_schema}.agt_loan_dubil_info_h.fir_ovdue_dt is '首次逾期日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.conti_ovdue_dt is '连续逾期日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.ovdue_dt is '逾期日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.loan_ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.agt_loan_dubil_info_h.ovdue_bal is '逾期本金';
comment on column ${iml_schema}.agt_loan_dubil_info_h.pric_ovdue_days is '本金逾期天数';
comment on column ${iml_schema}.agt_loan_dubil_info_h.pric_ovdue_amt is '本金逾期金额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.pric_ovdue_fst_dt is '本金最早逾期日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.int_ovdue_days is '利息逾期天数';
comment on column ${iml_schema}.agt_loan_dubil_info_h.int_ovdue_amt is '利息逾期金额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.int_ovdue_fst_dt is '利息最早逾期日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.pnlt_flg is '罚息标志';
comment on column ${iml_schema}.agt_loan_dubil_info_h.ovdue_pnlt_bal is '逾期罚息余额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.ovdue_int_rat is '逾期利率';
comment on column ${iml_schema}.agt_loan_dubil_info_h.ovdue_int_rat_float_way_cd is '逾期利率浮动方式代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.ovdue_int_rat_flo_val is '逾期利率浮动值';
comment on column ${iml_schema}.agt_loan_dubil_info_h.over_int_dt is '欠息日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.over_int_days is '欠息天数';
comment on column ${iml_schema}.agt_loan_dubil_info_h.recvbl_over_int is '应收欠息';
comment on column ${iml_schema}.agt_loan_dubil_info_h.recvbl_pnlt is '应收罚息';
comment on column ${iml_schema}.agt_loan_dubil_info_h.recvbl_uncol_pnlt is '应收未收罚息';
comment on column ${iml_schema}.agt_loan_dubil_info_h.comp_int_flg is '复利标志';
comment on column ${iml_schema}.agt_loan_dubil_info_h.coll_over_int is '催收欠息';
comment on column ${iml_schema}.agt_loan_dubil_info_h.coll_pnlt is '催收罚息';
comment on column ${iml_schema}.agt_loan_dubil_info_h.coll_acru_int is '催收应计利息';
comment on column ${iml_schema}.agt_loan_dubil_info_h.coll_acru_pnlt is '催收应计罚息';
comment on column ${iml_schema}.agt_loan_dubil_info_h.acm_rtn_pric is '累计归还本金';
comment on column ${iml_schema}.agt_loan_dubil_info_h.acm_rtn_int is '累计归还利息';
comment on column ${iml_schema}.agt_loan_dubil_info_h.in_bs_over_int_bal is '表内欠息余额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.off_bs_flg is '表外标志';
comment on column ${iml_schema}.agt_loan_dubil_info_h.off_bs_over_int_bal is '表外欠息余额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.idle_bal is '呆滞余额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.bad_debt_bal is '呆账余额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.accti_org_id is '核算机构编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.provi_resv_lmt is '计提准备金额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.pre_loss_amt is '预测损失金额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.move_remark is '迁移备注';
comment on column ${iml_schema}.agt_loan_dubil_info_h.refac_loan_idf_cd is '支小再贷款标识代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.spcl_refac_idf_cd is '专项再贷款标识代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.init_bus_id is '原业务编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.init_dubil_id is '原始借据编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.init_loan_exp_dt is '原贷款到期日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.old_cust_id is '旧客户编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.old_prod_id is '旧产品编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.next_int_set_dt is '下一结息日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.prob_asset_flg is '问题资产标志';
comment on column ${iml_schema}.agt_loan_dubil_info_h.fir_idtfy_non_dt is '首次认定不良日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.regroup_loan_flg is '重组贷款标志';
comment on column ${iml_schema}.agt_loan_dubil_info_h.regroup_dt is '重组日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.regroup_loan_type_cd is '重组贷款类型代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.stl_acct_open_bank_num is '结算账户开户行号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.stl_acct_seq_num is '结算账户序号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.bad_debt_wrt_off_status_cd is '呆账核销状态代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.wrt_off_dt is '核销日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.wrt_off_pric is '核销本金';
comment on column ${iml_schema}.agt_loan_dubil_info_h.wrt_off_int is '核销利息';
comment on column ${iml_schema}.agt_loan_dubil_info_h.wrt_off_callbk_amt is '核销回收金额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.revs_flg is '冲正标志';
comment on column ${iml_schema}.agt_loan_dubil_info_h.termnt_dt is '终止日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.belong_strip_line_cd is '所属条线代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.risk_monit_rela_flow_num is '风险监测关联流水号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.asset_thd_cls_cd is '资产三分类代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.level5_cls_dt is '五级分类日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.level11_cls_cd is '十一级分类代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.level11_cls_dt is '十一级分类日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.low_risk_flg is '低风险标志';
comment on column ${iml_schema}.agt_loan_dubil_info_h.level10_cls_manu_med_flg is '十级分类人工干预标志';
comment on column ${iml_schema}.agt_loan_dubil_info_h.last_level10_cls_cd is '上一十级分类代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.last_level10_cls_dt is '上一十级分类日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.last_level5_cls_cd is '上一五级分类代码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.last_level5_cls_cmplt_dt is '上一五级分类完成日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.last_term_level5_cls_modif_dt is '上一期五级分类变更日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.abs_flg is '资产证券化标志';
comment on column ${iml_schema}.agt_loan_dubil_info_h.cred_rht_advise_cfmed_flg is '债权通知书已确认标志';
comment on column ${iml_schema}.agt_loan_dubil_info_h.provi_for_aged_property_flg is '养老产业标志';
comment on column ${iml_schema}.agt_loan_dubil_info_h.prft_cut_amt is '分润金额';
comment on column ${iml_schema}.agt_loan_dubil_info_h.oper_dt is '经办日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.bus_oper_teller_id is '业务经办人编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.oper_org_id is '经办机构编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_loan_dubil_info_h.modif_dt is '变更日期';
comment on column ${iml_schema}.agt_loan_dubil_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_dubil_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_dubil_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_dubil_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_dubil_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_dubil_info_h.etl_timestamp is 'ETL处理时间戳';
