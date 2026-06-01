/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_cap_supv_coprator_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_cap_supv_coprator_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_cap_supv_coprator_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cap_supv_coprator_info_h(
    coprator_seq_num varchar2(250) -- 合作商序号
    ,lp_id varchar2(60) -- 法人编号
    ,coprator_id varchar2(500) -- 合作商编号
    ,coprator_name varchar2(2000) -- 合作商名称
    ,coprator_abbr varchar2(2000) -- 合作商简称
    ,cust_type_cd varchar2(2000) -- 客户类型代码
    ,trdpty_flow_num varchar2(500) -- 第三方流水号
    ,cert_type_cd varchar2(500) -- 证件类型代码
    ,cert_no varchar2(500) -- 证件号码
    ,cert_exp_dt date -- 证件到期日期
    ,legal_rep_name varchar2(500) -- 法定代表人名称
    ,legal_rep_cert_type_cd varchar2(500) -- 法定代表人证件类型代码
    ,legal_rep_cert_no varchar2(500) -- 法定代表人证件号码
    ,lp_cert_start_dt date -- 法人证件开始日期
    ,lp_cert_exp_dt date -- 法人证件到期日期
    ,lp_phone_num varchar2(500) -- 法人联系电话号码
    ,operr_name varchar2(2000) -- 经办人名称
    ,operr_cert_type_cd varchar2(500) -- 经办人证件类型代码
    ,operr_cert_no varchar2(500) -- 经办人证件号码
    ,operr_cert_start_dt date -- 经办人证件开始日期
    ,operr_cert_exp_dt date -- 经办人证件到期日期
    ,operr_mobile_no varchar2(500) -- 经办人手机号
    ,dtl_addr varchar2(2000) -- 详细地址
    ,zip_cd varchar2(500) -- 邮政编码
    ,phone_num varchar2(500) -- 联系电话号码
    ,monit_acct_id varchar2(500) -- 监控账户编号
    ,monit_acct_name varchar2(2000) -- 监控账户名称
    ,monit_acct_org_id varchar2(500) -- 监控账户机构编号
    ,monit_acct_org_name varchar2(2000) -- 监控账户机构名称
    ,mdl_enter_id varchar2(2000) -- 中间入账账户编号
    ,mdl_enter_name varchar2(2000) -- 中间入账账户名称
    ,mdl_enter_org_id varchar2(2000) -- 中间入账账户机构编号
    ,mdl_enter_org_name varchar2(2000) -- 中间入账账户机构名称
    ,trdpty_clear_enter_id varchar2(500) -- 第三方清算入账账户编号
    ,trdpty_clear_enter_name varchar2(2000) -- 第三方清算入账账户名称
    ,trdpty_clear_enter_org_id varchar2(500) -- 第三方清算入账账号机构编号
    ,trdpty_clear_enter_org_name varchar2(2000) -- 第三方清算入账账户机构名称
    ,trdpty_clear_enter_obank_flg varchar2(2000) -- 第三方清算入账账户他行标志
    ,corp_stl_acct_id varchar2(1000) -- 企业结算账户编号
    ,corp_stl_acct_name varchar2(1000) -- 企业结算账户名称
    ,corp_stl_acct_org_id varchar2(1000) -- 企业结算账户机构编号
    ,corp_stl_acct_org_name varchar2(1000) -- 企业结算账户机构名称
    ,cust_id varchar2(1000) -- 客户编号
    ,coprator_status_cd varchar2(60) -- 合作商状态代码
    ,clear_mode_cd varchar2(100) -- 清算模式代码
    ,dmic_st_msg_send_flg varchar2(100) -- 动账短信发送标志
    ,vtual_acct_id varchar2(250) -- 虚拟账户编号
    ,open_chn_cd varchar2(2000) -- 开通渠道代码
    ,bd_card_qtty_uplmi number(30) -- 绑定卡数量上限
    ,operr_id varchar2(2000) -- 操作员编号
    ,check_operr_id varchar2(500) -- 复核操作员编号
    ,update_tm timestamp -- 更新时间
    ,create_tm timestamp -- 创建时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.pty_cap_supv_coprator_info_h to ${icl_schema};
grant select on ${iml_schema}.pty_cap_supv_coprator_info_h to ${idl_schema};
grant select on ${iml_schema}.pty_cap_supv_coprator_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_cap_supv_coprator_info_h is '资金监管合作商信息历史';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.coprator_seq_num is '合作商序号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.coprator_id is '合作商编号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.coprator_name is '合作商名称';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.coprator_abbr is '合作商简称';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.trdpty_flow_num is '第三方流水号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.cert_no is '证件号码';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.cert_exp_dt is '证件到期日期';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.legal_rep_name is '法定代表人名称';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.legal_rep_cert_type_cd is '法定代表人证件类型代码';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.legal_rep_cert_no is '法定代表人证件号码';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.lp_cert_start_dt is '法人证件开始日期';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.lp_cert_exp_dt is '法人证件到期日期';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.lp_phone_num is '法人联系电话号码';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.operr_name is '经办人名称';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.operr_cert_type_cd is '经办人证件类型代码';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.operr_cert_no is '经办人证件号码';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.operr_cert_start_dt is '经办人证件开始日期';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.operr_cert_exp_dt is '经办人证件到期日期';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.operr_mobile_no is '经办人手机号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.dtl_addr is '详细地址';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.zip_cd is '邮政编码';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.phone_num is '联系电话号码';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.monit_acct_id is '监控账户编号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.monit_acct_name is '监控账户名称';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.monit_acct_org_id is '监控账户机构编号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.monit_acct_org_name is '监控账户机构名称';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.mdl_enter_id is '中间入账账户编号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.mdl_enter_name is '中间入账账户名称';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.mdl_enter_org_id is '中间入账账户机构编号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.mdl_enter_org_name is '中间入账账户机构名称';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.trdpty_clear_enter_id is '第三方清算入账账户编号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.trdpty_clear_enter_name is '第三方清算入账账户名称';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.trdpty_clear_enter_org_id is '第三方清算入账账号机构编号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.trdpty_clear_enter_org_name is '第三方清算入账账户机构名称';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.trdpty_clear_enter_obank_flg is '第三方清算入账账户他行标志';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.corp_stl_acct_id is '企业结算账户编号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.corp_stl_acct_name is '企业结算账户名称';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.corp_stl_acct_org_id is '企业结算账户机构编号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.corp_stl_acct_org_name is '企业结算账户机构名称';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.coprator_status_cd is '合作商状态代码';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.clear_mode_cd is '清算模式代码';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.dmic_st_msg_send_flg is '动账短信发送标志';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.vtual_acct_id is '虚拟账户编号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.open_chn_cd is '开通渠道代码';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.bd_card_qtty_uplmi is '绑定卡数量上限';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.operr_id is '操作员编号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.check_operr_id is '复核操作员编号';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.update_tm is '更新时间';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.create_tm is '创建时间';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_cap_supv_coprator_info_h.etl_timestamp is 'ETL处理时间戳';
