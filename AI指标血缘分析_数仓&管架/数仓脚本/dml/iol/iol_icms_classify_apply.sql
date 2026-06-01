/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_classify_apply
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
create table ${iol_schema}.icms_classify_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_classify_apply
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_classify_apply_op purge;
drop table ${iol_schema}.icms_classify_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_classify_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_classify_apply where 0=1;

create table ${iol_schema}.icms_classify_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_classify_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_classify_apply_cl(
            serialno -- 流水号
            ,creditaggreement -- 额度合同号
            ,relativetype -- 关联类型
            ,finalpolicyresult -- 终审策略分类
            ,finalcustomerlevel -- 终审监测评级
            ,inputuserid -- 登记人
            ,flag -- 标记
            ,relativeserialno -- 关联流水号
            ,iscurrentmonth -- 是否本月新发生
            ,totalsum -- 敞口
            ,maturity -- 到期日
            ,vouchtype -- 担保类型
            ,levelclassify -- 评级对应的风险分类
            ,kernaladjustlevel -- 
            ,alarminfo -- 
            ,entrance -- 申请发起入口1对公系统，2同业系统
            ,objecttype -- 对象类型
            ,businesstype -- 业务类型
            ,businesscurrency -- 业务币种
            ,inputorgid -- 登记机构
            ,policyresult -- 本期申请策略分类
            ,updateorgid -- 更新时间
            ,updatedate -- 更新日期
            ,type -- 类型
            ,licensedate -- 营业执照登记日
            ,approveclassifyresult -- 审批环节风险分类
            ,lastcustomerlevel -- 上期监测评级
            ,updateuserid -- 更新人
            ,pigeonholedate -- 归案日期
            ,contractserialno -- 合同号
            ,remark1 -- 意见
            ,customerlevel -- 信用评级
            ,classifynum -- 分类笔数
            ,accountmonth -- 分类截至日期
            ,customerid -- 客户号
            ,relativeno -- 关联号
            ,inputdate -- 登记日期
            ,approveclassifytime -- 审批时间
            ,coverage -- 担保覆盖率
            ,assurecustomerid -- 保证人流水号
            ,approvestatus -- 流程状态
            ,customername -- 客户名
            ,remark -- 备注
            ,guarantysum -- 处置抵质押物收回净值（元）
            ,classifymode -- 关联合同类型
            ,finalclassifyresult -- 终审风险分类
            ,alarmadjustlevel -- 
            ,lastpolicyresult -- 上期策略分类
            ,adjusttype -- 
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,classifyresult -- 分类结果
            ,lastclassifyresult -- 上期风险分类
            ,customerleveltime -- 信用评级时间
            ,approveevaluateresult -- 审批环节主体评级
            ,opensum -- 
            ,assurelevel -- 保证人信用等级
            ,adviseclassifyresult -- 本期系统建议分类
            ,balance -- 余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_classify_apply_op(
            serialno -- 流水号
            ,creditaggreement -- 额度合同号
            ,relativetype -- 关联类型
            ,finalpolicyresult -- 终审策略分类
            ,finalcustomerlevel -- 终审监测评级
            ,inputuserid -- 登记人
            ,flag -- 标记
            ,relativeserialno -- 关联流水号
            ,iscurrentmonth -- 是否本月新发生
            ,totalsum -- 敞口
            ,maturity -- 到期日
            ,vouchtype -- 担保类型
            ,levelclassify -- 评级对应的风险分类
            ,kernaladjustlevel -- 
            ,alarminfo -- 
            ,entrance -- 申请发起入口1对公系统，2同业系统
            ,objecttype -- 对象类型
            ,businesstype -- 业务类型
            ,businesscurrency -- 业务币种
            ,inputorgid -- 登记机构
            ,policyresult -- 本期申请策略分类
            ,updateorgid -- 更新时间
            ,updatedate -- 更新日期
            ,type -- 类型
            ,licensedate -- 营业执照登记日
            ,approveclassifyresult -- 审批环节风险分类
            ,lastcustomerlevel -- 上期监测评级
            ,updateuserid -- 更新人
            ,pigeonholedate -- 归案日期
            ,contractserialno -- 合同号
            ,remark1 -- 意见
            ,customerlevel -- 信用评级
            ,classifynum -- 分类笔数
            ,accountmonth -- 分类截至日期
            ,customerid -- 客户号
            ,relativeno -- 关联号
            ,inputdate -- 登记日期
            ,approveclassifytime -- 审批时间
            ,coverage -- 担保覆盖率
            ,assurecustomerid -- 保证人流水号
            ,approvestatus -- 流程状态
            ,customername -- 客户名
            ,remark -- 备注
            ,guarantysum -- 处置抵质押物收回净值（元）
            ,classifymode -- 关联合同类型
            ,finalclassifyresult -- 终审风险分类
            ,alarmadjustlevel -- 
            ,lastpolicyresult -- 上期策略分类
            ,adjusttype -- 
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,classifyresult -- 分类结果
            ,lastclassifyresult -- 上期风险分类
            ,customerleveltime -- 信用评级时间
            ,approveevaluateresult -- 审批环节主体评级
            ,opensum -- 
            ,assurelevel -- 保证人信用等级
            ,adviseclassifyresult -- 本期系统建议分类
            ,balance -- 余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.creditaggreement, o.creditaggreement) as creditaggreement -- 额度合同号
    ,nvl(n.relativetype, o.relativetype) as relativetype -- 关联类型
    ,nvl(n.finalpolicyresult, o.finalpolicyresult) as finalpolicyresult -- 终审策略分类
    ,nvl(n.finalcustomerlevel, o.finalcustomerlevel) as finalcustomerlevel -- 终审监测评级
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.flag, o.flag) as flag -- 标记
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 关联流水号
    ,nvl(n.iscurrentmonth, o.iscurrentmonth) as iscurrentmonth -- 是否本月新发生
    ,nvl(n.totalsum, o.totalsum) as totalsum -- 敞口
    ,nvl(n.maturity, o.maturity) as maturity -- 到期日
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 担保类型
    ,nvl(n.levelclassify, o.levelclassify) as levelclassify -- 评级对应的风险分类
    ,nvl(n.kernaladjustlevel, o.kernaladjustlevel) as kernaladjustlevel -- 
    ,nvl(n.alarminfo, o.alarminfo) as alarminfo -- 
    ,nvl(n.entrance, o.entrance) as entrance -- 申请发起入口1对公系统，2同业系统
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务类型
    ,nvl(n.businesscurrency, o.businesscurrency) as businesscurrency -- 业务币种
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.policyresult, o.policyresult) as policyresult -- 本期申请策略分类
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新时间
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.type, o.type) as type -- 类型
    ,nvl(n.licensedate, o.licensedate) as licensedate -- 营业执照登记日
    ,nvl(n.approveclassifyresult, o.approveclassifyresult) as approveclassifyresult -- 审批环节风险分类
    ,nvl(n.lastcustomerlevel, o.lastcustomerlevel) as lastcustomerlevel -- 上期监测评级
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.pigeonholedate, o.pigeonholedate) as pigeonholedate -- 归案日期
    ,nvl(n.contractserialno, o.contractserialno) as contractserialno -- 合同号
    ,nvl(n.remark1, o.remark1) as remark1 -- 意见
    ,nvl(n.customerlevel, o.customerlevel) as customerlevel -- 信用评级
    ,nvl(n.classifynum, o.classifynum) as classifynum -- 分类笔数
    ,nvl(n.accountmonth, o.accountmonth) as accountmonth -- 分类截至日期
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.relativeno, o.relativeno) as relativeno -- 关联号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.approveclassifytime, o.approveclassifytime) as approveclassifytime -- 审批时间
    ,nvl(n.coverage, o.coverage) as coverage -- 担保覆盖率
    ,nvl(n.assurecustomerid, o.assurecustomerid) as assurecustomerid -- 保证人流水号
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 流程状态
    ,nvl(n.customername, o.customername) as customername -- 客户名
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.guarantysum, o.guarantysum) as guarantysum -- 处置抵质押物收回净值（元）
    ,nvl(n.classifymode, o.classifymode) as classifymode -- 关联合同类型
    ,nvl(n.finalclassifyresult, o.finalclassifyresult) as finalclassifyresult -- 终审风险分类
    ,nvl(n.alarmadjustlevel, o.alarmadjustlevel) as alarmadjustlevel -- 
    ,nvl(n.lastpolicyresult, o.lastpolicyresult) as lastpolicyresult -- 上期策略分类
    ,nvl(n.adjusttype, o.adjusttype) as adjusttype -- 
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.classifyresult, o.classifyresult) as classifyresult -- 分类结果
    ,nvl(n.lastclassifyresult, o.lastclassifyresult) as lastclassifyresult -- 上期风险分类
    ,nvl(n.customerleveltime, o.customerleveltime) as customerleveltime -- 信用评级时间
    ,nvl(n.approveevaluateresult, o.approveevaluateresult) as approveevaluateresult -- 审批环节主体评级
    ,nvl(n.opensum, o.opensum) as opensum -- 
    ,nvl(n.assurelevel, o.assurelevel) as assurelevel -- 保证人信用等级
    ,nvl(n.adviseclassifyresult, o.adviseclassifyresult) as adviseclassifyresult -- 本期系统建议分类
    ,nvl(n.balance, o.balance) as balance -- 余额
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
from (select * from ${iol_schema}.icms_classify_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_classify_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.creditaggreement <> n.creditaggreement
        or o.relativetype <> n.relativetype
        or o.finalpolicyresult <> n.finalpolicyresult
        or o.finalcustomerlevel <> n.finalcustomerlevel
        or o.inputuserid <> n.inputuserid
        or o.flag <> n.flag
        or o.relativeserialno <> n.relativeserialno
        or o.iscurrentmonth <> n.iscurrentmonth
        or o.totalsum <> n.totalsum
        or o.maturity <> n.maturity
        or o.vouchtype <> n.vouchtype
        or o.levelclassify <> n.levelclassify
        or o.kernaladjustlevel <> n.kernaladjustlevel
        or o.alarminfo <> n.alarminfo
        or o.entrance <> n.entrance
        or o.objecttype <> n.objecttype
        or o.businesstype <> n.businesstype
        or o.businesscurrency <> n.businesscurrency
        or o.inputorgid <> n.inputorgid
        or o.policyresult <> n.policyresult
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.type <> n.type
        or o.licensedate <> n.licensedate
        or o.approveclassifyresult <> n.approveclassifyresult
        or o.lastcustomerlevel <> n.lastcustomerlevel
        or o.updateuserid <> n.updateuserid
        or o.pigeonholedate <> n.pigeonholedate
        or o.contractserialno <> n.contractserialno
        or o.remark1 <> n.remark1
        or o.customerlevel <> n.customerlevel
        or o.classifynum <> n.classifynum
        or o.accountmonth <> n.accountmonth
        or o.customerid <> n.customerid
        or o.relativeno <> n.relativeno
        or o.inputdate <> n.inputdate
        or o.approveclassifytime <> n.approveclassifytime
        or o.coverage <> n.coverage
        or o.assurecustomerid <> n.assurecustomerid
        or o.approvestatus <> n.approvestatus
        or o.customername <> n.customername
        or o.remark <> n.remark
        or o.guarantysum <> n.guarantysum
        or o.classifymode <> n.classifymode
        or o.finalclassifyresult <> n.finalclassifyresult
        or o.alarmadjustlevel <> n.alarmadjustlevel
        or o.lastpolicyresult <> n.lastpolicyresult
        or o.adjusttype <> n.adjusttype
        or o.migtflag <> n.migtflag
        or o.classifyresult <> n.classifyresult
        or o.lastclassifyresult <> n.lastclassifyresult
        or o.customerleveltime <> n.customerleveltime
        or o.approveevaluateresult <> n.approveevaluateresult
        or o.opensum <> n.opensum
        or o.assurelevel <> n.assurelevel
        or o.adviseclassifyresult <> n.adviseclassifyresult
        or o.balance <> n.balance
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_classify_apply_cl(
            serialno -- 流水号
            ,creditaggreement -- 额度合同号
            ,relativetype -- 关联类型
            ,finalpolicyresult -- 终审策略分类
            ,finalcustomerlevel -- 终审监测评级
            ,inputuserid -- 登记人
            ,flag -- 标记
            ,relativeserialno -- 关联流水号
            ,iscurrentmonth -- 是否本月新发生
            ,totalsum -- 敞口
            ,maturity -- 到期日
            ,vouchtype -- 担保类型
            ,levelclassify -- 评级对应的风险分类
            ,kernaladjustlevel -- 
            ,alarminfo -- 
            ,entrance -- 申请发起入口1对公系统，2同业系统
            ,objecttype -- 对象类型
            ,businesstype -- 业务类型
            ,businesscurrency -- 业务币种
            ,inputorgid -- 登记机构
            ,policyresult -- 本期申请策略分类
            ,updateorgid -- 更新时间
            ,updatedate -- 更新日期
            ,type -- 类型
            ,licensedate -- 营业执照登记日
            ,approveclassifyresult -- 审批环节风险分类
            ,lastcustomerlevel -- 上期监测评级
            ,updateuserid -- 更新人
            ,pigeonholedate -- 归案日期
            ,contractserialno -- 合同号
            ,remark1 -- 意见
            ,customerlevel -- 信用评级
            ,classifynum -- 分类笔数
            ,accountmonth -- 分类截至日期
            ,customerid -- 客户号
            ,relativeno -- 关联号
            ,inputdate -- 登记日期
            ,approveclassifytime -- 审批时间
            ,coverage -- 担保覆盖率
            ,assurecustomerid -- 保证人流水号
            ,approvestatus -- 流程状态
            ,customername -- 客户名
            ,remark -- 备注
            ,guarantysum -- 处置抵质押物收回净值（元）
            ,classifymode -- 关联合同类型
            ,finalclassifyresult -- 终审风险分类
            ,alarmadjustlevel -- 
            ,lastpolicyresult -- 上期策略分类
            ,adjusttype -- 
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,classifyresult -- 分类结果
            ,lastclassifyresult -- 上期风险分类
            ,customerleveltime -- 信用评级时间
            ,approveevaluateresult -- 审批环节主体评级
            ,opensum -- 
            ,assurelevel -- 保证人信用等级
            ,adviseclassifyresult -- 本期系统建议分类
            ,balance -- 余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_classify_apply_op(
            serialno -- 流水号
            ,creditaggreement -- 额度合同号
            ,relativetype -- 关联类型
            ,finalpolicyresult -- 终审策略分类
            ,finalcustomerlevel -- 终审监测评级
            ,inputuserid -- 登记人
            ,flag -- 标记
            ,relativeserialno -- 关联流水号
            ,iscurrentmonth -- 是否本月新发生
            ,totalsum -- 敞口
            ,maturity -- 到期日
            ,vouchtype -- 担保类型
            ,levelclassify -- 评级对应的风险分类
            ,kernaladjustlevel -- 
            ,alarminfo -- 
            ,entrance -- 申请发起入口1对公系统，2同业系统
            ,objecttype -- 对象类型
            ,businesstype -- 业务类型
            ,businesscurrency -- 业务币种
            ,inputorgid -- 登记机构
            ,policyresult -- 本期申请策略分类
            ,updateorgid -- 更新时间
            ,updatedate -- 更新日期
            ,type -- 类型
            ,licensedate -- 营业执照登记日
            ,approveclassifyresult -- 审批环节风险分类
            ,lastcustomerlevel -- 上期监测评级
            ,updateuserid -- 更新人
            ,pigeonholedate -- 归案日期
            ,contractserialno -- 合同号
            ,remark1 -- 意见
            ,customerlevel -- 信用评级
            ,classifynum -- 分类笔数
            ,accountmonth -- 分类截至日期
            ,customerid -- 客户号
            ,relativeno -- 关联号
            ,inputdate -- 登记日期
            ,approveclassifytime -- 审批时间
            ,coverage -- 担保覆盖率
            ,assurecustomerid -- 保证人流水号
            ,approvestatus -- 流程状态
            ,customername -- 客户名
            ,remark -- 备注
            ,guarantysum -- 处置抵质押物收回净值（元）
            ,classifymode -- 关联合同类型
            ,finalclassifyresult -- 终审风险分类
            ,alarmadjustlevel -- 
            ,lastpolicyresult -- 上期策略分类
            ,adjusttype -- 
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,classifyresult -- 分类结果
            ,lastclassifyresult -- 上期风险分类
            ,customerleveltime -- 信用评级时间
            ,approveevaluateresult -- 审批环节主体评级
            ,opensum -- 
            ,assurelevel -- 保证人信用等级
            ,adviseclassifyresult -- 本期系统建议分类
            ,balance -- 余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.creditaggreement -- 额度合同号
    ,o.relativetype -- 关联类型
    ,o.finalpolicyresult -- 终审策略分类
    ,o.finalcustomerlevel -- 终审监测评级
    ,o.inputuserid -- 登记人
    ,o.flag -- 标记
    ,o.relativeserialno -- 关联流水号
    ,o.iscurrentmonth -- 是否本月新发生
    ,o.totalsum -- 敞口
    ,o.maturity -- 到期日
    ,o.vouchtype -- 担保类型
    ,o.levelclassify -- 评级对应的风险分类
    ,o.kernaladjustlevel -- 
    ,o.alarminfo -- 
    ,o.entrance -- 申请发起入口1对公系统，2同业系统
    ,o.objecttype -- 对象类型
    ,o.businesstype -- 业务类型
    ,o.businesscurrency -- 业务币种
    ,o.inputorgid -- 登记机构
    ,o.policyresult -- 本期申请策略分类
    ,o.updateorgid -- 更新时间
    ,o.updatedate -- 更新日期
    ,o.type -- 类型
    ,o.licensedate -- 营业执照登记日
    ,o.approveclassifyresult -- 审批环节风险分类
    ,o.lastcustomerlevel -- 上期监测评级
    ,o.updateuserid -- 更新人
    ,o.pigeonholedate -- 归案日期
    ,o.contractserialno -- 合同号
    ,o.remark1 -- 意见
    ,o.customerlevel -- 信用评级
    ,o.classifynum -- 分类笔数
    ,o.accountmonth -- 分类截至日期
    ,o.customerid -- 客户号
    ,o.relativeno -- 关联号
    ,o.inputdate -- 登记日期
    ,o.approveclassifytime -- 审批时间
    ,o.coverage -- 担保覆盖率
    ,o.assurecustomerid -- 保证人流水号
    ,o.approvestatus -- 流程状态
    ,o.customername -- 客户名
    ,o.remark -- 备注
    ,o.guarantysum -- 处置抵质押物收回净值（元）
    ,o.classifymode -- 关联合同类型
    ,o.finalclassifyresult -- 终审风险分类
    ,o.alarmadjustlevel -- 
    ,o.lastpolicyresult -- 上期策略分类
    ,o.adjusttype -- 
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.classifyresult -- 分类结果
    ,o.lastclassifyresult -- 上期风险分类
    ,o.customerleveltime -- 信用评级时间
    ,o.approveevaluateresult -- 审批环节主体评级
    ,o.opensum -- 
    ,o.assurelevel -- 保证人信用等级
    ,o.adviseclassifyresult -- 本期系统建议分类
    ,o.balance -- 余额
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
from ${iol_schema}.icms_classify_apply_bk o
    left join ${iol_schema}.icms_classify_apply_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_classify_apply_cl d
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
--truncate table ${iol_schema}.icms_classify_apply;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_classify_apply') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_classify_apply drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_classify_apply add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_classify_apply exchange partition p_${batch_date} with table ${iol_schema}.icms_classify_apply_cl;
alter table ${iol_schema}.icms_classify_apply exchange partition p_20991231 with table ${iol_schema}.icms_classify_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_classify_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_classify_apply_op purge;
drop table ${iol_schema}.icms_classify_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_classify_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_classify_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
