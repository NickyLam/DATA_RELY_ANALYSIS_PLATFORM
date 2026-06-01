/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_elec_chn_acct_sign_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_elec_chn_acct_sign_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_elec_chn_acct_sign_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_elec_chn_acct_sign_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(60) -- 账户编号
    ,open_chn_type_cd varchar2(30) -- 开通渠道类型代码
    ,sign_chn_cd varchar2(30) -- 签约渠道编号
    ,acct_status_cd varchar2(30) -- 账户状态代码
    ,vouch_type_cd varchar2(30) -- 凭证类型代码
    ,user_id varchar2(60) -- 用户编号
    ,cust_id varchar2(60) -- 客户编号
    ,acct_alias varchar2(500) -- 账户别名
    ,acct_add_dt date -- 账户加挂日期
    ,acct_add_org varchar2(60) -- 账户加挂机构
    ,tran_prvlg_open_flg varchar2(30) -- 转账权限开通标志
    ,apot_tran_open_flg varchar2(30) -- 约定转账开通标志
    ,card_type_cd varchar2(30) -- 卡类型代码
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
grant select on ${icl_schema}.cmm_elec_chn_acct_sign_info to ${idl_schema};
grant select on ${icl_schema}.cmm_elec_chn_acct_sign_info to ${iel_schema};
grant select on ${icl_schema}.cmm_elec_chn_acct_sign_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_elec_chn_acct_sign_info is '电子渠道账户签约信息';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.acct_id is '账户编号';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.open_chn_type_cd is '开通渠道类型代码';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.sign_chn_cd is '签约渠道编号';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.acct_status_cd is '账户状态代码';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.vouch_type_cd is '凭证类型代码';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.user_id is '用户编号';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.acct_alias is '账户别名';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.acct_add_dt is '账户加挂日期';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.acct_add_org is '账户加挂机构';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.tran_prvlg_open_flg is '转账权限开通标志';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.apot_tran_open_flg is '约定转账开通标志';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.card_type_cd is '卡类型代码';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_elec_chn_acct_sign_info.etl_timestamp is 'ETL处理时间戳';
