/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_ibank_cust_chat_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_ibank_cust_chat_info
whenever sqlerror continue none;
drop table ${iml_schema}.pty_ibank_cust_chat_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_ibank_cust_chat_info(
    party_id varchar2(100) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,fin_inst_cate_cd varchar2(30) -- 金融机构类别代码
    ,open_acct_lics_num varchar2(60) -- 开户许可证号码
    ,fx_mang_lics_num varchar2(60) -- 外汇经营许可证号码
    ,fin_lics_num varchar2(60) -- 金融许可证号码
    ,csrc_cd_no varchar2(30) -- 证监会代码证号
    ,ibank_no varchar2(60) -- 联行号
    ,swift_id varchar2(60) -- SWIFT编号
    ,apv_num varchar2(60) -- 审批文号
    ,apv_num_valid_dt date -- 审批文号有效日期
    ,corp_fori_exch_cd varchar2(30) -- 企业外管代码
    ,cbrc_oss_code varchar2(60) -- 银监会非现场监管编码
    ,cbrc_oss_code_valid_dt date -- 银监会非现场监管编码有效日期
    ,insure_lics_num varchar2(60) -- 保险许可证号码
    ,insure_lics_valid_dt date -- 保险许可证有效日期
    ,secu_lics_num varchar2(60) -- 证券许可证号码
    ,secu_lics_valid_dt date -- 证券许可证有效日期
    ,intstl_factor_cert_num varchar2(60) -- 国结保理商证号
    ,fin_inst_code varchar2(60) -- 金融机构编码
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
grant select on ${iml_schema}.pty_ibank_cust_chat_info to ${icl_schema};
grant select on ${iml_schema}.pty_ibank_cust_chat_info to ${idl_schema};
grant select on ${iml_schema}.pty_ibank_cust_chat_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_ibank_cust_chat_info is '同业客户特有信息';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.party_id is '当事人编号';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.lp_id is '法人编号';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.fin_inst_cate_cd is '金融机构类别代码';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.open_acct_lics_num is '开户许可证号码';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.fx_mang_lics_num is '外汇经营许可证号码';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.fin_lics_num is '金融许可证号码';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.csrc_cd_no is '证监会代码证号';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.ibank_no is '联行号';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.swift_id is 'SWIFT编号';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.apv_num is '审批文号';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.apv_num_valid_dt is '审批文号有效日期';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.corp_fori_exch_cd is '企业外管代码';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.cbrc_oss_code is '银监会非现场监管编码';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.cbrc_oss_code_valid_dt is '银监会非现场监管编码有效日期';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.insure_lics_num is '保险许可证号码';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.insure_lics_valid_dt is '保险许可证有效日期';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.secu_lics_num is '证券许可证号码';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.secu_lics_valid_dt is '证券许可证有效日期';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.intstl_factor_cert_num is '国结保理商证号';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.fin_inst_code is '金融机构编码';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.start_dt is '开始时间';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.end_dt is '结束时间';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.id_mark is '增删标志';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.job_cd is '任务编码';
comment on column ${iml_schema}.pty_ibank_cust_chat_info.etl_timestamp is 'ETL处理时间戳';
