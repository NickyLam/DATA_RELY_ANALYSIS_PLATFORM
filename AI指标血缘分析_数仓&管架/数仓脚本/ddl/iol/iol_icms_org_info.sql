/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_org_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_org_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_org_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_org_info(
    orgid varchar2(12) -- 机构编号
    ,orgstatus varchar2(1) -- 机构状态
    ,orgadd varchar2(400) -- 机构地址
    ,cmnum number(22) -- 客户经理数
    ,hostno varchar2(36) -- 主机号
    ,corporgid varchar2(64) -- 法人机构编号
    ,vitualid varchar2(64) -- 虚拟柜员号
    ,inputuser varchar2(64) -- 登记人
    ,updatedate varchar2(64) -- 
    ,orglevel varchar2(2) -- 机构级别
    ,orgclass varchar2(64) -- 机构类型
    ,orgcode varchar2(64) -- 机构编码
    ,updateuser varchar2(64) -- 更新人
    ,orgproperty varchar2(1000) -- 属性集
    ,relativeorgid varchar2(12) -- 上级机构编号
    ,orgtel varchar2(30) -- 联系电话
    ,businesslicense varchar2(64) -- 营业执照机构级别
    ,branchnum number(22) -- 管辖网点数
    ,updatetime varchar2(32) -- 更新时间
    ,belongarea varchar2(6) -- 行政区划
    ,zipcode varchar2(64) -- 邮政编码
    ,principal varchar2(36) -- 负责人
    ,belongorgid varchar2(12) -- 权属机构
    ,inputorg varchar2(64) -- 登记机构
    ,orgoldname varchar2(160) -- 机构曾用名
    ,setupdate date -- 机构成立日期
    ,businesshours varchar2(160) -- 营业时间
    ,updateorg varchar2(64) -- 更新机构
    ,inputtime varchar2(32) -- 登记时间
    ,inputdate varchar2(64) -- 
    ,banklicense varchar2(30) -- 金融许可证编号
    ,mainframeexgid varchar2(64) -- 交换号
    ,ishs varchar2(2) -- 是否是记账机构,码值：YesNo
    ,orgname varchar2(200) -- 机构名称
    ,remark varchar2(1000) -- 备注
    ,vitualserialno number(22) -- 虚拟流水号
    ,bankid varchar2(30) -- 人行金融机构编码
    ,sortno varchar2(64) -- 排序号
    ,mainframeorgid varchar2(64) -- 网点号
    ,title varchar2(80) -- 职务
    ,fixphone varchar2(11) -- 传真
    ,contactpeople varchar2(80) -- 联系人
    ,mobiletel varchar2(30) -- 联系人手机号码
    ,email varchar2(400) -- 电子邮箱
    ,orgalias varchar2(20) -- 机构批复简称
    ,belongorglevel varchar2(20) -- 上级机构层级
    ,icmsorglevel varchar2(20) -- 信贷机构层级
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
grant select on ${iol_schema}.icms_org_info to ${iml_schema};
grant select on ${iol_schema}.icms_org_info to ${icl_schema};
grant select on ${iol_schema}.icms_org_info to ${idl_schema};
grant select on ${iol_schema}.icms_org_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_org_info is '机构信息表';
comment on column ${iol_schema}.icms_org_info.orgid is '机构编号';
comment on column ${iol_schema}.icms_org_info.orgstatus is '机构状态';
comment on column ${iol_schema}.icms_org_info.orgadd is '机构地址';
comment on column ${iol_schema}.icms_org_info.cmnum is '客户经理数';
comment on column ${iol_schema}.icms_org_info.hostno is '主机号';
comment on column ${iol_schema}.icms_org_info.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_org_info.vitualid is '虚拟柜员号';
comment on column ${iol_schema}.icms_org_info.inputuser is '登记人';
comment on column ${iol_schema}.icms_org_info.updatedate is '';
comment on column ${iol_schema}.icms_org_info.orglevel is '机构级别';
comment on column ${iol_schema}.icms_org_info.orgclass is '机构类型';
comment on column ${iol_schema}.icms_org_info.orgcode is '机构编码';
comment on column ${iol_schema}.icms_org_info.updateuser is '更新人';
comment on column ${iol_schema}.icms_org_info.orgproperty is '属性集';
comment on column ${iol_schema}.icms_org_info.relativeorgid is '上级机构编号';
comment on column ${iol_schema}.icms_org_info.orgtel is '联系电话';
comment on column ${iol_schema}.icms_org_info.businesslicense is '营业执照机构级别';
comment on column ${iol_schema}.icms_org_info.branchnum is '管辖网点数';
comment on column ${iol_schema}.icms_org_info.updatetime is '更新时间';
comment on column ${iol_schema}.icms_org_info.belongarea is '行政区划';
comment on column ${iol_schema}.icms_org_info.zipcode is '邮政编码';
comment on column ${iol_schema}.icms_org_info.principal is '负责人';
comment on column ${iol_schema}.icms_org_info.belongorgid is '权属机构';
comment on column ${iol_schema}.icms_org_info.inputorg is '登记机构';
comment on column ${iol_schema}.icms_org_info.orgoldname is '机构曾用名';
comment on column ${iol_schema}.icms_org_info.setupdate is '机构成立日期';
comment on column ${iol_schema}.icms_org_info.businesshours is '营业时间';
comment on column ${iol_schema}.icms_org_info.updateorg is '更新机构';
comment on column ${iol_schema}.icms_org_info.inputtime is '登记时间';
comment on column ${iol_schema}.icms_org_info.inputdate is '';
comment on column ${iol_schema}.icms_org_info.banklicense is '金融许可证编号';
comment on column ${iol_schema}.icms_org_info.mainframeexgid is '交换号';
comment on column ${iol_schema}.icms_org_info.ishs is '是否是记账机构,码值：YesNo';
comment on column ${iol_schema}.icms_org_info.orgname is '机构名称';
comment on column ${iol_schema}.icms_org_info.remark is '备注';
comment on column ${iol_schema}.icms_org_info.vitualserialno is '虚拟流水号';
comment on column ${iol_schema}.icms_org_info.bankid is '人行金融机构编码';
comment on column ${iol_schema}.icms_org_info.sortno is '排序号';
comment on column ${iol_schema}.icms_org_info.mainframeorgid is '网点号';
comment on column ${iol_schema}.icms_org_info.title is '职务';
comment on column ${iol_schema}.icms_org_info.fixphone is '传真';
comment on column ${iol_schema}.icms_org_info.contactpeople is '联系人';
comment on column ${iol_schema}.icms_org_info.mobiletel is '联系人手机号码';
comment on column ${iol_schema}.icms_org_info.email is '电子邮箱';
comment on column ${iol_schema}.icms_org_info.orgalias is '机构批复简称';
comment on column ${iol_schema}.icms_org_info.belongorglevel is '上级机构层级';
comment on column ${iol_schema}.icms_org_info.icmsorglevel is '信贷机构层级';
comment on column ${iol_schema}.icms_org_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_org_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_org_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_org_info.etl_timestamp is 'ETL处理时间戳';
