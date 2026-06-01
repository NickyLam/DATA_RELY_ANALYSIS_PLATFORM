/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_loan_acct_accti_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_loan_acct_accti_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_loan_acct_accti_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_loan_acct_accti_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,accti_seq_num varchar2(60) -- 核算序号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,acct_id varchar2(100) -- 账户编号
    ,loan_num varchar2(60) -- 贷款号
    ,distr_flow_num varchar2(100) -- 放款流水号
    ,acct_curr_cd varchar2(30) -- 账户币种代码
    ,prod_id varchar2(100) -- 产品编号
    ,camp_prod_id varchar2(100) -- 营销产品编号
    ,camp_prod_name varchar2(500) -- 营销产品名称
    ,acct_name varchar2(500) -- 账户名称
    ,cust_id varchar2(100) -- 客户编号
    ,acct_status_cd varchar2(30) -- 账户状态代码
    ,accti_status_cd varchar2(30) -- 核算状态代码
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,sob_cate_cd varchar2(30) -- 账套类别代码
    ,src_module_type_cd varchar2(30) -- 源模块类型代码
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,tran_code varchar2(100) -- 交易码
    ,evt_cate_id varchar2(100) -- 事件类别编号
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,tran_amt number(30,2) -- 交易金额
    ,org_id varchar2(100) -- 机构编号
    ,chn_id varchar2(100) -- 渠道编号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,bank_tran_seq_num varchar2(60) -- 银行交易序号
    ,revs_flg varchar2(10) -- 冲正标志
    ,revs_dt date -- 冲正日期
    ,tran_descb varchar2(500) -- 交易描述
    ,post_flg varchar2(10) -- 过账标志
    ,loan_org_id varchar2(100) -- 贷款机构编号
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,check_entry_code varchar2(60) -- 对账编码
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
grant select on ${iml_schema}.evt_loan_acct_accti_flow to ${icl_schema};
grant select on ${iml_schema}.evt_loan_acct_accti_flow to ${idl_schema};
grant select on ${iml_schema}.evt_loan_acct_accti_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_loan_acct_accti_flow is '贷款账户核算流水';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.accti_seq_num is '核算序号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.loan_num is '贷款号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.distr_flow_num is '放款流水号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.acct_curr_cd is '账户币种代码';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.prod_id is '产品编号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.camp_prod_id is '营销产品编号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.camp_prod_name is '营销产品名称';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.acct_name is '账户名称';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.accti_status_cd is '核算状态代码';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.sob_cate_cd is '账套类别代码';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.src_module_type_cd is '源模块类型代码';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.tran_code is '交易码';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.evt_cate_id is '事件类别编号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.org_id is '机构编号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.bank_tran_seq_num is '银行交易序号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.revs_flg is '冲正标志';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.revs_dt is '冲正日期';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.tran_descb is '交易描述';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.post_flg is '过账标志';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.loan_org_id is '贷款机构编号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.check_entry_code is '对账编码';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_loan_acct_accti_flow.etl_timestamp is 'ETL处理时间戳';
