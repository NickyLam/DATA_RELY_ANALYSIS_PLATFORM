/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_fkd_policy_info
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
create table ${iol_schema}.icms_fkd_policy_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_fkd_policy_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fkd_policy_info_op purge;
drop table ${iol_schema}.icms_fkd_policy_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_policy_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fkd_policy_info where 0=1;

create table ${iol_schema}.icms_fkd_policy_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fkd_policy_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fkd_policy_info_cl(
            serialno -- 主键
            ,applyno -- 业务流水号
            ,loaninterdt -- 同贷交互时间
            ,insurercode -- 保险公司代码
            ,performanceperiod -- 履约期
            ,policyno -- 保单号
            ,cusname -- 客户名称
            ,loanrate -- 年化利率
            ,policyterms -- 保险期限
            ,borrowerrelation -- 与借款人关系
            ,policydeductratio -- 绝对免赔率
            ,loanprice -- 贷款金额
            ,crtdt -- 创建时间
            ,banktype -- 新贷款机构
            ,bankcode -- 银行联行号
            ,relativeserialno -- 申请表流水号
            ,policyamt -- 保险金额
            ,inputdate -- 保单生效时间
            ,policyratio -- 承保比例（单位：%）
            ,outputdate -- 保单解除时间
            ,bankname -- 银行名称
            ,insurername -- 保险公司名称
            ,isconformed -- 是否确认授信
            ,migtflag -- 
            ,guarcontno -- 担保合同编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fkd_policy_info_op(
            serialno -- 主键
            ,applyno -- 业务流水号
            ,loaninterdt -- 同贷交互时间
            ,insurercode -- 保险公司代码
            ,performanceperiod -- 履约期
            ,policyno -- 保单号
            ,cusname -- 客户名称
            ,loanrate -- 年化利率
            ,policyterms -- 保险期限
            ,borrowerrelation -- 与借款人关系
            ,policydeductratio -- 绝对免赔率
            ,loanprice -- 贷款金额
            ,crtdt -- 创建时间
            ,banktype -- 新贷款机构
            ,bankcode -- 银行联行号
            ,relativeserialno -- 申请表流水号
            ,policyamt -- 保险金额
            ,inputdate -- 保单生效时间
            ,policyratio -- 承保比例（单位：%）
            ,outputdate -- 保单解除时间
            ,bankname -- 银行名称
            ,insurername -- 保险公司名称
            ,isconformed -- 是否确认授信
            ,migtflag -- 
            ,guarcontno -- 担保合同编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 主键
    ,nvl(n.applyno, o.applyno) as applyno -- 业务流水号
    ,nvl(n.loaninterdt, o.loaninterdt) as loaninterdt -- 同贷交互时间
    ,nvl(n.insurercode, o.insurercode) as insurercode -- 保险公司代码
    ,nvl(n.performanceperiod, o.performanceperiod) as performanceperiod -- 履约期
    ,nvl(n.policyno, o.policyno) as policyno -- 保单号
    ,nvl(n.cusname, o.cusname) as cusname -- 客户名称
    ,nvl(n.loanrate, o.loanrate) as loanrate -- 年化利率
    ,nvl(n.policyterms, o.policyterms) as policyterms -- 保险期限
    ,nvl(n.borrowerrelation, o.borrowerrelation) as borrowerrelation -- 与借款人关系
    ,nvl(n.policydeductratio, o.policydeductratio) as policydeductratio -- 绝对免赔率
    ,nvl(n.loanprice, o.loanprice) as loanprice -- 贷款金额
    ,nvl(n.crtdt, o.crtdt) as crtdt -- 创建时间
    ,nvl(n.banktype, o.banktype) as banktype -- 新贷款机构
    ,nvl(n.bankcode, o.bankcode) as bankcode -- 银行联行号
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 申请表流水号
    ,nvl(n.policyamt, o.policyamt) as policyamt -- 保险金额
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 保单生效时间
    ,nvl(n.policyratio, o.policyratio) as policyratio -- 承保比例（单位：%）
    ,nvl(n.outputdate, o.outputdate) as outputdate -- 保单解除时间
    ,nvl(n.bankname, o.bankname) as bankname -- 银行名称
    ,nvl(n.insurername, o.insurername) as insurername -- 保险公司名称
    ,nvl(n.isconformed, o.isconformed) as isconformed -- 是否确认授信
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.guarcontno, o.guarcontno) as guarcontno -- 担保合同编号
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
from (select * from ${iol_schema}.icms_fkd_policy_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_fkd_policy_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.loaninterdt <> n.loaninterdt
        or o.insurercode <> n.insurercode
        or o.performanceperiod <> n.performanceperiod
        or o.policyno <> n.policyno
        or o.cusname <> n.cusname
        or o.loanrate <> n.loanrate
        or o.policyterms <> n.policyterms
        or o.borrowerrelation <> n.borrowerrelation
        or o.policydeductratio <> n.policydeductratio
        or o.loanprice <> n.loanprice
        or o.crtdt <> n.crtdt
        or o.banktype <> n.banktype
        or o.bankcode <> n.bankcode
        or o.relativeserialno <> n.relativeserialno
        or o.policyamt <> n.policyamt
        or o.inputdate <> n.inputdate
        or o.policyratio <> n.policyratio
        or o.outputdate <> n.outputdate
        or o.bankname <> n.bankname
        or o.insurername <> n.insurername
        or o.isconformed <> n.isconformed
        or o.migtflag <> n.migtflag
        or o.guarcontno <> n.guarcontno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fkd_policy_info_cl(
            serialno -- 主键
            ,applyno -- 业务流水号
            ,loaninterdt -- 同贷交互时间
            ,insurercode -- 保险公司代码
            ,performanceperiod -- 履约期
            ,policyno -- 保单号
            ,cusname -- 客户名称
            ,loanrate -- 年化利率
            ,policyterms -- 保险期限
            ,borrowerrelation -- 与借款人关系
            ,policydeductratio -- 绝对免赔率
            ,loanprice -- 贷款金额
            ,crtdt -- 创建时间
            ,banktype -- 新贷款机构
            ,bankcode -- 银行联行号
            ,relativeserialno -- 申请表流水号
            ,policyamt -- 保险金额
            ,inputdate -- 保单生效时间
            ,policyratio -- 承保比例（单位：%）
            ,outputdate -- 保单解除时间
            ,bankname -- 银行名称
            ,insurername -- 保险公司名称
            ,isconformed -- 是否确认授信
            ,migtflag -- 
            ,guarcontno -- 担保合同编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fkd_policy_info_op(
            serialno -- 主键
            ,applyno -- 业务流水号
            ,loaninterdt -- 同贷交互时间
            ,insurercode -- 保险公司代码
            ,performanceperiod -- 履约期
            ,policyno -- 保单号
            ,cusname -- 客户名称
            ,loanrate -- 年化利率
            ,policyterms -- 保险期限
            ,borrowerrelation -- 与借款人关系
            ,policydeductratio -- 绝对免赔率
            ,loanprice -- 贷款金额
            ,crtdt -- 创建时间
            ,banktype -- 新贷款机构
            ,bankcode -- 银行联行号
            ,relativeserialno -- 申请表流水号
            ,policyamt -- 保险金额
            ,inputdate -- 保单生效时间
            ,policyratio -- 承保比例（单位：%）
            ,outputdate -- 保单解除时间
            ,bankname -- 银行名称
            ,insurername -- 保险公司名称
            ,isconformed -- 是否确认授信
            ,migtflag -- 
            ,guarcontno -- 担保合同编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 主键
    ,o.applyno -- 业务流水号
    ,o.loaninterdt -- 同贷交互时间
    ,o.insurercode -- 保险公司代码
    ,o.performanceperiod -- 履约期
    ,o.policyno -- 保单号
    ,o.cusname -- 客户名称
    ,o.loanrate -- 年化利率
    ,o.policyterms -- 保险期限
    ,o.borrowerrelation -- 与借款人关系
    ,o.policydeductratio -- 绝对免赔率
    ,o.loanprice -- 贷款金额
    ,o.crtdt -- 创建时间
    ,o.banktype -- 新贷款机构
    ,o.bankcode -- 银行联行号
    ,o.relativeserialno -- 申请表流水号
    ,o.policyamt -- 保险金额
    ,o.inputdate -- 保单生效时间
    ,o.policyratio -- 承保比例（单位：%）
    ,o.outputdate -- 保单解除时间
    ,o.bankname -- 银行名称
    ,o.insurername -- 保险公司名称
    ,o.isconformed -- 是否确认授信
    ,o.migtflag -- 
    ,o.guarcontno -- 担保合同编号
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
from ${iol_schema}.icms_fkd_policy_info_bk o
    left join ${iol_schema}.icms_fkd_policy_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_fkd_policy_info_cl d
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
--truncate table ${iol_schema}.icms_fkd_policy_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_fkd_policy_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_fkd_policy_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_fkd_policy_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_fkd_policy_info exchange partition p_${batch_date} with table ${iol_schema}.icms_fkd_policy_info_cl;
alter table ${iol_schema}.icms_fkd_policy_info exchange partition p_20991231 with table ${iol_schema}.icms_fkd_policy_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_fkd_policy_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fkd_policy_info_op purge;
drop table ${iol_schema}.icms_fkd_policy_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_fkd_policy_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_fkd_policy_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
