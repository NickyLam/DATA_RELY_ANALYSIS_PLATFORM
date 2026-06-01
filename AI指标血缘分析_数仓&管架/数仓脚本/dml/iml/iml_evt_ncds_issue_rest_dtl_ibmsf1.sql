/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ncds_issue_rest_dtl_ibmsf1
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
drop table ${iml_schema}.evt_ncds_issue_rest_dtl_ibmsf1_tm purge;
alter table ${iml_schema}.evt_ncds_issue_rest_dtl add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ncds_issue_rest_dtl modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ncds_issue_rest_dtl_ibmsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_odd_no -- 交易单号
    ,sub_tran_odd_no -- 子交易单号
    ,dep_rcpt_cd -- 存单代码
    ,dep_rcpt_asset_type_cd -- 存单资产类型代码
    ,dep_rcpt_market_type_cd -- 存单市场类型代码
    ,issue_way_cd -- 发行方式代码
    ,subscr_ps_id -- 认购人ID
    ,subscr_ps_name -- 认购人名称
    ,bid_price -- 投标价位(元)
    ,bid_qtty -- 投标量(亿元)
    ,hit_bid_price -- 中标价位(元)
    ,hit_bid_qtty -- 中标量(亿元)
    ,subscr_tm -- 认购时间
    ,submit_user -- 提交用户
    ,actl_subscr_qtty -- 实际认购量
    ,remark -- 备注
    ,sell_org -- 销售机构
    ,fee_calc_rule_cd -- 费用计算规则代码
    ,actl_subscr_ps_id -- 实际认购人编号
    ,actl_subscr_ps_name -- 实际认购人名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ncds_issue_rest_dtl
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ibms_ttrd_ncd_result_details-
insert into ${iml_schema}.evt_ncds_issue_rest_dtl_ibmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_odd_no -- 交易单号
    ,sub_tran_odd_no -- 子交易单号
    ,dep_rcpt_cd -- 存单代码
    ,dep_rcpt_asset_type_cd -- 存单资产类型代码
    ,dep_rcpt_market_type_cd -- 存单市场类型代码
    ,issue_way_cd -- 发行方式代码
    ,subscr_ps_id -- 认购人ID
    ,subscr_ps_name -- 认购人名称
    ,bid_price -- 投标价位(元)
    ,bid_qtty -- 投标量(亿元)
    ,hit_bid_price -- 中标价位(元)
    ,hit_bid_qtty -- 中标量(亿元)
    ,subscr_tm -- 认购时间
    ,submit_user -- 提交用户
    ,actl_subscr_qtty -- 实际认购量
    ,remark -- 备注
    ,sell_org -- 销售机构
    ,fee_calc_rule_cd -- 费用计算规则代码
    ,actl_subscr_ps_id -- 实际认购人编号
    ,actl_subscr_ps_name -- 实际认购人名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104017'||P1.SEQ_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SYSORDID -- 交易单号
    ,P1.REF_SYSORDID -- 子交易单号
    ,P1.I_CODE -- 存单代码
    ,P1.A_TYPE -- 存单资产类型代码
    ,P1.M_TYPE -- 存单市场类型代码
    ,NVL(TRIM(P1.ISSUE_TYPE),'-') -- 发行方式代码
    ,P1.PARTYID -- 认购人ID
    ,P1.PARTYNAME -- 认购人名称
    ,P1.BID_PRICE -- 投标价位(元)
    ,P1.BID_AMOUNT -- 投标量(亿元)
    ,P1.BIDDING_PRICE -- 中标价位(元)
    ,P1.BIDDING_AMOUNT -- 中标量(亿元)
    ,${iml_schema}.DATEFORMAT_MIN(P1.BID_TIME) -- 认购时间
    ,P1.USERNAME -- 提交用户
    ,P1.BIDDING_ACTUAL_AMOUNT -- 实际认购量
    ,P1.MEMO -- 备注
    ,P1.SALES_ORGANIZATION -- 销售机构
    ,NVL(TRIM(P1.COST_CALCULATE_RULE),'-') -- 费用计算规则代码
    ,to_char(P1.REAL_PARTY_ID) -- 实际认购人编号
    ,P1.REAL_PARTY_ID -- 实际认购人名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_ncd_result_details' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_ncd_result_details p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_ncds_issue_rest_dtl truncate partition p_ibmsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ncds_issue_rest_dtl exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.evt_ncds_issue_rest_dtl_ibmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ncds_issue_rest_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ncds_issue_rest_dtl_ibmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ncds_issue_rest_dtl', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);