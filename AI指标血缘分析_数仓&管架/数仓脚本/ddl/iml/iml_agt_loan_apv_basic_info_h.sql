/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_apv_basic_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_apv_basic_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_apv_basic_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_apv_basic_info_h(
    agt_id varchar2(250) -- 协议编号
    ,apv_flow_num varchar2(100) -- 审批流水号
    ,appl_flow_num varchar2(100) -- 申请流水号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,appl_way_cd varchar2(30) -- 申请方式代码
    ,lmt_cont_flg varchar2(10) -- 额度合同标志
    ,loan_distr_type_cd varchar2(30) -- 贷款发放类型代码
    ,happ_dt date -- 发生日期
    ,curr_cd varchar2(30) -- 币种代码
    ,apv_amt number(30,2) -- 审批金额
    ,base_prod_id varchar2(100) -- 基础产品编号
    ,prod_id varchar2(100) -- 产品编号
    ,mon_tenor number(10) -- 月期限
    ,day_tenor number(10) -- 日期限
    ,begin_dt date -- 起始日期
    ,exp_dt date -- 到期日期
    ,remote_bus_flg varchar2(10) -- 异地业务标志
    ,lmt_circl_flg varchar2(10) -- 额度循环标志
    ,risk_type_cd varchar2(30) -- 风险类型代码
    ,low_risk_bus_flg varchar2(10) -- 低风险业务标志
    ,crdt_dir_cd varchar2(30) -- 授信投向代码
    ,nat_std_indus_dir_cd varchar2(30) -- 国标行业投向代码
    ,bank_int_indus_dir_cd varchar2(30) -- 行内行业投向代码
    ,loan_usage_cd varchar2(30) -- 贷款用途代码
    ,usage_descb varchar2(2000) -- 用途描述
    ,int_rat_mode_cd varchar2(30) -- 利率模式代码
    ,fix_int_rat number(18,8) -- 固定利率
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,base_rat number(18,8) -- 基准利率
    ,int_rat_float_type_cd varchar2(30) -- 利率浮动类型代码
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,int_rat_flo_val number(18,6) -- 利率浮动值
    ,exec_int_rat number(18,8) -- 执行利率
    ,main_guar_way_cd varchar2(30) -- 主担保方式代码
    ,guar_way_cd_two varchar2(30) -- 担保方式代码二
    ,guar_way_cd_three varchar2(30) -- 担保方式代码三
    ,other_guar_way_cd varchar2(30) -- 其他担保方式代码
    ,supp_guar_way_flg varchar2(10) -- 追加担保方式标志
    ,other_cond_descb varchar2(1000) -- 其他条件描述
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,repay_ped varchar2(10) -- 还款周期
    ,repay_ped_cd varchar2(30) -- 还款周期单位代码
    ,deflt_repay_day varchar2(10) -- 默认还款日
    ,rsrv_amt number(30,2) -- 预留金额
    ,rela_old_cont_id varchar2(100) -- 关联旧合同编号
    ,lmt_id varchar2(100) -- 额度编号
    ,create_cont_flg varchar2(10) -- 生成合同标志
    ,apv_status_cd varchar2(30) -- 审批状态代码
    ,reply_type_cd varchar2(30) -- 批复类型代码
    ,final_apv_opinion_descb varchar2(4000) -- 最终审批意见描述
    ,oper_teller_id varchar2(100) -- 业务经办人编号
    ,oper_org_id varchar2(100) -- 经办机构编号
    ,oper_dt date -- 经办日期
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,modif_dt date -- 变更日期
    ,belong_strip_line_cd varchar2(30) -- 所属条线代码
    ,lp_id varchar2(100) -- 法人编号
    ,spec_ped_corp_cd varchar2(30) -- 指定周期单位代码
    ,spec_ped_cd varchar2(30) -- 指定周期代码
    ,b_renew_exp_dt date -- 展期前到期日期
    ,b_renew_amt number(30,2) -- 展期前金额
    ,b_renew_exec_year_int_rat number(18,8) -- 展期前执行年利率
    ,crdt_org_way_cd varchar2(30) -- 授信组织方式代码
    ,lmt_open_amt number(30,2) -- 额度敞口金额
    ,file_dt date -- 归档日期
    ,level11_cls_cd varchar2(30) -- 十一级分类代码
    ,attach_rgst_flg varchar2(10) -- 补登标志
    ,effect_flg varchar2(10) -- 生效标志
    ,margin_acct_id varchar2(100) -- 保证金账户编号
    ,margin_tran_out_acct_id varchar2(100) -- 保证金转出账户编号
    ,margin_curr_cd varchar2(30) -- 保证金币种代码
    ,margin_ratio number(18,6) -- 保证金比例
    ,margin_amt number(30,2) -- 保证金金额
    ,int_rat_adj_ped_cd varchar2(30) -- 利率调整周期代码
    ,ovdue_exec_int_rat number(18,8) -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd varchar2(30) -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val number(18,6) -- 逾期利率浮动值
    ,stl_acct_name varchar2(500) -- 结算账户名称
    ,enter_id varchar2(100) -- 入账账户编号
    ,stl_acct_id varchar2(100) -- 结算账户编号
    ,move_remark varchar2(500) -- 迁移备注
    ,provi_for_aged_property_flg varchar2(10) -- 养老产业标志
    ,up_level_flow_num varchar2(100) -- 上层流水号
    ,risk_cls_rest_cd varchar2(60) -- 风险分类结果代码
    ,annual_vrfction_status_cd varchar2(30) -- 年审状态代码
    ,int_rat_float_way_cd varchar2(30) -- 利率浮动方式代码
    ,reply_id varchar2(100) -- 批复编号
    ,need_annual_vrfction_flg varchar2(10) -- 需要年审标志
    ,l_ped_annual_vrfction_dt date -- 上期年审日期
    ,curr_issue_annual_vrfction_dt date -- 本期年审日期
    ,ibank_tepla_id varchar2(100) -- 同业模板编号
    ,regroup_loan_flg varchar2(10) -- 重组贷款标志
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
grant select on ${iml_schema}.agt_loan_apv_basic_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_apv_basic_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_apv_basic_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_apv_basic_info_h is '贷款审批基本信息历史';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.apv_flow_num is '审批流水号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.appl_way_cd is '申请方式代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.lmt_cont_flg is '额度合同标志';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.loan_distr_type_cd is '贷款发放类型代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.happ_dt is '发生日期';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.apv_amt is '审批金额';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.base_prod_id is '基础产品编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.mon_tenor is '月期限';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.day_tenor is '日期限';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.begin_dt is '起始日期';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.remote_bus_flg is '异地业务标志';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.lmt_circl_flg is '额度循环标志';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.risk_type_cd is '风险类型代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.low_risk_bus_flg is '低风险业务标志';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.crdt_dir_cd is '授信投向代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.nat_std_indus_dir_cd is '国标行业投向代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.bank_int_indus_dir_cd is '行内行业投向代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.usage_descb is '用途描述';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.int_rat_mode_cd is '利率模式代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.fix_int_rat is '固定利率';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.base_rat is '基准利率';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.int_rat_float_type_cd is '利率浮动类型代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.int_rat_flo_val is '利率浮动值';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.main_guar_way_cd is '主担保方式代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.guar_way_cd_two is '担保方式代码二';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.guar_way_cd_three is '担保方式代码三';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.other_guar_way_cd is '其他担保方式代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.supp_guar_way_flg is '追加担保方式标志';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.other_cond_descb is '其他条件描述';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.repay_ped is '还款周期';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.repay_ped_cd is '还款周期单位代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.deflt_repay_day is '默认还款日';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.rsrv_amt is '预留金额';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.rela_old_cont_id is '关联旧合同编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.lmt_id is '额度编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.create_cont_flg is '生成合同标志';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.reply_type_cd is '批复类型代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.final_apv_opinion_descb is '最终审批意见描述';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.oper_teller_id is '业务经办人编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.oper_org_id is '经办机构编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.oper_dt is '经办日期';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.modif_dt is '变更日期';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.belong_strip_line_cd is '所属条线代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.spec_ped_corp_cd is '指定周期单位代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.spec_ped_cd is '指定周期代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.b_renew_exp_dt is '展期前到期日期';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.b_renew_amt is '展期前金额';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.b_renew_exec_year_int_rat is '展期前执行年利率';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.crdt_org_way_cd is '授信组织方式代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.lmt_open_amt is '额度敞口金额';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.file_dt is '归档日期';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.level11_cls_cd is '十一级分类代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.attach_rgst_flg is '补登标志';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.effect_flg is '生效标志';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.margin_acct_id is '保证金账户编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.margin_tran_out_acct_id is '保证金转出账户编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.margin_curr_cd is '保证金币种代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.margin_ratio is '保证金比例';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.margin_amt is '保证金金额';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.int_rat_adj_ped_cd is '利率调整周期代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.ovdue_exec_int_rat is '逾期执行利率';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.ovdue_int_rat_float_way_cd is '逾期利率浮动方式代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.ovdue_int_rat_flo_val is '逾期利率浮动值';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.stl_acct_name is '结算账户名称';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.enter_id is '入账账户编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.stl_acct_id is '结算账户编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.move_remark is '迁移备注';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.provi_for_aged_property_flg is '养老产业标志';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.up_level_flow_num is '上层流水号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.risk_cls_rest_cd is '风险分类结果代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.annual_vrfction_status_cd is '年审状态代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.reply_id is '批复编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.need_annual_vrfction_flg is '需要年审标志';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.l_ped_annual_vrfction_dt is '上期年审日期';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.curr_issue_annual_vrfction_dt is '本期年审日期';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.ibank_tepla_id is '同业模板编号';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.regroup_loan_flg is '重组贷款标志';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_apv_basic_info_h.etl_timestamp is 'ETL处理时间戳';
