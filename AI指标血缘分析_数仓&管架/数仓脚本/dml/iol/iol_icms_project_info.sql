/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_project_info
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
create table ${iol_schema}.icms_project_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_project_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_project_info_op purge;
drop table ${iol_schema}.icms_project_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_project_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_project_info where 0=1;

create table ${iol_schema}.icms_project_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_project_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_project_info_cl(
            projectno -- 项目编号
            ,capitalscale -- 项目资本金比例
            ,licence1 -- 土地使用权证书
            ,projecttype -- 项目类型
            ,virescenceradio -- 项目绿化率
            ,codistribute -- 联建单位所分配房屋面积
            ,useinfo -- 地价缴付投入)情况
            ,inputdate -- 登记日期
            ,otherarea -- 其它面积
            ,sum1 -- 拆迁、补偿费
            ,capitalassertscast -- 固定资产投资
            ,expectproductdate -- 竣工日期
            ,rebuildarea -- 还建面积
            ,sum7 -- 土地开发项目我行贷款
            ,colonizepower -- 新增能力
            ,licence3 -- 建筑工程施工许可证
            ,otherexamineinfo -- 项目审批情况
            ,sum6 -- 目前土地储备中心现有土地估算价值
            ,projectregiion -- 项目所在行政区域
            ,chieflyproduct -- 项目主要产品
            ,sum4 -- 目前周边土地价格
            ,sum9 -- 目前拥有土地估计销售价值
            ,projectadd -- 项目地址
            ,projectinvestment -- 项目总投资
            ,dimensionradio -- 项目容积率
            ,expectcompletedate -- 计划竣工日期
            ,licence5 -- 商品房预售许可证
            ,updateuserid -- 更新人
            ,industry -- 项目所属行业
            ,constructproperty -- 建设性质
            ,licence6 -- 许可证6
            ,corporgid -- 法人机构编号
            ,remark -- 备注
            ,industrytype -- 项目所属行业分类
            ,supervisorinfo -- 监理单位名称及资质等级
            ,projectcapital -- 项目资本金
            ,contractorinfo -- 承建单位名称及资质
            ,buildarea -- 总建筑面积
            ,carportarea -- 车库面积
            ,inputorgid -- 登记机构
            ,developmentname -- 发展商名称
            ,inputuserid -- 登记人
            ,copartnername -- 联建单位名称
            ,terratype -- 土地目前类型
            ,homearea -- 自营面积
            ,plantotalcast -- 计划总投资
            ,totallandvalue -- 总地价
            ,projectid -- 项目立项文号
            ,developmentid -- 发展商组织机构代码
            ,projectinfo -- 项目建设内容
            ,constructtimes -- 总建设期数
            ,housearea -- 住宅面积
            ,updateorgid -- 更新机构
            ,beginbuilddate -- 开工日期
            ,approveorgid -- 立项批复单位
            ,licence4 -- 建设用地规划许可证
            ,projectlevel -- 项目级别
            ,sum3 -- 土地直接出让成本投入
            ,updatedate -- 更新日期
            ,holdarea -- 占地面积
            ,licence2 -- 建筑工程规划许可证
            ,projectname -- 项目名称
            ,emporiumarea -- 商铺面积
            ,sum5 -- 土地开发项目预计销售价格
            ,projectsubtype -- 项目子类型
            ,fund -- 铺底流动资金
            ,copartnerid -- 联建单位组织机构代码
            ,holdtype -- 土地取得方式
            ,sum8 -- 目前拥有土地面积
            ,otherareaflag -- 是否异地项目
            ,scriptoriumarea -- 写字间面积
            ,sum2 -- 土地配套费用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_project_info_op(
            projectno -- 项目编号
            ,capitalscale -- 项目资本金比例
            ,licence1 -- 土地使用权证书
            ,projecttype -- 项目类型
            ,virescenceradio -- 项目绿化率
            ,codistribute -- 联建单位所分配房屋面积
            ,useinfo -- 地价缴付投入)情况
            ,inputdate -- 登记日期
            ,otherarea -- 其它面积
            ,sum1 -- 拆迁、补偿费
            ,capitalassertscast -- 固定资产投资
            ,expectproductdate -- 竣工日期
            ,rebuildarea -- 还建面积
            ,sum7 -- 土地开发项目我行贷款
            ,colonizepower -- 新增能力
            ,licence3 -- 建筑工程施工许可证
            ,otherexamineinfo -- 项目审批情况
            ,sum6 -- 目前土地储备中心现有土地估算价值
            ,projectregiion -- 项目所在行政区域
            ,chieflyproduct -- 项目主要产品
            ,sum4 -- 目前周边土地价格
            ,sum9 -- 目前拥有土地估计销售价值
            ,projectadd -- 项目地址
            ,projectinvestment -- 项目总投资
            ,dimensionradio -- 项目容积率
            ,expectcompletedate -- 计划竣工日期
            ,licence5 -- 商品房预售许可证
            ,updateuserid -- 更新人
            ,industry -- 项目所属行业
            ,constructproperty -- 建设性质
            ,licence6 -- 许可证6
            ,corporgid -- 法人机构编号
            ,remark -- 备注
            ,industrytype -- 项目所属行业分类
            ,supervisorinfo -- 监理单位名称及资质等级
            ,projectcapital -- 项目资本金
            ,contractorinfo -- 承建单位名称及资质
            ,buildarea -- 总建筑面积
            ,carportarea -- 车库面积
            ,inputorgid -- 登记机构
            ,developmentname -- 发展商名称
            ,inputuserid -- 登记人
            ,copartnername -- 联建单位名称
            ,terratype -- 土地目前类型
            ,homearea -- 自营面积
            ,plantotalcast -- 计划总投资
            ,totallandvalue -- 总地价
            ,projectid -- 项目立项文号
            ,developmentid -- 发展商组织机构代码
            ,projectinfo -- 项目建设内容
            ,constructtimes -- 总建设期数
            ,housearea -- 住宅面积
            ,updateorgid -- 更新机构
            ,beginbuilddate -- 开工日期
            ,approveorgid -- 立项批复单位
            ,licence4 -- 建设用地规划许可证
            ,projectlevel -- 项目级别
            ,sum3 -- 土地直接出让成本投入
            ,updatedate -- 更新日期
            ,holdarea -- 占地面积
            ,licence2 -- 建筑工程规划许可证
            ,projectname -- 项目名称
            ,emporiumarea -- 商铺面积
            ,sum5 -- 土地开发项目预计销售价格
            ,projectsubtype -- 项目子类型
            ,fund -- 铺底流动资金
            ,copartnerid -- 联建单位组织机构代码
            ,holdtype -- 土地取得方式
            ,sum8 -- 目前拥有土地面积
            ,otherareaflag -- 是否异地项目
            ,scriptoriumarea -- 写字间面积
            ,sum2 -- 土地配套费用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.projectno, o.projectno) as projectno -- 项目编号
    ,nvl(n.capitalscale, o.capitalscale) as capitalscale -- 项目资本金比例
    ,nvl(n.licence1, o.licence1) as licence1 -- 土地使用权证书
    ,nvl(n.projecttype, o.projecttype) as projecttype -- 项目类型
    ,nvl(n.virescenceradio, o.virescenceradio) as virescenceradio -- 项目绿化率
    ,nvl(n.codistribute, o.codistribute) as codistribute -- 联建单位所分配房屋面积
    ,nvl(n.useinfo, o.useinfo) as useinfo -- 地价缴付投入)情况
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.otherarea, o.otherarea) as otherarea -- 其它面积
    ,nvl(n.sum1, o.sum1) as sum1 -- 拆迁、补偿费
    ,nvl(n.capitalassertscast, o.capitalassertscast) as capitalassertscast -- 固定资产投资
    ,nvl(n.expectproductdate, o.expectproductdate) as expectproductdate -- 竣工日期
    ,nvl(n.rebuildarea, o.rebuildarea) as rebuildarea -- 还建面积
    ,nvl(n.sum7, o.sum7) as sum7 -- 土地开发项目我行贷款
    ,nvl(n.colonizepower, o.colonizepower) as colonizepower -- 新增能力
    ,nvl(n.licence3, o.licence3) as licence3 -- 建筑工程施工许可证
    ,nvl(n.otherexamineinfo, o.otherexamineinfo) as otherexamineinfo -- 项目审批情况
    ,nvl(n.sum6, o.sum6) as sum6 -- 目前土地储备中心现有土地估算价值
    ,nvl(n.projectregiion, o.projectregiion) as projectregiion -- 项目所在行政区域
    ,nvl(n.chieflyproduct, o.chieflyproduct) as chieflyproduct -- 项目主要产品
    ,nvl(n.sum4, o.sum4) as sum4 -- 目前周边土地价格
    ,nvl(n.sum9, o.sum9) as sum9 -- 目前拥有土地估计销售价值
    ,nvl(n.projectadd, o.projectadd) as projectadd -- 项目地址
    ,nvl(n.projectinvestment, o.projectinvestment) as projectinvestment -- 项目总投资
    ,nvl(n.dimensionradio, o.dimensionradio) as dimensionradio -- 项目容积率
    ,nvl(n.expectcompletedate, o.expectcompletedate) as expectcompletedate -- 计划竣工日期
    ,nvl(n.licence5, o.licence5) as licence5 -- 商品房预售许可证
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.industry, o.industry) as industry -- 项目所属行业
    ,nvl(n.constructproperty, o.constructproperty) as constructproperty -- 建设性质
    ,nvl(n.licence6, o.licence6) as licence6 -- 许可证6
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.industrytype, o.industrytype) as industrytype -- 项目所属行业分类
    ,nvl(n.supervisorinfo, o.supervisorinfo) as supervisorinfo -- 监理单位名称及资质等级
    ,nvl(n.projectcapital, o.projectcapital) as projectcapital -- 项目资本金
    ,nvl(n.contractorinfo, o.contractorinfo) as contractorinfo -- 承建单位名称及资质
    ,nvl(n.buildarea, o.buildarea) as buildarea -- 总建筑面积
    ,nvl(n.carportarea, o.carportarea) as carportarea -- 车库面积
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.developmentname, o.developmentname) as developmentname -- 发展商名称
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.copartnername, o.copartnername) as copartnername -- 联建单位名称
    ,nvl(n.terratype, o.terratype) as terratype -- 土地目前类型
    ,nvl(n.homearea, o.homearea) as homearea -- 自营面积
    ,nvl(n.plantotalcast, o.plantotalcast) as plantotalcast -- 计划总投资
    ,nvl(n.totallandvalue, o.totallandvalue) as totallandvalue -- 总地价
    ,nvl(n.projectid, o.projectid) as projectid -- 项目立项文号
    ,nvl(n.developmentid, o.developmentid) as developmentid -- 发展商组织机构代码
    ,nvl(n.projectinfo, o.projectinfo) as projectinfo -- 项目建设内容
    ,nvl(n.constructtimes, o.constructtimes) as constructtimes -- 总建设期数
    ,nvl(n.housearea, o.housearea) as housearea -- 住宅面积
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.beginbuilddate, o.beginbuilddate) as beginbuilddate -- 开工日期
    ,nvl(n.approveorgid, o.approveorgid) as approveorgid -- 立项批复单位
    ,nvl(n.licence4, o.licence4) as licence4 -- 建设用地规划许可证
    ,nvl(n.projectlevel, o.projectlevel) as projectlevel -- 项目级别
    ,nvl(n.sum3, o.sum3) as sum3 -- 土地直接出让成本投入
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.holdarea, o.holdarea) as holdarea -- 占地面积
    ,nvl(n.licence2, o.licence2) as licence2 -- 建筑工程规划许可证
    ,nvl(n.projectname, o.projectname) as projectname -- 项目名称
    ,nvl(n.emporiumarea, o.emporiumarea) as emporiumarea -- 商铺面积
    ,nvl(n.sum5, o.sum5) as sum5 -- 土地开发项目预计销售价格
    ,nvl(n.projectsubtype, o.projectsubtype) as projectsubtype -- 项目子类型
    ,nvl(n.fund, o.fund) as fund -- 铺底流动资金
    ,nvl(n.copartnerid, o.copartnerid) as copartnerid -- 联建单位组织机构代码
    ,nvl(n.holdtype, o.holdtype) as holdtype -- 土地取得方式
    ,nvl(n.sum8, o.sum8) as sum8 -- 目前拥有土地面积
    ,nvl(n.otherareaflag, o.otherareaflag) as otherareaflag -- 是否异地项目
    ,nvl(n.scriptoriumarea, o.scriptoriumarea) as scriptoriumarea -- 写字间面积
    ,nvl(n.sum2, o.sum2) as sum2 -- 土地配套费用
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
from (select * from ${iol_schema}.icms_project_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_project_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.projectno = n.projectno
where (
        o.projectno is null
    )
    or (
        n.projectno is null
    )
    or (
        o.capitalscale <> n.capitalscale
        or o.licence1 <> n.licence1
        or o.projecttype <> n.projecttype
        or o.virescenceradio <> n.virescenceradio
        or o.codistribute <> n.codistribute
        or o.useinfo <> n.useinfo
        or o.inputdate <> n.inputdate
        or o.otherarea <> n.otherarea
        or o.sum1 <> n.sum1
        or o.capitalassertscast <> n.capitalassertscast
        or o.expectproductdate <> n.expectproductdate
        or o.rebuildarea <> n.rebuildarea
        or o.sum7 <> n.sum7
        or o.colonizepower <> n.colonizepower
        or o.licence3 <> n.licence3
        or o.otherexamineinfo <> n.otherexamineinfo
        or o.sum6 <> n.sum6
        or o.projectregiion <> n.projectregiion
        or o.chieflyproduct <> n.chieflyproduct
        or o.sum4 <> n.sum4
        or o.sum9 <> n.sum9
        or o.projectadd <> n.projectadd
        or o.projectinvestment <> n.projectinvestment
        or o.dimensionradio <> n.dimensionradio
        or o.expectcompletedate <> n.expectcompletedate
        or o.licence5 <> n.licence5
        or o.updateuserid <> n.updateuserid
        or o.industry <> n.industry
        or o.constructproperty <> n.constructproperty
        or o.licence6 <> n.licence6
        or o.corporgid <> n.corporgid
        or o.remark <> n.remark
        or o.industrytype <> n.industrytype
        or o.supervisorinfo <> n.supervisorinfo
        or o.projectcapital <> n.projectcapital
        or o.contractorinfo <> n.contractorinfo
        or o.buildarea <> n.buildarea
        or o.carportarea <> n.carportarea
        or o.inputorgid <> n.inputorgid
        or o.developmentname <> n.developmentname
        or o.inputuserid <> n.inputuserid
        or o.copartnername <> n.copartnername
        or o.terratype <> n.terratype
        or o.homearea <> n.homearea
        or o.plantotalcast <> n.plantotalcast
        or o.totallandvalue <> n.totallandvalue
        or o.projectid <> n.projectid
        or o.developmentid <> n.developmentid
        or o.projectinfo <> n.projectinfo
        or o.constructtimes <> n.constructtimes
        or o.housearea <> n.housearea
        or o.updateorgid <> n.updateorgid
        or o.beginbuilddate <> n.beginbuilddate
        or o.approveorgid <> n.approveorgid
        or o.licence4 <> n.licence4
        or o.projectlevel <> n.projectlevel
        or o.sum3 <> n.sum3
        or o.updatedate <> n.updatedate
        or o.holdarea <> n.holdarea
        or o.licence2 <> n.licence2
        or o.projectname <> n.projectname
        or o.emporiumarea <> n.emporiumarea
        or o.sum5 <> n.sum5
        or o.projectsubtype <> n.projectsubtype
        or o.fund <> n.fund
        or o.copartnerid <> n.copartnerid
        or o.holdtype <> n.holdtype
        or o.sum8 <> n.sum8
        or o.otherareaflag <> n.otherareaflag
        or o.scriptoriumarea <> n.scriptoriumarea
        or o.sum2 <> n.sum2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_project_info_cl(
            projectno -- 项目编号
            ,capitalscale -- 项目资本金比例
            ,licence1 -- 土地使用权证书
            ,projecttype -- 项目类型
            ,virescenceradio -- 项目绿化率
            ,codistribute -- 联建单位所分配房屋面积
            ,useinfo -- 地价缴付投入)情况
            ,inputdate -- 登记日期
            ,otherarea -- 其它面积
            ,sum1 -- 拆迁、补偿费
            ,capitalassertscast -- 固定资产投资
            ,expectproductdate -- 竣工日期
            ,rebuildarea -- 还建面积
            ,sum7 -- 土地开发项目我行贷款
            ,colonizepower -- 新增能力
            ,licence3 -- 建筑工程施工许可证
            ,otherexamineinfo -- 项目审批情况
            ,sum6 -- 目前土地储备中心现有土地估算价值
            ,projectregiion -- 项目所在行政区域
            ,chieflyproduct -- 项目主要产品
            ,sum4 -- 目前周边土地价格
            ,sum9 -- 目前拥有土地估计销售价值
            ,projectadd -- 项目地址
            ,projectinvestment -- 项目总投资
            ,dimensionradio -- 项目容积率
            ,expectcompletedate -- 计划竣工日期
            ,licence5 -- 商品房预售许可证
            ,updateuserid -- 更新人
            ,industry -- 项目所属行业
            ,constructproperty -- 建设性质
            ,licence6 -- 许可证6
            ,corporgid -- 法人机构编号
            ,remark -- 备注
            ,industrytype -- 项目所属行业分类
            ,supervisorinfo -- 监理单位名称及资质等级
            ,projectcapital -- 项目资本金
            ,contractorinfo -- 承建单位名称及资质
            ,buildarea -- 总建筑面积
            ,carportarea -- 车库面积
            ,inputorgid -- 登记机构
            ,developmentname -- 发展商名称
            ,inputuserid -- 登记人
            ,copartnername -- 联建单位名称
            ,terratype -- 土地目前类型
            ,homearea -- 自营面积
            ,plantotalcast -- 计划总投资
            ,totallandvalue -- 总地价
            ,projectid -- 项目立项文号
            ,developmentid -- 发展商组织机构代码
            ,projectinfo -- 项目建设内容
            ,constructtimes -- 总建设期数
            ,housearea -- 住宅面积
            ,updateorgid -- 更新机构
            ,beginbuilddate -- 开工日期
            ,approveorgid -- 立项批复单位
            ,licence4 -- 建设用地规划许可证
            ,projectlevel -- 项目级别
            ,sum3 -- 土地直接出让成本投入
            ,updatedate -- 更新日期
            ,holdarea -- 占地面积
            ,licence2 -- 建筑工程规划许可证
            ,projectname -- 项目名称
            ,emporiumarea -- 商铺面积
            ,sum5 -- 土地开发项目预计销售价格
            ,projectsubtype -- 项目子类型
            ,fund -- 铺底流动资金
            ,copartnerid -- 联建单位组织机构代码
            ,holdtype -- 土地取得方式
            ,sum8 -- 目前拥有土地面积
            ,otherareaflag -- 是否异地项目
            ,scriptoriumarea -- 写字间面积
            ,sum2 -- 土地配套费用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_project_info_op(
            projectno -- 项目编号
            ,capitalscale -- 项目资本金比例
            ,licence1 -- 土地使用权证书
            ,projecttype -- 项目类型
            ,virescenceradio -- 项目绿化率
            ,codistribute -- 联建单位所分配房屋面积
            ,useinfo -- 地价缴付投入)情况
            ,inputdate -- 登记日期
            ,otherarea -- 其它面积
            ,sum1 -- 拆迁、补偿费
            ,capitalassertscast -- 固定资产投资
            ,expectproductdate -- 竣工日期
            ,rebuildarea -- 还建面积
            ,sum7 -- 土地开发项目我行贷款
            ,colonizepower -- 新增能力
            ,licence3 -- 建筑工程施工许可证
            ,otherexamineinfo -- 项目审批情况
            ,sum6 -- 目前土地储备中心现有土地估算价值
            ,projectregiion -- 项目所在行政区域
            ,chieflyproduct -- 项目主要产品
            ,sum4 -- 目前周边土地价格
            ,sum9 -- 目前拥有土地估计销售价值
            ,projectadd -- 项目地址
            ,projectinvestment -- 项目总投资
            ,dimensionradio -- 项目容积率
            ,expectcompletedate -- 计划竣工日期
            ,licence5 -- 商品房预售许可证
            ,updateuserid -- 更新人
            ,industry -- 项目所属行业
            ,constructproperty -- 建设性质
            ,licence6 -- 许可证6
            ,corporgid -- 法人机构编号
            ,remark -- 备注
            ,industrytype -- 项目所属行业分类
            ,supervisorinfo -- 监理单位名称及资质等级
            ,projectcapital -- 项目资本金
            ,contractorinfo -- 承建单位名称及资质
            ,buildarea -- 总建筑面积
            ,carportarea -- 车库面积
            ,inputorgid -- 登记机构
            ,developmentname -- 发展商名称
            ,inputuserid -- 登记人
            ,copartnername -- 联建单位名称
            ,terratype -- 土地目前类型
            ,homearea -- 自营面积
            ,plantotalcast -- 计划总投资
            ,totallandvalue -- 总地价
            ,projectid -- 项目立项文号
            ,developmentid -- 发展商组织机构代码
            ,projectinfo -- 项目建设内容
            ,constructtimes -- 总建设期数
            ,housearea -- 住宅面积
            ,updateorgid -- 更新机构
            ,beginbuilddate -- 开工日期
            ,approveorgid -- 立项批复单位
            ,licence4 -- 建设用地规划许可证
            ,projectlevel -- 项目级别
            ,sum3 -- 土地直接出让成本投入
            ,updatedate -- 更新日期
            ,holdarea -- 占地面积
            ,licence2 -- 建筑工程规划许可证
            ,projectname -- 项目名称
            ,emporiumarea -- 商铺面积
            ,sum5 -- 土地开发项目预计销售价格
            ,projectsubtype -- 项目子类型
            ,fund -- 铺底流动资金
            ,copartnerid -- 联建单位组织机构代码
            ,holdtype -- 土地取得方式
            ,sum8 -- 目前拥有土地面积
            ,otherareaflag -- 是否异地项目
            ,scriptoriumarea -- 写字间面积
            ,sum2 -- 土地配套费用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.projectno -- 项目编号
    ,o.capitalscale -- 项目资本金比例
    ,o.licence1 -- 土地使用权证书
    ,o.projecttype -- 项目类型
    ,o.virescenceradio -- 项目绿化率
    ,o.codistribute -- 联建单位所分配房屋面积
    ,o.useinfo -- 地价缴付投入)情况
    ,o.inputdate -- 登记日期
    ,o.otherarea -- 其它面积
    ,o.sum1 -- 拆迁、补偿费
    ,o.capitalassertscast -- 固定资产投资
    ,o.expectproductdate -- 竣工日期
    ,o.rebuildarea -- 还建面积
    ,o.sum7 -- 土地开发项目我行贷款
    ,o.colonizepower -- 新增能力
    ,o.licence3 -- 建筑工程施工许可证
    ,o.otherexamineinfo -- 项目审批情况
    ,o.sum6 -- 目前土地储备中心现有土地估算价值
    ,o.projectregiion -- 项目所在行政区域
    ,o.chieflyproduct -- 项目主要产品
    ,o.sum4 -- 目前周边土地价格
    ,o.sum9 -- 目前拥有土地估计销售价值
    ,o.projectadd -- 项目地址
    ,o.projectinvestment -- 项目总投资
    ,o.dimensionradio -- 项目容积率
    ,o.expectcompletedate -- 计划竣工日期
    ,o.licence5 -- 商品房预售许可证
    ,o.updateuserid -- 更新人
    ,o.industry -- 项目所属行业
    ,o.constructproperty -- 建设性质
    ,o.licence6 -- 许可证6
    ,o.corporgid -- 法人机构编号
    ,o.remark -- 备注
    ,o.industrytype -- 项目所属行业分类
    ,o.supervisorinfo -- 监理单位名称及资质等级
    ,o.projectcapital -- 项目资本金
    ,o.contractorinfo -- 承建单位名称及资质
    ,o.buildarea -- 总建筑面积
    ,o.carportarea -- 车库面积
    ,o.inputorgid -- 登记机构
    ,o.developmentname -- 发展商名称
    ,o.inputuserid -- 登记人
    ,o.copartnername -- 联建单位名称
    ,o.terratype -- 土地目前类型
    ,o.homearea -- 自营面积
    ,o.plantotalcast -- 计划总投资
    ,o.totallandvalue -- 总地价
    ,o.projectid -- 项目立项文号
    ,o.developmentid -- 发展商组织机构代码
    ,o.projectinfo -- 项目建设内容
    ,o.constructtimes -- 总建设期数
    ,o.housearea -- 住宅面积
    ,o.updateorgid -- 更新机构
    ,o.beginbuilddate -- 开工日期
    ,o.approveorgid -- 立项批复单位
    ,o.licence4 -- 建设用地规划许可证
    ,o.projectlevel -- 项目级别
    ,o.sum3 -- 土地直接出让成本投入
    ,o.updatedate -- 更新日期
    ,o.holdarea -- 占地面积
    ,o.licence2 -- 建筑工程规划许可证
    ,o.projectname -- 项目名称
    ,o.emporiumarea -- 商铺面积
    ,o.sum5 -- 土地开发项目预计销售价格
    ,o.projectsubtype -- 项目子类型
    ,o.fund -- 铺底流动资金
    ,o.copartnerid -- 联建单位组织机构代码
    ,o.holdtype -- 土地取得方式
    ,o.sum8 -- 目前拥有土地面积
    ,o.otherareaflag -- 是否异地项目
    ,o.scriptoriumarea -- 写字间面积
    ,o.sum2 -- 土地配套费用
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
from ${iol_schema}.icms_project_info_bk o
    left join ${iol_schema}.icms_project_info_op n
        on
            o.projectno = n.projectno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_project_info_cl d
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
--truncate table ${iol_schema}.icms_project_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_project_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_project_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_project_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_project_info exchange partition p_${batch_date} with table ${iol_schema}.icms_project_info_cl;
alter table ${iol_schema}.icms_project_info exchange partition p_20991231 with table ${iol_schema}.icms_project_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_project_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_project_info_op purge;
drop table ${iol_schema}.icms_project_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_project_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_project_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
