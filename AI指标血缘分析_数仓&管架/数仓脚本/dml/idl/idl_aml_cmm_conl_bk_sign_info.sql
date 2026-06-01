/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_cmm_conl_bk_sign_info
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
alter table ${idl_schema}.aml_cmm_conl_bk_sign_info drop partition p_${last_date};
alter table ${idl_schema}.aml_cmm_conl_bk_sign_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_cmm_conl_bk_sign_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_cmm_conl_bk_sign_info (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,cust_id  -- 客户编号
    ,cust_cn_name  -- 客户中文名称
    ,cust_en_name  -- 客户英文名称
    ,open_acct_tm  -- 开户时间
    ,open_acct_brch_id  -- 开户分行编号
    ,open_acct_brac_id  -- 开户网点编号
    ,belong_brac_id  -- 归属网点编号
    ,open_acct_operr_id  -- 开户操作员编号
    ,cust_mgr_id  -- 客户经理编号
    ,group_cust_flg  -- 集团客户标志
    ,cash_ctrl_flg  -- 现金控制标志
    ,sup_chain_sys_flg  -- 供应链系统标志
    ,sign_yqt_flg  -- 签约银企通标志
    ,onl_bank_cust_type_cd  -- 网银客户类型代码
    ,onl_bank_cust_status_cd  -- 网银客户状态代码
    ,cert_type_cd  -- 证件类型代码
    ,cert_no  -- 证件号码
    ,orgnz_cd  -- 组织机构代码
    ,legal_rep_name  -- 法人代表名称
    ,lp_cert_type_cd  -- 法人证件类型代码
    ,lp_cert_no  -- 法人证件号码
    ,lp_tel_num  -- 法人电话号码
    ,lp_cert_exp_dt  -- 法人证件到期日期
    ,edit_flg  -- 版本标志
    ,posta_addr  -- 通讯地址
    ,tel_num  -- 电话号码
    ,fax_num  -- 传真号码
    ,zip_cd  -- 邮政编码
    ,charge_acct_id  -- 收费账户编号
    ,charge_curr_cd  -- 收费币种代码
    ,final_tran_tm  -- 最后交易时间
    ,status_modif_descb_info  -- 状态变更描述信息
    ,sign_yqt_tm  -- 签约银企通时间
    ,oa_wrtoff_tm  -- OA注销时间
    ,init_oa_id  -- 原OA编号
    ,oa_reim_rela_acct_id  -- OA报销关联账户编号
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.cust_cn_name,chr(13),''),chr(10),'')  -- 客户中文名称
    ,replace(replace(t1.cust_en_name,chr(13),''),chr(10),'')  -- 客户英文名称
    ,t1.open_acct_tm  -- 开户时间
    ,replace(replace(t1.open_acct_brch_id,chr(13),''),chr(10),'')  -- 开户分行编号
    ,replace(replace(t1.open_acct_brac_id,chr(13),''),chr(10),'')  -- 开户网点编号
    ,replace(replace(t1.belong_brac_id,chr(13),''),chr(10),'')  -- 归属网点编号
    ,replace(replace(t1.open_acct_operr_id,chr(13),''),chr(10),'')  -- 开户操作员编号
    ,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'')  -- 客户经理编号
    ,replace(replace(t1.group_cust_flg,chr(13),''),chr(10),'')  -- 集团客户标志
    ,replace(replace(t1.cash_ctrl_flg,chr(13),''),chr(10),'')  -- 现金控制标志
    ,replace(replace(t1.sup_chain_sys_flg,chr(13),''),chr(10),'')  -- 供应链系统标志
    ,replace(replace(t1.sign_yqt_flg,chr(13),''),chr(10),'')  -- 签约银企通标志
    ,replace(replace(t1.onl_bank_cust_type_cd,chr(13),''),chr(10),'')  -- 网银客户类型代码
    ,replace(replace(t1.onl_bank_cust_status_cd,chr(13),''),chr(10),'')  -- 网银客户状态代码
    ,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'')  -- 证件类型代码
    ,replace(replace(t1.cert_no,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.orgnz_cd,chr(13),''),chr(10),'')  -- 组织机构代码
    ,replace(replace(t1.legal_rep_name,chr(13),''),chr(10),'')  -- 法人代表名称
    ,replace(replace(t1.lp_cert_type_cd,chr(13),''),chr(10),'')  -- 法人证件类型代码
    ,replace(replace(t1.lp_cert_no,chr(13),''),chr(10),'')  -- 法人证件号码
    ,replace(replace(t1.lp_tel_num,chr(13),''),chr(10),'')  -- 法人电话号码
    ,t1.lp_cert_exp_dt  -- 法人证件到期日期
    ,replace(replace(t1.edit_flg,chr(13),''),chr(10),'')  -- 版本标志
    ,replace(replace(t1.posta_addr,chr(13),''),chr(10),'')  -- 通讯地址
    ,replace(replace(t1.tel_num,chr(13),''),chr(10),'')  -- 电话号码
    ,replace(replace(t1.fax_num,chr(13),''),chr(10),'')  -- 传真号码
    ,replace(replace(t1.zip_cd,chr(13),''),chr(10),'')  -- 邮政编码
    ,replace(replace(t1.charge_acct_id,chr(13),''),chr(10),'')  -- 收费账户编号
    ,replace(replace(t1.charge_curr_cd,chr(13),''),chr(10),'')  -- 收费币种代码
    ,t1.final_tran_tm  -- 最后交易时间
    ,replace(replace(t1.status_modif_descb_info,chr(13),''),chr(10),'')  -- 状态变更描述信息
    ,t1.sign_yqt_tm  -- 签约银企通时间
    ,t1.oa_wrtoff_tm  -- OA注销时间
    ,replace(replace(t1.init_oa_id,chr(13),''),chr(10),'')  -- 原OA编号
    ,replace(replace(t1.oa_reim_rela_acct_id,chr(13),''),chr(10),'')  -- OA报销关联账户编号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${icl_schema}.cmm_conl_bk_sign_info t1    --企业网银签约信息
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_cmm_conl_bk_sign_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);