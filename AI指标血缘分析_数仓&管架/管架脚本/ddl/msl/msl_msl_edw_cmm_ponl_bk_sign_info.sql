/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_cmm_ponl_bk_sign_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info(
    etl_dt date
    ,lp_id varchar2(60)
    ,cust_id varchar2(60)
    ,user_id varchar2(60)
    ,onl_bank_cust_status_cd varchar2(10)
    ,open_acct_tm timestamp(6)
    ,clos_acct_tm timestamp(6)
    ,ghb_emply_flg varchar2(10)
    ,cust_cn_name varchar2(600)
    ,cust_en_name varchar2(100)
    ,cert_type_cd varchar2(10)
    ,cert_no varchar2(60)
    ,cont_addr varchar2(300)
    ,phone varchar2(60)
    ,zip_cd varchar2(10)
    ,mobile_no varchar2(60)
    ,gender_cd varchar2(10)
    ,work_unit_tel varchar2(60)
    ,open_bank_id varchar2(60)
    ,open_bank_name varchar2(200)
    ,open_acct_brch_id varchar2(60)
    ,open_acct_brch_name varchar2(100)
    ,open_acct_org_id varchar2(60)
    ,open_acct_org_name varchar2(500)
    ,cty varchar2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info is '个人网银签约信息';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.lp_id is '法人编号';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.cust_id is '客户编号';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.user_id is '用户编号';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.onl_bank_cust_status_cd is '网银客户状态代码';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.open_acct_tm is '开户时间';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.clos_acct_tm is '销户时间';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.ghb_emply_flg is '本行员工标志';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.cust_cn_name is '客户中文名称';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.cust_en_name is '客户英文名称';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.cert_type_cd is '证件类型代码';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.cert_no is '证件号码';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.cont_addr is '联系地址';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.phone is '联系电话';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.zip_cd is '邮政编码';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.mobile_no is '手机号码';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.gender_cd is '性别代码';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.work_unit_tel is '工作单位电话';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.open_bank_id is '开户行编号';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.open_bank_name is '开户行名称';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.open_acct_brch_id is '开户分行编号';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.open_acct_brch_name is '开户分行名称';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.open_acct_org_id is '开户机构编号';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.open_acct_org_name is '开户机构名称';
comment on column ${msl_schema}.msl_edw_cmm_ponl_bk_sign_info.cty is '国家';
