/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_myzy_iqp_loan_app
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
create table ${iol_schema}.icms_myzy_iqp_loan_app_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_myzy_iqp_loan_app
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myzy_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_myzy_iqp_loan_app_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myzy_iqp_loan_app_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_myzy_iqp_loan_app where 0=1;

create table ${iol_schema}.icms_myzy_iqp_loan_app_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_myzy_iqp_loan_app where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_myzy_iqp_loan_app_cl(
            serno -- 流水号
            ,requestid -- 请求流水号
            ,cusnamenew -- 新姓名
            ,ischeckrule -- 反欺诈是否已校验标识
            ,resultmsg -- 审批结果描述
            ,telenew -- 新联系方式
            ,sysid -- 处理业务系统ID
            ,floatratebp -- 利率浮动点差BP
            ,creditflag -- 当前用户授信标识
            ,nationalitynew -- 新国籍
            ,cusid -- 客户号
            ,validdatestartnew -- 新证件有效期起始日
            ,source -- 申请来源
            ,cardno -- 快捷卡卡号
            ,certvalidenddate -- 证件有效期
            ,inputid -- 登记人
            ,isapplyscore -- 发送评分接口成功与否
            ,execrate -- 执行年利率，借呗推送日利率X360
            ,validdateendnew -- 新证件有效期到期日
            ,startdate -- 审批开始时间
            ,promotereason -- 调额的原因说明
            ,certcodenew -- 新证件号码
            ,zmauthflag -- 芝麻授权成功表示
            ,prdcode -- 产品编号
            ,applyno -- 授信申请单号
            ,repaymode -- 还款方式
            ,expired -- 申请过期时间
            ,expirydate -- 固化授信有效期
            ,lpr -- LPR
            ,productcode -- 产品标识
            ,hasjbadmit -- 是否之前就有借呗额度
            ,cusname -- 客户姓名
            ,rulingir -- 基准利率
            ,informflag -- 通知借呗成功与否
            ,failreason -- 备注信息
            ,bizmode -- 业务模式
            ,promotetype -- 调额的类型
            ,certtypenew -- 新证件类型
            ,inputbrid -- 登记机构
            ,approvestatus -- 审批状态
            ,autoscore -- 评分A卡评分
            ,creditno -- 授信编号
            ,applydate -- 申请日期
            ,modeltype -- 所属模块
            ,riskrating -- 风险评级
            ,migtflag -- 
            ,certtype -- 证件类型
            ,isgetcuscode -- 是否开户成功
            ,isagree -- 借呗是否同意审批结果
            ,sexnew -- 新性别
            ,resultcode -- 审批结果码
            ,iscreditadopted -- 征信规则校验结果
            ,lastadvicedate -- 终审通知时间
            ,applyamount -- 审批额度(元)
            ,enddate -- 审批结束时间
            ,isintercept -- 是否成功发起MQ
            ,iscollectcredit -- 个人征信采集成功与否
            ,addressnew -- 新地址
            ,ratefloatmode -- 利率浮动方式
            ,ratetype -- 利率类型1基准2lpr
            ,professionnew -- 新职业
            ,prdname -- 产品名称
            ,biztype -- 申请类型
            ,certcode -- 证件号码
            ,mobileno -- 手机号
            ,changeresultreason -- 额度、定价变更原因
            ,solvencyratings -- 偿债能力评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_myzy_iqp_loan_app_op(
            serno -- 流水号
            ,requestid -- 请求流水号
            ,cusnamenew -- 新姓名
            ,ischeckrule -- 反欺诈是否已校验标识
            ,resultmsg -- 审批结果描述
            ,telenew -- 新联系方式
            ,sysid -- 处理业务系统ID
            ,floatratebp -- 利率浮动点差BP
            ,creditflag -- 当前用户授信标识
            ,nationalitynew -- 新国籍
            ,cusid -- 客户号
            ,validdatestartnew -- 新证件有效期起始日
            ,source -- 申请来源
            ,cardno -- 快捷卡卡号
            ,certvalidenddate -- 证件有效期
            ,inputid -- 登记人
            ,isapplyscore -- 发送评分接口成功与否
            ,execrate -- 执行年利率，借呗推送日利率X360
            ,validdateendnew -- 新证件有效期到期日
            ,startdate -- 审批开始时间
            ,promotereason -- 调额的原因说明
            ,certcodenew -- 新证件号码
            ,zmauthflag -- 芝麻授权成功表示
            ,prdcode -- 产品编号
            ,applyno -- 授信申请单号
            ,repaymode -- 还款方式
            ,expired -- 申请过期时间
            ,expirydate -- 固化授信有效期
            ,lpr -- LPR
            ,productcode -- 产品标识
            ,hasjbadmit -- 是否之前就有借呗额度
            ,cusname -- 客户姓名
            ,rulingir -- 基准利率
            ,informflag -- 通知借呗成功与否
            ,failreason -- 备注信息
            ,bizmode -- 业务模式
            ,promotetype -- 调额的类型
            ,certtypenew -- 新证件类型
            ,inputbrid -- 登记机构
            ,approvestatus -- 审批状态
            ,autoscore -- 评分A卡评分
            ,creditno -- 授信编号
            ,applydate -- 申请日期
            ,modeltype -- 所属模块
            ,riskrating -- 风险评级
            ,migtflag -- 
            ,certtype -- 证件类型
            ,isgetcuscode -- 是否开户成功
            ,isagree -- 借呗是否同意审批结果
            ,sexnew -- 新性别
            ,resultcode -- 审批结果码
            ,iscreditadopted -- 征信规则校验结果
            ,lastadvicedate -- 终审通知时间
            ,applyamount -- 审批额度(元)
            ,enddate -- 审批结束时间
            ,isintercept -- 是否成功发起MQ
            ,iscollectcredit -- 个人征信采集成功与否
            ,addressnew -- 新地址
            ,ratefloatmode -- 利率浮动方式
            ,ratetype -- 利率类型1基准2lpr
            ,professionnew -- 新职业
            ,prdname -- 产品名称
            ,biztype -- 申请类型
            ,certcode -- 证件号码
            ,mobileno -- 手机号
            ,changeresultreason -- 额度、定价变更原因
            ,solvencyratings -- 偿债能力评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serno, o.serno) as serno -- 流水号
    ,nvl(n.requestid, o.requestid) as requestid -- 请求流水号
    ,nvl(n.cusnamenew, o.cusnamenew) as cusnamenew -- 新姓名
    ,nvl(n.ischeckrule, o.ischeckrule) as ischeckrule -- 反欺诈是否已校验标识
    ,nvl(n.resultmsg, o.resultmsg) as resultmsg -- 审批结果描述
    ,nvl(n.telenew, o.telenew) as telenew -- 新联系方式
    ,nvl(n.sysid, o.sysid) as sysid -- 处理业务系统ID
    ,nvl(n.floatratebp, o.floatratebp) as floatratebp -- 利率浮动点差BP
    ,nvl(n.creditflag, o.creditflag) as creditflag -- 当前用户授信标识
    ,nvl(n.nationalitynew, o.nationalitynew) as nationalitynew -- 新国籍
    ,nvl(n.cusid, o.cusid) as cusid -- 客户号
    ,nvl(n.validdatestartnew, o.validdatestartnew) as validdatestartnew -- 新证件有效期起始日
    ,nvl(n.source, o.source) as source -- 申请来源
    ,nvl(n.cardno, o.cardno) as cardno -- 快捷卡卡号
    ,nvl(n.certvalidenddate, o.certvalidenddate) as certvalidenddate -- 证件有效期
    ,nvl(n.inputid, o.inputid) as inputid -- 登记人
    ,nvl(n.isapplyscore, o.isapplyscore) as isapplyscore -- 发送评分接口成功与否
    ,nvl(n.execrate, o.execrate) as execrate -- 执行年利率，借呗推送日利率X360
    ,nvl(n.validdateendnew, o.validdateendnew) as validdateendnew -- 新证件有效期到期日
    ,nvl(n.startdate, o.startdate) as startdate -- 审批开始时间
    ,nvl(n.promotereason, o.promotereason) as promotereason -- 调额的原因说明
    ,nvl(n.certcodenew, o.certcodenew) as certcodenew -- 新证件号码
    ,nvl(n.zmauthflag, o.zmauthflag) as zmauthflag -- 芝麻授权成功表示
    ,nvl(n.prdcode, o.prdcode) as prdcode -- 产品编号
    ,nvl(n.applyno, o.applyno) as applyno -- 授信申请单号
    ,nvl(n.repaymode, o.repaymode) as repaymode -- 还款方式
    ,nvl(n.expired, o.expired) as expired -- 申请过期时间
    ,nvl(n.expirydate, o.expirydate) as expirydate -- 固化授信有效期
    ,nvl(n.lpr, o.lpr) as lpr -- LPR
    ,nvl(n.productcode, o.productcode) as productcode -- 产品标识
    ,nvl(n.hasjbadmit, o.hasjbadmit) as hasjbadmit -- 是否之前就有借呗额度
    ,nvl(n.cusname, o.cusname) as cusname -- 客户姓名
    ,nvl(n.rulingir, o.rulingir) as rulingir -- 基准利率
    ,nvl(n.informflag, o.informflag) as informflag -- 通知借呗成功与否
    ,nvl(n.failreason, o.failreason) as failreason -- 备注信息
    ,nvl(n.bizmode, o.bizmode) as bizmode -- 业务模式
    ,nvl(n.promotetype, o.promotetype) as promotetype -- 调额的类型
    ,nvl(n.certtypenew, o.certtypenew) as certtypenew -- 新证件类型
    ,nvl(n.inputbrid, o.inputbrid) as inputbrid -- 登记机构
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.autoscore, o.autoscore) as autoscore -- 评分A卡评分
    ,nvl(n.creditno, o.creditno) as creditno -- 授信编号
    ,nvl(n.applydate, o.applydate) as applydate -- 申请日期
    ,nvl(n.modeltype, o.modeltype) as modeltype -- 所属模块
    ,nvl(n.riskrating, o.riskrating) as riskrating -- 风险评级
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.isgetcuscode, o.isgetcuscode) as isgetcuscode -- 是否开户成功
    ,nvl(n.isagree, o.isagree) as isagree -- 借呗是否同意审批结果
    ,nvl(n.sexnew, o.sexnew) as sexnew -- 新性别
    ,nvl(n.resultcode, o.resultcode) as resultcode -- 审批结果码
    ,nvl(n.iscreditadopted, o.iscreditadopted) as iscreditadopted -- 征信规则校验结果
    ,nvl(n.lastadvicedate, o.lastadvicedate) as lastadvicedate -- 终审通知时间
    ,nvl(n.applyamount, o.applyamount) as applyamount -- 审批额度(元)
    ,nvl(n.enddate, o.enddate) as enddate -- 审批结束时间
    ,nvl(n.isintercept, o.isintercept) as isintercept -- 是否成功发起MQ
    ,nvl(n.iscollectcredit, o.iscollectcredit) as iscollectcredit -- 个人征信采集成功与否
    ,nvl(n.addressnew, o.addressnew) as addressnew -- 新地址
    ,nvl(n.ratefloatmode, o.ratefloatmode) as ratefloatmode -- 利率浮动方式
    ,nvl(n.ratetype, o.ratetype) as ratetype -- 利率类型1基准2lpr
    ,nvl(n.professionnew, o.professionnew) as professionnew -- 新职业
    ,nvl(n.prdname, o.prdname) as prdname -- 产品名称
    ,nvl(n.biztype, o.biztype) as biztype -- 申请类型
    ,nvl(n.certcode, o.certcode) as certcode -- 证件号码
    ,nvl(n.mobileno, o.mobileno) as mobileno -- 手机号
    ,nvl(n.changeresultreason, o.changeresultreason) as changeresultreason -- 额度、定价变更原因
    ,nvl(n.solvencyratings, o.solvencyratings) as solvencyratings -- 偿债能力评级
    ,case when
            n.serno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_myzy_iqp_loan_app_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_myzy_iqp_loan_app where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serno = n.serno
