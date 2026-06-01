/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_conl_bk_sign_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_conl_bk_sign_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_conl_bk_sign_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_conl_bk_sign_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(60) -- 客户编号
    ,cust_cn_name varchar2(600) -- 客户中文名称
    ,cust_en_name varchar2(100) -- 客户英文名称
    ,open_acct_tm timestamp(6) -- 开户时间
    ,open_acct_brch_id varchar2(60) -- 开户分行编号
    ,open_acct_brac_id varchar2(60) -- 开户网点编号
    ,belong_brac_id varchar2(60) -- 归属网点编号
    ,open_acct_operr_id varchar2(60) -- 开户操作员编号
    ,sign_chn_cd varchar2(10) -- 签约渠道代码
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,group_cust_flg varchar2(10) -- 集团客户标志
    ,cash_ctrl_flg varchar2(10) -- 现金控制标志
    ,sup_chain_sys_flg varchar2(10) -- 供应链系统标志
    ,sign_yqt_flg varchar2(10) -- 签约银企通标志
    ,onl_bank_cust_type_cd varchar2(10) -- 网银客户类型代码
    ,onl_bank_cust_status_cd varchar2(10) -- 网银客户状态代码
    ,cert_type_cd varchar2(10) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,orgnz_cd varchar2(60) -- 组织机构代码
    ,legal_rep_name varchar2(120) -- 法人代表名称
    ,lp_cert_type_cd varchar2(10) -- 法人证件类型代码
    ,lp_cert_no varchar2(60) -- 法人证件号码
    ,lp_tel_num varchar2(60) -- 法人电话号码
    ,lp_cert_exp_dt date -- 法人证件到期日期
    ,edit_flg varchar2(10) -- 版本标志
    ,posta_addr varchar2(600) -- 通讯地址
    ,tel_num varchar2(60) -- 电话号码
    ,fax_num varchar2(60) -- 传真号码
    ,zip_cd varchar2(60) -- 邮政编码
    ,charge_acct_id varchar2(60) -- 收费账户编号
    ,charge_curr_cd varchar2(10) -- 收费币种代码
    ,final_tran_tm timestamp(6) -- 最后交易时间
    ,status_modif_descb_info varchar2(300) -- 状态变更描述信息
    ,sign_yqt_tm timestamp(6) -- 签约银企通时间
    ,oa_wrtoff_tm timestamp(6) -- OA注销时间
    ,init_oa_id varchar2(60) -- 原OA编号
    ,oa_reim_rela_acct_id varchar2(60) -- OA报销关联账户编号
    ,onl_bank_tran_lmt number(30,2) -- 网银转账限额
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
grant select on ${icl_schema}.cmm_conl_bk_sign_info to ${idl_schema};
grant select on ${icl_schema}.cmm_conl_bk_sign_info to ${iel_schema};
grant select on ${icl_schema}.cmm_conl_bk_sign_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_conl_bk_sign_info is '企业网银签约信息';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.cust_cn_name is '客户中文名称';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.cust_en_name is '客户英文名称';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.open_acct_tm is '开户时间';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.open_acct_brch_id is '开户分行编号';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.open_acct_brac_id is '开户网点编号';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.belong_brac_id is '归属网点编号';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.open_acct_operr_id is '开户操作员编号';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.sign_chn_cd is '签约渠道代码';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.cust_mgr_id is '客户经理编号';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.group_cust_flg is '集团客户标志';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.cash_ctrl_flg is '现金控制标志';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.sup_chain_sys_flg is '供应链系统标志';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.sign_yqt_flg is '签约银企通标志';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.onl_bank_cust_type_cd is '网银客户类型代码';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.onl_bank_cust_status_cd is '网银客户状态代码';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.cert_type_cd is '证件类型代码';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.cert_no is '证件号码';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.orgnz_cd is '组织机构代码';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.legal_rep_name is '法人代表名称';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.lp_cert_type_cd is '法人证件类型代码';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.lp_cert_no is '法人证件号码';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.lp_tel_num is '法人电话号码';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.lp_cert_exp_dt is '法人证件到期日期';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.edit_flg is '版本标志';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.posta_addr is '通讯地址';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.tel_num is '电话号码';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.fax_num is '传真号码';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.zip_cd is '邮政编码';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.charge_acct_id is '收费账户编号';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.charge_curr_cd is '收费币种代码';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.final_tran_tm is '最后交易时间';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.status_modif_descb_info is '状态变更描述信息';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.sign_yqt_tm is '签约银企通时间';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.oa_wrtoff_tm is 'OA注销时间';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.init_oa_id is '原OA编号';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.oa_reim_rela_acct_id is 'OA报销关联账户编号';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.onl_bank_tran_lmt is '网银转账限额';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_conl_bk_sign_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_conl_bk_sign_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_conl_bk_sign_info.etl_timestamp is 'ETL处理时间戳';
