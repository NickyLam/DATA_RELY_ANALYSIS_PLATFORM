/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_dzhx_approve
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
create table ${iol_schema}.icms_dzhx_approve_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_dzhx_approve
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_dzhx_approve_op purge;
drop table ${iol_schema}.icms_dzhx_approve_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_dzhx_approve_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_dzhx_approve where 0=1;

create table ${iol_schema}.icms_dzhx_approve_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_dzhx_approve where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_dzhx_approve_cl(
            customerid -- 客户编号
            ,customername -- 客户名称
            ,attribute2 -- 内部户
            ,remark1 -- 对借款人（或股权）追偿情况及结果
            ,mainrepresent -- 借款人法定代表人
            ,violateserialno -- 借款人被判触犯刑律文号
            ,otherserialno -- 其他部门证明文号
            ,attribute1 -- 诉讼费（汇总）
            ,inputorgid -- 登记机构
            ,hxoutinterest -- 核销表外利息
            ,cancellicensedate -- 工商部门注销（或吊销）借款人营业执照时间
            ,updateuserid -- 更新人
            ,remark2 -- 对保证人、抵押/质押物追偿情况及结果
            ,inputdate -- 登记时间
            ,certtype -- 证件类型
            ,hxmoney -- 核销本金（汇总）
            ,remark3 -- 责任人认定及责任人处理结果
            ,ifsearch -- 是否保留对债务人的追索权
            ,imputorgid -- 登记机构
            ,migtflag -- 
            ,certid -- 证件号码
            ,entproperty -- 企业性质
            ,courtdecisiondate -- 法院最终裁定时间
            ,inputuserid -- 登记人
            ,courtdecisionserialno -- 法院最终裁定文号
            ,hxininterest -- 核销表内利息
            ,updatedate -- 更新时间
            ,otherdate -- 其他部门证明时间
            ,approvehxdate -- 审批核销时间
            ,approvehxsum -- 核销金额（审批通过）
            ,remark -- 呆账形成原因
            ,industry -- 所属行业
            ,violatedate -- 借款人被判触犯刑律时间
            ,hxtype -- 核销类型
            ,updateorgid -- 更新机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_dzhx_approve_op(
            customerid -- 客户编号
            ,customername -- 客户名称
            ,attribute2 -- 内部户
            ,remark1 -- 对借款人（或股权）追偿情况及结果
            ,mainrepresent -- 借款人法定代表人
            ,violateserialno -- 借款人被判触犯刑律文号
            ,otherserialno -- 其他部门证明文号
            ,attribute1 -- 诉讼费（汇总）
            ,inputorgid -- 登记机构
            ,hxoutinterest -- 核销表外利息
            ,cancellicensedate -- 工商部门注销（或吊销）借款人营业执照时间
            ,updateuserid -- 更新人
            ,remark2 -- 对保证人、抵押/质押物追偿情况及结果
            ,inputdate -- 登记时间
            ,certtype -- 证件类型
            ,hxmoney -- 核销本金（汇总）
            ,remark3 -- 责任人认定及责任人处理结果
            ,ifsearch -- 是否保留对债务人的追索权
            ,imputorgid -- 登记机构
            ,migtflag -- 
            ,certid -- 证件号码
            ,entproperty -- 企业性质
            ,courtdecisiondate -- 法院最终裁定时间
            ,inputuserid -- 登记人
            ,courtdecisionserialno -- 法院最终裁定文号
            ,hxininterest -- 核销表内利息
            ,updatedate -- 更新时间
            ,otherdate -- 其他部门证明时间
            ,approvehxdate -- 审批核销时间
            ,approvehxsum -- 核销金额（审批通过）
            ,remark -- 呆账形成原因
            ,industry -- 所属行业
            ,violatedate -- 借款人被判触犯刑律时间
            ,hxtype -- 核销类型
            ,updateorgid -- 更新机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 内部户
    ,nvl(n.remark1, o.remark1) as remark1 -- 对借款人（或股权）追偿情况及结果
    ,nvl(n.mainrepresent, o.mainrepresent) as mainrepresent -- 借款人法定代表人
    ,nvl(n.violateserialno, o.violateserialno) as violateserialno -- 借款人被判触犯刑律文号
    ,nvl(n.otherserialno, o.otherserialno) as otherserialno -- 其他部门证明文号
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 诉讼费（汇总）
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.hxoutinterest, o.hxoutinterest) as hxoutinterest -- 核销表外利息
    ,nvl(n.cancellicensedate, o.cancellicensedate) as cancellicensedate -- 工商部门注销（或吊销）借款人营业执照时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.remark2, o.remark2) as remark2 -- 对保证人、抵押/质押物追偿情况及结果
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.hxmoney, o.hxmoney) as hxmoney -- 核销本金（汇总）
    ,nvl(n.remark3, o.remark3) as remark3 -- 责任人认定及责任人处理结果
    ,nvl(n.ifsearch, o.ifsearch) as ifsearch -- 是否保留对债务人的追索权
    ,nvl(n.imputorgid, o.imputorgid) as imputorgid -- 登记机构
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.entproperty, o.entproperty) as entproperty -- 企业性质
    ,nvl(n.courtdecisiondate, o.courtdecisiondate) as courtdecisiondate -- 法院最终裁定时间
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.courtdecisionserialno, o.courtdecisionserialno) as courtdecisionserialno -- 法院最终裁定文号
    ,nvl(n.hxininterest, o.hxininterest) as hxininterest -- 核销表内利息
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.otherdate, o.otherdate) as otherdate -- 其他部门证明时间
    ,nvl(n.approvehxdate, o.approvehxdate) as approvehxdate -- 审批核销时间
    ,nvl(n.approvehxsum, o.approvehxsum) as approvehxsum -- 核销金额（审批通过）
    ,nvl(n.remark, o.remark) as remark -- 呆账形成原因
    ,nvl(n.industry, o.industry) as industry -- 所属行业
    ,nvl(n.violatedate, o.violatedate) as violatedate -- 借款人被判触犯刑律时间
    ,nvl(n.hxtype, o.hxtype) as hxtype -- 核销类型
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,case when
            n.customerid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.customerid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.customerid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_dzhx_approve_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_dzhx_approve where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.customerid = n.customerid
