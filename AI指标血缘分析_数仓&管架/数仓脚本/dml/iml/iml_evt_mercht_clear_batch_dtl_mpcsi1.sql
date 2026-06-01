/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_mercht_clear_batch_dtl_mpcsi1
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
alter table ${iml_schema}.evt_mercht_clear_batch_dtl add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_mercht_clear_batch_dtl modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
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
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_mercht_clear_batch_dtl'') and subpartition_name = ''P_MPCSI1_'||bat_dt||''' ';
   -- dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    --dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_mercht_clear_batch_dtl truncate subpartition P_MPCSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_mercht_clear_batch_dtl modify partition p_mpcsi1 add subpartition P_MPCSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
      --  dbms_output.put_line(v_sql);
        execute immediate v_sql;
      --  dbms_output.put_line('AAA');
    end if;
      end loop;
end;
/

-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to  table
-- mpcs_a51ubmerchantpltdtl-1
insert into ${iml_schema}.evt_mercht_clear_batch_dtl(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,init_tran_flow_num -- 原交易流水号
    ,rgst_dt -- 登记日期
    ,rgst_tm -- 登记时间
    ,dtl_status_cd -- 明细状态代码
    ,upp_flow_num -- UPP流水号
    ,amt -- 金额
    ,curr_cd -- 币种代码
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_sub_acct_num -- 付款子账号
    ,pay_pt_type_cd -- 付款支付工具类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_sub_acct_num -- 收款子账号
    ,recvbl_pt_type_cd -- 收款支付工具类型代码
    ,bank_postsc -- 银行附言
    ,cust_postsc -- 客户附言
    ,err_descb -- 错误描述
    ,tran_org_id -- 交易机构编号
    ,core_flow_num -- 核心流水号
    ,core_dt -- 核心日期
    ,final_modif_tm -- 最后修改时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201010'||P1.BATCHNO||P1.TRANSNBR||P1.TRANSDT -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BATCHNO -- 批次编号
    ,P1.TRANSNBR -- 原交易流水号
    ,${iml_schema}.dateformat_min(P1.TRANSDT) -- 登记日期
    ,${iml_schema}.timeformat_min(P1.TRANSDT||P1.TRANSTM) -- 登记时间
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DTLSTATUS END -- 明细状态代码
    ,P1.TRANSACTIONID -- UPP流水号
    ,to_number(nvl(P1.AMOUNT,0)) -- 金额
    ,nvl(trim(p1.CURRENCYUOMID),'-') -- 币种代码
    ,P1.PAYERACCT -- 付款账户编号
    ,P1.PAYERACCTNAME -- 付款账户名称
    ,P1.PAYERSUBACCTSEQNO -- 付款子账号
    ,nvl(trim(p1.PAYERMETHODTYPEID),'-') -- 付款支付工具类型代码
    ,P1.PAYEEACCT -- 收款账户编号
    ,P1.PAYEEACCTNAME -- 收款账户名称
    ,P1.PAYEESUBACCTSEQNO -- 收款子账号
    ,nvl(trim(p1.PAYEEMETHODTYPEID),'-') -- 收款支付工具类型代码
    ,P1.INTERNALNOTE -- 银行附言
    ,P1.PUBLICNOTE -- 客户附言
    ,P1.FAILREASON -- 错误描述
    ,P1.PARTYID -- 交易机构编号
    ,P1.HOSTNBR -- 核心流水号
    ,${iml_schema}.timeformat_min(P1.HOSTDATE) -- 核心日期
    ,${iml_schema}.timeformat_min(P1.UPDT) -- 最后修改时间
    ,P1.ETL_DT as etl_dt -- ETL处理日期
    ,'mpcs_a51ubmerchantpltdtl' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a51ubmerchantpltdtl p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DTLSTATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A51UBMERCHANTPLTDTL'
        AND R1.SRC_FIELD_EN_NAME= 'DTLSTATUS'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_MERCHT_CLEAR_BATCH_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'DTL_STATUS_CD'
where  1 = 1 
     and p1.etl_dt >= to_date('${batch_date}','yyyymmdd')-14 and p1.etl_dt <= to_date('${batch_date}','yyyymmdd') 
;
commit;





-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_mercht_clear_batch_dtl', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);