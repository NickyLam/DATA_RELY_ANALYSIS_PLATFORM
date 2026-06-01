/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fbms_bsc_uusbranch_infos
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fbms_bsc_uusbranch_infos
whenever sqlerror continue none;
drop table ${iol_schema}.fbms_bsc_uusbranch_infos purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fbms_bsc_uusbranch_infos(
    branchcode varchar2(300) -- 机构唯一标识
    ,branchnum varchar2(768) -- 内部机构编号--含总、分、支行编号和部门、团队编号,总行、分行 3位数字,其它机构是6位数字的机构编码，按照核心系统编码为准，核心不存在机构则使用8位代码，3位总分行编码+5位顺序号
    ,zoneno varchar2(384) -- 分行号码--全行所属分行号默认填000
    ,pbocfinancialcode varchar2(300) -- 人民银行金融机构编号--指人民银行颁布的，用于识别、界定各类金融机构具体组成的唯一标识
    ,financialcode varchar2(300) -- 金融机构标识码--指由国家外汇管理局统一制定，唯一标识金融机构总行（总公司）及其分支机构的代码，每个总行或分支机构均拥有一个唯一的12位金融机构标识码
    ,swiftcode varchar2(765) -- swift号码--描述环球同业银行金融电讯协会（swift）为其会员银行同业提供的标准编号，广泛应用于信用证业务以及跨国的结算支付
    ,bankcode varchar2(765) -- 支付系统银行行号--指在人民银行现代化支付系统中唯一标识一个银行机构。用于人民银行所组织的大额支付系统\小额支付系统\城市商业银行银行汇票系统\全国支票影像系统（含一些城市的同城票据自动清分系统）等跨区域支付结算业务
    ,legalpersonnum varchar2(765) -- 法人顺序号--机构所属的法人编号，华兴银行为0001
    ,businesslicense varchar2(765) -- 营业执照号码--描述工商行政管理机关发给我行机构进行金融服务活动的凭证
    ,organizationcode varchar2(765) -- 内部机构代码--描述对于中华人民共和国内依法注册、依法登记的机关、企、事业单位、社会团体和民办非企业单位颁发的一个在全国范围内唯一的、始终不变的代码标识编号信息
    ,taxid varchar2(765) -- 税务登记证号--描述机构法人代表/负责人在申报办理税务登记时税务机关颁发的登记凭证编号信息
    ,branchname varchar2(765) -- 内部机构名称--监管部门或有权审批机构批准的机构名称
    ,organcnshortname varchar2(765) -- 内部机构简称--按照一定规则对机构的全称进行适当缩略后形成的机构简称
    ,organenfullname varchar2(765) -- 内部机构英文全称--描述按照命名规范统一制定的机构英文全称
    ,organenshortname varchar2(765) -- 内部机构英文简称--描述按照命名规范统一制定的机构英文简称
    ,organstatecode varchar2(765) -- 机构营业状态代码--指机构经营活动所处的状态。1:待营业,2:正常营业,3:暂停营业:4:终止营业
    ,branchstatu varchar2(765) -- 机构状态代码--指机构的使用状态。1：未启用，2：已启用，3：锁定中，4：已注销
    ,organfoundingdate varchar2(765) -- 机构成立日期--指机构成立日期，在营业场所内对外开展服务日期（服务涵盖业务咨询、业务交易办理等服务）
    ,organclosedate varchar2(765) -- 机构关闭日期--指机构关闭营业，在营业场所内不再对外开展服务日期（服务涵盖业务咨询、业务交易办理等服务
    ,organtype varchar2(765) -- 内部机构类型代码--依据我行机构管理模式对机构分类的具体划分。包括：全行00，总行10，分行11，支行12，部门23，团队31等
    ,isst varchar2(765) -- 实体机构标志--通过正式批文建立的组织单元，包含总行、分行、支行、实际部门等。0表示否，1表示是
    ,ishs varchar2(765) -- 核算机构标志--指可以作为账务、成本等财务指标的核算单元，此类型的机构与总账系统系统保持一致。0表示否，1表示是
    ,isyy varchar2(765) -- 营业机构标志--指经过人民银行和金融监管机构批准设立的对外提供银行业务的机构。0表示否，1表示是
    ,isxz varchar2(765) -- 行政机构标志--为行政管理需要而设立的机构，办公类系统使用此类。0表示否，1表示是
    ,iszw varchar2(765) -- 账务机构标志--指能够进行账务处理的机构，此类型机构与会计引擎保持一致。0表示否，1表示对内对外、2只对内、3只对外
    ,branchlevel varchar2(765) -- 内部机构级别代码--指按照我行管理要求，机构所对应的管理层级。比如总行、分行、支行等1-集团2-公司3-总行4-分行5-支行6-网点7-总行工作室8-分行工作室
    ,leafnoteflag varchar2(765) -- 叶节点标志--指用于判断此机构是否为机构树最底层的分类节点
    ,supebranchnum varchar2(765) -- 行政上级内部机构编码--机构行政上级机构的机构编码。行政类型机构树与营业机构树均使用此字段构建
    ,zwuporgancode varchar2(765) -- 账务上级内部机构编码--机构账务上级机构的机构编码
    ,hsuporgancode varchar2(765) -- 核算上级内部机构编码--机构核算上级机构的机构编码
    ,seque varchar2(765) -- 机构顺序号--指机构在其行政上级机构下的显示顺序
    ,postcode varchar2(765) -- 邮政编码--描述机构所在地址的邮政编码信息
    ,country varchar2(765) -- 所在国家--描述机构的物理地址所在国家信息。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
    ,province varchar2(765) -- 所在省/州--描述机构的物理地址所在行政区划的的“省/自治区/直辖市/特别行政区”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
    ,city varchar2(765) -- 所在城市--描述机构的指物理地址中所在行政区划的的“市/地区/自治州/盟/直辖市所辖市辖区（县）”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
    ,county varchar2(765) -- 所在县/区--描述机构的物理地址中所在行政区划的“县/自治县/县级市/旗/自治旗/市辖区/林区/特区”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
    ,address varchar2(765) -- 详细地址--描述机构的物理地址中除国家地区、行政区划（省、市、县）之外的地址信息，包括街道（乡、镇）、门牌号（村、组）等信息。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
    ,email varchar2(765) -- 电子邮箱--描述机构的电子地址具体信息
    ,url varchar2(765) -- 网址--描述机构的电子地址具体信息
    ,countrycode varchar2(765) -- 国际长途区号--描述机构使用的电话号码所在国际地区的区号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
    ,areacode varchar2(765) -- 国内长途区号--描述机构使用的电话号码所在国内地区的区号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
    ,phone varchar2(765) -- 电话号码--描述机构使用的除国际长途区号、国内长途区号和分机号之外的电话号码。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
    ,subphone varchar2(765) -- 分机号--描述机构使用的电话分机号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
    ,servicephone varchar2(765) -- 服务电话--描述机构的电话地址类型信息，如办公电话、服务电话等
    ,funorgan varchar2(765) -- 
    ,fundep varchar2(765) -- 
    ,financiallicnum varchar2(765) -- 金融许可证号码--金融许可证号码是金融许可证上的机构编码，共15位。金融许可证是指银监会依法颁发的特许金融机构经营金融业务的法律文件
    ,organsystem varchar2(765) -- 机构关联系统--01:深圳同城02:广东省金融服务平台03:二代支付04:网银互联，多个系统用"|"分隔
    ,orderno varchar2(765) -- 显示顺序号--序号
    ,cbrcfininsttid varchar2(765) -- 银监会金融机构编号--银监会金融机构编号
    ,unionfinancialcode varchar2(765) -- 银联金融机构编号--银联金融机构编号
    ,workstarttm varchar2(765) -- 工作开始时间
    ,workendtm varchar2(765) -- 工作结束时间
    ,legalpersonname varchar2(765) -- 法人姓名
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
grant select on ${iol_schema}.fbms_bsc_uusbranch_infos to ${iml_schema};
grant select on ${iol_schema}.fbms_bsc_uusbranch_infos to ${icl_schema};
grant select on ${iol_schema}.fbms_bsc_uusbranch_infos to ${idl_schema};
grant select on ${iol_schema}.fbms_bsc_uusbranch_infos to ${iel_schema};

-- comment
comment on table ${iol_schema}.fbms_bsc_uusbranch_infos is '机构信息表--统一用户系统';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.branchcode is '机构唯一标识';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.branchnum is '内部机构编号--含总、分、支行编号和部门、团队编号,总行、分行 3位数字,其它机构是6位数字的机构编码，按照核心系统编码为准，核心不存在机构则使用8位代码，3位总分行编码+5位顺序号';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.zoneno is '分行号码--全行所属分行号默认填000';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.pbocfinancialcode is '人民银行金融机构编号--指人民银行颁布的，用于识别、界定各类金融机构具体组成的唯一标识';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.financialcode is '金融机构标识码--指由国家外汇管理局统一制定，唯一标识金融机构总行（总公司）及其分支机构的代码，每个总行或分支机构均拥有一个唯一的12位金融机构标识码';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.swiftcode is 'swift号码--描述环球同业银行金融电讯协会（swift）为其会员银行同业提供的标准编号，广泛应用于信用证业务以及跨国的结算支付';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.bankcode is '支付系统银行行号--指在人民银行现代化支付系统中唯一标识一个银行机构。用于人民银行所组织的大额支付系统\小额支付系统\城市商业银行银行汇票系统\全国支票影像系统（含一些城市的同城票据自动清分系统）等跨区域支付结算业务';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.legalpersonnum is '法人顺序号--机构所属的法人编号，华兴银行为0001';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.businesslicense is '营业执照号码--描述工商行政管理机关发给我行机构进行金融服务活动的凭证';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.organizationcode is '内部机构代码--描述对于中华人民共和国内依法注册、依法登记的机关、企、事业单位、社会团体和民办非企业单位颁发的一个在全国范围内唯一的、始终不变的代码标识编号信息';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.taxid is '税务登记证号--描述机构法人代表/负责人在申报办理税务登记时税务机关颁发的登记凭证编号信息';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.branchname is '内部机构名称--监管部门或有权审批机构批准的机构名称';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.organcnshortname is '内部机构简称--按照一定规则对机构的全称进行适当缩略后形成的机构简称';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.organenfullname is '内部机构英文全称--描述按照命名规范统一制定的机构英文全称';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.organenshortname is '内部机构英文简称--描述按照命名规范统一制定的机构英文简称';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.organstatecode is '机构营业状态代码--指机构经营活动所处的状态。1:待营业,2:正常营业,3:暂停营业:4:终止营业';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.branchstatu is '机构状态代码--指机构的使用状态。1：未启用，2：已启用，3：锁定中，4：已注销';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.organfoundingdate is '机构成立日期--指机构成立日期，在营业场所内对外开展服务日期（服务涵盖业务咨询、业务交易办理等服务）';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.organclosedate is '机构关闭日期--指机构关闭营业，在营业场所内不再对外开展服务日期（服务涵盖业务咨询、业务交易办理等服务';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.organtype is '内部机构类型代码--依据我行机构管理模式对机构分类的具体划分。包括：全行00，总行10，分行11，支行12，部门23，团队31等';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.isst is '实体机构标志--通过正式批文建立的组织单元，包含总行、分行、支行、实际部门等。0表示否，1表示是';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.ishs is '核算机构标志--指可以作为账务、成本等财务指标的核算单元，此类型的机构与总账系统系统保持一致。0表示否，1表示是';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.isyy is '营业机构标志--指经过人民银行和金融监管机构批准设立的对外提供银行业务的机构。0表示否，1表示是';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.isxz is '行政机构标志--为行政管理需要而设立的机构，办公类系统使用此类。0表示否，1表示是';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.iszw is '账务机构标志--指能够进行账务处理的机构，此类型机构与会计引擎保持一致。0表示否，1表示对内对外、2只对内、3只对外';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.branchlevel is '内部机构级别代码--指按照我行管理要求，机构所对应的管理层级。比如总行、分行、支行等1-集团2-公司3-总行4-分行5-支行6-网点7-总行工作室8-分行工作室';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.leafnoteflag is '叶节点标志--指用于判断此机构是否为机构树最底层的分类节点';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.supebranchnum is '行政上级内部机构编码--机构行政上级机构的机构编码。行政类型机构树与营业机构树均使用此字段构建';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.zwuporgancode is '账务上级内部机构编码--机构账务上级机构的机构编码';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.hsuporgancode is '核算上级内部机构编码--机构核算上级机构的机构编码';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.seque is '机构顺序号--指机构在其行政上级机构下的显示顺序';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.postcode is '邮政编码--描述机构所在地址的邮政编码信息';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.country is '所在国家--描述机构的物理地址所在国家信息。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.province is '所在省/州--描述机构的物理地址所在行政区划的的“省/自治区/直辖市/特别行政区”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.city is '所在城市--描述机构的指物理地址中所在行政区划的的“市/地区/自治州/盟/直辖市所辖市辖区（县）”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.county is '所在县/区--描述机构的物理地址中所在行政区划的“县/自治县/县级市/旗/自治旗/市辖区/林区/特区”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.address is '详细地址--描述机构的物理地址中除国家地区、行政区划（省、市、县）之外的地址信息，包括街道（乡、镇）、门牌号（村、组）等信息。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.email is '电子邮箱--描述机构的电子地址具体信息';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.url is '网址--描述机构的电子地址具体信息';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.countrycode is '国际长途区号--描述机构使用的电话号码所在国际地区的区号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.areacode is '国内长途区号--描述机构使用的电话号码所在国内地区的区号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.phone is '电话号码--描述机构使用的除国际长途区号、国内长途区号和分机号之外的电话号码。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.subphone is '分机号--描述机构使用的电话分机号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.servicephone is '服务电话--描述机构的电话地址类型信息，如办公电话、服务电话等';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.funorgan is '';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.fundep is '';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.financiallicnum is '金融许可证号码--金融许可证号码是金融许可证上的机构编码，共15位。金融许可证是指银监会依法颁发的特许金融机构经营金融业务的法律文件';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.organsystem is '机构关联系统--01:深圳同城02:广东省金融服务平台03:二代支付04:网银互联，多个系统用"|"分隔';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.orderno is '显示顺序号--序号';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.cbrcfininsttid is '银监会金融机构编号--银监会金融机构编号';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.unionfinancialcode is '银联金融机构编号--银联金融机构编号';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.workstarttm is '工作开始时间';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.workendtm is '工作结束时间';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.legalpersonname is '法人姓名';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.start_dt is '开始时间';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.end_dt is '结束时间';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.id_mark is '增删标志';
comment on column ${iol_schema}.fbms_bsc_uusbranch_infos.etl_timestamp is 'ETL处理时间戳';
