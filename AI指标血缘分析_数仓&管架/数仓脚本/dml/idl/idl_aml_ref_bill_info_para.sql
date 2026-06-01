/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_ref_bill_info_para
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
alter table ${idl_schema}.aml_ref_bill_info_para drop partition p_${last_date};
alter table ${idl_schema}.aml_ref_bill_info_para drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_ref_bill_info_para add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_ref_bill_info_para partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,bill_id  -- 票据编号
    ,lp_id  -- 法人编号
    ,bill_num  -- 票据号码
    ,bill_lev_ctrl_flg  -- 票据级别控制标志
    ,role_src_cd  -- 角色来源代码
    ,discnt_batch_id  -- 贴现批次编号
    ,pbc_tranbl_flg  -- 人行可转让标志
    ,hxb_acpt_flg  -- 我行承兑标志
    ,bill_med_cd  -- 票据介质代码
    ,bill_type_cd  -- 票据类型代码
    ,draw_dt  -- 出票日期
    ,fac_val_exp_dt  -- 票面到期日期
    ,cust_id  -- 客户编号
    ,drawer_cate_cd  -- 出票人类别代码
    ,drawer_orgnz_cd  -- 出票人组织机构代码
    ,drawer_name  -- 出票人名称
    ,drawer_acct_num  -- 出票人账号
    ,drawer_open_bank_num  -- 出票人开户行号
    ,accptor_open_bank_name  -- 承兑人开户行名称
    ,drawer_open_bank_name  -- 出票人开户行名称
    ,accptor_name  -- 承兑人名称
    ,accptor_open_bank_num  -- 承兑人开户行号
    ,accptor_acct_num  -- 承兑人账号
    ,recver_name  -- 收款人名称
    ,recver_acct_num  -- 收款人账号
    ,recver_open_bank_num  -- 收款人开户行号
    ,recver_open_bank_name  -- 收款人开户行名称
    ,bill_amt  -- 票据金额
    ,sys_in_acpt_flg  -- 系统内承兑标志
    ,bill_belong_org_id  -- 票据所属机构编号
    ,bill_invtry_status_cd  -- 票据库存状态代码
    ,bill_status_cd  -- 票据状态代码
    ,proc_mdl_status_cd  -- 处理中状态代码
    ,inpwn_status_cd  -- 质押状态代码
    ,inpwn_rgst_b_id  -- 质押登记簿编号
    ,loss_status_cd  -- 挂失状态代码
    ,loss_rgst_b_id  -- 挂失登记簿编号
    ,final_modif_operr_id  -- 最后修改操作员编号
    ,final_modif_tm  -- 最后修改时间
    ,drawer_crdt_level_cd  -- 出票人信用等级代码
    ,drawer_rating_org_id  -- 出票人评级机构编号
    ,drawer_rating_exp_dt  -- 出票人评级到期日期
    ,recv_bank_name  -- 收款行名称
    ,cpes_acpt_rgst_status_flg  -- 票交所承兑登记状态标志
    ,cpes_discnt_rgst_status_flg  -- 票交所贴现登记状态标志
    ,drawer_unify_soci_crdt_cd  -- 出票人统一社会信用代码
    ,payoff_flg  -- 结清标志
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.bill_id,chr(13),''),chr(10),'')  -- 票据编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.bill_num,chr(13),''),chr(10),'')  -- 票据号码
    ,null as bill_lev_ctrl_flg  -- 票据级别控制标志
    ,replace(replace(t1.role_src_cd,chr(13),''),chr(10),'')  -- 角色来源代码
    ,replace(replace(t1.discnt_batch_id,chr(13),''),chr(10),'')  -- 贴现批次编号
    ,replace(replace(t1.pbc_tranbl_flg,chr(13),''),chr(10),'')  -- 人行可转让标志
    ,replace(replace(t1.hxb_acpt_flg,chr(13),''),chr(10),'')  -- 我行承兑标志
    ,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'')  -- 票据介质代码
    ,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'')  -- 票据类型代码
    ,t1.draw_dt  -- 出票日期
    ,t1.fac_val_exp_dt  -- 票面到期日期
    ,null as cust_id  -- 客户编号
    ,replace(replace(t1.drawer_cate_cd,chr(13),''),chr(10),'')  -- 出票人类别代码
    ,replace(replace(t1.drawer_orgnz_cd,chr(13),''),chr(10),'')  -- 出票人组织机构代码
    ,replace(replace(t1.drawer_name,chr(13),''),chr(10),'')  -- 出票人名称
    ,replace(replace(t1.drawer_acct_num,chr(13),''),chr(10),'')  -- 出票人账号
    ,replace(replace(t1.drawer_open_bank_num,chr(13),''),chr(10),'')  -- 出票人开户行号
    ,replace(replace(t1.accptor_open_bank_name,chr(13),''),chr(10),'')  -- 承兑人开户行名称
    ,replace(replace(t1.drawer_open_bank_name,chr(13),''),chr(10),'')  -- 出票人开户行名称
    ,replace(replace(t1.accptor_name,chr(13),''),chr(10),'')  -- 承兑人名称
    ,replace(replace(t1.accptor_open_bank_num,chr(13),''),chr(10),'')  -- 承兑人开户行号
    ,replace(replace(t1.accptor_acct_num,chr(13),''),chr(10),'')  -- 承兑人账号
    ,replace(replace(t1.recver_name,chr(13),''),chr(10),'')  -- 收款人名称
    ,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'')  -- 收款人账号
    ,replace(replace(t1.recver_open_bank_num,chr(13),''),chr(10),'')  -- 收款人开户行号
    ,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'')  -- 收款人开户行名称
    ,t1.bill_amt  -- 票据金额
    ,null as sys_in_acpt_flg  -- 系统内承兑标志
    ,replace(replace(t1.bill_belong_org_id,chr(13),''),chr(10),'')  -- 票据所属机构编号
    ,null as bill_invtry_status_cd  -- 票据库存状态代码
    ,replace(replace(t1.bill_status_cd,chr(13),''),chr(10),'')  -- 票据状态代码
    ,null as proc_mdl_status_cd  -- 处理中状态代码
    ,null as inpwn_status_cd  -- 质押状态代码
    ,null as inpwn_rgst_b_id  -- 质押登记簿编号
    ,null as loss_status_cd  -- 挂失状态代码
    ,null as loss_rgst_b_id  -- 挂失登记簿编号
    ,replace(replace(t1.final_modif_operr_id,chr(13),''),chr(10),'')  -- 最后修改操作员编号
    ,t1.final_modif_tm  -- 最后修改时间
    ,null as drawer_crdt_level_cd  -- 出票人信用等级代码
    ,null as drawer_rating_org_id  -- 出票人评级机构编号
    ,null as drawer_rating_exp_dt  -- 出票人评级到期日期
    ,null as recv_bank_name  -- 收款行名称
    ,null as CPES_ACPT_RGST_STATUS_FLG  -- 票交所承兑登记状态标志
    ,null as CPES_DISCNT_RGST_STATUS_FLG  -- 票交所贴现登记状态标志
    ,null as drawer_unify_soci_crdt_cd  -- 出票人统一社会信用代码
    ,null as payoff_flg  -- 结清标志
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from iml.agt_bill_info t1    --票据信息
where t1.update_dt = to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_ref_bill_info_para',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);