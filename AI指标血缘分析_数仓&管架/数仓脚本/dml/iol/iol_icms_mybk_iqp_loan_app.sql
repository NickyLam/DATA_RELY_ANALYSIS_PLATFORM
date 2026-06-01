/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybk_iqp_loan_app
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
create table ${iol_schema}.icms_mybk_iqp_loan_app_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_mybk_iqp_loan_app
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybk_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_mybk_iqp_loan_app_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_iqp_loan_app_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybk_iqp_loan_app where 0=1;

create table ${iol_schema}.icms_mybk_iqp_loan_app_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybk_iqp_loan_app where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybk_iqp_loan_app_cl(
            serialno -- 业务流水号
            ,staffnum -- 职工人数
            ,prdcode -- 产品编号
            ,lastadvicedate -- 终审通知时间
            ,floatratebpbottom -- 利率下限浮动点差BP
            ,bsntype -- 产品业务类型
            ,informfinalflag -- 终审通知成功与否
            ,certcode -- 证件号码
            ,cusname -- 姓名
            ,platformaccess -- 网商贷审批结果
            ,targetjyflag2 -- 客群经营标签（人行口径）
            ,targetjyflag3 -- 客群经营标签（银监口径）
            ,applytimes -- 申请次数（同一客户）
            ,csappresult -- 网商贷初审结论
            ,platformadmit -- 授信建议额度
            ,custinst -- 客引机构ID(区分旺农贷、中和农信)
            ,income -- 营业收入，单位元
            ,applyamount -- 审批额度(元)
            ,inputbrid -- 登记机构
            ,businessmodel -- 业务模式MYBK_CREDIT_LOAN:网商信用类贷款PLAT_CREDIT_LOAN:平台贷
            ,requestid -- 初审幂等ID
            ,actcerttype -- 企业实控人证件类型
            ,arno -- 方案合约号（代表一种合作模式，区分旺农贷和中和农信）
            ,floatratebplimit -- 利率上限浮动点差BP
            ,ratefloatmodebottom -- 利率下限浮动方式
            ,platformratelimit -- 授信年利率上限
            ,lprbottom -- 利率下限LPR，网商贷默认一年期LPR
            ,applyno -- 蚂蚁申请单号
            ,startdate -- 审批开始时间
            ,informflag -- 初审通知成功与否
            ,prdname -- 产品名称
            ,failreason -- 拒绝原因
            ,enddate -- 审批结束时间
            ,approvestatus -- 审批状态
            ,refusecode -- 拒绝码
            ,mobile -- 手机号码
            ,zsrequestid -- 终审幂等ID
            ,farmerflag -- 是否农户
            ,lprlimit -- 利率上限LPR，网商贷默认一年期LPR
            ,ackmsg -- 批复意见
            ,cusid -- 客户号
            ,platformratebottom -- 授信年利率下限
            ,inputid -- 登记人
            ,csapprovestatus -- 初审审批状态
            ,migtflag -- 
            ,balstatus -- 额度状态：审批中111、否决998、有效(申请通过且额度未关闭)886、关闭(申请通过且额度关闭)887
            ,applydate -- 申请日期
            ,certtype -- 证件类型
            ,actcertno -- 企业实控人证件号码
            ,actcertname -- 企业实控人证件名
            ,ratefloatmodelimit -- 利率上限浮动方式
            ,rulingir -- 年利率
            ,loanar -- 业务场景
            ,authorizationbookid -- 授权书编号
            ,csretry -- 初审重试次数
            ,zsretry -- 终审重试次数
            ,noticedate -- 通知时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybk_iqp_loan_app_op(
            serialno -- 业务流水号
            ,staffnum -- 职工人数
            ,prdcode -- 产品编号
            ,lastadvicedate -- 终审通知时间
            ,floatratebpbottom -- 利率下限浮动点差BP
            ,bsntype -- 产品业务类型
            ,informfinalflag -- 终审通知成功与否
            ,certcode -- 证件号码
            ,cusname -- 姓名
            ,platformaccess -- 网商贷审批结果
            ,targetjyflag2 -- 客群经营标签（人行口径）
            ,targetjyflag3 -- 客群经营标签（银监口径）
            ,applytimes -- 申请次数（同一客户）
            ,csappresult -- 网商贷初审结论
            ,platformadmit -- 授信建议额度
            ,custinst -- 客引机构ID(区分旺农贷、中和农信)
            ,income -- 营业收入，单位元
            ,applyamount -- 审批额度(元)
            ,inputbrid -- 登记机构
            ,businessmodel -- 业务模式MYBK_CREDIT_LOAN:网商信用类贷款PLAT_CREDIT_LOAN:平台贷
            ,requestid -- 初审幂等ID
            ,actcerttype -- 企业实控人证件类型
            ,arno -- 方案合约号（代表一种合作模式，区分旺农贷和中和农信）
            ,floatratebplimit -- 利率上限浮动点差BP
            ,ratefloatmodebottom -- 利率下限浮动方式
            ,platformratelimit -- 授信年利率上限
            ,lprbottom -- 利率下限LPR，网商贷默认一年期LPR
            ,applyno -- 蚂蚁申请单号
            ,startdate -- 审批开始时间
            ,informflag -- 初审通知成功与否
            ,prdname -- 产品名称
            ,failreason -- 拒绝原因
            ,enddate -- 审批结束时间
            ,approvestatus -- 审批状态
            ,refusecode -- 拒绝码
            ,mobile -- 手机号码
            ,zsrequestid -- 终审幂等ID
            ,farmerflag -- 是否农户
            ,lprlimit -- 利率上限LPR，网商贷默认一年期LPR
            ,ackmsg -- 批复意见
            ,cusid -- 客户号
            ,platformratebottom -- 授信年利率下限
            ,inputid -- 登记人
            ,csapprovestatus -- 初审审批状态
            ,migtflag -- 
            ,balstatus -- 额度状态：审批中111、否决998、有效(申请通过且额度未关闭)886、关闭(申请通过且额度关闭)887
            ,applydate -- 申请日期
            ,certtype -- 证件类型
            ,actcertno -- 企业实控人证件号码
            ,actcertname -- 企业实控人证件名
            ,ratefloatmodelimit -- 利率上限浮动方式
            ,rulingir -- 年利率
            ,loanar -- 业务场景
            ,authorizationbookid -- 授权书编号
            ,csretry -- 初审重试次数
            ,zsretry -- 终审重试次数
            ,noticedate -- 通知时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 业务流水号
    ,nvl(n.staffnum, o.staffnum) as staffnum -- 职工人数
    ,nvl(n.prdcode, o.prdcode) as prdcode -- 产品编号
    ,nvl(n.lastadvicedate, o.lastadvicedate) as lastadvicedate -- 终审通知时间
    ,nvl(n.floatratebpbottom, o.floatratebpbottom) as floatratebpbottom -- 利率下限浮动点差BP
    ,nvl(n.bsntype, o.bsntype) as bsntype -- 产品业务类型
    ,nvl(n.informfinalflag, o.informfinalflag) as informfinalflag -- 终审通知成功与否
    ,nvl(n.certcode, o.certcode) as certcode -- 证件号码
    ,nvl(n.cusname, o.cusname) as cusname -- 姓名
    ,nvl(n.platformaccess, o.platformaccess) as platformaccess -- 网商贷审批结果
    ,nvl(n.targetjyflag2, o.targetjyflag2) as targetjyflag2 -- 客群经营标签（人行口径）
    ,nvl(n.targetjyflag3, o.targetjyflag3) as targetjyflag3 -- 客群经营标签（银监口径）
    ,nvl(n.applytimes, o.applytimes) as applytimes -- 申请次数（同一客户）
    ,nvl(n.csappresult, o.csappresult) as csappresult -- 网商贷初审结论
    ,nvl(n.platformadmit, o.platformadmit) as platformadmit -- 授信建议额度
    ,nvl(n.custinst, o.custinst) as custinst -- 客引机构ID(区分旺农贷、中和农信)
    ,nvl(n.income, o.income) as income -- 营业收入，单位元
    ,nvl(n.applyamount, o.applyamount) as applyamount -- 审批额度(元)
    ,nvl(n.inputbrid, o.inputbrid) as inputbrid -- 登记机构
    ,nvl(n.businessmodel, o.businessmodel) as businessmodel -- 业务模式MYBK_CREDIT_LOAN:网商信用类贷款PLAT_CREDIT_LOAN:平台贷
    ,nvl(n.requestid, o.requestid) as requestid -- 初审幂等ID
    ,nvl(n.actcerttype, o.actcerttype) as actcerttype -- 企业实控人证件类型
    ,nvl(n.arno, o.arno) as arno -- 方案合约号（代表一种合作模式，区分旺农贷和中和农信）
    ,nvl(n.floatratebplimit, o.floatratebplimit) as floatratebplimit -- 利率上限浮动点差BP
    ,nvl(n.ratefloatmodebottom, o.ratefloatmodebottom) as ratefloatmodebottom -- 利率下限浮动方式
    ,nvl(n.platformratelimit, o.platformratelimit) as platformratelimit -- 授信年利率上限
    ,nvl(n.lprbottom, o.lprbottom) as lprbottom -- 利率下限LPR，网商贷默认一年期LPR
    ,nvl(n.applyno, o.applyno) as applyno -- 蚂蚁申请单号
    ,nvl(n.startdate, o.startdate) as startdate -- 审批开始时间
    ,nvl(n.informflag, o.informflag) as informflag -- 初审通知成功与否
    ,nvl(n.prdname, o.prdname) as prdname -- 产品名称
    ,nvl(n.failreason, o.failreason) as failreason -- 拒绝原因
    ,nvl(n.enddate, o.enddate) as enddate -- 审批结束时间
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.refusecode, o.refusecode) as refusecode -- 拒绝码
    ,nvl(n.mobile, o.mobile) as mobile -- 手机号码
    ,nvl(n.zsrequestid, o.zsrequestid) as zsrequestid -- 终审幂等ID
    ,nvl(n.farmerflag, o.farmerflag) as farmerflag -- 是否农户
    ,nvl(n.lprlimit, o.lprlimit) as lprlimit -- 利率上限LPR，网商贷默认一年期LPR
    ,nvl(n.ackmsg, o.ackmsg) as ackmsg -- 批复意见
    ,nvl(n.cusid, o.cusid) as cusid -- 客户号
    ,nvl(n.platformratebottom, o.platformratebottom) as platformratebottom -- 授信年利率下限
    ,nvl(n.inputid, o.inputid) as inputid -- 登记人
    ,nvl(n.csapprovestatus, o.csapprovestatus) as csapprovestatus -- 初审审批状态
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.balstatus, o.balstatus) as balstatus -- 额度状态：审批中111、否决998、有效(申请通过且额度未关闭)886、关闭(申请通过且额度关闭)887
    ,nvl(n.applydate, o.applydate) as applydate -- 申请日期
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.actcertno, o.actcertno) as actcertno -- 企业实控人证件号码
    ,nvl(n.actcertname, o.actcertname) as actcertname -- 企业实控人证件名
    ,nvl(n.ratefloatmodelimit, o.ratefloatmodelimit) as ratefloatmodelimit -- 利率上限浮动方式
    ,nvl(n.rulingir, o.rulingir) as rulingir -- 年利率
    ,nvl(n.loanar, o.loanar) as loanar -- 业务场景
    ,nvl(n.authorizationbookid, o.authorizationbookid) as authorizationbookid -- 授权书编号
    ,nvl(n.csretry, o.csretry) as csretry -- 初审重试次数
    ,nvl(n.zsretry, o.zsretry) as zsretry -- 终审重试次数
    ,nvl(n.noticedate, o.noticedate) as noticedate -- 通知时间
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
from (select * from ${iol_schema}.icms_mybk_iqp_loan_app_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_mybk_iqp_loan_app where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.staffnum <> n.staffnum
        or o.prdcode <> n.prdcode
        or o.lastadvicedate <> n.lastadvicedate
        or o.floatratebpbottom <> n.floatratebpbottom
        or o.bsntype <> n.bsntype
        or o.informfinalflag <> n.informfinalflag
        or o.certcode <> n.certcode
        or o.cusname <> n.cusname
        or o.platformaccess <> n.platformaccess
        or o.targetjyflag2 <> n.targetjyflag2
        or o.targetjyflag3 <> n.targetjyflag3
        or o.applytimes <> n.applytimes
        or o.csappresult <> n.csappresult
        or o.platformadmit <> n.platformadmit
        or o.custinst <> n.custinst
        or o.income <> n.income
        or o.applyamount <> n.applyamount
        or o.inputbrid <> n.inputbrid
        or o.businessmodel <> n.businessmodel
        or o.requestid <> n.requestid
        or o.actcerttype <> n.actcerttype
        or o.arno <> n.arno
        or o.floatratebplimit <> n.floatratebplimit
        or o.ratefloatmodebottom <> n.ratefloatmodebottom
        or o.platformratelimit <> n.platformratelimit
        or o.lprbottom <> n.lprbottom
        or o.applyno <> n.applyno
        or o.startdate <> n.startdate
        or o.informflag <> n.informflag
        or o.prdname <> n.prdname
        or o.failreason <> n.failreason
        or o.enddate <> n.enddate
        or o.approvestatus <> n.approvestatus
        or o.refusecode <> n.refusecode
        or o.mobile <> n.mobile
        or o.zsrequestid <> n.zsrequestid
        or o.farmerflag <> n.farmerflag
        or o.lprlimit <> n.lprlimit
        or o.ackmsg <> n.ackmsg
        or o.cusid <> n.cusid
        or o.platformratebottom <> n.platformratebottom
        or o.inputid <> n.inputid
        or o.csapprovestatus <> n.csapprovestatus
        or o.migtflag <> n.migtflag
        or o.balstatus <> n.balstatus
        or o.applydate <> n.applydate
        or o.certtype <> n.certtype
        or o.actcertno <> n.actcertno
        or o.actcertname <> n.actcertname
        or o.ratefloatmodelimit <> n.ratefloatmodelimit
        or o.rulingir <> n.rulingir
        or o.loanar <> n.loanar
        or o.authorizationbookid <> n.authorizationbookid
        or o.csretry <> n.csretry
        or o.zsretry <> n.zsretry
        or o.noticedate <> n.noticedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybk_iqp_loan_app_cl(
            serialno -- 业务流水号
            ,staffnum -- 职工人数
            ,prdcode -- 产品编号
            ,lastadvicedate -- 终审通知时间
            ,floatratebpbottom -- 利率下限浮动点差BP
            ,bsntype -- 产品业务类型
            ,informfinalflag -- 终审通知成功与否
            ,certcode -- 证件号码
            ,cusname -- 姓名
            ,platformaccess -- 网商贷审批结果
            ,targetjyflag2 -- 客群经营标签（人行口径）
            ,targetjyflag3 -- 客群经营标签（银监口径）
            ,applytimes -- 申请次数（同一客户）
            ,csappresult -- 网商贷初审结论
            ,platformadmit -- 授信建议额度
            ,custinst -- 客引机构ID(区分旺农贷、中和农信)
            ,income -- 营业收入，单位元
            ,applyamount -- 审批额度(元)
            ,inputbrid -- 登记机构
            ,businessmodel -- 业务模式MYBK_CREDIT_LOAN:网商信用类贷款PLAT_CREDIT_LOAN:平台贷
            ,requestid -- 初审幂等ID
            ,actcerttype -- 企业实控人证件类型
            ,arno -- 方案合约号（代表一种合作模式，区分旺农贷和中和农信）
            ,floatratebplimit -- 利率上限浮动点差BP
            ,ratefloatmodebottom -- 利率下限浮动方式
            ,platformratelimit -- 授信年利率上限
            ,lprbottom -- 利率下限LPR，网商贷默认一年期LPR
            ,applyno -- 蚂蚁申请单号
            ,startdate -- 审批开始时间
            ,informflag -- 初审通知成功与否
            ,prdname -- 产品名称
            ,failreason -- 拒绝原因
            ,enddate -- 审批结束时间
            ,approvestatus -- 审批状态
            ,refusecode -- 拒绝码
            ,mobile -- 手机号码
            ,zsrequestid -- 终审幂等ID
            ,farmerflag -- 是否农户
            ,lprlimit -- 利率上限LPR，网商贷默认一年期LPR
            ,ackmsg -- 批复意见
            ,cusid -- 客户号
            ,platformratebottom -- 授信年利率下限
            ,inputid -- 登记人
            ,csapprovestatus -- 初审审批状态
            ,migtflag -- 
            ,balstatus -- 额度状态：审批中111、否决998、有效(申请通过且额度未关闭)886、关闭(申请通过且额度关闭)887
            ,applydate -- 申请日期
            ,certtype -- 证件类型
            ,actcertno -- 企业实控人证件号码
            ,actcertname -- 企业实控人证件名
            ,ratefloatmodelimit -- 利率上限浮动方式
            ,rulingir -- 年利率
            ,loanar -- 业务场景
            ,authorizationbookid -- 授权书编号
            ,csretry -- 初审重试次数
            ,zsretry -- 终审重试次数
            ,noticedate -- 通知时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybk_iqp_loan_app_op(
            serialno -- 业务流水号
            ,staffnum -- 职工人数
            ,prdcode -- 产品编号
            ,lastadvicedate -- 终审通知时间
            ,floatratebpbottom -- 利率下限浮动点差BP
            ,bsntype -- 产品业务类型
            ,informfinalflag -- 终审通知成功与否
            ,certcode -- 证件号码
            ,cusname -- 姓名
            ,platformaccess -- 网商贷审批结果
            ,targetjyflag2 -- 客群经营标签（人行口径）
            ,targetjyflag3 -- 客群经营标签（银监口径）
            ,applytimes -- 申请次数（同一客户）
            ,csappresult -- 网商贷初审结论
            ,platformadmit -- 授信建议额度
            ,custinst -- 客引机构ID(区分旺农贷、中和农信)
            ,income -- 营业收入，单位元
            ,applyamount -- 审批额度(元)
            ,inputbrid -- 登记机构
            ,businessmodel -- 业务模式MYBK_CREDIT_LOAN:网商信用类贷款PLAT_CREDIT_LOAN:平台贷
            ,requestid -- 初审幂等ID
            ,actcerttype -- 企业实控人证件类型
            ,arno -- 方案合约号（代表一种合作模式，区分旺农贷和中和农信）
            ,floatratebplimit -- 利率上限浮动点差BP
            ,ratefloatmodebottom -- 利率下限浮动方式
            ,platformratelimit -- 授信年利率上限
            ,lprbottom -- 利率下限LPR，网商贷默认一年期LPR
            ,applyno -- 蚂蚁申请单号
            ,startdate -- 审批开始时间
            ,informflag -- 初审通知成功与否
            ,prdname -- 产品名称
            ,failreason -- 拒绝原因
            ,enddate -- 审批结束时间
            ,approvestatus -- 审批状态
            ,refusecode -- 拒绝码
            ,mobile -- 手机号码
            ,zsrequestid -- 终审幂等ID
            ,farmerflag -- 是否农户
            ,lprlimit -- 利率上限LPR，网商贷默认一年期LPR
            ,ackmsg -- 批复意见
            ,cusid -- 客户号
            ,platformratebottom -- 授信年利率下限
            ,inputid -- 登记人
            ,csapprovestatus -- 初审审批状态
            ,migtflag -- 
            ,balstatus -- 额度状态：审批中111、否决998、有效(申请通过且额度未关闭)886、关闭(申请通过且额度关闭)887
            ,applydate -- 申请日期
            ,certtype -- 证件类型
            ,actcertno -- 企业实控人证件号码
            ,actcertname -- 企业实控人证件名
            ,ratefloatmodelimit -- 利率上限浮动方式
            ,rulingir -- 年利率
            ,loanar -- 业务场景
            ,authorizationbookid -- 授权书编号
            ,csretry -- 初审重试次数
            ,zsretry -- 终审重试次数
            ,noticedate -- 通知时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 业务流水号
    ,o.staffnum -- 职工人数
    ,o.prdcode -- 产品编号
    ,o.lastadvicedate -- 终审通知时间
    ,o.floatratebpbottom -- 利率下限浮动点差BP
    ,o.bsntype -- 产品业务类型
    ,o.informfinalflag -- 终审通知成功与否
    ,o.certcode -- 证件号码
    ,o.cusname -- 姓名
    ,o.platformaccess -- 网商贷审批结果
    ,o.targetjyflag2 -- 客群经营标签（人行口径）
    ,o.targetjyflag3 -- 客群经营标签（银监口径）
    ,o.applytimes -- 申请次数（同一客户）
    ,o.csappresult -- 网商贷初审结论
    ,o.platformadmit -- 授信建议额度
    ,o.custinst -- 客引机构ID(区分旺农贷、中和农信)
    ,o.income -- 营业收入，单位元
    ,o.applyamount -- 审批额度(元)
    ,o.inputbrid -- 登记机构
    ,o.businessmodel -- 业务模式MYBK_CREDIT_LOAN:网商信用类贷款PLAT_CREDIT_LOAN:平台贷
    ,o.requestid -- 初审幂等ID
    ,o.actcerttype -- 企业实控人证件类型
    ,o.arno -- 方案合约号（代表一种合作模式，区分旺农贷和中和农信）
    ,o.floatratebplimit -- 利率上限浮动点差BP
    ,o.ratefloatmodebottom -- 利率下限浮动方式
    ,o.platformratelimit -- 授信年利率上限
    ,o.lprbottom -- 利率下限LPR，网商贷默认一年期LPR
    ,o.applyno -- 蚂蚁申请单号
    ,o.startdate -- 审批开始时间
    ,o.informflag -- 初审通知成功与否
    ,o.prdname -- 产品名称
    ,o.failreason -- 拒绝原因
    ,o.enddate -- 审批结束时间
    ,o.approvestatus -- 审批状态
    ,o.refusecode -- 拒绝码
    ,o.mobile -- 手机号码
    ,o.zsrequestid -- 终审幂等ID
    ,o.farmerflag -- 是否农户
    ,o.lprlimit -- 利率上限LPR，网商贷默认一年期LPR
    ,o.ackmsg -- 批复意见
    ,o.cusid -- 客户号
    ,o.platformratebottom -- 授信年利率下限
    ,o.inputid -- 登记人
    ,o.csapprovestatus -- 初审审批状态
    ,o.migtflag -- 
    ,o.balstatus -- 额度状态：审批中111、否决998、有效(申请通过且额度未关闭)886、关闭(申请通过且额度关闭)887
    ,o.applydate -- 申请日期
    ,o.certtype -- 证件类型
    ,o.actcertno -- 企业实控人证件号码
    ,o.actcertname -- 企业实控人证件名
    ,o.ratefloatmodelimit -- 利率上限浮动方式
    ,o.rulingir -- 年利率
    ,o.loanar -- 业务场景
    ,o.authorizationbookid -- 授权书编号
    ,o.csretry -- 初审重试次数
    ,o.zsretry -- 终审重试次数
    ,o.noticedate -- 通知时间
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
from ${iol_schema}.icms_mybk_iqp_loan_app_bk o
    left join ${iol_schema}.icms_mybk_iqp_loan_app_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_mybk_iqp_loan_app_cl d
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
--truncate table ${iol_schema}.icms_mybk_iqp_loan_app;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_mybk_iqp_loan_app') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_mybk_iqp_loan_app drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_mybk_iqp_loan_app add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_mybk_iqp_loan_app exchange partition p_${batch_date} with table ${iol_schema}.icms_mybk_iqp_loan_app_cl;
alter table ${iol_schema}.icms_mybk_iqp_loan_app exchange partition p_20991231 with table ${iol_schema}.icms_mybk_iqp_loan_app_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybk_iqp_loan_app to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybk_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_mybk_iqp_loan_app_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_mybk_iqp_loan_app_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybk_iqp_loan_app',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
