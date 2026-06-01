/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ups_agt_pay_flow_pppsi1
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
drop table ${iml_schema}.evt_ups_agt_pay_flow_pppsi1_tm purge;
alter table ${iml_schema}.evt_ups_agt_pay_flow add partition p_pppsi1 values ('pppsi1')(
        subpartition p_pppsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ups_agt_pay_flow modify partition p_pppsi1
    add subpartition p_pppsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

set serveroutput on
--set line 200;
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
--dbms_output.put_line('BBB');
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_ups_agt_pay_flow'') and subpartition_name = ''P_PPPSI1_'||bat_dt||''' ';
    dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_ups_agt_pay_flow truncate subpartition P_PPPSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_ups_agt_pay_flow modify partition p_pppsi1 add subpartition P_PPPSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
        dbms_output.put_line('AAA');
    end if;
      end loop;
end;
/



-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ppps_u_txn_collection-1
insert into ${iml_schema}.evt_ups_agt_pay_flow(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_no -- 批次号
    ,tran_flow_num -- 交易流水号
    ,bus_kind_id -- 业务种类编号
    ,tran_type_cd -- 交易类型代码
    ,tran_curr_cd -- 交易币种代码
    ,tran_amt -- 交易金额
    ,tran_tm -- 交易时间
    ,aldy_refund_amt -- 已退款金额
    ,aldy_refund_cnt -- 已退款次数
    ,tran_status_cd -- 交易状态代码
    ,acpt_pay_instr_cd -- 收付款指令代码
    ,exc_resv_bank_acct_id -- 备付金银行账户编号
    ,exc_resv_bank_acct_name -- 备付金银行账户名称
    ,payer_acct_org_id -- 付款方账户所属机构编号
    ,payer_acct_type_cd -- 付款方账户类型代码
    ,payer_acct_id -- 付款方账户编号
    ,payer_acct_name -- 付款方账户名称
    ,payer_rsrv_mobile_no -- 付款方预留手机号
    ,send_org_id -- 发送机构编号
    ,recver_acct_org_id -- 收款方账户所属机构编号
    ,recver_acct_id -- 收款方账户编号
    ,recver_acct_name -- 收款方账户名称
    ,recver_acct_type_cd -- 收款方账户类型代码
    ,sign_agt_id -- 签约协议编号
    ,mercht_id -- 商户编号
    ,mercht_cate_cd -- 商户类别代码
    ,mercht_name -- 商户名称
    ,level2_mercht_id -- 二级商户编号
    ,level2_mercht_cate_cd -- 二级商户类别代码
    ,level2_mercht_name -- 二级商户名称
    ,sys_flow_num -- 系统流水号
    ,sys_type_cd -- 系统类型代码
    ,sys_tran_dt -- 系统交易日期
    ,sys_return_code -- 系统返回码
    ,sys_return_comnt -- 系统返回说明
    ,core_flow_num -- 核心流水号
    ,core_tran_dt -- 核心交易日期
    ,core_tran_status_cd -- 核心交易状态代码
    ,aldy_tran_flg -- 已转移标志
    ,aldy_adj_entry_flg -- 已调账标志
    ,aldy_clear_flg -- 已清算标志
    ,check_entry_status_cd -- 对账状态代码
    ,clear_batch_no -- 清算批次号
    ,clear_dt -- 清算日期
    ,indent_id -- 订单编号
    ,indent_descb -- 订单描述
    ,plat_tran_flow_num -- 平台交易流水号
    ,plat_tran_dt -- 平台交易日期
    ,plat_tran_tm -- 平台交易时间
    ,out_plat_flow_num -- 外联平台流水号
    ,out_ova_plat_flow_num -- 外联全局平台流水号
    ,open_acct_org_id -- 开户机构编号
    ,teller_id -- 柜员编号
    ,create_tm -- 创建时间
    ,final_update_tm -- 最后更新时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401021'||P1.TRX_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BATCH_ID -- 批次号
    ,P1.TRX_ID -- 交易流水号
    ,P1.BIZ_TP -- 业务种类编号
    ,nvl(trim(P1.TRANS_TYPE),'-') -- 交易类型代码
    ,nvl(trim(P1.TRX_CURRY),'-') -- 交易币种代码
    ,P1.TRX_AMT_D -- 交易金额
    ,${iml_schema}.dateformat_min(P1.TRX_DT_TM) -- 交易时间
    ,P1.REPAYMENT_AMT_D -- 已退款金额
    ,P1.REPAYMENT_CNT -- 已退款次数
    ,nvl(trim(P1.TRX_STATUS),'-') -- 交易状态代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.R_P_FLG END -- 收付款指令代码
    ,P1.INSTG_ACCT_ID -- 备付金银行账户编号
    ,P1.INSTG_ACCT_NM -- 备付金银行账户名称
    ,P1.PYER_ACCT_ISSR_ID -- 付款方账户所属机构编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.PYER_ACCT_TP END -- 付款方账户类型代码
    ,P1.PYER_ACCT_ID -- 付款方账户编号
    ,P1.PYER_NM -- 付款方账户名称
    ,P1.MOB_NO -- 付款方预留手机号
    ,P1.PYEE_ISSR_ID -- 发送机构编号
    ,P1.PYEE_ACCT_ISSR_ID -- 收款方账户所属机构编号
    ,P1.PYEE_ACCT_ID -- 收款方账户编号
    ,P1.PYEE_NM -- 收款方账户名称
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.PYEE_ACCT_TP END -- 收款方账户类型代码
    ,P1.SGN_NO -- 签约协议编号
    ,P1.MRCHNT_NO -- 商户编号
    ,nvl(trim(P1.MRCHNT_TP_ID),'-') -- 商户类别代码
    ,P1.MRCHNT_PLTFRM_NM -- 商户名称
    ,P1.SUB_MRCHNT_NO -- 二级商户编号
    ,nvl(trim(P1.SUB_MRCHNT_TP_ID),'-') -- 二级商户类别代码
    ,P1.SUB_MRCHNT_PLTFRM_NM -- 二级商户名称
    ,P1.SYS_ID -- 系统流水号
    ,nvl(trim(P1.SYS_TYPE),'-') -- 系统类型代码
    ,${iml_schema}.dateformat_max2(P1.SYS_DATE) -- 系统交易日期
    ,P1.SYS_RTN_CD -- 系统返回码
    ,P1.SYS_RTN_DESC -- 系统返回说明
    ,P1.HOST_ID -- 核心流水号
    ,${iml_schema}.dateformat_max2(P1.HOST_DATE) -- 核心交易日期
    ,nvl(trim(P1.HOST_STATUS),'-') -- 核心交易状态代码
    ,nvl(trim(P1.TRANSFER_FLAG),'-') -- 已转移标志
    ,nvl(trim(P1.ADJUST_FLAG),'-') -- 已调账标志
    ,nvl(trim(P1.LIQU_FLAG),'-') -- 已清算标志
    ,nvl(trim(P1.CHK_STATUS),'-') -- 对账状态代码
    ,P1.SETTLMT_INF -- 清算批次号
    ,${iml_schema}.dateformat_max2(P1.SETTLMT_DT) -- 清算日期
    ,P1.ORDR_ID -- 订单编号
    ,P1.ORDR_DESC -- 订单描述
    ,P1.TXN_NO -- 平台交易流水号
    ,${iml_schema}.dateformat_max2(P1.TXN_DATE) -- 平台交易日期
    ,${iml_schema}.dateformat_min(P1.TXN_TIME) -- 平台交易时间
    ,P1.TRAN_SEQ_NO -- 外联平台流水号
    ,P1.GLOBAL_SEQ_NO -- 外联全局平台流水号
    ,P1.OPEN_ORG_ID -- 开户机构编号
    ,P1.TELLER_NO -- 柜员编号
    ,${iml_schema}.dateformat_min(P1.CREATE_TIME) -- 创建时间
    ,${iml_schema}.dateformat_min(P1.UPDATE_TIME) -- 最后更新时间
    ,P1.etl_dt as etl_dt  -- ETL处理日期
    ,'ppps_u_txn_collection' -- 源表名称
    ,'pppsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ppps_u_txn_collection p1 
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.R_P_FLG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'PPPS'
        AND R1.SRC_TAB_EN_NAME= 'PPPS_U_TXN_COLLECTION'
        AND R1.SRC_FIELD_EN_NAME= 'R_P_FLG'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_UPS_AGT_PAY_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ACPT_PAY_INSTR_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PYER_ACCT_TP = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'PPPS'
        AND R2.SRC_TAB_EN_NAME= 'PPPS_U_TXN_COLLECTION'
        AND R2.SRC_FIELD_EN_NAME= 'PYER_ACCT_TP'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_UPS_AGT_PAY_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PAYER_ACCT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.PYEE_ACCT_TP = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'PPPS'
        AND R3.SRC_TAB_EN_NAME= 'PPPS_U_TXN_COLLECTION'
        AND R3.SRC_FIELD_EN_NAME= 'PYEE_ACCT_TP'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_UPS_AGT_PAY_FLOW'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'RECVER_ACCT_TYPE_CD'
where  1 = 1 
    and P1.etl_dt>=to_date('${batch_date}','yyyymmdd')-14 and P1.etl_dt<=to_date('${batch_date}','yyyymmdd')
;
commit;


-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ups_agt_pay_flow to ${iml_schema};



-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ups_agt_pay_flow', partname => 'p_pppsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);