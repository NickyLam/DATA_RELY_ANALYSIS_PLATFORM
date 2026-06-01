/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_tran_bank_corp_user_tbpsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_tran_bank_corp_user_tbpsf1_tm purge;
drop table ${iml_schema}.pty_tran_bank_corp_user_tbpsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_tran_bank_corp_user add partition p_tbpsf1 values ('tbpsf1')(
        subpartition p_tbpsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_tran_bank_corp_user modify partition p_tbpsf1
    add subpartition p_tbpsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_tran_bank_corp_user_tbpsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_tran_bank_corp_user partition for ('tbpsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_tran_bank_corp_user_tbpsf1_tm
compress ${option_switch} for query high
as
select
    user_id -- 用户编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,user_login_id -- 用户登录ID
    ,user_name -- 用户名称
    ,open_acct_dt -- 开户日期
    ,clos_acct_dt -- 销户日期
    ,e_mail -- 电子邮箱
    ,tel_num -- 电话号码
    ,mobile_no -- 手机号码
    ,acct_status_cd -- 账户状态代码
    ,gender_cd -- 性别代码
    ,senti_cd -- 敏感代码
    ,admin_flg -- 管理员标志
    ,user_lab_remark -- 用户标签备注
    ,user_froz_status_flg -- 用户冻结状态标志
    ,user_pause_status_cd -- 用户暂停状态代码
    ,user_froz_dt -- 用户冻结日期
    ,user_pause_dt -- 用户暂停日期
    ,resv_addr -- 备用地址
    ,hp_id -- 头像编号
    ,operr_auth_status_cd -- 操作员授权状态代码
    ,wx_sign_status_flg -- 微信签约状态标志
    ,recver_name_diplay_way_cd -- 收款人名称展示方式代码
    ,lp_cert_exp_nr_cert_no -- 法人证件是否到期不提醒证件号
    ,corp_cert_exp_nr_cert_no -- 企业证件是否到期不提醒证件号
    ,acct_num_exp_nr_acct_num -- 账号是否到期不提醒账号
    ,ss_yqt_func_flg -- 启停银企通功能标志
    ,onl_bank_user_flg -- 网银用户标志
    ,mobile_no_bind_flg -- 手机号绑定标志
    ,choice_not_bind_flg -- 选择不绑定标志
    ,oa_admin_flg -- OA管理员标志
    ,init_oa_user_id -- 原OA用户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_tran_bank_corp_user
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_tran_bank_corp_user_tbpsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_tran_bank_corp_user partition for ('tbpsf1') where 0=1;

-- 2.1 insert data to tm table
-- tbps_cpr_user_inf-
insert into ${iml_schema}.pty_tran_bank_corp_user_tbpsf1_tm(
    user_id -- 用户编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,user_login_id -- 用户登录ID
    ,user_name -- 用户名称
    ,open_acct_dt -- 开户日期
    ,clos_acct_dt -- 销户日期
    ,e_mail -- 电子邮箱
    ,tel_num -- 电话号码
    ,mobile_no -- 手机号码
    ,acct_status_cd -- 账户状态代码
    ,gender_cd -- 性别代码
    ,senti_cd -- 敏感代码
    ,admin_flg -- 管理员标志
    ,user_lab_remark -- 用户标签备注
    ,user_froz_status_flg -- 用户冻结状态标志
    ,user_pause_status_cd -- 用户暂停状态代码
    ,user_froz_dt -- 用户冻结日期
    ,user_pause_dt -- 用户暂停日期
    ,resv_addr -- 备用地址
    ,hp_id -- 头像编号
    ,operr_auth_status_cd -- 操作员授权状态代码
    ,wx_sign_status_flg -- 微信签约状态标志
    ,recver_name_diplay_way_cd -- 收款人名称展示方式代码
    ,lp_cert_exp_nr_cert_no -- 法人证件是否到期不提醒证件号
    ,corp_cert_exp_nr_cert_no -- 企业证件是否到期不提醒证件号
    ,acct_num_exp_nr_acct_num -- 账号是否到期不提醒账号
    ,ss_yqt_func_flg -- 启停银企通功能标志
    ,onl_bank_user_flg -- 网银用户标志
    ,mobile_no_bind_flg -- 手机号绑定标志
    ,choice_not_bind_flg -- 选择不绑定标志
    ,oa_admin_flg -- OA管理员标志
    ,init_oa_user_id -- 原OA用户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CUI_USERNO -- 用户编号
    ,'9999' -- 法人编号
    ,P1.CUI_ECIFNO -- 客户编号
    ,P1.CUI_USERID -- 用户登录ID
    ,P1.CUI_USERNAME -- 用户名称
    ,${iml_schema}.DATEFORMAT_MIN(substr(P1.CUI_OPENDATE,1,8)) -- 开户日期
    ,${iml_schema}.DATEFORMAT_MAX(substr(P1.CUI_CLOSEDATE,1,8)) -- 销户日期
    ,P1.CUI_EMAIL -- 电子邮箱
    ,P1.CUI_PHONE -- 电话号码
    ,P1.CUI_MOBILEPHONE -- 手机号码
    ,P1.CUI_STT -- 账户状态代码
    ,nvl(trim(p1.CUI_SEX),'0') -- 性别代码
    ,P1.CUI_SENSEFLAG -- 敏感代码
    ,P1.CUI_ADMINFLAG -- 管理员标志
    ,P1.CUI_CUSTOMLABEL -- 用户标签备注
    ,P1.CUI_FREEZESTATE -- 用户冻结状态标志
    ,P1.CUI_PAUSESTATE -- 用户暂停状态代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.CUI_FREEZEDATE) -- 用户冻结日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.CUI_PAUSEDATE) -- 用户暂停日期
    ,P1.CUI_ADDRESSONE -- 备用地址
    ,P1.CUI_CUSTOMLOGO -- 头像编号
    ,NVL(TRIM(p1.CUI_MGMTAUTHTYPE),'-') -- 操作员授权状态代码
    ,P1.CUI_WEIXINSIGNFLAG -- 微信签约状态标志
    ,NVL(TRIM(p1.CUI_BKSTYPE),'-') -- 收款人名称展示方式代码
    ,P1.LEGPERENDDAREAD -- 法人证件是否到期不提醒证件号
    ,P1.CERTINFOENDDAREAD -- 企业证件是否到期不提醒证件号
    ,P1.ACNOREAD -- 账号是否到期不提醒账号
    ,P1.CUI_MOBILEBANK_OPEN -- 启停银企通功能标志
    ,P1.CUI_EBANKUSER -- 网银用户标志
    ,P1.CUI_ISBAND_PHONE -- 手机号绑定标志
    ,P1.CUI_ISSELECT_BAND -- 选择不绑定标志
    ,P1.CUI_ISOA_ADMINFLAG -- OA管理员标志
    ,P1.CUI_OLD_OAUSERNO -- 原OA用户编号
    ,NVL(TRIM(P1.CUI_CETTYPE),'0000') -- 证件类型代码
    ,P1.CUI_CETNO -- 证件号码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tbps_cpr_user_inf' -- 源表名称
    ,'tbpsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tbps_cpr_user_inf p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_tran_bank_corp_user_tbpsf1_tm 
  	                                group by 
  	                                        user_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.pty_tran_bank_corp_user_tbpsf1_ex(
    user_id -- 用户编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,user_login_id -- 用户登录ID
    ,user_name -- 用户名称
    ,open_acct_dt -- 开户日期
    ,clos_acct_dt -- 销户日期
    ,e_mail -- 电子邮箱
    ,tel_num -- 电话号码
    ,mobile_no -- 手机号码
    ,acct_status_cd -- 账户状态代码
    ,gender_cd -- 性别代码
    ,senti_cd -- 敏感代码
    ,admin_flg -- 管理员标志
    ,user_lab_remark -- 用户标签备注
    ,user_froz_status_flg -- 用户冻结状态标志
    ,user_pause_status_cd -- 用户暂停状态代码
    ,user_froz_dt -- 用户冻结日期
    ,user_pause_dt -- 用户暂停日期
    ,resv_addr -- 备用地址
    ,hp_id -- 头像编号
    ,operr_auth_status_cd -- 操作员授权状态代码
    ,wx_sign_status_flg -- 微信签约状态标志
    ,recver_name_diplay_way_cd -- 收款人名称展示方式代码
    ,lp_cert_exp_nr_cert_no -- 法人证件是否到期不提醒证件号
    ,corp_cert_exp_nr_cert_no -- 企业证件是否到期不提醒证件号
    ,acct_num_exp_nr_acct_num -- 账号是否到期不提醒账号
    ,ss_yqt_func_flg -- 启停银企通功能标志
    ,onl_bank_user_flg -- 网银用户标志
    ,mobile_no_bind_flg -- 手机号绑定标志
    ,choice_not_bind_flg -- 选择不绑定标志
    ,oa_admin_flg -- OA管理员标志
    ,init_oa_user_id -- 原OA用户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.user_id, o.user_id) as user_id -- 用户编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.user_login_id, o.user_login_id) as user_login_id -- 用户登录ID
    ,nvl(n.user_name, o.user_name) as user_name -- 用户名称
    ,nvl(n.open_acct_dt, o.open_acct_dt) as open_acct_dt -- 开户日期
    ,nvl(n.clos_acct_dt, o.clos_acct_dt) as clos_acct_dt -- 销户日期
    ,nvl(n.e_mail, o.e_mail) as e_mail -- 电子邮箱
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 电话号码
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别代码
    ,nvl(n.senti_cd, o.senti_cd) as senti_cd -- 敏感代码
    ,nvl(n.admin_flg, o.admin_flg) as admin_flg -- 管理员标志
    ,nvl(n.user_lab_remark, o.user_lab_remark) as user_lab_remark -- 用户标签备注
    ,nvl(n.user_froz_status_flg, o.user_froz_status_flg) as user_froz_status_flg -- 用户冻结状态标志
    ,nvl(n.user_pause_status_cd, o.user_pause_status_cd) as user_pause_status_cd -- 用户暂停状态代码
    ,nvl(n.user_froz_dt, o.user_froz_dt) as user_froz_dt -- 用户冻结日期
    ,nvl(n.user_pause_dt, o.user_pause_dt) as user_pause_dt -- 用户暂停日期
    ,nvl(n.resv_addr, o.resv_addr) as resv_addr -- 备用地址
    ,nvl(n.hp_id, o.hp_id) as hp_id -- 头像编号
    ,nvl(n.operr_auth_status_cd, o.operr_auth_status_cd) as operr_auth_status_cd -- 操作员授权状态代码
    ,nvl(n.wx_sign_status_flg, o.wx_sign_status_flg) as wx_sign_status_flg -- 微信签约状态标志
    ,nvl(n.recver_name_diplay_way_cd, o.recver_name_diplay_way_cd) as recver_name_diplay_way_cd -- 收款人名称展示方式代码
    ,nvl(n.lp_cert_exp_nr_cert_no, o.lp_cert_exp_nr_cert_no) as lp_cert_exp_nr_cert_no -- 法人证件是否到期不提醒证件号
    ,nvl(n.corp_cert_exp_nr_cert_no, o.corp_cert_exp_nr_cert_no) as corp_cert_exp_nr_cert_no -- 企业证件是否到期不提醒证件号
    ,nvl(n.acct_num_exp_nr_acct_num, o.acct_num_exp_nr_acct_num) as acct_num_exp_nr_acct_num -- 账号是否到期不提醒账号
    ,nvl(n.ss_yqt_func_flg, o.ss_yqt_func_flg) as ss_yqt_func_flg -- 启停银企通功能标志
    ,nvl(n.onl_bank_user_flg, o.onl_bank_user_flg) as onl_bank_user_flg -- 网银用户标志
    ,nvl(n.mobile_no_bind_flg, o.mobile_no_bind_flg) as mobile_no_bind_flg -- 手机号绑定标志
    ,nvl(n.choice_not_bind_flg, o.choice_not_bind_flg) as choice_not_bind_flg -- 选择不绑定标志
    ,nvl(n.oa_admin_flg, o.oa_admin_flg) as oa_admin_flg -- OA管理员标志
    ,nvl(n.init_oa_user_id, o.init_oa_user_id) as init_oa_user_id -- 原OA用户编号
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.user_id is null
                and o.lp_id is null
            ) or (
                o.cust_id <> n.cust_id
                or o.user_login_id <> n.user_login_id
                or o.user_name <> n.user_name
                or o.open_acct_dt <> n.open_acct_dt
                or o.clos_acct_dt <> n.clos_acct_dt
                or o.e_mail <> n.e_mail
                or o.tel_num <> n.tel_num
                or o.mobile_no <> n.mobile_no
                or o.acct_status_cd <> n.acct_status_cd
                or o.gender_cd <> n.gender_cd
                or o.senti_cd <> n.senti_cd
                or o.admin_flg <> n.admin_flg
                or o.user_lab_remark <> n.user_lab_remark
                or o.user_froz_status_flg <> n.user_froz_status_flg
                or o.user_pause_status_cd <> n.user_pause_status_cd
                or o.user_froz_dt <> n.user_froz_dt
                or o.user_pause_dt <> n.user_pause_dt
                or o.resv_addr <> n.resv_addr
                or o.hp_id <> n.hp_id
                or o.operr_auth_status_cd <> n.operr_auth_status_cd
                or o.wx_sign_status_flg <> n.wx_sign_status_flg
                or o.recver_name_diplay_way_cd <> n.recver_name_diplay_way_cd
                or o.lp_cert_exp_nr_cert_no <> n.lp_cert_exp_nr_cert_no
                or o.corp_cert_exp_nr_cert_no <> n.corp_cert_exp_nr_cert_no
                or o.acct_num_exp_nr_acct_num <> n.acct_num_exp_nr_acct_num
                or o.ss_yqt_func_flg <> n.ss_yqt_func_flg
                or o.onl_bank_user_flg <> n.onl_bank_user_flg
                or o.mobile_no_bind_flg <> n.mobile_no_bind_flg
                or o.choice_not_bind_flg <> n.choice_not_bind_flg
                or o.oa_admin_flg <> n.oa_admin_flg
                or o.init_oa_user_id <> n.init_oa_user_id
                or o.cert_type_cd <> n.cert_type_cd
                or o.cert_no <> n.cert_no
            ) or (
                 case when (
                           n.user_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.user_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_tran_bank_corp_user_tbpsf1_tm n
    full join ${iml_schema}.pty_tran_bank_corp_user_tbpsf1_bk o
        on
            o.user_id = n.user_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_tran_bank_corp_user truncate partition for ('tbpsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_tran_bank_corp_user exchange subpartition p_tbpsf1_${batch_date} with table ${iml_schema}.pty_tran_bank_corp_user_tbpsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_tran_bank_corp_user drop subpartition p_tbpsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_tran_bank_corp_user to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_tran_bank_corp_user_tbpsf1_tm purge;
drop table ${iml_schema}.pty_tran_bank_corp_user_tbpsf1_ex purge;
drop table ${iml_schema}.pty_tran_bank_corp_user_tbpsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_tran_bank_corp_user', partname => 'p_tbpsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);