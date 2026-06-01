/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_flow_opinion
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
create table ${iol_schema}.icms_flow_opinion_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_flow_opinion
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_flow_opinion_op purge;
drop table ${iol_schema}.icms_flow_opinion_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_flow_opinion_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_flow_opinion where 0=1;

create table ${iol_schema}.icms_flow_opinion_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_flow_opinion where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_flow_opinion_cl(
            serialno -- 流程节点编号
            ,opinionno -- 意见编号
            ,objecttype -- 流程对象任务类型
            ,objectno -- 流程对象编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,businesscurrency -- 业务币种
            ,businesssum -- 名义金额
            ,termyear -- 期限（年）
            ,termmonth -- 期限（月）
            ,termday -- 期限（日）
            ,baseratetype -- 基准利率类型
            ,ratefloattype -- 利率浮动方式
            ,ratefloat -- 利率浮动值
            ,bailcurrency -- 保证金币种
            ,businessrate -- 执行利率
            ,bailratio -- 保证金比率
            ,bailsum -- 保证金金额
            ,pdgratio -- 手续费比率
            ,pdgsum -- 手续费金额
            ,baserate -- 基准;年)利率
            ,phaseopinion -- 节点意见详情
            ,phaseopinion1 -- 意见详情1
            ,phaseopinion2 -- 意见详情2
            ,phaseopinion3 -- 意见详情3
            ,exposuresum -- 敞口金额
            ,opiniontype -- 意见类型
            ,inputorg -- 登记机构
            ,inputuser -- 登记人
            ,updateorg -- 更新机构
            ,updateuser -- 更新人
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,phasechoice -- 阶段意见
            ,warehousing -- 是否入库
            ,payreq -- 授信方案
            ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
            ,contractreq -- 需落实到合同、协议中的特殊要求
            ,loanmanagereq -- 贷后管理要求
            ,agreemachine -- 是否认可机器决策结果
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,iscycle -- 是否循环(额度);是否循环
            ,isyeartocheck -- 是否需要年审
            ,isjoinlimits -- 是否纳入单一客户或集团的限额
            ,onlineamount -- 线上额度(元)
            ,repaytype -- 还款方式
            ,repaycycle -- 还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)
            ,balloonamortenddate -- 气球贷摊销到期日
            ,coopterm -- 合作期限(月)
            ,nominalsum -- 项目总额度(元)
            ,firstusesum -- 先期启用额度
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_flow_opinion_op(
            serialno -- 流程节点编号
            ,opinionno -- 意见编号
            ,objecttype -- 流程对象任务类型
            ,objectno -- 流程对象编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,businesscurrency -- 业务币种
            ,businesssum -- 名义金额
            ,termyear -- 期限（年）
            ,termmonth -- 期限（月）
            ,termday -- 期限（日）
            ,baseratetype -- 基准利率类型
            ,ratefloattype -- 利率浮动方式
            ,ratefloat -- 利率浮动值
            ,bailcurrency -- 保证金币种
            ,businessrate -- 执行利率
            ,bailratio -- 保证金比率
            ,bailsum -- 保证金金额
            ,pdgratio -- 手续费比率
            ,pdgsum -- 手续费金额
            ,baserate -- 基准;年)利率
            ,phaseopinion -- 节点意见详情
            ,phaseopinion1 -- 意见详情1
            ,phaseopinion2 -- 意见详情2
            ,phaseopinion3 -- 意见详情3
            ,exposuresum -- 敞口金额
            ,opiniontype -- 意见类型
            ,inputorg -- 登记机构
            ,inputuser -- 登记人
            ,updateorg -- 更新机构
            ,updateuser -- 更新人
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,phasechoice -- 阶段意见
            ,warehousing -- 是否入库
            ,payreq -- 授信方案
            ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
            ,contractreq -- 需落实到合同、协议中的特殊要求
            ,loanmanagereq -- 贷后管理要求
            ,agreemachine -- 是否认可机器决策结果
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,iscycle -- 是否循环(额度);是否循环
            ,isyeartocheck -- 是否需要年审
            ,isjoinlimits -- 是否纳入单一客户或集团的限额
            ,onlineamount -- 线上额度(元)
            ,repaytype -- 还款方式
            ,repaycycle -- 还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)
            ,balloonamortenddate -- 气球贷摊销到期日
            ,coopterm -- 合作期限(月)
            ,nominalsum -- 项目总额度(元)
            ,firstusesum -- 先期启用额度
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流程节点编号
    ,nvl(n.opinionno, o.opinionno) as opinionno -- 意见编号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 流程对象任务类型
    ,nvl(n.objectno, o.objectno) as objectno -- 流程对象编号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.businesscurrency, o.businesscurrency) as businesscurrency -- 业务币种
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 名义金额
    ,nvl(n.termyear, o.termyear) as termyear -- 期限（年）
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限（月）
    ,nvl(n.termday, o.termday) as termday -- 期限（日）
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- 基准利率类型
    ,nvl(n.ratefloattype, o.ratefloattype) as ratefloattype -- 利率浮动方式
    ,nvl(n.ratefloat, o.ratefloat) as ratefloat -- 利率浮动值
    ,nvl(n.bailcurrency, o.bailcurrency) as bailcurrency -- 保证金币种
    ,nvl(n.businessrate, o.businessrate) as businessrate -- 执行利率
    ,nvl(n.bailratio, o.bailratio) as bailratio -- 保证金比率
    ,nvl(n.bailsum, o.bailsum) as bailsum -- 保证金金额
    ,nvl(n.pdgratio, o.pdgratio) as pdgratio -- 手续费比率
    ,nvl(n.pdgsum, o.pdgsum) as pdgsum -- 手续费金额
    ,nvl(n.baserate, o.baserate) as baserate -- 基准;年)利率
    ,nvl(n.phaseopinion, o.phaseopinion) as phaseopinion -- 节点意见详情
    ,nvl(n.phaseopinion1, o.phaseopinion1) as phaseopinion1 -- 意见详情1
    ,nvl(n.phaseopinion2, o.phaseopinion2) as phaseopinion2 -- 意见详情2
    ,nvl(n.phaseopinion3, o.phaseopinion3) as phaseopinion3 -- 意见详情3
    ,nvl(n.exposuresum, o.exposuresum) as exposuresum -- 敞口金额
    ,nvl(n.opiniontype, o.opiniontype) as opiniontype -- 意见类型
    ,nvl(n.inputorg, o.inputorg) as inputorg -- 登记机构
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 登记人
    ,nvl(n.updateorg, o.updateorg) as updateorg -- 更新机构
    ,nvl(n.updateuser, o.updateuser) as updateuser -- 更新人
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记时间
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.phasechoice, o.phasechoice) as phasechoice -- 阶段意见
    ,nvl(n.warehousing, o.warehousing) as warehousing -- 是否入库
    ,nvl(n.payreq, o.payreq) as payreq -- 授信方案
    ,nvl(n.afterpayreq, o.afterpayreq) as afterpayreq -- 发放与支付前须落实的特殊限制性条件
    ,nvl(n.contractreq, o.contractreq) as contractreq -- 需落实到合同、协议中的特殊要求
    ,nvl(n.loanmanagereq, o.loanmanagereq) as loanmanagereq -- 贷后管理要求
    ,nvl(n.agreemachine, o.agreemachine) as agreemachine -- 是否认可机器决策结果
    ,nvl(n.riskexposuresum, o.riskexposuresum) as riskexposuresum -- 其中，一般风险敞口限额
    ,nvl(n.iscycle, o.iscycle) as iscycle -- 是否循环(额度);是否循环
    ,nvl(n.isyeartocheck, o.isyeartocheck) as isyeartocheck -- 是否需要年审
    ,nvl(n.isjoinlimits, o.isjoinlimits) as isjoinlimits -- 是否纳入单一客户或集团的限额
    ,nvl(n.onlineamount, o.onlineamount) as onlineamount -- 线上额度(元)
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.repaycycle, o.repaycycle) as repaycycle -- 还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)
    ,nvl(n.balloonamortenddate, o.balloonamortenddate) as balloonamortenddate -- 气球贷摊销到期日
    ,nvl(n.coopterm, o.coopterm) as coopterm -- 合作期限(月)
    ,nvl(n.nominalsum, o.nominalsum) as nominalsum -- 项目总额度(元)
    ,nvl(n.firstusesum, o.firstusesum) as firstusesum -- 先期启用额度
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.lowriskexposuresum, o.lowriskexposuresum) as lowriskexposuresum -- 其中，类低风险敞口金额(元)
    ,case when
            n.serialno is null
            and n.opinionno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
            and n.opinionno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
            and n.opinionno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_flow_opinion_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_flow_opinion where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
            and o.opinionno = n.opinionno
