/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_tran_bank_corp_user
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_tran_bank_corp_user
whenever sqlerror continue none;
drop table ${iml_schema}.pty_tran_bank_corp_user purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_tran_bank_corp_user(
    user_id varchar2(60) -- 用户编号
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(60) -- 客户编号
    ,user_login_id varchar2(100) -- 用户登录ID
    ,user_name varchar2(100) -- 用户名称
    ,open_acct_dt date -- 开户日期
    ,clos_acct_dt date -- 销户日期
    ,e_mail varchar2(60) -- 电子邮箱
    ,tel_num varchar2(60) -- 电话号码
    ,mobile_no varchar2(60) -- 手机号码
    ,acct_status_cd varchar2(10) -- 账户状态代码
    ,gender_cd varchar2(10) -- 性别代码
    ,senti_cd varchar2(10) -- 敏感代码
    ,admin_flg varchar2(10) -- 管理员标志
    ,user_lab_remark varchar2(250) -- 用户标签备注
    ,user_froz_status_flg varchar2(10) -- 用户冻结状态标志
    ,user_pause_status_cd varchar2(10) -- 用户暂停状态代码
    ,user_froz_dt date -- 用户冻结日期
    ,user_pause_dt date -- 用户暂停日期
    ,resv_addr varchar2(250) -- 备用地址
    ,hp_id varchar2(100) -- 头像编号
    ,operr_auth_status_cd varchar2(10) -- 操作员授权状态代码
    ,wx_sign_status_flg varchar2(10) -- 微信签约状态标志
    ,recver_name_diplay_way_cd varchar2(10) -- 收款人名称展示方式代码
    ,lp_cert_exp_nr_cert_no varchar2(60) -- 法人证件是否到期不提醒证件号
    ,corp_cert_exp_nr_cert_no varchar2(1000) -- 企业证件是否到期不提醒证件号
    ,acct_num_exp_nr_acct_num varchar2(1000) -- 账号是否到期不提醒账号
    ,ss_yqt_func_flg varchar2(10) -- 启停银企通功能标志
    ,onl_bank_user_flg varchar2(10) -- 网银用户标志
    ,mobile_no_bind_flg varchar2(10) -- 手机号绑定标志
    ,choice_not_bind_flg varchar2(10) -- 选择不绑定标志
    ,oa_admin_flg varchar2(10) -- OA管理员标志
    ,init_oa_user_id varchar2(60) -- 原OA用户编号
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
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
grant select on ${iml_schema}.pty_tran_bank_corp_user to ${icl_schema};
grant select on ${iml_schema}.pty_tran_bank_corp_user to ${idl_schema};
grant select on ${iml_schema}.pty_tran_bank_corp_user to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_tran_bank_corp_user is '交易银行企业用户表';
comment on column ${iml_schema}.pty_tran_bank_corp_user.user_id is '用户编号';
comment on column ${iml_schema}.pty_tran_bank_corp_user.lp_id is '法人编号';
comment on column ${iml_schema}.pty_tran_bank_corp_user.cust_id is '客户编号';
comment on column ${iml_schema}.pty_tran_bank_corp_user.user_login_id is '用户登录ID';
comment on column ${iml_schema}.pty_tran_bank_corp_user.user_name is '用户名称';
comment on column ${iml_schema}.pty_tran_bank_corp_user.open_acct_dt is '开户日期';
comment on column ${iml_schema}.pty_tran_bank_corp_user.clos_acct_dt is '销户日期';
comment on column ${iml_schema}.pty_tran_bank_corp_user.e_mail is '电子邮箱';
comment on column ${iml_schema}.pty_tran_bank_corp_user.tel_num is '电话号码';
comment on column ${iml_schema}.pty_tran_bank_corp_user.mobile_no is '手机号码';
comment on column ${iml_schema}.pty_tran_bank_corp_user.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.pty_tran_bank_corp_user.gender_cd is '性别代码';
comment on column ${iml_schema}.pty_tran_bank_corp_user.senti_cd is '敏感代码';
comment on column ${iml_schema}.pty_tran_bank_corp_user.admin_flg is '管理员标志';
comment on column ${iml_schema}.pty_tran_bank_corp_user.user_lab_remark is '用户标签备注';
comment on column ${iml_schema}.pty_tran_bank_corp_user.user_froz_status_flg is '用户冻结状态标志';
comment on column ${iml_schema}.pty_tran_bank_corp_user.user_pause_status_cd is '用户暂停状态代码';
comment on column ${iml_schema}.pty_tran_bank_corp_user.user_froz_dt is '用户冻结日期';
comment on column ${iml_schema}.pty_tran_bank_corp_user.user_pause_dt is '用户暂停日期';
comment on column ${iml_schema}.pty_tran_bank_corp_user.resv_addr is '备用地址';
comment on column ${iml_schema}.pty_tran_bank_corp_user.hp_id is '头像编号';
comment on column ${iml_schema}.pty_tran_bank_corp_user.operr_auth_status_cd is '操作员授权状态代码';
comment on column ${iml_schema}.pty_tran_bank_corp_user.wx_sign_status_flg is '微信签约状态标志';
comment on column ${iml_schema}.pty_tran_bank_corp_user.recver_name_diplay_way_cd is '收款人名称展示方式代码';
comment on column ${iml_schema}.pty_tran_bank_corp_user.lp_cert_exp_nr_cert_no is '法人证件是否到期不提醒证件号';
comment on column ${iml_schema}.pty_tran_bank_corp_user.corp_cert_exp_nr_cert_no is '企业证件是否到期不提醒证件号';
comment on column ${iml_schema}.pty_tran_bank_corp_user.acct_num_exp_nr_acct_num is '账号是否到期不提醒账号';
comment on column ${iml_schema}.pty_tran_bank_corp_user.ss_yqt_func_flg is '启停银企通功能标志';
comment on column ${iml_schema}.pty_tran_bank_corp_user.onl_bank_user_flg is '网银用户标志';
comment on column ${iml_schema}.pty_tran_bank_corp_user.mobile_no_bind_flg is '手机号绑定标志';
comment on column ${iml_schema}.pty_tran_bank_corp_user.choice_not_bind_flg is '选择不绑定标志';
comment on column ${iml_schema}.pty_tran_bank_corp_user.oa_admin_flg is 'OA管理员标志';
comment on column ${iml_schema}.pty_tran_bank_corp_user.init_oa_user_id is '原OA用户编号';
comment on column ${iml_schema}.pty_tran_bank_corp_user.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.pty_tran_bank_corp_user.cert_no is '证件号码';
comment on column ${iml_schema}.pty_tran_bank_corp_user.create_dt is '创建日期';
comment on column ${iml_schema}.pty_tran_bank_corp_user.update_dt is '更新日期';
comment on column ${iml_schema}.pty_tran_bank_corp_user.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.pty_tran_bank_corp_user.id_mark is '增删标志';
comment on column ${iml_schema}.pty_tran_bank_corp_user.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_tran_bank_corp_user.job_cd is '任务编码';
comment on column ${iml_schema}.pty_tran_bank_corp_user.etl_timestamp is 'ETL处理时间戳';
