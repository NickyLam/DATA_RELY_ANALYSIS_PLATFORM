/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_lhwd_repay_dtl_icmsf1
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
drop table ${iml_schema}.evt_lhwd_repay_dtl_icmsf1_tm purge;
alter table ${iml_schema}.evt_lhwd_repay_dtl add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_lhwd_repay_dtl modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_lhwd_repay_dtl_icmsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,partner_dubil_id -- 合作方借据编号
    ,repay_flow_num -- 还款流水号
    ,repay_dt -- 还款日期
    ,repay_perds -- 还款期数
    ,repay_amt -- 还款金额
    ,curr_cd -- 币种代码
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_name -- 还款账户名称
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,repay_num_id -- 还款账户编号
    ,repay_type_cd -- 还款类型代码
    ,repay_way_cd -- 还款方式代码
    ,callbk_type_cd -- 回收类型代码
    ,clear_tran_id -- 清算交易编号
    ,intnal_tran_flow_num -- 内部交易流水号
    ,tran_flow_num -- 交易流水号
    ,batch_dt -- 批次日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_lhwd_repay_dtl
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- icms_lhwd_repayment_info-1
insert into ${iml_schema}.evt_lhwd_repay_dtl_icmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,partner_dubil_id -- 合作方借据编号
    ,repay_flow_num -- 还款流水号
    ,repay_dt -- 还款日期
    ,repay_perds -- 还款期数
    ,repay_amt -- 还款金额
    ,curr_cd -- 币种代码
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_name -- 还款账户名称
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,repay_num_id -- 还款账户编号
    ,repay_type_cd -- 还款类型代码
    ,repay_way_cd -- 还款方式代码
    ,callbk_type_cd -- 回收类型代码
    ,clear_tran_id -- 清算交易编号
    ,intnal_tran_flow_num -- 内部交易流水号
    ,tran_flow_num -- 交易流水号
    ,batch_dt -- 批次日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401058'||P1.SERIALNO -- 事件编号
    ,'9999' -- 法人编号
    ,P2.HXBDSERIALNO -- 借据编号
    ,P1.BDSERIALNO -- 合作方借据编号
    ,P1.SERIALNO -- 还款流水号
    ,${iml_schema}.dateformat_max2(P1.TRANTIME) -- 还款日期
    ,to_number(nvl(trim(P1.REPAYTERM),'0')) -- 还款期数
    ,P1.TOTALAMT -- 还款金额
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.LXBUSINESSSUM -- 实还本金
    ,P1.LXINTAMT -- 实还利息
    ,P1.LXQODPAMT -- 实还罚息
    ,P1.ODIAMT -- 实还复利
    ,P1.PREPMTFEEREPAY -- 已还提前还款手续费
    ,nvl(trim(P1.REPAYACCOUNTTYPE),'-') -- 还款账户类型代码
    ,P1.REPAYACCOUNTNAME -- 还款账户名称
    ,P1.REPAYACCOUNTBANKNAME -- 还款账户开户机构名称
    ,P1.REPAYACCOUNTNO -- 还款账户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.REPAYMODE END -- 还款类型代码
    ,nvl(trim(P1.REPAYWAY),'9') -- 还款方式代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'|| P1.RECEIPTTYPE END -- 回收类型代码
    ,P1.SETTLEMENTSERIALNO -- 清算交易编号
    ,P1.INSEQNO -- 内部交易流水号
    ,P1.SEQNO -- 交易流水号
    ,${iml_schema}.dateformat_max2(P1.CURDATE) -- 批次日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_lhwd_repayment_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
   from ${iol_schema}.icms_lhwd_repayment_info p1
   inner join ${iol_schema}.icms_lhwd_business_duebill_his p2 on p1.bdserialno = p2.serialno 
    and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iml_schema}.ref_pub_cd_map r1 on P1.REPAYMODE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_LHWD_REPAYMENT_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'REPAYMODE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_LHWD_REPAY_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'REPAY_TYPE_CD'
   left join ${iml_schema}.ref_pub_cd_map r2 on P1.RECEIPTTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_LHWD_REPAYMENT_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'RECEIPTTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_LHWD_REPAY_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CALLBK_TYPE_CD'
 where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_lhwd_repay_dtl truncate partition p_icmsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_lhwd_repay_dtl exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.evt_lhwd_repay_dtl_icmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_lhwd_repay_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_lhwd_repay_dtl_icmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_lhwd_repay_dtl', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);