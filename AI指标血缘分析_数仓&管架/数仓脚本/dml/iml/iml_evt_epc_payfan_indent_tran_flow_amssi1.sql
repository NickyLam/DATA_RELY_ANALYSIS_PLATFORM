/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_epc_payfan_indent_tran_flow_amssi1
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
drop table ${iml_schema}.evt_epc_payfan_indent_tran_flow_amssi1_tm purge;
alter table ${iml_schema}.evt_epc_payfan_indent_tran_flow add partition p_amssi1 values ('amssi1')(
        subpartition p_amssi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_epc_payfan_indent_tran_flow modify partition p_amssi1
    add subpartition p_amssi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_epc_payfan_indent_tran_flow_amssi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,order_no -- 订单号
    ,indent_amt -- 订单金额
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,sign_ser_num -- 签约序列号
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,pay_acct_core_type_cd -- 付款账户核心类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_acct_core_type_cd -- 收款账户核心类型代码
    ,ppp_tran_flow_num -- PPP交易流水号
    ,ppp_init_tran_dt -- PPP原交易日期
    ,ppp_return_info -- ppp返回信息
    ,postsc -- 附言
    ,valid_flg -- 有效标志
    ,init_create_dt -- 最初创建日期
    ,create_teller_id -- 创建柜员编号
    ,create_teller_name -- 创建柜员名称
    ,latest_update_dt -- 最新更新日期
    ,update_teller_id -- 更新柜员编号
    ,update_teller_name -- 更新柜员名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_epc_payfan_indent_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- amss_online_pay_order-1
insert into ${iml_schema}.evt_epc_payfan_indent_tran_flow_amssi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,order_no -- 订单号
    ,indent_amt -- 订单金额
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,sign_ser_num -- 签约序列号
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,pay_acct_core_type_cd -- 付款账户核心类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_acct_core_type_cd -- 收款账户核心类型代码
    ,ppp_tran_flow_num -- PPP交易流水号
    ,ppp_init_tran_dt -- PPP原交易日期
    ,ppp_return_info -- ppp返回信息
    ,postsc -- 附言
    ,valid_flg -- 有效标志
    ,init_create_dt -- 最初创建日期
    ,create_teller_id -- 创建柜员编号
    ,create_teller_name -- 创建柜员名称
    ,latest_update_dt -- 最新更新日期
    ,update_teller_id -- 更新柜员编号
    ,update_teller_name -- 更新柜员名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401050'||P1.ORDER_NUM -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ONLINE_PAY_ORDER_ID -- 序列号
    ,P1.ORDER_NUM -- 订单号
    ,P1.TXN_AMT -- 订单金额
    ,P1.TXN_STATUS -- 交易状态代码
    ,P1.TXN_TIME -- 交易日期
    ,P1.SIGN_NUM -- 签约序列号
    ,P1.PAYER_ACCT -- 付款账户编号
    ,P1.PAYER_NAME -- 付款账户名称
    ,nvl(trim(P1.PAYER_ACCT_TYP),'-') -- 付款账户类型代码
    ,case when R2.TARGET_CD_VAL Is not null then R2.TARGET_CD_VAL else '@'||P1.PAYER_ACCT_BCS_TYP end -- 付款账户核心类型代码
    ,P1.RCV_ACCT -- 收款账户编号
    ,P1.RCV_ACCT_NAME -- 收款账户名称
    ,case when R4.TARGET_CD_VAL Is not null then R4.TARGET_CD_VAL else '@'||P1.RCV_ACCT_TYP end -- 收款账户类型代码
    ,case when R3.TARGET_CD_VAL Is not null then R3.TARGET_CD_VAL else '@'||P1.RCV_ACCT_BCS_TYP end -- 收款账户核心类型代码
    ,P1.ORI_TRX_SEQ -- PPP交易流水号
    ,${iml_schema}.dateformat_max2(P1.ORI_TRX_DT) -- PPP原交易日期
    ,P1.RESP_MSG -- ppp返回信息
    ,P1.POST_MSG -- 附言
    ,case when P1.PHYSICS_FLAG = 1 then '1' else '0' end -- 有效标志
    ,P1.CREATE_TIME -- 最初创建日期
    ,decode(to_char(P1.CREATE_USER),0,' ',to_char(P1.CREATE_USER)) -- 创建柜员编号
    ,P1.CREATE_EMP -- 创建柜员名称
    ,P1.UPDATE_TIME -- 最新更新日期
    ,decode(to_char(P1.CREATE_USER),0,' ',to_char(P1.UPDATE_USER)) -- 更新柜员编号
    ,P1.UPDATE_EMP -- 更新柜员名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'amss_online_pay_order' -- 源表名称
    ,'amssi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.amss_online_pay_order p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PAYER_ACCT_BCS_TYP = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'AMSS'
        AND R2.SRC_TAB_EN_NAME= 'AMSS_ONLINE_PAY_ORDER'
        AND R2.SRC_FIELD_EN_NAME= 'PAYER_ACCT_BCS_TYP'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_EPC_PAYFAN_INDENT_TRAN_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PAY_ACCT_CORE_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.RCV_ACCT_BCS_TYP = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'AMSS'
        AND R3.SRC_TAB_EN_NAME= 'AMSS_ONLINE_PAY_ORDER'
        AND R3.SRC_FIELD_EN_NAME= 'RCV_ACCT_BCS_TYP'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_EPC_PAYFAN_INDENT_TRAN_FLOW'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'RECVBL_ACCT_CORE_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.RCV_ACCT_TYP = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'AMSS'
        AND R4.SRC_TAB_EN_NAME= 'AMSS_ONLINE_PAY_ORDER'
        AND R4.SRC_FIELD_EN_NAME= 'RCV_ACCT_TYP'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_EPC_PAYFAN_INDENT_TRAN_FLOW'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'RECVBL_ACCT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_epc_payfan_indent_tran_flow truncate subpartition p_amssi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_epc_payfan_indent_tran_flow exchange subpartition p_amssi1_${batch_date} with table ${iml_schema}.evt_epc_payfan_indent_tran_flow_amssi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_epc_payfan_indent_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_epc_payfan_indent_tran_flow_amssi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_epc_payfan_indent_tran_flow', partname => 'p_amssi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);