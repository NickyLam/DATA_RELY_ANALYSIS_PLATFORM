/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_log_acct_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_log_acct_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_log_acct_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_log_acct_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,log_id varchar2(100) -- 保函编号
    ,prod_id varchar2(100) -- 产品编号
    ,log_cont_id varchar2(100) -- 保函合同编号
    ,dubil_id varchar2(100) -- 借据编号
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,guar_org_id varchar2(100) -- 担保机构编号
    ,rev_guar_org_id varchar2(100) -- 反担机构编号
    ,appl_cust_id varchar2(100) -- 申请者客户编号
    ,benefc_acct_id varchar2(100) -- 受益人账户编号
    ,benefc_name varchar2(500) -- 受益人名称
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,curr_cd varchar2(30) -- 币种代码
    ,log_amt number(30,2) -- 保函金额
    ,pymc_cust_acct_num varchar2(60) -- 备款客户账号
    ,pymc_acct_sub_acct_num varchar2(60) -- 备款账户子账号
    ,pymc_acct_curr_cd varchar2(30) -- 备款账户币种代码
    ,pymc_acct_prod_id varchar2(100) -- 备款账户产品编号
    ,pbc_clear_acct_num varchar2(60) -- 人行清算账号
    ,stl_acct_sub_acct_num varchar2(60) -- 结算账户子账号
    ,stl_acct_curr_cd varchar2(30) -- 结算账户币种代码
    ,stl_acct_prod_id varchar2(100) -- 结算账户产品编号
    ,advc_amt number(30,2) -- 垫款金额
    ,advc_loan_acct_num varchar2(60) -- 垫款贷款账号
    ,advc_fix_pnlt_int_rat number(18,8) -- 垫款固定罚息利率
    ,begin_dt date -- 起始日期
    ,exp_dt date -- 到期日期
    ,log_status_cd varchar2(30) -- 保函状态代码
    ,remark varchar2(500) -- 备注
    ,cont_curr_cd varchar2(30) -- 合同币种代码
    ,log_init_froz_amt number(30,2) -- 保函原始冻结金额
    ,benefc_cert_type_cd varchar2(30) -- 受益人证件类型代码
    ,benefc_cert_no varchar2(60) -- 受益人证件号码
    ,new_log_termnt_dt date -- 新保函终止日期
    ,mtg_cont_id varchar2(100) -- 抵押合同编号
    ,benefc_resdnt_addr varchar2(500) -- 受益人居住地址
    ,col_book_val number(30,2) -- 押品账面价值
    ,surp_compens_amt number(30,2) -- 剩余赔付金额
    ,log_compens_status_cd varchar2(30) -- 保函赔付状态代码
    ,loan_sign_cont_amt number(30,2) -- 贷款签约合同金额
    ,cust_id varchar2(100) -- 客户编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,ghb_benefc_acct_num_flg varchar2(10) -- 本行受益人账号标志
    ,final_modif_dt date -- 最后修改日期
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
grant select on ${iml_schema}.agt_log_acct_h to ${icl_schema};
grant select on ${iml_schema}.agt_log_acct_h to ${idl_schema};
grant select on ${iml_schema}.agt_log_acct_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_log_acct_h is '保函账户历史';
comment on column ${iml_schema}.agt_log_acct_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_log_acct_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_log_acct_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_log_acct_h.log_id is '保函编号';
comment on column ${iml_schema}.agt_log_acct_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_log_acct_h.log_cont_id is '保函合同编号';
comment on column ${iml_schema}.agt_log_acct_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_log_acct_h.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.agt_log_acct_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_log_acct_h.guar_org_id is '担保机构编号';
comment on column ${iml_schema}.agt_log_acct_h.rev_guar_org_id is '反担机构编号';
comment on column ${iml_schema}.agt_log_acct_h.appl_cust_id is '申请者客户编号';
comment on column ${iml_schema}.agt_log_acct_h.benefc_acct_id is '受益人账户编号';
comment on column ${iml_schema}.agt_log_acct_h.benefc_name is '受益人名称';
comment on column ${iml_schema}.agt_log_acct_h.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_log_acct_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_log_acct_h.log_amt is '保函金额';
comment on column ${iml_schema}.agt_log_acct_h.pymc_cust_acct_num is '备款客户账号';
comment on column ${iml_schema}.agt_log_acct_h.pymc_acct_sub_acct_num is '备款账户子账号';
comment on column ${iml_schema}.agt_log_acct_h.pymc_acct_curr_cd is '备款账户币种代码';
comment on column ${iml_schema}.agt_log_acct_h.pymc_acct_prod_id is '备款账户产品编号';
comment on column ${iml_schema}.agt_log_acct_h.pbc_clear_acct_num is '人行清算账号';
comment on column ${iml_schema}.agt_log_acct_h.stl_acct_sub_acct_num is '结算账户子账号';
comment on column ${iml_schema}.agt_log_acct_h.stl_acct_curr_cd is '结算账户币种代码';
comment on column ${iml_schema}.agt_log_acct_h.stl_acct_prod_id is '结算账户产品编号';
comment on column ${iml_schema}.agt_log_acct_h.advc_amt is '垫款金额';
comment on column ${iml_schema}.agt_log_acct_h.advc_loan_acct_num is '垫款贷款账号';
comment on column ${iml_schema}.agt_log_acct_h.advc_fix_pnlt_int_rat is '垫款固定罚息利率';
comment on column ${iml_schema}.agt_log_acct_h.begin_dt is '起始日期';
comment on column ${iml_schema}.agt_log_acct_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_log_acct_h.log_status_cd is '保函状态代码';
comment on column ${iml_schema}.agt_log_acct_h.remark is '备注';
comment on column ${iml_schema}.agt_log_acct_h.cont_curr_cd is '合同币种代码';
comment on column ${iml_schema}.agt_log_acct_h.log_init_froz_amt is '保函原始冻结金额';
comment on column ${iml_schema}.agt_log_acct_h.benefc_cert_type_cd is '受益人证件类型代码';
comment on column ${iml_schema}.agt_log_acct_h.benefc_cert_no is '受益人证件号码';
comment on column ${iml_schema}.agt_log_acct_h.new_log_termnt_dt is '新保函终止日期';
comment on column ${iml_schema}.agt_log_acct_h.mtg_cont_id is '抵押合同编号';
comment on column ${iml_schema}.agt_log_acct_h.benefc_resdnt_addr is '受益人居住地址';
comment on column ${iml_schema}.agt_log_acct_h.col_book_val is '押品账面价值';
comment on column ${iml_schema}.agt_log_acct_h.surp_compens_amt is '剩余赔付金额';
comment on column ${iml_schema}.agt_log_acct_h.log_compens_status_cd is '保函赔付状态代码';
comment on column ${iml_schema}.agt_log_acct_h.loan_sign_cont_amt is '贷款签约合同金额';
comment on column ${iml_schema}.agt_log_acct_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_log_acct_h.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.agt_log_acct_h.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.agt_log_acct_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_log_acct_h.ghb_benefc_acct_num_flg is '本行受益人账号标志';
comment on column ${iml_schema}.agt_log_acct_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_log_acct_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_log_acct_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_log_acct_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_log_acct_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_log_acct_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_log_acct_h.etl_timestamp is 'ETL处理时间戳';
