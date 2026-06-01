/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol hgls_gh_uus_organ
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.hgls_gh_uus_organ
whenever sqlerror continue none;
drop table ${iol_schema}.hgls_gh_uus_organ purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_gh_uus_organ(
    id number(22,0) -- 主键id
    ,organcodekey varchar2(4000) -- 统一组织机构编码
    ,organcode varchar2(4000) -- 组织机构编号
    ,zoneno varchar2(4000) -- 分行号
    ,pbocfinancialcode varchar2(4000) -- 人行金融机构编码
    ,financialcode varchar2(4000) -- 金融机构标识码
    ,swiftcode varchar2(4000) -- SWIFT编号
    ,bankcode varchar2(4000) -- 人行支付行号
    ,legal varchar2(4000) -- 法人号
    ,businesslicense varchar2(4000) -- 营业执照号码
    ,organizationcode varchar2(4000) -- 组织机构代码
    ,taxid varchar2(4000) -- 税务登记证号
    ,organcnfullname varchar2(4000) -- 机构全称
    ,organcnshortname varchar2(4000) -- 机构简称
    ,organenfullname varchar2(4000) -- 组织机构英文全称
    ,organenshortname varchar2(4000) -- 组织机构英文简称
    ,organstatecode varchar2(4000) -- 机构营业状态
    ,organstatus varchar2(4000) -- 机构状态
    ,organfoundingdate varchar2(4000) -- 机构成立日期
    ,organclosedate varchar2(4000) -- 机构撤销日期
    ,organtype varchar2(4000) -- 组织机构类型
    ,isst varchar2(4000) -- 是否为实体机构
    ,ishs varchar2(4000) -- 是否为核算机构
    ,isyy varchar2(4000) -- 是否为报表机构
    ,isxz varchar2(4000) -- 是否为行政机构
    ,iszw varchar2(4000) -- 是否为混合机构
    ,organlevel varchar2(4000) -- 机构级别
    ,leafnoteflag varchar2(4000) -- 叶节点标志
    ,xzuporgancode varchar2(4000) -- 行政上级机构编号
    ,zwuporgancode varchar2(4000) -- 混合上级机构编号
    ,hsuporgancode varchar2(4000) -- 核算上级机构编号
    ,seque varchar2(4000) -- 机构顺序号
    ,postcode varchar2(4000) -- 邮政编码
    ,country varchar2(4000) -- 所在国家
    ,province varchar2(4000) -- 所在省/州
    ,city varchar2(4000) -- 所在城市
    ,county varchar2(4000) -- 所在县/区
    ,address varchar2(4000) -- 详细地址
    ,email varchar2(4000) -- 电子邮箱
    ,url varchar2(4000) -- 网址
    ,countrycode varchar2(4000) -- 国际长途区号
    ,areacode varchar2(4000) -- 国内长途区号
    ,phone varchar2(4000) -- 电话号码
    ,subphone varchar2(4000) -- 分机号
    ,servicephone varchar2(4000) -- 服务电话
    ,funorgan varchar2(4000) -- 职能机构
    ,fundep varchar2(4000) -- 职能部门
    ,financiallicnum varchar2(4000) -- 金融许可证编号
    ,organsystem varchar2(4000) -- 机构关联系统
    ,orderno varchar2(4000) -- 显示顺序号
    ,cbrcfininsttid varchar2(4000) -- 银监会金融机构编号
    ,unionfinancialcode varchar2(4000) -- 银联金融机构编号
    ,workstarttm varchar2(4000) -- 工作开始时间
    ,workendtm varchar2(4000) -- 工作结束时间
    ,bbuporgancode varchar2(4000) -- 报表上级机构编号
    ,heademplyid varchar2(4000) -- 负责人工号
    ,isxnhs varchar2(4000) -- 是否为虚拟核算机构
    ,rhregcode varchar2(4000) -- 人行地区码
    ,blngcitypbc varchar2(4000) -- 所属城市(人行)
    ,bankcodeperson varchar2(4000) -- 支付系统银行行号（用于个人结算账户报送）
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
grant select on ${iol_schema}.hgls_gh_uus_organ to ${iml_schema};
grant select on ${iol_schema}.hgls_gh_uus_organ to ${icl_schema};
grant select on ${iol_schema}.hgls_gh_uus_organ to ${idl_schema};
grant select on ${iol_schema}.hgls_gh_uus_organ to ${iel_schema};

-- comment
comment on table ${iol_schema}.hgls_gh_uus_organ is '统一用户系统机构表';
comment on column ${iol_schema}.hgls_gh_uus_organ.id is '主键id';
comment on column ${iol_schema}.hgls_gh_uus_organ.organcodekey is '统一组织机构编码';
comment on column ${iol_schema}.hgls_gh_uus_organ.organcode is '组织机构编号';
comment on column ${iol_schema}.hgls_gh_uus_organ.zoneno is '分行号';
comment on column ${iol_schema}.hgls_gh_uus_organ.pbocfinancialcode is '人行金融机构编码';
comment on column ${iol_schema}.hgls_gh_uus_organ.financialcode is '金融机构标识码';
comment on column ${iol_schema}.hgls_gh_uus_organ.swiftcode is 'SWIFT编号';
comment on column ${iol_schema}.hgls_gh_uus_organ.bankcode is '人行支付行号';
comment on column ${iol_schema}.hgls_gh_uus_organ.legal is '法人号';
comment on column ${iol_schema}.hgls_gh_uus_organ.businesslicense is '营业执照号码';
comment on column ${iol_schema}.hgls_gh_uus_organ.organizationcode is '组织机构代码';
comment on column ${iol_schema}.hgls_gh_uus_organ.taxid is '税务登记证号';
comment on column ${iol_schema}.hgls_gh_uus_organ.organcnfullname is '机构全称';
comment on column ${iol_schema}.hgls_gh_uus_organ.organcnshortname is '机构简称';
comment on column ${iol_schema}.hgls_gh_uus_organ.organenfullname is '组织机构英文全称';
comment on column ${iol_schema}.hgls_gh_uus_organ.organenshortname is '组织机构英文简称';
comment on column ${iol_schema}.hgls_gh_uus_organ.organstatecode is '机构营业状态';
comment on column ${iol_schema}.hgls_gh_uus_organ.organstatus is '机构状态';
comment on column ${iol_schema}.hgls_gh_uus_organ.organfoundingdate is '机构成立日期';
comment on column ${iol_schema}.hgls_gh_uus_organ.organclosedate is '机构撤销日期';
comment on column ${iol_schema}.hgls_gh_uus_organ.organtype is '组织机构类型';
comment on column ${iol_schema}.hgls_gh_uus_organ.isst is '是否为实体机构';
comment on column ${iol_schema}.hgls_gh_uus_organ.ishs is '是否为核算机构';
comment on column ${iol_schema}.hgls_gh_uus_organ.isyy is '是否为报表机构';
comment on column ${iol_schema}.hgls_gh_uus_organ.isxz is '是否为行政机构';
comment on column ${iol_schema}.hgls_gh_uus_organ.iszw is '是否为混合机构';
comment on column ${iol_schema}.hgls_gh_uus_organ.organlevel is '机构级别';
comment on column ${iol_schema}.hgls_gh_uus_organ.leafnoteflag is '叶节点标志';
comment on column ${iol_schema}.hgls_gh_uus_organ.xzuporgancode is '行政上级机构编号';
comment on column ${iol_schema}.hgls_gh_uus_organ.zwuporgancode is '混合上级机构编号';
comment on column ${iol_schema}.hgls_gh_uus_organ.hsuporgancode is '核算上级机构编号';
comment on column ${iol_schema}.hgls_gh_uus_organ.seque is '机构顺序号';
comment on column ${iol_schema}.hgls_gh_uus_organ.postcode is '邮政编码';
comment on column ${iol_schema}.hgls_gh_uus_organ.country is '所在国家';
comment on column ${iol_schema}.hgls_gh_uus_organ.province is '所在省/州';
comment on column ${iol_schema}.hgls_gh_uus_organ.city is '所在城市';
comment on column ${iol_schema}.hgls_gh_uus_organ.county is '所在县/区';
comment on column ${iol_schema}.hgls_gh_uus_organ.address is '详细地址';
comment on column ${iol_schema}.hgls_gh_uus_organ.email is '电子邮箱';
comment on column ${iol_schema}.hgls_gh_uus_organ.url is '网址';
comment on column ${iol_schema}.hgls_gh_uus_organ.countrycode is '国际长途区号';
comment on column ${iol_schema}.hgls_gh_uus_organ.areacode is '国内长途区号';
comment on column ${iol_schema}.hgls_gh_uus_organ.phone is '电话号码';
comment on column ${iol_schema}.hgls_gh_uus_organ.subphone is '分机号';
comment on column ${iol_schema}.hgls_gh_uus_organ.servicephone is '服务电话';
comment on column ${iol_schema}.hgls_gh_uus_organ.funorgan is '职能机构';
comment on column ${iol_schema}.hgls_gh_uus_organ.fundep is '职能部门';
comment on column ${iol_schema}.hgls_gh_uus_organ.financiallicnum is '金融许可证编号';
comment on column ${iol_schema}.hgls_gh_uus_organ.organsystem is '机构关联系统';
comment on column ${iol_schema}.hgls_gh_uus_organ.orderno is '显示顺序号';
comment on column ${iol_schema}.hgls_gh_uus_organ.cbrcfininsttid is '银监会金融机构编号';
comment on column ${iol_schema}.hgls_gh_uus_organ.unionfinancialcode is '银联金融机构编号';
comment on column ${iol_schema}.hgls_gh_uus_organ.workstarttm is '工作开始时间';
comment on column ${iol_schema}.hgls_gh_uus_organ.workendtm is '工作结束时间';
comment on column ${iol_schema}.hgls_gh_uus_organ.bbuporgancode is '报表上级机构编号';
comment on column ${iol_schema}.hgls_gh_uus_organ.heademplyid is '负责人工号';
comment on column ${iol_schema}.hgls_gh_uus_organ.isxnhs is '是否为虚拟核算机构';
comment on column ${iol_schema}.hgls_gh_uus_organ.rhregcode is '人行地区码';
comment on column ${iol_schema}.hgls_gh_uus_organ.blngcitypbc is '所属城市(人行)';
comment on column ${iol_schema}.hgls_gh_uus_organ.bankcodeperson is '支付系统银行行号（用于个人结算账户报送）';
comment on column ${iol_schema}.hgls_gh_uus_organ.start_dt is '开始时间';
comment on column ${iol_schema}.hgls_gh_uus_organ.end_dt is '结束时间';
comment on column ${iol_schema}.hgls_gh_uus_organ.id_mark is '增删标志';
comment on column ${iol_schema}.hgls_gh_uus_organ.etl_timestamp is 'ETL处理时间戳';
