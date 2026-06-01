/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_project_info
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
create table ${iol_schema}.icms_customer_project_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_project_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_project_info_op purge;
drop table ${iol_schema}.icms_customer_project_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_project_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_project_info where 0=1;

create table ${iol_schema}.icms_customer_project_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_project_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_project_info_cl(
            projectno -- 项目编号
            ,landestimatevalue -- 目前拥有土地估计销售价值
            ,industrytype -- 项目所属行业分类
            ,projectcapital -- 项目资本金
            ,carportarea -- 车库面积
            ,approveorgid -- 立项批复单位
            ,landmatchingfee -- 土地配套费用
            ,developmentid -- 发展商组织机构代码
            ,chieflyproduct -- 项目主要产品
            ,projectadd -- 项目地址
            ,plantotalcast -- 计划总投资
            ,holdtype -- 土地取得方式
            ,constructionnature -- 建设性质
            ,removalexpenses -- 拆迁、补偿费
            ,expectprojecttype -- 预计开发项目类型
            ,landsellcostinput -- 土地直接出让成本投入
            ,capitalassetcast -- 固定资产投资
            ,constructionperiod -- 总建设期数
            ,surroundlandprice -- 目前周边土地价格
            ,developmentname -- 发展商名称
            ,codistribute -- 联建单位所分配房屋面积(平方米)
            ,greeningrate -- 项目绿化率（％）
            ,updateuserid -- 更新人
            ,corporgid -- 法人机构编号
            ,projectid -- 项目立项文号
            ,buildarea -- 总建筑面积(平方米)
            ,updateorgid -- 更新机构
            ,emporiumarea -- 商铺面积(平方米)
            ,estimatesellprice -- 土地开发项目预计销售价格
            ,capitalscale -- 项目资本金比例（％）
            ,beginbuilddate -- 开工日期
            ,estimatevalue -- 目前土地储备中心现有土地估算价值
            ,industry -- 项目所属行业
            ,projectname -- 项目名称
            ,supervisorinfo -- 监理单位名称及资质等级
            ,housearea -- 住宅面积(平方米)
            ,otherarea -- 其它面积
            ,ourloan -- 土地开发项目我行贷款
            ,inputorgid -- 登记机构
            ,newcapacity -- 新增能力
            ,rebuildarea -- 还建面积(平方米)
            ,expectcompletedate -- 计划竣工日期
            ,volumeratio -- 项目容积率（％）
            ,commodityhousesalelicence -- 商品房预售许可证
            ,projectlevel -- 项目级别
            ,landusecert -- 土地使用权证书
            ,inputdate -- 登记日期
            ,projectplanlicence -- 建筑工程规划许可证
            ,otherareaflag -- 是否异地项目
            ,totallandvalue -- 总地价
            ,terrauser -- 目前土地使用权人
            ,updatedate -- 更新日期
            ,projectsubtype -- 项目子类型
            ,intialworkingcapital -- 铺底流动资金
            ,landuseplanlicence -- 建设用地规划许可证
            ,terratype -- 目前土地类型
            ,landarea -- 目前拥有土地面积
            ,inputuserid -- 登记人
            ,holdarea -- 占地面积(平方米)
            ,completeflag -- 数据录入完整性标识
            ,migtflag -- 
            ,projecttype -- 项目类型
            ,projectinfo -- 项目建设内容
            ,completeddate -- 竣工日期
            ,copartnername -- 联建单位名称
            ,scriptoriumarea -- 写字间面积(平方米)
            ,contractorinfo -- 承建单位名称及资质
            ,copartnerid -- 联建单位组织机构代码
            ,homearea -- 自营面积(平方米)
            ,projectbuildlicence -- 建筑工程施工许可证
            ,examineinfo -- 项目审批情况
            ,projectregiion -- 项目所在行政区域
            ,projectinvestment -- 项目总投资
            ,useinfo -- 地价缴付（投入）情况
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_project_info_op(
            projectno -- 项目编号
            ,landestimatevalue -- 目前拥有土地估计销售价值
            ,industrytype -- 项目所属行业分类
            ,projectcapital -- 项目资本金
            ,carportarea -- 车库面积
            ,approveorgid -- 立项批复单位
            ,landmatchingfee -- 土地配套费用
            ,developmentid -- 发展商组织机构代码
            ,chieflyproduct -- 项目主要产品
            ,projectadd -- 项目地址
            ,plantotalcast -- 计划总投资
            ,holdtype -- 土地取得方式
            ,constructionnature -- 建设性质
            ,removalexpenses -- 拆迁、补偿费
            ,expectprojecttype -- 预计开发项目类型
            ,landsellcostinput -- 土地直接出让成本投入
            ,capitalassetcast -- 固定资产投资
            ,constructionperiod -- 总建设期数
            ,surroundlandprice -- 目前周边土地价格
            ,developmentname -- 发展商名称
            ,codistribute -- 联建单位所分配房屋面积(平方米)
            ,greeningrate -- 项目绿化率（％）
            ,updateuserid -- 更新人
            ,corporgid -- 法人机构编号
            ,projectid -- 项目立项文号
            ,buildarea -- 总建筑面积(平方米)
            ,updateorgid -- 更新机构
            ,emporiumarea -- 商铺面积(平方米)
            ,estimatesellprice -- 土地开发项目预计销售价格
            ,capitalscale -- 项目资本金比例（％）
            ,beginbuilddate -- 开工日期
            ,estimatevalue -- 目前土地储备中心现有土地估算价值
            ,industry -- 项目所属行业
            ,projectname -- 项目名称
            ,supervisorinfo -- 监理单位名称及资质等级
            ,housearea -- 住宅面积(平方米)
            ,otherarea -- 其它面积
            ,ourloan -- 土地开发项目我行贷款
            ,inputorgid -- 登记机构
            ,newcapacity -- 新增能力
            ,rebuildarea -- 还建面积(平方米)
            ,expectcompletedate -- 计划竣工日期
            ,volumeratio -- 项目容积率（％）
            ,commodityhousesalelicence -- 商品房预售许可证
            ,projectlevel -- 项目级别
            ,landusecert -- 土地使用权证书
            ,inputdate -- 登记日期
            ,projectplanlicence -- 建筑工程规划许可证
            ,otherareaflag -- 是否异地项目
            ,totallandvalue -- 总地价
            ,terrauser -- 目前土地使用权人
            ,updatedate -- 更新日期
            ,projectsubtype -- 项目子类型
            ,intialworkingcapital -- 铺底流动资金
            ,landuseplanlicence -- 建设用地规划许可证
            ,terratype -- 目前土地类型
            ,landarea -- 目前拥有土地面积
            ,inputuserid -- 登记人
            ,holdarea -- 占地面积(平方米)
            ,completeflag -- 数据录入完整性标识
            ,migtflag -- 
            ,projecttype -- 项目类型
            ,projectinfo -- 项目建设内容
            ,completeddate -- 竣工日期
            ,copartnername -- 联建单位名称
            ,scriptoriumarea -- 写字间面积(平方米)
            ,contractorinfo -- 承建单位名称及资质
            ,copartnerid -- 联建单位组织机构代码
            ,homearea -- 自营面积(平方米)
            ,projectbuildlicence -- 建筑工程施工许可证
            ,examineinfo -- 项目审批情况
            ,projectregiion -- 项目所在行政区域
            ,projectinvestment -- 项目总投资
            ,useinfo -- 地价缴付（投入）情况
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.projectno, o.projectno) as projectno -- 项目编号
    ,nvl(n.landestimatevalue, o.landestimatevalue) as landestimatevalue -- 目前拥有土地估计销售价值
    ,nvl(n.industrytype, o.industrytype) as industrytype -- 项目所属行业分类
    ,nvl(n.projectcapital, o.projectcapital) as projectcapital -- 项目资本金
    ,nvl(n.carportarea, o.carportarea) as carportarea -- 车库面积
    ,nvl(n.approveorgid, o.approveorgid) as approveorgid -- 立项批复单位
    ,nvl(n.landmatchingfee, o.landmatchingfee) as landmatchingfee -- 土地配套费用
    ,nvl(n.developmentid, o.developmentid) as developmentid -- 发展商组织机构代码
    ,nvl(n.chieflyproduct, o.chieflyproduct) as chieflyproduct -- 项目主要产品
    ,nvl(n.projectadd, o.projectadd) as projectadd -- 项目地址
    ,nvl(n.plantotalcast, o.plantotalcast) as plantotalcast -- 计划总投资
    ,nvl(n.holdtype, o.holdtype) as holdtype -- 土地取得方式
    ,nvl(n.constructionnature, o.constructionnature) as constructionnature -- 建设性质
    ,nvl(n.removalexpenses, o.removalexpenses) as removalexpenses -- 拆迁、补偿费
    ,nvl(n.expectprojecttype, o.expectprojecttype) as expectprojecttype -- 预计开发项目类型
    ,nvl(n.landsellcostinput, o.landsellcostinput) as landsellcostinput -- 土地直接出让成本投入
    ,nvl(n.capitalassetcast, o.capitalassetcast) as capitalassetcast -- 固定资产投资
    ,nvl(n.constructionperiod, o.constructionperiod) as constructionperiod -- 总建设期数
    ,nvl(n.surroundlandprice, o.surroundlandprice) as surroundlandprice -- 目前周边土地价格
    ,nvl(n.developmentname, o.developmentname) as developmentname -- 发展商名称
    ,nvl(n.codistribute, o.codistribute) as codistribute -- 联建单位所分配房屋面积(平方米)
    ,nvl(n.greeningrate, o.greeningrate) as greeningrate -- 项目绿化率（％）
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.projectid, o.projectid) as projectid -- 项目立项文号
    ,nvl(n.buildarea, o.buildarea) as buildarea -- 总建筑面积(平方米)
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.emporiumarea, o.emporiumarea) as emporiumarea -- 商铺面积(平方米)
    ,nvl(n.estimatesellprice, o.estimatesellprice) as estimatesellprice -- 土地开发项目预计销售价格
    ,nvl(n.capitalscale, o.capitalscale) as capitalscale -- 项目资本金比例（％）
    ,nvl(n.beginbuilddate, o.beginbuilddate) as beginbuilddate -- 开工日期
    ,nvl(n.estimatevalue, o.estimatevalue) as estimatevalue -- 目前土地储备中心现有土地估算价值
    ,nvl(n.industry, o.industry) as industry -- 项目所属行业
    ,nvl(n.projectname, o.projectname) as projectname -- 项目名称
    ,nvl(n.supervisorinfo, o.supervisorinfo) as supervisorinfo -- 监理单位名称及资质等级
    ,nvl(n.housearea, o.housearea) as housearea -- 住宅面积(平方米)
    ,nvl(n.otherarea, o.otherarea) as otherarea -- 其它面积
    ,nvl(n.ourloan, o.ourloan) as ourloan -- 土地开发项目我行贷款
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.newcapacity, o.newcapacity) as newcapacity -- 新增能力
    ,nvl(n.rebuildarea, o.rebuildarea) as rebuildarea -- 还建面积(平方米)
    ,nvl(n.expectcompletedate, o.expectcompletedate) as expectcompletedate -- 计划竣工日期
    ,nvl(n.volumeratio, o.volumeratio) as volumeratio -- 项目容积率（％）
    ,nvl(n.commodityhousesalelicence, o.commodityhousesalelicence) as commodityhousesalelicence -- 商品房预售许可证
    ,nvl(n.projectlevel, o.projectlevel) as projectlevel -- 项目级别
    ,nvl(n.landusecert, o.landusecert) as landusecert -- 土地使用权证书
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.projectplanlicence, o.projectplanlicence) as projectplanlicence -- 建筑工程规划许可证
    ,nvl(n.otherareaflag, o.otherareaflag) as otherareaflag -- 是否异地项目
    ,nvl(n.totallandvalue, o.totallandvalue) as totallandvalue -- 总地价
    ,nvl(n.terrauser, o.terrauser) as terrauser -- 目前土地使用权人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.projectsubtype, o.projectsubtype) as projectsubtype -- 项目子类型
    ,nvl(n.intialworkingcapital, o.intialworkingcapital) as intialworkingcapital -- 铺底流动资金
    ,nvl(n.landuseplanlicence, o.landuseplanlicence) as landuseplanlicence -- 建设用地规划许可证
    ,nvl(n.terratype, o.terratype) as terratype -- 目前土地类型
    ,nvl(n.landarea, o.landarea) as landarea -- 目前拥有土地面积
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.holdarea, o.holdarea) as holdarea -- 占地面积(平方米)
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 数据录入完整性标识
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.projecttype, o.projecttype) as projecttype -- 项目类型
    ,nvl(n.projectinfo, o.projectinfo) as projectinfo -- 项目建设内容
    ,nvl(n.completeddate, o.completeddate) as completeddate -- 竣工日期
    ,nvl(n.copartnername, o.copartnername) as copartnername -- 联建单位名称
    ,nvl(n.scriptoriumarea, o.scriptoriumarea) as scriptoriumarea -- 写字间面积(平方米)
    ,nvl(n.contractorinfo, o.contractorinfo) as contractorinfo -- 承建单位名称及资质
    ,nvl(n.copartnerid, o.copartnerid) as copartnerid -- 联建单位组织机构代码
    ,nvl(n.homearea, o.homearea) as homearea -- 自营面积(平方米)
    ,nvl(n.projectbuildlicence, o.projectbuildlicence) as projectbuildlicence -- 建筑工程施工许可证
    ,nvl(n.examineinfo, o.examineinfo) as examineinfo -- 项目审批情况
    ,nvl(n.projectregiion, o.projectregiion) as projectregiion -- 项目所在行政区域
    ,nvl(n.projectinvestment, o.projectinvestment) as projectinvestment -- 项目总投资
    ,nvl(n.useinfo, o.useinfo) as useinfo -- 地价缴付（投入）情况
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.projectno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.projectno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.projectno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_customer_project_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_project_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.projectno = n.projectno
where (
        o.projectno is null
    )
    or (
        n.projectno is null
    )
    or (
        o.landestimatevalue <> n.landestimatevalue
        or o.industrytype <> n.industrytype
        or o.projectcapital <> n.projectcapital
        or o.carportarea <> n.carportarea
        or o.approveorgid <> n.approveorgid
        or o.landmatchingfee <> n.landmatchingfee
        or o.developmentid <> n.developmentid
        or o.chieflyproduct <> n.chieflyproduct
        or o.projectadd <> n.projectadd
        or o.plantotalcast <> n.plantotalcast
        or o.holdtype <> n.holdtype
        or o.constructionnature <> n.constructionnature
        or o.removalexpenses <> n.removalexpenses
        or o.expectprojecttype <> n.expectprojecttype
        or o.landsellcostinput <> n.landsellcostinput
        or o.capitalassetcast <> n.capitalassetcast
        or o.constructionperiod <> n.constructionperiod
        or o.surroundlandprice <> n.surroundlandprice
        or o.developmentname <> n.developmentname
        or o.codistribute <> n.codistribute
        or o.greeningrate <> n.greeningrate
        or o.updateuserid <> n.updateuserid
        or o.corporgid <> n.corporgid
        or o.projectid <> n.projectid
        or o.buildarea <> n.buildarea
        or o.updateorgid <> n.updateorgid
        or o.emporiumarea <> n.emporiumarea
        or o.estimatesellprice <> n.estimatesellprice
        or o.capitalscale <> n.capitalscale
        or o.beginbuilddate <> n.beginbuilddate
        or o.estimatevalue <> n.estimatevalue
        or o.industry <> n.industry
        or o.projectname <> n.projectname
        or o.supervisorinfo <> n.supervisorinfo
        or o.housearea <> n.housearea
        or o.otherarea <> n.otherarea
        or o.ourloan <> n.ourloan
        or o.inputorgid <> n.inputorgid
        or o.newcapacity <> n.newcapacity
        or o.rebuildarea <> n.rebuildarea
        or o.expectcompletedate <> n.expectcompletedate
        or o.volumeratio <> n.volumeratio
        or o.commodityhousesalelicence <> n.commodityhousesalelicence
        or o.projectlevel <> n.projectlevel
        or o.landusecert <> n.landusecert
        or o.inputdate <> n.inputdate
        or o.projectplanlicence <> n.projectplanlicence
        or o.otherareaflag <> n.otherareaflag
        or o.totallandvalue <> n.totallandvalue
        or o.terrauser <> n.terrauser
        or o.updatedate <> n.updatedate
        or o.projectsubtype <> n.projectsubtype
        or o.intialworkingcapital <> n.intialworkingcapital
        or o.landuseplanlicence <> n.landuseplanlicence
        or o.terratype <> n.terratype
        or o.landarea <> n.landarea
        or o.inputuserid <> n.inputuserid
        or o.holdarea <> n.holdarea
        or o.completeflag <> n.completeflag
        or o.migtflag <> n.migtflag
        or o.projecttype <> n.projecttype
        or o.projectinfo <> n.projectinfo
        or o.completeddate <> n.completeddate
        or o.copartnername <> n.copartnername
        or o.scriptoriumarea <> n.scriptoriumarea
        or o.contractorinfo <> n.contractorinfo
        or o.copartnerid <> n.copartnerid
        or o.homearea <> n.homearea
        or o.projectbuildlicence <> n.projectbuildlicence
        or o.examineinfo <> n.examineinfo
        or o.projectregiion <> n.projectregiion
        or o.projectinvestment <> n.projectinvestment
        or o.useinfo <> n.useinfo
        or o.remark <> n.remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_project_info_cl(
            projectno -- 项目编号
            ,landestimatevalue -- 目前拥有土地估计销售价值
            ,industrytype -- 项目所属行业分类
            ,projectcapital -- 项目资本金
            ,carportarea -- 车库面积
            ,approveorgid -- 立项批复单位
            ,landmatchingfee -- 土地配套费用
            ,developmentid -- 发展商组织机构代码
            ,chieflyproduct -- 项目主要产品
            ,projectadd -- 项目地址
            ,plantotalcast -- 计划总投资
            ,holdtype -- 土地取得方式
            ,constructionnature -- 建设性质
            ,removalexpenses -- 拆迁、补偿费
            ,expectprojecttype -- 预计开发项目类型
            ,landsellcostinput -- 土地直接出让成本投入
            ,capitalassetcast -- 固定资产投资
            ,constructionperiod -- 总建设期数
            ,surroundlandprice -- 目前周边土地价格
            ,developmentname -- 发展商名称
            ,codistribute -- 联建单位所分配房屋面积(平方米)
            ,greeningrate -- 项目绿化率（％）
            ,updateuserid -- 更新人
            ,corporgid -- 法人机构编号
            ,projectid -- 项目立项文号
            ,buildarea -- 总建筑面积(平方米)
            ,updateorgid -- 更新机构
            ,emporiumarea -- 商铺面积(平方米)
            ,estimatesellprice -- 土地开发项目预计销售价格
            ,capitalscale -- 项目资本金比例（％）
            ,beginbuilddate -- 开工日期
            ,estimatevalue -- 目前土地储备中心现有土地估算价值
            ,industry -- 项目所属行业
            ,projectname -- 项目名称
            ,supervisorinfo -- 监理单位名称及资质等级
            ,housearea -- 住宅面积(平方米)
            ,otherarea -- 其它面积
            ,ourloan -- 土地开发项目我行贷款
            ,inputorgid -- 登记机构
            ,newcapacity -- 新增能力
            ,rebuildarea -- 还建面积(平方米)
            ,expectcompletedate -- 计划竣工日期
            ,volumeratio -- 项目容积率（％）
            ,commodityhousesalelicence -- 商品房预售许可证
            ,projectlevel -- 项目级别
            ,landusecert -- 土地使用权证书
            ,inputdate -- 登记日期
            ,projectplanlicence -- 建筑工程规划许可证
            ,otherareaflag -- 是否异地项目
            ,totallandvalue -- 总地价
            ,terrauser -- 目前土地使用权人
            ,updatedate -- 更新日期
            ,projectsubtype -- 项目子类型
            ,intialworkingcapital -- 铺底流动资金
            ,landuseplanlicence -- 建设用地规划许可证
            ,terratype -- 目前土地类型
            ,landarea -- 目前拥有土地面积
            ,inputuserid -- 登记人
            ,holdarea -- 占地面积(平方米)
            ,completeflag -- 数据录入完整性标识
            ,migtflag -- 
            ,projecttype -- 项目类型
            ,projectinfo -- 项目建设内容
            ,completeddate -- 竣工日期
            ,copartnername -- 联建单位名称
            ,scriptoriumarea -- 写字间面积(平方米)
            ,contractorinfo -- 承建单位名称及资质
            ,copartnerid -- 联建单位组织机构代码
            ,homearea -- 自营面积(平方米)
            ,projectbuildlicence -- 建筑工程施工许可证
            ,examineinfo -- 项目审批情况
            ,projectregiion -- 项目所在行政区域
            ,projectinvestment -- 项目总投资
            ,useinfo -- 地价缴付（投入）情况
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_project_info_op(
            projectno -- 项目编号
            ,landestimatevalue -- 目前拥有土地估计销售价值
            ,industrytype -- 项目所属行业分类
            ,projectcapital -- 项目资本金
            ,carportarea -- 车库面积
            ,approveorgid -- 立项批复单位
            ,landmatchingfee -- 土地配套费用
            ,developmentid -- 发展商组织机构代码
            ,chieflyproduct -- 项目主要产品
            ,projectadd -- 项目地址
            ,plantotalcast -- 计划总投资
            ,holdtype -- 土地取得方式
            ,constructionnature -- 建设性质
            ,removalexpenses -- 拆迁、补偿费
            ,expectprojecttype -- 预计开发项目类型
            ,landsellcostinput -- 土地直接出让成本投入
            ,capitalassetcast -- 固定资产投资
            ,constructionperiod -- 总建设期数
            ,surroundlandprice -- 目前周边土地价格
            ,developmentname -- 发展商名称
            ,codistribute -- 联建单位所分配房屋面积(平方米)
            ,greeningrate -- 项目绿化率（％）
            ,updateuserid -- 更新人
            ,corporgid -- 法人机构编号
            ,projectid -- 项目立项文号
            ,buildarea -- 总建筑面积(平方米)
            ,updateorgid -- 更新机构
            ,emporiumarea -- 商铺面积(平方米)
            ,estimatesellprice -- 土地开发项目预计销售价格
            ,capitalscale -- 项目资本金比例（％）
            ,beginbuilddate -- 开工日期
            ,estimatevalue -- 目前土地储备中心现有土地估算价值
            ,industry -- 项目所属行业
            ,projectname -- 项目名称
            ,supervisorinfo -- 监理单位名称及资质等级
            ,housearea -- 住宅面积(平方米)
            ,otherarea -- 其它面积
            ,ourloan -- 土地开发项目我行贷款
            ,inputorgid -- 登记机构
            ,newcapacity -- 新增能力
            ,rebuildarea -- 还建面积(平方米)
            ,expectcompletedate -- 计划竣工日期
            ,volumeratio -- 项目容积率（％）
            ,commodityhousesalelicence -- 商品房预售许可证
            ,projectlevel -- 项目级别
            ,landusecert -- 土地使用权证书
            ,inputdate -- 登记日期
            ,projectplanlicence -- 建筑工程规划许可证
            ,otherareaflag -- 是否异地项目
            ,totallandvalue -- 总地价
            ,terrauser -- 目前土地使用权人
            ,updatedate -- 更新日期
            ,projectsubtype -- 项目子类型
            ,intialworkingcapital -- 铺底流动资金
            ,landuseplanlicence -- 建设用地规划许可证
            ,terratype -- 目前土地类型
            ,landarea -- 目前拥有土地面积
            ,inputuserid -- 登记人
            ,holdarea -- 占地面积(平方米)
            ,completeflag -- 数据录入完整性标识
            ,migtflag -- 
            ,projecttype -- 项目类型
            ,projectinfo -- 项目建设内容
            ,completeddate -- 竣工日期
            ,copartnername -- 联建单位名称
            ,scriptoriumarea -- 写字间面积(平方米)
            ,contractorinfo -- 承建单位名称及资质
            ,copartnerid -- 联建单位组织机构代码
            ,homearea -- 自营面积(平方米)
            ,projectbuildlicence -- 建筑工程施工许可证
            ,examineinfo -- 项目审批情况
            ,projectregiion -- 项目所在行政区域
            ,projectinvestment -- 项目总投资
            ,useinfo -- 地价缴付（投入）情况
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.projectno -- 项目编号
    ,o.landestimatevalue -- 目前拥有土地估计销售价值
    ,o.industrytype -- 项目所属行业分类
    ,o.projectcapital -- 项目资本金
    ,o.carportarea -- 车库面积
    ,o.approveorgid -- 立项批复单位
    ,o.landmatchingfee -- 土地配套费用
    ,o.developmentid -- 发展商组织机构代码
    ,o.chieflyproduct -- 项目主要产品
    ,o.projectadd -- 项目地址
    ,o.plantotalcast -- 计划总投资
    ,o.holdtype -- 土地取得方式
    ,o.constructionnature -- 建设性质
    ,o.removalexpenses -- 拆迁、补偿费
    ,o.expectprojecttype -- 预计开发项目类型
    ,o.landsellcostinput -- 土地直接出让成本投入
    ,o.capitalassetcast -- 固定资产投资
    ,o.constructionperiod -- 总建设期数
    ,o.surroundlandprice -- 目前周边土地价格
    ,o.developmentname -- 发展商名称
    ,o.codistribute -- 联建单位所分配房屋面积(平方米)
    ,o.greeningrate -- 项目绿化率（％）
    ,o.updateuserid -- 更新人
    ,o.corporgid -- 法人机构编号
    ,o.projectid -- 项目立项文号
    ,o.buildarea -- 总建筑面积(平方米)
    ,o.updateorgid -- 更新机构
    ,o.emporiumarea -- 商铺面积(平方米)
    ,o.estimatesellprice -- 土地开发项目预计销售价格
    ,o.capitalscale -- 项目资本金比例（％）
    ,o.beginbuilddate -- 开工日期
    ,o.estimatevalue -- 目前土地储备中心现有土地估算价值
    ,o.industry -- 项目所属行业
    ,o.projectname -- 项目名称
    ,o.supervisorinfo -- 监理单位名称及资质等级
    ,o.housearea -- 住宅面积(平方米)
    ,o.otherarea -- 其它面积
    ,o.ourloan -- 土地开发项目我行贷款
    ,o.inputorgid -- 登记机构
    ,o.newcapacity -- 新增能力
    ,o.rebuildarea -- 还建面积(平方米)
    ,o.expectcompletedate -- 计划竣工日期
    ,o.volumeratio -- 项目容积率（％）
    ,o.commodityhousesalelicence -- 商品房预售许可证
    ,o.projectlevel -- 项目级别
    ,o.landusecert -- 土地使用权证书
    ,o.inputdate -- 登记日期
    ,o.projectplanlicence -- 建筑工程规划许可证
    ,o.otherareaflag -- 是否异地项目
    ,o.totallandvalue -- 总地价
    ,o.terrauser -- 目前土地使用权人
    ,o.updatedate -- 更新日期
    ,o.projectsubtype -- 项目子类型
    ,o.intialworkingcapital -- 铺底流动资金
    ,o.landuseplanlicence -- 建设用地规划许可证
    ,o.terratype -- 目前土地类型
    ,o.landarea -- 目前拥有土地面积
    ,o.inputuserid -- 登记人
    ,o.holdarea -- 占地面积(平方米)
    ,o.completeflag -- 数据录入完整性标识
    ,o.migtflag -- 
    ,o.projecttype -- 项目类型
    ,o.projectinfo -- 项目建设内容
    ,o.completeddate -- 竣工日期
    ,o.copartnername -- 联建单位名称
    ,o.scriptoriumarea -- 写字间面积(平方米)
    ,o.contractorinfo -- 承建单位名称及资质
    ,o.copartnerid -- 联建单位组织机构代码
    ,o.homearea -- 自营面积(平方米)
    ,o.projectbuildlicence -- 建筑工程施工许可证
    ,o.examineinfo -- 项目审批情况
    ,o.projectregiion -- 项目所在行政区域
    ,o.projectinvestment -- 项目总投资
    ,o.useinfo -- 地价缴付（投入）情况
    ,o.remark -- 备注
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
from ${iol_schema}.icms_customer_project_info_bk o
    left join ${iol_schema}.icms_customer_project_info_op n
        on
            o.projectno = n.projectno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_project_info_cl d
        on
            o.projectno = d.projectno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_customer_project_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_project_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_project_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_project_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_project_info exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_project_info_cl;
alter table ${iol_schema}.icms_customer_project_info exchange partition p_20991231 with table ${iol_schema}.icms_customer_project_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_project_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_project_info_op purge;
drop table ${iol_schema}.icms_customer_project_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_project_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_project_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
