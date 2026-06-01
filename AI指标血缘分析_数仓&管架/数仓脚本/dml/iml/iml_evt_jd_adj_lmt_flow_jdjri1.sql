/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_jd_adj_lmt_flow_jdjri1
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
drop table ${iml_schema}.evt_jd_adj_lmt_flow_jdjri1_tm purge;
alter table ${iml_schema}.evt_jd_adj_lmt_flow add partition p_jdjri1 values ('jdjri1')(
        subpartition p_jdjri1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_jd_adj_lmt_flow modify partition p_jdjri1
    add subpartition p_jdjri1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_jd_adj_lmt_flow_jdjri1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,adj_lmt_flow_id -- 调额流水编号
    ,jd_cust_id -- 外部客户编号
    ,prod_cd -- 产品代码
    ,cust_lmt_id -- 客户额度编号
    ,adj_lmt_type_cd -- 调额类型代码
    ,adj_lmt_way_cd -- 调额方式代码
    ,adj_lmt -- 调额额度
    ,adj_lmt_bf_crdt_lmt -- 调额前授信额度
    ,adj_lmt_post_crdt_lmt -- 调额后授信额度
    ,adj_lmt_dt -- 调额日期
    ,adj_lmt_effect_dt -- 调额生效日期
    ,prod_id -- 产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_jd_adj_lmt_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_jdjr_quotaadjust_info-
insert into ${iml_schema}.evt_jd_adj_lmt_flow_jdjri1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,adj_lmt_flow_id -- 调额流水编号
    ,jd_cust_id -- 外部客户编号
    ,prod_cd -- 产品代码
    ,cust_lmt_id -- 客户额度编号
    ,adj_lmt_type_cd -- 调额类型代码
    ,adj_lmt_way_cd -- 调额方式代码
    ,adj_lmt -- 调额额度
    ,adj_lmt_bf_crdt_lmt -- 调额前授信额度
    ,adj_lmt_post_crdt_lmt -- 调额后授信额度
    ,adj_lmt_dt -- 调额日期
    ,adj_lmt_effect_dt -- 调额生效日期
    ,prod_id -- 产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102035'||P1.ADJUSTLIMITNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ADJUSTLIMITNO -- 调额流水编号
    ,P1.CUSNO -- 外部客户编号
    ,P1.PRDNO -- 产品代码
    ,P1.LIMITNO -- 客户额度编号
    ,P1.LIMITUPDOWN -- 调额类型代码
    ,P1.ADJUSTTYPE -- 调额方式代码
    ,P1.ADJUSTLIMIT -- 调额额度
    ,P1.BEFOREADJUSTLIMIT -- 调额前授信额度
    ,P1.AFTERADJUSTLIMIT -- 调额后授信额度
    ,${iml_schema}.DATEFORMAT_MIN(trim(P1.ADJUSTDT)) -- 调额日期
    ,${iml_schema}.DATEFORMAT_MIN(trim(P1.ADJUSTSTARTDT)) -- 调额生效日期
    ,P1.PRDCODE -- 产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_jdjr_quotaadjust_info' -- 源表名称
    ,'jdjri1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_jdjr_quotaadjust_info p1
where  1 = 1 
    and p1.BUSSDATE = '${batch_date}' 
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_jd_adj_lmt_flow truncate subpartition p_jdjri1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_jd_adj_lmt_flow exchange subpartition p_jdjri1_${batch_date} with table ${iml_schema}.evt_jd_adj_lmt_flow_jdjri1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_jd_adj_lmt_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_jd_adj_lmt_flow_jdjri1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_jd_adj_lmt_flow', partname => 'p_jdjri1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);