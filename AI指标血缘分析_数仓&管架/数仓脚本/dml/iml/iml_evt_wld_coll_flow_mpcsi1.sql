/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_wld_coll_flow_mpcsi1
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
drop table ${iml_schema}.evt_wld_coll_flow_mpcsi1_tm purge;
alter table ${iml_schema}.evt_wld_coll_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_wld_coll_flow modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wld_coll_flow_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_doc_name -- 批量文件名称
    ,seq_num -- 序号
    ,coll_flow_num -- 催收流水号
    ,case_id -- 案件编号
    ,cust_id -- 客户编号
    ,way_cd -- 催记方式代码
    ,coll_act_type_cd -- 催收动作类型代码
    ,coll_dt -- 催收日期
    ,coll_rest_type_cd -- 催收结果类型代码
    ,promis_repay_amt -- 承诺偿还金额
    ,promis_repay_dt -- 承诺偿还日期
    ,remark -- 备注
    ,org_id -- 机构编号
    ,create_tm -- 创建时间
    ,final_modif_tm -- 最后修改时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_wld_coll_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a0ntm_coll_rec-1
insert into ${iml_schema}.evt_wld_coll_flow_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_doc_name -- 批量文件名称
    ,seq_num -- 序号
    ,coll_flow_num -- 催收流水号
    ,case_id -- 案件编号
    ,cust_id -- 客户编号
    ,way_cd -- 催记方式代码
    ,coll_act_type_cd -- 催收动作类型代码
    ,coll_dt -- 催收日期
    ,coll_rest_type_cd -- 催收结果类型代码
    ,promis_repay_amt -- 承诺偿还金额
    ,promis_repay_dt -- 承诺偿还日期
    ,remark -- 备注
    ,org_id -- 机构编号
    ,create_tm -- 创建时间
    ,final_modif_tm -- 最后修改时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102080'||P1.BATCHFILENAME||P1.SEQNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BATCHFILENAME -- 批量文件名称
    ,P1.SEQNO -- 序号
    ,P1.COLL_REC_ID -- 催收流水号
    ,P1.CASE_NO -- 案件编号
    ,NVL(TRIM(P2.cbscustno),' ') -- 客户编号
    ,P1.COLL_REC_TYPE -- 催记方式代码
    ,P1.ACTION_CODE -- 催收动作类型代码
    ,${iml_schema}.dateformat_max2(P1.COLL_TIME) -- 催收日期
    ,P1.COLL_CONSEQ -- 催收结果类型代码
    ,P1.PROM_AMT -- 承诺偿还金额
    ,${iml_schema}.dateformat_max2(P1.PROM_DATE) -- 承诺偿还日期
    ,P1.REMARK -- 备注
    ,P1.ORG -- 机构编号
    ,P1.CREATED_DATETIME -- 创建时间
    ,P1.LAST_MODIFIED_DATETIME -- 最后修改时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a0ntm_coll_rec' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a0ntm_coll_rec p1
    left join ${iol_schema}.mpcs_a0ntm_customer p2 on P1.CUST_ID=P2.CUST_ID AND  P2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P2.END_DT>TO_DATE('${batch_date}','YYYYMMDD') 
where  1 = 1 
     and substr(p1.batchfilename,length(P1.batchfilename)-6-8,8)='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_wld_coll_flow truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_wld_coll_flow exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_wld_coll_flow_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_wld_coll_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_wld_coll_flow_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_wld_coll_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);