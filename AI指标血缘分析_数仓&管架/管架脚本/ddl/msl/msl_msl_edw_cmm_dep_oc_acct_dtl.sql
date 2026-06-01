/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_cmm_dep_oc_acct_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl(
    etl_dt date
    ,lp_id varchar2(60)
    ,oc_acct_flow_num varchar2(500)
    ,ova_chn_flow_num varchar2(500)
    ,tran_flow_num varchar2(60)
    ,tran_dt date
    ,acct_id varchar2(60)
    ,acct_name varchar2(500)
    ,open_vouch_id varchar2(60)
    ,dep_prod_acct_id varchar2(200)
    ,belong_org_id varchar2(20)
    ,tran_org_id varchar2(20)
    ,sav_type_cd varchar2(10)
    ,dep_term_cd varchar2(10)
    ,open_vouch_type_cd varchar2(10)
    ,proc_status_cd varchar2(10)
    ,chn_cd varchar2(60)
    ,curr_cd varchar2(10)
    ,operr_cert_type_cd varchar2(20)
    ,operr_cert_no varchar2(60)
    ,operr_mobile_no varchar2(20)
    ,operr_info_invalid_dt date
    ,ec_flg varchar2(10)
    ,oc_acct_flg varchar2(10)
    ,strk_bal_flg varchar2(10)
    ,tran_amt number(30,2)
    ,sub_acct_id varchar2(60)
    ,agent_idf_cd varchar2(10)
    ,agent_name varchar2(60)
    ,agent_cert_type_cd varchar2(10)
    ,agent_cert_no varchar2(60)
    ,agent_cert_start_dt date
    ,agent_cert_exp_dt date
    ,old_sub_acct_id varchar2(10)
    ,old_dep_prod_acct_id varchar2(200)
    ,tran_teller_id varchar2(60)
    ,dep_term_tenor_type_cd varchar2(10)
    ,agent_phone varchar2(60)
    ,agent_licen_issue_autho_site varchar2(100)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl is '存款开销户明细';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.etl_dt is 'ETL处理日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.lp_id is '法人编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.oc_acct_flow_num is '开销户流水号';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.ova_chn_flow_num is '全局渠道流水号';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.tran_flow_num is '交易流水号';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.tran_dt is '交易日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.acct_id is '账户编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.acct_name is '账户名称';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.open_vouch_id is '开户凭证编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.dep_prod_acct_id is '存款产品户编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.belong_org_id is '归属机构编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.tran_org_id is '交易机构编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.sav_type_cd is '储种代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.dep_term_cd is '存期代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.open_vouch_type_cd is '开户凭证类型代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.proc_status_cd is '处理状态代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.chn_cd is '渠道编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.curr_cd is '币种代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.operr_cert_type_cd is '经办人证件类型代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.operr_cert_no is '经办人证件号';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.operr_mobile_no is '经办人手机号';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.operr_info_invalid_dt is '经办人信息失效日期';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.ec_flg is '钞汇标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.oc_acct_flg is '开销户标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.strk_bal_flg is '冲账标志';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.tran_amt is '交易金额';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.sub_acct_id is '子户编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.agent_idf_cd is '代理标识代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.agent_name is '代理人名称';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.agent_cert_type_cd is '代理人证件类型代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.agent_cert_no is '代理人证件号码';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.agent_cert_start_dt is '代理人证件开始日';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.agent_cert_exp_dt is '代理人证件到期日';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.old_sub_acct_id is '旧子户编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.old_dep_prod_acct_id is '旧存款产品户编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.tran_teller_id is '交易柜员编号';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.dep_term_tenor_type_cd is '存期期限类型代码';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.agent_phone is '代理人联系电话';
comment on column ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl.agent_licen_issue_autho_site is '代理人发证机关所在地';
