/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_adv_repay_appl_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_adv_repay_appl_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_adv_repay_appl_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_adv_repay_appl_h(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,appl_flow_num varchar2(100) -- 申请流水号
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,rela_obj_flow_num varchar2(100) -- 关联对象流水号
    ,rela_obj_type_name varchar2(500) -- 关联对象类型名称
    ,rela_dubil_id varchar2(100) -- 关联借据编号
    ,appl_status_cd varchar2(30) -- 申请状态代码
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,acct_flg varchar2(10) -- 账户标志
    ,acct_type_cd varchar2(100) -- 账户类型代码
    ,repay_acct_name varchar2(500) -- 还款账户名称
    ,repay_acct_id varchar2(100) -- 还款账户编号
    ,actl_recv_pric number(30,2) -- 实收本金
    ,actl_recv_int number(30,2) -- 实收利息
    ,actl_recv_pnlt number(30,2) -- 实收罚息
    ,actl_recv_comp_int number(30,2) -- 实收复息
    ,actl_recv_fee number(30,2) -- 实收费用
    ,repay_tot_amt number(30,2) -- 还款总金额
    ,adv_repay_way_cd varchar2(30) -- 提前还款方式代码
    ,adv_repay_int_accr_way_cd varchar2(30) -- 提前还款计息方式代码
    ,adv_repay_int_accr_base_cd varchar2(30) -- 提前还款计息基础代码
    ,adv_repay_amt_type_cd varchar2(30) -- 提前还款金额类型代码
    ,adv_repay_amt number(30,8) -- 提前还款金额
    ,adv_rtn_pric number(30,2) -- 提前归还本金
    ,adv_rtn_int number(30,2) -- 提前归还利息
    ,adv_rtn_fee varchar2(500) -- 提前归还费用
    ,penalty_amt number(30,2) -- 违约金金额
    ,deduct_seq_cd varchar2(30) -- 扣款顺序代码
    ,onl_pay_flg varchar2(10) -- 在线支付标志
    ,core_tran_flow_num varchar2(100) -- 核心交易流水号
    ,core_tran_status_cd varchar2(30) -- 核心交易状态代码
    ,appl_dt date -- 申请日期
    ,core_tran_dt date -- 核心交易日期
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,modif_dt date -- 变更日期
    ,belong_strip_line_cd varchar2(30) -- 所属条线代码
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
grant select on ${iml_schema}.agt_loan_adv_repay_appl_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_adv_repay_appl_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_adv_repay_appl_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_adv_repay_appl_h is '贷款提前还款申请历史';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.rela_obj_flow_num is '关联对象流水号';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.rela_obj_type_name is '关联对象类型名称';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.rela_dubil_id is '关联借据编号';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.appl_status_cd is '申请状态代码';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.acct_flg is '账户标志';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.repay_acct_name is '还款账户名称';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.repay_acct_id is '还款账户编号';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.actl_recv_pric is '实收本金';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.actl_recv_int is '实收利息';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.actl_recv_pnlt is '实收罚息';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.actl_recv_comp_int is '实收复息';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.actl_recv_fee is '实收费用';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.repay_tot_amt is '还款总金额';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.adv_repay_way_cd is '提前还款方式代码';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.adv_repay_int_accr_way_cd is '提前还款计息方式代码';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.adv_repay_int_accr_base_cd is '提前还款计息基础代码';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.adv_repay_amt_type_cd is '提前还款金额类型代码';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.adv_repay_amt is '提前还款金额';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.adv_rtn_pric is '提前归还本金';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.adv_rtn_int is '提前归还利息';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.adv_rtn_fee is '提前归还费用';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.penalty_amt is '违约金金额';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.deduct_seq_cd is '扣款顺序代码';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.onl_pay_flg is '在线支付标志';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.core_tran_flow_num is '核心交易流水号';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.core_tran_status_cd is '核心交易状态代码';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.appl_dt is '申请日期';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.core_tran_dt is '核心交易日期';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.modif_dt is '变更日期';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.belong_strip_line_cd is '所属条线代码';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_adv_repay_appl_h.etl_timestamp is 'ETL处理时间戳';
