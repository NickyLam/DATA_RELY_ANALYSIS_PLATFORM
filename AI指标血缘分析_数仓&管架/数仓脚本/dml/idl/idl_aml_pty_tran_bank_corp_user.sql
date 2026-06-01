/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_pty_tran_bank_corp_user
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_pty_tran_bank_corp_user drop partition p_${last_date};
alter table ${idl_schema}.aml_pty_tran_bank_corp_user drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_pty_tran_bank_corp_user add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_pty_tran_bank_corp_user partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,user_id  -- 用户编号
    ,lp_id  -- 法人编号
    ,user_login_id  -- 用户登录ID
    ,user_name  -- 用户名称
    ,open_acct_dt  -- 开户日期
    ,clos_acct_dt  -- 销户日期
    ,e_mail  -- 电子邮箱
    ,tel_num  -- 电话号码
    ,mobile_no  -- 手机号码
    ,acct_status_cd  -- 账户状态代码
    ,gender_cd  -- 性别代码
    ,senti_cd  -- 敏感代码
    ,admin_flg  -- 管理员标志
    ,user_lab_remark  -- 用户标签备注
    ,user_froz_status_flg  -- 用户冻结状态标志
    ,user_pause_status_cd  -- 用户暂停状态代码
    ,user_froz_dt  -- 用户冻结日期
    ,user_pause_dt  -- 用户暂停日期
    ,resv_addr  -- 备用地址
    ,hp_id  -- 头像编号
    ,operr_auth_status_cd  -- 操作员授权状态代码
    ,wx_sign_status_flg  -- 微信签约状态标志
    ,recver_name_diplay_way_cd  -- 收款人名称展示方式代码
    ,lp_cert_exp_nr_cert_no  -- 法人证件是否到期不提醒证件号
    ,corp_cert_exp_nr_cert_no  -- 企业证件是否到期不提醒证件号
    ,acct_num_exp_nr_acct_num  -- 账号是否到期不提醒账号
    ,ss_yqt_func_flg  -- 启停银企通功能标志
    ,onl_bank_user_flg  -- 网银用户标志
    ,mobile_no_bind_flg  -- 手机号绑定标志
    ,choice_not_bind_flg  -- 选择不绑定标志
    ,oa_admin_flg  -- OA管理员标志
    ,init_oa_user_id  -- 原OA用户编号
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.user_id,chr(13),''),chr(10),'')  -- 用户编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.user_login_id,chr(13),''),chr(10),'')  -- 用户登录ID
    ,replace(replace(t1.user_name,chr(13),''),chr(10),'')  -- 用户名称
    ,t1.open_acct_dt  -- 开户日期
    ,t1.clos_acct_dt  -- 销户日期
    ,replace(replace(t1.e_mail,chr(13),''),chr(10),'')  -- 电子邮箱
    ,replace(replace(t1.tel_num,chr(13),''),chr(10),'')  -- 电话号码
    ,replace(replace(t1.mobile_no,chr(13),''),chr(10),'')  -- 手机号码
    ,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'')  -- 账户状态代码
    ,replace(replace(t1.gender_cd,chr(13),''),chr(10),'')  -- 性别代码
    ,replace(replace(t1.senti_cd,chr(13),''),chr(10),'')  -- 敏感代码
    ,replace(replace(t1.admin_flg,chr(13),''),chr(10),'')  -- 管理员标志
    ,replace(replace(t1.user_lab_remark,chr(13),''),chr(10),'')  -- 用户标签备注
    ,replace(replace(t1.user_froz_status_flg,chr(13),''),chr(10),'')  -- 用户冻结状态标志
    ,replace(replace(t1.user_pause_status_cd,chr(13),''),chr(10),'')  -- 用户暂停状态代码
    ,t1.user_froz_dt  -- 用户冻结日期
    ,t1.user_pause_dt  -- 用户暂停日期
    ,replace(replace(t1.resv_addr,chr(13),''),chr(10),'')  -- 备用地址
    ,replace(replace(t1.hp_id,chr(13),''),chr(10),'')  -- 头像编号
    ,replace(replace(t1.operr_auth_status_cd,chr(13),''),chr(10),'')  -- 操作员授权状态代码
    ,replace(replace(t1.wx_sign_status_flg,chr(13),''),chr(10),'')  -- 微信签约状态标志
    ,replace(replace(t1.recver_name_diplay_way_cd,chr(13),''),chr(10),'')  -- 收款人名称展示方式代码
    ,replace(replace(t1.lp_cert_exp_nr_cert_no,chr(13),''),chr(10),'')  -- 法人证件是否到期不提醒证件号
    ,replace(replace(t1.corp_cert_exp_nr_cert_no,chr(13),''),chr(10),'')  -- 企业证件是否到期不提醒证件号
    ,replace(replace(t1.acct_num_exp_nr_acct_num,chr(13),''),chr(10),'')  -- 账号是否到期不提醒账号
    ,replace(replace(t1.ss_yqt_func_flg,chr(13),''),chr(10),'')  -- 启停银企通功能标志
    ,replace(replace(t1.onl_bank_user_flg,chr(13),''),chr(10),'')  -- 网银用户标志
    ,replace(replace(t1.mobile_no_bind_flg,chr(13),''),chr(10),'')  -- 手机号绑定标志
    ,replace(replace(t1.choice_not_bind_flg,chr(13),''),chr(10),'')  -- 选择不绑定标志
    ,replace(replace(t1.oa_admin_flg,chr(13),''),chr(10),'')  -- OA管理员标志
    ,replace(replace(t1.init_oa_user_id,chr(13),''),chr(10),'')  -- 原OA用户编号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.pty_tran_bank_corp_user t1    --交易银行企业用户表
where t1.create_dt <=to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_pty_tran_bank_corp_user',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);