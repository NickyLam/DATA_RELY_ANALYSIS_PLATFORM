/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_send_collection_dtls
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.bdps_send_collection_dtls_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_send_collection_dtls
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_send_collection_dtls_op purge;
drop table ${iol_schema}.bdps_send_collection_dtls_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_send_collection_dtls_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_send_collection_dtls where 0=1;

create table ${iol_schema}.bdps_send_collection_dtls_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_send_collection_dtls where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_send_collection_dtls_cl(
            id -- 
            ,batch_id -- 
            ,src_type -- 
            ,branch_id -- 
            ,send_date -- 
            ,draft_id -- 
            ,isse_curcd -- 
            ,isse_amt -- 
            ,drft_hldr_cmonid -- 
            ,apply_amt -- 
            ,mesg_type -- 
            ,sttlm_mk -- 
            ,drft_hldr_role -- 
            ,apply_date -- 
            ,ovrdue_rsn -- 
            ,apply_curcd -- 
            ,drft_hldr_name -- 
            ,drft_hldr_actno -- 
            ,drft_hldr_ubank -- 
            ,drft_hldr_agcy_ubank -- 
            ,req_remark -- 
            ,req_prxy_prop_stn -- 
            ,rcv_remark -- 
            ,rcv_prxy_sgntr -- 
            ,prompt_status -- 
            ,endst_date -- 
            ,cancel_date -- 
            ,cancel_opid -- 
            ,receive_date -- 
            ,sig_mk -- 
            ,dish_code -- 
            ,dish_rsn -- 
            ,cm_status -- 
            ,cm_err_procd -- 
            ,ecds_prc_msg -- 
            ,account_date -- 
            ,account_flag -- 
            ,actlog_id -- 
            ,swt_biz_id -- 
            ,trf_ref -- 
            ,trf_id -- 
            ,entity_regstat -- 
            ,entity_reg_id -- 
            ,misc -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,cancel_flag -- 
            ,branch_id_opt -- 
            ,ebank_pool_id -- 
            ,fee -- 
            ,rcv_back_id -- 
            ,refid -- 
            ,virtual_account_no -- 
            ,is_problem_draft -- 
            ,return_cash_account -- 回款账户
            ,serino -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_send_collection_dtls_op(
            id -- 
            ,batch_id -- 
            ,src_type -- 
            ,branch_id -- 
            ,send_date -- 
            ,draft_id -- 
            ,isse_curcd -- 
            ,isse_amt -- 
            ,drft_hldr_cmonid -- 
            ,apply_amt -- 
            ,mesg_type -- 
            ,sttlm_mk -- 
            ,drft_hldr_role -- 
            ,apply_date -- 
            ,ovrdue_rsn -- 
            ,apply_curcd -- 
            ,drft_hldr_name -- 
            ,drft_hldr_actno -- 
            ,drft_hldr_ubank -- 
            ,drft_hldr_agcy_ubank -- 
            ,req_remark -- 
            ,req_prxy_prop_stn -- 
            ,rcv_remark -- 
            ,rcv_prxy_sgntr -- 
            ,prompt_status -- 
            ,endst_date -- 
            ,cancel_date -- 
            ,cancel_opid -- 
            ,receive_date -- 
            ,sig_mk -- 
            ,dish_code -- 
            ,dish_rsn -- 
            ,cm_status -- 
            ,cm_err_procd -- 
            ,ecds_prc_msg -- 
            ,account_date -- 
            ,account_flag -- 
            ,actlog_id -- 
            ,swt_biz_id -- 
            ,trf_ref -- 
            ,trf_id -- 
            ,entity_regstat -- 
            ,entity_reg_id -- 
            ,misc -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,cancel_flag -- 
            ,branch_id_opt -- 
            ,ebank_pool_id -- 
            ,fee -- 
            ,rcv_back_id -- 
            ,refid -- 
            ,virtual_account_no -- 
            ,is_problem_draft -- 
            ,return_cash_account -- 回款账户
            ,serino -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.batch_id, o.batch_id) as batch_id -- 
    ,nvl(n.src_type, o.src_type) as src_type -- 
    ,nvl(n.branch_id, o.branch_id) as branch_id -- 
    ,nvl(n.send_date, o.send_date) as send_date -- 
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 
    ,nvl(n.isse_curcd, o.isse_curcd) as isse_curcd -- 
    ,nvl(n.isse_amt, o.isse_amt) as isse_amt -- 
    ,nvl(n.drft_hldr_cmonid, o.drft_hldr_cmonid) as drft_hldr_cmonid -- 
    ,nvl(n.apply_amt, o.apply_amt) as apply_amt -- 
    ,nvl(n.mesg_type, o.mesg_type) as mesg_type -- 
    ,nvl(n.sttlm_mk, o.sttlm_mk) as sttlm_mk -- 
    ,nvl(n.drft_hldr_role, o.drft_hldr_role) as drft_hldr_role -- 
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 
    ,nvl(n.ovrdue_rsn, o.ovrdue_rsn) as ovrdue_rsn -- 
    ,nvl(n.apply_curcd, o.apply_curcd) as apply_curcd -- 
    ,nvl(n.drft_hldr_name, o.drft_hldr_name) as drft_hldr_name -- 
    ,nvl(n.drft_hldr_actno, o.drft_hldr_actno) as drft_hldr_actno -- 
    ,nvl(n.drft_hldr_ubank, o.drft_hldr_ubank) as drft_hldr_ubank -- 
    ,nvl(n.drft_hldr_agcy_ubank, o.drft_hldr_agcy_ubank) as drft_hldr_agcy_ubank -- 
    ,nvl(n.req_remark, o.req_remark) as req_remark -- 
    ,nvl(n.req_prxy_prop_stn, o.req_prxy_prop_stn) as req_prxy_prop_stn -- 
    ,nvl(n.rcv_remark, o.rcv_remark) as rcv_remark -- 
    ,nvl(n.rcv_prxy_sgntr, o.rcv_prxy_sgntr) as rcv_prxy_sgntr -- 
    ,nvl(n.prompt_status, o.prompt_status) as prompt_status -- 
    ,nvl(n.endst_date, o.endst_date) as endst_date -- 
    ,nvl(n.cancel_date, o.cancel_date) as cancel_date -- 
    ,nvl(n.cancel_opid, o.cancel_opid) as cancel_opid -- 
    ,nvl(n.receive_date, o.receive_date) as receive_date -- 
    ,nvl(n.sig_mk, o.sig_mk) as sig_mk -- 
    ,nvl(n.dish_code, o.dish_code) as dish_code -- 
    ,nvl(n.dish_rsn, o.dish_rsn) as dish_rsn -- 
    ,nvl(n.cm_status, o.cm_status) as cm_status -- 
    ,nvl(n.cm_err_procd, o.cm_err_procd) as cm_err_procd -- 
    ,nvl(n.ecds_prc_msg, o.ecds_prc_msg) as ecds_prc_msg -- 
    ,nvl(n.account_date, o.account_date) as account_date -- 
    ,nvl(n.account_flag, o.account_flag) as account_flag -- 
    ,nvl(n.actlog_id, o.actlog_id) as actlog_id -- 
    ,nvl(n.swt_biz_id, o.swt_biz_id) as swt_biz_id -- 
    ,nvl(n.trf_ref, o.trf_ref) as trf_ref -- 
    ,nvl(n.trf_id, o.trf_id) as trf_id -- 
    ,nvl(n.entity_regstat, o.entity_regstat) as entity_regstat -- 
    ,nvl(n.entity_reg_id, o.entity_reg_id) as entity_reg_id -- 
    ,nvl(n.misc, o.misc) as misc -- 
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 
    ,nvl(n.cancel_flag, o.cancel_flag) as cancel_flag -- 
    ,nvl(n.branch_id_opt, o.branch_id_opt) as branch_id_opt -- 
    ,nvl(n.ebank_pool_id, o.ebank_pool_id) as ebank_pool_id -- 
    ,nvl(n.fee, o.fee) as fee -- 
    ,nvl(n.rcv_back_id, o.rcv_back_id) as rcv_back_id -- 
    ,nvl(n.refid, o.refid) as refid -- 
    ,nvl(n.virtual_account_no, o.virtual_account_no) as virtual_account_no -- 
    ,nvl(n.is_problem_draft, o.is_problem_draft) as is_problem_draft -- 
    ,nvl(n.return_cash_account, o.return_cash_account) as return_cash_account -- 回款账户
    ,nvl(n.serino, o.serino) as serino -- 序列号
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdps_send_collection_dtls_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_send_collection_dtls where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.batch_id <> n.batch_id
        or o.src_type <> n.src_type
        or o.branch_id <> n.branch_id
        or o.send_date <> n.send_date
        or o.draft_id <> n.draft_id
        or o.isse_curcd <> n.isse_curcd
        or o.isse_amt <> n.isse_amt
        or o.drft_hldr_cmonid <> n.drft_hldr_cmonid
        or o.apply_amt <> n.apply_amt
        or o.mesg_type <> n.mesg_type
        or o.sttlm_mk <> n.sttlm_mk
        or o.drft_hldr_role <> n.drft_hldr_role
        or o.apply_date <> n.apply_date
        or o.ovrdue_rsn <> n.ovrdue_rsn
        or o.apply_curcd <> n.apply_curcd
        or o.drft_hldr_name <> n.drft_hldr_name
        or o.drft_hldr_actno <> n.drft_hldr_actno
        or o.drft_hldr_ubank <> n.drft_hldr_ubank
        or o.drft_hldr_agcy_ubank <> n.drft_hldr_agcy_ubank
        or o.req_remark <> n.req_remark
        or o.req_prxy_prop_stn <> n.req_prxy_prop_stn
        or o.rcv_remark <> n.rcv_remark
        or o.rcv_prxy_sgntr <> n.rcv_prxy_sgntr
        or o.prompt_status <> n.prompt_status
        or o.endst_date <> n.endst_date
        or o.cancel_date <> n.cancel_date
        or o.cancel_opid <> n.cancel_opid
        or o.receive_date <> n.receive_date
        or o.sig_mk <> n.sig_mk
        or o.dish_code <> n.dish_code
        or o.dish_rsn <> n.dish_rsn
        or o.cm_status <> n.cm_status
        or o.cm_err_procd <> n.cm_err_procd
        or o.ecds_prc_msg <> n.ecds_prc_msg
        or o.account_date <> n.account_date
        or o.account_flag <> n.account_flag
        or o.actlog_id <> n.actlog_id
        or o.swt_biz_id <> n.swt_biz_id
        or o.trf_ref <> n.trf_ref
        or o.trf_id <> n.trf_id
        or o.entity_regstat <> n.entity_regstat
        or o.entity_reg_id <> n.entity_reg_id
        or o.misc <> n.misc
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.cancel_flag <> n.cancel_flag
        or o.branch_id_opt <> n.branch_id_opt
        or o.ebank_pool_id <> n.ebank_pool_id
        or o.fee <> n.fee
        or o.rcv_back_id <> n.rcv_back_id
        or o.refid <> n.refid
        or o.virtual_account_no <> n.virtual_account_no
        or o.is_problem_draft <> n.is_problem_draft
        or o.return_cash_account <> n.return_cash_account
        or o.serino <> n.serino
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_send_collection_dtls_cl(
            id -- 
            ,batch_id -- 
            ,src_type -- 
            ,branch_id -- 
            ,send_date -- 
            ,draft_id -- 
            ,isse_curcd -- 
            ,isse_amt -- 
            ,drft_hldr_cmonid -- 
            ,apply_amt -- 
            ,mesg_type -- 
            ,sttlm_mk -- 
            ,drft_hldr_role -- 
            ,apply_date -- 
            ,ovrdue_rsn -- 
            ,apply_curcd -- 
            ,drft_hldr_name -- 
            ,drft_hldr_actno -- 
            ,drft_hldr_ubank -- 
            ,drft_hldr_agcy_ubank -- 
            ,req_remark -- 
            ,req_prxy_prop_stn -- 
            ,rcv_remark -- 
            ,rcv_prxy_sgntr -- 
            ,prompt_status -- 
            ,endst_date -- 
            ,cancel_date -- 
            ,cancel_opid -- 
            ,receive_date -- 
            ,sig_mk -- 
            ,dish_code -- 
            ,dish_rsn -- 
            ,cm_status -- 
            ,cm_err_procd -- 
            ,ecds_prc_msg -- 
            ,account_date -- 
            ,account_flag -- 
            ,actlog_id -- 
            ,swt_biz_id -- 
            ,trf_ref -- 
            ,trf_id -- 
            ,entity_regstat -- 
            ,entity_reg_id -- 
            ,misc -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,cancel_flag -- 
            ,branch_id_opt -- 
            ,ebank_pool_id -- 
            ,fee -- 
            ,rcv_back_id -- 
            ,refid -- 
            ,virtual_account_no -- 
            ,is_problem_draft -- 
            ,return_cash_account -- 回款账户
            ,serino -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_send_collection_dtls_op(
            id -- 
            ,batch_id -- 
            ,src_type -- 
            ,branch_id -- 
            ,send_date -- 
            ,draft_id -- 
            ,isse_curcd -- 
            ,isse_amt -- 
            ,drft_hldr_cmonid -- 
            ,apply_amt -- 
            ,mesg_type -- 
            ,sttlm_mk -- 
            ,drft_hldr_role -- 
            ,apply_date -- 
            ,ovrdue_rsn -- 
            ,apply_curcd -- 
            ,drft_hldr_name -- 
            ,drft_hldr_actno -- 
            ,drft_hldr_ubank -- 
            ,drft_hldr_agcy_ubank -- 
            ,req_remark -- 
            ,req_prxy_prop_stn -- 
            ,rcv_remark -- 
            ,rcv_prxy_sgntr -- 
            ,prompt_status -- 
            ,endst_date -- 
            ,cancel_date -- 
            ,cancel_opid -- 
            ,receive_date -- 
            ,sig_mk -- 
            ,dish_code -- 
            ,dish_rsn -- 
            ,cm_status -- 
            ,cm_err_procd -- 
            ,ecds_prc_msg -- 
            ,account_date -- 
            ,account_flag -- 
            ,actlog_id -- 
            ,swt_biz_id -- 
            ,trf_ref -- 
            ,trf_id -- 
            ,entity_regstat -- 
            ,entity_reg_id -- 
            ,misc -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,cancel_flag -- 
            ,branch_id_opt -- 
            ,ebank_pool_id -- 
            ,fee -- 
            ,rcv_back_id -- 
            ,refid -- 
            ,virtual_account_no -- 
            ,is_problem_draft -- 
            ,return_cash_account -- 回款账户
            ,serino -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.batch_id -- 
    ,o.src_type -- 
    ,o.branch_id -- 
    ,o.send_date -- 
    ,o.draft_id -- 
    ,o.isse_curcd -- 
    ,o.isse_amt -- 
    ,o.drft_hldr_cmonid -- 
    ,o.apply_amt -- 
    ,o.mesg_type -- 
    ,o.sttlm_mk -- 
    ,o.drft_hldr_role -- 
    ,o.apply_date -- 
    ,o.ovrdue_rsn -- 
    ,o.apply_curcd -- 
    ,o.drft_hldr_name -- 
    ,o.drft_hldr_actno -- 
    ,o.drft_hldr_ubank -- 
    ,o.drft_hldr_agcy_ubank -- 
    ,o.req_remark -- 
    ,o.req_prxy_prop_stn -- 
    ,o.rcv_remark -- 
    ,o.rcv_prxy_sgntr -- 
    ,o.prompt_status -- 
    ,o.endst_date -- 
    ,o.cancel_date -- 
    ,o.cancel_opid -- 
    ,o.receive_date -- 
    ,o.sig_mk -- 
    ,o.dish_code -- 
    ,o.dish_rsn -- 
    ,o.cm_status -- 
    ,o.cm_err_procd -- 
    ,o.ecds_prc_msg -- 
    ,o.account_date -- 
    ,o.account_flag -- 
    ,o.actlog_id -- 
    ,o.swt_biz_id -- 
    ,o.trf_ref -- 
    ,o.trf_id -- 
    ,o.entity_regstat -- 
    ,o.entity_reg_id -- 
    ,o.misc -- 
    ,o.last_upd_oper_id -- 
    ,o.last_upd_time -- 
    ,o.cancel_flag -- 
    ,o.branch_id_opt -- 
    ,o.ebank_pool_id -- 
    ,o.fee -- 
    ,o.rcv_back_id -- 
    ,o.refid -- 
    ,o.virtual_account_no -- 
    ,o.is_problem_draft -- 
    ,o.return_cash_account -- 回款账户
    ,o.serino -- 序列号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_send_collection_dtls_bk o
    left join ${iol_schema}.bdps_send_collection_dtls_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_send_collection_dtls_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdps_send_collection_dtls;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdps_send_collection_dtls') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdps_send_collection_dtls drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdps_send_collection_dtls add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdps_send_collection_dtls exchange partition p_${batch_date} with table ${iol_schema}.bdps_send_collection_dtls_cl;
alter table ${iol_schema}.bdps_send_collection_dtls exchange partition p_20991231 with table ${iol_schema}.bdps_send_collection_dtls_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_send_collection_dtls to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_send_collection_dtls_op purge;
drop table ${iol_schema}.bdps_send_collection_dtls_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_send_collection_dtls_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_send_collection_dtls',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
