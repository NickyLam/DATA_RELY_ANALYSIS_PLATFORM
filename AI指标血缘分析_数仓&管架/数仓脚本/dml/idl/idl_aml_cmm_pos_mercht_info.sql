/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_cmm_pos_mercht_info
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
alter table ${idl_schema}.aml_cmm_pos_mercht_info drop partition p_${last_date};
alter table ${idl_schema}.aml_cmm_pos_mercht_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_cmm_pos_mercht_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_cmm_pos_mercht_info (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,mercht_order_id  -- 商户序列编号
    ,mercht_id  -- 商户编号
    ,agency_id  -- 代理商编号
    ,mercht_name  -- 商户名称
    ,mercht_fname  -- 商户全称
    ,work_addr  -- 办公地址
    ,open_acct_bank_name  -- 开户银行名称
    ,open_acct_bank_id  -- 开户银行编号
    ,acct_id  -- 账户编号
    ,acct_name  -- 账户名称
    ,cotas_type_cd  -- 联系人类型代码
    ,cotas_name  -- 联系人名称
    ,cont_num  -- 联系号码
    ,cotas_e_mail  -- 联系人电子邮箱
    ,fax_num  -- 传真号码
    ,oper_co_corp_name  -- 经办合作单位名称
    ,agency_abbr  -- 代理商简称
    ,agency_belong_brch_id  -- 代理商所属分行编号
    ,agency_bus_lics_id  -- 代理商营业执照编号
    ,agency_cotas_name  -- 代理商联系人名称
    ,agency_cotas_addr  -- 代理商联系人地址
    ,agency_enter_acct_chn_cd  -- 代理商入账渠道代码
    ,agency_status_cd  -- 代理商状态代码
    ,recv_bill_bank_id  -- 收单银行编号
    ,mercht_status_cd  -- 商户状态代码
    ,belong_org_id  -- 所属机构编号
    ,cust_mgr_id  -- 客户经理编号
    ,cust_mgr_name  -- 客户经理名称
    ,flow_bank_apv_flow_id  -- 流程银行审批流水编号
    ,flow_bank_apv_rest_cd  -- 流程银行审批结果代码
    ,h5_flow_flg  -- H5进件标志
    ,dic_conc_co_status_cd  -- 直连商户合作状态代码
    ,dic_conc_mercht_flg  --直连商户标志
    ,jh_mercht_flg  --聚合商户标志
    ,mercht_start_use_dt  --商户启用日期
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.mercht_order_id,chr(13),''),chr(10),'')  -- 商户序列编号
    ,replace(replace(t1.mercht_id,chr(13),''),chr(10),'')  -- 商户编号
    ,replace(replace(t1.agency_id,chr(13),''),chr(10),'')  -- 代理商编号
    ,replace(replace(t1.mercht_name,chr(13),''),chr(10),'')  -- 商户名称
    ,replace(replace(t1.mercht_fname,chr(13),''),chr(10),'')  -- 商户全称
    ,replace(replace(t1.work_addr,chr(13),''),chr(10),'')  -- 办公地址
    ,replace(replace(t1.open_acct_bank_name,chr(13),''),chr(10),'')  -- 开户银行名称
    ,replace(replace(t1.open_acct_bank_id,chr(13),''),chr(10),'')  -- 开户银行编号
    ,replace(replace(t1.acct_id,chr(13),''),chr(10),'')  -- 账户编号
    ,replace(replace(t1.acct_name,chr(13),''),chr(10),'')  -- 账户名称
    ,replace(replace(t1.cotas_type_cd,chr(13),''),chr(10),'')  -- 联系人类型代码
    ,replace(replace(t1.cotas_name,chr(13),''),chr(10),'')  -- 联系人名称
    ,replace(replace(t1.cont_num,chr(13),''),chr(10),'')  -- 联系号码
    ,replace(replace(t1.cotas_e_mail,chr(13),''),chr(10),'')  -- 联系人电子邮箱
    ,replace(replace(t1.fax_num,chr(13),''),chr(10),'')  -- 传真号码
    ,replace(replace(t1.oper_co_corp_name,chr(13),''),chr(10),'')  -- 经办合作单位名称
    ,replace(replace(t1.agency_abbr,chr(13),''),chr(10),'')  -- 代理商简称
    ,replace(replace(t1.agency_belong_brch_id,chr(13),''),chr(10),'')  -- 代理商所属分行编号
    ,replace(replace(t1.agency_bus_lics_id,chr(13),''),chr(10),'')  -- 代理商营业执照编号
    ,replace(replace(t1.agency_cotas_name,chr(13),''),chr(10),'')  -- 代理商联系人名称
    ,replace(replace(t1.agency_cotas_addr,chr(13),''),chr(10),'')  -- 代理商联系人地址
    ,replace(replace(t1.agency_enter_acct_chn_cd,chr(13),''),chr(10),'')  -- 代理商入账渠道代码
    ,replace(replace(t1.agency_status_cd,chr(13),''),chr(10),'')  -- 代理商状态代码
    ,replace(replace(t1.recv_bill_bank_id,chr(13),''),chr(10),'')  -- 收单银行编号
    ,replace(replace(t1.mercht_status_cd,chr(13),''),chr(10),'')  -- 商户状态代码
    ,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'')  -- 所属机构编号
    ,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'')  -- 客户经理编号
    ,replace(replace(t1.cust_mgr_name,chr(13),''),chr(10),'')  -- 客户经理名称
    ,replace(replace(t1.flow_bank_apv_flow_id,chr(13),''),chr(10),'')  -- 流程银行审批流水编号
    ,replace(replace(t1.flow_bank_apv_rest_cd,chr(13),''),chr(10),'')  -- 流程银行审批结果代码
    ,replace(replace(t1.h5_flow_flg,chr(13),''),chr(10),'')  -- H5进件标志
    ,replace(replace(t1.dic_conc_co_status_cd,chr(13),''),chr(10),'')  -- 直连商户合作状态代码
    ,replace(replace(t1.dic_conc_mercht_flg,chr(13),''),chr(10),'') --直连商户标志
    ,replace(replace(t1.jh_mercht_flg,chr(13),''),chr(10),'') --聚合商户标志
    ,t1.mercht_start_use_dt --商户启用日期
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${icl_schema}.cmm_pos_mercht_info t1    --pos商户信息
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_cmm_pos_mercht_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);