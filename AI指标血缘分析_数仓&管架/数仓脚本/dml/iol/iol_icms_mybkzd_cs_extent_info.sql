/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybkzd_cs_extent_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.icms_mybkzd_cs_extent_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_mybkzd_cs_extent_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybkzd_cs_extent_info_op purge;
drop table ${iol_schema}.icms_mybkzd_cs_extent_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzd_cs_extent_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybkzd_cs_extent_info where 0=1;

create table ${iol_schema}.icms_mybkzd_cs_extent_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybkzd_cs_extent_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybkzd_cs_extent_info_cl(
            serialno -- 流水号
            ,applyno -- 蚂蚁申请编号
            ,mobile -- 手机号码
            ,address -- 地址信息
            ,prov -- 省份
            ,city -- 城市
            ,area -- 地区
            ,certvalidenddate -- 证件有效期
            ,busdatareqdate -- 采集时间
            ,businfoexistflag -- 是否存有效商信息
            ,notexistreason -- 无有效工商信息原因
            ,companyinfoname -- 公司名
            ,companyinfolawer -- 法定代表
            ,registerno -- 工商注册号
            ,registerdate -- 注册时间
            ,registeraddress -- 注册地址
            ,registeraddressareacode -- 注册地址行政区编号
            ,registeraddressarea -- 注册地省市区
            ,registerfund -- 注册资本(万元)
            ,fundcurrency -- 币种
            ,tradecode -- 行业代码
            ,managerange -- 经营范围
            ,orgcode -- 组织机构号
            ,registerdepartment -- 注册工商局
            ,statusid -- 经营状态
            ,statusdesc -- 经营状态描述
            ,lastcheckyear -- 最后年检年度
            ,managebegindate -- 经营开始时间
            ,manageenddate -- 经营结束时间
            ,opendate -- 开业时间
            ,companytype -- 公司类型
            ,economictype -- 公司经济类型
            ,targetjyflag1 -- 客群经营标签（经营场景)
            ,industryname -- 客群主营行业
            ,certvalidstartdate -- 证件有效期起始日
            ,sex -- 性别
            ,indivocc -- 职业
            ,nationality -- 国籍
            ,businessscene -- 业务场景
            ,businesstag -- 业务标识
            ,pushreason -- 客群区分标识
            ,custverifytype -- 核身方式
            ,custverifyresult -- 核身结果
            ,custverifytime -- 核身通过时间
            ,customertag -- 客群标
            ,employee_id -- 推广者员工号
            ,nation -- 民族
            ,company_info_org_code -- 统一社会信用代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybkzd_cs_extent_info_op(
            serialno -- 流水号
            ,applyno -- 蚂蚁申请编号
            ,mobile -- 手机号码
            ,address -- 地址信息
            ,prov -- 省份
            ,city -- 城市
            ,area -- 地区
            ,certvalidenddate -- 证件有效期
            ,busdatareqdate -- 采集时间
            ,businfoexistflag -- 是否存有效商信息
            ,notexistreason -- 无有效工商信息原因
            ,companyinfoname -- 公司名
            ,companyinfolawer -- 法定代表
            ,registerno -- 工商注册号
            ,registerdate -- 注册时间
            ,registeraddress -- 注册地址
            ,registeraddressareacode -- 注册地址行政区编号
            ,registeraddressarea -- 注册地省市区
            ,registerfund -- 注册资本(万元)
            ,fundcurrency -- 币种
            ,tradecode -- 行业代码
            ,managerange -- 经营范围
            ,orgcode -- 组织机构号
            ,registerdepartment -- 注册工商局
            ,statusid -- 经营状态
            ,statusdesc -- 经营状态描述
            ,lastcheckyear -- 最后年检年度
            ,managebegindate -- 经营开始时间
            ,manageenddate -- 经营结束时间
            ,opendate -- 开业时间
            ,companytype -- 公司类型
            ,economictype -- 公司经济类型
            ,targetjyflag1 -- 客群经营标签（经营场景)
            ,industryname -- 客群主营行业
            ,certvalidstartdate -- 证件有效期起始日
            ,sex -- 性别
            ,indivocc -- 职业
            ,nationality -- 国籍
            ,businessscene -- 业务场景
            ,businesstag -- 业务标识
            ,pushreason -- 客群区分标识
            ,custverifytype -- 核身方式
            ,custverifyresult -- 核身结果
            ,custverifytime -- 核身通过时间
            ,customertag -- 客群标
            ,employee_id -- 推广者员工号
            ,nation -- 民族
            ,company_info_org_code -- 统一社会信用代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.applyno, o.applyno) as applyno -- 蚂蚁申请编号
    ,nvl(n.mobile, o.mobile) as mobile -- 手机号码
    ,nvl(n.address, o.address) as address -- 地址信息
    ,nvl(n.prov, o.prov) as prov -- 省份
    ,nvl(n.city, o.city) as city -- 城市
    ,nvl(n.area, o.area) as area -- 地区
    ,nvl(n.certvalidenddate, o.certvalidenddate) as certvalidenddate -- 证件有效期
    ,nvl(n.busdatareqdate, o.busdatareqdate) as busdatareqdate -- 采集时间
    ,nvl(n.businfoexistflag, o.businfoexistflag) as businfoexistflag -- 是否存有效商信息
    ,nvl(n.notexistreason, o.notexistreason) as notexistreason -- 无有效工商信息原因
    ,nvl(n.companyinfoname, o.companyinfoname) as companyinfoname -- 公司名
    ,nvl(n.companyinfolawer, o.companyinfolawer) as companyinfolawer -- 法定代表
    ,nvl(n.registerno, o.registerno) as registerno -- 工商注册号
    ,nvl(n.registerdate, o.registerdate) as registerdate -- 注册时间
    ,nvl(n.registeraddress, o.registeraddress) as registeraddress -- 注册地址
    ,nvl(n.registeraddressareacode, o.registeraddressareacode) as registeraddressareacode -- 注册地址行政区编号
    ,nvl(n.registeraddressarea, o.registeraddressarea) as registeraddressarea -- 注册地省市区
    ,nvl(n.registerfund, o.registerfund) as registerfund -- 注册资本(万元)
    ,nvl(n.fundcurrency, o.fundcurrency) as fundcurrency -- 币种
    ,nvl(n.tradecode, o.tradecode) as tradecode -- 行业代码
    ,nvl(n.managerange, o.managerange) as managerange -- 经营范围
    ,nvl(n.orgcode, o.orgcode) as orgcode -- 组织机构号
    ,nvl(n.registerdepartment, o.registerdepartment) as registerdepartment -- 注册工商局
    ,nvl(n.statusid, o.statusid) as statusid -- 经营状态
    ,nvl(n.statusdesc, o.statusdesc) as statusdesc -- 经营状态描述
    ,nvl(n.lastcheckyear, o.lastcheckyear) as lastcheckyear -- 最后年检年度
    ,nvl(n.managebegindate, o.managebegindate) as managebegindate -- 经营开始时间
    ,nvl(n.manageenddate, o.manageenddate) as manageenddate -- 经营结束时间
    ,nvl(n.opendate, o.opendate) as opendate -- 开业时间
    ,nvl(n.companytype, o.companytype) as companytype -- 公司类型
    ,nvl(n.economictype, o.economictype) as economictype -- 公司经济类型
    ,nvl(n.targetjyflag1, o.targetjyflag1) as targetjyflag1 -- 客群经营标签（经营场景)
    ,nvl(n.industryname, o.industryname) as industryname -- 客群主营行业
    ,nvl(n.certvalidstartdate, o.certvalidstartdate) as certvalidstartdate -- 证件有效期起始日
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.indivocc, o.indivocc) as indivocc -- 职业
    ,nvl(n.nationality, o.nationality) as nationality -- 国籍
    ,nvl(n.businessscene, o.businessscene) as businessscene -- 业务场景
    ,nvl(n.businesstag, o.businesstag) as businesstag -- 业务标识
    ,nvl(n.pushreason, o.pushreason) as pushreason -- 客群区分标识
    ,nvl(n.custverifytype, o.custverifytype) as custverifytype -- 核身方式
    ,nvl(n.custverifyresult, o.custverifyresult) as custverifyresult -- 核身结果
    ,nvl(n.custverifytime, o.custverifytime) as custverifytime -- 核身通过时间
    ,nvl(n.customertag, o.customertag) as customertag -- 客群标
    ,nvl(n.employee_id, o.employee_id) as employee_id -- 推广者员工号
    ,nvl(n.nation, o.nation) as nation -- 民族
    ,nvl(n.company_info_org_code, o.company_info_org_code) as company_info_org_code -- 统一社会信用代码
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_mybkzd_cs_extent_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_mybkzd_cs_extent_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.applyno <> n.applyno
        or o.mobile <> n.mobile
        or o.address <> n.address
        or o.prov <> n.prov
        or o.city <> n.city
        or o.area <> n.area
        or o.certvalidenddate <> n.certvalidenddate
        or o.busdatareqdate <> n.busdatareqdate
        or o.businfoexistflag <> n.businfoexistflag
        or o.notexistreason <> n.notexistreason
        or o.companyinfoname <> n.companyinfoname
        or o.companyinfolawer <> n.companyinfolawer
        or o.registerno <> n.registerno
        or o.registerdate <> n.registerdate
        or o.registeraddress <> n.registeraddress
        or o.registeraddressareacode <> n.registeraddressareacode
        or o.registeraddressarea <> n.registeraddressarea
        or o.registerfund <> n.registerfund
        or o.fundcurrency <> n.fundcurrency
        or o.tradecode <> n.tradecode
        or o.managerange <> n.managerange
        or o.orgcode <> n.orgcode
        or o.registerdepartment <> n.registerdepartment
        or o.statusid <> n.statusid
        or o.statusdesc <> n.statusdesc
        or o.lastcheckyear <> n.lastcheckyear
        or o.managebegindate <> n.managebegindate
        or o.manageenddate <> n.manageenddate
        or o.opendate <> n.opendate
        or o.companytype <> n.companytype
        or o.economictype <> n.economictype
        or o.targetjyflag1 <> n.targetjyflag1
        or o.industryname <> n.industryname
        or o.certvalidstartdate <> n.certvalidstartdate
        or o.sex <> n.sex
        or o.indivocc <> n.indivocc
        or o.nationality <> n.nationality
        or o.businessscene <> n.businessscene
        or o.businesstag <> n.businesstag
        or o.pushreason <> n.pushreason
        or o.custverifytype <> n.custverifytype
        or o.custverifyresult <> n.custverifyresult
        or o.custverifytime <> n.custverifytime
        or o.customertag <> n.customertag
        or o.employee_id <> n.employee_id
        or o.nation <> n.nation
        or o.company_info_org_code <> n.company_info_org_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybkzd_cs_extent_info_cl(
            serialno -- 流水号
            ,applyno -- 蚂蚁申请编号
            ,mobile -- 手机号码
            ,address -- 地址信息
            ,prov -- 省份
            ,city -- 城市
            ,area -- 地区
            ,certvalidenddate -- 证件有效期
            ,busdatareqdate -- 采集时间
            ,businfoexistflag -- 是否存有效商信息
            ,notexistreason -- 无有效工商信息原因
            ,companyinfoname -- 公司名
            ,companyinfolawer -- 法定代表
            ,registerno -- 工商注册号
            ,registerdate -- 注册时间
            ,registeraddress -- 注册地址
            ,registeraddressareacode -- 注册地址行政区编号
            ,registeraddressarea -- 注册地省市区
            ,registerfund -- 注册资本(万元)
            ,fundcurrency -- 币种
            ,tradecode -- 行业代码
            ,managerange -- 经营范围
            ,orgcode -- 组织机构号
            ,registerdepartment -- 注册工商局
            ,statusid -- 经营状态
            ,statusdesc -- 经营状态描述
            ,lastcheckyear -- 最后年检年度
            ,managebegindate -- 经营开始时间
            ,manageenddate -- 经营结束时间
            ,opendate -- 开业时间
            ,companytype -- 公司类型
            ,economictype -- 公司经济类型
            ,targetjyflag1 -- 客群经营标签（经营场景)
            ,industryname -- 客群主营行业
            ,certvalidstartdate -- 证件有效期起始日
            ,sex -- 性别
            ,indivocc -- 职业
            ,nationality -- 国籍
            ,businessscene -- 业务场景
            ,businesstag -- 业务标识
            ,pushreason -- 客群区分标识
            ,custverifytype -- 核身方式
            ,custverifyresult -- 核身结果
            ,custverifytime -- 核身通过时间
            ,customertag -- 客群标
            ,employee_id -- 推广者员工号
            ,nation -- 民族
            ,company_info_org_code -- 统一社会信用代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybkzd_cs_extent_info_op(
            serialno -- 流水号
            ,applyno -- 蚂蚁申请编号
            ,mobile -- 手机号码
            ,address -- 地址信息
            ,prov -- 省份
            ,city -- 城市
            ,area -- 地区
            ,certvalidenddate -- 证件有效期
            ,busdatareqdate -- 采集时间
            ,businfoexistflag -- 是否存有效商信息
            ,notexistreason -- 无有效工商信息原因
            ,companyinfoname -- 公司名
            ,companyinfolawer -- 法定代表
            ,registerno -- 工商注册号
            ,registerdate -- 注册时间
            ,registeraddress -- 注册地址
            ,registeraddressareacode -- 注册地址行政区编号
            ,registeraddressarea -- 注册地省市区
            ,registerfund -- 注册资本(万元)
            ,fundcurrency -- 币种
            ,tradecode -- 行业代码
            ,managerange -- 经营范围
            ,orgcode -- 组织机构号
            ,registerdepartment -- 注册工商局
            ,statusid -- 经营状态
            ,statusdesc -- 经营状态描述
            ,lastcheckyear -- 最后年检年度
            ,managebegindate -- 经营开始时间
            ,manageenddate -- 经营结束时间
            ,opendate -- 开业时间
            ,companytype -- 公司类型
            ,economictype -- 公司经济类型
            ,targetjyflag1 -- 客群经营标签（经营场景)
            ,industryname -- 客群主营行业
            ,certvalidstartdate -- 证件有效期起始日
            ,sex -- 性别
            ,indivocc -- 职业
            ,nationality -- 国籍
            ,businessscene -- 业务场景
            ,businesstag -- 业务标识
            ,pushreason -- 客群区分标识
            ,custverifytype -- 核身方式
            ,custverifyresult -- 核身结果
            ,custverifytime -- 核身通过时间
            ,customertag -- 客群标
            ,employee_id -- 推广者员工号
            ,nation -- 民族
            ,company_info_org_code -- 统一社会信用代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.applyno -- 蚂蚁申请编号
    ,o.mobile -- 手机号码
    ,o.address -- 地址信息
    ,o.prov -- 省份
    ,o.city -- 城市
    ,o.area -- 地区
    ,o.certvalidenddate -- 证件有效期
    ,o.busdatareqdate -- 采集时间
    ,o.businfoexistflag -- 是否存有效商信息
    ,o.notexistreason -- 无有效工商信息原因
    ,o.companyinfoname -- 公司名
    ,o.companyinfolawer -- 法定代表
    ,o.registerno -- 工商注册号
    ,o.registerdate -- 注册时间
    ,o.registeraddress -- 注册地址
    ,o.registeraddressareacode -- 注册地址行政区编号
    ,o.registeraddressarea -- 注册地省市区
    ,o.registerfund -- 注册资本(万元)
    ,o.fundcurrency -- 币种
    ,o.tradecode -- 行业代码
    ,o.managerange -- 经营范围
    ,o.orgcode -- 组织机构号
    ,o.registerdepartment -- 注册工商局
    ,o.statusid -- 经营状态
    ,o.statusdesc -- 经营状态描述
    ,o.lastcheckyear -- 最后年检年度
    ,o.managebegindate -- 经营开始时间
    ,o.manageenddate -- 经营结束时间
    ,o.opendate -- 开业时间
    ,o.companytype -- 公司类型
    ,o.economictype -- 公司经济类型
    ,o.targetjyflag1 -- 客群经营标签（经营场景)
    ,o.industryname -- 客群主营行业
    ,o.certvalidstartdate -- 证件有效期起始日
    ,o.sex -- 性别
    ,o.indivocc -- 职业
    ,o.nationality -- 国籍
    ,o.businessscene -- 业务场景
    ,o.businesstag -- 业务标识
    ,o.pushreason -- 客群区分标识
    ,o.custverifytype -- 核身方式
    ,o.custverifyresult -- 核身结果
    ,o.custverifytime -- 核身通过时间
    ,o.customertag -- 客群标
    ,o.employee_id -- 推广者员工号
    ,o.nation -- 民族
    ,o.company_info_org_code -- 统一社会信用代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_mybkzd_cs_extent_info_bk o
    left join ${iol_schema}.icms_mybkzd_cs_extent_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_mybkzd_cs_extent_info_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_mybkzd_cs_extent_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_mybkzd_cs_extent_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_mybkzd_cs_extent_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_mybkzd_cs_extent_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_mybkzd_cs_extent_info exchange partition p_${batch_date} with table ${iol_schema}.icms_mybkzd_cs_extent_info_cl;
alter table ${iol_schema}.icms_mybkzd_cs_extent_info exchange partition p_20991231 with table ${iol_schema}.icms_mybkzd_cs_extent_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybkzd_cs_extent_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybkzd_cs_extent_info_op purge;
drop table ${iol_schema}.icms_mybkzd_cs_extent_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_mybkzd_cs_extent_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybkzd_cs_extent_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
