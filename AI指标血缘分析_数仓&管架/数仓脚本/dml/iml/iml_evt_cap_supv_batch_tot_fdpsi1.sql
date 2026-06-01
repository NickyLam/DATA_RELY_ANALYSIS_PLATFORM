/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_cap_supv_batch_tot_fdpsi1
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
drop table ${iml_schema}.evt_cap_supv_batch_tot_fdpsi1_tm purge;
alter table ${iml_schema}.evt_cap_supv_batch_tot add partition p_fdpsi1 values ('fdpsi1')(
        subpartition p_fdpsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_cap_supv_batch_tot modify partition p_fdpsi1
    add subpartition p_fdpsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cap_supv_batch_tot_fdpsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,batch_name_cd -- 批次名称代码
    ,batch_type_cd -- 批次类型代码
    ,cap_src_cd -- 资金来源代码
    ,coprator_id -- 合作商编号
    ,check_entry_dt -- 对账日期
    ,trdpty_batch_id -- 第三方批次编号
    ,trdpty_flow_num -- 第三方流水号
    ,submit_data_tot -- 提交数据总笔数
    ,submit_data_tot_amt -- 提交数据总金额
    ,rest_data_tot -- 结果数据总笔数
    ,rest_data_tot_amt -- 结果数据总金额
    ,in_gold_submit_tot -- 入金提交总笔数
    ,in_gold_submit_tot_amt -- 入金提交总金额
    ,wdraw_submit_tot -- 出金提交总笔数
    ,wdraw_submit_tot_amt -- 出金提交总金额
    ,sucs_cnt -- 成功笔数
    ,sucs_amt -- 成功金额
    ,fail_cnt -- 失败笔数
    ,fail_amt -- 失败金额
    ,submit_tot_guar_amt -- 提交总担保金额
    ,sucs_guar_amt -- 成功担保金额
    ,resp_code -- 响应码
    ,resp_info -- 响应信息
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_dt -- 交易日期
    ,init_create_dt -- 最初创建日期
    ,init_create_affair_dt -- 最初创建事务日期
    ,final_modif_dt -- 最后修改日期
    ,final_modif_affair_dt -- 最后修改事务日期
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_cap_supv_batch_tot
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fdps_batch_process-1
insert into ${iml_schema}.evt_cap_supv_batch_tot_fdpsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,batch_name_cd -- 批次名称代码
    ,batch_type_cd -- 批次类型代码
    ,cap_src_cd -- 资金来源代码
    ,coprator_id -- 合作商编号
    ,check_entry_dt -- 对账日期
    ,trdpty_batch_id -- 第三方批次编号
    ,trdpty_flow_num -- 第三方流水号
    ,submit_data_tot -- 提交数据总笔数
    ,submit_data_tot_amt -- 提交数据总金额
    ,rest_data_tot -- 结果数据总笔数
    ,rest_data_tot_amt -- 结果数据总金额
    ,in_gold_submit_tot -- 入金提交总笔数
    ,in_gold_submit_tot_amt -- 入金提交总金额
    ,wdraw_submit_tot -- 出金提交总笔数
    ,wdraw_submit_tot_amt -- 出金提交总金额
    ,sucs_cnt -- 成功笔数
    ,sucs_amt -- 成功金额
    ,fail_cnt -- 失败笔数
    ,fail_amt -- 失败金额
    ,submit_tot_guar_amt -- 提交总担保金额
    ,sucs_guar_amt -- 成功担保金额
    ,resp_code -- 响应码
    ,resp_info -- 响应信息
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_dt -- 交易日期
    ,init_create_dt -- 最初创建日期
    ,init_create_affair_dt -- 最初创建事务日期
    ,final_modif_dt -- 最后修改日期
    ,final_modif_affair_dt -- 最后修改事务日期
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104029'||P1.BATCH_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BATCH_ID -- 批次编号
    ,nvl(trim（P1.BATCH_NAME),'-') -- 批次名称代码
    ,nvl(trim（P1.BATCH_TYPE),'-') -- 批次类型代码
    ,nvl(trim（P1.AMT_SOURCE),'-') -- 资金来源代码
    ,P1.PARENT_MERCHANT_ID -- 合作商编号
    ,${iml_schema}.dateformat_max2(P1.CHECK_DATE) -- 对账日期
    ,P1.THIRD_BATCH_ID -- 第三方批次编号
    ,P1.OLD_REQ_SEQ_NO -- 第三方流水号
    ,P1.SUBMIT_COUNT -- 提交数据总笔数
    ,P1.SUBMIT_SUM -- 提交数据总金额
    ,P1.RESULT_COUNT -- 结果数据总笔数
    ,P1.RESULT_SUM -- 结果数据总金额
    ,P1.DEPOSIT_COUNT -- 入金提交总笔数
    ,P1.DEPOSIT_SUM -- 入金提交总金额
    ,P1.WITHDRAW_COUNT -- 出金提交总笔数
    ,P1.WITHDRAW_SUM -- 出金提交总金额
    ,P1.SUCCESS_COUNT -- 成功笔数
    ,P1.SUCCESS_AMOUNT -- 成功金额
    ,P1.FAIL_COUNT -- 失败笔数
    ,P1.FAIL_AMOUNT -- 失败金额
    ,P1.SUBMIT_GUA_AMOUNT -- 提交总担保金额
    ,P1.SUCCESS_GUA_AMOUNT -- 成功担保金额
    ,P1.RESP_CODE -- 响应码
    ,P1.RESP_MSG -- 响应信息
    ,P1.TRAN_BRANCH_ID -- 交易机构编号
    ,P1.TRAN_TELLER_NO -- 交易柜员编号
    ,P1.TRANSACTION_DATE -- 交易日期
    ,P1.CREATED_STAMP -- 最初创建日期
    ,P1.CREATED_TX_STAMP -- 最初创建事务日期
    ,P1.LAST_UPDATED_STAMP -- 最后修改日期
    ,P1.LAST_UPDATED_TX_STAMP -- 最后修改事务日期
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fdps_batch_process' -- 源表名称
    ,'fdpsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fdps_batch_process p1
where  1 = 1 
     and P1.ETL_DT = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_cap_supv_batch_tot truncate subpartition p_fdpsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_cap_supv_batch_tot exchange subpartition p_fdpsi1_${batch_date} with table ${iml_schema}.evt_cap_supv_batch_tot_fdpsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_cap_supv_batch_tot to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_cap_supv_batch_tot_fdpsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_cap_supv_batch_tot', partname => 'p_fdpsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);