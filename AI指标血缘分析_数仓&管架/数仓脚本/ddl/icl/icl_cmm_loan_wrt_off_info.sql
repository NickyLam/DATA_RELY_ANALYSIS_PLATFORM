/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_loan_wrt_off_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_loan_wrt_off_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_loan_wrt_off_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_loan_wrt_off_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(60) -- 账户编号
    ,dubil_id varchar2(60) -- 借据编号
    ,cont_id varchar2(60) -- 合同编号
    ,loan_num varchar2(60) -- 贷款号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,cust_id varchar2(60) -- 客户编号
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,appl_teller_id varchar2(60) -- 申请柜员编号
    ,fir_wrt_off_dt date -- 首次核销日期
    ,curr_cd varchar2(60) -- 币种代码
    ,actl_wrtoff_loan_pric number(30,2) -- 实核贷款本金
    ,actl_wrtoff_in_bs_int number(30,2) -- 实核表内利息
    ,actl_wrtoff_off_bs_int number(30,2) -- 实核表外利息
    ,wrt_off_advc_money_amt number(38,6) -- 核销垫付款项金额
    ,wrt_off_retra_pric number(30,2) -- 核销收回本金
    ,wrt_off_retra_in_bs_int number(30,2) -- 核销收回表内利息
    ,wrt_off_retra_off_bs_int number(30,2) -- 核销收回表外利息
    ,wrt_off_retra_advc_fee number(30,2) -- 核销收回垫付费用
    ,wrt_off_retra_cnt number(22) -- 核销收回笔数
    ,all_retra_flg varchar2(10) -- 全部收回标志
    ,final_wrt_off_retra_dt date -- 最后核销收回日期
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
grant select on ${icl_schema}.cmm_loan_wrt_off_info to ${idl_schema};
grant select on ${icl_schema}.cmm_loan_wrt_off_info to ${iel_schema};
grant select on ${icl_schema}.cmm_loan_wrt_off_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_loan_wrt_off_info is '贷款核销信息';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.acct_id is '账户编号';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.dubil_id is '借据编号';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.cont_id is '合同编号';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.loan_num is '贷款号';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.belong_org_id is '所属机构编号';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.appl_teller_id is '申请柜员编号';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.fir_wrt_off_dt is '首次核销日期';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.actl_wrtoff_loan_pric is '实核贷款本金';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.actl_wrtoff_in_bs_int is '实核表内利息';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.actl_wrtoff_off_bs_int is '实核表外利息';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.wrt_off_advc_money_amt is '核销垫付款项金额';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.wrt_off_retra_pric is '核销收回本金';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.wrt_off_retra_in_bs_int is '核销收回表内利息';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.wrt_off_retra_off_bs_int is '核销收回表外利息';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.wrt_off_retra_advc_fee is '核销收回垫付费用';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.wrt_off_retra_cnt is '核销收回笔数';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.all_retra_flg is '全部收回标志';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.final_wrt_off_retra_dt is '最后核销收回日期';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_loan_wrt_off_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_loan_wrt_off_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_loan_wrt_off_info.etl_timestamp is 'ETL处理时间戳';
