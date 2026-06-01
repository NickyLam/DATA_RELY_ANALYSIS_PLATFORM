/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_rightcert_info
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
create table ${iol_schema}.icms_clr_rightcert_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_rightcert_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_rightcert_info_op purge;
drop table ${iol_schema}.icms_clr_rightcert_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_rightcert_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_rightcert_info where 0=1;

create table ${iol_schema}.icms_clr_rightcert_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_rightcert_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_rightcert_info_cl(
            rightcertid -- 权证编号
            ,rightcertname -- 权证名称
            ,clrid -- 押品编号
            ,guarantyplanno -- 担保方案编号
            ,sourcesystem -- 源系统
            ,rightcerttype -- 权证类型
            ,rightcertno -- 权证号
            ,rightregistrationorg -- 权证登记机关
            ,rightregistrationdate -- 权证登记时间
            ,packageid -- 最新的权证所属封包
            ,barcode -- 条形码
            ,transferdate -- 移交日期
            ,rightcertstatus -- 权证状态
            ,rightamount -- 权利金额
            ,possessortype -- 权证持有者类型
            ,isneedwarehousing -- 是否需要入库
            ,inwarehousingdate -- 正式入库日期
            ,outwarehousingdate -- 正式出库日期
            ,tempoutwhreason -- 临时出库日期
            ,lastoutwhdate -- 最近一次出库日期
            ,lastinwhdate -- 最近一次入库日期
            ,expcreturndate -- 临时出库预计归还日期
            ,isoverdue -- 临时出库是否逾期
            ,overduedays -- 临时出库逾期天数
            ,isdataconv -- 是否为移植
            ,registrationuserid -- 抵质押办证人
            ,rightduedate -- 权证到期日
            ,clrownerid -- 权属人编号
            ,clrownername -- 权属人名称
            ,saveorgid -- 保存机构编号
            ,catalogflag -- 区分权证和代保品,2：权证1：代保品
            ,clrownerstartdate -- 抵押登记起始日
            ,clrownerenddate -- 抵押登记到期日
            ,currency -- 币种
            ,guarantyregno -- 抵押登记编号
            ,moneyin -- 入账金额
            ,moneyintype -- 入账金额类型
            ,bookstatus -- 记账状态
            ,rightregorgtype -- 登记机构类型
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,remark -- 备注
            ,oldclrid -- 合并前押品编号
            ,twobarcodes -- 二维码
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_rightcert_info_op(
            rightcertid -- 权证编号
            ,rightcertname -- 权证名称
            ,clrid -- 押品编号
            ,guarantyplanno -- 担保方案编号
            ,sourcesystem -- 源系统
            ,rightcerttype -- 权证类型
            ,rightcertno -- 权证号
            ,rightregistrationorg -- 权证登记机关
            ,rightregistrationdate -- 权证登记时间
            ,packageid -- 最新的权证所属封包
            ,barcode -- 条形码
            ,transferdate -- 移交日期
            ,rightcertstatus -- 权证状态
            ,rightamount -- 权利金额
            ,possessortype -- 权证持有者类型
            ,isneedwarehousing -- 是否需要入库
            ,inwarehousingdate -- 正式入库日期
            ,outwarehousingdate -- 正式出库日期
            ,tempoutwhreason -- 临时出库日期
            ,lastoutwhdate -- 最近一次出库日期
            ,lastinwhdate -- 最近一次入库日期
            ,expcreturndate -- 临时出库预计归还日期
            ,isoverdue -- 临时出库是否逾期
            ,overduedays -- 临时出库逾期天数
            ,isdataconv -- 是否为移植
            ,registrationuserid -- 抵质押办证人
            ,rightduedate -- 权证到期日
            ,clrownerid -- 权属人编号
            ,clrownername -- 权属人名称
            ,saveorgid -- 保存机构编号
            ,catalogflag -- 区分权证和代保品,2：权证1：代保品
            ,clrownerstartdate -- 抵押登记起始日
            ,clrownerenddate -- 抵押登记到期日
            ,currency -- 币种
            ,guarantyregno -- 抵押登记编号
            ,moneyin -- 入账金额
            ,moneyintype -- 入账金额类型
            ,bookstatus -- 记账状态
            ,rightregorgtype -- 登记机构类型
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,remark -- 备注
            ,oldclrid -- 合并前押品编号
            ,twobarcodes -- 二维码
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rightcertid, o.rightcertid) as rightcertid -- 权证编号
    ,nvl(n.rightcertname, o.rightcertname) as rightcertname -- 权证名称
    ,nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.guarantyplanno, o.guarantyplanno) as guarantyplanno -- 担保方案编号
    ,nvl(n.sourcesystem, o.sourcesystem) as sourcesystem -- 源系统
    ,nvl(n.rightcerttype, o.rightcerttype) as rightcerttype -- 权证类型
    ,nvl(n.rightcertno, o.rightcertno) as rightcertno -- 权证号
    ,nvl(n.rightregistrationorg, o.rightregistrationorg) as rightregistrationorg -- 权证登记机关
    ,nvl(n.rightregistrationdate, o.rightregistrationdate) as rightregistrationdate -- 权证登记时间
    ,nvl(n.packageid, o.packageid) as packageid -- 最新的权证所属封包
    ,nvl(n.barcode, o.barcode) as barcode -- 条形码
    ,nvl(n.transferdate, o.transferdate) as transferdate -- 移交日期
    ,nvl(n.rightcertstatus, o.rightcertstatus) as rightcertstatus -- 权证状态
    ,nvl(n.rightamount, o.rightamount) as rightamount -- 权利金额
    ,nvl(n.possessortype, o.possessortype) as possessortype -- 权证持有者类型
    ,nvl(n.isneedwarehousing, o.isneedwarehousing) as isneedwarehousing -- 是否需要入库
    ,nvl(n.inwarehousingdate, o.inwarehousingdate) as inwarehousingdate -- 正式入库日期
    ,nvl(n.outwarehousingdate, o.outwarehousingdate) as outwarehousingdate -- 正式出库日期
    ,nvl(n.tempoutwhreason, o.tempoutwhreason) as tempoutwhreason -- 临时出库日期
    ,nvl(n.lastoutwhdate, o.lastoutwhdate) as lastoutwhdate -- 最近一次出库日期
    ,nvl(n.lastinwhdate, o.lastinwhdate) as lastinwhdate -- 最近一次入库日期
    ,nvl(n.expcreturndate, o.expcreturndate) as expcreturndate -- 临时出库预计归还日期
    ,nvl(n.isoverdue, o.isoverdue) as isoverdue -- 临时出库是否逾期
    ,nvl(n.overduedays, o.overduedays) as overduedays -- 临时出库逾期天数
    ,nvl(n.isdataconv, o.isdataconv) as isdataconv -- 是否为移植
    ,nvl(n.registrationuserid, o.registrationuserid) as registrationuserid -- 抵质押办证人
    ,nvl(n.rightduedate, o.rightduedate) as rightduedate -- 权证到期日
    ,nvl(n.clrownerid, o.clrownerid) as clrownerid -- 权属人编号
    ,nvl(n.clrownername, o.clrownername) as clrownername -- 权属人名称
    ,nvl(n.saveorgid, o.saveorgid) as saveorgid -- 保存机构编号
    ,nvl(n.catalogflag, o.catalogflag) as catalogflag -- 区分权证和代保品,2：权证1：代保品
    ,nvl(n.clrownerstartdate, o.clrownerstartdate) as clrownerstartdate -- 抵押登记起始日
    ,nvl(n.clrownerenddate, o.clrownerenddate) as clrownerenddate -- 抵押登记到期日
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.guarantyregno, o.guarantyregno) as guarantyregno -- 抵押登记编号
    ,nvl(n.moneyin, o.moneyin) as moneyin -- 入账金额
    ,nvl(n.moneyintype, o.moneyintype) as moneyintype -- 入账金额类型
    ,nvl(n.bookstatus, o.bookstatus) as bookstatus -- 记账状态
    ,nvl(n.rightregorgtype, o.rightregorgtype) as rightregorgtype -- 登记机构类型
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.oldclrid, o.oldclrid) as oldclrid -- 合并前押品编号
    ,nvl(n.twobarcodes, o.twobarcodes) as twobarcodes -- 二维码
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,case when
            n.rightcertid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rightcertid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rightcertid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_rightcert_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_rightcert_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.rightcertid = n.rightcertid
