/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_retl_loan_cont_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_retl_loan_cont_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_retl_loan_cont_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_retl_loan_cont_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cont_id varchar2(60) -- 合同编号
    ,cont_name varchar2(500) -- 合同名称
    ,cust_id varchar2(60) -- 客户编号
    ,lmt_cont_id varchar2(60) -- 额度合同编号
    ,enter_acct_id varchar2(60) -- 入账账户编号
    ,repay_acct_id varchar2(60) -- 还款账户编号
    ,prod_id varchar2(60) -- 产品编号
    ,prod_name varchar2(500) -- 产品名称
    ,apv_flow_num varchar2(60) -- 审批流水号
	,aplv_flow_num varchar2(100) -- 申请流水号
    ,init_dubil_id varchar2(60) -- 原借据编号
    ,cont_type_cd varchar2(10) -- 合同类型代码
    ,cont_status_cd varchar2(10) -- 合同状态代码
    ,bus_kind_cd varchar2(60) -- 业务种类代码
    ,loan_happ_type_cd varchar2(30) -- 贷款发生类型代码
    ,major_guar_way_cd varchar2(10) -- 主要担保方式代码
    ,sub_guar_way_cd varchar2(10) -- 子担保方式代码
    ,borw_usage_type_cd varchar2(10) -- 借款用途类型代码
    ,dir_indus_cd varchar2(10) -- 贷款投向行业代码
    ,distr_way_cd varchar2(10) -- 发放方式代码
    ,mode_pay_cd varchar2(10) -- 支付方式代码
    ,tenor_type_cd varchar2(10) -- 期限类型代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,int_rat_float_dir_cd varchar2(10) -- 利率浮动方向代码
    ,repay_freq_cd varchar2(10) -- 还款频率代码
    ,repay_day_cfm_cd varchar2(10) -- 还款日确定代码
    ,curr_cd varchar2(10) -- 币种代码
    ,housing_cnt_cd varchar2(10) -- 住房套数代码
    ,high_tech_property_type_cd varchar2(60) -- 高技术产业类型代码
    ,digit_econ_core_property_type_cd varchar2(60) -- 数字经济核心产业类型代码
    ,intel_prop_inte_property_type_cd varchar2(60) -- 知识产权密集型产业类型代码
    ,strtg_new_indus_type_cd varchar2(60) -- 战略新兴产业类型代码
    ,cul_and_rela_property_type_cd varchar2(60) -- 文化及相关产业类型代码
    ,digit_econ_core_type_cd varchar2(60) -- 投向数字经济核心产业类型代码
    ,agclt_flg varchar2(10) -- 涉农贷款标志
    ,green_crdt_flg varchar2(10) -- 绿色信贷标志
    ,green_loan_usage_cd varchar2(60) -- 绿色贷款用途代码
    ,green_loan_usage_level2_cls_cd varchar2(60) -- 绿色贷款用途二级分类代码
    ,green_loan_usage_level3_cls_cd varchar2(60) -- 绿色贷款用途三级分类代码
    ,vehic_type_cd varchar2(60) -- 车辆类型代码
    ,crdt_lmt_use_flg varchar2(10) -- 授信额度使用标志
    ,mortg_flg varchar2(10) -- 按揭标志
    ,gro_lend_flg varchar2(10) -- 联保贷款标志
    ,blon_loan_flg varchar2(10) -- 气球贷标志
    ,green_pass_flg varchar2(10) -- 绿色通道标志
    ,low_risk_bus_flg varchar2(10) -- 低风险业务标志
    ,bar_flg varchar2(10) -- 随借随还标志
    ,allow_stage_repay_flg varchar2(10) -- 允许阶段性还款标志
    ,provi_for_aged_property_flg varchar2(10) -- 养老产业标志
    ,hxb_open_supv_acct_flg varchar2(10) -- 在我行开立监管账户标志
    ,incre_crdt_mode_cd varchar2(60) -- 增信模式代码
    ,entr_loan_flg varchar2(10) -- 委托贷款标志
    ,csner_cust_no varchar2(60) -- 委托人客户号
    ,csner_cust_name varchar2(250) -- 委托人客户名称
    ,appl_dt date -- 申请日期
    ,apv_dt date -- 审批日期
    ,sign_dt date -- 签约日期
    ,cont_create_dt date -- 合同生成日期
    ,start_dt date -- 起始日期
    ,termnt_dt date -- 终止日期
    ,exp_dt date -- 到期日期
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,rgst_org_id varchar2(60) -- 登记机构编号
    ,mgmt_org_id varchar2(60) -- 管理机构编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,crdt_loan_flg varchar2(10) -- 信用贷款标志
    ,crdt_loan_reply_flow_num varchar2(60) -- 信用贷款批复流水号
    ,coprator_id varchar2(60) -- 合作商编号
    ,coprator_name varchar2(100) -- 合作商名称
    ,use_coprator_lmt_flg varchar2(10) -- 使用合作商额度标志
    ,coprator_agt_id varchar2(60) -- 合作商协议编号
    ,coprator_stand_b_id varchar2(60) -- 合作商台账编号
    ,coprator_proj_type_cd varchar2(10) -- 合作商项目类型代码
    ,coprator_type_cd varchar2(10) -- 合作商类型代码
    ,base_rat number(18,8) -- 基准利率
    ,exec_int_rat number(18,8) -- 执行利率
    ,repay_day varchar2(10) -- 还款日
    ,tenor number(10,0) -- 期限
    ,pm_guar_tot number(30,2) -- 抵质押担保总额
    ,avg_pm_rat number(18,8) -- 平均抵质押率
    ,cont_amt number(30,2) -- 合同金额
    ,cont_aval_bal number(30,2) -- 合同可用余额
    ,acm_distr_amt number(30,2) -- 累计发放金额
    ,acm_callbk_amt number(30,2) -- 累计回收金额
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
grant select on ${icl_schema}.cmm_retl_loan_cont_info to ${idl_schema};
grant select on ${icl_schema}.cmm_retl_loan_cont_info to ${iel_schema};
grant select on ${icl_schema}.cmm_retl_loan_cont_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_retl_loan_cont_info is '零售贷款合同信息';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.cont_id is '合同编号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.cont_name is '合同名称';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.lmt_cont_id is '额度合同编号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.enter_acct_id is '入账账户编号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.repay_acct_id is '还款账户编号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.prod_name is '产品名称';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.apv_flow_num is '审批流水号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.aplv_flow_num is '申请流水号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.init_dubil_id is '原借据编号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.cont_type_cd is '合同类型代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.cont_status_cd is '合同状态代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.bus_kind_cd is '业务种类代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.loan_happ_type_cd is '贷款发生类型代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.major_guar_way_cd is '主要担保方式代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.sub_guar_way_cd is '子担保方式代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.borw_usage_type_cd is '借款用途类型代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.dir_indus_cd is '贷款投向行业代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.distr_way_cd is '发放方式代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.mode_pay_cd is '支付方式代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.tenor_type_cd is '期限类型代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.int_rat_float_dir_cd is '利率浮动方向代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.repay_freq_cd is '还款频率代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.repay_day_cfm_cd is '还款日确定代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.housing_cnt_cd is '住房套数代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.high_tech_property_type_cd is '高技术产业类型代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.digit_econ_core_property_type_cd is '数字经济核心产业类型代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.intel_prop_inte_property_type_cd is '知识产权密集型产业类型代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.strtg_new_indus_type_cd is '战略新兴产业类型代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.cul_and_rela_property_type_cd is '文化及相关产业类型代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.digit_econ_core_type_cd is '投向数字经济核心产业类型代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.agclt_flg is '涉农贷款标志';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.green_crdt_flg is '绿色信贷标志';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.green_loan_usage_cd is '绿色贷款用途代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.green_loan_usage_level2_cls_cd is '绿色贷款用途二级分类代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.green_loan_usage_level3_cls_cd is '绿色贷款用途三级分类代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.vehic_type_cd is '车辆类型代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.crdt_lmt_use_flg is '授信额度使用标志';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.mortg_flg is '按揭标志';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.gro_lend_flg is '联保贷款标志';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.blon_loan_flg is '气球贷标志';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.green_pass_flg is '绿色通道标志';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.low_risk_bus_flg is '低风险业务标志';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.bar_flg is '随借随还标志';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.allow_stage_repay_flg is '允许阶段性还款标志';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.provi_for_aged_property_flg is '养老产业标志';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.hxb_open_supv_acct_flg is '在我行开立监管账户标志';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.incre_crdt_mode_cd is '增信模式代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.entr_loan_flg is '委托贷款标志';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.csner_cust_no is '委托人客户号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.csner_cust_name is '委托人客户名称';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.appl_dt is '申请日期';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.apv_dt is '审批日期';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.sign_dt is '签约日期';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.cont_create_dt is '合同生成日期';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.start_dt is '起始日期';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.termnt_dt is '终止日期';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.cust_mgr_id is '客户经理编号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.rgst_org_id is '登记机构编号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.mgmt_org_id is '管理机构编号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.crdt_loan_flg is '信用贷款标志';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.crdt_loan_reply_flow_num is '信用贷款批复流水号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.coprator_id is '合作商编号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.coprator_name is '合作商名称';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.use_coprator_lmt_flg is '使用合作商额度标志';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.coprator_agt_id is '合作商协议编号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.coprator_stand_b_id is '合作商台账编号';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.coprator_proj_type_cd is '合作商项目类型代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.coprator_type_cd is '合作商类型代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.base_rat is '基准利率';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.exec_int_rat is '执行利率';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.repay_day is '还款日';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.tenor is '期限';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.pm_guar_tot is '抵质押担保总额';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.avg_pm_rat is '平均抵质押率';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.cont_amt is '合同金额';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.cont_aval_bal is '合同可用余额';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.acm_distr_amt is '累计发放金额';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.acm_callbk_amt is '累计回收金额';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_retl_loan_cont_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_retl_loan_cont_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_retl_loan_cont_info.etl_timestamp is 'ETL处理时间戳';
