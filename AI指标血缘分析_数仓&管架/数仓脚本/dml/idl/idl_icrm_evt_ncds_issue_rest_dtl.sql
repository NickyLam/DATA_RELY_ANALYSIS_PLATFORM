/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_evt_ncds_issue_rest_dtl
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icrm_evt_ncds_issue_rest_dtl drop partition p_${last_date};
alter table ${idl_schema}.icrm_evt_ncds_issue_rest_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_evt_ncds_issue_rest_dtl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_evt_ncds_issue_rest_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,tran_odd_no  -- 交易单号
    ,sub_tran_odd_no  -- 子交易单号
    ,dep_rcpt_cd  -- 存单代码
    ,dep_rcpt_asset_type_cd  -- 存单资产类型代码
    ,dep_rcpt_market_type_cd  -- 存单市场类型代码
    ,issue_way_cd  -- 发行方式代码
    ,subscr_ps_id  -- 认购人ID
    ,subscr_ps_name  -- 认购人名称
    ,bid_price  -- 投标价位(元)
    ,bid_qtty  -- 投标量(亿元)
    ,hit_bid_price  -- 中标价位(元)
    ,hit_bid_qtty  -- 中标量(亿元)
    ,subscr_tm  -- 认购时间
    ,submit_user  -- 提交用户
    ,actl_subscr_qtty  -- 实际认购量
    ,remark  -- 备注
    ,sell_org  -- 销售机构
    ,fee_calc_rule_cd  -- 费用计算规则代码
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.tran_odd_no,chr(13),''),chr(10),'')  -- 交易单号
    ,replace(replace(t1.sub_tran_odd_no,chr(13),''),chr(10),'')  -- 子交易单号
    ,replace(replace(t1.dep_rcpt_cd,chr(13),''),chr(10),'')  -- 存单代码
    ,replace(replace(t1.dep_rcpt_asset_type_cd,chr(13),''),chr(10),'')  -- 存单资产类型代码
    ,replace(replace(t1.dep_rcpt_market_type_cd,chr(13),''),chr(10),'')  -- 存单市场类型代码
    ,replace(replace(t1.issue_way_cd,chr(13),''),chr(10),'')  -- 发行方式代码
    ,replace(replace(t1.subscr_ps_id,chr(13),''),chr(10),'')  -- 认购人ID
    ,replace(replace(t1.subscr_ps_name,chr(13),''),chr(10),'')  -- 认购人名称
    ,t1.bid_price  -- 投标价位(元)
    ,t1.bid_qtty  -- 投标量(亿元)
    ,t1.hit_bid_price  -- 中标价位(元)
    ,t1.hit_bid_qtty  -- 中标量(亿元)
    ,replace(replace(t1.subscr_tm,chr(13),''),chr(10),'')  -- 认购时间
    ,replace(replace(t1.submit_user,chr(13),''),chr(10),'')  -- 提交用户
    ,t1.actl_subscr_qtty  -- 实际认购量
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.sell_org,chr(13),''),chr(10),'')  -- 销售机构
    ,replace(replace(t1.fee_calc_rule_cd,chr(13),''),chr(10),'')  -- 费用计算规则代码
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.evt_ncds_issue_rest_dtl t1    --同业存单发行结果明细表
where t1.etl_dt= to_date('${batch_date}','yyyymmdd')  ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_evt_ncds_issue_rest_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);