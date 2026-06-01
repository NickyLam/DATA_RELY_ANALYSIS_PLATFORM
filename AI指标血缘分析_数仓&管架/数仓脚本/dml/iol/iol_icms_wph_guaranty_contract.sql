/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wph_guaranty_contract
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
create table ${iol_schema}.icms_wph_guaranty_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wph_guaranty_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wph_guaranty_contract_op purge;
drop table ${iol_schema}.icms_wph_guaranty_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_guaranty_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wph_guaranty_contract where 0=1;

create table ${iol_schema}.icms_wph_guaranty_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wph_guaranty_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wph_guaranty_contract_cl(
            guarantyno -- 担保合同编号
            ,guarantytype -- 担保合同类型
            ,guarantystyle -- 担保方式
            ,guarantystatus -- 担保合同状态
            ,signdate -- 协议签定日期
            ,begindate -- 合同生效日
            ,enddate -- 合同到期日
            ,customerid -- 被担保人客户号
            ,guarantorid -- 担保人编号
            ,guarantorname -- 担保人名称
            ,guarantycurrency -- 担保币种
            ,guarantyvalue -- 担保总金额
            ,guarantyinfo -- 担保物概况
            ,otherdescsribe -- 其它特别约定
            ,guarantyopinion -- 担保意见
            ,certtype -- 担保人证件类型
            ,certid -- 担保人证件号码
            ,loancardno -- 担保人贷款卡编号
            ,guaranteeform -- 保证担保形式
            ,voucheecontractno -- 被担保合同号
            ,guaranteetype -- 担保类型
            ,guaranteecontracttype -- 唯品担保合同类型
            ,warrantortype -- 保证人类别
            ,warrantorname -- 保证人名称
            ,companycerttype -- 证件类别
            ,companycertno -- 证件号码
            ,warrantorproperty -- 保证人净资产
            ,guaranteestartdate -- 担保起始日期
            ,guaranteeenddate -- 担保到期日期
            ,guaranteecontractstatus -- 唯品担保合同状态
            ,guaranteecontractsigndate -- 唯品担保合同签订日期
            ,guaranteecontracteffectdate -- 唯品担保合同生效日期
            ,guaranteecontractenddate -- 唯品担保合同到期日期
            ,guaranteecurrency -- 唯品担保币种
            ,guaranteeamount -- 唯品担保总金额
            ,guaranteerate -- 担保费率
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wph_guaranty_contract_op(
            guarantyno -- 担保合同编号
            ,guarantytype -- 担保合同类型
            ,guarantystyle -- 担保方式
            ,guarantystatus -- 担保合同状态
            ,signdate -- 协议签定日期
            ,begindate -- 合同生效日
            ,enddate -- 合同到期日
            ,customerid -- 被担保人客户号
            ,guarantorid -- 担保人编号
            ,guarantorname -- 担保人名称
            ,guarantycurrency -- 担保币种
            ,guarantyvalue -- 担保总金额
            ,guarantyinfo -- 担保物概况
            ,otherdescsribe -- 其它特别约定
            ,guarantyopinion -- 担保意见
            ,certtype -- 担保人证件类型
            ,certid -- 担保人证件号码
            ,loancardno -- 担保人贷款卡编号
            ,guaranteeform -- 保证担保形式
            ,voucheecontractno -- 被担保合同号
            ,guaranteetype -- 担保类型
            ,guaranteecontracttype -- 唯品担保合同类型
            ,warrantortype -- 保证人类别
            ,warrantorname -- 保证人名称
            ,companycerttype -- 证件类别
            ,companycertno -- 证件号码
            ,warrantorproperty -- 保证人净资产
            ,guaranteestartdate -- 担保起始日期
            ,guaranteeenddate -- 担保到期日期
            ,guaranteecontractstatus -- 唯品担保合同状态
            ,guaranteecontractsigndate -- 唯品担保合同签订日期
            ,guaranteecontracteffectdate -- 唯品担保合同生效日期
            ,guaranteecontractenddate -- 唯品担保合同到期日期
            ,guaranteecurrency -- 唯品担保币种
            ,guaranteeamount -- 唯品担保总金额
            ,guaranteerate -- 担保费率
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.guarantyno, o.guarantyno) as guarantyno -- 担保合同编号
    ,nvl(n.guarantytype, o.guarantytype) as guarantytype -- 担保合同类型
    ,nvl(n.guarantystyle, o.guarantystyle) as guarantystyle -- 担保方式
    ,nvl(n.guarantystatus, o.guarantystatus) as guarantystatus -- 担保合同状态
    ,nvl(n.signdate, o.signdate) as signdate -- 协议签定日期
    ,nvl(n.begindate, o.begindate) as begindate -- 合同生效日
    ,nvl(n.enddate, o.enddate) as enddate -- 合同到期日
    ,nvl(n.customerid, o.customerid) as customerid -- 被担保人客户号
    ,nvl(n.guarantorid, o.guarantorid) as guarantorid -- 担保人编号
    ,nvl(n.guarantorname, o.guarantorname) as guarantorname -- 担保人名称
    ,nvl(n.guarantycurrency, o.guarantycurrency) as guarantycurrency -- 担保币种
    ,nvl(n.guarantyvalue, o.guarantyvalue) as guarantyvalue -- 担保总金额
    ,nvl(n.guarantyinfo, o.guarantyinfo) as guarantyinfo -- 担保物概况
    ,nvl(n.otherdescsribe, o.otherdescsribe) as otherdescsribe -- 其它特别约定
    ,nvl(n.guarantyopinion, o.guarantyopinion) as guarantyopinion -- 担保意见
    ,nvl(n.certtype, o.certtype) as certtype -- 担保人证件类型
    ,nvl(n.certid, o.certid) as certid -- 担保人证件号码
    ,nvl(n.loancardno, o.loancardno) as loancardno -- 担保人贷款卡编号
    ,nvl(n.guaranteeform, o.guaranteeform) as guaranteeform -- 保证担保形式
    ,nvl(n.voucheecontractno, o.voucheecontractno) as voucheecontractno -- 被担保合同号
    ,nvl(n.guaranteetype, o.guaranteetype) as guaranteetype -- 担保类型
    ,nvl(n.guaranteecontracttype, o.guaranteecontracttype) as guaranteecontracttype -- 唯品担保合同类型
    ,nvl(n.warrantortype, o.warrantortype) as warrantortype -- 保证人类别
    ,nvl(n.warrantorname, o.warrantorname) as warrantorname -- 保证人名称
    ,nvl(n.companycerttype, o.companycerttype) as companycerttype -- 证件类别
    ,nvl(n.companycertno, o.companycertno) as companycertno -- 证件号码
    ,nvl(n.warrantorproperty, o.warrantorproperty) as warrantorproperty -- 保证人净资产
    ,nvl(n.guaranteestartdate, o.guaranteestartdate) as guaranteestartdate -- 担保起始日期
    ,nvl(n.guaranteeenddate, o.guaranteeenddate) as guaranteeenddate -- 担保到期日期
    ,nvl(n.guaranteecontractstatus, o.guaranteecontractstatus) as guaranteecontractstatus -- 唯品担保合同状态
    ,nvl(n.guaranteecontractsigndate, o.guaranteecontractsigndate) as guaranteecontractsigndate -- 唯品担保合同签订日期
    ,nvl(n.guaranteecontracteffectdate, o.guaranteecontracteffectdate) as guaranteecontracteffectdate -- 唯品担保合同生效日期
    ,nvl(n.guaranteecontractenddate, o.guaranteecontractenddate) as guaranteecontractenddate -- 唯品担保合同到期日期
    ,nvl(n.guaranteecurrency, o.guaranteecurrency) as guaranteecurrency -- 唯品担保币种
    ,nvl(n.guaranteeamount, o.guaranteeamount) as guaranteeamount -- 唯品担保总金额
    ,nvl(n.guaranteerate, o.guaranteerate) as guaranteerate -- 担保费率
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,case when
            n.guarantyno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.guarantyno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.guarantyno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_wph_guaranty_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wph_guaranty_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.guarantyno = n.guarantyno
where (
        o.guarantyno is null
    )
    or (
        n.guarantyno is null
    )
    or (
        o.guarantytype <> n.guarantytype
        or o.guarantystyle <> n.guarantystyle
        or o.guarantystatus <> n.guarantystatus
        or o.signdate <> n.signdate
        or o.begindate <> n.begindate
        or o.enddate <> n.enddate
        or o.customerid <> n.customerid
        or o.guarantorid <> n.guarantorid
        or o.guarantorname <> n.guarantorname
        or o.guarantycurrency <> n.guarantycurrency
        or o.guarantyvalue <> n.guarantyvalue
        or o.guarantyinfo <> n.guarantyinfo
        or o.otherdescsribe <> n.otherdescsribe
        or o.guarantyopinion <> n.guarantyopinion
        or o.certtype <> n.certtype
        or o.certid <> n.certid
        or o.loancardno <> n.loancardno
        or o.guaranteeform <> n.guaranteeform
        or o.voucheecontractno <> n.voucheecontractno
        or o.guaranteetype <> n.guaranteetype
        or o.guaranteecontracttype <> n.guaranteecontracttype
        or o.warrantortype <> n.warrantortype
        or o.warrantorname <> n.warrantorname
        or o.companycerttype <> n.companycerttype
        or o.companycertno <> n.companycertno
        or o.warrantorproperty <> n.warrantorproperty
        or o.guaranteestartdate <> n.guaranteestartdate
        or o.guaranteeenddate <> n.guaranteeenddate
        or o.guaranteecontractstatus <> n.guaranteecontractstatus
        or o.guaranteecontractsigndate <> n.guaranteecontractsigndate
        or o.guaranteecontracteffectdate <> n.guaranteecontracteffectdate
        or o.guaranteecontractenddate <> n.guaranteecontractenddate
        or o.guaranteecurrency <> n.guaranteecurrency
        or o.guaranteeamount <> n.guaranteeamount
        or o.guaranteerate <> n.guaranteerate
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.updateuserid <> n.updateuserid
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wph_guaranty_contract_cl(
            guarantyno -- 担保合同编号
            ,guarantytype -- 担保合同类型
            ,guarantystyle -- 担保方式
            ,guarantystatus -- 担保合同状态
            ,signdate -- 协议签定日期
            ,begindate -- 合同生效日
            ,enddate -- 合同到期日
            ,customerid -- 被担保人客户号
            ,guarantorid -- 担保人编号
            ,guarantorname -- 担保人名称
            ,guarantycurrency -- 担保币种
            ,guarantyvalue -- 担保总金额
            ,guarantyinfo -- 担保物概况
            ,otherdescsribe -- 其它特别约定
            ,guarantyopinion -- 担保意见
            ,certtype -- 担保人证件类型
            ,certid -- 担保人证件号码
            ,loancardno -- 担保人贷款卡编号
            ,guaranteeform -- 保证担保形式
            ,voucheecontractno -- 被担保合同号
            ,guaranteetype -- 担保类型
            ,guaranteecontracttype -- 唯品担保合同类型
            ,warrantortype -- 保证人类别
            ,warrantorname -- 保证人名称
            ,companycerttype -- 证件类别
            ,companycertno -- 证件号码
            ,warrantorproperty -- 保证人净资产
            ,guaranteestartdate -- 担保起始日期
            ,guaranteeenddate -- 担保到期日期
            ,guaranteecontractstatus -- 唯品担保合同状态
            ,guaranteecontractsigndate -- 唯品担保合同签订日期
            ,guaranteecontracteffectdate -- 唯品担保合同生效日期
            ,guaranteecontractenddate -- 唯品担保合同到期日期
            ,guaranteecurrency -- 唯品担保币种
            ,guaranteeamount -- 唯品担保总金额
            ,guaranteerate -- 担保费率
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wph_guaranty_contract_op(
            guarantyno -- 担保合同编号
            ,guarantytype -- 担保合同类型
            ,guarantystyle -- 担保方式
            ,guarantystatus -- 担保合同状态
            ,signdate -- 协议签定日期
            ,begindate -- 合同生效日
            ,enddate -- 合同到期日
            ,customerid -- 被担保人客户号
            ,guarantorid -- 担保人编号
            ,guarantorname -- 担保人名称
            ,guarantycurrency -- 担保币种
            ,guarantyvalue -- 担保总金额
            ,guarantyinfo -- 担保物概况
            ,otherdescsribe -- 其它特别约定
            ,guarantyopinion -- 担保意见
            ,certtype -- 担保人证件类型
            ,certid -- 担保人证件号码
            ,loancardno -- 担保人贷款卡编号
            ,guaranteeform -- 保证担保形式
            ,voucheecontractno -- 被担保合同号
            ,guaranteetype -- 担保类型
            ,guaranteecontracttype -- 唯品担保合同类型
            ,warrantortype -- 保证人类别
            ,warrantorname -- 保证人名称
            ,companycerttype -- 证件类别
            ,companycertno -- 证件号码
            ,warrantorproperty -- 保证人净资产
            ,guaranteestartdate -- 担保起始日期
            ,guaranteeenddate -- 担保到期日期
            ,guaranteecontractstatus -- 唯品担保合同状态
            ,guaranteecontractsigndate -- 唯品担保合同签订日期
            ,guaranteecontracteffectdate -- 唯品担保合同生效日期
            ,guaranteecontractenddate -- 唯品担保合同到期日期
            ,guaranteecurrency -- 唯品担保币种
            ,guaranteeamount -- 唯品担保总金额
            ,guaranteerate -- 担保费率
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.guarantyno -- 担保合同编号
    ,o.guarantytype -- 担保合同类型
    ,o.guarantystyle -- 担保方式
    ,o.guarantystatus -- 担保合同状态
    ,o.signdate -- 协议签定日期
    ,o.begindate -- 合同生效日
    ,o.enddate -- 合同到期日
    ,o.customerid -- 被担保人客户号
    ,o.guarantorid -- 担保人编号
    ,o.guarantorname -- 担保人名称
    ,o.guarantycurrency -- 担保币种
    ,o.guarantyvalue -- 担保总金额
    ,o.guarantyinfo -- 担保物概况
    ,o.otherdescsribe -- 其它特别约定
    ,o.guarantyopinion -- 担保意见
    ,o.certtype -- 担保人证件类型
    ,o.certid -- 担保人证件号码
    ,o.loancardno -- 担保人贷款卡编号
    ,o.guaranteeform -- 保证担保形式
    ,o.voucheecontractno -- 被担保合同号
    ,o.guaranteetype -- 担保类型
    ,o.guaranteecontracttype -- 唯品担保合同类型
    ,o.warrantortype -- 保证人类别
    ,o.warrantorname -- 保证人名称
    ,o.companycerttype -- 证件类别
    ,o.companycertno -- 证件号码
    ,o.warrantorproperty -- 保证人净资产
    ,o.guaranteestartdate -- 担保起始日期
    ,o.guaranteeenddate -- 担保到期日期
    ,o.guaranteecontractstatus -- 唯品担保合同状态
    ,o.guaranteecontractsigndate -- 唯品担保合同签订日期
    ,o.guaranteecontracteffectdate -- 唯品担保合同生效日期
    ,o.guaranteecontractenddate -- 唯品担保合同到期日期
    ,o.guaranteecurrency -- 唯品担保币种
    ,o.guaranteeamount -- 唯品担保总金额
    ,o.guaranteerate -- 担保费率
    ,o.inputorgid -- 登记机构
    ,o.inputuserid -- 登记人
    ,o.inputdate -- 登记日期
    ,o.updateorgid -- 更新机构
    ,o.updateuserid -- 更新人
    ,o.updatedate -- 更新日期
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
from ${iol_schema}.icms_wph_guaranty_contract_bk o
    left join ${iol_schema}.icms_wph_guaranty_contract_op n
        on
            o.guarantyno = n.guarantyno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wph_guaranty_contract_cl d
        on
            o.guarantyno = d.guarantyno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_wph_guaranty_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wph_guaranty_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wph_guaranty_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wph_guaranty_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wph_guaranty_contract exchange partition p_${batch_date} with table ${iol_schema}.icms_wph_guaranty_contract_cl;
alter table ${iol_schema}.icms_wph_guaranty_contract exchange partition p_20991231 with table ${iol_schema}.icms_wph_guaranty_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wph_guaranty_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wph_guaranty_contract_op purge;
drop table ${iol_schema}.icms_wph_guaranty_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wph_guaranty_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wph_guaranty_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
