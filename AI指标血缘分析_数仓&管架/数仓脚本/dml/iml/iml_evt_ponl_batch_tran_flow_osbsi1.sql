/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ponl_batch_tran_flow_osbsi1
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
drop table ${iml_schema}.evt_ponl_batch_tran_flow_osbsi1_tm purge;
alter table ${iml_schema}.evt_ponl_batch_tran_flow add partition p_osbsi1 values ('osbsi1')(
        subpartition p_osbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ponl_batch_tran_flow modify partition p_osbsi1
    add subpartition p_osbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ponl_batch_tran_flow_osbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,onl_tran_flow_num -- 网银交易流水号
    ,batch_id -- 批次编号
    ,cust_id -- 客户编号
    ,dept_id -- 部门编号
    ,save_cert_way_cd -- 安全认证方式代码
    ,auth_type_cd -- 授权类型代码
    ,tot -- 总笔数
    ,tot_amt -- 总金额
    ,sucs_cnt -- 成功次数
    ,sucs_amt -- 成功金额
    ,fail_cnt -- 失败次数
    ,fail_amt -- 失败金额
    ,tran_dt -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,batch_data_src_cd -- 批量数据来源代码
    ,tran_way_cd -- 转出方式代码
    ,tran_out_dt -- 转出日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ponl_batch_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- osbs_tps_batch_flow-1
insert into ${iml_schema}.evt_ponl_batch_tran_flow_osbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,onl_tran_flow_num -- 网银交易流水号
    ,batch_id -- 批次编号
    ,cust_id -- 客户编号
    ,dept_id -- 部门编号
    ,save_cert_way_cd -- 安全认证方式代码
    ,auth_type_cd -- 授权类型代码
    ,tot -- 总笔数
    ,tot_amt -- 总金额
    ,sucs_cnt -- 成功次数
    ,sucs_amt -- 成功金额
    ,fail_cnt -- 失败次数
    ,fail_amt -- 失败金额
    ,tran_dt -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,batch_data_src_cd -- 批量数据来源代码
    ,tran_way_cd -- 转出方式代码
    ,tran_out_dt -- 转出日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104041'||P1.TBF_BATCHNO||P1.TBF_BATCHNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TBF_FLOWNO -- 网银交易流水号
    ,P1.TBF_BATCHNO -- 批次编号
    ,P1.TBF_ECIFNO -- 客户编号
    ,P1.TBF_DEPTID -- 部门编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TBF_TRANSAUTHTYPE END  -- 安全认证方式代码
    ,nvl(trim(P1.TBF_AUTHTYPE),'-') -- 授权类型代码
    ,P1.TBF_TOTALCOUNT -- 总笔数
    ,P1.TBF_TOTALAMOUNT -- 总金额
    ,P1.TBF_SUCCESSCOUNT -- 成功次数
    ,P1.TBF_SUCCESSAMOUNT -- 成功金额
    ,P1.TBF_FAILCOUNT -- 失败次数
    ,P1.TBF_FAILAMOUNT -- 失败金额
    ,P1.TBF_TRANSDATE -- 交易日期
    ,${iml_schema}.timeformat_min(P1.TBF_TRANSTIME) -- 交易时间戳
    ,P1.TBF_TRANSCODE -- 交易码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.TBF_BATCHSTATE END  -- 交易状态代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TBF_BATCHTYPE END  -- 批量数据来源代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.TBF_TRANSFERTYPE END  -- 转出方式代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.TBF_TRANSFERDATE) -- 转出日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'osbs_tps_batch_flow' -- 源表名称
    ,'osbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.osbs_tps_batch_flow p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TBF_TRANSAUTHTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'OSBS'
        AND R1.SRC_TAB_EN_NAME= 'OSBS_TPS_BATCH_FLOW'
        AND R1.SRC_FIELD_EN_NAME= 'TBF_TRANSAUTHTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_PONL_BATCH_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'SAVE_CERT_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.TBF_BATCHSTATE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'OSBS'
        AND R2.SRC_TAB_EN_NAME= 'OSBS_TPS_BATCH_FLOW'
        AND R2.SRC_FIELD_EN_NAME= 'TBF_BATCHSTATE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_PONL_BATCH_TRAN_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TBF_BATCHTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'OSBS'
        AND R3.SRC_TAB_EN_NAME= 'OSBS_TPS_BATCH_FLOW'
        AND R3.SRC_FIELD_EN_NAME= 'TBF_BATCHTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_PONL_BATCH_TRAN_FLOW'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'BATCH_DATA_SRC_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.TBF_TRANSFERTYPE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'OSBS'
        AND R4.SRC_TAB_EN_NAME= 'OSBS_TPS_BATCH_FLOW'
        AND R4.SRC_FIELD_EN_NAME= 'TBF_TRANSFERTYPE'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_PONL_BATCH_TRAN_FLOW'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'TRAN_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and substr(P1.TBF_TRANSDATE,1,8)='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_ponl_batch_tran_flow truncate subpartition p_osbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ponl_batch_tran_flow exchange subpartition p_osbsi1_${batch_date} with table ${iml_schema}.evt_ponl_batch_tran_flow_osbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ponl_batch_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ponl_batch_tran_flow_osbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ponl_batch_tran_flow', partname => 'p_osbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);