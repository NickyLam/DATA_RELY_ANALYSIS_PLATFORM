/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bill_info_bdmsf1
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
drop table ${iml_schema}.agt_bill_info_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_info_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_bill_info add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_bill_info modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bill_info_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_info partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_info_bdmsf1_tm
compress ${option_switch} for query high
as
select
    vouch_id -- 凭证编号
    ,bill_id -- 票据编号
    ,lp_id -- 法人编号
    ,bill_num -- 票据号码
    ,role_src_cd -- 角色来源代码
    ,discnt_batch_id -- 贴现批次编号
    ,pbc_tranbl_flg -- 人行可转让标志
    ,hxb_acpt_flg -- 我行承兑标志
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,fac_val_exp_dt -- 票面到期日期
    ,drawer_cate_cd -- 出票人类别代码
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_open_bank_num -- 出票人开户行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_cate_cd -- 承兑人类别代码
    ,accptor_name -- 承兑人名称
    ,accptor_open_bank_num -- 承兑人开户行号
    ,accptor_acct_num -- 承兑人账号
    ,recver_name -- 收款人名称
    ,recver_acct_num -- 收款人账号
    ,recver_open_bank_num -- 收款人开户行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,bill_amt -- 票据金额
    ,bill_belong_org_id -- 票据所属机构编号
    ,bill_status_cd -- 票据状态代码
    ,loss_flg -- 挂失标志
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,receipt_flg -- 小票标志
    ,redcst_flg -- 再贴现标志
    ,h_data_flg -- 历史数据标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_bill_info_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_bill_info partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_bms_draft_centre_info-
