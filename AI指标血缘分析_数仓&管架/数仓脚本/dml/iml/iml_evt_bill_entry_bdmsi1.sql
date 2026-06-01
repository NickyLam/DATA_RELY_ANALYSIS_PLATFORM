/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bill_entry_bdmsi1
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
drop table ${iml_schema}.evt_bill_entry_bdmsi1_tm purge;
alter table ${iml_schema}.evt_bill_entry add partition p_bdmsi1 values ('bdmsi1')(
        subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_bill_entry modify partition p_bdmsi1
    add subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_entry_bdmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entry_bill_id -- 记账票据编号
    ,hq_org_id -- 总行机构编号
    ,tran_org_id -- 交易机构编号
    ,entry_tran_num -- 记账交易号
    ,prod_id -- 产品编号
    ,cont_id -- 合同编号
    ,agt_id -- 协议编号
    ,bus_id -- 业务编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,int_accr_exp_dt -- 计息到期日期
    ,int_accr_days -- 计息天数
    ,interest -- 利息
    ,fac_val_amt -- 票面金额
    ,buyer_pay_int_amt -- 买方付息金额
    ,actl_recv_amt -- 实收金额
    ,actl_amt -- 实付金额
    ,comm_fee -- 手续费
    ,todos -- 工本费
    ,tran_flow_num -- 交易流水号
    ,intfc_return_code -- 接口返回码
    ,intfc_return_type_cd -- 接口返回类型代码
    ,entry_status_cd -- 记账状态代码
    ,entry_tm -- 记账时间
    ,update_tm -- 更新时间
    ,final_modif_operr_id -- 最后修改操作员编号
    ,rgst_cter_ccution_id -- 登记中心流转编号
    ,bank_core_entry_flow_num -- 银行核心记账流水号
    ,fin_org_id -- 财务机构编号
    ,bill_sub_intrv_id -- 票据子区间编号
    ,h_data_flg -- 历史数据标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_entry
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- bdms_bms_trade_draft-
insert into ${iml_schema}.evt_bill_entry_bdmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entry_bill_id -- 记账票据编号
    ,hq_org_id -- 总行机构编号
    ,tran_org_id -- 交易机构编号
    ,entry_tran_num -- 记账交易号
    ,prod_id -- 产品编号
    ,cont_id -- 合同编号
    ,agt_id -- 协议编号
    ,bus_id -- 业务编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,int_accr_exp_dt -- 计息到期日期
    ,int_accr_days -- 计息天数
    ,interest -- 利息
    ,fac_val_amt -- 票面金额
    ,buyer_pay_int_amt -- 买方付息金额
    ,actl_recv_amt -- 实收金额
    ,actl_amt -- 实付金额
    ,comm_fee -- 手续费
    ,todos -- 工本费
    ,tran_flow_num -- 交易流水号
    ,intfc_return_code -- 接口返回码
    ,intfc_return_type_cd -- 接口返回类型代码
    ,entry_status_cd -- 记账状态代码
    ,entry_tm -- 记账时间
    ,update_tm -- 更新时间
    ,final_modif_operr_id -- 最后修改操作员编号
    ,rgst_cter_ccution_id -- 登记中心流转编号
    ,bank_core_entry_flow_num -- 银行核心记账流水号
    ,fin_org_id -- 财务机构编号
    ,bill_sub_intrv_id -- 票据子区间编号
    ,h_data_flg -- 历史数据标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101006'||TO_CHAR(P1.CREATE_TIME,'YYYYMMDD')||P1.TRADE_DRAFT_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TRADE_DRAFT_ID -- 记账票据编号
    ,P1.TOP_BRANCH_NO -- 总行机构编号
    ,P1.TRANS_BRANCH_NO -- 交易机构编号
    ,P1.TRADE_NO -- 记账交易号
    ,P1.PRODUCT_NO -- 产品编号
    ,P1.CONTRACT_ID -- 合同编号
    ,P1.PROTOCOL_NO -- 协议编号
    ,P1.DETAIL_ID -- 业务编号
    ,P1.DRAFT_ID -- 票据编号
    ,P1.DRAFT_NUMBER -- 票据号码
    ,${iml_schema}.DATEFORMAT_MIN(P1.PAYMENT_DATE) -- 计息到期日期
    ,P1.PAYMENT_DAYS -- 计息天数
    ,P1.ADJUST_INTEREST -- 利息
    ,P1.DRAFT_AMOUNT -- 票面金额
    ,P1.PAYER_AMOUNT -- 买方付息金额
    ,P1.REAL_AMOUNT -- 实收金额
    ,P1.PAY_AMOUNT -- 实付金额
    ,P1.CHARGE -- 手续费
    ,P1.EXPENSES -- 工本费
    ,P1.TRADE_SEQ_NO -- 交易流水号
    ,P1.RECODE -- 接口返回码
    ,NVL(TRIM(P1.RESTATUS),'-') -- 接口返回类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 记账状态代码
    ,P1.CREATE_TIME -- 记账时间
    ,P1.UPDATE_TIME -- 更新时间
    ,P1.LAST_UPD_OPER_NO -- 最后修改操作员编号
    ,P1.TRANS_ID -- 登记中心流转编号
    ,P1.BANK_SEQ_NO -- 银行核心记账流水号
    ,P1.ACCT_BRANCH_NO -- 财务机构编号
    ,P1.CD_RANGE -- 票据子区间编号
    ,P1.DRAFT_RESERVE2 -- 历史数据标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_trade_draft' -- 源表名称
    ,'bdmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_trade_draft p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_BMS_TRADE_DRAFT'
        AND R1.SRC_FIELD_EN_NAME= 'STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_BILL_ENTRY'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND TO_CHAR(P1.CREATE_TIME,'YYYYMMDD')='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_bill_entry truncate subpartition p_bdmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_bill_entry exchange subpartition p_bdmsi1_${batch_date} with table ${iml_schema}.evt_bill_entry_bdmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bill_entry to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_bill_entry_bdmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bill_entry', partname => 'p_bdmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);