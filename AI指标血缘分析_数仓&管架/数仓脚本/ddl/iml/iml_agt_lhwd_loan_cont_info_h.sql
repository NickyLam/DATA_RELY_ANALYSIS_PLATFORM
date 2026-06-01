/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_lhwd_loan_cont_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_lhwd_loan_cont_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_lhwd_loan_cont_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lhwd_loan_cont_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,cont_id varchar2(100) -- 合同编号
    ,rela_cont_id varchar2(100) -- 关联合同编号
    ,prod_id varchar2(100) -- 产品编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,lmt_cont_flg varchar2(10) -- 额度合同标志
    ,crdt_id varchar2(100) -- 授信编号
    ,crdt_chn_cd varchar2(60) -- 授信渠道代码
    ,curr_cd varchar2(30) -- 币种代码
    ,cont_amt number(30,8) -- 合同金额
    ,cont_bal number(30,8) -- 合同余额
    ,aval_lmt number(30,8) -- 可用额度
    ,ocup_lmt number(30,8) -- 占用额度
    ,distr_amt number(30,8) -- 放款金额
    ,distr_dt date -- 放款日期
    ,mon_tenor number(10) -- 月期限
    ,day_tenor number(10) -- 日期限
    ,cont_effect_dt date -- 合同生效日期
    ,cont_exp_dt date -- 合同到期日期
    ,cont_status_cd varchar2(60) -- 合同状态代码
    ,apv_status_cd varchar2(60) -- 审批状态代码
    ,circl_flg varchar2(10) -- 循环标志
    ,main_guar_way_cd varchar2(30) -- 主担保方式代码
    ,mode_pay_cd varchar2(60) -- 支付方式代码
    ,loan_dir_indus_cd varchar2(60) -- 贷款投向行业代码
    ,loan_usage_cd varchar2(60) -- 贷款用途代码
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,repay_ped_cd varchar2(60) -- 还款周期代码
    ,grace_period number(10) -- 宽限期
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,base_rat number(18,8) -- 基准利率
    ,exec_int_rat number(30,8) -- 执行利率
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,int_rat_adj_ped_cd varchar2(60) -- 利率调整周期代码
    ,int_rat_float_point number(18,8) -- 利率浮动点数
    ,ovdue_int_rat number(18,8) -- 逾期利率
    ,ovdue_int_rat_float_way_cd varchar2(100) -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt number(30,8) -- 逾期利率浮动比例
    ,bank_card_rsrv_mobile_no varchar2(100) -- 银行卡预留手机号
    ,enter_id varchar2(100) -- 入账账户编号
    ,enter_name varchar2(500) -- 入账账户名称
    ,enter_open_acct_org_name varchar2(500) -- 入账账户开户机构名称
    ,enter_type_cd varchar2(100) -- 入账账户类型代码
    ,repay_num_id varchar2(100) -- 还款账户编号
    ,repay_num_type_cd varchar2(100) -- 还款账户类型代码
    ,repay_num_name varchar2(500) -- 还款账户名称
    ,repay_num_open_acct_org_name varchar2(500) -- 还款账户开户机构名称
    ,out_acct_org_id varchar2(100) -- 出账机构编号
    ,bank_contri_ratio number(30,8) -- 银行出资比例
    ,partner_prod_id varchar2(100) -- 合作方产品编号
    ,partner_ova_flow_num varchar2(100) -- 合作方全局流水号
    ,partner_bus_mode_cd varchar2(100) -- 合作方业务模式代码
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.agt_lhwd_loan_cont_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_lhwd_loan_cont_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_lhwd_loan_cont_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_lhwd_loan_cont_info_h is '联合网贷贷款合同信息历史';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.rela_cont_id is '关联合同编号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.lmt_cont_flg is '额度合同标志';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.crdt_id is '授信编号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.crdt_chn_cd is '授信渠道代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.cont_amt is '合同金额';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.cont_bal is '合同余额';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.aval_lmt is '可用额度';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.ocup_lmt is '占用额度';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.distr_amt is '放款金额';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.distr_dt is '放款日期';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.mon_tenor is '月期限';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.day_tenor is '日期限';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.cont_effect_dt is '合同生效日期';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.cont_exp_dt is '合同到期日期';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.cont_status_cd is '合同状态代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.circl_flg is '循环标志';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.main_guar_way_cd is '主担保方式代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.mode_pay_cd is '支付方式代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.loan_dir_indus_cd is '贷款投向行业代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.repay_ped_cd is '还款周期代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.grace_period is '宽限期';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.base_rat is '基准利率';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.int_rat_adj_ped_cd is '利率调整周期代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.int_rat_float_point is '利率浮动点数';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.ovdue_int_rat is '逾期利率';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.ovdue_int_rat_float_way_cd is '逾期利率浮动方式代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.ovdue_int_rat_fl_rt is '逾期利率浮动比例';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.bank_card_rsrv_mobile_no is '银行卡预留手机号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.enter_id is '入账账户编号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.enter_name is '入账账户名称';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.enter_open_acct_org_name is '入账账户开户机构名称';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.enter_type_cd is '入账账户类型代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.repay_num_id is '还款账户编号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.repay_num_type_cd is '还款账户类型代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.repay_num_name is '还款账户名称';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.repay_num_open_acct_org_name is '还款账户开户机构名称';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.out_acct_org_id is '出账机构编号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.bank_contri_ratio is '银行出资比例';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.partner_prod_id is '合作方产品编号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.partner_ova_flow_num is '合作方全局流水号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.partner_bus_mode_cd is '合作方业务模式代码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_lhwd_loan_cont_info_h.etl_timestamp is 'ETL处理时间戳';
