/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scrm_we_news_trends
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
drop table ${iol_schema}.scrm_we_news_trends_ex purge;
alter table ${iol_schema}.scrm_we_news_trends add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.scrm_we_news_trends truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.scrm_we_news_trends_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scrm_we_news_trends where 0=1;

insert /*+ append */ into ${iol_schema}.scrm_we_news_trends_ex(
    trends_id -- 
    ,external_userid -- 
    ,external_username -- 外部联系人的姓名
    ,opr_prsn_id -- 
    ,vist_func_id -- 1云店 2 早报 3：资讯
    ,counts -- 
    ,mov_tp_cd -- 操作类型
    ,mov_tp_nm -- 
    ,mov_title -- 动态标题
    ,mov_inf_dsc -- 动态描述
    ,mov_dt -- 动态日期
    ,mov_tm -- 动态时间
    ,corp_id -- 
    ,opr_prsn_name -- 操作人姓名
    ,mobile -- 手机号
    ,type_id -- 类型ID
    ,trends_type -- 记录类型 1：浏览  2：分享
    ,cust_type -- 操作角色类型0客户 1客户经理
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    trends_id -- 
    ,external_userid -- 
    ,external_username -- 外部联系人的姓名
    ,opr_prsn_id -- 
    ,vist_func_id -- 1云店 2 早报 3：资讯
    ,counts -- 
    ,mov_tp_cd -- 操作类型
    ,mov_tp_nm -- 
    ,mov_title -- 动态标题
    ,mov_inf_dsc -- 动态描述
    ,mov_dt -- 动态日期
    ,mov_tm -- 动态时间
    ,corp_id -- 
    ,opr_prsn_name -- 操作人姓名
    ,mobile -- 手机号
    ,type_id -- 类型ID
    ,trends_type -- 记录类型 1：浏览  2：分享
    ,cust_type -- 操作角色类型0客户 1客户经理
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.scrm_we_news_trends
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.scrm_we_news_trends exchange partition p_${batch_date} with table ${iol_schema}.scrm_we_news_trends_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scrm_we_news_trends to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.scrm_we_news_trends_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scrm_we_news_trends',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);