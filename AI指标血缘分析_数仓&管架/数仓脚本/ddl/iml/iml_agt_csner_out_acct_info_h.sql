/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_csner_out_acct_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_csner_out_acct_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_csner_out_acct_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_csner_out_acct_info_h(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,flow_num varchar2(500) -- 流水号
    ,csner_cust_id varchar2(500) -- 委托人客户编号
    ,csner_name varchar2(500) -- 委托人名称
    ,csner_acct_id varchar2(100) -- 委托人账户编号
    ,csner_dep_acct_name varchar2(500) -- 委托人存款账户名称
    ,csner_type_cd varchar2(500) -- 委托人类型代码
    ,entr_dep_acct_id varchar2(100) -- 委托存款账户账号
    ,entr_dep_acct_name varchar2(500) -- 委托存款账户名称
    ,dubil_id varchar2(100) -- 借据编号
    ,borw_cont_id varchar2(100) -- 借款合同编号
    ,brwer_cust_id varchar2(100) -- 借款人客户编号
    ,brwer_name varchar2(500) -- 借款人名称
    ,pric_rtn_enter_id varchar2(100) -- 本金归还入账账户编号
    ,pric_rtn_enter_name varchar2(500) -- 本金归还入账账户名称
    ,stamp_tax_tax_acct_id varchar2(100) -- 印花税扣税账户编号
    ,stamp_tax_tax_acct_name varchar2(500) -- 印花税扣税账户名称
    ,comm_fee_coll_acct_id varchar2(100) -- 手续费收取账户编号
    ,comm_fee_coll_acct_name varchar2(500) -- 手续费收取账户名称
    ,int_rtn_enter_id varchar2(500) -- 利息归还入账账户编号
    ,int_rtn_enter_name varchar2(500) -- 利息归还入账账户名称
    ,cap_src_cd varchar2(1000) -- 资金来源代码
    ,csner_open_bank_num varchar2(100) -- 委托人开户行号
    ,csner_open_bank_name varchar2(500) -- 委托人开户行名称
    ,csner_cert_no varchar2(60) -- 委托人证件号码
    ,csner_cert_type_cd varchar2(30) -- 委托人证件类型代码
    ,entr_loan_dir_cd varchar2(30) -- 委托贷款投向代码
    ,entr_loan_subclass_cd varchar2(30) -- 委托贷款细类代码
    ,natnal_econ_gen_cd varchar2(30) -- 国民经济大类代码
    ,natnal_econ_sub_type_cd varchar2(30) -- 国民经济子类代码
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
grant select on ${iml_schema}.agt_csner_out_acct_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_csner_out_acct_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_csner_out_acct_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_csner_out_acct_info_h is '委托人出账信息历史';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.flow_num is '流水号';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.csner_cust_id is '委托人客户编号';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.csner_name is '委托人名称';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.csner_acct_id is '委托人账户编号';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.csner_dep_acct_name is '委托人存款账户名称';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.csner_type_cd is '委托人类型代码';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.entr_dep_acct_id is '委托存款账户账号';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.entr_dep_acct_name is '委托存款账户名称';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.borw_cont_id is '借款合同编号';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.brwer_cust_id is '借款人客户编号';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.brwer_name is '借款人名称';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.pric_rtn_enter_id is '本金归还入账账户编号';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.pric_rtn_enter_name is '本金归还入账账户名称';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.stamp_tax_tax_acct_id is '印花税扣税账户编号';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.stamp_tax_tax_acct_name is '印花税扣税账户名称';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.comm_fee_coll_acct_id is '手续费收取账户编号';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.comm_fee_coll_acct_name is '手续费收取账户名称';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.int_rtn_enter_id is '利息归还入账账户编号';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.int_rtn_enter_name is '利息归还入账账户名称';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.cap_src_cd is '资金来源代码';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.csner_open_bank_num is '委托人开户行号';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.csner_open_bank_name is '委托人开户行名称';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.csner_cert_no is '委托人证件号码';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.csner_cert_type_cd is '委托人证件类型代码';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.entr_loan_dir_cd is '委托贷款投向代码';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.entr_loan_subclass_cd is '委托贷款细类代码';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.natnal_econ_gen_cd is '国民经济大类代码';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.natnal_econ_sub_type_cd is '国民经济子类代码';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_csner_out_acct_info_h.etl_timestamp is 'ETL处理时间戳';
