/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ppps_ps_agt_pay_flow_pppsi1
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
alter table ${iml_schema}.evt_ppps_ps_agt_pay_flow add partition p_pppsi1 values ('pppsi1')(
        subpartition p_pppsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ppps_ps_agt_pay_flow modify partition p_pppsi1
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
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_ppps_ps_agt_pay_flow'') and subpartition_name = ''P_PPPSI1_'||bat_dt||''' ';
    dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_ppps_ps_agt_pay_flow truncate subpartition P_PPPSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_ppps_ps_agt_pay_flow modify partition p_pppsi1 add subpartition P_PPPSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
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
-- ppps_e_txn_collection-1
insert into ${iml_schema}.evt_ppps_ps_agt_pay_flow(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,acpt_pay_instr_cd -- 收付款指令代码
    ,payer_acct_belong_org_id -- 付款方账户所属机构编号
    ,batch_no -- 批次号
    ,ova_flow_num -- 全局流水号
    ,tran_curr_cd -- 交易币种代码
    ,tran_amt -- 交易金额
    ,tran_cate_cd -- 交易类别代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,pay_status_cd -- 支付状态代码
    ,plat_tran_flow_num -- 平台交易流水号
    ,plat_tran_dt -- 平台交易日期
    ,plat_tran_tm -- 平台交易时间
    ,create_tm -- 创建时间
    ,indent_id -- 订单编号
    ,indent_descb -- 订单描述
    ,check_entry_descb -- 对账描述
    ,check_entry_status_id -- 对账状态编号
    ,payer_agt_id -- 付款方协议编号
    ,payer_acct_id -- 付款方账户编号
    ,payer_acct_type_cd -- 付款方账户类型代码
    ,payer_acct_name -- 付款方账户名称
    ,core_revs_flow_num -- 核心冲正流水号
    ,core_revs_dt -- 核心冲正日期
    ,core_tran_dt -- 核心交易日期
    ,core_tran_status_cd -- 核心交易状态代码
    ,core_flow_num -- 核心流水号
    ,core_req_flow_num -- 核心请求流水号
    ,core_resp_code -- 核心响应码
    ,core_resp_info -- 核心响应信息
    ,tran_status_cd -- 交易状态代码
    ,recver_acct_id -- 收款方账户编号
    ,recver_acct_type_cd -- 收款方账户类型代码
    ,recver_acct_name -- 收款方账户名称
    ,recver_acct_belong_org_id -- 收款方账户所属机构编号
    ,adj_entry_way_cd -- 调账方式代码
    ,sys_return_code -- 系统返回码
    ,sys_return_comnt -- 系统返回说明
    ,sys_type_cd -- 系统类型代码
    ,sys_flow_num -- 系统流水号
    ,bus_return_code -- 业务返回码
    ,bus_return_dt -- 业务返回日期
    ,bus_return_comnt -- 业务返回说明
    ,aldy_clear_flg -- 已清算标志
    ,aldy_adj_entry_flg -- 已调账标志
    ,aldy_refund_cnt -- 已退款次数
    ,aldy_refund_amt -- 已退款金额
    ,aldy_tran_flg -- 已转移标志
    ,final_update_tm -- 最后更新时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
     '201006'||P1.TRX_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TRX_ID -- 交易流水号
    ,nvl(trim(P1.R_P_FLG),'-') -- 收付款指令代码
    ,P1.PYER_ACCT_ISSR_ID -- 付款方账户所属机构编号
    ,P1.BATCH_ID -- 批次号
    ,P1.GLOBAL_SEQ_NO -- 全局流水号
    ,nvl(trim(P1.TRX_CURRY),'-') -- 交易币种代码
    ,P1.TRX_AMT_D -- 交易金额
    ,nvl(trim(P1.TRX_CTGY),'0000') -- 交易类别代码
    ,${iml_schema}.dateformat_min(P1.SYS_DATE) -- 交易日期
    ,${iml_schema}.timeformat_min(P1.TRX_DT_TM) -- 交易时间
    ,nvl(trim(P1.STATUS),'-') -- 支付状态代码
    ,P1.TXN_NO -- 平台交易流水号
    ,${iml_schema}.dateformat_min(P1.TXN_DATE) -- 平台交易日期
    ,${iml_schema}.timeformat_min(P1.TXN_TIME) -- 平台交易时间
    ,P1.CREATE_TIME -- 创建时间
    ,P1.ORDR_ID -- 订单编号
    ,P1.ORDR_DESC -- 订单描述
    ,P1.CHK_DESC -- 对账描述
    ,P1.CHK_STATUS -- 对账状态编号
    ,P1.SGN_NO -- 付款方协议编号
    ,P1.PYER_ACCT_NO -- 付款方账户编号
    ,nvl(trim(P1.PYER_ACCT_TP),'-') -- 付款方账户类型代码
    ,P1.PYER_ACCT_NM -- 付款方账户名称
    ,P1.HOST_REVERT_ID -- 核心冲正流水号
    ,${iml_schema}.dateformat_min(P1.HOST_REVERT_DATE) -- 核心冲正日期
    ,${iml_schema}.dateformat_min(P1.HOST_DATE) -- 核心交易日期
    ,nvl(trim(P1.HOST_STATUS),'-') -- 核心交易状态代码
    ,P1.HOST_ID -- 核心流水号
    ,P1.HOST_REQ_NO -- 核心请求流水号
    ,P1.HOST_RET_CODE -- 核心响应码
    ,P1.HOST_RET_MSG -- 核心响应信息
    ,nvl(trim(P1.TRX_STATUS),'-') -- 交易状态代码
    ,P1.PYEE_ACCT_ID -- 收款方账户编号
    ,nvl(trim(P1.PYEE_ACCT_TP),'-') -- 收款方账户类型代码
    ,P1.PYEE_NM -- 收款方账户名称
    ,P1.PYEE_ACCT_ISSR_ID -- 收款方账户所属机构编号
    ,nvl(trim(P1.ADJ_MTD),'-') -- 调账方式代码
    ,P1.SYS_RTN_CD -- 系统返回码
    ,P1.SYS_RTN_DESC -- 系统返回说明
    ,nvl(trim(P1.SYS_TYPE),'-') -- 系统类型代码
    ,P1.SYS_ID -- 系统流水号
    ,P1.BIZ_STS_CD -- 业务返回码
    ,${iml_schema}.dateformat_min(P1.BIZ_DATE) -- 业务返回日期
    ,P1.BIZ_STS_DESC -- 业务返回说明
    ,P1.LIQU_FLAG -- 已清算标志
    ,P1.ADJUST_FLAG -- 已调账标志
    ,P1.REPAYMENT_CNT -- 已退款次数
    ,P1.REPAYMENT_AMT_D -- 已退款金额
    ,P1.TRANSFER_FLAG -- 已转移标志
    ,P1.UPDATE_TIME -- 最后更新时间
    ,to_date(P1.sys_date,'yyyy-mm-dd') as etl_dt -- ETL处理日期
    ,'ppps_e_txn_collection' -- 源表名称
    ,'pppsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ppps_e_txn_collection p1
where  1 = 1 
    and to_date(P1.sys_date,'yyyy-mm-dd')>=to_date('${batch_date}','yyyymmdd')-14
    and to_date(P1.sys_date,'yyyy-mm-dd')<=to_date('${batch_date}','yyyymmdd')
;
commit;




-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ppps_ps_agt_pay_flow to ${iml_schema};


-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ppps_ps_agt_pay_flow', partname => 'p_pppsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);