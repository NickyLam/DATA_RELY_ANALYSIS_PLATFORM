/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_wld_crdt_apv_rest_mpcsi1
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
drop table ${iml_schema}.evt_wld_crdt_apv_rest_mpcsi1_tm purge;
alter table ${iml_schema}.evt_wld_crdt_apv_rest add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_wld_crdt_apv_rest modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wld_crdt_apv_rest_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,batch_doc_name -- 批量文件名称
    ,apv_dt -- 审批日期
    ,bank_id -- 银行编号
    ,final_apv_rest -- 最终审批结果
    ,co_bk_apv_rest -- 合作行审批结果
    ,co_bk_g_room_apv_rest -- 合作行机房审批结果
    ,psz_rg_apv_rest -- Psz区审批结果
    ,refuse_cd -- 拒绝代码
    ,fst_deb_flg -- 首借标志
    ,flow_num -- 流水号
    ,score_val -- 评分分值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_wld_crdt_apv_rest
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a0nreport_ds_approval_flow-
insert into ${iml_schema}.evt_wld_crdt_apv_rest_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,batch_doc_name -- 批量文件名称
    ,apv_dt -- 审批日期
    ,bank_id -- 银行编号
    ,final_apv_rest -- 最终审批结果
    ,co_bk_apv_rest -- 合作行审批结果
    ,co_bk_g_room_apv_rest -- 合作行机房审批结果
    ,psz_rg_apv_rest -- Psz区审批结果
    ,refuse_cd -- 拒绝代码
    ,fst_deb_flg -- 首借标志
    ,flow_num -- 流水号
    ,score_val -- 评分分值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102010'||P1.PARTITION_DATE||P1.SEQNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SEQNO -- 序列号
    ,P1.BATCHFILENAME -- 批量文件名称
    ,${iml_schema}.DATEFORMAT_MAX(P1.PARTITION_DATE) -- 审批日期
    ,P1.BANK_NO -- 银行编号
    ,P1.FINAL_RET -- 最终审批结果
    ,P1.OURS_APPROVAL_RET -- 合作行审批结果
    ,P1.OUTER_RET -- 合作行机房审批结果
    ,P1.PSZ_RET -- Psz区审批结果
    ,P1.CODE_BLOCK -- 拒绝代码
    ,NVL(TRIM(P1.IS_FIRST),'-') -- 首借标志
    ,P1.BIZ_NO -- 流水号
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.CUST_SCORE, '[0-9]+')),0)) -- 评分分值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a0nreport_ds_approval_flow' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a0nreport_ds_approval_flow p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND P1.PARTITION_DATE='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_wld_crdt_apv_rest truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_wld_crdt_apv_rest exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_wld_crdt_apv_rest_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_wld_crdt_apv_rest to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_wld_crdt_apv_rest_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_wld_crdt_apv_rest', partname => 'p_mpcsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);