/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_rgst_cter_bill_ccution_bdmsi1
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
drop table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsi1_tm purge;
alter table ${iml_schema}.evt_rgst_cter_bill_ccution add partition p_bdmsi1 values ('bdmsi1')(
        subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_rgst_cter_bill_ccution modify partition p_bdmsi1
    add subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_id -- 登记编号
    ,agt_id -- 协议编号
    ,agt_dtl_id -- 协议明细编号
    ,bill_id -- 票据编号
    ,bus_type_cd -- 业务类型代码
    ,bus_attr_cd -- 业务属性代码
    ,bill_num -- 票据号码
    ,tran_dir_cd -- 交易方向代码
    ,tran_dt -- 交易日期
    ,reqer_type_cd -- 请求方类型代码
    ,reqer_name -- 请求方名称
    ,reqer_soci_crdt_cd -- 请求方社会信用代码
    ,reqer_acct_num -- 请求方账号
    ,reqer_mem_id -- 请求方会员编号
    ,reqer_org_id -- 请求方机构编号
    ,reqer_pay_sys_bank_no -- 请求方支付系统行行号
    ,recver_type_cd -- 接收方类型代码
    ,recver_name -- 接收方名称
    ,recver_soci_crdt_cd -- 接收方社会信用代码
    ,recver_acct_num -- 接收方账号
    ,recver_mem_code -- 接收方会员编码
    ,recver_org_id -- 接收方机构编号
    ,recver_pay_sys_bank_no -- 接收方支付系统行行号
    ,actl_amt -- 实付金额
    ,actl_int -- 实付利息
    ,int_rat -- 利率
    ,stop_pay_type_cd -- 止付类型代码
    ,remit_stop_pay_type_cd -- 解除止付类型代码
    ,surp_tenor -- 剩余期限
    ,stl_amt -- 结算金额
    ,sys_in_flg -- 系统内标志
    ,tran_status_cd -- 交易状态代码
    ,payoff_type_cd -- 结清类型代码
    ,invtry_org_id -- 库存机构编号
    ,hq_org_id -- 总行机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_rgst_cter_bill_ccution
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- bdms_dpc_draft_trans_info-
insert into ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_id -- 登记编号
    ,agt_id -- 协议编号
    ,agt_dtl_id -- 协议明细编号
    ,bill_id -- 票据编号
    ,bus_type_cd -- 业务类型代码
    ,bus_attr_cd -- 业务属性代码
    ,bill_num -- 票据号码
    ,tran_dir_cd -- 交易方向代码
    ,tran_dt -- 交易日期
    ,reqer_type_cd -- 请求方类型代码
    ,reqer_name -- 请求方名称
    ,reqer_soci_crdt_cd -- 请求方社会信用代码
    ,reqer_acct_num -- 请求方账号
    ,reqer_mem_id -- 请求方会员编号
    ,reqer_org_id -- 请求方机构编号
    ,reqer_pay_sys_bank_no -- 请求方支付系统行行号
    ,recver_type_cd -- 接收方类型代码
    ,recver_name -- 接收方名称
    ,recver_soci_crdt_cd -- 接收方社会信用代码
    ,recver_acct_num -- 接收方账号
    ,recver_mem_code -- 接收方会员编码
    ,recver_org_id -- 接收方机构编号
    ,recver_pay_sys_bank_no -- 接收方支付系统行行号
    ,actl_amt -- 实付金额
    ,actl_int -- 实付利息
    ,int_rat -- 利率
    ,stop_pay_type_cd -- 止付类型代码
    ,remit_stop_pay_type_cd -- 解除止付类型代码
    ,surp_tenor -- 剩余期限
    ,stl_amt -- 结算金额
    ,sys_in_flg -- 系统内标志
    ,tran_status_cd -- 交易状态代码
    ,payoff_type_cd -- 结清类型代码
    ,invtry_org_id -- 库存机构编号
    ,hq_org_id -- 总行机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104011'||P1.TXN_DATE||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ID -- 登记编号
    ,P1.CONTRACT_ID -- 协议编号
    ,P1.DETAILS_ID -- 协议明细编号
    ,P1.DRAFT_ID -- 票据编号
    ,NVL(TRIM(P1.BUSI_TYPE),'-') -- 业务类型代码
    ,P1.BUSI_ATTR_NO -- 业务属性代码
    ,P1.DRAFT_NUMBER -- 票据号码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TRADE_DIRECT END -- 交易方向代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.TXN_DATE) -- 交易日期
    ,NVL(TRIM(P1.REQ_TYPE),'0') -- 请求方类型代码
    ,P1.REQ_NAME -- 请求方名称
    ,P1.REQ_CERT_NO -- 请求方社会信用代码
    ,P1.REQ_ACCOUNT -- 请求方账号
    ,P1.REQ_MEM_NO -- 请求方会员编号
    ,P1.REQ_BRH_NO -- 请求方机构编号
    ,P1.REQ_BANK_NO -- 请求方支付系统行行号
    ,NVL(TRIM(P1.RCV_TYPE),'0') -- 接收方类型代码
    ,P1.RCV_NAME -- 接收方名称
    ,P1.RCV_CERT_NO -- 接收方社会信用代码
    ,P1.RCV_ACCOUNT -- 接收方账号
    ,P1.RCV_MEM_NO -- 接收方会员编码
    ,P1.RCV_BRH_NO -- 接收方机构编号
    ,P1.RCV_BANK_NO -- 接收方支付系统行行号
    ,P1.PAY_AMOUNT -- 实付金额
    ,P1.PAY_INTEREST -- 实付利息
    ,P1.RATE -- 利率
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.STOP_PAY_TYPE END -- 止付类型代码
    ,NVL(TRIM(P1.RELIEVE_STP_TYPE),'RT00') -- 解除止付类型代码
    ,P1.TENOR_DAYS -- 剩余期限
    ,P1.SETTLE_AMT -- 结算金额
    ,P1.INNER_FLAG -- 系统内标志
    ,NVL(TRIM(P1.TRANS_STATUS),'-') -- 交易状态代码
    ,NVL(TRIM(P1.SETTLE_TYPE),'-') -- 结清类型代码
    ,P1.STORE_BRH_NO -- 库存机构编号
    ,P1.TOP_BRANCH_NO -- 总行机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_dpc_draft_trans_info' -- 源表名称
    ,'bdmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_dpc_draft_trans_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TRADE_DIRECT = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_DPC_DRAFT_TRANS_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'TRADE_DIRECT'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_RGST_CTER_BILL_CCUTION'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.STOP_PAY_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_DPC_DRAFT_TRANS_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'STOP_PAY_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_RGST_CTER_BILL_CCUTION'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'STOP_PAY_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_rgst_cter_bill_ccution truncate partition p_bdmsi1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_rgst_cter_bill_ccution exchange subpartition p_bdmsi1_${batch_date} with table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_rgst_cter_bill_ccution to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_rgst_cter_bill_ccution', partname => 'p_bdmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);