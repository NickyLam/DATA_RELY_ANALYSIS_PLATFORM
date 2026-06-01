/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_group_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_group_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_group_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_group_info(
    groupid varchar2(30) -- 客户编号
    ,businessscope varchar2(4000) -- 经营范围(文本描述)
    ,mgtorgid varchar2(32) -- 主办机构
    ,currentversionseq varchar2(32) -- 当前正在使用的家谱版本号
    ,countrycode varchar2(18) -- 所在国家(地区)
    ,firstloandate date -- 首贷日期
    ,groupmembercount number(22) -- 集群成员数量
    ,registerregioncode varchar2(18) -- 登记地行政区划代码
    ,creditlevel varchar2(80) -- 内部信用评级级别
    ,groupcredittype varchar2(18) -- 集团类型
    ,customertype varchar2(18) -- 客户类型
    ,newregioncode varchar2(18) -- 行政区域（风险预警）
    ,industrytypeproportion number(16,2) -- 第一大主营业务占比
    ,city varchar2(18) -- 省直辖市/县
    ,officeaddupdatedate date -- 更新办公地址日期
    ,isretiveeconmics varchar2(1) -- 是否经济依存
    ,groupname varchar2(200) -- 集群名称
    ,familymapstatus varchar2(6) -- 家谱版本状态
    ,approveorgid varchar2(32) -- 复核机构
    ,isrelatedparty varchar2(10) -- 是否我行关联方标志
    ,parentcompanyofficeadd varchar2(200) -- 集团客户母公司国内办公地址
    ,industrytypeproportion2 number(16,2) -- 第三大主营业务占比
    ,corpidetitytype varchar2(18) -- 征信报送企业身份标识类型
    ,refversionseq varchar2(32) -- 当前正在维护的家谱版本号
    ,oldfinancefocus varchar2(18) -- 过往财务集中情况
    ,oldheadofficemanage varchar2(6) -- 过往总行集中管理情况
    ,industrytype varchar2(18) -- 所属行业类型
    ,subjectbusiness varchar2(800) -- 主营业务(文本描述)
    ,groupstatus varchar2(6) -- 集群状态
    ,groupabbname varchar2(500) -- 集团简称
    ,updateuserid varchar2(32) -- 更新人
    ,updatedate date -- 更新日期
    ,corporgid varchar2(32) -- 法人机构编号
    ,groupcustomertype varchar2(18) -- 集群客户类型
    ,oldgroupcredittype varchar2(18) -- 过往集团类型
    ,industrytypeproportion1 number(16,2) -- 第二大主营业务占比
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,mgtuserid varchar2(32) -- 主办客户经理
    ,inputorgid varchar2(32) -- 登记单位
    ,inputuserid varchar2(32) -- 登记人
    ,oldgroupabbname varchar2(500) -- 集群曾用简称
    ,isrelativetrade varchar2(1) -- 是否我行关联交易
    ,actualcontrollercounts number(15,0) -- 实际控制人个数
    ,remark varchar2(500) -- 备注
    ,updateorgid varchar2(32) -- 更新机构
    ,industrytype1 varchar2(18) -- 第二大主营业务编号(行业代码)
    ,industrytype2 varchar2(18) -- 第三大主营业务编号(行业代码)
    ,inputdate date -- 登记日期
    ,financialgroupscope varchar2(200) -- 规模(文本描述)
    ,financialgroupposition varchar2(200) -- 行业地位(文本描述)
    ,grouptype varchar2(32) -- 集群类型
    ,approvedate date -- 复核日期
    ,oldgroupname varchar2(500) -- 集团曾用名
    ,headofficemanage varchar2(6) -- 总行集中管理
    ,approveuserid varchar2(32) -- 复核人
    ,investmencounts number(15,0) -- 主要出资人个数
    ,keymembercustomerid varchar2(32) -- 集团核心企业
    ,financefocus varchar2(18) -- 财务是否集中
    ,migtoldvalue varchar2(250) -- 迁移数据-参数转换前字段值
    ,actualcontroller varchar2(200) -- 实际控制人
    ,migtcustomerid varchar2(64) -- 转换前客户号
    ,iscontroller varchar2(2) -- 是否有实控人
    ,controllercerttype varchar2(10) -- 实控人证件类型
    ,controllercertid varchar2(64) -- 实控人证件号码
    ,controllernational varchar2(18) -- 实控人国别
    ,groupnature varchar2(32) -- 集团性质
    ,groupcreditcustomertype varchar2(32) -- 集团客户类型
    ,groupstatusone varchar2(3) -- 集团是否生效
    ,isflow varchar2(3) -- 是否修改成员信息走流程：0否，1是
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
grant select on ${iol_schema}.icms_group_info to ${iml_schema};
grant select on ${iol_schema}.icms_group_info to ${icl_schema};
grant select on ${iol_schema}.icms_group_info to ${idl_schema};
grant select on ${iol_schema}.icms_group_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_group_info is '集群客户概况信息集群客户概况信息';
comment on column ${iol_schema}.icms_group_info.groupid is '客户编号';
comment on column ${iol_schema}.icms_group_info.businessscope is '经营范围(文本描述)';
comment on column ${iol_schema}.icms_group_info.mgtorgid is '主办机构';
comment on column ${iol_schema}.icms_group_info.currentversionseq is '当前正在使用的家谱版本号';
comment on column ${iol_schema}.icms_group_info.countrycode is '所在国家(地区)';
comment on column ${iol_schema}.icms_group_info.firstloandate is '首贷日期';
comment on column ${iol_schema}.icms_group_info.groupmembercount is '集群成员数量';
comment on column ${iol_schema}.icms_group_info.registerregioncode is '登记地行政区划代码';
comment on column ${iol_schema}.icms_group_info.creditlevel is '内部信用评级级别';
comment on column ${iol_schema}.icms_group_info.groupcredittype is '集团类型';
comment on column ${iol_schema}.icms_group_info.customertype is '客户类型';
comment on column ${iol_schema}.icms_group_info.newregioncode is '行政区域（风险预警）';
comment on column ${iol_schema}.icms_group_info.industrytypeproportion is '第一大主营业务占比';
comment on column ${iol_schema}.icms_group_info.city is '省直辖市/县';
comment on column ${iol_schema}.icms_group_info.officeaddupdatedate is '更新办公地址日期';
comment on column ${iol_schema}.icms_group_info.isretiveeconmics is '是否经济依存';
comment on column ${iol_schema}.icms_group_info.groupname is '集群名称';
comment on column ${iol_schema}.icms_group_info.familymapstatus is '家谱版本状态';
comment on column ${iol_schema}.icms_group_info.approveorgid is '复核机构';
comment on column ${iol_schema}.icms_group_info.isrelatedparty is '是否我行关联方标志';
comment on column ${iol_schema}.icms_group_info.parentcompanyofficeadd is '集团客户母公司国内办公地址';
comment on column ${iol_schema}.icms_group_info.industrytypeproportion2 is '第三大主营业务占比';
comment on column ${iol_schema}.icms_group_info.corpidetitytype is '征信报送企业身份标识类型';
comment on column ${iol_schema}.icms_group_info.refversionseq is '当前正在维护的家谱版本号';
comment on column ${iol_schema}.icms_group_info.oldfinancefocus is '过往财务集中情况';
comment on column ${iol_schema}.icms_group_info.oldheadofficemanage is '过往总行集中管理情况';
comment on column ${iol_schema}.icms_group_info.industrytype is '所属行业类型';
comment on column ${iol_schema}.icms_group_info.subjectbusiness is '主营业务(文本描述)';
comment on column ${iol_schema}.icms_group_info.groupstatus is '集群状态';
comment on column ${iol_schema}.icms_group_info.groupabbname is '集团简称';
comment on column ${iol_schema}.icms_group_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_group_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_group_info.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_group_info.groupcustomertype is '集群客户类型';
comment on column ${iol_schema}.icms_group_info.oldgroupcredittype is '过往集团类型';
comment on column ${iol_schema}.icms_group_info.industrytypeproportion1 is '第二大主营业务占比';
comment on column ${iol_schema}.icms_group_info.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_group_info.mgtuserid is '主办客户经理';
comment on column ${iol_schema}.icms_group_info.inputorgid is '登记单位';
comment on column ${iol_schema}.icms_group_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_group_info.oldgroupabbname is '集群曾用简称';
comment on column ${iol_schema}.icms_group_info.isrelativetrade is '是否我行关联交易';
comment on column ${iol_schema}.icms_group_info.actualcontrollercounts is '实际控制人个数';
comment on column ${iol_schema}.icms_group_info.remark is '备注';
comment on column ${iol_schema}.icms_group_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_group_info.industrytype1 is '第二大主营业务编号(行业代码)';
comment on column ${iol_schema}.icms_group_info.industrytype2 is '第三大主营业务编号(行业代码)';
comment on column ${iol_schema}.icms_group_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_group_info.financialgroupscope is '规模(文本描述)';
comment on column ${iol_schema}.icms_group_info.financialgroupposition is '行业地位(文本描述)';
comment on column ${iol_schema}.icms_group_info.grouptype is '集群类型';
comment on column ${iol_schema}.icms_group_info.approvedate is '复核日期';
comment on column ${iol_schema}.icms_group_info.oldgroupname is '集团曾用名';
comment on column ${iol_schema}.icms_group_info.headofficemanage is '总行集中管理';
comment on column ${iol_schema}.icms_group_info.approveuserid is '复核人';
comment on column ${iol_schema}.icms_group_info.investmencounts is '主要出资人个数';
comment on column ${iol_schema}.icms_group_info.keymembercustomerid is '集团核心企业';
comment on column ${iol_schema}.icms_group_info.financefocus is '财务是否集中';
comment on column ${iol_schema}.icms_group_info.migtoldvalue is '迁移数据-参数转换前字段值';
comment on column ${iol_schema}.icms_group_info.actualcontroller is '实际控制人';
comment on column ${iol_schema}.icms_group_info.migtcustomerid is '转换前客户号';
comment on column ${iol_schema}.icms_group_info.iscontroller is '是否有实控人';
comment on column ${iol_schema}.icms_group_info.controllercerttype is '实控人证件类型';
comment on column ${iol_schema}.icms_group_info.controllercertid is '实控人证件号码';
comment on column ${iol_schema}.icms_group_info.controllernational is '实控人国别';
comment on column ${iol_schema}.icms_group_info.groupnature is '集团性质';
comment on column ${iol_schema}.icms_group_info.groupcreditcustomertype is '集团客户类型';
comment on column ${iol_schema}.icms_group_info.groupstatusone is '集团是否生效';
comment on column ${iol_schema}.icms_group_info.isflow is '是否修改成员信息走流程：0否，1是';
comment on column ${iol_schema}.icms_group_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_group_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_group_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_group_info.etl_timestamp is 'ETL处理时间戳';
