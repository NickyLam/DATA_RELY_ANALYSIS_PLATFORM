/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_cc_contractinfo
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
create table ${iol_schema}.mims_cc_contractinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_cc_contractinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_cc_contractinfo_op purge;
drop table ${iol_schema}.mims_cc_contractinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_cc_contractinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_cc_contractinfo where 0=1;

create table ${iol_schema}.mims_cc_contractinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_cc_contractinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_cc_contractinfo_cl(
            contractno -- 合同号
            ,custid -- 客户号
            ,regioncode -- 地区号
            ,orgid -- 机构代码
            ,mforgid -- 入账机构
            ,custmgr -- 客户经理
            ,credittype -- 授信品种
            ,loandirect -- 贷款投向
            ,currency -- 币种代码
            ,amt -- 合同金额
            ,balance -- 合同余额
            ,coveragerate -- 保证金比例
            ,assuremoney -- 保证金金额
            ,occurdate -- 生效日期
            ,duedate -- 到期日期
            ,guartype -- 担保方式 质押 3      信用 0      抵押 2      保证 1
            ,mainguartype -- 主担保方式
            ,createdate -- 建立日期
            ,updatedate -- 更新日期
            ,payamt -- 已发放金额
            ,fiveclass -- 五级分类
            ,balanceout -- 表外余额
            ,balancein -- 表内余额
            ,balance13 -- 欠息金额
            ,squarestate -- 结清状态 字典：issettle      1-已结清；2-未结清
            ,tenclass -- 贷款评级
            ,reqno -- 批复编号
            ,barsign -- 条线 对公条线 1    中小企业条线 2    个人条线 3
            ,creditaggreement -- 授信合同编号
            ,datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
            ,applycode -- 授信申请编号
            ,txtcontractno -- 纸质合同编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_cc_contractinfo_op(
            contractno -- 合同号
            ,custid -- 客户号
            ,regioncode -- 地区号
            ,orgid -- 机构代码
            ,mforgid -- 入账机构
            ,custmgr -- 客户经理
            ,credittype -- 授信品种
            ,loandirect -- 贷款投向
            ,currency -- 币种代码
            ,amt -- 合同金额
            ,balance -- 合同余额
            ,coveragerate -- 保证金比例
            ,assuremoney -- 保证金金额
            ,occurdate -- 生效日期
            ,duedate -- 到期日期
            ,guartype -- 担保方式 质押 3      信用 0      抵押 2      保证 1
            ,mainguartype -- 主担保方式
            ,createdate -- 建立日期
            ,updatedate -- 更新日期
            ,payamt -- 已发放金额
            ,fiveclass -- 五级分类
            ,balanceout -- 表外余额
            ,balancein -- 表内余额
            ,balance13 -- 欠息金额
            ,squarestate -- 结清状态 字典：issettle      1-已结清；2-未结清
            ,tenclass -- 贷款评级
            ,reqno -- 批复编号
            ,barsign -- 条线 对公条线 1    中小企业条线 2    个人条线 3
            ,creditaggreement -- 授信合同编号
            ,datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
            ,applycode -- 授信申请编号
            ,txtcontractno -- 纸质合同编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.contractno, o.contractno) as contractno -- 合同号
    ,nvl(n.custid, o.custid) as custid -- 客户号
    ,nvl(n.regioncode, o.regioncode) as regioncode -- 地区号
    ,nvl(n.orgid, o.orgid) as orgid -- 机构代码
    ,nvl(n.mforgid, o.mforgid) as mforgid -- 入账机构
    ,nvl(n.custmgr, o.custmgr) as custmgr -- 客户经理
    ,nvl(n.credittype, o.credittype) as credittype -- 授信品种
    ,nvl(n.loandirect, o.loandirect) as loandirect -- 贷款投向
    ,nvl(n.currency, o.currency) as currency -- 币种代码
    ,nvl(n.amt, o.amt) as amt -- 合同金额
    ,nvl(n.balance, o.balance) as balance -- 合同余额
    ,nvl(n.coveragerate, o.coveragerate) as coveragerate -- 保证金比例
    ,nvl(n.assuremoney, o.assuremoney) as assuremoney -- 保证金金额
    ,nvl(n.occurdate, o.occurdate) as occurdate -- 生效日期
    ,nvl(n.duedate, o.duedate) as duedate -- 到期日期
    ,nvl(n.guartype, o.guartype) as guartype -- 担保方式 质押 3      信用 0      抵押 2      保证 1
    ,nvl(n.mainguartype, o.mainguartype) as mainguartype -- 主担保方式
    ,nvl(n.createdate, o.createdate) as createdate -- 建立日期
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.payamt, o.payamt) as payamt -- 已发放金额
    ,nvl(n.fiveclass, o.fiveclass) as fiveclass -- 五级分类
    ,nvl(n.balanceout, o.balanceout) as balanceout -- 表外余额
    ,nvl(n.balancein, o.balancein) as balancein -- 表内余额
    ,nvl(n.balance13, o.balance13) as balance13 -- 欠息金额
    ,nvl(n.squarestate, o.squarestate) as squarestate -- 结清状态 字典：issettle      1-已结清；2-未结清
    ,nvl(n.tenclass, o.tenclass) as tenclass -- 贷款评级
    ,nvl(n.reqno, o.reqno) as reqno -- 批复编号
    ,nvl(n.barsign, o.barsign) as barsign -- 条线 对公条线 1    中小企业条线 2    个人条线 3
    ,nvl(n.creditaggreement, o.creditaggreement) as creditaggreement -- 授信合同编号
    ,nvl(n.datasourceflag, o.datasourceflag) as datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
    ,nvl(n.applycode, o.applycode) as applycode -- 授信申请编号
    ,nvl(n.txtcontractno, o.txtcontractno) as txtcontractno -- 纸质合同编号
    ,case when
            n.contractno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.contractno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.contractno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_cc_contractinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_cc_contractinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.contractno = n.contractno
