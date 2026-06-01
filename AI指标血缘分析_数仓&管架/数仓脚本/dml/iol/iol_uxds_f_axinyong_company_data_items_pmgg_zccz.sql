/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_axinyong_company_data_items_pmgg_zccz
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
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz_ex purge;
alter table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,itemnumber -- 项目编号
    ,targetindustry -- 标的行业
    ,itemcontent -- 项目内容
    ,itemtype -- 项目类型
    ,transferor -- 转让方名称
    ,listingenddate -- 挂牌期满日期
    ,city -- 项目地点（市）
    ,datakeyid -- 数据主键id
    ,datatype -- 数据类型值
    ,remark -- 备注
    ,pmgg_zccz -- 关联标签
    ,announcedate -- 发布日期
    ,province -- 项目地点（省）
    ,name -- 项目名称
    ,objectname -- 标的企业名称
    ,exchangename -- 交易所名称
    ,listedprice -- 挂牌价格
    ,listingstartdate -- 挂牌起始日期
    ,region -- 项目地点（区）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,itemnumber -- 项目编号
    ,targetindustry -- 标的行业
    ,itemcontent -- 项目内容
    ,itemtype -- 项目类型
    ,transferor -- 转让方名称
    ,listingenddate -- 挂牌期满日期
    ,city -- 项目地点（市）
    ,datakeyid -- 数据主键id
    ,datatype -- 数据类型值
    ,remark -- 备注
    ,pmgg_zccz -- 关联标签
    ,announcedate -- 发布日期
    ,province -- 项目地点（省）
    ,name -- 项目名称
    ,objectname -- 标的企业名称
    ,exchangename -- 交易所名称
    ,listedprice -- 挂牌价格
    ,listingstartdate -- 挂牌起始日期
    ,region -- 项目地点（区）
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_axinyong_company_data_items_pmgg_zccz',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);