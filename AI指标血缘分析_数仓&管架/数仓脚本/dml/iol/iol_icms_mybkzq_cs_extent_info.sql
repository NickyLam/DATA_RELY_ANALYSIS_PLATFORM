/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybkzq_cs_extent_info
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
drop table ${iol_schema}.icms_mybkzq_cs_extent_info_ex purge;
alter table ${iol_schema}.icms_mybkzq_cs_extent_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_mybkzq_cs_extent_info;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_mybkzq_cs_extent_info_ex nologging
compress
as
select * from ${iol_schema}.icms_mybkzq_cs_extent_info where 0=1;

insert /*+ append */ into ${iol_schema}.icms_mybkzq_cs_extent_info_ex(
    serialno -- 信贷流水号
    ,applyno -- 债转申请单据号
    ,businessscene -- 业务类型
    ,businesstag -- 与合作机构合作的业务标识
    ,mobile -- 借款人手机号
    ,address -- 地址详情
    ,prov -- 省份
    ,city -- 城市
    ,area -- 区域
    ,certvalidenddate -- 证件有效期
    ,busdatareqdate -- 数据采集时间
    ,businfoexistflag -- 是否存有效工商信息
    ,notexistreason -- 无有效工商信息原因
    ,companyinfoname -- 公司名
    ,companyinfolawer -- 法定代表人
    ,companyinforegisterno -- 工商注册号
    ,companyinforegisterdate -- 注册时间
    ,companyinforegisteraddress -- 注册地址
    ,companyinforegisteraddressareacode -- 注册地址行政区编号
    ,companyinforegisteraddressarea -- 注册地省市区
    ,companyinforegisterfund -- 注册资本(万元)
    ,companyinfofundcurrency -- 币种
    ,companyinfotradecode -- 2017行业代码
    ,companyinfomanagerange -- 经营范围
    ,companyinfoorgcode -- 统一社会信用代码
    ,companyinforegisterdepartment -- 注册工商局
    ,companyinfostatusid -- 经营状态
    ,companyinfostatusdesc -- 经营状态描述
    ,companyinfolastcheckyear -- 最后年检年度
    ,companyinfomanagebegindate -- 经营开始时间
    ,companyinfomanageenddate -- 经营结束时间
    ,companyinfoopendate -- 开业时间
    ,companyinfocompanytype -- 公司类型
    ,companyinfoeconomictype -- 公司经济类型
    ,targetjyflag1 -- 客群经营标识
    ,industryname -- 客群主营行业
    ,custipid -- 借款人在网商的会员ID
    ,custiproleid -- 借款人在网商的会员角色ID
    ,sex -- 性别
    ,transmode -- 债转模式
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno -- 信贷流水号
    ,applyno -- 债转申请单据号
    ,businessscene -- 业务类型
    ,businesstag -- 与合作机构合作的业务标识
    ,mobile -- 借款人手机号
    ,address -- 地址详情
    ,prov -- 省份
    ,city -- 城市
    ,area -- 区域
    ,certvalidenddate -- 证件有效期
    ,busdatareqdate -- 数据采集时间
    ,businfoexistflag -- 是否存有效工商信息
    ,notexistreason -- 无有效工商信息原因
    ,companyinfoname -- 公司名
    ,companyinfolawer -- 法定代表人
    ,companyinforegisterno -- 工商注册号
    ,companyinforegisterdate -- 注册时间
    ,companyinforegisteraddress -- 注册地址
    ,companyinforegisteraddressareacode -- 注册地址行政区编号
    ,companyinforegisteraddressarea -- 注册地省市区
    ,companyinforegisterfund -- 注册资本(万元)
    ,companyinfofundcurrency -- 币种
    ,companyinfotradecode -- 2017行业代码
    ,companyinfomanagerange -- 经营范围
    ,companyinfoorgcode -- 统一社会信用代码
    ,companyinforegisterdepartment -- 注册工商局
    ,companyinfostatusid -- 经营状态
    ,companyinfostatusdesc -- 经营状态描述
    ,companyinfolastcheckyear -- 最后年检年度
    ,companyinfomanagebegindate -- 经营开始时间
    ,companyinfomanageenddate -- 经营结束时间
    ,companyinfoopendate -- 开业时间
    ,companyinfocompanytype -- 公司类型
    ,companyinfoeconomictype -- 公司经济类型
    ,targetjyflag1 -- 客群经营标识
    ,industryname -- 客群主营行业
    ,custipid -- 借款人在网商的会员ID
    ,custiproleid -- 借款人在网商的会员角色ID
    ,sex -- 性别
    ,transmode -- 债转模式
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_mybkzq_cs_extent_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_mybkzq_cs_extent_info exchange partition p_${batch_date} with table ${iol_schema}.icms_mybkzq_cs_extent_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybkzq_cs_extent_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_mybkzq_cs_extent_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybkzq_cs_extent_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);