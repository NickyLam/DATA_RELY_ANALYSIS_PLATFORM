/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_send_out_coll_dtl_bdmsf1
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
drop table ${iml_schema}.agt_send_out_coll_dtl_bdmsf1_tm purge;
drop table ${iml_schema}.agt_send_out_coll_dtl_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_send_out_coll_dtl add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_send_out_coll_dtl modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_send_out_coll_dtl_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_send_out_coll_dtl partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_send_out_coll_dtl_bdmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,send_out_coll_dtl_id -- 发出托收明细编号
    ,lp_id -- 法人编号
    ,send_out_coll_batch_id -- 发出托收批次编号
    ,org_id -- 机构编号
    ,send_out_coll_dt -- 发出托收日期
    ,bill_id -- 票据编号
    ,bill_curr_cd -- 票据币种代码
    ,bill_amt -- 票据金额
    ,sugst_payer_orgnz_cd -- 提示付款人组织机构代码
    ,sugst_pay_amt -- 提示付款金额
    ,msg_kind_cd -- 报文种类代码
    ,clear_way_cd -- 清算方式代码
    ,sugst_payer_cate_cd -- 提示付款人类别代码
    ,sugst_pay_appl_dt -- 提示付款申请日期
    ,sugst_pay_curr_cd -- 提示付款币种代码
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_acct_num -- 提示付款人账号
    ,sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,sugst_payer_udtake_bk_no -- 提示付款人承接行行号
    ,send_out_coll_dtl_status_cd -- 发出托收明细状态代码
    ,recv_dt -- 签收日期
    ,recv_opinion_cd -- 签收意见代码
    ,comm_status_cd -- 通讯状态代码
    ,msg_process_cd -- 报文处理码
    ,entry_flg -- 记账标志
    ,bus_flow_num -- 业务流水号
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,sugst_pay_agent_appl_cd -- 提示付款代理申请代码
    ,accptor_agent_reply_cd -- 承兑人代理回复代码
    ,entry_dt -- 记账日期
    ,entry_flow_num -- 记账流水号
    ,spec_prmssn_prtcptr_id -- 特许参与者编号
    ,pay_tran_num -- 支付交易号
    ,core_entry_acct_num -- 核心记账账号
    ,core_entry_uniq_ind_no -- 核心记账唯一标识号
    ,lock_ind -- 加锁标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_send_out_coll_dtl
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_send_out_coll_dtl_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_send_out_coll_dtl partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_send_collection_dtls-
insert into ${iml_schema}.agt_send_out_coll_dtl_bdmsf1_tm(
    agt_id -- 协议编号
    ,send_out_coll_dtl_id -- 发出托收明细编号
    ,lp_id -- 法人编号
    ,send_out_coll_batch_id -- 发出托收批次编号
    ,org_id -- 机构编号
    ,send_out_coll_dt -- 发出托收日期
    ,bill_id -- 票据编号
    ,bill_curr_cd -- 票据币种代码
    ,bill_amt -- 票据金额
    ,sugst_payer_orgnz_cd -- 提示付款人组织机构代码
    ,sugst_pay_amt -- 提示付款金额
    ,msg_kind_cd -- 报文种类代码
    ,clear_way_cd -- 清算方式代码
    ,sugst_payer_cate_cd -- 提示付款人类别代码
    ,sugst_pay_appl_dt -- 提示付款申请日期
    ,sugst_pay_curr_cd -- 提示付款币种代码
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_acct_num -- 提示付款人账号
    ,sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,sugst_payer_udtake_bk_no -- 提示付款人承接行行号
    ,send_out_coll_dtl_status_cd -- 发出托收明细状态代码
    ,recv_dt -- 签收日期
    ,recv_opinion_cd -- 签收意见代码
    ,comm_status_cd -- 通讯状态代码
    ,msg_process_cd -- 报文处理码
    ,entry_flg -- 记账标志
    ,bus_flow_num -- 业务流水号
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,sugst_pay_agent_appl_cd -- 提示付款代理申请代码
    ,accptor_agent_reply_cd -- 承兑人代理回复代码
    ,entry_dt -- 记账日期
    ,entry_flow_num -- 记账流水号
    ,spec_prmssn_prtcptr_id -- 特许参与者编号
    ,pay_tran_num -- 支付交易号
    ,core_entry_acct_num -- 核心记账账号
    ,core_entry_uniq_ind_no -- 核心记账唯一标识号
    ,lock_ind -- 加锁标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223106'||TO_CHAR(P1.ID) -- 协议编号
    ,TO_CHAR(P1.ID) -- 发出托收明细编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.BATCH_ID) -- 发出托收批次编号
    ,P2.brh_no -- 机构编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.SEND_DATE) -- 发出托收日期
    ,TO_CHAR(P1.DRAFT_ID) -- 票据编号
    ,nvl(trim(P1.ISSE_CURCD),'CNY') -- 票据币种代码
    ,P1.ISSE_AMT -- 票据金额
    ,P1.DRFT_HLDR_CMONID -- 提示付款人组织机构代码
    ,P1.APPLY_AMT -- 提示付款金额
    ,NVL(TRIM(P1.MESG_TYPE),'000') -- 报文种类代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.STTLM_MK END -- 清算方式代码
    ,NVL(TRIM(P1.DRFT_HLDR_ROLE),'-') -- 提示付款人类别代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.APPLY_DATE) -- 提示付款申请日期
    ,nvl(trim(P1.APPLY_CURCD),'CNY') -- 提示付款币种代码
    ,P1.DRFT_HLDR_NAME -- 提示付款人名称
    ,P1.DRFT_HLDR_ACTNO -- 提示付款人账号
    ,P1.DRFT_HLDR_UBANK -- 提示付款人开户行行号
    ,P1.DRFT_HLDR_AGCY_UBANK -- 提示付款人承接行行号
    ,NVL(TRIM(P1.PROMPT_STATUS),'-') -- 发出托收明细状态代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.ENDST_DATE) -- 签收日期
    ,NVL(TRIM(P1.SIG_MK),'-') -- 签收意见代码
    ,NVL(TRIM(P1.CM_STATUS),'00') -- 通讯状态代码
    ,P1.CM_ERR_PROCD -- 报文处理码
    ,P1.ACCOUNT_FLAG -- 记账标志
    ,TO_CHAR(P1.SWT_BIZ_ID) -- 业务流水号
    ,TO_CHAR(P1.LAST_UPD_OPER_ID) -- 最后修改操作员编号
    ,to_timestamp(to_char(${iml_schema}.dateformat_max(P1.LAST_UPD_TIME),'yyyy/mm/dd HH24:MI:SS'),'yyyy/mm/dd HH24:MI:SS.FF6') -- 最后修改时间
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.REQ_PRXY_PROP_STN END -- 提示付款代理申请代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.RCV_PRXY_SGNTR END -- 承兑人代理回复代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.ACCOUNT_DATE) -- 记账日期
    ,TO_CHAR(P1.ACTLOG_ID) -- 记账流水号
    ,P1.TRF_REF -- 特许参与者编号
    ,P1.TRF_ID -- 支付交易号
    ,P1.CORE_ACCOUNT -- 核心记账账号
    ,P1.DATAID -- 核心记账唯一标识号
    ,P1.APPLOCK -- 加锁标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_send_collection_dtls' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_send_collection_dtls p1
    left join ${iol_schema}.bdms_branch_info p2 on P1.BRANCH_ID=P2.ID AND  P2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P2.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.STTLM_MK = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_SEND_COLLECTION_DTLS'
        AND R1.SRC_FIELD_EN_NAME= 'STTLM_MK'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_SEND_OUT_COLL_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.REQ_PRXY_PROP_STN = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_SEND_COLLECTION_DTLS'
        AND R2.SRC_FIELD_EN_NAME= 'REQ_PRXY_PROP_STN'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_SEND_OUT_COLL_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'SUGST_PAY_AGENT_APPL_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.RCV_PRXY_SGNTR = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_SEND_COLLECTION_DTLS'
        AND R3.SRC_FIELD_EN_NAME= 'RCV_PRXY_SGNTR'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_SEND_OUT_COLL_DTL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'ACCPTOR_AGENT_REPLY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_send_out_coll_dtl_bdmsf1_tm 
  	                                group by 
  	                                        agt_id
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
insert /*+ append */ into ${iml_schema}.agt_send_out_coll_dtl_bdmsf1_ex(
    agt_id -- 协议编号
    ,send_out_coll_dtl_id -- 发出托收明细编号
    ,lp_id -- 法人编号
    ,send_out_coll_batch_id -- 发出托收批次编号
    ,org_id -- 机构编号
    ,send_out_coll_dt -- 发出托收日期
    ,bill_id -- 票据编号
    ,bill_curr_cd -- 票据币种代码
    ,bill_amt -- 票据金额
    ,sugst_payer_orgnz_cd -- 提示付款人组织机构代码
    ,sugst_pay_amt -- 提示付款金额
    ,msg_kind_cd -- 报文种类代码
    ,clear_way_cd -- 清算方式代码
    ,sugst_payer_cate_cd -- 提示付款人类别代码
    ,sugst_pay_appl_dt -- 提示付款申请日期
    ,sugst_pay_curr_cd -- 提示付款币种代码
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_acct_num -- 提示付款人账号
    ,sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,sugst_payer_udtake_bk_no -- 提示付款人承接行行号
    ,send_out_coll_dtl_status_cd -- 发出托收明细状态代码
    ,recv_dt -- 签收日期
    ,recv_opinion_cd -- 签收意见代码
    ,comm_status_cd -- 通讯状态代码
    ,msg_process_cd -- 报文处理码
    ,entry_flg -- 记账标志
    ,bus_flow_num -- 业务流水号
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,sugst_pay_agent_appl_cd -- 提示付款代理申请代码
    ,accptor_agent_reply_cd -- 承兑人代理回复代码
    ,entry_dt -- 记账日期
    ,entry_flow_num -- 记账流水号
    ,spec_prmssn_prtcptr_id -- 特许参与者编号
    ,pay_tran_num -- 支付交易号
    ,core_entry_acct_num -- 核心记账账号
    ,core_entry_uniq_ind_no -- 核心记账唯一标识号
    ,lock_ind -- 加锁标志
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.send_out_coll_dtl_id, o.send_out_coll_dtl_id) as send_out_coll_dtl_id -- 发出托收明细编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.send_out_coll_batch_id, o.send_out_coll_batch_id) as send_out_coll_batch_id -- 发出托收批次编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.send_out_coll_dt, o.send_out_coll_dt) as send_out_coll_dt -- 发出托收日期
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.bill_curr_cd, o.bill_curr_cd) as bill_curr_cd -- 票据币种代码
    ,nvl(n.bill_amt, o.bill_amt) as bill_amt -- 票据金额
    ,nvl(n.sugst_payer_orgnz_cd, o.sugst_payer_orgnz_cd) as sugst_payer_orgnz_cd -- 提示付款人组织机构代码
    ,nvl(n.sugst_pay_amt, o.sugst_pay_amt) as sugst_pay_amt -- 提示付款金额
    ,nvl(n.msg_kind_cd, o.msg_kind_cd) as msg_kind_cd -- 报文种类代码
    ,nvl(n.clear_way_cd, o.clear_way_cd) as clear_way_cd -- 清算方式代码
    ,nvl(n.sugst_payer_cate_cd, o.sugst_payer_cate_cd) as sugst_payer_cate_cd -- 提示付款人类别代码
    ,nvl(n.sugst_pay_appl_dt, o.sugst_pay_appl_dt) as sugst_pay_appl_dt -- 提示付款申请日期
    ,nvl(n.sugst_pay_curr_cd, o.sugst_pay_curr_cd) as sugst_pay_curr_cd -- 提示付款币种代码
    ,nvl(n.sugst_payer_name, o.sugst_payer_name) as sugst_payer_name -- 提示付款人名称
    ,nvl(n.sugst_payer_acct_num, o.sugst_payer_acct_num) as sugst_payer_acct_num -- 提示付款人账号
    ,nvl(n.sugst_payer_open_bank_no, o.sugst_payer_open_bank_no) as sugst_payer_open_bank_no -- 提示付款人开户行行号
    ,nvl(n.sugst_payer_udtake_bk_no, o.sugst_payer_udtake_bk_no) as sugst_payer_udtake_bk_no -- 提示付款人承接行行号
    ,nvl(n.send_out_coll_dtl_status_cd, o.send_out_coll_dtl_status_cd) as send_out_coll_dtl_status_cd -- 发出托收明细状态代码
    ,nvl(n.recv_dt, o.recv_dt) as recv_dt -- 签收日期
    ,nvl(n.recv_opinion_cd, o.recv_opinion_cd) as recv_opinion_cd -- 签收意见代码
    ,nvl(n.comm_status_cd, o.comm_status_cd) as comm_status_cd -- 通讯状态代码
    ,nvl(n.msg_process_cd, o.msg_process_cd) as msg_process_cd -- 报文处理码
    ,nvl(n.entry_flg, o.entry_flg) as entry_flg -- 记账标志
    ,nvl(n.bus_flow_num, o.bus_flow_num) as bus_flow_num -- 业务流水号
    ,nvl(n.final_modif_operr_id, o.final_modif_operr_id) as final_modif_operr_id -- 最后修改操作员编号
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,nvl(n.sugst_pay_agent_appl_cd, o.sugst_pay_agent_appl_cd) as sugst_pay_agent_appl_cd -- 提示付款代理申请代码
    ,nvl(n.accptor_agent_reply_cd, o.accptor_agent_reply_cd) as accptor_agent_reply_cd -- 承兑人代理回复代码
    ,nvl(n.entry_dt, o.entry_dt) as entry_dt -- 记账日期
    ,nvl(n.entry_flow_num, o.entry_flow_num) as entry_flow_num -- 记账流水号
    ,nvl(n.spec_prmssn_prtcptr_id, o.spec_prmssn_prtcptr_id) as spec_prmssn_prtcptr_id -- 特许参与者编号
    ,nvl(n.pay_tran_num, o.pay_tran_num) as pay_tran_num -- 支付交易号
    ,nvl(n.core_entry_acct_num, o.core_entry_acct_num) as core_entry_acct_num -- 核心记账账号
    ,nvl(n.core_entry_uniq_ind_no, o.core_entry_uniq_ind_no) as core_entry_uniq_ind_no -- 核心记账唯一标识号
    ,nvl(n.lock_ind, o.lock_ind) as lock_ind -- 加锁标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.send_out_coll_dtl_id <> n.send_out_coll_dtl_id
                or o.send_out_coll_batch_id <> n.send_out_coll_batch_id
                or o.org_id <> n.org_id
                or o.send_out_coll_dt <> n.send_out_coll_dt
                or o.bill_id <> n.bill_id
                or o.bill_curr_cd <> n.bill_curr_cd
                or o.bill_amt <> n.bill_amt
                or o.sugst_payer_orgnz_cd <> n.sugst_payer_orgnz_cd
                or o.sugst_pay_amt <> n.sugst_pay_amt
                or o.msg_kind_cd <> n.msg_kind_cd
                or o.clear_way_cd <> n.clear_way_cd
                or o.sugst_payer_cate_cd <> n.sugst_payer_cate_cd
                or o.sugst_pay_appl_dt <> n.sugst_pay_appl_dt
                or o.sugst_pay_curr_cd <> n.sugst_pay_curr_cd
                or o.sugst_payer_name <> n.sugst_payer_name
                or o.sugst_payer_acct_num <> n.sugst_payer_acct_num
                or o.sugst_payer_open_bank_no <> n.sugst_payer_open_bank_no
                or o.sugst_payer_udtake_bk_no <> n.sugst_payer_udtake_bk_no
                or o.send_out_coll_dtl_status_cd <> n.send_out_coll_dtl_status_cd
                or o.recv_dt <> n.recv_dt
                or o.recv_opinion_cd <> n.recv_opinion_cd
                or o.comm_status_cd <> n.comm_status_cd
                or o.msg_process_cd <> n.msg_process_cd
                or o.entry_flg <> n.entry_flg
                or o.bus_flow_num <> n.bus_flow_num
                or o.final_modif_operr_id <> n.final_modif_operr_id
                or o.final_modif_tm <> n.final_modif_tm
                or o.sugst_pay_agent_appl_cd <> n.sugst_pay_agent_appl_cd
                or o.accptor_agent_reply_cd <> n.accptor_agent_reply_cd
                or o.entry_dt <> n.entry_dt
                or o.entry_flow_num <> n.entry_flow_num
                or o.spec_prmssn_prtcptr_id <> n.spec_prmssn_prtcptr_id
                or o.pay_tran_num <> n.pay_tran_num
                or o.core_entry_acct_num <> n.core_entry_acct_num
                or o.core_entry_uniq_ind_no <> n.core_entry_uniq_ind_no
                or o.lock_ind <> n.lock_ind
            ) or (
                 case when (
                           n.agt_id is null
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
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_send_out_coll_dtl_bdmsf1_tm n
    full join ${iml_schema}.agt_send_out_coll_dtl_bdmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_send_out_coll_dtl truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_send_out_coll_dtl exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_send_out_coll_dtl_bdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_send_out_coll_dtl drop subpartition p_bdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_send_out_coll_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_send_out_coll_dtl_bdmsf1_tm purge;
drop table ${iml_schema}.agt_send_out_coll_dtl_bdmsf1_ex purge;
drop table ${iml_schema}.agt_send_out_coll_dtl_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_send_out_coll_dtl', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);