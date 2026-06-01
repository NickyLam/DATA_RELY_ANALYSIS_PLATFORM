/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybkzd_credit_change_app
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
create table ${iol_schema}.icms_mybkzd_credit_change_app_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_mybkzd_credit_change_app
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybkzd_credit_change_app_op purge;
drop table ${iol_schema}.icms_mybkzd_credit_change_app_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzd_credit_change_app_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybkzd_credit_change_app where 0=1;

create table ${iol_schema}.icms_mybkzd_credit_change_app_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybkzd_credit_change_app where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybkzd_credit_change_app_cl(
            serialno -- 授信申请编号
            ,cusid -- 客户号
            ,cusname -- 客户名称
            ,certtype -- 证件类型
            ,certcode -- 证件号码
            ,csapplydate -- 初审日期
            ,zsapplydate -- 终审日期
            ,applyamount -- 原审批额度
            ,applydate -- 申请日期
            ,informdate -- 申请通知时间
            ,returndate -- 回调通知时间
            ,requestid -- 请求幂等ID
            ,applyno -- 联合审批单号
            ,custiproleid -- 会员角色ID
            ,businessmodel -- 业务模式
            ,changetype -- 调整类型（0代表关闭授信 1代表调整授信额度、定价）
            ,changecode -- 调整原因码
            ,changemsg -- 中文理由说明
            ,creditamt -- 银行建议的授信额度
            ,creditratelimit -- 银行建议的授信利率上限
            ,creditratebottom -- 银行建议的授信利率下限
            ,informflag -- 通知成功与否
            ,isagree -- 网商银行是否同意申请
            ,resultmsg -- 网商银行处理失败原因
            ,failreason -- 备注信息
            ,inputid -- 登记人
            ,inputbrid -- 登记机构
            ,sysid -- 处理业务系统ID
            ,approvestatus -- 审批状态
            ,loanar -- 业务场景
            ,applytime -- 申请时间
            ,closeflag -- 是否是缺少九要素关闭额度标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybkzd_credit_change_app_op(
            serialno -- 授信申请编号
            ,cusid -- 客户号
            ,cusname -- 客户名称
            ,certtype -- 证件类型
            ,certcode -- 证件号码
            ,csapplydate -- 初审日期
            ,zsapplydate -- 终审日期
            ,applyamount -- 原审批额度
            ,applydate -- 申请日期
            ,informdate -- 申请通知时间
            ,returndate -- 回调通知时间
            ,requestid -- 请求幂等ID
            ,applyno -- 联合审批单号
            ,custiproleid -- 会员角色ID
            ,businessmodel -- 业务模式
            ,changetype -- 调整类型（0代表关闭授信 1代表调整授信额度、定价）
            ,changecode -- 调整原因码
            ,changemsg -- 中文理由说明
            ,creditamt -- 银行建议的授信额度
            ,creditratelimit -- 银行建议的授信利率上限
            ,creditratebottom -- 银行建议的授信利率下限
            ,informflag -- 通知成功与否
            ,isagree -- 网商银行是否同意申请
            ,resultmsg -- 网商银行处理失败原因
            ,failreason -- 备注信息
            ,inputid -- 登记人
            ,inputbrid -- 登记机构
            ,sysid -- 处理业务系统ID
            ,approvestatus -- 审批状态
            ,loanar -- 业务场景
            ,applytime -- 申请时间
            ,closeflag -- 是否是缺少九要素关闭额度标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 授信申请编号
    ,nvl(n.cusid, o.cusid) as cusid -- 客户号
    ,nvl(n.cusname, o.cusname) as cusname -- 客户名称
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certcode, o.certcode) as certcode -- 证件号码
    ,nvl(n.csapplydate, o.csapplydate) as csapplydate -- 初审日期
    ,nvl(n.zsapplydate, o.zsapplydate) as zsapplydate -- 终审日期
    ,nvl(n.applyamount, o.applyamount) as applyamount -- 原审批额度
    ,nvl(n.applydate, o.applydate) as applydate -- 申请日期
    ,nvl(n.informdate, o.informdate) as informdate -- 申请通知时间
    ,nvl(n.returndate, o.returndate) as returndate -- 回调通知时间
    ,nvl(n.requestid, o.requestid) as requestid -- 请求幂等ID
    ,nvl(n.applyno, o.applyno) as applyno -- 联合审批单号
    ,nvl(n.custiproleid, o.custiproleid) as custiproleid -- 会员角色ID
    ,nvl(n.businessmodel, o.businessmodel) as businessmodel -- 业务模式
    ,nvl(n.changetype, o.changetype) as changetype -- 调整类型（0代表关闭授信 1代表调整授信额度、定价）
    ,nvl(n.changecode, o.changecode) as changecode -- 调整原因码
    ,nvl(n.changemsg, o.changemsg) as changemsg -- 中文理由说明
    ,nvl(n.creditamt, o.creditamt) as creditamt -- 银行建议的授信额度
    ,nvl(n.creditratelimit, o.creditratelimit) as creditratelimit -- 银行建议的授信利率上限
    ,nvl(n.creditratebottom, o.creditratebottom) as creditratebottom -- 银行建议的授信利率下限
    ,nvl(n.informflag, o.informflag) as informflag -- 通知成功与否
    ,nvl(n.isagree, o.isagree) as isagree -- 网商银行是否同意申请
    ,nvl(n.resultmsg, o.resultmsg) as resultmsg -- 网商银行处理失败原因
    ,nvl(n.failreason, o.failreason) as failreason -- 备注信息
    ,nvl(n.inputid, o.inputid) as inputid -- 登记人
    ,nvl(n.inputbrid, o.inputbrid) as inputbrid -- 登记机构
    ,nvl(n.sysid, o.sysid) as sysid -- 处理业务系统ID
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.loanar, o.loanar) as loanar -- 业务场景
    ,nvl(n.applytime, o.applytime) as applytime -- 申请时间
    ,nvl(n.closeflag, o.closeflag) as closeflag -- 是否是缺少九要素关闭额度标志
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
from (select * from ${iol_schema}.icms_mybkzd_credit_change_app_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_mybkzd_credit_change_app where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.cusid <> n.cusid
        or o.cusname <> n.cusname
        or o.certtype <> n.certtype
        or o.certcode <> n.certcode
        or o.csapplydate <> n.csapplydate
        or o.zsapplydate <> n.zsapplydate
        or o.applyamount <> n.applyamount
        or o.applydate <> n.applydate
        or o.informdate <> n.informdate
        or o.returndate <> n.returndate
        or o.requestid <> n.requestid
        or o.applyno <> n.applyno
        or o.custiproleid <> n.custiproleid
        or o.businessmodel <> n.businessmodel
        or o.changetype <> n.changetype
        or o.changecode <> n.changecode
        or o.changemsg <> n.changemsg
        or o.creditamt <> n.creditamt
        or o.creditratelimit <> n.creditratelimit
        or o.creditratebottom <> n.creditratebottom
        or o.informflag <> n.informflag
        or o.isagree <> n.isagree
        or o.resultmsg <> n.resultmsg
        or o.failreason <> n.failreason
        or o.inputid <> n.inputid
        or o.inputbrid <> n.inputbrid
        or o.sysid <> n.sysid
        or o.approvestatus <> n.approvestatus
        or o.loanar <> n.loanar
        or o.applytime <> n.applytime
        or o.closeflag <> n.closeflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybkzd_credit_change_app_cl(
            serialno -- 授信申请编号
            ,cusid -- 客户号
            ,cusname -- 客户名称
            ,certtype -- 证件类型
            ,certcode -- 证件号码
            ,csapplydate -- 初审日期
            ,zsapplydate -- 终审日期
            ,applyamount -- 原审批额度
            ,applydate -- 申请日期
            ,informdate -- 申请通知时间
            ,returndate -- 回调通知时间
            ,requestid -- 请求幂等ID
            ,applyno -- 联合审批单号
            ,custiproleid -- 会员角色ID
            ,businessmodel -- 业务模式
            ,changetype -- 调整类型（0代表关闭授信 1代表调整授信额度、定价）
            ,changecode -- 调整原因码
            ,changemsg -- 中文理由说明
            ,creditamt -- 银行建议的授信额度
            ,creditratelimit -- 银行建议的授信利率上限
            ,creditratebottom -- 银行建议的授信利率下限
            ,informflag -- 通知成功与否
            ,isagree -- 网商银行是否同意申请
            ,resultmsg -- 网商银行处理失败原因
            ,failreason -- 备注信息
            ,inputid -- 登记人
            ,inputbrid -- 登记机构
            ,sysid -- 处理业务系统ID
            ,approvestatus -- 审批状态
            ,loanar -- 业务场景
            ,applytime -- 申请时间
            ,closeflag -- 是否是缺少九要素关闭额度标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybkzd_credit_change_app_op(
            serialno -- 授信申请编号
            ,cusid -- 客户号
            ,cusname -- 客户名称
            ,certtype -- 证件类型
            ,certcode -- 证件号码
            ,csapplydate -- 初审日期
            ,zsapplydate -- 终审日期
            ,applyamount -- 原审批额度
            ,applydate -- 申请日期
            ,informdate -- 申请通知时间
            ,returndate -- 回调通知时间
            ,requestid -- 请求幂等ID
            ,applyno -- 联合审批单号
            ,custiproleid -- 会员角色ID
            ,businessmodel -- 业务模式
            ,changetype -- 调整类型（0代表关闭授信 1代表调整授信额度、定价）
            ,changecode -- 调整原因码
            ,changemsg -- 中文理由说明
            ,creditamt -- 银行建议的授信额度
            ,creditratelimit -- 银行建议的授信利率上限
            ,creditratebottom -- 银行建议的授信利率下限
            ,informflag -- 通知成功与否
            ,isagree -- 网商银行是否同意申请
            ,resultmsg -- 网商银行处理失败原因
            ,failreason -- 备注信息
            ,inputid -- 登记人
            ,inputbrid -- 登记机构
            ,sysid -- 处理业务系统ID
            ,approvestatus -- 审批状态
            ,loanar -- 业务场景
            ,applytime -- 申请时间
            ,closeflag -- 是否是缺少九要素关闭额度标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 授信申请编号
    ,o.cusid -- 客户号
    ,o.cusname -- 客户名称
    ,o.certtype -- 证件类型
    ,o.certcode -- 证件号码
    ,o.csapplydate -- 初审日期
    ,o.zsapplydate -- 终审日期
    ,o.applyamount -- 原审批额度
    ,o.applydate -- 申请日期
    ,o.informdate -- 申请通知时间
    ,o.returndate -- 回调通知时间
    ,o.requestid -- 请求幂等ID
    ,o.applyno -- 联合审批单号
    ,o.custiproleid -- 会员角色ID
    ,o.businessmodel -- 业务模式
    ,o.changetype -- 调整类型（0代表关闭授信 1代表调整授信额度、定价）
    ,o.changecode -- 调整原因码
    ,o.changemsg -- 中文理由说明
    ,o.creditamt -- 银行建议的授信额度
    ,o.creditratelimit -- 银行建议的授信利率上限
    ,o.creditratebottom -- 银行建议的授信利率下限
    ,o.informflag -- 通知成功与否
    ,o.isagree -- 网商银行是否同意申请
    ,o.resultmsg -- 网商银行处理失败原因
    ,o.failreason -- 备注信息
    ,o.inputid -- 登记人
    ,o.inputbrid -- 登记机构
    ,o.sysid -- 处理业务系统ID
    ,o.approvestatus -- 审批状态
    ,o.loanar -- 业务场景
    ,o.applytime -- 申请时间
    ,o.closeflag -- 是否是缺少九要素关闭额度标志
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
from ${iol_schema}.icms_mybkzd_credit_change_app_bk o
    left join ${iol_schema}.icms_mybkzd_credit_change_app_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_mybkzd_credit_change_app_cl d
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
--truncate table ${iol_schema}.icms_mybkzd_credit_change_app;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_mybkzd_credit_change_app') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_mybkzd_credit_change_app drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_mybkzd_credit_change_app add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_mybkzd_credit_change_app exchange partition p_${batch_date} with table ${iol_schema}.icms_mybkzd_credit_change_app_cl;
alter table ${iol_schema}.icms_mybkzd_credit_change_app exchange partition p_20991231 with table ${iol_schema}.icms_mybkzd_credit_change_app_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybkzd_credit_change_app to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybkzd_credit_change_app_op purge;
drop table ${iol_schema}.icms_mybkzd_credit_change_app_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_mybkzd_credit_change_app_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybkzd_credit_change_app',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
