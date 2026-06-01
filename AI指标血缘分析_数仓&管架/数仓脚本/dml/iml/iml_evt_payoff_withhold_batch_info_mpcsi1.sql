/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_payoff_withhold_batch_info_mpcsi1
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
drop table ${iml_schema}.evt_payoff_withhold_batch_info_mpcsi1_tm purge;
alter table ${iml_schema}.evt_payoff_withhold_batch_info add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_payoff_withhold_batch_info modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_payoff_withhold_batch_info_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_dt -- 批次日期
    ,batch_flow_num -- 批次流水号
    ,sign_id -- 签约编号
    ,batch_id -- 批次编号
    ,batch_data_doc_name -- 批次数据文件名
    ,memo_cd -- 摘要代码
    ,memo_comnt -- 摘要说明
    ,sign_type_cd -- 签约类型代码
    ,deduct_acct_id -- 扣款账户编号
    ,deduct_acct_name -- 扣款账户名称
    ,tot -- 总笔数
    ,tot_amt -- 总金额
    ,sucs_cnt -- 成功笔数
    ,sucs_amt -- 成功金额
    ,fail_cnt -- 失败笔数
    ,fail_amt -- 失败金额
    ,oper_org_id -- 经办机构编号
    ,oper_teller_id -- 经办柜员编号
    ,tran_status_cd -- 交易状态代码
    ,err_info_desc -- 错误信息描述
    ,actl_deduct_acct_id -- 实际扣款账户编号
    ,midgrod_tran_flow_num -- 中台交易流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_payoff_withhold_batch_info
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a60projdf_sign_summary-1
insert into ${iml_schema}.evt_payoff_withhold_batch_info_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_dt -- 批次日期
    ,batch_flow_num -- 批次流水号
    ,sign_id -- 签约编号
    ,batch_id -- 批次编号
    ,batch_data_doc_name -- 批次数据文件名
    ,memo_cd -- 摘要代码
    ,memo_comnt -- 摘要说明
    ,sign_type_cd -- 签约类型代码
    ,deduct_acct_id -- 扣款账户编号
    ,deduct_acct_name -- 扣款账户名称
    ,tot -- 总笔数
    ,tot_amt -- 总金额
    ,sucs_cnt -- 成功笔数
    ,sucs_amt -- 成功金额
    ,fail_cnt -- 失败笔数
    ,fail_amt -- 失败金额
    ,oper_org_id -- 经办机构编号
    ,oper_teller_id -- 经办柜员编号
    ,tran_status_cd -- 交易状态代码
    ,err_info_desc -- 错误信息描述
    ,actl_deduct_acct_id -- 实际扣款账户编号
    ,midgrod_tran_flow_num -- 中台交易流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102074'||P1.BACHDT||P1.BACHSQ -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.DATEFORMAT_MAX2(P1.BACHDT) -- 批次日期
    ,P1.BACHSQ -- 批次流水号
    ,P1.PROJNO -- 签约编号
    ,P1.SUMMSQ -- 批次编号
    ,P1.DATFNA -- 批次数据文件名
    ,P1.MMTEXT -- 摘要代码
    ,P1.MMCONT -- 摘要说明
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PROJTP END -- 签约类型代码
    ,P1.PAYACC -- 扣款账户编号
    ,P1.PAYNAM -- 扣款账户名称
    ,P1.TRANNO -- 总笔数
    ,P1.TRANAM -- 总金额
    ,P1.SUCCNO -- 成功笔数
    ,P1.SUCCAM -- 成功金额
    ,P1.FAILNO -- 失败笔数
    ,P1.FAILAM -- 失败金额
    ,P1.BRANCH -- 经办机构编号
    ,P1.TLRNBR -- 经办柜员编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.TRANST END -- 交易状态代码
    ,P1.ERRMSG -- 错误信息描述
    ,P1.REALACCTNO -- 实际扣款账户编号
    ,P1.TRANSEQNO -- 中台交易流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a60projdf_sign_summary' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a60projdf_sign_summary p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PROJTP = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A60PROJDF_SIGN_SUMMARY'
        AND R1.SRC_FIELD_EN_NAME= 'PROJTP'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_PAYOFF_WITHHOLD_BATCH_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'SIGN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.TRANST = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A60PROJDF_SIGN_SUMMARY'
        AND R2.SRC_FIELD_EN_NAME= 'TRANST'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_PAYOFF_WITHHOLD_BATCH_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
where  1 = 1 
      AND P1.BACHDT='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_payoff_withhold_batch_info truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_payoff_withhold_batch_info exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_payoff_withhold_batch_info_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_payoff_withhold_batch_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_payoff_withhold_batch_info_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_payoff_withhold_batch_info', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);