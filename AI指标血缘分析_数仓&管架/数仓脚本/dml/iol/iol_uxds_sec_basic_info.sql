/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_sec_basic_info
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
drop table ${iol_schema}.uxds_sec_basic_info_ex purge;
alter table ${iol_schema}.uxds_sec_basic_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.uxds_sec_basic_info;

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_sec_basic_info_ex nologging
compress
as
select * from ${iol_schema}.uxds_sec_basic_info where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_sec_basic_info_ex(
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录通讯到用户端时间
    ,sec_issuer_id -- 证券发行主体id
    ,sec_code -- 证券代码
    ,sec_short_name_cn -- 证券简称(中文)
    ,phonetic_short_name -- 拼音简称
    ,sec_full_name -- 证券全称
    ,sec_type_code -- 证券类别编码@关联到sec_classi_public_code_table.ctgry_code
    ,sec_type -- 证券类别@阳光私募
    ,td_mkt_encode -- 交易市场编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=212
    ,td_mkt -- 交易市场
    ,listed_date -- 上市日期
    ,stop_listing_date -- 终止上市日期
    ,issue_org_id -- 发行机构id@关联到corp_basic_info.org_id
    ,listed_status_code -- 上市状态编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=213
    ,listed_status -- 上市状态@包括：正常上市、终止上市、暂停上市、ST、*ST、已发行未上市等
    ,thscode -- 同花顺代码
    ,sec_id -- 证券id
    ,is_listing -- 是否上市@0：否；1：是
    ,is_delisted -- 是否摘牌@0：否；1：是
    ,listed_board_code -- 上市板编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=216
    ,listed_board_name -- 上市板名称
    ,td_currency_code -- 交易货币代码@关联到public_code_table.ctgry_code，public_code_table.class_encode=518
    ,td_currency_name -- 交易货币名称
    ,isin -- 全球证券分类识别码
    ,cusip -- 美国统一证券识别编码
    ,sec_full_name_en -- 证券英文全称
    ,sec_short_name_en -- 证券简称(英文)
    ,isvalid -- 是否有效
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录通讯到用户端时间
    ,sec_issuer_id -- 证券发行主体id
    ,sec_code -- 证券代码
    ,sec_short_name_cn -- 证券简称(中文)
    ,phonetic_short_name -- 拼音简称
    ,sec_full_name -- 证券全称
    ,sec_type_code -- 证券类别编码@关联到sec_classi_public_code_table.ctgry_code
    ,sec_type -- 证券类别@阳光私募
    ,td_mkt_encode -- 交易市场编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=212
    ,td_mkt -- 交易市场
    ,listed_date -- 上市日期
    ,stop_listing_date -- 终止上市日期
    ,issue_org_id -- 发行机构id@关联到corp_basic_info.org_id
    ,listed_status_code -- 上市状态编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=213
    ,listed_status -- 上市状态@包括：正常上市、终止上市、暂停上市、ST、*ST、已发行未上市等
    ,thscode -- 同花顺代码
    ,sec_id -- 证券id
    ,is_listing -- 是否上市@0：否；1：是
    ,is_delisted -- 是否摘牌@0：否；1：是
    ,listed_board_code -- 上市板编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=216
    ,listed_board_name -- 上市板名称
    ,td_currency_code -- 交易货币代码@关联到public_code_table.ctgry_code，public_code_table.class_encode=518
    ,td_currency_name -- 交易货币名称
    ,isin -- 全球证券分类识别码
    ,cusip -- 美国统一证券识别编码
    ,sec_full_name_en -- 证券英文全称
    ,sec_short_name_en -- 证券简称(英文)
    ,isvalid -- 是否有效
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_sec_basic_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_sec_basic_info exchange partition p_${batch_date} with table ${iol_schema}.uxds_sec_basic_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_sec_basic_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_sec_basic_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_sec_basic_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);