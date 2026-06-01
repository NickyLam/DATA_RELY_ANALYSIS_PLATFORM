/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_cl_business_info
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
create table ${iol_schema}.icms_cl_business_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_cl_business_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cl_business_info_op purge;
drop table ${iol_schema}.icms_cl_business_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_business_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_business_info where 0=1;

create table ${iol_schema}.icms_cl_business_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_business_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cl_business_info_cl(
            amountfactor -- 金额折算系数
            ,operateorgid -- 经办机构
            ,inputuserid -- 登记人
            ,sourcesystem -- 最初来源系统
            ,recyclable -- 可循环标志Y/N
            ,actualexpiredate -- 实际终结日
            ,operateuserid -- 经办人
            ,actualprenomamount -- 实际占用预占名义金额
            ,slowreleaseexposureamount -- 可缓释敞口金额
            ,updateuserid -- 最后更新人
            ,updatedate -- 最后更新日期
            ,preno -- 
            ,exposurebalance -- 授信敞口余额
            ,slowreleaseexposurecurrency -- 可缓释敞口金额币种
            ,timelimitmonth -- 期限月
            ,floatingrate -- 浮动利率
            ,balanceupdatetime -- 余额更新时间
            ,totalrepayment -- 累计还款
            ,manageuserid -- 管理人
            ,manageorgid -- 管理机构
            ,islowrisk -- 是否是低风险业务
            ,exposureamount -- 敞口金额
            ,guarantyway -- 担保方式
            ,expiredate -- 到期日
            ,timelimitday -- 期限日
            ,updateorgid -- 最后更新机构
            ,businesstype -- 业务品种
            ,currency -- 币种
            ,totalpayment -- 累计放款
            ,securitydeposit -- 保证金
            ,execnominalamount -- 执行名义金额
            ,availableexposureamount -- 可用敞口金额
            ,occupyflag -- 占用标识
            ,customerid -- 额度系统客户编号
            ,nominalamount -- 名义金额
            ,nominalbalance -- 授信名义余额
            ,occurway -- 发生方式
            ,execslowreleaseexposureamount -- 执行可缓释敞口金额
            ,status -- 状态
            ,inputdate -- 登记日期
            ,pledgerate -- 抵质押率
            ,creditphase -- 当前授信阶段
            ,inputorgid -- 登记机构
            ,businessno -- 额度系统业务编号
            ,effectivedate -- 生效日期
            ,createdway -- 创建方式:审批/系统
            ,availablenominalamount -- 可用名义金额
            ,remark -- 备注
            ,actualpreexpamount -- 
            ,execexposureamount -- 执行敞口金额
            ,sourcebusinessno -- 最初来源业务编号
            ,pledgesum -- 抵质押物金额
            ,bctype -- 业务合同类型：1 单笔单批
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cl_business_info_op(
            amountfactor -- 金额折算系数
            ,operateorgid -- 经办机构
            ,inputuserid -- 登记人
            ,sourcesystem -- 最初来源系统
            ,recyclable -- 可循环标志Y/N
            ,actualexpiredate -- 实际终结日
            ,operateuserid -- 经办人
            ,actualprenomamount -- 实际占用预占名义金额
            ,slowreleaseexposureamount -- 可缓释敞口金额
            ,updateuserid -- 最后更新人
            ,updatedate -- 最后更新日期
            ,preno -- 
            ,exposurebalance -- 授信敞口余额
            ,slowreleaseexposurecurrency -- 可缓释敞口金额币种
            ,timelimitmonth -- 期限月
            ,floatingrate -- 浮动利率
            ,balanceupdatetime -- 余额更新时间
            ,totalrepayment -- 累计还款
            ,manageuserid -- 管理人
            ,manageorgid -- 管理机构
            ,islowrisk -- 是否是低风险业务
            ,exposureamount -- 敞口金额
            ,guarantyway -- 担保方式
            ,expiredate -- 到期日
            ,timelimitday -- 期限日
            ,updateorgid -- 最后更新机构
            ,businesstype -- 业务品种
            ,currency -- 币种
            ,totalpayment -- 累计放款
            ,securitydeposit -- 保证金
            ,execnominalamount -- 执行名义金额
            ,availableexposureamount -- 可用敞口金额
            ,occupyflag -- 占用标识
            ,customerid -- 额度系统客户编号
            ,nominalamount -- 名义金额
            ,nominalbalance -- 授信名义余额
            ,occurway -- 发生方式
            ,execslowreleaseexposureamount -- 执行可缓释敞口金额
            ,status -- 状态
            ,inputdate -- 登记日期
            ,pledgerate -- 抵质押率
            ,creditphase -- 当前授信阶段
            ,inputorgid -- 登记机构
            ,businessno -- 额度系统业务编号
            ,effectivedate -- 生效日期
            ,createdway -- 创建方式:审批/系统
            ,availablenominalamount -- 可用名义金额
            ,remark -- 备注
            ,actualpreexpamount -- 
            ,execexposureamount -- 执行敞口金额
            ,sourcebusinessno -- 最初来源业务编号
            ,pledgesum -- 抵质押物金额
            ,bctype -- 业务合同类型：1 单笔单批
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.amountfactor, o.amountfactor) as amountfactor -- 金额折算系数
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.sourcesystem, o.sourcesystem) as sourcesystem -- 最初来源系统
    ,nvl(n.recyclable, o.recyclable) as recyclable -- 可循环标志Y/N
    ,nvl(n.actualexpiredate, o.actualexpiredate) as actualexpiredate -- 实际终结日
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 经办人
    ,nvl(n.actualprenomamount, o.actualprenomamount) as actualprenomamount -- 实际占用预占名义金额
    ,nvl(n.slowreleaseexposureamount, o.slowreleaseexposureamount) as slowreleaseexposureamount -- 可缓释敞口金额
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 最后更新人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 最后更新日期
    ,nvl(n.preno, o.preno) as preno -- 
    ,nvl(n.exposurebalance, o.exposurebalance) as exposurebalance -- 授信敞口余额
    ,nvl(n.slowreleaseexposurecurrency, o.slowreleaseexposurecurrency) as slowreleaseexposurecurrency -- 可缓释敞口金额币种
    ,nvl(n.timelimitmonth, o.timelimitmonth) as timelimitmonth -- 期限月
    ,nvl(n.floatingrate, o.floatingrate) as floatingrate -- 浮动利率
    ,nvl(n.balanceupdatetime, o.balanceupdatetime) as balanceupdatetime -- 余额更新时间
    ,nvl(n.totalrepayment, o.totalrepayment) as totalrepayment -- 累计还款
    ,nvl(n.manageuserid, o.manageuserid) as manageuserid -- 管理人
    ,nvl(n.manageorgid, o.manageorgid) as manageorgid -- 管理机构
    ,nvl(n.islowrisk, o.islowrisk) as islowrisk -- 是否是低风险业务
    ,nvl(n.exposureamount, o.exposureamount) as exposureamount -- 敞口金额
    ,nvl(n.guarantyway, o.guarantyway) as guarantyway -- 担保方式
    ,nvl(n.expiredate, o.expiredate) as expiredate -- 到期日
    ,nvl(n.timelimitday, o.timelimitday) as timelimitday -- 期限日
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 最后更新机构
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务品种
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.totalpayment, o.totalpayment) as totalpayment -- 累计放款
    ,nvl(n.securitydeposit, o.securitydeposit) as securitydeposit -- 保证金
    ,nvl(n.execnominalamount, o.execnominalamount) as execnominalamount -- 执行名义金额
    ,nvl(n.availableexposureamount, o.availableexposureamount) as availableexposureamount -- 可用敞口金额
    ,nvl(n.occupyflag, o.occupyflag) as occupyflag -- 占用标识
    ,nvl(n.customerid, o.customerid) as customerid -- 额度系统客户编号
    ,nvl(n.nominalamount, o.nominalamount) as nominalamount -- 名义金额
    ,nvl(n.nominalbalance, o.nominalbalance) as nominalbalance -- 授信名义余额
    ,nvl(n.occurway, o.occurway) as occurway -- 发生方式
    ,nvl(n.execslowreleaseexposureamount, o.execslowreleaseexposureamount) as execslowreleaseexposureamount -- 执行可缓释敞口金额
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.pledgerate, o.pledgerate) as pledgerate -- 抵质押率
    ,nvl(n.creditphase, o.creditphase) as creditphase -- 当前授信阶段
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.businessno, o.businessno) as businessno -- 额度系统业务编号
    ,nvl(n.effectivedate, o.effectivedate) as effectivedate -- 生效日期
    ,nvl(n.createdway, o.createdway) as createdway -- 创建方式:审批/系统
    ,nvl(n.availablenominalamount, o.availablenominalamount) as availablenominalamount -- 可用名义金额
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.actualpreexpamount, o.actualpreexpamount) as actualpreexpamount -- 
    ,nvl(n.execexposureamount, o.execexposureamount) as execexposureamount -- 执行敞口金额
    ,nvl(n.sourcebusinessno, o.sourcebusinessno) as sourcebusinessno -- 最初来源业务编号
    ,nvl(n.pledgesum, o.pledgesum) as pledgesum -- 抵质押物金额
    ,nvl(n.bctype, o.bctype) as bctype -- 业务合同类型：1 单笔单批
    ,case when
            n.businessno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.businessno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.businessno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_cl_business_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_cl_business_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.businessno = n.businessno
