/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_project_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_project_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_project_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_project_info(
    projectno varchar2(64) -- 项目编号
    ,landestimatevalue number(24,6) -- 目前拥有土地估计销售价值
    ,industrytype varchar2(5) -- 项目所属行业分类
    ,projectcapital number(24,6) -- 项目资本金
    ,carportarea number(18,2) -- 车库面积
    ,approveorgid varchar2(64) -- 立项批复单位
    ,landmatchingfee number(24,6) -- 土地配套费用
    ,developmentid varchar2(64) -- 发展商组织机构代码
    ,chieflyproduct varchar2(1000) -- 项目主要产品
    ,projectadd varchar2(1000) -- 项目地址
    ,plantotalcast number(24,6) -- 计划总投资
    ,holdtype varchar2(36) -- 土地取得方式
    ,constructionnature varchar2(36) -- 建设性质
    ,removalexpenses number(24,6) -- 拆迁、补偿费
    ,expectprojecttype varchar2(36) -- 预计开发项目类型
    ,landsellcostinput number(24,6) -- 土地直接出让成本投入
    ,capitalassetcast number(24,6) -- 固定资产投资
    ,constructionperiod number(22) -- 总建设期数
    ,surroundlandprice number(24,6) -- 目前周边土地价格
    ,developmentname varchar2(160) -- 发展商名称
    ,codistribute number(18,2) -- 联建单位所分配房屋面积(平方米)
    ,greeningrate number(24,8) -- 项目绿化率（％）
    ,updateuserid varchar2(64) -- 更新人
    ,corporgid varchar2(64) -- 法人机构编号
    ,projectid varchar2(160) -- 项目立项文号
    ,buildarea number(18,2) -- 总建筑面积(平方米)
    ,updateorgid varchar2(64) -- 更新机构
    ,emporiumarea number(18,2) -- 商铺面积(平方米)
    ,estimatesellprice number(24,6) -- 土地开发项目预计销售价格
    ,capitalscale number(24,8) -- 项目资本金比例（％）
    ,beginbuilddate date -- 开工日期
    ,estimatevalue number(24,6) -- 目前土地储备中心现有土地估算价值
    ,industry varchar2(36) -- 项目所属行业
    ,projectname varchar2(200) -- 项目名称
    ,supervisorinfo varchar2(1000) -- 监理单位名称及资质等级
    ,housearea number(18,2) -- 住宅面积(平方米)
    ,otherarea number(18,2) -- 其它面积
    ,ourloan number(24,6) -- 土地开发项目我行贷款
    ,inputorgid varchar2(64) -- 登记机构
    ,newcapacity varchar2(400) -- 新增能力
    ,rebuildarea number(18,2) -- 还建面积(平方米)
    ,expectcompletedate date -- 计划竣工日期
    ,volumeratio number(24,8) -- 项目容积率（％）
    ,commodityhousesalelicence varchar2(64) -- 商品房预售许可证
    ,projectlevel varchar2(36) -- 项目级别
    ,landusecert varchar2(64) -- 土地使用权证书
    ,inputdate date -- 登记日期
    ,projectplanlicence varchar2(64) -- 建筑工程规划许可证
    ,otherareaflag varchar2(2) -- 是否异地项目
    ,totallandvalue number(24,6) -- 总地价
    ,terrauser varchar2(160) -- 目前土地使用权人
    ,updatedate date -- 更新日期
    ,projectsubtype varchar2(36) -- 项目子类型
    ,intialworkingcapital number(24,6) -- 铺底流动资金
    ,landuseplanlicence varchar2(64) -- 建设用地规划许可证
    ,terratype varchar2(160) -- 目前土地类型
    ,landarea number(18,2) -- 目前拥有土地面积
    ,inputuserid varchar2(64) -- 登记人
    ,holdarea number(18,2) -- 占地面积(平方米)
    ,completeflag varchar2(12) -- 数据录入完整性标识
    ,migtflag varchar2(80) -- 
    ,projecttype varchar2(3) -- 项目类型
    ,projectinfo varchar2(1000) -- 项目建设内容
    ,completeddate date -- 竣工日期
    ,copartnername varchar2(160) -- 联建单位名称
    ,scriptoriumarea number(18,2) -- 写字间面积(平方米)
    ,contractorinfo varchar2(1000) -- 承建单位名称及资质
    ,copartnerid varchar2(64) -- 联建单位组织机构代码
    ,homearea number(18,2) -- 自营面积(平方米)
    ,projectbuildlicence varchar2(64) -- 建筑工程施工许可证
    ,examineinfo varchar2(1000) -- 项目审批情况
    ,projectregiion varchar2(36) -- 项目所在行政区域
    ,projectinvestment number(24,6) -- 项目总投资
    ,useinfo varchar2(1000) -- 地价缴付（投入）情况
    ,remark varchar2(1000) -- 备注
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_customer_project_info to ${iml_schema};
grant select on ${iol_schema}.icms_customer_project_info to ${icl_schema};
grant select on ${iol_schema}.icms_customer_project_info to ${idl_schema};
grant select on ${iol_schema}.icms_customer_project_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_project_info is '项目基本信息项目基本信息';
comment on column ${iol_schema}.icms_customer_project_info.projectno is '项目编号';
comment on column ${iol_schema}.icms_customer_project_info.landestimatevalue is '目前拥有土地估计销售价值';
comment on column ${iol_schema}.icms_customer_project_info.industrytype is '项目所属行业分类';
comment on column ${iol_schema}.icms_customer_project_info.projectcapital is '项目资本金';
comment on column ${iol_schema}.icms_customer_project_info.carportarea is '车库面积';
comment on column ${iol_schema}.icms_customer_project_info.approveorgid is '立项批复单位';
comment on column ${iol_schema}.icms_customer_project_info.landmatchingfee is '土地配套费用';
comment on column ${iol_schema}.icms_customer_project_info.developmentid is '发展商组织机构代码';
comment on column ${iol_schema}.icms_customer_project_info.chieflyproduct is '项目主要产品';
comment on column ${iol_schema}.icms_customer_project_info.projectadd is '项目地址';
comment on column ${iol_schema}.icms_customer_project_info.plantotalcast is '计划总投资';
comment on column ${iol_schema}.icms_customer_project_info.holdtype is '土地取得方式';
comment on column ${iol_schema}.icms_customer_project_info.constructionnature is '建设性质';
comment on column ${iol_schema}.icms_customer_project_info.removalexpenses is '拆迁、补偿费';
comment on column ${iol_schema}.icms_customer_project_info.expectprojecttype is '预计开发项目类型';
comment on column ${iol_schema}.icms_customer_project_info.landsellcostinput is '土地直接出让成本投入';
comment on column ${iol_schema}.icms_customer_project_info.capitalassetcast is '固定资产投资';
comment on column ${iol_schema}.icms_customer_project_info.constructionperiod is '总建设期数';
comment on column ${iol_schema}.icms_customer_project_info.surroundlandprice is '目前周边土地价格';
comment on column ${iol_schema}.icms_customer_project_info.developmentname is '发展商名称';
comment on column ${iol_schema}.icms_customer_project_info.codistribute is '联建单位所分配房屋面积(平方米)';
comment on column ${iol_schema}.icms_customer_project_info.greeningrate is '项目绿化率（％）';
comment on column ${iol_schema}.icms_customer_project_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_project_info.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_project_info.projectid is '项目立项文号';
comment on column ${iol_schema}.icms_customer_project_info.buildarea is '总建筑面积(平方米)';
comment on column ${iol_schema}.icms_customer_project_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_project_info.emporiumarea is '商铺面积(平方米)';
comment on column ${iol_schema}.icms_customer_project_info.estimatesellprice is '土地开发项目预计销售价格';
comment on column ${iol_schema}.icms_customer_project_info.capitalscale is '项目资本金比例（％）';
comment on column ${iol_schema}.icms_customer_project_info.beginbuilddate is '开工日期';
comment on column ${iol_schema}.icms_customer_project_info.estimatevalue is '目前土地储备中心现有土地估算价值';
comment on column ${iol_schema}.icms_customer_project_info.industry is '项目所属行业';
comment on column ${iol_schema}.icms_customer_project_info.projectname is '项目名称';
comment on column ${iol_schema}.icms_customer_project_info.supervisorinfo is '监理单位名称及资质等级';
comment on column ${iol_schema}.icms_customer_project_info.housearea is '住宅面积(平方米)';
comment on column ${iol_schema}.icms_customer_project_info.otherarea is '其它面积';
comment on column ${iol_schema}.icms_customer_project_info.ourloan is '土地开发项目我行贷款';
comment on column ${iol_schema}.icms_customer_project_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_project_info.newcapacity is '新增能力';
comment on column ${iol_schema}.icms_customer_project_info.rebuildarea is '还建面积(平方米)';
comment on column ${iol_schema}.icms_customer_project_info.expectcompletedate is '计划竣工日期';
comment on column ${iol_schema}.icms_customer_project_info.volumeratio is '项目容积率（％）';
comment on column ${iol_schema}.icms_customer_project_info.commodityhousesalelicence is '商品房预售许可证';
comment on column ${iol_schema}.icms_customer_project_info.projectlevel is '项目级别';
comment on column ${iol_schema}.icms_customer_project_info.landusecert is '土地使用权证书';
comment on column ${iol_schema}.icms_customer_project_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_project_info.projectplanlicence is '建筑工程规划许可证';
comment on column ${iol_schema}.icms_customer_project_info.otherareaflag is '是否异地项目';
comment on column ${iol_schema}.icms_customer_project_info.totallandvalue is '总地价';
comment on column ${iol_schema}.icms_customer_project_info.terrauser is '目前土地使用权人';
comment on column ${iol_schema}.icms_customer_project_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_project_info.projectsubtype is '项目子类型';
comment on column ${iol_schema}.icms_customer_project_info.intialworkingcapital is '铺底流动资金';
comment on column ${iol_schema}.icms_customer_project_info.landuseplanlicence is '建设用地规划许可证';
comment on column ${iol_schema}.icms_customer_project_info.terratype is '目前土地类型';
comment on column ${iol_schema}.icms_customer_project_info.landarea is '目前拥有土地面积';
comment on column ${iol_schema}.icms_customer_project_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_project_info.holdarea is '占地面积(平方米)';
comment on column ${iol_schema}.icms_customer_project_info.completeflag is '数据录入完整性标识';
comment on column ${iol_schema}.icms_customer_project_info.migtflag is '';
comment on column ${iol_schema}.icms_customer_project_info.projecttype is '项目类型';
comment on column ${iol_schema}.icms_customer_project_info.projectinfo is '项目建设内容';
comment on column ${iol_schema}.icms_customer_project_info.completeddate is '竣工日期';
comment on column ${iol_schema}.icms_customer_project_info.copartnername is '联建单位名称';
comment on column ${iol_schema}.icms_customer_project_info.scriptoriumarea is '写字间面积(平方米)';
comment on column ${iol_schema}.icms_customer_project_info.contractorinfo is '承建单位名称及资质';
comment on column ${iol_schema}.icms_customer_project_info.copartnerid is '联建单位组织机构代码';
comment on column ${iol_schema}.icms_customer_project_info.homearea is '自营面积(平方米)';
comment on column ${iol_schema}.icms_customer_project_info.projectbuildlicence is '建筑工程施工许可证';
comment on column ${iol_schema}.icms_customer_project_info.examineinfo is '项目审批情况';
comment on column ${iol_schema}.icms_customer_project_info.projectregiion is '项目所在行政区域';
comment on column ${iol_schema}.icms_customer_project_info.projectinvestment is '项目总投资';
comment on column ${iol_schema}.icms_customer_project_info.useinfo is '地价缴付（投入）情况';
comment on column ${iol_schema}.icms_customer_project_info.remark is '备注';
comment on column ${iol_schema}.icms_customer_project_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_project_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_project_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_project_info.etl_timestamp is 'ETL处理时间戳';
