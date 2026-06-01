/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uuss_uus_organ
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uuss_uus_organ
whenever sqlerror continue none;
drop table ${iol_schema}.uuss_uus_organ purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uuss_uus_organ(
    organcodekey varchar2(18) -- 统一组织机构编码
    ,organcode varchar2(18) -- 组织机构编号
    ,zoneno varchar2(5) -- 分行号
    ,pbocfinancialcode varchar2(90) -- 人民银行金融机构编号
    ,financialcode varchar2(18) -- 金融机构标识码
    ,swiftcode varchar2(45) -- SWIFT号码
    ,bankcode varchar2(18) -- 支付系统银行行号
    ,legal varchar2(6) -- 法人号
    ,businesslicense varchar2(27) -- 营业执照号码
    ,organizationcode varchar2(14) -- 组织机构代码
    ,taxid varchar2(23) -- 税务登记证号
    ,organcnfullname varchar2(300) -- 组织机构名称
    ,organcnshortname varchar2(150) -- 组织机构简称
    ,organenfullname varchar2(150) -- 组织机构英文全称
    ,organenshortname varchar2(150) -- 组织机构英文简称
    ,organstatecode varchar2(2) -- 机构营业状态
    ,organstatus varchar2(2) -- 机构状态
    ,organfoundingdate varchar2(12) -- 机构成立日期
    ,organclosedate varchar2(12) -- 机构关闭日期
    ,organtype varchar2(3) -- 组织机构类型
    ,isst varchar2(2) -- 是否为实体机构
    ,ishs varchar2(2) -- 是否为核算机构
    ,isyy varchar2(2) -- 是否为营业机构
    ,isxz varchar2(2) -- 是否为行政机构
    ,iszw varchar2(2) -- 是否为账务机构
    ,organlevel varchar2(3) -- 组织机构级别代码
    ,leafnoteflag varchar2(2) -- 叶节点标志
    ,xzuporgancode varchar2(18) -- 行政上级组织机构编码
    ,zwuporgancode varchar2(18) -- 账务上级组织机构编码
    ,hsuporgancode varchar2(18) -- 核算上级组织机构编码
    ,seque varchar2(5) -- 机构顺序号
    ,postcode varchar2(9) -- 邮政编码
    ,country varchar2(5) -- 所在国家
    ,province varchar2(9) -- 所在省/州
    ,city varchar2(9) -- 所在城市
    ,county varchar2(9) -- 所在县/区
    ,address varchar2(600) -- 详细地址
    ,email varchar2(75) -- 电子邮箱
    ,url varchar2(75) -- 网址
    ,countrycode varchar2(6) -- 国际长途区号
    ,areacode varchar2(6) -- 国内长途区号
    ,phone varchar2(45) -- 电话号码
    ,subphone varchar2(9) -- 分机号
    ,servicephone varchar2(45) -- 服务电话
    ,funorgan varchar2(18) -- 职能机构
    ,fundep varchar2(18) -- 职能部门
    ,orderno varchar2(18) -- 显示顺序号
    ,financiallicnum varchar2(45) -- 金融许可证号码
    ,organsystem varchar2(383) -- 机构关联系统
    ,cbrcfininsttid varchar2(90) -- 银监会金融机构编号
    ,unionfinancialcode varchar2(21) -- 银联金融机构编号
    ,workstarttm varchar2(9) -- 工作开始时间
    ,workendtm varchar2(9) -- 工作结束时间
    ,updatedate varchar2(12) -- 更新日期
    ,heademplyid varchar2(12) -- 负责人员工编号
    ,isxnhs varchar2(2) -- 是否为虚拟核算机构
    ,rhregcode varchar2(15) -- 人行地区码
    ,blng_city_pbc varchar2(300) -- 所属城市(人行)
    ,bankcodeperson varchar2(18) -- 支付系统银行行号（用于个人结算账户报送）
    ,note1 varchar2(300) -- 备用1
    ,note2 varchar2(300) -- 备用2
    ,note3 varchar2(300) -- 备用3
    ,note4 varchar2(150) -- 备用4
    ,note5 varchar2(150) -- 备用5
    ,note6 varchar2(150) -- 备用6
    ,note7 varchar2(150) -- 备用7
    ,note8 varchar2(75) -- 备用8
    ,note9 varchar2(75) -- 备用9
    ,note10 varchar2(75) -- 备用10
    ,bbuporgancode varchar2(18) -- 报表上级机构编号
    ,countyflag varchar2(3) -- 县域机构标识
    ,technologyflag varchar2(3) -- 科技支行标识
    ,specialflag varchar2(3) -- 科技特色支行标识
    ,financeflag varchar2(3) -- 科技金融专营机构标识
    ,freetradeflag varchar2(3) -- 自贸区网点标识
    ,busitimedesc varchar2(4000) -- 网点营业时间说明
    ,busiscopdesc varchar2(4000) -- 主要业务范围说明
    ,physicsflag varchar2(3) -- 零售管户机构|1是 0否
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
grant select on ${iol_schema}.uuss_uus_organ to ${iml_schema};
grant select on ${iol_schema}.uuss_uus_organ to ${icl_schema};
grant select on ${iol_schema}.uuss_uus_organ to ${idl_schema};
grant select on ${iol_schema}.uuss_uus_organ to ${iel_schema};

-- comment
comment on table ${iol_schema}.uuss_uus_organ is '机构信息表';
comment on column ${iol_schema}.uuss_uus_organ.organcodekey is '统一组织机构编码';
comment on column ${iol_schema}.uuss_uus_organ.organcode is '组织机构编号';
comment on column ${iol_schema}.uuss_uus_organ.zoneno is '分行号';
comment on column ${iol_schema}.uuss_uus_organ.pbocfinancialcode is '人民银行金融机构编号';
comment on column ${iol_schema}.uuss_uus_organ.financialcode is '金融机构标识码';
comment on column ${iol_schema}.uuss_uus_organ.swiftcode is 'SWIFT号码';
comment on column ${iol_schema}.uuss_uus_organ.bankcode is '支付系统银行行号';
comment on column ${iol_schema}.uuss_uus_organ.legal is '法人号';
comment on column ${iol_schema}.uuss_uus_organ.businesslicense is '营业执照号码';
comment on column ${iol_schema}.uuss_uus_organ.organizationcode is '组织机构代码';
comment on column ${iol_schema}.uuss_uus_organ.taxid is '税务登记证号';
comment on column ${iol_schema}.uuss_uus_organ.organcnfullname is '组织机构名称';
comment on column ${iol_schema}.uuss_uus_organ.organcnshortname is '组织机构简称';
comment on column ${iol_schema}.uuss_uus_organ.organenfullname is '组织机构英文全称';
comment on column ${iol_schema}.uuss_uus_organ.organenshortname is '组织机构英文简称';
comment on column ${iol_schema}.uuss_uus_organ.organstatecode is '机构营业状态';
comment on column ${iol_schema}.uuss_uus_organ.organstatus is '机构状态';
comment on column ${iol_schema}.uuss_uus_organ.organfoundingdate is '机构成立日期';
comment on column ${iol_schema}.uuss_uus_organ.organclosedate is '机构关闭日期';
comment on column ${iol_schema}.uuss_uus_organ.organtype is '组织机构类型';
comment on column ${iol_schema}.uuss_uus_organ.isst is '是否为实体机构';
comment on column ${iol_schema}.uuss_uus_organ.ishs is '是否为核算机构';
comment on column ${iol_schema}.uuss_uus_organ.isyy is '是否为营业机构';
comment on column ${iol_schema}.uuss_uus_organ.isxz is '是否为行政机构';
comment on column ${iol_schema}.uuss_uus_organ.iszw is '是否为账务机构';
comment on column ${iol_schema}.uuss_uus_organ.organlevel is '组织机构级别代码';
comment on column ${iol_schema}.uuss_uus_organ.leafnoteflag is '叶节点标志';
comment on column ${iol_schema}.uuss_uus_organ.xzuporgancode is '行政上级组织机构编码';
comment on column ${iol_schema}.uuss_uus_organ.zwuporgancode is '账务上级组织机构编码';
comment on column ${iol_schema}.uuss_uus_organ.hsuporgancode is '核算上级组织机构编码';
comment on column ${iol_schema}.uuss_uus_organ.seque is '机构顺序号';
comment on column ${iol_schema}.uuss_uus_organ.postcode is '邮政编码';
comment on column ${iol_schema}.uuss_uus_organ.country is '所在国家';
comment on column ${iol_schema}.uuss_uus_organ.province is '所在省/州';
comment on column ${iol_schema}.uuss_uus_organ.city is '所在城市';
comment on column ${iol_schema}.uuss_uus_organ.county is '所在县/区';
comment on column ${iol_schema}.uuss_uus_organ.address is '详细地址';
comment on column ${iol_schema}.uuss_uus_organ.email is '电子邮箱';
comment on column ${iol_schema}.uuss_uus_organ.url is '网址';
comment on column ${iol_schema}.uuss_uus_organ.countrycode is '国际长途区号';
comment on column ${iol_schema}.uuss_uus_organ.areacode is '国内长途区号';
comment on column ${iol_schema}.uuss_uus_organ.phone is '电话号码';
comment on column ${iol_schema}.uuss_uus_organ.subphone is '分机号';
comment on column ${iol_schema}.uuss_uus_organ.servicephone is '服务电话';
comment on column ${iol_schema}.uuss_uus_organ.funorgan is '职能机构';
comment on column ${iol_schema}.uuss_uus_organ.fundep is '职能部门';
comment on column ${iol_schema}.uuss_uus_organ.orderno is '显示顺序号';
comment on column ${iol_schema}.uuss_uus_organ.financiallicnum is '金融许可证号码';
comment on column ${iol_schema}.uuss_uus_organ.organsystem is '机构关联系统';
comment on column ${iol_schema}.uuss_uus_organ.cbrcfininsttid is '银监会金融机构编号';
comment on column ${iol_schema}.uuss_uus_organ.unionfinancialcode is '银联金融机构编号';
comment on column ${iol_schema}.uuss_uus_organ.workstarttm is '工作开始时间';
comment on column ${iol_schema}.uuss_uus_organ.workendtm is '工作结束时间';
comment on column ${iol_schema}.uuss_uus_organ.updatedate is '更新日期';
comment on column ${iol_schema}.uuss_uus_organ.heademplyid is '负责人员工编号';
comment on column ${iol_schema}.uuss_uus_organ.isxnhs is '是否为虚拟核算机构';
comment on column ${iol_schema}.uuss_uus_organ.rhregcode is '人行地区码';
comment on column ${iol_schema}.uuss_uus_organ.blng_city_pbc is '所属城市(人行)';
comment on column ${iol_schema}.uuss_uus_organ.bankcodeperson is '支付系统银行行号（用于个人结算账户报送）';
comment on column ${iol_schema}.uuss_uus_organ.note1 is '备用1';
comment on column ${iol_schema}.uuss_uus_organ.note2 is '备用2';
comment on column ${iol_schema}.uuss_uus_organ.note3 is '备用3';
comment on column ${iol_schema}.uuss_uus_organ.note4 is '备用4';
comment on column ${iol_schema}.uuss_uus_organ.note5 is '备用5';
comment on column ${iol_schema}.uuss_uus_organ.note6 is '备用6';
comment on column ${iol_schema}.uuss_uus_organ.note7 is '备用7';
comment on column ${iol_schema}.uuss_uus_organ.note8 is '备用8';
comment on column ${iol_schema}.uuss_uus_organ.note9 is '备用9';
comment on column ${iol_schema}.uuss_uus_organ.note10 is '备用10';
comment on column ${iol_schema}.uuss_uus_organ.bbuporgancode is '报表上级机构编号';
comment on column ${iol_schema}.uuss_uus_organ.countyflag is '县域机构标识';
comment on column ${iol_schema}.uuss_uus_organ.technologyflag is '科技支行标识';
comment on column ${iol_schema}.uuss_uus_organ.specialflag is '科技特色支行标识';
comment on column ${iol_schema}.uuss_uus_organ.financeflag is '科技金融专营机构标识';
comment on column ${iol_schema}.uuss_uus_organ.freetradeflag is '自贸区网点标识';
comment on column ${iol_schema}.uuss_uus_organ.busitimedesc is '网点营业时间说明';
comment on column ${iol_schema}.uuss_uus_organ.busiscopdesc is '主要业务范围说明';
comment on column ${iol_schema}.uuss_uus_organ.physicsflag is '零售管户机构|1是 0否';
comment on column ${iol_schema}.uuss_uus_organ.start_dt is '开始时间';
comment on column ${iol_schema}.uuss_uus_organ.end_dt is '结束时间';
comment on column ${iol_schema}.uuss_uus_organ.id_mark is '增删标志';
comment on column ${iol_schema}.uuss_uus_organ.etl_timestamp is 'ETL处理时间戳';
