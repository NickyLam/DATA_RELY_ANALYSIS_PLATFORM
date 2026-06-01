/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_onl_bank_tran_dtl_osbsi1
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
drop table ${iml_schema}.evt_onl_bank_tran_dtl_osbsi1_tm purge;
alter table ${iml_schema}.evt_onl_bank_tran_dtl add partition p_osbsi1 values ('osbsi1')(
        subpartition p_osbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_onl_bank_tran_dtl modify partition p_osbsi1
    add subpartition p_osbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_onl_bank_tran_dtl_osbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 转账流水号
    ,whole_unify_cust_id -- 全行统一客户编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,tran_oper_type_cd -- 交易操作类型代码
    ,tran_return_code -- 交易返回码
    ,fail_rs -- 失败原因
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,comm_fee -- 手续费
    ,pay_acct_num -- 付款账号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,recvbl_num -- 收款账号
    ,recvbl_num_name -- 收款账号名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recver_bank_no -- 收款人银行行号
    ,recver_bank_name -- 收款人银行名称
    ,recver_prov_cd -- 收款人省份代码
    ,recver_prov_name -- 收款人省份名称
    ,recver_city_cd -- 收款人城市代码
    ,recver_city_name -- 收款人城市名称
    ,plan_fomult_tm -- 计划制定时间
    ,plan_type_cd -- 计划类型代码
    ,tran_freq_cd -- 交易频率代码
    ,next_exec_dt -- 下一次执行日期
    ,precon_plan_status_cd -- 预约计划状态代码
    ,tm_or_ff_begin_dt -- 定时或定频起始日期
    ,tm_or_ff_closing_dt -- 定时或定频截止日期
    ,lmt_attr_cd -- 限额属性代码
    ,save_cert_way_cd -- 安全认证方式代码
    ,usage_comnt -- 用途说明
    ,onl_bank_tran_flow_num -- 网银交易流水号
    ,recver_nickna -- 收款人昵称
    ,atm_equip_id -- ATM设备编号
    ,st_msg_advise_mobile_no -- 短信通知手机号码
    ,brac_id -- 网点编号
    ,brac_name -- 网点名称
    ,dept_cd -- 部门代码
    ,tran_out_route_id -- 转出路由编号
    ,remit_way_id -- 汇路编号
    ,remit_way_name -- 汇路名称
    ,next_day_tran_out_flg -- 次日转出标志
    ,tran_mobile_no -- 转账手机号码
    ,crdt_card_repay_flg -- 信用卡还款标志
    ,user_seq_id -- 用户顺序编号
    ,remark -- 备注
    ,tran_order_no -- 交易订单号
    ,chain_way_track_no -- 链路跟踪号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_onl_bank_tran_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- osbs_tps_trandetail_flow-
insert into ${iml_schema}.evt_onl_bank_tran_dtl_osbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 转账流水号
    ,whole_unify_cust_id -- 全行统一客户编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,tran_oper_type_cd -- 交易操作类型代码
    ,tran_return_code -- 交易返回码
    ,fail_rs -- 失败原因
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,comm_fee -- 手续费
    ,pay_acct_num -- 付款账号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,recvbl_num -- 收款账号
    ,recvbl_num_name -- 收款账号名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recver_bank_no -- 收款人银行行号
    ,recver_bank_name -- 收款人银行名称
    ,recver_prov_cd -- 收款人省份代码
    ,recver_prov_name -- 收款人省份名称
    ,recver_city_cd -- 收款人城市代码
    ,recver_city_name -- 收款人城市名称
    ,plan_fomult_tm -- 计划制定时间
    ,plan_type_cd -- 计划类型代码
    ,tran_freq_cd -- 交易频率代码
    ,next_exec_dt -- 下一次执行日期
    ,precon_plan_status_cd -- 预约计划状态代码
    ,tm_or_ff_begin_dt -- 定时或定频起始日期
    ,tm_or_ff_closing_dt -- 定时或定频截止日期
    ,lmt_attr_cd -- 限额属性代码
    ,save_cert_way_cd -- 安全认证方式代码
    ,usage_comnt -- 用途说明
    ,onl_bank_tran_flow_num -- 网银交易流水号
    ,recver_nickna -- 收款人昵称
    ,atm_equip_id -- ATM设备编号
    ,st_msg_advise_mobile_no -- 短信通知手机号码
    ,brac_id -- 网点编号
    ,brac_name -- 网点名称
    ,dept_cd -- 部门代码
    ,tran_out_route_id -- 转出路由编号
    ,remit_way_id -- 汇路编号
    ,remit_way_name -- 汇路名称
    ,next_day_tran_out_flg -- 次日转出标志
    ,tran_mobile_no -- 转账手机号码
    ,crdt_card_repay_flg -- 信用卡还款标志
    ,user_seq_id -- 用户顺序编号
    ,remark -- 备注
    ,tran_order_no -- 交易订单号
    ,chain_way_track_no -- 链路跟踪号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102037'||p1.TDF_DETAIL_FLOWNO -- 事件编号
    ,'9999' -- 法人编号
    ,p1.TDF_DETAIL_FLOWNO -- 转账流水号
    ,p1.TDF_ECIFNO -- 全行统一客户编号
    ,${iml_schema}.DATEFORMAT_MIN(substr(TDF_TRANSTIME,1,8)) -- 交易日期
    ,p1.TDF_TRANSTIME -- 交易时间
    ,p1.TDF_TRANSCODE -- 交易码
    ,NVL(TRIM(p1.TDF_OPTYPE),'-') -- 交易操作类型代码
    ,p1.TDF_RETURNCODE -- 交易返回码
    ,p1.TDF_RETURNMSG -- 失败原因
    ,p1.TDF_AMONUT -- 交易金额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TDF_CURRENCY END -- 币种代码
    ,p1.TDF_FEE -- 手续费
    ,p1.TDF_PAYACCNO -- 付款账号
    ,p1.TDF_PAYACCNAME -- 付款账户名称
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.TDF_PAYACCTYPE END -- 付款账户类型代码
    ,p1.TDF_RCVACCNO -- 收款账号
    ,p1.TDF_RCVACCNAME -- 收款账号名称
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TDF_RCVACCTYPE END -- 收款账户类型代码
    ,p1.TDF_RCVBANKID -- 收款人银行行号
    ,p1.TDF_RCVBANKNAME -- 收款人银行名称
    ,P1.TDF_PROVINCECODE -- 收款人省份代码
    ,p1.TDF_PROVINCENAME -- 收款人省份名称
    ,p1.TDF_CITYCODE -- 收款人城市代码
    ,p1.TDF_CITYNAME -- 收款人城市名称
    ,p1.TDF_SUBMITTIME -- 计划制定时间
    ,NVL(TRIM(p1.TDF_TYPE),'-') -- 计划类型代码
    ,nvl(trim(p1.TDF_TRANFREQ),'-') -- 交易频率代码
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(p1.TDF_NEXTEXEDATE)) -- 下一次执行日期
    ,NVL(TRIM(p1.TDF_STATE),'-') -- 预约计划状态代码
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(p1.TDF_BEGINDATE)) -- 定时或定频起始日期
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(p1.TDF_ENDDATE)) -- 定时或定频截止日期
    ,p1.TDF_LIMITNAME -- 限额属性代码
    ,nvl(trim(p1.TDF_SECURITYTYPE),'-') -- 安全认证方式代码
    ,p1.TDF_USE -- 用途说明
    ,p1.TDF_TRADE_FLOWNO -- 网银交易流水号
    ,p1.TDF_RCVACCNICKNAME -- 收款人昵称
    ,p1.TDF_DEVICEID -- ATM设备编号
    ,p1.TDF_RCVMOBILE -- 短信通知手机号码
    ,p1.TDF_BRANCHNO -- 网点编号
    ,p1.TDF_BRANCHNAME -- 网点名称
    ,NVL(TRIM(p1.TDF_DEPTID),'00') -- 部门代码
    ,p1.TDF_PATHID -- 转出路由编号
    ,p1.TDF_ROUTEID -- 汇路编号
    ,p1.TDF_ROUTENAME -- 汇路名称
    ,p1.TDF_ISNEXTDAY -- 次日转出标志
    ,p1.TDF_MOBILENO -- 转账手机号码
    ,p1.TDF_ISCREDITREPAY -- 信用卡还款标志
    ,p1.TDF_USERNO -- 用户顺序编号
    ,p1.TDF_REMARK -- 备注
    ,P1.TX_SEQ_NUM -- 交易订单号
    ,P1.CHAIN_WAY_TRACK_NO -- 链路跟踪号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'osbs_tps_trandetail_flow' -- 源表名称
    ,'osbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.osbs_tps_trandetail_flow p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TDF_CURRENCY = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'OSBS'
        AND R1.SRC_TAB_EN_NAME= 'OSBS_TPS_TRANDETAIL_FLOW'
        AND R1.SRC_FIELD_EN_NAME= 'TDF_CURRENCY'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_ONL_BANK_TRAN_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.TDF_PAYACCTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'OSBS'
        AND R2.SRC_TAB_EN_NAME= 'OSBS_TPS_TRANDETAIL_FLOW'
        AND R2.SRC_FIELD_EN_NAME= 'TDF_PAYACCTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_ONL_BANK_TRAN_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PAY_ACCT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TDF_RCVACCTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'OSBS'
        AND R3.SRC_TAB_EN_NAME= 'OSBS_TPS_TRANDETAIL_FLOW'
        AND R3.SRC_FIELD_EN_NAME= 'TDF_RCVACCTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_ONL_BANK_TRAN_DTL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'RECVBL_ACCT_TYPE_CD'
    /*left join ${iml_schema}.ref_pub_cd_map r4 on P1.TDF_PROVINCECODE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'OSBS'
        AND R4.SRC_TAB_EN_NAME= 'OSBS_TPS_TRANDETAIL_FLOW'
        AND R4.SRC_FIELD_EN_NAME= 'TDF_PROVINCECODE'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_ONL_BANK_TRAN_DTL'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'RECVER_PROV_CD'    */
where  1 = 1 
    and SUBSTR(p1.tdf_transtime,1,8) =  '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_onl_bank_tran_dtl truncate subpartition p_osbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_onl_bank_tran_dtl exchange subpartition p_osbsi1_${batch_date} with table ${iml_schema}.evt_onl_bank_tran_dtl_osbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_onl_bank_tran_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_onl_bank_tran_dtl_osbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_onl_bank_tran_dtl', partname => 'p_osbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);