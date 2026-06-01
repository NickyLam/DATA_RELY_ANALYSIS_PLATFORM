/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_tran_bank_corp_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_tran_bank_corp_info
whenever sqlerror continue none;
drop table ${iml_schema}.pty_tran_bank_corp_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_tran_bank_corp_info(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,cust_cn_name varchar2(1000) -- 客户中文名称
    ,cust_en_name varchar2(100) -- 客户英文名称
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,edit_flg varchar2(10) -- 版本标志
    ,corp_addr varchar2(1000) -- 企业地址
    ,charge_acct_num varchar2(60) -- 收费账号
    ,curr_cd varchar2(10) -- 币种代码
    ,zip_cd varchar2(10) -- 邮政编码
    ,tel_num varchar2(60) -- 电话号码
    ,fax varchar2(60) -- 传真
    ,e_mail varchar2(60) -- 电子邮箱
    ,open_acct_tm timestamp -- 开户时间
    ,final_update_tm timestamp -- 最后更新时间
    ,acct_status_cd varchar2(10) -- 账户状态代码
    ,status_remark varchar2(500) -- 状态备注
    ,orgnz_id varchar2(60) -- 组织机构编号
    ,legal_rep_name varchar2(250) -- 法人代表名称
    ,lp_cert_type_cd varchar2(10) -- 法人证件类型代码
    ,lp_cert_no varchar2(60) -- 法人证件号码
    ,lp_tel_num varchar2(60) -- 法人电话号码
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,open_acct_brch_id varchar2(60) -- 开户分行编号
    ,open_acct_brac_id varchar2(60) -- 开户网点编号
    ,bus_belong_brac_id varchar2(60) -- 业务归属网点编号
    ,open_acct_operr_id varchar2(60) -- 开户操作员编号
    ,cash_ctrl_flg varchar2(10) -- 现金控制标志
    ,lp_cert_exp_dt date -- 法人证件到期日期
    ,sup_chain_sys_flg varchar2(10) -- 供应链系统标志
    ,sign_yqt_flg varchar2(10) -- 签约银企通标志
    ,sign_yqt_tm timestamp -- 签约银企通时间
    ,oa_wrtoff_tm timestamp -- OA注销时间
    ,init_oa_id varchar2(20) -- 原OA编号
    ,oa_reim_rela_acct varchar2(60) -- OA报销关联账户
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(100) -- 证件号码
    ,group_cust_flg varchar2(30) -- 集团客户标志
    ,sign_chn_cd varchar2(60) -- 签约渠道代码
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.pty_tran_bank_corp_info to ${icl_schema};
grant select on ${iml_schema}.pty_tran_bank_corp_info to ${idl_schema};
grant select on ${iml_schema}.pty_tran_bank_corp_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_tran_bank_corp_info is '交易银行企业信息表';
comment on column ${iml_schema}.pty_tran_bank_corp_info.party_id is '当事人编号';
comment on column ${iml_schema}.pty_tran_bank_corp_info.lp_id is '法人编号';
comment on column ${iml_schema}.pty_tran_bank_corp_info.cust_cn_name is '客户中文名称';
comment on column ${iml_schema}.pty_tran_bank_corp_info.cust_en_name is '客户英文名称';
comment on column ${iml_schema}.pty_tran_bank_corp_info.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.pty_tran_bank_corp_info.edit_flg is '版本标志';
comment on column ${iml_schema}.pty_tran_bank_corp_info.corp_addr is '企业地址';
comment on column ${iml_schema}.pty_tran_bank_corp_info.charge_acct_num is '收费账号';
comment on column ${iml_schema}.pty_tran_bank_corp_info.curr_cd is '币种代码';
comment on column ${iml_schema}.pty_tran_bank_corp_info.zip_cd is '邮政编码';
comment on column ${iml_schema}.pty_tran_bank_corp_info.tel_num is '电话号码';
comment on column ${iml_schema}.pty_tran_bank_corp_info.fax is '传真';
comment on column ${iml_schema}.pty_tran_bank_corp_info.e_mail is '电子邮箱';
comment on column ${iml_schema}.pty_tran_bank_corp_info.open_acct_tm is '开户时间';
comment on column ${iml_schema}.pty_tran_bank_corp_info.final_update_tm is '最后更新时间';
comment on column ${iml_schema}.pty_tran_bank_corp_info.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.pty_tran_bank_corp_info.status_remark is '状态备注';
comment on column ${iml_schema}.pty_tran_bank_corp_info.orgnz_id is '组织机构编号';
comment on column ${iml_schema}.pty_tran_bank_corp_info.legal_rep_name is '法人代表名称';
comment on column ${iml_schema}.pty_tran_bank_corp_info.lp_cert_type_cd is '法人证件类型代码';
comment on column ${iml_schema}.pty_tran_bank_corp_info.lp_cert_no is '法人证件号码';
comment on column ${iml_schema}.pty_tran_bank_corp_info.lp_tel_num is '法人电话号码';
comment on column ${iml_schema}.pty_tran_bank_corp_info.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.pty_tran_bank_corp_info.open_acct_brch_id is '开户分行编号';
comment on column ${iml_schema}.pty_tran_bank_corp_info.open_acct_brac_id is '开户网点编号';
comment on column ${iml_schema}.pty_tran_bank_corp_info.bus_belong_brac_id is '业务归属网点编号';
comment on column ${iml_schema}.pty_tran_bank_corp_info.open_acct_operr_id is '开户操作员编号';
comment on column ${iml_schema}.pty_tran_bank_corp_info.cash_ctrl_flg is '现金控制标志';
comment on column ${iml_schema}.pty_tran_bank_corp_info.lp_cert_exp_dt is '法人证件到期日期';
comment on column ${iml_schema}.pty_tran_bank_corp_info.sup_chain_sys_flg is '供应链系统标志';
comment on column ${iml_schema}.pty_tran_bank_corp_info.sign_yqt_flg is '签约银企通标志';
comment on column ${iml_schema}.pty_tran_bank_corp_info.sign_yqt_tm is '签约银企通时间';
comment on column ${iml_schema}.pty_tran_bank_corp_info.oa_wrtoff_tm is 'OA注销时间';
comment on column ${iml_schema}.pty_tran_bank_corp_info.init_oa_id is '原OA编号';
comment on column ${iml_schema}.pty_tran_bank_corp_info.oa_reim_rela_acct is 'OA报销关联账户';
comment on column ${iml_schema}.pty_tran_bank_corp_info.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.pty_tran_bank_corp_info.cert_no is '证件号码';
comment on column ${iml_schema}.pty_tran_bank_corp_info.group_cust_flg is '集团客户标志';
comment on column ${iml_schema}.pty_tran_bank_corp_info.sign_chn_cd is '签约渠道代码';
comment on column ${iml_schema}.pty_tran_bank_corp_info.create_dt is '创建日期';
comment on column ${iml_schema}.pty_tran_bank_corp_info.update_dt is '更新日期';
comment on column ${iml_schema}.pty_tran_bank_corp_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.pty_tran_bank_corp_info.id_mark is '增删标志';
comment on column ${iml_schema}.pty_tran_bank_corp_info.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_tran_bank_corp_info.job_cd is '任务编码';
comment on column ${iml_schema}.pty_tran_bank_corp_info.etl_timestamp is 'ETL处理时间戳';
