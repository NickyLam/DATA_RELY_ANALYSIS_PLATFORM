/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lhwd_fm_business_attach
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
create table ${iol_schema}.icms_lhwd_fm_business_attach_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_lhwd_fm_business_attach
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lhwd_fm_business_attach_op purge;
drop table ${iol_schema}.icms_lhwd_fm_business_attach_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_fm_business_attach_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lhwd_fm_business_attach where 0=1;

create table ${iol_schema}.icms_lhwd_fm_business_attach_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lhwd_fm_business_attach where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lhwd_fm_business_attach_cl(
            serialno -- 流水号
            ,baserialno -- 授信编号
            ,bcserialno -- 合同编号
            ,bpserialno -- 放款编号
            ,fundno -- 资方编号
            ,applyno -- 全局流水号（第三方）
            ,repaytype -- 还款方式
            ,customerrate -- 对客利率
            ,recommendyearrate -- 推荐资金方合同年利率
            ,guaranteeinstitution -- 担保机构标识
            ,assetidentification -- 资产标识
            ,creditflag -- 征信标识
            ,bankreservephone -- 银行卡预留手机号
            ,paymentaccountno -- 入账账户
            ,paymentaccountname -- 入账账户名
            ,paymentaccountbankname -- 入账账户开户机构
            ,paymentaccounttype -- 入账账户类型
            ,finaldecisioncode -- 最终决策结果标识
            ,finalapplyamount -- 最终审批额度(元)
            ,finalapplyterm -- 最终审批期限
            ,extinfo -- 扩展信息
            ,riskfactorinfo -- 风险信息
            ,putoutfailcode -- 放款失败编码
            ,putoutfailreason -- 放款失败原因
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,imageprocstatus -- 影像文件处理状态 1处理完全 2超过处理时限，影像有缺失
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lhwd_fm_business_attach_op(
            serialno -- 流水号
            ,baserialno -- 授信编号
            ,bcserialno -- 合同编号
            ,bpserialno -- 放款编号
            ,fundno -- 资方编号
            ,applyno -- 全局流水号（第三方）
            ,repaytype -- 还款方式
            ,customerrate -- 对客利率
            ,recommendyearrate -- 推荐资金方合同年利率
            ,guaranteeinstitution -- 担保机构标识
            ,assetidentification -- 资产标识
            ,creditflag -- 征信标识
            ,bankreservephone -- 银行卡预留手机号
            ,paymentaccountno -- 入账账户
            ,paymentaccountname -- 入账账户名
            ,paymentaccountbankname -- 入账账户开户机构
            ,paymentaccounttype -- 入账账户类型
            ,finaldecisioncode -- 最终决策结果标识
            ,finalapplyamount -- 最终审批额度(元)
            ,finalapplyterm -- 最终审批期限
            ,extinfo -- 扩展信息
            ,riskfactorinfo -- 风险信息
            ,putoutfailcode -- 放款失败编码
            ,putoutfailreason -- 放款失败原因
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,imageprocstatus -- 影像文件处理状态 1处理完全 2超过处理时限，影像有缺失
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.baserialno, o.baserialno) as baserialno -- 授信编号
    ,nvl(n.bcserialno, o.bcserialno) as bcserialno -- 合同编号
    ,nvl(n.bpserialno, o.bpserialno) as bpserialno -- 放款编号
    ,nvl(n.fundno, o.fundno) as fundno -- 资方编号
    ,nvl(n.applyno, o.applyno) as applyno -- 全局流水号（第三方）
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.customerrate, o.customerrate) as customerrate -- 对客利率
    ,nvl(n.recommendyearrate, o.recommendyearrate) as recommendyearrate -- 推荐资金方合同年利率
    ,nvl(n.guaranteeinstitution, o.guaranteeinstitution) as guaranteeinstitution -- 担保机构标识
    ,nvl(n.assetidentification, o.assetidentification) as assetidentification -- 资产标识
    ,nvl(n.creditflag, o.creditflag) as creditflag -- 征信标识
    ,nvl(n.bankreservephone, o.bankreservephone) as bankreservephone -- 银行卡预留手机号
    ,nvl(n.paymentaccountno, o.paymentaccountno) as paymentaccountno -- 入账账户
    ,nvl(n.paymentaccountname, o.paymentaccountname) as paymentaccountname -- 入账账户名
    ,nvl(n.paymentaccountbankname, o.paymentaccountbankname) as paymentaccountbankname -- 入账账户开户机构
    ,nvl(n.paymentaccounttype, o.paymentaccounttype) as paymentaccounttype -- 入账账户类型
    ,nvl(n.finaldecisioncode, o.finaldecisioncode) as finaldecisioncode -- 最终决策结果标识
    ,nvl(n.finalapplyamount, o.finalapplyamount) as finalapplyamount -- 最终审批额度(元)
    ,nvl(n.finalapplyterm, o.finalapplyterm) as finalapplyterm -- 最终审批期限
    ,nvl(n.extinfo, o.extinfo) as extinfo -- 扩展信息
    ,nvl(n.riskfactorinfo, o.riskfactorinfo) as riskfactorinfo -- 风险信息
    ,nvl(n.putoutfailcode, o.putoutfailcode) as putoutfailcode -- 放款失败编码
    ,nvl(n.putoutfailreason, o.putoutfailreason) as putoutfailreason -- 放款失败原因
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.imageprocstatus, o.imageprocstatus) as imageprocstatus -- 影像文件处理状态 1处理完全 2超过处理时限，影像有缺失
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
from (select * from ${iol_schema}.icms_lhwd_fm_business_attach_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_lhwd_fm_business_attach where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.baserialno <> n.baserialno
        or o.bcserialno <> n.bcserialno
        or o.bpserialno <> n.bpserialno
        or o.fundno <> n.fundno
        or o.applyno <> n.applyno
        or o.repaytype <> n.repaytype
        or o.customerrate <> n.customerrate
        or o.recommendyearrate <> n.recommendyearrate
        or o.guaranteeinstitution <> n.guaranteeinstitution
        or o.assetidentification <> n.assetidentification
        or o.creditflag <> n.creditflag
        or o.bankreservephone <> n.bankreservephone
        or o.paymentaccountno <> n.paymentaccountno
        or o.paymentaccountname <> n.paymentaccountname
        or o.paymentaccountbankname <> n.paymentaccountbankname
        or o.paymentaccounttype <> n.paymentaccounttype
        or o.finaldecisioncode <> n.finaldecisioncode
        or o.finalapplyamount <> n.finalapplyamount
        or o.finalapplyterm <> n.finalapplyterm
        or o.extinfo <> n.extinfo
        or o.riskfactorinfo <> n.riskfactorinfo
        or o.putoutfailcode <> n.putoutfailcode
        or o.putoutfailreason <> n.putoutfailreason
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.imageprocstatus <> n.imageprocstatus
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lhwd_fm_business_attach_cl(
            serialno -- 流水号
            ,baserialno -- 授信编号
            ,bcserialno -- 合同编号
            ,bpserialno -- 放款编号
            ,fundno -- 资方编号
            ,applyno -- 全局流水号（第三方）
            ,repaytype -- 还款方式
            ,customerrate -- 对客利率
            ,recommendyearrate -- 推荐资金方合同年利率
            ,guaranteeinstitution -- 担保机构标识
            ,assetidentification -- 资产标识
            ,creditflag -- 征信标识
            ,bankreservephone -- 银行卡预留手机号
            ,paymentaccountno -- 入账账户
            ,paymentaccountname -- 入账账户名
            ,paymentaccountbankname -- 入账账户开户机构
            ,paymentaccounttype -- 入账账户类型
            ,finaldecisioncode -- 最终决策结果标识
            ,finalapplyamount -- 最终审批额度(元)
            ,finalapplyterm -- 最终审批期限
            ,extinfo -- 扩展信息
            ,riskfactorinfo -- 风险信息
            ,putoutfailcode -- 放款失败编码
            ,putoutfailreason -- 放款失败原因
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,imageprocstatus -- 影像文件处理状态 1处理完全 2超过处理时限，影像有缺失
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lhwd_fm_business_attach_op(
            serialno -- 流水号
            ,baserialno -- 授信编号
            ,bcserialno -- 合同编号
            ,bpserialno -- 放款编号
            ,fundno -- 资方编号
            ,applyno -- 全局流水号（第三方）
            ,repaytype -- 还款方式
            ,customerrate -- 对客利率
            ,recommendyearrate -- 推荐资金方合同年利率
            ,guaranteeinstitution -- 担保机构标识
            ,assetidentification -- 资产标识
            ,creditflag -- 征信标识
            ,bankreservephone -- 银行卡预留手机号
            ,paymentaccountno -- 入账账户
            ,paymentaccountname -- 入账账户名
            ,paymentaccountbankname -- 入账账户开户机构
            ,paymentaccounttype -- 入账账户类型
            ,finaldecisioncode -- 最终决策结果标识
            ,finalapplyamount -- 最终审批额度(元)
            ,finalapplyterm -- 最终审批期限
            ,extinfo -- 扩展信息
            ,riskfactorinfo -- 风险信息
            ,putoutfailcode -- 放款失败编码
            ,putoutfailreason -- 放款失败原因
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,imageprocstatus -- 影像文件处理状态 1处理完全 2超过处理时限，影像有缺失
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.baserialno -- 授信编号
    ,o.bcserialno -- 合同编号
    ,o.bpserialno -- 放款编号
    ,o.fundno -- 资方编号
    ,o.applyno -- 全局流水号（第三方）
    ,o.repaytype -- 还款方式
    ,o.customerrate -- 对客利率
    ,o.recommendyearrate -- 推荐资金方合同年利率
    ,o.guaranteeinstitution -- 担保机构标识
    ,o.assetidentification -- 资产标识
    ,o.creditflag -- 征信标识
    ,o.bankreservephone -- 银行卡预留手机号
    ,o.paymentaccountno -- 入账账户
    ,o.paymentaccountname -- 入账账户名
    ,o.paymentaccountbankname -- 入账账户开户机构
    ,o.paymentaccounttype -- 入账账户类型
    ,o.finaldecisioncode -- 最终决策结果标识
    ,o.finalapplyamount -- 最终审批额度(元)
    ,o.finalapplyterm -- 最终审批期限
    ,o.extinfo -- 扩展信息
    ,o.riskfactorinfo -- 风险信息
    ,o.putoutfailcode -- 放款失败编码
    ,o.putoutfailreason -- 放款失败原因
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记时间
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新时间
    ,o.imageprocstatus -- 影像文件处理状态 1处理完全 2超过处理时限，影像有缺失
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
from ${iol_schema}.icms_lhwd_fm_business_attach_bk o
    left join ${iol_schema}.icms_lhwd_fm_business_attach_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_lhwd_fm_business_attach_cl d
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
--truncate table ${iol_schema}.icms_lhwd_fm_business_attach;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_lhwd_fm_business_attach') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_lhwd_fm_business_attach drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_lhwd_fm_business_attach add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_lhwd_fm_business_attach exchange partition p_${batch_date} with table ${iol_schema}.icms_lhwd_fm_business_attach_cl;
alter table ${iol_schema}.icms_lhwd_fm_business_attach exchange partition p_20991231 with table ${iol_schema}.icms_lhwd_fm_business_attach_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lhwd_fm_business_attach to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lhwd_fm_business_attach_op purge;
drop table ${iol_schema}.icms_lhwd_fm_business_attach_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_lhwd_fm_business_attach_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lhwd_fm_business_attach',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
