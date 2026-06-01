/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_asset_finance_acceptance_bill
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
create table ${iol_schema}.icms_clr_asset_finance_acceptance_bill_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_asset_finance_acceptance_bill
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_finance_acceptance_bill_op purge;
drop table ${iol_schema}.icms_clr_asset_finance_acceptance_bill_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_acceptance_bill_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_finance_acceptance_bill where 0=1;

create table ${iol_schema}.icms_clr_asset_finance_acceptance_bill_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_finance_acceptance_bill where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_finance_acceptance_bill_cl(
            clrid -- 押品编号
            ,notecode -- 票据号码
            ,notetype -- 票据类型
            ,remitter -- 出票人名称
            ,remittercode -- 出票人组织机构代码
            ,remittertype -- 出票人类型
            ,remitteropenacount -- 出票人开户行行号
            ,remitteraccount -- 出票人账号
            ,acceptor -- 承兑人名称
            ,acceptortype -- 承兑人类型
            ,payee -- 收款人名称
            ,payeetype -- 收款人类型
            ,isbillbhand -- 是否有票据前手
            ,billbhandname -- 票据前手名称
            ,billbhandtype -- 票据前手类型
            ,faceamount -- 票面金额
            ,startdate -- 票据签发日
            ,enddate -- 票据到期日期
            ,remittercountry -- 出票人注册地所在国家或地区
            ,remitterrating -- 出票人注册地所在国家或地区外部评级结果
            ,acceptorcountry -- 承兑人注册地所在国家或地区
            ,acceptorrating -- 承兑人注册地所在国家或地区外部评级结果
            ,remark -- 其他说明
            ,isbankpaste -- 是否银行保贴
            ,bankpastename -- 银行保贴名称
            ,tdcurrency -- 币种
            ,billkind -- 票据种类：普通票据和等分化票据
            ,subpackage -- 是否允许分包
            ,sectioncode -- 子区间号
            ,printcertno -- 纸质打印凭证号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,inoutno -- 出入库质押解质押接口信贷批次号
            ,acceptoropenbankno -- 承兑人开户行行号
            ,acceptoropenbankname -- 承兑人开户行行名
            ,sponsoraccount -- 出质人账号
            ,sponsoropenbankno -- 出质人开户行行号
            ,sponsoropenbankname -- 出质人开户行行名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_finance_acceptance_bill_op(
            clrid -- 押品编号
            ,notecode -- 票据号码
            ,notetype -- 票据类型
            ,remitter -- 出票人名称
            ,remittercode -- 出票人组织机构代码
            ,remittertype -- 出票人类型
            ,remitteropenacount -- 出票人开户行行号
            ,remitteraccount -- 出票人账号
            ,acceptor -- 承兑人名称
            ,acceptortype -- 承兑人类型
            ,payee -- 收款人名称
            ,payeetype -- 收款人类型
            ,isbillbhand -- 是否有票据前手
            ,billbhandname -- 票据前手名称
            ,billbhandtype -- 票据前手类型
            ,faceamount -- 票面金额
            ,startdate -- 票据签发日
            ,enddate -- 票据到期日期
            ,remittercountry -- 出票人注册地所在国家或地区
            ,remitterrating -- 出票人注册地所在国家或地区外部评级结果
            ,acceptorcountry -- 承兑人注册地所在国家或地区
            ,acceptorrating -- 承兑人注册地所在国家或地区外部评级结果
            ,remark -- 其他说明
            ,isbankpaste -- 是否银行保贴
            ,bankpastename -- 银行保贴名称
            ,tdcurrency -- 币种
            ,billkind -- 票据种类：普通票据和等分化票据
            ,subpackage -- 是否允许分包
            ,sectioncode -- 子区间号
            ,printcertno -- 纸质打印凭证号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,inoutno -- 出入库质押解质押接口信贷批次号
            ,acceptoropenbankno -- 承兑人开户行行号
            ,acceptoropenbankname -- 承兑人开户行行名
            ,sponsoraccount -- 出质人账号
            ,sponsoropenbankno -- 出质人开户行行号
            ,sponsoropenbankname -- 出质人开户行行名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.notecode, o.notecode) as notecode -- 票据号码
    ,nvl(n.notetype, o.notetype) as notetype -- 票据类型
    ,nvl(n.remitter, o.remitter) as remitter -- 出票人名称
    ,nvl(n.remittercode, o.remittercode) as remittercode -- 出票人组织机构代码
    ,nvl(n.remittertype, o.remittertype) as remittertype -- 出票人类型
    ,nvl(n.remitteropenacount, o.remitteropenacount) as remitteropenacount -- 出票人开户行行号
    ,nvl(n.remitteraccount, o.remitteraccount) as remitteraccount -- 出票人账号
    ,nvl(n.acceptor, o.acceptor) as acceptor -- 承兑人名称
    ,nvl(n.acceptortype, o.acceptortype) as acceptortype -- 承兑人类型
    ,nvl(n.payee, o.payee) as payee -- 收款人名称
    ,nvl(n.payeetype, o.payeetype) as payeetype -- 收款人类型
    ,nvl(n.isbillbhand, o.isbillbhand) as isbillbhand -- 是否有票据前手
    ,nvl(n.billbhandname, o.billbhandname) as billbhandname -- 票据前手名称
    ,nvl(n.billbhandtype, o.billbhandtype) as billbhandtype -- 票据前手类型
    ,nvl(n.faceamount, o.faceamount) as faceamount -- 票面金额
    ,nvl(n.startdate, o.startdate) as startdate -- 票据签发日
    ,nvl(n.enddate, o.enddate) as enddate -- 票据到期日期
    ,nvl(n.remittercountry, o.remittercountry) as remittercountry -- 出票人注册地所在国家或地区
    ,nvl(n.remitterrating, o.remitterrating) as remitterrating -- 出票人注册地所在国家或地区外部评级结果
    ,nvl(n.acceptorcountry, o.acceptorcountry) as acceptorcountry -- 承兑人注册地所在国家或地区
    ,nvl(n.acceptorrating, o.acceptorrating) as acceptorrating -- 承兑人注册地所在国家或地区外部评级结果
    ,nvl(n.remark, o.remark) as remark -- 其他说明
    ,nvl(n.isbankpaste, o.isbankpaste) as isbankpaste -- 是否银行保贴
    ,nvl(n.bankpastename, o.bankpastename) as bankpastename -- 银行保贴名称
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 币种
    ,nvl(n.billkind, o.billkind) as billkind -- 票据种类：普通票据和等分化票据
    ,nvl(n.subpackage, o.subpackage) as subpackage -- 是否允许分包
    ,nvl(n.sectioncode, o.sectioncode) as sectioncode -- 子区间号
    ,nvl(n.printcertno, o.printcertno) as printcertno -- 纸质打印凭证号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,nvl(n.inoutno, o.inoutno) as inoutno -- 出入库质押解质押接口信贷批次号
    ,nvl(n.acceptoropenbankno, o.acceptoropenbankno) as acceptoropenbankno -- 承兑人开户行行号
    ,nvl(n.acceptoropenbankname, o.acceptoropenbankname) as acceptoropenbankname -- 承兑人开户行行名
    ,nvl(n.sponsoraccount, o.sponsoraccount) as sponsoraccount -- 出质人账号
    ,nvl(n.sponsoropenbankno, o.sponsoropenbankno) as sponsoropenbankno -- 出质人开户行行号
    ,nvl(n.sponsoropenbankname, o.sponsoropenbankname) as sponsoropenbankname -- 出质人开户行行名
    ,case when
            n.clrid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.clrid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.clrid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_asset_finance_acceptance_bill_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_asset_finance_acceptance_bill where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrid = n.clrid
where (
        o.clrid is null
    )
    or (
        n.clrid is null
    )
    or (
        o.notecode <> n.notecode
        or o.notetype <> n.notetype
        or o.remitter <> n.remitter
        or o.remittercode <> n.remittercode
        or o.remittertype <> n.remittertype
        or o.remitteropenacount <> n.remitteropenacount
        or o.remitteraccount <> n.remitteraccount
        or o.acceptor <> n.acceptor
        or o.acceptortype <> n.acceptortype
        or o.payee <> n.payee
        or o.payeetype <> n.payeetype
        or o.isbillbhand <> n.isbillbhand
        or o.billbhandname <> n.billbhandname
        or o.billbhandtype <> n.billbhandtype
        or o.faceamount <> n.faceamount
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.remittercountry <> n.remittercountry
        or o.remitterrating <> n.remitterrating
        or o.acceptorcountry <> n.acceptorcountry
        or o.acceptorrating <> n.acceptorrating
        or o.remark <> n.remark
        or o.isbankpaste <> n.isbankpaste
        or o.bankpastename <> n.bankpastename
        or o.tdcurrency <> n.tdcurrency
        or o.billkind <> n.billkind
        or o.subpackage <> n.subpackage
        or o.sectioncode <> n.sectioncode
        or o.printcertno <> n.printcertno
        or o.migtflag <> n.migtflag
        or o.inoutno <> n.inoutno
        or o.acceptoropenbankno <> n.acceptoropenbankno
        or o.acceptoropenbankname <> n.acceptoropenbankname
        or o.sponsoraccount <> n.sponsoraccount
        or o.sponsoropenbankno <> n.sponsoropenbankno
        or o.sponsoropenbankname <> n.sponsoropenbankname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_finance_acceptance_bill_cl(
            clrid -- 押品编号
            ,notecode -- 票据号码
            ,notetype -- 票据类型
            ,remitter -- 出票人名称
            ,remittercode -- 出票人组织机构代码
            ,remittertype -- 出票人类型
            ,remitteropenacount -- 出票人开户行行号
            ,remitteraccount -- 出票人账号
            ,acceptor -- 承兑人名称
            ,acceptortype -- 承兑人类型
            ,payee -- 收款人名称
            ,payeetype -- 收款人类型
            ,isbillbhand -- 是否有票据前手
            ,billbhandname -- 票据前手名称
            ,billbhandtype -- 票据前手类型
            ,faceamount -- 票面金额
            ,startdate -- 票据签发日
            ,enddate -- 票据到期日期
            ,remittercountry -- 出票人注册地所在国家或地区
            ,remitterrating -- 出票人注册地所在国家或地区外部评级结果
            ,acceptorcountry -- 承兑人注册地所在国家或地区
            ,acceptorrating -- 承兑人注册地所在国家或地区外部评级结果
            ,remark -- 其他说明
            ,isbankpaste -- 是否银行保贴
            ,bankpastename -- 银行保贴名称
            ,tdcurrency -- 币种
            ,billkind -- 票据种类：普通票据和等分化票据
            ,subpackage -- 是否允许分包
            ,sectioncode -- 子区间号
            ,printcertno -- 纸质打印凭证号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,inoutno -- 出入库质押解质押接口信贷批次号
            ,acceptoropenbankno -- 承兑人开户行行号
            ,acceptoropenbankname -- 承兑人开户行行名
            ,sponsoraccount -- 出质人账号
            ,sponsoropenbankno -- 出质人开户行行号
            ,sponsoropenbankname -- 出质人开户行行名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_finance_acceptance_bill_op(
            clrid -- 押品编号
            ,notecode -- 票据号码
            ,notetype -- 票据类型
            ,remitter -- 出票人名称
            ,remittercode -- 出票人组织机构代码
            ,remittertype -- 出票人类型
            ,remitteropenacount -- 出票人开户行行号
            ,remitteraccount -- 出票人账号
            ,acceptor -- 承兑人名称
            ,acceptortype -- 承兑人类型
            ,payee -- 收款人名称
            ,payeetype -- 收款人类型
            ,isbillbhand -- 是否有票据前手
            ,billbhandname -- 票据前手名称
            ,billbhandtype -- 票据前手类型
            ,faceamount -- 票面金额
            ,startdate -- 票据签发日
            ,enddate -- 票据到期日期
            ,remittercountry -- 出票人注册地所在国家或地区
            ,remitterrating -- 出票人注册地所在国家或地区外部评级结果
            ,acceptorcountry -- 承兑人注册地所在国家或地区
            ,acceptorrating -- 承兑人注册地所在国家或地区外部评级结果
            ,remark -- 其他说明
            ,isbankpaste -- 是否银行保贴
            ,bankpastename -- 银行保贴名称
            ,tdcurrency -- 币种
            ,billkind -- 票据种类：普通票据和等分化票据
            ,subpackage -- 是否允许分包
            ,sectioncode -- 子区间号
            ,printcertno -- 纸质打印凭证号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,inoutno -- 出入库质押解质押接口信贷批次号
            ,acceptoropenbankno -- 承兑人开户行行号
            ,acceptoropenbankname -- 承兑人开户行行名
            ,sponsoraccount -- 出质人账号
            ,sponsoropenbankno -- 出质人开户行行号
            ,sponsoropenbankname -- 出质人开户行行名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrid -- 押品编号
    ,o.notecode -- 票据号码
    ,o.notetype -- 票据类型
    ,o.remitter -- 出票人名称
    ,o.remittercode -- 出票人组织机构代码
    ,o.remittertype -- 出票人类型
    ,o.remitteropenacount -- 出票人开户行行号
    ,o.remitteraccount -- 出票人账号
    ,o.acceptor -- 承兑人名称
    ,o.acceptortype -- 承兑人类型
    ,o.payee -- 收款人名称
    ,o.payeetype -- 收款人类型
    ,o.isbillbhand -- 是否有票据前手
    ,o.billbhandname -- 票据前手名称
    ,o.billbhandtype -- 票据前手类型
    ,o.faceamount -- 票面金额
    ,o.startdate -- 票据签发日
    ,o.enddate -- 票据到期日期
    ,o.remittercountry -- 出票人注册地所在国家或地区
    ,o.remitterrating -- 出票人注册地所在国家或地区外部评级结果
    ,o.acceptorcountry -- 承兑人注册地所在国家或地区
    ,o.acceptorrating -- 承兑人注册地所在国家或地区外部评级结果
    ,o.remark -- 其他说明
    ,o.isbankpaste -- 是否银行保贴
    ,o.bankpastename -- 银行保贴名称
    ,o.tdcurrency -- 币种
    ,o.billkind -- 票据种类：普通票据和等分化票据
    ,o.subpackage -- 是否允许分包
    ,o.sectioncode -- 子区间号
    ,o.printcertno -- 纸质打印凭证号
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
    ,o.inoutno -- 出入库质押解质押接口信贷批次号
    ,o.acceptoropenbankno -- 承兑人开户行行号
    ,o.acceptoropenbankname -- 承兑人开户行行名
    ,o.sponsoraccount -- 出质人账号
    ,o.sponsoropenbankno -- 出质人开户行行号
    ,o.sponsoropenbankname -- 出质人开户行行名
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
from ${iol_schema}.icms_clr_asset_finance_acceptance_bill_bk o
    left join ${iol_schema}.icms_clr_asset_finance_acceptance_bill_op n
        on
            o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_asset_finance_acceptance_bill_cl d
        on
            o.clrid = d.clrid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_asset_finance_acceptance_bill;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_asset_finance_acceptance_bill') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_asset_finance_acceptance_bill drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_asset_finance_acceptance_bill add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_asset_finance_acceptance_bill exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_asset_finance_acceptance_bill_cl;
alter table ${iol_schema}.icms_clr_asset_finance_acceptance_bill exchange partition p_20991231 with table ${iol_schema}.icms_clr_asset_finance_acceptance_bill_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_asset_finance_acceptance_bill to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_finance_acceptance_bill_op purge;
drop table ${iol_schema}.icms_clr_asset_finance_acceptance_bill_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_asset_finance_acceptance_bill_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_asset_finance_acceptance_bill',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
