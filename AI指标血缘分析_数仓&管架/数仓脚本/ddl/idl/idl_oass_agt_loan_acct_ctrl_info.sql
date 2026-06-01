/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_loan_acct_ctrl_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.oass_agt_loan_acct_ctrl_info
whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_loan_acct_ctrl_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.oass_agt_loan_acct_ctrl_info(
    etl_dt date -- 数据日期   
    ,agt_id varchar2(60) -- 协议编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,dubil_id varchar2(60) -- 借据编号   
    ,loan_cust_type_cd varchar2(10) -- 贷款客户类型代码   
    ,promis_loan_flg varchar2(10) -- 承诺贷款标志   
    ,circl_loan_flg varchar2(10) -- 循环贷款标志   
    ,unite_loan_flg varchar2(10) -- 联合贷款代码   
    ,deriv_loan_flg varchar2(10) -- 衍生贷款标志   
    ,agent_loan_flg varchar2(10) -- 代理贷款标志   
    ,acru_non_acru_accti_flg varchar2(10) -- 按应计非应计核算标志   
    ,oots_accti_flg varchar2(10) -- 按一逾两呆核算标志   
    ,loan_modal_subj_accti_flg varchar2(10) -- 贷款形态分科目核算标志   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识
    ,job_cd varchar2(10) -- 任务编码   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_loan_acct_ctrl_info to ${iel_schema};
grant select on ${idl_schema}.oass_agt_loan_acct_ctrl_info to ${idl_schema};


-- comment
comment on table ${idl_schema}.oass_agt_loan_acct_ctrl_info is '贷款账户控制信息';
comment on column ${idl_schema}.oass_agt_loan_acct_ctrl_info.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_loan_acct_ctrl_info.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_loan_acct_ctrl_info.lp_id is '法人编号';
comment on column ${idl_schema}.oass_agt_loan_acct_ctrl_info.dubil_id is '借据编号';
comment on column ${idl_schema}.oass_agt_loan_acct_ctrl_info.loan_cust_type_cd is '贷款客户类型代码';
comment on column ${idl_schema}.oass_agt_loan_acct_ctrl_info.promis_loan_flg is '承诺贷款标志';
comment on column ${idl_schema}.oass_agt_loan_acct_ctrl_info.circl_loan_flg is '循环贷款标志';
comment on column ${idl_schema}.oass_agt_loan_acct_ctrl_info.unite_loan_flg is '联合贷款代码';
comment on column ${idl_schema}.oass_agt_loan_acct_ctrl_info.deriv_loan_flg is '衍生贷款标志';
comment on column ${idl_schema}.oass_agt_loan_acct_ctrl_info.agent_loan_flg is '代理贷款标志';
comment on column ${idl_schema}.oass_agt_loan_acct_ctrl_info.acru_non_acru_accti_flg is '按应计非应计核算标志';
comment on column ${idl_schema}.oass_agt_loan_acct_ctrl_info.oots_accti_flg is '按一逾两呆核算标志';
comment on column ${idl_schema}.oass_agt_loan_acct_ctrl_info.loan_modal_subj_accti_flg is '贷款形态分科目核算标志';
comment on column ${idl_schema}.oass_agt_loan_acct_ctrl_info.create_dt is '创建日期';
comment on column ${idl_schema}.oass_agt_loan_acct_ctrl_info.update_dt is '更新日期';
comment on column ${idl_schema}.oass_agt_loan_acct_ctrl_info.id_mark is '删除标识';