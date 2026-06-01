/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_wld_syn_adj_flow_mpcsi1
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
drop table ${iml_schema}.evt_wld_syn_adj_flow_mpcsi1_tm purge;
alter table ${iml_schema}.evt_wld_syn_adj_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_wld_syn_adj_flow modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wld_syn_adj_flow_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_doc_name -- 批量文件名称
    ,seq_num -- 序号
    ,bus_flow_num -- 业务流水号
    ,syn_id -- 银团编号
    ,bank_id -- 银行编号
    ,tran_type_cd -- 交易类型代码
    ,logic_card_no -- 逻辑卡号
    ,exc_resv_clear_amt -- 备付金清算金额
    ,cnc_entry_amt -- CNC记账金额
    ,should_adj_bal -- 应调整差额
    ,batch_dt -- 批量日期
    ,excep_type_cd -- 异常类型代码
    ,cust_name -- 客户名称	
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_wld_syn_adj_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a0nds_split_diff-1
insert into ${iml_schema}.evt_wld_syn_adj_flow_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_doc_name -- 批量文件名称
    ,seq_num -- 序号
    ,bus_flow_num -- 业务流水号
    ,syn_id -- 银团编号
    ,bank_id -- 银行编号
    ,tran_type_cd -- 交易类型代码
    ,logic_card_no -- 逻辑卡号
    ,exc_resv_clear_amt -- 备付金清算金额
    ,cnc_entry_amt -- CNC记账金额
    ,should_adj_bal -- 应调整差额
    ,batch_dt -- 批量日期
    ,excep_type_cd -- 异常类型代码
    ,cust_name -- 客户名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102081'||P1.BATCHFILENAME||P1.SEQNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BATCHFILENAME -- 批量文件名称
    ,P1.SEQNO -- 序号
    ,P1.CONSUMER_TRANS_ID -- 业务流水号
    ,P1.BANK_GROUP_ID -- 银团编号
    ,P1.BANK_NO -- 银行编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.REG_TYPE  END -- 交易类型代码
    ,P1.LOGICAL_CARD_NO -- 逻辑卡号
    ,P1.BF_AMT -- 备付金清算金额；
    ,P1.ACCOUNT_AMT -- CNC记账金额
    ,P1.ERROR_AMT -- 应调整差额
    ,${iml_schema}.dateformat_max2(P1.PARTITION_DATE) -- 批量日期
    ,P1.ERROR_TYPE -- 异常类型代码
    ,P1.NAME -- 客户名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a0nds_split_diff' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a0nds_split_diff p1
       left join ${iml_schema}.REF_PUB_CD_MAP R1
           on P1.REG_TYPE = R1.SRC_CODE_VAL
           and R1.SORC_SYS_CD= 'MPCS'
           and R1.SRC_TAB_EN_NAME= 'MPCS_A0NDS_SPLIT_DIFF'
           and R1.SRC_FIELD_EN_NAME= 'REG_TYPE'
           and R1.TARGET_TAB_EN_NAME= 'EVT_WLD_SYN_ADJ_FLOW'
           and R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_TYPE_CD'
where  1 = 1 
     and P1.partition_date= '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_wld_syn_adj_flow truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_wld_syn_adj_flow exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_wld_syn_adj_flow_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_wld_syn_adj_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_wld_syn_adj_flow_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_wld_syn_adj_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);