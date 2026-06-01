/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_log_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_log_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_log_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_log_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,acct_id varchar2(100) -- 账户编号
    ,tran_seq_num varchar2(60) -- 交易序号
    ,lmt_id varchar2(100) -- 限制编号
    ,tran_descb varchar2(500) -- 交易描述
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,vrif_post_forbid_flg varchar2(10) -- 核实后禁止标志
    ,revo_flg varchar2(10) -- 撤销标志
    ,log_id varchar2(100) -- 保函编号
    ,bus_prod_id varchar2(100) -- 业务产品编号
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,guar_org_id varchar2(100) -- 担保机构编号
    ,rev_guar_org_id varchar2(100) -- 反担机构编号
    ,log_cont_id varchar2(100) -- 保函合同编号
    ,applit_stl_acct_id varchar2(100) -- 申请人结算账户编号
    ,benefc_acct_id varchar2(100) -- 受益人账户编号
    ,benefc_name varchar2(500) -- 受益人名称
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,curr_cd varchar2(30) -- 币种代码
    ,log_amt number(30,2) -- 保函金额
    ,stop_pay_ratio number(18,6) -- 止付比例
    ,margin_amt number(30,2) -- 保证金金额
    ,pymc_cust_acct_num varchar2(60) -- 备款客户账号
    ,pymc_acct_sub_acct_num varchar2(60) -- 备款账户子账号
    ,pymc_acct_curr_cd varchar2(30) -- 备款账户币种代码
    ,pymc_acct_prod_id varchar2(100) -- 备款账户产品编号
    ,pbc_clear_cust_acct_num varchar2(60) -- 人行清算客户账号
    ,stl_acct_sub_acct_num varchar2(60) -- 结算账户子账号
    ,stl_acct_curr_cd varchar2(30) -- 结算账户币种代码
    ,stl_acct_prod_id varchar2(100) -- 结算账户产品编号
    ,margin_cust_acct_num varchar2(60) -- 保证金客户账号
    ,margin_acct_sub_acct_num varchar2(60) -- 保证金账户子账号
    ,margin_acct_curr_cd varchar2(30) -- 保证金账户币种代码
    ,margin_acct_prod_id varchar2(100) -- 保证金账户产品编号
    ,advc_amt number(30,2) -- 垫款金额
    ,advc_dubil_id varchar2(100) -- 垫款借据编号
    ,advc_fix_pnlt_int_rat number(18,8) -- 垫款固定罚息利率
    ,begin_dt date -- 起始日期
    ,exp_dt date -- 到期日期
    ,log_status_cd varchar2(30) -- 保函状态代码
    ,evt_cate_id varchar2(100) -- 事件类别编号
    ,post_flg varchar2(10) -- 过账标志
    ,tran_termn_id varchar2(100) -- 交易终端编号
    ,log_valid_flg varchar2(10) -- 保函有效标志
    ,remark varchar2(500) -- 备注
    ,mtg_cont_id varchar2(100) -- 抵押合同编号
    ,log_compens_status_cd varchar2(30) -- 保函赔付状态代码
    ,loan_sign_cont_amt number(30,2) -- 贷款签约合同金额
    ,benefc_cert_type_cd varchar2(30) -- 受益人证件类型代码
    ,benefc_cert_no varchar2(60) -- 受益人证件号码
    ,col_book_val number(30,2) -- 押品账面价值
    ,new_log_termnt_dt date -- 新保函终止日期
    ,benefc_resdnt_addr varchar2(500) -- 受益人居住地址
    ,cont_curr_cd varchar2(30) -- 合同币种代码
    ,log_compens_amt number(30,2) -- 保函赔付金额
    ,cust_id varchar2(100) -- 客户编号
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_tm timestamp -- 交易时间
    ,check_entry_code varchar2(60) -- 对账编码
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_log_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_log_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_log_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_log_tran_flow is '保函交易流水';
comment on column ${iml_schema}.evt_log_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_log_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_log_tran_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_log_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_log_tran_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_log_tran_flow.tran_seq_num is '交易序号';
comment on column ${iml_schema}.evt_log_tran_flow.lmt_id is '限制编号';
comment on column ${iml_schema}.evt_log_tran_flow.tran_descb is '交易描述';
comment on column ${iml_schema}.evt_log_tran_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_log_tran_flow.vrif_post_forbid_flg is '核实后禁止标志';
comment on column ${iml_schema}.evt_log_tran_flow.revo_flg is '撤销标志';
comment on column ${iml_schema}.evt_log_tran_flow.log_id is '保函编号';
comment on column ${iml_schema}.evt_log_tran_flow.bus_prod_id is '业务产品编号';
comment on column ${iml_schema}.evt_log_tran_flow.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_log_tran_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_log_tran_flow.guar_org_id is '担保机构编号';
comment on column ${iml_schema}.evt_log_tran_flow.rev_guar_org_id is '反担机构编号';
comment on column ${iml_schema}.evt_log_tran_flow.log_cont_id is '保函合同编号';
comment on column ${iml_schema}.evt_log_tran_flow.applit_stl_acct_id is '申请人结算账户编号';
comment on column ${iml_schema}.evt_log_tran_flow.benefc_acct_id is '受益人账户编号';
comment on column ${iml_schema}.evt_log_tran_flow.benefc_name is '受益人名称';
comment on column ${iml_schema}.evt_log_tran_flow.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_log_tran_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_log_tran_flow.log_amt is '保函金额';
comment on column ${iml_schema}.evt_log_tran_flow.stop_pay_ratio is '止付比例';
comment on column ${iml_schema}.evt_log_tran_flow.margin_amt is '保证金金额';
comment on column ${iml_schema}.evt_log_tran_flow.pymc_cust_acct_num is '备款客户账号';
comment on column ${iml_schema}.evt_log_tran_flow.pymc_acct_sub_acct_num is '备款账户子账号';
comment on column ${iml_schema}.evt_log_tran_flow.pymc_acct_curr_cd is '备款账户币种代码';
comment on column ${iml_schema}.evt_log_tran_flow.pymc_acct_prod_id is '备款账户产品编号';
comment on column ${iml_schema}.evt_log_tran_flow.pbc_clear_cust_acct_num is '人行清算客户账号';
comment on column ${iml_schema}.evt_log_tran_flow.stl_acct_sub_acct_num is '结算账户子账号';
comment on column ${iml_schema}.evt_log_tran_flow.stl_acct_curr_cd is '结算账户币种代码';
comment on column ${iml_schema}.evt_log_tran_flow.stl_acct_prod_id is '结算账户产品编号';
comment on column ${iml_schema}.evt_log_tran_flow.margin_cust_acct_num is '保证金客户账号';
comment on column ${iml_schema}.evt_log_tran_flow.margin_acct_sub_acct_num is '保证金账户子账号';
comment on column ${iml_schema}.evt_log_tran_flow.margin_acct_curr_cd is '保证金账户币种代码';
comment on column ${iml_schema}.evt_log_tran_flow.margin_acct_prod_id is '保证金账户产品编号';
comment on column ${iml_schema}.evt_log_tran_flow.advc_amt is '垫款金额';
comment on column ${iml_schema}.evt_log_tran_flow.advc_dubil_id is '垫款借据编号';
comment on column ${iml_schema}.evt_log_tran_flow.advc_fix_pnlt_int_rat is '垫款固定罚息利率';
comment on column ${iml_schema}.evt_log_tran_flow.begin_dt is '起始日期';
comment on column ${iml_schema}.evt_log_tran_flow.exp_dt is '到期日期';
comment on column ${iml_schema}.evt_log_tran_flow.log_status_cd is '保函状态代码';
comment on column ${iml_schema}.evt_log_tran_flow.evt_cate_id is '事件类别编号';
comment on column ${iml_schema}.evt_log_tran_flow.post_flg is '过账标志';
comment on column ${iml_schema}.evt_log_tran_flow.tran_termn_id is '交易终端编号';
comment on column ${iml_schema}.evt_log_tran_flow.log_valid_flg is '保函有效标志';
comment on column ${iml_schema}.evt_log_tran_flow.remark is '备注';
comment on column ${iml_schema}.evt_log_tran_flow.mtg_cont_id is '抵押合同编号';
comment on column ${iml_schema}.evt_log_tran_flow.log_compens_status_cd is '保函赔付状态代码';
comment on column ${iml_schema}.evt_log_tran_flow.loan_sign_cont_amt is '贷款签约合同金额';
comment on column ${iml_schema}.evt_log_tran_flow.benefc_cert_type_cd is '受益人证件类型代码';
comment on column ${iml_schema}.evt_log_tran_flow.benefc_cert_no is '受益人证件号码';
comment on column ${iml_schema}.evt_log_tran_flow.col_book_val is '押品账面价值';
comment on column ${iml_schema}.evt_log_tran_flow.new_log_termnt_dt is '新保函终止日期';
comment on column ${iml_schema}.evt_log_tran_flow.benefc_resdnt_addr is '受益人居住地址';
comment on column ${iml_schema}.evt_log_tran_flow.cont_curr_cd is '合同币种代码';
comment on column ${iml_schema}.evt_log_tran_flow.log_compens_amt is '保函赔付金额';
comment on column ${iml_schema}.evt_log_tran_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_log_tran_flow.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.evt_log_tran_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_log_tran_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_log_tran_flow.check_entry_code is '对账编码';
comment on column ${iml_schema}.evt_log_tran_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_log_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_log_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_log_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_log_tran_flow.etl_timestamp is 'ETL处理时间戳';
