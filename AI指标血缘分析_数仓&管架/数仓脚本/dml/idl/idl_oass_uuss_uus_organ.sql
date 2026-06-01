/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_uuss_uus_organ
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_uuss_uus_organ drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_uuss_uus_organ add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_uuss_uus_organ (
etl_dt  --数据日期
,zoneno  --分行号
,pbocfinancialcode  --人民银行金融机构编号
,financialcode  --金融机构标识码
,swiftcode  --SWIFT号码
,bankcode  --支付系统银行行号
,legal  --法人号
,businesslicense  --营业执照号码
,organizationcode  --组织机构代码
,taxid  --税务登记证号
,organcnfullname  --组织机构名称
,organcnshortname  --组织机构简称
,organenfullname  --组织机构英文全称
,organenshortname  --组织机构英文简称
,organstatecode  --机构营业状态
,organstatus  --机构状态
,organfoundingdate  --机构成立日期
,organclosedate  --机构关闭日期
,organtype  --组织机构类型
,isst  --是否为实体机构
,ishs  --是否为核算机构
,isyy  --是否为营业机构
,isxz  --是否为行政机构
,iszw  --是否为账务机构
,organlevel  --组织机构级别代码
,leafnoteflag  --叶节点标志
,xzuporgancode  --行政上级组织机构编码
,zwuporgancode  --账务上级组织机构编码
,hsuporgancode  --核算上级组织机构编码
,seque  --机构顺序号
,postcode  --邮政编码
,country  --所在国家
,province  --所在省/州
,city  --所在城市
,county  --所在县/区
,address  --详细地址
,email  --电子邮箱
,url  --网址
,countrycode  --国际长途区号
,areacode  --国内长途区号
,phone  --电话号码
,subphone  --分机号
,servicephone  --服务电话
,funorgan  --职能机构
,fundep  --职能部门
,orderno  --显示顺序号
,financiallicnum  --金融许可证号码
,organsystem  --机构关联系统
,cbrcfininsttid  --银监会金融机构编号
,unionfinancialcode  --银联金融机构编号
,workstarttm  --工作开始时间
,workendtm  --工作结束时间
,updatedate  --更新日期
,heademplyid  --负责人员工编号
,isxnhs  --是否为虚拟核算机构
,rhregcode  --人行地区码
,blng_city_pbc  --所属城市(人行)
,bankcodeperson  --支付系统银行行号（用于个人结算账户报送）
,note1  --备用1
,note2  --备用2
,note3  --备用3
,note4  --备用4
,note5  --备用5
,note6  --备用6
,note7  --备用7
,note8  --备用8
,note9  --备用9
,note10  --备用10
,bbuporgancode  --报表上级机构编号
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,organcodekey  --统一组织机构编码
,organcode  --组织机构编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.zoneno,chr(13),''),chr(10),'') as zoneno --分行号
,replace(replace(t1.pbocfinancialcode,chr(13),''),chr(10),'') as pbocfinancialcode --人民银行金融机构编号
,replace(replace(t1.financialcode,chr(13),''),chr(10),'') as financialcode --金融机构标识码
,replace(replace(t1.swiftcode,chr(13),''),chr(10),'') as swiftcode --SWIFT号码
,replace(replace(t1.bankcode,chr(13),''),chr(10),'') as bankcode --支付系统银行行号
,replace(replace(t1.legal,chr(13),''),chr(10),'') as legal --法人号
,replace(replace(t1.businesslicense,chr(13),''),chr(10),'') as businesslicense --营业执照号码
,replace(replace(t1.organizationcode,chr(13),''),chr(10),'') as organizationcode --组织机构代码
,replace(replace(t1.taxid,chr(13),''),chr(10),'') as taxid --税务登记证号
,replace(replace(t1.organcnfullname,chr(13),''),chr(10),'') as organcnfullname --组织机构名称
,replace(replace(t1.organcnshortname,chr(13),''),chr(10),'') as organcnshortname --组织机构简称
,replace(replace(t1.organenfullname,chr(13),''),chr(10),'') as organenfullname --组织机构英文全称
,replace(replace(t1.organenshortname,chr(13),''),chr(10),'') as organenshortname --组织机构英文简称
,replace(replace(t1.organstatecode,chr(13),''),chr(10),'') as organstatecode --机构营业状态
,replace(replace(t1.organstatus,chr(13),''),chr(10),'') as organstatus --机构状态
,replace(replace(t1.organfoundingdate,chr(13),''),chr(10),'') as organfoundingdate --机构成立日期
,replace(replace(t1.organclosedate,chr(13),''),chr(10),'') as organclosedate --机构关闭日期
,replace(replace(t1.organtype,chr(13),''),chr(10),'') as organtype --组织机构类型
,replace(replace(t1.isst,chr(13),''),chr(10),'') as isst --是否为实体机构
,replace(replace(t1.ishs,chr(13),''),chr(10),'') as ishs --是否为核算机构
,replace(replace(t1.isyy,chr(13),''),chr(10),'') as isyy --是否为营业机构
,replace(replace(t1.isxz,chr(13),''),chr(10),'') as isxz --是否为行政机构
,replace(replace(t1.iszw,chr(13),''),chr(10),'') as iszw --是否为账务机构
,replace(replace(t1.organlevel,chr(13),''),chr(10),'') as organlevel --组织机构级别代码
,replace(replace(t1.leafnoteflag,chr(13),''),chr(10),'') as leafnoteflag --叶节点标志
,replace(replace(t1.xzuporgancode,chr(13),''),chr(10),'') as xzuporgancode --行政上级组织机构编码
,replace(replace(t1.zwuporgancode,chr(13),''),chr(10),'') as zwuporgancode --账务上级组织机构编码
,replace(replace(t1.hsuporgancode,chr(13),''),chr(10),'') as hsuporgancode --核算上级组织机构编码
,replace(replace(t1.seque,chr(13),''),chr(10),'') as seque --机构顺序号
,replace(replace(t1.postcode,chr(13),''),chr(10),'') as postcode --邮政编码
,replace(replace(t1.country,chr(13),''),chr(10),'') as country --所在国家
,replace(replace(t1.province,chr(13),''),chr(10),'') as province --所在省/州
,replace(replace(t1.city,chr(13),''),chr(10),'') as city --所在城市
,replace(replace(t1.county,chr(13),''),chr(10),'') as county --所在县/区
,replace(replace(t1.address,chr(13),''),chr(10),'') as address --详细地址
,replace(replace(t1.email,chr(13),''),chr(10),'') as email --电子邮箱
,replace(replace(t1.url,chr(13),''),chr(10),'') as url --网址
,replace(replace(t1.countrycode,chr(13),''),chr(10),'') as countrycode --国际长途区号
,replace(replace(t1.areacode,chr(13),''),chr(10),'') as areacode --国内长途区号
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone --电话号码
,replace(replace(t1.subphone,chr(13),''),chr(10),'') as subphone --分机号
,replace(replace(t1.servicephone,chr(13),''),chr(10),'') as servicephone --服务电话
,replace(replace(t1.funorgan,chr(13),''),chr(10),'') as funorgan --职能机构
,replace(replace(t1.fundep,chr(13),''),chr(10),'') as fundep --职能部门
,replace(replace(t1.orderno,chr(13),''),chr(10),'') as orderno --显示顺序号
,replace(replace(t1.financiallicnum,chr(13),''),chr(10),'') as financiallicnum --金融许可证号码
,replace(replace(t1.organsystem,chr(13),''),chr(10),'') as organsystem --机构关联系统
,replace(replace(t1.cbrcfininsttid,chr(13),''),chr(10),'') as cbrcfininsttid --银监会金融机构编号
,replace(replace(t1.unionfinancialcode,chr(13),''),chr(10),'') as unionfinancialcode --银联金融机构编号
,replace(replace(t1.workstarttm,chr(13),''),chr(10),'') as workstarttm --工作开始时间
,replace(replace(t1.workendtm,chr(13),''),chr(10),'') as workendtm --工作结束时间
,replace(replace(t1.updatedate,chr(13),''),chr(10),'') as updatedate --更新日期
,replace(replace(t1.heademplyid,chr(13),''),chr(10),'') as heademplyid --负责人员工编号
,replace(replace(t1.isxnhs,chr(13),''),chr(10),'') as isxnhs --是否为虚拟核算机构
,replace(replace(t1.rhregcode,chr(13),''),chr(10),'') as rhregcode --人行地区码
,replace(replace(t1.blng_city_pbc,chr(13),''),chr(10),'') as blng_city_pbc --所属城市(人行)
,replace(replace(t1.bankcodeperson,chr(13),''),chr(10),'') as bankcodeperson --支付系统银行行号（用于个人结算账户报送）
,replace(replace(t1.note1,chr(13),''),chr(10),'') as note1 --备用1
,replace(replace(t1.note2,chr(13),''),chr(10),'') as note2 --备用2
,replace(replace(t1.note3,chr(13),''),chr(10),'') as note3 --备用3
,replace(replace(t1.note4,chr(13),''),chr(10),'') as note4 --备用4
,replace(replace(t1.note5,chr(13),''),chr(10),'') as note5 --备用5
,replace(replace(t1.note6,chr(13),''),chr(10),'') as note6 --备用6
,replace(replace(t1.note7,chr(13),''),chr(10),'') as note7 --备用7
,replace(replace(t1.note8,chr(13),''),chr(10),'') as note8 --备用8
,replace(replace(t1.note9,chr(13),''),chr(10),'') as note9 --备用9
,replace(replace(t1.note10,chr(13),''),chr(10),'') as note10 --备用10
,replace(replace(t1.bbuporgancode,chr(13),''),chr(10),'') as bbuporgancode --报表上级机构编号
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.organcodekey,chr(13),''),chr(10),'') as organcodekey --统一组织机构编码
,replace(replace(t1.organcode,chr(13),''),chr(10),'') as organcode --组织机构编号
from ${iol_schema}.uuss_uus_organ t1    --机构信息表
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_uuss_uus_organ',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
