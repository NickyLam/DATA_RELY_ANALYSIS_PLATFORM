/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_case_pro
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
create table ${iol_schema}.icms_ap_case_pro_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_case_pro
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_case_pro_op purge;
drop table ${iol_schema}.icms_ap_case_pro_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_case_pro_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_case_pro where 0=1;

create table ${iol_schema}.icms_ap_case_pro_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_case_pro where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_case_pro_cl(
            caseno -- 案件项目编号
            ,bankruptendflag -- 是否破产终结
            ,bankruptflag -- 是否申请破产
            ,executeflag -- 是否执结
            ,bankrupttype -- 破产类型
            ,customerid -- 当事人编号
            ,objectinterestsum -- 标的利息金额
            ,executedate -- 执结日期
            ,employmentsche2 -- 二审聘请方案描述
            ,belongorgid -- 所属机构
            ,objectcapitalsum -- 标的本金金额
            ,objectsum -- 标的金额
            ,suitrequest -- 诉讼请求
            ,executestage -- 执行阶段
            ,updatedate -- 更新日期
            ,realcompsum -- 实际赔偿金额
            ,endflag -- 是否终结
            ,stopcasedate -- 人工终止日期
            ,caseprogramstage -- 案件程序阶段
            ,thirdparty -- 第三人
            ,suitprohistory -- 案件诉讼程序阶段历史
            ,fmuserid -- 主办客户经理ID
            ,liquidatecaseflag -- 是否清收案件
            ,propertysaveflag2 -- 二审是否有财产保全
            ,agencypattern -- 代理方式
            ,caseid -- 案号
            ,hirelawyerflag -- 是否聘请律师
            ,otherpropertydes -- 其他有效财产线索情况说明
            ,objectinterestbalance -- 标的利息余额
            ,winflag -- 是否胜诉
            ,tmsp -- 时间戳
            ,bysuitrequest -- 被诉诉请
            ,monitorflag -- 是否总行监控案件
            ,defendant -- 被告
            ,employmentsche -- 聘请方案描述
            ,lawagent -- 诉讼代理人
            ,zxinterest -- 账销案存资产欠息余额
            ,suitrequest2 -- 二审诉讼请求
            ,otherpropertydes2 -- 二审其他有效财产线索情况说明
            ,casedesc -- 案件描述
            ,closeddate -- 审结日期
            ,lawyername -- 代理律师
            ,casename -- 案件名称
            ,casereason -- 案由
            ,otherpartyname -- 其他当事人
            ,propertysaveflag -- 是否有财产保全
            ,employmentsche1 -- 一审聘请方案描述
            ,stopcours -- 人工终止原因
            ,deleteflag -- 删除标记
            ,relativecaseid -- 关联案件案号
            ,customername -- 当事人名称
            ,objectcurrenty -- 标的币种
            ,closedflag -- 是否审结
            ,stoppeddate -- 中止日期
            ,caseprogramtype -- 案件程序类型
            ,specialflag -- 是否总行专案
            ,occurdate -- 发生日期
            ,objectcapitalbalance -- 标的本金余额
            ,stoppedflag -- 是否中止
            ,executeddate -- 执结日期
            ,otherpropertydes1 -- 一审其他有效财产线索情况说明
            ,fileno -- 影像平台编号
            ,reportflag -- 是否上报总行管理
            ,enddate -- 终结日期
            ,caseprojectdesc -- 案件方案描述
            ,objectcost -- 标的费用金额
            ,thirdpartyids -- 第三人编号
            ,relativecaseno -- 关联案件流水号
            ,fmusername -- 主办客户经理
            ,smusername -- 协办客户经理
            ,caseflag -- 案件属性
            ,executedflag -- 是否执结
            ,saveflag -- 保存状态
            ,bankruptenddate -- 破产终结日期
            ,bankruptstage -- 破产案件阶段
            ,updateorgid -- 更新机构编号
            ,accuser -- 原告
            ,updateuserid -- 更新人编号
            ,acceptunitname -- 受理单位名称
            ,trendinfo -- 案件动态内容
            ,approvestatus -- 审批状态
            ,accuserids -- 原告编号
            ,acceptunitid -- 受理单位ID
            ,seizureslist -- 查封物情况
            ,suitrequest1 -- 一审诉讼请求
            ,casetype -- 案件类型
            ,relativecasename -- 关联案件名称
            ,lawfirmname -- 代理律所
            ,inputuserid -- 登记人编号
            ,objectbalance -- 标的余额
            ,suitprogramstage -- 诉讼程序阶段
            ,assetno -- 资产编号
            ,remark -- 备注
            ,executestatus -- 落实状态
            ,projectno -- 项目编号
            ,replyopinion -- 答辩意见
            ,smuserid -- 协办客户经理ID
            ,propertysaveflag1 -- 一审是否有财产保全
            ,defendantids -- 被告人编号
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,bankposition -- 我行地位
            ,assetpreservesche -- 资产保全方案
            ,zxbalance -- 账销案存资产本金余额
            ,bysuitobject -- 被诉标的
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_case_pro_op(
            caseno -- 案件项目编号
            ,bankruptendflag -- 是否破产终结
            ,bankruptflag -- 是否申请破产
            ,executeflag -- 是否执结
            ,bankrupttype -- 破产类型
            ,customerid -- 当事人编号
            ,objectinterestsum -- 标的利息金额
            ,executedate -- 执结日期
            ,employmentsche2 -- 二审聘请方案描述
            ,belongorgid -- 所属机构
            ,objectcapitalsum -- 标的本金金额
            ,objectsum -- 标的金额
            ,suitrequest -- 诉讼请求
            ,executestage -- 执行阶段
            ,updatedate -- 更新日期
            ,realcompsum -- 实际赔偿金额
            ,endflag -- 是否终结
            ,stopcasedate -- 人工终止日期
            ,caseprogramstage -- 案件程序阶段
            ,thirdparty -- 第三人
            ,suitprohistory -- 案件诉讼程序阶段历史
            ,fmuserid -- 主办客户经理ID
            ,liquidatecaseflag -- 是否清收案件
            ,propertysaveflag2 -- 二审是否有财产保全
            ,agencypattern -- 代理方式
            ,caseid -- 案号
            ,hirelawyerflag -- 是否聘请律师
            ,otherpropertydes -- 其他有效财产线索情况说明
            ,objectinterestbalance -- 标的利息余额
            ,winflag -- 是否胜诉
            ,tmsp -- 时间戳
            ,bysuitrequest -- 被诉诉请
            ,monitorflag -- 是否总行监控案件
            ,defendant -- 被告
            ,employmentsche -- 聘请方案描述
            ,lawagent -- 诉讼代理人
            ,zxinterest -- 账销案存资产欠息余额
            ,suitrequest2 -- 二审诉讼请求
            ,otherpropertydes2 -- 二审其他有效财产线索情况说明
            ,casedesc -- 案件描述
            ,closeddate -- 审结日期
            ,lawyername -- 代理律师
            ,casename -- 案件名称
            ,casereason -- 案由
            ,otherpartyname -- 其他当事人
            ,propertysaveflag -- 是否有财产保全
            ,employmentsche1 -- 一审聘请方案描述
            ,stopcours -- 人工终止原因
            ,deleteflag -- 删除标记
            ,relativecaseid -- 关联案件案号
            ,customername -- 当事人名称
            ,objectcurrenty -- 标的币种
            ,closedflag -- 是否审结
            ,stoppeddate -- 中止日期
            ,caseprogramtype -- 案件程序类型
            ,specialflag -- 是否总行专案
            ,occurdate -- 发生日期
            ,objectcapitalbalance -- 标的本金余额
            ,stoppedflag -- 是否中止
            ,executeddate -- 执结日期
            ,otherpropertydes1 -- 一审其他有效财产线索情况说明
            ,fileno -- 影像平台编号
            ,reportflag -- 是否上报总行管理
            ,enddate -- 终结日期
            ,caseprojectdesc -- 案件方案描述
            ,objectcost -- 标的费用金额
            ,thirdpartyids -- 第三人编号
            ,relativecaseno -- 关联案件流水号
            ,fmusername -- 主办客户经理
            ,smusername -- 协办客户经理
            ,caseflag -- 案件属性
            ,executedflag -- 是否执结
            ,saveflag -- 保存状态
            ,bankruptenddate -- 破产终结日期
            ,bankruptstage -- 破产案件阶段
            ,updateorgid -- 更新机构编号
            ,accuser -- 原告
            ,updateuserid -- 更新人编号
            ,acceptunitname -- 受理单位名称
            ,trendinfo -- 案件动态内容
            ,approvestatus -- 审批状态
            ,accuserids -- 原告编号
            ,acceptunitid -- 受理单位ID
            ,seizureslist -- 查封物情况
            ,suitrequest1 -- 一审诉讼请求
            ,casetype -- 案件类型
            ,relativecasename -- 关联案件名称
            ,lawfirmname -- 代理律所
            ,inputuserid -- 登记人编号
            ,objectbalance -- 标的余额
            ,suitprogramstage -- 诉讼程序阶段
            ,assetno -- 资产编号
            ,remark -- 备注
            ,executestatus -- 落实状态
            ,projectno -- 项目编号
            ,replyopinion -- 答辩意见
            ,smuserid -- 协办客户经理ID
            ,propertysaveflag1 -- 一审是否有财产保全
            ,defendantids -- 被告人编号
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,bankposition -- 我行地位
            ,assetpreservesche -- 资产保全方案
            ,zxbalance -- 账销案存资产本金余额
            ,bysuitobject -- 被诉标的
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.caseno, o.caseno) as caseno -- 案件项目编号
    ,nvl(n.bankruptendflag, o.bankruptendflag) as bankruptendflag -- 是否破产终结
    ,nvl(n.bankruptflag, o.bankruptflag) as bankruptflag -- 是否申请破产
    ,nvl(n.executeflag, o.executeflag) as executeflag -- 是否执结
    ,nvl(n.bankrupttype, o.bankrupttype) as bankrupttype -- 破产类型
    ,nvl(n.customerid, o.customerid) as customerid -- 当事人编号
    ,nvl(n.objectinterestsum, o.objectinterestsum) as objectinterestsum -- 标的利息金额
    ,nvl(n.executedate, o.executedate) as executedate -- 执结日期
    ,nvl(n.employmentsche2, o.employmentsche2) as employmentsche2 -- 二审聘请方案描述
    ,nvl(n.belongorgid, o.belongorgid) as belongorgid -- 所属机构
    ,nvl(n.objectcapitalsum, o.objectcapitalsum) as objectcapitalsum -- 标的本金金额
    ,nvl(n.objectsum, o.objectsum) as objectsum -- 标的金额
    ,nvl(n.suitrequest, o.suitrequest) as suitrequest -- 诉讼请求
    ,nvl(n.executestage, o.executestage) as executestage -- 执行阶段
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.realcompsum, o.realcompsum) as realcompsum -- 实际赔偿金额
    ,nvl(n.endflag, o.endflag) as endflag -- 是否终结
    ,nvl(n.stopcasedate, o.stopcasedate) as stopcasedate -- 人工终止日期
    ,nvl(n.caseprogramstage, o.caseprogramstage) as caseprogramstage -- 案件程序阶段
    ,nvl(n.thirdparty, o.thirdparty) as thirdparty -- 第三人
    ,nvl(n.suitprohistory, o.suitprohistory) as suitprohistory -- 案件诉讼程序阶段历史
    ,nvl(n.fmuserid, o.fmuserid) as fmuserid -- 主办客户经理ID
    ,nvl(n.liquidatecaseflag, o.liquidatecaseflag) as liquidatecaseflag -- 是否清收案件
    ,nvl(n.propertysaveflag2, o.propertysaveflag2) as propertysaveflag2 -- 二审是否有财产保全
    ,nvl(n.agencypattern, o.agencypattern) as agencypattern -- 代理方式
    ,nvl(n.caseid, o.caseid) as caseid -- 案号
    ,nvl(n.hirelawyerflag, o.hirelawyerflag) as hirelawyerflag -- 是否聘请律师
    ,nvl(n.otherpropertydes, o.otherpropertydes) as otherpropertydes -- 其他有效财产线索情况说明
    ,nvl(n.objectinterestbalance, o.objectinterestbalance) as objectinterestbalance -- 标的利息余额
    ,nvl(n.winflag, o.winflag) as winflag -- 是否胜诉
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.bysuitrequest, o.bysuitrequest) as bysuitrequest -- 被诉诉请
    ,nvl(n.monitorflag, o.monitorflag) as monitorflag -- 是否总行监控案件
    ,nvl(n.defendant, o.defendant) as defendant -- 被告
    ,nvl(n.employmentsche, o.employmentsche) as employmentsche -- 聘请方案描述
    ,nvl(n.lawagent, o.lawagent) as lawagent -- 诉讼代理人
    ,nvl(n.zxinterest, o.zxinterest) as zxinterest -- 账销案存资产欠息余额
    ,nvl(n.suitrequest2, o.suitrequest2) as suitrequest2 -- 二审诉讼请求
    ,nvl(n.otherpropertydes2, o.otherpropertydes2) as otherpropertydes2 -- 二审其他有效财产线索情况说明
    ,nvl(n.casedesc, o.casedesc) as casedesc -- 案件描述
    ,nvl(n.closeddate, o.closeddate) as closeddate -- 审结日期
    ,nvl(n.lawyername, o.lawyername) as lawyername -- 代理律师
    ,nvl(n.casename, o.casename) as casename -- 案件名称
    ,nvl(n.casereason, o.casereason) as casereason -- 案由
    ,nvl(n.otherpartyname, o.otherpartyname) as otherpartyname -- 其他当事人
    ,nvl(n.propertysaveflag, o.propertysaveflag) as propertysaveflag -- 是否有财产保全
    ,nvl(n.employmentsche1, o.employmentsche1) as employmentsche1 -- 一审聘请方案描述
    ,nvl(n.stopcours, o.stopcours) as stopcours -- 人工终止原因
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标记
    ,nvl(n.relativecaseid, o.relativecaseid) as relativecaseid -- 关联案件案号
    ,nvl(n.customername, o.customername) as customername -- 当事人名称
    ,nvl(n.objectcurrenty, o.objectcurrenty) as objectcurrenty -- 标的币种
    ,nvl(n.closedflag, o.closedflag) as closedflag -- 是否审结
    ,nvl(n.stoppeddate, o.stoppeddate) as stoppeddate -- 中止日期
    ,nvl(n.caseprogramtype, o.caseprogramtype) as caseprogramtype -- 案件程序类型
    ,nvl(n.specialflag, o.specialflag) as specialflag -- 是否总行专案
    ,nvl(n.occurdate, o.occurdate) as occurdate -- 发生日期
    ,nvl(n.objectcapitalbalance, o.objectcapitalbalance) as objectcapitalbalance -- 标的本金余额
    ,nvl(n.stoppedflag, o.stoppedflag) as stoppedflag -- 是否中止
    ,nvl(n.executeddate, o.executeddate) as executeddate -- 执结日期
    ,nvl(n.otherpropertydes1, o.otherpropertydes1) as otherpropertydes1 -- 一审其他有效财产线索情况说明
    ,nvl(n.fileno, o.fileno) as fileno -- 影像平台编号
    ,nvl(n.reportflag, o.reportflag) as reportflag -- 是否上报总行管理
    ,nvl(n.enddate, o.enddate) as enddate -- 终结日期
    ,nvl(n.caseprojectdesc, o.caseprojectdesc) as caseprojectdesc -- 案件方案描述
    ,nvl(n.objectcost, o.objectcost) as objectcost -- 标的费用金额
    ,nvl(n.thirdpartyids, o.thirdpartyids) as thirdpartyids -- 第三人编号
    ,nvl(n.relativecaseno, o.relativecaseno) as relativecaseno -- 关联案件流水号
    ,nvl(n.fmusername, o.fmusername) as fmusername -- 主办客户经理
    ,nvl(n.smusername, o.smusername) as smusername -- 协办客户经理
    ,nvl(n.caseflag, o.caseflag) as caseflag -- 案件属性
    ,nvl(n.executedflag, o.executedflag) as executedflag -- 是否执结
    ,nvl(n.saveflag, o.saveflag) as saveflag -- 保存状态
    ,nvl(n.bankruptenddate, o.bankruptenddate) as bankruptenddate -- 破产终结日期
    ,nvl(n.bankruptstage, o.bankruptstage) as bankruptstage -- 破产案件阶段
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,nvl(n.accuser, o.accuser) as accuser -- 原告
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.acceptunitname, o.acceptunitname) as acceptunitname -- 受理单位名称
    ,nvl(n.trendinfo, o.trendinfo) as trendinfo -- 案件动态内容
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.accuserids, o.accuserids) as accuserids -- 原告编号
    ,nvl(n.acceptunitid, o.acceptunitid) as acceptunitid -- 受理单位ID
    ,nvl(n.seizureslist, o.seizureslist) as seizureslist -- 查封物情况
    ,nvl(n.suitrequest1, o.suitrequest1) as suitrequest1 -- 一审诉讼请求
    ,nvl(n.casetype, o.casetype) as casetype -- 案件类型
    ,nvl(n.relativecasename, o.relativecasename) as relativecasename -- 关联案件名称
    ,nvl(n.lawfirmname, o.lawfirmname) as lawfirmname -- 代理律所
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人编号
    ,nvl(n.objectbalance, o.objectbalance) as objectbalance -- 标的余额
    ,nvl(n.suitprogramstage, o.suitprogramstage) as suitprogramstage -- 诉讼程序阶段
    ,nvl(n.assetno, o.assetno) as assetno -- 资产编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.executestatus, o.executestatus) as executestatus -- 落实状态
    ,nvl(n.projectno, o.projectno) as projectno -- 项目编号
    ,nvl(n.replyopinion, o.replyopinion) as replyopinion -- 答辩意见
    ,nvl(n.smuserid, o.smuserid) as smuserid -- 协办客户经理ID
    ,nvl(n.propertysaveflag1, o.propertysaveflag1) as propertysaveflag1 -- 一审是否有财产保全
    ,nvl(n.defendantids, o.defendantids) as defendantids -- 被告人编号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构编号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.bankposition, o.bankposition) as bankposition -- 我行地位
    ,nvl(n.assetpreservesche, o.assetpreservesche) as assetpreservesche -- 资产保全方案
    ,nvl(n.zxbalance, o.zxbalance) as zxbalance -- 账销案存资产本金余额
    ,nvl(n.bysuitobject, o.bysuitobject) as bysuitobject -- 被诉标的
    ,case when
            n.caseno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.caseno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.caseno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_case_pro_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_case_pro where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.caseno = n.caseno
