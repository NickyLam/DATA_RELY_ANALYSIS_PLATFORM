/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_abs_base_asset_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_abs_base_asset_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_abs_base_asset_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_abs_base_asset_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,base_asset_id varchar2(60) -- 基础资产编号
    ,cust_id varchar2(60) -- 客户编号
    ,dubil_id varchar2(60) -- 借据编号
    ,cont_id varchar2(100) -- 合同编号
    ,loan_cont_id varchar2(60) -- 贷款合同编号
    ,asset_pool_id varchar2(100) -- 资产池编号
    ,curr_cd varchar2(30) -- 币种代码
    ,loan_amt number(30,2) -- 贷款金额
    ,bad_debt_amt number(30,2) -- 坏账金额
    ,ovdue_amt number(30,2) -- 逾期金额
    ,loan_bal number(30,2) -- 贷款余额
    ,idle_amt number(30,2) -- 呆滞金额
    ,rpbl_int number(30,2) -- 应还利息
    ,asset_status_cd varchar2(30) -- 资产状态代码
    ,tran_cosdetn number(30,2) -- 转让对价
    ,pkg_belong_hxb_int number(30,2) -- 封包时归属我行利息
    ,pkg_pric_bal number(30,8) -- 封包时本金余额
    ,pkg_asset_bal number(30,8) -- 封包时资产余额
    ,pkg_belong_hxb_int_rat number(30,8) -- 封包时归属我行利率
    ,redem_belong_hxb_int number(30,8) -- 赎回时归属我行利息
    ,redem_belong_trust_int number(30,8) -- 赎回时归属信托利息
    ,redem_cosdetn number(30,8) -- 赎回对价
    ,redem_belong_trust_pric number(30,8) -- 赎回时归属信托本金
    ,redem_cosdetn_pric number(30,8) -- 赎回对价本金
    ,redem_cosdetn_int number(30,8) -- 赎回对价利息
    ,pkg_bf_int_recvbl_bal number(30,2) -- 封包前应收利息余额
    ,pkg_post_int_recvbl_tot number(30,2) -- 封包后应收利息总额
    ,pkg_post_int_recvbl_bal number(30,2) -- 封包后应收利息余额
    ,rtn_pkg_post_int_recvbl number(30,2) -- 已归还封包后应收利息
    ,tran_loan_int_tot number(30,2) -- 转让贷款利息总额
    ,recvbl_acct_id varchar2(60) -- 收款账户编号
    ,recvbl_acct_name varchar2(150) -- 收款账户名称
    ,recvbl_acct_belong_org_id varchar2(60) -- 收款账户所属机构编号
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
grant select on ${icl_schema}.cmm_abs_base_asset_info to ${idl_schema};
grant select on ${icl_schema}.cmm_abs_base_asset_info to ${iel_schema};
grant select on ${icl_schema}.cmm_abs_base_asset_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_abs_base_asset_info is '资产证券化基础资产信息';
comment on column ${icl_schema}.cmm_abs_base_asset_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_abs_base_asset_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_abs_base_asset_info.base_asset_id is '基础资产编号';
comment on column ${icl_schema}.cmm_abs_base_asset_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_abs_base_asset_info.dubil_id is '借据编号';
comment on column ${icl_schema}.cmm_abs_base_asset_info.cont_id is '合同编号';
comment on column ${icl_schema}.cmm_abs_base_asset_info.loan_cont_id is '贷款合同编号';
comment on column ${icl_schema}.cmm_abs_base_asset_info.asset_pool_id is '资产池编号';
comment on column ${icl_schema}.cmm_abs_base_asset_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_abs_base_asset_info.loan_amt is '贷款金额';
comment on column ${icl_schema}.cmm_abs_base_asset_info.bad_debt_amt is '坏账金额';
comment on column ${icl_schema}.cmm_abs_base_asset_info.ovdue_amt is '逾期金额';
comment on column ${icl_schema}.cmm_abs_base_asset_info.loan_bal is '贷款余额';
comment on column ${icl_schema}.cmm_abs_base_asset_info.idle_amt is '呆滞金额';
comment on column ${icl_schema}.cmm_abs_base_asset_info.rpbl_int is '应还利息';
comment on column ${icl_schema}.cmm_abs_base_asset_info.asset_status_cd is '资产状态代码';
comment on column ${icl_schema}.cmm_abs_base_asset_info.tran_cosdetn is '转让对价';
comment on column ${icl_schema}.cmm_abs_base_asset_info.pkg_belong_hxb_int is '封包时归属我行利息';
comment on column ${icl_schema}.cmm_abs_base_asset_info.pkg_pric_bal is '封包时本金余额';
comment on column ${icl_schema}.cmm_abs_base_asset_info.pkg_asset_bal is '封包时资产余额';
comment on column ${icl_schema}.cmm_abs_base_asset_info.pkg_belong_hxb_int_rat is '封包时归属我行利率';
comment on column ${icl_schema}.cmm_abs_base_asset_info.redem_belong_hxb_int is '赎回时归属我行利息';
comment on column ${icl_schema}.cmm_abs_base_asset_info.redem_belong_trust_int is '赎回时归属信托利息';
comment on column ${icl_schema}.cmm_abs_base_asset_info.redem_cosdetn is '赎回对价';
comment on column ${icl_schema}.cmm_abs_base_asset_info.redem_belong_trust_pric is '赎回时归属信托本金';
comment on column ${icl_schema}.cmm_abs_base_asset_info.redem_cosdetn_pric is '赎回对价本金';
comment on column ${icl_schema}.cmm_abs_base_asset_info.redem_cosdetn_int is '赎回对价利息';
comment on column ${icl_schema}.cmm_abs_base_asset_info.pkg_bf_int_recvbl_bal is '封包前应收利息余额';
comment on column ${icl_schema}.cmm_abs_base_asset_info.pkg_post_int_recvbl_tot is '封包后应收利息总额';
comment on column ${icl_schema}.cmm_abs_base_asset_info.pkg_post_int_recvbl_bal is '封包后应收利息余额';
comment on column ${icl_schema}.cmm_abs_base_asset_info.rtn_pkg_post_int_recvbl is '已归还封包后应收利息';
comment on column ${icl_schema}.cmm_abs_base_asset_info.tran_loan_int_tot is '转让贷款利息总额';
comment on column ${icl_schema}.cmm_abs_base_asset_info.recvbl_acct_id is '收款账户编号';
comment on column ${icl_schema}.cmm_abs_base_asset_info.recvbl_acct_name is '收款账户名称';
comment on column ${icl_schema}.cmm_abs_base_asset_info.recvbl_acct_belong_org_id is '收款账户所属机构编号';
comment on column ${icl_schema}.cmm_abs_base_asset_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_abs_base_asset_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_abs_base_asset_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_abs_base_asset_info.etl_timestamp is 'ETL处理时间戳';
