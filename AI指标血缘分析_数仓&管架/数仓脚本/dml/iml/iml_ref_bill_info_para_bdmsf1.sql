/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_bill_info_para_bdmsf1
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
drop table ${iml_schema}.ref_bill_info_para_bdmsf1_tm purge;
drop table ${iml_schema}.ref_bill_info_para_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ref_bill_info_para add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_bill_info_para modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_bill_info_para_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_bill_info_para partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_bill_info_para_bdmsf1_tm
compress ${option_switch} for query high
as
select
    bill_id -- 票据编号
    ,lp_id -- 法人编号
    ,bill_num -- 票据号码
    ,bill_lev_ctrl_flg -- 票据级别控制标志
    ,role_src_cd -- 角色来源代码
    ,discnt_batch_id -- 贴现批次编号
    ,pbc_tranbl_flg -- 人行可转让标志
    ,hxb_acpt_flg -- 我行承兑标志
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,fac_val_exp_dt -- 票面到期日期
    ,cust_id -- 客户编号
    ,drawer_cate_cd -- 出票人类别代码
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_open_bank_num -- 出票人开户行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_name -- 承兑人名称
    ,accptor_open_bank_num -- 承兑人开户行号
    ,accptor_acct_num -- 承兑人账号
    ,recver_name -- 收款人名称
    ,recver_acct_num -- 收款人账号
    ,recver_open_bank_num -- 收款人开户行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,bill_amt -- 票据金额
    ,sys_in_acpt_flg -- 系统内承兑标志
    ,bill_belong_org_id -- 票据所属机构编号
    ,bill_invtry_status_cd -- 票据库存状态代码
    ,bill_status_cd -- 票据状态代码
    ,proc_mdl_status_cd -- 处理中状态代码
    ,inpwn_status_cd -- 质押状态代码
    ,inpwn_rgst_b_id -- 质押登记簿编号
    ,loss_status_cd -- 挂失状态代码
    ,loss_rgst_b_id -- 挂失登记簿编号
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,drawer_crdt_level_cd -- 出票人信用等级代码
    ,drawer_rating_org_id -- 出票人评级机构编号
    ,drawer_rating_exp_dt -- 出票人评级到期日期
    ,recv_bank_name -- 收款行名称
    ,cpes_acpt_rgst_status_flg -- 票交所承兑登记状态标志
    ,cpes_discnt_rgst_status_flg -- 票交所贴现登记状态标志
    ,drawer_unify_soci_crdt_cd -- 出票人统一社会信用代码
    ,payoff_flg -- 结清标志
    ,receipt_flg -- 小票标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_bill_info_para
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ref_bill_info_para_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ref_bill_info_para partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_draft_info-
insert into ${iml_schema}.ref_bill_info_para_bdmsf1_tm(
    bill_id -- 票据编号
    ,lp_id -- 法人编号
    ,bill_num -- 票据号码
    ,bill_lev_ctrl_flg -- 票据级别控制标志
    ,role_src_cd -- 角色来源代码
    ,discnt_batch_id -- 贴现批次编号
    ,pbc_tranbl_flg -- 人行可转让标志
    ,hxb_acpt_flg -- 我行承兑标志
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,fac_val_exp_dt -- 票面到期日期
    ,cust_id -- 客户编号
    ,drawer_cate_cd -- 出票人类别代码
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_open_bank_num -- 出票人开户行号
    ,drawer_open_bank_name -- 承兑人开户行名称
    ,accptor_name -- 出票人开户行名称
    ,accptor_open_bank_num -- 承兑人名称
    ,accptor_open_bank_name -- 承兑人开户行号
    ,accptor_acct_num -- 承兑人账号
    ,recver_name -- 收款人名称
    ,recver_acct_num -- 收款人账号
    ,recver_open_bank_num -- 收款人开户行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,bill_amt -- 票据金额
    ,sys_in_acpt_flg -- 系统内承兑标志
    ,bill_belong_org_id -- 票据所属机构编号
    ,bill_invtry_status_cd -- 票据库存状态代码
    ,bill_status_cd -- 票据状态代码
    ,proc_mdl_status_cd -- 处理中状态代码
    ,inpwn_status_cd -- 质押状态代码
    ,inpwn_rgst_b_id -- 质押登记簿编号
    ,loss_status_cd -- 挂失状态代码
    ,loss_rgst_b_id -- 挂失登记簿编号
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,drawer_crdt_level_cd -- 出票人信用等级代码
    ,drawer_rating_org_id -- 出票人评级机构编号
    ,drawer_rating_exp_dt -- 出票人评级到期日期
    ,recv_bank_name -- 收款行名称
    ,cpes_acpt_rgst_status_flg -- 票交所承兑登记状态标志
    ,cpes_discnt_rgst_status_flg -- 票交所贴现登记状态标志
    ,drawer_unify_soci_crdt_cd -- 出票人统一社会信用代码
    ,payoff_flg -- 结清标志
    ,receipt_flg -- 小票标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    TO_CHAR(P1.ID) -- 票据编号
    ,'9999' -- 法人编号
    ,P1.DRAFT_NUMBER -- 票据号码
    ,P1.DFCLS_CTL -- 票据级别控制标志
    ,NVL(TRIM(P1.SRC_TYPE),'00') -- 角色来源代码
    ,TO_CHAR(P1.BUY_CONTRACT_ID) -- 贴现批次编号
    ,P1.END_OR_SEMENT_MK -- 人行可转让标志
    ,CASE WHEN (P1.DRAFT_TYPE='1' and P8.ubank_no IS NOT NULL) THEN '1' ELSE '0' END  -- 我行承兑标志
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DRAFT_ATTR END -- 票据介质代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DRAFT_TYPE END -- 票据类型代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.REMIT_DATE) -- 出票日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.MATURITY_DATE) -- 票面到期日期
    ,NVL(P2.CUST_NO,' ') -- 客户编号
    ,NVL(TRIM(P1.REMITTER_ROLE),'-') -- 出票人类别代码
    ,P1.REMITTER_CMONID -- 出票人组织机构代码
    ,P1.REMITTER_NAME -- 出票人名称
    ,P1.REMITTER_ACCOUNT -- 出票人账号
    ,NVL(TRIM(P3.UBANK_NO),' ') -- 出票人开户行号
    ,P1.REMITTER_BANK_NAME -- 承兑人开户行名称
    ,P1.ACCEPTOR -- 出票人开户行名称
    ,NVL(TRIM(P4.UBANK_NO),' ') -- 承兑人名称
    ,P1.ACCEPTOR_BANK_NAME -- 承兑人开户行号
    ,P1.ACCEPTOR_ACTNO -- 承兑人账号
    ,P1.PAYEE_NAME -- 收款人名称
    ,P1.PAYEE_ACCOUNT -- 收款人账号
    ,NVL(TRIM(P5.UBANK_NO),' ') -- 收款人开户行号
    ,P1.PAYEE_BANK_NAME -- 收款人开户行名称
    ,P1.FACE_AMOUNT -- 票据金额
    ,P1.DRAWER_BANK_FLAG -- 系统内承兑标志
    ,NVL(TRIM(P6.BRH_NO),' ') -- 票据所属机构编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.STORE_STATUS END -- 票据库存状态代码
    ,NVL(TRIM(P1.STATUS),'00') -- 票据状态代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.TMP_STATUS END -- 处理中状态代码
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.COLLZTN_STATUS END -- 质押状态代码
    ,TO_CHAR(P1.COLLZTN_ID) -- 质押登记簿编号
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.LOSS_STATUS END -- 挂失状态代码
    ,TO_CHAR(P1.RPLOSS_ID) -- 挂失登记簿编号
    ,NVL(TRIM(P7.OPR_NO),' ') -- 最后修改操作员编号
    ,to_timestamp(to_char(${iml_schema}.dateformat_max(P1.LAST_UPD_TIME),'yyyy/mm/dd HH24:MI:SS'),'yyyy/mm/dd HH24:MI:SS.FF6') -- 最后修改时间
    ,NVL(TRIM(P1.DF_DRWR_CDTRATGS),'-') -- 出票人信用等级代码
    ,P1.DF_DRWR_CDTRATGSAGCY -- 出票人评级机构编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.DF_DRWR_CDTRATGDUEDT) -- 出票人评级到期日期
    ,P1.PAYEE_BANK_NO -- 收款行名称
    ,P1.ACCEPT_FLAG -- 票交所承兑登记状态标志
    ,P1.DISCOUNT_FLAG -- 票交所贴现登记状态标志
    ,P1.REMITTER_CODE -- 出票人统一社会信用代码
    ,P1.SETTLE_FLAG -- 结清标志
    ,P1.IS_RECEIPT -- 小票标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_draft_info' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_draft_info p1
    left join ${iol_schema}.bdms_union_bank p3 on P1.REMITTER_BANK_ID=P3.ID AND P3.START_DT <= TO_DATE('${batch_date}','yyyymmdd') and P3.END_DT > TO_DATE('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_union_bank p4 on P1.ACCEPTOR_BANK_ID=P4.ID AND P4.START_DT <= TO_DATE('${batch_date}','yyyymmdd') and P4.END_DT > TO_DATE('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_union_bank p5 on P1.PAYEE_BANK_ID=P5.ID AND P5.START_DT <= TO_DATE('${batch_date}','yyyymmdd') and P5.END_DT > TO_DATE('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_branch_info p6 on P1.BELONG_BRANCH_ID=P6.ID AND P6.START_DT <= TO_DATE('${batch_date}','yyyymmdd') and P6.END_DT > TO_DATE('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_operator p7 on P1.LAST_UPD_OPER_ID=P7.ID AND P7.START_DT <= TO_DATE('${batch_date}','yyyymmdd') and P7.END_DT > TO_DATE('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_union_bank p8 on P1.ACCEPTOR_BANK_ID=P8.id AND P8.START_DT <= TO_DATE('${batch_date}','yyyymmdd') and P8.END_DT > TO_DATE('${batch_date}','yyyymmdd') AND P8.drct = '313586000006'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DRAFT_ATTR = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_DRAFT_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'DRAFT_ATTR'
        AND R1.TARGET_TAB_EN_NAME= 'REF_BILL_INFO_PARA'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BILL_MED_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DRAFT_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_DRAFT_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'DRAFT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'REF_BILL_INFO_PARA'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BILL_TYPE_CD'
    left join ${iol_schema}.bdms_customer_info p2 on TO_CHAR(P1.REMITTER_ID)=TO_CHAR(P2.ID)  AND P2.START_DT <= TO_DATE('${batch_date}','yyyymmdd') and P2.END_DT > TO_DATE('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.STORE_STATUS = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_DRAFT_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'STORE_STATUS'
        AND R3.TARGET_TAB_EN_NAME= 'REF_BILL_INFO_PARA'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'BILL_INVTRY_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.TMP_STATUS = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'BDMS'
        AND R5.SRC_TAB_EN_NAME= 'BDMS_DRAFT_INFO'
        AND R5.SRC_FIELD_EN_NAME= 'TMP_STATUS'
        AND R5.TARGET_TAB_EN_NAME= 'REF_BILL_INFO_PARA'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'PROC_MDL_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.COLLZTN_STATUS = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'BDMS'
        AND R6.SRC_TAB_EN_NAME= 'BDMS_DRAFT_INFO'
        AND R6.SRC_FIELD_EN_NAME= 'COLLZTN_STATUS'
        AND R6.TARGET_TAB_EN_NAME= 'REF_BILL_INFO_PARA'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'INPWN_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.LOSS_STATUS = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'BDMS'
        AND R7.SRC_TAB_EN_NAME= 'BDMS_DRAFT_INFO'
        AND R7.SRC_FIELD_EN_NAME= 'LOSS_STATUS'
        AND R7.TARGET_TAB_EN_NAME= 'REF_BILL_INFO_PARA'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'LOSS_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.ref_bill_info_para_bdmsf1_ex(
    bill_id -- 票据编号
    ,lp_id -- 法人编号
    ,bill_num -- 票据号码
    ,bill_lev_ctrl_flg -- 票据级别控制标志
    ,role_src_cd -- 角色来源代码
    ,discnt_batch_id -- 贴现批次编号
    ,pbc_tranbl_flg -- 人行可转让标志
    ,hxb_acpt_flg -- 我行承兑标志
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,draw_dt -- 出票日期
    ,fac_val_exp_dt -- 票面到期日期
    ,cust_id -- 客户编号
    ,drawer_cate_cd -- 出票人类别代码
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_name -- 出票人名称
    ,drawer_acct_num -- 出票人账号
    ,drawer_open_bank_num -- 出票人开户行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_name -- 承兑人名称
    ,accptor_open_bank_num -- 承兑人开户行号
    ,accptor_acct_num -- 承兑人账号
    ,recver_name -- 收款人名称
    ,recver_acct_num -- 收款人账号
    ,recver_open_bank_num -- 收款人开户行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,bill_amt -- 票据金额
    ,sys_in_acpt_flg -- 系统内承兑标志
    ,bill_belong_org_id -- 票据所属机构编号
    ,bill_invtry_status_cd -- 票据库存状态代码
    ,bill_status_cd -- 票据状态代码
    ,proc_mdl_status_cd -- 处理中状态代码
    ,inpwn_status_cd -- 质押状态代码
    ,inpwn_rgst_b_id -- 质押登记簿编号
    ,loss_status_cd -- 挂失状态代码
    ,loss_rgst_b_id -- 挂失登记簿编号
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,drawer_crdt_level_cd -- 出票人信用等级代码
    ,drawer_rating_org_id -- 出票人评级机构编号
    ,drawer_rating_exp_dt -- 出票人评级到期日期
    ,recv_bank_name -- 收款行名称
    ,cpes_acpt_rgst_status_flg -- 票交所承兑登记状态标志
    ,cpes_discnt_rgst_status_flg -- 票交所贴现登记状态标志
    ,drawer_unify_soci_crdt_cd -- 出票人统一社会信用代码
    ,payoff_flg -- 结清标志
    ,receipt_flg -- 小票标志
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,nvl(n.bill_lev_ctrl_flg, o.bill_lev_ctrl_flg) as bill_lev_ctrl_flg -- 票据级别控制标志
    ,nvl(n.role_src_cd, o.role_src_cd) as role_src_cd -- 角色来源代码
    ,nvl(n.discnt_batch_id, o.discnt_batch_id) as discnt_batch_id -- 贴现批次编号
    ,nvl(n.pbc_tranbl_flg, o.pbc_tranbl_flg) as pbc_tranbl_flg -- 人行可转让标志
    ,nvl(n.hxb_acpt_flg, o.hxb_acpt_flg) as hxb_acpt_flg -- 我行承兑标志
    ,nvl(n.bill_med_cd, o.bill_med_cd) as bill_med_cd -- 票据介质代码
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.draw_dt, o.draw_dt) as draw_dt -- 出票日期
    ,nvl(n.fac_val_exp_dt, o.fac_val_exp_dt) as fac_val_exp_dt -- 票面到期日期
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.drawer_cate_cd, o.drawer_cate_cd) as drawer_cate_cd -- 出票人类别代码
    ,nvl(n.drawer_orgnz_cd, o.drawer_orgnz_cd) as drawer_orgnz_cd -- 出票人组织机构代码
    ,nvl(n.drawer_name, o.drawer_name) as drawer_name -- 出票人名称
    ,nvl(n.drawer_acct_num, o.drawer_acct_num) as drawer_acct_num -- 出票人账号
    ,nvl(n.drawer_open_bank_num, o.drawer_open_bank_num) as drawer_open_bank_num -- 出票人开户行号
    ,nvl(n.accptor_open_bank_name, o.accptor_open_bank_name) as accptor_open_bank_name -- 承兑人开户行名称
    ,nvl(n.drawer_open_bank_name, o.drawer_open_bank_name) as drawer_open_bank_name -- 出票人开户行名称
    ,nvl(n.accptor_name, o.accptor_name) as accptor_name -- 承兑人名称
    ,nvl(n.accptor_open_bank_num, o.accptor_open_bank_num) as accptor_open_bank_num -- 承兑人开户行号
    ,nvl(n.accptor_acct_num, o.accptor_acct_num) as accptor_acct_num -- 承兑人账号
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 收款人名称
    ,nvl(n.recver_acct_num, o.recver_acct_num) as recver_acct_num -- 收款人账号
    ,nvl(n.recver_open_bank_num, o.recver_open_bank_num) as recver_open_bank_num -- 收款人开户行号
    ,nvl(n.recver_open_bank_name, o.recver_open_bank_name) as recver_open_bank_name -- 收款人开户行名称
    ,nvl(n.bill_amt, o.bill_amt) as bill_amt -- 票据金额
    ,nvl(n.sys_in_acpt_flg, o.sys_in_acpt_flg) as sys_in_acpt_flg -- 系统内承兑标志
    ,nvl(n.bill_belong_org_id, o.bill_belong_org_id) as bill_belong_org_id -- 票据所属机构编号
    ,nvl(n.bill_invtry_status_cd, o.bill_invtry_status_cd) as bill_invtry_status_cd -- 票据库存状态代码
    ,nvl(n.bill_status_cd, o.bill_status_cd) as bill_status_cd -- 票据状态代码
    ,nvl(n.proc_mdl_status_cd, o.proc_mdl_status_cd) as proc_mdl_status_cd -- 处理中状态代码
    ,nvl(n.inpwn_status_cd, o.inpwn_status_cd) as inpwn_status_cd -- 质押状态代码
    ,nvl(n.inpwn_rgst_b_id, o.inpwn_rgst_b_id) as inpwn_rgst_b_id -- 质押登记簿编号
    ,nvl(n.loss_status_cd, o.loss_status_cd) as loss_status_cd -- 挂失状态代码
    ,nvl(n.loss_rgst_b_id, o.loss_rgst_b_id) as loss_rgst_b_id -- 挂失登记簿编号
    ,nvl(n.final_modif_operr_id, o.final_modif_operr_id) as final_modif_operr_id -- 最后修改操作员编号
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,nvl(n.drawer_crdt_level_cd, o.drawer_crdt_level_cd) as drawer_crdt_level_cd -- 出票人信用等级代码
    ,nvl(n.drawer_rating_org_id, o.drawer_rating_org_id) as drawer_rating_org_id -- 出票人评级机构编号
    ,nvl(n.drawer_rating_exp_dt, o.drawer_rating_exp_dt) as drawer_rating_exp_dt -- 出票人评级到期日期
    ,nvl(n.recv_bank_name, o.recv_bank_name) as recv_bank_name -- 收款行名称
    ,nvl(n.cpes_acpt_rgst_status_flg, o.cpes_acpt_rgst_status_flg) as cpes_acpt_rgst_status_flg -- 票交所承兑登记状态标志
    ,nvl(n.cpes_discnt_rgst_status_flg, o.cpes_discnt_rgst_status_flg) as cpes_discnt_rgst_status_flg -- 票交所贴现登记状态标志
    ,nvl(n.drawer_unify_soci_crdt_cd, o.drawer_unify_soci_crdt_cd) as drawer_unify_soci_crdt_cd -- 出票人统一社会信用代码
    ,nvl(n.payoff_flg, o.payoff_flg) as payoff_flg -- 结清标志
    ,nvl(n.receipt_flg, o.receipt_flg) as receipt_flg -- 小票标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.bill_id is null
                and o.lp_id is null
            ) or (
                o.bill_num <> n.bill_num
                or o.bill_lev_ctrl_flg <> n.bill_lev_ctrl_flg
                or o.role_src_cd <> n.role_src_cd
                or o.discnt_batch_id <> n.discnt_batch_id
                or o.pbc_tranbl_flg <> n.pbc_tranbl_flg
                or o.hxb_acpt_flg <> n.hxb_acpt_flg
                or o.bill_med_cd <> n.bill_med_cd
                or o.bill_type_cd <> n.bill_type_cd
                or o.draw_dt <> n.draw_dt
                or o.fac_val_exp_dt <> n.fac_val_exp_dt
                or o.cust_id <> n.cust_id
                or o.drawer_cate_cd <> n.drawer_cate_cd
                or o.drawer_orgnz_cd <> n.drawer_orgnz_cd
                or o.drawer_name <> n.drawer_name
                or o.drawer_acct_num <> n.drawer_acct_num
                or o.drawer_open_bank_num <> n.drawer_open_bank_num
                or o.accptor_open_bank_name <> n.accptor_open_bank_name
                or o.drawer_open_bank_name <> n.drawer_open_bank_name
                or o.accptor_name <> n.accptor_name
                or o.accptor_open_bank_num <> n.accptor_open_bank_num
                or o.accptor_acct_num <> n.accptor_acct_num
                or o.recver_name <> n.recver_name
                or o.recver_acct_num <> n.recver_acct_num
                or o.recver_open_bank_num <> n.recver_open_bank_num
                or o.recver_open_bank_name <> n.recver_open_bank_name
                or o.bill_amt <> n.bill_amt
                or o.sys_in_acpt_flg <> n.sys_in_acpt_flg
                or o.bill_belong_org_id <> n.bill_belong_org_id
                or o.bill_invtry_status_cd <> n.bill_invtry_status_cd
                or o.bill_status_cd <> n.bill_status_cd
                or o.proc_mdl_status_cd <> n.proc_mdl_status_cd
                or o.inpwn_status_cd <> n.inpwn_status_cd
                or o.inpwn_rgst_b_id <> n.inpwn_rgst_b_id
                or o.loss_status_cd <> n.loss_status_cd
                or o.loss_rgst_b_id <> n.loss_rgst_b_id
                or o.final_modif_operr_id <> n.final_modif_operr_id
                or o.final_modif_tm <> n.final_modif_tm
                or o.drawer_crdt_level_cd <> n.drawer_crdt_level_cd
                or o.drawer_rating_org_id <> n.drawer_rating_org_id
                or o.drawer_rating_exp_dt <> n.drawer_rating_exp_dt
                or o.recv_bank_name <> n.recv_bank_name
                or o.cpes_acpt_rgst_status_flg <> n.cpes_acpt_rgst_status_flg
                or o.cpes_discnt_rgst_status_flg <> n.cpes_discnt_rgst_status_flg
                or o.drawer_unify_soci_crdt_cd <> n.drawer_unify_soci_crdt_cd
                or o.payoff_flg <> n.payoff_flg
                or o.receipt_flg <> n.receipt_flg
            )
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.bill_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_bill_info_para_bdmsf1_tm n
    full join ${iml_schema}.ref_bill_info_para_bdmsf1_bk o
        on
            o.bill_id = n.bill_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_bill_info_para truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ref_bill_info_para exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.ref_bill_info_para_bdmsf1_ex;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_bill_info_para to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_bill_info_para_bdmsf1_tm purge;
drop table ${iml_schema}.ref_bill_info_para_bdmsf1_ex purge;
drop table ${iml_schema}.ref_bill_info_para_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_bill_info_para', partname => 'p_bdmsf1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);