where (
        o.serno is null
    )
    or (
        n.serno is null
    )
    or (
        o.requestid <> n.requestid
        or o.cusnamenew <> n.cusnamenew
        or o.ischeckrule <> n.ischeckrule
        or o.resultmsg <> n.resultmsg
        or o.telenew <> n.telenew
        or o.sysid <> n.sysid
        or o.floatratebp <> n.floatratebp
        or o.creditflag <> n.creditflag
        or o.nationalitynew <> n.nationalitynew
        or o.cusid <> n.cusid
        or o.validdatestartnew <> n.validdatestartnew
        or o.source <> n.source
        or o.cardno <> n.cardno
        or o.certvalidenddate <> n.certvalidenddate
        or o.inputid <> n.inputid
        or o.isapplyscore <> n.isapplyscore
        or o.execrate <> n.execrate
        or o.validdateendnew <> n.validdateendnew
        or o.startdate <> n.startdate
        or o.promotereason <> n.promotereason
        or o.certcodenew <> n.certcodenew
        or o.zmauthflag <> n.zmauthflag
        or o.prdcode <> n.prdcode
        or o.applyno <> n.applyno
        or o.repaymode <> n.repaymode
        or o.expired <> n.expired
        or o.expirydate <> n.expirydate
        or o.lpr <> n.lpr
        or o.productcode <> n.productcode
        or o.hasjbadmit <> n.hasjbadmit
        or o.cusname <> n.cusname
        or o.rulingir <> n.rulingir
        or o.informflag <> n.informflag
        or o.failreason <> n.failreason
        or o.bizmode <> n.bizmode
        or o.promotetype <> n.promotetype
        or o.certtypenew <> n.certtypenew
        or o.inputbrid <> n.inputbrid
        or o.approvestatus <> n.approvestatus
        or o.autoscore <> n.autoscore
        or o.creditno <> n.creditno
        or o.applydate <> n.applydate
        or o.modeltype <> n.modeltype
        or o.riskrating <> n.riskrating
        or o.migtflag <> n.migtflag
        or o.certtype <> n.certtype
        or o.isgetcuscode <> n.isgetcuscode
        or o.isagree <> n.isagree
        or o.sexnew <> n.sexnew
        or o.resultcode <> n.resultcode
        or o.iscreditadopted <> n.iscreditadopted
        or o.lastadvicedate <> n.lastadvicedate
        or o.applyamount <> n.applyamount
        or o.enddate <> n.enddate
        or o.isintercept <> n.isintercept
        or o.iscollectcredit <> n.iscollectcredit
        or o.addressnew <> n.addressnew
        or o.ratefloatmode <> n.ratefloatmode
        or o.ratetype <> n.ratetype
        or o.professionnew <> n.professionnew
        or o.prdname <> n.prdname
        or o.biztype <> n.biztype
        or o.certcode <> n.certcode
        or o.mobileno <> n.mobileno
        or o.changeresultreason <> n.changeresultreason
        or o.solvencyratings <> n.solvencyratings
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_myzy_iqp_loan_app_cl(
            serno -- 流水号
            ,requestid -- 请求流水号
            ,cusnamenew -- 新姓名
            ,ischeckrule -- 反欺诈是否已校验标识
            ,resultmsg -- 审批结果描述
            ,telenew -- 新联系方式
            ,sysid -- 处理业务系统ID
            ,floatratebp -- 利率浮动点差BP
            ,creditflag -- 当前用户授信标识
            ,nationalitynew -- 新国籍
            ,cusid -- 客户号
            ,validdatestartnew -- 新证件有效期起始日
            ,source -- 申请来源
            ,cardno -- 快捷卡卡号
            ,certvalidenddate -- 证件有效期
            ,inputid -- 登记人
            ,isapplyscore -- 发送评分接口成功与否
            ,execrate -- 执行年利率，借呗推送日利率X360
            ,validdateendnew -- 新证件有效期到期日
            ,startdate -- 审批开始时间
            ,promotereason -- 调额的原因说明
            ,certcodenew -- 新证件号码
            ,zmauthflag -- 芝麻授权成功表示
            ,prdcode -- 产品编号
            ,applyno -- 授信申请单号
            ,repaymode -- 还款方式
            ,expired -- 申请过期时间
            ,expirydate -- 固化授信有效期
            ,lpr -- LPR
            ,productcode -- 产品标识
            ,hasjbadmit -- 是否之前就有借呗额度
            ,cusname -- 客户姓名
            ,rulingir -- 基准利率
            ,informflag -- 通知借呗成功与否
            ,failreason -- 备注信息
            ,bizmode -- 业务模式
            ,promotetype -- 调额的类型
            ,certtypenew -- 新证件类型
            ,inputbrid -- 登记机构
            ,approvestatus -- 审批状态
            ,autoscore -- 评分A卡评分
            ,creditno -- 授信编号
            ,applydate -- 申请日期
            ,modeltype -- 所属模块
            ,riskrating -- 风险评级
            ,migtflag -- 
            ,certtype -- 证件类型
            ,isgetcuscode -- 是否开户成功
            ,isagree -- 借呗是否同意审批结果
            ,sexnew -- 新性别
            ,resultcode -- 审批结果码
            ,iscreditadopted -- 征信规则校验结果
            ,lastadvicedate -- 终审通知时间
            ,applyamount -- 审批额度(元)
            ,enddate -- 审批结束时间
            ,isintercept -- 是否成功发起MQ
            ,iscollectcredit -- 个人征信采集成功与否
            ,addressnew -- 新地址
            ,ratefloatmode -- 利率浮动方式
            ,ratetype -- 利率类型1基准2lpr
            ,professionnew -- 新职业
            ,prdname -- 产品名称
            ,biztype -- 申请类型
            ,certcode -- 证件号码
            ,mobileno -- 手机号
            ,changeresultreason -- 额度、定价变更原因
            ,solvencyratings -- 偿债能力评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_myzy_iqp_loan_app_op(
            serno -- 流水号
            ,requestid -- 请求流水号
            ,cusnamenew -- 新姓名
            ,ischeckrule -- 反欺诈是否已校验标识
            ,resultmsg -- 审批结果描述
            ,telenew -- 新联系方式
            ,sysid -- 处理业务系统ID
            ,floatratebp -- 利率浮动点差BP
            ,creditflag -- 当前用户授信标识
            ,nationalitynew -- 新国籍
            ,cusid -- 客户号
            ,validdatestartnew -- 新证件有效期起始日
            ,source -- 申请来源
            ,cardno -- 快捷卡卡号
            ,certvalidenddate -- 证件有效期
            ,inputid -- 登记人
            ,isapplyscore -- 发送评分接口成功与否
            ,execrate -- 执行年利率，借呗推送日利率X360
            ,validdateendnew -- 新证件有效期到期日
            ,startdate -- 审批开始时间
            ,promotereason -- 调额的原因说明
            ,certcodenew -- 新证件号码
            ,zmauthflag -- 芝麻授权成功表示
            ,prdcode -- 产品编号
            ,applyno -- 授信申请单号
            ,repaymode -- 还款方式
            ,expired -- 申请过期时间
            ,expirydate -- 固化授信有效期
            ,lpr -- LPR
            ,productcode -- 产品标识
            ,hasjbadmit -- 是否之前就有借呗额度
            ,cusname -- 客户姓名
            ,rulingir -- 基准利率
            ,informflag -- 通知借呗成功与否
            ,failreason -- 备注信息
            ,bizmode -- 业务模式
            ,promotetype -- 调额的类型
            ,certtypenew -- 新证件类型
            ,inputbrid -- 登记机构
            ,approvestatus -- 审批状态
            ,autoscore -- 评分A卡评分
            ,creditno -- 授信编号
            ,applydate -- 申请日期
            ,modeltype -- 所属模块
            ,riskrating -- 风险评级
            ,migtflag -- 
            ,certtype -- 证件类型
            ,isgetcuscode -- 是否开户成功
            ,isagree -- 借呗是否同意审批结果
            ,sexnew -- 新性别
            ,resultcode -- 审批结果码
            ,iscreditadopted -- 征信规则校验结果
            ,lastadvicedate -- 终审通知时间
            ,applyamount -- 审批额度(元)
            ,enddate -- 审批结束时间
            ,isintercept -- 是否成功发起MQ
            ,iscollectcredit -- 个人征信采集成功与否
            ,addressnew -- 新地址
            ,ratefloatmode -- 利率浮动方式
            ,ratetype -- 利率类型1基准2lpr
            ,professionnew -- 新职业
            ,prdname -- 产品名称
            ,biztype -- 申请类型
            ,certcode -- 证件号码
            ,mobileno -- 手机号
            ,changeresultreason -- 额度、定价变更原因
            ,solvencyratings -- 偿债能力评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serno -- 流水号
    ,o.requestid -- 请求流水号
    ,o.cusnamenew -- 新姓名
    ,o.ischeckrule -- 反欺诈是否已校验标识
    ,o.resultmsg -- 审批结果描述
    ,o.telenew -- 新联系方式
    ,o.sysid -- 处理业务系统ID
    ,o.floatratebp -- 利率浮动点差BP
    ,o.creditflag -- 当前用户授信标识
    ,o.nationalitynew -- 新国籍
    ,o.cusid -- 客户号
    ,o.validdatestartnew -- 新证件有效期起始日
    ,o.source -- 申请来源
    ,o.cardno -- 快捷卡卡号
    ,o.certvalidenddate -- 证件有效期
    ,o.inputid -- 登记人
    ,o.isapplyscore -- 发送评分接口成功与否
    ,o.execrate -- 执行年利率，借呗推送日利率X360
    ,o.validdateendnew -- 新证件有效期到期日
    ,o.startdate -- 审批开始时间
    ,o.promotereason -- 调额的原因说明
    ,o.certcodenew -- 新证件号码
    ,o.zmauthflag -- 芝麻授权成功表示
    ,o.prdcode -- 产品编号
    ,o.applyno -- 授信申请单号
    ,o.repaymode -- 还款方式
    ,o.expired -- 申请过期时间
    ,o.expirydate -- 固化授信有效期
    ,o.lpr -- LPR
    ,o.productcode -- 产品标识
    ,o.hasjbadmit -- 是否之前就有借呗额度
    ,o.cusname -- 客户姓名
    ,o.rulingir -- 基准利率
    ,o.informflag -- 通知借呗成功与否
    ,o.failreason -- 备注信息
    ,o.bizmode -- 业务模式
    ,o.promotetype -- 调额的类型
    ,o.certtypenew -- 新证件类型
    ,o.inputbrid -- 登记机构
    ,o.approvestatus -- 审批状态
    ,o.autoscore -- 评分A卡评分
    ,o.creditno -- 授信编号
    ,o.applydate -- 申请日期
    ,o.modeltype -- 所属模块
    ,o.riskrating -- 风险评级
    ,o.migtflag -- 
    ,o.certtype -- 证件类型
    ,o.isgetcuscode -- 是否开户成功
    ,o.isagree -- 借呗是否同意审批结果
    ,o.sexnew -- 新性别
    ,o.resultcode -- 审批结果码
    ,o.iscreditadopted -- 征信规则校验结果
    ,o.lastadvicedate -- 终审通知时间
    ,o.applyamount -- 审批额度(元)
    ,o.enddate -- 审批结束时间
    ,o.isintercept -- 是否成功发起MQ
    ,o.iscollectcredit -- 个人征信采集成功与否
    ,o.addressnew -- 新地址
    ,o.ratefloatmode -- 利率浮动方式
    ,o.ratetype -- 利率类型1基准2lpr
    ,o.professionnew -- 新职业
    ,o.prdname -- 产品名称
    ,o.biztype -- 申请类型
    ,o.certcode -- 证件号码
    ,o.mobileno -- 手机号
    ,o.changeresultreason -- 额度、定价变更原因
    ,o.solvencyratings -- 偿债能力评级
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
from ${iol_schema}.icms_myzy_iqp_loan_app_bk o
    left join ${iol_schema}.icms_myzy_iqp_loan_app_op n
        on
            o.serno = n.serno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_myzy_iqp_loan_app_cl d
        on
            o.serno = d.serno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_myzy_iqp_loan_app;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_myzy_iqp_loan_app') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_myzy_iqp_loan_app drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_myzy_iqp_loan_app add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_myzy_iqp_loan_app exchange partition p_${batch_date} with table ${iol_schema}.icms_myzy_iqp_loan_app_cl;
alter table ${iol_schema}.icms_myzy_iqp_loan_app exchange partition p_20991231 with table ${iol_schema}.icms_myzy_iqp_loan_app_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_myzy_iqp_loan_app to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myzy_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_myzy_iqp_loan_app_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_myzy_iqp_loan_app_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_myzy_iqp_loan_app',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
