/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_remindalert_wastbook
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
create table ${iol_schema}.icms_remindalert_wastbook_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_remindalert_wastbook
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_remindalert_wastbook_op purge;
drop table ${iol_schema}.icms_remindalert_wastbook_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_remindalert_wastbook_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_remindalert_wastbook where 0=1;

create table ${iol_schema}.icms_remindalert_wastbook_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_remindalert_wastbook where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_remindalert_wastbook_cl(
            serialno -- 流水号
            ,remark4 -- 客户经理生效原因
            ,submitriskorgid -- 风险经理机构
            ,signlevel -- 信号级别
            ,querydate -- 征信查询日期
            ,effectflag -- 生效/失效预警申请
            ,inputdate -- 登记时间
            ,inputuserid -- 登记人
            ,remark -- 原因
            ,certid -- 证件号码
            ,loanoverdate -- 是否贷款逾期
            ,creditcardoverdate -- 是否信用卡逾期
            ,allcreditcardusedamount -- 所有信用卡已使用额度
            ,updateorgid -- 更新机构
            ,customertype -- 客户类型
            ,newcreditloannum -- 新增信用贷款笔数
            ,remark2 -- 风险经理失效原因
            ,managerorgid -- 管户机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,guarantyforothersyq -- 对外担保是否逾期
            ,updateuserid -- 更新人
            ,customerid -- 客户编号
            ,objecttype -- 监测类型
            ,certtype -- 证件类型
            ,reportscope -- 报表口径
            ,newcreditloanbalance -- 新增信用贷款余额
            ,querytimesamonth -- 近一月征信查询次数
            ,allcreditcardamount -- 所有信用卡授信额度
            ,inputorgid -- 登记机构
            ,laststatusflag -- 最新状态标志
            ,relatingname -- 关联企业名称
            ,alertcontent -- 预警内容
            ,customername -- 客户名称
            ,relatingid -- 关联企业编号
            ,signname -- 信号名称
            ,manageruserid -- 管户人
            ,objectno -- 监测流水号
            ,remark1 -- 客户经理失效原因
            ,guarantyforothers -- 对外担保金额
            ,creditcardusedrate -- 信用卡使用率
            ,alertinfosource -- 预警信息来源
            ,updatedate -- 更新日期
            ,reportdate -- 报表日期
            ,rowsubject -- 报表科目
            ,submitriskmanager -- 风险经理编号
            ,duebillserialno -- 借据号
            ,status -- 状态标志
            ,remark3 -- 总经理室失效原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_remindalert_wastbook_op(
            serialno -- 流水号
            ,remark4 -- 客户经理生效原因
            ,submitriskorgid -- 风险经理机构
            ,signlevel -- 信号级别
            ,querydate -- 征信查询日期
            ,effectflag -- 生效/失效预警申请
            ,inputdate -- 登记时间
            ,inputuserid -- 登记人
            ,remark -- 原因
            ,certid -- 证件号码
            ,loanoverdate -- 是否贷款逾期
            ,creditcardoverdate -- 是否信用卡逾期
            ,allcreditcardusedamount -- 所有信用卡已使用额度
            ,updateorgid -- 更新机构
            ,customertype -- 客户类型
            ,newcreditloannum -- 新增信用贷款笔数
            ,remark2 -- 风险经理失效原因
            ,managerorgid -- 管户机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,guarantyforothersyq -- 对外担保是否逾期
            ,updateuserid -- 更新人
            ,customerid -- 客户编号
            ,objecttype -- 监测类型
            ,certtype -- 证件类型
            ,reportscope -- 报表口径
            ,newcreditloanbalance -- 新增信用贷款余额
            ,querytimesamonth -- 近一月征信查询次数
            ,allcreditcardamount -- 所有信用卡授信额度
            ,inputorgid -- 登记机构
            ,laststatusflag -- 最新状态标志
            ,relatingname -- 关联企业名称
            ,alertcontent -- 预警内容
            ,customername -- 客户名称
            ,relatingid -- 关联企业编号
            ,signname -- 信号名称
            ,manageruserid -- 管户人
            ,objectno -- 监测流水号
            ,remark1 -- 客户经理失效原因
            ,guarantyforothers -- 对外担保金额
            ,creditcardusedrate -- 信用卡使用率
            ,alertinfosource -- 预警信息来源
            ,updatedate -- 更新日期
            ,reportdate -- 报表日期
            ,rowsubject -- 报表科目
            ,submitriskmanager -- 风险经理编号
            ,duebillserialno -- 借据号
            ,status -- 状态标志
            ,remark3 -- 总经理室失效原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.remark4, o.remark4) as remark4 -- 客户经理生效原因
    ,nvl(n.submitriskorgid, o.submitriskorgid) as submitriskorgid -- 风险经理机构
    ,nvl(n.signlevel, o.signlevel) as signlevel -- 信号级别
    ,nvl(n.querydate, o.querydate) as querydate -- 征信查询日期
    ,nvl(n.effectflag, o.effectflag) as effectflag -- 生效/失效预警申请
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.remark, o.remark) as remark -- 原因
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.loanoverdate, o.loanoverdate) as loanoverdate -- 是否贷款逾期
    ,nvl(n.creditcardoverdate, o.creditcardoverdate) as creditcardoverdate -- 是否信用卡逾期
    ,nvl(n.allcreditcardusedamount, o.allcreditcardusedamount) as allcreditcardusedamount -- 所有信用卡已使用额度
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型
    ,nvl(n.newcreditloannum, o.newcreditloannum) as newcreditloannum -- 新增信用贷款笔数
    ,nvl(n.remark2, o.remark2) as remark2 -- 风险经理失效原因
    ,nvl(n.managerorgid, o.managerorgid) as managerorgid -- 管户机构
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.guarantyforothersyq, o.guarantyforothersyq) as guarantyforothersyq -- 对外担保是否逾期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 监测类型
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.reportscope, o.reportscope) as reportscope -- 报表口径
    ,nvl(n.newcreditloanbalance, o.newcreditloanbalance) as newcreditloanbalance -- 新增信用贷款余额
    ,nvl(n.querytimesamonth, o.querytimesamonth) as querytimesamonth -- 近一月征信查询次数
    ,nvl(n.allcreditcardamount, o.allcreditcardamount) as allcreditcardamount -- 所有信用卡授信额度
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.laststatusflag, o.laststatusflag) as laststatusflag -- 最新状态标志
    ,nvl(n.relatingname, o.relatingname) as relatingname -- 关联企业名称
    ,nvl(n.alertcontent, o.alertcontent) as alertcontent -- 预警内容
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.relatingid, o.relatingid) as relatingid -- 关联企业编号
    ,nvl(n.signname, o.signname) as signname -- 信号名称
    ,nvl(n.manageruserid, o.manageruserid) as manageruserid -- 管户人
    ,nvl(n.objectno, o.objectno) as objectno -- 监测流水号
    ,nvl(n.remark1, o.remark1) as remark1 -- 客户经理失效原因
    ,nvl(n.guarantyforothers, o.guarantyforothers) as guarantyforothers -- 对外担保金额
    ,nvl(n.creditcardusedrate, o.creditcardusedrate) as creditcardusedrate -- 信用卡使用率
    ,nvl(n.alertinfosource, o.alertinfosource) as alertinfosource -- 预警信息来源
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.reportdate, o.reportdate) as reportdate -- 报表日期
    ,nvl(n.rowsubject, o.rowsubject) as rowsubject -- 报表科目
    ,nvl(n.submitriskmanager, o.submitriskmanager) as submitriskmanager -- 风险经理编号
    ,nvl(n.duebillserialno, o.duebillserialno) as duebillserialno -- 借据号
    ,nvl(n.status, o.status) as status -- 状态标志
    ,nvl(n.remark3, o.remark3) as remark3 -- 总经理室失效原因
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
from (select * from ${iol_schema}.icms_remindalert_wastbook_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_remindalert_wastbook where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.remark4 <> n.remark4
        or o.submitriskorgid <> n.submitriskorgid
        or o.signlevel <> n.signlevel
        or o.querydate <> n.querydate
        or o.effectflag <> n.effectflag
        or o.inputdate <> n.inputdate
        or o.inputuserid <> n.inputuserid
        or o.remark <> n.remark
        or o.certid <> n.certid
        or o.loanoverdate <> n.loanoverdate
        or o.creditcardoverdate <> n.creditcardoverdate
        or o.allcreditcardusedamount <> n.allcreditcardusedamount
        or o.updateorgid <> n.updateorgid
        or o.customertype <> n.customertype
        or o.newcreditloannum <> n.newcreditloannum
        or o.remark2 <> n.remark2
        or o.managerorgid <> n.managerorgid
        or o.migtflag <> n.migtflag
        or o.guarantyforothersyq <> n.guarantyforothersyq
        or o.updateuserid <> n.updateuserid
        or o.customerid <> n.customerid
        or o.objecttype <> n.objecttype
        or o.certtype <> n.certtype
        or o.reportscope <> n.reportscope
        or o.newcreditloanbalance <> n.newcreditloanbalance
        or o.querytimesamonth <> n.querytimesamonth
        or o.allcreditcardamount <> n.allcreditcardamount
        or o.inputorgid <> n.inputorgid
        or o.laststatusflag <> n.laststatusflag
        or o.relatingname <> n.relatingname
        or o.alertcontent <> n.alertcontent
        or o.customername <> n.customername
        or o.relatingid <> n.relatingid
        or o.signname <> n.signname
        or o.manageruserid <> n.manageruserid
        or o.objectno <> n.objectno
        or o.remark1 <> n.remark1
        or o.guarantyforothers <> n.guarantyforothers
        or o.creditcardusedrate <> n.creditcardusedrate
        or o.alertinfosource <> n.alertinfosource
        or o.updatedate <> n.updatedate
        or o.reportdate <> n.reportdate
        or o.rowsubject <> n.rowsubject
        or o.submitriskmanager <> n.submitriskmanager
        or o.duebillserialno <> n.duebillserialno
        or o.status <> n.status
        or o.remark3 <> n.remark3
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_remindalert_wastbook_cl(
            serialno -- 流水号
            ,remark4 -- 客户经理生效原因
            ,submitriskorgid -- 风险经理机构
            ,signlevel -- 信号级别
            ,querydate -- 征信查询日期
            ,effectflag -- 生效/失效预警申请
            ,inputdate -- 登记时间
            ,inputuserid -- 登记人
            ,remark -- 原因
            ,certid -- 证件号码
            ,loanoverdate -- 是否贷款逾期
            ,creditcardoverdate -- 是否信用卡逾期
            ,allcreditcardusedamount -- 所有信用卡已使用额度
            ,updateorgid -- 更新机构
            ,customertype -- 客户类型
            ,newcreditloannum -- 新增信用贷款笔数
            ,remark2 -- 风险经理失效原因
            ,managerorgid -- 管户机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,guarantyforothersyq -- 对外担保是否逾期
            ,updateuserid -- 更新人
            ,customerid -- 客户编号
            ,objecttype -- 监测类型
            ,certtype -- 证件类型
            ,reportscope -- 报表口径
            ,newcreditloanbalance -- 新增信用贷款余额
            ,querytimesamonth -- 近一月征信查询次数
            ,allcreditcardamount -- 所有信用卡授信额度
            ,inputorgid -- 登记机构
            ,laststatusflag -- 最新状态标志
            ,relatingname -- 关联企业名称
            ,alertcontent -- 预警内容
            ,customername -- 客户名称
            ,relatingid -- 关联企业编号
            ,signname -- 信号名称
            ,manageruserid -- 管户人
            ,objectno -- 监测流水号
            ,remark1 -- 客户经理失效原因
            ,guarantyforothers -- 对外担保金额
            ,creditcardusedrate -- 信用卡使用率
            ,alertinfosource -- 预警信息来源
            ,updatedate -- 更新日期
            ,reportdate -- 报表日期
            ,rowsubject -- 报表科目
            ,submitriskmanager -- 风险经理编号
            ,duebillserialno -- 借据号
            ,status -- 状态标志
            ,remark3 -- 总经理室失效原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_remindalert_wastbook_op(
            serialno -- 流水号
            ,remark4 -- 客户经理生效原因
            ,submitriskorgid -- 风险经理机构
            ,signlevel -- 信号级别
            ,querydate -- 征信查询日期
            ,effectflag -- 生效/失效预警申请
            ,inputdate -- 登记时间
            ,inputuserid -- 登记人
            ,remark -- 原因
            ,certid -- 证件号码
            ,loanoverdate -- 是否贷款逾期
            ,creditcardoverdate -- 是否信用卡逾期
            ,allcreditcardusedamount -- 所有信用卡已使用额度
            ,updateorgid -- 更新机构
            ,customertype -- 客户类型
            ,newcreditloannum -- 新增信用贷款笔数
            ,remark2 -- 风险经理失效原因
            ,managerorgid -- 管户机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,guarantyforothersyq -- 对外担保是否逾期
            ,updateuserid -- 更新人
            ,customerid -- 客户编号
            ,objecttype -- 监测类型
            ,certtype -- 证件类型
            ,reportscope -- 报表口径
            ,newcreditloanbalance -- 新增信用贷款余额
            ,querytimesamonth -- 近一月征信查询次数
            ,allcreditcardamount -- 所有信用卡授信额度
            ,inputorgid -- 登记机构
            ,laststatusflag -- 最新状态标志
            ,relatingname -- 关联企业名称
            ,alertcontent -- 预警内容
            ,customername -- 客户名称
            ,relatingid -- 关联企业编号
            ,signname -- 信号名称
            ,manageruserid -- 管户人
            ,objectno -- 监测流水号
            ,remark1 -- 客户经理失效原因
            ,guarantyforothers -- 对外担保金额
            ,creditcardusedrate -- 信用卡使用率
            ,alertinfosource -- 预警信息来源
            ,updatedate -- 更新日期
            ,reportdate -- 报表日期
            ,rowsubject -- 报表科目
            ,submitriskmanager -- 风险经理编号
            ,duebillserialno -- 借据号
            ,status -- 状态标志
            ,remark3 -- 总经理室失效原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.remark4 -- 客户经理生效原因
    ,o.submitriskorgid -- 风险经理机构
    ,o.signlevel -- 信号级别
    ,o.querydate -- 征信查询日期
    ,o.effectflag -- 生效/失效预警申请
    ,o.inputdate -- 登记时间
    ,o.inputuserid -- 登记人
    ,o.remark -- 原因
    ,o.certid -- 证件号码
    ,o.loanoverdate -- 是否贷款逾期
    ,o.creditcardoverdate -- 是否信用卡逾期
    ,o.allcreditcardusedamount -- 所有信用卡已使用额度
    ,o.updateorgid -- 更新机构
    ,o.customertype -- 客户类型
    ,o.newcreditloannum -- 新增信用贷款笔数
    ,o.remark2 -- 风险经理失效原因
    ,o.managerorgid -- 管户机构
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.guarantyforothersyq -- 对外担保是否逾期
    ,o.updateuserid -- 更新人
    ,o.customerid -- 客户编号
    ,o.objecttype -- 监测类型
    ,o.certtype -- 证件类型
    ,o.reportscope -- 报表口径
    ,o.newcreditloanbalance -- 新增信用贷款余额
    ,o.querytimesamonth -- 近一月征信查询次数
    ,o.allcreditcardamount -- 所有信用卡授信额度
    ,o.inputorgid -- 登记机构
    ,o.laststatusflag -- 最新状态标志
    ,o.relatingname -- 关联企业名称
    ,o.alertcontent -- 预警内容
    ,o.customername -- 客户名称
    ,o.relatingid -- 关联企业编号
    ,o.signname -- 信号名称
    ,o.manageruserid -- 管户人
    ,o.objectno -- 监测流水号
    ,o.remark1 -- 客户经理失效原因
    ,o.guarantyforothers -- 对外担保金额
    ,o.creditcardusedrate -- 信用卡使用率
    ,o.alertinfosource -- 预警信息来源
    ,o.updatedate -- 更新日期
    ,o.reportdate -- 报表日期
    ,o.rowsubject -- 报表科目
    ,o.submitriskmanager -- 风险经理编号
    ,o.duebillserialno -- 借据号
    ,o.status -- 状态标志
    ,o.remark3 -- 总经理室失效原因
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
from ${iol_schema}.icms_remindalert_wastbook_bk o
    left join ${iol_schema}.icms_remindalert_wastbook_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_remindalert_wastbook_cl d
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
--truncate table ${iol_schema}.icms_remindalert_wastbook;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_remindalert_wastbook') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_remindalert_wastbook drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_remindalert_wastbook add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_remindalert_wastbook exchange partition p_${batch_date} with table ${iol_schema}.icms_remindalert_wastbook_cl;
alter table ${iol_schema}.icms_remindalert_wastbook exchange partition p_20991231 with table ${iol_schema}.icms_remindalert_wastbook_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_remindalert_wastbook to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_remindalert_wastbook_op purge;
drop table ${iol_schema}.icms_remindalert_wastbook_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_remindalert_wastbook_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_remindalert_wastbook',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
