/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_fbs_v_accentry2
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_accentry2_ex purge;
alter table ${iol_schema}.ctms_fbs_v_accentry2 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ctms_fbs_v_accentry2;

-- 2.3 insert data to ex table
create table ${iol_schema}.ctms_fbs_v_accentry2_ex nologging
compress
as
select * from ${iol_schema}.ctms_fbs_v_accentry2 where 0=1;

insert /*+ append */ into ${iol_schema}.ctms_fbs_v_accentry2_ex(
    alterbalance_id -- 变动明细唯一识别代码
    ,cusnumber -- 机构编号
    ,branch_number -- 分支机构编号
    ,accentry2_id -- 分录唯一识别代码
    ,view_table -- 关联原交易表表名
    ,settledate -- 出账日期
    ,acccode -- 分录定义编号
    ,acctype -- 分录类型 1：交易分录 2：交割分录 3：估值分录 4：敞口损益分录 5：手工调账分录 6：计提分录
    ,keepfolder_id -- 账户编号
    ,accountingcode -- 科目编号
    ,accountingdesc -- 科目名称
    ,debitcredit -- 借贷方向 D:借 C:贷
    ,crncy_code -- 货币编号
    ,ald_crncy_ename -- 货币
    ,inouttype -- 表内表外 I：表内 O:表外
    ,accentry2_id_rev -- 冲回分录id
    ,lastmodified -- 修改实际
    ,amount -- 金额
    ,dealsqno -- 交易编号
    ,rev_flag -- 冲回标志 1:冲回 0:不冲回
    ,event_name -- 会计事件名称
    ,deal_sqno -- 交易编号
    ,counter_party_id -- 交易对手编号
    ,counter_party_scname -- 交易对手名称
    ,currency -- 货币名称
    ,ibo_type -- 拆借类型 0：外币拆借（拆入、拆出体现在金额的正负上）； 1：同业存款（同业存放、存放同业体现在金额的正负上）； 2：融资（融入、融出体现在金额的正负上）。
    ,product -- 产品类型 1：即期； 2：远期； 3：掉期；4：期权； 5：拆借； 57：外汇拆借提前支取现金流； 58：外汇拆借/同存 变动现金流； 59：外汇拆借/同存 周期付息； 6：货币掉期； 61：利率互换； 9：贵金属拆借； -9：钆差； 98：违约罚金；11：头寸调拨。
    ,client_deal_sqno -- 成交编号
    ,day_end_date -- 日终出账日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    alterbalance_id -- 变动明细唯一识别代码
    ,cusnumber -- 机构编号
    ,branch_number -- 分支机构编号
    ,accentry2_id -- 分录唯一识别代码
    ,view_table -- 关联原交易表表名
    ,settledate -- 出账日期
    ,acccode -- 分录定义编号
    ,acctype -- 分录类型 1：交易分录 2：交割分录 3：估值分录 4：敞口损益分录 5：手工调账分录 6：计提分录
    ,keepfolder_id -- 账户编号
    ,accountingcode -- 科目编号
    ,accountingdesc -- 科目名称
    ,debitcredit -- 借贷方向 D:借 C:贷
    ,crncy_code -- 货币编号
    ,ald_crncy_ename -- 货币
    ,inouttype -- 表内表外 I：表内 O:表外
    ,accentry2_id_rev -- 冲回分录id
    ,lastmodified -- 修改实际
    ,amount -- 金额
    ,dealsqno -- 交易编号
    ,rev_flag -- 冲回标志 1:冲回 0:不冲回
    ,event_name -- 会计事件名称
    ,deal_sqno -- 交易编号
    ,counter_party_id -- 交易对手编号
    ,counter_party_scname -- 交易对手名称
    ,currency -- 货币名称
    ,ibo_type -- 拆借类型 0：外币拆借（拆入、拆出体现在金额的正负上）； 1：同业存款（同业存放、存放同业体现在金额的正负上）； 2：融资（融入、融出体现在金额的正负上）。
    ,product -- 产品类型 1：即期； 2：远期； 3：掉期；4：期权； 5：拆借； 57：外汇拆借提前支取现金流； 58：外汇拆借/同存 变动现金流； 59：外汇拆借/同存 周期付息； 6：货币掉期； 61：利率互换； 9：贵金属拆借； -9：钆差； 98：违约罚金；11：头寸调拨。
    ,client_deal_sqno -- 成交编号
    ,day_end_date -- 日终出账日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ctms_fbs_v_accentry2
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ctms_fbs_v_accentry2 exchange partition p_${batch_date} with table ${iol_schema}.ctms_fbs_v_accentry2_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_fbs_v_accentry2 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ctms_fbs_v_accentry2_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_fbs_v_accentry2',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);