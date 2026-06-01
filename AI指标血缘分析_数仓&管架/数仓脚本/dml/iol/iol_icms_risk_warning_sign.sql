/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_risk_warning_sign
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
create table ${iol_schema}.icms_risk_warning_sign_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_risk_warning_sign
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_risk_warning_sign_op purge;
drop table ${iol_schema}.icms_risk_warning_sign_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_risk_warning_sign_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_risk_warning_sign where 0=1;

create table ${iol_schema}.icms_risk_warning_sign_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_risk_warning_sign where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_risk_warning_sign_cl(
            serialno -- 预警信号编号
            ,signlevel -- 预警信号级别(一级预警信号（重大）、二级预警信号、三级预警信号)
            ,effecttime -- 生效时间
            ,maxoverduedays -- 当前最高逾期天数
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,creditlevel -- 信用等级
            ,customername -- 客户名称
            ,remark -- 备注
            ,businessname -- 企业名称
            ,rqrfindate -- 要求完成日期
            ,canceltime -- 失效时间
            ,monitorcode -- 预警信号代码
            ,balance -- 产品余额
            ,warningresult -- 预警信号原因
            ,releaseresult -- 解除理由
            ,compaddr -- 企业地址
            ,repaytype -- 还款方式
            ,dealopinion -- 处理意见
            ,inputuserid -- 登记人
            ,compsize -- 企业规模
            ,customertype -- 客户类型
            ,monitorcontent -- 预警信号内容
            ,riskcontrolplan -- 拟采取的处置计划和风险控制措施
            ,compprop -- 企业性质
            ,isprveconomy -- 是否民营
            ,productid -- 产品编号
            ,riskdealno -- 助贷风险处理流水
            ,managerorgid -- 主管机构
            ,customerid -- 客户编号
            ,industryname -- 所属行业名称
            ,signtype -- 预警信号类型
            ,checktaskno -- 检查任务编号
            ,industrytype -- 所属行业类型
            ,creditdesc -- 当前授信情况
            ,releasedate -- 解除日期
            ,updatedate -- 更新日期
            ,accumrepaysum -- 累计还款本金
            ,monitortaskno -- 监测任务编号
            ,effectdate -- 生效日期
            ,signstatus -- 预警信号状态
            ,inputdate -- 登记日期
            ,createtype -- 生成方式
            ,inputorgid -- 登记机构
            ,effectresult -- 生效原因
            ,risklosslevel -- 本笔贷款的风险程度及预计损失程度
            ,overduelevel -- 逾期等级
            ,dealdate -- 处理日期
            ,infactfindate -- 实际审批完成日期
            ,batserialno -- 处理批次流水号
            ,term -- 期限
            ,manageruserid -- 主管客户经理
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_risk_warning_sign_op(
            serialno -- 预警信号编号
            ,signlevel -- 预警信号级别(一级预警信号（重大）、二级预警信号、三级预警信号)
            ,effecttime -- 生效时间
            ,maxoverduedays -- 当前最高逾期天数
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,creditlevel -- 信用等级
            ,customername -- 客户名称
            ,remark -- 备注
            ,businessname -- 企业名称
            ,rqrfindate -- 要求完成日期
            ,canceltime -- 失效时间
            ,monitorcode -- 预警信号代码
            ,balance -- 产品余额
            ,warningresult -- 预警信号原因
            ,releaseresult -- 解除理由
            ,compaddr -- 企业地址
            ,repaytype -- 还款方式
            ,dealopinion -- 处理意见
            ,inputuserid -- 登记人
            ,compsize -- 企业规模
            ,customertype -- 客户类型
            ,monitorcontent -- 预警信号内容
            ,riskcontrolplan -- 拟采取的处置计划和风险控制措施
            ,compprop -- 企业性质
            ,isprveconomy -- 是否民营
            ,productid -- 产品编号
            ,riskdealno -- 助贷风险处理流水
            ,managerorgid -- 主管机构
            ,customerid -- 客户编号
            ,industryname -- 所属行业名称
            ,signtype -- 预警信号类型
            ,checktaskno -- 检查任务编号
            ,industrytype -- 所属行业类型
            ,creditdesc -- 当前授信情况
            ,releasedate -- 解除日期
            ,updatedate -- 更新日期
            ,accumrepaysum -- 累计还款本金
            ,monitortaskno -- 监测任务编号
            ,effectdate -- 生效日期
            ,signstatus -- 预警信号状态
            ,inputdate -- 登记日期
            ,createtype -- 生成方式
            ,inputorgid -- 登记机构
            ,effectresult -- 生效原因
            ,risklosslevel -- 本笔贷款的风险程度及预计损失程度
            ,overduelevel -- 逾期等级
            ,dealdate -- 处理日期
            ,infactfindate -- 实际审批完成日期
            ,batserialno -- 处理批次流水号
            ,term -- 期限
            ,manageruserid -- 主管客户经理
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 预警信号编号
    ,nvl(n.signlevel, o.signlevel) as signlevel -- 预警信号级别(一级预警信号（重大）、二级预警信号、三级预警信号)
    ,nvl(n.effecttime, o.effecttime) as effecttime -- 生效时间
    ,nvl(n.maxoverduedays, o.maxoverduedays) as maxoverduedays -- 当前最高逾期天数
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.creditlevel, o.creditlevel) as creditlevel -- 信用等级
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.businessname, o.businessname) as businessname -- 企业名称
    ,nvl(n.rqrfindate, o.rqrfindate) as rqrfindate -- 要求完成日期
    ,nvl(n.canceltime, o.canceltime) as canceltime -- 失效时间
    ,nvl(n.monitorcode, o.monitorcode) as monitorcode -- 预警信号代码
    ,nvl(n.balance, o.balance) as balance -- 产品余额
    ,nvl(n.warningresult, o.warningresult) as warningresult -- 预警信号原因
    ,nvl(n.releaseresult, o.releaseresult) as releaseresult -- 解除理由
    ,nvl(n.compaddr, o.compaddr) as compaddr -- 企业地址
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.dealopinion, o.dealopinion) as dealopinion -- 处理意见
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.compsize, o.compsize) as compsize -- 企业规模
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型
    ,nvl(n.monitorcontent, o.monitorcontent) as monitorcontent -- 预警信号内容
    ,nvl(n.riskcontrolplan, o.riskcontrolplan) as riskcontrolplan -- 拟采取的处置计划和风险控制措施
    ,nvl(n.compprop, o.compprop) as compprop -- 企业性质
    ,nvl(n.isprveconomy, o.isprveconomy) as isprveconomy -- 是否民营
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.riskdealno, o.riskdealno) as riskdealno -- 助贷风险处理流水
    ,nvl(n.managerorgid, o.managerorgid) as managerorgid -- 主管机构
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.industryname, o.industryname) as industryname -- 所属行业名称
    ,nvl(n.signtype, o.signtype) as signtype -- 预警信号类型
    ,nvl(n.checktaskno, o.checktaskno) as checktaskno -- 检查任务编号
    ,nvl(n.industrytype, o.industrytype) as industrytype -- 所属行业类型
    ,nvl(n.creditdesc, o.creditdesc) as creditdesc -- 当前授信情况
    ,nvl(n.releasedate, o.releasedate) as releasedate -- 解除日期
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.accumrepaysum, o.accumrepaysum) as accumrepaysum -- 累计还款本金
    ,nvl(n.monitortaskno, o.monitortaskno) as monitortaskno -- 监测任务编号
    ,nvl(n.effectdate, o.effectdate) as effectdate -- 生效日期
    ,nvl(n.signstatus, o.signstatus) as signstatus -- 预警信号状态
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.createtype, o.createtype) as createtype -- 生成方式
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.effectresult, o.effectresult) as effectresult -- 生效原因
    ,nvl(n.risklosslevel, o.risklosslevel) as risklosslevel -- 本笔贷款的风险程度及预计损失程度
    ,nvl(n.overduelevel, o.overduelevel) as overduelevel -- 逾期等级
    ,nvl(n.dealdate, o.dealdate) as dealdate -- 处理日期
    ,nvl(n.infactfindate, o.infactfindate) as infactfindate -- 实际审批完成日期
    ,nvl(n.batserialno, o.batserialno) as batserialno -- 处理批次流水号
    ,nvl(n.term, o.term) as term -- 期限
    ,nvl(n.manageruserid, o.manageruserid) as manageruserid -- 主管客户经理
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certid, o.certid) as certid -- 证件号码
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
from (select * from ${iol_schema}.icms_risk_warning_sign_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_risk_warning_sign where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.signlevel <> n.signlevel
        or o.effecttime <> n.effecttime
        or o.maxoverduedays <> n.maxoverduedays
        or o.migtflag <> n.migtflag
        or o.creditlevel <> n.creditlevel
        or o.customername <> n.customername
        or o.remark <> n.remark
        or o.businessname <> n.businessname
        or o.rqrfindate <> n.rqrfindate
        or o.canceltime <> n.canceltime
        or o.monitorcode <> n.monitorcode
        or o.balance <> n.balance
        or o.warningresult <> n.warningresult
        or o.releaseresult <> n.releaseresult
        or o.compaddr <> n.compaddr
        or o.repaytype <> n.repaytype
        or o.dealopinion <> n.dealopinion
        or o.inputuserid <> n.inputuserid
        or o.compsize <> n.compsize
        or o.customertype <> n.customertype
        or o.monitorcontent <> n.monitorcontent
        or o.riskcontrolplan <> n.riskcontrolplan
        or o.compprop <> n.compprop
        or o.isprveconomy <> n.isprveconomy
        or o.productid <> n.productid
        or o.riskdealno <> n.riskdealno
        or o.managerorgid <> n.managerorgid
        or o.customerid <> n.customerid
        or o.industryname <> n.industryname
        or o.signtype <> n.signtype
        or o.checktaskno <> n.checktaskno
        or o.industrytype <> n.industrytype
        or o.creditdesc <> n.creditdesc
        or o.releasedate <> n.releasedate
        or o.updatedate <> n.updatedate
        or o.accumrepaysum <> n.accumrepaysum
        or o.monitortaskno <> n.monitortaskno
        or o.effectdate <> n.effectdate
        or o.signstatus <> n.signstatus
        or o.inputdate <> n.inputdate
        or o.createtype <> n.createtype
        or o.inputorgid <> n.inputorgid
        or o.effectresult <> n.effectresult
        or o.risklosslevel <> n.risklosslevel
        or o.overduelevel <> n.overduelevel
        or o.dealdate <> n.dealdate
        or o.infactfindate <> n.infactfindate
        or o.batserialno <> n.batserialno
        or o.term <> n.term
        or o.manageruserid <> n.manageruserid
        or o.certtype <> n.certtype
        or o.certid <> n.certid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_risk_warning_sign_cl(
            serialno -- 预警信号编号
            ,signlevel -- 预警信号级别(一级预警信号（重大）、二级预警信号、三级预警信号)
            ,effecttime -- 生效时间
            ,maxoverduedays -- 当前最高逾期天数
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,creditlevel -- 信用等级
            ,customername -- 客户名称
            ,remark -- 备注
            ,businessname -- 企业名称
            ,rqrfindate -- 要求完成日期
            ,canceltime -- 失效时间
            ,monitorcode -- 预警信号代码
            ,balance -- 产品余额
            ,warningresult -- 预警信号原因
            ,releaseresult -- 解除理由
            ,compaddr -- 企业地址
            ,repaytype -- 还款方式
            ,dealopinion -- 处理意见
            ,inputuserid -- 登记人
            ,compsize -- 企业规模
            ,customertype -- 客户类型
            ,monitorcontent -- 预警信号内容
            ,riskcontrolplan -- 拟采取的处置计划和风险控制措施
            ,compprop -- 企业性质
            ,isprveconomy -- 是否民营
            ,productid -- 产品编号
            ,riskdealno -- 助贷风险处理流水
            ,managerorgid -- 主管机构
            ,customerid -- 客户编号
            ,industryname -- 所属行业名称
            ,signtype -- 预警信号类型
            ,checktaskno -- 检查任务编号
            ,industrytype -- 所属行业类型
            ,creditdesc -- 当前授信情况
            ,releasedate -- 解除日期
            ,updatedate -- 更新日期
            ,accumrepaysum -- 累计还款本金
            ,monitortaskno -- 监测任务编号
            ,effectdate -- 生效日期
            ,signstatus -- 预警信号状态
            ,inputdate -- 登记日期
            ,createtype -- 生成方式
            ,inputorgid -- 登记机构
            ,effectresult -- 生效原因
            ,risklosslevel -- 本笔贷款的风险程度及预计损失程度
            ,overduelevel -- 逾期等级
            ,dealdate -- 处理日期
            ,infactfindate -- 实际审批完成日期
            ,batserialno -- 处理批次流水号
            ,term -- 期限
            ,manageruserid -- 主管客户经理
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_risk_warning_sign_op(
            serialno -- 预警信号编号
            ,signlevel -- 预警信号级别(一级预警信号（重大）、二级预警信号、三级预警信号)
            ,effecttime -- 生效时间
            ,maxoverduedays -- 当前最高逾期天数
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,creditlevel -- 信用等级
            ,customername -- 客户名称
            ,remark -- 备注
            ,businessname -- 企业名称
            ,rqrfindate -- 要求完成日期
            ,canceltime -- 失效时间
            ,monitorcode -- 预警信号代码
            ,balance -- 产品余额
            ,warningresult -- 预警信号原因
            ,releaseresult -- 解除理由
            ,compaddr -- 企业地址
            ,repaytype -- 还款方式
            ,dealopinion -- 处理意见
            ,inputuserid -- 登记人
            ,compsize -- 企业规模
            ,customertype -- 客户类型
            ,monitorcontent -- 预警信号内容
            ,riskcontrolplan -- 拟采取的处置计划和风险控制措施
            ,compprop -- 企业性质
            ,isprveconomy -- 是否民营
            ,productid -- 产品编号
            ,riskdealno -- 助贷风险处理流水
            ,managerorgid -- 主管机构
            ,customerid -- 客户编号
            ,industryname -- 所属行业名称
            ,signtype -- 预警信号类型
            ,checktaskno -- 检查任务编号
            ,industrytype -- 所属行业类型
            ,creditdesc -- 当前授信情况
            ,releasedate -- 解除日期
            ,updatedate -- 更新日期
            ,accumrepaysum -- 累计还款本金
            ,monitortaskno -- 监测任务编号
            ,effectdate -- 生效日期
            ,signstatus -- 预警信号状态
            ,inputdate -- 登记日期
            ,createtype -- 生成方式
            ,inputorgid -- 登记机构
            ,effectresult -- 生效原因
            ,risklosslevel -- 本笔贷款的风险程度及预计损失程度
            ,overduelevel -- 逾期等级
            ,dealdate -- 处理日期
            ,infactfindate -- 实际审批完成日期
            ,batserialno -- 处理批次流水号
            ,term -- 期限
            ,manageruserid -- 主管客户经理
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 预警信号编号
    ,o.signlevel -- 预警信号级别(一级预警信号（重大）、二级预警信号、三级预警信号)
    ,o.effecttime -- 生效时间
    ,o.maxoverduedays -- 当前最高逾期天数
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.creditlevel -- 信用等级
    ,o.customername -- 客户名称
    ,o.remark -- 备注
    ,o.businessname -- 企业名称
    ,o.rqrfindate -- 要求完成日期
    ,o.canceltime -- 失效时间
    ,o.monitorcode -- 预警信号代码
    ,o.balance -- 产品余额
    ,o.warningresult -- 预警信号原因
    ,o.releaseresult -- 解除理由
    ,o.compaddr -- 企业地址
    ,o.repaytype -- 还款方式
    ,o.dealopinion -- 处理意见
    ,o.inputuserid -- 登记人
    ,o.compsize -- 企业规模
    ,o.customertype -- 客户类型
    ,o.monitorcontent -- 预警信号内容
    ,o.riskcontrolplan -- 拟采取的处置计划和风险控制措施
    ,o.compprop -- 企业性质
    ,o.isprveconomy -- 是否民营
    ,o.productid -- 产品编号
    ,o.riskdealno -- 助贷风险处理流水
    ,o.managerorgid -- 主管机构
    ,o.customerid -- 客户编号
    ,o.industryname -- 所属行业名称
    ,o.signtype -- 预警信号类型
    ,o.checktaskno -- 检查任务编号
    ,o.industrytype -- 所属行业类型
    ,o.creditdesc -- 当前授信情况
    ,o.releasedate -- 解除日期
    ,o.updatedate -- 更新日期
    ,o.accumrepaysum -- 累计还款本金
    ,o.monitortaskno -- 监测任务编号
    ,o.effectdate -- 生效日期
    ,o.signstatus -- 预警信号状态
    ,o.inputdate -- 登记日期
    ,o.createtype -- 生成方式
    ,o.inputorgid -- 登记机构
    ,o.effectresult -- 生效原因
    ,o.risklosslevel -- 本笔贷款的风险程度及预计损失程度
    ,o.overduelevel -- 逾期等级
    ,o.dealdate -- 处理日期
    ,o.infactfindate -- 实际审批完成日期
    ,o.batserialno -- 处理批次流水号
    ,o.term -- 期限
    ,o.manageruserid -- 主管客户经理
    ,o.certtype -- 证件类型
    ,o.certid -- 证件号码
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
from ${iol_schema}.icms_risk_warning_sign_bk o
    left join ${iol_schema}.icms_risk_warning_sign_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_risk_warning_sign_cl d
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
--truncate table ${iol_schema}.icms_risk_warning_sign;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_risk_warning_sign') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_risk_warning_sign drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_risk_warning_sign add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_risk_warning_sign exchange partition p_${batch_date} with table ${iol_schema}.icms_risk_warning_sign_cl;
alter table ${iol_schema}.icms_risk_warning_sign exchange partition p_20991231 with table ${iol_schema}.icms_risk_warning_sign_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_risk_warning_sign to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_risk_warning_sign_op purge;
drop table ${iol_schema}.icms_risk_warning_sign_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_risk_warning_sign_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_risk_warning_sign',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