where (
        o.customerid is null
    )
    or (
        n.customerid is null
    )
    or (
        o.customername <> n.customername
        or o.attribute2 <> n.attribute2
        or o.remark1 <> n.remark1
        or o.mainrepresent <> n.mainrepresent
        or o.violateserialno <> n.violateserialno
        or o.otherserialno <> n.otherserialno
        or o.attribute1 <> n.attribute1
        or o.inputorgid <> n.inputorgid
        or o.hxoutinterest <> n.hxoutinterest
        or o.cancellicensedate <> n.cancellicensedate
        or o.updateuserid <> n.updateuserid
        or o.remark2 <> n.remark2
        or o.inputdate <> n.inputdate
        or o.certtype <> n.certtype
        or o.hxmoney <> n.hxmoney
        or o.remark3 <> n.remark3
        or o.ifsearch <> n.ifsearch
        or o.imputorgid <> n.imputorgid
        or o.migtflag <> n.migtflag
        or o.certid <> n.certid
        or o.entproperty <> n.entproperty
        or o.courtdecisiondate <> n.courtdecisiondate
        or o.inputuserid <> n.inputuserid
        or o.courtdecisionserialno <> n.courtdecisionserialno
        or o.hxininterest <> n.hxininterest
        or o.updatedate <> n.updatedate
        or o.otherdate <> n.otherdate
        or o.approvehxdate <> n.approvehxdate
        or o.approvehxsum <> n.approvehxsum
        or o.remark <> n.remark
        or o.industry <> n.industry
        or o.violatedate <> n.violatedate
        or o.hxtype <> n.hxtype
        or o.updateorgid <> n.updateorgid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_dzhx_approve_cl(
            customerid -- 客户编号
            ,customername -- 客户名称
            ,attribute2 -- 内部户
            ,remark1 -- 对借款人（或股权）追偿情况及结果
            ,mainrepresent -- 借款人法定代表人
            ,violateserialno -- 借款人被判触犯刑律文号
            ,otherserialno -- 其他部门证明文号
            ,attribute1 -- 诉讼费（汇总）
            ,inputorgid -- 登记机构
            ,hxoutinterest -- 核销表外利息
            ,cancellicensedate -- 工商部门注销（或吊销）借款人营业执照时间
            ,updateuserid -- 更新人
            ,remark2 -- 对保证人、抵押/质押物追偿情况及结果
            ,inputdate -- 登记时间
            ,certtype -- 证件类型
            ,hxmoney -- 核销本金（汇总）
            ,remark3 -- 责任人认定及责任人处理结果
            ,ifsearch -- 是否保留对债务人的追索权
            ,imputorgid -- 登记机构
            ,migtflag -- 
            ,certid -- 证件号码
            ,entproperty -- 企业性质
            ,courtdecisiondate -- 法院最终裁定时间
            ,inputuserid -- 登记人
            ,courtdecisionserialno -- 法院最终裁定文号
            ,hxininterest -- 核销表内利息
            ,updatedate -- 更新时间
            ,otherdate -- 其他部门证明时间
            ,approvehxdate -- 审批核销时间
            ,approvehxsum -- 核销金额（审批通过）
            ,remark -- 呆账形成原因
            ,industry -- 所属行业
            ,violatedate -- 借款人被判触犯刑律时间
            ,hxtype -- 核销类型
            ,updateorgid -- 更新机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_dzhx_approve_op(
            customerid -- 客户编号
            ,customername -- 客户名称
            ,attribute2 -- 内部户
            ,remark1 -- 对借款人（或股权）追偿情况及结果
            ,mainrepresent -- 借款人法定代表人
            ,violateserialno -- 借款人被判触犯刑律文号
            ,otherserialno -- 其他部门证明文号
            ,attribute1 -- 诉讼费（汇总）
            ,inputorgid -- 登记机构
            ,hxoutinterest -- 核销表外利息
            ,cancellicensedate -- 工商部门注销（或吊销）借款人营业执照时间
            ,updateuserid -- 更新人
            ,remark2 -- 对保证人、抵押/质押物追偿情况及结果
            ,inputdate -- 登记时间
            ,certtype -- 证件类型
            ,hxmoney -- 核销本金（汇总）
            ,remark3 -- 责任人认定及责任人处理结果
            ,ifsearch -- 是否保留对债务人的追索权
            ,imputorgid -- 登记机构
            ,migtflag -- 
            ,certid -- 证件号码
            ,entproperty -- 企业性质
            ,courtdecisiondate -- 法院最终裁定时间
            ,inputuserid -- 登记人
            ,courtdecisionserialno -- 法院最终裁定文号
            ,hxininterest -- 核销表内利息
            ,updatedate -- 更新时间
            ,otherdate -- 其他部门证明时间
            ,approvehxdate -- 审批核销时间
            ,approvehxsum -- 核销金额（审批通过）
            ,remark -- 呆账形成原因
            ,industry -- 所属行业
            ,violatedate -- 借款人被判触犯刑律时间
            ,hxtype -- 核销类型
            ,updateorgid -- 更新机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.attribute2 -- 内部户
    ,o.remark1 -- 对借款人（或股权）追偿情况及结果
    ,o.mainrepresent -- 借款人法定代表人
    ,o.violateserialno -- 借款人被判触犯刑律文号
    ,o.otherserialno -- 其他部门证明文号
    ,o.attribute1 -- 诉讼费（汇总）
    ,o.inputorgid -- 登记机构
    ,o.hxoutinterest -- 核销表外利息
    ,o.cancellicensedate -- 工商部门注销（或吊销）借款人营业执照时间
    ,o.updateuserid -- 更新人
    ,o.remark2 -- 对保证人、抵押/质押物追偿情况及结果
    ,o.inputdate -- 登记时间
    ,o.certtype -- 证件类型
    ,o.hxmoney -- 核销本金（汇总）
    ,o.remark3 -- 责任人认定及责任人处理结果
    ,o.ifsearch -- 是否保留对债务人的追索权
    ,o.imputorgid -- 登记机构
    ,o.migtflag -- 
    ,o.certid -- 证件号码
    ,o.entproperty -- 企业性质
    ,o.courtdecisiondate -- 法院最终裁定时间
    ,o.inputuserid -- 登记人
    ,o.courtdecisionserialno -- 法院最终裁定文号
    ,o.hxininterest -- 核销表内利息
    ,o.updatedate -- 更新时间
    ,o.otherdate -- 其他部门证明时间
    ,o.approvehxdate -- 审批核销时间
    ,o.approvehxsum -- 核销金额（审批通过）
    ,o.remark -- 呆账形成原因
    ,o.industry -- 所属行业
    ,o.violatedate -- 借款人被判触犯刑律时间
    ,o.hxtype -- 核销类型
    ,o.updateorgid -- 更新机构
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
from ${iol_schema}.icms_dzhx_approve_bk o
    left join ${iol_schema}.icms_dzhx_approve_op n
        on
            o.customerid = n.customerid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_dzhx_approve_cl d
        on
            o.customerid = d.customerid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_dzhx_approve;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_dzhx_approve') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_dzhx_approve drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_dzhx_approve add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_dzhx_approve exchange partition p_${batch_date} with table ${iol_schema}.icms_dzhx_approve_cl;
alter table ${iol_schema}.icms_dzhx_approve exchange partition p_20991231 with table ${iol_schema}.icms_dzhx_approve_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_dzhx_approve to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_dzhx_approve_op purge;
drop table ${iol_schema}.icms_dzhx_approve_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_dzhx_approve_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_dzhx_approve',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
