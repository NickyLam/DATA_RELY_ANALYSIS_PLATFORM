/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_dubil_risk_adj_flow_icmsi1
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
drop table ${iml_schema}.evt_dubil_risk_adj_flow_icmsi1_tm purge;
alter table ${iml_schema}.evt_dubil_risk_adj_flow add partition p_icmsi1 values ('icmsi1')(
        subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_dubil_risk_adj_flow modify partition p_icmsi1
    add subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dubil_risk_adj_flow_icmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,dubil_id -- 借据编号
    ,curr_cd -- 币种代码
    ,bal -- 余额
    ,bf_adj_level5_cls_cd -- 调整前五级分类代码
    ,a_adjust_level5_cls_cd -- 调整后五级分类代码
    ,adj_dt -- 调整日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_dubil_risk_adj_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_classify_change_his-1
insert into ${iml_schema}.evt_dubil_risk_adj_flow_icmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,dubil_id -- 借据编号
    ,curr_cd -- 币种代码
    ,bal -- 余额
    ,bf_adj_level5_cls_cd -- 调整前五级分类代码
    ,a_adjust_level5_cls_cd -- 调整后五级分类代码
    ,adj_dt -- 调整日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401028'||P1.SERIALNO||P1.INPUTDATE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 流水号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,P1.BDSERIALNO -- 借据编号
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.BALANCE -- 余额
    ,nvl(trim(P1.CLASSIFYRESULTOLD),'99') -- 调整前五级分类代码
    ,nvl(trim(P1.CLASSIFYRESULTNEW),'99') -- 调整后五级分类代码
    ,P1.INPUTDATE -- 调整日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_classify_change_his' -- 源表名称
    ,'icmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_classify_change_his p1
where  1 = 1 
     and P1.ETL_DT = to_date(${batch_date},'yyyymmdd') 
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_dubil_risk_adj_flow truncate subpartition p_icmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_dubil_risk_adj_flow exchange subpartition p_icmsi1_${batch_date} with table ${iml_schema}.evt_dubil_risk_adj_flow_icmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_dubil_risk_adj_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_dubil_risk_adj_flow_icmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_dubil_risk_adj_flow', partname => 'p_icmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);