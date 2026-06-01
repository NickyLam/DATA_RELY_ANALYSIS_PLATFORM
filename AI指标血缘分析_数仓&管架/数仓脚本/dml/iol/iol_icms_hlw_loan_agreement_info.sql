/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_hlw_loan_agreement_info
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
create table ${iol_schema}.icms_hlw_loan_agreement_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_hlw_loan_agreement_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_hlw_loan_agreement_info_op purge;
drop table ${iol_schema}.icms_hlw_loan_agreement_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_hlw_loan_agreement_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_hlw_loan_agreement_info where 0=1;

create table ${iol_schema}.icms_hlw_loan_agreement_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_hlw_loan_agreement_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_hlw_loan_agreement_info_cl(
            serialno -- 流水号
            ,productid -- 产品编号
            ,productname -- 产品名称
            ,belongorgid -- 所属机构
            ,agreementno -- 合作协议编号
            ,ismainagreement -- 是否属于主协议
            ,mainagreementno -- 对应的主合作协议编号
            ,cooperatename -- 合作方名称
            ,cooperatecerttype -- 合作方证件类型
            ,cooperatecertid -- 合作方证件号码
            ,cooperatetype -- 合作方类型
            ,cooperatemethod -- 合作方式
            ,providecreditmodel -- 提供增信的模式
            ,cooperateregisteraddress -- 合作方注册地行政区划
            ,startdate -- 合作协议起始日期
            ,maturitydate -- 合作协议到期日期
            ,actualmaturitydate -- 合作协议实际终止日期
            ,limitflag -- 限制标识
            ,cooperatestatus -- 协议状态
            ,operationtype -- 数据操作类型:01-新增02-编辑
            ,oldserialno -- 原数据流水号
            ,datastatus -- 数据状态：01-启用；02-停用
            ,approvestatus -- 流程状态
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,investmentprop -- 对我行出资部分进行担保的比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_hlw_loan_agreement_info_op(
            serialno -- 流水号
            ,productid -- 产品编号
            ,productname -- 产品名称
            ,belongorgid -- 所属机构
            ,agreementno -- 合作协议编号
            ,ismainagreement -- 是否属于主协议
            ,mainagreementno -- 对应的主合作协议编号
            ,cooperatename -- 合作方名称
            ,cooperatecerttype -- 合作方证件类型
            ,cooperatecertid -- 合作方证件号码
            ,cooperatetype -- 合作方类型
            ,cooperatemethod -- 合作方式
            ,providecreditmodel -- 提供增信的模式
            ,cooperateregisteraddress -- 合作方注册地行政区划
            ,startdate -- 合作协议起始日期
            ,maturitydate -- 合作协议到期日期
            ,actualmaturitydate -- 合作协议实际终止日期
            ,limitflag -- 限制标识
            ,cooperatestatus -- 协议状态
            ,operationtype -- 数据操作类型:01-新增02-编辑
            ,oldserialno -- 原数据流水号
            ,datastatus -- 数据状态：01-启用；02-停用
            ,approvestatus -- 流程状态
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,investmentprop -- 对我行出资部分进行担保的比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.productname, o.productname) as productname -- 产品名称
    ,nvl(n.belongorgid, o.belongorgid) as belongorgid -- 所属机构
    ,nvl(n.agreementno, o.agreementno) as agreementno -- 合作协议编号
    ,nvl(n.ismainagreement, o.ismainagreement) as ismainagreement -- 是否属于主协议
    ,nvl(n.mainagreementno, o.mainagreementno) as mainagreementno -- 对应的主合作协议编号
    ,nvl(n.cooperatename, o.cooperatename) as cooperatename -- 合作方名称
    ,nvl(n.cooperatecerttype, o.cooperatecerttype) as cooperatecerttype -- 合作方证件类型
    ,nvl(n.cooperatecertid, o.cooperatecertid) as cooperatecertid -- 合作方证件号码
    ,nvl(n.cooperatetype, o.cooperatetype) as cooperatetype -- 合作方类型
    ,nvl(n.cooperatemethod, o.cooperatemethod) as cooperatemethod -- 合作方式
    ,nvl(n.providecreditmodel, o.providecreditmodel) as providecreditmodel -- 提供增信的模式
    ,nvl(n.cooperateregisteraddress, o.cooperateregisteraddress) as cooperateregisteraddress -- 合作方注册地行政区划
    ,nvl(n.startdate, o.startdate) as startdate -- 合作协议起始日期
    ,nvl(n.maturitydate, o.maturitydate) as maturitydate -- 合作协议到期日期
    ,nvl(n.actualmaturitydate, o.actualmaturitydate) as actualmaturitydate -- 合作协议实际终止日期
    ,nvl(n.limitflag, o.limitflag) as limitflag -- 限制标识
    ,nvl(n.cooperatestatus, o.cooperatestatus) as cooperatestatus -- 协议状态
    ,nvl(n.operationtype, o.operationtype) as operationtype -- 数据操作类型:01-新增02-编辑
    ,nvl(n.oldserialno, o.oldserialno) as oldserialno -- 原数据流水号
    ,nvl(n.datastatus, o.datastatus) as datastatus -- 数据状态：01-启用；02-停用
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 流程状态
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.investmentprop, o.investmentprop) as investmentprop -- 对我行出资部分进行担保的比例
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
from (select * from ${iol_schema}.icms_hlw_loan_agreement_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_hlw_loan_agreement_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.productid <> n.productid
        or o.productname <> n.productname
        or o.belongorgid <> n.belongorgid
        or o.agreementno <> n.agreementno
        or o.ismainagreement <> n.ismainagreement
        or o.mainagreementno <> n.mainagreementno
        or o.cooperatename <> n.cooperatename
        or o.cooperatecerttype <> n.cooperatecerttype
        or o.cooperatecertid <> n.cooperatecertid
        or o.cooperatetype <> n.cooperatetype
        or o.cooperatemethod <> n.cooperatemethod
        or o.providecreditmodel <> n.providecreditmodel
        or o.cooperateregisteraddress <> n.cooperateregisteraddress
        or o.startdate <> n.startdate
        or o.maturitydate <> n.maturitydate
        or o.actualmaturitydate <> n.actualmaturitydate
        or o.limitflag <> n.limitflag
        or o.cooperatestatus <> n.cooperatestatus
        or o.operationtype <> n.operationtype
        or o.oldserialno <> n.oldserialno
        or o.datastatus <> n.datastatus
        or o.approvestatus <> n.approvestatus
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.investmentprop <> n.investmentprop
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_hlw_loan_agreement_info_cl(
            serialno -- 流水号
            ,productid -- 产品编号
            ,productname -- 产品名称
            ,belongorgid -- 所属机构
            ,agreementno -- 合作协议编号
            ,ismainagreement -- 是否属于主协议
            ,mainagreementno -- 对应的主合作协议编号
            ,cooperatename -- 合作方名称
            ,cooperatecerttype -- 合作方证件类型
            ,cooperatecertid -- 合作方证件号码
            ,cooperatetype -- 合作方类型
            ,cooperatemethod -- 合作方式
            ,providecreditmodel -- 提供增信的模式
            ,cooperateregisteraddress -- 合作方注册地行政区划
            ,startdate -- 合作协议起始日期
            ,maturitydate -- 合作协议到期日期
            ,actualmaturitydate -- 合作协议实际终止日期
            ,limitflag -- 限制标识
            ,cooperatestatus -- 协议状态
            ,operationtype -- 数据操作类型:01-新增02-编辑
            ,oldserialno -- 原数据流水号
            ,datastatus -- 数据状态：01-启用；02-停用
            ,approvestatus -- 流程状态
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,investmentprop -- 对我行出资部分进行担保的比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_hlw_loan_agreement_info_op(
            serialno -- 流水号
            ,productid -- 产品编号
            ,productname -- 产品名称
            ,belongorgid -- 所属机构
            ,agreementno -- 合作协议编号
            ,ismainagreement -- 是否属于主协议
            ,mainagreementno -- 对应的主合作协议编号
            ,cooperatename -- 合作方名称
            ,cooperatecerttype -- 合作方证件类型
            ,cooperatecertid -- 合作方证件号码
            ,cooperatetype -- 合作方类型
            ,cooperatemethod -- 合作方式
            ,providecreditmodel -- 提供增信的模式
            ,cooperateregisteraddress -- 合作方注册地行政区划
            ,startdate -- 合作协议起始日期
            ,maturitydate -- 合作协议到期日期
            ,actualmaturitydate -- 合作协议实际终止日期
            ,limitflag -- 限制标识
            ,cooperatestatus -- 协议状态
            ,operationtype -- 数据操作类型:01-新增02-编辑
            ,oldserialno -- 原数据流水号
            ,datastatus -- 数据状态：01-启用；02-停用
            ,approvestatus -- 流程状态
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,investmentprop -- 对我行出资部分进行担保的比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.productid -- 产品编号
    ,o.productname -- 产品名称
    ,o.belongorgid -- 所属机构
    ,o.agreementno -- 合作协议编号
    ,o.ismainagreement -- 是否属于主协议
    ,o.mainagreementno -- 对应的主合作协议编号
    ,o.cooperatename -- 合作方名称
    ,o.cooperatecerttype -- 合作方证件类型
    ,o.cooperatecertid -- 合作方证件号码
    ,o.cooperatetype -- 合作方类型
    ,o.cooperatemethod -- 合作方式
    ,o.providecreditmodel -- 提供增信的模式
    ,o.cooperateregisteraddress -- 合作方注册地行政区划
    ,o.startdate -- 合作协议起始日期
    ,o.maturitydate -- 合作协议到期日期
    ,o.actualmaturitydate -- 合作协议实际终止日期
    ,o.limitflag -- 限制标识
    ,o.cooperatestatus -- 协议状态
    ,o.operationtype -- 数据操作类型:01-新增02-编辑
    ,o.oldserialno -- 原数据流水号
    ,o.datastatus -- 数据状态：01-启用；02-停用
    ,o.approvestatus -- 流程状态
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记时间
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新时间
    ,o.investmentprop -- 对我行出资部分进行担保的比例
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
from ${iol_schema}.icms_hlw_loan_agreement_info_bk o
    left join ${iol_schema}.icms_hlw_loan_agreement_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_hlw_loan_agreement_info_cl d
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
--truncate table ${iol_schema}.icms_hlw_loan_agreement_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_hlw_loan_agreement_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_hlw_loan_agreement_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_hlw_loan_agreement_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_hlw_loan_agreement_info exchange partition p_${batch_date} with table ${iol_schema}.icms_hlw_loan_agreement_info_cl;
alter table ${iol_schema}.icms_hlw_loan_agreement_info exchange partition p_20991231 with table ${iol_schema}.icms_hlw_loan_agreement_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_hlw_loan_agreement_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_hlw_loan_agreement_info_op purge;
drop table ${iol_schema}.icms_hlw_loan_agreement_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_hlw_loan_agreement_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_hlw_loan_agreement_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