where (
        o.rightcertid is null
    )
    or (
        n.rightcertid is null
    )
    or (
        o.rightcertname <> n.rightcertname
        or o.clrid <> n.clrid
        or o.guarantyplanno <> n.guarantyplanno
        or o.sourcesystem <> n.sourcesystem
        or o.rightcerttype <> n.rightcerttype
        or o.rightcertno <> n.rightcertno
        or o.rightregistrationorg <> n.rightregistrationorg
        or o.rightregistrationdate <> n.rightregistrationdate
        or o.packageid <> n.packageid
        or o.barcode <> n.barcode
        or o.transferdate <> n.transferdate
        or o.rightcertstatus <> n.rightcertstatus
        or o.rightamount <> n.rightamount
        or o.possessortype <> n.possessortype
        or o.isneedwarehousing <> n.isneedwarehousing
        or o.inwarehousingdate <> n.inwarehousingdate
        or o.outwarehousingdate <> n.outwarehousingdate
        or o.tempoutwhreason <> n.tempoutwhreason
        or o.lastoutwhdate <> n.lastoutwhdate
        or o.lastinwhdate <> n.lastinwhdate
        or o.expcreturndate <> n.expcreturndate
        or o.isoverdue <> n.isoverdue
        or o.overduedays <> n.overduedays
        or o.isdataconv <> n.isdataconv
        or o.registrationuserid <> n.registrationuserid
        or o.rightduedate <> n.rightduedate
        or o.clrownerid <> n.clrownerid
        or o.clrownername <> n.clrownername
        or o.saveorgid <> n.saveorgid
        or o.catalogflag <> n.catalogflag
        or o.clrownerstartdate <> n.clrownerstartdate
        or o.clrownerenddate <> n.clrownerenddate
        or o.currency <> n.currency
        or o.guarantyregno <> n.guarantyregno
        or o.moneyin <> n.moneyin
        or o.moneyintype <> n.moneyintype
        or o.bookstatus <> n.bookstatus
        or o.rightregorgtype <> n.rightregorgtype
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.corporgid <> n.corporgid
        or o.remark <> n.remark
        or o.oldclrid <> n.oldclrid
        or o.twobarcodes <> n.twobarcodes
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_rightcert_info_cl(
            rightcertid -- 权证编号
            ,rightcertname -- 权证名称
            ,clrid -- 押品编号
            ,guarantyplanno -- 担保方案编号
            ,sourcesystem -- 源系统
            ,rightcerttype -- 权证类型
            ,rightcertno -- 权证号
            ,rightregistrationorg -- 权证登记机关
            ,rightregistrationdate -- 权证登记时间
            ,packageid -- 最新的权证所属封包
            ,barcode -- 条形码
            ,transferdate -- 移交日期
            ,rightcertstatus -- 权证状态
            ,rightamount -- 权利金额
            ,possessortype -- 权证持有者类型
            ,isneedwarehousing -- 是否需要入库
            ,inwarehousingdate -- 正式入库日期
            ,outwarehousingdate -- 正式出库日期
            ,tempoutwhreason -- 临时出库日期
            ,lastoutwhdate -- 最近一次出库日期
            ,lastinwhdate -- 最近一次入库日期
            ,expcreturndate -- 临时出库预计归还日期
            ,isoverdue -- 临时出库是否逾期
            ,overduedays -- 临时出库逾期天数
            ,isdataconv -- 是否为移植
            ,registrationuserid -- 抵质押办证人
            ,rightduedate -- 权证到期日
            ,clrownerid -- 权属人编号
            ,clrownername -- 权属人名称
            ,saveorgid -- 保存机构编号
            ,catalogflag -- 区分权证和代保品,2：权证1：代保品
            ,clrownerstartdate -- 抵押登记起始日
            ,clrownerenddate -- 抵押登记到期日
            ,currency -- 币种
            ,guarantyregno -- 抵押登记编号
            ,moneyin -- 入账金额
            ,moneyintype -- 入账金额类型
            ,bookstatus -- 记账状态
            ,rightregorgtype -- 登记机构类型
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,remark -- 备注
            ,oldclrid -- 合并前押品编号
            ,twobarcodes -- 二维码
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_rightcert_info_op(
            rightcertid -- 权证编号
            ,rightcertname -- 权证名称
            ,clrid -- 押品编号
            ,guarantyplanno -- 担保方案编号
            ,sourcesystem -- 源系统
            ,rightcerttype -- 权证类型
            ,rightcertno -- 权证号
            ,rightregistrationorg -- 权证登记机关
            ,rightregistrationdate -- 权证登记时间
            ,packageid -- 最新的权证所属封包
            ,barcode -- 条形码
            ,transferdate -- 移交日期
            ,rightcertstatus -- 权证状态
            ,rightamount -- 权利金额
            ,possessortype -- 权证持有者类型
            ,isneedwarehousing -- 是否需要入库
            ,inwarehousingdate -- 正式入库日期
            ,outwarehousingdate -- 正式出库日期
            ,tempoutwhreason -- 临时出库日期
            ,lastoutwhdate -- 最近一次出库日期
            ,lastinwhdate -- 最近一次入库日期
            ,expcreturndate -- 临时出库预计归还日期
            ,isoverdue -- 临时出库是否逾期
            ,overduedays -- 临时出库逾期天数
            ,isdataconv -- 是否为移植
            ,registrationuserid -- 抵质押办证人
            ,rightduedate -- 权证到期日
            ,clrownerid -- 权属人编号
            ,clrownername -- 权属人名称
            ,saveorgid -- 保存机构编号
            ,catalogflag -- 区分权证和代保品,2：权证1：代保品
            ,clrownerstartdate -- 抵押登记起始日
            ,clrownerenddate -- 抵押登记到期日
            ,currency -- 币种
            ,guarantyregno -- 抵押登记编号
            ,moneyin -- 入账金额
            ,moneyintype -- 入账金额类型
            ,bookstatus -- 记账状态
            ,rightregorgtype -- 登记机构类型
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,remark -- 备注
            ,oldclrid -- 合并前押品编号
            ,twobarcodes -- 二维码
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rightcertid -- 权证编号
    ,o.rightcertname -- 权证名称
    ,o.clrid -- 押品编号
    ,o.guarantyplanno -- 担保方案编号
    ,o.sourcesystem -- 源系统
    ,o.rightcerttype -- 权证类型
    ,o.rightcertno -- 权证号
    ,o.rightregistrationorg -- 权证登记机关
    ,o.rightregistrationdate -- 权证登记时间
    ,o.packageid -- 最新的权证所属封包
    ,o.barcode -- 条形码
    ,o.transferdate -- 移交日期
    ,o.rightcertstatus -- 权证状态
    ,o.rightamount -- 权利金额
    ,o.possessortype -- 权证持有者类型
    ,o.isneedwarehousing -- 是否需要入库
    ,o.inwarehousingdate -- 正式入库日期
    ,o.outwarehousingdate -- 正式出库日期
    ,o.tempoutwhreason -- 临时出库日期
    ,o.lastoutwhdate -- 最近一次出库日期
    ,o.lastinwhdate -- 最近一次入库日期
    ,o.expcreturndate -- 临时出库预计归还日期
    ,o.isoverdue -- 临时出库是否逾期
    ,o.overduedays -- 临时出库逾期天数
    ,o.isdataconv -- 是否为移植
    ,o.registrationuserid -- 抵质押办证人
    ,o.rightduedate -- 权证到期日
    ,o.clrownerid -- 权属人编号
    ,o.clrownername -- 权属人名称
    ,o.saveorgid -- 保存机构编号
    ,o.catalogflag -- 区分权证和代保品,2：权证1：代保品
    ,o.clrownerstartdate -- 抵押登记起始日
    ,o.clrownerenddate -- 抵押登记到期日
    ,o.currency -- 币种
    ,o.guarantyregno -- 抵押登记编号
    ,o.moneyin -- 入账金额
    ,o.moneyintype -- 入账金额类型
    ,o.bookstatus -- 记账状态
    ,o.rightregorgtype -- 登记机构类型
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.corporgid -- 法人机构编号
    ,o.remark -- 备注
    ,o.oldclrid -- 合并前押品编号
    ,o.twobarcodes -- 二维码
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
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
from ${iol_schema}.icms_clr_rightcert_info_bk o
    left join ${iol_schema}.icms_clr_rightcert_info_op n
        on
            o.rightcertid = n.rightcertid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_rightcert_info_cl d
        on
            o.rightcertid = d.rightcertid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_rightcert_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_rightcert_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_rightcert_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_rightcert_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_rightcert_info exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_rightcert_info_cl;
alter table ${iol_schema}.icms_clr_rightcert_info exchange partition p_20991231 with table ${iol_schema}.icms_clr_rightcert_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_rightcert_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_rightcert_info_op purge;
drop table ${iol_schema}.icms_clr_rightcert_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_rightcert_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_rightcert_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
