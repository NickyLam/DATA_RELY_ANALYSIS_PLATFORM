/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_cpes_bill_info
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
alter table ${idl_schema}.oass_agt_cpes_bill_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_cpes_bill_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_cpes_bill_info (
    etl_dt  -- 数据日期
    ,vouch_id  -- 凭证编号
    ,lp_id  -- 法人编号
    ,bill_id  -- 票据编号
    ,bill_num  -- 票据号码
    ,bill_med_cd  -- 票据介质代码
    ,bill_type_cd  -- 票据类型代码
    ,draw_dt  -- 出票日期
    ,exp_dt  -- 到期日期
    ,fac_val_amt  -- 票面金额
    ,drawer_name  -- 出票人名称
    ,drawer_acct_num  -- 出票人账号
    ,drawer_soci_crdt_cd  -- 出票人社会信用代码
    ,drawer_open_acct_org_cd  -- 出票人开户机构代码
    ,drawer_open_bank_no  -- 出票人开户行行号
    ,drawer_open_bank_name  -- 出票人开户行名称
    ,accptor_name  -- 承兑人名称
    ,accptor_acct_num  -- 承兑人账号
    ,accptor_soci_crdt_cd  -- 承兑人社会信用代码
    ,accptor_open_acct_org_cd  -- 承兑人开户机构代码
    ,accptor_open_bank_no  -- 承兑人开户行行号
    ,accptor_open_bank_name  -- 承兑人开户行名称
    ,recver_name  -- 收款人名称
    ,recver_acct_num  -- 收款人账号
    ,recver_soci_crdt_cd  -- 收款人社会信用代码
    ,recver_open_acct_org_cd  -- 收款人开户机构代码
    ,recver_open_bank_no  -- 收款人开户行行号
    ,recver_open_bank_name  -- 收款人开户行名称
    ,pay_bank_org_cd  -- 付款行机构代码
    ,pay_bank_no  -- 付款行行号
    ,pay_cfm_org_cd  -- 付款确认机构代码
    ,discnt_bk_org_cd  -- 贴现行机构代码
    ,discnt_guar_org_cd  -- 贴现保证机构代码
    ,invtry_org_cd  -- 库存机构代码
    ,bill_ccution_status_cd  -- 票据流转状态代码
    ,risk_bill_status_cd  -- 风险票据状态代码
    ,bill_invtry_status_cd  -- 票据库存状态代码
    ,bill_status_cd  -- 票据状态代码
    ,init_ccution_status_cd  -- 原流转状态代码
    ,init_risk_bill_status_cd  -- 原风险票据状态代码
    ,init_bill_status_cd  -- 原票据状态代码
    ,init_bill_invtry_status_cd  -- 原票据库存状态代码
    ,discnt_dt  -- 贴现日期
    ,start_dt  -- 开始时间
    ,end_dt  -- 结束时间
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.vouch_id,chr(13),''),chr(10),'')  -- 凭证编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.bill_id,chr(13),''),chr(10),'')  -- 票据编号
    ,replace(replace(t1.bill_num,chr(13),''),chr(10),'')  -- 票据号码
    ,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'')  -- 票据介质代码
    ,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'')  -- 票据类型代码
    ,t1.draw_dt  -- 出票日期
    ,t1.exp_dt  -- 到期日期
    ,t1.fac_val_amt  -- 票面金额
    ,replace(replace(t1.drawer_name,chr(13),''),chr(10),'')  -- 出票人名称
    ,replace(replace(t1.drawer_acct_num,chr(13),''),chr(10),'')  -- 出票人账号
    ,replace(replace(t1.drawer_soci_crdt_cd,chr(13),''),chr(10),'')  -- 出票人社会信用代码
    ,replace(replace(t1.drawer_open_acct_org_cd,chr(13),''),chr(10),'')  -- 出票人开户机构代码
    ,replace(replace(t1.drawer_open_bank_no,chr(13),''),chr(10),'')  -- 出票人开户行行号
    ,replace(replace(t1.drawer_open_bank_name,chr(13),''),chr(10),'')  -- 出票人开户行名称
    ,replace(replace(t1.accptor_name,chr(13),''),chr(10),'')  -- 承兑人名称
    ,replace(replace(t1.accptor_acct_num,chr(13),''),chr(10),'')  -- 承兑人账号
    ,replace(replace(t1.accptor_soci_crdt_cd,chr(13),''),chr(10),'')  -- 承兑人社会信用代码
    ,replace(replace(t1.accptor_open_acct_org_cd,chr(13),''),chr(10),'')  -- 承兑人开户机构代码
    ,replace(replace(t1.accptor_open_bank_no,chr(13),''),chr(10),'')  -- 承兑人开户行行号
    ,replace(replace(t1.accptor_open_bank_name,chr(13),''),chr(10),'')  -- 承兑人开户行名称
    ,replace(replace(t1.recver_name,chr(13),''),chr(10),'')  -- 收款人名称
    ,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'')  -- 收款人账号
    ,replace(replace(t1.recver_soci_crdt_cd,chr(13),''),chr(10),'')  -- 收款人社会信用代码
    ,replace(replace(t1.recver_open_acct_org_cd,chr(13),''),chr(10),'')  -- 收款人开户机构代码
    ,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'')  -- 收款人开户行行号
    ,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'')  -- 收款人开户行名称
    ,replace(replace(t1.pay_bank_org_cd,chr(13),''),chr(10),'')  -- 付款行机构代码
    ,replace(replace(t1.pay_bank_no,chr(13),''),chr(10),'')  -- 付款行行号
    ,replace(replace(t1.pay_cfm_org_cd,chr(13),''),chr(10),'')  -- 付款确认机构代码
    ,replace(replace(t1.discnt_bk_org_cd,chr(13),''),chr(10),'')  -- 贴现行机构代码
    ,replace(replace(t1.discnt_guar_org_cd,chr(13),''),chr(10),'')  -- 贴现保证机构代码
    ,replace(replace(t1.invtry_org_cd,chr(13),''),chr(10),'')  -- 库存机构代码
    ,replace(replace(t1.bill_ccution_status_cd,chr(13),''),chr(10),'')  -- 票据流转状态代码
    ,replace(replace(t1.risk_bill_status_cd,chr(13),''),chr(10),'')  -- 风险票据状态代码
    ,replace(replace(t1.bill_invtry_status_cd,chr(13),''),chr(10),'')  -- 票据库存状态代码
    ,replace(replace(t1.bill_status_cd,chr(13),''),chr(10),'')  -- 票据状态代码
    ,replace(replace(t1.init_ccution_status_cd,chr(13),''),chr(10),'')  -- 原流转状态代码
    ,replace(replace(t1.init_risk_bill_status_cd,chr(13),''),chr(10),'')  -- 原风险票据状态代码
    ,replace(replace(t1.init_bill_status_cd,chr(13),''),chr(10),'')  -- 原票据状态代码
    ,replace(replace(t1.init_bill_invtry_status_cd,chr(13),''),chr(10),'')  -- 原票据库存状态代码
    ,t1.discnt_dt  -- 贴现日期
    ,t1.start_dt  -- 开始时间
    ,t1.end_dt  -- 结束时间
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码
from ${iml_schema}.agt_cpes_bill_info t1    --票交所票据信息;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_cpes_bill_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);