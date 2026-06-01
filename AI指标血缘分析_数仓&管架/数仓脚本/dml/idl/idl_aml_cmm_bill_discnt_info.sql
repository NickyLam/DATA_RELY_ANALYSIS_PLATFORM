/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_cmm_bill_discnt_info
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
alter table ${idl_schema}.aml_cmm_bill_discnt_info drop partition p_${last_date};
alter table ${idl_schema}.aml_cmm_bill_discnt_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_cmm_bill_discnt_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_cmm_bill_discnt_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,bus_id  -- 业务编号
    ,batch_id  -- 批次编号
    ,bill_num  -- 票据号码
    ,cust_id  -- 客户编号
    ,cust_name  -- 客户名称
    ,bill_med_cd  -- 票据介质代码
    ,bill_kind_cd  -- 票据种类代码
    ,discnt_bus_type_cd  -- 贴现业务类型代码
    ,sys_in_flg  -- 系统内标志
    ,city_wide_flg  -- 同城标志
    ,int_accr_flg  -- 计息标志
    ,appl_dt  -- 申请日期
    ,recv_dt  -- 签收日期
    ,value_dt  -- 起息日期
    ,revo_dt  -- 撤销日期
    ,draw_dt  -- 出票日期
    ,exp_dt  -- 到期日期
    ,dir_rher_name  -- 直接前手名称
    ,discnt_applit_acct_num  -- 贴现申请人账号
    ,discnt_applit_bank_no  -- 贴现申请人行号
    ,dscnt_props_cate_cd  -- 贴出人类别代码
    ,dscnt_props_name  -- 贴出人名称
    ,dscnt_props_orgnz_cd  -- 贴出人组织机构代码
    ,dscnt_props_acct_num  -- 贴出人账号
    ,dscnt_props_open_bank_no  -- 贴出人开户行行号
    ,dscnt_name  -- 贴入人名称
    ,dscnt_bank_no  -- 贴入人行号
    ,drawer_name  -- 出票人名称
    ,drawer_cate_cd  -- 出票人类别代码
    ,drawer_acct_num  -- 出票人账号
    ,drawer_open_bank_no  -- 出票人开户行行号
    ,drawer_open_bank_name  -- 出票人开户行名称
    ,accptor_name  -- 承兑人名称
    ,accptor_acct_num  -- 承兑人账号
    ,accptor_open_bank_no  -- 承兑人开户行行号
    ,accptor_open_bank_name  -- 承兑人开户行名称
    ,main_guar_way_cd  -- 主担保方式代码
    ,agent_discnt_flg  -- 代理贴现标志
    ,onl_discnt_flg  -- 在线贴现标志
    ,entry_status_cd  -- 记账状态代码
    ,entry_dt  -- 记账日期
    ,int_accr_exp_dt  -- 计息到期日期
    ,discnt_int_rat  -- 贴现利率
    ,defer_days  -- 顺延天数
    ,int_accr_days  -- 计息天数
    ,not_ngbl_flg  -- 不得转让标志
    ,hxb_acpt_flg  -- 我行承兑标志
    ,curr_cd  -- 币种代码
    ,fac_val_amt  -- 票面金额
    ,payoff_flg  -- 结清标志
    ,discnt_status_cd  -- 贴现状态代码
    ,int_amt  -- 利息金额
    ,buyer_pay_int_amt  -- 买方付息金额
    ,actl_amt  -- 实付金额
    ,risk_bear_fee  -- 风险承担费
    ,issue_org_id  -- 签发机构编号
    ,enter_acct_org_id  -- 入账机构编号
    ,cust_mgr_id  -- 客户经理编号
    ,dept_id  -- 部门编号
    ,operr_id  -- 操作员编号
    ,agent_name  -- 代理人名称
    ,drawer_crdt_level_cd  -- 出票人信用等级代码
    ,drawer_rating_org_name  -- 出票人评级机构名称
    ,drawer_rating_exp_dt  -- 出票人评级到期日期
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    t1.etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.bus_id,chr(13),''),chr(10),'')  -- 业务编号
    ,replace(replace(t1.batch_id,chr(13),''),chr(10),'')  -- 批次编号
    ,replace(replace(t1.bill_num,chr(13),''),chr(10),'')  -- 票据号码
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.cust_name,chr(13),''),chr(10),'')  -- 客户名称
    ,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'')  -- 票据介质代码
    ,replace(replace(t1.bill_kind_cd,chr(13),''),chr(10),'')  -- 票据种类代码
    ,replace(replace(t1.discnt_bus_type_cd,chr(13),''),chr(10),'')  -- 贴现业务类型代码
    ,replace(replace(t1.sys_in_flg,chr(13),''),chr(10),'')  -- 系统内标志
    ,replace(replace(t1.city_wide_flg,chr(13),''),chr(10),'')  -- 同城标志
    ,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'')  -- 计息标志
    ,t1.appl_dt  -- 申请日期
    ,t1.recv_dt  -- 签收日期
    ,t1.value_dt  -- 起息日期
    ,t1.revo_dt  -- 撤销日期
    ,t1.draw_dt  -- 出票日期
    ,t1.exp_dt  -- 到期日期
    ,replace(replace(t1.dir_rher_name,chr(13),''),chr(10),'')  -- 直接前手名称
    ,replace(replace(t1.discnt_applit_acct_num,chr(13),''),chr(10),'')  -- 贴现申请人账号
    ,replace(replace(t1.discnt_applit_bank_no,chr(13),''),chr(10),'')  -- 贴现申请人行号
    ,replace(replace(t1.dscnt_props_cate_cd,chr(13),''),chr(10),'')  -- 贴出人类别代码
    ,replace(replace(t1.dscnt_props_name,chr(13),''),chr(10),'')  -- 贴出人名称
    ,replace(replace(t1.dscnt_props_orgnz_cd,chr(13),''),chr(10),'')  -- 贴出人组织机构代码
    ,replace(replace(t1.dscnt_props_acct_num,chr(13),''),chr(10),'')  -- 贴出人账号
    ,replace(replace(t1.dscnt_props_open_bank_no,chr(13),''),chr(10),'')  -- 贴出人开户行行号
    ,replace(replace(t1.dscnt_name,chr(13),''),chr(10),'')  -- 贴入人名称
    ,replace(replace(t1.dscnt_bank_no,chr(13),''),chr(10),'')  -- 贴入人行号
    ,replace(replace(t1.drawer_name,chr(13),''),chr(10),'')  -- 出票人名称
    ,replace(replace(t1.drawer_cate_cd,chr(13),''),chr(10),'')  -- 出票人类别代码
    ,replace(replace(t1.drawer_acct_num,chr(13),''),chr(10),'')  -- 出票人账号
    ,replace(replace(t1.drawer_open_bank_no,chr(13),''),chr(10),'')  -- 出票人开户行行号
    ,replace(replace(t1.drawer_open_bank_name,chr(13),''),chr(10),'')  -- 出票人开户行名称
    ,replace(replace(t1.accptor_name,chr(13),''),chr(10),'')  -- 承兑人名称
    ,replace(replace(t1.accptor_acct_num,chr(13),''),chr(10),'')  -- 承兑人账号
    ,replace(replace(t1.accptor_open_bank_no,chr(13),''),chr(10),'')  -- 承兑人开户行行号
    ,replace(replace(t1.accptor_open_bank_name,chr(13),''),chr(10),'')  -- 承兑人开户行名称
    ,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'')  -- 主担保方式代码
    ,replace(replace(t1.agent_discnt_flg,chr(13),''),chr(10),'')  -- 代理贴现标志
    ,replace(replace(t1.onl_discnt_flg,chr(13),''),chr(10),'')  -- 在线贴现标志
    ,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'')  -- 记账状态代码
    ,t1.entry_dt  -- 记账日期
    ,t1.int_accr_exp_dt  -- 计息到期日期
    ,t1.discnt_int_rat  -- 贴现利率
    ,replace(replace(t1.defer_days,chr(13),''),chr(10),'')  -- 顺延天数
    ,t1.int_accr_days  -- 计息天数
    ,replace(replace(t1.not_ngbl_flg,chr(13),''),chr(10),'')  -- 不得转让标志
    ,replace(replace(t1.hxb_acpt_flg,chr(13),''),chr(10),'')  -- 我行承兑标志
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.fac_val_amt  -- 票面金额
    ,replace(replace(t1.payoff_flg,chr(13),''),chr(10),'')  -- 结清标志
    ,replace(replace(t1.discnt_status_cd,chr(13),''),chr(10),'')  -- 贴现状态代码
    ,t1.int_amt  -- 利息金额
    ,t1.buyer_pay_int_amt  -- 买方付息金额
    ,t1.actl_amt  -- 实付金额
    ,t1.risk_bear_fee  -- 风险承担费
    ,replace(replace(t1.issue_org_id,chr(13),''),chr(10),'')  -- 签发机构编号
    ,replace(replace(t1.enter_acct_org_id,chr(13),''),chr(10),'')  -- 入账机构编号
    ,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'')  -- 客户经理编号
    ,replace(replace(t1.dept_id,chr(13),''),chr(10),'')  -- 部门编号
    ,replace(replace(t1.operr_id,chr(13),''),chr(10),'')  -- 操作员编号
    ,replace(replace(t1.agent_name,chr(13),''),chr(10),'')  -- 代理人名称
    ,replace(replace(t1.drawer_crdt_level_cd,chr(13),''),chr(10),'')  -- 出票人信用等级代码
    ,replace(replace(t1.drawer_rating_org_name,chr(13),''),chr(10),'')  -- 出票人评级机构名称
    ,t1.drawer_rating_exp_dt  -- 出票人评级到期日期
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,t1.etl_timestamp  -- ETL处理时间戳
from ${icl_schema}.cmm_bill_discnt_info t1    --票据贴现信息
where t1.etl_dt= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_cmm_bill_discnt_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);