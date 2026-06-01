/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_corp_rgst_bill_info_para_bdmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_corp_rgst_bill_info_para add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_corp_rgst_bill_info_para partition for ('bdmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_tm purge;
drop table ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_op purge;
drop table ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,bill_num -- 票据号码
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_amt -- 票据金额
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bill_src_plat_cd -- 票据来源平台代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,allow_split_pkg_ccution_flg -- 允许分包流转标志
    ,init_bill_id -- 原始票据编号
    ,actl_bf_split_bill_id -- 实际拆前票据编号
    ,actl_bf_split_intrv_id -- 实际拆前区间编号
    ,drawer_mem_cd -- 出票人会员代码
    ,drawer_name -- 出票人名称
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,drawer_acct_type_cd -- 出票人账户类型代码
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_acct_name -- 出票人账户名称
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,drawer_open_bank_org_cd -- 出票人开户行机构代码
    ,drawer_open_bank_org_name -- 出票人开户行机构名称
    ,accptor_mem_cd -- 承兑人会员代码
    ,accptor_name -- 承兑人名称
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,accptor_acct_type_cd -- 承兑人账户类型代码
    ,accptor_acct_id -- 承兑人账户编号
    ,accptor_acct_name -- 承兑人账户名称
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,accptor_open_bank_org_cd -- 承兑人开户行机构代码
    ,accptor_open_bank_org_name -- 承兑人开户行机构名称
    ,recver_mem_cd -- 收款人会员代码
    ,recver_name -- 收款人名称
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,recver_acct_type_cd -- 收款人账户类型代码
    ,recver_acct_id -- 收款人账户编号
    ,recver_acct_name -- 收款人账户名称
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_open_bank_org_cd -- 收款人开户行机构代码
    ,recver_open_bank_org_name -- 收款人开户行机构名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_name -- 付款行名称
    ,acpt_guar_bk_bank_no -- 承兑保证行行号
    ,acpt_guar_bk_org_cd -- 承兑保证行机构代码
    ,coll_bank_bank_no -- 托收行行号
    ,discnt_dt -- 贴现日期
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_bank_name -- 贴现行名称
    ,init_belong_rgst_org_cd -- 初始权属登记机构代码
    ,risk_bill_status_cd -- 风险票据状态代码
    ,not_ngbl_cd -- 不得转让代码
    ,exp_uncond_pay_entr_cd -- 到期无条件支付委托代码
    ,payoff_flg -- 结清标志
    ,payoff_dt -- 结清日期
    ,recs_type_cd -- 追索类型代码
    ,bf_discnt_manual_recs_cd -- 贴现前手动追索代码
    ,manual_recs_lock_flg_cd -- 手动追索锁定标志代码
    ,endors_cnt -- 背书次数
    ,bill_obg_mem_cd -- 票据权利人会员代码
    ,bill_obg_name -- 票据权利人名称
    ,bill_obg_soci_crdt_cd -- 票据权利人社会信用代码
    ,bill_obg_acct_type_cd -- 票据权利人账户类型代码
    ,bill_obg_acct_id -- 票据权利人账户编号
    ,bill_obg_open_bank_no -- 票据权利人开户行行号
    ,bill_obg_open_bank_name -- 票据权利人开户行名称
    ,bill_obg_open_bank_org_cd -- 票据权利人开户行机构代码
    ,bill_obg_open_bank_org_name -- 票据权利人开户行机构名称
    ,lock_flg -- 锁定标志
    ,bill_src_tran_cd -- 票据来源交易代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,bill_status_cd -- 票据状态代码
    ,bill_belong_name -- 票据所属人名称
    ,bill_belong_soci_crdt_cd -- 票据所属人社会信用代码
    ,bill_belong_acct_id -- 票据所属人账户编号
    ,bill_belong_open_bank_no -- 票据所属人开户行行号
    ,bill_belong_open_bank_name -- 票据所属人开户行名称
    ,bill_belong_open_bank_org_cd -- 票据所属人开户行机构代码
    ,bill_belong_open_bank_org_name -- 票据所属人开户行机构名称
    ,fir_rgst_id -- 首次登记编号
    ,final_modif_tm -- 最后修改时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_corp_rgst_bill_info_para partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_corp_rgst_bill_info_para partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_corp_rgst_bill_info_para partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_cust_dpc_draft_info-
insert into ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_tm(
    rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,bill_num -- 票据号码
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_amt -- 票据金额
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bill_src_plat_cd -- 票据来源平台代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,allow_split_pkg_ccution_flg -- 允许分包流转标志
    ,init_bill_id -- 原始票据编号
    ,actl_bf_split_bill_id -- 实际拆前票据编号
    ,actl_bf_split_intrv_id -- 实际拆前区间编号
    ,drawer_mem_cd -- 出票人会员代码
    ,drawer_name -- 出票人名称
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,drawer_acct_type_cd -- 出票人账户类型代码
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_acct_name -- 出票人账户名称
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,drawer_open_bank_org_cd -- 出票人开户行机构代码
    ,drawer_open_bank_org_name -- 出票人开户行机构名称
    ,accptor_mem_cd -- 承兑人会员代码
    ,accptor_name -- 承兑人名称
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,accptor_acct_type_cd -- 承兑人账户类型代码
    ,accptor_acct_id -- 承兑人账户编号
    ,accptor_acct_name -- 承兑人账户名称
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,accptor_open_bank_org_cd -- 承兑人开户行机构代码
    ,accptor_open_bank_org_name -- 承兑人开户行机构名称
    ,recver_mem_cd -- 收款人会员代码
    ,recver_name -- 收款人名称
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,recver_acct_type_cd -- 收款人账户类型代码
    ,recver_acct_id -- 收款人账户编号
    ,recver_acct_name -- 收款人账户名称
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_open_bank_org_cd -- 收款人开户行机构代码
    ,recver_open_bank_org_name -- 收款人开户行机构名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_name -- 付款行名称
    ,acpt_guar_bk_bank_no -- 承兑保证行行号
    ,acpt_guar_bk_org_cd -- 承兑保证行机构代码
    ,coll_bank_bank_no -- 托收行行号
    ,discnt_dt -- 贴现日期
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_bank_name -- 贴现行名称
    ,init_belong_rgst_org_cd -- 初始权属登记机构代码
    ,risk_bill_status_cd -- 风险票据状态代码
    ,not_ngbl_cd -- 不得转让代码
    ,exp_uncond_pay_entr_cd -- 到期无条件支付委托代码
    ,payoff_flg -- 结清标志
    ,payoff_dt -- 结清日期
    ,recs_type_cd -- 追索类型代码
    ,bf_discnt_manual_recs_cd -- 贴现前手动追索代码
    ,manual_recs_lock_flg_cd -- 手动追索锁定标志代码
    ,endors_cnt -- 背书次数
    ,bill_obg_mem_cd -- 票据权利人会员代码
    ,bill_obg_name -- 票据权利人名称
    ,bill_obg_soci_crdt_cd -- 票据权利人社会信用代码
    ,bill_obg_acct_type_cd -- 票据权利人账户类型代码
    ,bill_obg_acct_id -- 票据权利人账户编号
    ,bill_obg_open_bank_no -- 票据权利人开户行行号
    ,bill_obg_open_bank_name -- 票据权利人开户行名称
    ,bill_obg_open_bank_org_cd -- 票据权利人开户行机构代码
    ,bill_obg_open_bank_org_name -- 票据权利人开户行机构名称
    ,lock_flg -- 锁定标志
    ,bill_src_tran_cd -- 票据来源交易代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,bill_status_cd -- 票据状态代码
    ,bill_belong_name -- 票据所属人名称
    ,bill_belong_soci_crdt_cd -- 票据所属人社会信用代码
    ,bill_belong_acct_id -- 票据所属人账户编号
    ,bill_belong_open_bank_no -- 票据所属人开户行行号
    ,bill_belong_open_bank_name -- 票据所属人开户行名称
    ,bill_belong_open_bank_org_cd -- 票据所属人开户行机构代码
    ,bill_belong_open_bank_org_name -- 票据所属人开户行机构名称
    ,fir_rgst_id -- 首次登记编号
    ,final_modif_tm -- 最后修改时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 登记编号
    ,'9999' -- 法人编号
    ,P1.DRAFT_NUMBER -- 票据号码
    ,P1.CD_RANGE -- 票据子区间编号
    ,P1.DRAFT_AMOUNT -- 票据金额
    ,P1.STANDARD_AMT -- 票据区间标准金额
    ,case when R1.TARGET_CD_VAL is not null then R1.TARGET_CD_VAL else '@'||P1.DRAFT_ATTR end -- 票据介质代码
    ,case when R2.TARGET_CD_VAL is not null then R2.TARGET_CD_VAL else '@'||P1.DRAFT_TYPE end -- 票据类型代码
    ,nvl(trim(P1.PRODUCT_TYPE),'-') -- 票据来源平台代码
    ,${iml_schema}.dateformat_min(P1.REMIT_DATE) -- 出票日期
    ,${iml_schema}.dateformat_max2(P1.MATURITY_DATE) -- 到期日期
    ,P1.CD_SPLIT -- 允许分包流转标志
    ,P1.ORG_DRAFT_ID -- 原始票据编号
    ,P1.SPLIT_DRAFT_ID -- 实际拆前票据编号
    ,P1.SPLIT_RANGE -- 实际拆前区间编号
    ,P1.REMITTER_MEM_NO -- 出票人会员代码
    ,P1.REMITTER_NAME -- 出票人名称
    ,P1.REMITTER_CRT_NO -- 出票人社会信用代码
    ,nvl(trim(P1.REMITTER_DIST_TP),'-') -- 出票人账户类型代码
    ,P1.REMITTER_ACCOUNT -- 出票人账户编号
    ,P1.REMITTER_ACCTNAME -- 出票人账户名称
    ,P1.REMITTER_BANK_NO -- 出票人开户行行号
    ,P1.REMITTER_BANK_NAME -- 出票人开户行名称
    ,P1.REMITTER_BRH_NO -- 出票人开户行机构代码
    ,P1.REMITTER_BRH_NAME -- 出票人开户行机构名称
    ,P1.ACCEPTOR_MEM_NO -- 承兑人会员代码
    ,P1.ACCEPTOR_NAME -- 承兑人名称
    ,P1.ACCEPTOR_CRT_NO -- 承兑人社会信用代码
    ,nvl(trim(P1.ACCEPTOR_DIST_TP),'-') -- 承兑人账户类型代码
    ,P1.ACCEPTOR_ACCOUNT -- 承兑人账户编号
    ,P1.ACCEPTOR_ACCTNAME -- 承兑人账户名称
    ,P1.ACCEPTOR_BANK_NO -- 承兑人开户行行号
    ,P1.ACCEPTOR_BANK_NAME -- 承兑人开户行名称
    ,P1.ACCEPTOR_BRH_NO -- 承兑人开户行机构代码
    ,P1.ACCEPTOR_BRH_NAME -- 承兑人开户行机构名称
    ,P1.PAYEE_MEM_NO -- 收款人会员代码
    ,P1.PAYEE_NAME -- 收款人名称
    ,P1.PAYEE_CRT_NO -- 收款人社会信用代码
    ,nvl(trim(P1.PAYEE_DIST_TP),'-') -- 收款人账户类型代码
    ,P1.PAYEE_ACCOUNT -- 收款人账户编号
    ,P1.PAYEE_ACCTNAME -- 收款人账户名称
    ,P1.PAYEE_BANK_NO -- 收款人开户行行号
    ,P1.PAYEE_BANK_NAME -- 收款人开户行名称
    ,P1.PAYEE_BRH_NO -- 收款人开户行机构代码
    ,P1.PAYEE_BRH_NAME -- 收款人开户行机构名称
    ,P1.DRAWEE_BANK_NO -- 付款行行号
    ,P1.DRAWEE_BRH_NO -- 付款行机构代码
    ,P1.DRAWEE_BANK_NAME -- 付款行名称
    ,P1.GUA_ACCEPT_BANK_NO -- 承兑保证行行号
    ,P1.GUA_ACCEPT_BRH_NO -- 承兑保证行机构代码
    ,P1.COLLECTION_BANK_NO -- 托收行行号
    ,${iml_schema}.dateformat_min(P1.DISC_DATE) -- 贴现日期
    ,P1.DISCOUNT_BRH_NO -- 贴现行机构代码
    ,P1.DISCOUNT_BRH_NAME -- 贴现行名称
    ,P1.INIT_BRH_NO -- 初始权属登记机构代码
    ,nvl(trim(P1.RISK_STATUS),'-') -- 风险票据状态代码
    ,case when R3.TARGET_CD_VAL is not null then R3.TARGET_CD_VAL else '@'||P1.TRANSFER_FLAG end -- 不得转让代码
    ,nvl(trim(P1.CONSIGNMENT_CODE),'-') -- 到期无条件支付委托代码
    ,nvl(trim(P1.SETTLE_FLAG),'-') -- 结清标志
    ,${iml_schema}.dateformat_max2(P1.SETTLE_DATE) -- 结清日期
    ,case when R4.TARGET_CD_VAL is not null then R4.TARGET_CD_VAL else '@'||P1.RECOVERY_FLAG end -- 追索类型代码
    ,nvl(trim(P1.RECOVERY_HAND_FLAG),'-') -- 贴现前手动追索代码
    ,nvl(trim(P1.HAND_RECOVERY_LOCK_FLAG),'-') -- 手动追索锁定标志代码
    ,P1.ENDORSE_TIMES -- 背书次数
    ,P1.OWNER_MEM_NO -- 票据权利人会员代码
    ,P1.OWNER_NAME -- 票据权利人名称
    ,P1.OWNER_CRT_NO -- 票据权利人社会信用代码
    ,nvl(trim(P1.OWNER_DIST_TP),'-') -- 票据权利人账户类型代码
    ,P1.OWNER_ACCOUNT -- 票据权利人账户编号
    ,P1.OWNER_BANK_NO -- 票据权利人开户行行号
    ,P1.OWNER_BANK_NAME -- 票据权利人开户行名称
    ,P1.OWNER_BRH_NO -- 票据权利人开户行机构代码
    ,P1.OWNER_BRH_NAME -- 票据权利人开户行机构名称
    ,nvl(trim(P1.LOCK_FLAG),'-') -- 锁定标志
    ,nvl(trim(P1.SRC_TYPE),'-') -- 票据来源交易代码
    ,nvl(trim(P1.FLOW_STATUS),'-') -- 票据流转状态代码
    ,nvl(trim(P1.STATUS),'-') -- 票据状态代码
    ,P1.BELONG_NAME -- 票据所属人名称
    ,P1.BELONG_CRT_NO -- 票据所属人社会信用代码
    ,P1.BELONG_ACCOUNT -- 票据所属人账户编号
    ,P1.BELONG_BANK_NO -- 票据所属人开户行行号
    ,P1.BELONG_BANK_NAME -- 票据所属人开户行名称
    ,P1.BELONG_BRH_NO -- 票据所属人开户行机构代码
    ,P1.BELONG_BRH_NAME -- 票据所属人开户行机构名称
    ,P1.INIT_TRANS_ID -- 首次登记编号
    ,${iml_schema}.timeformat_max2(p1.last_upd_time) -- 最后修改时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cust_dpc_draft_info' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.bdms_cust_dpc_draft_info p1
  left join ${iml_schema}.ref_pub_cd_map r1
    on p1.draft_attr = r1.src_code_val
   and r1.sorc_sys_cd = 'BDMS'
   and r1.src_tab_en_name = 'BDMS_CUST_DPC_DRAFT_INFO'
   and r1.src_field_en_name = 'DRAFT_ATTR'
   and r1.target_tab_en_name = 'REF_CORP_RGST_BILL_INFO_PARA'
   and r1.target_tab_field_en_name = 'BILL_MED_CD'
  left join ${iml_schema}.ref_pub_cd_map r2
    on p1.draft_type = r2.src_code_val
   and r2.sorc_sys_cd = 'BDMS'
   and r2.src_tab_en_name = 'BDMS_CUST_DPC_DRAFT_INFO'
   and r2.src_field_en_name = 'DRAFT_TYPE'
   and r2.target_tab_en_name = 'REF_CORP_RGST_BILL_INFO_PARA'
   and r2.target_tab_field_en_name = 'BILL_TYPE_CD'
  left join ${iml_schema}.ref_pub_cd_map r3
    on p1.transfer_flag = r3.src_code_val
   and r3.sorc_sys_cd = 'BDMS'
   and r3.src_tab_en_name = 'BDMS_CUST_DPC_DRAFT_INFO'
   and r3.src_field_en_name = 'TRANSFER_FLAG'
   and r3.target_tab_en_name = 'REF_CORP_RGST_BILL_INFO_PARA'
   and r3.target_tab_field_en_name = 'NOT_NGBL_CD'
  left join ${iml_schema}.ref_pub_cd_map r4
    on p1.recovery_flag = r4.src_code_val
   and r4.sorc_sys_cd = 'BDMS'
   and r4.src_tab_en_name = 'BDMS_CUST_DPC_DRAFT_INFO'
   and r4.src_field_en_name = 'RECOVERY_FLAG'
   and r4.target_tab_en_name = 'REF_CORP_RGST_BILL_INFO_PARA'
   and r4.target_tab_field_en_name = 'RECS_TYPE_CD'
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and p1.migrate_flag  <> '1' -- ecds迁移票据标志
   ;
 commit;



commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_tm 
  	                                group by 
  	                                        rgst_id
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_cl(
            rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,bill_num -- 票据号码
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_amt -- 票据金额
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bill_src_plat_cd -- 票据来源平台代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,allow_split_pkg_ccution_flg -- 允许分包流转标志
    ,init_bill_id -- 原始票据编号
    ,actl_bf_split_bill_id -- 实际拆前票据编号
    ,actl_bf_split_intrv_id -- 实际拆前区间编号
    ,drawer_mem_cd -- 出票人会员代码
    ,drawer_name -- 出票人名称
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,drawer_acct_type_cd -- 出票人账户类型代码
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_acct_name -- 出票人账户名称
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,drawer_open_bank_org_cd -- 出票人开户行机构代码
    ,drawer_open_bank_org_name -- 出票人开户行机构名称
    ,accptor_mem_cd -- 承兑人会员代码
    ,accptor_name -- 承兑人名称
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,accptor_acct_type_cd -- 承兑人账户类型代码
    ,accptor_acct_id -- 承兑人账户编号
    ,accptor_acct_name -- 承兑人账户名称
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,accptor_open_bank_org_cd -- 承兑人开户行机构代码
    ,accptor_open_bank_org_name -- 承兑人开户行机构名称
    ,recver_mem_cd -- 收款人会员代码
    ,recver_name -- 收款人名称
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,recver_acct_type_cd -- 收款人账户类型代码
    ,recver_acct_id -- 收款人账户编号
    ,recver_acct_name -- 收款人账户名称
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_open_bank_org_cd -- 收款人开户行机构代码
    ,recver_open_bank_org_name -- 收款人开户行机构名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_name -- 付款行名称
    ,acpt_guar_bk_bank_no -- 承兑保证行行号
    ,acpt_guar_bk_org_cd -- 承兑保证行机构代码
    ,coll_bank_bank_no -- 托收行行号
    ,discnt_dt -- 贴现日期
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_bank_name -- 贴现行名称
    ,init_belong_rgst_org_cd -- 初始权属登记机构代码
    ,risk_bill_status_cd -- 风险票据状态代码
    ,not_ngbl_cd -- 不得转让代码
    ,exp_uncond_pay_entr_cd -- 到期无条件支付委托代码
    ,payoff_flg -- 结清标志
    ,payoff_dt -- 结清日期
    ,recs_type_cd -- 追索类型代码
    ,bf_discnt_manual_recs_cd -- 贴现前手动追索代码
    ,manual_recs_lock_flg_cd -- 手动追索锁定标志代码
    ,endors_cnt -- 背书次数
    ,bill_obg_mem_cd -- 票据权利人会员代码
    ,bill_obg_name -- 票据权利人名称
    ,bill_obg_soci_crdt_cd -- 票据权利人社会信用代码
    ,bill_obg_acct_type_cd -- 票据权利人账户类型代码
    ,bill_obg_acct_id -- 票据权利人账户编号
    ,bill_obg_open_bank_no -- 票据权利人开户行行号
    ,bill_obg_open_bank_name -- 票据权利人开户行名称
    ,bill_obg_open_bank_org_cd -- 票据权利人开户行机构代码
    ,bill_obg_open_bank_org_name -- 票据权利人开户行机构名称
    ,lock_flg -- 锁定标志
    ,bill_src_tran_cd -- 票据来源交易代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,bill_status_cd -- 票据状态代码
    ,bill_belong_name -- 票据所属人名称
    ,bill_belong_soci_crdt_cd -- 票据所属人社会信用代码
    ,bill_belong_acct_id -- 票据所属人账户编号
    ,bill_belong_open_bank_no -- 票据所属人开户行行号
    ,bill_belong_open_bank_name -- 票据所属人开户行名称
    ,bill_belong_open_bank_org_cd -- 票据所属人开户行机构代码
    ,bill_belong_open_bank_org_name -- 票据所属人开户行机构名称
    ,fir_rgst_id -- 首次登记编号
    ,final_modif_tm -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_op(
            rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,bill_num -- 票据号码
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_amt -- 票据金额
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bill_src_plat_cd -- 票据来源平台代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,allow_split_pkg_ccution_flg -- 允许分包流转标志
    ,init_bill_id -- 原始票据编号
    ,actl_bf_split_bill_id -- 实际拆前票据编号
    ,actl_bf_split_intrv_id -- 实际拆前区间编号
    ,drawer_mem_cd -- 出票人会员代码
    ,drawer_name -- 出票人名称
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,drawer_acct_type_cd -- 出票人账户类型代码
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_acct_name -- 出票人账户名称
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,drawer_open_bank_org_cd -- 出票人开户行机构代码
    ,drawer_open_bank_org_name -- 出票人开户行机构名称
    ,accptor_mem_cd -- 承兑人会员代码
    ,accptor_name -- 承兑人名称
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,accptor_acct_type_cd -- 承兑人账户类型代码
    ,accptor_acct_id -- 承兑人账户编号
    ,accptor_acct_name -- 承兑人账户名称
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,accptor_open_bank_org_cd -- 承兑人开户行机构代码
    ,accptor_open_bank_org_name -- 承兑人开户行机构名称
    ,recver_mem_cd -- 收款人会员代码
    ,recver_name -- 收款人名称
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,recver_acct_type_cd -- 收款人账户类型代码
    ,recver_acct_id -- 收款人账户编号
    ,recver_acct_name -- 收款人账户名称
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_open_bank_org_cd -- 收款人开户行机构代码
    ,recver_open_bank_org_name -- 收款人开户行机构名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_name -- 付款行名称
    ,acpt_guar_bk_bank_no -- 承兑保证行行号
    ,acpt_guar_bk_org_cd -- 承兑保证行机构代码
    ,coll_bank_bank_no -- 托收行行号
    ,discnt_dt -- 贴现日期
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_bank_name -- 贴现行名称
    ,init_belong_rgst_org_cd -- 初始权属登记机构代码
    ,risk_bill_status_cd -- 风险票据状态代码
    ,not_ngbl_cd -- 不得转让代码
    ,exp_uncond_pay_entr_cd -- 到期无条件支付委托代码
    ,payoff_flg -- 结清标志
    ,payoff_dt -- 结清日期
    ,recs_type_cd -- 追索类型代码
    ,bf_discnt_manual_recs_cd -- 贴现前手动追索代码
    ,manual_recs_lock_flg_cd -- 手动追索锁定标志代码
    ,endors_cnt -- 背书次数
    ,bill_obg_mem_cd -- 票据权利人会员代码
    ,bill_obg_name -- 票据权利人名称
    ,bill_obg_soci_crdt_cd -- 票据权利人社会信用代码
    ,bill_obg_acct_type_cd -- 票据权利人账户类型代码
    ,bill_obg_acct_id -- 票据权利人账户编号
    ,bill_obg_open_bank_no -- 票据权利人开户行行号
    ,bill_obg_open_bank_name -- 票据权利人开户行名称
    ,bill_obg_open_bank_org_cd -- 票据权利人开户行机构代码
    ,bill_obg_open_bank_org_name -- 票据权利人开户行机构名称
    ,lock_flg -- 锁定标志
    ,bill_src_tran_cd -- 票据来源交易代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,bill_status_cd -- 票据状态代码
    ,bill_belong_name -- 票据所属人名称
    ,bill_belong_soci_crdt_cd -- 票据所属人社会信用代码
    ,bill_belong_acct_id -- 票据所属人账户编号
    ,bill_belong_open_bank_no -- 票据所属人开户行行号
    ,bill_belong_open_bank_name -- 票据所属人开户行名称
    ,bill_belong_open_bank_org_cd -- 票据所属人开户行机构代码
    ,bill_belong_open_bank_org_name -- 票据所属人开户行机构名称
    ,fir_rgst_id -- 首次登记编号
    ,final_modif_tm -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rgst_id, o.rgst_id) as rgst_id -- 登记编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,nvl(n.bill_sub_intrv_id, o.bill_sub_intrv_id) as bill_sub_intrv_id -- 票据子区间编号
    ,nvl(n.bill_amt, o.bill_amt) as bill_amt -- 票据金额
    ,nvl(n.bill_intrv_std_amt, o.bill_intrv_std_amt) as bill_intrv_std_amt -- 票据区间标准金额
    ,nvl(n.bill_med_cd, o.bill_med_cd) as bill_med_cd -- 票据介质代码
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.bill_src_plat_cd, o.bill_src_plat_cd) as bill_src_plat_cd -- 票据来源平台代码
    ,nvl(n.draw_dt, o.draw_dt) as draw_dt -- 出票日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.allow_split_pkg_ccution_flg, o.allow_split_pkg_ccution_flg) as allow_split_pkg_ccution_flg -- 允许分包流转标志
    ,nvl(n.init_bill_id, o.init_bill_id) as init_bill_id -- 原始票据编号
    ,nvl(n.actl_bf_split_bill_id, o.actl_bf_split_bill_id) as actl_bf_split_bill_id -- 实际拆前票据编号
    ,nvl(n.actl_bf_split_intrv_id, o.actl_bf_split_intrv_id) as actl_bf_split_intrv_id -- 实际拆前区间编号
    ,nvl(n.drawer_mem_cd, o.drawer_mem_cd) as drawer_mem_cd -- 出票人会员代码
    ,nvl(n.drawer_name, o.drawer_name) as drawer_name -- 出票人名称
    ,nvl(n.drawer_soci_crdt_cd, o.drawer_soci_crdt_cd) as drawer_soci_crdt_cd -- 出票人社会信用代码
    ,nvl(n.drawer_acct_type_cd, o.drawer_acct_type_cd) as drawer_acct_type_cd -- 出票人账户类型代码
    ,nvl(n.drawer_acct_id, o.drawer_acct_id) as drawer_acct_id -- 出票人账户编号
    ,nvl(n.drawer_acct_name, o.drawer_acct_name) as drawer_acct_name -- 出票人账户名称
    ,nvl(n.drawer_open_bank_no, o.drawer_open_bank_no) as drawer_open_bank_no -- 出票人开户行行号
    ,nvl(n.drawer_open_bank_name, o.drawer_open_bank_name) as drawer_open_bank_name -- 出票人开户行名称
    ,nvl(n.drawer_open_bank_org_cd, o.drawer_open_bank_org_cd) as drawer_open_bank_org_cd -- 出票人开户行机构代码
    ,nvl(n.drawer_open_bank_org_name, o.drawer_open_bank_org_name) as drawer_open_bank_org_name -- 出票人开户行机构名称
    ,nvl(n.accptor_mem_cd, o.accptor_mem_cd) as accptor_mem_cd -- 承兑人会员代码
    ,nvl(n.accptor_name, o.accptor_name) as accptor_name -- 承兑人名称
    ,nvl(n.accptor_soci_crdt_cd, o.accptor_soci_crdt_cd) as accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,nvl(n.accptor_acct_type_cd, o.accptor_acct_type_cd) as accptor_acct_type_cd -- 承兑人账户类型代码
    ,nvl(n.accptor_acct_id, o.accptor_acct_id) as accptor_acct_id -- 承兑人账户编号
    ,nvl(n.accptor_acct_name, o.accptor_acct_name) as accptor_acct_name -- 承兑人账户名称
    ,nvl(n.accptor_open_bank_no, o.accptor_open_bank_no) as accptor_open_bank_no -- 承兑人开户行行号
    ,nvl(n.accptor_open_bank_name, o.accptor_open_bank_name) as accptor_open_bank_name -- 承兑人开户行名称
    ,nvl(n.accptor_open_bank_org_cd, o.accptor_open_bank_org_cd) as accptor_open_bank_org_cd -- 承兑人开户行机构代码
    ,nvl(n.accptor_open_bank_org_name, o.accptor_open_bank_org_name) as accptor_open_bank_org_name -- 承兑人开户行机构名称
    ,nvl(n.recver_mem_cd, o.recver_mem_cd) as recver_mem_cd -- 收款人会员代码
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 收款人名称
    ,nvl(n.recver_soci_crdt_cd, o.recver_soci_crdt_cd) as recver_soci_crdt_cd -- 收款人社会信用代码
    ,nvl(n.recver_acct_type_cd, o.recver_acct_type_cd) as recver_acct_type_cd -- 收款人账户类型代码
    ,nvl(n.recver_acct_id, o.recver_acct_id) as recver_acct_id -- 收款人账户编号
    ,nvl(n.recver_acct_name, o.recver_acct_name) as recver_acct_name -- 收款人账户名称
    ,nvl(n.recver_open_bank_no, o.recver_open_bank_no) as recver_open_bank_no -- 收款人开户行行号
    ,nvl(n.recver_open_bank_name, o.recver_open_bank_name) as recver_open_bank_name -- 收款人开户行名称
    ,nvl(n.recver_open_bank_org_cd, o.recver_open_bank_org_cd) as recver_open_bank_org_cd -- 收款人开户行机构代码
    ,nvl(n.recver_open_bank_org_name, o.recver_open_bank_org_name) as recver_open_bank_org_name -- 收款人开户行机构名称
    ,nvl(n.pay_bank_bank_no, o.pay_bank_bank_no) as pay_bank_bank_no -- 付款行行号
    ,nvl(n.pay_bank_org_cd, o.pay_bank_org_cd) as pay_bank_org_cd -- 付款行机构代码
    ,nvl(n.pay_bank_name, o.pay_bank_name) as pay_bank_name -- 付款行名称
    ,nvl(n.acpt_guar_bk_bank_no, o.acpt_guar_bk_bank_no) as acpt_guar_bk_bank_no -- 承兑保证行行号
    ,nvl(n.acpt_guar_bk_org_cd, o.acpt_guar_bk_org_cd) as acpt_guar_bk_org_cd -- 承兑保证行机构代码
    ,nvl(n.coll_bank_bank_no, o.coll_bank_bank_no) as coll_bank_bank_no -- 托收行行号
    ,nvl(n.discnt_dt, o.discnt_dt) as discnt_dt -- 贴现日期
    ,nvl(n.discnt_bk_org_cd, o.discnt_bk_org_cd) as discnt_bk_org_cd -- 贴现行机构代码
    ,nvl(n.discnt_bank_name, o.discnt_bank_name) as discnt_bank_name -- 贴现行名称
    ,nvl(n.init_belong_rgst_org_cd, o.init_belong_rgst_org_cd) as init_belong_rgst_org_cd -- 初始权属登记机构代码
    ,nvl(n.risk_bill_status_cd, o.risk_bill_status_cd) as risk_bill_status_cd -- 风险票据状态代码
    ,nvl(n.not_ngbl_cd, o.not_ngbl_cd) as not_ngbl_cd -- 不得转让代码
    ,nvl(n.exp_uncond_pay_entr_cd, o.exp_uncond_pay_entr_cd) as exp_uncond_pay_entr_cd -- 到期无条件支付委托代码
    ,nvl(n.payoff_flg, o.payoff_flg) as payoff_flg -- 结清标志
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(n.recs_type_cd, o.recs_type_cd) as recs_type_cd -- 追索类型代码
    ,nvl(n.bf_discnt_manual_recs_cd, o.bf_discnt_manual_recs_cd) as bf_discnt_manual_recs_cd -- 贴现前手动追索代码
    ,nvl(n.manual_recs_lock_flg_cd, o.manual_recs_lock_flg_cd) as manual_recs_lock_flg_cd -- 手动追索锁定标志代码
    ,nvl(n.endors_cnt, o.endors_cnt) as endors_cnt -- 背书次数
    ,nvl(n.bill_obg_mem_cd, o.bill_obg_mem_cd) as bill_obg_mem_cd -- 票据权利人会员代码
    ,nvl(n.bill_obg_name, o.bill_obg_name) as bill_obg_name -- 票据权利人名称
    ,nvl(n.bill_obg_soci_crdt_cd, o.bill_obg_soci_crdt_cd) as bill_obg_soci_crdt_cd -- 票据权利人社会信用代码
    ,nvl(n.bill_obg_acct_type_cd, o.bill_obg_acct_type_cd) as bill_obg_acct_type_cd -- 票据权利人账户类型代码
    ,nvl(n.bill_obg_acct_id, o.bill_obg_acct_id) as bill_obg_acct_id -- 票据权利人账户编号
    ,nvl(n.bill_obg_open_bank_no, o.bill_obg_open_bank_no) as bill_obg_open_bank_no -- 票据权利人开户行行号
    ,nvl(n.bill_obg_open_bank_name, o.bill_obg_open_bank_name) as bill_obg_open_bank_name -- 票据权利人开户行名称
    ,nvl(n.bill_obg_open_bank_org_cd, o.bill_obg_open_bank_org_cd) as bill_obg_open_bank_org_cd -- 票据权利人开户行机构代码
    ,nvl(n.bill_obg_open_bank_org_name, o.bill_obg_open_bank_org_name) as bill_obg_open_bank_org_name -- 票据权利人开户行机构名称
    ,nvl(n.lock_flg, o.lock_flg) as lock_flg -- 锁定标志
    ,nvl(n.bill_src_tran_cd, o.bill_src_tran_cd) as bill_src_tran_cd -- 票据来源交易代码
    ,nvl(n.bill_ccution_status_cd, o.bill_ccution_status_cd) as bill_ccution_status_cd -- 票据流转状态代码
    ,nvl(n.bill_status_cd, o.bill_status_cd) as bill_status_cd -- 票据状态代码
    ,nvl(n.bill_belong_name, o.bill_belong_name) as bill_belong_name -- 票据所属人名称
    ,nvl(n.bill_belong_soci_crdt_cd, o.bill_belong_soci_crdt_cd) as bill_belong_soci_crdt_cd -- 票据所属人社会信用代码
    ,nvl(n.bill_belong_acct_id, o.bill_belong_acct_id) as bill_belong_acct_id -- 票据所属人账户编号
    ,nvl(n.bill_belong_open_bank_no, o.bill_belong_open_bank_no) as bill_belong_open_bank_no -- 票据所属人开户行行号
    ,nvl(n.bill_belong_open_bank_name, o.bill_belong_open_bank_name) as bill_belong_open_bank_name -- 票据所属人开户行名称
    ,nvl(n.bill_belong_open_bank_org_cd, o.bill_belong_open_bank_org_cd) as bill_belong_open_bank_org_cd -- 票据所属人开户行机构代码
    ,nvl(n.bill_belong_open_bank_org_name, o.bill_belong_open_bank_org_name) as bill_belong_open_bank_org_name -- 票据所属人开户行机构名称
    ,nvl(n.fir_rgst_id, o.fir_rgst_id) as fir_rgst_id -- 首次登记编号
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,case when
            n.rgst_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rgst_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rgst_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_tm n
    full join (select * from ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.rgst_id = n.rgst_id
            and o.lp_id = n.lp_id
where (
        o.rgst_id is null
        and o.lp_id is null
    )
    or (
        n.rgst_id is null
        and n.lp_id is null
    )
    or (
        o.bill_num <> n.bill_num
        or o.bill_sub_intrv_id <> n.bill_sub_intrv_id
        or o.bill_amt <> n.bill_amt
        or o.bill_intrv_std_amt <> n.bill_intrv_std_amt
        or o.bill_med_cd <> n.bill_med_cd
        or o.bill_type_cd <> n.bill_type_cd
        or o.bill_src_plat_cd <> n.bill_src_plat_cd
        or o.draw_dt <> n.draw_dt
        or o.exp_dt <> n.exp_dt
        or o.allow_split_pkg_ccution_flg <> n.allow_split_pkg_ccution_flg
        or o.init_bill_id <> n.init_bill_id
        or o.actl_bf_split_bill_id <> n.actl_bf_split_bill_id
        or o.actl_bf_split_intrv_id <> n.actl_bf_split_intrv_id
        or o.drawer_mem_cd <> n.drawer_mem_cd
        or o.drawer_name <> n.drawer_name
        or o.drawer_soci_crdt_cd <> n.drawer_soci_crdt_cd
        or o.drawer_acct_type_cd <> n.drawer_acct_type_cd
        or o.drawer_acct_id <> n.drawer_acct_id
        or o.drawer_acct_name <> n.drawer_acct_name
        or o.drawer_open_bank_no <> n.drawer_open_bank_no
        or o.drawer_open_bank_name <> n.drawer_open_bank_name
        or o.drawer_open_bank_org_cd <> n.drawer_open_bank_org_cd
        or o.drawer_open_bank_org_name <> n.drawer_open_bank_org_name
        or o.accptor_mem_cd <> n.accptor_mem_cd
        or o.accptor_name <> n.accptor_name
        or o.accptor_soci_crdt_cd <> n.accptor_soci_crdt_cd
        or o.accptor_acct_type_cd <> n.accptor_acct_type_cd
        or o.accptor_acct_id <> n.accptor_acct_id
        or o.accptor_acct_name <> n.accptor_acct_name
        or o.accptor_open_bank_no <> n.accptor_open_bank_no
        or o.accptor_open_bank_name <> n.accptor_open_bank_name
        or o.accptor_open_bank_org_cd <> n.accptor_open_bank_org_cd
        or o.accptor_open_bank_org_name <> n.accptor_open_bank_org_name
        or o.recver_mem_cd <> n.recver_mem_cd
        or o.recver_name <> n.recver_name
        or o.recver_soci_crdt_cd <> n.recver_soci_crdt_cd
        or o.recver_acct_type_cd <> n.recver_acct_type_cd
        or o.recver_acct_id <> n.recver_acct_id
        or o.recver_acct_name <> n.recver_acct_name
        or o.recver_open_bank_no <> n.recver_open_bank_no
        or o.recver_open_bank_name <> n.recver_open_bank_name
        or o.recver_open_bank_org_cd <> n.recver_open_bank_org_cd
        or o.recver_open_bank_org_name <> n.recver_open_bank_org_name
        or o.pay_bank_bank_no <> n.pay_bank_bank_no
        or o.pay_bank_org_cd <> n.pay_bank_org_cd
        or o.pay_bank_name <> n.pay_bank_name
        or o.acpt_guar_bk_bank_no <> n.acpt_guar_bk_bank_no
        or o.acpt_guar_bk_org_cd <> n.acpt_guar_bk_org_cd
        or o.coll_bank_bank_no <> n.coll_bank_bank_no
        or o.discnt_dt <> n.discnt_dt
        or o.discnt_bk_org_cd <> n.discnt_bk_org_cd
        or o.discnt_bank_name <> n.discnt_bank_name
        or o.init_belong_rgst_org_cd <> n.init_belong_rgst_org_cd
        or o.risk_bill_status_cd <> n.risk_bill_status_cd
        or o.not_ngbl_cd <> n.not_ngbl_cd
        or o.exp_uncond_pay_entr_cd <> n.exp_uncond_pay_entr_cd
        or o.payoff_flg <> n.payoff_flg
        or o.payoff_dt <> n.payoff_dt
        or o.recs_type_cd <> n.recs_type_cd
        or o.bf_discnt_manual_recs_cd <> n.bf_discnt_manual_recs_cd
        or o.manual_recs_lock_flg_cd <> n.manual_recs_lock_flg_cd
        or o.endors_cnt <> n.endors_cnt
        or o.bill_obg_mem_cd <> n.bill_obg_mem_cd
        or o.bill_obg_name <> n.bill_obg_name
        or o.bill_obg_soci_crdt_cd <> n.bill_obg_soci_crdt_cd
        or o.bill_obg_acct_type_cd <> n.bill_obg_acct_type_cd
        or o.bill_obg_acct_id <> n.bill_obg_acct_id
        or o.bill_obg_open_bank_no <> n.bill_obg_open_bank_no
        or o.bill_obg_open_bank_name <> n.bill_obg_open_bank_name
        or o.bill_obg_open_bank_org_cd <> n.bill_obg_open_bank_org_cd
        or o.bill_obg_open_bank_org_name <> n.bill_obg_open_bank_org_name
        or o.lock_flg <> n.lock_flg
        or o.bill_src_tran_cd <> n.bill_src_tran_cd
        or o.bill_ccution_status_cd <> n.bill_ccution_status_cd
        or o.bill_status_cd <> n.bill_status_cd
        or o.bill_belong_name <> n.bill_belong_name
        or o.bill_belong_soci_crdt_cd <> n.bill_belong_soci_crdt_cd
        or o.bill_belong_acct_id <> n.bill_belong_acct_id
        or o.bill_belong_open_bank_no <> n.bill_belong_open_bank_no
        or o.bill_belong_open_bank_name <> n.bill_belong_open_bank_name
        or o.bill_belong_open_bank_org_cd <> n.bill_belong_open_bank_org_cd
        or o.bill_belong_open_bank_org_name <> n.bill_belong_open_bank_org_name
        or o.fir_rgst_id <> n.fir_rgst_id
        or o.final_modif_tm <> n.final_modif_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_cl(
            rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,bill_num -- 票据号码
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_amt -- 票据金额
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bill_src_plat_cd -- 票据来源平台代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,allow_split_pkg_ccution_flg -- 允许分包流转标志
    ,init_bill_id -- 原始票据编号
    ,actl_bf_split_bill_id -- 实际拆前票据编号
    ,actl_bf_split_intrv_id -- 实际拆前区间编号
    ,drawer_mem_cd -- 出票人会员代码
    ,drawer_name -- 出票人名称
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,drawer_acct_type_cd -- 出票人账户类型代码
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_acct_name -- 出票人账户名称
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,drawer_open_bank_org_cd -- 出票人开户行机构代码
    ,drawer_open_bank_org_name -- 出票人开户行机构名称
    ,accptor_mem_cd -- 承兑人会员代码
    ,accptor_name -- 承兑人名称
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,accptor_acct_type_cd -- 承兑人账户类型代码
    ,accptor_acct_id -- 承兑人账户编号
    ,accptor_acct_name -- 承兑人账户名称
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,accptor_open_bank_org_cd -- 承兑人开户行机构代码
    ,accptor_open_bank_org_name -- 承兑人开户行机构名称
    ,recver_mem_cd -- 收款人会员代码
    ,recver_name -- 收款人名称
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,recver_acct_type_cd -- 收款人账户类型代码
    ,recver_acct_id -- 收款人账户编号
    ,recver_acct_name -- 收款人账户名称
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_open_bank_org_cd -- 收款人开户行机构代码
    ,recver_open_bank_org_name -- 收款人开户行机构名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_name -- 付款行名称
    ,acpt_guar_bk_bank_no -- 承兑保证行行号
    ,acpt_guar_bk_org_cd -- 承兑保证行机构代码
    ,coll_bank_bank_no -- 托收行行号
    ,discnt_dt -- 贴现日期
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_bank_name -- 贴现行名称
    ,init_belong_rgst_org_cd -- 初始权属登记机构代码
    ,risk_bill_status_cd -- 风险票据状态代码
    ,not_ngbl_cd -- 不得转让代码
    ,exp_uncond_pay_entr_cd -- 到期无条件支付委托代码
    ,payoff_flg -- 结清标志
    ,payoff_dt -- 结清日期
    ,recs_type_cd -- 追索类型代码
    ,bf_discnt_manual_recs_cd -- 贴现前手动追索代码
    ,manual_recs_lock_flg_cd -- 手动追索锁定标志代码
    ,endors_cnt -- 背书次数
    ,bill_obg_mem_cd -- 票据权利人会员代码
    ,bill_obg_name -- 票据权利人名称
    ,bill_obg_soci_crdt_cd -- 票据权利人社会信用代码
    ,bill_obg_acct_type_cd -- 票据权利人账户类型代码
    ,bill_obg_acct_id -- 票据权利人账户编号
    ,bill_obg_open_bank_no -- 票据权利人开户行行号
    ,bill_obg_open_bank_name -- 票据权利人开户行名称
    ,bill_obg_open_bank_org_cd -- 票据权利人开户行机构代码
    ,bill_obg_open_bank_org_name -- 票据权利人开户行机构名称
    ,lock_flg -- 锁定标志
    ,bill_src_tran_cd -- 票据来源交易代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,bill_status_cd -- 票据状态代码
    ,bill_belong_name -- 票据所属人名称
    ,bill_belong_soci_crdt_cd -- 票据所属人社会信用代码
    ,bill_belong_acct_id -- 票据所属人账户编号
    ,bill_belong_open_bank_no -- 票据所属人开户行行号
    ,bill_belong_open_bank_name -- 票据所属人开户行名称
    ,bill_belong_open_bank_org_cd -- 票据所属人开户行机构代码
    ,bill_belong_open_bank_org_name -- 票据所属人开户行机构名称
    ,fir_rgst_id -- 首次登记编号
    ,final_modif_tm -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_op(
            rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,bill_num -- 票据号码
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_amt -- 票据金额
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bill_src_plat_cd -- 票据来源平台代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,allow_split_pkg_ccution_flg -- 允许分包流转标志
    ,init_bill_id -- 原始票据编号
    ,actl_bf_split_bill_id -- 实际拆前票据编号
    ,actl_bf_split_intrv_id -- 实际拆前区间编号
    ,drawer_mem_cd -- 出票人会员代码
    ,drawer_name -- 出票人名称
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,drawer_acct_type_cd -- 出票人账户类型代码
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_acct_name -- 出票人账户名称
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,drawer_open_bank_org_cd -- 出票人开户行机构代码
    ,drawer_open_bank_org_name -- 出票人开户行机构名称
    ,accptor_mem_cd -- 承兑人会员代码
    ,accptor_name -- 承兑人名称
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,accptor_acct_type_cd -- 承兑人账户类型代码
    ,accptor_acct_id -- 承兑人账户编号
    ,accptor_acct_name -- 承兑人账户名称
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,accptor_open_bank_org_cd -- 承兑人开户行机构代码
    ,accptor_open_bank_org_name -- 承兑人开户行机构名称
    ,recver_mem_cd -- 收款人会员代码
    ,recver_name -- 收款人名称
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,recver_acct_type_cd -- 收款人账户类型代码
    ,recver_acct_id -- 收款人账户编号
    ,recver_acct_name -- 收款人账户名称
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_open_bank_org_cd -- 收款人开户行机构代码
    ,recver_open_bank_org_name -- 收款人开户行机构名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_name -- 付款行名称
    ,acpt_guar_bk_bank_no -- 承兑保证行行号
    ,acpt_guar_bk_org_cd -- 承兑保证行机构代码
    ,coll_bank_bank_no -- 托收行行号
    ,discnt_dt -- 贴现日期
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_bank_name -- 贴现行名称
    ,init_belong_rgst_org_cd -- 初始权属登记机构代码
    ,risk_bill_status_cd -- 风险票据状态代码
    ,not_ngbl_cd -- 不得转让代码
    ,exp_uncond_pay_entr_cd -- 到期无条件支付委托代码
    ,payoff_flg -- 结清标志
    ,payoff_dt -- 结清日期
    ,recs_type_cd -- 追索类型代码
    ,bf_discnt_manual_recs_cd -- 贴现前手动追索代码
    ,manual_recs_lock_flg_cd -- 手动追索锁定标志代码
    ,endors_cnt -- 背书次数
    ,bill_obg_mem_cd -- 票据权利人会员代码
    ,bill_obg_name -- 票据权利人名称
    ,bill_obg_soci_crdt_cd -- 票据权利人社会信用代码
    ,bill_obg_acct_type_cd -- 票据权利人账户类型代码
    ,bill_obg_acct_id -- 票据权利人账户编号
    ,bill_obg_open_bank_no -- 票据权利人开户行行号
    ,bill_obg_open_bank_name -- 票据权利人开户行名称
    ,bill_obg_open_bank_org_cd -- 票据权利人开户行机构代码
    ,bill_obg_open_bank_org_name -- 票据权利人开户行机构名称
    ,lock_flg -- 锁定标志
    ,bill_src_tran_cd -- 票据来源交易代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,bill_status_cd -- 票据状态代码
    ,bill_belong_name -- 票据所属人名称
    ,bill_belong_soci_crdt_cd -- 票据所属人社会信用代码
    ,bill_belong_acct_id -- 票据所属人账户编号
    ,bill_belong_open_bank_no -- 票据所属人开户行行号
    ,bill_belong_open_bank_name -- 票据所属人开户行名称
    ,bill_belong_open_bank_org_cd -- 票据所属人开户行机构代码
    ,bill_belong_open_bank_org_name -- 票据所属人开户行机构名称
    ,fir_rgst_id -- 首次登记编号
    ,final_modif_tm -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rgst_id -- 登记编号
    ,o.lp_id -- 法人编号
    ,o.bill_num -- 票据号码
    ,o.bill_sub_intrv_id -- 票据子区间编号
    ,o.bill_amt -- 票据金额
    ,o.bill_intrv_std_amt -- 票据区间标准金额
    ,o.bill_med_cd -- 票据介质代码
    ,o.bill_type_cd -- 票据类型代码
    ,o.bill_src_plat_cd -- 票据来源平台代码
    ,o.draw_dt -- 出票日期
    ,o.exp_dt -- 到期日期
    ,o.allow_split_pkg_ccution_flg -- 允许分包流转标志
    ,o.init_bill_id -- 原始票据编号
    ,o.actl_bf_split_bill_id -- 实际拆前票据编号
    ,o.actl_bf_split_intrv_id -- 实际拆前区间编号
    ,o.drawer_mem_cd -- 出票人会员代码
    ,o.drawer_name -- 出票人名称
    ,o.drawer_soci_crdt_cd -- 出票人社会信用代码
    ,o.drawer_acct_type_cd -- 出票人账户类型代码
    ,o.drawer_acct_id -- 出票人账户编号
    ,o.drawer_acct_name -- 出票人账户名称
    ,o.drawer_open_bank_no -- 出票人开户行行号
    ,o.drawer_open_bank_name -- 出票人开户行名称
    ,o.drawer_open_bank_org_cd -- 出票人开户行机构代码
    ,o.drawer_open_bank_org_name -- 出票人开户行机构名称
    ,o.accptor_mem_cd -- 承兑人会员代码
    ,o.accptor_name -- 承兑人名称
    ,o.accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,o.accptor_acct_type_cd -- 承兑人账户类型代码
    ,o.accptor_acct_id -- 承兑人账户编号
    ,o.accptor_acct_name -- 承兑人账户名称
    ,o.accptor_open_bank_no -- 承兑人开户行行号
    ,o.accptor_open_bank_name -- 承兑人开户行名称
    ,o.accptor_open_bank_org_cd -- 承兑人开户行机构代码
    ,o.accptor_open_bank_org_name -- 承兑人开户行机构名称
    ,o.recver_mem_cd -- 收款人会员代码
    ,o.recver_name -- 收款人名称
    ,o.recver_soci_crdt_cd -- 收款人社会信用代码
    ,o.recver_acct_type_cd -- 收款人账户类型代码
    ,o.recver_acct_id -- 收款人账户编号
    ,o.recver_acct_name -- 收款人账户名称
    ,o.recver_open_bank_no -- 收款人开户行行号
    ,o.recver_open_bank_name -- 收款人开户行名称
    ,o.recver_open_bank_org_cd -- 收款人开户行机构代码
    ,o.recver_open_bank_org_name -- 收款人开户行机构名称
    ,o.pay_bank_bank_no -- 付款行行号
    ,o.pay_bank_org_cd -- 付款行机构代码
    ,o.pay_bank_name -- 付款行名称
    ,o.acpt_guar_bk_bank_no -- 承兑保证行行号
    ,o.acpt_guar_bk_org_cd -- 承兑保证行机构代码
    ,o.coll_bank_bank_no -- 托收行行号
    ,o.discnt_dt -- 贴现日期
    ,o.discnt_bk_org_cd -- 贴现行机构代码
    ,o.discnt_bank_name -- 贴现行名称
    ,o.init_belong_rgst_org_cd -- 初始权属登记机构代码
    ,o.risk_bill_status_cd -- 风险票据状态代码
    ,o.not_ngbl_cd -- 不得转让代码
    ,o.exp_uncond_pay_entr_cd -- 到期无条件支付委托代码
    ,o.payoff_flg -- 结清标志
    ,o.payoff_dt -- 结清日期
    ,o.recs_type_cd -- 追索类型代码
    ,o.bf_discnt_manual_recs_cd -- 贴现前手动追索代码
    ,o.manual_recs_lock_flg_cd -- 手动追索锁定标志代码
    ,o.endors_cnt -- 背书次数
    ,o.bill_obg_mem_cd -- 票据权利人会员代码
    ,o.bill_obg_name -- 票据权利人名称
    ,o.bill_obg_soci_crdt_cd -- 票据权利人社会信用代码
    ,o.bill_obg_acct_type_cd -- 票据权利人账户类型代码
    ,o.bill_obg_acct_id -- 票据权利人账户编号
    ,o.bill_obg_open_bank_no -- 票据权利人开户行行号
    ,o.bill_obg_open_bank_name -- 票据权利人开户行名称
    ,o.bill_obg_open_bank_org_cd -- 票据权利人开户行机构代码
    ,o.bill_obg_open_bank_org_name -- 票据权利人开户行机构名称
    ,o.lock_flg -- 锁定标志
    ,o.bill_src_tran_cd -- 票据来源交易代码
    ,o.bill_ccution_status_cd -- 票据流转状态代码
    ,o.bill_status_cd -- 票据状态代码
    ,o.bill_belong_name -- 票据所属人名称
    ,o.bill_belong_soci_crdt_cd -- 票据所属人社会信用代码
    ,o.bill_belong_acct_id -- 票据所属人账户编号
    ,o.bill_belong_open_bank_no -- 票据所属人开户行行号
    ,o.bill_belong_open_bank_name -- 票据所属人开户行名称
    ,o.bill_belong_open_bank_org_cd -- 票据所属人开户行机构代码
    ,o.bill_belong_open_bank_org_name -- 票据所属人开户行机构名称
    ,o.fir_rgst_id -- 首次登记编号
    ,o.final_modif_tm -- 最后修改时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_bk o
    left join ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_op n
        on
            o.rgst_id = n.rgst_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_cl d
        on
            o.rgst_id = d.rgst_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_corp_rgst_bill_info_para;
--alter table ${iml_schema}.ref_corp_rgst_bill_info_para truncate partition for ('bdmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ref_corp_rgst_bill_info_para') 
               and substr(subpartition_name,1,8)=upper('p_bdmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ref_corp_rgst_bill_info_para drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ref_corp_rgst_bill_info_para modify partition p_bdmsf1 
add subpartition p_bdmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ref_corp_rgst_bill_info_para exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_cl;
alter table ${iml_schema}.ref_corp_rgst_bill_info_para exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_corp_rgst_bill_info_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_tm purge;
drop table ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_op purge;
drop table ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_corp_rgst_bill_info_para_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_corp_rgst_bill_info_para', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
