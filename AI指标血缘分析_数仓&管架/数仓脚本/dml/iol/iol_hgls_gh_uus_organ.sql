/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_hgls_gh_uus_organ
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
create table ${iol_schema}.hgls_gh_uus_organ_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.hgls_gh_uus_organ
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_gh_uus_organ_op purge;
drop table ${iol_schema}.hgls_gh_uus_organ_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_gh_uus_organ_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_gh_uus_organ where 0=1;

create table ${iol_schema}.hgls_gh_uus_organ_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_gh_uus_organ where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_gh_uus_organ_cl(
            id -- 主键id
            ,organcodekey -- 统一组织机构编码
            ,organcode -- 组织机构编号
            ,zoneno -- 分行号
            ,pbocfinancialcode -- 人行金融机构编码
            ,financialcode -- 金融机构标识码
            ,swiftcode -- SWIFT编号
            ,bankcode -- 人行支付行号
            ,legal -- 法人号
            ,businesslicense -- 营业执照号码
            ,organizationcode -- 组织机构代码
            ,taxid -- 税务登记证号
            ,organcnfullname -- 机构全称
            ,organcnshortname -- 机构简称
            ,organenfullname -- 组织机构英文全称
            ,organenshortname -- 组织机构英文简称
            ,organstatecode -- 机构营业状态
            ,organstatus -- 机构状态
            ,organfoundingdate -- 机构成立日期
            ,organclosedate -- 机构撤销日期
            ,organtype -- 组织机构类型
            ,isst -- 是否为实体机构
            ,ishs -- 是否为核算机构
            ,isyy -- 是否为报表机构
            ,isxz -- 是否为行政机构
            ,iszw -- 是否为混合机构
            ,organlevel -- 机构级别
            ,leafnoteflag -- 叶节点标志
            ,xzuporgancode -- 行政上级机构编号
            ,zwuporgancode -- 混合上级机构编号
            ,hsuporgancode -- 核算上级机构编号
            ,seque -- 机构顺序号
            ,postcode -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 所在县/区
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,url -- 网址
            ,countrycode -- 国际长途区号
            ,areacode -- 国内长途区号
            ,phone -- 电话号码
            ,subphone -- 分机号
            ,servicephone -- 服务电话
            ,funorgan -- 职能机构
            ,fundep -- 职能部门
            ,financiallicnum -- 金融许可证编号
            ,organsystem -- 机构关联系统
            ,orderno -- 显示顺序号
            ,cbrcfininsttid -- 银监会金融机构编号
            ,unionfinancialcode -- 银联金融机构编号
            ,workstarttm -- 工作开始时间
            ,workendtm -- 工作结束时间
            ,bbuporgancode -- 报表上级机构编号
            ,heademplyid -- 负责人工号
            ,isxnhs -- 是否为虚拟核算机构
            ,rhregcode -- 人行地区码
            ,blngcitypbc -- 所属城市(人行)
            ,bankcodeperson -- 支付系统银行行号（用于个人结算账户报送）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_gh_uus_organ_op(
            id -- 主键id
            ,organcodekey -- 统一组织机构编码
            ,organcode -- 组织机构编号
            ,zoneno -- 分行号
            ,pbocfinancialcode -- 人行金融机构编码
            ,financialcode -- 金融机构标识码
            ,swiftcode -- SWIFT编号
            ,bankcode -- 人行支付行号
            ,legal -- 法人号
            ,businesslicense -- 营业执照号码
            ,organizationcode -- 组织机构代码
            ,taxid -- 税务登记证号
            ,organcnfullname -- 机构全称
            ,organcnshortname -- 机构简称
            ,organenfullname -- 组织机构英文全称
            ,organenshortname -- 组织机构英文简称
            ,organstatecode -- 机构营业状态
            ,organstatus -- 机构状态
            ,organfoundingdate -- 机构成立日期
            ,organclosedate -- 机构撤销日期
            ,organtype -- 组织机构类型
            ,isst -- 是否为实体机构
            ,ishs -- 是否为核算机构
            ,isyy -- 是否为报表机构
            ,isxz -- 是否为行政机构
            ,iszw -- 是否为混合机构
            ,organlevel -- 机构级别
            ,leafnoteflag -- 叶节点标志
            ,xzuporgancode -- 行政上级机构编号
            ,zwuporgancode -- 混合上级机构编号
            ,hsuporgancode -- 核算上级机构编号
            ,seque -- 机构顺序号
            ,postcode -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 所在县/区
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,url -- 网址
            ,countrycode -- 国际长途区号
            ,areacode -- 国内长途区号
            ,phone -- 电话号码
            ,subphone -- 分机号
            ,servicephone -- 服务电话
            ,funorgan -- 职能机构
            ,fundep -- 职能部门
            ,financiallicnum -- 金融许可证编号
            ,organsystem -- 机构关联系统
            ,orderno -- 显示顺序号
            ,cbrcfininsttid -- 银监会金融机构编号
            ,unionfinancialcode -- 银联金融机构编号
            ,workstarttm -- 工作开始时间
            ,workendtm -- 工作结束时间
            ,bbuporgancode -- 报表上级机构编号
            ,heademplyid -- 负责人工号
            ,isxnhs -- 是否为虚拟核算机构
            ,rhregcode -- 人行地区码
            ,blngcitypbc -- 所属城市(人行)
            ,bankcodeperson -- 支付系统银行行号（用于个人结算账户报送）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键id
    ,nvl(n.organcodekey, o.organcodekey) as organcodekey -- 统一组织机构编码
    ,nvl(n.organcode, o.organcode) as organcode -- 组织机构编号
    ,nvl(n.zoneno, o.zoneno) as zoneno -- 分行号
    ,nvl(n.pbocfinancialcode, o.pbocfinancialcode) as pbocfinancialcode -- 人行金融机构编码
    ,nvl(n.financialcode, o.financialcode) as financialcode -- 金融机构标识码
    ,nvl(n.swiftcode, o.swiftcode) as swiftcode -- SWIFT编号
    ,nvl(n.bankcode, o.bankcode) as bankcode -- 人行支付行号
    ,nvl(n.legal, o.legal) as legal -- 法人号
    ,nvl(n.businesslicense, o.businesslicense) as businesslicense -- 营业执照号码
    ,nvl(n.organizationcode, o.organizationcode) as organizationcode -- 组织机构代码
    ,nvl(n.taxid, o.taxid) as taxid -- 税务登记证号
    ,nvl(n.organcnfullname, o.organcnfullname) as organcnfullname -- 机构全称
    ,nvl(n.organcnshortname, o.organcnshortname) as organcnshortname -- 机构简称
    ,nvl(n.organenfullname, o.organenfullname) as organenfullname -- 组织机构英文全称
    ,nvl(n.organenshortname, o.organenshortname) as organenshortname -- 组织机构英文简称
    ,nvl(n.organstatecode, o.organstatecode) as organstatecode -- 机构营业状态
    ,nvl(n.organstatus, o.organstatus) as organstatus -- 机构状态
    ,nvl(n.organfoundingdate, o.organfoundingdate) as organfoundingdate -- 机构成立日期
    ,nvl(n.organclosedate, o.organclosedate) as organclosedate -- 机构撤销日期
    ,nvl(n.organtype, o.organtype) as organtype -- 组织机构类型
    ,nvl(n.isst, o.isst) as isst -- 是否为实体机构
    ,nvl(n.ishs, o.ishs) as ishs -- 是否为核算机构
    ,nvl(n.isyy, o.isyy) as isyy -- 是否为报表机构
    ,nvl(n.isxz, o.isxz) as isxz -- 是否为行政机构
    ,nvl(n.iszw, o.iszw) as iszw -- 是否为混合机构
    ,nvl(n.organlevel, o.organlevel) as organlevel -- 机构级别
    ,nvl(n.leafnoteflag, o.leafnoteflag) as leafnoteflag -- 叶节点标志
    ,nvl(n.xzuporgancode, o.xzuporgancode) as xzuporgancode -- 行政上级机构编号
    ,nvl(n.zwuporgancode, o.zwuporgancode) as zwuporgancode -- 混合上级机构编号
    ,nvl(n.hsuporgancode, o.hsuporgancode) as hsuporgancode -- 核算上级机构编号
    ,nvl(n.seque, o.seque) as seque -- 机构顺序号
    ,nvl(n.postcode, o.postcode) as postcode -- 邮政编码
    ,nvl(n.country, o.country) as country -- 所在国家
    ,nvl(n.province, o.province) as province -- 所在省/州
    ,nvl(n.city, o.city) as city -- 所在城市
    ,nvl(n.county, o.county) as county -- 所在县/区
    ,nvl(n.address, o.address) as address -- 详细地址
    ,nvl(n.email, o.email) as email -- 电子邮箱
    ,nvl(n.url, o.url) as url -- 网址
    ,nvl(n.countrycode, o.countrycode) as countrycode -- 国际长途区号
    ,nvl(n.areacode, o.areacode) as areacode -- 国内长途区号
    ,nvl(n.phone, o.phone) as phone -- 电话号码
    ,nvl(n.subphone, o.subphone) as subphone -- 分机号
    ,nvl(n.servicephone, o.servicephone) as servicephone -- 服务电话
    ,nvl(n.funorgan, o.funorgan) as funorgan -- 职能机构
    ,nvl(n.fundep, o.fundep) as fundep -- 职能部门
    ,nvl(n.financiallicnum, o.financiallicnum) as financiallicnum -- 金融许可证编号
    ,nvl(n.organsystem, o.organsystem) as organsystem -- 机构关联系统
    ,nvl(n.orderno, o.orderno) as orderno -- 显示顺序号
    ,nvl(n.cbrcfininsttid, o.cbrcfininsttid) as cbrcfininsttid -- 银监会金融机构编号
    ,nvl(n.unionfinancialcode, o.unionfinancialcode) as unionfinancialcode -- 银联金融机构编号
    ,nvl(n.workstarttm, o.workstarttm) as workstarttm -- 工作开始时间
    ,nvl(n.workendtm, o.workendtm) as workendtm -- 工作结束时间
    ,nvl(n.bbuporgancode, o.bbuporgancode) as bbuporgancode -- 报表上级机构编号
    ,nvl(n.heademplyid, o.heademplyid) as heademplyid -- 负责人工号
    ,nvl(n.isxnhs, o.isxnhs) as isxnhs -- 是否为虚拟核算机构
    ,nvl(n.rhregcode, o.rhregcode) as rhregcode -- 人行地区码
    ,nvl(n.blngcitypbc, o.blngcitypbc) as blngcitypbc -- 所属城市(人行)
    ,nvl(n.bankcodeperson, o.bankcodeperson) as bankcodeperson -- 支付系统银行行号（用于个人结算账户报送）
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.hgls_gh_uus_organ_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.hgls_gh_uus_organ where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.organcodekey <> n.organcodekey
        or o.organcode <> n.organcode
        or o.zoneno <> n.zoneno
        or o.pbocfinancialcode <> n.pbocfinancialcode
        or o.financialcode <> n.financialcode
        or o.swiftcode <> n.swiftcode
        or o.bankcode <> n.bankcode
        or o.legal <> n.legal
        or o.businesslicense <> n.businesslicense
        or o.organizationcode <> n.organizationcode
        or o.taxid <> n.taxid
        or o.organcnfullname <> n.organcnfullname
        or o.organcnshortname <> n.organcnshortname
        or o.organenfullname <> n.organenfullname
        or o.organenshortname <> n.organenshortname
        or o.organstatecode <> n.organstatecode
        or o.organstatus <> n.organstatus
        or o.organfoundingdate <> n.organfoundingdate
        or o.organclosedate <> n.organclosedate
        or o.organtype <> n.organtype
        or o.isst <> n.isst
        or o.ishs <> n.ishs
        or o.isyy <> n.isyy
        or o.isxz <> n.isxz
        or o.iszw <> n.iszw
        or o.organlevel <> n.organlevel
        or o.leafnoteflag <> n.leafnoteflag
        or o.xzuporgancode <> n.xzuporgancode
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
        or o.bbuporgancode <> n.bbuporgancode
        or o.heademplyid <> n.heademplyid
        or o.isxnhs <> n.isxnhs
        or o.rhregcode <> n.rhregcode
        or o.blngcitypbc <> n.blngcitypbc
        or o.bankcodeperson <> n.bankcodeperson
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_gh_uus_organ_cl(
            id -- 主键id
            ,organcodekey -- 统一组织机构编码
            ,organcode -- 组织机构编号
            ,zoneno -- 分行号
            ,pbocfinancialcode -- 人行金融机构编码
            ,financialcode -- 金融机构标识码
            ,swiftcode -- SWIFT编号
            ,bankcode -- 人行支付行号
            ,legal -- 法人号
            ,businesslicense -- 营业执照号码
            ,organizationcode -- 组织机构代码
            ,taxid -- 税务登记证号
            ,organcnfullname -- 机构全称
            ,organcnshortname -- 机构简称
            ,organenfullname -- 组织机构英文全称
            ,organenshortname -- 组织机构英文简称
            ,organstatecode -- 机构营业状态
            ,organstatus -- 机构状态
            ,organfoundingdate -- 机构成立日期
            ,organclosedate -- 机构撤销日期
            ,organtype -- 组织机构类型
            ,isst -- 是否为实体机构
            ,ishs -- 是否为核算机构
            ,isyy -- 是否为报表机构
            ,isxz -- 是否为行政机构
            ,iszw -- 是否为混合机构
            ,organlevel -- 机构级别
            ,leafnoteflag -- 叶节点标志
            ,xzuporgancode -- 行政上级机构编号
            ,zwuporgancode -- 混合上级机构编号
            ,hsuporgancode -- 核算上级机构编号
            ,seque -- 机构顺序号
            ,postcode -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 所在县/区
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,url -- 网址
            ,countrycode -- 国际长途区号
            ,areacode -- 国内长途区号
            ,phone -- 电话号码
            ,subphone -- 分机号
            ,servicephone -- 服务电话
            ,funorgan -- 职能机构
            ,fundep -- 职能部门
            ,financiallicnum -- 金融许可证编号
            ,organsystem -- 机构关联系统
            ,orderno -- 显示顺序号
            ,cbrcfininsttid -- 银监会金融机构编号
            ,unionfinancialcode -- 银联金融机构编号
            ,workstarttm -- 工作开始时间
            ,workendtm -- 工作结束时间
            ,bbuporgancode -- 报表上级机构编号
            ,heademplyid -- 负责人工号
            ,isxnhs -- 是否为虚拟核算机构
            ,rhregcode -- 人行地区码
            ,blngcitypbc -- 所属城市(人行)
            ,bankcodeperson -- 支付系统银行行号（用于个人结算账户报送）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_gh_uus_organ_op(
            id -- 主键id
            ,organcodekey -- 统一组织机构编码
            ,organcode -- 组织机构编号
            ,zoneno -- 分行号
            ,pbocfinancialcode -- 人行金融机构编码
            ,financialcode -- 金融机构标识码
            ,swiftcode -- SWIFT编号
            ,bankcode -- 人行支付行号
            ,legal -- 法人号
            ,businesslicense -- 营业执照号码
            ,organizationcode -- 组织机构代码
            ,taxid -- 税务登记证号
            ,organcnfullname -- 机构全称
            ,organcnshortname -- 机构简称
            ,organenfullname -- 组织机构英文全称
            ,organenshortname -- 组织机构英文简称
            ,organstatecode -- 机构营业状态
            ,organstatus -- 机构状态
            ,organfoundingdate -- 机构成立日期
            ,organclosedate -- 机构撤销日期
            ,organtype -- 组织机构类型
            ,isst -- 是否为实体机构
            ,ishs -- 是否为核算机构
            ,isyy -- 是否为报表机构
            ,isxz -- 是否为行政机构
            ,iszw -- 是否为混合机构
            ,organlevel -- 机构级别
            ,leafnoteflag -- 叶节点标志
            ,xzuporgancode -- 行政上级机构编号
            ,zwuporgancode -- 混合上级机构编号
            ,hsuporgancode -- 核算上级机构编号
            ,seque -- 机构顺序号
            ,postcode -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 所在县/区
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,url -- 网址
            ,countrycode -- 国际长途区号
            ,areacode -- 国内长途区号
            ,phone -- 电话号码
            ,subphone -- 分机号
            ,servicephone -- 服务电话
            ,funorgan -- 职能机构
            ,fundep -- 职能部门
            ,financiallicnum -- 金融许可证编号
            ,organsystem -- 机构关联系统
            ,orderno -- 显示顺序号
            ,cbrcfininsttid -- 银监会金融机构编号
            ,unionfinancialcode -- 银联金融机构编号
            ,workstarttm -- 工作开始时间
            ,workendtm -- 工作结束时间
            ,bbuporgancode -- 报表上级机构编号
            ,heademplyid -- 负责人工号
            ,isxnhs -- 是否为虚拟核算机构
            ,rhregcode -- 人行地区码
            ,blngcitypbc -- 所属城市(人行)
            ,bankcodeperson -- 支付系统银行行号（用于个人结算账户报送）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键id
    ,o.organcodekey -- 统一组织机构编码
    ,o.organcode -- 组织机构编号
    ,o.zoneno -- 分行号
    ,o.pbocfinancialcode -- 人行金融机构编码
    ,o.financialcode -- 金融机构标识码
    ,o.swiftcode -- SWIFT编号
    ,o.bankcode -- 人行支付行号
    ,o.legal -- 法人号
    ,o.businesslicense -- 营业执照号码
    ,o.organizationcode -- 组织机构代码
    ,o.taxid -- 税务登记证号
    ,o.organcnfullname -- 机构全称
    ,o.organcnshortname -- 机构简称
    ,o.organenfullname -- 组织机构英文全称
    ,o.organenshortname -- 组织机构英文简称
    ,o.organstatecode -- 机构营业状态
    ,o.organstatus -- 机构状态
    ,o.organfoundingdate -- 机构成立日期
    ,o.organclosedate -- 机构撤销日期
    ,o.organtype -- 组织机构类型
    ,o.isst -- 是否为实体机构
    ,o.ishs -- 是否为核算机构
    ,o.isyy -- 是否为报表机构
    ,o.isxz -- 是否为行政机构
    ,o.iszw -- 是否为混合机构
    ,o.organlevel -- 机构级别
    ,o.leafnoteflag -- 叶节点标志
    ,o.xzuporgancode -- 行政上级机构编号
    ,o.zwuporgancode -- 混合上级机构编号
    ,o.hsuporgancode -- 核算上级机构编号
    ,o.seque -- 机构顺序号
    ,o.postcode -- 邮政编码
    ,o.country -- 所在国家
    ,o.province -- 所在省/州
    ,o.city -- 所在城市
    ,o.county -- 所在县/区
    ,o.address -- 详细地址
    ,o.email -- 电子邮箱
    ,o.url -- 网址
    ,o.countrycode -- 国际长途区号
    ,o.areacode -- 国内长途区号
    ,o.phone -- 电话号码
    ,o.subphone -- 分机号
    ,o.servicephone -- 服务电话
    ,o.funorgan -- 职能机构
    ,o.fundep -- 职能部门
    ,o.financiallicnum -- 金融许可证编号
    ,o.organsystem -- 机构关联系统
    ,o.orderno -- 显示顺序号
    ,o.cbrcfininsttid -- 银监会金融机构编号
    ,o.unionfinancialcode -- 银联金融机构编号
    ,o.workstarttm -- 工作开始时间
    ,o.workendtm -- 工作结束时间
    ,o.bbuporgancode -- 报表上级机构编号
    ,o.heademplyid -- 负责人工号
    ,o.isxnhs -- 是否为虚拟核算机构
    ,o.rhregcode -- 人行地区码
    ,o.blngcitypbc -- 所属城市(人行)
    ,o.bankcodeperson -- 支付系统银行行号（用于个人结算账户报送）
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
from ${iol_schema}.hgls_gh_uus_organ_bk o
    left join ${iol_schema}.hgls_gh_uus_organ_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.hgls_gh_uus_organ_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.hgls_gh_uus_organ;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('hgls_gh_uus_organ') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.hgls_gh_uus_organ drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.hgls_gh_uus_organ add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.hgls_gh_uus_organ exchange partition p_${batch_date} with table ${iol_schema}.hgls_gh_uus_organ_cl;
alter table ${iol_schema}.hgls_gh_uus_organ exchange partition p_20991231 with table ${iol_schema}.hgls_gh_uus_organ_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.hgls_gh_uus_organ to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_gh_uus_organ_op purge;
drop table ${iol_schema}.hgls_gh_uus_organ_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.hgls_gh_uus_organ_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'hgls_gh_uus_organ',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
