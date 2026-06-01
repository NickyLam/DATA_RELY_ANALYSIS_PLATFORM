/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_hqd_iqp_loan_prior
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
create table ${iol_schema}.icms_hqd_iqp_loan_prior_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_hqd_iqp_loan_prior
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_hqd_iqp_loan_prior_op purge;
drop table ${iol_schema}.icms_hqd_iqp_loan_prior_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_hqd_iqp_loan_prior_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_hqd_iqp_loan_prior where 0=1;

create table ${iol_schema}.icms_hqd_iqp_loan_prior_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_hqd_iqp_loan_prior where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_hqd_iqp_loan_prior_cl(
            serialno -- 业务流水号
            ,applyno -- 信贷申请流水号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,cusid -- 法人代表人客户号
            ,cusname -- 法人代表人姓名
            ,finalapplyamount -- 初审审批额度(元)
            ,inputdate -- 初审申请日期
            ,approvestatus -- 审批状态
            ,inputid -- 客户经理编号
            ,belongdept -- 所属分行名称
            ,appchannel -- 接入渠道
            ,birth -- 法人代表人出生日期
            ,certtype -- 法人代表人证件类型
            ,certno -- 法人代表人证件号码
            ,gender -- 法人代表人性别
            ,phone -- 法人代表人联系号码
            ,issdate -- 签发日期
            ,expirydate -- 借款人证件到期日
            ,dwellprovincecode -- 居住地址所在省份编码
            ,dwellcitycode -- 居住地址所在城市编码
            ,dwellareacode -- 居住地址所在区域编码
            ,dwelladdress -- 居住详细地址
            ,career -- 职业
            ,nationality -- 国籍
            ,entname -- 企业名称
            ,creditcode -- 统一社会信用代码
            ,taxno -- 纳税人识别号
            ,taxflag -- 税务查询标志(深圳/广东税务局)
            ,applyflag -- 是否授权
            ,taxapplyno -- 税务查询授权流水号
            ,productchannel -- 产品分类标志
            ,attribute1 -- 备用字段1
            ,attribute2 -- 备用字段2
            ,attribute3 -- 备用字段3
            ,attribute4 -- 备用字段4
            ,attribute5 -- 备用字段5
            ,sysid -- 系统来源
            ,qryopertp -- 查询操作申请类型
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,warninginfo -- 预警信息
            ,failreason -- 拒绝原因
            ,businessscope -- 经营范围
            ,businessvalidity -- 经营有效期（区间）
            ,registeredaddress -- 注册地址
            ,issmallent -- 是否小微企业
            ,inputorgid -- 登记机构
            ,nextyearincome -- 预测次年销售收入
            ,otherincome -- 其他渠道提供的营运资金
            ,informflag -- 是否通知
            ,applyenddate -- 初审结束日期
            ,registerdate -- 企业注册时间
            ,entmouthprice -- 每月租金金额
            ,entmouth -- 企业入驻月份数
            ,scale -- 企业规模
            ,proceeds -- 经营收入
            ,autoscore -- 评分分值
            ,gongancheckresult -- 公安联网核查结果
            ,mybankaffiliateflag -- 是否我行关联人
            ,zhengxincheckresult -- 征信校验结果
            ,baserialno -- 授信表流水号
            ,status -- 初审状态
            ,tradecode -- 行业类型
            ,empcountyear -- 从业人数
            ,tatalasset -- 资产合计
            ,enreportimage -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_hqd_iqp_loan_prior_op(
            serialno -- 业务流水号
            ,applyno -- 信贷申请流水号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,cusid -- 法人代表人客户号
            ,cusname -- 法人代表人姓名
            ,finalapplyamount -- 初审审批额度(元)
            ,inputdate -- 初审申请日期
            ,approvestatus -- 审批状态
            ,inputid -- 客户经理编号
            ,belongdept -- 所属分行名称
            ,appchannel -- 接入渠道
            ,birth -- 法人代表人出生日期
            ,certtype -- 法人代表人证件类型
            ,certno -- 法人代表人证件号码
            ,gender -- 法人代表人性别
            ,phone -- 法人代表人联系号码
            ,issdate -- 签发日期
            ,expirydate -- 借款人证件到期日
            ,dwellprovincecode -- 居住地址所在省份编码
            ,dwellcitycode -- 居住地址所在城市编码
            ,dwellareacode -- 居住地址所在区域编码
            ,dwelladdress -- 居住详细地址
            ,career -- 职业
            ,nationality -- 国籍
            ,entname -- 企业名称
            ,creditcode -- 统一社会信用代码
            ,taxno -- 纳税人识别号
            ,taxflag -- 税务查询标志(深圳/广东税务局)
            ,applyflag -- 是否授权
            ,taxapplyno -- 税务查询授权流水号
            ,productchannel -- 产品分类标志
            ,attribute1 -- 备用字段1
            ,attribute2 -- 备用字段2
            ,attribute3 -- 备用字段3
            ,attribute4 -- 备用字段4
            ,attribute5 -- 备用字段5
            ,sysid -- 系统来源
            ,qryopertp -- 查询操作申请类型
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,warninginfo -- 预警信息
            ,failreason -- 拒绝原因
            ,businessscope -- 经营范围
            ,businessvalidity -- 经营有效期（区间）
            ,registeredaddress -- 注册地址
            ,issmallent -- 是否小微企业
            ,inputorgid -- 登记机构
            ,nextyearincome -- 预测次年销售收入
            ,otherincome -- 其他渠道提供的营运资金
            ,informflag -- 是否通知
            ,applyenddate -- 初审结束日期
            ,registerdate -- 企业注册时间
            ,entmouthprice -- 每月租金金额
            ,entmouth -- 企业入驻月份数
            ,scale -- 企业规模
            ,proceeds -- 经营收入
            ,autoscore -- 评分分值
            ,gongancheckresult -- 公安联网核查结果
            ,mybankaffiliateflag -- 是否我行关联人
            ,zhengxincheckresult -- 征信校验结果
            ,baserialno -- 授信表流水号
            ,status -- 初审状态
            ,tradecode -- 行业类型
            ,empcountyear -- 从业人数
            ,tatalasset -- 资产合计
            ,enreportimage -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 业务流水号
    ,nvl(n.applyno, o.applyno) as applyno -- 信贷申请流水号
    ,nvl(n.prdcode, o.prdcode) as prdcode -- 产品编号
    ,nvl(n.prdname, o.prdname) as prdname -- 产品名称
    ,nvl(n.cusid, o.cusid) as cusid -- 法人代表人客户号
    ,nvl(n.cusname, o.cusname) as cusname -- 法人代表人姓名
    ,nvl(n.finalapplyamount, o.finalapplyamount) as finalapplyamount -- 初审审批额度(元)
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 初审申请日期
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.inputid, o.inputid) as inputid -- 客户经理编号
    ,nvl(n.belongdept, o.belongdept) as belongdept -- 所属分行名称
    ,nvl(n.appchannel, o.appchannel) as appchannel -- 接入渠道
    ,nvl(n.birth, o.birth) as birth -- 法人代表人出生日期
    ,nvl(n.certtype, o.certtype) as certtype -- 法人代表人证件类型
    ,nvl(n.certno, o.certno) as certno -- 法人代表人证件号码
    ,nvl(n.gender, o.gender) as gender -- 法人代表人性别
    ,nvl(n.phone, o.phone) as phone -- 法人代表人联系号码
    ,nvl(n.issdate, o.issdate) as issdate -- 签发日期
    ,nvl(n.expirydate, o.expirydate) as expirydate -- 借款人证件到期日
    ,nvl(n.dwellprovincecode, o.dwellprovincecode) as dwellprovincecode -- 居住地址所在省份编码
    ,nvl(n.dwellcitycode, o.dwellcitycode) as dwellcitycode -- 居住地址所在城市编码
    ,nvl(n.dwellareacode, o.dwellareacode) as dwellareacode -- 居住地址所在区域编码
    ,nvl(n.dwelladdress, o.dwelladdress) as dwelladdress -- 居住详细地址
    ,nvl(n.career, o.career) as career -- 职业
    ,nvl(n.nationality, o.nationality) as nationality -- 国籍
    ,nvl(n.entname, o.entname) as entname -- 企业名称
    ,nvl(n.creditcode, o.creditcode) as creditcode -- 统一社会信用代码
    ,nvl(n.taxno, o.taxno) as taxno -- 纳税人识别号
    ,nvl(n.taxflag, o.taxflag) as taxflag -- 税务查询标志(深圳/广东税务局)
    ,nvl(n.applyflag, o.applyflag) as applyflag -- 是否授权
    ,nvl(n.taxapplyno, o.taxapplyno) as taxapplyno -- 税务查询授权流水号
    ,nvl(n.productchannel, o.productchannel) as productchannel -- 产品分类标志
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 备用字段1
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 备用字段2
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 备用字段3
    ,nvl(n.attribute4, o.attribute4) as attribute4 -- 备用字段4
    ,nvl(n.attribute5, o.attribute5) as attribute5 -- 备用字段5
    ,nvl(n.sysid, o.sysid) as sysid -- 系统来源
    ,nvl(n.qryopertp, o.qryopertp) as qryopertp -- 查询操作申请类型
    ,nvl(n.authotype, o.authotype) as authotype -- 授权方式
    ,nvl(n.biometrics, o.biometrics) as biometrics -- 生物识别技术
    ,nvl(n.authotime, o.authotime) as authotime -- 授权时间
    ,nvl(n.authostrdate, o.authostrdate) as authostrdate -- 授权开始时间
    ,nvl(n.authoenddate, o.authoenddate) as authoenddate -- 授权结束时间
    ,nvl(n.warninginfo, o.warninginfo) as warninginfo -- 预警信息
    ,nvl(n.failreason, o.failreason) as failreason -- 拒绝原因
    ,nvl(n.businessscope, o.businessscope) as businessscope -- 经营范围
    ,nvl(n.businessvalidity, o.businessvalidity) as businessvalidity -- 经营有效期（区间）
    ,nvl(n.registeredaddress, o.registeredaddress) as registeredaddress -- 注册地址
    ,nvl(n.issmallent, o.issmallent) as issmallent -- 是否小微企业
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.nextyearincome, o.nextyearincome) as nextyearincome -- 预测次年销售收入
    ,nvl(n.otherincome, o.otherincome) as otherincome -- 其他渠道提供的营运资金
    ,nvl(n.informflag, o.informflag) as informflag -- 是否通知
    ,nvl(n.applyenddate, o.applyenddate) as applyenddate -- 初审结束日期
    ,nvl(n.registerdate, o.registerdate) as registerdate -- 企业注册时间
    ,nvl(n.entmouthprice, o.entmouthprice) as entmouthprice -- 每月租金金额
    ,nvl(n.entmouth, o.entmouth) as entmouth -- 企业入驻月份数
    ,nvl(n.scale, o.scale) as scale -- 企业规模
    ,nvl(n.proceeds, o.proceeds) as proceeds -- 经营收入
    ,nvl(n.autoscore, o.autoscore) as autoscore -- 评分分值
    ,nvl(n.gongancheckresult, o.gongancheckresult) as gongancheckresult -- 公安联网核查结果
    ,nvl(n.mybankaffiliateflag, o.mybankaffiliateflag) as mybankaffiliateflag -- 是否我行关联人
    ,nvl(n.zhengxincheckresult, o.zhengxincheckresult) as zhengxincheckresult -- 征信校验结果
    ,nvl(n.baserialno, o.baserialno) as baserialno -- 授信表流水号
    ,nvl(n.status, o.status) as status -- 初审状态
    ,nvl(n.tradecode, o.tradecode) as tradecode -- 行业类型
    ,nvl(n.empcountyear, o.empcountyear) as empcountyear -- 从业人数
    ,nvl(n.tatalasset, o.tatalasset) as tatalasset -- 资产合计
    ,nvl(n.enreportimage, o.enreportimage) as enreportimage -- 
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_hqd_iqp_loan_prior_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_hqd_iqp_loan_prior where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.applyno <> n.applyno
        or o.prdcode <> n.prdcode
        or o.prdname <> n.prdname
        or o.cusid <> n.cusid
        or o.cusname <> n.cusname
        or o.finalapplyamount <> n.finalapplyamount
        or o.inputdate <> n.inputdate
        or o.approvestatus <> n.approvestatus
        or o.inputid <> n.inputid
        or o.belongdept <> n.belongdept
        or o.appchannel <> n.appchannel
        or o.birth <> n.birth
        or o.certtype <> n.certtype
        or o.certno <> n.certno
        or o.gender <> n.gender
        or o.phone <> n.phone
        or o.issdate <> n.issdate
        or o.expirydate <> n.expirydate
        or o.dwellprovincecode <> n.dwellprovincecode
        or o.dwellcitycode <> n.dwellcitycode
        or o.dwellareacode <> n.dwellareacode
        or o.dwelladdress <> n.dwelladdress
        or o.career <> n.career
        or o.nationality <> n.nationality
        or o.entname <> n.entname
        or o.creditcode <> n.creditcode
        or o.taxno <> n.taxno
        or o.taxflag <> n.taxflag
        or o.applyflag <> n.applyflag
        or o.taxapplyno <> n.taxapplyno
        or o.productchannel <> n.productchannel
        or o.attribute1 <> n.attribute1
        or o.attribute2 <> n.attribute2
        or o.attribute3 <> n.attribute3
        or o.attribute4 <> n.attribute4
        or o.attribute5 <> n.attribute5
        or o.sysid <> n.sysid
        or o.qryopertp <> n.qryopertp
        or o.authotype <> n.authotype
        or o.biometrics <> n.biometrics
        or o.authotime <> n.authotime
        or o.authostrdate <> n.authostrdate
        or o.authoenddate <> n.authoenddate
        or o.warninginfo <> n.warninginfo
        or o.failreason <> n.failreason
        or o.businessscope <> n.businessscope
        or o.businessvalidity <> n.businessvalidity
        or o.registeredaddress <> n.registeredaddress
        or o.issmallent <> n.issmallent
        or o.inputorgid <> n.inputorgid
        or o.nextyearincome <> n.nextyearincome
        or o.otherincome <> n.otherincome
        or o.informflag <> n.informflag
        or o.applyenddate <> n.applyenddate
        or o.registerdate <> n.registerdate
        or o.entmouthprice <> n.entmouthprice
        or o.entmouth <> n.entmouth
        or o.scale <> n.scale
        or o.proceeds <> n.proceeds
        or o.autoscore <> n.autoscore
        or o.gongancheckresult <> n.gongancheckresult
        or o.mybankaffiliateflag <> n.mybankaffiliateflag
        or o.zhengxincheckresult <> n.zhengxincheckresult
        or o.baserialno <> n.baserialno
        or o.status <> n.status
        or o.tradecode <> n.tradecode
        or o.empcountyear <> n.empcountyear
        or o.tatalasset <> n.tatalasset
        or o.enreportimage <> n.enreportimage
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_hqd_iqp_loan_prior_cl(
            serialno -- 业务流水号
            ,applyno -- 信贷申请流水号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,cusid -- 法人代表人客户号
            ,cusname -- 法人代表人姓名
            ,finalapplyamount -- 初审审批额度(元)
            ,inputdate -- 初审申请日期
            ,approvestatus -- 审批状态
            ,inputid -- 客户经理编号
            ,belongdept -- 所属分行名称
            ,appchannel -- 接入渠道
            ,birth -- 法人代表人出生日期
            ,certtype -- 法人代表人证件类型
            ,certno -- 法人代表人证件号码
            ,gender -- 法人代表人性别
            ,phone -- 法人代表人联系号码
            ,issdate -- 签发日期
            ,expirydate -- 借款人证件到期日
            ,dwellprovincecode -- 居住地址所在省份编码
            ,dwellcitycode -- 居住地址所在城市编码
            ,dwellareacode -- 居住地址所在区域编码
            ,dwelladdress -- 居住详细地址
            ,career -- 职业
            ,nationality -- 国籍
            ,entname -- 企业名称
            ,creditcode -- 统一社会信用代码
            ,taxno -- 纳税人识别号
            ,taxflag -- 税务查询标志(深圳/广东税务局)
            ,applyflag -- 是否授权
            ,taxapplyno -- 税务查询授权流水号
            ,productchannel -- 产品分类标志
            ,attribute1 -- 备用字段1
            ,attribute2 -- 备用字段2
            ,attribute3 -- 备用字段3
            ,attribute4 -- 备用字段4
            ,attribute5 -- 备用字段5
            ,sysid -- 系统来源
            ,qryopertp -- 查询操作申请类型
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,warninginfo -- 预警信息
            ,failreason -- 拒绝原因
            ,businessscope -- 经营范围
            ,businessvalidity -- 经营有效期（区间）
            ,registeredaddress -- 注册地址
            ,issmallent -- 是否小微企业
            ,inputorgid -- 登记机构
            ,nextyearincome -- 预测次年销售收入
            ,otherincome -- 其他渠道提供的营运资金
            ,informflag -- 是否通知
            ,applyenddate -- 初审结束日期
            ,registerdate -- 企业注册时间
            ,entmouthprice -- 每月租金金额
            ,entmouth -- 企业入驻月份数
            ,scale -- 企业规模
            ,proceeds -- 经营收入
            ,autoscore -- 评分分值
            ,gongancheckresult -- 公安联网核查结果
            ,mybankaffiliateflag -- 是否我行关联人
            ,zhengxincheckresult -- 征信校验结果
            ,baserialno -- 授信表流水号
            ,status -- 初审状态
            ,tradecode -- 行业类型
            ,empcountyear -- 从业人数
            ,tatalasset -- 资产合计
            ,enreportimage -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_hqd_iqp_loan_prior_op(
            serialno -- 业务流水号
            ,applyno -- 信贷申请流水号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,cusid -- 法人代表人客户号
            ,cusname -- 法人代表人姓名
            ,finalapplyamount -- 初审审批额度(元)
            ,inputdate -- 初审申请日期
            ,approvestatus -- 审批状态
            ,inputid -- 客户经理编号
            ,belongdept -- 所属分行名称
            ,appchannel -- 接入渠道
            ,birth -- 法人代表人出生日期
            ,certtype -- 法人代表人证件类型
            ,certno -- 法人代表人证件号码
            ,gender -- 法人代表人性别
            ,phone -- 法人代表人联系号码
            ,issdate -- 签发日期
            ,expirydate -- 借款人证件到期日
            ,dwellprovincecode -- 居住地址所在省份编码
            ,dwellcitycode -- 居住地址所在城市编码
            ,dwellareacode -- 居住地址所在区域编码
            ,dwelladdress -- 居住详细地址
            ,career -- 职业
            ,nationality -- 国籍
            ,entname -- 企业名称
            ,creditcode -- 统一社会信用代码
            ,taxno -- 纳税人识别号
            ,taxflag -- 税务查询标志(深圳/广东税务局)
            ,applyflag -- 是否授权
            ,taxapplyno -- 税务查询授权流水号
            ,productchannel -- 产品分类标志
            ,attribute1 -- 备用字段1
            ,attribute2 -- 备用字段2
            ,attribute3 -- 备用字段3
            ,attribute4 -- 备用字段4
            ,attribute5 -- 备用字段5
            ,sysid -- 系统来源
            ,qryopertp -- 查询操作申请类型
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,warninginfo -- 预警信息
            ,failreason -- 拒绝原因
            ,businessscope -- 经营范围
            ,businessvalidity -- 经营有效期（区间）
            ,registeredaddress -- 注册地址
            ,issmallent -- 是否小微企业
            ,inputorgid -- 登记机构
            ,nextyearincome -- 预测次年销售收入
            ,otherincome -- 其他渠道提供的营运资金
            ,informflag -- 是否通知
            ,applyenddate -- 初审结束日期
            ,registerdate -- 企业注册时间
            ,entmouthprice -- 每月租金金额
            ,entmouth -- 企业入驻月份数
            ,scale -- 企业规模
            ,proceeds -- 经营收入
            ,autoscore -- 评分分值
            ,gongancheckresult -- 公安联网核查结果
            ,mybankaffiliateflag -- 是否我行关联人
            ,zhengxincheckresult -- 征信校验结果
            ,baserialno -- 授信表流水号
            ,status -- 初审状态
            ,tradecode -- 行业类型
            ,empcountyear -- 从业人数
            ,tatalasset -- 资产合计
            ,enreportimage -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 业务流水号
    ,o.applyno -- 信贷申请流水号
    ,o.prdcode -- 产品编号
    ,o.prdname -- 产品名称
    ,o.cusid -- 法人代表人客户号
    ,o.cusname -- 法人代表人姓名
    ,o.finalapplyamount -- 初审审批额度(元)
    ,o.inputdate -- 初审申请日期
    ,o.approvestatus -- 审批状态
    ,o.inputid -- 客户经理编号
    ,o.belongdept -- 所属分行名称
    ,o.appchannel -- 接入渠道
    ,o.birth -- 法人代表人出生日期
    ,o.certtype -- 法人代表人证件类型
    ,o.certno -- 法人代表人证件号码
    ,o.gender -- 法人代表人性别
    ,o.phone -- 法人代表人联系号码
    ,o.issdate -- 签发日期
    ,o.expirydate -- 借款人证件到期日
    ,o.dwellprovincecode -- 居住地址所在省份编码
    ,o.dwellcitycode -- 居住地址所在城市编码
    ,o.dwellareacode -- 居住地址所在区域编码
    ,o.dwelladdress -- 居住详细地址
    ,o.career -- 职业
    ,o.nationality -- 国籍
    ,o.entname -- 企业名称
    ,o.creditcode -- 统一社会信用代码
    ,o.taxno -- 纳税人识别号
    ,o.taxflag -- 税务查询标志(深圳/广东税务局)
    ,o.applyflag -- 是否授权
    ,o.taxapplyno -- 税务查询授权流水号
    ,o.productchannel -- 产品分类标志
    ,o.attribute1 -- 备用字段1
    ,o.attribute2 -- 备用字段2
    ,o.attribute3 -- 备用字段3
    ,o.attribute4 -- 备用字段4
    ,o.attribute5 -- 备用字段5
    ,o.sysid -- 系统来源
    ,o.qryopertp -- 查询操作申请类型
    ,o.authotype -- 授权方式
    ,o.biometrics -- 生物识别技术
    ,o.authotime -- 授权时间
    ,o.authostrdate -- 授权开始时间
    ,o.authoenddate -- 授权结束时间
    ,o.warninginfo -- 预警信息
    ,o.failreason -- 拒绝原因
    ,o.businessscope -- 经营范围
    ,o.businessvalidity -- 经营有效期（区间）
    ,o.registeredaddress -- 注册地址
    ,o.issmallent -- 是否小微企业
    ,o.inputorgid -- 登记机构
    ,o.nextyearincome -- 预测次年销售收入
    ,o.otherincome -- 其他渠道提供的营运资金
    ,o.informflag -- 是否通知
    ,o.applyenddate -- 初审结束日期
    ,o.registerdate -- 企业注册时间
    ,o.entmouthprice -- 每月租金金额
    ,o.entmouth -- 企业入驻月份数
    ,o.scale -- 企业规模
    ,o.proceeds -- 经营收入
    ,o.autoscore -- 评分分值
    ,o.gongancheckresult -- 公安联网核查结果
    ,o.mybankaffiliateflag -- 是否我行关联人
    ,o.zhengxincheckresult -- 征信校验结果
    ,o.baserialno -- 授信表流水号
    ,o.status -- 初审状态
    ,o.tradecode -- 行业类型
    ,o.empcountyear -- 从业人数
    ,o.tatalasset -- 资产合计
    ,o.enreportimage -- 
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
from ${iol_schema}.icms_hqd_iqp_loan_prior_bk o
    left join ${iol_schema}.icms_hqd_iqp_loan_prior_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_hqd_iqp_loan_prior_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_hqd_iqp_loan_prior;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_hqd_iqp_loan_prior') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_hqd_iqp_loan_prior drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_hqd_iqp_loan_prior add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_hqd_iqp_loan_prior exchange partition p_${batch_date} with table ${iol_schema}.icms_hqd_iqp_loan_prior_cl;
alter table ${iol_schema}.icms_hqd_iqp_loan_prior exchange partition p_20991231 with table ${iol_schema}.icms_hqd_iqp_loan_prior_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_hqd_iqp_loan_prior to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_hqd_iqp_loan_prior_op purge;
drop table ${iol_schema}.icms_hqd_iqp_loan_prior_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_hqd_iqp_loan_prior_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_hqd_iqp_loan_prior',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
