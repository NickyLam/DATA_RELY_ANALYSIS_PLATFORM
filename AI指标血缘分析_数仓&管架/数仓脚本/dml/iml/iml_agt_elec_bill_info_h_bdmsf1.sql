/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_elec_bill_info_h_bdmsf1
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
alter table ${iml_schema}.agt_elec_bill_info_h add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_elec_bill_info_h_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_elec_bill_info_h partition for ('bdmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_elec_bill_info_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_elec_bill_info_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_elec_bill_info_h_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_elec_bill_info_h_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    bill_id -- 票据编号
    ,lp_id -- 法人编号
    ,bill_type_cd -- 票据类型代码
    ,bill_num -- 票据号码
    ,bill_amt -- 贴现票据金额
    ,tran_flow_num -- 交易编号
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,tran_cd -- 转让代码
    ,drawer_cate_cd -- 出票人类别代码
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_name -- 出票人名称
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_open_bank_no -- 收款人开户行行号
    ,accptor_cate_cd -- 承兑人类别代码
    ,accptor_orgnz_cd -- 承兑人组织机构代码
    ,accptor_name -- 承兑人名称
    ,accptor_acct_id -- 承兑人账户编号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,bill_obg_cate_cd -- 票据权利人类别代码
    ,bill_obg_orgnz_cd -- 票据权利人组织机构代码
    ,bill_obg_name -- 票据权利人名称
    ,bill_obg_acct_id -- 票据权利人账户编号
    ,bill_obg_open_bank_no -- 票据权利人开户行行号
    ,bill_last_status_cd -- 票据上一状态代码
    ,bill_send_ps_status_cd -- 票据发送人状态代码
    ,bill_recv_ps_status_cd -- 票据接收人状态代码
    ,create_tm -- 创建时间
    ,lock_flg -- 锁定标志
    ,curr_status_cd -- 当前状态代码
    ,recs_type_cd -- 追索类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_elec_bill_info_h partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.agt_elec_bill_info_h_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_elec_bill_info_h partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.agt_elec_bill_info_h_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_elec_bill_info_h partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_bms_e_draft_info-
insert into ${iml_schema}.agt_elec_bill_info_h_bdmsf1_tm(
    bill_id -- 票据编号
    ,lp_id -- 法人编号
    ,bill_type_cd -- 票据类型代码
    ,bill_num -- 票据号码
    ,bill_amt -- 贴现票据金额
    ,tran_flow_num -- 交易编号
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,tran_cd -- 转让代码
    ,drawer_cate_cd -- 出票人类别代码
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_name -- 出票人名称
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_open_bank_no -- 收款人开户行行号
    ,accptor_cate_cd -- 承兑人类别代码
    ,accptor_orgnz_cd -- 承兑人组织机构代码
    ,accptor_name -- 承兑人名称
    ,accptor_acct_id -- 承兑人账户编号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,bill_obg_cate_cd -- 票据权利人类别代码
    ,bill_obg_orgnz_cd -- 票据权利人组织机构代码
    ,bill_obg_name -- 票据权利人名称
    ,bill_obg_acct_id -- 票据权利人账户编号
    ,bill_obg_open_bank_no -- 票据权利人开户行行号
    ,bill_last_status_cd -- 票据上一状态代码
    ,bill_send_ps_status_cd -- 票据发送人状态代码
    ,bill_recv_ps_status_cd -- 票据接收人状态代码
    ,create_tm -- 创建时间
    ,lock_flg -- 锁定标志
    ,curr_status_cd -- 当前状态代码
    ,recs_type_cd -- 追索类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 票据编号
    ,'9999' -- 法人编号
    ,nvl(trim(P1.DRAFT_TYPE),'-') -- 票据类型代码
    ,P1.ELECTRIC_DRAFT_ID -- 票据号码
    ,P1.DRAFT_AMOUNT -- 贴现票据金额
    ,P1.TRANS_ID -- 交易编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.REMIT_DATE) -- 出票日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.MATURITY_DATE) -- 到期日期
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.TRANSFER_FLAG END -- 转让代码
    ,nvl(trim(P1.REMITTER_TYPE),'-') -- 出票人类别代码
    ,P1.REMITTER_BRCH_CODE -- 出票人组织机构代码
    ,P1.REMITTER_NAME -- 出票人名称
    ,P1.REMITTER_ACCOUNT -- 出票人账户编号
    ,P1.REMITTER_BANK_ID -- 出票人开户行行号
    ,P1.PAYEE_NAME -- 收款人名称
    ,P1.PAYEE_ACCOUNT -- 收款人账户编号
    ,P1.PAYEE_BANK_ID -- 收款人开户行行号
    ,nvl(trim(P1.ACCEPTOR_TYPE),'-') -- 承兑人类别代码
    ,P1.ACCEPTOR_BRCH_CODE -- 承兑人组织机构代码
    ,P1.ACCEPTOR_NAME -- 承兑人名称
    ,P1.ACCEPTOR_ACCOUNT -- 承兑人账户编号
    ,P1.ACCEPTOR_BANK_ID -- 承兑人开户行行号
    ,nvl(trim(P1.OWNER_TYPE),'-') -- 票据权利人类别代码
    ,P1.OWNER_BRCH_CODE -- 票据权利人组织机构代码
    ,P1.OWNER_NAME -- 票据权利人名称
    ,P1.OWNER_ACCOUNT -- 票据权利人账户编号
    ,P1.OWNER_BANK_ID -- 票据权利人开户行行号
    ,NVL(TRIM(P1.DRAFT_ORG_STATUS),'-') -- 票据上一状态代码
    ,NVL(TRIM(P1.DRAFT_SND_STATUS),'-') -- 票据发送人状态代码
    ,NVL(TRIM(P1.DRAFT_RCV_STATUS),'-') -- 票据接收人状态代码
    ,${iml_schema}.timeformat_min(P1.REC_CRT_TS) -- 创建时间
    ,P1.LOCK_FLAG -- 锁定标志
    ,nvl(trim(P1.CURRENT_STATUS),'-') -- 当前状态代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.RCRSTP END -- 追索类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_e_draft_info' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_e_draft_info p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.TRANSFER_FLAG = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_BMS_E_DRAFT_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'TRANSFER_FLAG'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_ELEC_BILL_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.RCRSTP = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_BMS_E_DRAFT_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'RCRSTP'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_ELEC_BILL_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'RECS_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_elec_bill_info_h_bdmsf1_tm 
  	                                group by 
  	                                        bill_id
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
        into ${iml_schema}.agt_elec_bill_info_h_bdmsf1_cl(
            bill_id -- 票据编号
    ,lp_id -- 法人编号
    ,bill_type_cd -- 票据类型代码
    ,bill_num -- 票据号码
    ,bill_amt -- 贴现票据金额
    ,tran_flow_num -- 交易编号
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,tran_cd -- 转让代码
    ,drawer_cate_cd -- 出票人类别代码
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_name -- 出票人名称
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_open_bank_no -- 收款人开户行行号
    ,accptor_cate_cd -- 承兑人类别代码
    ,accptor_orgnz_cd -- 承兑人组织机构代码
    ,accptor_name -- 承兑人名称
    ,accptor_acct_id -- 承兑人账户编号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,bill_obg_cate_cd -- 票据权利人类别代码
    ,bill_obg_orgnz_cd -- 票据权利人组织机构代码
    ,bill_obg_name -- 票据权利人名称
    ,bill_obg_acct_id -- 票据权利人账户编号
    ,bill_obg_open_bank_no -- 票据权利人开户行行号
    ,bill_last_status_cd -- 票据上一状态代码
    ,bill_send_ps_status_cd -- 票据发送人状态代码
    ,bill_recv_ps_status_cd -- 票据接收人状态代码
    ,create_tm -- 创建时间
    ,lock_flg -- 锁定标志
    ,curr_status_cd -- 当前状态代码
    ,recs_type_cd -- 追索类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_elec_bill_info_h_bdmsf1_op(
            bill_id -- 票据编号
    ,lp_id -- 法人编号
    ,bill_type_cd -- 票据类型代码
    ,bill_num -- 票据号码
    ,bill_amt -- 贴现票据金额
    ,tran_flow_num -- 交易编号
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,tran_cd -- 转让代码
    ,drawer_cate_cd -- 出票人类别代码
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_name -- 出票人名称
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_open_bank_no -- 收款人开户行行号
    ,accptor_cate_cd -- 承兑人类别代码
    ,accptor_orgnz_cd -- 承兑人组织机构代码
    ,accptor_name -- 承兑人名称
    ,accptor_acct_id -- 承兑人账户编号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,bill_obg_cate_cd -- 票据权利人类别代码
    ,bill_obg_orgnz_cd -- 票据权利人组织机构代码
    ,bill_obg_name -- 票据权利人名称
    ,bill_obg_acct_id -- 票据权利人账户编号
    ,bill_obg_open_bank_no -- 票据权利人开户行行号
    ,bill_last_status_cd -- 票据上一状态代码
    ,bill_send_ps_status_cd -- 票据发送人状态代码
    ,bill_recv_ps_status_cd -- 票据接收人状态代码
    ,create_tm -- 创建时间
    ,lock_flg -- 锁定标志
    ,curr_status_cd -- 当前状态代码
    ,recs_type_cd -- 追索类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,nvl(n.bill_amt, o.bill_amt) as bill_amt -- 贴现票据金额
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易编号
    ,nvl(n.draw_dt, o.draw_dt) as draw_dt -- 出票日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.tran_cd, o.tran_cd) as tran_cd -- 转让代码
    ,nvl(n.drawer_cate_cd, o.drawer_cate_cd) as drawer_cate_cd -- 出票人类别代码
    ,nvl(n.drawer_orgnz_cd, o.drawer_orgnz_cd) as drawer_orgnz_cd -- 出票人组织机构代码
    ,nvl(n.drawer_name, o.drawer_name) as drawer_name -- 出票人名称
    ,nvl(n.drawer_acct_id, o.drawer_acct_id) as drawer_acct_id -- 出票人账户编号
    ,nvl(n.drawer_open_bank_no, o.drawer_open_bank_no) as drawer_open_bank_no -- 出票人开户行行号
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 收款人名称
    ,nvl(n.recver_acct_id, o.recver_acct_id) as recver_acct_id -- 收款人账户编号
    ,nvl(n.recver_open_bank_no, o.recver_open_bank_no) as recver_open_bank_no -- 收款人开户行行号
    ,nvl(n.accptor_cate_cd, o.accptor_cate_cd) as accptor_cate_cd -- 承兑人类别代码
    ,nvl(n.accptor_orgnz_cd, o.accptor_orgnz_cd) as accptor_orgnz_cd -- 承兑人组织机构代码
    ,nvl(n.accptor_name, o.accptor_name) as accptor_name -- 承兑人名称
    ,nvl(n.accptor_acct_id, o.accptor_acct_id) as accptor_acct_id -- 承兑人账户编号
    ,nvl(n.accptor_open_bank_no, o.accptor_open_bank_no) as accptor_open_bank_no -- 承兑人开户行行号
    ,nvl(n.bill_obg_cate_cd, o.bill_obg_cate_cd) as bill_obg_cate_cd -- 票据权利人类别代码
    ,nvl(n.bill_obg_orgnz_cd, o.bill_obg_orgnz_cd) as bill_obg_orgnz_cd -- 票据权利人组织机构代码
    ,nvl(n.bill_obg_name, o.bill_obg_name) as bill_obg_name -- 票据权利人名称
    ,nvl(n.bill_obg_acct_id, o.bill_obg_acct_id) as bill_obg_acct_id -- 票据权利人账户编号
    ,nvl(n.bill_obg_open_bank_no, o.bill_obg_open_bank_no) as bill_obg_open_bank_no -- 票据权利人开户行行号
    ,nvl(n.bill_last_status_cd, o.bill_last_status_cd) as bill_last_status_cd -- 票据上一状态代码
    ,nvl(n.bill_send_ps_status_cd, o.bill_send_ps_status_cd) as bill_send_ps_status_cd -- 票据发送人状态代码
    ,nvl(n.bill_recv_ps_status_cd, o.bill_recv_ps_status_cd) as bill_recv_ps_status_cd -- 票据接收人状态代码
    ,nvl(n.create_tm, o.create_tm) as create_tm -- 创建时间
    ,nvl(n.lock_flg, o.lock_flg) as lock_flg -- 锁定标志
    ,nvl(n.curr_status_cd, o.curr_status_cd) as curr_status_cd -- 当前状态代码
    ,nvl(n.recs_type_cd, o.recs_type_cd) as recs_type_cd -- 追索类型代码
    ,case when
            n.bill_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bill_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bill_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_elec_bill_info_h_bdmsf1_tm n
    full join (select * from ${iml_schema}.agt_elec_bill_info_h_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.bill_id = n.bill_id
            and o.lp_id = n.lp_id
where (
        o.bill_id is null
        and o.lp_id is null
    )
    or (
        n.bill_id is null
        and n.lp_id is null
    )
    or (
        o.bill_type_cd <> n.bill_type_cd
        or o.bill_num <> n.bill_num
        or o.bill_amt <> n.bill_amt
        or o.tran_flow_num <> n.tran_flow_num
        or o.draw_dt <> n.draw_dt
        or o.exp_dt <> n.exp_dt
        or o.tran_cd <> n.tran_cd
        or o.drawer_cate_cd <> n.drawer_cate_cd
        or o.drawer_orgnz_cd <> n.drawer_orgnz_cd
        or o.drawer_name <> n.drawer_name
        or o.drawer_acct_id <> n.drawer_acct_id
        or o.drawer_open_bank_no <> n.drawer_open_bank_no
        or o.recver_name <> n.recver_name
        or o.recver_acct_id <> n.recver_acct_id
        or o.recver_open_bank_no <> n.recver_open_bank_no
        or o.accptor_cate_cd <> n.accptor_cate_cd
        or o.accptor_orgnz_cd <> n.accptor_orgnz_cd
        or o.accptor_name <> n.accptor_name
        or o.accptor_acct_id <> n.accptor_acct_id
        or o.accptor_open_bank_no <> n.accptor_open_bank_no
        or o.bill_obg_cate_cd <> n.bill_obg_cate_cd
        or o.bill_obg_orgnz_cd <> n.bill_obg_orgnz_cd
        or o.bill_obg_name <> n.bill_obg_name
        or o.bill_obg_acct_id <> n.bill_obg_acct_id
        or o.bill_obg_open_bank_no <> n.bill_obg_open_bank_no
        or o.bill_last_status_cd <> n.bill_last_status_cd
        or o.bill_send_ps_status_cd <> n.bill_send_ps_status_cd
        or o.bill_recv_ps_status_cd <> n.bill_recv_ps_status_cd
        or o.create_tm <> n.create_tm
        or o.lock_flg <> n.lock_flg
        or o.curr_status_cd <> n.curr_status_cd
        or o.recs_type_cd <> n.recs_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_elec_bill_info_h_bdmsf1_cl(
            bill_id -- 票据编号
    ,lp_id -- 法人编号
    ,bill_type_cd -- 票据类型代码
    ,bill_num -- 票据号码
    ,bill_amt -- 贴现票据金额
    ,tran_flow_num -- 交易编号
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,tran_cd -- 转让代码
    ,drawer_cate_cd -- 出票人类别代码
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_name -- 出票人名称
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_open_bank_no -- 收款人开户行行号
    ,accptor_cate_cd -- 承兑人类别代码
    ,accptor_orgnz_cd -- 承兑人组织机构代码
    ,accptor_name -- 承兑人名称
    ,accptor_acct_id -- 承兑人账户编号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,bill_obg_cate_cd -- 票据权利人类别代码
    ,bill_obg_orgnz_cd -- 票据权利人组织机构代码
    ,bill_obg_name -- 票据权利人名称
    ,bill_obg_acct_id -- 票据权利人账户编号
    ,bill_obg_open_bank_no -- 票据权利人开户行行号
    ,bill_last_status_cd -- 票据上一状态代码
    ,bill_send_ps_status_cd -- 票据发送人状态代码
    ,bill_recv_ps_status_cd -- 票据接收人状态代码
    ,create_tm -- 创建时间
    ,lock_flg -- 锁定标志
    ,curr_status_cd -- 当前状态代码
    ,recs_type_cd -- 追索类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_elec_bill_info_h_bdmsf1_op(
            bill_id -- 票据编号
    ,lp_id -- 法人编号
    ,bill_type_cd -- 票据类型代码
    ,bill_num -- 票据号码
    ,bill_amt -- 贴现票据金额
    ,tran_flow_num -- 交易编号
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,tran_cd -- 转让代码
    ,drawer_cate_cd -- 出票人类别代码
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_name -- 出票人名称
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_open_bank_no -- 收款人开户行行号
    ,accptor_cate_cd -- 承兑人类别代码
    ,accptor_orgnz_cd -- 承兑人组织机构代码
    ,accptor_name -- 承兑人名称
    ,accptor_acct_id -- 承兑人账户编号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,bill_obg_cate_cd -- 票据权利人类别代码
    ,bill_obg_orgnz_cd -- 票据权利人组织机构代码
    ,bill_obg_name -- 票据权利人名称
    ,bill_obg_acct_id -- 票据权利人账户编号
    ,bill_obg_open_bank_no -- 票据权利人开户行行号
    ,bill_last_status_cd -- 票据上一状态代码
    ,bill_send_ps_status_cd -- 票据发送人状态代码
    ,bill_recv_ps_status_cd -- 票据接收人状态代码
    ,create_tm -- 创建时间
    ,lock_flg -- 锁定标志
    ,curr_status_cd -- 当前状态代码
    ,recs_type_cd -- 追索类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bill_id -- 票据编号
    ,o.lp_id -- 法人编号
    ,o.bill_type_cd -- 票据类型代码
    ,o.bill_num -- 票据号码
    ,o.bill_amt -- 贴现票据金额
    ,o.tran_flow_num -- 交易编号
    ,o.draw_dt -- 出票日期
    ,o.exp_dt -- 到期日期
    ,o.tran_cd -- 转让代码
    ,o.drawer_cate_cd -- 出票人类别代码
    ,o.drawer_orgnz_cd -- 出票人组织机构代码
    ,o.drawer_name -- 出票人名称
    ,o.drawer_acct_id -- 出票人账户编号
    ,o.drawer_open_bank_no -- 出票人开户行行号
    ,o.recver_name -- 收款人名称
    ,o.recver_acct_id -- 收款人账户编号
    ,o.recver_open_bank_no -- 收款人开户行行号
    ,o.accptor_cate_cd -- 承兑人类别代码
    ,o.accptor_orgnz_cd -- 承兑人组织机构代码
    ,o.accptor_name -- 承兑人名称
    ,o.accptor_acct_id -- 承兑人账户编号
    ,o.accptor_open_bank_no -- 承兑人开户行行号
    ,o.bill_obg_cate_cd -- 票据权利人类别代码
    ,o.bill_obg_orgnz_cd -- 票据权利人组织机构代码
    ,o.bill_obg_name -- 票据权利人名称
    ,o.bill_obg_acct_id -- 票据权利人账户编号
    ,o.bill_obg_open_bank_no -- 票据权利人开户行行号
    ,o.bill_last_status_cd -- 票据上一状态代码
    ,o.bill_send_ps_status_cd -- 票据发送人状态代码
    ,o.bill_recv_ps_status_cd -- 票据接收人状态代码
    ,o.create_tm -- 创建时间
    ,o.lock_flg -- 锁定标志
    ,o.curr_status_cd -- 当前状态代码
    ,o.recs_type_cd -- 追索类型代码
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
from ${iml_schema}.agt_elec_bill_info_h_bdmsf1_bk o
    left join ${iml_schema}.agt_elec_bill_info_h_bdmsf1_op n
        on
            o.bill_id = n.bill_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_elec_bill_info_h_bdmsf1_cl d
        on
            o.bill_id = d.bill_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_elec_bill_info_h;
--alter table ${iml_schema}.agt_elec_bill_info_h truncate partition for ('bdmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_elec_bill_info_h') 
               and substr(subpartition_name,1,8)=upper('p_bdmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_elec_bill_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_elec_bill_info_h modify partition p_bdmsf1 
add subpartition p_bdmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_elec_bill_info_h exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_elec_bill_info_h_bdmsf1_cl;
alter table ${iml_schema}.agt_elec_bill_info_h exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.agt_elec_bill_info_h_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_elec_bill_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_elec_bill_info_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_elec_bill_info_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_elec_bill_info_h_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_elec_bill_info_h_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_elec_bill_info_h', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
