/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_shareholder_list
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
drop table ${iol_schema}.uxds_shareholder_list_ex purge;
alter table ${iol_schema}.uxds_shareholder_list add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.uxds_shareholder_list;

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_shareholder_list_ex nologging
compress
as
select * from ${iol_schema}.uxds_shareholder_list where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_shareholder_list_ex(
    seq -- 记录唯一标识
    ,ctime -- 记录创建日期
    ,mtime -- 记录修改日期
    ,rtime -- 记录通讯到用户端日期
    ,held_num -- 持有数量
    ,held_num_res_share -- 持股数量-限售股份
    ,held_num_unlim_share -- 持股数量-无限售股份
    ,held_ratio -- 持有比例
    ,holder_ctgry -- 股东类别
    ,holder_id -- 股东id
    ,holder_name -- 股东名称
    ,holder_rank -- 股东名次
    ,holder_type_code -- 股东类别编码
    ,is_holder_org -- 股东是否机构
    ,pledge_num -- 质押数量
    ,publish_date -- 公布日期
    ,share_ctgry -- 股份类别
    ,share_pledge_frozen_num -- 股份质押冻结数量
    ,share_type_code -- 股份类别编码
    ,acting_concert_sign -- 一致行动人标志
    ,top10_holders_rr_expalin -- 前10名股东之间存在关联关系或一致行动人的说明
    ,corp_code -- 公司代码
    ,ed -- 截止日期
    ,frozen_num -- 冻结数量
    ,isvalid -- 是否有效
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    seq -- 记录唯一标识
    ,ctime -- 记录创建日期
    ,mtime -- 记录修改日期
    ,rtime -- 记录通讯到用户端日期
    ,held_num -- 持有数量
    ,held_num_res_share -- 持股数量-限售股份
    ,held_num_unlim_share -- 持股数量-无限售股份
    ,held_ratio -- 持有比例
    ,holder_ctgry -- 股东类别
    ,holder_id -- 股东id
    ,holder_name -- 股东名称
    ,holder_rank -- 股东名次
    ,holder_type_code -- 股东类别编码
    ,is_holder_org -- 股东是否机构
    ,pledge_num -- 质押数量
    ,publish_date -- 公布日期
    ,share_ctgry -- 股份类别
    ,share_pledge_frozen_num -- 股份质押冻结数量
    ,share_type_code -- 股份类别编码
    ,acting_concert_sign -- 一致行动人标志
    ,top10_holders_rr_expalin -- 前10名股东之间存在关联关系或一致行动人的说明
    ,corp_code -- 公司代码
    ,ed -- 截止日期
    ,frozen_num -- 冻结数量
    ,isvalid -- 是否有效
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_shareholder_list
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_shareholder_list exchange partition p_${batch_date} with table ${iol_schema}.uxds_shareholder_list_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_shareholder_list to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_shareholder_list_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_shareholder_list',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);