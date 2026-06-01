/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_ship_executives
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
create table ${iol_schema}.icms_customer_ship_executives_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_ship_executives
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_ship_executives_op purge;
drop table ${iol_schema}.icms_customer_ship_executives_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_ship_executives_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_ship_executives where 0=1;

create table ${iol_schema}.icms_customer_ship_executives_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_ship_executives where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_ship_executives_cl(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,sharevalue -- 持股比例
            ,birthday -- 出生日期
            ,resume -- 工作简历
            ,corporgid -- 法人机构编号
            ,certtype -- 证件类型
            ,engageterm -- 相关行业从业年限
            ,holdstock -- 持股情况
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,telephone -- 联系电话
            ,updateuserid -- 更新人
            ,familycerttype -- 配偶证件类型
            ,certid -- 证件号码
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,maincustomerid -- 主客户号
            ,jobtitle -- 职称
            ,officephone -- 单位电话
            ,customername -- 高管姓名
            ,effstatus -- 有效标志
            ,familycertid -- 配偶证件号码
            ,sex -- 性别
            ,inputdate -- 登记日期
            ,ntlycd -- 国籍
            ,eduexperience -- 学历
            ,tempstatus -- 是否引入标记
            ,actualcontroller -- 是否为企业实际控制人
            ,relationship -- 担任职务
            ,holddate -- 担任该职务时间
            ,executivetype -- 高管类型
            ,professional -- 高管职业
            ,customerid -- 客户编号
            ,remark -- 备注
            ,familycustname -- 配偶姓名
            ,migtoldvalue -- 备份原字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_ship_executives_op(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,sharevalue -- 持股比例
            ,birthday -- 出生日期
            ,resume -- 工作简历
            ,corporgid -- 法人机构编号
            ,certtype -- 证件类型
            ,engageterm -- 相关行业从业年限
            ,holdstock -- 持股情况
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,telephone -- 联系电话
            ,updateuserid -- 更新人
            ,familycerttype -- 配偶证件类型
            ,certid -- 证件号码
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,maincustomerid -- 主客户号
            ,jobtitle -- 职称
            ,officephone -- 单位电话
            ,customername -- 高管姓名
            ,effstatus -- 有效标志
            ,familycertid -- 配偶证件号码
            ,sex -- 性别
            ,inputdate -- 登记日期
            ,ntlycd -- 国籍
            ,eduexperience -- 学历
            ,tempstatus -- 是否引入标记
            ,actualcontroller -- 是否为企业实际控制人
            ,relationship -- 担任职务
            ,holddate -- 担任该职务时间
            ,executivetype -- 高管类型
            ,professional -- 高管职业
            ,customerid -- 客户编号
            ,remark -- 备注
            ,familycustname -- 配偶姓名
            ,migtoldvalue -- 备份原字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.sharevalue, o.sharevalue) as sharevalue -- 持股比例
    ,nvl(n.birthday, o.birthday) as birthday -- 出生日期
    ,nvl(n.resume, o.resume) as resume -- 工作简历
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.engageterm, o.engageterm) as engageterm -- 相关行业从业年限
    ,nvl(n.holdstock, o.holdstock) as holdstock -- 持股情况
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.telephone, o.telephone) as telephone -- 联系电话
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.familycerttype, o.familycerttype) as familycerttype -- 配偶证件类型
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.maincustomerid, o.maincustomerid) as maincustomerid -- 主客户号
    ,nvl(n.jobtitle, o.jobtitle) as jobtitle -- 职称
    ,nvl(n.officephone, o.officephone) as officephone -- 单位电话
    ,nvl(n.customername, o.customername) as customername -- 高管姓名
    ,nvl(n.effstatus, o.effstatus) as effstatus -- 有效标志
    ,nvl(n.familycertid, o.familycertid) as familycertid -- 配偶证件号码
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.ntlycd, o.ntlycd) as ntlycd -- 国籍
    ,nvl(n.eduexperience, o.eduexperience) as eduexperience -- 学历
    ,nvl(n.tempstatus, o.tempstatus) as tempstatus -- 是否引入标记
    ,nvl(n.actualcontroller, o.actualcontroller) as actualcontroller -- 是否为企业实际控制人
    ,nvl(n.relationship, o.relationship) as relationship -- 担任职务
    ,nvl(n.holddate, o.holddate) as holddate -- 担任该职务时间
    ,nvl(n.executivetype, o.executivetype) as executivetype -- 高管类型
    ,nvl(n.professional, o.professional) as professional -- 高管职业
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.familycustname, o.familycustname) as familycustname -- 配偶姓名
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
from (select * from ${iol_schema}.icms_customer_ship_executives_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_ship_executives where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.sharevalue <> n.sharevalue
        or o.birthday <> n.birthday
        or o.resume <> n.resume
        or o.corporgid <> n.corporgid
        or o.certtype <> n.certtype
        or o.engageterm <> n.engageterm
        or o.holdstock <> n.holdstock
        or o.inputorgid <> n.inputorgid
        or o.updatedate <> n.updatedate
        or o.telephone <> n.telephone
        or o.updateuserid <> n.updateuserid
        or o.familycerttype <> n.familycerttype
        or o.certid <> n.certid
        or o.inputuserid <> n.inputuserid
        or o.updateorgid <> n.updateorgid
        or o.maincustomerid <> n.maincustomerid
        or o.jobtitle <> n.jobtitle
        or o.officephone <> n.officephone
        or o.customername <> n.customername
        or o.effstatus <> n.effstatus
        or o.familycertid <> n.familycertid
        or o.sex <> n.sex
        or o.inputdate <> n.inputdate
        or o.ntlycd <> n.ntlycd
        or o.eduexperience <> n.eduexperience
        or o.tempstatus <> n.tempstatus
        or o.actualcontroller <> n.actualcontroller
        or o.relationship <> n.relationship
        or o.holddate <> n.holddate
        or o.executivetype <> n.executivetype
        or o.professional <> n.professional
        or o.customerid <> n.customerid
        or o.remark <> n.remark
        or o.familycustname <> n.familycustname
        or o.migtoldvalue <> n.migtoldvalue
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_ship_executives_cl(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,sharevalue -- 持股比例
            ,birthday -- 出生日期
            ,resume -- 工作简历
            ,corporgid -- 法人机构编号
            ,certtype -- 证件类型
            ,engageterm -- 相关行业从业年限
            ,holdstock -- 持股情况
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,telephone -- 联系电话
            ,updateuserid -- 更新人
            ,familycerttype -- 配偶证件类型
            ,certid -- 证件号码
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,maincustomerid -- 主客户号
            ,jobtitle -- 职称
            ,officephone -- 单位电话
            ,customername -- 高管姓名
            ,effstatus -- 有效标志
            ,familycertid -- 配偶证件号码
            ,sex -- 性别
            ,inputdate -- 登记日期
            ,ntlycd -- 国籍
            ,eduexperience -- 学历
            ,tempstatus -- 是否引入标记
            ,actualcontroller -- 是否为企业实际控制人
            ,relationship -- 担任职务
            ,holddate -- 担任该职务时间
            ,executivetype -- 高管类型
            ,professional -- 高管职业
            ,customerid -- 客户编号
            ,remark -- 备注
            ,familycustname -- 配偶姓名
            ,migtoldvalue -- 备份原字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_ship_executives_op(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,sharevalue -- 持股比例
            ,birthday -- 出生日期
            ,resume -- 工作简历
            ,corporgid -- 法人机构编号
            ,certtype -- 证件类型
            ,engageterm -- 相关行业从业年限
            ,holdstock -- 持股情况
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,telephone -- 联系电话
            ,updateuserid -- 更新人
            ,familycerttype -- 配偶证件类型
            ,certid -- 证件号码
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,maincustomerid -- 主客户号
            ,jobtitle -- 职称
            ,officephone -- 单位电话
            ,customername -- 高管姓名
            ,effstatus -- 有效标志
            ,familycertid -- 配偶证件号码
            ,sex -- 性别
            ,inputdate -- 登记日期
            ,ntlycd -- 国籍
            ,eduexperience -- 学历
            ,tempstatus -- 是否引入标记
            ,actualcontroller -- 是否为企业实际控制人
            ,relationship -- 担任职务
            ,holddate -- 担任该职务时间
            ,executivetype -- 高管类型
            ,professional -- 高管职业
            ,customerid -- 客户编号
            ,remark -- 备注
            ,familycustname -- 配偶姓名
            ,migtoldvalue -- 备份原字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.sharevalue -- 持股比例
    ,o.birthday -- 出生日期
    ,o.resume -- 工作简历
    ,o.corporgid -- 法人机构编号
    ,o.certtype -- 证件类型
    ,o.engageterm -- 相关行业从业年限
    ,o.holdstock -- 持股情况
    ,o.inputorgid -- 登记机构
    ,o.updatedate -- 更新日期
    ,o.telephone -- 联系电话
    ,o.updateuserid -- 更新人
    ,o.familycerttype -- 配偶证件类型
    ,o.certid -- 证件号码
    ,o.inputuserid -- 登记人
    ,o.updateorgid -- 更新机构
    ,o.maincustomerid -- 主客户号
    ,o.jobtitle -- 职称
    ,o.officephone -- 单位电话
    ,o.customername -- 高管姓名
    ,o.effstatus -- 有效标志
    ,o.familycertid -- 配偶证件号码
    ,o.sex -- 性别
    ,o.inputdate -- 登记日期
    ,o.ntlycd -- 国籍
    ,o.eduexperience -- 学历
    ,o.tempstatus -- 是否引入标记
    ,o.actualcontroller -- 是否为企业实际控制人
    ,o.relationship -- 担任职务
    ,o.holddate -- 担任该职务时间
    ,o.executivetype -- 高管类型
    ,o.professional -- 高管职业
    ,o.customerid -- 客户编号
    ,o.remark -- 备注
    ,o.familycustname -- 配偶姓名
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
from ${iol_schema}.icms_customer_ship_executives_bk o
    left join ${iol_schema}.icms_customer_ship_executives_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_ship_executives_cl d
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
--truncate table ${iol_schema}.icms_customer_ship_executives;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_ship_executives') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_ship_executives drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_ship_executives add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_ship_executives exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_ship_executives_cl;
alter table ${iol_schema}.icms_customer_ship_executives exchange partition p_20991231 with table ${iol_schema}.icms_customer_ship_executives_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_ship_executives to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_ship_executives_op purge;
drop table ${iol_schema}.icms_customer_ship_executives_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_ship_executives_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_ship_executives',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
