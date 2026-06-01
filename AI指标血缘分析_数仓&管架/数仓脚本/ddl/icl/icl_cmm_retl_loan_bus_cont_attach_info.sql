/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_retl_loan_bus_cont_attach_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_retl_loan_bus_cont_attach_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_retl_loan_bus_cont_attach_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_retl_loan_bus_cont_attach_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cont_id varchar2(60) -- 合同编号
    ,cont_name varchar2(500) -- 合同名称
    ,cust_id varchar2(60) -- 客户编号
    ,lmt_cont_id varchar2(60) -- 额度合同编号
    ,oper_teller_id varchar2(100) -- 经办柜员编号
    ,mgmt_teller_id varchar2(100) -- 管理柜员编号
    ,cont_type_cd varchar2(10) -- 合同类型代码
    ,level5_cls_cd varchar2(30) -- 五级分类代码
    ,int_rat_mode_cd varchar2(30) -- 利率模式代码
    ,ocup_open_lmt_risk_type_cd varchar2(30) -- 占用敞口额度风险类型代码
    ,cont_bal number(30,2) -- 合同余额
    ,margin_amt number(30,2) -- 保证金金额
    ,rgst_dt date -- 登记日期
    ,loan_usage_descb varchar2(2000) -- 贷款用途描述
    ,remark varchar2(4000) -- 备注
    ,recvbl_bank_card_card_no varchar2(100) -- 收款银行卡卡号
    ,recvbl_bank_card_name varchar2(500) -- 收款银行卡名称
    ,recvbl_bank_no varchar2(100) -- 收款银行行号
    ,recvbl_bank_name varchar2(500) -- 收款银行名称
    ,repay_bank_card_num varchar2(100) -- 还款银行卡号
    ,repay_bank_card_name varchar2(500) -- 还款银行卡名称
    ,repay_bank_no varchar2(100) -- 还款银行行号
    ,repay_bank_name varchar2(500) -- 还款银行名称
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_retl_loan_bus_cont_attach_info to ${idl_schema};
grant select on ${icl_schema}.cmm_retl_loan_bus_cont_attach_info to ${iel_schema};
grant select on ${icl_schema}.cmm_retl_loan_bus_cont_attach_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_retl_loan_bus_cont_attach_info is '零售贷款业务合同补充信息';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.cont_id is '合同编号';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.cont_name is '合同名称';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.lmt_cont_id is '额度合同编号';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.oper_teller_id is '经办柜员编号';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.mgmt_teller_id is '管理柜员编号';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.cont_type_cd is '合同类型代码';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.level5_cls_cd is '五级分类代码';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.int_rat_mode_cd is '利率模式代码';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.ocup_open_lmt_risk_type_cd is '占用敞口额度风险类型代码';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.cont_bal is '合同余额';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.margin_amt is '保证金金额';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.rgst_dt is '登记日期';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.loan_usage_descb is '贷款用途描述';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.remark is '备注';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.recvbl_bank_card_card_no is '收款银行卡卡号';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.recvbl_bank_card_name is '收款银行卡名称';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.recvbl_bank_no is '收款银行行号';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.recvbl_bank_name is '收款银行名称';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.repay_bank_card_num is '还款银行卡号';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.repay_bank_card_name is '还款银行卡名称';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.repay_bank_no is '还款银行行号';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.repay_bank_name is '还款银行名称';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_retl_loan_bus_cont_attach_info.etl_timestamp is '数据处理时间';

