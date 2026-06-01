/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_cmm_ponl_bk_sign_info
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
alter table ${idl_schema}.aml_cmm_ponl_bk_sign_info drop partition p_${last_date};
alter table ${idl_schema}.aml_cmm_ponl_bk_sign_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_cmm_ponl_bk_sign_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_cmm_ponl_bk_sign_info (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,cust_id  -- 客户编号
    ,user_id  -- 用户编号
    ,onl_bank_cust_status_cd  -- 网银客户状态代码
    ,open_acct_tm  -- 开户时间
    ,clos_acct_tm  -- 销户时间
    ,ghb_emply_flg  -- 本行员工标志
    ,cust_cn_name  -- 客户中文名称
    ,cust_en_name  -- 客户英文名称
    ,cert_type_cd  -- 证件类型代码
    ,cert_no  -- 证件号码
    ,cont_addr  -- 联系地址
    ,phone  -- 联系电话
    ,zip_cd  -- 邮政编码
    ,mobile_no  -- 手机号码
    ,gender_cd  -- 性别代码
    ,work_unit_tel  -- 工作单位电话
    ,open_bank_id  -- 开户行编号
    ,open_bank_name  -- 开户行名称
    ,open_acct_brch_id  -- 开户分行编号
    ,open_acct_brch_name  -- 开户分行名称
    ,open_acct_org_id  -- 开户机构编号
    ,open_acct_org_name  -- 开户机构名称
    ,cty  -- 国家
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.user_id,chr(13),''),chr(10),'')  -- 用户编号
    ,replace(replace(t1.onl_bank_cust_status_cd,chr(13),''),chr(10),'')  -- 网银客户状态代码
    ,t1.open_acct_tm  -- 开户时间
    ,t1.clos_acct_tm  -- 销户时间
    ,replace(replace(t1.ghb_emply_flg,chr(13),''),chr(10),'')  -- 本行员工标志
    ,replace(replace(t1.cust_cn_name,chr(13),''),chr(10),'')  -- 客户中文名称
    ,replace(replace(t1.cust_en_name,chr(13),''),chr(10),'')  -- 客户英文名称
    ,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'')  -- 证件类型代码
    ,replace(replace(t1.cert_no,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.cont_addr,chr(13),''),chr(10),'')  -- 联系地址
    ,replace(replace(t1.phone,chr(13),''),chr(10),'')  -- 联系电话
    ,replace(replace(t1.zip_cd,chr(13),''),chr(10),'')  -- 邮政编码
    ,replace(replace(t1.mobile_no,chr(13),''),chr(10),'')  -- 手机号码
    ,replace(replace(t1.gender_cd,chr(13),''),chr(10),'')  -- 性别代码
    ,replace(replace(t1.work_unit_tel,chr(13),''),chr(10),'')  -- 工作单位电话
    ,replace(replace(t1.open_bank_id,chr(13),''),chr(10),'')  -- 开户行编号
    ,replace(replace(t1.open_bank_name,chr(13),''),chr(10),'')  -- 开户行名称
    ,replace(replace(t1.open_acct_brch_id,chr(13),''),chr(10),'')  -- 开户分行编号
    ,replace(replace(t1.open_acct_brch_name,chr(13),''),chr(10),'')  -- 开户分行名称
    ,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'')  -- 开户机构编号
    ,replace(replace(t1.open_acct_org_name,chr(13),''),chr(10),'')  -- 开户机构名称
    ,replace(replace(t1.cty,chr(13),''),chr(10),'')  -- 国家
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${icl_schema}.cmm_ponl_bk_sign_info t1    --个人网银签约信息
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_cmm_ponl_bk_sign_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);