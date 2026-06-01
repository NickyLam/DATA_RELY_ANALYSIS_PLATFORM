/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_project_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_project_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_project_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_project_info(
    projectno varchar2(64) -- 项目编号
    ,capitalscale number(24,6) -- 项目资本金比例
    ,licence1 varchar2(64) -- 土地使用权证书
    ,projecttype varchar2(3) -- 项目类型
    ,virescenceradio number(24,6) -- 项目绿化率
    ,codistribute number(24,6) -- 联建单位所分配房屋面积
    ,useinfo varchar2(1000) -- 地价缴付投入)情况
    ,inputdate date -- 登记日期
    ,otherarea number(24,6) -- 其它面积
    ,sum1 number(24,6) -- 拆迁、补偿费
    ,capitalassertscast number(24,6) -- 固定资产投资
    ,expectproductdate date -- 竣工日期
    ,rebuildarea number(24,6) -- 还建面积
    ,sum7 number(24,6) -- 土地开发项目我行贷款
    ,colonizepower varchar2(1000) -- 新增能力
    ,licence3 varchar2(64) -- 建筑工程施工许可证
    ,otherexamineinfo varchar2(1000) -- 项目审批情况
    ,sum6 number(24,6) -- 目前土地储备中心现有土地估算价值
    ,projectregiion varchar2(64) -- 项目所在行政区域
    ,chieflyproduct varchar2(1000) -- 项目主要产品
    ,sum4 number(24,6) -- 目前周边土地价格
    ,sum9 number(24,6) -- 目前拥有土地估计销售价值
    ,projectadd varchar2(1000) -- 项目地址
    ,projectinvestment number(24,6) -- 项目总投资
    ,dimensionradio number(24,6) -- 项目容积率
    ,expectcompletedate date -- 计划竣工日期
    ,licence5 varchar2(64) -- 商品房预售许可证
    ,updateuserid varchar2(64) -- 更新人
    ,industry varchar2(64) -- 项目所属行业
    ,constructproperty varchar2(64) -- 建设性质
    ,licence6 varchar2(64) -- 许可证6
    ,corporgid varchar2(64) -- 法人机构编号
    ,remark varchar2(1000) -- 备注
    ,industrytype varchar2(5) -- 项目所属行业分类
    ,supervisorinfo varchar2(1000) -- 监理单位名称及资质等级
    ,projectcapital number(24,6) -- 项目资本金
    ,contractorinfo varchar2(1000) -- 承建单位名称及资质
    ,buildarea number(24,6) -- 总建筑面积
    ,carportarea number(24,6) -- 车库面积
    ,inputorgid varchar2(64) -- 登记机构
    ,developmentname varchar2(160) -- 发展商名称
    ,inputuserid varchar2(64) -- 登记人
    ,copartnername varchar2(160) -- 联建单位名称
    ,terratype varchar2(64) -- 土地目前类型
    ,homearea number(24,6) -- 自营面积
    ,plantotalcast number(24,6) -- 计划总投资
    ,totallandvalue number(24,6) -- 总地价
    ,projectid varchar2(64) -- 项目立项文号
    ,developmentid varchar2(64) -- 发展商组织机构代码
    ,projectinfo varchar2(1000) -- 项目建设内容
    ,constructtimes number(22) -- 总建设期数
    ,housearea number(24,6) -- 住宅面积
    ,updateorgid varchar2(64) -- 更新机构
    ,beginbuilddate date -- 开工日期
    ,approveorgid varchar2(64) -- 立项批复单位
    ,licence4 varchar2(64) -- 建设用地规划许可证
    ,projectlevel varchar2(64) -- 项目级别
    ,sum3 number(24,6) -- 土地直接出让成本投入
    ,updatedate date -- 更新日期
    ,holdarea number(24,6) -- 占地面积
    ,licence2 varchar2(64) -- 建筑工程规划许可证
    ,projectname varchar2(200) -- 项目名称
    ,emporiumarea number(24,6) -- 商铺面积
    ,sum5 number(24,6) -- 土地开发项目预计销售价格
    ,projectsubtype varchar2(36) -- 项目子类型
    ,fund number(24,6) -- 铺底流动资金
    ,copartnerid varchar2(64) -- 联建单位组织机构代码
    ,holdtype varchar2(64) -- 土地取得方式
    ,sum8 number(24,6) -- 目前拥有土地面积
    ,otherareaflag varchar2(64) -- 是否异地项目
    ,scriptoriumarea number(24,6) -- 写字间面积
    ,sum2 number(24,6) -- 土地配套费用
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
grant select on ${iol_schema}.icms_project_info to ${iml_schema};
grant select on ${iol_schema}.icms_project_info to ${icl_schema};
grant select on ${iol_schema}.icms_project_info to ${idl_schema};
grant select on ${iol_schema}.icms_project_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_project_info is '项目基本信息';
comment on column ${iol_schema}.icms_project_info.projectno is '项目编号';
comment on column ${iol_schema}.icms_project_info.capitalscale is '项目资本金比例';
comment on column ${iol_schema}.icms_project_info.licence1 is '土地使用权证书';
comment on column ${iol_schema}.icms_project_info.projecttype is '项目类型';
comment on column ${iol_schema}.icms_project_info.virescenceradio is '项目绿化率';
comment on column ${iol_schema}.icms_project_info.codistribute is '联建单位所分配房屋面积';
comment on column ${iol_schema}.icms_project_info.useinfo is '地价缴付投入)情况';
comment on column ${iol_schema}.icms_project_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_project_info.otherarea is '其它面积';
comment on column ${iol_schema}.icms_project_info.sum1 is '拆迁、补偿费';
comment on column ${iol_schema}.icms_project_info.capitalassertscast is '固定资产投资';
comment on column ${iol_schema}.icms_project_info.expectproductdate is '竣工日期';
comment on column ${iol_schema}.icms_project_info.rebuildarea is '还建面积';
comment on column ${iol_schema}.icms_project_info.sum7 is '土地开发项目我行贷款';
comment on column ${iol_schema}.icms_project_info.colonizepower is '新增能力';
comment on column ${iol_schema}.icms_project_info.licence3 is '建筑工程施工许可证';
comment on column ${iol_schema}.icms_project_info.otherexamineinfo is '项目审批情况';
comment on column ${iol_schema}.icms_project_info.sum6 is '目前土地储备中心现有土地估算价值';
comment on column ${iol_schema}.icms_project_info.projectregiion is '项目所在行政区域';
comment on column ${iol_schema}.icms_project_info.chieflyproduct is '项目主要产品';
comment on column ${iol_schema}.icms_project_info.sum4 is '目前周边土地价格';
comment on column ${iol_schema}.icms_project_info.sum9 is '目前拥有土地估计销售价值';
comment on column ${iol_schema}.icms_project_info.projectadd is '项目地址';
comment on column ${iol_schema}.icms_project_info.projectinvestment is '项目总投资';
comment on column ${iol_schema}.icms_project_info.dimensionradio is '项目容积率';
comment on column ${iol_schema}.icms_project_info.expectcompletedate is '计划竣工日期';
comment on column ${iol_schema}.icms_project_info.licence5 is '商品房预售许可证';
comment on column ${iol_schema}.icms_project_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_project_info.industry is '项目所属行业';
comment on column ${iol_schema}.icms_project_info.constructproperty is '建设性质';
comment on column ${iol_schema}.icms_project_info.licence6 is '许可证6';
comment on column ${iol_schema}.icms_project_info.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_project_info.remark is '备注';
comment on column ${iol_schema}.icms_project_info.industrytype is '项目所属行业分类';
comment on column ${iol_schema}.icms_project_info.supervisorinfo is '监理单位名称及资质等级';
comment on column ${iol_schema}.icms_project_info.projectcapital is '项目资本金';
comment on column ${iol_schema}.icms_project_info.contractorinfo is '承建单位名称及资质';
comment on column ${iol_schema}.icms_project_info.buildarea is '总建筑面积';
comment on column ${iol_schema}.icms_project_info.carportarea is '车库面积';
comment on column ${iol_schema}.icms_project_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_project_info.developmentname is '发展商名称';
comment on column ${iol_schema}.icms_project_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_project_info.copartnername is '联建单位名称';
comment on column ${iol_schema}.icms_project_info.terratype is '土地目前类型';
comment on column ${iol_schema}.icms_project_info.homearea is '自营面积';
comment on column ${iol_schema}.icms_project_info.plantotalcast is '计划总投资';
comment on column ${iol_schema}.icms_project_info.totallandvalue is '总地价';
comment on column ${iol_schema}.icms_project_info.projectid is '项目立项文号';
comment on column ${iol_schema}.icms_project_info.developmentid is '发展商组织机构代码';
comment on column ${iol_schema}.icms_project_info.projectinfo is '项目建设内容';
comment on column ${iol_schema}.icms_project_info.constructtimes is '总建设期数';
comment on column ${iol_schema}.icms_project_info.housearea is '住宅面积';
comment on column ${iol_schema}.icms_project_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_project_info.beginbuilddate is '开工日期';
comment on column ${iol_schema}.icms_project_info.approveorgid is '立项批复单位';
comment on column ${iol_schema}.icms_project_info.licence4 is '建设用地规划许可证';
comment on column ${iol_schema}.icms_project_info.projectlevel is '项目级别';
comment on column ${iol_schema}.icms_project_info.sum3 is '土地直接出让成本投入';
comment on column ${iol_schema}.icms_project_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_project_info.holdarea is '占地面积';
comment on column ${iol_schema}.icms_project_info.licence2 is '建筑工程规划许可证';
comment on column ${iol_schema}.icms_project_info.projectname is '项目名称';
comment on column ${iol_schema}.icms_project_info.emporiumarea is '商铺面积';
comment on column ${iol_schema}.icms_project_info.sum5 is '土地开发项目预计销售价格';
comment on column ${iol_schema}.icms_project_info.projectsubtype is '项目子类型';
comment on column ${iol_schema}.icms_project_info.fund is '铺底流动资金';
comment on column ${iol_schema}.icms_project_info.copartnerid is '联建单位组织机构代码';
comment on column ${iol_schema}.icms_project_info.holdtype is '土地取得方式';
comment on column ${iol_schema}.icms_project_info.sum8 is '目前拥有土地面积';
comment on column ${iol_schema}.icms_project_info.otherareaflag is '是否异地项目';
comment on column ${iol_schema}.icms_project_info.scriptoriumarea is '写字间面积';
comment on column ${iol_schema}.icms_project_info.sum2 is '土地配套费用';
comment on column ${iol_schema}.icms_project_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_project_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_project_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_project_info.etl_timestamp is 'ETL处理时间戳';
