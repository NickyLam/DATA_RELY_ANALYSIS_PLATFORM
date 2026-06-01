/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_ponl_bk_sign_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_ponl_bk_sign_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_ponl_bk_sign_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ponl_bk_sign_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(60) -- 客户编号
    ,user_id varchar2(60) -- 用户编号
    ,onl_bank_cust_status_cd varchar2(10) -- 网银客户状态代码
    ,open_acct_tm timestamp(6) -- 开户时间
    ,clos_acct_tm timestamp(6) -- 销户时间
    ,ghb_emply_flg varchar2(10) -- 本行员工标志
    ,cust_cn_name varchar2(600) -- 客户中文名称
    ,cust_en_name varchar2(100) -- 客户英文名称
    ,cert_type_cd varchar2(10) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,cont_addr varchar2(300) -- 联系地址
    ,phone varchar2(60) -- 联系电话
    ,zip_cd varchar2(10) -- 邮政编码
    ,mobile_no varchar2(60) -- 手机号码
    ,gender_cd varchar2(10) -- 性别代码
    ,work_unit_tel varchar2(60) -- 工作单位电话
    ,open_bank_id varchar2(60) -- 开户行编号
    ,open_bank_name varchar2(200) -- 开户行名称
    ,open_acct_brch_id varchar2(60) -- 开户分行编号
    ,open_acct_brch_name varchar2(100) -- 开户分行名称
    ,open_acct_org_id varchar2(60) -- 开户机构编号
    ,open_acct_org_name varchar2(500) -- 开户机构名称
    ,cty varchar2(10) -- 国家
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
grant select on ${icl_schema}.cmm_ponl_bk_sign_info to ${idl_schema};
grant select on ${icl_schema}.cmm_ponl_bk_sign_info to ${iel_schema};
grant select on ${icl_schema}.cmm_ponl_bk_sign_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_ponl_bk_sign_info is '个人网银签约信息';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.user_id is '用户编号';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.onl_bank_cust_status_cd is '网银客户状态代码';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.open_acct_tm is '开户时间';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.clos_acct_tm is '销户时间';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.ghb_emply_flg is '本行员工标志';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.cust_cn_name is '客户中文名称';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.cust_en_name is '客户英文名称';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.cert_type_cd is '证件类型代码';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.cert_no is '证件号码';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.cont_addr is '联系地址';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.phone is '联系电话';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.zip_cd is '邮政编码';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.mobile_no is '手机号码';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.gender_cd is '性别代码';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.work_unit_tel is '工作单位电话';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.open_bank_id is '开户行编号';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.open_bank_name is '开户行名称';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.open_acct_brch_id is '开户分行编号';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.open_acct_brch_name is '开户分行名称';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.open_acct_org_id is '开户机构编号';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.open_acct_org_name is '开户机构名称';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.cty is '国家';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_ponl_bk_sign_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_ponl_bk_sign_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_ponl_bk_sign_info.etl_timestamp is 'ETL处理时间戳';
