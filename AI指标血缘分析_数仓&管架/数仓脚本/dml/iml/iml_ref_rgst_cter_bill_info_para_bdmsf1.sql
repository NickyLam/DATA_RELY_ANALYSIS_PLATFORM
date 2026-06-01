/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_rgst_cter_bill_info_para_bdmsf1
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
alter table ${iml_schema}.ref_rgst_cter_bill_info_para add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_rgst_cter_bill_info_para partition for ('bdmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_tm purge;
drop table ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_op purge;
drop table ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,init_bill_sys_bill_id -- 原票据系统票据编号
    ,bill_num -- 票据号码
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,bill_amt -- 贴现票据金额
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,accptor_name -- 承兑人名称
    ,accptor_acct_num -- 承兑人账号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,recver_name -- 收款人名称
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_acct_num -- 收款人账号
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,pay_bank_no -- 付款行行号
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_name -- 付款行名称
    ,pay_cfm_org_cd -- 付款确认机构代码
    ,acpt_guar_bank_no -- 承兑保证行行号
    ,coll_bank_no -- 托收行行号
    ,holder_name -- 持票人名称
    ,holder_soci_crdt_cd -- 持票人社会信用代码
    ,holder_acct_num -- 持票人账号
    ,holder_org_cd -- 持票人机构代码
    ,holder_org_name -- 持票人机构名称
    ,risk_bill_status_cd -- 风险票据状态代码
    ,bill_invtry_status_cd -- 票据库存状态代码
    ,bill_src_cd -- 票据来源代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,bill_status_cd -- 票据状态代码
    ,comb_status_cd -- 组合状态代码
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_bank_name -- 贴现行名称
    ,invtry_org_cd -- 库存机构代码
    ,init_belong_rgst_org_cd -- 初始权属登记机构代码
    ,bill_belong_org_id -- 票据所属机构编号
    ,hq_org_id -- 总行机构编号
    ,hxb_acpt_flg -- 我行承兑标志
    ,pay_cfm_flg -- 付款确认标志
    ,lock_flg -- 锁定标志
    ,payoff_flg -- 结清标志
    ,recs_flg -- 追偿标志
    ,discnt_dt -- 贴现日期
    ,tran_cd -- 转让代码
    ,receipt_flg -- 小票标志
    ,bill_sub_intrv_id -- 票据子区间号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,init_bill_id -- 原始票据编号
    ,select_id -- 挑票编号
    ,actl_bf_split_bill_id -- 实际拆前票据编号
    ,actl_bf_split_intrv_id -- 实际拆前区间编号
    ,remark_1 -- 备注1
    ,payoff_dt -- 结清日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_rgst_cter_bill_info_para partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_rgst_cter_bill_info_para partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_rgst_cter_bill_info_para partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_dpc_draft_info-
insert into ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_tm(
    rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,init_bill_sys_bill_id -- 原票据系统票据编号
    ,bill_num -- 票据号码
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,bill_amt -- 贴现票据金额
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,accptor_name -- 承兑人名称
    ,accptor_acct_num -- 承兑人账号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,recver_name -- 收款人名称
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_acct_num -- 收款人账号
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,pay_bank_no -- 付款行行号
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_name -- 付款行名称
    ,pay_cfm_org_cd -- 付款确认机构代码
    ,acpt_guar_bank_no -- 承兑保证行行号
    ,coll_bank_no -- 托收行行号
    ,holder_name -- 持票人名称
    ,holder_soci_crdt_cd -- 持票人社会信用代码
    ,holder_acct_num -- 持票人账号
    ,holder_org_cd -- 持票人机构代码
    ,holder_org_name -- 持票人机构名称
    ,risk_bill_status_cd -- 风险票据状态代码
    ,bill_invtry_status_cd -- 票据库存状态代码
    ,bill_src_cd -- 票据来源代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,bill_status_cd -- 票据状态代码
    ,comb_status_cd -- 组合状态代码
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_bank_name -- 贴现行名称
    ,invtry_org_cd -- 库存机构代码
    ,init_belong_rgst_org_cd -- 初始权属登记机构代码
    ,bill_belong_org_id -- 票据所属机构编号
    ,hq_org_id -- 总行机构编号
    ,hxb_acpt_flg -- 我行承兑标志
    ,pay_cfm_flg -- 付款确认标志
    ,lock_flg -- 锁定标志
    ,payoff_flg -- 结清标志
    ,recs_flg -- 追偿标志
    ,discnt_dt -- 贴现日期
    ,tran_cd -- 转让代码
    ,receipt_flg -- 小票标志
    ,bill_sub_intrv_id -- 票据子区间号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,init_bill_id -- 原始票据编号
    ,select_id -- 挑票编号
    ,actl_bf_split_bill_id -- 实际拆前票据编号
    ,actl_bf_split_intrv_id -- 实际拆前区间编号
    ,remark_1 -- 备注1
    ,payoff_dt -- 结清日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 登记编号
    ,'9999' -- 法人编号
    ,P1.BMS_DRAFT_ID -- 原票据系统票据编号
    ,P1.DRAFT_NUMBER -- 票据号码
    ,case when R1.TARGET_CD_VAL is not null then R1.TARGET_CD_VAL else '@'||P1.DRAFT_ATTR end -- 票据介质代码
    ,case when R2.TARGET_CD_VAL is not null then R2.TARGET_CD_VAL else '@'||P1.DRAFT_TYPE end -- 票据类型代码
    ,${iml_schema}.dateformat_min(P1.REMIT_DATE) -- 出票日期
    ,${iml_schema}.dateformat_max2(P1.MATURITY_DATE) -- 到期日期
    ,P1.DRAFT_AMOUNT -- 贴现票据金额
    ,P1.REMITTER_NAME -- 出票人名称
    ,P1.REMITTER_ACCOUNT -- 出票人账号
    ,P1.REMITTER_BANK_NO -- 出票人开户行行号
    ,P1.REMITTER_BANK_NAME -- 出票人开户行名称
    ,P1.REMITTER_CRT_NO -- 出票人社会信用代码
    ,P1.ACCEPTOR_NAME -- 承兑人名称
    ,P1.ACCEPTOR_ACCOUNT -- 承兑人账号
    ,P1.ACCEPTOR_BANK_NO -- 承兑人开户行行号
    ,P1.ACCEPTOR_BANK_NAME -- 承兑人开户行名称
    ,P1.ACCEPTOR_CRT_NO -- 承兑人社会信用代码
    ,P1.PAYEE_NAME -- 收款人名称
    ,P1.PAYEE_BANK_NAME -- 收款人开户行名称
    ,P1.PAYEE_ACCOUNT -- 收款人账号
    ,P1.PAYEE_BANK_NO -- 收款人开户行行号
    ,P1.PAYEE_CRT_NO -- 收款人社会信用代码
    ,P1.DRAWEE_BANK_NO -- 付款行行号
    ,P1.DRAWEE_BRH_NO -- 付款行机构代码
    ,P1.DRAWEE_BANK_NAME -- 付款行名称
    ,P1.DRAWEE_CONFIRM_BRH_NO -- 付款确认机构代码
    ,P1.GUA_ACCEPT_BANK_NO -- 承兑保证行行号
    ,P1.COLLECTION_BANK_NO -- 托收行行号
    ,P1.HOLDER_NAME -- 持票人名称
    ,P1.HOLDER_CRT_NO -- 持票人社会信用代码
    ,P1.HOLDER_ACCT_NO -- 持票人账号
    ,P1.HOLDER_BRH_NO -- 持票人机构代码
    ,P1.HOLDER_BRH_NAME -- 持票人机构名称
    ,nvl(trim(P1.RISK_STATUS),'-') -- 风险票据状态代码
    ,case when R4.TARGET_CD_VAL is not null then R4.TARGET_CD_VAL else '@'||P1.STORE_STATUS end -- 票据库存状态代码
    ,nvl(trim(P1.SRC_TYPE),'-') -- 票据来源代码
    ,nvl(trim(P1.FLOW_STATUS),'-') -- 票据流转状态代码
    ,nvl(trim(P1.STATUS),'-') -- 票据状态代码
    ,nvl(trim(P1.COM_STATUS),'-') -- 组合状态代码
    ,P1.DISCOUNT_BRH_NO -- 贴现行机构代码
    ,P1.DISCOUNT_BRH_NAME -- 贴现行名称
    ,P1.STORE_BRH_NO -- 库存机构代码
    ,P1.INIT_BRH_NO -- 初始权属登记机构代码
    ,P1.BELONG_BRANCH_NO -- 票据所属机构编号
    ,P1.TOP_BRANCH_NO -- 总行机构编号
    ,case when (P1.DRAFT_TYPE='1' and P2.BANK_NO is not null) then '1' else '0' end -- 我行承兑标志
    ,nvl(trim(P1.PAY_CONFIRM_FLAG),'-') -- 付款确认标志
    ,nvl(trim(P1.LOCK_FLAG),'-') -- 锁定标志
    ,nvl(trim(P1.SETTLE_FLAG),'-') -- 结清标志
    ,nvl(trim(P1.RECOVERY_FLAG),'-'） -- 追偿标志
    ,${iml_schema}.dateformat_min(P1.DISC_DATE) -- 贴现日期
    ,case when R3.TARGET_CD_VAL is not null then R3.TARGET_CD_VAL else '@'||P1.TRANSFER_FLAG end -- 转让代码
    ,nvl(trim(P1.IS_RECEIPT),'-'） -- 小票标志
    ,P1.CD_RANGE -- 票据子区间号
    ,P1.STANDARD_AMT -- 票据区间标准金额
    ,P1.ORG_DRAFT_ID -- 原始票据编号
    ,P1.SELECT_DRAFT_ID -- 挑票编号
    ,P1.SPLIT_DRAFT_ID -- 实际拆前票据编号
    ,P1.SPLIT_RANGE -- 实际拆前区间编号
    ,P1.RESERVE6 -- 备注1
    ,${iml_schema}.dateformat_max2(P1.SETTLE_DATE) -- 结清日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_dpc_draft_info' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.bdms_dpc_draft_info p1
  left join ((select distinct bank_no, start_dt, end_dt
                from ${iol_schema}.bdms_htes_ptcpt_info
               where belong_legal_no = '313586000006')) p2
    on p1.acceptor_bank_no = p2.bank_no
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.ref_pub_cd_map r1
    on p1.draft_attr = r1.src_code_val
   and r1.sorc_sys_cd = 'BDMS'
   and r1.src_tab_en_name = 'BDMS_DPC_DRAFT_INFO'
   and r1.src_field_en_name = 'DRAFT_ATTR'
   and r1.target_tab_en_name = 'REF_RGST_CTER_BILL_INFO_PARA'
   and r1.target_tab_field_en_name = 'BILL_MED_CD'
  left join ${iml_schema}.ref_pub_cd_map r2
    on p1.draft_type = r2.src_code_val
   and r2.sorc_sys_cd = 'BDMS'
   and r2.src_tab_en_name = 'BDMS_DPC_DRAFT_INFO'
   and r2.src_field_en_name = 'DRAFT_TYPE'
   and r2.target_tab_en_name = 'REF_RGST_CTER_BILL_INFO_PARA'
   and r2.target_tab_field_en_name = 'BILL_TYPE_CD'
  left join ${iml_schema}.ref_pub_cd_map r4
    on p1.store_status = r4.src_code_val
   and r4.sorc_sys_cd = 'BDMS'
   and r4.src_tab_en_name = 'BDMS_DPC_DRAFT_INFO'
   and r4.src_field_en_name = 'STORE_STATUS'
   and r4.target_tab_en_name = 'REF_RGST_CTER_BILL_INFO_PARA'
   and r4.target_tab_field_en_name = 'BILL_INVTRY_STATUS_CD'
  left join ${iml_schema}.ref_pub_cd_map r3
    on p1.draft_transfer_flag = r3.src_code_val
   and r3.sorc_sys_cd = 'BDMS'
   and r3.src_tab_en_name = 'BDMS_DPC_DRAFT_INFO'
   and r3.src_field_en_name = 'TRANSFER_FLAG'
   and r3.target_tab_en_name = 'REF_RGST_CTER_BILL_INFO_PARA'
   and r3.target_tab_field_en_name = 'TRAN_CD'
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
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_tm 
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
        into ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_cl(
            rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,init_bill_sys_bill_id -- 原票据系统票据编号
    ,bill_num -- 票据号码
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,bill_amt -- 贴现票据金额
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,accptor_name -- 承兑人名称
    ,accptor_acct_num -- 承兑人账号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,recver_name -- 收款人名称
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_acct_num -- 收款人账号
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,pay_bank_no -- 付款行行号
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_name -- 付款行名称
    ,pay_cfm_org_cd -- 付款确认机构代码
    ,acpt_guar_bank_no -- 承兑保证行行号
    ,coll_bank_no -- 托收行行号
    ,holder_name -- 持票人名称
    ,holder_soci_crdt_cd -- 持票人社会信用代码
    ,holder_acct_num -- 持票人账号
    ,holder_org_cd -- 持票人机构代码
    ,holder_org_name -- 持票人机构名称
    ,risk_bill_status_cd -- 风险票据状态代码
    ,bill_invtry_status_cd -- 票据库存状态代码
    ,bill_src_cd -- 票据来源代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,bill_status_cd -- 票据状态代码
    ,comb_status_cd -- 组合状态代码
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_bank_name -- 贴现行名称
    ,invtry_org_cd -- 库存机构代码
    ,init_belong_rgst_org_cd -- 初始权属登记机构代码
    ,bill_belong_org_id -- 票据所属机构编号
    ,hq_org_id -- 总行机构编号
    ,hxb_acpt_flg -- 我行承兑标志
    ,pay_cfm_flg -- 付款确认标志
    ,lock_flg -- 锁定标志
    ,payoff_flg -- 结清标志
    ,recs_flg -- 追偿标志
    ,discnt_dt -- 贴现日期
    ,tran_cd -- 转让代码
    ,receipt_flg -- 小票标志
    ,bill_sub_intrv_id -- 票据子区间号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,init_bill_id -- 原始票据编号
    ,select_id -- 挑票编号
    ,actl_bf_split_bill_id -- 实际拆前票据编号
    ,actl_bf_split_intrv_id -- 实际拆前区间编号
    ,remark_1 -- 备注1
    ,payoff_dt -- 结清日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_op(
            rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,init_bill_sys_bill_id -- 原票据系统票据编号
    ,bill_num -- 票据号码
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,bill_amt -- 贴现票据金额
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,accptor_name -- 承兑人名称
    ,accptor_acct_num -- 承兑人账号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,recver_name -- 收款人名称
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_acct_num -- 收款人账号
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,pay_bank_no -- 付款行行号
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_name -- 付款行名称
    ,pay_cfm_org_cd -- 付款确认机构代码
    ,acpt_guar_bank_no -- 承兑保证行行号
    ,coll_bank_no -- 托收行行号
    ,holder_name -- 持票人名称
    ,holder_soci_crdt_cd -- 持票人社会信用代码
    ,holder_acct_num -- 持票人账号
    ,holder_org_cd -- 持票人机构代码
    ,holder_org_name -- 持票人机构名称
    ,risk_bill_status_cd -- 风险票据状态代码
    ,bill_invtry_status_cd -- 票据库存状态代码
    ,bill_src_cd -- 票据来源代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,bill_status_cd -- 票据状态代码
    ,comb_status_cd -- 组合状态代码
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_bank_name -- 贴现行名称
    ,invtry_org_cd -- 库存机构代码
    ,init_belong_rgst_org_cd -- 初始权属登记机构代码
    ,bill_belong_org_id -- 票据所属机构编号
    ,hq_org_id -- 总行机构编号
    ,hxb_acpt_flg -- 我行承兑标志
    ,pay_cfm_flg -- 付款确认标志
    ,lock_flg -- 锁定标志
    ,payoff_flg -- 结清标志
    ,recs_flg -- 追偿标志
    ,discnt_dt -- 贴现日期
    ,tran_cd -- 转让代码
    ,receipt_flg -- 小票标志
    ,bill_sub_intrv_id -- 票据子区间号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,init_bill_id -- 原始票据编号
    ,select_id -- 挑票编号
    ,actl_bf_split_bill_id -- 实际拆前票据编号
    ,actl_bf_split_intrv_id -- 实际拆前区间编号
    ,remark_1 -- 备注1
    ,payoff_dt -- 结清日期
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
    ,nvl(n.init_bill_sys_bill_id, o.init_bill_sys_bill_id) as init_bill_sys_bill_id -- 原票据系统票据编号
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,nvl(n.bill_med_cd, o.bill_med_cd) as bill_med_cd -- 票据介质代码
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.draw_dt, o.draw_dt) as draw_dt -- 出票日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.bill_amt, o.bill_amt) as bill_amt -- 贴现票据金额
    ,nvl(n.drawer_name, o.drawer_name) as drawer_name -- 出票人名称
    ,nvl(n.drawer_acct_num, o.drawer_acct_num) as drawer_acct_num -- 出票人账号
    ,nvl(n.drawer_open_bank_no, o.drawer_open_bank_no) as drawer_open_bank_no -- 出票人开户行行号
    ,nvl(n.drawer_open_bank_name, o.drawer_open_bank_name) as drawer_open_bank_name -- 出票人开户行名称
    ,nvl(n.drawer_soci_crdt_cd, o.drawer_soci_crdt_cd) as drawer_soci_crdt_cd -- 出票人社会信用代码
    ,nvl(n.accptor_name, o.accptor_name) as accptor_name -- 承兑人名称
    ,nvl(n.accptor_acct_num, o.accptor_acct_num) as accptor_acct_num -- 承兑人账号
    ,nvl(n.accptor_open_bank_no, o.accptor_open_bank_no) as accptor_open_bank_no -- 承兑人开户行行号
    ,nvl(n.accptor_open_bank_name, o.accptor_open_bank_name) as accptor_open_bank_name -- 承兑人开户行名称
    ,nvl(n.accptor_soci_crdt_cd, o.accptor_soci_crdt_cd) as accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 收款人名称
    ,nvl(n.recver_open_bank_name, o.recver_open_bank_name) as recver_open_bank_name -- 收款人开户行名称
    ,nvl(n.recver_acct_num, o.recver_acct_num) as recver_acct_num -- 收款人账号
    ,nvl(n.recver_open_bank_no, o.recver_open_bank_no) as recver_open_bank_no -- 收款人开户行行号
    ,nvl(n.recver_soci_crdt_cd, o.recver_soci_crdt_cd) as recver_soci_crdt_cd -- 收款人社会信用代码
    ,nvl(n.pay_bank_no, o.pay_bank_no) as pay_bank_no -- 付款行行号
    ,nvl(n.pay_bank_org_cd, o.pay_bank_org_cd) as pay_bank_org_cd -- 付款行机构代码
    ,nvl(n.pay_bank_name, o.pay_bank_name) as pay_bank_name -- 付款行名称
    ,nvl(n.pay_cfm_org_cd, o.pay_cfm_org_cd) as pay_cfm_org_cd -- 付款确认机构代码
    ,nvl(n.acpt_guar_bank_no, o.acpt_guar_bank_no) as acpt_guar_bank_no -- 承兑保证行行号
    ,nvl(n.coll_bank_no, o.coll_bank_no) as coll_bank_no -- 托收行行号
    ,nvl(n.holder_name, o.holder_name) as holder_name -- 持票人名称
    ,nvl(n.holder_soci_crdt_cd, o.holder_soci_crdt_cd) as holder_soci_crdt_cd -- 持票人社会信用代码
    ,nvl(n.holder_acct_num, o.holder_acct_num) as holder_acct_num -- 持票人账号
    ,nvl(n.holder_org_cd, o.holder_org_cd) as holder_org_cd -- 持票人机构代码
    ,nvl(n.holder_org_name, o.holder_org_name) as holder_org_name -- 持票人机构名称
    ,nvl(n.risk_bill_status_cd, o.risk_bill_status_cd) as risk_bill_status_cd -- 风险票据状态代码
    ,nvl(n.bill_invtry_status_cd, o.bill_invtry_status_cd) as bill_invtry_status_cd -- 票据库存状态代码
    ,nvl(n.bill_src_cd, o.bill_src_cd) as bill_src_cd -- 票据来源代码
    ,nvl(n.bill_ccution_status_cd, o.bill_ccution_status_cd) as bill_ccution_status_cd -- 票据流转状态代码
    ,nvl(n.bill_status_cd, o.bill_status_cd) as bill_status_cd -- 票据状态代码
    ,nvl(n.comb_status_cd, o.comb_status_cd) as comb_status_cd -- 组合状态代码
    ,nvl(n.discnt_bk_org_cd, o.discnt_bk_org_cd) as discnt_bk_org_cd -- 贴现行机构代码
    ,nvl(n.discnt_bank_name, o.discnt_bank_name) as discnt_bank_name -- 贴现行名称
    ,nvl(n.invtry_org_cd, o.invtry_org_cd) as invtry_org_cd -- 库存机构代码
    ,nvl(n.init_belong_rgst_org_cd, o.init_belong_rgst_org_cd) as init_belong_rgst_org_cd -- 初始权属登记机构代码
    ,nvl(n.bill_belong_org_id, o.bill_belong_org_id) as bill_belong_org_id -- 票据所属机构编号
    ,nvl(n.hq_org_id, o.hq_org_id) as hq_org_id -- 总行机构编号
    ,nvl(n.hxb_acpt_flg, o.hxb_acpt_flg) as hxb_acpt_flg -- 我行承兑标志
    ,nvl(n.pay_cfm_flg, o.pay_cfm_flg) as pay_cfm_flg -- 付款确认标志
    ,nvl(n.lock_flg, o.lock_flg) as lock_flg -- 锁定标志
    ,nvl(n.payoff_flg, o.payoff_flg) as payoff_flg -- 结清标志
    ,nvl(n.recs_flg, o.recs_flg) as recs_flg -- 追偿标志
    ,nvl(n.discnt_dt, o.discnt_dt) as discnt_dt -- 贴现日期
    ,nvl(n.tran_cd, o.tran_cd) as tran_cd -- 转让代码
    ,nvl(n.receipt_flg, o.receipt_flg) as receipt_flg -- 小票标志
    ,nvl(n.bill_sub_intrv_id, o.bill_sub_intrv_id) as bill_sub_intrv_id -- 票据子区间号
    ,nvl(n.bill_intrv_std_amt, o.bill_intrv_std_amt) as bill_intrv_std_amt -- 票据区间标准金额
    ,nvl(n.init_bill_id, o.init_bill_id) as init_bill_id -- 原始票据编号
    ,nvl(n.select_id, o.select_id) as select_id -- 挑票编号
    ,nvl(n.actl_bf_split_bill_id, o.actl_bf_split_bill_id) as actl_bf_split_bill_id -- 实际拆前票据编号
    ,nvl(n.actl_bf_split_intrv_id, o.actl_bf_split_intrv_id) as actl_bf_split_intrv_id -- 实际拆前区间编号
    ,nvl(n.remark_1, o.remark_1) as remark_1 -- 备注1
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
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
from ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_tm n
    full join (select * from ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.init_bill_sys_bill_id <> n.init_bill_sys_bill_id
        or o.bill_num <> n.bill_num
        or o.bill_med_cd <> n.bill_med_cd
        or o.bill_type_cd <> n.bill_type_cd
        or o.draw_dt <> n.draw_dt
        or o.exp_dt <> n.exp_dt
        or o.bill_amt <> n.bill_amt
        or o.drawer_name <> n.drawer_name
        or o.drawer_acct_num <> n.drawer_acct_num
        or o.drawer_open_bank_no <> n.drawer_open_bank_no
        or o.drawer_open_bank_name <> n.drawer_open_bank_name
        or o.drawer_soci_crdt_cd <> n.drawer_soci_crdt_cd
        or o.accptor_name <> n.accptor_name
        or o.accptor_acct_num <> n.accptor_acct_num
        or o.accptor_open_bank_no <> n.accptor_open_bank_no
        or o.accptor_open_bank_name <> n.accptor_open_bank_name
        or o.accptor_soci_crdt_cd <> n.accptor_soci_crdt_cd
        or o.recver_name <> n.recver_name
        or o.recver_open_bank_name <> n.recver_open_bank_name
        or o.recver_acct_num <> n.recver_acct_num
        or o.recver_open_bank_no <> n.recver_open_bank_no
        or o.recver_soci_crdt_cd <> n.recver_soci_crdt_cd
        or o.pay_bank_no <> n.pay_bank_no
        or o.pay_bank_org_cd <> n.pay_bank_org_cd
        or o.pay_bank_name <> n.pay_bank_name
        or o.pay_cfm_org_cd <> n.pay_cfm_org_cd
        or o.acpt_guar_bank_no <> n.acpt_guar_bank_no
        or o.coll_bank_no <> n.coll_bank_no
        or o.holder_name <> n.holder_name
        or o.holder_soci_crdt_cd <> n.holder_soci_crdt_cd
        or o.holder_acct_num <> n.holder_acct_num
        or o.holder_org_cd <> n.holder_org_cd
        or o.holder_org_name <> n.holder_org_name
        or o.risk_bill_status_cd <> n.risk_bill_status_cd
        or o.bill_invtry_status_cd <> n.bill_invtry_status_cd
        or o.bill_src_cd <> n.bill_src_cd
        or o.bill_ccution_status_cd <> n.bill_ccution_status_cd
        or o.bill_status_cd <> n.bill_status_cd
        or o.comb_status_cd <> n.comb_status_cd
        or o.discnt_bk_org_cd <> n.discnt_bk_org_cd
        or o.discnt_bank_name <> n.discnt_bank_name
        or o.invtry_org_cd <> n.invtry_org_cd
        or o.init_belong_rgst_org_cd <> n.init_belong_rgst_org_cd
        or o.bill_belong_org_id <> n.bill_belong_org_id
        or o.hq_org_id <> n.hq_org_id
        or o.hxb_acpt_flg <> n.hxb_acpt_flg
        or o.pay_cfm_flg <> n.pay_cfm_flg
        or o.lock_flg <> n.lock_flg
        or o.payoff_flg <> n.payoff_flg
        or o.recs_flg <> n.recs_flg
        or o.discnt_dt <> n.discnt_dt
        or o.tran_cd <> n.tran_cd
        or o.receipt_flg <> n.receipt_flg
        or o.bill_sub_intrv_id <> n.bill_sub_intrv_id
        or o.bill_intrv_std_amt <> n.bill_intrv_std_amt
        or o.init_bill_id <> n.init_bill_id
        or o.select_id <> n.select_id
        or o.actl_bf_split_bill_id <> n.actl_bf_split_bill_id
        or o.actl_bf_split_intrv_id <> n.actl_bf_split_intrv_id
        or o.remark_1 <> n.remark_1
        or o.payoff_dt <> n.payoff_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_cl(
            rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,init_bill_sys_bill_id -- 原票据系统票据编号
    ,bill_num -- 票据号码
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,bill_amt -- 贴现票据金额
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,accptor_name -- 承兑人名称
    ,accptor_acct_num -- 承兑人账号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,recver_name -- 收款人名称
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_acct_num -- 收款人账号
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,pay_bank_no -- 付款行行号
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_name -- 付款行名称
    ,pay_cfm_org_cd -- 付款确认机构代码
    ,acpt_guar_bank_no -- 承兑保证行行号
    ,coll_bank_no -- 托收行行号
    ,holder_name -- 持票人名称
    ,holder_soci_crdt_cd -- 持票人社会信用代码
    ,holder_acct_num -- 持票人账号
    ,holder_org_cd -- 持票人机构代码
    ,holder_org_name -- 持票人机构名称
    ,risk_bill_status_cd -- 风险票据状态代码
    ,bill_invtry_status_cd -- 票据库存状态代码
    ,bill_src_cd -- 票据来源代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,bill_status_cd -- 票据状态代码
    ,comb_status_cd -- 组合状态代码
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_bank_name -- 贴现行名称
    ,invtry_org_cd -- 库存机构代码
    ,init_belong_rgst_org_cd -- 初始权属登记机构代码
    ,bill_belong_org_id -- 票据所属机构编号
    ,hq_org_id -- 总行机构编号
    ,hxb_acpt_flg -- 我行承兑标志
    ,pay_cfm_flg -- 付款确认标志
    ,lock_flg -- 锁定标志
    ,payoff_flg -- 结清标志
    ,recs_flg -- 追偿标志
    ,discnt_dt -- 贴现日期
    ,tran_cd -- 转让代码
    ,receipt_flg -- 小票标志
    ,bill_sub_intrv_id -- 票据子区间号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,init_bill_id -- 原始票据编号
    ,select_id -- 挑票编号
    ,actl_bf_split_bill_id -- 实际拆前票据编号
    ,actl_bf_split_intrv_id -- 实际拆前区间编号
    ,remark_1 -- 备注1
    ,payoff_dt -- 结清日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_op(
            rgst_id -- 登记编号
    ,lp_id -- 法人编号
    ,init_bill_sys_bill_id -- 原票据系统票据编号
    ,bill_num -- 票据号码
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,bill_amt -- 贴现票据金额
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,accptor_name -- 承兑人名称
    ,accptor_acct_num -- 承兑人账号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,recver_name -- 收款人名称
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_acct_num -- 收款人账号
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,pay_bank_no -- 付款行行号
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_name -- 付款行名称
    ,pay_cfm_org_cd -- 付款确认机构代码
    ,acpt_guar_bank_no -- 承兑保证行行号
    ,coll_bank_no -- 托收行行号
    ,holder_name -- 持票人名称
    ,holder_soci_crdt_cd -- 持票人社会信用代码
    ,holder_acct_num -- 持票人账号
    ,holder_org_cd -- 持票人机构代码
    ,holder_org_name -- 持票人机构名称
    ,risk_bill_status_cd -- 风险票据状态代码
    ,bill_invtry_status_cd -- 票据库存状态代码
    ,bill_src_cd -- 票据来源代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,bill_status_cd -- 票据状态代码
    ,comb_status_cd -- 组合状态代码
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_bank_name -- 贴现行名称
    ,invtry_org_cd -- 库存机构代码
    ,init_belong_rgst_org_cd -- 初始权属登记机构代码
    ,bill_belong_org_id -- 票据所属机构编号
    ,hq_org_id -- 总行机构编号
    ,hxb_acpt_flg -- 我行承兑标志
    ,pay_cfm_flg -- 付款确认标志
    ,lock_flg -- 锁定标志
    ,payoff_flg -- 结清标志
    ,recs_flg -- 追偿标志
    ,discnt_dt -- 贴现日期
    ,tran_cd -- 转让代码
    ,receipt_flg -- 小票标志
    ,bill_sub_intrv_id -- 票据子区间号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,init_bill_id -- 原始票据编号
    ,select_id -- 挑票编号
    ,actl_bf_split_bill_id -- 实际拆前票据编号
    ,actl_bf_split_intrv_id -- 实际拆前区间编号
    ,remark_1 -- 备注1
    ,payoff_dt -- 结清日期
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
    ,o.init_bill_sys_bill_id -- 原票据系统票据编号
    ,o.bill_num -- 票据号码
    ,o.bill_med_cd -- 票据介质代码
    ,o.bill_type_cd -- 票据类型代码
    ,o.draw_dt -- 出票日期
    ,o.exp_dt -- 到期日期
    ,o.bill_amt -- 贴现票据金额
    ,o.drawer_name -- 出票人名称
    ,o.drawer_acct_num -- 出票人账号
    ,o.drawer_open_bank_no -- 出票人开户行行号
    ,o.drawer_open_bank_name -- 出票人开户行名称
    ,o.drawer_soci_crdt_cd -- 出票人社会信用代码
    ,o.accptor_name -- 承兑人名称
    ,o.accptor_acct_num -- 承兑人账号
    ,o.accptor_open_bank_no -- 承兑人开户行行号
    ,o.accptor_open_bank_name -- 承兑人开户行名称
    ,o.accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,o.recver_name -- 收款人名称
    ,o.recver_open_bank_name -- 收款人开户行名称
    ,o.recver_acct_num -- 收款人账号
    ,o.recver_open_bank_no -- 收款人开户行行号
    ,o.recver_soci_crdt_cd -- 收款人社会信用代码
    ,o.pay_bank_no -- 付款行行号
    ,o.pay_bank_org_cd -- 付款行机构代码
    ,o.pay_bank_name -- 付款行名称
    ,o.pay_cfm_org_cd -- 付款确认机构代码
    ,o.acpt_guar_bank_no -- 承兑保证行行号
    ,o.coll_bank_no -- 托收行行号
    ,o.holder_name -- 持票人名称
    ,o.holder_soci_crdt_cd -- 持票人社会信用代码
    ,o.holder_acct_num -- 持票人账号
    ,o.holder_org_cd -- 持票人机构代码
    ,o.holder_org_name -- 持票人机构名称
    ,o.risk_bill_status_cd -- 风险票据状态代码
    ,o.bill_invtry_status_cd -- 票据库存状态代码
    ,o.bill_src_cd -- 票据来源代码
    ,o.bill_ccution_status_cd -- 票据流转状态代码
    ,o.bill_status_cd -- 票据状态代码
    ,o.comb_status_cd -- 组合状态代码
    ,o.discnt_bk_org_cd -- 贴现行机构代码
    ,o.discnt_bank_name -- 贴现行名称
    ,o.invtry_org_cd -- 库存机构代码
    ,o.init_belong_rgst_org_cd -- 初始权属登记机构代码
    ,o.bill_belong_org_id -- 票据所属机构编号
    ,o.hq_org_id -- 总行机构编号
    ,o.hxb_acpt_flg -- 我行承兑标志
    ,o.pay_cfm_flg -- 付款确认标志
    ,o.lock_flg -- 锁定标志
    ,o.payoff_flg -- 结清标志
    ,o.recs_flg -- 追偿标志
    ,o.discnt_dt -- 贴现日期
    ,o.tran_cd -- 转让代码
    ,o.receipt_flg -- 小票标志
    ,o.bill_sub_intrv_id -- 票据子区间号
    ,o.bill_intrv_std_amt -- 票据区间标准金额
    ,o.init_bill_id -- 原始票据编号
    ,o.select_id -- 挑票编号
    ,o.actl_bf_split_bill_id -- 实际拆前票据编号
    ,o.actl_bf_split_intrv_id -- 实际拆前区间编号
    ,o.remark_1 -- 备注1
    ,o.payoff_dt -- 结清日期
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
from ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_bk o
    left join ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_op n
        on
            o.rgst_id = n.rgst_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_cl d
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
--truncate table ${iml_schema}.ref_rgst_cter_bill_info_para;
--alter table ${iml_schema}.ref_rgst_cter_bill_info_para truncate partition for ('bdmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ref_rgst_cter_bill_info_para') 
               and substr(subpartition_name,1,8)=upper('p_bdmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ref_rgst_cter_bill_info_para drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ref_rgst_cter_bill_info_para modify partition p_bdmsf1 
add subpartition p_bdmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ref_rgst_cter_bill_info_para exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_cl;
alter table ${iml_schema}.ref_rgst_cter_bill_info_para exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_rgst_cter_bill_info_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_tm purge;
drop table ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_op purge;
drop table ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_rgst_cter_bill_info_para_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_rgst_cter_bill_info_para', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
