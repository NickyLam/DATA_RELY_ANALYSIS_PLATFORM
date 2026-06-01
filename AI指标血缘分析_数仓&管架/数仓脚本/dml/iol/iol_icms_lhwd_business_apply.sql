/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lhwd_business_apply
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
create table ${iol_schema}.icms_lhwd_business_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_lhwd_business_apply
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lhwd_business_apply_op purge;
drop table ${iol_schema}.icms_lhwd_business_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_business_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lhwd_business_apply where 0=1;

create table ${iol_schema}.icms_lhwd_business_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lhwd_business_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lhwd_business_apply_cl(
            serialno -- 流水号
            ,usage -- 借款用途
            ,creditchannel -- 授信渠道
            ,applyno -- 全局流水号（第三方）
            ,businessmodel -- 业务模式（第三方）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,currency -- 币种
            ,businesssum -- 授信申请金额
            ,productid -- 产品编号（行内）
            ,productno -- 产品编号（第三方）
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,iscycle -- 循环标志
            ,vouchtype -- 担保方式
            ,nationalindustrytype -- 贷款投向行业
            ,loanusetype -- 贷款用途
            ,approvestatus -- 审批状态
            ,bankcontriratio -- 银行出资比例
            ,refusecode -- 拒绝错误码
            ,refusereason -- 拒绝原因描述
            ,acceptrisktime -- 接收风控返回时间（终审结束时间）
            ,manualapproval -- 转人工标识
            ,partnerapvrestflg -- 合作方审批结果
            ,apvstarttm -- 审批开始时间
            ,apvamt -- 我行授信金额
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lhwd_business_apply_op(
            serialno -- 流水号
            ,usage -- 借款用途
            ,creditchannel -- 授信渠道
            ,applyno -- 全局流水号（第三方）
            ,businessmodel -- 业务模式（第三方）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,currency -- 币种
            ,businesssum -- 授信申请金额
            ,productid -- 产品编号（行内）
            ,productno -- 产品编号（第三方）
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,iscycle -- 循环标志
            ,vouchtype -- 担保方式
            ,nationalindustrytype -- 贷款投向行业
            ,loanusetype -- 贷款用途
            ,approvestatus -- 审批状态
            ,bankcontriratio -- 银行出资比例
            ,refusecode -- 拒绝错误码
            ,refusereason -- 拒绝原因描述
            ,acceptrisktime -- 接收风控返回时间（终审结束时间）
            ,manualapproval -- 转人工标识
            ,partnerapvrestflg -- 合作方审批结果
            ,apvstarttm -- 审批开始时间
            ,apvamt -- 我行授信金额
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.usage, o.usage) as usage -- 借款用途
    ,nvl(n.creditchannel, o.creditchannel) as creditchannel -- 授信渠道
    ,nvl(n.applyno, o.applyno) as applyno -- 全局流水号（第三方）
    ,nvl(n.businessmodel, o.businessmodel) as businessmodel -- 业务模式（第三方）
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 授信申请金额
    ,nvl(n.productid, o.productid) as productid -- 产品编号（行内）
    ,nvl(n.productno, o.productno) as productno -- 产品编号（第三方）
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限(月)
    ,nvl(n.termday, o.termday) as termday -- 期限(天)
    ,nvl(n.iscycle, o.iscycle) as iscycle -- 循环标志
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 担保方式
    ,nvl(n.nationalindustrytype, o.nationalindustrytype) as nationalindustrytype -- 贷款投向行业
    ,nvl(n.loanusetype, o.loanusetype) as loanusetype -- 贷款用途
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.bankcontriratio, o.bankcontriratio) as bankcontriratio -- 银行出资比例
    ,nvl(n.refusecode, o.refusecode) as refusecode -- 拒绝错误码
    ,nvl(n.refusereason, o.refusereason) as refusereason -- 拒绝原因描述
    ,nvl(n.acceptrisktime, o.acceptrisktime) as acceptrisktime -- 接收风控返回时间（终审结束时间）
    ,nvl(n.manualapproval, o.manualapproval) as manualapproval -- 转人工标识
    ,nvl(n.partnerapvrestflg, o.partnerapvrestflg) as partnerapvrestflg -- 合作方审批结果
    ,nvl(n.apvstarttm, o.apvstarttm) as apvstarttm -- 审批开始时间
    ,nvl(n.apvamt, o.apvamt) as apvamt -- 我行授信金额
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
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
from (select * from ${iol_schema}.icms_lhwd_business_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_lhwd_business_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.usage <> n.usage
        or o.creditchannel <> n.creditchannel
        or o.applyno <> n.applyno
        or o.businessmodel <> n.businessmodel
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.currency <> n.currency
        or o.businesssum <> n.businesssum
        or o.productid <> n.productid
        or o.productno <> n.productno
        or o.termmonth <> n.termmonth
        or o.termday <> n.termday
        or o.iscycle <> n.iscycle
        or o.vouchtype <> n.vouchtype
        or o.nationalindustrytype <> n.nationalindustrytype
        or o.loanusetype <> n.loanusetype
        or o.approvestatus <> n.approvestatus
        or o.bankcontriratio <> n.bankcontriratio
        or o.refusecode <> n.refusecode
        or o.refusereason <> n.refusereason
        or o.acceptrisktime <> n.acceptrisktime
        or o.manualapproval <> n.manualapproval
        or o.partnerapvrestflg <> n.partnerapvrestflg
        or o.apvstarttm <> n.apvstarttm
        or o.apvamt <> n.apvamt
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lhwd_business_apply_cl(
            serialno -- 流水号
            ,usage -- 借款用途
            ,creditchannel -- 授信渠道
            ,applyno -- 全局流水号（第三方）
            ,businessmodel -- 业务模式（第三方）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,currency -- 币种
            ,businesssum -- 授信申请金额
            ,productid -- 产品编号（行内）
            ,productno -- 产品编号（第三方）
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,iscycle -- 循环标志
            ,vouchtype -- 担保方式
            ,nationalindustrytype -- 贷款投向行业
            ,loanusetype -- 贷款用途
            ,approvestatus -- 审批状态
            ,bankcontriratio -- 银行出资比例
            ,refusecode -- 拒绝错误码
            ,refusereason -- 拒绝原因描述
            ,acceptrisktime -- 接收风控返回时间（终审结束时间）
            ,manualapproval -- 转人工标识
            ,partnerapvrestflg -- 合作方审批结果
            ,apvstarttm -- 审批开始时间
            ,apvamt -- 我行授信金额
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lhwd_business_apply_op(
            serialno -- 流水号
            ,usage -- 借款用途
            ,creditchannel -- 授信渠道
            ,applyno -- 全局流水号（第三方）
            ,businessmodel -- 业务模式（第三方）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,currency -- 币种
            ,businesssum -- 授信申请金额
            ,productid -- 产品编号（行内）
            ,productno -- 产品编号（第三方）
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,iscycle -- 循环标志
            ,vouchtype -- 担保方式
            ,nationalindustrytype -- 贷款投向行业
            ,loanusetype -- 贷款用途
            ,approvestatus -- 审批状态
            ,bankcontriratio -- 银行出资比例
            ,refusecode -- 拒绝错误码
            ,refusereason -- 拒绝原因描述
            ,acceptrisktime -- 接收风控返回时间（终审结束时间）
            ,manualapproval -- 转人工标识
            ,partnerapvrestflg -- 合作方审批结果
            ,apvstarttm -- 审批开始时间
            ,apvamt -- 我行授信金额
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.usage -- 借款用途
    ,o.creditchannel -- 授信渠道
    ,o.applyno -- 全局流水号（第三方）
    ,o.businessmodel -- 业务模式（第三方）
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.currency -- 币种
    ,o.businesssum -- 授信申请金额
    ,o.productid -- 产品编号（行内）
    ,o.productno -- 产品编号（第三方）
    ,o.termmonth -- 期限(月)
    ,o.termday -- 期限(天)
    ,o.iscycle -- 循环标志
    ,o.vouchtype -- 担保方式
    ,o.nationalindustrytype -- 贷款投向行业
    ,o.loanusetype -- 贷款用途
    ,o.approvestatus -- 审批状态
    ,o.bankcontriratio -- 银行出资比例
    ,o.refusecode -- 拒绝错误码
    ,o.refusereason -- 拒绝原因描述
    ,o.acceptrisktime -- 接收风控返回时间（终审结束时间）
    ,o.manualapproval -- 转人工标识
    ,o.partnerapvrestflg -- 合作方审批结果
    ,o.apvstarttm -- 审批开始时间
    ,o.apvamt -- 我行授信金额
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记时间
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新时间
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
from ${iol_schema}.icms_lhwd_business_apply_bk o
    left join ${iol_schema}.icms_lhwd_business_apply_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_lhwd_business_apply_cl d
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
--truncate table ${iol_schema}.icms_lhwd_business_apply;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_lhwd_business_apply') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_lhwd_business_apply drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_lhwd_business_apply add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_lhwd_business_apply exchange partition p_${batch_date} with table ${iol_schema}.icms_lhwd_business_apply_cl;
alter table ${iol_schema}.icms_lhwd_business_apply exchange partition p_20991231 with table ${iol_schema}.icms_lhwd_business_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lhwd_business_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lhwd_business_apply_op purge;
drop table ${iol_schema}.icms_lhwd_business_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_lhwd_business_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lhwd_business_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
