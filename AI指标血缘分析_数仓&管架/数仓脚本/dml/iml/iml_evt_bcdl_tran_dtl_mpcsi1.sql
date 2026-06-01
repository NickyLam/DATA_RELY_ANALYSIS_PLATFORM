/*
Purpose:    整全模型层-15天增量流水脚本，清空目标表近15天分区数据，把15天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bcdl_tran_dtl_mpcsi1
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
drop table ${iml_schema}.evt_bcdl_tran_dtl_mpcsi1_tm purge;
alter table ${iml_schema}.evt_bcdl_tran_dtl add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_bcdl_tran_dtl modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
-- 2.2.1 get new data into table
set serveroutput on
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_bcdl_tran_dtl'') and subpartition_name = upper(''p_mpcsi1_'||bat_dt||''') ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_bcdl_tran_dtl truncate subpartition p_mpcsi1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_bcdl_tran_dtl modify partition p_mpcsi1 add subpartition p_mpcsi1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
  end loop;
end;
/

-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a63ttrn-
insert into ${iml_schema}.evt_bcdl_tran_dtl(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cust_id -- 交易客户编号
    ,corp_work_dt -- 企业工作日期
    ,corp_flow_num -- 企业流水号
    ,corp_work_dt_batch -- 企业工作日期(批次)
    ,corp_flow_num_batch -- 企业流水号(批次)
    ,work_dt_batch -- 工作日期(批次)
    ,flow_num_batch -- 流水号(批次)
    ,tran_step_cd -- 交易步骤代码
    ,acct_dt -- 账务日期
    ,check_entry_status_cd -- 对账核对状态代码
    ,chn_cd -- 渠道代码
    ,chn_dt -- 渠道日期
    ,chn_flow_num -- 渠道流水号
    ,core_tran_dt -- 核心交易日期
    ,core_tran_flow_num -- 核心交易流水号
    ,init_sys_idf_id -- 原系统标识编号
    ,org_id -- 机构编号
    ,pay_acct -- 付款账户
    ,pay_acct_num_name -- 付款账号户名
    ,recver_type_cd -- 收款人类型代码
    ,recvbl_num -- 收款账号
    ,recvbl_num_acct_name -- 收款账号户名
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,curr_cd -- 币种代码
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_amt -- 交易金额
    ,comm_fee -- 手续费
    ,memo_cd -- 摘要代码
    ,postsc -- 附言
    ,dtl_status_cd -- 明细状态代码
    ,resp_code -- 响应码
    ,resp_info -- 响应信息
    ,sync_rest_dt -- 同步结果日期
    ,sync_rest_cnt -- 同步结果次数
    ,sorc_sys_tran_timestamp -- 源系统交易时间戳
    ,ova_flow_num -- 全局流水号
    ,output_ip_addr -- 输出IP地址
    ,output_mac_val -- 输出MAC值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102051'||P1.CUSTNO||P1.ENTWORKDT||P1.ENTSEQNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.CUSTNO -- 交易客户编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.ENTWORKDT) -- 企业工作日期
    ,P1.ENTSEQNO -- 企业流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.BATENTWORKDT) -- 企业工作日期(批次)
    ,P1.BATENTSEQNO -- 企业流水号(批次)
    ,${iml_schema}.DATEFORMAT_MIN(P1.WORKDT) -- 工作日期(批次)
    ,P1.SEQNO -- 流水号(批次)
    ,P1.STEP -- 交易步骤代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.CENTREDATE) -- 账务日期
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.SETTLESTAT END -- 对账核对状态代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL 
       ELSE '@'||P1.CHNL 
     END -- 渠道代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.CHNLDT) -- 渠道日期
    ,P1.CHNLSEQNO -- 渠道流水号
    ,${iml_schema}.DATEFORMAT_MAX(P1.HOSTDT) -- 核心交易日期
    ,P1.HOSTSEQNO -- 核心交易流水号
    ,P1.DATAID -- 原系统标识编号
    ,P1.BRCNO -- 机构编号
    ,P1.PAYACCTNO -- 付款账户
    ,P1.PAYACCTNAME -- 付款账号户名
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL     
       ELSE '@'||P1.RCVACCTFLAG 
     END -- 收款人类型代码
    ,P1.RCVACCTNO -- 收款账号
    ,P1.RCVACCTNAME -- 收款账号户名
    ,P1.RCVBANKNO -- 收款行行号
    ,P1.RCVBANKNAME -- 收款行名称
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL 
       ELSE '@'||P1.CCY
     END -- 币种代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL 
       ELSE '@'||P1.CCYFLAG
     END -- 钞汇标识代码
    ,P1.TRNAMT -- 交易金额
    ,P1.FEE -- 手续费
    ,nvl(P1.MEMOCD,'-') -- 摘要代码
    ,P1.REMARK -- 附言
    ,P1.STAT -- 明细状态代码
    ,P1.RSPCD -- 响应码
    ,P1.RSPMSG -- 响应信息
    ,P1.SYNTS -- 同步结果日期
    ,P1.SYNCOUNT -- 同步结果次数
    ,P1.TRNTS -- 源系统交易时间戳
    ,P1.GLOBALSEQNO -- 全局流水号
    ,P1.EFMIPADD -- 输出IP地址
    ,P1.EFMMAC -- 输出MAC值
    ,P1.etl_dt as etl_dt -- ETL处理日期
    ,'mpcs_a63ttrn' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a63ttrn p1
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.SETTLESTAT = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'MPCS'
        AND R5.SRC_TAB_EN_NAME= 'MPCS_A63TTRN'
        AND R5.SRC_FIELD_EN_NAME= 'SETTLESTAT'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_BCDL_TRAN_DTL'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CHECK_ENTRY_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CHNL = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A63TTRN'
        AND R1.SRC_FIELD_EN_NAME= 'CHNL'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_BCDL_TRAN_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CHN_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.RCVACCTFLAG = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A63TTRN'
        AND R2.SRC_FIELD_EN_NAME= 'RCVACCTFLAG'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_BCDL_TRAN_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'RECVER_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CCY = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A63TTRN'
        AND R3.SRC_FIELD_EN_NAME= 'CCY'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_BCDL_TRAN_DTL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.CCYFLAG = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A63TTRN'
        AND R4.SRC_FIELD_EN_NAME= 'CCYFLAG'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_BCDL_TRAN_DTL'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'EC_IDF_CD'
where  1 = 1 
    and p1.etl_dt>=to_date('${batch_date}','yyyymmdd')-14
    and p1.etl_dt<=to_date('${batch_date}','yyyymmdd')
    ;
commit;




-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bcdl_tran_dtl to ${iml_schema};


-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bcdl_tran_dtl', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);