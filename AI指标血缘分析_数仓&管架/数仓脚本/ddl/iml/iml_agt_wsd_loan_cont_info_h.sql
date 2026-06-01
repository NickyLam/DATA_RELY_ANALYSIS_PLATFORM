/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wsd_loan_cont_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wsd_loan_cont_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wsd_loan_cont_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wsd_loan_cont_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,cont_id varchar2(100) -- 合同编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,prod_id varchar2(100) -- 产品编号
    ,lmt_cont_flg varchar2(10) -- 额度合同标志
    ,crdt_appl_id varchar2(100) -- 授信申请编号
    ,appl_type_cd varchar2(100) -- 申请类型代码
    ,sign_dt date -- 签订日期
    ,payoff_dt date -- 结清日期
    ,curr_cd varchar2(30) -- 币种代码
    ,cont_amt number(30,8) -- 合同金额
    ,actl_out_acct_amt number(30,8) -- 实际出账金额
    ,out_acct_dt date -- 出账日期
    ,apv_status_cd varchar2(100) -- 审批状态代码
    ,spec_repay_dt date -- 指定还款日期
    ,tenor number(10) -- 期限
    ,int_rat_float_way_cd varchar2(30) -- 利率浮动方式代码
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,main_guar_way_cd varchar2(30) -- 主担保方式代码
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,exec_int_rat number(18,8) -- 执行利率
    ,loan_bal number(30,8) -- 贷款余额
    ,cont_status_cd varchar2(60) -- 合同状态代码
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,loan_usage_cd varchar2(30) -- 贷款用途代码
    ,recvbl_acct_id varchar2(250) -- 收款账户编号
    ,recver_open_bank_no varchar2(100) -- 收款人开户行行号
    ,oper_teller_id varchar2(100) -- 经办柜员编号
    ,oper_org_id varchar2(100) -- 经办机构编号
    ,oper_dt date -- 经办日期
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,up_date date -- 更新日期
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
grant select on ${iml_schema}.agt_wsd_loan_cont_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_wsd_loan_cont_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_wsd_loan_cont_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wsd_loan_cont_info_h is '网商贷贷款合同信息历史';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.lmt_cont_flg is '额度合同标志';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.crdt_appl_id is '授信申请编号';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.appl_type_cd is '申请类型代码';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.sign_dt is '签订日期';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.cont_amt is '合同金额';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.actl_out_acct_amt is '实际出账金额';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.out_acct_dt is '出账日期';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.spec_repay_dt is '指定还款日期';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.tenor is '期限';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.main_guar_way_cd is '主担保方式代码';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.loan_bal is '贷款余额';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.cont_status_cd is '合同状态代码';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.recver_open_bank_no is '收款人开户行行号';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.oper_teller_id is '经办柜员编号';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.oper_org_id is '经办机构编号';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.oper_dt is '经办日期';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.up_date is '更新日期';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wsd_loan_cont_info_h.etl_timestamp is 'ETL处理时间戳';
