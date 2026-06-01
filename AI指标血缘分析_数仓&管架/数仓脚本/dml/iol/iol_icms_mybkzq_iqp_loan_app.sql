/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybkzq_iqp_loan_app
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
create table ${iol_schema}.icms_mybkzq_iqp_loan_app_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_mybkzq_iqp_loan_app
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybkzq_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_mybkzq_iqp_loan_app_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzq_iqp_loan_app_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybkzq_iqp_loan_app where 0=1;

create table ${iol_schema}.icms_mybkzq_iqp_loan_app_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybkzq_iqp_loan_app where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybkzq_iqp_loan_app_cl(
            serialno -- 业务流水号
            ,applyno -- 蚂蚁申请单号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,applydate -- 申请日期
            ,certtype -- 证件类型
            ,certcode -- 证件号码
            ,cusname -- 客户姓名
            ,cusid -- 客户号
            ,platformaccess -- 网商贷审批结果
            ,businessmodel -- 业务模式
            ,csrequestid -- 初审幂等ID
            ,informcsflag -- 初审通知成功与否
            ,csapprovestatus -- 初审审批状态
            ,csappresult -- 初审审批结论
            ,csretry -- 初审重试次数
            ,zsrequestid -- 终审幂等ID
            ,informzsflag -- 终审通知成功与否
            ,zsadvicedate -- 终审通知时间
            ,zsrefusecode -- 终审审批错误码
            ,zsackmsg -- 终审审批结论
            ,zsretry -- 终审重试次数
            ,approvestatus -- 终审结束审批状态
            ,applytimes -- 申请次数（同一客户）
            ,openingflag -- 开户标识
            ,inputid -- 登记人
            ,inputorgid -- 登记机构
            ,applyamount -- 审批额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybkzq_iqp_loan_app_op(
            serialno -- 业务流水号
            ,applyno -- 蚂蚁申请单号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,applydate -- 申请日期
            ,certtype -- 证件类型
            ,certcode -- 证件号码
            ,cusname -- 客户姓名
            ,cusid -- 客户号
            ,platformaccess -- 网商贷审批结果
            ,businessmodel -- 业务模式
            ,csrequestid -- 初审幂等ID
            ,informcsflag -- 初审通知成功与否
            ,csapprovestatus -- 初审审批状态
            ,csappresult -- 初审审批结论
            ,csretry -- 初审重试次数
            ,zsrequestid -- 终审幂等ID
            ,informzsflag -- 终审通知成功与否
            ,zsadvicedate -- 终审通知时间
            ,zsrefusecode -- 终审审批错误码
            ,zsackmsg -- 终审审批结论
            ,zsretry -- 终审重试次数
            ,approvestatus -- 终审结束审批状态
            ,applytimes -- 申请次数（同一客户）
            ,openingflag -- 开户标识
            ,inputid -- 登记人
            ,inputorgid -- 登记机构
            ,applyamount -- 审批额度
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
    ,nvl(n.cusname, o.cusname) as cusname -- 客户姓名
    ,nvl(n.cusid, o.cusid) as cusid -- 客户号
    ,nvl(n.platformaccess, o.platformaccess) as platformaccess -- 网商贷审批结果
    ,nvl(n.businessmodel, o.businessmodel) as businessmodel -- 业务模式
    ,nvl(n.csrequestid, o.csrequestid) as csrequestid -- 初审幂等ID
    ,nvl(n.informcsflag, o.informcsflag) as informcsflag -- 初审通知成功与否
    ,nvl(n.csapprovestatus, o.csapprovestatus) as csapprovestatus -- 初审审批状态
    ,nvl(n.csappresult, o.csappresult) as csappresult -- 初审审批结论
    ,nvl(n.csretry, o.csretry) as csretry -- 初审重试次数
    ,nvl(n.zsrequestid, o.zsrequestid) as zsrequestid -- 终审幂等ID
    ,nvl(n.informzsflag, o.informzsflag) as informzsflag -- 终审通知成功与否
    ,nvl(n.zsadvicedate, o.zsadvicedate) as zsadvicedate -- 终审通知时间
    ,nvl(n.zsrefusecode, o.zsrefusecode) as zsrefusecode -- 终审审批错误码
    ,nvl(n.zsackmsg, o.zsackmsg) as zsackmsg -- 终审审批结论
    ,nvl(n.zsretry, o.zsretry) as zsretry -- 终审重试次数
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 终审结束审批状态
    ,nvl(n.applytimes, o.applytimes) as applytimes -- 申请次数（同一客户）
    ,nvl(n.openingflag, o.openingflag) as openingflag -- 开户标识
    ,nvl(n.inputid, o.inputid) as inputid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.applyamount, o.applyamount) as applyamount -- 审批额度
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
from (select * from ${iol_schema}.icms_mybkzq_iqp_loan_app_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_mybkzq_iqp_loan_app where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.businessmodel <> n.businessmodel
        or o.csrequestid <> n.csrequestid
        or o.informcsflag <> n.informcsflag
        or o.csapprovestatus <> n.csapprovestatus
        or o.csappresult <> n.csappresult
        or o.csretry <> n.csretry
        or o.zsrequestid <> n.zsrequestid
        or o.informzsflag <> n.informzsflag
        or o.zsadvicedate <> n.zsadvicedate
        or o.zsrefusecode <> n.zsrefusecode
        or o.zsackmsg <> n.zsackmsg
        or o.zsretry <> n.zsretry
        or o.approvestatus <> n.approvestatus
        or o.applytimes <> n.applytimes
        or o.openingflag <> n.openingflag
        or o.inputid <> n.inputid
        or o.inputorgid <> n.inputorgid
        or o.applyamount <> n.applyamount
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybkzq_iqp_loan_app_cl(
            serialno -- 业务流水号
            ,applyno -- 蚂蚁申请单号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,applydate -- 申请日期
            ,certtype -- 证件类型
            ,certcode -- 证件号码
            ,cusname -- 客户姓名
            ,cusid -- 客户号
            ,platformaccess -- 网商贷审批结果
            ,businessmodel -- 业务模式
            ,csrequestid -- 初审幂等ID
            ,informcsflag -- 初审通知成功与否
            ,csapprovestatus -- 初审审批状态
            ,csappresult -- 初审审批结论
            ,csretry -- 初审重试次数
            ,zsrequestid -- 终审幂等ID
            ,informzsflag -- 终审通知成功与否
            ,zsadvicedate -- 终审通知时间
            ,zsrefusecode -- 终审审批错误码
            ,zsackmsg -- 终审审批结论
            ,zsretry -- 终审重试次数
            ,approvestatus -- 终审结束审批状态
            ,applytimes -- 申请次数（同一客户）
            ,openingflag -- 开户标识
            ,inputid -- 登记人
            ,inputorgid -- 登记机构
            ,applyamount -- 审批额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybkzq_iqp_loan_app_op(
            serialno -- 业务流水号
            ,applyno -- 蚂蚁申请单号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,applydate -- 申请日期
            ,certtype -- 证件类型
            ,certcode -- 证件号码
            ,cusname -- 客户姓名
            ,cusid -- 客户号
            ,platformaccess -- 网商贷审批结果
            ,businessmodel -- 业务模式
            ,csrequestid -- 初审幂等ID
            ,informcsflag -- 初审通知成功与否
            ,csapprovestatus -- 初审审批状态
            ,csappresult -- 初审审批结论
            ,csretry -- 初审重试次数
            ,zsrequestid -- 终审幂等ID
            ,informzsflag -- 终审通知成功与否
            ,zsadvicedate -- 终审通知时间
            ,zsrefusecode -- 终审审批错误码
            ,zsackmsg -- 终审审批结论
            ,zsretry -- 终审重试次数
            ,approvestatus -- 终审结束审批状态
            ,applytimes -- 申请次数（同一客户）
            ,openingflag -- 开户标识
            ,inputid -- 登记人
            ,inputorgid -- 登记机构
            ,applyamount -- 审批额度
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
    ,o.cusname -- 客户姓名
    ,o.cusid -- 客户号
    ,o.platformaccess -- 网商贷审批结果
    ,o.businessmodel -- 业务模式
    ,o.csrequestid -- 初审幂等ID
    ,o.informcsflag -- 初审通知成功与否
    ,o.csapprovestatus -- 初审审批状态
    ,o.csappresult -- 初审审批结论
    ,o.csretry -- 初审重试次数
    ,o.zsrequestid -- 终审幂等ID
    ,o.informzsflag -- 终审通知成功与否
    ,o.zsadvicedate -- 终审通知时间
    ,o.zsrefusecode -- 终审审批错误码
    ,o.zsackmsg -- 终审审批结论
    ,o.zsretry -- 终审重试次数
    ,o.approvestatus -- 终审结束审批状态
    ,o.applytimes -- 申请次数（同一客户）
    ,o.openingflag -- 开户标识
    ,o.inputid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.applyamount -- 审批额度
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
from ${iol_schema}.icms_mybkzq_iqp_loan_app_bk o
    left join ${iol_schema}.icms_mybkzq_iqp_loan_app_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_mybkzq_iqp_loan_app_cl d
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
--truncate table ${iol_schema}.icms_mybkzq_iqp_loan_app;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_mybkzq_iqp_loan_app') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_mybkzq_iqp_loan_app drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_mybkzq_iqp_loan_app add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_mybkzq_iqp_loan_app exchange partition p_${batch_date} with table ${iol_schema}.icms_mybkzq_iqp_loan_app_cl;
alter table ${iol_schema}.icms_mybkzq_iqp_loan_app exchange partition p_20991231 with table ${iol_schema}.icms_mybkzq_iqp_loan_app_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybkzq_iqp_loan_app to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybkzq_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_mybkzq_iqp_loan_app_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_mybkzq_iqp_loan_app_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybkzq_iqp_loan_app',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