insert into ${iml_schema}.agt_bill_info_bdmsf1_tm(
    vouch_id -- 凭证编号
    ,bill_id -- 票据编号
    ,lp_id -- 法人编号
    ,bill_num -- 票据号码
    ,role_src_cd -- 角色来源代码
    ,discnt_batch_id -- 贴现批次编号
    ,pbc_tranbl_flg -- 人行可转让标志
    ,hxb_acpt_flg -- 我行承兑标志
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,fac_val_exp_dt -- 票面到期日期
    ,drawer_cate_cd -- 出票人类别代码
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_open_bank_num -- 出票人开户行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_cate_cd -- 承兑人类别代码
    ,accptor_name -- 承兑人名称
    ,accptor_open_bank_num -- 承兑人开户行号
    ,accptor_acct_num -- 承兑人账号
    ,recver_name -- 收款人名称
    ,recver_acct_num -- 收款人账号
    ,recver_open_bank_num -- 收款人开户行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,bill_amt -- 票据金额
    ,bill_belong_org_id -- 票据所属机构编号
    ,bill_status_cd -- 票据状态代码
    ,loss_flg -- 挂失标志
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,receipt_flg -- 小票标志
    ,redcst_flg -- 再贴现标志
    ,h_data_flg -- 历史数据标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101008'||P1.ID -- 凭证编号
    ,P1.ID -- 票据编号
    ,'9999' -- 法人编号
    ,P1.DRAFT_NUMBER -- 票据号码
    ,nvl(trim(P2.SRC_TYPE),'00') -- 角色来源代码
    ,P1.BUY_CONTRACT_ID -- 贴现批次编号
    ,nvl(trim(P1.DRAFT_TRANSFER_FLAG),'-') -- 人行可转让标志
    ,CASE WHEN (P1.DRAFT_TYPE='1' and P8.BANK_NO IS NOT NULL) THEN '1' ELSE '0' END -- 我行承兑标志
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DRAFT_ATTR END -- 票据介质代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DRAFT_TYPE END -- 票据类型代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.REMIT_DATE) -- 出票日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.MATURITY_DATE) -- 票面到期日期
    ,NVL(TRIM(P1.REMITTER_ROLE),'-') -- 出票人类别代码
    ,P1.REMITTER_CMONID -- 出票人组织机构代码
    ,P1.REMITTER_NAME -- 出票人名称
    ,P1.REMITTER_ACCOUNT -- 出票人账号
    ,case when nvl(trim(P1.REMITTER_BANK_NO),'0')<>'0'  then P1.REMITTER_BANK_NO else NVL(TRIM(P9.BANK_NO), '0') END -- 出票人开户行号
    ,P1.ACCEPTOR_BANK_NAME -- 承兑人开户行名称
    ,P1.REMITTER_BANK_NAME -- 出票人开户行名称
    ,NVL(TRIM(P1.ACCEPTOR_ROLE),'-') -- 承兑人类别代码
    ,P1.ACCEPTOR_NAME -- 承兑人名称
    ,case when nvl(trim(P1.ACCEPTOR_BANK_NO),'0')<>'0'  then P1.ACCEPTOR_BANK_NO else NVL(TRIM(P10.BANK_NO), '0') END -- 承兑人开户行号
    ,P1.ACCEPTOR_ACCOUNT -- 承兑人账号
    ,P1.PAYEE_NAME -- 收款人名称
    ,P1.PAYEE_ACCOUNT -- 收款人账号
    ,case when nvl(trim(P1.PAYEE_BANK_NO),'0')<>'0'  then P1.PAYEE_BANK_NO else NVL(TRIM(P11.BANK_NO), '0') END -- 收款人开户行号
    ,P1.PAYEE_BANK_NAME -- 收款人开户行名称
    ,P1.DRAFT_AMOUNT -- 票据金额
    ,P1.BELONG_BRANCH_NO -- 票据所属机构编号
    ,nvl(trim(P6.STATUS),'-') -- 票据状态代码
    ,nvl(trim(P1.REPORT_OF_LOSS_FLAG),'-') -- 挂失标志
    ,P1.LAST_OPERATOR_NO -- 最后修改操作员编号
    ,P1.LAST_TXN_DATE -- 最后修改时间
    ,NVL(TRIM(P1.IS_RECEIPT),'-') -- 小票标志
    ,NVL(TRIM(P1.STOCK_STATUS),'-') -- 再贴现标志
    ,p1.RESERVE1 -- 历史数据标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_draft_centre_info' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.bdms_bms_draft_centre_info p1
  left join ${iol_schema}.bdms_v_src_type p2
    on p1.id = p2.id
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select bank_no,
                    actor_full_call,
                    row_number() over(partition by actor_full_call order by id desc) as rn
               from ${iol_schema}.bdms_bms_ecds_bank_data
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')) p11
    on p1.payee_bank_name = p11.actor_full_call
   and p11.rn = 1
  left join (select bank_no,
                    actor_full_call,
                    row_number() over(partition by actor_full_call order by id desc) as rn
               from ${iol_schema}.bdms_bms_ecds_bank_data
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')) p9
    on p1.remitter_bank_name = p9.actor_full_call
   and p9.rn = 1
  left join (select distinct bank_no, start_dt, end_dt
                from ${iol_schema}.bdms_htes_ptcpt_info
               where belong_legal_no = '313586000006') p8
    on p1.acceptor_bank_no = p8.bank_no
   and p8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p8.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select bank_no,
                    actor_full_call,
                    row_number() over(partition by actor_full_call order by id desc) as rn
               from ${iol_schema}.bdms_bms_ecds_bank_data
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')) p10
    on p1.acceptor_bank_name = p10.actor_full_call
   and p10.rn = 1
  left join ${iol_schema}.bdms_draft_status p6
    on p1.id = p6.id
   and p6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p6.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.ref_pub_cd_map r1
    on p1.draft_attr = r1.src_code_val
   and r1.sorc_sys_cd = 'BDMS'
   and r1.src_tab_en_name = 'BDMS_BMS_DRAFT_CENTRE_INFO'
   and r1.src_field_en_name = 'DRAFT_ATTR'
   and r1.target_tab_en_name = 'AGT_BILL_INFO'
   and r1.target_tab_field_en_name = 'BILL_MED_CD'
  left join ${iml_schema}.ref_pub_cd_map r2
    on p1.draft_type = r2.src_code_val
   and r2.sorc_sys_cd = 'BDMS'
   and r2.src_tab_en_name = 'BDMS_BMS_DRAFT_CENTRE_INFO'
   and r2.src_field_en_name = 'DRAFT_TYPE'
   and r2.target_tab_en_name = 'AGT_BILL_INFO'
   and r2.target_tab_field_en_name = 'BILL_TYPE_CD'
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   ;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bill_info_bdmsf1_tm 
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_bill_info_bdmsf1_ex(
    vouch_id -- 凭证编号
    ,bill_id -- 票据编号
    ,lp_id -- 法人编号
    ,bill_num -- 票据号码
    ,role_src_cd -- 角色来源代码
    ,discnt_batch_id -- 贴现批次编号
    ,pbc_tranbl_flg -- 人行可转让标志
    ,hxb_acpt_flg -- 我行承兑标志
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,fac_val_exp_dt -- 票面到期日期
    ,drawer_cate_cd -- 出票人类别代码
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_open_bank_num -- 出票人开户行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_cate_cd -- 承兑人类别代码
    ,accptor_name -- 承兑人名称
    ,accptor_open_bank_num -- 承兑人开户行号
    ,accptor_acct_num -- 承兑人账号
    ,recver_name -- 收款人名称
    ,recver_acct_num -- 收款人账号
    ,recver_open_bank_num -- 收款人开户行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,bill_amt -- 票据金额
    ,bill_belong_org_id -- 票据所属机构编号
    ,bill_status_cd -- 票据状态代码
    ,loss_flg -- 挂失标志
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,receipt_flg -- 小票标志
    ,redcst_flg -- 再贴现标志
    ,h_data_flg -- 历史数据标志
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,nvl(n.role_src_cd, o.role_src_cd) as role_src_cd -- 角色来源代码
    ,nvl(n.discnt_batch_id, o.discnt_batch_id) as discnt_batch_id -- 贴现批次编号
    ,nvl(n.pbc_tranbl_flg, o.pbc_tranbl_flg) as pbc_tranbl_flg -- 人行可转让标志
    ,nvl(n.hxb_acpt_flg, o.hxb_acpt_flg) as hxb_acpt_flg -- 我行承兑标志
    ,nvl(n.bill_med_cd, o.bill_med_cd) as bill_med_cd -- 票据介质代码
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.draw_dt, o.draw_dt) as draw_dt -- 出票日期
    ,nvl(n.fac_val_exp_dt, o.fac_val_exp_dt) as fac_val_exp_dt -- 票面到期日期
    ,nvl(n.drawer_cate_cd, o.drawer_cate_cd) as drawer_cate_cd -- 出票人类别代码
    ,nvl(n.drawer_orgnz_cd, o.drawer_orgnz_cd) as drawer_orgnz_cd -- 出票人组织机构代码
    ,nvl(n.drawer_name, o.drawer_name) as drawer_name -- 出票人名称
    ,nvl(n.drawer_acct_num, o.drawer_acct_num) as drawer_acct_num -- 出票人账号
    ,nvl(n.drawer_open_bank_num, o.drawer_open_bank_num) as drawer_open_bank_num -- 出票人开户行号
    ,nvl(n.accptor_open_bank_name, o.accptor_open_bank_name) as accptor_open_bank_name -- 承兑人开户行名称
    ,nvl(n.drawer_open_bank_name, o.drawer_open_bank_name) as drawer_open_bank_name -- 出票人开户行名称
    ,nvl(n.accptor_cate_cd, o.accptor_cate_cd) as accptor_cate_cd -- 承兑人类别代码
    ,nvl(n.accptor_name, o.accptor_name) as accptor_name -- 承兑人名称
    ,nvl(n.accptor_open_bank_num, o.accptor_open_bank_num) as accptor_open_bank_num -- 承兑人开户行号
    ,nvl(n.accptor_acct_num, o.accptor_acct_num) as accptor_acct_num -- 承兑人账号
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 收款人名称
    ,nvl(n.recver_acct_num, o.recver_acct_num) as recver_acct_num -- 收款人账号
    ,nvl(n.recver_open_bank_num, o.recver_open_bank_num) as recver_open_bank_num -- 收款人开户行号
    ,nvl(n.recver_open_bank_name, o.recver_open_bank_name) as recver_open_bank_name -- 收款人开户行名称
    ,nvl(n.bill_amt, o.bill_amt) as bill_amt -- 票据金额
    ,nvl(n.bill_belong_org_id, o.bill_belong_org_id) as bill_belong_org_id -- 票据所属机构编号
    ,nvl(n.bill_status_cd, o.bill_status_cd) as bill_status_cd -- 票据状态代码
    ,nvl(n.loss_flg, o.loss_flg) as loss_flg -- 挂失标志
    ,nvl(n.final_modif_operr_id, o.final_modif_operr_id) as final_modif_operr_id -- 最后修改操作员编号
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,nvl(n.receipt_flg, o.receipt_flg) as receipt_flg -- 小票标志
    ,nvl(n.redcst_flg, o.redcst_flg) as redcst_flg -- 再贴现标志
    ,nvl(n.h_data_flg, o.h_data_flg) as h_data_flg -- 历史数据标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.vouch_id is null
                and o.lp_id is null
            ) or (
                o.bill_id <> n.bill_id
                or o.bill_num <> n.bill_num
                or o.role_src_cd <> n.role_src_cd
                or o.discnt_batch_id <> n.discnt_batch_id
                or o.pbc_tranbl_flg <> n.pbc_tranbl_flg
                or o.hxb_acpt_flg <> n.hxb_acpt_flg
                or o.bill_med_cd <> n.bill_med_cd
                or o.bill_type_cd <> n.bill_type_cd
                or o.draw_dt <> n.draw_dt
                or o.fac_val_exp_dt <> n.fac_val_exp_dt
                or o.drawer_cate_cd <> n.drawer_cate_cd
                or o.drawer_orgnz_cd <> n.drawer_orgnz_cd
                or o.drawer_name <> n.drawer_name
                or o.drawer_acct_num <> n.drawer_acct_num
                or o.drawer_open_bank_num <> n.drawer_open_bank_num
                or o.accptor_open_bank_name <> n.accptor_open_bank_name
                or o.drawer_open_bank_name <> n.drawer_open_bank_name
                or o.accptor_cate_cd <> n.accptor_cate_cd
                or o.accptor_name <> n.accptor_name
                or o.accptor_open_bank_num <> n.accptor_open_bank_num
                or o.accptor_acct_num <> n.accptor_acct_num
                or o.recver_name <> n.recver_name
                or o.recver_acct_num <> n.recver_acct_num
                or o.recver_open_bank_num <> n.recver_open_bank_num
                or o.recver_open_bank_name <> n.recver_open_bank_name
                or o.bill_amt <> n.bill_amt
                or o.bill_belong_org_id <> n.bill_belong_org_id
                or o.bill_status_cd <> n.bill_status_cd
                or o.loss_flg <> n.loss_flg
                or o.final_modif_operr_id <> n.final_modif_operr_id
                or o.final_modif_tm <> n.final_modif_tm
                or o.receipt_flg <> n.receipt_flg
                or o.redcst_flg <> n.redcst_flg
                or o.h_data_flg <> n.h_data_flg
            ) or (
                 case when (
                           n.vouch_id is null
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
                n.vouch_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_info_bdmsf1_tm n
    full join ${iml_schema}.agt_bill_info_bdmsf1_bk o
        on
            o.vouch_id = n.vouch_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_bill_info truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_bill_info exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_bill_info_bdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_bill_info drop subpartition p_bdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bill_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_bill_info_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_info_bdmsf1_ex purge;
drop table ${iml_schema}.agt_bill_info_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bill_info', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);