where (
        o.contractno is null
    )
    or (
        n.contractno is null
    )
    or (
        o.custid <> n.custid
        or o.regioncode <> n.regioncode
        or o.orgid <> n.orgid
        or o.mforgid <> n.mforgid
        or o.custmgr <> n.custmgr
        or o.credittype <> n.credittype
        or o.loandirect <> n.loandirect
        or o.currency <> n.currency
        or o.amt <> n.amt
        or o.balance <> n.balance
        or o.coveragerate <> n.coveragerate
        or o.assuremoney <> n.assuremoney
        or o.occurdate <> n.occurdate
        or o.duedate <> n.duedate
        or o.guartype <> n.guartype
        or o.mainguartype <> n.mainguartype
        or o.createdate <> n.createdate
        or o.updatedate <> n.updatedate
        or o.payamt <> n.payamt
        or o.fiveclass <> n.fiveclass
        or o.balanceout <> n.balanceout
        or o.balancein <> n.balancein
        or o.balance13 <> n.balance13
        or o.squarestate <> n.squarestate
        or o.tenclass <> n.tenclass
        or o.reqno <> n.reqno
        or o.barsign <> n.barsign
        or o.creditaggreement <> n.creditaggreement
        or o.datasourceflag <> n.datasourceflag
        or o.applycode <> n.applycode
        or o.txtcontractno <> n.txtcontractno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_cc_contractinfo_cl(
            contractno -- 合同号
            ,custid -- 客户号
            ,regioncode -- 地区号
            ,orgid -- 机构代码
            ,mforgid -- 入账机构
            ,custmgr -- 客户经理
            ,credittype -- 授信品种
            ,loandirect -- 贷款投向
            ,currency -- 币种代码
            ,amt -- 合同金额
            ,balance -- 合同余额
            ,coveragerate -- 保证金比例
            ,assuremoney -- 保证金金额
            ,occurdate -- 生效日期
            ,duedate -- 到期日期
            ,guartype -- 担保方式 质押 3      信用 0      抵押 2      保证 1
            ,mainguartype -- 主担保方式
            ,createdate -- 建立日期
            ,updatedate -- 更新日期
            ,payamt -- 已发放金额
            ,fiveclass -- 五级分类
            ,balanceout -- 表外余额
            ,balancein -- 表内余额
            ,balance13 -- 欠息金额
            ,squarestate -- 结清状态 字典：issettle      1-已结清；2-未结清
            ,tenclass -- 贷款评级
            ,reqno -- 批复编号
            ,barsign -- 条线 对公条线 1    中小企业条线 2    个人条线 3
            ,creditaggreement -- 授信合同编号
            ,datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
            ,applycode -- 授信申请编号
            ,txtcontractno -- 纸质合同编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_cc_contractinfo_op(
            contractno -- 合同号
            ,custid -- 客户号
            ,regioncode -- 地区号
            ,orgid -- 机构代码
            ,mforgid -- 入账机构
            ,custmgr -- 客户经理
            ,credittype -- 授信品种
            ,loandirect -- 贷款投向
            ,currency -- 币种代码
            ,amt -- 合同金额
            ,balance -- 合同余额
            ,coveragerate -- 保证金比例
            ,assuremoney -- 保证金金额
            ,occurdate -- 生效日期
            ,duedate -- 到期日期
            ,guartype -- 担保方式 质押 3      信用 0      抵押 2      保证 1
            ,mainguartype -- 主担保方式
            ,createdate -- 建立日期
            ,updatedate -- 更新日期
            ,payamt -- 已发放金额
            ,fiveclass -- 五级分类
            ,balanceout -- 表外余额
            ,balancein -- 表内余额
            ,balance13 -- 欠息金额
            ,squarestate -- 结清状态 字典：issettle      1-已结清；2-未结清
            ,tenclass -- 贷款评级
            ,reqno -- 批复编号
            ,barsign -- 条线 对公条线 1    中小企业条线 2    个人条线 3
            ,creditaggreement -- 授信合同编号
            ,datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
            ,applycode -- 授信申请编号
            ,txtcontractno -- 纸质合同编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.contractno -- 合同号
    ,o.custid -- 客户号
    ,o.regioncode -- 地区号
    ,o.orgid -- 机构代码
    ,o.mforgid -- 入账机构
    ,o.custmgr -- 客户经理
    ,o.credittype -- 授信品种
    ,o.loandirect -- 贷款投向
    ,o.currency -- 币种代码
    ,o.amt -- 合同金额
    ,o.balance -- 合同余额
    ,o.coveragerate -- 保证金比例
    ,o.assuremoney -- 保证金金额
    ,o.occurdate -- 生效日期
    ,o.duedate -- 到期日期
    ,o.guartype -- 担保方式 质押 3      信用 0      抵押 2      保证 1
    ,o.mainguartype -- 主担保方式
    ,o.createdate -- 建立日期
    ,o.updatedate -- 更新日期
    ,o.payamt -- 已发放金额
    ,o.fiveclass -- 五级分类
    ,o.balanceout -- 表外余额
    ,o.balancein -- 表内余额
    ,o.balance13 -- 欠息金额
    ,o.squarestate -- 结清状态 字典：issettle      1-已结清；2-未结清
    ,o.tenclass -- 贷款评级
    ,o.reqno -- 批复编号
    ,o.barsign -- 条线 对公条线 1    中小企业条线 2    个人条线 3
    ,o.creditaggreement -- 授信合同编号
    ,o.datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
    ,o.applycode -- 授信申请编号
    ,o.txtcontractno -- 纸质合同编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_cc_contractinfo_bk o
    left join ${iol_schema}.mims_cc_contractinfo_op n
        on
            o.contractno = n.contractno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_cc_contractinfo_cl d
        on
            o.contractno = d.contractno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mims_cc_contractinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_cc_contractinfo exchange partition p_19000101 with table ${iol_schema}.mims_cc_contractinfo_cl;
alter table ${iol_schema}.mims_cc_contractinfo exchange partition p_20991231 with table ${iol_schema}.mims_cc_contractinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_cc_contractinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_cc_contractinfo_op purge;
drop table ${iol_schema}.mims_cc_contractinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_cc_contractinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_cc_contractinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
