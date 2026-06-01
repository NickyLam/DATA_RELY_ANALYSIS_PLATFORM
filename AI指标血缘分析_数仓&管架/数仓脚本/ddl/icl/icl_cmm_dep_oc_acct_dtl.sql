/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_dep_oc_acct_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_dep_oc_acct_dtl
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_dep_oc_acct_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_dep_oc_acct_dtl(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,oc_acct_flow_num varchar2(500) -- 开销户流水号
    ,ova_chn_flow_num varchar2(500) -- 全局渠道流水号
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,tran_timestamp date -- 交易时间
    ,acct_id varchar2(60) -- 账户编号
    ,sub_acct_id varchar2(60) -- 子户编号
    ,old_sub_acct_id varchar2(10) -- 旧子户编号
    ,acct_name varchar2(500) -- 账户名称
    ,open_vouch_id varchar2(60) -- 开户凭证编号
    ,dep_prod_acct_id varchar2(200) -- 存款产品户编号
    ,old_dep_prod_acct_id varchar2(200) -- 旧存款产品户编号
    ,tran_teller_id varchar2(60) -- 交易柜员编号
    ,belong_org_id varchar2(20) -- 归属机构编号
    ,tran_org_id varchar2(20) -- 交易机构编号
    ,sav_type_cd varchar2(10) -- 储种代码
    ,dep_term_cd varchar2(10) -- 存期代码
    ,dep_term_tenor_type_cd varchar2(10) -- 存期期限类型代码
    ,open_vouch_type_cd varchar2(10) -- 开户凭证类型代码
    ,proc_status_cd varchar2(10) -- 处理状态代码
    ,chn_cd varchar2(60) -- 渠道编号
    ,curr_cd varchar2(10) -- 币种代码
    ,operr_cert_type_cd varchar2(20) -- 经办人证件类型代码
    ,operr_cert_no varchar2(60) -- 经办人证件号
    ,operr_mobile_no varchar2(20) -- 经办人手机号
    ,operr_info_invalid_dt date -- 经办人信息失效日期
    ,ec_flg varchar2(10) -- 钞汇标志
    ,oc_acct_flg varchar2(10) -- 开销户标志
    ,strk_bal_flg varchar2(10) -- 冲账标志
    ,tran_amt number(30,2) -- 交易金额
    ,agent_idf_cd varchar2(10) -- 代理标识代码
    ,agent_name varchar2(60) -- 代理人名称
    ,agent_cert_type_cd varchar2(10) -- 代理人证件类型代码
    ,agent_cert_no varchar2(60) -- 代理人证件号码
    ,agent_cert_start_dt date -- 代理人证件开始日
    ,agent_cert_exp_dt date -- 代理人证件到期日
    ,agent_phone varchar2(60) -- 代理人联系电话
    ,agent_licen_issue_autho_site varchar2(100) -- 代理人发证机关所在地
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
grant select on ${icl_schema}.cmm_dep_oc_acct_dtl to ${idl_schema};
grant select on ${icl_schema}.cmm_dep_oc_acct_dtl to ${iel_schema};
grant select on ${icl_schema}.cmm_dep_oc_acct_dtl to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_dep_oc_acct_dtl is '存款开销户明细';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.oc_acct_flow_num is '开销户流水号';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.ova_chn_flow_num is '全局渠道流水号';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.tran_flow_num is '交易流水号';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.tran_dt is '交易日期';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.tran_timestamp is '交易时间';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.acct_id is '账户编号';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.sub_acct_id is '子户编号';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.old_sub_acct_id is '旧子户编号';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.acct_name is '账户名称';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.open_vouch_id is '开户凭证编号';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.dep_prod_acct_id is '存款产品户编号';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.old_dep_prod_acct_id is '旧存款产品户编号';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.tran_teller_id is '交易柜员编号';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.belong_org_id is '归属机构编号';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.tran_org_id is '交易机构编号';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.sav_type_cd is '储种代码';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.dep_term_cd is '存期代码';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.dep_term_tenor_type_cd is '存期期限类型代码';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.open_vouch_type_cd is '开户凭证类型代码';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.proc_status_cd is '处理状态代码';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.chn_cd is '渠道编号';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.operr_cert_type_cd is '经办人证件类型代码';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.operr_cert_no is '经办人证件号';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.operr_mobile_no is '经办人手机号';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.operr_info_invalid_dt is '经办人信息失效日期';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.ec_flg is '钞汇标志';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.oc_acct_flg is '开销户标志';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.strk_bal_flg is '冲账标志';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.tran_amt is '交易金额';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.agent_idf_cd is '代理标识代码';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.agent_name is '代理人名称';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.agent_cert_type_cd is '代理人证件类型代码';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.agent_cert_no is '代理人证件号码';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.agent_cert_start_dt is '代理人证件开始日';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.agent_cert_exp_dt is '代理人证件到期日';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.agent_phone is '代理人联系电话';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.agent_licen_issue_autho_site is '代理人发证机关所在地';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_dep_oc_acct_dtl.etl_timestamp is 'ETL处理时间戳';
