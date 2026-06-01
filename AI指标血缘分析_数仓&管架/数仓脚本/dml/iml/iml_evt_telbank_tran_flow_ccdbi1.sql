/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_telbank_tran_flow_ccdbi1
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
drop table ${iml_schema}.evt_telbank_tran_flow_ccdbi1_tm purge;
alter table ${iml_schema}.evt_telbank_tran_flow add partition p_ccdbi1 values ('ccdbi1')(
        subpartition p_ccdbi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_telbank_tran_flow modify partition p_ccdbi1
    add subpartition p_ccdbi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_telbank_tran_flow_ccdbi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,serv_flow_num -- 服务流水号
    ,chn_flow_num -- 渠道流水号
    ,call_flow_num -- 呼叫流水号
    ,tran_cd -- 交易代码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,acct_id -- 账户编号
    ,curr_cd -- 币种代码
    ,in_call_num -- 呼入电话号码
    ,operr_id -- 操作员编号
    ,cust_name -- 客户名称
    ,aud_sys_cd -- 语音系统代码
    ,tran_tm -- 交易时间
    ,host_return_code -- 主机返回码
    ,host_return_info -- 主机返回信息
    ,bus_cate_cd -- 业务类别代码
    ,remark_info -- 备注信息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_telbank_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ccdb_log_tran_com-
insert into ${iml_schema}.evt_telbank_tran_flow_ccdbi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,serv_flow_num -- 服务流水号
    ,chn_flow_num -- 渠道流水号
    ,call_flow_num -- 呼叫流水号
    ,tran_cd -- 交易代码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,acct_id -- 账户编号
    ,curr_cd -- 币种代码
    ,in_call_num -- 呼入电话号码
    ,operr_id -- 操作员编号
    ,cust_name -- 客户名称
    ,aud_sys_cd -- 语音系统代码
    ,tran_tm -- 交易时间
    ,host_return_code -- 主机返回码
    ,host_return_info -- 主机返回信息
    ,bus_cate_cd -- 业务类别代码
    ,remark_info -- 备注信息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102056'||P1.CODE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.CODE -- 交易流水号
    ,P1.TRANS_SERVICE_ID -- 服务流水号
    ,P1.CC_JOUR_SEQ -- 渠道流水号
    ,P1.CONNECT_ID -- 呼叫流水号
    ,P1.TRAN_CODE -- 交易代码
    ,P1.RETURN_CODE -- 返回码
    ,P1.RETURN_MESSAGE -- 返回信息
    ,P1.PAPER_ID -- 证件号码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PAPER_TYPE END -- 证件类型代码
    ,P1.CARD_NO -- 账户编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CURRENCY END -- 币种代码
    ,P1.CALL_NO -- 呼入电话号码
    ,P1.OPERATOR_CODE -- 操作员编号
    ,P1.CUST_NAME -- 客户名称
    ,NVL(TRIM(P1.CHANNEL_CODE),'X') -- 语音系统代码
    ,P1.TRANS_DATE -- 交易时间
    ,P1.HOST_RETURN_CODE -- 主机返回码
    ,P1.HOST_RETURN_MESSAGE -- 主机返回信息
    ,NVL(TRIM(P1.BUSINESS_TYPE),'X') -- 业务类别代码
    ,P1.AEXPINFO -- 备注信息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ccdb_log_tran_com' -- 源表名称
    ,'ccdbi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ccdb_log_tran_com p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PAPER_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'CCDB'
        AND R1.SRC_TAB_EN_NAME= 'CCDB_LOG_TRAN_COM'
        AND R1.SRC_FIELD_EN_NAME= 'PAPER_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_TELBANK_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CERT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CURRENCY= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'CCDB'
        AND R2.SRC_TAB_EN_NAME= 'CCDB_LOG_TRAN_COM'
        AND R2.SRC_FIELD_EN_NAME= 'CURRENCY'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_TELBANK_TRAN_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND TO_CHAR(P1.TRANS_DATE,'YYYYMMDD') = '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_telbank_tran_flow truncate subpartition p_ccdbi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_telbank_tran_flow exchange subpartition p_ccdbi1_${batch_date} with table ${iml_schema}.evt_telbank_tran_flow_ccdbi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_telbank_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_telbank_tran_flow_ccdbi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_telbank_tran_flow', partname => 'p_ccdbi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);