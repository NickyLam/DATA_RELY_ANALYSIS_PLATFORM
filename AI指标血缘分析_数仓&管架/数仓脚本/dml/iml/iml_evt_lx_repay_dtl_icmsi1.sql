/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_lx_repay_dtl_icmsi1
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
drop table ${iml_schema}.evt_lx_repay_dtl_icmsi1_tm purge;
alter table ${iml_schema}.evt_lx_repay_dtl add partition p_icmsi1 values ('icmsi1')(
        subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_lx_repay_dtl modify partition p_icmsi1
    add subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_lx_repay_dtl_icmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,src_appl_flow_num -- 源申请流水号
    ,dubil_id -- 借据编号
    ,curr_cd -- 币种代码
    ,repay_perds -- 还款期数
    ,repay_type_cd -- 还款类型代码
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_id -- 还款账户编号
    ,repay_dt -- 还款日期
    ,pric_int_callbk_dt -- 本息回收日期
    ,payoff_dt -- 结清日期
    ,clear_tran_id -- 清算交易编号
    ,paid_amt_tot -- 实还金额总额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,guar_fee -- 担保费
    ,consul_serv_fee -- 咨询服务费
    ,crdt_estim_fee -- 信用评估费
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_lx_repay_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_lx_repayment_detail-1
insert into ${iml_schema}.evt_lx_repay_dtl_icmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,src_appl_flow_num -- 源申请流水号
    ,dubil_id -- 借据编号
    ,curr_cd -- 币种代码
    ,repay_perds -- 还款期数
    ,repay_type_cd -- 还款类型代码
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_id -- 还款账户编号
    ,repay_dt -- 还款日期
    ,pric_int_callbk_dt -- 本息回收日期
    ,payoff_dt -- 结清日期
    ,clear_tran_id -- 清算交易编号
    ,paid_amt_tot -- 实还金额总额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,guar_fee -- 担保费
    ,consul_serv_fee -- 咨询服务费
    ,crdt_estim_fee -- 信用评估费
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401052'||P1.ASSETID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ASSETID -- 源申请流水号
    ,P1.CAPITALLOANNO -- 借据编号
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.REPAYTERM -- 还款期数
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.REPAYMENTTYPE END -- 还款类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'|| P1.REPAYMENTACCTYPE END -- 还款账户类型代码
    ,P1.REPAYACCTNO -- 还款账户编号
    ,${iml_schema}.dateformat_max2(P1.REPAYDATE) -- 还款日期
    ,${iml_schema}.dateformat_max2(null) -- 本息回收日期
    ,${iml_schema}.dateformat_max2(P1.SETTLEDATE) -- 结清日期
    ,' ' -- 清算交易编号
    ,to_number(nvl(trim(P1.REALAMOUNTTOTAL),0)) -- 实还金额总额
    ,to_number(nvl(trim(P1.LXBUSINESSSUM),0)) -- 实还本金
    ,to_number(nvl(trim(P1.LXINTAMT),0)) -- 实还利息
    ,to_number(nvl(trim(P1.LXQODPAMT),0)) -- 实还罚息
    ,to_number(nvl(trim(P1.GUARANTYFEE),0)) -- 担保费
    ,to_number(nvl(trim(P1.SIMULATIONFEE),0)) -- 咨询服务费
    ,to_number(nvl(trim(P1.CREDITASSESSFEE),0)) -- 信用评估费
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_lx_repayment_detail' -- 源表名称
    ,'icmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_lx_repayment_detail p1
  left join ${iml_schema}.ref_pub_cd_map r1 
   on P1.REPAYMENTTYPE = R1.SRC_CODE_VAL
  and R1.SORC_SYS_CD = 'ICMS'
  and R1.SRC_TAB_EN_NAME = 'ICMS_LX_REPAYMENT_DETAIL'
  and R1.SRC_FIELD_EN_NAME = 'REPAYMENTTYPE'
  and R1.TARGET_TAB_EN_NAME = 'EVT_LX_REPAY_DTL'
  and R1.TARGET_TAB_FIELD_EN_NAME = 'REPAY_TYPE_CD'
  left join ${iml_schema}.ref_pub_cd_map r2 
   on P1.REPAYMENTACCTYPE = R2.SRC_CODE_VAL
  and R2.SORC_SYS_CD = 'ICMS'
  and R2.SRC_TAB_EN_NAME = 'ICMS_LX_REPAYMENT_DETAIL'
  and R2.SRC_FIELD_EN_NAME = 'REPAYMENTACCTYPE'
  and R2.TARGET_TAB_EN_NAME = 'EVT_LX_REPAY_DTL'
  and R2.TARGET_TAB_FIELD_EN_NAME = 'REPAY_NUM_TYPE_CD'
where  1 = 1 
  and p1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_lx_repay_dtl truncate subpartition p_icmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_lx_repay_dtl exchange subpartition p_icmsi1_${batch_date} with table ${iml_schema}.evt_lx_repay_dtl_icmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_lx_repay_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_lx_repay_dtl_icmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_lx_repay_dtl', partname => 'p_icmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);