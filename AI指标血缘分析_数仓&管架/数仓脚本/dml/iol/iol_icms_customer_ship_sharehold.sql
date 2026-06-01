/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_ship_sharehold
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
create table ${iol_schema}.icms_customer_ship_sharehold_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_ship_sharehold
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_ship_sharehold_op purge;
drop table ${iol_schema}.icms_customer_ship_sharehold_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_ship_sharehold_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_ship_sharehold where 0=1;

create table ${iol_schema}.icms_customer_ship_sharehold_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_ship_sharehold where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_ship_sharehold_cl(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,corporgid -- 法人机构编号
            ,investmentprop -- 投资比例
            ,investmentmensftype -- 出资人身份类别
            ,enttype -- 企业类型
            ,tempstatus -- 暂存状态
            ,actualcontroller -- 是否为企业实际控制人
            ,inputorgid -- 登记机构
            ,maincustomerid -- 主客户号
            ,customerid -- 客户编号
            ,investdate -- 总投资最迟到位日期
            ,inputdate -- 登记日期
            ,shareholdingratio -- 持股比例
            ,relationship -- 出资方式
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,currencytype -- 投资币种
            ,investlastdate -- 出资最迟到位日期
            ,customertype -- 股东类型
            ,investmentsum -- 实缴金额
            ,certid -- 股东证件号码
            ,societyinstitutioncode -- 社会信用代码
            ,commercialregno -- 商事与非商事登记证号
            ,inputuserid -- 登记人
            ,creditinstitutioncode -- 机构信用代码
            ,fictitiousperson -- 法人代表名称
            ,updatedate -- 更新日期
            ,investmentype -- 出资人类型
            ,effstatus -- 有效标志
            ,countryorregion -- 所在国家或地区
            ,customername -- 股东姓名
            ,oughtsum -- 投资金额
            ,holdstartdate -- 开始持股时间
            ,certtype -- 股东证件类型
            ,loancardno -- 股权证号
            ,remark -- 备注
            ,migtoldvalue -- 备份原字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_ship_sharehold_op(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,corporgid -- 法人机构编号
            ,investmentprop -- 投资比例
            ,investmentmensftype -- 出资人身份类别
            ,enttype -- 企业类型
            ,tempstatus -- 暂存状态
            ,actualcontroller -- 是否为企业实际控制人
            ,inputorgid -- 登记机构
            ,maincustomerid -- 主客户号
            ,customerid -- 客户编号
            ,investdate -- 总投资最迟到位日期
            ,inputdate -- 登记日期
            ,shareholdingratio -- 持股比例
            ,relationship -- 出资方式
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,currencytype -- 投资币种
            ,investlastdate -- 出资最迟到位日期
            ,customertype -- 股东类型
            ,investmentsum -- 实缴金额
            ,certid -- 股东证件号码
            ,societyinstitutioncode -- 社会信用代码
            ,commercialregno -- 商事与非商事登记证号
            ,inputuserid -- 登记人
            ,creditinstitutioncode -- 机构信用代码
            ,fictitiousperson -- 法人代表名称
            ,updatedate -- 更新日期
            ,investmentype -- 出资人类型
            ,effstatus -- 有效标志
            ,countryorregion -- 所在国家或地区
            ,customername -- 股东姓名
            ,oughtsum -- 投资金额
            ,holdstartdate -- 开始持股时间
            ,certtype -- 股东证件类型
            ,loancardno -- 股权证号
            ,remark -- 备注
            ,migtoldvalue -- 备份原字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.investmentprop, o.investmentprop) as investmentprop -- 投资比例
    ,nvl(n.investmentmensftype, o.investmentmensftype) as investmentmensftype -- 出资人身份类别
    ,nvl(n.enttype, o.enttype) as enttype -- 企业类型
    ,nvl(n.tempstatus, o.tempstatus) as tempstatus -- 暂存状态
    ,nvl(n.actualcontroller, o.actualcontroller) as actualcontroller -- 是否为企业实际控制人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.maincustomerid, o.maincustomerid) as maincustomerid -- 主客户号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.investdate, o.investdate) as investdate -- 总投资最迟到位日期
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.shareholdingratio, o.shareholdingratio) as shareholdingratio -- 持股比例
    ,nvl(n.relationship, o.relationship) as relationship -- 出资方式
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.currencytype, o.currencytype) as currencytype -- 投资币种
    ,nvl(n.investlastdate, o.investlastdate) as investlastdate -- 出资最迟到位日期
    ,nvl(n.customertype, o.customertype) as customertype -- 股东类型
    ,nvl(n.investmentsum, o.investmentsum) as investmentsum -- 实缴金额
    ,nvl(n.certid, o.certid) as certid -- 股东证件号码
    ,nvl(n.societyinstitutioncode, o.societyinstitutioncode) as societyinstitutioncode -- 社会信用代码
    ,nvl(n.commercialregno, o.commercialregno) as commercialregno -- 商事与非商事登记证号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.creditinstitutioncode, o.creditinstitutioncode) as creditinstitutioncode -- 机构信用代码
    ,nvl(n.fictitiousperson, o.fictitiousperson) as fictitiousperson -- 法人代表名称
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.investmentype, o.investmentype) as investmentype -- 出资人类型
    ,nvl(n.effstatus, o.effstatus) as effstatus -- 有效标志
    ,nvl(n.countryorregion, o.countryorregion) as countryorregion -- 所在国家或地区
    ,nvl(n.customername, o.customername) as customername -- 股东姓名
    ,nvl(n.oughtsum, o.oughtsum) as oughtsum -- 投资金额
    ,nvl(n.holdstartdate, o.holdstartdate) as holdstartdate -- 开始持股时间
    ,nvl(n.certtype, o.certtype) as certtype -- 股东证件类型
    ,nvl(n.loancardno, o.loancardno) as loancardno -- 股权证号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.migtoldvalue, o.migtoldvalue) as migtoldvalue -- 备份原字段值
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
from (select * from ${iol_schema}.icms_customer_ship_sharehold_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_ship_sharehold where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.migtflag <> n.migtflag
        or o.corporgid <> n.corporgid
        or o.investmentprop <> n.investmentprop
        or o.investmentmensftype <> n.investmentmensftype
        or o.enttype <> n.enttype
        or o.tempstatus <> n.tempstatus
        or o.actualcontroller <> n.actualcontroller
        or o.inputorgid <> n.inputorgid
        or o.maincustomerid <> n.maincustomerid
        or o.customerid <> n.customerid
        or o.investdate <> n.investdate
        or o.inputdate <> n.inputdate
        or o.shareholdingratio <> n.shareholdingratio
        or o.relationship <> n.relationship
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.currencytype <> n.currencytype
        or o.investlastdate <> n.investlastdate
        or o.customertype <> n.customertype
        or o.investmentsum <> n.investmentsum
        or o.certid <> n.certid
        or o.societyinstitutioncode <> n.societyinstitutioncode
        or o.commercialregno <> n.commercialregno
        or o.inputuserid <> n.inputuserid
        or o.creditinstitutioncode <> n.creditinstitutioncode
        or o.fictitiousperson <> n.fictitiousperson
        or o.updatedate <> n.updatedate
        or o.investmentype <> n.investmentype
        or o.effstatus <> n.effstatus
        or o.countryorregion <> n.countryorregion
        or o.customername <> n.customername
        or o.oughtsum <> n.oughtsum
        or o.holdstartdate <> n.holdstartdate
        or o.certtype <> n.certtype
        or o.loancardno <> n.loancardno
        or o.remark <> n.remark
        or o.migtoldvalue <> n.migtoldvalue
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_ship_sharehold_cl(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,corporgid -- 法人机构编号
            ,investmentprop -- 投资比例
            ,investmentmensftype -- 出资人身份类别
            ,enttype -- 企业类型
            ,tempstatus -- 暂存状态
            ,actualcontroller -- 是否为企业实际控制人
            ,inputorgid -- 登记机构
            ,maincustomerid -- 主客户号
            ,customerid -- 客户编号
            ,investdate -- 总投资最迟到位日期
            ,inputdate -- 登记日期
            ,shareholdingratio -- 持股比例
            ,relationship -- 出资方式
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,currencytype -- 投资币种
            ,investlastdate -- 出资最迟到位日期
            ,customertype -- 股东类型
            ,investmentsum -- 实缴金额
            ,certid -- 股东证件号码
            ,societyinstitutioncode -- 社会信用代码
            ,commercialregno -- 商事与非商事登记证号
            ,inputuserid -- 登记人
            ,creditinstitutioncode -- 机构信用代码
            ,fictitiousperson -- 法人代表名称
            ,updatedate -- 更新日期
            ,investmentype -- 出资人类型
            ,effstatus -- 有效标志
            ,countryorregion -- 所在国家或地区
            ,customername -- 股东姓名
            ,oughtsum -- 投资金额
            ,holdstartdate -- 开始持股时间
            ,certtype -- 股东证件类型
            ,loancardno -- 股权证号
            ,remark -- 备注
            ,migtoldvalue -- 备份原字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_ship_sharehold_op(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,corporgid -- 法人机构编号
            ,investmentprop -- 投资比例
            ,investmentmensftype -- 出资人身份类别
            ,enttype -- 企业类型
            ,tempstatus -- 暂存状态
            ,actualcontroller -- 是否为企业实际控制人
            ,inputorgid -- 登记机构
            ,maincustomerid -- 主客户号
            ,customerid -- 客户编号
            ,investdate -- 总投资最迟到位日期
            ,inputdate -- 登记日期
            ,shareholdingratio -- 持股比例
            ,relationship -- 出资方式
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,currencytype -- 投资币种
            ,investlastdate -- 出资最迟到位日期
            ,customertype -- 股东类型
            ,investmentsum -- 实缴金额
            ,certid -- 股东证件号码
            ,societyinstitutioncode -- 社会信用代码
            ,commercialregno -- 商事与非商事登记证号
            ,inputuserid -- 登记人
            ,creditinstitutioncode -- 机构信用代码
            ,fictitiousperson -- 法人代表名称
            ,updatedate -- 更新日期
            ,investmentype -- 出资人类型
            ,effstatus -- 有效标志
            ,countryorregion -- 所在国家或地区
            ,customername -- 股东姓名
            ,oughtsum -- 投资金额
            ,holdstartdate -- 开始持股时间
            ,certtype -- 股东证件类型
            ,loancardno -- 股权证号
            ,remark -- 备注
            ,migtoldvalue -- 备份原字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.corporgid -- 法人机构编号
    ,o.investmentprop -- 投资比例
    ,o.investmentmensftype -- 出资人身份类别
    ,o.enttype -- 企业类型
    ,o.tempstatus -- 暂存状态
    ,o.actualcontroller -- 是否为企业实际控制人
    ,o.inputorgid -- 登记机构
    ,o.maincustomerid -- 主客户号
    ,o.customerid -- 客户编号
    ,o.investdate -- 总投资最迟到位日期
    ,o.inputdate -- 登记日期
    ,o.shareholdingratio -- 持股比例
    ,o.relationship -- 出资方式
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.currencytype -- 投资币种
    ,o.investlastdate -- 出资最迟到位日期
    ,o.customertype -- 股东类型
    ,o.investmentsum -- 实缴金额
    ,o.certid -- 股东证件号码
    ,o.societyinstitutioncode -- 社会信用代码
    ,o.commercialregno -- 商事与非商事登记证号
    ,o.inputuserid -- 登记人
    ,o.creditinstitutioncode -- 机构信用代码
    ,o.fictitiousperson -- 法人代表名称
    ,o.updatedate -- 更新日期
    ,o.investmentype -- 出资人类型
    ,o.effstatus -- 有效标志
    ,o.countryorregion -- 所在国家或地区
    ,o.customername -- 股东姓名
    ,o.oughtsum -- 投资金额
    ,o.holdstartdate -- 开始持股时间
    ,o.certtype -- 股东证件类型
    ,o.loancardno -- 股权证号
    ,o.remark -- 备注
    ,o.migtoldvalue -- 备份原字段值
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
from ${iol_schema}.icms_customer_ship_sharehold_bk o
    left join ${iol_schema}.icms_customer_ship_sharehold_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_ship_sharehold_cl d
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
--truncate table ${iol_schema}.icms_customer_ship_sharehold;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_ship_sharehold') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_ship_sharehold drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_ship_sharehold add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_ship_sharehold exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_ship_sharehold_cl;
alter table ${iol_schema}.icms_customer_ship_sharehold exchange partition p_20991231 with table ${iol_schema}.icms_customer_ship_sharehold_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_ship_sharehold to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_ship_sharehold_op purge;
drop table ${iol_schema}.icms_customer_ship_sharehold_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_ship_sharehold_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_ship_sharehold',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
