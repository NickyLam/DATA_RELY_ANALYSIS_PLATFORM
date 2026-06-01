/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_cont_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_cont_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_cont_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_cont_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,cont_id varchar2(100) -- 合同编号
    ,apv_flow_num varchar2(100) -- 审批流水号
    ,rela_cont_id varchar2(100) -- 关联合同编号
    ,text_cont_id varchar2(500) -- 文本合同编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,lmt_cont_flg varchar2(10) -- 额度合同标志
    ,rela_old_cont_id varchar2(100) -- 关联旧合同编号
    ,appl_way_cd varchar2(30) -- 申请方式代码
    ,loan_distr_type_cd varchar2(30) -- 贷款发放类型代码
    ,distr_mode_pay_cd varchar2(30) -- 放款支付方式代码
    ,happ_dt date -- 发生日期
    ,curr_cd varchar2(30) -- 币种代码
    ,cont_amt number(30,2) -- 合同金额
    ,actl_out_acct_amt number(30,2) -- 实际出账金额
    ,out_acct_dt date -- 出账日期
    ,base_prod_id varchar2(100) -- 基础产品编号
    ,prod_id varchar2(100) -- 产品编号
    ,mon_tenor number(22) -- 月期限
    ,day_tenor number(22) -- 日期限
    ,cont_effect_dt date -- 合同生效日期
    ,cont_exp_dt date -- 合同到期日期
    ,lmt_circl_flg varchar2(10) -- 循环贷款标志
    ,risk_type_cd varchar2(30) -- 风险类型代码
    ,low_risk_bus_flg varchar2(10) -- 低风险业务标志
    ,remote_bus_flg varchar2(10) -- 异地业务标志
    ,int_rat_mode_cd varchar2(30) -- 利率模式代码
    ,fix_int_rat number(18,8) -- 固定利率
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,base_rat number(18,8) -- 基准利率
    ,int_rat_float_type_cd varchar2(30) -- 利率浮动类型代码
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,int_rat_flo_val number(18,6) -- 利率浮动值
    ,exec_int_rat number(18,8) -- 执行利率
    ,main_guar_way_cd varchar2(30) -- 主担保方式代码
    ,supp_guar_way_flg varchar2(10) -- 追加担保方式标志
    ,other_cond_descb varchar2(1000) -- 其他条件描述
    ,guar_way_cd_two varchar2(30) -- 担保方式代码二
    ,guar_way_cd_three varchar2(30) -- 担保方式代码三
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,sub_guar_way_cd varchar2(100) -- 子担保方式代码
    ,repay_ped varchar2(10) -- 还款周期
    ,repay_ped_cd varchar2(30) -- 还款周期单位代码
    ,deflt_repay_day number(22) -- 默认还款日
    ,stl_acct_id varchar2(100) -- 结算账户编号
    ,crdt_dir_cd varchar2(30) -- 授信投向代码
    ,nat_std_indus_dir_cd varchar2(30) -- 国标行业投向代码
    ,bank_int_indus_dir_cd varchar2(30) -- 行内行业投向代码
    ,usage_descb varchar2(1000) -- 用途描述
    ,data_input_integy_flg varchar2(10) -- 数据录入已完善标志
    ,rsrv_amt number(30,2) -- 预留金额
    ,curr_bal number(30,2) -- 当前余额
    ,nomal_bal number(30,2) -- 正常余额
    ,loan_ovdue_amt number(30,2) -- 贷款逾期金额
    ,idle_bal number(30,2) -- 呆滞余额
    ,bad_debt_bal number(30,2) -- 呆账余额
    ,in_bs_over_int_bal number(30,2) -- 表内欠息余额
    ,off_bs_over_int_bal number(30,2) -- 表外欠息余额
    ,ovdue_pnlt_bal number(30,2) -- 逾期罚息余额
    ,comp_int_bal number(30,2) -- 复息余额
    ,loan_ovdue_days number(22) -- 贷款逾期天数
    ,over_int_days number(22) -- 欠息天数
    ,wrt_off_pric number(30,2) -- 核销本金
    ,wrt_off_int number(30,2) -- 核销利息
    ,pre_loss_amt number(30,2) -- 预测损失金额
    ,fir_idtfy_non_dt date -- 首次认定不良日期
    ,cont_status_cd varchar2(30) -- 合同状态代码
    ,effect_dt date -- 生效日期
    ,termnt_dt date -- 终止日期
    ,payoff_flg varchar2(10) -- 结清标志
    ,off_bs_flg varchar2(10) -- 表外标志
    ,onl_bus_flg varchar2(10) -- 线上业务标志
    ,belong_strip_line_cd varchar2(30) -- 所属条线代码
    ,apv_status_cd varchar2(30) -- 审批状态代码
    ,lmt_id varchar2(100) -- 额度编号
    ,oper_teller_id varchar2(100) -- 业务经办人编号
    ,oper_org_id varchar2(100) -- 经办机构编号
    ,oper_dt date -- 经办日期
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,modif_dt date -- 变更日期
    ,spec_ped_corp_cd varchar2(30) -- 指定周期单位代码
    ,spec_ped_cd varchar2(30) -- 指定周期代码
    ,b_renew_exp_dt date -- 展期前到期日期
    ,b_renew_amt number(30,2) -- 展期前金额
    ,b_renew_exec_year_int_rat number(18,8) -- 展期前执行年利率
    ,hxb_rela_party_flg varchar2(10) -- 我行关联方标志
    ,loan_usage_cd varchar2(30) -- 贷款用途代码
    ,int_rat_adj_ped_cd varchar2(30) -- 利率调整周期代码
    ,lmt_open_amt number(30,2) -- 额度敞口金额
    ,occu_lmt number(30,2) -- 已占用额度
    ,margin_curr_cd varchar2(30) -- 保证金币种代码
    ,margin_ratio number(18,6) -- 保证金比例
    ,margin_amt number(30,2) -- 保证金金额
    ,open_amt number(30,2) -- 敞口金额
    ,open_amt_stat number(30,6) -- 敞口金额统计
    ,lmt_cont_id varchar2(100) -- 额度合同编号
    ,exec_mon_int_rat number(18,8) -- 执行月利率
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,level5_cls_cd varchar2(30) -- 五级分类代码
    ,level5_cls_dt date -- 五级分类日期
    ,level11_cls_cd varchar2(30) -- 十一级分类代码
    ,lon_post_mgmt_teller_id varchar2(100) -- 贷后管理柜员编号
    ,lon_post_mgmt_org_id varchar2(100) -- 贷后管理机构编号
    ,file_dt date -- 归档日期
    ,froz_flg varchar2(10) -- 冻结状态代码
    ,ovdue_exec_int_rat number(18,8) -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd varchar2(30) -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val number(22,0) -- 逾期利率浮动值
    ,core_out_acct_org_id varchar2(100) -- 核心出账机构编号
    ,stl_acct_name varchar2(500) -- 结算账户名称
    ,enter_id varchar2(100) -- 入账账户编号
    ,enter_name varchar2(500) -- 入账账户名称
    ,enter_open_acct_org_id varchar2(100) -- 入账账户开户机构编号
    ,backup_status_cd varchar2(30) -- 备份状态代码
    ,backup_lmt_cont_id varchar2(100) -- 备份额度合同编号
    ,comm_fee_rat number(30,6) -- 手续费率
    ,move_remark varchar2(500) -- 迁移备注
    ,strtg_new_indus_type_cd varchar2(30) -- 战略新兴产业类型代码
    ,high_new_tech_corp_flg varchar2(10) -- 高新技术企业标志
    ,scen_tech_corp_flg varchar2(10) -- 科技企业标志
    ,tech_inovt_corp_flg varchar2(10) -- 科创企业标志
    ,xxd_camp_lmt_flg varchar2(10) -- 新兴贷营销额度标志
    ,provi_for_aged_property_flg varchar2(10) -- 养老产业标志
    ,seed_loan_flg varchar2(10) -- 种业振兴贷款标志
    ,county_loan_flg varchar2(10) -- 县城城区贷款标志
    ,high_tech_property_flg varchar2(10) -- 投向高技术产业标志
    ,digit_econ_core_type_cd varchar2(30) -- 数字经济核心产业类型代码
    ,remark varchar2(4000) -- 备注
    ,prod_gen_id varchar2(100) -- 产品大类编号
    ,tran_bf_prod_id varchar2(100) -- 转换前产品编号
    ,tran_bf_cust_id varchar2(100) -- 转换前客户编号
    ,attach_rgst_bus_type_cd varchar2(30) -- 补登业务类型代码
    ,margin_acct_id varchar2(100) -- 保证金账户编号
    ,margin_tran_out_acct_id varchar2(100) -- 保证金转出账户编号
    ,update_cnt number(30) -- 更新次数
    ,dubil_id varchar2(100) -- 借据编号
    ,sign_lmt_cont_flg varchar2(10) -- 签订额度合同标志
    ,sign_paper_cont_flg varchar2(10) -- 签署纸质合同标志
    ,comm_fee_amt number(30,8) -- 手续费金额
    ,crdt_apv_aval_amt number(30,8) -- 信贷审批可用金额
    ,b_renew_cont_id varchar2(100) -- 展期前合同编号
    ,ocup_open_lmt_risk_type_cd varchar2(30) -- 占用敞口额度风险类型代码
    ,ocup_o_use_lmt_flg varchar2(10) -- 占用他用额度标志
    ,risk_mgmt_apv_aval_amt number(30,8) -- 风控审批可用金额
    ,ifc_cnt_tot_apv_aval_amt number(30,8) -- IFC数总审批可用金额
    ,ifc_apved_lmt_cont_amt number(30,8) -- IFC审批后额度合同金额
    ,regroup_loan_flg varchar2(10) -- 重组贷款标志
    ,only_new_minorent_flg varchar2(10) -- 专精特新小巨人企业标志
    ,only_new_littlegiantent_flg varchar2(10) -- 专精特新中小企业标志
    ,indent_tech_flg varchar2(10) -- 工业企业技术改造升级标志
    ,cul_property_flg varchar2(10) -- 文化产业标志
    ,advanced_manu_flg varchar2(10) -- 先进制造业标志
    ,auto_que_lon_post_rept_flg varchar2(10) -- 自动查询贷后报告标志
    ,buss_tiket_recs_flg varchar2(10) -- 商票保贴追索标志
    ,discnter_margin_acct_flg varchar2(10) -- 贴现人保证金账户标志
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
grant select on ${iml_schema}.agt_loan_cont_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_cont_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_cont_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_cont_info_h is '贷款合同信息历史';
comment on column ${iml_schema}.agt_loan_cont_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.apv_flow_num is '审批流水号';
comment on column ${iml_schema}.agt_loan_cont_info_h.rela_cont_id is '关联合同编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.text_cont_id is '文本合同编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_loan_cont_info_h.lmt_cont_flg is '额度合同标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.rela_old_cont_id is '关联旧合同编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.appl_way_cd is '申请方式代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.loan_distr_type_cd is '贷款发放类型代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.distr_mode_pay_cd is '放款支付方式代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.happ_dt is '发生日期';
comment on column ${iml_schema}.agt_loan_cont_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.cont_amt is '合同金额';
comment on column ${iml_schema}.agt_loan_cont_info_h.actl_out_acct_amt is '实际出账金额';
comment on column ${iml_schema}.agt_loan_cont_info_h.out_acct_dt is '出账日期';
comment on column ${iml_schema}.agt_loan_cont_info_h.base_prod_id is '基础产品编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.mon_tenor is '月期限';
comment on column ${iml_schema}.agt_loan_cont_info_h.day_tenor is '日期限';
comment on column ${iml_schema}.agt_loan_cont_info_h.cont_effect_dt is '合同生效日期';
comment on column ${iml_schema}.agt_loan_cont_info_h.cont_exp_dt is '合同到期日期';
comment on column ${iml_schema}.agt_loan_cont_info_h.lmt_circl_flg is '循环贷款标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.risk_type_cd is '风险类型代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.low_risk_bus_flg is '低风险业务标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.remote_bus_flg is '异地业务标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.int_rat_mode_cd is '利率模式代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.fix_int_rat is '固定利率';
comment on column ${iml_schema}.agt_loan_cont_info_h.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.base_rat is '基准利率';
comment on column ${iml_schema}.agt_loan_cont_info_h.int_rat_float_type_cd is '利率浮动类型代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.int_rat_flo_val is '利率浮动值';
comment on column ${iml_schema}.agt_loan_cont_info_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_loan_cont_info_h.main_guar_way_cd is '主担保方式代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.supp_guar_way_flg is '追加担保方式标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.other_cond_descb is '其他条件描述';
comment on column ${iml_schema}.agt_loan_cont_info_h.guar_way_cd_two is '担保方式代码二';
comment on column ${iml_schema}.agt_loan_cont_info_h.guar_way_cd_three is '担保方式代码三';
comment on column ${iml_schema}.agt_loan_cont_info_h.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.sub_guar_way_cd is '子担保方式代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.repay_ped is '还款周期';
comment on column ${iml_schema}.agt_loan_cont_info_h.repay_ped_cd is '还款周期单位代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.deflt_repay_day is '默认还款日';
comment on column ${iml_schema}.agt_loan_cont_info_h.stl_acct_id is '结算账户编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.crdt_dir_cd is '授信投向代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.nat_std_indus_dir_cd is '国标行业投向代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.bank_int_indus_dir_cd is '行内行业投向代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.usage_descb is '用途描述';
comment on column ${iml_schema}.agt_loan_cont_info_h.data_input_integy_flg is '数据录入已完善标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.rsrv_amt is '预留金额';
comment on column ${iml_schema}.agt_loan_cont_info_h.curr_bal is '当前余额';
comment on column ${iml_schema}.agt_loan_cont_info_h.nomal_bal is '正常余额';
comment on column ${iml_schema}.agt_loan_cont_info_h.loan_ovdue_amt is '贷款逾期金额';
comment on column ${iml_schema}.agt_loan_cont_info_h.idle_bal is '呆滞余额';
comment on column ${iml_schema}.agt_loan_cont_info_h.bad_debt_bal is '呆账余额';
comment on column ${iml_schema}.agt_loan_cont_info_h.in_bs_over_int_bal is '表内欠息余额';
comment on column ${iml_schema}.agt_loan_cont_info_h.off_bs_over_int_bal is '表外欠息余额';
comment on column ${iml_schema}.agt_loan_cont_info_h.ovdue_pnlt_bal is '逾期罚息余额';
comment on column ${iml_schema}.agt_loan_cont_info_h.comp_int_bal is '复息余额';
comment on column ${iml_schema}.agt_loan_cont_info_h.loan_ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.agt_loan_cont_info_h.over_int_days is '欠息天数';
comment on column ${iml_schema}.agt_loan_cont_info_h.wrt_off_pric is '核销本金';
comment on column ${iml_schema}.agt_loan_cont_info_h.wrt_off_int is '核销利息';
comment on column ${iml_schema}.agt_loan_cont_info_h.pre_loss_amt is '预测损失金额';
comment on column ${iml_schema}.agt_loan_cont_info_h.fir_idtfy_non_dt is '首次认定不良日期';
comment on column ${iml_schema}.agt_loan_cont_info_h.cont_status_cd is '合同状态代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_loan_cont_info_h.termnt_dt is '终止日期';
comment on column ${iml_schema}.agt_loan_cont_info_h.payoff_flg is '结清标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.off_bs_flg is '表外标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.onl_bus_flg is '线上业务标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.belong_strip_line_cd is '所属条线代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.lmt_id is '额度编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.oper_teller_id is '业务经办人编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.oper_org_id is '经办机构编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.oper_dt is '经办日期';
comment on column ${iml_schema}.agt_loan_cont_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_loan_cont_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.modif_dt is '变更日期';
comment on column ${iml_schema}.agt_loan_cont_info_h.spec_ped_corp_cd is '指定周期单位代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.spec_ped_cd is '指定周期代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.b_renew_exp_dt is '展期前到期日期';
comment on column ${iml_schema}.agt_loan_cont_info_h.b_renew_amt is '展期前金额';
comment on column ${iml_schema}.agt_loan_cont_info_h.b_renew_exec_year_int_rat is '展期前执行年利率';
comment on column ${iml_schema}.agt_loan_cont_info_h.hxb_rela_party_flg is '我行关联方标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.int_rat_adj_ped_cd is '利率调整周期代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.lmt_open_amt is '额度敞口金额';
comment on column ${iml_schema}.agt_loan_cont_info_h.occu_lmt is '已占用额度';
comment on column ${iml_schema}.agt_loan_cont_info_h.margin_curr_cd is '保证金币种代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.margin_ratio is '保证金比例';
comment on column ${iml_schema}.agt_loan_cont_info_h.margin_amt is '保证金金额';
comment on column ${iml_schema}.agt_loan_cont_info_h.open_amt is '敞口金额';
comment on column ${iml_schema}.agt_loan_cont_info_h.open_amt_stat is '敞口金额统计';
comment on column ${iml_schema}.agt_loan_cont_info_h.lmt_cont_id is '额度合同编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.exec_mon_int_rat is '执行月利率';
comment on column ${iml_schema}.agt_loan_cont_info_h.asset_thd_cls_cd is '资产三分类代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.level5_cls_dt is '五级分类日期';
comment on column ${iml_schema}.agt_loan_cont_info_h.level11_cls_cd is '十一级分类代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.lon_post_mgmt_teller_id is '贷后管理柜员编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.lon_post_mgmt_org_id is '贷后管理机构编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.file_dt is '归档日期';
comment on column ${iml_schema}.agt_loan_cont_info_h.froz_flg is '冻结状态代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.ovdue_exec_int_rat is '逾期执行利率';
comment on column ${iml_schema}.agt_loan_cont_info_h.ovdue_int_rat_float_way_cd is '逾期利率浮动方式代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.ovdue_int_rat_flo_val is '逾期利率浮动值';
comment on column ${iml_schema}.agt_loan_cont_info_h.core_out_acct_org_id is '核心出账机构编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.stl_acct_name is '结算账户名称';
comment on column ${iml_schema}.agt_loan_cont_info_h.enter_id is '入账账户编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.enter_name is '入账账户名称';
comment on column ${iml_schema}.agt_loan_cont_info_h.enter_open_acct_org_id is '入账账户开户机构编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.backup_status_cd is '备份状态代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.backup_lmt_cont_id is '备份额度合同编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.comm_fee_rat is '手续费率';
comment on column ${iml_schema}.agt_loan_cont_info_h.move_remark is '迁移备注';
comment on column ${iml_schema}.agt_loan_cont_info_h.strtg_new_indus_type_cd is '战略新兴产业类型代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.high_new_tech_corp_flg is '高新技术企业标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.scen_tech_corp_flg is '科技企业标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.tech_inovt_corp_flg is '科创企业标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.xxd_camp_lmt_flg is '新兴贷营销额度标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.provi_for_aged_property_flg is '养老产业标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.seed_loan_flg is '种业振兴贷款标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.county_loan_flg is '县城城区贷款标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.high_tech_property_flg is '投向高技术产业标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.digit_econ_core_type_cd is '数字经济核心产业类型代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.remark is '备注';
comment on column ${iml_schema}.agt_loan_cont_info_h.prod_gen_id is '产品大类编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.tran_bf_prod_id is '转换前产品编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.tran_bf_cust_id is '转换前客户编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.attach_rgst_bus_type_cd is '补登业务类型代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.margin_acct_id is '保证金账户编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.margin_tran_out_acct_id is '保证金转出账户编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.update_cnt is '更新次数';
comment on column ${iml_schema}.agt_loan_cont_info_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.sign_lmt_cont_flg is '签订额度合同标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.sign_paper_cont_flg is '签署纸质合同标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.comm_fee_amt is '手续费金额';
comment on column ${iml_schema}.agt_loan_cont_info_h.crdt_apv_aval_amt is '信贷审批可用金额';
comment on column ${iml_schema}.agt_loan_cont_info_h.b_renew_cont_id is '展期前合同编号';
comment on column ${iml_schema}.agt_loan_cont_info_h.ocup_open_lmt_risk_type_cd is '占用敞口额度风险类型代码';
comment on column ${iml_schema}.agt_loan_cont_info_h.ocup_o_use_lmt_flg is '占用他用额度标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.risk_mgmt_apv_aval_amt is '风控审批可用金额';
comment on column ${iml_schema}.agt_loan_cont_info_h.ifc_cnt_tot_apv_aval_amt is 'IFC数总审批可用金额';
comment on column ${iml_schema}.agt_loan_cont_info_h.ifc_apved_lmt_cont_amt is 'IFC审批后额度合同金额';
comment on column ${iml_schema}.agt_loan_cont_info_h.regroup_loan_flg is '重组贷款标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.only_new_minorent_flg is '专精特新小巨人企业标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.only_new_littlegiantent_flg is '专精特新中小企业标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.indent_tech_flg is '工业企业技术改造升级标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.cul_property_flg is '文化产业标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.advanced_manu_flg is '先进制造业标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.auto_que_lon_post_rept_flg is '自动查询贷后报告标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.buss_tiket_recs_flg is '商票保贴追索标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.discnter_margin_acct_flg is '贴现人保证金账户标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_cont_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_cont_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_cont_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_cont_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_cont_info_h.etl_timestamp is 'ETL处理时间戳';
