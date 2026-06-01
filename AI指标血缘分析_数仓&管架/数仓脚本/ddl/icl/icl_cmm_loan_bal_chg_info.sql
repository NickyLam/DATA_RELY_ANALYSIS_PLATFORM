/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_loan_bal_chg_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_loan_bal_chg_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_loan_bal_chg_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_loan_bal_chg_info(
     etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(100) --借据编号
    ,cust_id varchar2(100) --客户编号
    ,std_prod_id varchar2(60) --标准产品编号
    ,bus_line_cd varchar2(10) --业务条线代码
    ,disp_type_cd varchar2(10) --处置类型代码
    ,disp_way_cd varchar2(10) --处置方式代码
    ,tran_type_cd varchar2(10) --转让类型代码
    ,bal_chag_date date --余额变动日期
    ,bal_tm_ear_lvl5_cls_cd varchar2(10) --余额时点年初五级分类代码
    ,bal_tm_lvl5_cls_cd varchar2(10) --余额时点五级分类代码
    ,tran_dt date --转让日期
    ,wrt_off_dt date --核销日期
    ,prob_loan_dt date --问题贷款日期
    ,ear_y_pric_bal number(30,2) --年初本金余额 
    ,pric_amt number(30,2) --本金金额
    ,int_amt number(30,2) --利息金额
    ,pnlt_amt number(30,2) --罚息金额
    ,comp_int_amt number(30,2) --复息金额
    ,fee_amt number(30,2) --费用金额
    ,open_acct_org_id varchar2(60) --开户机构编号
    ,mgmt_org_id varchar2(60) --管理机构编号
    ,acct_instit_id varchar2(60) --账务机构编号
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
grant select on ${icl_schema}.cmm_loan_bal_chg_info to ${idl_schema};
grant select on ${icl_schema}.cmm_loan_bal_chg_info to ${iel_schema};
grant select on ${icl_schema}.cmm_loan_bal_chg_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_loan_bal_chg_info is '不良问题贷款余额变动信息';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.dubil_id is '借据编号';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.bus_line_cd is '业务条线代码';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.disp_type_cd is '处置类型代码';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.disp_way_cd is '处置方式代码';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.tran_type_cd is '转让类型代码';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.bal_chag_date is '余额变动日期';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.bal_tm_ear_lvl5_cls_cd is '余额时点年初五级分类代码';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.bal_tm_lvl5_cls_cd is '余额时点五级分类代码';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.tran_dt is '转让日期';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.wrt_off_dt is '核销日期';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.prob_loan_dt is '问题贷款日期';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.ear_y_pric_bal is '年初本金余额';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.pric_amt is '本金金额';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.int_amt is '利息金额';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.pnlt_amt is '罚息金额';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.comp_int_amt is '复息金额';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.fee_amt is '费用金额';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.open_acct_org_id is '开户机构编号';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.mgmt_org_id is '管理机构编号';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_loan_bal_chg_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_loan_bal_chg_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_loan_bal_chg_info.etl_timestamp is 'ETL处理时间戳';
