/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_cbps_check_entry_flow_mpcsi1
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
alter table ${iml_schema}.evt_cbps_check_entry_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_cbps_check_entry_flow modify partition p_mpcsi1
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
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_cbps_check_entry_flow'') and subpartition_name = ''P_MPCSI1_'||bat_dt||''' ';
    dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_cbps_check_entry_flow truncate subpartition P_MPCSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_cbps_check_entry_flow modify partition p_mpcsi1 add subpartition P_MPCSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
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
-- mpcs_a1rtfintranlist-
insert into ${iml_schema}.evt_cbps_check_entry_flow(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sys_id -- 系统编号
    ,midgrod_flow_num -- 中台流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,midgrod_tran_tm -- 中台交易时间
    ,msg_type_id -- 报文类型编号
    ,core_tran_code -- 核心交易码
    ,midgrod_tran_code -- 中台交易码
    ,mgmt_org_id -- 管理机构编号
    ,tran_org_id -- 交易机构编号
    ,teller_id -- 柜员编号
    ,tran_type_cd -- 交易类型代码
    ,tran_status_cd -- 交易状态代码
    ,core_tran_dt -- 核心交易日期
    ,core_tran_flow_num -- 核心交易流水号
    ,payer_acct_num -- 付款人账号
    ,payer_name -- 付款人名称
    ,recver_acct_num -- 收款人账号
    ,recver_name -- 收款人名称
    ,pay_flow_num -- 支付流水号
    ,init_pay_flow_num -- 原支付流水号
    ,return_cd -- 返回代码
    ,return_info_desc -- 返回信息描述
    ,tran_amt -- 交易金额
    ,entry_code -- 记账分录编码
    ,check_entry_dt -- 对账日期
    ,check_entry_status_cd -- 对账状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104039'||P1.SYSCD||P1.MAINSEQ||P1.TRANSDT -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SYSCD -- 系统编号
    ,P1.MAINSEQ -- 中台流水号
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRANSDT) -- 中台交易日期
    ,${iml_schema}.DATEFORMAT_MAX(substr(P1.TRANSDT,1,8)||P1.TRANSTIME) -- 中台交易时间
    ,P1.PCKNO -- 报文类型编号
    ,P1.HOSTTRCD -- 核心交易码
    ,P1.FRONTTRCD -- 中台交易码
    ,P1.MAGEBRN -- 管理机构编号
    ,P1.BRCNO -- 交易机构编号
    ,P1.USERID -- 柜员编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TRNTP END -- 交易类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 交易状态代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.HOSTDATE) -- 核心交易日期
    ,P1.HOSTNBR -- 核心交易流水号
    ,P1.PAYACCT -- 付款人账号
    ,P1.PAYNAME -- 付款人名称
    ,P1.INCOACCT -- 收款人账号
    ,P1.INCONAME -- 收款人名称
    ,P1.DATAID -- 支付流水号
    ,P1.ORGDATAID -- 原支付流水号
    ,P1.ERRCODE -- 返回代码
    ,P1.ERRMS -- 返回信息描述
    ,to_number(nvl(trim(p1.TRANSAMT),'0')) -- 交易金额
    ,P1.ABSCDE -- 记账分录编码
    ,${iml_schema}.DATEFORMAT_MAX(P1.COLLDT) -- 对账日期
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.COLSTS END -- 对账状态代码
    ,P1.ETL_DT as etl_dt -- ETL处理日期
    ,'mpcs_a1rtfintranlist' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a1rtfintranlist p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TRNTP = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A1RTFINTRANLIST'
        AND R1.SRC_FIELD_EN_NAME= 'TRNTP'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_CBPS_CHECK_ENTRY_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A1RTFINTRANLIST'
        AND R2.SRC_FIELD_EN_NAME= 'STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_CBPS_CHECK_ENTRY_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.COLSTS = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A1RTFINTRANLIST'
        AND R3.SRC_FIELD_EN_NAME= 'COLSTS'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_CBPS_CHECK_ENTRY_FLOW'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CHECK_ENTRY_STATUS_CD'
 where  1 = 1 
  and p1.etl_dt >= to_date('${batch_date}','yyyymmdd')-14
  and p1.etl_dt <= to_date('${batch_date}','yyyymmdd')
  ;
commit;



-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_cbps_check_entry_flow to ${iml_schema};


-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_cbps_check_entry_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);