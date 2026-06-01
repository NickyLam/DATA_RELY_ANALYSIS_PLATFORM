/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybkzd_iqp_loan_app
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
create table ${iol_schema}.icms_mybkzd_iqp_loan_app_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_mybkzd_iqp_loan_app
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybkzd_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_mybkzd_iqp_loan_app_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzd_iqp_loan_app_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybkzd_iqp_loan_app where 0=1;

create table ${iol_schema}.icms_mybkzd_iqp_loan_app_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybkzd_iqp_loan_app where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybkzd_iqp_loan_app_cl(
            serialno -- 业务流水号
            ,applyno -- 蚂蚁申请单号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,applydate -- 申请日期
            ,certtype -- 证件类型
            ,certcode -- 证件号码
            ,cusname -- 姓名
            ,cusid -- 客户号
            ,platformaccess -- 网商贷审批结果
            ,platformadmit -- 授信建议额度
            ,platformratelimit -- 授信年利率上限
            ,platformratebottom -- 授信年利率下限
            ,failreason -- 拒绝原因
            ,applyamount -- 审批额度(元)
            ,rulingir -- 年利率
            ,startdate -- 审批开始时间
            ,enddate -- 审批结束时间
            ,approvestatus -- 审批状态
            ,informflag -- 初审通知成功与否
            ,informfinalflag -- 终审通知成功与否
            ,lastadvicedate -- 终审通知时间
            ,inputid -- 登记人
            ,inputbrid -- 登记机构
            ,businessmodel -- 业务模式
            ,refusecode -- 拒绝码
            ,ackmsg -- 拒绝原因
            ,csapprovestatus -- 初审审批状态
            ,targetjyflag2 -- 客群经营标签（人行口径）
            ,targetjyflag3 -- 客群经营标签（银监口径）
            ,farmerflag -- 是否农户
            ,mobile -- 手机号码
            ,requestid -- 初审幂等ID
            ,zsrequestid -- 终审幂等ID
            ,loanar -- 业务场景
            ,bsntype -- 产品业务类型
            ,actcerttype -- 企业实控人证件类型
            ,actcertno -- 企业实控人证件号码
            ,actcertname -- 企业实控人证件名
            ,staffnum -- 职工人数
            ,income -- 营业收入，单位元
            ,arno -- 方案合约号（代表一种合作模式，区分旺农贷和中和农信）
            ,lprlimit -- 利率上限LPR，网商贷默认一年期LPR
            ,lprbottom -- 利率下限LPR，网商贷默认一年期LPR
            ,floatratebplimit -- 利率上限浮动点差BP
            ,floatratebpbottom -- 利率下限浮动点差BP
            ,ratefloatmodelimit -- 利率上限浮动方式
            ,ratefloatmodebottom -- 利率下限浮动方式
            ,applytimes -- 申请次数（同一客户）
            ,custinst -- 客引机构ID(区分旺农贷、中和农信)
            ,csappresult -- 网商贷初审结论
            ,balstatus -- 额度状态
            ,authorizationbookid -- 授权书编号
            ,isfreshcust -- 是否绿色信贷
            ,loanusetype -- 贷款用途
            ,ownapplyamount -- 我行审批额度
            ,greenloanflag -- 绿色信贷标识
            ,greenloanuse -- 绿色贷款用途
            ,gradeamt -- 命中反洗钱评级
            ,openingflag -- 开户标识
            ,csretry -- 初审重试次数
            ,zsretry -- 终审重试次数
            ,issendbooster -- 是否已发booster接口: YesNo
            ,sendriskstatus -- 发送风控状态: onlineFlowStatus
            ,noticedate -- 通知时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybkzd_iqp_loan_app_op(
            serialno -- 业务流水号
            ,applyno -- 蚂蚁申请单号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,applydate -- 申请日期
            ,certtype -- 证件类型
            ,certcode -- 证件号码
            ,cusname -- 姓名
            ,cusid -- 客户号
            ,platformaccess -- 网商贷审批结果
            ,platformadmit -- 授信建议额度
            ,platformratelimit -- 授信年利率上限
            ,platformratebottom -- 授信年利率下限
            ,failreason -- 拒绝原因
            ,applyamount -- 审批额度(元)
            ,rulingir -- 年利率
            ,startdate -- 审批开始时间
            ,enddate -- 审批结束时间
            ,approvestatus -- 审批状态
            ,informflag -- 初审通知成功与否
            ,informfinalflag -- 终审通知成功与否
            ,lastadvicedate -- 终审通知时间
            ,inputid -- 登记人
            ,inputbrid -- 登记机构
            ,businessmodel -- 业务模式
            ,refusecode -- 拒绝码
            ,ackmsg -- 拒绝原因
            ,csapprovestatus -- 初审审批状态
            ,targetjyflag2 -- 客群经营标签（人行口径）
            ,targetjyflag3 -- 客群经营标签（银监口径）
            ,farmerflag -- 是否农户
            ,mobile -- 手机号码
            ,requestid -- 初审幂等ID
            ,zsrequestid -- 终审幂等ID
            ,loanar -- 业务场景
            ,bsntype -- 产品业务类型
            ,actcerttype -- 企业实控人证件类型
            ,actcertno -- 企业实控人证件号码
            ,actcertname -- 企业实控人证件名
            ,staffnum -- 职工人数
            ,income -- 营业收入，单位元
            ,arno -- 方案合约号（代表一种合作模式，区分旺农贷和中和农信）
            ,lprlimit -- 利率上限LPR，网商贷默认一年期LPR
            ,lprbottom -- 利率下限LPR，网商贷默认一年期LPR
            ,floatratebplimit -- 利率上限浮动点差BP
            ,floatratebpbottom -- 利率下限浮动点差BP
            ,ratefloatmodelimit -- 利率上限浮动方式
            ,ratefloatmodebottom -- 利率下限浮动方式
            ,applytimes -- 申请次数（同一客户）
            ,custinst -- 客引机构ID(区分旺农贷、中和农信)
            ,csappresult -- 网商贷初审结论
            ,balstatus -- 额度状态
            ,authorizationbookid -- 授权书编号
            ,isfreshcust -- 是否绿色信贷
            ,loanusetype -- 贷款用途
            ,ownapplyamount -- 我行审批额度
            ,greenloanflag -- 绿色信贷标识
            ,greenloanuse -- 绿色贷款用途
            ,gradeamt -- 命中反洗钱评级
            ,openingflag -- 开户标识
            ,csretry -- 初审重试次数
            ,zsretry -- 终审重试次数
            ,issendbooster -- 是否已发booster接口: YesNo
            ,sendriskstatus -- 发送风控状态: onlineFlowStatus
            ,noticedate -- 通知时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 业务流水号
    ,nvl(n.applyno, o.applyno) as applyno -- 蚂蚁申请单号
    ,nvl(n.prdcode, o.prdcode) as prdcode -- 产品编号
    ,nvl(n.prdname, o.prdname) as prdname -- 产品名称
    ,nvl(n.applydate, o.applydate) as applydate -- 申请日期
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certcode, o.certcode) as certcode -- 证件号码
    ,nvl(n.cusname, o.cusname) as cusname -- 姓名
    ,nvl(n.cusid, o.cusid) as cusid -- 客户号
    ,nvl(n.platformaccess, o.platformaccess) as platformaccess -- 网商贷审批结果
    ,nvl(n.platformadmit, o.platformadmit) as platformadmit -- 授信建议额度
    ,nvl(n.platformratelimit, o.platformratelimit) as platformratelimit -- 授信年利率上限
    ,nvl(n.platformratebottom, o.platformratebottom) as platformratebottom -- 授信年利率下限
    ,nvl(n.failreason, o.failreason) as failreason -- 拒绝原因
    ,nvl(n.applyamount, o.applyamount) as applyamount -- 审批额度(元)
    ,nvl(n.rulingir, o.rulingir) as rulingir -- 年利率
    ,nvl(n.startdate, o.startdate) as startdate -- 审批开始时间
    ,nvl(n.enddate, o.enddate) as enddate -- 审批结束时间
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.informflag, o.informflag) as informflag -- 初审通知成功与否
    ,nvl(n.informfinalflag, o.informfinalflag) as informfinalflag -- 终审通知成功与否
    ,nvl(n.lastadvicedate, o.lastadvicedate) as lastadvicedate -- 终审通知时间
    ,nvl(n.inputid, o.inputid) as inputid -- 登记人
    ,nvl(n.inputbrid, o.inputbrid) as inputbrid -- 登记机构
    ,nvl(n.businessmodel, o.businessmodel) as businessmodel -- 业务模式
    ,nvl(n.refusecode, o.refusecode) as refusecode -- 拒绝码
    ,nvl(n.ackmsg, o.ackmsg) as ackmsg -- 拒绝原因
    ,nvl(n.csapprovestatus, o.csapprovestatus) as csapprovestatus -- 初审审批状态
    ,nvl(n.targetjyflag2, o.targetjyflag2) as targetjyflag2 -- 客群经营标签（人行口径）
    ,nvl(n.targetjyflag3, o.targetjyflag3) as targetjyflag3 -- 客群经营标签（银监口径）
    ,nvl(n.farmerflag, o.farmerflag) as farmerflag -- 是否农户
    ,nvl(n.mobile, o.mobile) as mobile -- 手机号码
    ,nvl(n.requestid, o.requestid) as requestid -- 初审幂等ID
    ,nvl(n.zsrequestid, o.zsrequestid) as zsrequestid -- 终审幂等ID
    ,nvl(n.loanar, o.loanar) as loanar -- 业务场景
    ,nvl(n.bsntype, o.bsntype) as bsntype -- 产品业务类型
    ,nvl(n.actcerttype, o.actcerttype) as actcerttype -- 企业实控人证件类型
    ,nvl(n.actcertno, o.actcertno) as actcertno -- 企业实控人证件号码
    ,nvl(n.actcertname, o.actcertname) as actcertname -- 企业实控人证件名
    ,nvl(n.staffnum, o.staffnum) as staffnum -- 职工人数
    ,nvl(n.income, o.income) as income -- 营业收入，单位元
    ,nvl(n.arno, o.arno) as arno -- 方案合约号（代表一种合作模式，区分旺农贷和中和农信）
    ,nvl(n.lprlimit, o.lprlimit) as lprlimit -- 利率上限LPR，网商贷默认一年期LPR
    ,nvl(n.lprbottom, o.lprbottom) as lprbottom -- 利率下限LPR，网商贷默认一年期LPR
    ,nvl(n.floatratebplimit, o.floatratebplimit) as floatratebplimit -- 利率上限浮动点差BP
    ,nvl(n.floatratebpbottom, o.floatratebpbottom) as floatratebpbottom -- 利率下限浮动点差BP
    ,nvl(n.ratefloatmodelimit, o.ratefloatmodelimit) as ratefloatmodelimit -- 利率上限浮动方式
    ,nvl(n.ratefloatmodebottom, o.ratefloatmodebottom) as ratefloatmodebottom -- 利率下限浮动方式
    ,nvl(n.applytimes, o.applytimes) as applytimes -- 申请次数（同一客户）
    ,nvl(n.custinst, o.custinst) as custinst -- 客引机构ID(区分旺农贷、中和农信)
    ,nvl(n.csappresult, o.csappresult) as csappresult -- 网商贷初审结论
    ,nvl(n.balstatus, o.balstatus) as balstatus -- 额度状态
    ,nvl(n.authorizationbookid, o.authorizationbookid) as authorizationbookid -- 授权书编号
    ,nvl(n.isfreshcust, o.isfreshcust) as isfreshcust -- 是否绿色信贷
    ,nvl(n.loanusetype, o.loanusetype) as loanusetype -- 贷款用途
    ,nvl(n.ownapplyamount, o.ownapplyamount) as ownapplyamount -- 我行审批额度
    ,nvl(n.greenloanflag, o.greenloanflag) as greenloanflag -- 绿色信贷标识
    ,nvl(n.greenloanuse, o.greenloanuse) as greenloanuse -- 绿色贷款用途
    ,nvl(n.gradeamt, o.gradeamt) as gradeamt -- 命中反洗钱评级
    ,nvl(n.openingflag, o.openingflag) as openingflag -- 开户标识
    ,nvl(n.csretry, o.csretry) as csretry -- 初审重试次数
    ,nvl(n.zsretry, o.zsretry) as zsretry -- 终审重试次数
    ,nvl(n.issendbooster, o.issendbooster) as issendbooster -- 是否已发booster接口: YesNo
    ,nvl(n.sendriskstatus, o.sendriskstatus) as sendriskstatus -- 发送风控状态: onlineFlowStatus
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
from (select * from ${iol_schema}.icms_mybkzd_iqp_loan_app_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_mybkzd_iqp_loan_app where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.applydate <> n.applydate
        or o.certtype <> n.certtype
        or o.certcode <> n.certcode
        or o.cusname <> n.cusname
        or o.cusid <> n.cusid
        or o.platformaccess <> n.platformaccess
        or o.platformadmit <> n.platformadmit
        or o.platformratelimit <> n.platformratelimit
        or o.platformratebottom <> n.platformratebottom
        or o.failreason <> n.failreason
        or o.applyamount <> n.applyamount
        or o.rulingir <> n.rulingir
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.approvestatus <> n.approvestatus
        or o.informflag <> n.informflag
        or o.informfinalflag <> n.informfinalflag
        or o.lastadvicedate <> n.lastadvicedate
        or o.inputid <> n.inputid
        or o.inputbrid <> n.inputbrid
        or o.businessmodel <> n.businessmodel
        or o.refusecode <> n.refusecode
        or o.ackmsg <> n.ackmsg
        or o.csapprovestatus <> n.csapprovestatus
        or o.targetjyflag2 <> n.targetjyflag2
        or o.targetjyflag3 <> n.targetjyflag3
        or o.farmerflag <> n.farmerflag
        or o.mobile <> n.mobile
        or o.requestid <> n.requestid
        or o.zsrequestid <> n.zsrequestid
        or o.loanar <> n.loanar
        or o.bsntype <> n.bsntype
        or o.actcerttype <> n.actcerttype
        or o.actcertno <> n.actcertno
        or o.actcertname <> n.actcertname
        or o.staffnum <> n.staffnum
        or o.income <> n.income
        or o.arno <> n.arno
        or o.lprlimit <> n.lprlimit
        or o.lprbottom <> n.lprbottom
        or o.floatratebplimit <> n.floatratebplimit
        or o.floatratebpbottom <> n.floatratebpbottom
        or o.ratefloatmodelimit <> n.ratefloatmodelimit
        or o.ratefloatmodebottom <> n.ratefloatmodebottom
        or o.applytimes <> n.applytimes
        or o.custinst <> n.custinst
        or o.csappresult <> n.csappresult
        or o.balstatus <> n.balstatus
        or o.authorizationbookid <> n.authorizationbookid
        or o.isfreshcust <> n.isfreshcust
        or o.loanusetype <> n.loanusetype
        or o.ownapplyamount <> n.ownapplyamount
        or o.greenloanflag <> n.greenloanflag
        or o.greenloanuse <> n.greenloanuse
        or o.gradeamt <> n.gradeamt
        or o.openingflag <> n.openingflag
        or o.csretry <> n.csretry
        or o.zsretry <> n.zsretry
        or o.issendbooster <> n.issendbooster
        or o.sendriskstatus <> n.sendriskstatus
        or o.noticedate <> n.noticedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybkzd_iqp_loan_app_cl(
            serialno -- 业务流水号
            ,applyno -- 蚂蚁申请单号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,applydate -- 申请日期
            ,certtype -- 证件类型
            ,certcode -- 证件号码
            ,cusname -- 姓名
            ,cusid -- 客户号
            ,platformaccess -- 网商贷审批结果
            ,platformadmit -- 授信建议额度
            ,platformratelimit -- 授信年利率上限
            ,platformratebottom -- 授信年利率下限
            ,failreason -- 拒绝原因
            ,applyamount -- 审批额度(元)
            ,rulingir -- 年利率
            ,startdate -- 审批开始时间
            ,enddate -- 审批结束时间
            ,approvestatus -- 审批状态
            ,informflag -- 初审通知成功与否
            ,informfinalflag -- 终审通知成功与否
            ,lastadvicedate -- 终审通知时间
            ,inputid -- 登记人
            ,inputbrid -- 登记机构
            ,businessmodel -- 业务模式
            ,refusecode -- 拒绝码
            ,ackmsg -- 拒绝原因
            ,csapprovestatus -- 初审审批状态
            ,targetjyflag2 -- 客群经营标签（人行口径）
            ,targetjyflag3 -- 客群经营标签（银监口径）
            ,farmerflag -- 是否农户
            ,mobile -- 手机号码
            ,requestid -- 初审幂等ID
            ,zsrequestid -- 终审幂等ID
            ,loanar -- 业务场景
            ,bsntype -- 产品业务类型
            ,actcerttype -- 企业实控人证件类型
            ,actcertno -- 企业实控人证件号码
            ,actcertname -- 企业实控人证件名
            ,staffnum -- 职工人数
            ,income -- 营业收入，单位元
            ,arno -- 方案合约号（代表一种合作模式，区分旺农贷和中和农信）
            ,lprlimit -- 利率上限LPR，网商贷默认一年期LPR
            ,lprbottom -- 利率下限LPR，网商贷默认一年期LPR
            ,floatratebplimit -- 利率上限浮动点差BP
            ,floatratebpbottom -- 利率下限浮动点差BP
            ,ratefloatmodelimit -- 利率上限浮动方式
            ,ratefloatmodebottom -- 利率下限浮动方式
            ,applytimes -- 申请次数（同一客户）
            ,custinst -- 客引机构ID(区分旺农贷、中和农信)
            ,csappresult -- 网商贷初审结论
            ,balstatus -- 额度状态
            ,authorizationbookid -- 授权书编号
            ,isfreshcust -- 是否绿色信贷
            ,loanusetype -- 贷款用途
            ,ownapplyamount -- 我行审批额度
            ,greenloanflag -- 绿色信贷标识
            ,greenloanuse -- 绿色贷款用途
            ,gradeamt -- 命中反洗钱评级
            ,openingflag -- 开户标识
            ,csretry -- 初审重试次数
            ,zsretry -- 终审重试次数
            ,issendbooster -- 是否已发booster接口: YesNo
            ,sendriskstatus -- 发送风控状态: onlineFlowStatus
            ,noticedate -- 通知时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybkzd_iqp_loan_app_op(
            serialno -- 业务流水号
            ,applyno -- 蚂蚁申请单号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,applydate -- 申请日期
            ,certtype -- 证件类型
            ,certcode -- 证件号码
            ,cusname -- 姓名
            ,cusid -- 客户号
            ,platformaccess -- 网商贷审批结果
            ,platformadmit -- 授信建议额度
            ,platformratelimit -- 授信年利率上限
            ,platformratebottom -- 授信年利率下限
            ,failreason -- 拒绝原因
            ,applyamount -- 审批额度(元)
            ,rulingir -- 年利率
            ,startdate -- 审批开始时间
            ,enddate -- 审批结束时间
            ,approvestatus -- 审批状态
            ,informflag -- 初审通知成功与否
            ,informfinalflag -- 终审通知成功与否
            ,lastadvicedate -- 终审通知时间
            ,inputid -- 登记人
            ,inputbrid -- 登记机构
            ,businessmodel -- 业务模式
            ,refusecode -- 拒绝码
            ,ackmsg -- 拒绝原因
            ,csapprovestatus -- 初审审批状态
            ,targetjyflag2 -- 客群经营标签（人行口径）
            ,targetjyflag3 -- 客群经营标签（银监口径）
            ,farmerflag -- 是否农户
            ,mobile -- 手机号码
            ,requestid -- 初审幂等ID
            ,zsrequestid -- 终审幂等ID
            ,loanar -- 业务场景
            ,bsntype -- 产品业务类型
            ,actcerttype -- 企业实控人证件类型
            ,actcertno -- 企业实控人证件号码
            ,actcertname -- 企业实控人证件名
            ,staffnum -- 职工人数
            ,income -- 营业收入，单位元
            ,arno -- 方案合约号（代表一种合作模式，区分旺农贷和中和农信）
            ,lprlimit -- 利率上限LPR，网商贷默认一年期LPR
            ,lprbottom -- 利率下限LPR，网商贷默认一年期LPR
            ,floatratebplimit -- 利率上限浮动点差BP
            ,floatratebpbottom -- 利率下限浮动点差BP
            ,ratefloatmodelimit -- 利率上限浮动方式
            ,ratefloatmodebottom -- 利率下限浮动方式
            ,applytimes -- 申请次数（同一客户）
            ,custinst -- 客引机构ID(区分旺农贷、中和农信)
            ,csappresult -- 网商贷初审结论
            ,balstatus -- 额度状态
            ,authorizationbookid -- 授权书编号
            ,isfreshcust -- 是否绿色信贷
            ,loanusetype -- 贷款用途
            ,ownapplyamount -- 我行审批额度
            ,greenloanflag -- 绿色信贷标识
            ,greenloanuse -- 绿色贷款用途
            ,gradeamt -- 命中反洗钱评级
            ,openingflag -- 开户标识
            ,csretry -- 初审重试次数
            ,zsretry -- 终审重试次数
            ,issendbooster -- 是否已发booster接口: YesNo
            ,sendriskstatus -- 发送风控状态: onlineFlowStatus
            ,noticedate -- 通知时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 业务流水号
    ,o.applyno -- 蚂蚁申请单号
    ,o.prdcode -- 产品编号
    ,o.prdname -- 产品名称
    ,o.applydate -- 申请日期
    ,o.certtype -- 证件类型
    ,o.certcode -- 证件号码
    ,o.cusname -- 姓名
    ,o.cusid -- 客户号
    ,o.platformaccess -- 网商贷审批结果
    ,o.platformadmit -- 授信建议额度
    ,o.platformratelimit -- 授信年利率上限
    ,o.platformratebottom -- 授信年利率下限
    ,o.failreason -- 拒绝原因
    ,o.applyamount -- 审批额度(元)
    ,o.rulingir -- 年利率
    ,o.startdate -- 审批开始时间
    ,o.enddate -- 审批结束时间
    ,o.approvestatus -- 审批状态
    ,o.informflag -- 初审通知成功与否
    ,o.informfinalflag -- 终审通知成功与否
    ,o.lastadvicedate -- 终审通知时间
    ,o.inputid -- 登记人
    ,o.inputbrid -- 登记机构
    ,o.businessmodel -- 业务模式
    ,o.refusecode -- 拒绝码
    ,o.ackmsg -- 拒绝原因
    ,o.csapprovestatus -- 初审审批状态
    ,o.targetjyflag2 -- 客群经营标签（人行口径）
    ,o.targetjyflag3 -- 客群经营标签（银监口径）
    ,o.farmerflag -- 是否农户
    ,o.mobile -- 手机号码
    ,o.requestid -- 初审幂等ID
    ,o.zsrequestid -- 终审幂等ID
    ,o.loanar -- 业务场景
    ,o.bsntype -- 产品业务类型
    ,o.actcerttype -- 企业实控人证件类型
    ,o.actcertno -- 企业实控人证件号码
    ,o.actcertname -- 企业实控人证件名
    ,o.staffnum -- 职工人数
    ,o.income -- 营业收入，单位元
    ,o.arno -- 方案合约号（代表一种合作模式，区分旺农贷和中和农信）
    ,o.lprlimit -- 利率上限LPR，网商贷默认一年期LPR
    ,o.lprbottom -- 利率下限LPR，网商贷默认一年期LPR
    ,o.floatratebplimit -- 利率上限浮动点差BP
    ,o.floatratebpbottom -- 利率下限浮动点差BP
    ,o.ratefloatmodelimit -- 利率上限浮动方式
    ,o.ratefloatmodebottom -- 利率下限浮动方式
    ,o.applytimes -- 申请次数（同一客户）
    ,o.custinst -- 客引机构ID(区分旺农贷、中和农信)
    ,o.csappresult -- 网商贷初审结论
    ,o.balstatus -- 额度状态
    ,o.authorizationbookid -- 授权书编号
    ,o.isfreshcust -- 是否绿色信贷
    ,o.loanusetype -- 贷款用途
    ,o.ownapplyamount -- 我行审批额度
    ,o.greenloanflag -- 绿色信贷标识
    ,o.greenloanuse -- 绿色贷款用途
    ,o.gradeamt -- 命中反洗钱评级
    ,o.openingflag -- 开户标识
    ,o.csretry -- 初审重试次数
    ,o.zsretry -- 终审重试次数
    ,o.issendbooster -- 是否已发booster接口: YesNo
    ,o.sendriskstatus -- 发送风控状态: onlineFlowStatus
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
from ${iol_schema}.icms_mybkzd_iqp_loan_app_bk o
    left join ${iol_schema}.icms_mybkzd_iqp_loan_app_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_mybkzd_iqp_loan_app_cl d
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
--truncate table ${iol_schema}.icms_mybkzd_iqp_loan_app;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_mybkzd_iqp_loan_app') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_mybkzd_iqp_loan_app drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_mybkzd_iqp_loan_app add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_mybkzd_iqp_loan_app exchange partition p_${batch_date} with table ${iol_schema}.icms_mybkzd_iqp_loan_app_cl;
alter table ${iol_schema}.icms_mybkzd_iqp_loan_app exchange partition p_20991231 with table ${iol_schema}.icms_mybkzd_iqp_loan_app_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybkzd_iqp_loan_app to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybkzd_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_mybkzd_iqp_loan_app_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_mybkzd_iqp_loan_app_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybkzd_iqp_loan_app',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
