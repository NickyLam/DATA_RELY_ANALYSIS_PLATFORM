/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fbms_bsc_uusbranch_infos
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
create table ${iol_schema}.fbms_bsc_uusbranch_infos_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fbms_bsc_uusbranch_infos
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fbms_bsc_uusbranch_infos_op purge;
drop table ${iol_schema}.fbms_bsc_uusbranch_infos_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fbms_bsc_uusbranch_infos_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fbms_bsc_uusbranch_infos where 0=1;

create table ${iol_schema}.fbms_bsc_uusbranch_infos_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fbms_bsc_uusbranch_infos where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fbms_bsc_uusbranch_infos_cl(
            branchcode -- 机构唯一标识
            ,branchnum -- 内部机构编号--含总、分、支行编号和部门、团队编号,总行、分行 3位数字,其它机构是6位数字的机构编码，按照核心系统编码为准，核心不存在机构则使用8位代码，3位总分行编码+5位顺序号
            ,zoneno -- 分行号码--全行所属分行号默认填000
            ,pbocfinancialcode -- 人民银行金融机构编号--指人民银行颁布的，用于识别、界定各类金融机构具体组成的唯一标识
            ,financialcode -- 金融机构标识码--指由国家外汇管理局统一制定，唯一标识金融机构总行（总公司）及其分支机构的代码，每个总行或分支机构均拥有一个唯一的12位金融机构标识码
            ,swiftcode -- swift号码--描述环球同业银行金融电讯协会（swift）为其会员银行同业提供的标准编号，广泛应用于信用证业务以及跨国的结算支付
            ,bankcode -- 支付系统银行行号--指在人民银行现代化支付系统中唯一标识一个银行机构。用于人民银行所组织的大额支付系统\小额支付系统\城市商业银行银行汇票系统\全国支票影像系统（含一些城市的同城票据自动清分系统）等跨区域支付结算业务
            ,legalpersonnum -- 法人顺序号--机构所属的法人编号，华兴银行为0001
            ,businesslicense -- 营业执照号码--描述工商行政管理机关发给我行机构进行金融服务活动的凭证
            ,organizationcode -- 内部机构代码--描述对于中华人民共和国内依法注册、依法登记的机关、企、事业单位、社会团体和民办非企业单位颁发的一个在全国范围内唯一的、始终不变的代码标识编号信息
            ,taxid -- 税务登记证号--描述机构法人代表/负责人在申报办理税务登记时税务机关颁发的登记凭证编号信息
            ,branchname -- 内部机构名称--监管部门或有权审批机构批准的机构名称
            ,organcnshortname -- 内部机构简称--按照一定规则对机构的全称进行适当缩略后形成的机构简称
            ,organenfullname -- 内部机构英文全称--描述按照命名规范统一制定的机构英文全称
            ,organenshortname -- 内部机构英文简称--描述按照命名规范统一制定的机构英文简称
            ,organstatecode -- 机构营业状态代码--指机构经营活动所处的状态。1:待营业,2:正常营业,3:暂停营业:4:终止营业
            ,branchstatu -- 机构状态代码--指机构的使用状态。1：未启用，2：已启用，3：锁定中，4：已注销
            ,organfoundingdate -- 机构成立日期--指机构成立日期，在营业场所内对外开展服务日期（服务涵盖业务咨询、业务交易办理等服务）
            ,organclosedate -- 机构关闭日期--指机构关闭营业，在营业场所内不再对外开展服务日期（服务涵盖业务咨询、业务交易办理等服务
            ,organtype -- 内部机构类型代码--依据我行机构管理模式对机构分类的具体划分。包括：全行00，总行10，分行11，支行12，部门23，团队31等
            ,isst -- 实体机构标志--通过正式批文建立的组织单元，包含总行、分行、支行、实际部门等。0表示否，1表示是
            ,ishs -- 核算机构标志--指可以作为账务、成本等财务指标的核算单元，此类型的机构与总账系统系统保持一致。0表示否，1表示是
            ,isyy -- 营业机构标志--指经过人民银行和金融监管机构批准设立的对外提供银行业务的机构。0表示否，1表示是
            ,isxz -- 行政机构标志--为行政管理需要而设立的机构，办公类系统使用此类。0表示否，1表示是
            ,iszw -- 账务机构标志--指能够进行账务处理的机构，此类型机构与会计引擎保持一致。0表示否，1表示对内对外、2只对内、3只对外
            ,branchlevel -- 内部机构级别代码--指按照我行管理要求，机构所对应的管理层级。比如总行、分行、支行等1-集团2-公司3-总行4-分行5-支行6-网点7-总行工作室8-分行工作室
            ,leafnoteflag -- 叶节点标志--指用于判断此机构是否为机构树最底层的分类节点
            ,supebranchnum -- 行政上级内部机构编码--机构行政上级机构的机构编码。行政类型机构树与营业机构树均使用此字段构建
            ,zwuporgancode -- 账务上级内部机构编码--机构账务上级机构的机构编码
            ,hsuporgancode -- 核算上级内部机构编码--机构核算上级机构的机构编码
            ,seque -- 机构顺序号--指机构在其行政上级机构下的显示顺序
            ,postcode -- 邮政编码--描述机构所在地址的邮政编码信息
            ,country -- 所在国家--描述机构的物理地址所在国家信息。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,province -- 所在省/州--描述机构的物理地址所在行政区划的的“省/自治区/直辖市/特别行政区”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,city -- 所在城市--描述机构的指物理地址中所在行政区划的的“市/地区/自治州/盟/直辖市所辖市辖区（县）”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,county -- 所在县/区--描述机构的物理地址中所在行政区划的“县/自治县/县级市/旗/自治旗/市辖区/林区/特区”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,address -- 详细地址--描述机构的物理地址中除国家地区、行政区划（省、市、县）之外的地址信息，包括街道（乡、镇）、门牌号（村、组）等信息。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,email -- 电子邮箱--描述机构的电子地址具体信息
            ,url -- 网址--描述机构的电子地址具体信息
            ,countrycode -- 国际长途区号--描述机构使用的电话号码所在国际地区的区号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
            ,areacode -- 国内长途区号--描述机构使用的电话号码所在国内地区的区号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
            ,phone -- 电话号码--描述机构使用的除国际长途区号、国内长途区号和分机号之外的电话号码。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
            ,subphone -- 分机号--描述机构使用的电话分机号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
            ,servicephone -- 服务电话--描述机构的电话地址类型信息，如办公电话、服务电话等
            ,funorgan -- 
            ,fundep -- 
            ,financiallicnum -- 金融许可证号码--金融许可证号码是金融许可证上的机构编码，共15位。金融许可证是指银监会依法颁发的特许金融机构经营金融业务的法律文件
            ,organsystem -- 机构关联系统--01:深圳同城02:广东省金融服务平台03:二代支付04:网银互联，多个系统用"|"分隔
            ,orderno -- 显示顺序号--序号
            ,cbrcfininsttid -- 银监会金融机构编号--银监会金融机构编号
            ,unionfinancialcode -- 银联金融机构编号--银联金融机构编号
            ,workstarttm -- 工作开始时间
            ,workendtm -- 工作结束时间
            ,legalpersonname -- 法人姓名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fbms_bsc_uusbranch_infos_op(
            branchcode -- 机构唯一标识
            ,branchnum -- 内部机构编号--含总、分、支行编号和部门、团队编号,总行、分行 3位数字,其它机构是6位数字的机构编码，按照核心系统编码为准，核心不存在机构则使用8位代码，3位总分行编码+5位顺序号
            ,zoneno -- 分行号码--全行所属分行号默认填000
            ,pbocfinancialcode -- 人民银行金融机构编号--指人民银行颁布的，用于识别、界定各类金融机构具体组成的唯一标识
            ,financialcode -- 金融机构标识码--指由国家外汇管理局统一制定，唯一标识金融机构总行（总公司）及其分支机构的代码，每个总行或分支机构均拥有一个唯一的12位金融机构标识码
            ,swiftcode -- swift号码--描述环球同业银行金融电讯协会（swift）为其会员银行同业提供的标准编号，广泛应用于信用证业务以及跨国的结算支付
            ,bankcode -- 支付系统银行行号--指在人民银行现代化支付系统中唯一标识一个银行机构。用于人民银行所组织的大额支付系统\小额支付系统\城市商业银行银行汇票系统\全国支票影像系统（含一些城市的同城票据自动清分系统）等跨区域支付结算业务
            ,legalpersonnum -- 法人顺序号--机构所属的法人编号，华兴银行为0001
            ,businesslicense -- 营业执照号码--描述工商行政管理机关发给我行机构进行金融服务活动的凭证
            ,organizationcode -- 内部机构代码--描述对于中华人民共和国内依法注册、依法登记的机关、企、事业单位、社会团体和民办非企业单位颁发的一个在全国范围内唯一的、始终不变的代码标识编号信息
            ,taxid -- 税务登记证号--描述机构法人代表/负责人在申报办理税务登记时税务机关颁发的登记凭证编号信息
            ,branchname -- 内部机构名称--监管部门或有权审批机构批准的机构名称
            ,organcnshortname -- 内部机构简称--按照一定规则对机构的全称进行适当缩略后形成的机构简称
            ,organenfullname -- 内部机构英文全称--描述按照命名规范统一制定的机构英文全称
            ,organenshortname -- 内部机构英文简称--描述按照命名规范统一制定的机构英文简称
            ,organstatecode -- 机构营业状态代码--指机构经营活动所处的状态。1:待营业,2:正常营业,3:暂停营业:4:终止营业
            ,branchstatu -- 机构状态代码--指机构的使用状态。1：未启用，2：已启用，3：锁定中，4：已注销
            ,organfoundingdate -- 机构成立日期--指机构成立日期，在营业场所内对外开展服务日期（服务涵盖业务咨询、业务交易办理等服务）
            ,organclosedate -- 机构关闭日期--指机构关闭营业，在营业场所内不再对外开展服务日期（服务涵盖业务咨询、业务交易办理等服务
            ,organtype -- 内部机构类型代码--依据我行机构管理模式对机构分类的具体划分。包括：全行00，总行10，分行11，支行12，部门23，团队31等
            ,isst -- 实体机构标志--通过正式批文建立的组织单元，包含总行、分行、支行、实际部门等。0表示否，1表示是
            ,ishs -- 核算机构标志--指可以作为账务、成本等财务指标的核算单元，此类型的机构与总账系统系统保持一致。0表示否，1表示是
            ,isyy -- 营业机构标志--指经过人民银行和金融监管机构批准设立的对外提供银行业务的机构。0表示否，1表示是
            ,isxz -- 行政机构标志--为行政管理需要而设立的机构，办公类系统使用此类。0表示否，1表示是
            ,iszw -- 账务机构标志--指能够进行账务处理的机构，此类型机构与会计引擎保持一致。0表示否，1表示对内对外、2只对内、3只对外
            ,branchlevel -- 内部机构级别代码--指按照我行管理要求，机构所对应的管理层级。比如总行、分行、支行等1-集团2-公司3-总行4-分行5-支行6-网点7-总行工作室8-分行工作室
            ,leafnoteflag -- 叶节点标志--指用于判断此机构是否为机构树最底层的分类节点
            ,supebranchnum -- 行政上级内部机构编码--机构行政上级机构的机构编码。行政类型机构树与营业机构树均使用此字段构建
            ,zwuporgancode -- 账务上级内部机构编码--机构账务上级机构的机构编码
            ,hsuporgancode -- 核算上级内部机构编码--机构核算上级机构的机构编码
            ,seque -- 机构顺序号--指机构在其行政上级机构下的显示顺序
            ,postcode -- 邮政编码--描述机构所在地址的邮政编码信息
            ,country -- 所在国家--描述机构的物理地址所在国家信息。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,province -- 所在省/州--描述机构的物理地址所在行政区划的的“省/自治区/直辖市/特别行政区”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,city -- 所在城市--描述机构的指物理地址中所在行政区划的的“市/地区/自治州/盟/直辖市所辖市辖区（县）”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,county -- 所在县/区--描述机构的物理地址中所在行政区划的“县/自治县/县级市/旗/自治旗/市辖区/林区/特区”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,address -- 详细地址--描述机构的物理地址中除国家地区、行政区划（省、市、县）之外的地址信息，包括街道（乡、镇）、门牌号（村、组）等信息。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,email -- 电子邮箱--描述机构的电子地址具体信息
            ,url -- 网址--描述机构的电子地址具体信息
            ,countrycode -- 国际长途区号--描述机构使用的电话号码所在国际地区的区号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
            ,areacode -- 国内长途区号--描述机构使用的电话号码所在国内地区的区号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
            ,phone -- 电话号码--描述机构使用的除国际长途区号、国内长途区号和分机号之外的电话号码。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
            ,subphone -- 分机号--描述机构使用的电话分机号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
            ,servicephone -- 服务电话--描述机构的电话地址类型信息，如办公电话、服务电话等
            ,funorgan -- 
            ,fundep -- 
            ,financiallicnum -- 金融许可证号码--金融许可证号码是金融许可证上的机构编码，共15位。金融许可证是指银监会依法颁发的特许金融机构经营金融业务的法律文件
            ,organsystem -- 机构关联系统--01:深圳同城02:广东省金融服务平台03:二代支付04:网银互联，多个系统用"|"分隔
            ,orderno -- 显示顺序号--序号
            ,cbrcfininsttid -- 银监会金融机构编号--银监会金融机构编号
            ,unionfinancialcode -- 银联金融机构编号--银联金融机构编号
            ,workstarttm -- 工作开始时间
            ,workendtm -- 工作结束时间
            ,legalpersonname -- 法人姓名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branchcode, o.branchcode) as branchcode -- 机构唯一标识
    ,nvl(n.branchnum, o.branchnum) as branchnum -- 内部机构编号--含总、分、支行编号和部门、团队编号,总行、分行 3位数字,其它机构是6位数字的机构编码，按照核心系统编码为准，核心不存在机构则使用8位代码，3位总分行编码+5位顺序号
    ,nvl(n.zoneno, o.zoneno) as zoneno -- 分行号码--全行所属分行号默认填000
    ,nvl(n.pbocfinancialcode, o.pbocfinancialcode) as pbocfinancialcode -- 人民银行金融机构编号--指人民银行颁布的，用于识别、界定各类金融机构具体组成的唯一标识
    ,nvl(n.financialcode, o.financialcode) as financialcode -- 金融机构标识码--指由国家外汇管理局统一制定，唯一标识金融机构总行（总公司）及其分支机构的代码，每个总行或分支机构均拥有一个唯一的12位金融机构标识码
    ,nvl(n.swiftcode, o.swiftcode) as swiftcode -- swift号码--描述环球同业银行金融电讯协会（swift）为其会员银行同业提供的标准编号，广泛应用于信用证业务以及跨国的结算支付
    ,nvl(n.bankcode, o.bankcode) as bankcode -- 支付系统银行行号--指在人民银行现代化支付系统中唯一标识一个银行机构。用于人民银行所组织的大额支付系统\小额支付系统\城市商业银行银行汇票系统\全国支票影像系统（含一些城市的同城票据自动清分系统）等跨区域支付结算业务
    ,nvl(n.legalpersonnum, o.legalpersonnum) as legalpersonnum -- 法人顺序号--机构所属的法人编号，华兴银行为0001
    ,nvl(n.businesslicense, o.businesslicense) as businesslicense -- 营业执照号码--描述工商行政管理机关发给我行机构进行金融服务活动的凭证
    ,nvl(n.organizationcode, o.organizationcode) as organizationcode -- 内部机构代码--描述对于中华人民共和国内依法注册、依法登记的机关、企、事业单位、社会团体和民办非企业单位颁发的一个在全国范围内唯一的、始终不变的代码标识编号信息
    ,nvl(n.taxid, o.taxid) as taxid -- 税务登记证号--描述机构法人代表/负责人在申报办理税务登记时税务机关颁发的登记凭证编号信息
    ,nvl(n.branchname, o.branchname) as branchname -- 内部机构名称--监管部门或有权审批机构批准的机构名称
    ,nvl(n.organcnshortname, o.organcnshortname) as organcnshortname -- 内部机构简称--按照一定规则对机构的全称进行适当缩略后形成的机构简称
    ,nvl(n.organenfullname, o.organenfullname) as organenfullname -- 内部机构英文全称--描述按照命名规范统一制定的机构英文全称
    ,nvl(n.organenshortname, o.organenshortname) as organenshortname -- 内部机构英文简称--描述按照命名规范统一制定的机构英文简称
    ,nvl(n.organstatecode, o.organstatecode) as organstatecode -- 机构营业状态代码--指机构经营活动所处的状态。1:待营业,2:正常营业,3:暂停营业:4:终止营业
    ,nvl(n.branchstatu, o.branchstatu) as branchstatu -- 机构状态代码--指机构的使用状态。1：未启用，2：已启用，3：锁定中，4：已注销
    ,nvl(n.organfoundingdate, o.organfoundingdate) as organfoundingdate -- 机构成立日期--指机构成立日期，在营业场所内对外开展服务日期（服务涵盖业务咨询、业务交易办理等服务）
    ,nvl(n.organclosedate, o.organclosedate) as organclosedate -- 机构关闭日期--指机构关闭营业，在营业场所内不再对外开展服务日期（服务涵盖业务咨询、业务交易办理等服务
    ,nvl(n.organtype, o.organtype) as organtype -- 内部机构类型代码--依据我行机构管理模式对机构分类的具体划分。包括：全行00，总行10，分行11，支行12，部门23，团队31等
    ,nvl(n.isst, o.isst) as isst -- 实体机构标志--通过正式批文建立的组织单元，包含总行、分行、支行、实际部门等。0表示否，1表示是
    ,nvl(n.ishs, o.ishs) as ishs -- 核算机构标志--指可以作为账务、成本等财务指标的核算单元，此类型的机构与总账系统系统保持一致。0表示否，1表示是
    ,nvl(n.isyy, o.isyy) as isyy -- 营业机构标志--指经过人民银行和金融监管机构批准设立的对外提供银行业务的机构。0表示否，1表示是
    ,nvl(n.isxz, o.isxz) as isxz -- 行政机构标志--为行政管理需要而设立的机构，办公类系统使用此类。0表示否，1表示是
    ,nvl(n.iszw, o.iszw) as iszw -- 账务机构标志--指能够进行账务处理的机构，此类型机构与会计引擎保持一致。0表示否，1表示对内对外、2只对内、3只对外
    ,nvl(n.branchlevel, o.branchlevel) as branchlevel -- 内部机构级别代码--指按照我行管理要求，机构所对应的管理层级。比如总行、分行、支行等1-集团2-公司3-总行4-分行5-支行6-网点7-总行工作室8-分行工作室
    ,nvl(n.leafnoteflag, o.leafnoteflag) as leafnoteflag -- 叶节点标志--指用于判断此机构是否为机构树最底层的分类节点
    ,nvl(n.supebranchnum, o.supebranchnum) as supebranchnum -- 行政上级内部机构编码--机构行政上级机构的机构编码。行政类型机构树与营业机构树均使用此字段构建
    ,nvl(n.zwuporgancode, o.zwuporgancode) as zwuporgancode -- 账务上级内部机构编码--机构账务上级机构的机构编码
    ,nvl(n.hsuporgancode, o.hsuporgancode) as hsuporgancode -- 核算上级内部机构编码--机构核算上级机构的机构编码
    ,nvl(n.seque, o.seque) as seque -- 机构顺序号--指机构在其行政上级机构下的显示顺序
    ,nvl(n.postcode, o.postcode) as postcode -- 邮政编码--描述机构所在地址的邮政编码信息
    ,nvl(n.country, o.country) as country -- 所在国家--描述机构的物理地址所在国家信息。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
    ,nvl(n.province, o.province) as province -- 所在省/州--描述机构的物理地址所在行政区划的的“省/自治区/直辖市/特别行政区”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
    ,nvl(n.city, o.city) as city -- 所在城市--描述机构的指物理地址中所在行政区划的的“市/地区/自治州/盟/直辖市所辖市辖区（县）”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
    ,nvl(n.county, o.county) as county -- 所在县/区--描述机构的物理地址中所在行政区划的“县/自治县/县级市/旗/自治旗/市辖区/林区/特区”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
    ,nvl(n.address, o.address) as address -- 详细地址--描述机构的物理地址中除国家地区、行政区划（省、市、县）之外的地址信息，包括街道（乡、镇）、门牌号（村、组）等信息。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
    ,nvl(n.email, o.email) as email -- 电子邮箱--描述机构的电子地址具体信息
    ,nvl(n.url, o.url) as url -- 网址--描述机构的电子地址具体信息
    ,nvl(n.countrycode, o.countrycode) as countrycode -- 国际长途区号--描述机构使用的电话号码所在国际地区的区号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
    ,nvl(n.areacode, o.areacode) as areacode -- 国内长途区号--描述机构使用的电话号码所在国内地区的区号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
    ,nvl(n.phone, o.phone) as phone -- 电话号码--描述机构使用的除国际长途区号、国内长途区号和分机号之外的电话号码。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
    ,nvl(n.subphone, o.subphone) as subphone -- 分机号--描述机构使用的电话分机号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
    ,nvl(n.servicephone, o.servicephone) as servicephone -- 服务电话--描述机构的电话地址类型信息，如办公电话、服务电话等
    ,nvl(n.funorgan, o.funorgan) as funorgan -- 
    ,nvl(n.fundep, o.fundep) as fundep -- 
    ,nvl(n.financiallicnum, o.financiallicnum) as financiallicnum -- 金融许可证号码--金融许可证号码是金融许可证上的机构编码，共15位。金融许可证是指银监会依法颁发的特许金融机构经营金融业务的法律文件
    ,nvl(n.organsystem, o.organsystem) as organsystem -- 机构关联系统--01:深圳同城02:广东省金融服务平台03:二代支付04:网银互联，多个系统用"|"分隔
    ,nvl(n.orderno, o.orderno) as orderno -- 显示顺序号--序号
    ,nvl(n.cbrcfininsttid, o.cbrcfininsttid) as cbrcfininsttid -- 银监会金融机构编号--银监会金融机构编号
    ,nvl(n.unionfinancialcode, o.unionfinancialcode) as unionfinancialcode -- 银联金融机构编号--银联金融机构编号
    ,nvl(n.workstarttm, o.workstarttm) as workstarttm -- 工作开始时间
    ,nvl(n.workendtm, o.workendtm) as workendtm -- 工作结束时间
    ,nvl(n.legalpersonname, o.legalpersonname) as legalpersonname -- 法人姓名
    ,case when
            n.branchnum is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.branchnum is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.branchnum is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fbms_bsc_uusbranch_infos_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fbms_bsc_uusbranch_infos where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.branchnum = n.branchnum
where (
        o.branchnum is null
    )
    or (
        n.branchnum is null
    )
    or (
        o.branchcode <> n.branchcode
        or o.zoneno <> n.zoneno
        or o.pbocfinancialcode <> n.pbocfinancialcode
        or o.financialcode <> n.financialcode
        or o.swiftcode <> n.swiftcode
        or o.bankcode <> n.bankcode
        or o.legalpersonnum <> n.legalpersonnum
        or o.businesslicense <> n.businesslicense
        or o.organizationcode <> n.organizationcode
        or o.taxid <> n.taxid
        or o.branchname <> n.branchname
        or o.organcnshortname <> n.organcnshortname
        or o.organenfullname <> n.organenfullname
        or o.organenshortname <> n.organenshortname
        or o.organstatecode <> n.organstatecode
        or o.branchstatu <> n.branchstatu
        or o.organfoundingdate <> n.organfoundingdate
        or o.organclosedate <> n.organclosedate
        or o.organtype <> n.organtype
        or o.isst <> n.isst
        or o.ishs <> n.ishs
        or o.isyy <> n.isyy
        or o.isxz <> n.isxz
        or o.iszw <> n.iszw
        or o.branchlevel <> n.branchlevel
        or o.leafnoteflag <> n.leafnoteflag
        or o.supebranchnum <> n.supebranchnum
        or o.zwuporgancode <> n.zwuporgancode
        or o.hsuporgancode <> n.hsuporgancode
        or o.seque <> n.seque
        or o.postcode <> n.postcode
        or o.country <> n.country
        or o.province <> n.province
        or o.city <> n.city
        or o.county <> n.county
        or o.address <> n.address
        or o.email <> n.email
        or o.url <> n.url
        or o.countrycode <> n.countrycode
        or o.areacode <> n.areacode
        or o.phone <> n.phone
        or o.subphone <> n.subphone
        or o.servicephone <> n.servicephone
        or o.funorgan <> n.funorgan
        or o.fundep <> n.fundep
        or o.financiallicnum <> n.financiallicnum
        or o.organsystem <> n.organsystem
        or o.orderno <> n.orderno
        or o.cbrcfininsttid <> n.cbrcfininsttid
        or o.unionfinancialcode <> n.unionfinancialcode
        or o.workstarttm <> n.workstarttm
        or o.workendtm <> n.workendtm
        or o.legalpersonname <> n.legalpersonname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fbms_bsc_uusbranch_infos_cl(
            branchcode -- 机构唯一标识
            ,branchnum -- 内部机构编号--含总、分、支行编号和部门、团队编号,总行、分行 3位数字,其它机构是6位数字的机构编码，按照核心系统编码为准，核心不存在机构则使用8位代码，3位总分行编码+5位顺序号
            ,zoneno -- 分行号码--全行所属分行号默认填000
            ,pbocfinancialcode -- 人民银行金融机构编号--指人民银行颁布的，用于识别、界定各类金融机构具体组成的唯一标识
            ,financialcode -- 金融机构标识码--指由国家外汇管理局统一制定，唯一标识金融机构总行（总公司）及其分支机构的代码，每个总行或分支机构均拥有一个唯一的12位金融机构标识码
            ,swiftcode -- swift号码--描述环球同业银行金融电讯协会（swift）为其会员银行同业提供的标准编号，广泛应用于信用证业务以及跨国的结算支付
            ,bankcode -- 支付系统银行行号--指在人民银行现代化支付系统中唯一标识一个银行机构。用于人民银行所组织的大额支付系统\小额支付系统\城市商业银行银行汇票系统\全国支票影像系统（含一些城市的同城票据自动清分系统）等跨区域支付结算业务
            ,legalpersonnum -- 法人顺序号--机构所属的法人编号，华兴银行为0001
            ,businesslicense -- 营业执照号码--描述工商行政管理机关发给我行机构进行金融服务活动的凭证
            ,organizationcode -- 内部机构代码--描述对于中华人民共和国内依法注册、依法登记的机关、企、事业单位、社会团体和民办非企业单位颁发的一个在全国范围内唯一的、始终不变的代码标识编号信息
            ,taxid -- 税务登记证号--描述机构法人代表/负责人在申报办理税务登记时税务机关颁发的登记凭证编号信息
            ,branchname -- 内部机构名称--监管部门或有权审批机构批准的机构名称
            ,organcnshortname -- 内部机构简称--按照一定规则对机构的全称进行适当缩略后形成的机构简称
            ,organenfullname -- 内部机构英文全称--描述按照命名规范统一制定的机构英文全称
            ,organenshortname -- 内部机构英文简称--描述按照命名规范统一制定的机构英文简称
            ,organstatecode -- 机构营业状态代码--指机构经营活动所处的状态。1:待营业,2:正常营业,3:暂停营业:4:终止营业
            ,branchstatu -- 机构状态代码--指机构的使用状态。1：未启用，2：已启用，3：锁定中，4：已注销
            ,organfoundingdate -- 机构成立日期--指机构成立日期，在营业场所内对外开展服务日期（服务涵盖业务咨询、业务交易办理等服务）
            ,organclosedate -- 机构关闭日期--指机构关闭营业，在营业场所内不再对外开展服务日期（服务涵盖业务咨询、业务交易办理等服务
            ,organtype -- 内部机构类型代码--依据我行机构管理模式对机构分类的具体划分。包括：全行00，总行10，分行11，支行12，部门23，团队31等
            ,isst -- 实体机构标志--通过正式批文建立的组织单元，包含总行、分行、支行、实际部门等。0表示否，1表示是
            ,ishs -- 核算机构标志--指可以作为账务、成本等财务指标的核算单元，此类型的机构与总账系统系统保持一致。0表示否，1表示是
            ,isyy -- 营业机构标志--指经过人民银行和金融监管机构批准设立的对外提供银行业务的机构。0表示否，1表示是
            ,isxz -- 行政机构标志--为行政管理需要而设立的机构，办公类系统使用此类。0表示否，1表示是
            ,iszw -- 账务机构标志--指能够进行账务处理的机构，此类型机构与会计引擎保持一致。0表示否，1表示对内对外、2只对内、3只对外
            ,branchlevel -- 内部机构级别代码--指按照我行管理要求，机构所对应的管理层级。比如总行、分行、支行等1-集团2-公司3-总行4-分行5-支行6-网点7-总行工作室8-分行工作室
            ,leafnoteflag -- 叶节点标志--指用于判断此机构是否为机构树最底层的分类节点
            ,supebranchnum -- 行政上级内部机构编码--机构行政上级机构的机构编码。行政类型机构树与营业机构树均使用此字段构建
            ,zwuporgancode -- 账务上级内部机构编码--机构账务上级机构的机构编码
            ,hsuporgancode -- 核算上级内部机构编码--机构核算上级机构的机构编码
            ,seque -- 机构顺序号--指机构在其行政上级机构下的显示顺序
            ,postcode -- 邮政编码--描述机构所在地址的邮政编码信息
            ,country -- 所在国家--描述机构的物理地址所在国家信息。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,province -- 所在省/州--描述机构的物理地址所在行政区划的的“省/自治区/直辖市/特别行政区”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,city -- 所在城市--描述机构的指物理地址中所在行政区划的的“市/地区/自治州/盟/直辖市所辖市辖区（县）”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,county -- 所在县/区--描述机构的物理地址中所在行政区划的“县/自治县/县级市/旗/自治旗/市辖区/林区/特区”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,address -- 详细地址--描述机构的物理地址中除国家地区、行政区划（省、市、县）之外的地址信息，包括街道（乡、镇）、门牌号（村、组）等信息。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,email -- 电子邮箱--描述机构的电子地址具体信息
            ,url -- 网址--描述机构的电子地址具体信息
            ,countrycode -- 国际长途区号--描述机构使用的电话号码所在国际地区的区号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
            ,areacode -- 国内长途区号--描述机构使用的电话号码所在国内地区的区号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
            ,phone -- 电话号码--描述机构使用的除国际长途区号、国内长途区号和分机号之外的电话号码。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
            ,subphone -- 分机号--描述机构使用的电话分机号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
            ,servicephone -- 服务电话--描述机构的电话地址类型信息，如办公电话、服务电话等
            ,funorgan -- 
            ,fundep -- 
            ,financiallicnum -- 金融许可证号码--金融许可证号码是金融许可证上的机构编码，共15位。金融许可证是指银监会依法颁发的特许金融机构经营金融业务的法律文件
            ,organsystem -- 机构关联系统--01:深圳同城02:广东省金融服务平台03:二代支付04:网银互联，多个系统用"|"分隔
            ,orderno -- 显示顺序号--序号
            ,cbrcfininsttid -- 银监会金融机构编号--银监会金融机构编号
            ,unionfinancialcode -- 银联金融机构编号--银联金融机构编号
            ,workstarttm -- 工作开始时间
            ,workendtm -- 工作结束时间
            ,legalpersonname -- 法人姓名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fbms_bsc_uusbranch_infos_op(
            branchcode -- 机构唯一标识
            ,branchnum -- 内部机构编号--含总、分、支行编号和部门、团队编号,总行、分行 3位数字,其它机构是6位数字的机构编码，按照核心系统编码为准，核心不存在机构则使用8位代码，3位总分行编码+5位顺序号
            ,zoneno -- 分行号码--全行所属分行号默认填000
            ,pbocfinancialcode -- 人民银行金融机构编号--指人民银行颁布的，用于识别、界定各类金融机构具体组成的唯一标识
            ,financialcode -- 金融机构标识码--指由国家外汇管理局统一制定，唯一标识金融机构总行（总公司）及其分支机构的代码，每个总行或分支机构均拥有一个唯一的12位金融机构标识码
            ,swiftcode -- swift号码--描述环球同业银行金融电讯协会（swift）为其会员银行同业提供的标准编号，广泛应用于信用证业务以及跨国的结算支付
            ,bankcode -- 支付系统银行行号--指在人民银行现代化支付系统中唯一标识一个银行机构。用于人民银行所组织的大额支付系统\小额支付系统\城市商业银行银行汇票系统\全国支票影像系统（含一些城市的同城票据自动清分系统）等跨区域支付结算业务
            ,legalpersonnum -- 法人顺序号--机构所属的法人编号，华兴银行为0001
            ,businesslicense -- 营业执照号码--描述工商行政管理机关发给我行机构进行金融服务活动的凭证
            ,organizationcode -- 内部机构代码--描述对于中华人民共和国内依法注册、依法登记的机关、企、事业单位、社会团体和民办非企业单位颁发的一个在全国范围内唯一的、始终不变的代码标识编号信息
            ,taxid -- 税务登记证号--描述机构法人代表/负责人在申报办理税务登记时税务机关颁发的登记凭证编号信息
            ,branchname -- 内部机构名称--监管部门或有权审批机构批准的机构名称
            ,organcnshortname -- 内部机构简称--按照一定规则对机构的全称进行适当缩略后形成的机构简称
            ,organenfullname -- 内部机构英文全称--描述按照命名规范统一制定的机构英文全称
            ,organenshortname -- 内部机构英文简称--描述按照命名规范统一制定的机构英文简称
            ,organstatecode -- 机构营业状态代码--指机构经营活动所处的状态。1:待营业,2:正常营业,3:暂停营业:4:终止营业
            ,branchstatu -- 机构状态代码--指机构的使用状态。1：未启用，2：已启用，3：锁定中，4：已注销
            ,organfoundingdate -- 机构成立日期--指机构成立日期，在营业场所内对外开展服务日期（服务涵盖业务咨询、业务交易办理等服务）
            ,organclosedate -- 机构关闭日期--指机构关闭营业，在营业场所内不再对外开展服务日期（服务涵盖业务咨询、业务交易办理等服务
            ,organtype -- 内部机构类型代码--依据我行机构管理模式对机构分类的具体划分。包括：全行00，总行10，分行11，支行12，部门23，团队31等
            ,isst -- 实体机构标志--通过正式批文建立的组织单元，包含总行、分行、支行、实际部门等。0表示否，1表示是
            ,ishs -- 核算机构标志--指可以作为账务、成本等财务指标的核算单元，此类型的机构与总账系统系统保持一致。0表示否，1表示是
            ,isyy -- 营业机构标志--指经过人民银行和金融监管机构批准设立的对外提供银行业务的机构。0表示否，1表示是
            ,isxz -- 行政机构标志--为行政管理需要而设立的机构，办公类系统使用此类。0表示否，1表示是
            ,iszw -- 账务机构标志--指能够进行账务处理的机构，此类型机构与会计引擎保持一致。0表示否，1表示对内对外、2只对内、3只对外
            ,branchlevel -- 内部机构级别代码--指按照我行管理要求，机构所对应的管理层级。比如总行、分行、支行等1-集团2-公司3-总行4-分行5-支行6-网点7-总行工作室8-分行工作室
            ,leafnoteflag -- 叶节点标志--指用于判断此机构是否为机构树最底层的分类节点
            ,supebranchnum -- 行政上级内部机构编码--机构行政上级机构的机构编码。行政类型机构树与营业机构树均使用此字段构建
            ,zwuporgancode -- 账务上级内部机构编码--机构账务上级机构的机构编码
            ,hsuporgancode -- 核算上级内部机构编码--机构核算上级机构的机构编码
            ,seque -- 机构顺序号--指机构在其行政上级机构下的显示顺序
            ,postcode -- 邮政编码--描述机构所在地址的邮政编码信息
            ,country -- 所在国家--描述机构的物理地址所在国家信息。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,province -- 所在省/州--描述机构的物理地址所在行政区划的的“省/自治区/直辖市/特别行政区”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,city -- 所在城市--描述机构的指物理地址中所在行政区划的的“市/地区/自治州/盟/直辖市所辖市辖区（县）”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,county -- 所在县/区--描述机构的物理地址中所在行政区划的“县/自治县/县级市/旗/自治旗/市辖区/林区/特区”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,address -- 详细地址--描述机构的物理地址中除国家地区、行政区划（省、市、县）之外的地址信息，包括街道（乡、镇）、门牌号（村、组）等信息。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
            ,email -- 电子邮箱--描述机构的电子地址具体信息
            ,url -- 网址--描述机构的电子地址具体信息
            ,countrycode -- 国际长途区号--描述机构使用的电话号码所在国际地区的区号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
            ,areacode -- 国内长途区号--描述机构使用的电话号码所在国内地区的区号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
            ,phone -- 电话号码--描述机构使用的除国际长途区号、国内长途区号和分机号之外的电话号码。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
            ,subphone -- 分机号--描述机构使用的电话分机号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
            ,servicephone -- 服务电话--描述机构的电话地址类型信息，如办公电话、服务电话等
            ,funorgan -- 
            ,fundep -- 
            ,financiallicnum -- 金融许可证号码--金融许可证号码是金融许可证上的机构编码，共15位。金融许可证是指银监会依法颁发的特许金融机构经营金融业务的法律文件
            ,organsystem -- 机构关联系统--01:深圳同城02:广东省金融服务平台03:二代支付04:网银互联，多个系统用"|"分隔
            ,orderno -- 显示顺序号--序号
            ,cbrcfininsttid -- 银监会金融机构编号--银监会金融机构编号
            ,unionfinancialcode -- 银联金融机构编号--银联金融机构编号
            ,workstarttm -- 工作开始时间
            ,workendtm -- 工作结束时间
            ,legalpersonname -- 法人姓名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branchcode -- 机构唯一标识
    ,o.branchnum -- 内部机构编号--含总、分、支行编号和部门、团队编号,总行、分行 3位数字,其它机构是6位数字的机构编码，按照核心系统编码为准，核心不存在机构则使用8位代码，3位总分行编码+5位顺序号
    ,o.zoneno -- 分行号码--全行所属分行号默认填000
    ,o.pbocfinancialcode -- 人民银行金融机构编号--指人民银行颁布的，用于识别、界定各类金融机构具体组成的唯一标识
    ,o.financialcode -- 金融机构标识码--指由国家外汇管理局统一制定，唯一标识金融机构总行（总公司）及其分支机构的代码，每个总行或分支机构均拥有一个唯一的12位金融机构标识码
    ,o.swiftcode -- swift号码--描述环球同业银行金融电讯协会（swift）为其会员银行同业提供的标准编号，广泛应用于信用证业务以及跨国的结算支付
    ,o.bankcode -- 支付系统银行行号--指在人民银行现代化支付系统中唯一标识一个银行机构。用于人民银行所组织的大额支付系统\小额支付系统\城市商业银行银行汇票系统\全国支票影像系统（含一些城市的同城票据自动清分系统）等跨区域支付结算业务
    ,o.legalpersonnum -- 法人顺序号--机构所属的法人编号，华兴银行为0001
    ,o.businesslicense -- 营业执照号码--描述工商行政管理机关发给我行机构进行金融服务活动的凭证
    ,o.organizationcode -- 内部机构代码--描述对于中华人民共和国内依法注册、依法登记的机关、企、事业单位、社会团体和民办非企业单位颁发的一个在全国范围内唯一的、始终不变的代码标识编号信息
    ,o.taxid -- 税务登记证号--描述机构法人代表/负责人在申报办理税务登记时税务机关颁发的登记凭证编号信息
    ,o.branchname -- 内部机构名称--监管部门或有权审批机构批准的机构名称
    ,o.organcnshortname -- 内部机构简称--按照一定规则对机构的全称进行适当缩略后形成的机构简称
    ,o.organenfullname -- 内部机构英文全称--描述按照命名规范统一制定的机构英文全称
    ,o.organenshortname -- 内部机构英文简称--描述按照命名规范统一制定的机构英文简称
    ,o.organstatecode -- 机构营业状态代码--指机构经营活动所处的状态。1:待营业,2:正常营业,3:暂停营业:4:终止营业
    ,o.branchstatu -- 机构状态代码--指机构的使用状态。1：未启用，2：已启用，3：锁定中，4：已注销
    ,o.organfoundingdate -- 机构成立日期--指机构成立日期，在营业场所内对外开展服务日期（服务涵盖业务咨询、业务交易办理等服务）
    ,o.organclosedate -- 机构关闭日期--指机构关闭营业，在营业场所内不再对外开展服务日期（服务涵盖业务咨询、业务交易办理等服务
    ,o.organtype -- 内部机构类型代码--依据我行机构管理模式对机构分类的具体划分。包括：全行00，总行10，分行11，支行12，部门23，团队31等
    ,o.isst -- 实体机构标志--通过正式批文建立的组织单元，包含总行、分行、支行、实际部门等。0表示否，1表示是
    ,o.ishs -- 核算机构标志--指可以作为账务、成本等财务指标的核算单元，此类型的机构与总账系统系统保持一致。0表示否，1表示是
    ,o.isyy -- 营业机构标志--指经过人民银行和金融监管机构批准设立的对外提供银行业务的机构。0表示否，1表示是
    ,o.isxz -- 行政机构标志--为行政管理需要而设立的机构，办公类系统使用此类。0表示否，1表示是
    ,o.iszw -- 账务机构标志--指能够进行账务处理的机构，此类型机构与会计引擎保持一致。0表示否，1表示对内对外、2只对内、3只对外
    ,o.branchlevel -- 内部机构级别代码--指按照我行管理要求，机构所对应的管理层级。比如总行、分行、支行等1-集团2-公司3-总行4-分行5-支行6-网点7-总行工作室8-分行工作室
    ,o.leafnoteflag -- 叶节点标志--指用于判断此机构是否为机构树最底层的分类节点
    ,o.supebranchnum -- 行政上级内部机构编码--机构行政上级机构的机构编码。行政类型机构树与营业机构树均使用此字段构建
    ,o.zwuporgancode -- 账务上级内部机构编码--机构账务上级机构的机构编码
    ,o.hsuporgancode -- 核算上级内部机构编码--机构核算上级机构的机构编码
    ,o.seque -- 机构顺序号--指机构在其行政上级机构下的显示顺序
    ,o.postcode -- 邮政编码--描述机构所在地址的邮政编码信息
    ,o.country -- 所在国家--描述机构的物理地址所在国家信息。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
    ,o.province -- 所在省/州--描述机构的物理地址所在行政区划的的“省/自治区/直辖市/特别行政区”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
    ,o.city -- 所在城市--描述机构的指物理地址中所在行政区划的的“市/地区/自治州/盟/直辖市所辖市辖区（县）”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
    ,o.county -- 所在县/区--描述机构的物理地址中所在行政区划的“县/自治县/县级市/旗/自治旗/市辖区/林区/特区”。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
    ,o.address -- 详细地址--描述机构的物理地址中除国家地区、行政区划（省、市、县）之外的地址信息，包括街道（乡、镇）、门牌号（村、组）等信息。完整的物理地址由“国家和地区代码+省代码+市代码+县代码+详细地址（邮政编码）”组成
    ,o.email -- 电子邮箱--描述机构的电子地址具体信息
    ,o.url -- 网址--描述机构的电子地址具体信息
    ,o.countrycode -- 国际长途区号--描述机构使用的电话号码所在国际地区的区号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
    ,o.areacode -- 国内长途区号--描述机构使用的电话号码所在国内地区的区号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
    ,o.phone -- 电话号码--描述机构使用的除国际长途区号、国内长途区号和分机号之外的电话号码。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
    ,o.subphone -- 分机号--描述机构使用的电话分机号信息。完整的电话号码由“国际长途区号+国内长途区号+电话号码+分机号”组成
    ,o.servicephone -- 服务电话--描述机构的电话地址类型信息，如办公电话、服务电话等
    ,o.funorgan -- 
    ,o.fundep -- 
    ,o.financiallicnum -- 金融许可证号码--金融许可证号码是金融许可证上的机构编码，共15位。金融许可证是指银监会依法颁发的特许金融机构经营金融业务的法律文件
    ,o.organsystem -- 机构关联系统--01:深圳同城02:广东省金融服务平台03:二代支付04:网银互联，多个系统用"|"分隔
    ,o.orderno -- 显示顺序号--序号
    ,o.cbrcfininsttid -- 银监会金融机构编号--银监会金融机构编号
    ,o.unionfinancialcode -- 银联金融机构编号--银联金融机构编号
    ,o.workstarttm -- 工作开始时间
    ,o.workendtm -- 工作结束时间
    ,o.legalpersonname -- 法人姓名
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
from ${iol_schema}.fbms_bsc_uusbranch_infos_bk o
    left join ${iol_schema}.fbms_bsc_uusbranch_infos_op n
        on
            o.branchnum = n.branchnum
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fbms_bsc_uusbranch_infos_cl d
        on
            o.branchnum = d.branchnum
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fbms_bsc_uusbranch_infos;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fbms_bsc_uusbranch_infos') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fbms_bsc_uusbranch_infos drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fbms_bsc_uusbranch_infos add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fbms_bsc_uusbranch_infos exchange partition p_${batch_date} with table ${iol_schema}.fbms_bsc_uusbranch_infos_cl;
alter table ${iol_schema}.fbms_bsc_uusbranch_infos exchange partition p_20991231 with table ${iol_schema}.fbms_bsc_uusbranch_infos_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fbms_bsc_uusbranch_infos to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fbms_bsc_uusbranch_infos_op purge;
drop table ${iol_schema}.fbms_bsc_uusbranch_infos_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fbms_bsc_uusbranch_infos_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fbms_bsc_uusbranch_infos',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
