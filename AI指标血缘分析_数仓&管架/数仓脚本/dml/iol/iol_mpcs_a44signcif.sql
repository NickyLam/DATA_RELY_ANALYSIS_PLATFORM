/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a44signcif
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
create table ${iol_schema}.mpcs_a44signcif_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a44signcif;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a44signcif_op purge;
drop table ${iol_schema}.mpcs_a44signcif_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a44signcif_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a44signcif where 0=1;

create table ${iol_schema}.mpcs_a44signcif_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a44signcif where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a44signcif_cl(
            signseqno -- 
            ,trndt -- 
            ,trntm -- 
            ,srcsysid -- 
            ,srcseqno -- 
            ,idtype -- 
            ,idno -- 
            ,idduedt -- 
            ,custname -- 
            ,legalname -- 
            ,legalidtype -- 
            ,legalidno -- 
            ,legalidduedt -- 
            ,legaltel -- 
            ,corpid -- 
            ,regicd -- 
            ,dealsp -- 
            ,corppr -- 
            ,corptp -- 
            ,regiam -- 
            ,insttype -- 
            ,zipcd -- 
            ,fax -- 
            ,addr -- 
            ,actorname -- 
            ,actoridtype -- 
            ,actoridno -- 
            ,actoridduedt -- 
            ,actortel -- 
            ,actoraddr -- 
            ,contactname -- 
            ,contactidtype -- 
            ,contactidno -- 
            ,contactidduedt -- 
            ,contactaddr -- 
            ,mobile -- 
            ,custmanagerid -- 
            ,state -- 
            ,custno -- 
            ,acctno -- 
            ,openbrcno -- 
            ,openbrcname -- 
            ,bstyle -- 
            ,bacctno -- 
            ,bacctname -- 
            ,bacctbankid -- 
            ,bacctbankname -- 
            ,updt -- 
            ,uptm -- 
            ,contactzipcd -- 
            ,contactfax -- 
            ,cifopendt -- 
            ,acopendt -- 
            ,custmanagername -- 
            ,tellerid -- 
            ,ntusflag -- 
            ,expireflag -- 
            ,taxresident -- 
            ,brntype -- 
            ,addresstype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a44signcif_op(
            signseqno -- 
            ,trndt -- 
            ,trntm -- 
            ,srcsysid -- 
            ,srcseqno -- 
            ,idtype -- 
            ,idno -- 
            ,idduedt -- 
            ,custname -- 
            ,legalname -- 
            ,legalidtype -- 
            ,legalidno -- 
            ,legalidduedt -- 
            ,legaltel -- 
            ,corpid -- 
            ,regicd -- 
            ,dealsp -- 
            ,corppr -- 
            ,corptp -- 
            ,regiam -- 
            ,insttype -- 
            ,zipcd -- 
            ,fax -- 
            ,addr -- 
            ,actorname -- 
            ,actoridtype -- 
            ,actoridno -- 
            ,actoridduedt -- 
            ,actortel -- 
            ,actoraddr -- 
            ,contactname -- 
            ,contactidtype -- 
            ,contactidno -- 
            ,contactidduedt -- 
            ,contactaddr -- 
            ,mobile -- 
            ,custmanagerid -- 
            ,state -- 
            ,custno -- 
            ,acctno -- 
            ,openbrcno -- 
            ,openbrcname -- 
            ,bstyle -- 
            ,bacctno -- 
            ,bacctname -- 
            ,bacctbankid -- 
            ,bacctbankname -- 
            ,updt -- 
            ,uptm -- 
            ,contactzipcd -- 
            ,contactfax -- 
            ,cifopendt -- 
            ,acopendt -- 
            ,custmanagername -- 
            ,tellerid -- 
            ,ntusflag -- 
            ,expireflag -- 
            ,taxresident -- 
            ,brntype -- 
            ,addresstype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.signseqno, o.signseqno) as signseqno -- 
    ,nvl(n.trndt, o.trndt) as trndt -- 
    ,nvl(n.trntm, o.trntm) as trntm -- 
    ,nvl(n.srcsysid, o.srcsysid) as srcsysid -- 
    ,nvl(n.srcseqno, o.srcseqno) as srcseqno -- 
    ,nvl(n.idtype, o.idtype) as idtype -- 
    ,nvl(n.idno, o.idno) as idno -- 
    ,nvl(n.idduedt, o.idduedt) as idduedt -- 
    ,nvl(n.custname, o.custname) as custname -- 
    ,nvl(n.legalname, o.legalname) as legalname -- 
    ,nvl(n.legalidtype, o.legalidtype) as legalidtype -- 
    ,nvl(n.legalidno, o.legalidno) as legalidno -- 
    ,nvl(n.legalidduedt, o.legalidduedt) as legalidduedt -- 
    ,nvl(n.legaltel, o.legaltel) as legaltel -- 
    ,nvl(n.corpid, o.corpid) as corpid -- 
    ,nvl(n.regicd, o.regicd) as regicd -- 
    ,nvl(n.dealsp, o.dealsp) as dealsp -- 
    ,nvl(n.corppr, o.corppr) as corppr -- 
    ,nvl(n.corptp, o.corptp) as corptp -- 
    ,nvl(n.regiam, o.regiam) as regiam -- 
    ,nvl(n.insttype, o.insttype) as insttype -- 
    ,nvl(n.zipcd, o.zipcd) as zipcd -- 
    ,nvl(n.fax, o.fax) as fax -- 
    ,nvl(n.addr, o.addr) as addr -- 
    ,nvl(n.actorname, o.actorname) as actorname -- 
    ,nvl(n.actoridtype, o.actoridtype) as actoridtype -- 
    ,nvl(n.actoridno, o.actoridno) as actoridno -- 
    ,nvl(n.actoridduedt, o.actoridduedt) as actoridduedt -- 
    ,nvl(n.actortel, o.actortel) as actortel -- 
    ,nvl(n.actoraddr, o.actoraddr) as actoraddr -- 
    ,nvl(n.contactname, o.contactname) as contactname -- 
    ,nvl(n.contactidtype, o.contactidtype) as contactidtype -- 
    ,nvl(n.contactidno, o.contactidno) as contactidno -- 
    ,nvl(n.contactidduedt, o.contactidduedt) as contactidduedt -- 
    ,nvl(n.contactaddr, o.contactaddr) as contactaddr -- 
    ,nvl(n.mobile, o.mobile) as mobile -- 
    ,nvl(n.custmanagerid, o.custmanagerid) as custmanagerid -- 
    ,nvl(n.state, o.state) as state -- 
    ,nvl(n.custno, o.custno) as custno -- 
    ,nvl(n.acctno, o.acctno) as acctno -- 
    ,nvl(n.openbrcno, o.openbrcno) as openbrcno -- 
    ,nvl(n.openbrcname, o.openbrcname) as openbrcname -- 
    ,nvl(n.bstyle, o.bstyle) as bstyle -- 
    ,nvl(n.bacctno, o.bacctno) as bacctno -- 
    ,nvl(n.bacctname, o.bacctname) as bacctname -- 
    ,nvl(n.bacctbankid, o.bacctbankid) as bacctbankid -- 
    ,nvl(n.bacctbankname, o.bacctbankname) as bacctbankname -- 
    ,nvl(n.updt, o.updt) as updt -- 
    ,nvl(n.uptm, o.uptm) as uptm -- 
    ,nvl(n.contactzipcd, o.contactzipcd) as contactzipcd -- 
    ,nvl(n.contactfax, o.contactfax) as contactfax -- 
    ,nvl(n.cifopendt, o.cifopendt) as cifopendt -- 
    ,nvl(n.acopendt, o.acopendt) as acopendt -- 
    ,nvl(n.custmanagername, o.custmanagername) as custmanagername -- 
    ,nvl(n.tellerid, o.tellerid) as tellerid -- 
    ,nvl(n.ntusflag, o.ntusflag) as ntusflag -- 
    ,nvl(n.expireflag, o.expireflag) as expireflag -- 
    ,nvl(n.taxresident, o.taxresident) as taxresident -- 
    ,nvl(n.brntype, o.brntype) as brntype -- 
    ,nvl(n.addresstype, o.addresstype) as addresstype -- 
    ,case when
            n.signseqno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.signseqno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.signseqno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a44signcif_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a44signcif where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.signseqno = n.signseqno
where (
        o.signseqno is null
    )
    or (
        n.signseqno is null
    )
    or (
        o.trndt <> n.trndt
        or o.trntm <> n.trntm
        or o.srcsysid <> n.srcsysid
        or o.srcseqno <> n.srcseqno
        or o.idtype <> n.idtype
        or o.idno <> n.idno
        or o.idduedt <> n.idduedt
        or o.custname <> n.custname
        or o.legalname <> n.legalname
        or o.legalidtype <> n.legalidtype
        or o.legalidno <> n.legalidno
        or o.legalidduedt <> n.legalidduedt
        or o.legaltel <> n.legaltel
        or o.corpid <> n.corpid
        or o.regicd <> n.regicd
        or o.dealsp <> n.dealsp
        or o.corppr <> n.corppr
        or o.corptp <> n.corptp
        or o.regiam <> n.regiam
        or o.insttype <> n.insttype
        or o.zipcd <> n.zipcd
        or o.fax <> n.fax
        or o.addr <> n.addr
        or o.actorname <> n.actorname
        or o.actoridtype <> n.actoridtype
        or o.actoridno <> n.actoridno
        or o.actoridduedt <> n.actoridduedt
        or o.actortel <> n.actortel
        or o.actoraddr <> n.actoraddr
        or o.contactname <> n.contactname
        or o.contactidtype <> n.contactidtype
        or o.contactidno <> n.contactidno
        or o.contactidduedt <> n.contactidduedt
        or o.contactaddr <> n.contactaddr
        or o.mobile <> n.mobile
        or o.custmanagerid <> n.custmanagerid
        or o.state <> n.state
        or o.custno <> n.custno
        or o.acctno <> n.acctno
        or o.openbrcno <> n.openbrcno
        or o.openbrcname <> n.openbrcname
        or o.bstyle <> n.bstyle
        or o.bacctno <> n.bacctno
        or o.bacctname <> n.bacctname
        or o.bacctbankid <> n.bacctbankid
        or o.bacctbankname <> n.bacctbankname
        or o.updt <> n.updt
        or o.uptm <> n.uptm
        or o.contactzipcd <> n.contactzipcd
        or o.contactfax <> n.contactfax
        or o.cifopendt <> n.cifopendt
        or o.acopendt <> n.acopendt
        or o.custmanagername <> n.custmanagername
        or o.tellerid <> n.tellerid
        or o.ntusflag <> n.ntusflag
        or o.expireflag <> n.expireflag
        or o.taxresident <> n.taxresident
        or o.brntype <> n.brntype
        or o.addresstype <> n.addresstype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a44signcif_cl(
            signseqno -- 
            ,trndt -- 
            ,trntm -- 
            ,srcsysid -- 
            ,srcseqno -- 
            ,idtype -- 
            ,idno -- 
            ,idduedt -- 
            ,custname -- 
            ,legalname -- 
            ,legalidtype -- 
            ,legalidno -- 
            ,legalidduedt -- 
            ,legaltel -- 
            ,corpid -- 
            ,regicd -- 
            ,dealsp -- 
            ,corppr -- 
            ,corptp -- 
            ,regiam -- 
            ,insttype -- 
            ,zipcd -- 
            ,fax -- 
            ,addr -- 
            ,actorname -- 
            ,actoridtype -- 
            ,actoridno -- 
            ,actoridduedt -- 
            ,actortel -- 
            ,actoraddr -- 
            ,contactname -- 
            ,contactidtype -- 
            ,contactidno -- 
            ,contactidduedt -- 
            ,contactaddr -- 
            ,mobile -- 
            ,custmanagerid -- 
            ,state -- 
            ,custno -- 
            ,acctno -- 
            ,openbrcno -- 
            ,openbrcname -- 
            ,bstyle -- 
            ,bacctno -- 
            ,bacctname -- 
            ,bacctbankid -- 
            ,bacctbankname -- 
            ,updt -- 
            ,uptm -- 
            ,contactzipcd -- 
            ,contactfax -- 
            ,cifopendt -- 
            ,acopendt -- 
            ,custmanagername -- 
            ,tellerid -- 
            ,ntusflag -- 
            ,expireflag -- 
            ,taxresident -- 
            ,brntype -- 
            ,addresstype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a44signcif_op(
            signseqno -- 
            ,trndt -- 
            ,trntm -- 
            ,srcsysid -- 
            ,srcseqno -- 
            ,idtype -- 
            ,idno -- 
            ,idduedt -- 
            ,custname -- 
            ,legalname -- 
            ,legalidtype -- 
            ,legalidno -- 
            ,legalidduedt -- 
            ,legaltel -- 
            ,corpid -- 
            ,regicd -- 
            ,dealsp -- 
            ,corppr -- 
            ,corptp -- 
            ,regiam -- 
            ,insttype -- 
            ,zipcd -- 
            ,fax -- 
            ,addr -- 
            ,actorname -- 
            ,actoridtype -- 
            ,actoridno -- 
            ,actoridduedt -- 
            ,actortel -- 
            ,actoraddr -- 
            ,contactname -- 
            ,contactidtype -- 
            ,contactidno -- 
            ,contactidduedt -- 
            ,contactaddr -- 
            ,mobile -- 
            ,custmanagerid -- 
            ,state -- 
            ,custno -- 
            ,acctno -- 
            ,openbrcno -- 
            ,openbrcname -- 
            ,bstyle -- 
            ,bacctno -- 
            ,bacctname -- 
            ,bacctbankid -- 
            ,bacctbankname -- 
            ,updt -- 
            ,uptm -- 
            ,contactzipcd -- 
            ,contactfax -- 
            ,cifopendt -- 
            ,acopendt -- 
            ,custmanagername -- 
            ,tellerid -- 
            ,ntusflag -- 
            ,expireflag -- 
            ,taxresident -- 
            ,brntype -- 
            ,addresstype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.signseqno -- 
    ,o.trndt -- 
    ,o.trntm -- 
    ,o.srcsysid -- 
    ,o.srcseqno -- 
    ,o.idtype -- 
    ,o.idno -- 
    ,o.idduedt -- 
    ,o.custname -- 
    ,o.legalname -- 
    ,o.legalidtype -- 
    ,o.legalidno -- 
    ,o.legalidduedt -- 
    ,o.legaltel -- 
    ,o.corpid -- 
    ,o.regicd -- 
    ,o.dealsp -- 
    ,o.corppr -- 
    ,o.corptp -- 
    ,o.regiam -- 
    ,o.insttype -- 
    ,o.zipcd -- 
    ,o.fax -- 
    ,o.addr -- 
    ,o.actorname -- 
    ,o.actoridtype -- 
    ,o.actoridno -- 
    ,o.actoridduedt -- 
    ,o.actortel -- 
    ,o.actoraddr -- 
    ,o.contactname -- 
    ,o.contactidtype -- 
    ,o.contactidno -- 
    ,o.contactidduedt -- 
    ,o.contactaddr -- 
    ,o.mobile -- 
    ,o.custmanagerid -- 
    ,o.state -- 
    ,o.custno -- 
    ,o.acctno -- 
    ,o.openbrcno -- 
    ,o.openbrcname -- 
    ,o.bstyle -- 
    ,o.bacctno -- 
    ,o.bacctname -- 
    ,o.bacctbankid -- 
    ,o.bacctbankname -- 
    ,o.updt -- 
    ,o.uptm -- 
    ,o.contactzipcd -- 
    ,o.contactfax -- 
    ,o.cifopendt -- 
    ,o.acopendt -- 
    ,o.custmanagername -- 
    ,o.tellerid -- 
    ,o.ntusflag -- 
    ,o.expireflag -- 
    ,o.taxresident -- 
    ,o.brntype -- 
    ,o.addresstype -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a44signcif_bk o
    left join ${iol_schema}.mpcs_a44signcif_op n
        on
            o.signseqno = n.signseqno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a44signcif_cl d
        on
            o.signseqno = d.signseqno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a44signcif;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a44signcif exchange partition p_19000101 with table ${iol_schema}.mpcs_a44signcif_cl;
alter table ${iol_schema}.mpcs_a44signcif exchange partition p_20991231 with table ${iol_schema}.mpcs_a44signcif_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a44signcif to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a44signcif_op purge;
drop table ${iol_schema}.mpcs_a44signcif_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a44signcif_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a44signcif',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
