/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_wrt_guat_tran_flow_addit_info_ncbsi1
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
drop table ${iml_schema}.evt_wrt_guat_tran_flow_addit_info_ncbsi1_tm purge;
alter table ${iml_schema}.evt_wrt_guat_tran_flow_addit_info add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_wrt_guat_tran_flow_addit_info modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wrt_guat_tran_flow_addit_info_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,tran_flow_num -- 交易流水号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,decl_type_cd -- 申报类型代码
    ,decl_cust_type_cd -- 申报客户类型代码
    ,subm_num -- 报送号码
    ,inco_tran_code -- 收入方交易编码
    ,expns_tran_code -- 支出方交易编码
    ,wrt_guat_type_cd -- 结售汇类型代码
    ,wrt_guat_proj_code -- 结售汇项目编码
    ,wrt_guat_tran_status_cd -- 结售汇交易状态代码
    ,wrt_guat_usage -- 结售汇用途
    ,wrt_guat_dtl_usage -- 结汇详细用途
    ,cust_single_acct_prefr_val -- 客户单户优惠值
    ,int_rat_apv_form_id -- 利率审批单编号
    ,cash_from_cd -- 现钞来源代码
    ,cash_usage_cd -- 现钞提取用途代码
    ,cash_from_cty_rg_cd -- 现钞来源国家地区代码
    ,cash_to_cty_rg_cd -- 现钞去向国家地区代码
    ,src_module_type_cd -- 源模块类型代码
    ,check_teller_id -- 复核柜员编号
    ,check_dt -- 复核日期
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,final_modif_teller_id -- 最后修改柜员编号
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_wrt_guat_tran_flow_addit_info
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ncbs_rb_exchange_tran_attach-1
insert into ${iml_schema}.evt_wrt_guat_tran_flow_addit_info_ncbsi1_tm(
    evt_id -- 事件编号
    ,tran_flow_num -- 交易流水号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,decl_type_cd -- 申报类型代码
    ,decl_cust_type_cd -- 申报客户类型代码
    ,subm_num -- 报送号码
    ,inco_tran_code -- 收入方交易编码
    ,expns_tran_code -- 支出方交易编码
    ,wrt_guat_type_cd -- 结售汇类型代码
    ,wrt_guat_proj_code -- 结售汇项目编码
    ,wrt_guat_tran_status_cd -- 结售汇交易状态代码
    ,wrt_guat_usage -- 结售汇用途
    ,wrt_guat_dtl_usage -- 结汇详细用途
    ,cust_single_acct_prefr_val -- 客户单户优惠值
    ,int_rat_apv_form_id -- 利率审批单编号
    ,cash_from_cd -- 现钞来源代码
    ,cash_usage_cd -- 现钞提取用途代码
    ,cash_from_cty_rg_cd -- 现钞来源国家地区代码
    ,cash_to_cty_rg_cd -- 现钞去向国家地区代码
    ,src_module_type_cd -- 源模块类型代码
    ,check_teller_id -- 复核柜员编号
    ,check_dt -- 复核日期
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,final_modif_teller_id -- 最后修改柜员编号
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201005'||P1.SEQ_NO -- 事件编号
    ,P1.SEQ_NO -- 交易流水号
    ,'9999' -- 法人编号
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(P1.EXCHANGE_CLASS),'-') -- 申报类型代码
    ,nvl(trim(P1.EXCHANGE_REPORT_TYPE),'-') -- 申报客户类型代码
    ,P1.EXCHANGE_REPORT_NO -- 报送号码
    ,P1.EXCHANGE_TRAN_CODE -- 收入方交易编码
    ,P1.EXCHANGE_TRAN_CODET -- 支出方交易编码
    ,nvl(trim(P1.EXCHANGE_TYPE),'-') -- 结售汇类型代码
    ,P1.EXCHANGE_ITEM_CODE -- 结售汇项目编码
    ,P1.EXCHANGE_TRAN_STATUS -- 结售汇交易状态代码
    ,P1.EXCHANGE_PURPOSE -- 结售汇用途
    ,P1.EXCHANGE_PURPOSE_DETAILS -- 结汇详细用途
    ,P1.DISCOUNT_VALUE -- 客户单户优惠值
    ,P1.INT_RATE_FORM_NO -- 利率审批单编号
    ,nvl(trim(P1.CASH_FROM_CODE),'-') -- 现钞来源代码
    ,nvl(trim(P1.CASH_TO_CODE),'-') -- 现钞提取用途代码
    ,nvl(trim(P1.CASH_FROM_COUNTRY),'XXX') -- 现钞来源国家地区代码
    ,nvl(trim(P1.CASH_TO_COUNTRY),'XXX') -- 现钞去向国家地区代码
    ,nvl(trim(P1.SOURCE_MODULE),'-') -- 源模块类型代码
    ,P1.APPR_USER_ID -- 复核柜员编号
    ,P1.APPROVAL_DATE -- 复核日期
    ,P1.TRAN_DATE -- 交易日期
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.LAST_CHANGE_USER_ID -- 最后修改柜员编号
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_exchange_tran_attach' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_exchange_tran_attach p1
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_wrt_guat_tran_flow_addit_info truncate partition p_ncbsi1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_wrt_guat_tran_flow_addit_info exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_wrt_guat_tran_flow_addit_info_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_wrt_guat_tran_flow_addit_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_wrt_guat_tran_flow_addit_info_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_wrt_guat_tran_flow_addit_info', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);