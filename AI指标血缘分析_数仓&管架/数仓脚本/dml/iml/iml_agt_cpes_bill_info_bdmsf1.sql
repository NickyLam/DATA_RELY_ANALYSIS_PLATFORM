/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cpes_bill_info_bdmsf1
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
alter table ${iml_schema}.agt_cpes_bill_info add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_cpes_bill_info_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cpes_bill_info partition for ('bdmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_cpes_bill_info_bdmsf1_tm purge;
drop table ${iml_schema}.agt_cpes_bill_info_bdmsf1_op purge;
drop table ${iml_schema}.agt_cpes_bill_info_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cpes_bill_info_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,fac_val_amt -- 票面金额
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,drawer_open_acct_org_cd -- 出票人开户机构代码
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_name -- 承兑人名称
    ,accptor_acct_num -- 承兑人账号
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,accptor_open_acct_org_cd -- 承兑人开户机构代码
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,recver_name -- 收款人名称
    ,recver_acct_num -- 收款人账号
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,recver_open_acct_org_cd -- 收款人开户机构代码
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_no -- 付款行行号
    ,pay_cfm_org_cd -- 付款确认机构代码
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_guar_org_cd -- 贴现保证机构代码
    ,invtry_org_cd -- 库存机构代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,risk_bill_status_cd -- 风险票据状态代码
    ,bill_invtry_status_cd -- 票据库存状态代码
    ,bill_status_cd -- 票据状态代码
    ,init_ccution_status_cd -- 原流转状态代码
    ,init_risk_bill_status_cd -- 原风险票据状态代码
    ,init_bill_status_cd -- 原票据状态代码
    ,init_bill_invtry_status_cd -- 原票据库存状态代码
    ,discnt_dt -- 贴现日期
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,payoff_dt -- 结清日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cpes_bill_info partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.agt_cpes_bill_info_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cpes_bill_info partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.agt_cpes_bill_info_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cpes_bill_info partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_htes_draft_info-
insert into ${iml_schema}.agt_cpes_bill_info_bdmsf1_tm(
    vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,fac_val_amt -- 票面金额
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,drawer_open_acct_org_cd -- 出票人开户机构代码
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_name -- 承兑人名称
    ,accptor_acct_num -- 承兑人账号
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,accptor_open_acct_org_cd -- 承兑人开户机构代码
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,recver_name -- 收款人名称
    ,recver_acct_num -- 收款人账号
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,recver_open_acct_org_cd -- 收款人开户机构代码
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_no -- 付款行行号
    ,pay_cfm_org_cd -- 付款确认机构代码
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_guar_org_cd -- 贴现保证机构代码
    ,invtry_org_cd -- 库存机构代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,risk_bill_status_cd -- 风险票据状态代码
    ,bill_invtry_status_cd -- 票据库存状态代码
    ,bill_status_cd -- 票据状态代码
    ,init_ccution_status_cd -- 原流转状态代码
    ,init_risk_bill_status_cd -- 原风险票据状态代码
    ,init_bill_status_cd -- 原票据状态代码
    ,init_bill_invtry_status_cd -- 原票据库存状态代码
    ,discnt_dt -- 贴现日期
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,payoff_dt -- 结清日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101004'||P1.ID -- 凭证编号
    ,'9999' -- 法人编号
    ,P1.ID -- 票据编号
    ,P1.DRAFT_NUMBER -- 票据号码
    ,case when R1.TARGET_CD_VAL is not null then R1.TARGET_CD_VAL else '@'||P1.DRAFT_ATTR end -- 票据介质代码
    ,nvl(trim(P1.DRAFT_TYPE),'-') -- 票据类型代码
    ,${iml_schema}.dateformat_min(P1.REMIT_DATE) -- 出票日期
    ,${iml_schema}.dateformat_max2(P1.MATURITY_DATE) -- 到期日期
    ,P1.DRAFT_AMOUNT -- 票面金额
    ,P1.REMITTER_NAME -- 出票人名称
    ,P1.REMITTER_ACCOUNT -- 出票人账号
    ,P1.REMITTER_CREDIT_NO -- 出票人社会信用代码
    ,P1.REMITTER_BRH_NO -- 出票人开户机构代码
    ,P1.REMITTER_BANK_NO -- 出票人开户行行号
    ,P1.REMITTER_BANK_NAME -- 出票人开户行名称
    ,P1.ACCEPTOR_NAME -- 承兑人名称
    ,P1.ACCEPTOR_ACCOUNT -- 承兑人账号
    ,P1.ACCEPTOR_CREDIT_NO -- 承兑人社会信用代码
    ,P1.ACCEPTOR_BRH_NO -- 承兑人开户机构代码
    ,P1.ACCEPTOR_BANK_NO -- 承兑人开户行行号
    ,P1.ACCEPTOR_BANK_NAME -- 承兑人开户行名称
    ,P1.PAYEE_NAME -- 收款人名称
    ,P1.PAYEE_ACCOUNT -- 收款人账号
    ,P1.PAYEE_CREDIT_NO -- 收款人社会信用代码
    ,P1.PAYEE_BRH_NO -- 收款人开户机构代码
    ,P1.PAYEE_BANK_NO -- 收款人开户行行号
    ,P1.PAYEE_BANK_NAME -- 收款人开户行名称
    ,P1.PAYER_BRH_NO -- 付款行机构代码
    ,P1.PAYER_BANK_NO -- 付款行行号
    ,P1.PAYER_CONFIRM_BRH_NO -- 付款确认机构代码
    ,P1.DISCOUNT_BRH_NO -- 贴现行机构代码
    ,P1.DISC_GUA_BRH_NO -- 贴现保证机构代码
    ,P1.STORE_BRH_NO -- 库存机构代码
    ,NVL(TRIM(P1.FLOW_STATUS),'-') -- 票据流转状态代码
    ,NVL(TRIM(P1.RISK_STATUS),'-') -- 风险票据状态代码
    ,NVL(TRIM(P1.STORE_STATUS),'-') -- 票据库存状态代码
    ,CASE WHEN P1.STATUS='-' THEN 'ST00' WHEN TRIM(P1.STATUS) IS NULL THEN 'ST00' ELSE P1.STATUS END -- 票据状态代码
    ,NVL(TRIM(P1.ORG_FLOW_STATUS),'-') -- 原流转状态代码
    ,NVL(TRIM(P1.ORG_RISK_STATUS),'-') -- 原风险票据状态代码
    ,CASE WHEN P1.STATUS='-' THEN 'ST00' WHEN TRIM(P1.ORG_STATUS) IS NULL THEN 'ST00' ELSE P1.STATUS END -- 原票据状态代码
    ,NVL(TRIM(P1.ORG_STORE_STATUS),'-') -- 原票据库存状态代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.DISC_DATE) -- 贴现日期
    ,P1.CD_RANGE -- 票据子区间编号
    ,P1.STANDARD_AMT -- 票据区间标准金额
    ,${iml_schema}.dateformat_max2(P1.SETTLE_DATE) -- 结清日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_htes_draft_info' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.bdms_htes_draft_info p1
  left join ${iml_schema}.ref_pub_cd_map r1
    on p1.draft_attr = r1.src_code_val
   and r1.sorc_sys_cd = 'BDMS'
   and r1.src_tab_en_name = 'BDMS_HTES_DRAFT_INFO'
   and r1.src_field_en_name = 'DRAFT_ATTR'
   and r1.target_tab_en_name = 'AGT_CPES_BILL_INFO'
   and r1.target_tab_field_en_name = 'BILL_MED_CD'
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
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_cpes_bill_info_bdmsf1_tm 
  	                                group by 
  	                                        vouch_id
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
        into ${iml_schema}.agt_cpes_bill_info_bdmsf1_cl(
            vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,fac_val_amt -- 票面金额
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,drawer_open_acct_org_cd -- 出票人开户机构代码
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_name -- 承兑人名称
    ,accptor_acct_num -- 承兑人账号
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,accptor_open_acct_org_cd -- 承兑人开户机构代码
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,recver_name -- 收款人名称
    ,recver_acct_num -- 收款人账号
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,recver_open_acct_org_cd -- 收款人开户机构代码
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_no -- 付款行行号
    ,pay_cfm_org_cd -- 付款确认机构代码
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_guar_org_cd -- 贴现保证机构代码
    ,invtry_org_cd -- 库存机构代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,risk_bill_status_cd -- 风险票据状态代码
    ,bill_invtry_status_cd -- 票据库存状态代码
    ,bill_status_cd -- 票据状态代码
    ,init_ccution_status_cd -- 原流转状态代码
    ,init_risk_bill_status_cd -- 原风险票据状态代码
    ,init_bill_status_cd -- 原票据状态代码
    ,init_bill_invtry_status_cd -- 原票据库存状态代码
    ,discnt_dt -- 贴现日期
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,payoff_dt -- 结清日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cpes_bill_info_bdmsf1_op(
            vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,fac_val_amt -- 票面金额
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,drawer_open_acct_org_cd -- 出票人开户机构代码
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_name -- 承兑人名称
    ,accptor_acct_num -- 承兑人账号
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,accptor_open_acct_org_cd -- 承兑人开户机构代码
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,recver_name -- 收款人名称
    ,recver_acct_num -- 收款人账号
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,recver_open_acct_org_cd -- 收款人开户机构代码
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_no -- 付款行行号
    ,pay_cfm_org_cd -- 付款确认机构代码
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_guar_org_cd -- 贴现保证机构代码
    ,invtry_org_cd -- 库存机构代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,risk_bill_status_cd -- 风险票据状态代码
    ,bill_invtry_status_cd -- 票据库存状态代码
    ,bill_status_cd -- 票据状态代码
    ,init_ccution_status_cd -- 原流转状态代码
    ,init_risk_bill_status_cd -- 原风险票据状态代码
    ,init_bill_status_cd -- 原票据状态代码
    ,init_bill_invtry_status_cd -- 原票据库存状态代码
    ,discnt_dt -- 贴现日期
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,payoff_dt -- 结清日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,nvl(n.bill_med_cd, o.bill_med_cd) as bill_med_cd -- 票据介质代码
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.draw_dt, o.draw_dt) as draw_dt -- 出票日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.fac_val_amt, o.fac_val_amt) as fac_val_amt -- 票面金额
    ,nvl(n.drawer_name, o.drawer_name) as drawer_name -- 出票人名称
    ,nvl(n.drawer_acct_num, o.drawer_acct_num) as drawer_acct_num -- 出票人账号
    ,nvl(n.drawer_soci_crdt_cd, o.drawer_soci_crdt_cd) as drawer_soci_crdt_cd -- 出票人社会信用代码
    ,nvl(n.drawer_open_acct_org_cd, o.drawer_open_acct_org_cd) as drawer_open_acct_org_cd -- 出票人开户机构代码
    ,nvl(n.drawer_open_bank_no, o.drawer_open_bank_no) as drawer_open_bank_no -- 出票人开户行行号
    ,nvl(n.drawer_open_bank_name, o.drawer_open_bank_name) as drawer_open_bank_name -- 出票人开户行名称
    ,nvl(n.accptor_name, o.accptor_name) as accptor_name -- 承兑人名称
    ,nvl(n.accptor_acct_num, o.accptor_acct_num) as accptor_acct_num -- 承兑人账号
    ,nvl(n.accptor_soci_crdt_cd, o.accptor_soci_crdt_cd) as accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,nvl(n.accptor_open_acct_org_cd, o.accptor_open_acct_org_cd) as accptor_open_acct_org_cd -- 承兑人开户机构代码
    ,nvl(n.accptor_open_bank_no, o.accptor_open_bank_no) as accptor_open_bank_no -- 承兑人开户行行号
    ,nvl(n.accptor_open_bank_name, o.accptor_open_bank_name) as accptor_open_bank_name -- 承兑人开户行名称
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 收款人名称
    ,nvl(n.recver_acct_num, o.recver_acct_num) as recver_acct_num -- 收款人账号
    ,nvl(n.recver_soci_crdt_cd, o.recver_soci_crdt_cd) as recver_soci_crdt_cd -- 收款人社会信用代码
    ,nvl(n.recver_open_acct_org_cd, o.recver_open_acct_org_cd) as recver_open_acct_org_cd -- 收款人开户机构代码
    ,nvl(n.recver_open_bank_no, o.recver_open_bank_no) as recver_open_bank_no -- 收款人开户行行号
    ,nvl(n.recver_open_bank_name, o.recver_open_bank_name) as recver_open_bank_name -- 收款人开户行名称
    ,nvl(n.pay_bank_org_cd, o.pay_bank_org_cd) as pay_bank_org_cd -- 付款行机构代码
    ,nvl(n.pay_bank_no, o.pay_bank_no) as pay_bank_no -- 付款行行号
    ,nvl(n.pay_cfm_org_cd, o.pay_cfm_org_cd) as pay_cfm_org_cd -- 付款确认机构代码
    ,nvl(n.discnt_bk_org_cd, o.discnt_bk_org_cd) as discnt_bk_org_cd -- 贴现行机构代码
    ,nvl(n.discnt_guar_org_cd, o.discnt_guar_org_cd) as discnt_guar_org_cd -- 贴现保证机构代码
    ,nvl(n.invtry_org_cd, o.invtry_org_cd) as invtry_org_cd -- 库存机构代码
    ,nvl(n.bill_ccution_status_cd, o.bill_ccution_status_cd) as bill_ccution_status_cd -- 票据流转状态代码
    ,nvl(n.risk_bill_status_cd, o.risk_bill_status_cd) as risk_bill_status_cd -- 风险票据状态代码
    ,nvl(n.bill_invtry_status_cd, o.bill_invtry_status_cd) as bill_invtry_status_cd -- 票据库存状态代码
    ,nvl(n.bill_status_cd, o.bill_status_cd) as bill_status_cd -- 票据状态代码
    ,nvl(n.init_ccution_status_cd, o.init_ccution_status_cd) as init_ccution_status_cd -- 原流转状态代码
    ,nvl(n.init_risk_bill_status_cd, o.init_risk_bill_status_cd) as init_risk_bill_status_cd -- 原风险票据状态代码
    ,nvl(n.init_bill_status_cd, o.init_bill_status_cd) as init_bill_status_cd -- 原票据状态代码
    ,nvl(n.init_bill_invtry_status_cd, o.init_bill_invtry_status_cd) as init_bill_invtry_status_cd -- 原票据库存状态代码
    ,nvl(n.discnt_dt, o.discnt_dt) as discnt_dt -- 贴现日期
    ,nvl(n.bill_sub_intrv_id, o.bill_sub_intrv_id) as bill_sub_intrv_id -- 票据子区间编号
    ,nvl(n.bill_intrv_std_amt, o.bill_intrv_std_amt) as bill_intrv_std_amt -- 票据区间标准金额
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,case when
            n.vouch_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.vouch_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.vouch_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cpes_bill_info_bdmsf1_tm n
    full join (select * from ${iml_schema}.agt_cpes_bill_info_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.vouch_id = n.vouch_id
            and o.lp_id = n.lp_id
where (
        o.vouch_id is null
        and o.lp_id is null
    )
    or (
        n.vouch_id is null
        and n.lp_id is null
    )
    or (
        o.bill_id <> n.bill_id
        or o.bill_num <> n.bill_num
        or o.bill_med_cd <> n.bill_med_cd
        or o.bill_type_cd <> n.bill_type_cd
        or o.draw_dt <> n.draw_dt
        or o.exp_dt <> n.exp_dt
        or o.fac_val_amt <> n.fac_val_amt
        or o.drawer_name <> n.drawer_name
        or o.drawer_acct_num <> n.drawer_acct_num
        or o.drawer_soci_crdt_cd <> n.drawer_soci_crdt_cd
        or o.drawer_open_acct_org_cd <> n.drawer_open_acct_org_cd
        or o.drawer_open_bank_no <> n.drawer_open_bank_no
        or o.drawer_open_bank_name <> n.drawer_open_bank_name
        or o.accptor_name <> n.accptor_name
        or o.accptor_acct_num <> n.accptor_acct_num
        or o.accptor_soci_crdt_cd <> n.accptor_soci_crdt_cd
        or o.accptor_open_acct_org_cd <> n.accptor_open_acct_org_cd
        or o.accptor_open_bank_no <> n.accptor_open_bank_no
        or o.accptor_open_bank_name <> n.accptor_open_bank_name
        or o.recver_name <> n.recver_name
        or o.recver_acct_num <> n.recver_acct_num
        or o.recver_soci_crdt_cd <> n.recver_soci_crdt_cd
        or o.recver_open_acct_org_cd <> n.recver_open_acct_org_cd
        or o.recver_open_bank_no <> n.recver_open_bank_no
        or o.recver_open_bank_name <> n.recver_open_bank_name
        or o.pay_bank_org_cd <> n.pay_bank_org_cd
        or o.pay_bank_no <> n.pay_bank_no
        or o.pay_cfm_org_cd <> n.pay_cfm_org_cd
        or o.discnt_bk_org_cd <> n.discnt_bk_org_cd
        or o.discnt_guar_org_cd <> n.discnt_guar_org_cd
        or o.invtry_org_cd <> n.invtry_org_cd
        or o.bill_ccution_status_cd <> n.bill_ccution_status_cd
        or o.risk_bill_status_cd <> n.risk_bill_status_cd
        or o.bill_invtry_status_cd <> n.bill_invtry_status_cd
        or o.bill_status_cd <> n.bill_status_cd
        or o.init_ccution_status_cd <> n.init_ccution_status_cd
        or o.init_risk_bill_status_cd <> n.init_risk_bill_status_cd
        or o.init_bill_status_cd <> n.init_bill_status_cd
        or o.init_bill_invtry_status_cd <> n.init_bill_invtry_status_cd
        or o.discnt_dt <> n.discnt_dt
        or o.bill_sub_intrv_id <> n.bill_sub_intrv_id
        or o.bill_intrv_std_amt <> n.bill_intrv_std_amt
        or o.payoff_dt <> n.payoff_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cpes_bill_info_bdmsf1_cl(
            vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,fac_val_amt -- 票面金额
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,drawer_open_acct_org_cd -- 出票人开户机构代码
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_name -- 承兑人名称
    ,accptor_acct_num -- 承兑人账号
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,accptor_open_acct_org_cd -- 承兑人开户机构代码
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,recver_name -- 收款人名称
    ,recver_acct_num -- 收款人账号
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,recver_open_acct_org_cd -- 收款人开户机构代码
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_no -- 付款行行号
    ,pay_cfm_org_cd -- 付款确认机构代码
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_guar_org_cd -- 贴现保证机构代码
    ,invtry_org_cd -- 库存机构代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,risk_bill_status_cd -- 风险票据状态代码
    ,bill_invtry_status_cd -- 票据库存状态代码
    ,bill_status_cd -- 票据状态代码
    ,init_ccution_status_cd -- 原流转状态代码
    ,init_risk_bill_status_cd -- 原风险票据状态代码
    ,init_bill_status_cd -- 原票据状态代码
    ,init_bill_invtry_status_cd -- 原票据库存状态代码
    ,discnt_dt -- 贴现日期
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,payoff_dt -- 结清日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cpes_bill_info_bdmsf1_op(
            vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,fac_val_amt -- 票面金额
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_soci_crdt_cd -- 出票人社会信用代码
    ,drawer_open_acct_org_cd -- 出票人开户机构代码
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_name -- 承兑人名称
    ,accptor_acct_num -- 承兑人账号
    ,accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,accptor_open_acct_org_cd -- 承兑人开户机构代码
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,recver_name -- 收款人名称
    ,recver_acct_num -- 收款人账号
    ,recver_soci_crdt_cd -- 收款人社会信用代码
    ,recver_open_acct_org_cd -- 收款人开户机构代码
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,pay_bank_org_cd -- 付款行机构代码
    ,pay_bank_no -- 付款行行号
    ,pay_cfm_org_cd -- 付款确认机构代码
    ,discnt_bk_org_cd -- 贴现行机构代码
    ,discnt_guar_org_cd -- 贴现保证机构代码
    ,invtry_org_cd -- 库存机构代码
    ,bill_ccution_status_cd -- 票据流转状态代码
    ,risk_bill_status_cd -- 风险票据状态代码
    ,bill_invtry_status_cd -- 票据库存状态代码
    ,bill_status_cd -- 票据状态代码
    ,init_ccution_status_cd -- 原流转状态代码
    ,init_risk_bill_status_cd -- 原风险票据状态代码
    ,init_bill_status_cd -- 原票据状态代码
    ,init_bill_invtry_status_cd -- 原票据库存状态代码
    ,discnt_dt -- 贴现日期
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,payoff_dt -- 结清日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.vouch_id -- 凭证编号
    ,o.lp_id -- 法人编号
    ,o.bill_id -- 票据编号
    ,o.bill_num -- 票据号码
    ,o.bill_med_cd -- 票据介质代码
    ,o.bill_type_cd -- 票据类型代码
    ,o.draw_dt -- 出票日期
    ,o.exp_dt -- 到期日期
    ,o.fac_val_amt -- 票面金额
    ,o.drawer_name -- 出票人名称
    ,o.drawer_acct_num -- 出票人账号
    ,o.drawer_soci_crdt_cd -- 出票人社会信用代码
    ,o.drawer_open_acct_org_cd -- 出票人开户机构代码
    ,o.drawer_open_bank_no -- 出票人开户行行号
    ,o.drawer_open_bank_name -- 出票人开户行名称
    ,o.accptor_name -- 承兑人名称
    ,o.accptor_acct_num -- 承兑人账号
    ,o.accptor_soci_crdt_cd -- 承兑人社会信用代码
    ,o.accptor_open_acct_org_cd -- 承兑人开户机构代码
    ,o.accptor_open_bank_no -- 承兑人开户行行号
    ,o.accptor_open_bank_name -- 承兑人开户行名称
    ,o.recver_name -- 收款人名称
    ,o.recver_acct_num -- 收款人账号
    ,o.recver_soci_crdt_cd -- 收款人社会信用代码
    ,o.recver_open_acct_org_cd -- 收款人开户机构代码
    ,o.recver_open_bank_no -- 收款人开户行行号
    ,o.recver_open_bank_name -- 收款人开户行名称
    ,o.pay_bank_org_cd -- 付款行机构代码
    ,o.pay_bank_no -- 付款行行号
    ,o.pay_cfm_org_cd -- 付款确认机构代码
    ,o.discnt_bk_org_cd -- 贴现行机构代码
    ,o.discnt_guar_org_cd -- 贴现保证机构代码
    ,o.invtry_org_cd -- 库存机构代码
    ,o.bill_ccution_status_cd -- 票据流转状态代码
    ,o.risk_bill_status_cd -- 风险票据状态代码
    ,o.bill_invtry_status_cd -- 票据库存状态代码
    ,o.bill_status_cd -- 票据状态代码
    ,o.init_ccution_status_cd -- 原流转状态代码
    ,o.init_risk_bill_status_cd -- 原风险票据状态代码
    ,o.init_bill_status_cd -- 原票据状态代码
    ,o.init_bill_invtry_status_cd -- 原票据库存状态代码
    ,o.discnt_dt -- 贴现日期
    ,o.bill_sub_intrv_id -- 票据子区间编号
    ,o.bill_intrv_std_amt -- 票据区间标准金额
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
from ${iml_schema}.agt_cpes_bill_info_bdmsf1_bk o
    left join ${iml_schema}.agt_cpes_bill_info_bdmsf1_op n
        on
            o.vouch_id = n.vouch_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_cpes_bill_info_bdmsf1_cl d
        on
            o.vouch_id = d.vouch_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_cpes_bill_info;
--alter table ${iml_schema}.agt_cpes_bill_info truncate partition for ('bdmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_cpes_bill_info') 
               and substr(subpartition_name,1,8)=upper('p_bdmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_cpes_bill_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_cpes_bill_info modify partition p_bdmsf1 
add subpartition p_bdmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_cpes_bill_info exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_cpes_bill_info_bdmsf1_cl;
alter table ${iml_schema}.agt_cpes_bill_info exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.agt_cpes_bill_info_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cpes_bill_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_cpes_bill_info_bdmsf1_tm purge;
drop table ${iml_schema}.agt_cpes_bill_info_bdmsf1_op purge;
drop table ${iml_schema}.agt_cpes_bill_info_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_cpes_bill_info_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cpes_bill_info', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
