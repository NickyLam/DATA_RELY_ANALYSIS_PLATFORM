/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_out_acct_mini_loan_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,out_acct_flow_num varchar2(100) -- 出账流水号
    ,recver_open_bank_cate_cd varchar2(30) -- 收款人开户行类别代码
    ,recver_open_bank_rg_cd varchar2(30) -- 收款人开户行地区代码
    ,mini_loan_stl_acct_id varchar2(100) -- 微贷结算账户编号
    ,loan_type_cd varchar2(30) -- 贷款类型代码
    ,prep_entred_tran_cnt number(10) -- 待受托划款笔数
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,bank_int_flg varchar2(10) -- 行内标志
    ,init_tran_dt date -- 原交易日期
    ,init_tran_flow_num varchar2(100) -- 原交易流水号
    ,loan_tenor_cd varchar2(30) -- 贷款期限代码
    ,guar_way_cd varchar2(30) -- 担保方式代码
    ,mode_pay_cd varchar2(30) -- 支付方式代码
    ,pay_way_cd varchar2(30) -- 付款方式代码
    ,mini_loan_repay_num_id_one varchar2(100) -- 微贷还款账户编号一
    ,mini_loan_repay_num_id_two varchar2(100) -- 微贷还款账户编号二
    ,entr_pay_acct_id varchar2(100) -- 受托支付账户编号
    ,entr_pay_acct_name varchar2(500) -- 受托支付账户名称
    ,tran_dt date -- 交易日期
    ,loan_repay_int_intrv number(10) -- 贷款还息间隔
    ,recv_bank_no varchar2(60) -- 收款行行号
    ,recv_bank_name varchar2(500) -- 收款行名称
    ,cust_id varchar2(100) -- 客户编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,enter_acct_org_id varchar2(100) -- 入账机构编号
    ,out_acct_status_cd varchar2(30) -- 出账状态代码
    ,repay_comnt_descb varchar2(500) -- 还款说明描述
    ,prtcpt_deduct_flg varchar2(10) -- 参与批扣标志
    ,tenor_type_cd varchar2(30) -- 期限类型代码
    ,user_id varchar2(100) -- 用户编号
    ,out_acct_appl_dt date -- 出账申请日期
    ,actl_out_acct_dt date -- 实际出账日期
    ,stud_loan_prod_id varchar2(100) -- 助贷产品编号
    ,major_guartor_id varchar2(100) -- 主要担保人编号
    ,major_guartor_name varchar2(500) -- 主要担保人名称
    ,secd_repay_acct_name varchar2(500) -- 第二还款账户名称
    ,secd_repay_acct_id varchar2(100) -- 第二还款账户编号
    ,forwd_tran_dt date -- 正向交易日期
    ,forwd_tran_flow_num varchar2(100) -- 正向交易流水号
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
grant select on ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h is '贷款出账微贷附属信息历史';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.recver_open_bank_cate_cd is '收款人开户行类别代码';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.recver_open_bank_rg_cd is '收款人开户行地区代码';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.mini_loan_stl_acct_id is '微贷结算账户编号';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.loan_type_cd is '贷款类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.prep_entred_tran_cnt is '待受托划款笔数';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.bank_int_flg is '行内标志';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.init_tran_dt is '原交易日期';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.init_tran_flow_num is '原交易流水号';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.loan_tenor_cd is '贷款期限代码';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.guar_way_cd is '担保方式代码';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.mode_pay_cd is '支付方式代码';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.pay_way_cd is '付款方式代码';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.mini_loan_repay_num_id_one is '微贷还款账户编号一';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.mini_loan_repay_num_id_two is '微贷还款账户编号二';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.entr_pay_acct_id is '受托支付账户编号';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.entr_pay_acct_name is '受托支付账户名称';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.loan_repay_int_intrv is '贷款还息间隔';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.recv_bank_no is '收款行行号';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.recv_bank_name is '收款行名称';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.enter_acct_org_id is '入账机构编号';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.out_acct_status_cd is '出账状态代码';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.repay_comnt_descb is '还款说明描述';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.prtcpt_deduct_flg is '参与批扣标志';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.user_id is '用户编号';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.out_acct_appl_dt is '出账申请日期';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.actl_out_acct_dt is '实际出账日期';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.stud_loan_prod_id is '助贷产品编号';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.major_guartor_id is '主要担保人编号';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.major_guartor_name is '主要担保人名称';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.secd_repay_acct_name is '第二还款账户名称';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.secd_repay_acct_id is '第二还款账户编号';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.forwd_tran_dt is '正向交易日期';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.forwd_tran_flow_num is '正向交易流水号';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h.etl_timestamp is 'ETL处理时间戳';
