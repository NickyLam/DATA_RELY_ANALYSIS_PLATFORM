/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_huikehongye_document_company_info_arr
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
drop table ${iol_schema}.uxds_f_huikehongye_document_company_info_arr_ex purge;
alter table ${iol_schema}.uxds_f_huikehongye_document_company_info_arr add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.uxds_f_huikehongye_document_company_info_arr truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_huikehongye_document_company_info_arr_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_f_huikehongye_document_company_info_arr where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_huikehongye_document_company_info_arr_ex(
    gendate -- 生成时间
    ,sequenceid -- 系统流水号
    ,location -- 所在地
    ,label_id -- 标签号
    ,industry_1 -- 行业分类1级
    ,industry_2 -- 行业分类2级
    ,industry_3 -- 行业分类3级
    ,industry_4 -- 行业分类4级
    ,sentiment -- 情感得分
    ,sentiment_score -- 情感得分
    ,cn_name -- 中文名称
    ,en_name -- 英文名称
    ,cn_short_name -- 中文名称简称
    ,type -- 公司类型
    ,br_code -- 商业登记号(备用)
    ,stock_name -- 股票名称
    ,stock_code -- 股票代码
    ,bond_code -- 债劵代码
    ,credit_code -- 统一社会信用代码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,sequenceid -- 系统流水号
    ,location -- 所在地
    ,label_id -- 标签号
    ,industry_1 -- 行业分类1级
    ,industry_2 -- 行业分类2级
    ,industry_3 -- 行业分类3级
    ,industry_4 -- 行业分类4级
    ,sentiment -- 情感得分
    ,sentiment_score -- 情感得分
    ,cn_name -- 中文名称
    ,en_name -- 英文名称
    ,cn_short_name -- 中文名称简称
    ,type -- 公司类型
    ,br_code -- 商业登记号(备用)
    ,stock_name -- 股票名称
    ,stock_code -- 股票代码
    ,bond_code -- 债劵代码
    ,credit_code -- 统一社会信用代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_huikehongye_document_company_info_arr
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_huikehongye_document_company_info_arr exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_huikehongye_document_company_info_arr_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_huikehongye_document_company_info_arr to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_huikehongye_document_company_info_arr_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_huikehongye_document_company_info_arr',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);