where (
        o.serialno is null
        and o.opinionno is null
    )
    or (
        n.serialno is null
        and n.opinionno is null
    )
    or (
        o.objecttype <> n.objecttype
        or o.objectno <> n.objectno
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.businesscurrency <> n.businesscurrency
        or o.businesssum <> n.businesssum
        or o.termyear <> n.termyear
        or o.termmonth <> n.termmonth
        or o.termday <> n.termday
        or o.baseratetype <> n.baseratetype
        or o.ratefloattype <> n.ratefloattype
        or o.ratefloat <> n.ratefloat
        or o.bailcurrency <> n.bailcurrency
        or o.businessrate <> n.businessrate
        or o.bailratio <> n.bailratio
        or o.bailsum <> n.bailsum
        or o.pdgratio <> n.pdgratio
        or o.pdgsum <> n.pdgsum
        or o.baserate <> n.baserate
        or o.phaseopinion <> n.phaseopinion
        or o.phaseopinion1 <> n.phaseopinion1
        or o.phaseopinion2 <> n.phaseopinion2
        or o.phaseopinion3 <> n.phaseopinion3
        or o.exposuresum <> n.exposuresum
        or o.opiniontype <> n.opiniontype
        or o.inputorg <> n.inputorg
        or o.inputuser <> n.inputuser
        or o.updateorg <> n.updateorg
        or o.updateuser <> n.updateuser
        or o.inputtime <> n.inputtime
        or o.updatetime <> n.updatetime
        or o.phasechoice <> n.phasechoice
        or o.warehousing <> n.warehousing
        or o.payreq <> n.payreq
        or o.afterpayreq <> n.afterpayreq
        or o.contractreq <> n.contractreq
        or o.loanmanagereq <> n.loanmanagereq
        or o.agreemachine <> n.agreemachine
        or o.riskexposuresum <> n.riskexposuresum
        or o.iscycle <> n.iscycle
        or o.isyeartocheck <> n.isyeartocheck
        or o.isjoinlimits <> n.isjoinlimits
        or o.onlineamount <> n.onlineamount
        or o.repaytype <> n.repaytype
        or o.repaycycle <> n.repaycycle
        or o.balloonamortenddate <> n.balloonamortenddate
        or o.coopterm <> n.coopterm
        or o.nominalsum <> n.nominalsum
        or o.firstusesum <> n.firstusesum
        or o.migtflag <> n.migtflag
        or o.lowriskexposuresum <> n.lowriskexposuresum
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_flow_opinion_cl(
            serialno -- 流程节点编号
            ,opinionno -- 意见编号
            ,objecttype -- 流程对象任务类型
            ,objectno -- 流程对象编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,businesscurrency -- 业务币种
            ,businesssum -- 名义金额
            ,termyear -- 期限（年）
            ,termmonth -- 期限（月）
            ,termday -- 期限（日）
            ,baseratetype -- 基准利率类型
            ,ratefloattype -- 利率浮动方式
            ,ratefloat -- 利率浮动值
            ,bailcurrency -- 保证金币种
            ,businessrate -- 执行利率
            ,bailratio -- 保证金比率
            ,bailsum -- 保证金金额
            ,pdgratio -- 手续费比率
            ,pdgsum -- 手续费金额
            ,baserate -- 基准;年)利率
            ,phaseopinion -- 节点意见详情
            ,phaseopinion1 -- 意见详情1
            ,phaseopinion2 -- 意见详情2
            ,phaseopinion3 -- 意见详情3
            ,exposuresum -- 敞口金额
            ,opiniontype -- 意见类型
            ,inputorg -- 登记机构
            ,inputuser -- 登记人
            ,updateorg -- 更新机构
            ,updateuser -- 更新人
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,phasechoice -- 阶段意见
            ,warehousing -- 是否入库
            ,payreq -- 授信方案
            ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
            ,contractreq -- 需落实到合同、协议中的特殊要求
            ,loanmanagereq -- 贷后管理要求
            ,agreemachine -- 是否认可机器决策结果
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,iscycle -- 是否循环(额度);是否循环
            ,isyeartocheck -- 是否需要年审
            ,isjoinlimits -- 是否纳入单一客户或集团的限额
            ,onlineamount -- 线上额度(元)
            ,repaytype -- 还款方式
            ,repaycycle -- 还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)
            ,balloonamortenddate -- 气球贷摊销到期日
            ,coopterm -- 合作期限(月)
            ,nominalsum -- 项目总额度(元)
            ,firstusesum -- 先期启用额度
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_flow_opinion_op(
            serialno -- 流程节点编号
            ,opinionno -- 意见编号
            ,objecttype -- 流程对象任务类型
            ,objectno -- 流程对象编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,businesscurrency -- 业务币种
            ,businesssum -- 名义金额
            ,termyear -- 期限（年）
            ,termmonth -- 期限（月）
            ,termday -- 期限（日）
            ,baseratetype -- 基准利率类型
            ,ratefloattype -- 利率浮动方式
            ,ratefloat -- 利率浮动值
            ,bailcurrency -- 保证金币种
            ,businessrate -- 执行利率
            ,bailratio -- 保证金比率
            ,bailsum -- 保证金金额
            ,pdgratio -- 手续费比率
            ,pdgsum -- 手续费金额
            ,baserate -- 基准;年)利率
            ,phaseopinion -- 节点意见详情
            ,phaseopinion1 -- 意见详情1
            ,phaseopinion2 -- 意见详情2
            ,phaseopinion3 -- 意见详情3
            ,exposuresum -- 敞口金额
            ,opiniontype -- 意见类型
            ,inputorg -- 登记机构
            ,inputuser -- 登记人
            ,updateorg -- 更新机构
            ,updateuser -- 更新人
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,phasechoice -- 阶段意见
            ,warehousing -- 是否入库
            ,payreq -- 授信方案
            ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
            ,contractreq -- 需落实到合同、协议中的特殊要求
            ,loanmanagereq -- 贷后管理要求
            ,agreemachine -- 是否认可机器决策结果
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,iscycle -- 是否循环(额度);是否循环
            ,isyeartocheck -- 是否需要年审
            ,isjoinlimits -- 是否纳入单一客户或集团的限额
            ,onlineamount -- 线上额度(元)
            ,repaytype -- 还款方式
            ,repaycycle -- 还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)
            ,balloonamortenddate -- 气球贷摊销到期日
            ,coopterm -- 合作期限(月)
            ,nominalsum -- 项目总额度(元)
            ,firstusesum -- 先期启用额度
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流程节点编号
    ,o.opinionno -- 意见编号
    ,o.objecttype -- 流程对象任务类型
    ,o.objectno -- 流程对象编号
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.businesscurrency -- 业务币种
    ,o.businesssum -- 名义金额
    ,o.termyear -- 期限（年）
    ,o.termmonth -- 期限（月）
    ,o.termday -- 期限（日）
    ,o.baseratetype -- 基准利率类型
    ,o.ratefloattype -- 利率浮动方式
    ,o.ratefloat -- 利率浮动值
    ,o.bailcurrency -- 保证金币种
    ,o.businessrate -- 执行利率
    ,o.bailratio -- 保证金比率
    ,o.bailsum -- 保证金金额
    ,o.pdgratio -- 手续费比率
    ,o.pdgsum -- 手续费金额
    ,o.baserate -- 基准;年)利率
    ,o.phaseopinion -- 节点意见详情
    ,o.phaseopinion1 -- 意见详情1
    ,o.phaseopinion2 -- 意见详情2
    ,o.phaseopinion3 -- 意见详情3
    ,o.exposuresum -- 敞口金额
    ,o.opiniontype -- 意见类型
    ,o.inputorg -- 登记机构
    ,o.inputuser -- 登记人
    ,o.updateorg -- 更新机构
    ,o.updateuser -- 更新人
    ,o.inputtime -- 登记时间
    ,o.updatetime -- 更新时间
    ,o.phasechoice -- 阶段意见
    ,o.warehousing -- 是否入库
    ,o.payreq -- 授信方案
    ,o.afterpayreq -- 发放与支付前须落实的特殊限制性条件
    ,o.contractreq -- 需落实到合同、协议中的特殊要求
    ,o.loanmanagereq -- 贷后管理要求
    ,o.agreemachine -- 是否认可机器决策结果
    ,o.riskexposuresum -- 其中，一般风险敞口限额
    ,o.iscycle -- 是否循环(额度);是否循环
    ,o.isyeartocheck -- 是否需要年审
    ,o.isjoinlimits -- 是否纳入单一客户或集团的限额
    ,o.onlineamount -- 线上额度(元)
    ,o.repaytype -- 还款方式
    ,o.repaycycle -- 还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)
    ,o.balloonamortenddate -- 气球贷摊销到期日
    ,o.coopterm -- 合作期限(月)
    ,o.nominalsum -- 项目总额度(元)
    ,o.firstusesum -- 先期启用额度
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.lowriskexposuresum -- 其中，类低风险敞口金额(元)
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
from ${iol_schema}.icms_flow_opinion_bk o
    left join ${iol_schema}.icms_flow_opinion_op n
        on
            o.serialno = n.serialno
            and o.opinionno = n.opinionno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_flow_opinion_cl d
        on
            o.serialno = d.serialno
            and o.opinionno = d.opinionno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_flow_opinion;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_flow_opinion') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_flow_opinion drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_flow_opinion add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_flow_opinion exchange partition p_${batch_date} with table ${iol_schema}.icms_flow_opinion_cl;
alter table ${iol_schema}.icms_flow_opinion exchange partition p_20991231 with table ${iol_schema}.icms_flow_opinion_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_flow_opinion to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_flow_opinion_op purge;
drop table ${iol_schema}.icms_flow_opinion_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_flow_opinion_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_flow_opinion',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
