/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybk_cs_extent_info
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
drop table ${iol_schema}.icms_mybk_cs_extent_info_ex purge;
alter table ${iol_schema}.icms_mybk_cs_extent_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_mybk_cs_extent_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_mybk_cs_extent_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybk_cs_extent_info where 0=1;

insert /*+ append */ into ${iol_schema}.icms_mybk_cs_extent_info_ex(
    serno -- 流水号
    ,registeraddressarea -- 注册地省市区
    ,statusid -- 经营状态
    ,sex -- 性别
    ,city -- 城市
    ,registerno -- 工商注册号
    ,orgcode -- 组织机构号
    ,managebegindate -- 经营开始时间
    ,opendate -- 开业时间
    ,economictype -- 公司经济类型
    ,registeraddressareacode -- 注册地址行政区编号
    ,area -- 地区
    ,companytype -- 公司类型
    ,registerdate -- 注册时间
    ,industryname -- 客群主营行业
    ,nationality -- 国籍
    ,registeraddress -- 注册地址
    ,registerdepartment -- 注册工商局
    ,migtflag -- 迁移标志：crsrcrilcupl
    ,busdatareqdate -- 采集时间
    ,businfoexistflag -- 是否存有效商信息
    ,fundcurrency -- 币种
    ,companyinfoname -- 公司名
    ,tradecode -- 行业代码
    ,managerange -- 经营范围
    ,mobile -- 手机号码
    ,certvalidenddate -- 证件有效期
    ,statusdesc -- 经营状态描述
    ,certvalidstartdate -- 证件有效期起始日
    ,manageenddate -- 经营结束时间
    ,targetjyflag1 -- 客群经营标签（经营场景)
    ,applyno -- 蚂蚁申请编号
    ,companyinfolawer -- 法定代表
    ,registerfund -- 注册资本(万元)
    ,address -- 地址信息
    ,prov -- 省份
    ,notexistreason -- 无有效工商信息原因
    ,lastcheckyear -- 最后年检年度
    ,indivocc -- 职业
    ,isestimatemode -- 是否预估授信
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serno -- 流水号
    ,registeraddressarea -- 注册地省市区
    ,statusid -- 经营状态
    ,sex -- 性别
    ,city -- 城市
    ,registerno -- 工商注册号
    ,orgcode -- 组织机构号
    ,managebegindate -- 经营开始时间
    ,opendate -- 开业时间
    ,economictype -- 公司经济类型
    ,registeraddressareacode -- 注册地址行政区编号
    ,area -- 地区
    ,companytype -- 公司类型
    ,registerdate -- 注册时间
    ,industryname -- 客群主营行业
    ,nationality -- 国籍
    ,registeraddress -- 注册地址
    ,registerdepartment -- 注册工商局
    ,migtflag -- 迁移标志：crsrcrilcupl
    ,busdatareqdate -- 采集时间
    ,businfoexistflag -- 是否存有效商信息
    ,fundcurrency -- 币种
    ,companyinfoname -- 公司名
    ,tradecode -- 行业代码
    ,managerange -- 经营范围
    ,mobile -- 手机号码
    ,certvalidenddate -- 证件有效期
    ,statusdesc -- 经营状态描述
    ,certvalidstartdate -- 证件有效期起始日
    ,manageenddate -- 经营结束时间
    ,targetjyflag1 -- 客群经营标签（经营场景)
    ,applyno -- 蚂蚁申请编号
    ,companyinfolawer -- 法定代表
    ,registerfund -- 注册资本(万元)
    ,address -- 地址信息
    ,prov -- 省份
    ,notexistreason -- 无有效工商信息原因
    ,lastcheckyear -- 最后年检年度
    ,indivocc -- 职业
    ,isestimatemode -- 是否预估授信
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_mybk_cs_extent_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_mybk_cs_extent_info exchange partition p_${batch_date} with table ${iol_schema}.icms_mybk_cs_extent_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybk_cs_extent_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_mybk_cs_extent_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybk_cs_extent_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);