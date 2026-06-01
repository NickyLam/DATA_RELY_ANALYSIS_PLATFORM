/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_cont_mini_loan_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h(
    agt_id varchar2(250) -- 协议编号
    ,cont_id varchar2(100) -- 合同编号
    ,stud_loan_deflt_prod_id varchar2(100) -- 助贷默认产品编号
    ,loan_usage_tran_amt number(30,2) -- 贷款用途交易金额
    ,mode_pay_cd varchar2(30) -- 支付方式代码
    ,tenor_type_cd varchar2(30) -- 期限类型代码
    ,comm_fee_mode_pay_cd varchar2(30) -- 手续费支付方式代码
    ,indv_loan_comm_fee_rat number(18,6) -- 个人贷款手续费率
    ,comm_fee_amt number(30,2) -- 手续费金额
    ,mini_loan_stl_acct_id varchar2(100) -- 微贷结算账户编号
    ,recver_open_bank_rg_cd varchar2(30) -- 收款人开户行地区代码
    ,major_guartor_name varchar2(500) -- 主要担保人名称
    ,major_guartor_id varchar2(100) -- 主要担保人编号
    ,secd_repay_acct_id varchar2(100) -- 第二还款账户编号
    ,secd_repay_acct_name varchar2(500) -- 第二还款账户名称
    ,repay_comnt_descb varchar2(500) -- 还款说明描述
    ,resv_pric number(30,2) -- 保留本金
    ,loan_ratio number(18,6) -- 贷款比例
    ,enter_acct_org_id varchar2(100) -- 入账机构编号
    ,bank_int_flg varchar2(10) -- 行内标志
    ,prtcpt_deduct_flg varchar2(10) -- 参与批扣标志
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
grant select on ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h is '贷款合同微贷附属信息历史';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.stud_loan_deflt_prod_id is '助贷默认产品编号';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.loan_usage_tran_amt is '贷款用途交易金额';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.mode_pay_cd is '支付方式代码';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.comm_fee_mode_pay_cd is '手续费支付方式代码';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.indv_loan_comm_fee_rat is '个人贷款手续费率';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.comm_fee_amt is '手续费金额';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.mini_loan_stl_acct_id is '微贷结算账户编号';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.recver_open_bank_rg_cd is '收款人开户行地区代码';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.major_guartor_name is '主要担保人名称';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.major_guartor_id is '主要担保人编号';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.secd_repay_acct_id is '第二还款账户编号';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.secd_repay_acct_name is '第二还款账户名称';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.repay_comnt_descb is '还款说明描述';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.resv_pric is '保留本金';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.loan_ratio is '贷款比例';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.enter_acct_org_id is '入账机构编号';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.bank_int_flg is '行内标志';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.prtcpt_deduct_flg is '参与批扣标志';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h.etl_timestamp is 'ETL处理时间戳';
