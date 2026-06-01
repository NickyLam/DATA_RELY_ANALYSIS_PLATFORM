/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_telbank_cap_tran_flow_ccdbi1
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
drop table ${iml_schema}.evt_telbank_cap_tran_flow_ccdbi1_tm purge;
alter table ${iml_schema}.evt_telbank_cap_tran_flow add partition p_ccdbi1 values ('ccdbi1')(
        subpartition p_ccdbi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_telbank_cap_tran_flow modify partition p_ccdbi1
    add subpartition p_ccdbi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_telbank_cap_tran_flow_ccdbi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,call_flow_num -- 呼叫流水号
    ,in_call_num -- 呼入电话号码
    ,aud_sys_cd -- 语音系统代码
    ,tran_cd -- 交易代码
    ,tran_tm -- 交易时间
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,cust_name -- 客户名称
    ,pay_acct_id -- 付款账户编号
    ,pay_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,avl_aging_cd -- 到账时效代码
    ,tran_amt -- 交易金额
    ,comm_fee -- 手续费
    ,curr_cd -- 币种代码
    ,chn_cd -- 渠道代码
    ,dep_term -- 存期
    ,redt_flg -- 转存标志
    ,operr_id -- 操作员编号
    ,sign_org_name -- 签约机构名称
    ,dep_term_cd -- 存期代码
    ,sav_type_cd -- 储种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_telbank_cap_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ccdb_log_tran_com_money-
insert into ${iml_schema}.evt_telbank_cap_tran_flow_ccdbi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,call_flow_num -- 呼叫流水号
    ,in_call_num -- 呼入电话号码
    ,aud_sys_cd -- 语音系统代码
    ,tran_cd -- 交易代码
    ,tran_tm -- 交易时间
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,cust_name -- 客户名称
    ,pay_acct_id -- 付款账户编号
    ,pay_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,avl_aging_cd -- 到账时效代码
    ,tran_amt -- 交易金额
    ,comm_fee -- 手续费
    ,curr_cd -- 币种代码
    ,chn_cd -- 渠道代码
    ,dep_term -- 存期
    ,redt_flg -- 转存标志
    ,operr_id -- 操作员编号
    ,sign_org_name -- 签约机构名称
    ,dep_term_cd -- 存期代码
    ,sav_type_cd -- 储种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102056'||P1.CODE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.CODE -- 交易流水号
    ,P1.CONNECT_ID -- 呼叫流水号
    ,P1.CALL_NO -- 呼入电话号码
    ,NVL(TRIM(P1.CHANNEL_CODE),'X') -- 语音系统代码
    ,P1.TRAN_CODE -- 交易代码
    ,P1.TRANS_DATE -- 交易时间
    ,P1.RETURN_CODE -- 返回码
    ,P1.RETURN_MESSAGE -- 返回信息
    ,P1.CUST_NAME -- 客户名称
    ,P1.CARD_NO -- 付款账户编号
    ,P1.OPEN_BANK_CODE -- 付款行行号
    ,P1.OPEN_BANK_NAME -- 付款行名称
    ,P1.TO_CARD_NO -- 收款账户编号
    ,P1.TO_CUST_NAME -- 收款账户名称
    ,P1.TO_OPEN_BANK_CODE -- 收款行行号
    ,P1.TO_OPEN_BANK_NAME -- 收款行名称
    ,NVL(TRIM(P1.TRANS_TYPE),'0') -- 到账时效代码
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.TRANS_MONEY, '[0-9.]+')),0)) -- 交易金额
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.TRANS_FREE, '[0-9.]+')),0)) -- 手续费
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CURRENCY END -- 币种代码
    ,P1.TRANS_CHANNEL -- 渠道代码
    ,P1.DEPOSIT_NAME -- 存期
    ,P1.TRANSFER_FLAG -- 转存标志
    ,P1.OPERATOR_CODE -- 操作员编号
    ,P1.SIGN_NEWORK -- 签约机构名称
    ,P1.DEPOSIT_CODE -- 存期代码
    ,P1.DISPOST_TYPE -- 储种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ccdb_log_tran_com_money' -- 源表名称
    ,'ccdbi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ccdb_log_tran_com_money p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CURRENCY= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'CCDB'
        AND R1.SRC_TAB_EN_NAME= 'CCDB_LOG_TRAN_COM_MONEY'
        AND R1.SRC_FIELD_EN_NAME= 'CURRENCY'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_TELBANK_CAP_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND TO_CHAR(P1.TRANS_DATE,'YYYYMMDD') = '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_telbank_cap_tran_flow truncate subpartition p_ccdbi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_telbank_cap_tran_flow exchange subpartition p_ccdbi1_${batch_date} with table ${iml_schema}.evt_telbank_cap_tran_flow_ccdbi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_telbank_cap_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_telbank_cap_tran_flow_ccdbi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_telbank_cap_tran_flow', partname => 'p_ccdbi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);