/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wld_iqp_loan_app
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
create table ${iol_schema}.icms_wld_iqp_loan_app_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wld_iqp_loan_app
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wld_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_wld_iqp_loan_app_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wld_iqp_loan_app_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wld_iqp_loan_app where 0=1;

create table ${iol_schema}.icms_wld_iqp_loan_app_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wld_iqp_loan_app where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wld_iqp_loan_app_cl(
            serialno -- 授信流水号
            ,seqno -- 业务流水号
            ,transcode -- 交易场景
            ,producttype -- 产品类型
            ,wldversion -- 版本号
            ,wldtimestamp -- 时间戳
            ,bankno -- 银行号
            ,papporderid -- 业务订单号
            ,bizscene -- 业务场景
            ,iscustdataqueryauth -- 客户是否授权查外部数据源
            ,isneedtdouterdata -- 是否需要查询外部多头数据
            ,isneedgaouterdata -- 是否需要查询外部公安数据
            ,isneedhfouterdata -- 是否需要查询外部法诉数据
            ,isneedyeouterdata -- 是否需要判断客户在合作行贷款余额超过20w
            ,isneedxxouterdata -- 是否需要查询外部学位数据
            ,isneedouterlimit -- 是否加工合作机构可用额度
            ,isneedouterlist -- 是否需要查询名单信息
            ,idtype -- 证件类型(不建议)
            ,idno -- 证件号
            ,certtype -- 证件类型(建议)
            ,customername -- 姓名
            ,genderno -- 性别
            ,nation -- 国籍
            ,validbegintime -- 有效起始日
            ,validendtime -- 有效结束日
            ,profession -- 职业
            ,address -- 地址
            ,phone -- 电话号
            ,ishaslandline -- 是否有座机
            ,limitpurpose -- 额度用途
            ,firstchecklimit -- 初审额度
            ,callbackcode -- 回调接口号
            ,inputuserid -- 客户经理
            ,inputorgid -- 所属机构
            ,inputdate -- 登记时间
            ,customerid -- 客户号
            ,openflag -- 开户标识
            ,informflag -- 通知标识
            ,riskpapporderid -- 业务订单号(风控)
            ,risktdouterdata -- 外部多头共债数据(风控)
            ,riskgaouterdata -- 外部公安数据(风控)
            ,riskhfouterdata -- 外部法诉数据(风控)
            ,riskyeouterdata -- 客户在合作行贷款余额超过20w(风控)
            ,riskxxouterdata -- 外部学位数据(风控)
            ,risknegative -- 反洗钱名单(风控)
            ,riskrelational -- 关系人关联人名单(风控)
            ,riskotherrule -- 其他不准入规则(风控)
            ,riskisoverlimithat -- 是否到达额度上限(风控)
            ,riskouterlimit -- 合作机构可用额度(风控)
            ,approvestatus -- 审批状态
            ,remark -- 备注
            ,operateorgid -- 账务机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wld_iqp_loan_app_op(
            serialno -- 授信流水号
            ,seqno -- 业务流水号
            ,transcode -- 交易场景
            ,producttype -- 产品类型
            ,wldversion -- 版本号
            ,wldtimestamp -- 时间戳
            ,bankno -- 银行号
            ,papporderid -- 业务订单号
            ,bizscene -- 业务场景
            ,iscustdataqueryauth -- 客户是否授权查外部数据源
            ,isneedtdouterdata -- 是否需要查询外部多头数据
            ,isneedgaouterdata -- 是否需要查询外部公安数据
            ,isneedhfouterdata -- 是否需要查询外部法诉数据
            ,isneedyeouterdata -- 是否需要判断客户在合作行贷款余额超过20w
            ,isneedxxouterdata -- 是否需要查询外部学位数据
            ,isneedouterlimit -- 是否加工合作机构可用额度
            ,isneedouterlist -- 是否需要查询名单信息
            ,idtype -- 证件类型(不建议)
            ,idno -- 证件号
            ,certtype -- 证件类型(建议)
            ,customername -- 姓名
            ,genderno -- 性别
            ,nation -- 国籍
            ,validbegintime -- 有效起始日
            ,validendtime -- 有效结束日
            ,profession -- 职业
            ,address -- 地址
            ,phone -- 电话号
            ,ishaslandline -- 是否有座机
            ,limitpurpose -- 额度用途
            ,firstchecklimit -- 初审额度
            ,callbackcode -- 回调接口号
            ,inputuserid -- 客户经理
            ,inputorgid -- 所属机构
            ,inputdate -- 登记时间
            ,customerid -- 客户号
            ,openflag -- 开户标识
            ,informflag -- 通知标识
            ,riskpapporderid -- 业务订单号(风控)
            ,risktdouterdata -- 外部多头共债数据(风控)
            ,riskgaouterdata -- 外部公安数据(风控)
            ,riskhfouterdata -- 外部法诉数据(风控)
            ,riskyeouterdata -- 客户在合作行贷款余额超过20w(风控)
            ,riskxxouterdata -- 外部学位数据(风控)
            ,risknegative -- 反洗钱名单(风控)
            ,riskrelational -- 关系人关联人名单(风控)
            ,riskotherrule -- 其他不准入规则(风控)
            ,riskisoverlimithat -- 是否到达额度上限(风控)
            ,riskouterlimit -- 合作机构可用额度(风控)
            ,approvestatus -- 审批状态
            ,remark -- 备注
            ,operateorgid -- 账务机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 授信流水号
    ,nvl(n.seqno, o.seqno) as seqno -- 业务流水号
    ,nvl(n.transcode, o.transcode) as transcode -- 交易场景
    ,nvl(n.producttype, o.producttype) as producttype -- 产品类型
    ,nvl(n.wldversion, o.wldversion) as wldversion -- 版本号
    ,nvl(n.wldtimestamp, o.wldtimestamp) as wldtimestamp -- 时间戳
    ,nvl(n.bankno, o.bankno) as bankno -- 银行号
    ,nvl(n.papporderid, o.papporderid) as papporderid -- 业务订单号
    ,nvl(n.bizscene, o.bizscene) as bizscene -- 业务场景
    ,nvl(n.iscustdataqueryauth, o.iscustdataqueryauth) as iscustdataqueryauth -- 客户是否授权查外部数据源
    ,nvl(n.isneedtdouterdata, o.isneedtdouterdata) as isneedtdouterdata -- 是否需要查询外部多头数据
    ,nvl(n.isneedgaouterdata, o.isneedgaouterdata) as isneedgaouterdata -- 是否需要查询外部公安数据
    ,nvl(n.isneedhfouterdata, o.isneedhfouterdata) as isneedhfouterdata -- 是否需要查询外部法诉数据
    ,nvl(n.isneedyeouterdata, o.isneedyeouterdata) as isneedyeouterdata -- 是否需要判断客户在合作行贷款余额超过20w
    ,nvl(n.isneedxxouterdata, o.isneedxxouterdata) as isneedxxouterdata -- 是否需要查询外部学位数据
    ,nvl(n.isneedouterlimit, o.isneedouterlimit) as isneedouterlimit -- 是否加工合作机构可用额度
    ,nvl(n.isneedouterlist, o.isneedouterlist) as isneedouterlist -- 是否需要查询名单信息
    ,nvl(n.idtype, o.idtype) as idtype -- 证件类型(不建议)
    ,nvl(n.idno, o.idno) as idno -- 证件号
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型(建议)
    ,nvl(n.customername, o.customername) as customername -- 姓名
    ,nvl(n.genderno, o.genderno) as genderno -- 性别
    ,nvl(n.nation, o.nation) as nation -- 国籍
    ,nvl(n.validbegintime, o.validbegintime) as validbegintime -- 有效起始日
    ,nvl(n.validendtime, o.validendtime) as validendtime -- 有效结束日
    ,nvl(n.profession, o.profession) as profession -- 职业
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.phone, o.phone) as phone -- 电话号
    ,nvl(n.ishaslandline, o.ishaslandline) as ishaslandline -- 是否有座机
    ,nvl(n.limitpurpose, o.limitpurpose) as limitpurpose -- 额度用途
    ,nvl(n.firstchecklimit, o.firstchecklimit) as firstchecklimit -- 初审额度
    ,nvl(n.callbackcode, o.callbackcode) as callbackcode -- 回调接口号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 客户经理
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 所属机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.openflag, o.openflag) as openflag -- 开户标识
    ,nvl(n.informflag, o.informflag) as informflag -- 通知标识
    ,nvl(n.riskpapporderid, o.riskpapporderid) as riskpapporderid -- 业务订单号(风控)
    ,nvl(n.risktdouterdata, o.risktdouterdata) as risktdouterdata -- 外部多头共债数据(风控)
    ,nvl(n.riskgaouterdata, o.riskgaouterdata) as riskgaouterdata -- 外部公安数据(风控)
    ,nvl(n.riskhfouterdata, o.riskhfouterdata) as riskhfouterdata -- 外部法诉数据(风控)
    ,nvl(n.riskyeouterdata, o.riskyeouterdata) as riskyeouterdata -- 客户在合作行贷款余额超过20w(风控)
    ,nvl(n.riskxxouterdata, o.riskxxouterdata) as riskxxouterdata -- 外部学位数据(风控)
    ,nvl(n.risknegative, o.risknegative) as risknegative -- 反洗钱名单(风控)
    ,nvl(n.riskrelational, o.riskrelational) as riskrelational -- 关系人关联人名单(风控)
    ,nvl(n.riskotherrule, o.riskotherrule) as riskotherrule -- 其他不准入规则(风控)
    ,nvl(n.riskisoverlimithat, o.riskisoverlimithat) as riskisoverlimithat -- 是否到达额度上限(风控)
    ,nvl(n.riskouterlimit, o.riskouterlimit) as riskouterlimit -- 合作机构可用额度(风控)
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 账务机构
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
from (select * from ${iol_schema}.icms_wld_iqp_loan_app_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wld_iqp_loan_app where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.seqno <> n.seqno
        or o.transcode <> n.transcode
        or o.producttype <> n.producttype
        or o.wldversion <> n.wldversion
        or o.wldtimestamp <> n.wldtimestamp
        or o.bankno <> n.bankno
        or o.papporderid <> n.papporderid
        or o.bizscene <> n.bizscene
        or o.iscustdataqueryauth <> n.iscustdataqueryauth
        or o.isneedtdouterdata <> n.isneedtdouterdata
        or o.isneedgaouterdata <> n.isneedgaouterdata
        or o.isneedhfouterdata <> n.isneedhfouterdata
        or o.isneedyeouterdata <> n.isneedyeouterdata
        or o.isneedxxouterdata <> n.isneedxxouterdata
        or o.isneedouterlimit <> n.isneedouterlimit
        or o.isneedouterlist <> n.isneedouterlist
        or o.idtype <> n.idtype
        or o.idno <> n.idno
        or o.certtype <> n.certtype
        or o.customername <> n.customername
        or o.genderno <> n.genderno
        or o.nation <> n.nation
        or o.validbegintime <> n.validbegintime
        or o.validendtime <> n.validendtime
        or o.profession <> n.profession
        or o.address <> n.address
        or o.phone <> n.phone
        or o.ishaslandline <> n.ishaslandline
        or o.limitpurpose <> n.limitpurpose
        or o.firstchecklimit <> n.firstchecklimit
        or o.callbackcode <> n.callbackcode
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.customerid <> n.customerid
        or o.openflag <> n.openflag
        or o.informflag <> n.informflag
        or o.riskpapporderid <> n.riskpapporderid
        or o.risktdouterdata <> n.risktdouterdata
        or o.riskgaouterdata <> n.riskgaouterdata
        or o.riskhfouterdata <> n.riskhfouterdata
        or o.riskyeouterdata <> n.riskyeouterdata
        or o.riskxxouterdata <> n.riskxxouterdata
        or o.risknegative <> n.risknegative
        or o.riskrelational <> n.riskrelational
        or o.riskotherrule <> n.riskotherrule
        or o.riskisoverlimithat <> n.riskisoverlimithat
        or o.riskouterlimit <> n.riskouterlimit
        or o.approvestatus <> n.approvestatus
        or o.remark <> n.remark
        or o.operateorgid <> n.operateorgid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wld_iqp_loan_app_cl(
            serialno -- 授信流水号
            ,seqno -- 业务流水号
            ,transcode -- 交易场景
            ,producttype -- 产品类型
            ,wldversion -- 版本号
            ,wldtimestamp -- 时间戳
            ,bankno -- 银行号
            ,papporderid -- 业务订单号
            ,bizscene -- 业务场景
            ,iscustdataqueryauth -- 客户是否授权查外部数据源
            ,isneedtdouterdata -- 是否需要查询外部多头数据
            ,isneedgaouterdata -- 是否需要查询外部公安数据
            ,isneedhfouterdata -- 是否需要查询外部法诉数据
            ,isneedyeouterdata -- 是否需要判断客户在合作行贷款余额超过20w
            ,isneedxxouterdata -- 是否需要查询外部学位数据
            ,isneedouterlimit -- 是否加工合作机构可用额度
            ,isneedouterlist -- 是否需要查询名单信息
            ,idtype -- 证件类型(不建议)
            ,idno -- 证件号
            ,certtype -- 证件类型(建议)
            ,customername -- 姓名
            ,genderno -- 性别
            ,nation -- 国籍
            ,validbegintime -- 有效起始日
            ,validendtime -- 有效结束日
            ,profession -- 职业
            ,address -- 地址
            ,phone -- 电话号
            ,ishaslandline -- 是否有座机
            ,limitpurpose -- 额度用途
            ,firstchecklimit -- 初审额度
            ,callbackcode -- 回调接口号
            ,inputuserid -- 客户经理
            ,inputorgid -- 所属机构
            ,inputdate -- 登记时间
            ,customerid -- 客户号
            ,openflag -- 开户标识
            ,informflag -- 通知标识
            ,riskpapporderid -- 业务订单号(风控)
            ,risktdouterdata -- 外部多头共债数据(风控)
            ,riskgaouterdata -- 外部公安数据(风控)
            ,riskhfouterdata -- 外部法诉数据(风控)
            ,riskyeouterdata -- 客户在合作行贷款余额超过20w(风控)
            ,riskxxouterdata -- 外部学位数据(风控)
            ,risknegative -- 反洗钱名单(风控)
            ,riskrelational -- 关系人关联人名单(风控)
            ,riskotherrule -- 其他不准入规则(风控)
            ,riskisoverlimithat -- 是否到达额度上限(风控)
            ,riskouterlimit -- 合作机构可用额度(风控)
            ,approvestatus -- 审批状态
            ,remark -- 备注
            ,operateorgid -- 账务机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wld_iqp_loan_app_op(
            serialno -- 授信流水号
            ,seqno -- 业务流水号
            ,transcode -- 交易场景
            ,producttype -- 产品类型
            ,wldversion -- 版本号
            ,wldtimestamp -- 时间戳
            ,bankno -- 银行号
            ,papporderid -- 业务订单号
            ,bizscene -- 业务场景
            ,iscustdataqueryauth -- 客户是否授权查外部数据源
            ,isneedtdouterdata -- 是否需要查询外部多头数据
            ,isneedgaouterdata -- 是否需要查询外部公安数据
            ,isneedhfouterdata -- 是否需要查询外部法诉数据
            ,isneedyeouterdata -- 是否需要判断客户在合作行贷款余额超过20w
            ,isneedxxouterdata -- 是否需要查询外部学位数据
            ,isneedouterlimit -- 是否加工合作机构可用额度
            ,isneedouterlist -- 是否需要查询名单信息
            ,idtype -- 证件类型(不建议)
            ,idno -- 证件号
            ,certtype -- 证件类型(建议)
            ,customername -- 姓名
            ,genderno -- 性别
            ,nation -- 国籍
            ,validbegintime -- 有效起始日
            ,validendtime -- 有效结束日
            ,profession -- 职业
            ,address -- 地址
            ,phone -- 电话号
            ,ishaslandline -- 是否有座机
            ,limitpurpose -- 额度用途
            ,firstchecklimit -- 初审额度
            ,callbackcode -- 回调接口号
            ,inputuserid -- 客户经理
            ,inputorgid -- 所属机构
            ,inputdate -- 登记时间
            ,customerid -- 客户号
            ,openflag -- 开户标识
            ,informflag -- 通知标识
            ,riskpapporderid -- 业务订单号(风控)
            ,risktdouterdata -- 外部多头共债数据(风控)
            ,riskgaouterdata -- 外部公安数据(风控)
            ,riskhfouterdata -- 外部法诉数据(风控)
            ,riskyeouterdata -- 客户在合作行贷款余额超过20w(风控)
            ,riskxxouterdata -- 外部学位数据(风控)
            ,risknegative -- 反洗钱名单(风控)
            ,riskrelational -- 关系人关联人名单(风控)
            ,riskotherrule -- 其他不准入规则(风控)
            ,riskisoverlimithat -- 是否到达额度上限(风控)
            ,riskouterlimit -- 合作机构可用额度(风控)
            ,approvestatus -- 审批状态
            ,remark -- 备注
            ,operateorgid -- 账务机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 授信流水号
    ,o.seqno -- 业务流水号
    ,o.transcode -- 交易场景
    ,o.producttype -- 产品类型
    ,o.wldversion -- 版本号
    ,o.wldtimestamp -- 时间戳
    ,o.bankno -- 银行号
    ,o.papporderid -- 业务订单号
    ,o.bizscene -- 业务场景
    ,o.iscustdataqueryauth -- 客户是否授权查外部数据源
    ,o.isneedtdouterdata -- 是否需要查询外部多头数据
    ,o.isneedgaouterdata -- 是否需要查询外部公安数据
    ,o.isneedhfouterdata -- 是否需要查询外部法诉数据
    ,o.isneedyeouterdata -- 是否需要判断客户在合作行贷款余额超过20w
    ,o.isneedxxouterdata -- 是否需要查询外部学位数据
    ,o.isneedouterlimit -- 是否加工合作机构可用额度
    ,o.isneedouterlist -- 是否需要查询名单信息
    ,o.idtype -- 证件类型(不建议)
    ,o.idno -- 证件号
    ,o.certtype -- 证件类型(建议)
    ,o.customername -- 姓名
    ,o.genderno -- 性别
    ,o.nation -- 国籍
    ,o.validbegintime -- 有效起始日
    ,o.validendtime -- 有效结束日
    ,o.profession -- 职业
    ,o.address -- 地址
    ,o.phone -- 电话号
    ,o.ishaslandline -- 是否有座机
    ,o.limitpurpose -- 额度用途
    ,o.firstchecklimit -- 初审额度
    ,o.callbackcode -- 回调接口号
    ,o.inputuserid -- 客户经理
    ,o.inputorgid -- 所属机构
    ,o.inputdate -- 登记时间
    ,o.customerid -- 客户号
    ,o.openflag -- 开户标识
    ,o.informflag -- 通知标识
    ,o.riskpapporderid -- 业务订单号(风控)
    ,o.risktdouterdata -- 外部多头共债数据(风控)
    ,o.riskgaouterdata -- 外部公安数据(风控)
    ,o.riskhfouterdata -- 外部法诉数据(风控)
    ,o.riskyeouterdata -- 客户在合作行贷款余额超过20w(风控)
    ,o.riskxxouterdata -- 外部学位数据(风控)
    ,o.risknegative -- 反洗钱名单(风控)
    ,o.riskrelational -- 关系人关联人名单(风控)
    ,o.riskotherrule -- 其他不准入规则(风控)
    ,o.riskisoverlimithat -- 是否到达额度上限(风控)
    ,o.riskouterlimit -- 合作机构可用额度(风控)
    ,o.approvestatus -- 审批状态
    ,o.remark -- 备注
    ,o.operateorgid -- 账务机构
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
from ${iol_schema}.icms_wld_iqp_loan_app_bk o
    left join ${iol_schema}.icms_wld_iqp_loan_app_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wld_iqp_loan_app_cl d
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
--truncate table ${iol_schema}.icms_wld_iqp_loan_app;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wld_iqp_loan_app') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wld_iqp_loan_app drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wld_iqp_loan_app add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wld_iqp_loan_app exchange partition p_${batch_date} with table ${iol_schema}.icms_wld_iqp_loan_app_cl;
alter table ${iol_schema}.icms_wld_iqp_loan_app exchange partition p_20991231 with table ${iol_schema}.icms_wld_iqp_loan_app_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wld_iqp_loan_app to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wld_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_wld_iqp_loan_app_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wld_iqp_loan_app_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wld_iqp_loan_app',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
