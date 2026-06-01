/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_crps_icms_mybk_cs_extent_info
CreateDate: 20230608
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.crps_icms_mybk_cs_extent_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_icms_mybk_cs_extent_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_icms_mybk_cs_extent_info (
etl_dt  --etl处理日期
,serno  --流水号
,registeraddressarea  --注册地省市区
,statusid  --经营状态
,sex  --性别
,city  --城市
,registerno  --工商注册号
,orgcode  --组织机构号
,managebegindate  --经营开始时间
,opendate  --开业时间
,economictype  --公司经济类型
,registeraddressareacode  --注册地址行政区编号
,area  --地区
,companytype  --公司类型
,registerdate  --注册时间
,industryname  --客群主营行业
,nationality  --国籍
,registeraddress  --注册地址
,registerdepartment  --注册工商局
,migtflag  --迁移标志：crsrcrilcupl
,busdatareqdate  --采集时间
,businfoexistflag  --是否存有效商信息
,fundcurrency  --币种
,companyinfoname  --公司名
,tradecode  --行业代码
,managerange  --经营范围
,mobile  --手机号码
,certvalidenddate  --证件有效期
,statusdesc  --经营状态描述
,certvalidstartdate  --证件有效期起始日
,manageenddate  --经营结束时间
,targetjyflag1  --客群经营标签（经营场景)
,applyno  --蚂蚁申请编号
,companyinfolawer  --法定代表
,registerfund  --注册资本(万元)
,address  --地址信息
,prov  --省份
,notexistreason  --无有效工商信息原因
,lastcheckyear  --最后年检年度
,indivocc  --职业

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --etl处理日期
,replace(replace(t1.serno,chr(13),''),chr(10),'') as serno --流水号
,replace(replace(t1.registeraddressarea,chr(13),''),chr(10),'') as registeraddressarea --注册地省市区
,replace(replace(t1.statusid,chr(13),''),chr(10),'') as statusid --经营状态
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex --性别
,replace(replace(t1.city,chr(13),''),chr(10),'') as city --城市
,replace(replace(t1.registerno,chr(13),''),chr(10),'') as registerno --工商注册号
,replace(replace(t1.orgcode,chr(13),''),chr(10),'') as orgcode --组织机构号
,replace(replace(t1.managebegindate,chr(13),''),chr(10),'') as managebegindate --经营开始时间
,replace(replace(t1.opendate,chr(13),''),chr(10),'') as opendate --开业时间
,replace(replace(t1.economictype,chr(13),''),chr(10),'') as economictype --公司经济类型
,replace(replace(t1.registeraddressareacode,chr(13),''),chr(10),'') as registeraddressareacode --注册地址行政区编号
,replace(replace(t1.area,chr(13),''),chr(10),'') as area --地区
,replace(replace(t1.companytype,chr(13),''),chr(10),'') as companytype --公司类型
,replace(replace(t1.registerdate,chr(13),''),chr(10),'') as registerdate --注册时间
,replace(replace(t1.industryname,chr(13),''),chr(10),'') as industryname --客群主营行业
,replace(replace(t1.nationality,chr(13),''),chr(10),'') as nationality --国籍
,replace(replace(t1.registeraddress,chr(13),''),chr(10),'') as registeraddress --注册地址
,replace(replace(t1.registerdepartment,chr(13),''),chr(10),'') as registerdepartment --注册工商局
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag --迁移标志：crsrcrilcupl
,replace(replace(t1.busdatareqdate,chr(13),''),chr(10),'') as busdatareqdate --采集时间
,replace(replace(t1.businfoexistflag,chr(13),''),chr(10),'') as businfoexistflag --是否存有效商信息
,replace(replace(t1.fundcurrency,chr(13),''),chr(10),'') as fundcurrency --币种
,replace(replace(t1.companyinfoname,chr(13),''),chr(10),'') as companyinfoname --公司名
,replace(replace(t1.tradecode,chr(13),''),chr(10),'') as tradecode --行业代码
,replace(replace(t1.managerange,chr(13),''),chr(10),'') as managerange --经营范围
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile --手机号码
,replace(replace(t1.certvalidenddate,chr(13),''),chr(10),'') as certvalidenddate --证件有效期
,replace(replace(t1.statusdesc,chr(13),''),chr(10),'') as statusdesc --经营状态描述
,replace(replace(t1.certvalidstartdate,chr(13),''),chr(10),'') as certvalidstartdate --证件有效期起始日
,replace(replace(t1.manageenddate,chr(13),''),chr(10),'') as manageenddate --经营结束时间
,replace(replace(t1.targetjyflag1,chr(13),''),chr(10),'') as targetjyflag1 --客群经营标签（经营场景)
,replace(replace(t1.applyno,chr(13),''),chr(10),'') as applyno --蚂蚁申请编号
,replace(replace(t1.companyinfolawer,chr(13),''),chr(10),'') as companyinfolawer --法定代表
,t1.registerfund as registerfund --注册资本(万元)
,replace(replace(t1.address,chr(13),''),chr(10),'') as address --地址信息
,replace(replace(t1.prov,chr(13),''),chr(10),'') as prov --省份
,replace(replace(t1.notexistreason,chr(13),''),chr(10),'') as notexistreason --无有效工商信息原因
,replace(replace(t1.lastcheckyear,chr(13),''),chr(10),'') as lastcheckyear --最后年检年度
,replace(replace(t1.indivocc,chr(13),''),chr(10),'') as indivocc --职业
from ${iol_schema}.icms_mybk_cs_extent_info t1    --网商贷初审扩展信息
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_icms_mybk_cs_extent_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
