/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bill_tran_entry_bdmsf1
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
drop table ${iml_schema}.evt_bill_tran_entry_bdmsf1_tm purge;
alter table ${iml_schema}.evt_bill_tran_entry add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_bill_tran_entry modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_tran_entry_bdmsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_id -- 登记编号
    ,indent_id -- 订单编号
    ,tran_req_id -- 交易请求编号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_attr_string -- 交易属性字符串
    ,belong_hq_org_id -- 所属总行机构编号
    ,entry_tran_id -- 记账交易编号
    ,entry_dt -- 记账日期
    ,core_entry_flow_num -- 核心记账流水号
    ,entry_flg -- 记账标志
    ,entry_status_cd -- 记账状态代码
    ,entry_ext_attr -- 记账扩展属性
    ,final_entry_dt -- 最后记账日期
    ,prod_id -- 产品编号
    ,batch_id -- 业务批次编号
    ,bus_agt_id -- 业务协议编号
    ,bus_dtl_id -- 业务明细编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,bill_amt -- 票据金额
    ,bill_src_cd -- 票据来源代码
    ,sys_id -- 系统编号
    ,init_bill_id -- 原票据编号
    ,bill_sub_intrv_id -- 票据子区间编号
    ,allow_pkg_ccution_flg -- 允许分包流转标志
    ,old_init_bill_id -- 原始票据编号
    ,splt_bf_bill_id -- 拆分前票据编号
    ,ext_amt_1 -- 扩展金额一
    ,ext_amt_2 -- 扩展金额二
    ,ext_amt_3 -- 扩展金额三
    ,prtcptr_ext -- 参与方扩展
    ,intfc_return_code -- 接口返回码
    ,intfc_return_type_cd -- 接口返回类型代码
    ,intfc_return_descb -- 接口返回描述
    ,remark_1 -- 备注一
    ,remark_2 -- 备注二
    ,remark_3 -- 备注三
    ,remark_4 -- 备注四
    ,fin_org_id -- 财务机构编号
    ,fir_create_dt -- 最初创建日期
    ,final_update_tm -- 最后更新日期
    ,final_operr_id -- 最后操作员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_tran_entry
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- bdms_bms_trade_record_order-1
insert into ${iml_schema}.evt_bill_tran_entry_bdmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_id -- 登记编号
    ,indent_id -- 订单编号
    ,tran_req_id -- 交易请求编号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_attr_string -- 交易属性字符串
    ,belong_hq_org_id -- 所属总行机构编号
    ,entry_tran_id -- 记账交易编号
    ,entry_dt -- 记账日期
    ,core_entry_flow_num -- 核心记账流水号
    ,entry_flg -- 记账标志
    ,entry_status_cd -- 记账状态代码
    ,entry_ext_attr -- 记账扩展属性
    ,final_entry_dt -- 最后记账日期
    ,prod_id -- 产品编号
    ,batch_id -- 业务批次编号
    ,bus_agt_id -- 业务协议编号
    ,bus_dtl_id -- 业务明细编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,bill_amt -- 票据金额
    ,bill_src_cd -- 票据来源代码
    ,sys_id -- 系统编号
    ,init_bill_id -- 原票据编号
    ,bill_sub_intrv_id -- 票据子区间编号
    ,allow_pkg_ccution_flg -- 允许分包流转标志
    ,old_init_bill_id -- 原始票据编号
    ,splt_bf_bill_id -- 拆分前票据编号
    ,ext_amt_1 -- 扩展金额一
    ,ext_amt_2 -- 扩展金额二
    ,ext_amt_3 -- 扩展金额三
    ,prtcptr_ext -- 参与方扩展
    ,intfc_return_code -- 接口返回码
    ,intfc_return_type_cd -- 接口返回类型代码
    ,intfc_return_descb -- 接口返回描述
    ,remark_1 -- 备注一
    ,remark_2 -- 备注二
    ,remark_3 -- 备注三
    ,remark_4 -- 备注四
    ,fin_org_id -- 财务机构编号
    ,fir_create_dt -- 最初创建日期
    ,final_update_tm -- 最后更新日期
    ,final_operr_id -- 最后操作员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101006'||P1.ORDER_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ORDER_ID -- 登记编号
    ,P1.ORDER_NO -- 订单编号
    ,P1.REQUEST_NO -- 交易请求编号
    ,P1.TRADE_SEQ_NO -- 交易流水号
    ,${iml_schema}.dateformat_max2(P1.TRADE_DATE) -- 交易日期
    ,P1.TRANS_BRANCH_NO -- 交易机构编号
    ,P1.TRADE_ATTR_STR -- 交易属性字符串
    ,P1.TOP_BRANCH_NO -- 所属总行机构编号
    ,P1.TRADE_NO -- 记账交易编号
    ,${iml_schema}.dateformat_max2(P1.ACCT_DATE) -- 记账日期
    ,P1.BANK_SEQ_NO -- 核心记账流水号
    ,nvl(trim(P1.IS_BATCH_ACCT),'-') -- 记账标志
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 记账状态代码
    ,P1.ACCT_SCENE -- 记账扩展属性
    ,${iml_schema}.dateformat_max2(P1.ACCT_TIMESTAMP) -- 最后记账日期
    ,P1.PRODUCT_NO -- 产品编号
    ,P1.CONTRACT_ID -- 业务批次编号
    ,P1.PROTOCOL_NO -- 业务协议编号
    ,P1.DETAIL_ID -- 业务明细编号
    ,P1.DRAFT_ID -- 票据编号
    ,P1.DRAFT_NUMBER -- 票据号码
    ,P1.DRAFT_AMOUNT -- 票据金额
    ,nvl(trim(P1.SRC_TYPE),'-') -- 票据来源代码
    ,P1.SYS_CODE -- 系统编号
    ,P1.BMS_DRAFT_ID -- 原票据编号
    ,P1.CD_RANGE -- 票据子区间编号
    ,nvl(trim(P1.CD_SPLIT),'-') -- 允许分包流转标志
    ,P1.ORG_DRAFT_ID -- 原始票据编号
    ,P1.SPLIT_DRAFT_ID -- 拆分前票据编号
    ,P1.AMOUNT_RESERVE1 -- 扩展金额一
    ,P1.AMOUNT_RESERVE2 -- 扩展金额二
    ,P1.AMOUNT_RESERVE3 -- 扩展金额三
    ,P1.EXTENSION -- 参与方扩展
    ,P1.RECODE -- 接口返回码
    ,nvl(trim(P1.RESTATUS),'-') -- 接口返回类型代码
    ,P1.REMESSAGE -- 接口返回描述
    ,P1.RESERVE1 -- 备注一
    ,P1.RESERVE2 -- 备注二
    ,P1.RESERVE3 -- 备注三
    ,P1.RESERVE4 -- 备注四
    ,P1.ACCT_BRANCH_NO -- 财务机构编号
    ,${iml_schema}.dateformat_min(P1.CREATE_TIME) -- 最初创建日期
    ,${iml_schema}.dateformat_max2(P1.UPDATE_TIME) -- 最后更新日期
    ,P1.LAST_UPD_OPER_NO -- 最后操作员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_trade_record_order' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_trade_record_order p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_BMS_TRADE_RECORD_ORDER'
        AND R1.SRC_FIELD_EN_NAME= 'STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_BILL_TRAN_ENTRY'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_bill_tran_entry truncate partition p_bdmsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_bill_tran_entry exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.evt_bill_tran_entry_bdmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bill_tran_entry to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_bill_tran_entry_bdmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bill_tran_entry', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);