where (
        o.caseno is null
    )
    or (
        n.caseno is null
    )
    or (
        o.bankruptendflag <> n.bankruptendflag
        or o.bankruptflag <> n.bankruptflag
        or o.executeflag <> n.executeflag
        or o.bankrupttype <> n.bankrupttype
        or o.customerid <> n.customerid
        or o.objectinterestsum <> n.objectinterestsum
        or o.executedate <> n.executedate
        or o.employmentsche2 <> n.employmentsche2
        or o.belongorgid <> n.belongorgid
        or o.objectcapitalsum <> n.objectcapitalsum
        or o.objectsum <> n.objectsum
        or o.suitrequest <> n.suitrequest
        or o.executestage <> n.executestage
        or o.updatedate <> n.updatedate
        or o.realcompsum <> n.realcompsum
        or o.endflag <> n.endflag
        or o.stopcasedate <> n.stopcasedate
        or o.caseprogramstage <> n.caseprogramstage
        or o.thirdparty <> n.thirdparty
        or o.suitprohistory <> n.suitprohistory
        or o.fmuserid <> n.fmuserid
        or o.liquidatecaseflag <> n.liquidatecaseflag
        or o.propertysaveflag2 <> n.propertysaveflag2
        or o.agencypattern <> n.agencypattern
        or o.caseid <> n.caseid
        or o.hirelawyerflag <> n.hirelawyerflag
        or o.otherpropertydes <> n.otherpropertydes
        or o.objectinterestbalance <> n.objectinterestbalance
        or o.winflag <> n.winflag
        or o.tmsp <> n.tmsp
        or o.bysuitrequest <> n.bysuitrequest
        or o.monitorflag <> n.monitorflag
        or o.defendant <> n.defendant
        or o.employmentsche <> n.employmentsche
        or o.lawagent <> n.lawagent
        or o.zxinterest <> n.zxinterest
        or o.suitrequest2 <> n.suitrequest2
        or o.otherpropertydes2 <> n.otherpropertydes2
        or o.casedesc <> n.casedesc
        or o.closeddate <> n.closeddate
        or o.lawyername <> n.lawyername
        or o.casename <> n.casename
        or o.casereason <> n.casereason
        or o.otherpartyname <> n.otherpartyname
        or o.propertysaveflag <> n.propertysaveflag
        or o.employmentsche1 <> n.employmentsche1
        or o.stopcours <> n.stopcours
        or o.deleteflag <> n.deleteflag
        or o.relativecaseid <> n.relativecaseid
        or o.customername <> n.customername
        or o.objectcurrenty <> n.objectcurrenty
        or o.closedflag <> n.closedflag
        or o.stoppeddate <> n.stoppeddate
        or o.caseprogramtype <> n.caseprogramtype
        or o.specialflag <> n.specialflag
        or o.occurdate <> n.occurdate
        or o.objectcapitalbalance <> n.objectcapitalbalance
        or o.stoppedflag <> n.stoppedflag
        or o.executeddate <> n.executeddate
        or o.otherpropertydes1 <> n.otherpropertydes1
        or o.fileno <> n.fileno
        or o.reportflag <> n.reportflag
        or o.enddate <> n.enddate
        or o.caseprojectdesc <> n.caseprojectdesc
        or o.objectcost <> n.objectcost
        or o.thirdpartyids <> n.thirdpartyids
        or o.relativecaseno <> n.relativecaseno
        or o.fmusername <> n.fmusername
        or o.smusername <> n.smusername
        or o.caseflag <> n.caseflag
        or o.executedflag <> n.executedflag
        or o.saveflag <> n.saveflag
        or o.bankruptenddate <> n.bankruptenddate
        or o.bankruptstage <> n.bankruptstage
        or o.updateorgid <> n.updateorgid
        or o.accuser <> n.accuser
        or o.updateuserid <> n.updateuserid
        or o.acceptunitname <> n.acceptunitname
        or o.trendinfo <> n.trendinfo
        or o.approvestatus <> n.approvestatus
        or o.accuserids <> n.accuserids
        or o.acceptunitid <> n.acceptunitid
        or o.seizureslist <> n.seizureslist
        or o.suitrequest1 <> n.suitrequest1
        or o.casetype <> n.casetype
        or o.relativecasename <> n.relativecasename
        or o.lawfirmname <> n.lawfirmname
        or o.inputuserid <> n.inputuserid
        or o.objectbalance <> n.objectbalance
        or o.suitprogramstage <> n.suitprogramstage
        or o.assetno <> n.assetno
        or o.remark <> n.remark
        or o.executestatus <> n.executestatus
        or o.projectno <> n.projectno
        or o.replyopinion <> n.replyopinion
        or o.smuserid <> n.smuserid
        or o.propertysaveflag1 <> n.propertysaveflag1
        or o.defendantids <> n.defendantids
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.bankposition <> n.bankposition
        or o.assetpreservesche <> n.assetpreservesche
        or o.zxbalance <> n.zxbalance
        or o.bysuitobject <> n.bysuitobject
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_case_pro_cl(
            caseno -- 案件项目编号
            ,bankruptendflag -- 是否破产终结
            ,bankruptflag -- 是否申请破产
            ,executeflag -- 是否执结
            ,bankrupttype -- 破产类型
            ,customerid -- 当事人编号
            ,objectinterestsum -- 标的利息金额
            ,executedate -- 执结日期
            ,employmentsche2 -- 二审聘请方案描述
            ,belongorgid -- 所属机构
            ,objectcapitalsum -- 标的本金金额
            ,objectsum -- 标的金额
            ,suitrequest -- 诉讼请求
            ,executestage -- 执行阶段
            ,updatedate -- 更新日期
            ,realcompsum -- 实际赔偿金额
            ,endflag -- 是否终结
            ,stopcasedate -- 人工终止日期
            ,caseprogramstage -- 案件程序阶段
            ,thirdparty -- 第三人
            ,suitprohistory -- 案件诉讼程序阶段历史
            ,fmuserid -- 主办客户经理ID
            ,liquidatecaseflag -- 是否清收案件
            ,propertysaveflag2 -- 二审是否有财产保全
            ,agencypattern -- 代理方式
            ,caseid -- 案号
            ,hirelawyerflag -- 是否聘请律师
            ,otherpropertydes -- 其他有效财产线索情况说明
            ,objectinterestbalance -- 标的利息余额
            ,winflag -- 是否胜诉
            ,tmsp -- 时间戳
            ,bysuitrequest -- 被诉诉请
            ,monitorflag -- 是否总行监控案件
            ,defendant -- 被告
            ,employmentsche -- 聘请方案描述
            ,lawagent -- 诉讼代理人
            ,zxinterest -- 账销案存资产欠息余额
            ,suitrequest2 -- 二审诉讼请求
            ,otherpropertydes2 -- 二审其他有效财产线索情况说明
            ,casedesc -- 案件描述
            ,closeddate -- 审结日期
            ,lawyername -- 代理律师
            ,casename -- 案件名称
            ,casereason -- 案由
            ,otherpartyname -- 其他当事人
            ,propertysaveflag -- 是否有财产保全
            ,employmentsche1 -- 一审聘请方案描述
            ,stopcours -- 人工终止原因
            ,deleteflag -- 删除标记
            ,relativecaseid -- 关联案件案号
            ,customername -- 当事人名称
            ,objectcurrenty -- 标的币种
            ,closedflag -- 是否审结
            ,stoppeddate -- 中止日期
            ,caseprogramtype -- 案件程序类型
            ,specialflag -- 是否总行专案
            ,occurdate -- 发生日期
            ,objectcapitalbalance -- 标的本金余额
            ,stoppedflag -- 是否中止
            ,executeddate -- 执结日期
            ,otherpropertydes1 -- 一审其他有效财产线索情况说明
            ,fileno -- 影像平台编号
            ,reportflag -- 是否上报总行管理
            ,enddate -- 终结日期
            ,caseprojectdesc -- 案件方案描述
            ,objectcost -- 标的费用金额
            ,thirdpartyids -- 第三人编号
            ,relativecaseno -- 关联案件流水号
            ,fmusername -- 主办客户经理
            ,smusername -- 协办客户经理
            ,caseflag -- 案件属性
            ,executedflag -- 是否执结
            ,saveflag -- 保存状态
            ,bankruptenddate -- 破产终结日期
            ,bankruptstage -- 破产案件阶段
            ,updateorgid -- 更新机构编号
            ,accuser -- 原告
            ,updateuserid -- 更新人编号
            ,acceptunitname -- 受理单位名称
            ,trendinfo -- 案件动态内容
            ,approvestatus -- 审批状态
            ,accuserids -- 原告编号
            ,acceptunitid -- 受理单位ID
            ,seizureslist -- 查封物情况
            ,suitrequest1 -- 一审诉讼请求
            ,casetype -- 案件类型
            ,relativecasename -- 关联案件名称
            ,lawfirmname -- 代理律所
            ,inputuserid -- 登记人编号
            ,objectbalance -- 标的余额
            ,suitprogramstage -- 诉讼程序阶段
            ,assetno -- 资产编号
            ,remark -- 备注
            ,executestatus -- 落实状态
            ,projectno -- 项目编号
            ,replyopinion -- 答辩意见
            ,smuserid -- 协办客户经理ID
            ,propertysaveflag1 -- 一审是否有财产保全
            ,defendantids -- 被告人编号
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,bankposition -- 我行地位
            ,assetpreservesche -- 资产保全方案
            ,zxbalance -- 账销案存资产本金余额
            ,bysuitobject -- 被诉标的
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_case_pro_op(
            caseno -- 案件项目编号
            ,bankruptendflag -- 是否破产终结
            ,bankruptflag -- 是否申请破产
            ,executeflag -- 是否执结
            ,bankrupttype -- 破产类型
            ,customerid -- 当事人编号
            ,objectinterestsum -- 标的利息金额
            ,executedate -- 执结日期
            ,employmentsche2 -- 二审聘请方案描述
            ,belongorgid -- 所属机构
            ,objectcapitalsum -- 标的本金金额
            ,objectsum -- 标的金额
            ,suitrequest -- 诉讼请求
            ,executestage -- 执行阶段
            ,updatedate -- 更新日期
            ,realcompsum -- 实际赔偿金额
            ,endflag -- 是否终结
            ,stopcasedate -- 人工终止日期
            ,caseprogramstage -- 案件程序阶段
            ,thirdparty -- 第三人
            ,suitprohistory -- 案件诉讼程序阶段历史
            ,fmuserid -- 主办客户经理ID
            ,liquidatecaseflag -- 是否清收案件
            ,propertysaveflag2 -- 二审是否有财产保全
            ,agencypattern -- 代理方式
            ,caseid -- 案号
            ,hirelawyerflag -- 是否聘请律师
            ,otherpropertydes -- 其他有效财产线索情况说明
            ,objectinterestbalance -- 标的利息余额
            ,winflag -- 是否胜诉
            ,tmsp -- 时间戳
            ,bysuitrequest -- 被诉诉请
            ,monitorflag -- 是否总行监控案件
            ,defendant -- 被告
            ,employmentsche -- 聘请方案描述
            ,lawagent -- 诉讼代理人
            ,zxinterest -- 账销案存资产欠息余额
            ,suitrequest2 -- 二审诉讼请求
            ,otherpropertydes2 -- 二审其他有效财产线索情况说明
            ,casedesc -- 案件描述
            ,closeddate -- 审结日期
            ,lawyername -- 代理律师
            ,casename -- 案件名称
            ,casereason -- 案由
            ,otherpartyname -- 其他当事人
            ,propertysaveflag -- 是否有财产保全
            ,employmentsche1 -- 一审聘请方案描述
            ,stopcours -- 人工终止原因
            ,deleteflag -- 删除标记
            ,relativecaseid -- 关联案件案号
            ,customername -- 当事人名称
            ,objectcurrenty -- 标的币种
            ,closedflag -- 是否审结
            ,stoppeddate -- 中止日期
            ,caseprogramtype -- 案件程序类型
            ,specialflag -- 是否总行专案
            ,occurdate -- 发生日期
            ,objectcapitalbalance -- 标的本金余额
            ,stoppedflag -- 是否中止
            ,executeddate -- 执结日期
            ,otherpropertydes1 -- 一审其他有效财产线索情况说明
            ,fileno -- 影像平台编号
            ,reportflag -- 是否上报总行管理
            ,enddate -- 终结日期
            ,caseprojectdesc -- 案件方案描述
            ,objectcost -- 标的费用金额
            ,thirdpartyids -- 第三人编号
            ,relativecaseno -- 关联案件流水号
            ,fmusername -- 主办客户经理
            ,smusername -- 协办客户经理
            ,caseflag -- 案件属性
            ,executedflag -- 是否执结
            ,saveflag -- 保存状态
            ,bankruptenddate -- 破产终结日期
            ,bankruptstage -- 破产案件阶段
            ,updateorgid -- 更新机构编号
            ,accuser -- 原告
            ,updateuserid -- 更新人编号
            ,acceptunitname -- 受理单位名称
            ,trendinfo -- 案件动态内容
            ,approvestatus -- 审批状态
            ,accuserids -- 原告编号
            ,acceptunitid -- 受理单位ID
            ,seizureslist -- 查封物情况
            ,suitrequest1 -- 一审诉讼请求
            ,casetype -- 案件类型
            ,relativecasename -- 关联案件名称
            ,lawfirmname -- 代理律所
            ,inputuserid -- 登记人编号
            ,objectbalance -- 标的余额
            ,suitprogramstage -- 诉讼程序阶段
            ,assetno -- 资产编号
            ,remark -- 备注
            ,executestatus -- 落实状态
            ,projectno -- 项目编号
            ,replyopinion -- 答辩意见
            ,smuserid -- 协办客户经理ID
            ,propertysaveflag1 -- 一审是否有财产保全
            ,defendantids -- 被告人编号
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,bankposition -- 我行地位
            ,assetpreservesche -- 资产保全方案
            ,zxbalance -- 账销案存资产本金余额
            ,bysuitobject -- 被诉标的
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.caseno -- 案件项目编号
    ,o.bankruptendflag -- 是否破产终结
    ,o.bankruptflag -- 是否申请破产
    ,o.executeflag -- 是否执结
    ,o.bankrupttype -- 破产类型
    ,o.customerid -- 当事人编号
    ,o.objectinterestsum -- 标的利息金额
    ,o.executedate -- 执结日期
    ,o.employmentsche2 -- 二审聘请方案描述
    ,o.belongorgid -- 所属机构
    ,o.objectcapitalsum -- 标的本金金额
    ,o.objectsum -- 标的金额
    ,o.suitrequest -- 诉讼请求
    ,o.executestage -- 执行阶段
    ,o.updatedate -- 更新日期
    ,o.realcompsum -- 实际赔偿金额
    ,o.endflag -- 是否终结
    ,o.stopcasedate -- 人工终止日期
    ,o.caseprogramstage -- 案件程序阶段
    ,o.thirdparty -- 第三人
    ,o.suitprohistory -- 案件诉讼程序阶段历史
    ,o.fmuserid -- 主办客户经理ID
    ,o.liquidatecaseflag -- 是否清收案件
    ,o.propertysaveflag2 -- 二审是否有财产保全
    ,o.agencypattern -- 代理方式
    ,o.caseid -- 案号
    ,o.hirelawyerflag -- 是否聘请律师
    ,o.otherpropertydes -- 其他有效财产线索情况说明
    ,o.objectinterestbalance -- 标的利息余额
    ,o.winflag -- 是否胜诉
    ,o.tmsp -- 时间戳
    ,o.bysuitrequest -- 被诉诉请
    ,o.monitorflag -- 是否总行监控案件
    ,o.defendant -- 被告
    ,o.employmentsche -- 聘请方案描述
    ,o.lawagent -- 诉讼代理人
    ,o.zxinterest -- 账销案存资产欠息余额
    ,o.suitrequest2 -- 二审诉讼请求
    ,o.otherpropertydes2 -- 二审其他有效财产线索情况说明
    ,o.casedesc -- 案件描述
    ,o.closeddate -- 审结日期
    ,o.lawyername -- 代理律师
    ,o.casename -- 案件名称
    ,o.casereason -- 案由
    ,o.otherpartyname -- 其他当事人
    ,o.propertysaveflag -- 是否有财产保全
    ,o.employmentsche1 -- 一审聘请方案描述
    ,o.stopcours -- 人工终止原因
    ,o.deleteflag -- 删除标记
    ,o.relativecaseid -- 关联案件案号
    ,o.customername -- 当事人名称
    ,o.objectcurrenty -- 标的币种
    ,o.closedflag -- 是否审结
    ,o.stoppeddate -- 中止日期
    ,o.caseprogramtype -- 案件程序类型
    ,o.specialflag -- 是否总行专案
    ,o.occurdate -- 发生日期
    ,o.objectcapitalbalance -- 标的本金余额
    ,o.stoppedflag -- 是否中止
    ,o.executeddate -- 执结日期
    ,o.otherpropertydes1 -- 一审其他有效财产线索情况说明
    ,o.fileno -- 影像平台编号
    ,o.reportflag -- 是否上报总行管理
    ,o.enddate -- 终结日期
    ,o.caseprojectdesc -- 案件方案描述
    ,o.objectcost -- 标的费用金额
    ,o.thirdpartyids -- 第三人编号
    ,o.relativecaseno -- 关联案件流水号
    ,o.fmusername -- 主办客户经理
    ,o.smusername -- 协办客户经理
    ,o.caseflag -- 案件属性
    ,o.executedflag -- 是否执结
    ,o.saveflag -- 保存状态
    ,o.bankruptenddate -- 破产终结日期
    ,o.bankruptstage -- 破产案件阶段
    ,o.updateorgid -- 更新机构编号
    ,o.accuser -- 原告
    ,o.updateuserid -- 更新人编号
    ,o.acceptunitname -- 受理单位名称
    ,o.trendinfo -- 案件动态内容
    ,o.approvestatus -- 审批状态
    ,o.accuserids -- 原告编号
    ,o.acceptunitid -- 受理单位ID
    ,o.seizureslist -- 查封物情况
    ,o.suitrequest1 -- 一审诉讼请求
    ,o.casetype -- 案件类型
    ,o.relativecasename -- 关联案件名称
    ,o.lawfirmname -- 代理律所
    ,o.inputuserid -- 登记人编号
    ,o.objectbalance -- 标的余额
    ,o.suitprogramstage -- 诉讼程序阶段
    ,o.assetno -- 资产编号
    ,o.remark -- 备注
    ,o.executestatus -- 落实状态
    ,o.projectno -- 项目编号
    ,o.replyopinion -- 答辩意见
    ,o.smuserid -- 协办客户经理ID
    ,o.propertysaveflag1 -- 一审是否有财产保全
    ,o.defendantids -- 被告人编号
    ,o.inputorgid -- 登记机构编号
    ,o.inputdate -- 登记日期
    ,o.bankposition -- 我行地位
    ,o.assetpreservesche -- 资产保全方案
    ,o.zxbalance -- 账销案存资产本金余额
    ,o.bysuitobject -- 被诉标的
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
from ${iol_schema}.icms_ap_case_pro_bk o
    left join ${iol_schema}.icms_ap_case_pro_op n
        on
            o.caseno = n.caseno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_case_pro_cl d
        on
            o.caseno = d.caseno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_case_pro;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_case_pro') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_case_pro drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_case_pro add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_case_pro exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_case_pro_cl;
alter table ${iol_schema}.icms_ap_case_pro exchange partition p_20991231 with table ${iol_schema}.icms_ap_case_pro_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_case_pro to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_case_pro_op purge;
drop table ${iol_schema}.icms_ap_case_pro_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_case_pro_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_case_pro',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
