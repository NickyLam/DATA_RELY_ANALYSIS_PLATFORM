/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_crdt_bus_cont_risk_adj_h_icmsf1
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
drop table ${iml_schema}.agt_crdt_bus_cont_risk_adj_h_icmsf1_tm purge;
alter table ${iml_schema}.agt_crdt_bus_cont_risk_adj_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_crdt_bus_cont_risk_adj_h modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_crdt_bus_cont_risk_adj_h_icmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,bus_cont_id -- 业务合同编号
    ,bus_type_cd -- 业务类型代码
    ,bus_curr_cd -- 业务币种代码
    ,bal -- 余额
    ,bf_adj_level5_cls_cd -- 调整前五级分类代码
    ,a_adjust_level5_cls_cd -- 调整后五级分类代码
    ,bf_adj_level11_cls_cd -- 调整前十一级分类代码
    ,a_adjust_level11_cls_cd -- 调整后十一级分类代码
    ,adj_dt -- 调整日期
    ,mg_prot_teller_id -- 管护柜员编号
    ,mg_prot_org_id -- 管护机构编号
    ,rela_flow_id -- 关联流程编号
    ,rela_flow_type_cd -- 关联流程类型代码
    ,obj_type_cd -- 对象类型代码
    ,obj_descb -- 对象描述
    ,init_teller_id -- 发起柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_crdt_bus_cont_risk_adj_h
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- icms_classify_changehistory-
insert into ${iml_schema}.agt_crdt_bus_cont_risk_adj_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,bus_cont_id -- 业务合同编号
    ,bus_type_cd -- 业务类型代码
    ,bus_curr_cd -- 业务币种代码
    ,bal -- 余额
    ,bf_adj_level5_cls_cd -- 调整前五级分类代码
    ,a_adjust_level5_cls_cd -- 调整后五级分类代码
    ,bf_adj_level11_cls_cd -- 调整前十一级分类代码
    ,a_adjust_level11_cls_cd -- 调整后十一级分类代码
    ,adj_dt -- 调整日期
    ,mg_prot_teller_id -- 管护柜员编号
    ,mg_prot_org_id -- 管护机构编号
    ,rela_flow_id -- 关联流程编号
    ,rela_flow_type_cd -- 关联流程类型代码
    ,obj_type_cd -- 对象类型代码
    ,obj_descb -- 对象描述
    ,init_teller_id -- 发起柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300027'||p1.serialno -- 协议编号
    ,'9999' -- 法人编号
    ,p1.serialno -- 流水号
    ,NVL(TRIM(P2.MFCUSTOMERID),P2.CUSTOMERID) -- 客户编号
    ,p1.customername -- 客户名称
    ,p1.contractserialno -- 业务合同编号
    ,p1.businesstype -- 业务类型代码
    ,nvl(trim(P1.businesscurrency),'-') -- 业务币种代码
    ,p1.balance -- 余额
    ,nvl(trim(P1.LASTCLASSIFYFIVE),'99') -- 调整前五级分类代码
    ,nvl(trim(P1.AFTERCLASSIFYFIVE),'99') -- 调整后五级分类代码
    ,nvl(trim(P1.LASTCLASSIFYELEVEN),'20') -- 调整前十一级分类代码
    ,nvl(trim(P1.AFTERCLASSIFYELEVEN),'20')  -- 调整后十一级分类代码
    ,p1.changetime -- 调整日期
    ,p1.operateuserid -- 管护柜员编号
    ,p1.operateorgid -- 管护机构编号
    ,p1.relativeserialno -- 关联流程编号
    ,nvl(trim(p1.relativetype),'-') -- 关联流程类型代码
    ,p1.objectype -- 对象类型代码
    ,p1.objectno -- 对象描述
    ,p1.flowinputuserid -- 发起柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_classify_changehistory' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_classify_changehistory p1
    LEFT JOIN ${iol_schema}.icms_customer_info p2
    on p1.customerid=p2.customerid 
    and P2.start_dt<= to_date('${batch_date}','yyyymmdd') 
    and P2.end_dt > to_date('${batch_date}','yyyymmdd')
    AND P2.Customerid NOT in ('2015090700000114',
                                 '2014060300000006',
                                 '2013041000000004',
                                 '2013120300000025',
                                 '2013061300000012',
                                 '2013022800000015',
                                 '2014061000000019',
                                 '2014101700000011',
                                 '#OwnerID',
                                 '2015081300000033')
where  1 = 1 
    and P1.start_dt<= to_date('${batch_date}','yyyymmdd') 
    and P1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.agt_crdt_bus_cont_risk_adj_h truncate partition p_icmsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.agt_crdt_bus_cont_risk_adj_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_crdt_bus_cont_risk_adj_h_icmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_crdt_bus_cont_risk_adj_h to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_crdt_bus_cont_risk_adj_h_icmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_crdt_bus_cont_risk_adj_h', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);