/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_indv_cust_chn_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_indv_cust_chn_rela_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_indv_cust_chn_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_indv_cust_chn_rela_h(
    party_id varchar2(100) -- 当事人编号
    ,belong_plat_cd varchar2(30) -- 所属平台代码
    ,lp_id varchar2(60) -- 法人编号
    ,sign_chn_cd varchar2(30) -- 签约渠道代码
    ,user_seq_num varchar2(60) -- 用户顺序号
    ,logon_acct_id varchar2(100) -- 登陆账户编号
    ,user_acct_status_cd varchar2(30) -- 用户账户状态代码
    ,open_tm timestamp -- 开户时间
    ,clos_acct_tm timestamp -- 销户时间
    ,onl_bank_pause_status_cd varchar2(30) -- 网银暂停状态代码
    ,onl_bank_pause_end_tm timestamp -- 网银暂停结束时间
    ,onl_bank_pause_start_tm timestamp -- 网银暂停开始时间
    ,mbank_pause_status_cd varchar2(30) -- 手机银行暂停状态代码
    ,mbank_pause_start_tm timestamp -- 手机银行暂停开始时间
    ,mbank_pause_end_tm timestamp -- 手机银行暂停结束时间
    ,e_acct_sign_plat_cd varchar2(30) -- 电子账户签约平台代码
    ,save_cert_way_cd varchar2(30) -- 安全认证方式代码
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
grant select on ${iml_schema}.pty_indv_cust_chn_rela_h to ${icl_schema};
grant select on ${iml_schema}.pty_indv_cust_chn_rela_h to ${idl_schema};
grant select on ${iml_schema}.pty_indv_cust_chn_rela_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_indv_cust_chn_rela_h is '个人客户与渠道关系历史';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.belong_plat_cd is '所属平台代码';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.sign_chn_cd is '签约渠道代码';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.user_seq_num is '用户顺序号';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.logon_acct_id is '登陆账户编号';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.user_acct_status_cd is '用户账户状态代码';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.open_tm is '开户时间';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.clos_acct_tm is '销户时间';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.onl_bank_pause_status_cd is '网银暂停状态代码';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.onl_bank_pause_end_tm is '网银暂停结束时间';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.onl_bank_pause_start_tm is '网银暂停开始时间';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.mbank_pause_status_cd is '手机银行暂停状态代码';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.mbank_pause_start_tm is '手机银行暂停开始时间';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.mbank_pause_end_tm is '手机银行暂停结束时间';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.e_acct_sign_plat_cd is '电子账户签约平台代码';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.save_cert_way_cd is '安全认证方式代码';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_indv_cust_chn_rela_h.etl_timestamp is 'ETL处理时间戳';