where (
        o.businessno is null
    )
    or (
        n.businessno is null
    )
    or (
        o.amountfactor <> n.amountfactor
        or o.operateorgid <> n.operateorgid
        or o.inputuserid <> n.inputuserid
        or o.sourcesystem <> n.sourcesystem
        or o.recyclable <> n.recyclable
        or o.actualexpiredate <> n.actualexpiredate
        or o.operateuserid <> n.operateuserid
        or o.actualprenomamount <> n.actualprenomamount
        or o.slowreleaseexposureamount <> n.slowreleaseexposureamount
        or o.updateuserid <> n.updateuserid
        or o.updatedate <> n.updatedate
        or o.preno <> n.preno
        or o.exposurebalance <> n.exposurebalance
        or o.slowreleaseexposurecurrency <> n.slowreleaseexposurecurrency
        or o.timelimitmonth <> n.timelimitmonth
        or o.floatingrate <> n.floatingrate
        or o.balanceupdatetime <> n.balanceupdatetime
        or o.totalrepayment <> n.totalrepayment
        or o.manageuserid <> n.manageuserid
        or o.manageorgid <> n.manageorgid
        or o.islowrisk <> n.islowrisk
        or o.exposureamount <> n.exposureamount
        or o.guarantyway <> n.guarantyway
        or o.expiredate <> n.expiredate
        or o.timelimitday <> n.timelimitday
        or o.updateorgid <> n.updateorgid
        or o.businesstype <> n.businesstype
        or o.currency <> n.currency
        or o.totalpayment <> n.totalpayment
        or o.securitydeposit <> n.securitydeposit
        or o.execnominalamount <> n.execnominalamount
        or o.availableexposureamount <> n.availableexposureamount
        or o.occupyflag <> n.occupyflag
        or o.customerid <> n.customerid
        or o.nominalamount <> n.nominalamount
        or o.nominalbalance <> n.nominalbalance
        or o.occurway <> n.occurway
        or o.execslowreleaseexposureamount <> n.execslowreleaseexposureamount
        or o.status <> n.status
        or o.inputdate <> n.inputdate
        or o.pledgerate <> n.pledgerate
        or o.creditphase <> n.creditphase
        or o.inputorgid <> n.inputorgid
        or o.effectivedate <> n.effectivedate
        or o.createdway <> n.createdway
        or o.availablenominalamount <> n.availablenominalamount
        or o.remark <> n.remark
        or o.actualpreexpamount <> n.actualpreexpamount
        or o.execexposureamount <> n.execexposureamount
        or o.sourcebusinessno <> n.sourcebusinessno
        or o.pledgesum <> n.pledgesum
        or o.bctype <> n.bctype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cl_business_info_cl(
            amountfactor -- 金额折算系数
            ,operateorgid -- 经办机构
            ,inputuserid -- 登记人
            ,sourcesystem -- 最初来源系统
            ,recyclable -- 可循环标志Y/N
            ,actualexpiredate -- 实际终结日
            ,operateuserid -- 经办人
            ,actualprenomamount -- 实际占用预占名义金额
            ,slowreleaseexposureamount -- 可缓释敞口金额
            ,updateuserid -- 最后更新人
            ,updatedate -- 最后更新日期
            ,preno -- 
            ,exposurebalance -- 授信敞口余额
            ,slowreleaseexposurecurrency -- 可缓释敞口金额币种
            ,timelimitmonth -- 期限月
            ,floatingrate -- 浮动利率
            ,balanceupdatetime -- 余额更新时间
            ,totalrepayment -- 累计还款
            ,manageuserid -- 管理人
            ,manageorgid -- 管理机构
            ,islowrisk -- 是否是低风险业务
            ,exposureamount -- 敞口金额
            ,guarantyway -- 担保方式
            ,expiredate -- 到期日
            ,timelimitday -- 期限日
            ,updateorgid -- 最后更新机构
            ,businesstype -- 业务品种
            ,currency -- 币种
            ,totalpayment -- 累计放款
            ,securitydeposit -- 保证金
            ,execnominalamount -- 执行名义金额
            ,availableexposureamount -- 可用敞口金额
            ,occupyflag -- 占用标识
            ,customerid -- 额度系统客户编号
            ,nominalamount -- 名义金额
            ,nominalbalance -- 授信名义余额
            ,occurway -- 发生方式
            ,execslowreleaseexposureamount -- 执行可缓释敞口金额
            ,status -- 状态
            ,inputdate -- 登记日期
            ,pledgerate -- 抵质押率
            ,creditphase -- 当前授信阶段
            ,inputorgid -- 登记机构
            ,businessno -- 额度系统业务编号
            ,effectivedate -- 生效日期
            ,createdway -- 创建方式:审批/系统
            ,availablenominalamount -- 可用名义金额
            ,remark -- 备注
            ,actualpreexpamount -- 
            ,execexposureamount -- 执行敞口金额
            ,sourcebusinessno -- 最初来源业务编号
            ,pledgesum -- 抵质押物金额
            ,bctype -- 业务合同类型：1 单笔单批
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cl_business_info_op(
            amountfactor -- 金额折算系数
            ,operateorgid -- 经办机构
            ,inputuserid -- 登记人
            ,sourcesystem -- 最初来源系统
            ,recyclable -- 可循环标志Y/N
            ,actualexpiredate -- 实际终结日
            ,operateuserid -- 经办人
            ,actualprenomamount -- 实际占用预占名义金额
            ,slowreleaseexposureamount -- 可缓释敞口金额
            ,updateuserid -- 最后更新人
            ,updatedate -- 最后更新日期
            ,preno -- 
            ,exposurebalance -- 授信敞口余额
            ,slowreleaseexposurecurrency -- 可缓释敞口金额币种
            ,timelimitmonth -- 期限月
            ,floatingrate -- 浮动利率
            ,balanceupdatetime -- 余额更新时间
            ,totalrepayment -- 累计还款
            ,manageuserid -- 管理人
            ,manageorgid -- 管理机构
            ,islowrisk -- 是否是低风险业务
            ,exposureamount -- 敞口金额
            ,guarantyway -- 担保方式
            ,expiredate -- 到期日
            ,timelimitday -- 期限日
            ,updateorgid -- 最后更新机构
            ,businesstype -- 业务品种
            ,currency -- 币种
            ,totalpayment -- 累计放款
            ,securitydeposit -- 保证金
            ,execnominalamount -- 执行名义金额
            ,availableexposureamount -- 可用敞口金额
            ,occupyflag -- 占用标识
            ,customerid -- 额度系统客户编号
            ,nominalamount -- 名义金额
            ,nominalbalance -- 授信名义余额
            ,occurway -- 发生方式
            ,execslowreleaseexposureamount -- 执行可缓释敞口金额
            ,status -- 状态
            ,inputdate -- 登记日期
            ,pledgerate -- 抵质押率
            ,creditphase -- 当前授信阶段
            ,inputorgid -- 登记机构
            ,businessno -- 额度系统业务编号
            ,effectivedate -- 生效日期
            ,createdway -- 创建方式:审批/系统
            ,availablenominalamount -- 可用名义金额
            ,remark -- 备注
            ,actualpreexpamount -- 
            ,execexposureamount -- 执行敞口金额
            ,sourcebusinessno -- 最初来源业务编号
            ,pledgesum -- 抵质押物金额
            ,bctype -- 业务合同类型：1 单笔单批
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.amountfactor -- 金额折算系数
    ,o.operateorgid -- 经办机构
    ,o.inputuserid -- 登记人
    ,o.sourcesystem -- 最初来源系统
    ,o.recyclable -- 可循环标志Y/N
    ,o.actualexpiredate -- 实际终结日
    ,o.operateuserid -- 经办人
    ,o.actualprenomamount -- 实际占用预占名义金额
    ,o.slowreleaseexposureamount -- 可缓释敞口金额
    ,o.updateuserid -- 最后更新人
    ,o.updatedate -- 最后更新日期
    ,o.preno -- 
    ,o.exposurebalance -- 授信敞口余额
    ,o.slowreleaseexposurecurrency -- 可缓释敞口金额币种
    ,o.timelimitmonth -- 期限月
    ,o.floatingrate -- 浮动利率
    ,o.balanceupdatetime -- 余额更新时间
    ,o.totalrepayment -- 累计还款
    ,o.manageuserid -- 管理人
    ,o.manageorgid -- 管理机构
    ,o.islowrisk -- 是否是低风险业务
    ,o.exposureamount -- 敞口金额
    ,o.guarantyway -- 担保方式
    ,o.expiredate -- 到期日
    ,o.timelimitday -- 期限日
    ,o.updateorgid -- 最后更新机构
    ,o.businesstype -- 业务品种
    ,o.currency -- 币种
    ,o.totalpayment -- 累计放款
    ,o.securitydeposit -- 保证金
    ,o.execnominalamount -- 执行名义金额
    ,o.availableexposureamount -- 可用敞口金额
    ,o.occupyflag -- 占用标识
    ,o.customerid -- 额度系统客户编号
    ,o.nominalamount -- 名义金额
    ,o.nominalbalance -- 授信名义余额
    ,o.occurway -- 发生方式
    ,o.execslowreleaseexposureamount -- 执行可缓释敞口金额
    ,o.status -- 状态
    ,o.inputdate -- 登记日期
    ,o.pledgerate -- 抵质押率
    ,o.creditphase -- 当前授信阶段
    ,o.inputorgid -- 登记机构
    ,o.businessno -- 额度系统业务编号
    ,o.effectivedate -- 生效日期
    ,o.createdway -- 创建方式:审批/系统
    ,o.availablenominalamount -- 可用名义金额
    ,o.remark -- 备注
    ,o.actualpreexpamount -- 
    ,o.execexposureamount -- 执行敞口金额
    ,o.sourcebusinessno -- 最初来源业务编号
    ,o.pledgesum -- 抵质押物金额
    ,o.bctype -- 业务合同类型：1 单笔单批
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
from ${iol_schema}.icms_cl_business_info_bk o
    left join ${iol_schema}.icms_cl_business_info_op n
        on
            o.businessno = n.businessno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_cl_business_info_cl d
        on
            o.businessno = d.businessno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_cl_business_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_cl_business_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_cl_business_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_cl_business_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_cl_business_info exchange partition p_${batch_date} with table ${iol_schema}.icms_cl_business_info_cl;
alter table ${iol_schema}.icms_cl_business_info exchange partition p_20991231 with table ${iol_schema}.icms_cl_business_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_cl_business_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cl_business_info_op purge;
drop table ${iol_schema}.icms_cl_business_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_cl_business_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_cl_business_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
