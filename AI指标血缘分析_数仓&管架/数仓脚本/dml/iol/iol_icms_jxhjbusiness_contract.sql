/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_jxhjbusiness_contract
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
create table ${iol_schema}.icms_jxhjbusiness_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_jxhjbusiness_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_jxhjbusiness_contract_op purge;
drop table ${iol_schema}.icms_jxhjbusiness_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_jxhjbusiness_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_jxhjbusiness_contract where 0=1;

create table ${iol_schema}.icms_jxhjbusiness_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_jxhjbusiness_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_jxhjbusiness_contract_cl(
            serialno -- 流水号
            ,purpose -- 用途
            ,contextinfo -- 提款说明
            ,direction -- 行业投向
            ,operateorgid -- 经办机构
            ,sfgjxzhy -- 是否国家限制行业
            ,vouchtype -- 主要担保方式
            ,updatedate -- 更新日期
            ,balance -- 合同余额(元)
            ,ifgudingcredit -- 是否固定资产授信
            ,classifyresulteleven -- 风险分类
            ,manageorgid -- 贷后管理机构
            ,maturity -- 合同到期日
            ,relativebcserialno -- 关联新业务合同流水号
            ,businesstype -- 业务品种
            ,guarantytype -- 担保/操作模式
            ,sfzfsx -- 是否政府授信
            ,relativebaserialno -- 关联新申请流水号
            ,pigeonholedate -- 归档日期
            ,businesscurrency -- 合同币种
            ,operatedate -- 经办时间
            ,useproduct -- 使用产品（贸易融资）
            ,sfgksx -- 是否国开行授信
            ,inputorgid -- 登记机构
            ,corpuspaymethod -- 还款方式
            ,mainproduct -- 经营商品（贸易融资）
            ,operateuserid -- 经办人
            ,zfsxlx -- 政府授信类型
            ,bailratio -- 保证金比例(%)
            ,bapbailratio -- 批复保证金比例(%)
            ,businesssum -- 合同金额(元)-申请阶段
            ,creditattribute -- 合同类型
            ,customerid -- 客户编号
            ,gksxpz -- 国开授信品种
            ,importantloan -- 重点贷款项目
            ,manageuserid -- 贷后管理人员
            ,othercondition -- 其他条件和要求
            ,paysource -- 还款说明
            ,inputuserid -- 登记人
            ,gshy -- 过剩行业
            ,guarantyhouse -- 抵押房产套数
            ,interestrateexplain -- 利率说明
            ,vouchtype1 -- 担保方式（内部口径）
            ,inputdate -- 登记日期
            ,relativebapserialno -- 关联新批复流水号
            ,isimportantloan -- 是否重点项目贷款
            ,lowrisk -- 是否低风险业务
            ,financesupportmode -- 贷款财政扶持方式
            ,putoutdate -- 合同起始日
            ,termmonth -- 期限(月)
            ,baptermmonth -- 批复期限(月)
            ,zfsxfs -- 政府授信支持方式
            ,migtflag -- 
            ,bapbusinesssum -- 合同金额(元)-批复阶段
            ,remark -- 备注
            ,artificialno -- 合同文本编号
            ,drawingtype -- 提款方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_jxhjbusiness_contract_op(
            serialno -- 流水号
            ,purpose -- 用途
            ,contextinfo -- 提款说明
            ,direction -- 行业投向
            ,operateorgid -- 经办机构
            ,sfgjxzhy -- 是否国家限制行业
            ,vouchtype -- 主要担保方式
            ,updatedate -- 更新日期
            ,balance -- 合同余额(元)
            ,ifgudingcredit -- 是否固定资产授信
            ,classifyresulteleven -- 风险分类
            ,manageorgid -- 贷后管理机构
            ,maturity -- 合同到期日
            ,relativebcserialno -- 关联新业务合同流水号
            ,businesstype -- 业务品种
            ,guarantytype -- 担保/操作模式
            ,sfzfsx -- 是否政府授信
            ,relativebaserialno -- 关联新申请流水号
            ,pigeonholedate -- 归档日期
            ,businesscurrency -- 合同币种
            ,operatedate -- 经办时间
            ,useproduct -- 使用产品（贸易融资）
            ,sfgksx -- 是否国开行授信
            ,inputorgid -- 登记机构
            ,corpuspaymethod -- 还款方式
            ,mainproduct -- 经营商品（贸易融资）
            ,operateuserid -- 经办人
            ,zfsxlx -- 政府授信类型
            ,bailratio -- 保证金比例(%)
            ,bapbailratio -- 批复保证金比例(%)
            ,businesssum -- 合同金额(元)-申请阶段
            ,creditattribute -- 合同类型
            ,customerid -- 客户编号
            ,gksxpz -- 国开授信品种
            ,importantloan -- 重点贷款项目
            ,manageuserid -- 贷后管理人员
            ,othercondition -- 其他条件和要求
            ,paysource -- 还款说明
            ,inputuserid -- 登记人
            ,gshy -- 过剩行业
            ,guarantyhouse -- 抵押房产套数
            ,interestrateexplain -- 利率说明
            ,vouchtype1 -- 担保方式（内部口径）
            ,inputdate -- 登记日期
            ,relativebapserialno -- 关联新批复流水号
            ,isimportantloan -- 是否重点项目贷款
            ,lowrisk -- 是否低风险业务
            ,financesupportmode -- 贷款财政扶持方式
            ,putoutdate -- 合同起始日
            ,termmonth -- 期限(月)
            ,baptermmonth -- 批复期限(月)
            ,zfsxfs -- 政府授信支持方式
            ,migtflag -- 
            ,bapbusinesssum -- 合同金额(元)-批复阶段
            ,remark -- 备注
            ,artificialno -- 合同文本编号
            ,drawingtype -- 提款方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.purpose, o.purpose) as purpose -- 用途
    ,nvl(n.contextinfo, o.contextinfo) as contextinfo -- 提款说明
    ,nvl(n.direction, o.direction) as direction -- 行业投向
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办机构
    ,nvl(n.sfgjxzhy, o.sfgjxzhy) as sfgjxzhy -- 是否国家限制行业
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 主要担保方式
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.balance, o.balance) as balance -- 合同余额(元)
    ,nvl(n.ifgudingcredit, o.ifgudingcredit) as ifgudingcredit -- 是否固定资产授信
    ,nvl(n.classifyresulteleven, o.classifyresulteleven) as classifyresulteleven -- 风险分类
    ,nvl(n.manageorgid, o.manageorgid) as manageorgid -- 贷后管理机构
    ,nvl(n.maturity, o.maturity) as maturity -- 合同到期日
    ,nvl(n.relativebcserialno, o.relativebcserialno) as relativebcserialno -- 关联新业务合同流水号
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务品种
    ,nvl(n.guarantytype, o.guarantytype) as guarantytype -- 担保/操作模式
    ,nvl(n.sfzfsx, o.sfzfsx) as sfzfsx -- 是否政府授信
    ,nvl(n.relativebaserialno, o.relativebaserialno) as relativebaserialno -- 关联新申请流水号
    ,nvl(n.pigeonholedate, o.pigeonholedate) as pigeonholedate -- 归档日期
    ,nvl(n.businesscurrency, o.businesscurrency) as businesscurrency -- 合同币种
    ,nvl(n.operatedate, o.operatedate) as operatedate -- 经办时间
    ,nvl(n.useproduct, o.useproduct) as useproduct -- 使用产品（贸易融资）
    ,nvl(n.sfgksx, o.sfgksx) as sfgksx -- 是否国开行授信
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.corpuspaymethod, o.corpuspaymethod) as corpuspaymethod -- 还款方式
    ,nvl(n.mainproduct, o.mainproduct) as mainproduct -- 经营商品（贸易融资）
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 经办人
    ,nvl(n.zfsxlx, o.zfsxlx) as zfsxlx -- 政府授信类型
    ,nvl(n.bailratio, o.bailratio) as bailratio -- 保证金比例(%)
    ,nvl(n.bapbailratio, o.bapbailratio) as bapbailratio -- 批复保证金比例(%)
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 合同金额(元)-申请阶段
    ,nvl(n.creditattribute, o.creditattribute) as creditattribute -- 合同类型
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.gksxpz, o.gksxpz) as gksxpz -- 国开授信品种
    ,nvl(n.importantloan, o.importantloan) as importantloan -- 重点贷款项目
    ,nvl(n.manageuserid, o.manageuserid) as manageuserid -- 贷后管理人员
    ,nvl(n.othercondition, o.othercondition) as othercondition -- 其他条件和要求
    ,nvl(n.paysource, o.paysource) as paysource -- 还款说明
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.gshy, o.gshy) as gshy -- 过剩行业
    ,nvl(n.guarantyhouse, o.guarantyhouse) as guarantyhouse -- 抵押房产套数
    ,nvl(n.interestrateexplain, o.interestrateexplain) as interestrateexplain -- 利率说明
    ,nvl(n.vouchtype1, o.vouchtype1) as vouchtype1 -- 担保方式（内部口径）
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.relativebapserialno, o.relativebapserialno) as relativebapserialno -- 关联新批复流水号
    ,nvl(n.isimportantloan, o.isimportantloan) as isimportantloan -- 是否重点项目贷款
    ,nvl(n.lowrisk, o.lowrisk) as lowrisk -- 是否低风险业务
    ,nvl(n.financesupportmode, o.financesupportmode) as financesupportmode -- 贷款财政扶持方式
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 合同起始日
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限(月)
    ,nvl(n.baptermmonth, o.baptermmonth) as baptermmonth -- 批复期限(月)
    ,nvl(n.zfsxfs, o.zfsxfs) as zfsxfs -- 政府授信支持方式
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.bapbusinesssum, o.bapbusinesssum) as bapbusinesssum -- 合同金额(元)-批复阶段
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.artificialno, o.artificialno) as artificialno -- 合同文本编号
    ,nvl(n.drawingtype, o.drawingtype) as drawingtype -- 提款方式
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
from (select * from ${iol_schema}.icms_jxhjbusiness_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_jxhjbusiness_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.purpose <> n.purpose
        or o.contextinfo <> n.contextinfo
        or o.direction <> n.direction
        or o.operateorgid <> n.operateorgid
        or o.sfgjxzhy <> n.sfgjxzhy
        or o.vouchtype <> n.vouchtype
        or o.updatedate <> n.updatedate
        or o.balance <> n.balance
        or o.ifgudingcredit <> n.ifgudingcredit
        or o.classifyresulteleven <> n.classifyresulteleven
        or o.manageorgid <> n.manageorgid
        or o.maturity <> n.maturity
        or o.relativebcserialno <> n.relativebcserialno
        or o.businesstype <> n.businesstype
        or o.guarantytype <> n.guarantytype
        or o.sfzfsx <> n.sfzfsx
        or o.relativebaserialno <> n.relativebaserialno
        or o.pigeonholedate <> n.pigeonholedate
        or o.businesscurrency <> n.businesscurrency
        or o.operatedate <> n.operatedate
        or o.useproduct <> n.useproduct
        or o.sfgksx <> n.sfgksx
        or o.inputorgid <> n.inputorgid
        or o.corpuspaymethod <> n.corpuspaymethod
        or o.mainproduct <> n.mainproduct
        or o.operateuserid <> n.operateuserid
        or o.zfsxlx <> n.zfsxlx
        or o.bailratio <> n.bailratio
        or o.bapbailratio <> n.bapbailratio
        or o.businesssum <> n.businesssum
        or o.creditattribute <> n.creditattribute
        or o.customerid <> n.customerid
        or o.gksxpz <> n.gksxpz
        or o.importantloan <> n.importantloan
        or o.manageuserid <> n.manageuserid
        or o.othercondition <> n.othercondition
        or o.paysource <> n.paysource
        or o.inputuserid <> n.inputuserid
        or o.gshy <> n.gshy
        or o.guarantyhouse <> n.guarantyhouse
        or o.interestrateexplain <> n.interestrateexplain
        or o.vouchtype1 <> n.vouchtype1
        or o.inputdate <> n.inputdate
        or o.relativebapserialno <> n.relativebapserialno
        or o.isimportantloan <> n.isimportantloan
        or o.lowrisk <> n.lowrisk
        or o.financesupportmode <> n.financesupportmode
        or o.putoutdate <> n.putoutdate
        or o.termmonth <> n.termmonth
        or o.baptermmonth <> n.baptermmonth
        or o.zfsxfs <> n.zfsxfs
        or o.migtflag <> n.migtflag
        or o.bapbusinesssum <> n.bapbusinesssum
        or o.remark <> n.remark
        or o.artificialno <> n.artificialno
        or o.drawingtype <> n.drawingtype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_jxhjbusiness_contract_cl(
            serialno -- 流水号
            ,purpose -- 用途
            ,contextinfo -- 提款说明
            ,direction -- 行业投向
            ,operateorgid -- 经办机构
            ,sfgjxzhy -- 是否国家限制行业
            ,vouchtype -- 主要担保方式
            ,updatedate -- 更新日期
            ,balance -- 合同余额(元)
            ,ifgudingcredit -- 是否固定资产授信
            ,classifyresulteleven -- 风险分类
            ,manageorgid -- 贷后管理机构
            ,maturity -- 合同到期日
            ,relativebcserialno -- 关联新业务合同流水号
            ,businesstype -- 业务品种
            ,guarantytype -- 担保/操作模式
            ,sfzfsx -- 是否政府授信
            ,relativebaserialno -- 关联新申请流水号
            ,pigeonholedate -- 归档日期
            ,businesscurrency -- 合同币种
            ,operatedate -- 经办时间
            ,useproduct -- 使用产品（贸易融资）
            ,sfgksx -- 是否国开行授信
            ,inputorgid -- 登记机构
            ,corpuspaymethod -- 还款方式
            ,mainproduct -- 经营商品（贸易融资）
            ,operateuserid -- 经办人
            ,zfsxlx -- 政府授信类型
            ,bailratio -- 保证金比例(%)
            ,bapbailratio -- 批复保证金比例(%)
            ,businesssum -- 合同金额(元)-申请阶段
            ,creditattribute -- 合同类型
            ,customerid -- 客户编号
            ,gksxpz -- 国开授信品种
            ,importantloan -- 重点贷款项目
            ,manageuserid -- 贷后管理人员
            ,othercondition -- 其他条件和要求
            ,paysource -- 还款说明
            ,inputuserid -- 登记人
            ,gshy -- 过剩行业
            ,guarantyhouse -- 抵押房产套数
            ,interestrateexplain -- 利率说明
            ,vouchtype1 -- 担保方式（内部口径）
            ,inputdate -- 登记日期
            ,relativebapserialno -- 关联新批复流水号
            ,isimportantloan -- 是否重点项目贷款
            ,lowrisk -- 是否低风险业务
            ,financesupportmode -- 贷款财政扶持方式
            ,putoutdate -- 合同起始日
            ,termmonth -- 期限(月)
            ,baptermmonth -- 批复期限(月)
            ,zfsxfs -- 政府授信支持方式
            ,migtflag -- 
            ,bapbusinesssum -- 合同金额(元)-批复阶段
            ,remark -- 备注
            ,artificialno -- 合同文本编号
            ,drawingtype -- 提款方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_jxhjbusiness_contract_op(
            serialno -- 流水号
            ,purpose -- 用途
            ,contextinfo -- 提款说明
            ,direction -- 行业投向
            ,operateorgid -- 经办机构
            ,sfgjxzhy -- 是否国家限制行业
            ,vouchtype -- 主要担保方式
            ,updatedate -- 更新日期
            ,balance -- 合同余额(元)
            ,ifgudingcredit -- 是否固定资产授信
            ,classifyresulteleven -- 风险分类
            ,manageorgid -- 贷后管理机构
            ,maturity -- 合同到期日
            ,relativebcserialno -- 关联新业务合同流水号
            ,businesstype -- 业务品种
            ,guarantytype -- 担保/操作模式
            ,sfzfsx -- 是否政府授信
            ,relativebaserialno -- 关联新申请流水号
            ,pigeonholedate -- 归档日期
            ,businesscurrency -- 合同币种
            ,operatedate -- 经办时间
            ,useproduct -- 使用产品（贸易融资）
            ,sfgksx -- 是否国开行授信
            ,inputorgid -- 登记机构
            ,corpuspaymethod -- 还款方式
            ,mainproduct -- 经营商品（贸易融资）
            ,operateuserid -- 经办人
            ,zfsxlx -- 政府授信类型
            ,bailratio -- 保证金比例(%)
            ,bapbailratio -- 批复保证金比例(%)
            ,businesssum -- 合同金额(元)-申请阶段
            ,creditattribute -- 合同类型
            ,customerid -- 客户编号
            ,gksxpz -- 国开授信品种
            ,importantloan -- 重点贷款项目
            ,manageuserid -- 贷后管理人员
            ,othercondition -- 其他条件和要求
            ,paysource -- 还款说明
            ,inputuserid -- 登记人
            ,gshy -- 过剩行业
            ,guarantyhouse -- 抵押房产套数
            ,interestrateexplain -- 利率说明
            ,vouchtype1 -- 担保方式（内部口径）
            ,inputdate -- 登记日期
            ,relativebapserialno -- 关联新批复流水号
            ,isimportantloan -- 是否重点项目贷款
            ,lowrisk -- 是否低风险业务
            ,financesupportmode -- 贷款财政扶持方式
            ,putoutdate -- 合同起始日
            ,termmonth -- 期限(月)
            ,baptermmonth -- 批复期限(月)
            ,zfsxfs -- 政府授信支持方式
            ,migtflag -- 
            ,bapbusinesssum -- 合同金额(元)-批复阶段
            ,remark -- 备注
            ,artificialno -- 合同文本编号
            ,drawingtype -- 提款方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.purpose -- 用途
    ,o.contextinfo -- 提款说明
    ,o.direction -- 行业投向
    ,o.operateorgid -- 经办机构
    ,o.sfgjxzhy -- 是否国家限制行业
    ,o.vouchtype -- 主要担保方式
    ,o.updatedate -- 更新日期
    ,o.balance -- 合同余额(元)
    ,o.ifgudingcredit -- 是否固定资产授信
    ,o.classifyresulteleven -- 风险分类
    ,o.manageorgid -- 贷后管理机构
    ,o.maturity -- 合同到期日
    ,o.relativebcserialno -- 关联新业务合同流水号
    ,o.businesstype -- 业务品种
    ,o.guarantytype -- 担保/操作模式
    ,o.sfzfsx -- 是否政府授信
    ,o.relativebaserialno -- 关联新申请流水号
    ,o.pigeonholedate -- 归档日期
    ,o.businesscurrency -- 合同币种
    ,o.operatedate -- 经办时间
    ,o.useproduct -- 使用产品（贸易融资）
    ,o.sfgksx -- 是否国开行授信
    ,o.inputorgid -- 登记机构
    ,o.corpuspaymethod -- 还款方式
    ,o.mainproduct -- 经营商品（贸易融资）
    ,o.operateuserid -- 经办人
    ,o.zfsxlx -- 政府授信类型
    ,o.bailratio -- 保证金比例(%)
    ,o.bapbailratio -- 批复保证金比例(%)
    ,o.businesssum -- 合同金额(元)-申请阶段
    ,o.creditattribute -- 合同类型
    ,o.customerid -- 客户编号
    ,o.gksxpz -- 国开授信品种
    ,o.importantloan -- 重点贷款项目
    ,o.manageuserid -- 贷后管理人员
    ,o.othercondition -- 其他条件和要求
    ,o.paysource -- 还款说明
    ,o.inputuserid -- 登记人
    ,o.gshy -- 过剩行业
    ,o.guarantyhouse -- 抵押房产套数
    ,o.interestrateexplain -- 利率说明
    ,o.vouchtype1 -- 担保方式（内部口径）
    ,o.inputdate -- 登记日期
    ,o.relativebapserialno -- 关联新批复流水号
    ,o.isimportantloan -- 是否重点项目贷款
    ,o.lowrisk -- 是否低风险业务
    ,o.financesupportmode -- 贷款财政扶持方式
    ,o.putoutdate -- 合同起始日
    ,o.termmonth -- 期限(月)
    ,o.baptermmonth -- 批复期限(月)
    ,o.zfsxfs -- 政府授信支持方式
    ,o.migtflag -- 
    ,o.bapbusinesssum -- 合同金额(元)-批复阶段
    ,o.remark -- 备注
    ,o.artificialno -- 合同文本编号
    ,o.drawingtype -- 提款方式
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
from ${iol_schema}.icms_jxhjbusiness_contract_bk o
    left join ${iol_schema}.icms_jxhjbusiness_contract_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_jxhjbusiness_contract_cl d
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
--truncate table ${iol_schema}.icms_jxhjbusiness_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_jxhjbusiness_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_jxhjbusiness_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_jxhjbusiness_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_jxhjbusiness_contract exchange partition p_${batch_date} with table ${iol_schema}.icms_jxhjbusiness_contract_cl;
alter table ${iol_schema}.icms_jxhjbusiness_contract exchange partition p_20991231 with table ${iol_schema}.icms_jxhjbusiness_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_jxhjbusiness_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_jxhjbusiness_contract_op purge;
drop table ${iol_schema}.icms_jxhjbusiness_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_jxhjbusiness_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_jxhjbusiness_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
